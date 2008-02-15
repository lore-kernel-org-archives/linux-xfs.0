Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 15 Feb 2008 11:15:40 -0800 (PST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m1FJFYFX025377
	for <xfs@oss.sgi.com>; Fri, 15 Feb 2008 11:15:35 -0800
Received: from bob.dscon.sk (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3BFB5E31BD7
	for <xfs@oss.sgi.com>; Fri, 15 Feb 2008 11:15:58 -0800 (PST)
Received: from bob.dscon.sk (bob.dscon.sk [88.86.113.10]) by cuda.sgi.com with ESMTP id ovvSlOVVHsN3heIE for <xfs@oss.sgi.com>; Fri, 15 Feb 2008 11:15:58 -0800 (PST)
Date: Fri, 15 Feb 2008 20:16:37 +0100
Subject: rewrite very slow
Message-ID: <20080215191636.GC4859@bob.dscon.sk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
From: xfs@bob.dscon.sk (DS)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Hello,

I need some help to tunning my storage.

Very simple test at begin (perl script test.pl):

#!/usr/bin/perl

$time=time();
for ($i=1;$i<100;$i++)
{
open (SUBOR,">$i.txt");
print SUBOR "aaaaaaaaaaaaaaaaaaa\n";
close (SUBOR);
print "WRITE $i. FILE\n";
}
$time2=time();
$rozdiel_casov=$time2-$time;

print "TIME ".$rozdiel_casov." sekund\n";

First run:
file1:/mnt/hosting/test# ./test.pl
WRITE 1. FILE
WRITE 2. FILE
...
WRITE 98. FILE
WRITE 99. FILE
TIME 0 sekund


Every next run (rewrite existing files) is very very very slow:

file1:/mnt/hosting/test# ./test.pl
WRITE 1. FILE
WRITE 2. FILE
...

WRITE 98. FILE
WRITE 99. FILE
TIME 43 sekund


I try it on ext3. Every run is only 1-3seconds.

I tried tunning my storage.
My last mount specification: 

(rw,noatime,nodiratime,nobarrier,osyncisosync,logbsize=256k,logbufs=8,quota)
I tried all possible configuration (barrier, nobarrier, osyncisosync,
logbssize=XX,logbufs=2-8) nothing help me.

file1:/mnt/hosting/test# xfs_info /mnt/hosting/
meta-data=/dev/mapper/vghosting-hosting isize=256    agcount=32,
agsize=7626752 blks
         =                       sectsz=512   attr=2
data     =                       bsize=4096   blocks=244056064,
imaxpct=25
         =                       sunit=0      swidth=0 blks, unwritten=1
naming   =version 2              bsize=4096
log      =internal               bsize=4096   blocks=32768, version=2
         =                       sectsz=512   sunit=0 blks
realtime =none                   extsz=65536  blocks=0, rtextents=0

I test it on 4 other xfs storages and results was similar.


Any ideas?

Thanks.

Dusan
