Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 22 Jun 2008 15:29:05 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m5MMSvAB032587
	for <xfs@oss.sgi.com>; Sun, 22 Jun 2008 15:28:58 -0700
Received: from ipmail01.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id AD4BE2659C3
	for <xfs@oss.sgi.com>; Sun, 22 Jun 2008 15:29:55 -0700 (PDT)
Received: from ipmail01.adl6.internode.on.net (ipmail01.adl6.internode.on.net [203.16.214.146]) by cuda.sgi.com with ESMTP id kcNUGTCmz1zR2ea1 for <xfs@oss.sgi.com>; Sun, 22 Jun 2008 15:29:55 -0700 (PDT)
Date: Mon, 23 Jun 2008 08:29:52 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [2.6.26-rc7] shrink_icache from pagefault locking (nee: nfsd
	hangs for a few sec)...
Message-ID: <20080622222952.GB11558@disturbed>
References: <6278d2220806220256g674304ectb945c14e7e09fede@mail.gmail.com> <6278d2220806220258p28de00c1x615ad7b2f708e3f8@mail.gmail.com> <20080622181011.GC625@csn.ul.ie> <20080622112100.794b1ae1@infradead.org> <6278d2220806221356o4c611e43n305ec9653d6d5359@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6278d2220806221356o4c611e43n305ec9653d6d5359@mail.gmail.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Daniel J Blueman <daniel.blueman@gmail.com>
Cc: Arjan van de Ven <arjan@infradead.org>, Mel Gorman <mel@csn.ul.ie>, Christoph Lameter <clameter@sgi.com>, Linus Torvalds <torvalds@linux-foundation.org>, Alexander Beregalov <a.beregalov@gmail.com>, Linux Kernel <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com

On Sun, Jun 22, 2008 at 09:56:17PM +0100, Daniel J Blueman wrote:
> On Sun, Jun 22, 2008 at 7:21 PM, Arjan van de Ven <arjan@infradead.org> wrote:
> > this sort of thing can easily be exposed with the latencytop tool...
> > it will at least tell you WHAT the system is blocking on.
> > (not so much the why, the tool isn't smart enough to automatically spit
> > out kernel patches yet)
> 
> Good plan. I reproduced this without NFS mounted, so pure XFS. I
> wasn't able to capture the same process's (ie 5480) latencytop trace,
> but it may have contributed to the list.
> 
> A fair amount of debugging was turned on, hurting the latency some
> (despite it being a 3.6GHz Penryn).
> 
> Daniel
> 
> --- [1]
> 
> $ vmstat 1
> procs -----------memory---------- ---swap-- -----io---- -system-- ----cpu----
>  r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id wa
> <snip>
>  1  1    156  14424     12 2329672    0    0     0 110755  177 3820 57  6 36  0
>  2  1    156  14736     12 2348152    0    0    24 25172  204 26018 35 21 43  1
>  5  0    156  24252     12 2363800    0    0 59656    31  545 25292 35 14 28 23
>  4  0    156  14696     12 2317784    0    0  3824     0   38 23083 95  6  0  0
>  4  0    156  14440     12 2319304    0    0  4672     0   72 3372 93  3  3  2
>  2  0    156  14428     12 2318484    0    0     0     4   27  731 52  0 49  0
>  2  0    156  14480     12 2308512    0    0     0    12   32 36629 39 13 49  0
>  2  0    156  14572     12 2301220    0    0  3904 12316  117 10760 58  7 26 11
> 
> --- [2]
> 
> Cause                                                Maximum     Percentage
> down xfs_buf_lock _xfs_buf_find xfs_buf_get_flags 271.1 msec          0.4 %

Waiting on I/O to complete. Your disk is busy.

> down xfs_buf_iowait xfs_buf_iostart xfs_buf_read_f206.1 msec          1.3 %

Waiting on I/O to complete. Your disk is busy.

> down xfs_buf_lock xfs_getsb xfs_trans_getsb xfs_tr160.4 msec          0.5 %

Waiting on a superblock I/O or a transaction to complete. Your
disk is busy.  (Note, this one can be avoided with lazy
superblock counters).

[snip reast of "busy disk trace"]

But really, all latencytop is telling you here is that it takes
time to wait for I/O to complete. It's mostly useless for tracking
down locking issues when you've got I/O in progress...

