Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6R9XtFJ180288 for <xfs@oss.sgi.com>; Wed, 27 Jul 2011 04:33:56 -0500
Received: from ogre.sisk.pl (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4631F9B439
	for <xfs@oss.sgi.com>; Wed, 27 Jul 2011 02:33:53 -0700 (PDT)
Received: from ogre.sisk.pl (ogre.sisk.pl [217.79.144.158]) by cuda.sgi.com
	with ESMTP id qxvsyHImB1IHk2As for <xfs@oss.sgi.com>;
	Wed, 27 Jul 2011 02:33:53 -0700 (PDT)
From: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: PM / hibernate xfs lock up / xfs_reclaim_inodes_ag
Date: Wed, 27 Jul 2011 11:35:13 +0200
References: <4E1C70AD.1010101@u-club.de> <201107262228.12099.rjw@sisk.pl>
	<20110727004543.GE8048@dastard>
In-Reply-To: <20110727004543.GE8048@dastard>
MIME-Version: 1.0
Message-Id: <201107271135.13297.rjw@sisk.pl>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph <cr2005@u-club.de>, Linux PM mailing list <linux-pm@lists.linux-foundation.org>, Nigel Cunningham <nigel@tuxonice.net>, Pavel Machek <pavel@ucw.cz>, xfs@oss.sgi.com

On Wednesday, July 27, 2011, Dave Chinner wrote:
> On Tue, Jul 26, 2011 at 10:28:11PM +0200, Rafael J. Wysocki wrote:
> > On Wednesday, July 13, 2011, Dave Chinner wrote:
> > > On Tue, Jul 12, 2011 at 06:05:01PM +0200, Christoph wrote:
> .....
> > > > SysRq : Show Blocked State
> > > > 
> > > > pm-hibernate    D 0000000000000000     0  3638   3637 0x00000000
> > > >  ffff8800017bf918 0000000000000082 ffff8800017be010 ffff880000000000
> > > >  ffff8800017be010 ffff88000b8a6170 0000000000013900 ffff8800017bffd8
> > > >  ffff8800017bffd8 0000000000013900 ffffffff8148b020 ffff88000b8a6170
> > > > Call Trace:
> > > >  [<ffffffff81344ce2>] schedule_timeout+0x22/0xbb
> > > >  [<ffffffff81344b64>] wait_for_common+0xcb/0x148
> > > >  [<ffffffff810408ea>] ? try_to_wake_up+0x18c/0x18c
> > > >  [<ffffffff81345527>] ? down_write+0x2d/0x31
> > > >  [<ffffffff81344c7b>] wait_for_completion+0x18/0x1a
> > > >  [<ffffffffa02374da>] xfs_reclaim_inode+0x74/0x258 [xfs]
> > > >  [<ffffffffa0237853>] xfs_reclaim_inodes_ag+0x195/0x264 [xfs]
> > > >  [<ffffffffa0237974>] xfs_reclaim_inode_shrink+0x52/0x90 [xfs]
> > > >  [<ffffffff810c4e21>] shrink_slab+0xdb/0x151
> > > >  [<ffffffff810c625a>] do_try_to_free_pages+0x204/0x39a
> > > >  [<ffffffff8134ce4e>] ? apic_timer_interrupt+0xe/0x20
> > > >  [<ffffffff810c647f>] shrink_all_memory+0x8f/0xa8
> > > >  [<ffffffff810cc41a>] ? next_online_pgdat+0x20/0x41
> > > >  [<ffffffff8107937d>] hibernate_preallocate_memory+0x1c4/0x30f
> > > >  [<ffffffff811a8fa2>] ? kobject_put+0x47/0x4b
> > > >  [<ffffffff81077eb2>] hibernation_snapshot+0x45/0x281
> > > >  [<ffffffff810781bf>] hibernate+0xd1/0x1b8
> > > >  [<ffffffff81076c58>] state_store+0x57/0xce
> > > >  [<ffffffff811a8d0b>] kobj_attr_store+0x17/0x19
> > > >  [<ffffffff81152bda>] sysfs_write_file+0xfc/0x138
> > > >  [<ffffffff810fca74>] vfs_write+0xa9/0x105
> > > >  [<ffffffff810fcb89>] sys_write+0x45/0x6c
> > > >  [<ffffffff8134c492>] system_call_fastpath+0x16/0x1b
> > > 
> > > It's waiting for IO completion, and holding an AG scan lock.
> > > 
> > > And IO completion requires a workqueue to run. Just FYI, this
> > > process of inode reclaim can dirty the filesystem, long after
> > > hibernate have assumed that it is clean due to the sys_sync() call
> > > you do after freezing the processes. I pointed out this flaw in
> > > using sync to write dirty data prior to hibernate a couple of years
> > > ago.
> > 
> > However, attempts to remove the sys_sync() from the hibernate code
> > were objected to by some developers, since they believe it will increase
> > the probability of data loss in case of a failing hibernation in general. 
> 
> I'm not suggesting it gets removed, I'm suggesting it gets replaced
> because it doesn't give the guarantees that you want or need.
> 
> > > Anyway, it's a good thing that XFS doesn't use freezable work
> > > queues, otherwise it would hang on every hibernate. Perhaps I should
> > > do that to force hibernate to do things properly in filesystems
> > > land.
> > 
> > Well, I'd say it's a very well known fact that filesystems are not
> > handled in any special way during hibernation, which is not a good
> > thing.  Nevertheless, I've never seen anyone from the filesystems land
> > pay any kind of attention to this issue.
> 
> I beg to differ. We went through this exact clas of bugs with swsusp
> back in 2006:
> 
> https://lkml.org/lkml/2006/11/12/144

You're right, sorry.  We discussed this 5 years ago, but the context
was a bit different (the hibernation code was using a different
mechanism for freeing memory).

> And this patch:
> 
> https://lkml.org/lkml/2006/11/1/155
> 
> ([PATCH -mm] swsusp: Freeze filesystems during suspend)
> 
> "This is needed by swsusp, because some filesystems (eg. XFS) use
> work queues and worker_threads run with PF_NOFREEZE set, so they can
> cause some writes to be performed after the suspend image has been
> created which may corrupt the filesystem.  The additional benefit of
> it is that if the resume fails, the filesystems will be in a
> consistent state and there won't be any journal replays needed."
> 
> --
> 
> And the patch essentially does:
> 
> -			sys_sync();
> +			freeze_filesystems();

Well, if you still think the patch does the right thing, I can rebase it
on top of the current freezer code and resubmit.

> But, Pavel didn't like freezing filesystems to quiesce them
> correctly, so the sys_sync() and all it's problems have remained
> until this day, where we still have users tripping over the same
> "filesystem not idle" problems.

The problem seems to be quite specific to XFS, though.

The Pavel's objection, if I remember it correctly, was that some
(or the majority of?) filesystems didn't implement the freezing operation,
so they would be more vulnerable to data loss in case of a failing hibernation
after this change.  However, that's better than actively causing pain to XFS
users.

> 
> [....]
> 
> > > IOWs, what hibernate does is:
> > > 
> > > 	freeze_processes()
> > > 	sys_sync()
> > > 	allocate a large amount of memory
> > > 
> > > Freezing the processes causes parts of filesystems to be put in the
> > > fridge, which means there is no guarantee that sys_sync() actually
> > > does what it is supposed to. As it is, sys_sync() really only
> > > guarantees file data is clean in memory - metadata does not need to
> > > be clean as long s it has been journalled and the journal is safe on
> > > disk.
> > >
> > > Further, allocating memory can cause memory reclaim to enter the
> > > filesystem and try to free memory held by the filesystem. In XFS (at
> > > least) this can cause the filesystem to issue tranactions and
> > > metadata IO to clean the dirty metadata to enable it to be
> > > reclaimed. So hibernate is effectively guaranteed to dirty the
> > > filesystem after it has frozen all the worker threads the filesystem
> > > might rely on.
> > > 
> > > Also, by this point kswapd has already been frozen, so hibernate is
> > > relying totally on direct memory reclaim to free up the memory it
> > > requires. I'm not sure that's a good idea.
> > > 
> > > IOWs, hibernate is still broken by design - and broken in exactly
> > > the way that was pointed out a couple of years ago by myself and
> > > others in the filesystem world: sys_sync() does not quiesce or
> > > guarantee a clean filesystem in memory after it completes.
> > > 
> > > There is a solution to this, and it already exists - it's called
> > > freezing the filesystem. Effectively hibernate needs to allocate
> > > memory before it freezes kernel/filesystem worker threads:
> > > 
> > > 	freeze_userspace_processes()
> > > 
> > > 	// just to clean the page cache quickly
> > > 	sys_sync()
> > > 
> > > 	// optionally to free page/inode/dentry caches:
> > > 		iterate_supers(drop_pagecache_sb, NULL);
> > > 		drop_slab()
> > > 
> > > 	allocate a large amount of memory
> > > 
> > > 	// Now quiesce the filesystems and clean remaining metadata
> > > 	iterate_supers(freeze_super, NULL);
> > > 
> > > 	freeze_remaining_processes()
> > > 
> > > This guarantees that filesystems are still working when memory
> > > reclaim comes along to free memory for the hibernate image, and that
> > > once it is allocated that filesystems will not be changed until
> > > thawed on the hibernate wakeup.
> > > 
> > > So, like I said a couple of years ago: fix hibernate to quiesce
> > > filesystems properly, and the hibernate will be much more reliable
> > > and robust and less likely to break randomly in the future.
> > 
> > Why don't you simply submit a patch to do that?
> 
> a) I don't know how to test suspend/hibernate
> b) I don't have any hardware I can test it on.
> c) I don't scale to solving every problem Linux has
> d) you guys need to decide how you're going to fix this because the
> problem has already been solved once before and it didn't get merged
> because nobody in the swsusp/hibernate world could agree on anything
> at the time.

OK, I'm not a filesystem expert in turn.

As I said, I can revive the Nigel's patch if you think it's better than
the code we have, but I'm afraid that's all I can do without any help from
the filesystems people.

Thanks,
Rafael

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
