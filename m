Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q8O4mSus077932 for <xfs@oss.sgi.com>; Sun, 23 Sep 2012 23:48:28 -0500
Received: from mail-oa0-f53.google.com (mail-oa0-f53.google.com
	[209.85.219.53]) by cuda.sgi.com with ESMTP id HtON4RuOQbqldG2k
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Sun, 23 Sep 2012 21:49:44 -0700 (PDT)
Received: by oagj6 with SMTP id j6so1429775oag.26
	for <xfs@oss.sgi.com>; Sun, 23 Sep 2012 21:49:43 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 24 Sep 2012 16:49:43 +1200
Message-ID: <CAJzjPKm+g9g7qQrvQr+Jy2Gjbj5NZpRY2LyfMQQCi519uqGx=g@mail.gmail.com>
Subject: xlog_space_left: head behind tail ?
From: Gregory Machin <gdm@linuxpro.co.za>
Reply-To: gdm@linuxpro.co.za
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Hi.

Since I started using Acronis backup software I have the following in my logs :

Sep 22 18:00:16 nzhmlfpr04 kernel: session_stat: dev=8:1 state=6
blksize=1024 mmapsize=262144
Sep 22 18:00:16 nzhmlfpr04 kernel: session_stat: psize=1024000
pstrt=2048 mshft=0 ioctls=728
Sep 22 18:00:16 nzhmlfpr04 kernel: session_stat: bhpgs=0 bhcnt=0
abhs=307 fbhs=307 dbhs=0
Sep 22 18:00:16 nzhmlfpr04 kernel: session_stat: gpgs=30836 ppgs=30836
emmax=30662 emmin=28746 emcur=0 cached=0
Sep 22 18:00:16 nzhmlfpr04 kernel: session_stat: rblk=9321 cblk=95
rcblk=46 rc2blk=0 mcblk=38 rwcolls=11
Sep 22 18:00:16 nzhmlfpr04 kernel: session_stat: sync=0 async=26 aretr=0
Sep 22 18:00:16 nzhmlfpr04 kernel: XFS (dm-2): xlog_space_left: head behind tail
Sep 22 18:00:16 nzhmlfpr04 kernel:  tail_cycle = 20, tail_bytes = 26561024
Sep 22 18:00:16 nzhmlfpr04 kernel:  GH   cycle = 20, GH   bytes = 26540592
Sep 22 18:00:16 nzhmlfpr04 kernel: XFS (dm-2): xlog_space_left: head behind tail
Sep 22 18:00:16 nzhmlfpr04 kernel:  tail_cycle = 20, tail_bytes = 26561024
Sep 22 18:00:16 nzhmlfpr04 kernel:  GH   cycle = 20, GH   bytes = 26540592
Sep 22 18:00:16 nzhmlfpr04 kernel: XFS (dm-2): xlog_space_left: head behind tail
Sep 22 18:00:16 nzhmlfpr04 kernel:  tail_cycle = 20, tail_bytes = 26561024
Sep 22 18:00:16 nzhmlfpr04 kernel:  GH   cycle = 20, GH   bytes = 26541608
Sep 22 18:00:16 nzhmlfpr04 kernel: XFS (dm-2): xlog_space_left: head behind tail
Sep 22 18:00:16 nzhmlfpr04 kernel:  tail_cycle = 20, tail_bytes = 26561024
Sep 22 18:00:16 nzhmlfpr04 kernel:  GH   cycle = 20, GH   bytes = 26541608
Sep 22 18:00:17 nzhmlfpr04 kernel: XFS (dm-5): xlog_space_left: head behind tail
Sep 22 18:00:17 nzhmlfpr04 kernel:  tail_cycle = 2052, tail_bytes = 3527680
Sep 22 18:00:17 nzhmlfpr04 kernel:  GH   cycle = 2052, GH   bytes = 3510104
Sep 22 18:00:17 nzhmlfpr04 kernel: XFS (dm-5): xlog_space_left: head behind tail
Sep 22 18:00:17 nzhmlfpr04 kernel:  tail_cycle = 2052, tail_bytes = 3527680
Sep 22 18:00:17 nzhmlfpr04 kernel:  GH   cycle = 2052, GH   bytes = 3510104
Sep 22 18:00:24 nzhmlfpr04 kernel: XFS (dm-3): xlog_space_left: head behind tail
Sep 22 18:00:24 nzhmlfpr04 kernel:  tail_cycle = 125, tail_bytes = 438272
Sep 22 18:00:24 nzhmlfpr04 kernel:  GH   cycle = 125, GH   bytes = 416952
Sep 22 18:00:24 nzhmlfpr04 kernel: XFS (dm-3): xlog_space_left: head behind tail
Sep 22 18:00:24 nzhmlfpr04 kernel:  tail_cycle = 125, tail_bytes = 438272
Sep 22 18:00:24 nzhmlfpr04 kernel:  GH   cycle = 125, GH   bytes = 416952
Sep 22 18:00:30 nzhmlfpr04 kernel: XFS (dm-4): xlog_space_left: head behind tail
Sep 22 18:00:30 nzhmlfpr04 kernel:  tail_cycle = 46, tail_bytes = 11395072
Sep 22 18:00:30 nzhmlfpr04 kernel:  GH   cycle = 46, GH   bytes = 11375664
Sep 22 18:00:30 nzhmlfpr04 kernel: XFS (dm-4): xlog_space_left: head behind tail
Sep 22 18:00:30 nzhmlfpr04 kernel:  tail_cycle = 46, tail_bytes = 11395072
Sep 22 18:00:30 nzhmlfpr04 kernel:  GH   cycle = 46, GH   bytes = 11375664
Sep 22 18:00:33 nzhmlfpr04 kernel: XFS (dm-2): xlog_space_left: head behind tail
Sep 22 18:00:33 nzhmlfpr04 kernel:  tail_cycle = 20, tail_bytes = 26563072
Sep 22 18:00:33 nzhmlfpr04 kernel:  GH   cycle = 20, GH   bytes = 26542632
Sep 22 18:00:33 nzhmlfpr04 kernel: XFS (dm-2): xlog_space_left: head behind tail
Sep 22 18:00:33 nzhmlfpr04 kernel:  tail_cycle = 20, tail_bytes = 26563072
Sep 22 18:00:33 nzhmlfpr04 kernel:  GH   cycle = 20, GH   bytes = 26542632
Sep 22 18:00:47 nzhmlfpr04 kernel: XFS (dm-5): xlog_space_left: head behind tail
Sep 22 18:00:47 nzhmlfpr04 kernel:  tail_cycle = 2052, tail_bytes = 3529728
Sep 22 18:00:47 nzhmlfpr04 kernel:  GH   cycle = 2052, GH   bytes = 3511128
Sep 22 18:00:47 nzhmlfpr04 kernel: XFS (dm-5): xlog_space_left: head behind tail
Sep 22 18:00:47 nzhmlfpr04 kernel:  tail_cycle = 2052, tail_bytes = 3529728
Sep 22 18:00:47 nzhmlfpr04 kernel:  GH   cycle = 2052, GH   bytes = 3511128
Sep 22 18:00:54 nzhmlfpr04 kernel: XFS (dm-3): xlog_space_left: head behind tail
Sep 22 18:00:54 nzhmlfpr04 kernel:  tail_cycle = 125, tail_bytes = 439296
Sep 22 18:00:54 nzhmlfpr04 kernel:  GH   cycle = 125, GH   bytes = 417976
Sep 22 18:00:54 nzhmlfpr04 kernel: XFS (dm-3): xlog_space_left: head behind tail
Sep 22 18:00:54 nzhmlfpr04 kernel:  tail_cycle = 125, tail_bytes = 439296
Sep 22 18:00:54 nzhmlfpr04 kernel:  GH   cycle = 125, GH   bytes = 417976
Sep 22 18:01:00 nzhmlfpr04 kernel: XFS (dm-4): xlog_space_left: head behind tail
Sep 22 18:01:00 nzhmlfpr04 kernel:  tail_cycle = 46, tail_bytes = 11396096
Sep 22 18:01:00 nzhmlfpr04 kernel:  GH   cycle = 46, GH   bytes = 11376688
Sep 22 18:01:00 nzhmlfpr04 kernel: XFS (dm-4): xlog_space_left: head behind tail
Sep 22 18:01:00 nzhmlfpr04 kernel:  tail_cycle = 46, tail_bytes = 11396096
Sep 22 18:01:00 nzhmlfpr04 kernel:  GH   cycle = 46, GH   bytes = 11376688
Sep 22 18:01:03 nzhmlfpr04 kernel: XFS (dm-2): xlog_space_left: head behind tail
Sep 22 18:01:03 nzhmlfpr04 kernel:  tail_cycle = 20, tail_bytes = 26564096
Sep 22 18:01:03 nzhmlfpr04 kernel:  GH   cycle = 20, GH   bytes = 26543656
Sep 22 18:01:03 nzhmlfpr04 kernel: XFS (dm-2): xlog_space_left: head behind tail
Sep 22 18:01:03 nzhmlfpr04 kernel:  tail_cycle = 20, tail_bytes = 26564096
Sep 22 18:01:03 nzhmlfpr04 kernel:  GH   cycle = 20, GH   bytes = 26543656
Sep 22 18:01:17 nzhmlfpr04 kernel: XFS (dm-5): xlog_space_left: head behind tail
Sep 22 18:01:17 nzhmlfpr04 kernel:  tail_cycle = 2052, tail_bytes = 3530752
Sep 22 18:01:17 nzhmlfpr04 kernel:  GH   cycle = 2052, GH   bytes = 3512152
Sep 22 18:01:17 nzhmlfpr04 kernel: XFS (dm-5): xlog_space_left: head behind tail
Sep 22 18:01:17 nzhmlfpr04 kernel:  tail_cycle = 2052, tail_bytes = 3530752
Sep 22 18:01:17 nzhmlfpr04 kernel:  GH   cycle = 2052, GH   bytes = 3512152
Sep 22 18:09:41 nzhmlfpr04 kernel: session_stat: dev=fd:2 state=6
blksize=4096 mmapsize=262144
Sep 22 18:09:41 nzhmlfpr04 kernel: session_stat: psize=209707008
pstrt=0 mshft=0 ioctls=170766
Sep 22 18:09:41 nzhmlfpr04 kernel: session_stat: bhpgs=0 bhcnt=0
abhs=85404 fbhs=85404 dbhs=0
Sep 22 18:09:41 nzhmlfpr04 kernel: session_stat: gpgs=31595 ppgs=31595
emmax=30662 emmin=28746 emcur=0 cached=0
Sep 22 18:09:41 nzhmlfpr04 kernel: session_stat: rblk=5460184 cblk=1
rcblk=1 rc2blk=0 mcblk=1 rwcolls=0
Sep 22 18:09:41 nzhmlfpr04 kernel: session_stat: sync=0 async=1 aretr=0
Sep 22 18:10:10 nzhmlfpr04 kernel: session_stat: dev=fd:0 state=6
blksize=4096 mmapsize=262144
Sep 22 18:10:10 nzhmlfpr04 kernel: session_stat: psize=78725120
pstrt=0 mshft=0 ioctls=25526
Sep 22 18:10:10 nzhmlfpr04 kernel: session_stat: bhpgs=0 bhcnt=0
abhs=4658 fbhs=4658 dbhs=0
Sep 22 18:10:10 nzhmlfpr04 kernel: session_stat: gpgs=31622 ppgs=31622
emmax=30662 emmin=28746 emcur=0 cached=0
Sep 22 18:10:10 nzhmlfpr04 kernel: session_stat: rblk=193051 cblk=525
rcblk=525 rc2blk=0 mcblk=246 rwcolls=53
Sep 22 18:10:10 nzhmlfpr04 kernel: session_stat: sync=0 async=525 aretr=0
Sep 22 18:10:10 nzhmlfpr04 kernel: session_unlockdev: No lock for
device (FD00001) in session (ffff880116b6c000)

