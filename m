Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 15 Sep 2006 15:07:46 -0700 (PDT)
Received: from limpet.umeoce.maine.edu (limpet.umeoce.maine.edu [130.111.192.115])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k8FM7YZd007926
	for <xfs@oss.sgi.com>; Fri, 15 Sep 2006 15:07:35 -0700
Received: from localhost (cousins@localhost)
	by limpet.umeoce.maine.edu (8.9.3/8.9.3) with ESMTP id RAA31806
	for <xfs@oss.sgi.com>; Fri, 15 Sep 2006 17:07:07 -0400
Date: Fri, 15 Sep 2006 17:07:07 -0400 (EDT)
From: Steve Cousins <cousins@limpet.umeoce.maine.edu>
Reply-To: cousins@umit.maine.edu
Subject: swidth with mdadm and RAID6
Message-ID: <Pine.LNX.4.10.10609151652070.31539-100000@limpet.umeoce.maine.edu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com


I have a RAID6 array of 11 500 GB drives using mdadm.  There is one
hot-spare so the number of data drives is 8.  I used mkfs.xfs with
defaults to create the file system and it seemed to pick up the chunk size
I used correctly (64K) but I think it got the swidth wrong.  Here is what
xfs_info says:

===========================================================================
meta-data=/dev/md0               isize=256    agcount=32, agsize=30524160
blks
         =                       sectsz=4096  attr=0
data     =                       bsize=4096   blocks=976772992, imaxpct=25
         =                       sunit=16     swidth=144 blks, unwritten=1
naming   =version 2              bsize=4096
log      =internal               bsize=4096   blocks=32768, version=2
         =                       sectsz=4096  sunit=1 blks
realtime =none                   extsz=589824 blocks=0, rtextents=0
===========================================================================

So, sunit*bsize=64K, but swidth=144 and swidth/sunit=9 so it looks like it
thought there were 9 data drives instead of 8.  

Am I diagnosing this correctly?  Should I recreate the array and
explicitly set sunit=16 and swidth=128?

Thanks for your help.

Steve
______________________________________________________________________
 Steve Cousins, Ocean Modeling Group    Email: cousins@umit.maine.edu
 Marine Sciences, 452 Aubert Hall       http://rocky.umeoce.maine.edu
 Univ. of Maine, Orono, ME 04469        Phone: (207) 581-4302
