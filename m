Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail03.adl6.internode.on.net ([150.101.137.143]:44174 "EHLO
        ipmail03.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725926AbeIGETD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 7 Sep 2018 00:19:03 -0400
Date: Fri, 7 Sep 2018 09:40:45 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: lockdep splat on 4.18.0
Message-ID: <20180906234045.GG27618@dastard>
References: <e9324157-e423-d4d4-375b-6bd8f24c7c2a@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e9324157-e423-d4d4-375b-6bd8f24c7c2a@suse.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jeff Mahoney <jeffm@suse.com>
Cc: xfs <linux-xfs@vger.kernel.org>

On Thu, Sep 06, 2018 at 11:44:07AM -0400, Jeff Mahoney wrote:
> Hi folks -
> 
> I hit this lockdep splat on 4.18.0 this morning (the + in the version is
> due to btrfs patch; xfs is unmodified).  In my experience lockdep splats
> involving mount are false positive, but Eric suggested I drop it here
> just the same.

Thanks Jeff!

tl;dr looks like a false positive we might be able to shut up by
changing the order of code in xfs_trans_alloc().

> 
> -Jeff
> 
> ======================================================
> WARNING: possible circular locking dependency detected
> 4.18.0-vanilla+ #8 Not tainted
> ------------------------------------------------------
> kswapd0/56 is trying to acquire lock:
> 000000002f3c47dc (sb_internal){.+.+}, at: xfs_trans_alloc+0x19d/0x250 [xfs]
> 
> but task is already holding lock:
> 00000000e0553233 (fs_reclaim){+.+.}, at: __fs_reclaim_acquire+0x5/0x40
> 
> which lock already depends on the new lock.
> 
> 
> the existing dependency chain (in reverse order) is:
> 
> -> #1 (fs_reclaim){+.+.}:
>        lock_acquire+0xbd/0x220
>        __fs_reclaim_acquire+0x2c/0x40
>        kmem_cache_alloc+0x2b/0x320
>        kmem_zone_alloc+0x95/0x100 [xfs]
>        xfs_trans_alloc+0x6f/0x250 [xfs]
>        xlog_recover_process_intents+0x1f6/0x300 [xfs]
>        xlog_recover_finish+0x18/0xa0 [xfs]
>        xfs_log_mount_finish+0x6d/0x110 [xfs]
>        xfs_mountfs+0x6f0/0xa40 [xfs]
>        xfs_fs_fill_super+0x520/0x6e0 [xfs]
>        mount_bdev+0x187/0x1c0
>        mount_fs+0x3a/0x160
>        vfs_kern_mount+0x66/0x150
>        do_mount+0x1d9/0xcf0
>        ksys_mount+0x7e/0xd0
>        __x64_sys_mount+0x21/0x30
>        do_syscall_64+0x5d/0x1a0
>        entry_SYSCALL_64_after_hwframe+0x49/0xbe
> 
> -> #0 (sb_internal){.+.+}:
>        __lock_acquire+0x436/0x770
>        lock_acquire+0xbd/0x220
>        __sb_start_write+0x166/0x1d0
>        xfs_trans_alloc+0x19d/0x250 [xfs]
>        xfs_iomap_write_allocate+0x1d7/0x330 [xfs]
>        xfs_map_blocks+0x2d7/0x550 [xfs]
>        xfs_do_writepage+0x26b/0x7a0 [xfs]
>        xfs_vm_writepage+0x28/0x50 [xfs]
>        pageout.isra.51+0x1ca/0x450
>        shrink_page_list+0x811/0xe30
>        shrink_inactive_list+0x2e2/0x770
>        shrink_node_memcg+0x32d/0x750
>        shrink_node+0xc9/0x470
>        balance_pgdat+0x175/0x360
>        kswapd+0x181/0x5d0
>        kthread+0xf8/0x130
>        ret_from_fork+0x3a/0x50
> 
> other info that might help us debug this:
> 
>  Possible unsafe locking scenario:
> 
>        CPU0                    CPU1
>        ----                    ----
>   lock(fs_reclaim);
>                                lock(sb_internal);
>                                lock(fs_reclaim);
>   lock(sb_internal);

Ok, looks like kswapd is doing direct writeback from reclaim (why
hasn't that been killed already?), which takes a freeze reference
before we start the transaction. Then, elsewhere, we do the normal
thing of taking a freeze reference, then allocating the transaction
structure via GFP_KERNEL, triggering then "memory reclaim lock
inversion".

It's not a deadlock - for anything to deadlock in this path, we have
to be in the middle of a freeze and have frozen the transaction
subsystem. Which we cannot do until we've cleaned all the dirty
cached pages in the filesystem and frozen all new writes. Which means
kswapd cannot enter this direct writeback path because we can't have
dirty pages on the filesystem.

So, yeah, yet another false positive.

I suspect we can shut it up by changing the order of operations in
xfs_trans_alloc(). I'll have a look at that.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