Then I found these :
Sep 22 20:17:17 nzhmlfpr04 kernel:  tail_cycle = 2052, tail_bytes = 3572736
Sep 22 20:17:17 nzhmlfpr04 kernel:  GH   cycle = 2052, GH   bytes = 3554064
Sep 22 20:17:24 nzhmlfpr04 kernel: XFS (dm-3): xlog_space_left: head behind tail
Sep 22 20:17:24 nzhmlfpr04 kernel:  tail_cycle = 125, tail_bytes = 488448
Sep 22 20:17:24 nzhmlfpr04 kernel:  GH   cycle = 125, GH   bytes = 467056
Sep 22 20:17:24 nzhmlfpr04 kernel: XFS (dm-3): xlog_space_left: head behind tail
Sep 22 20:17:24 nzhmlfpr04 kernel:  tail_cycle = 125, tail_bytes = 488448
Sep 22 20:17:24 nzhmlfpr04 kernel:  GH   cycle = 125, GH   bytes = 467056
Sep 22 20:17:30 nzhmlfpr04 kernel: XFS (dm-4): xlog_space_left: head behind tail
Sep 22 20:17:30 nzhmlfpr04 kernel:  tail_cycle = 46, tail_bytes = 11430912
Sep 22 20:17:30 nzhmlfpr04 kernel:  GH   cycle = 46, GH   bytes = 11411432
Sep 22 20:17:30 nzhmlfpr04 kernel: XFS (dm-4): xlog_space_left: head behind tail
Sep 22 20:17:30 nzhmlfpr04 kernel:  tail_cycle = 46, tail_bytes = 11430912
Sep 22 20:17:30 nzhmlfpr04 kernel:  GH   cycle = 46, GH   bytes = 11411432
Sep 22 20:17:33 nzhmlfpr04 kernel: XFS (dm-2): xlog_space_left: head behind tail
Sep 22 20:17:33 nzhmlfpr04 kernel:  tail_cycle = 20, tail_bytes = 26600960
Sep 22 20:17:33 nzhmlfpr04 kernel:  GH   cycle = 20, GH   bytes = 26580440
Sep 22 20:17:33 nzhmlfpr04 kernel: XFS (dm-2): xlog_space_left: head behind tail
Sep 22 20:17:33 nzhmlfpr04 kernel:  tail_cycle = 20, tail_bytes = 26600960
Sep 22 20:17:33 nzhmlfpr04 kernel:  GH   cycle = 20, GH   bytes = 26580440
Sep 22 20:17:47 nzhmlfpr04 kernel: XFS (dm-5): xlog_space_left: head behind tail
Sep 22 20:17:47 nzhmlfpr04 kernel:  tail_cycle = 2052, tail_bytes = 3573760
Sep 22 20:17:47 nzhmlfpr04 kernel:  GH   cycle = 2052, GH   bytes = 3555088
Sep 22 20:17:47 nzhmlfpr04 kernel: XFS (dm-5): xlog_space_left: head behind tail
Sep 22 20:17:47 nzhmlfpr04 kernel:  tail_cycle = 2052, tail_bytes = 3573760
Sep 22 20:17:47 nzhmlfpr04 kernel:  GH   cycle = 2052, GH   bytes = 3555088
Sep 22 20:17:54 nzhmlfpr04 kernel: XFS (dm-3): xlog_space_left: head behind tail
Sep 22 20:17:54 nzhmlfpr04 kernel:  tail_cycle = 125, tail_bytes = 489472
Sep 22 20:17:54 nzhmlfpr04 kernel:  GH   cycle = 125, GH   bytes = 468080
Sep 22 20:17:54 nzhmlfpr04 kernel: XFS (dm-3): xlog_space_left: head behind tail
Sep 22 20:17:54 nzhmlfpr04 kernel:  tail_cycle = 125, tail_bytes = 489472
Sep 22 20:17:54 nzhmlfpr04 kernel:  GH   cycle = 125, GH   bytes = 468080
Sep 22 20:19:07 nzhmlfpr04 kernel: XFS (snumbd11d): Corruption
detected. Unmount and run xfs_repair
Sep 22 20:19:07 nzhmlfpr04 kernel: XFS (snumbd11d): inode 0x13461d0d
background reclaim flush failed with 117
Sep 22 20:19:07 nzhmlfpr04 kernel: XFS (snumbd11d): Corruption
detected. Unmount and run xfs_repair
Sep 22 20:19:07 nzhmlfpr04 kernel: XFS (snumbd11d): inode 0x13461d0e
background reclaim flush failed with 117
Sep 22 20:19:07 nzhmlfpr04 kernel: XFS (snumbd11d): Corruption
detected. Unmount and run xfs_repair
Sep 22 20:19:07 nzhmlfpr04 kernel: XFS (snumbd11d): inode 0x13461d0f
background reclaim flush failed with 117
Sep 22 20:19:37 nzhmlfpr04 kernel: XFS (snumbd11d): Corruption
detected. Unmount and run xfs_repair
Sep 22 20:19:37 nzhmlfpr04 kernel: XFS (snumbd11d): inode 0x13461d0d
background reclaim flush failed with 117
Sep 22 20:19:37 nzhmlfpr04 kernel: XFS (snumbd11d): Corruption
detected. Unmount and run xfs_repair
Sep 22 20:19:37 nzhmlfpr04 kernel: XFS (snumbd11d): inode 0x13461d0e
background reclaim flush failed with 117
Sep 22 20:19:37 nzhmlfpr04 kernel: XFS (snumbd11d): Corruption
detected. Unmount and run xfs_repair
Sep 22 20:19:37 nzhmlfpr04 kernel: XFS (snumbd11d): inode 0x13461d0f
background reclaim flush failed with 117
Sep 22 20:20:07 nzhmlfpr04 kernel: XFS (snumbd11d): Corruption
detected. Unmount and run xfs_repair
Sep 22 20:20:07 nzhmlfpr04 kernel: XFS (snumbd11d): inode 0x13461d0d
background reclaim flush failed with 117
Sep 22 20:20:07 nzhmlfpr04 kernel: XFS (snumbd11d): Corruption
detected. Unmount and run xfs_repair
Sep 22 20:20:07 nzhmlfpr04 kernel: XFS (snumbd11d): inode 0x13461d0e
background reclaim flush failed with 117
Sep 22 20:20:07 nzhmlfpr04 kernel: XFS (snumbd11d): Corruption
detected. Unmount and run xfs_repair
Sep 22 20:20:07 nzhmlfpr04 kernel: XFS (snumbd11d): inode 0x13461d0f
background reclaim flush failed with 117


What is the cause for the first lot of logs and are they an issue ?
Did what was causing the first lot of logs create the second
"Corruption detected. Unmount and run xfs_repair"

I ran the xfs_repair and this has relosved the "Corruption detected.
Unmount and run xfs_repair" issue

I want to be sure before I start pointing fingures and asking
questions as to why I'm seeing the first lot of logs and what else
could have cause the 2nd ?

Thanks

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
