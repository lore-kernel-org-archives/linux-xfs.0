Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 25 Feb 2008 14:40:06 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m1PMdtTI005037
	for <xfs@oss.sgi.com>; Mon, 25 Feb 2008 14:39:58 -0800
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 97473616D19
	for <xfs@oss.sgi.com>; Mon, 25 Feb 2008 14:40:23 -0800 (PST)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id J3bLxxSyDlJILZJ8 for <xfs@oss.sgi.com>; Mon, 25 Feb 2008 14:40:23 -0800 (PST)
Message-ID: <47C343D1.30304@sandeen.net>
Date: Mon, 25 Feb 2008 14:40:17 -0800
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Linux XFS filesystem corruption (XFS_WANT_CORRUPTED_GOTO)
References: <Pine.LNX.4.64.0802221718430.13471@toro.qb3.berkeley.edu>
In-Reply-To: <Pine.LNX.4.64.0802221718430.13471@toro.qb3.berkeley.edu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: slaton <slaton@berkeley.edu>
Cc: xfs-oss <xfs@oss.sgi.com>

slaton wrote:
> A RAID5 (3ware card w/ 8 drive cage) filesystem on our cluster login node 
> shut down the other night with this error:
> 
> kernel: XFS internal error XFS_WANT_CORRUPTED_GOTO at line 1563 of file 
> 	fs/xfs/xfs_alloc.c.  Caller 0xffffffff8812b3a3
> kernel: Call Trace: [<ffffffff88129713>] [<ffffffff8812b3a3>]
> kernel:        [<ffffffff88150df7>] [<ffffffff8816af8a>] 
> 	[<ffffffff88137d6c>]
> kernel:        [<ffffffff88157d25>] [<ffffffff8816ed1c>] 
> 	[<ffffffff811051fa>]
> kernel:        [<ffffffff8817a5b2>] [<ffffffff8102c988>] 
> 	[<ffffffff882566ee>]
> kernel:        [<ffffffff8825ba4d>] [<ffffffff8825170a>] 
> 	[<ffffffff881a379e>]
> kernel:        [<ffffffff882512da>] [<ffffffff882514a0>] 
> 	[<ffffffff810604e2>]
> kernel:        [<ffffffff882512da>] [<ffffffff882512da>] 
> 	[<ffffffff810604da>]
> kernel: xfs_force_shutdown(sda1,0x8) called from line 4091 of file 
> 	fs/xfs/xfs_bmap.c.  Return address = 0xffffffff88137daf
> kernel: Filesystem "sda1": Corruption of in-memory data detected.  
> Shutting down filesystem: sda1 
> kernel: Please umount the filesystem, and rectify the problem(s)
> kernel: nfsd: non-standard errno: -990
> 
> System hung upon attempting to umount the volume. Have not yet rebooted.
> 
> Some additional info:
> 
> - Server arch is x86_64 (smp).
> 
> - Distro is caos2 linux, kernel 2.6.17 (smp). 2.6.23 pkg is also 
> available.

ksymoops might be good so we can see what the actual backtrace was.

Are you hitting http://oss.sgi.com/projects/xfs/faq.html#dir2 ?

-Eric
