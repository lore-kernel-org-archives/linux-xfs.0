Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 15 Jan 2008 09:29:07 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m0FHSxNw010216
	for <xfs@oss.sgi.com>; Tue, 15 Jan 2008 09:29:01 -0800
Received: from lucidpixels.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C7927520791
	for <xfs@oss.sgi.com>; Tue, 15 Jan 2008 09:29:14 -0800 (PST)
Received: from lucidpixels.com (lucidpixels.com [75.144.35.66]) by cuda.sgi.com with ESMTP id NPJBXl0UCYvsDvHW for <xfs@oss.sgi.com>; Tue, 15 Jan 2008 09:29:14 -0800 (PST)
Date: Tue, 15 Jan 2008 12:29:14 -0500 (EST)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Proper swidth and sunit for RAID 5 (does it matter)?
Message-ID: <alpine.DEB.0.999999.0801151227001.25921@p34.internal.lan>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Dave,

What is the proper sunit and swidth for a 64, 256, and 1024 kilobyte chunk 
size with a 10-disk raid 5?

Also, in the majority of benchmarks it does not seem to matter whether the 
FS is stripe-aligned or not (with SW raid)- does it mainly/only affect HW 
raid?

Current settings (10 disks):

# xfs_info /dev/md3
meta-data=/dev/md3               isize=256    agcount=4, agsize=82417536 
blks
          =                       sectsz=4096  attr=2
data     =                       bsize=4096   blocks=329670144, imaxpct=25
          =                       sunit=0      swidth=0 blks, unwritten=1
naming   =version 2              bsize=4096
log      =internal               bsize=4096   blocks=32768, version=2
          =                       sectsz=4096  sunit=1 blks, lazy-count=1
realtime =none                   extsz=9437184 blocks=0, rtextents=0

Justin.
