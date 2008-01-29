Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 29 Jan 2008 01:32:28 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m0T9WN8D008922
	for <xfs@oss.sgi.com>; Tue, 29 Jan 2008 01:32:25 -0800
Received: from enyo.dsw2k3.info (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 50925572616
	for <xfs@oss.sgi.com>; Tue, 29 Jan 2008 01:32:44 -0800 (PST)
Received: from enyo.dsw2k3.info (enyo.dsw2k3.info [195.71.86.239]) by cuda.sgi.com with ESMTP id 7WmCeKOuX0qEgfMS for <xfs@oss.sgi.com>; Tue, 29 Jan 2008 01:32:44 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
	by enyo.dsw2k3.info (Postfix) with ESMTP id 918982BD61
	for <xfs@oss.sgi.com>; Tue, 29 Jan 2008 10:32:11 +0100 (CET)
Received: from enyo.dsw2k3.info ([127.0.0.1])
	by localhost (enyo.dsw2k3.info [127.0.0.1]) (amavisd-new, port 10024)
	with LMTP id 9HPef71xli2Y for <xfs@oss.sgi.com>;
	Tue, 29 Jan 2008 10:32:06 +0100 (CET)
Received: from citd.de (p4FC4BD9B.dip.t-dialin.net [79.196.189.155])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client did not present a certificate)
	by enyo.dsw2k3.info (Postfix) with ESMTP id 55CC22BD69
	for <xfs@oss.sgi.com>; Tue, 29 Jan 2008 10:32:05 +0100 (CET)
Date: Tue, 29 Jan 2008 10:32:01 +0100
From: Matthias Schniedermeyer <ms@citd.de>
Subject: mkfs.xfs doesn't detect size of storage correctly
Message-ID: <20080129093201.GA16203@citd.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Hi


Yesterday i bought a 750GB HDD.
I encrypt nearly everything with loop-aes, so i also did it with this 
HDD.

I create a "fake" partition table and:
losetup -e aes256 -p 0 -o 4096 /dev/loop6 /dev/sdb < key

This creates a loop with everything except the first 4KB, i.e. it leaves 
out the MBR and another 3,5KB.

/proc/partions shows the correct(tm) size informations for the HDD and 
the loop:
- snip -
   7     6  732574580 loop6
   8    16  732574584 sdb
   8    17  732572001 sdb1
- snip -

But when i mkfs.xfs the loop
#> mkfs.xfs /dev/loop6
meta-data=/dev/loop6             isize=256    agcount=3, agsize=45785911 blks
         =                       sectsz=512   attr=2
data     =                       bsize=4096   blocks=137357733, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096
log      =internal log           bsize=4096   blocks=32768, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=0
realtime =none                   extsz=4096   blocks=0, rtextents=0

And mount it:
mount /dev/loop6 /mnt

And least but not least df it:
#> df -m /mnt
Filesystem           1M-blocks      Used Available Use% Mounted on
/dev/loop6              536426         5    536422   1% /mnt

There is roughly 1/3 missing.

What can i do to fix this?


#> mkfs.xfs -V
mkfs.xfs version 2.9.5
(Package is from: Debian SID/unstable)

Kernel is 2.6.24 (vanilla, plus of course the external module: loop-aes)


Btw. I have 50 other HDDs in more or less exactly the same setup, (49 
HDDs >= 200 GB and <= 500GB and one 1TB, of couse created with my system 
at an older stage from Feb 2007 onwoard, the 750GB is the first with 
kernel 2.6.24.) Up to now i can't remember ever "missing" space.





Bis denn

-- 
Real Programmers consider "what you see is what you get" to be just as 
bad a concept in Text Editors as it is in women. No, the Real Programmer
wants a "you asked for it, you got it" text editor -- complicated, 
cryptic, powerful, unforgiving, dangerous.
