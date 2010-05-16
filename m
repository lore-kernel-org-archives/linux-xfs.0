Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o4GJV7fN182580 for <xfs@oss.sgi.com>; Sun, 16 May 2010 14:31:07 -0500
Received: from smtp3-g21.free.fr (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 055EB130832A
	for <xfs@oss.sgi.com>; Sun, 16 May 2010 12:34:14 -0700 (PDT)
Received: from smtp3-g21.free.fr (smtp3-g21.free.fr [212.27.42.3]) by
	cuda.sgi.com with ESMTP id mukIDnVr7izeVcxt for
	<xfs@oss.sgi.com>; Sun, 16 May 2010 12:34:14 -0700 (PDT)
Date: Sun, 16 May 2010 21:33:07 +0200
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: Structure needs cleaning - Seagate Expansion External HDD 2TB USB
Message-ID: <20100516213307.4252621c@galadriel.home>
In-Reply-To: <4BEF12A5.2030505@btinternet.com>
References: <4BEF12A5.2030505@btinternet.com>
Mime-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Marcel z maleho mesta <newsx@btinternet.com>
Cc: xfs@oss.sgi.com

Le Sat, 15 May 2010 22:31:17 +0100 vous =E9criviez:

>  but the most important one "DVBgrab" with about =

> 400Gb of data :( (each file is between 1 and 2 Gb)

Don't write anything to your drive. Here is a perl script I wrote to
find back lost DV files from a huge corrupted array.
Mount some other place to save the found files to /mnt/destination,
then run the script passing the device to search as parameter.

#!/usr/bin/perl
use strict;
use warnings;


$|=3D1 ;

my ( $file )  =3D @ARGV;

my $blocksize =3D 4096 ;

my $lookupstring =3D pack "H*", "1F0700" ;
my $regexp =3D qr/^(.*?)($lookupstring.*)$/s ;

open ( my $raid, "< $file" ) or die "can't open $file \n" ;

{
	my $block ;
	my $offset =3D 0 ;
	my $nextblock =3D 0;
	my $testfile;
	=

	# frame size is 1440000 bytes
	my $framebuffer1 =3D '' ;
		=

	my $outnumber =3D 0;
	seek $raid, $offset, 0 or die ;
	=

	while ( my $readbytes =3D read $raid, $block, $blocksize ) {
		$offset +=3D $readbytes ;
		=

		print "* offset : $offset\n" unless ( $offset %
1073741824 ) ; =

		if ( length $framebuffer1 =3D=3D 0 ) {
			if ( $block =3D~ m/$regexp/ ) {
				print "found, file $outnumber
offset $offset\n"; $framebuffer1 =3D $2 ;
			}
		} elsif ( length $framebuffer1 < 144000 - $blocksize ) {
			$framebuffer1 .=3D $block ;
			print "file head inside : offset $offset\n" if
( $block =3D~ m/$regexp/ ) ; } elsif ( length $framebuffer1 =3D=3D 144000 -
$blocksize ) { $framebuffer1 .=3D $block ;
		} else {
			$framebuffer1 .=3D substr( $block, 0, ( 144000 -
length $framebuffer1 ) ) ;

			if ( not $testfile ) {
				print "OPEN\n";
				open $testfile,
">/mnt/destination/out". sprintf ("%09d", $outnumber) . ".dv" or die
"can't write file $outnumber "; }

			print $testfile $framebuffer1 ;
			=

			if ( $block =3D~ m/$regexp/ ) {
				print "found, file $outnumber
offset $offset\n"; $framebuffer1 =3D $2 ;
			} else {
				print "CLOSE\n" ;
				close $testfile ;
				undef $testfile ;
				$framebuffer1 =3D '' ;
				$outnumber++;
			}
		}

	}
}		=

		=


-- =

------------------------------------------------------------------------
Emmanuel Florac     |   Direction technique
                    |   Intellique
                    |	<eflorac@intellique.com>
                    |   +33 1 78 94 84 02
------------------------------------------------------------------------

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
