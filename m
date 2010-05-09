Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o49I1jYp231964 for <xfs@oss.sgi.com>; Sun, 9 May 2010 13:01:45 -0500
Received: from b.mx.filmlight.ltd.uk (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with SMTP id C3734323B11
	for <xfs@oss.sgi.com>; Sun,  9 May 2010 11:03:55 -0700 (PDT)
Received: from b.mx.filmlight.ltd.uk (bongo.filmlight.ltd.uk [77.107.81.251])
	by cuda.sgi.com with SMTP id XB1sxCk9Y6w8qwyB for
	<xfs@oss.sgi.com>; Sun, 09 May 2010 11:03:55 -0700 (PDT)
Message-Id: <B461E034-D859-4D21-8DB1-E5FA599833E9@filmlight.ltd.uk>
From: Roger Willcocks <roger@filmlight.ltd.uk>
In-Reply-To: <4BE55A63.8070203@purplehaze.ch>
Mime-Version: 1.0 (Apple Message framework v936)
Subject: Re: failed to read root inode
Date: Sun, 9 May 2010 19:03:52 +0100
References: <4BE55A63.8070203@purplehaze.ch>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"; DelSp="yes"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christian Affolter <christian.affolter@purplehaze.ch>
Cc: xfs@oss.sgi.com

The original xfs_repair log looks reasonably sane, and suggests that  
the block(s) containing inodes 128-191 had been zeroed out. xfs_repair  
claims to have fixed all that up, and rebuilt the root directory  
amongst others.

However xfs_check still complains, and correspondence off-list shows  
that xfs_repair -n detects the same 'bad magic number 0xfeed' on  
alternating inodes as xfs_check:

bad magic number 0xfeed on inode 128
bad version number 0x0 on inode 128
bad magic number 0x0 on inode 129
bad version number 0x0 on inode 129
bad (negative) size -8161755683656211562 on inode 129
bad magic number 0xfeed on inode 130
bad version number 0x0 on inode 130
bad magic number 0x0 on inode 131
bad version number 0x0 on inode 131
bad (negative) size -8161755683656211562 on inode 131

This pattern corresponds to the corruption described in http://oss.sgi.com/archives/xfs/2008-01/msg00696.html

xfs_check also says:

block 0/8 expected type unknown got log
block 0/9 expected type unknown got log
block 0/10 expected type unknown got log
block 0/11 expected type unknown got log

Could xfs_repair (or remounting the disk) have written log data over  
those blocks?

--
Roger


On 8 May 2010, at 13:34, Christian Affolter wrote:

> Hi
>
> After a disk crash within a hardware RAID-6 controller and kernel
> freeze, I'm unable to mount an XFS filesystem on top of an EVMS  
> volume:
>
> Filesystem "dm-13": Disabling barriers, not supported by the  
> underlying
> device
> XFS mounting filesystem dm-13
> Starting XFS recovery on filesystem: dm-13 (logdev: internal)
> XFS internal error XFS_WANT_CORRUPTED_GOTO at line 1599 of file
> fs/xfs/xfs_alloc.c.  Caller 0xffffffff8035c58d
> Pid: 13473, comm: mount Not tainted 2.6.26-gentoo #1
>
> Call Trace:
> [<ffffffff8035c58d>] xfs_free_extent+0xcd/0x110
> [<ffffffff8035aa03>] xfs_free_ag_extent+0x4e3/0x740
> [<ffffffff8035c58d>] xfs_free_extent+0xcd/0x110
> [<ffffffff80395e9d>] xlog_recover_process_efi+0x18d/0x1d0
> [<ffffffff80397400>] xlog_recover_process_efis+0x60/0xa0
> [<ffffffff80397463>] xlog_recover_finish+0x23/0xf0
> [<ffffffff8039d36a>] xfs_mountfs+0x4da/0x680
> [<ffffffff803a9ba8>] kmem_alloc+0x58/0x100
> [<ffffffff803a9cfb>] kmem_zalloc+0x2b/0x40
> [<ffffffff803a3dbd>] xfs_mount+0x36d/0x3a0
> [<ffffffff803b4bad>] xfs_fs_fill_super+0xbd/0x220
> [<ffffffff8028b551>] get_sb_bdev+0x141/0x180
> [<ffffffff803b4af0>] xfs_fs_fill_super+0x0/0x220
> [<ffffffff8028aeb6>] vfs_kern_mount+0x56/0xc0
> [<ffffffff8028af83>] do_kern_mount+0x53/0x110
> [<ffffffff802a343b>] do_new_mount+0x9b/0xe0
> [<ffffffff802a3666>] do_mount+0x1e6/0x220
> [<ffffffff802670f5>] __get_free_pages+0x15/0x60
> [<ffffffff802a373b>] sys_mount+0x9b/0x100
> [<ffffffff8020b49b>] system_call_after_swapgs+0x7b/0x80
>
> Filesystem "dm-13": XFS internal error xfs_trans_cancel at line 1163  
> of
> file fs/xfs/xfs_trans.c.  Caller 0xffffffff80395eb1
> Pid: 13473, comm: mount Not tainted 2.6.26-gentoo #1
>
> Call Trace:
> [<ffffffff80395eb1>] xlog_recover_process_efi+0x1a1/0x1d0
> [<ffffffff8039fd16>] xfs_trans_cancel+0x126/0x150
> [<ffffffff80395eb1>] xlog_recover_process_efi+0x1a1/0x1d0
> [<ffffffff80397400>] xlog_recover_process_efis+0x60/0xa0
> [<ffffffff80397463>] xlog_recover_finish+0x23/0xf0
> [<ffffffff8039d36a>] xfs_mountfs+0x4da/0x680
> [<ffffffff803a9ba8>] kmem_alloc+0x58/0x100
> [<ffffffff803a9cfb>] kmem_zalloc+0x2b/0x40
> [<ffffffff803a3dbd>] xfs_mount+0x36d/0x3a0
> [<ffffffff803b4bad>] xfs_fs_fill_super+0xbd/0x220
> [<ffffffff8028b551>] get_sb_bdev+0x141/0x180
> [<ffffffff803b4af0>] xfs_fs_fill_super+0x0/0x220
> [<ffffffff8028aeb6>] vfs_kern_mount+0x56/0xc0
> [<ffffffff8028af83>] do_kern_mount+0x53/0x110
> [<ffffffff802a343b>] do_new_mount+0x9b/0xe0
> [<ffffffff802a3666>] do_mount+0x1e6/0x220
> [<ffffffff802670f5>] __get_free_pages+0x15/0x60
> [<ffffffff802a373b>] sys_mount+0x9b/0x100
> [<ffffffff8020b49b>] system_call_after_swapgs+0x7b/0x80
>
> xfs_force_shutdown(dm-13,0x8) called from line 1164 of file
> fs/xfs/xfs_trans.c.  Return address = 0xffffffff8039fd2f
> Filesystem "dm-13": Corruption of in-memory data detected.  Shutting
> down filesystem: dm-13
> Please umount the filesystem, and rectify the problem(s)
> Failed to recover EFIs on filesystem: dm-13
> XFS: log mount finish failed
>
>
> I tried to repair the filesystem with the help of xfs_repair many  
> times,
> without any luck:
> Filesystem "dm-13": Disabling barriers, not supported by the  
> underlying
> device
> XFS mounting filesystem dm-13
> XFS: failed to read root inode
>
> xfs_check output:
> cache_node_purge: refcount was 1, not zero (node=0x820010)
> xfs_check: cannot read root inode (117)
> cache_node_purge: refcount was 1, not zero (node=0x8226b0)
> xfs_check: cannot read realtime bitmap inode (117)
> block 0/8 expected type unknown got log
> block 0/9 expected type unknown got log
> block 0/10 expected type unknown got log
> block 0/11 expected type unknown got log
> bad magic number 0xfeed for inode 128
> [...]
>
> Are there any other ways to fix the unreadable root inode or to  
> restore
> the remaining data?
>
>
> Environment informations:
> Linux Kernel: 2.6.26-gentoo (x86_64)
> xfsprogs:     3.0.3
>
> Attached you'll find the xfs_repair and xfs_check output.
>
>
> Thanks in advance and kind regards
> Christian
> < 
> xfs_repair 
> .log><xfs_check.log>_______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
