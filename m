Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 25 Oct 2008 05:06:54 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9PC5SIG017454
	for <xfs@oss.sgi.com>; Sat, 25 Oct 2008 05:05:28 -0700
Received: from lucidpixels.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 83AD212A7BB6
	for <xfs@oss.sgi.com>; Sat, 25 Oct 2008 05:05:24 -0700 (PDT)
Received: from lucidpixels.com (lucidpixels.com [75.144.35.66]) by cuda.sgi.com with ESMTP id oEgeXIEeZalRecar for <xfs@oss.sgi.com>; Sat, 25 Oct 2008 05:05:24 -0700 (PDT)
Date: Sat, 25 Oct 2008 08:05:23 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: xfs_db: out of memory (2.9.8)
Message-ID: <alpine.DEB.1.10.0810250801360.5019@p34.internal.lan>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

For the root partition I get "out of memory" when I try to check for 
fragmentation.

# xfs_db -c frag -f /dev/md2
xfs_db: out of memory

# xfs_db -V
xfs_db version 2.9.8

# mount | grep "/dev/md2"
/dev/md2 on / type xfs (rw,noatime)

# xfs_info /dev/md2
meta-data=/dev/root              isize=256    agcount=16, agsize=2024942 blks
          =                       sectsz=512   attr=0
data     =                       bsize=4096   blocks=32399072, imaxpct=25
          =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096 
log      =internal               bsize=4096   blocks=15819, version=1
          =                       sectsz=512   sunit=0 blks, lazy-count=0
realtime =none                   extsz=4096   blocks=0, rtextents=0

# xfs_db -c frag -f /dev/md3
actual 228842, ideal 223767, fragmentation factor 2.22%

Any idea?

Justin.
