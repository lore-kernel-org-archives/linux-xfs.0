Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 25 Feb 2008 14:20:32 -0800 (PST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m1PMKRnP002739
	for <xfs@oss.sgi.com>; Mon, 25 Feb 2008 14:20:27 -0800
Received: from toro.qb3.berkeley.edu (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 84B32EBC385
	for <xfs@oss.sgi.com>; Mon, 25 Feb 2008 14:20:54 -0800 (PST)
Received: from toro.qb3.berkeley.edu (toro.QB3.Berkeley.EDU [169.229.244.93]) by cuda.sgi.com with ESMTP id 4HWgRBaVg87b9O3z for <xfs@oss.sgi.com>; Mon, 25 Feb 2008 14:20:54 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
	by toro.qb3.berkeley.edu (Postfix) with ESMTP id 8AAB823913A
	for <xfs@oss.sgi.com>; Mon, 25 Feb 2008 14:20:52 -0800 (PST)
Date: Mon, 25 Feb 2008 14:20:52 -0800 (PST)
From: slaton <slaton@berkeley.edu>
Subject: Linux XFS filesystem corruption (XFS_WANT_CORRUPTED_GOTO)
Message-ID: <Pine.LNX.4.64.0802221718430.13471@toro.qb3.berkeley.edu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-oss <xfs@oss.sgi.com>

A RAID5 (3ware card w/ 8 drive cage) filesystem on our cluster login node 
shut down the other night with this error:

kernel: XFS internal error XFS_WANT_CORRUPTED_GOTO at line 1563 of file 
	fs/xfs/xfs_alloc.c.  Caller 0xffffffff8812b3a3
kernel: Call Trace: [<ffffffff88129713>] [<ffffffff8812b3a3>]
kernel:        [<ffffffff88150df7>] [<ffffffff8816af8a>] 
	[<ffffffff88137d6c>]
kernel:        [<ffffffff88157d25>] [<ffffffff8816ed1c>] 
	[<ffffffff811051fa>]
kernel:        [<ffffffff8817a5b2>] [<ffffffff8102c988>] 
	[<ffffffff882566ee>]
kernel:        [<ffffffff8825ba4d>] [<ffffffff8825170a>] 
	[<ffffffff881a379e>]
kernel:        [<ffffffff882512da>] [<ffffffff882514a0>] 
	[<ffffffff810604e2>]
kernel:        [<ffffffff882512da>] [<ffffffff882512da>] 
	[<ffffffff810604da>]
kernel: xfs_force_shutdown(sda1,0x8) called from line 4091 of file 
	fs/xfs/xfs_bmap.c.  Return address = 0xffffffff88137daf
kernel: Filesystem "sda1": Corruption of in-memory data detected.  
Shutting down filesystem: sda1 
kernel: Please umount the filesystem, and rectify the problem(s)
kernel: nfsd: non-standard errno: -990

System hung upon attempting to umount the volume. Have not yet rebooted.

Some additional info:

- Server arch is x86_64 (smp).

- Distro is caos2 linux, kernel 2.6.17 (smp). 2.6.23 pkg is also 
available.

- Kernel not compiled with CONFIG_4KSTACKS=y.

- xfsprogs package is xfsprogs-2.6.13

Memtest86 is running now - no errors yet reported.

After doing some searches, once this occurs it appears to repeat with 
increasing frequency, and i did read of a number of folks losing all data. 
There also appear to be issues related to using some older kernels and 
xfsprogs.

What kernel and xfsprogs version do you recommend i proceed with, before i 
attempt to remount or run xfs_repair?

Any alternate suggestions for recovery, and how to prevent this from 
recurring?

thanks for any help

slaton
