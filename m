Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:50492 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726106AbeI1Mkt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 28 Sep 2018 08:40:49 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 446772AC41
        for <linux-xfs@vger.kernel.org>; Fri, 28 Sep 2018 06:18:41 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 201261] New: [xfstests shared/010]: WARNING: possible circular
 locking dependency detected
Date: Fri, 28 Sep 2018 06:18:40 +0000
Message-ID: <bug-201261-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=201261

            Bug ID: 201261
           Summary: [xfstests shared/010]: WARNING: possible circular
                    locking dependency detected
           Product: File System
           Version: 2.5
    Kernel Version: v4.19-rc5
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: low
          Priority: P1
         Component: XFS
          Assignee: filesystem_xfs@kernel-bugs.kernel.org
          Reporter: zlang@redhat.com
        Regression: No

shared/010 detected a 'possible' circular locking dependency, although it maybe
not a real deadlock, but still hope to get reviewing for sure.

[77175.048175] run fstests shared/010 at 2018-09-28 00:09:33
[77175.871044] XFS (dm-3): Unmounting Filesystem
[77176.888694] XFS (dm-3): Mounting V5 Filesystem
[77176.996978] XFS (dm-3): Ending clean mount
[77177.157523] XFS (dm-3): Unmounting Filesystem
[77178.132455] XFS (dm-3): Mounting V5 Filesystem
[77178.217982] XFS (dm-3): Ending clean mount