> 2.6.26-rc7-211c #2
> -------------------------------------------------------
> AutopanoPro/5480 is trying to acquire lock:
>  (iprune_mutex){--..}, at: [<ffffffff802d2a5d>] shrink_icache_memory+0x7d/0x280
> 
> but task is already holding lock:
>  (&(&ip->i_iolock)->mr_lock){----}, at: [<ffffffff803a459f>]
> xfs_ilock+0xbf/0x110
> 
> which lock already depends on the new lock.
> 
> the existing dependency chain (in reverse order) is:
> 
> -> #1 (&(&ip->i_iolock)->mr_lock){----}:
>        [<ffffffff802769ad>] __lock_acquire+0xbdd/0x1020
>        [<ffffffff80276e55>] lock_acquire+0x65/0x90
>        [<ffffffff8026b41b>] down_write_nested+0x4b/0x90
>        [<ffffffff803a45df>] xfs_ilock+0xff/0x110
>        [<ffffffff803a47af>] xfs_ireclaim+0x3f/0x90
>        [<ffffffff803c9169>] xfs_finish_reclaim+0x59/0x220
>        [<ffffffff803cc3b5>] xfs_reclaim+0x185/0x190
>        [<ffffffff803d9211>] xfs_fs_clear_inode+0xe1/0x130
>        [<ffffffff802d25c7>] clear_inode+0x87/0x120
>        [<ffffffff802d290a>] dispose_list+0x2a/0x100
>        [<ffffffff802d2c06>] shrink_icache_memory+0x226/0x280
>        [<ffffffff8029d9c5>] shrink_slab+0x125/0x180
>        [<ffffffff8029dc52>] try_to_free_pages+0x232/0x360
>        [<ffffffff80297f0d>] __alloc_pages_internal+0x1ed/0x4a0
>        [<ffffffff802981db>] __alloc_pages+0xb/0x10
>        [<ffffffff802a312a>] handle_mm_fault+0x46a/0x6d0
>        [<ffffffff8060510a>] do_page_fault+0x3ca/0x830
>        [<ffffffff80602add>] error_exit+0x0/0xa9
>        [<ffffffffffffffff>] 0xffffffffffffffff

mmap_sem -> iprune_mutex -> xfs_ilock

> -> #0 (iprune_mutex){--..}:
>        [<ffffffff80276817>] __lock_acquire+0xa47/0x1020
>        [<ffffffff80276e55>] lock_acquire+0x65/0x90
>        [<ffffffff8060059a>] mutex_lock_nested+0xba/0x2b0
>        [<ffffffff802d2a5d>] shrink_icache_memory+0x7d/0x280
>        [<ffffffff8029d9c5>] shrink_slab+0x125/0x180
>        [<ffffffff8029dc52>] try_to_free_pages+0x232/0x360
>        [<ffffffff80297f0d>] __alloc_pages_internal+0x1ed/0x4a0
>        [<ffffffff802981db>] __alloc_pages+0xb/0x10
>        [<ffffffff8029a6b6>] __do_page_cache_readahead+0x136/0x230
>        [<ffffffff8029aa08>] ondemand_readahead+0x128/0x1f0
>        [<ffffffff8029ab45>] page_cache_async_readahead+0x75/0xa0
>        [<ffffffff80293a8a>] generic_file_aio_read+0x28a/0x610
>        [<ffffffff803d78c4>] xfs_read+0x124/0x270
>        [<ffffffff803d4416>] __xfs_file_read+0x46/0x50
>        [<ffffffff803d4451>] xfs_file_aio_read+0x11/0x20
>        [<ffffffff802bc1b1>] do_sync_read+0xf1/0x130
>        [<ffffffff802bca74>] vfs_read+0xc4/0x160
>        [<ffffffff802bcf10>] sys_read+0x50/0x90
>        [<ffffffff8022639b>] system_call_after_swapgs+0x7b/0x80
>        [<ffffffffffffffff>] 0xffffffffffffffff

xfs_ilock -> iprune_mutex

This is exactly the situation I mentioned in the previous email.
There is no potential deadlock here between the xfs_ilock and
iprune_mutex as the xfs_ilock that is held before and/or after
iprune_mutex is guaranteed to be different (the first is in use
so will never be found by shrink_icache_memory())...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
