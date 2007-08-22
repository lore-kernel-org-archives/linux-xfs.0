Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 22 Aug 2007 15:56:28 -0700 (PDT)
Received: from oth.net (mail.oth.net [209.173.220.26])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l7MMuM4p017484
	for <xfs@oss.sgi.com>; Wed, 22 Aug 2007 15:56:26 -0700
Received: from localhost (r6@localhost)
	by oth.net (8.9.3/8.9.3) with ESMTP id RAA11768
	for <xfs@oss.sgi.com>; Wed, 22 Aug 2007 17:17:33 -0500
Date: Wed, 22 Aug 2007 17:17:33 -0500 (CDT)
From: Chris Pearson <kermit4@gmail.com>
Subject: sb_ifree and sb_fdblocks are unequal
Message-ID: <Pine.LNX.4.21.0708221713020.11516-100000@orbis.oth.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

I have the same problem as posted in:
http://oss.sgi.com/archives/xfs/2006-02/msg00091.html

using xfsprogs-2.9.3  in linux  2.4.29

after running xfs_repair on a read-only mounted root filesystem, xfs_check
still shows errors:                                    
                                                                                                                             
# ./xfs_check.sh -f /dev/md1
sb_ifree 993009, counted 993008
sb_fdblocks 3119630, counted 3119633


# ./xfs_info.sh /                                                                                                                                                     
meta-data=/                      isize=256    agcount=56, agsize=1048576
blks
         =                       sectsz=512  
data     =                       bsize=4096   blocks=58587014, imaxpct=25
         =                       sunit=0      swidth=0 blks, unwritten=0
naming   =version 2              bsize=4096  
log      =internal               bsize=4096   blocks=2382, version=1
         =                       sectsz=512   sunit=0 blks
realtime =none                   extsz=65536  blocks=0, rtextents=0


It's possible, even likely, I had corruption due to a power outtage and
Seagate ATAPI drives that had write caching enabled by default.
