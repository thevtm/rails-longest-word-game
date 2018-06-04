require "json"
require "open-uri"

def generate_grid
  # generate random grid of letters
  grid_size = rand(8..12)
  alphabet = ("A".."Z").to_a
  (0...grid_size).map { |_| alphabet.sample }
end

def is_in_grid?(grid, word)
  word_wc = word.upcase.delete(" ").split("").each_with_object(Hash.new(0)) { |letter, acc| acc[letter] += 1 }
  grid_wc = grid.each_with_object(Hash.new(0)) { |letter, acc| acc[letter] += 1 }

  word_wc.each do |letter, letter_count|
    grid_letter_count = grid_wc[letter]
    return false unless letter_count <= grid_letter_count
  end

  true
end

def is_in_dictionary?(attempt)
  (JSON.parse(open("https://wagon-dictionary.herokuapp.com/#{attempt}").read))["found"]
end

class GamesController < ApplicationController
  def new
    @letters = generate_grid
  end

  def score
    @attempt = params[:attempt]
    @letters = JSON.parse(params[:letters])

    @valid_grid = is_in_grid?(@letters, @attempt)
    @valid_dictionary = is_in_dictionary?(@attempt)

    @score = @attempt.length;
  end
end
