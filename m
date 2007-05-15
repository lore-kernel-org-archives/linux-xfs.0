Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 15 May 2007 05:15:17 -0700 (PDT)
Received: from gk.uu.epigenomics.net (gk.uu.epigenomics.net [195.127.125.226])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l4FCFBfB025527
	for <xfs@oss.sgi.com>; Tue, 15 May 2007 05:15:13 -0700
From: linux-xfs@ml.epigenomics.com
Subject: xfs_repair: buf calloc failed (4132 bytes): Cannot allocate memory
Date: Tue, 15 May 2007 11:48:30 +0000 (UTC)
Message-ID: <slrnf4j7ge.aje.robert.sander@snell.epigenomics.epi>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Hi!

We have a RAID0 set of 3 400GB disks.

After a crash we needed to run xfs_repair, but it bails out with the
error message:

        - ensuring existence of lost+found directory
        - traversing filesystem starting at / ...
xfs_repair: buf calloc failed (4132 bytes): Cannot allocate memory

The filesystem contains many hardlinked files as it is a dirvish
repository (www.dirvish.org) with the hardlinks created by rsync.

This is the xfs_db info:

# xfs_db -r -c "sb 0" -c "p" /dev/md0
magicnum = 0x58465342
blocksize = 4096
dblocks = 293031424
rblocks = 0
rextents = 0
uuid = e8d3a22c-716f-4f3e-9e95-e06afb3559d0
logstart = 268435472
rootino = 256
rbmino = 257
rsumino = 258
rextsize = 48
agblocks = 9157232
agcount = 32
rbmblocks = 0
logblocks = 32768
versionnum = 0x3184
sectsize = 512
inodesize = 256
inopblock = 16
fname = "\000\000\000\000\000\000\000\000\000\000\000\000"
blocklog = 12
sectlog = 9
inodelog = 8
inopblog = 4
agblklog = 24
rextslog = 0
inprogress = 0
imax_pct = 25
icount = 18882496
ifree = 373596
fdblocks = 27494887
frextents = 0
uquotino = 0
gquotino = 0
qflags = 0
flags = 0
shared_vn = 0
inoalignmt = 2
unit = 16
width = 48
dirblklog = 0
logsectlog = 0
logsectsize = 0
logsunit = 0
features2 = 0

Kernel is 2.6.20.6 on a dual PIII machine with 1GB RAM and 10GB swap.

Mounting the filesystem is possible, but what about its current state?

Greetings
-- 
Robert Sander                     Senior Manager Information Systems
Epigenomics AG    Kleine Praesidentenstr. 1    10178 Berlin, Germany
phone:+49-30-24345-0                            fax:+49-30-24345-555
http://www.epigenomics.com             robert.sander@epigenomics.com
