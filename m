Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx3-phx2.redhat.com ([209.132.183.24]:48045 "EHLO
        mx3-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S942253AbcJFQLe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 6 Oct 2016 12:11:34 -0400
Date: Thu, 6 Oct 2016 12:11:26 -0400 (EDT)
From: CAI Qian <caiqian@redhat.com>
Message-ID: <1149670394.870034.1475770286233.JavaMail.zimbra@redhat.com>
In-Reply-To: <1860793605.807021.1475756759147.JavaMail.zimbra@redhat.com>
References: <CA+55aFxrqCng2Qxasc9pyMrKUGFjo==fEaFT1vkH9Lncte3RgQ@mail.gmail.com> <1238277728.610186.1475676579513.JavaMail.zimbra@redhat.com> <20161005153014.GC26977@htj.duckdns.org> <270577901.647921.1475682888765.JavaMail.zimbra@redhat.com> <874538236.682217.1475693824077.JavaMail.zimbra@redhat.com> <20161005200522.GE19539@ZenIV.linux.org.uk> <119370333.805584.1475756417736.JavaMail.zimbra@redhat.com> <1860793605.807021.1475756759147.JavaMail.zimbra@redhat.com>
Subject: Re: local DoS - systemd hang or timeout (WAS: Re: [RFC][CFT]
 splice_read reworked)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: tj <tj@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, Dave Chinner <david@fromorbit.com>, linux-xfs <linux-xfs@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>, Nick Piggin <npiggin@gmail.com>, linux-fsdevel@vger.kernel.org


> > > On Wed, Oct 05, 2016 at 02:57:04PM -0400, CAI Qian wrote:
> > > 
> > > > Not sure if this related, and there is always a lockdep regards procfs
> > > > happened
> > > > below unless masking by other lockdep issues before the cgroup hang.
> > > > Also,
> > > > this
> > > > hang is always reproducible.
> > > 
> > > Sigh...  Let's get the /proc/*/auxv out of the way - this should deal
> > > with
> > > it:
> > So I applied both this and the sanity patch, and both original sanity and
> > the
> > proc warnings went away. However, the cgroup hang can still be reproduced
> > as
> > well as this new xfs internal error below,
> 
> Wait. There is also a lockep happened before the xfs internal error as well.
Some other lockdep this time,

[ 4872.310639] =================================
[ 4872.315499] [ INFO: inconsistent lock state ]
[ 4872.320359] 4.8.0-rc8-splice-fixw-proc+ #4 Not tainted
[ 4872.326091] ---------------------------------
[ 4872.330950] inconsistent {RECLAIM_FS-ON-W} -> {IN-RECLAIM_FS-W} usage.
[ 4872.338235] kswapd1/437 [HC0[0]:SC0[0]:HE1:SE1] takes:
[ 4872.343965]  (&xfs_nondir_ilock_class){++++?.}, at: [<ffffffffa029968e>] xfs_ilock+0x18e/0x260 [xfs]
[ 4872.354236] {RECLAIM_FS-ON-W} state was registered at:
[ 4872.359969]   [<ffffffff810fcbd6>] mark_held_locks+0x66/0x90
[ 4872.366297]   [<ffffffff810fffd5>] lockdep_trace_alloc+0xc5/0x110
[ 4872.373107]   [<ffffffff81253ad3>] kmem_cache_alloc+0x33/0x2e0
[ 4872.379628]   [<ffffffffa02a8386>] kmem_zone_alloc+0x96/0x120 [xfs]
[ 4872.386654]   [<ffffffffa024967b>] xfs_bmbt_init_cursor+0x3b/0x160 [xfs]
[ 4872.394147]   [<ffffffffa0247f8f>] xfs_bunmapi+0x80f/0xb00 [xfs]
[ 4872.400202] kmemleak: Cannot allocate a kmemleak_object structure
[ 4872.400205] kmemleak: Kernel memory leak detector disabled
[ 4872.400337] kmemleak: Automatic memory scanning thread ended
[ 4872.400869] kmemleak: Kmemleak disabled without freeing internal data. Reclaim the memory with "echo clear > /sys/kernel/debug/kmemleak".
[ 4872.433878]   [<ffffffffa027ddc3>] xfs_bmap_punch_delalloc_range+0xe3/0x180 [xfs]
[ 4872.442253]   [<ffffffffa0294b39>] xfs_file_iomap_end+0x89/0xd0 [xfs]
[ 4872.449468]   [<ffffffff812f3da0>] iomap_apply+0xe0/0x130
[ 4872.455505]   [<ffffffff812f3e58>] iomap_file_buffered_write+0x68/0xa0
[ 4872.462798]   [<ffffffffa028a87f>] xfs_file_buffered_aio_write+0x14f/0x350 [xfs]
[ 4872.471079]   [<ffffffffa028ab6d>] xfs_file_write_iter+0xed/0x130 [xfs]
[ 4872.478485]   [<ffffffff81280eee>] do_iter_readv_writev+0xae/0x130
[ 4872.485393]   [<ffffffff81281992>] do_readv_writev+0x1a2/0x230
[ 4872.491911]   [<ffffffff81281c6c>] vfs_writev+0x3c/0x50
[ 4872.497752]   [<ffffffff81281ce4>] do_writev+0x64/0x100
[ 4872.503589]   [<ffffffff81282ea0>] SyS_writev+0x10/0x20
[ 4872.509428]   [<ffffffff81003c9c>] do_syscall_64+0x6c/0x1e0
[ 4872.515656]   [<ffffffff817d4a3f>] return_from_SYSCALL_64+0x0/0x7a
[ 4872.522563] irq event stamp: 427
[ 4872.526160] hardirqs last  enabled at (427): [<ffffffff817cf21d>] mutex_trylock+0xdd/0x200
[ 4872.535393] hardirqs last disabled at (426): [<ffffffff817cf191>] mutex_trylock+0x51/0x200
[ 4872.544627] softirqs last  enabled at (424): [<ffffffff817d7b37>] __do_softirq+0x1f7/0x4b7
[ 4872.553862] softirqs last disabled at (417): [<ffffffff810a4a98>] irq_exit+0xc8/0xe0
[ 4872.562513] 
[ 4872.562513] other info that might help us debug this:
[ 4872.569797]  Possible unsafe locking scenario:
[ 4872.569797] 
[ 4872.576401]        CPU0
[ 4872.579127]        ----
[ 4872.581854]   lock(&xfs_nondir_ilock_class);
[ 4872.586637]   <Interrupt>
[ 4872.589558]     lock(&xfs_nondir_ilock_class);
[ 4872.594533] 
[ 4872.594533]  *** DEADLOCK ***
[ 4872.594533] 
[ 4872.601140] 3 locks held by kswapd1/437:
[ 4872.605515]  #0:  (shrinker_rwsem){++++..}, at: [<ffffffff811f78ad>] shrink_slab+0x9d/0x620
[ 4872.614889]  #1:  (&type->s_umount_key#48){++++++}, at: [<ffffffff8128550b>] trylock_super+0x1b/0x50
[ 4872.625145]  #2:  (&pag->pag_ici_reclaim_lock){+.+...}, at: [<ffffffffa028e7a7>] xfs_reclaim_inodes_ag+0xc7/0x4f0 [xfs]
[ 4872.637247] 
[ 4872.637247] stack backtrace:
[ 4872.642109] CPU: 49 PID: 437 Comm: kswapd1 Not tainted 4.8.0-rc8-splice-fixw-proc+ #4
[ 4872.650846] Hardware name: Intel Corporation S2600WTT/S2600WTT, BIOS GRNDSDP1.86B.0044.R00.1501191641 01/19/2015
[ 4872.662202]  0000000000000086 00000000eda15d18 ffff880462bd7798 ffffffff813d2ecc
[ 4872.670498]  ffff880462e56000 ffffffff82a66870 ffff880462bd77e8 ffffffff811dd9e1
[ 4872.678793]  0000000000000000 ffff880400000001 ffff880400000001 000000000000000a
[ 4872.687086] Call Trace:
[ 4872.689817]  [<ffffffff813d2ecc>] dump_stack+0x85/0xc9
[ 4872.695543]  [<ffffffff811dd9e1>] print_usage_bug+0x1eb/0x1fc
[ 4872.701954]  [<ffffffff810fc0b0>] ? check_usage_backwards+0x150/0x150
[ 4872.709141]  [<ffffffff810fcae4>] mark_lock+0x264/0x2f0
[ 4872.714968]  [<ffffffff810fd491>] __lock_acquire+0x311/0x1990
[ 4872.721379]  [<ffffffff810499db>] ? save_stack_trace+0x2b/0x50
[ 4872.727892]  [<ffffffff810fd5f2>] ? __lock_acquire+0x472/0x1990
[ 4872.734497]  [<ffffffff810ff174>] lock_acquire+0xd4/0x240
[ 4872.740535]  [<ffffffffa029968e>] ? xfs_ilock+0x18e/0x260 [xfs]
[ 4872.747155]  [<ffffffffa028dd93>] ? xfs_reclaim_inode+0x113/0x380 [xfs]
[ 4872.754538]  [<ffffffff810f8bfa>] down_write_nested+0x4a/0x80
[ 4872.760962]  [<ffffffffa029968e>] ? xfs_ilock+0x18e/0x260 [xfs]
[ 4872.767579]  [<ffffffffa029968e>] xfs_ilock+0x18e/0x260 [xfs]
[ 4872.774004]  [<ffffffffa028dd93>] xfs_reclaim_inode+0x113/0x380 [xfs]
[ 4872.781203]  [<ffffffffa028e9ab>] xfs_reclaim_inodes_ag+0x2cb/0x4f0 [xfs]
[ 4872.788780]  [<ffffffffa028e7d2>] ? xfs_reclaim_inodes_ag+0xf2/0x4f0 [xfs]
[ 4872.796453]  [<ffffffff817d40aa>] ? _raw_spin_unlock_irqrestore+0x6a/0x80
[ 4872.804026]  [<ffffffff817d408a>] ? _raw_spin_unlock_irqrestore+0x4a/0x80
[ 4872.811602]  [<ffffffff810d1a58>] ? try_to_wake_up+0x58/0x510
[ 4872.818014]  [<ffffffff810d1f25>] ? wake_up_process+0x15/0x20
[ 4872.824438]  [<ffffffffa0290523>] xfs_reclaim_inodes_nr+0x33/0x40 [xfs]
[ 4872.831835]  [<ffffffffa02a26d9>] xfs_fs_free_cached_objects+0x19/0x20 [xfs]
[ 4872.839702]  [<ffffffff812856c1>] super_cache_scan+0x181/0x190
[ 4872.846210]  [<ffffffff811f7a79>] shrink_slab+0x269/0x620
[ 4872.852233]  [<ffffffff811fcc88>] shrink_node+0x108/0x310
[ 4872.858256]  [<ffffffff811fe360>] kswapd+0x3d0/0x960
[ 4872.863796]  [<ffffffff811fdf90>] ? mem_cgroup_shrink_node+0x370/0x370
[ 4872.871081]  [<ffffffff810c3f5e>] kthread+0xfe/0x120
[ 4872.876618]  [<ffffffff817d40ec>] ? _raw_spin_unlock_irq+0x2c/0x60
[ 4872.883514]  [<ffffffff817d4baf>] ret_from_fork+0x1f/0x40
[ 4872.889539]  [<ffffffff810c3e60>] ? kthread_create_on_node+0x230/0x230
