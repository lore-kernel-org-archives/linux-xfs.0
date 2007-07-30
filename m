Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 30 Jul 2007 10:30:31 -0700 (PDT)
Received: from mailrelay.pawisda.de (mail.pawisda.de [213.157.4.156])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l6UHUNbm024470
	for <xfs@oss.sgi.com>; Mon, 30 Jul 2007 10:30:25 -0700
Subject: Re: XFS shrink (step 0)
From: Ruben Porras <ruben.porras@linworks.de>
In-Reply-To: <20070629065525.GQ31489@sgi.com>
References: <1180715974.10796.46.camel@localhost>
	 <20070604001632.GA86004887@sgi.com> <1182291751.5289.9.camel@localhost>
	 <20070619234248.GT86004887@sgi.com> <46838FB4.1040906@linworks.de>
	 <20070629065525.GQ31489@sgi.com>
Content-Type: multipart/mixed; boundary="=-qMsU+OcdBmZRkLJQNSW7"
Date: Mon, 30 Jul 2007 19:30:25 +0200
Message-Id: <1185816625.3941.59.camel@localhost>
Mime-Version: 1.0
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs@oss.sgi.com, iusty@k1024.org

--=-qMsU+OcdBmZRkLJQNSW7
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Am Freitag, den 29.06.2007, 16:55 +1000 schrieb David Chinner:
> On Thu, Jun 28, 2007 at 12:38:44PM +0200, Ruben Porras wrote:

> For something like this it's probably easier to do with shell/perl/awk.
> 
> e.g. in shell, the number of ags in the filesystem:
> 
> iterate all ags:
> 
> numags=`xfs_db -r -c "sb 0" -c "p agcount" /dev/sdb8 | sed -e 's/.* = //'`
> lastag=`expr $numags - 1`
> for ags in `seq 0 1 $lastag`; do
> 	....
> done
> 
> Free space in an AG 0:
> 
> xfs_db -r -c "freesp -s -a 0" /dev/sdb8 | awk '/total free blocks/ {print $4}'

I decided to calcule the free space in a AG directly as the space in
"freeblks" - "btreeblks".

Attached is a perl script that calculates the free space of a hole
filesystem. It's easy to modify it to get the free space from a range of
AGs, so unless there are errors, I lay it on the mailing list as an
example, and I'll adapt it later as needed. I would like to start with
the step number 2.

How is the state of the program xfs_reno.c? Can it be released in the
near future as GPL, or should I go better for now with point number 3
(that is, move data out of offline AGs)?

--=-qMsU+OcdBmZRkLJQNSW7
Content-Disposition: attachment; filename=freecount.pl
Content-Type: application/x-perl; name=freecount.pl
Content-Transfer-Encoding: 7bit

#!/usr/bin/perl -T

use strict;
use warnings;

my $fd;

$ENV{PATH} = "/usr/sbin";
$ENV{LC_ALL} = "C";

my $XFSDB  = "xfs_db";

sub help { print "Usage: freecount.pl device\n"; }

sub read_param {
  my $param = shift or die;

  my ($key, $val) = split(/ = /, <$fd>);

  my $regex = quotemeta($param);

  die "desired $param not received" unless $key =~ /$regex/;

  return $val;
}

unless (@ARGV == 1) { help && exit }

my $dev = pop @ARGV;

# untaint
if ($dev =~ m!^(\/dev\/\w+\d+)$!) { $dev = $1 } else { help && exit }

open($fd, "$XFSDB -r -c 'sb' -c 'p agcount' -c 'p blocksize' $dev |")
  or die "Can't open xfs_db: $!\n";

my ($agcount, $blksize) = map { read_param $_ } qw/agcount blocksize/;

close($fd);

my $free = 0;

for (my $i = 0; $i < $agcount; $i++) {

  open($fd, "$XFSDB -r -c 'agf $i' -c 'p freeblks' -c 'p btreeblks' $dev |")
    or die "Can't open xfs_db: $!\n";

  # discount the space used in btreeblks from the free space
  $free += read_param("freeblks") - read_param("btreeblks");

  close($fd);
}

$free *= $blksize / (1024 ** 2);

print "$free M";

--=-qMsU+OcdBmZRkLJQNSW7--