[77510.592827] ======================================================
[77510.599723] WARNING: possible circular locking dependency detected
[77510.606621] 4.19.0-rc5+ #4 Not tainted
[77510.610802] ------------------------------------------------------
[77510.617699] kswapd1/182 is trying to acquire lock:
[77510.623046] 00000000c73c570f (sb_internal#2){.+.+}, at:
xfs_trans_alloc+0x476/0x620 [xfs]
[77510.632253] 
               but task is already holding lock:
[77510.638760] 00000000f626d6e6 (fs_reclaim){+.+.}, at:
__fs_reclaim_acquire+0x5/0x30
[77510.647219] 
               which lock already depends on the new lock.

[77510.656346] 
               the existing dependency chain (in reverse order) is:
[77510.664698] 
               -> #1 (fs_reclaim){+.+.}:
[77510.670440]        fs_reclaim_acquire.part.89+0x29/0x30
[77510.676274]        kmem_cache_alloc+0x3d/0x330
[77510.681287]        kmem_zone_alloc+0x6c/0x120 [xfs]
[77510.686774]        xfs_trans_alloc+0xeb/0x620 [xfs]
[77510.692260]        xfs_attr_set+0x59d/0x940 [xfs]
[77510.697562]        xfs_xattr_set+0x75/0xe0 [xfs]
[77510.702716]        __vfs_setxattr+0xd0/0x130
[77510.707480]        __vfs_setxattr_noperm+0xe7/0x390
[77510.712922]        vfs_setxattr+0xa3/0xd0
[77510.717403]        setxattr+0x182/0x240
[77510.721682]        path_setxattr+0x11b/0x130
[77510.726446]        __x64_sys_lsetxattr+0xbd/0x150
[77510.731699]        do_syscall_64+0xa5/0x470
[77510.736369]        entry_SYSCALL_64_after_hwframe+0x49/0xbe
[77510.742585] 
               -> #0 (sb_internal#2){.+.+}:
[77510.748607]        lock_acquire+0x14f/0x3a0
[77510.753277]        __sb_start_write+0x176/0x260
[77510.758386]        xfs_trans_alloc+0x476/0x620 [xfs]
[77510.763975]        xfs_free_eofblocks+0x2eb/0x500 [xfs]
[77510.769859]        xfs_fs_destroy_inode+0x31b/0x8f0 [xfs]
[77510.775885]        dispose_list+0xfa/0x1d0
[77510.780455]        prune_icache_sb+0xd9/0x150
[77510.785317]        super_cache_scan+0x279/0x430
[77510.790374]        do_shrink_slab+0x304/0x8d0
[77510.795234]        shrink_slab+0x35f/0x420
[77510.799806]        shrink_node+0x2db/0x1080
[77510.804474]        kswapd+0x8df/0x12e0
[77510.808658]        kthread+0x31a/0x3e0
[77510.812840]        ret_from_fork+0x3a/0x50
[77510.817409]
              other info that might help us debug this:

[77510.826344]  Possible unsafe locking scenario:

[77510.832951]        CPU0                    CPU1
[77510.838012]        ----                    ----
[77510.843066]   lock(fs_reclaim);
[77510.846570]                                lock(sb_internal#2);
[77510.853176]                                lock(fs_reclaim);
[77510.859492]   lock(sb_internal#2);
[77510.863286] 
                *** DEADLOCK ***

[77510.869894] 3 locks held by kswapd1/182:
[77510.874268]  #0: 00000000f626d6e6 (fs_reclaim){+.+.}, at:
__fs_reclaim_acquire+0x5/0x30
[77510.883206]  #1: 000000002d35879e (shrinker_rwsem){++++}, at:
shrink_slab+0x135/0x420
[77510.891950]  #2: 0000000064c43e71 (&type->s_umount_key#58){++++}, at:
trylock_super+0x16/0xc0
[77510.901471] 
               stack backtrace:
[77510.906334] CPU: 11 PID: 182 Comm: kswapd1 Not tainted 4.19.0-rc5+ #4
[77510.913523] Hardware name: IBM System x3650 M4 -[7915ON3]-/00J6520, BIOS
-[VVE124AUS-1.30]- 11/21/2012
[77510.923910] Call Trace:
[77510.926642]  dump_stack+0x9a/0xe9
[77510.930341]  print_circular_bug.isra.33.cold.53+0x1bc/0x279
[77510.936561]  ? save_trace+0xd6/0x250
[77510.940550]  check_prev_add.constprop.40+0xc0f/0x14c0
[77510.946189]  ? tsc_cs_mark_unstable+0x60/0x60
[77510.951051]  ? check_usage+0x540/0x540
[77510.955234]  ? native_sched_clock+0x7c/0x120
[77510.959997]  ? tsc_cs_mark_unstable+0x60/0x60
[77510.964861]  ? sched_clock+0x5/0x10
[77510.968754]  ? sched_clock_cpu+0x18/0x170
[77510.973230]  __lock_acquire+0x1f96/0x36e0
[77510.977706]  ? mark_held_locks+0x140/0x140
[77510.982276]  ? sched_clock_cpu+0x18/0x170
[77510.986750]  ? find_held_lock+0x3a/0x1c0
[77510.991126]  lock_acquire+0x14f/0x3a0
[77510.995266]  ? xfs_trans_alloc+0x476/0x620 [xfs]
[77511.000421]  __sb_start_write+0x176/0x260
[77511.004939]  ? xfs_trans_alloc+0x476/0x620 [xfs]
[77511.010145]  xfs_trans_alloc+0x476/0x620 [xfs]
[77511.015154]  xfs_free_eofblocks+0x2eb/0x500 [xfs]
[77511.020404]  ? find_held_lock+0x3a/0x1c0
[77511.024830]  ? xfs_can_free_eofblocks+0x240/0x240 [xfs]
[77511.030662]  ? lock_downgrade+0x5e0/0x5e0
[77511.035139]  ? do_raw_spin_unlock+0x54/0x1e0
[77511.039958]  xfs_fs_destroy_inode+0x31b/0x8f0 [xfs]
[77511.045404]  dispose_list+0xfa/0x1d0
[77511.049396]  ? list_lru_walk_one+0x97/0xd0
[77511.053966]  prune_icache_sb+0xd9/0x150
[77511.058248]  ? invalidate_inodes+0x380/0x380
[77511.063005]  ? list_lru_count_one+0x160/0x310
[77511.067867]  super_cache_scan+0x279/0x430
[77511.072343]  do_shrink_slab+0x304/0x8d0
[77511.076615]  shrink_slab+0x35f/0x420
[77511.080604]  ? do_shrink_slab+0x8d0/0x8d0
[77511.085079]  ? mem_cgroup_iter+0x198/0xa20
[77511.089649]  ? mem_cgroup_protected+0x46/0x3f0
[77511.094607]  ? vmpressure+0x2a/0x2a0
[77511.098598]  shrink_node+0x2db/0x1080
[77511.102686]  ? shrink_node_memcg+0x10e0/0x10e0
[77511.107635]  ? mem_cgroup_nr_lru_pages+0x90/0x90
[77511.112787]  ? inactive_list_is_low+0x253/0x550
[77511.117844]  ? pgdat_balanced+0x8c/0xe0
[77511.122123]  kswapd+0x8df/0x12e0
[77511.125728]  ? mem_cgroup_shrink_node+0x620/0x620
[77511.130980]  ? sched_clock_cpu+0x140/0x170
[77511.135550]  ? find_held_lock+0x3a/0x1c0
[77511.139929]  ? finish_wait+0x280/0x280
[77511.144112]  ? lock_downgrade+0x5e0/0x5e0
[77511.148588]  ? __kthread_parkme+0xb6/0x180
[77511.153159]  ? mem_cgroup_shrink_node+0x620/0x620
[77511.158408]  kthread+0x31a/0x3e0
[77511.162008]  ? kthread_create_worker_on_cpu+0xc0/0xc0
[77511.167645]  ret_from_fork+0x3a/0x50
[77530.225565] XFS (dm-3): Unmounting Filesystem
[77532.976435] XFS (dm-3): Mounting V5 Filesystem
[77533.061634] XFS (dm-3): Ending clean mount
[77670.112391] XFS (dm-2): Unmounting Filesystem
[77675.350231] XFS (dm-3): Unmounting Filesystem
[77680.714375] XFS (dm-3): Mounting V5 Filesystem
[77680.805766] XFS (dm-3): Ending clean mount

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
