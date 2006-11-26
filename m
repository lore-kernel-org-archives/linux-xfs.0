Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 27 Nov 2006 00:16:11 -0800 (PST)
Received: from ciao.gmane.org (main.gmane.org [80.91.229.2])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id kAR8FxaG014319
	for <linux-xfs@oss.sgi.com>; Mon, 27 Nov 2006 00:16:02 -0800
Received: from root by ciao.gmane.org with local (Exim 4.43)
	id 1GoaTC-00074K-2q
	for linux-xfs@oss.sgi.com; Mon, 27 Nov 2006 08:00:03 +0100
Received: from halleracaffe-14.broadband.pl ([85.232.226.14])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-xfs@oss.sgi.com>; Mon, 27 Nov 2006 08:00:02 +0100
Received: from mszpak by halleracaffe-14.broadband.pl with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-xfs@oss.sgi.com>; Mon, 27 Nov 2006 08:00:02 +0100
From: =?ISO-8859-2?Q?Marcin_Zaj=B1czkowski?= <mszpak@wp.pl>
Subject: Errors on XFS partition - ask for diagnose
Date: Sun, 26 Nov 2006 22:02:49 +0100
Message-ID: <ekcvdq$4g1$1@sea.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-xfs@oss.sgi.com

Hi,


Recently some of my executable files (on XFS partition) have become 
"invisible" for whereis, locate, find, bash, mc, nautilus and others.
They are not reported by autofill in bash, but I can run it by typing 
full file name. "ls" with full name returns info about file, "ls" with 
regexp no.

I run xfs_check and it returned me many errors (see below).

Because I don't have experience with errors on XFS partition I would 
like to ask, do you think that after ran of xfs_repair file system would 
be still usable (now only those files are invisible, but still accessible)?


Btw, I didn't have any power failure, nor problems with hardware (at 
least on this partition - based on smart report). The trigger for that 
was to fill in partition in 100%. Could it cause those error on my 
partition?


Regards
Marcin


[xfs_check-output]
bad free block nused 1 should be 14 for dir ino 48 block 16777216
bad free block nused 0 should be 5 for dir ino 335698 block 16777216
bad free block nused 0 should be 5 for dir ino 1355949 block 16777216
agi unlinked bucket 4 is 44164 in ag 2 (inode=1092740)
agi unlinked bucket 43 is 117355 in ag 2 (inode=1165931)
agi unlinked bucket 59 is 43387 in ag 2 (inode=1091963)
dir 2102297 block 0 entry 
     454ba2b3v bad inode number 1183729173579457891
dir 2102297 block 0 entry 
                                                    3 bad inode number 
3619544128639099186
dir 2102297 block 0 bad free entry at 296
dir 2102297 block 0 bad bestfree data
dir 2102297 block 0 entry/unused tag mismatch
dir 2102297 block 8388609 extra leaf entry 4d39b335 196
dir 2102297 block 8388609 extra leaf entry 4d5c32e1 60
(... 159 lines removed)
dir 2102297 block 8388612 extra leaf entry 4c6b7599 17c
dir 2102297 block 8388612 extra leaf entry 4c7a6849 18
bad free block ent 0 is 0 should be 65320 for dir ino 2102297 block 16777216
bad free block ent 1 is 0 should be 8 for dir ino 2102297 block 16777216
bad free block ent 2 is 0 should be 8 for dir ino 2102297 block 16777216
bad free block ent 3 is 0 should be 8 for dir ino 2102297 block 16777216
bad free block ent 4 is 0 should be 8 for dir ino 2102297 block 16777216
bad free block ent 5 is 0 should be 8 for dir ino 2102297 block 16777216
bad free block ent 6 is 0 should be 8 for dir ino 2102297 block 16777216
bad free block ent 7 is 0 should be 8 for dir ino 2102297 block 16777216
bad free block ent 8 is 0 should be 8 for dir ino 2102297 block 16777216
bad free block ent 10 is 0 should be 40 for dir ino 2102297 block 16777216
bad free block nused 1 should be 12 for dir ino 2102297 block 16777216
dir ino 2102297 missing leaf entry for ebbb4d51/a
dir ino 2102297 missing leaf entry for e118f281/21
dir ino 2102297 missing leaf entry for e34e82df/13
bad free block nused 0 should be 4 for dir ino 3426262 block 16777216
allocated inode 1091963 has 0 link count
allocated inode 1092740 has 0 link count
allocated inode 1165931 has 0 link count
disconnected inode 2146977, nlink 1
disconnected inode 2130509, nlink 1
(... 97 lines removed)
disconnected inode 2159424, nlink 1
disconnected inode 2272314, nlink 1
link count mismatch for inode 2136334 (name ?), nlink 8, counted 9
disconnected inode 2182819, nlink 1
disconnected inode 2146376, nlink 1
(... 62 lines removed)
disconnected inode 2256376, nlink 1
disconnected inode 2160161, nlink 1
[/xfs_check-output]
