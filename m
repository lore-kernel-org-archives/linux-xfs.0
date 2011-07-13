Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6D03dJq056629 for <xfs@oss.sgi.com>; Tue, 12 Jul 2011 19:03:40 -0500
Received: from ipmail07.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id F1C3A1BA1C4C
	for <xfs@oss.sgi.com>; Tue, 12 Jul 2011 17:03:36 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	aG1QENxtJNhrRAgL for <xfs@oss.sgi.com>;
	Tue, 12 Jul 2011 17:03:36 -0700 (PDT)
Date: Wed, 13 Jul 2011 10:03:32 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: PM / hibernate xfs lock up / xfs_reclaim_inodes_ag
Message-ID: <20110713000332.GM23038@dastard>
References: <4E1C70AD.1010101@u-club.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4E1C70AD.1010101@u-club.de>
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
To: Christoph <cr2005@u-club.de>
Cc: rjw@sisk.pl, xfs@oss.sgi.com

On Tue, Jul 12, 2011 at 06:05:01PM +0200, Christoph wrote:
> Hi!
> 
> I'd like you to have a look into this issue:
> 
> pm-hibernate locks up when using xfs while "Preallocating image memory".
> 
> https://bugzilla.kernel.org/show_bug.cgi?id=33622
> 
> I got at least this backtrace (2.6.39.3)
> 
> tia
> 
> chris
> 
> 
> 
> SysRq : Show Blocked State
> 
> pm-hibernate    D 0000000000000000     0  3638   3637 0x00000000
>  ffff8800017bf918 0000000000000082 ffff8800017be010 ffff880000000000
>  ffff8800017be010 ffff88000b8a6170 0000000000013900 ffff8800017bffd8
>  ffff8800017bffd8 0000000000013900 ffffffff8148b020 ffff88000b8a6170
> Call Trace:
>  [<ffffffff81344ce2>] schedule_timeout+0x22/0xbb
>  [<ffffffff81344b64>] wait_for_common+0xcb/0x148
>  [<ffffffff810408ea>] ? try_to_wake_up+0x18c/0x18c
>  [<ffffffff81345527>] ? down_write+0x2d/0x31
>  [<ffffffff81344c7b>] wait_for_completion+0x18/0x1a
>  [<ffffffffa02374da>] xfs_reclaim_inode+0x74/0x258 [xfs]
>  [<ffffffffa0237853>] xfs_reclaim_inodes_ag+0x195/0x264 [xfs]
>  [<ffffffffa0237974>] xfs_reclaim_inode_shrink+0x52/0x90 [xfs]
>  [<ffffffff810c4e21>] shrink_slab+0xdb/0x151
>  [<ffffffff810c625a>] do_try_to_free_pages+0x204/0x39a
>  [<ffffffff8134ce4e>] ? apic_timer_interrupt+0xe/0x20
>  [<ffffffff810c647f>] shrink_all_memory+0x8f/0xa8
>  [<ffffffff810cc41a>] ? next_online_pgdat+0x20/0x41
>  [<ffffffff8107937d>] hibernate_preallocate_memory+0x1c4/0x30f
>  [<ffffffff811a8fa2>] ? kobject_put+0x47/0x4b
>  [<ffffffff81077eb2>] hibernation_snapshot+0x45/0x281
>  [<ffffffff810781bf>] hibernate+0xd1/0x1b8
>  [<ffffffff81076c58>] state_store+0x57/0xce
>  [<ffffffff811a8d0b>] kobj_attr_store+0x17/0x19
>  [<ffffffff81152bda>] sysfs_write_file+0xfc/0x138
>  [<ffffffff810fca74>] vfs_write+0xa9/0x105
>  [<ffffffff810fcb89>] sys_write+0x45/0x6c
>  [<ffffffff8134c492>] system_call_fastpath+0x16/0x1b

It's waiting for IO completion, and holding an AG scan lock.

