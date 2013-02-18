require 'rdf/microdata'
require 'rdf/rdfxml'

default_dir = "/home/tewson/work/MSc/experiment-2/datasets/"

mode = ARGV[0]
datacat = ARGV[1]
datasrc = ARGV[2]

default_prefixes = {
  nil => "#",
  :base => "http://localhost/"+datasrc+"#",
  :md => "http://www.w3.org/ns/md#",
  :schema => "http://schema.org/",
  :rdfa => "http://www.w3.org/ns/rdfa#"
}

if mode == "-i" and !(datacat.nil?) and datacat!="" and !(datasrc.nil?) and datasrc!=""
  filename = default_dir+datacat+"/"+datasrc+".html"
  
  repo = RDF::Repository.new

  RDF::Microdata::Reader.open(filename) do |reader|
    reader.each_statement do |statement|
      repo.insert(statement)
    end
  end

  test = RDF::RDFXML::Writer.buffer(
    :prefixes => default_prefixes 
  ) do |writer|
    repo.each_statement do |statement|
      writer << statement
    end
  end


  File.open(default_dir+datacat+"/"+datasrc+"-new.rdf", 'w') { |file| file.write(test) }

else
  puts "No input file."
end


