Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 02 Mar 2008 17:40:48 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m231eZMe005029
	for <xfs@oss.sgi.com>; Sun, 2 Mar 2008 17:40:39 -0800
Message-ID: <47CB587E.8020602@sgi.com>
Date: Mon, 03 Mar 2008 12:46:38 +1100
From: Lachlan McIlroy <lachlan@sgi.com>
Reply-To: lachlan@sgi.com
MIME-Version: 1.0
Subject: Re: XFS_WANT_CORRUPTED_GOTO report
References: <20080302161507.GC12740@teal.hq.k1024.org>
In-Reply-To: <20080302161507.GC12740@teal.hq.k1024.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: iusty@k1024.org
Cc: xfs-oss <xfs@oss.sgi.com>

Iustin Pop wrote:
> Hi,
> 
> I searched the list but didn't find any reports of
> XFS_WANT_CORRUPTED_GOTO in xfs_bmap_add_extent_unwritten_real, so here
> it goes. My kernel is tainted as I use nvidia's binary driver, so if I'm
> told to go away I understand :) Otherwise it's a self compiled amd64
> kernel on debian unstable.
> 
> The filesystem in question was recently grown, and I did on a file:
> xfs_io disk0.img
> resvp 0 2G
> truncate 8G
> 
> (not with G but with the actual numbers). Then I proceeded to write into
> this file (it was used as a qemu disk image) and at some point:
> 
> XFS internal error XFS_WANT_CORRUPTED_GOTO at line 2058 of file fs/xfs/xfs_bmap_btree.c.  Caller 0xffffffff80318a80
> Pid: 281, comm: xfsdatad/1 Tainted: P        2.6.24.3-teal #1
> 
> Call Trace:
>  [<ffffffff80318a80>] xfs_bmap_add_extent_unwritten_real+0x710/0xce0
>  [<ffffffff80323fad>] xfs_bmbt_insert+0x14d/0x150
>  [<ffffffff80318a80>] xfs_bmap_add_extent_unwritten_real+0x710/0xce0
>  [<ffffffff8031b537>] xfs_bmap_add_extent+0x147/0x440
>  [<ffffffff8033a329>] xfs_iext_get_ext+0x49/0x80
>  [<ffffffff80324375>] xfs_btree_init_cursor+0x45/0x220
>  [<ffffffff8031ef71>] xfs_bmapi+0xc31/0x1360
>  [<ffffffff80346258>] xlog_grant_log_space+0x298/0x2e0
>  [<ffffffff80350d48>] xfs_trans_reserve+0xa8/0x210
>  [<ffffffff803409eb>] xfs_iomap_write_unwritten+0x14b/0x220
>  [<ffffffff803405ba>] xfs_iomap+0x25a/0x390
>  [<ffffffff805081ee>] thread_return+0x3a/0x56c
>  [<ffffffff8035da00>] xfs_end_bio_unwritten+0x0/0x40
>  [<ffffffff8035da2f>] xfs_end_bio_unwritten+0x2f/0x40
>  [<ffffffff80249a5c>] run_workqueue+0xcc/0x170
>  [<ffffffff8024a5f0>] worker_thread+0x0/0x110
>  [<ffffffff8024a5f0>] worker_thread+0x0/0x110
>  [<ffffffff8024a693>] worker_thread+0xa3/0x110
>  [<ffffffff8024e1e0>] autoremove_wake_function+0x0/0x30
>  [<ffffffff8024a5f0>] worker_thread+0x0/0x110
>  [<ffffffff8024a5f0>] worker_thread+0x0/0x110
>  [<ffffffff8024de1b>] kthread+0x4b/0x80
>  [<ffffffff8020cac8>] child_rip+0xa/0x12
>  [<ffffffff8024ddd0>] kthread+0x0/0x80
>  [<ffffffff8020cabe>] child_rip+0x0/0x12
> 
> Filesystem "dm-4": XFS internal error xfs_trans_cancel at line 1163 of file fs/xfs/xfs_trans.c.  Caller 0xffffffff80340a9b
> Pid: 281, comm: xfsdatad/1 Tainted: P        2.6.24.3-teal #1
> 
> Call Trace:
>  [<ffffffff80340a9b>] xfs_iomap_write_unwritten+0x1fb/0x220
>  [<ffffffff803515d4>] xfs_trans_cancel+0x104/0x130
>  [<ffffffff80340a9b>] xfs_iomap_write_unwritten+0x1fb/0x220
>  [<ffffffff803405ba>] xfs_iomap+0x25a/0x390
>  [<ffffffff805081ee>] thread_return+0x3a/0x56c
>  [<ffffffff8035da00>] xfs_end_bio_unwritten+0x0/0x40
>  [<ffffffff8035da2f>] xfs_end_bio_unwritten+0x2f/0x40
>  [<ffffffff80249a5c>] run_workqueue+0xcc/0x170
>  [<ffffffff8024a5f0>] worker_thread+0x0/0x110
>  [<ffffffff8024a5f0>] worker_thread+0x0/0x110
>  [<ffffffff8024a693>] worker_thread+0xa3/0x110
>  [<ffffffff8024e1e0>] autoremove_wake_function+0x0/0x30
>  [<ffffffff8024a5f0>] worker_thread+0x0/0x110
>  [<ffffffff8024a5f0>] worker_thread+0x0/0x110
>  [<ffffffff8024de1b>] kthread+0x4b/0x80
>  [<ffffffff8020cac8>] child_rip+0xa/0x12
>  [<ffffffff8024ddd0>] kthread+0x0/0x80
>  [<ffffffff8020cabe>] child_rip+0x0/0x12
> 
> xfs_force_shutdown(dm-4,0x8) called from line 1164 of file fs/xfs/xfs_trans.c.  Return address = 0xffffffff803515ed
> Filesystem "dm-4": Corruption of in-memory data detected.  Shutting down filesystem: dm-4
> Please umount the filesystem, and rectify the problem(s)
> 
> 
> xfs_repair didn't say anything related to corruption, mounting it just
> said starting recovery... ending recovery.
That reinforces the message above that the corruption was in-memory and
that the on-disk version is good.

> 
> After mount, the file in question is heavily fragmented (around 1600
> segments). I'm not sure if this file caused the corruption, but I'm
> almost certain, as no other traffic should have been at that time.
The file being written to (that caused the panic) has unwritten extents
and we were trying to convert the extents from unwritten to real after
writing to them.  These XFS_WANT_CORRUPTED_GOTO bugs often occur with
extent tree corruption so this is not surprising.  Could we get output
from xfs_bmap -v on this file?

> 
> I also have a metadump (run before recovery) and a full copy of the
> filesystem if it's useful.
Can we get a copy of that metadump?  I don't hold high hopes for it
though - the filesystem can be inconsistent until the log is replayed
but after the log was replayed the problem was gone.  I don't suppose
you have a copy of the log?