And IO completion requires a workqueue to run. Just FYI, this
process of inode reclaim can dirty the filesystem, long after
hibernate have assumed that it is clean due to the sys_sync() call
you do after freezing the processes. I pointed out this flaw in
using sync to write dirty data prior to hibernate a couple of years
ago.

Anyway, it's a good thing that XFS doesn't use freezable work
queues, otherwise it would hang on every hibernate. Perhaps I should
do that to force hibernate to do things properly in filesystems
land.

However, it is entirely possible that something else that XFS relies
on for IO completion has been put to sleep by this point.

/me finds the smoking cannon:

[  648.794455] xfsbufd/sda3    D 0000000000000000     0   192      2 0x00000000
[  648.794455]  ffff88003720be00 0000000000000046 ffff88003720bd90 ffffffff00000000
[  648.794455]  ffff88003720a010 ffff880056bc3580 0000000000013900 ffff88003720bfd8
[  648.794455]  ffff88003720bfd8 0000000000013900 ffffffff8148b020 ffff880056bc3580
[  648.794455] Call Trace:
[  648.794455]  [<ffffffff81065c0a>] refrigerator+0xbd/0xd3
[  648.794455]  [<ffffffffa022d072>] xfsbufd+0x93/0x14d [xfs]
[  648.794455]  [<ffffffffa022cfdf>] ? xfs_free_buftarg+0x4c/0x4c [xfs]
[  648.794455]  [<ffffffff8105f25a>] kthread+0x7d/0x85
[  648.794455]  [<ffffffff8134d6e4>] kernel_thread_helper+0x4/0x10
[  648.794455]  [<ffffffff8105f1dd>] ? kthread_worker_fn+0x148/0x148
[  648.794455]  [<ffffffff8134d6e0>] ? gs_change+0x13/0x13

The xfsbufd, responsible for pushing out dirty metadata, has been
been frozen. sys_sync() does not push out dirty metadata because it
is already on stable storage in the journal. If the flush lock is
already held on the inode, then inode reclaim will wait for the
xfsbufd to flush the backing buffer because reclaim can't do it
directly. And hibernate has already frozen the xfsbufd.

IOWs, what hibernate does is:

	freeze_processes()
	sys_sync()
	allocate a large amount of memory

Freezing the processes causes parts of filesystems to be put in the
fridge, which means there is no guarantee that sys_sync() actually
does what it is supposed to. As it is, sys_sync() really only
guarantees file data is clean in memory - metadata does not need to
be clean as long s it has been journalled and the journal is safe on
disk.

Further, allocating memory can cause memory reclaim to enter the
filesystem and try to free memory held by the filesystem. In XFS (at
least) this can cause the filesystem to issue tranactions and
metadata IO to clean the dirty metadata to enable it to be
reclaimed. So hibernate is effectively guaranteed to dirty the
filesystem after it has frozen all the worker threads the filesystem
might rely on.

Also, by this point kswapd has already been frozen, so hibernate is
relying totally on direct memory reclaim to free up the memory it
requires. I'm not sure that's a good idea.

IOWs, hibernate is still broken by design - and broken in exactly
the way that was pointed out a couple of years ago by myself and
others in the filesystem world: sys_sync() does not quiesce or
guarantee a clean filesystem in memory after it completes.

There is a solution to this, and it already exists - it's called
freezing the filesystem. Effectively hibernate needs to allocate
memory before it freezes kernel/filesystem worker threads:

	freeze_userspace_processes()

	// just to clean the page cache quickly
	sys_sync()

	// optionally to free page/inode/dentry caches:
		iterate_supers(drop_pagecache_sb, NULL);
		drop_slab()

	allocate a large amount of memory

	// Now quiesce the filesystems and clean remaining metadata
	iterate_supers(freeze_super, NULL);

	freeze_remaining_processes()

This guarantees that filesystems are still working when memory
reclaim comes along to free memory for the hibernate image, and that
once it is allocated that filesystems will not be changed until
thawed on the hibernate wakeup.

So, like I said a couple of years ago: fix hibernate to quiesce
filesystems properly, and the hibernate will be much more reliable
and robust and less likely to break randomly in the future.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
