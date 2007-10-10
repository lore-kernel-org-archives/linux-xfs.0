Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 10 Oct 2007 11:06:28 -0700 (PDT)
Received: from postfix2-g20.free.fr (postfix2-g20.free.fr [212.27.60.43])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id l9AI6K5Y021912
	for <xfs@oss.sgi.com>; Wed, 10 Oct 2007 11:06:21 -0700
Received: from smtp7-g19.free.fr (smtp7-g19.free.fr [212.27.42.64])
	by postfix2-g20.free.fr (Postfix) with ESMTP id 008091B89A28
	for <xfs@oss.sgi.com>; Wed, 10 Oct 2007 17:39:26 +0200 (CEST)
Date: Wed, 10 Oct 2007 19:40:13 +0200
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: Recover fs
Message-ID: <20071010194013.32accad1@galadriel.home>
In-Reply-To: <470B4D3A.3060105@albertix.com>
References: <470B4D3A.3060105@albertix.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: "Alberto (albertix.com)" <alberto@albertix.com>
Cc: xfs@oss.sgi.com

Le Tue, 09 Oct 2007 11:43:22 +0200 vous écriviez:

> I'm desperade (aprox. crying) , on this disks was 3 years of work
> data (web, db, materials).
> It's possibility to recover this data (nothing else was writing
> after on disk disks) ??? . Pls help me
> If is possibilty, I promise to make 10 copies (for penitency).

Alberto, apparently nobody cares to reply because 1) there's
essentially nothing to do and 2) you deserved it. I'm sorry, but you
really deserved it. Not backing up important data is plain stupid, but
not backing up important data when moving it around is completely crazy.

Now there is only one thing you may still try, but you won't get back
everything, and it will be very long and very painful : scan the hard
drive one byte at a time, and look for something you know. If you're
looking for JPG files, look for JPG headers, or HTML headers, for
databases there's probably some sort of identifiable header too.
I  did it one for a 12 TB X>FS that went booom (2.6.17 bug) containing
only DV files. Here is the perl program I used. 

#!/usr/bin/perl


use strict;
use warnings;

my ( $file )  = @ARGV;
my $blocksize = 144000 ;

my $lookupstring = pack "H*", "1F0700" ;
my $regexp = qr/^(.*?)($lookupstring.*)$/s ;

open ( my $raid, "< $file" ) or die "impossible d'ouvrir $file \n" ;

{
        my $block ;
        my $offset = 0 ;
        my $nextblock = 0;
        my $testfile;

        my $outnumber = 0;
        seek $raid, $offset, 0 or die ;

        while ( my $readbytes = read $raid, $block, $blocksize ) {
                $offset += $readbytes ;
                if ( $block =~ m/$regexp/ ) {
                        print "trouvé, fichier $outnumber offset
$offset\n";

                        if ( $testfile ) {
                                print $testfile $1;
                                close $testfile or die "Peut pas
fermer, $! "; undef $testfile ;
                                $outnumber++;
                                open $testfile,
">/mnt/destination/out". sprintf ("%09d", $ outnumber) . ".dv" or die
"impossible d'écrire sur fichier $outnumber "; print $testfile $2 ;
                        } else {
                                print "OPEN\n";
                                open $testfile,
">/mnt/destination/out". sprintf ("%09d", $ outnumber) . ".dv" or die
"impossible d'écrire sur fichier $outnumber "; print $testfile $2 ;
                        }
                } else {
                        if ( $testfile ) {
                                print $testfile $block;
                        }
                }

                if ($offset > 14293651161088 ) {
                        print "fini....\n";
                        exit;
                }
        }

}

-- 
--------------------------------------------------
Emmanuel Florac               www.intellique.com   
--------------------------------------------------
