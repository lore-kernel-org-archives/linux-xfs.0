Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 22 Jun 2008 11:13:59 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m5MIDsbx032288
	for <xfs@oss.sgi.com>; Sun, 22 Jun 2008 11:13:55 -0700
Received: from gir.skynet.ie (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5F27B1B37903
	for <xfs@oss.sgi.com>; Sun, 22 Jun 2008 11:14:51 -0700 (PDT)
Received: from gir.skynet.ie (gir.skynet.ie [193.1.99.77]) by cuda.sgi.com with ESMTP id tyMBo53tA4TiSJ7G for <xfs@oss.sgi.com>; Sun, 22 Jun 2008 11:14:51 -0700 (PDT)
Date: Sun, 22 Jun 2008 19:14:49 +0100
From: Mel Gorman <mel@csn.ul.ie>
Subject: Re: [2.6.26-rc7] shrink_icache from pagefault locking (nee: nfsd hangs for a few sec)...
Message-ID: <20080622181449.GD625@csn.ul.ie>
References: <6278d2220806220256g674304ectb945c14e7e09fede@mail.gmail.com> <6278d2220806220258p28de00c1x615ad7b2f708e3f8@mail.gmail.com> <20080622181011.GC625@csn.ul.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20080622181011.GC625@csn.ul.ie>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Daniel J Blueman <daniel.blueman@gmail.com>
Cc: Christoph Lameter <clameter@sgi.com>, Linus Torvalds <torvalds@linux-foundation.org>, Alexander Beregalov <a.beregalov@gmail.com>, Linux Kernel <linux-kernel@vger.kernel.org>, david@fromorbit.com, xfs@oss.sgi.com

(Sorry for the resend, the wrong Dave Chinner's email address was used)

On (22/06/08 10:58), Daniel J Blueman didst pronounce:
> I'm seeing a similar issue [2] to what was recently reported [1] by
> Alexander, but with another workload involving XFS and memory
> pressure.
> 

Is NFS involved or is this XFS only? It looks like XFS-only but no harm in
being sure.

I'm beginning to wonder if this is a problem where a lot of dirty inodes are
being written back in this path and we stall while that happens. I'm still
not getting why we are triggering this now and did not before 2.6.26-rc1
or why it bisects to the zonelist modifications. Diffing the reclaim and
allocation paths between 2.6.25 and 2.6.26-rc1 has not yielded any candidates
for me yet that would explain this.

> SLUB allocator is in use and config is at http://quora.org/config-client-debug .
> 
> Let me know if you'd like more details/vmlinux objdump etc.
> 
> Thanks,
>  Daniel
> 
> --- [1]
> 
> http://groups.google.com/group/fa.linux.kernel/browse_thread/thread/e673c9173d45a735/db9213ef39e4e11c
> 
> --- [2]
> 
> =======================================================
> [ INFO: possible circular locking dependency detected ]
> 2.6.26-rc7-210c #2
> -------------------------------------------------------
> AutopanoPro/4470 is trying to acquire lock:
>  (iprune_mutex){--..}, at: [<ffffffff802d94fd>] shrink_icache_memory+0x7d/0x290
> 
> but task is already holding lock:
>  (&mm->mmap_sem){----}, at: [<ffffffff805e3e15>] do_page_fault+0x255/0x890
> 
> which lock already depends on the new lock.
> 
> 
> the existing dependency chain (in reverse order) is:
> 
> -> #2 (&mm->mmap_sem){----}:
>       [<ffffffff80278f4d>] __lock_acquire+0xbdd/0x1020
>       [<ffffffff802793f5>] lock_acquire+0x65/0x90
>       [<ffffffff805df5ab>] down_read+0x3b/0x70
>       [<ffffffff805e3e3c>] do_page_fault+0x27c/0x890
>       [<ffffffff805e16cd>] error_exit+0x0/0xa9
>       [<ffffffffffffffff>] 0xffffffffffffffff
> 
> -> #1 (&(&ip->i_iolock)->mr_lock){----}:
>       [<ffffffff80278f4d>] __lock_acquire+0xbdd/0x1020
>       [<ffffffff802793f5>] lock_acquire+0x65/0x90
>       [<ffffffff8026d746>] down_write_nested+0x46/0x80
>       [<ffffffff8039df29>] xfs_ilock+0x99/0xa0
>       [<ffffffff8039e0cf>] xfs_ireclaim+0x3f/0x90
>       [<ffffffff803ba889>] xfs_finish_reclaim+0x59/0x1a0
>       [<ffffffff803bc199>] xfs_reclaim+0x109/0x110
>       [<ffffffff803c9541>] xfs_fs_clear_inode+0xe1/0x110
>       [<ffffffff802d906d>] clear_inode+0x7d/0x110
>       [<ffffffff802d93aa>] dispose_list+0x2a/0x100
>       [<ffffffff802d96af>] shrink_icache_memory+0x22f/0x290
>       [<ffffffff8029d868>] shrink_slab+0x168/0x1d0
>       [<ffffffff8029e0b6>] kswapd+0x3b6/0x560
>       [<ffffffff8026921d>] kthread+0x4d/0x80
>       [<ffffffff80227428>] child_rip+0xa/0x12
>       [<ffffffffffffffff>] 0xffffffffffffffff
> 
> -> #0 (iprune_mutex){--..}:
>       [<ffffffff80278db7>] __lock_acquire+0xa47/0x1020
>       [<ffffffff802793f5>] lock_acquire+0x65/0x90
>       [<ffffffff805dedd5>] mutex_lock_nested+0xb5/0x300
>       [<ffffffff802d94fd>] shrink_icache_memory+0x7d/0x290
>       [<ffffffff8029d868>] shrink_slab+0x168/0x1d0
>       [<ffffffff8029db38>] try_to_free_pages+0x268/0x3a0
>       [<ffffffff802979d6>] __alloc_pages_internal+0x206/0x4b0
>       [<ffffffff80297c89>] __alloc_pages_nodemask+0x9/0x10
>       [<ffffffff802b2bc2>] alloc_page_vma+0x72/0x1b0
>       [<ffffffff802a3642>] handle_mm_fault+0x462/0x7b0
>       [<ffffffff805e3ecc>] do_page_fault+0x30c/0x890
>       [<ffffffff805e16cd>] error_exit+0x0/0xa9
>       [<ffffffffffffffff>] 0xffffffffffffffff
> 
> other info that might help us debug this:
> 
> 2 locks held by AutopanoPro/4470:
>  #0:  (&mm->mmap_sem){----}, at: [<ffffffff805e3e15>] do_page_fault+0x255/0x890
>  #1:  (shrinker_rwsem){----}, at: [<ffffffff8029d732>] shrink_slab+0x32/0x1d0
> 
> stack backtrace:
> Pid: 4470, comm: AutopanoPro Not tainted 2.6.26-rc7-210c #2
> 
> Call Trace:
>  [<ffffffff80276823>] print_circular_bug_tail+0x83/0x90
>  [<ffffffff80275e09>] ? print_circular_bug_entry+0x49/0x60
>  [<ffffffff80278db7>] __lock_acquire+0xa47/0x1020
>  [<ffffffff802793f5>] lock_acquire+0x65/0x90
>  [<ffffffff802d94fd>] ? shrink_icache_memory+0x7d/0x290
>  [<ffffffff805dedd5>] mutex_lock_nested+0xb5/0x300
>  [<ffffffff802d94fd>] ? shrink_icache_memory+0x7d/0x290
>  [<ffffffff802d94fd>] shrink_icache_memory+0x7d/0x290
>  [<ffffffff8029d732>] ? shrink_slab+0x32/0x1d0
>  [<ffffffff8029d868>] shrink_slab+0x168/0x1d0
>  [<ffffffff8029db38>] try_to_free_pages+0x268/0x3a0
>  [<ffffffff8029c240>] ? isolate_pages_global+0x0/0x40
>  [<ffffffff802979d6>] __alloc_pages_internal+0x206/0x4b0
>  [<ffffffff80297c89>] __alloc_pages_nodemask+0x9/0x10
>  [<ffffffff802b2bc2>] alloc_page_vma+0x72/0x1b0
>  [<ffffffff802a3642>] handle_mm_fault+0x462/0x7b0
>  [<ffffffff80277e2f>] ? trace_hardirqs_on+0xbf/0x150
>  [<ffffffff805e3e15>] ? do_page_fault+0x255/0x890
>  [<ffffffff805e3ecc>] do_page_fault+0x30c/0x890
>  [<ffffffff805e16cd>] error_exit+0x0/0xa9
> -- 
> Daniel J Blueman
> 

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
