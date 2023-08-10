require 'pry'

class Song

  attr_accessor :name, :album, :id

  def initialize(name:, album:, id: nil)
    @id = id
    @name = name
    @album = album
  end

  def self.create_table
    sql = <<-SQL
      CREATE TABLE IF NOT EXISTS songs (
        id INTEGER PRIMARY KEY,
        name TEXT,
        album TEXT
      )
      SQL
    DB[:conn].execute (sql)
  end

  def save
    sql = <<-SQL
    INSERT INTO songs (name, album)
    VALUES (?, ?)
    SQL
    
    # insert the song
    DB[:conn].execute(sql, self.name, self.album)

    # get the song ID from the database and save it to the Ruby instance
    self.id = DB[:conn].execute("SELECT last_insert_rowid() FROM songs")[0][0]

    # return the Ruby instance
    self
  end

  # This is using Keyword Arguments which has been deprecated in Ruby 3.0
  def self.create(name:, album:)
    song = Song.new(name: name, album: album)
    song.save
  end

end

song = Song.new name: "Gold Digger", album: "Late Registration"
hello = Song.new name: "Hello", album: "25"
ninety_nine_problems = Song.new name: "99 Problems", album: "The Black Album"

binding.pry
0