Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40156 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751670AbdB1PPS (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 28 Feb 2017 10:15:18 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 38D77ABC6
        for <linux-xfs@vger.kernel.org>; Tue, 28 Feb 2017 15:15:11 +0000 (UTC)
Subject: Re: lockdep splat in today's master in generic/070
References: <0e8e52ac-36e4-c8f9-99c7-88e2c9bcb782@suse.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <2a240829-e325-adf8-e3a8-5057fdbeb06b@suse.com>
Date: Tue, 28 Feb 2017 17:15:10 +0200
MIME-Version: 1.0
In-Reply-To: <0e8e52ac-36e4-c8f9-99c7-88e2c9bcb782@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org



On 28.02.2017 16:56, Nikolay Borisov wrote:
> Hello, 
> 
> I've been running xfstest and I can reliably reproduce the following lockdep splat: 
> 
> [  644.173373] =================================
> [  644.174012] [ INFO: inconsistent lock state ]
> [  644.174012] 4.10.0-nbor #134 Not tainted
> [  644.174012] ---------------------------------
> [  644.174012] inconsistent {IN-RECLAIM_FS-W} -> {RECLAIM_FS-ON-W} usage.
> [  644.174012] fsstress/3365 [HC0[0]:SC0[0]:HE1:SE1] takes:
> [  644.174012]  (&xfs_nondir_ilock_class){++++?.}, at: [<ffffffff8136f231>] xfs_ilock+0x141/0x230
> [  644.174012] {IN-RECLAIM_FS-W} state was registered at:
> [  644.174012]   __lock_acquire+0x62a/0x17c0
> [  644.174012]   lock_acquire+0xc5/0x220
> [  644.174012]   down_write_nested+0x4f/0x90
> [  644.174012]   xfs_ilock+0x141/0x230
> [  644.174012]   xfs_reclaim_inode+0x12a/0x320
> [  644.174012]   xfs_reclaim_inodes_ag+0x2c8/0x4e0
> [  644.174012]   xfs_reclaim_inodes_nr+0x33/0x40
> [  644.174012]   xfs_fs_free_cached_objects+0x19/0x20
> [  644.174012]   super_cache_scan+0x191/0x1a0
> [  644.174012]   shrink_slab+0x26f/0x5f0
> [  644.174012]   shrink_node+0xf9/0x2f0
> [  644.174012]   kswapd+0x356/0x920
> [  644.174012]   kthread+0x10c/0x140
> [  644.174012]   ret_from_fork+0x31/0x40
> [  644.174012] irq event stamp: 173777
> [  644.174012] hardirqs last  enabled at (173777): [<ffffffff8105b440>] __local_bh_enable_ip+0x70/0xc0
> [  644.174012] hardirqs last disabled at (173775): [<ffffffff8105b407>] __local_bh_enable_ip+0x37/0xc0
> [  644.174012] softirqs last  enabled at (173776): [<ffffffff81357e2a>] _xfs_buf_find+0x67a/0xb70
> [  644.174012] softirqs last disabled at (173774): [<ffffffff81357d8b>] _xfs_buf_find+0x5db/0xb70
> [  644.174012] 
> [  644.174012] other info that might help us debug this:
> [  644.174012]  Possible unsafe locking scenario:
> [  644.174012] 
> [  644.174012]        CPU0
> [  644.174012]        ----
> [  644.174012]   lock(&xfs_nondir_ilock_class);
> [  644.174012]   <Interrupt>
> [  644.174012]     lock(&xfs_nondir_ilock_class);
> [  644.174012] 
> [  644.174012]  *** DEADLOCK ***
> [  644.174012] 
> [  644.174012] 4 locks held by fsstress/3365:
> [  644.174012]  #0:  (sb_writers#10){++++++}, at: [<ffffffff81208d04>] mnt_want_write+0x24/0x50
> [  644.174012]  #1:  (&sb->s_type->i_mutex_key#12){++++++}, at: [<ffffffff8120ea2f>] vfs_setxattr+0x6f/0xb0
> [  644.174012]  #2:  (sb_internal#2){++++++}, at: [<ffffffff8138185c>] xfs_trans_alloc+0xfc/0x140
> [  644.174012]  #3:  (&xfs_nondir_ilock_class){++++?.}, at: [<ffffffff8136f231>] xfs_ilock+0x141/0x230
> [  644.174012] 
> [  644.174012] stack backtrace:
> [  644.174012] CPU: 0 PID: 3365 Comm: fsstress Not tainted 4.10.0-nbor #134
> [  644.174012] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Ubuntu-1.8.2-1ubuntu1 04/01/2014
> [  644.174012] Call Trace:
> [  644.174012]  dump_stack+0x85/0xc9
> [  644.174012]  print_usage_bug.part.37+0x284/0x293
> [  644.174012]  ? print_shortest_lock_dependencies+0x1b0/0x1b0
> [  644.174012]  mark_lock+0x27e/0x660
> [  644.174012]  mark_held_locks+0x66/0x90
> [  644.174012]  lockdep_trace_alloc+0x6f/0xd0
> [  644.174012]  kmem_cache_alloc_node_trace+0x3a/0x2c0
> [  644.174012]  ? vm_map_ram+0x2a1/0x510
> [  644.174012]  vm_map_ram+0x2a1/0x510
> [  644.174012]  ? vm_map_ram+0x46/0x510
> [  644.174012]  _xfs_buf_map_pages+0x77/0x140
> [  644.174012]  xfs_buf_get_map+0x185/0x2a0
> [  644.174012]  xfs_attr_rmtval_set+0x233/0x430
> [  644.174012]  xfs_attr_leaf_addname+0x2d2/0x500
> [  644.174012]  xfs_attr_set+0x214/0x420
> [  644.174012]  xfs_xattr_set+0x59/0xb0
> [  644.174012]  __vfs_setxattr+0x76/0xa0
> [  644.174012]  __vfs_setxattr_noperm+0x5e/0xf0
> [  644.174012]  vfs_setxattr+0xae/0xb0
> [  644.174012]  ? __might_fault+0x43/0xa0
> [  644.174012]  setxattr+0x15e/0x1a0
> [  644.174012]  ? __lock_is_held+0x53/0x90
> [  644.174012]  ? rcu_read_lock_sched_held+0x93/0xa0
> [  644.174012]  ? rcu_sync_lockdep_assert+0x2f/0x60
> [  644.174012]  ? __sb_start_write+0x130/0x1d0
> [  644.174012]  ? mnt_want_write+0x24/0x50
> [  644.174012]  path_setxattr+0x8f/0xc0
> [  644.174012]  SyS_lsetxattr+0x11/0x20
> [  644.174012]  entry_SYSCALL_64_fastpath+0x23/0xc6

Got a similar splat during generic/048:

[  498.776968] =================================
[  498.777372] [ INFO: inconsistent lock state ]
[  498.777372] 4.10.0-nbor #134 Not tainted
[  498.777372] ---------------------------------
[  498.777372] inconsistent {RECLAIM_FS-ON-W} -> {IN-RECLAIM_FS-W} usage.
[  498.777372] kswapd0/45 [HC0[0]:SC0[0]:HE1:SE1] takes:
[  498.777372]  (&xfs_nondir_ilock_class){++++?.}, at: [<ffffffff8136f231>] xfs_ilock+0x141/0x230
[  498.777372] {RECLAIM_FS-ON-W} state was registered at:
[  498.777372]   mark_held_locks+0x66/0x90
[  498.777372]   lockdep_trace_alloc+0x6f/0xd0
[  498.777372]   kmem_cache_alloc_node_trace+0x3a/0x2c0
[  498.777372]   vm_map_ram+0x2a1/0x510
[  498.777372]   _xfs_buf_map_pages+0x77/0x140
[  498.777372]   xfs_buf_get_map+0x185/0x2a0
[  498.777372]   xfs_attr_rmtval_set+0x233/0x430
[  498.777372]   xfs_attr_node_addname+0x5ca/0x610
[  498.777372]   xfs_attr_set+0x3a7/0x420
[  498.777372]   xfs_xattr_set+0x59/0xb0
[  498.777372]   __vfs_setxattr+0x76/0xa0
[  498.777372]   __vfs_setxattr_noperm+0x5e/0xf0
[  498.777372]   vfs_setxattr+0xae/0xb0
[  498.777372]   setxattr+0x15e/0x1a0
[  498.777372]   path_setxattr+0x8f/0xc0
[  498.777372]   SyS_lsetxattr+0x11/0x20
[  498.777372]   entry_SYSCALL_64_fastpath+0x23/0xc6
[  498.777372] irq event stamp: 41
[  498.777372] hardirqs last  enabled at (41): [<ffffffff8174edff>] _raw_spin_unlock_irqrestore+0x3f/0x70
[  498.777372] hardirqs last disabled at (40): [<ffffffff8174e6be>] _raw_spin_lock_irqsave+0x2e/0x70
[  498.777372] softirqs last  enabled at (0): [<ffffffff81052121>] copy_process.part.57+0x511/0x1e10
[  498.777372] softirqs last disabled at (0): [<          (null)>]           (null)
[  498.789313] 
[  498.789313] other info that might help us debug this:
[  498.789313]  Possible unsafe locking scenario:
[  498.789313] 
[  498.789313]        CPU0
[  498.789313]        ----
[  498.789313]   lock(&xfs_nondir_ilock_class);
[  498.789313]   <Interrupt>
[  498.789313]     lock(&xfs_nondir_ilock_class);
[  498.789313] 
[  498.789313]  *** DEADLOCK ***
[  498.789313] 
[  498.789313] 3 locks held by kswapd0/45:
[  498.789313]  #0:  (shrinker_rwsem){++++..}, at: [<ffffffff81177def>] shrink_slab+0x8f/0x5f0
[  498.789313]  #1:  (&type->s_umount_key#31){++++++}, at: [<ffffffff811e6f74>] trylock_super+0x24/0x60
[  498.789313]  #2:  (&pag->pag_ici_reclaim_lock){+.+...}, at: [<ffffffff81364166>] xfs_reclaim_inodes_ag+0xb6/0x4e0
[  498.789313] 
[  498.789313] stack backtrace:
[  498.789313] CPU: 3 PID: 45 Comm: kswapd0 Not tainted 4.10.0-nbor #134
[  498.789313] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Ubuntu-1.8.2-1ubuntu1 04/01/2014
[  498.789313] Call Trace:
[  498.789313]  dump_stack+0x85/0xc9
[  498.789313]  print_usage_bug.part.37+0x284/0x293
[  498.803341]  ? check_usage_backwards+0x130/0x130
[  498.803341]  mark_lock+0x27e/0x660
[  498.803341]  __lock_acquire+0x62a/0x17c0
[  498.803341]  ? add_lock_to_list.isra.19.constprop.38+0x99/0x100
[  498.803341]  ? __lock_acquire+0x1246/0x17c0
[  498.803341]  ? __lock_acquire+0x300/0x17c0
[  498.803341]  lock_acquire+0xc5/0x220
[  498.803341]  ? xfs_ilock+0x141/0x230
[  498.803341]  ? xfs_reclaim_inode+0x12a/0x320
[  498.803341]  down_write_nested+0x4f/0x90
[  498.803341]  ? xfs_ilock+0x141/0x230
[  498.803341]  xfs_ilock+0x141/0x230
[  498.803341]  xfs_reclaim_inode+0x12a/0x320
[  498.803341]  xfs_reclaim_inodes_ag+0x2c8/0x4e0
[  498.803341]  ? xfs_reclaim_inodes_ag+0xe1/0x4e0
[  498.803341]  ? mark_held_locks+0x66/0x90
[  498.803341]  ? _raw_spin_unlock_irqrestore+0x3f/0x70
[  498.803341]  ? trace_hardirqs_on_caller+0x111/0x1e0
[  498.803341]  ? trace_hardirqs_on+0xd/0x10
[  498.803341]  ? try_to_wake_up+0xf5/0x5d0
[  498.803341]  ? wake_up_process+0x15/0x20
[  498.803341]  ? xfs_ail_push+0x4e/0x60
[  498.803341]  xfs_reclaim_inodes_nr+0x33/0x40
[  498.803341]  xfs_fs_free_cached_objects+0x19/0x20
[  498.803341]  super_cache_scan+0x191/0x1a0
[  498.803341]  shrink_slab+0x26f/0x5f0
[  498.803341]  shrink_node+0xf9/0x2f0
[  498.803341]  kswapd+0x356/0x920
[  498.803341]  kthread+0x10c/0x140
[  498.803341]  ? mem_cgroup_shrink_node+0x2f0/0x2f0
[  498.803341]  ? __kthread_init_worker+0x100/0x100
[  498.803341]  ret_from_fork+0x31/0x40

