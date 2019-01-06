Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-qk1-f174.google.com ([209.85.222.174]:46676 "EHLO
        mail-qk1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726215AbfAFF2n (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 6 Jan 2019 00:28:43 -0500
Received: by mail-qk1-f174.google.com with SMTP id q1so23706176qkf.13
        for <linux-xfs@vger.kernel.org>; Sat, 05 Jan 2019 21:28:42 -0800 (PST)
From: Qian Cai <cai@lca.pw>
Subject: possible circular locking dependency detected between fs_reclaim and
 sb_internal
Message-ID: <42952405-0062-6e20-e464-bf165ccbf32a@lca.pw>
Date: Sun, 6 Jan 2019 00:28:39 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: dchinner@redhat.com, darrick.wong@oracle.com, Peter Zijlstra <peterz@infradead.org>
Cc: bfoster@redhat.com, hch@lst.de, linux-xfs@vger.kernel.org

It looks like due to 8683edb7755 (xfs: avoid lockdep false positives in
xfs_trans_alloc), it triggers lockdep in some other ways.

[81388.050050] WARNING: possible circular locking dependency detected
[81388.056272] 4.20.0+ #47 Tainted: G        W    L
[81388.061182] ------------------------------------------------------
[81388.067402] fsfreeze/64059 is trying to acquire lock:
[81388.072487] 000000004f938084 (fs_reclaim){+.+.}, at:
fs_reclaim_acquire.part.19+0x5/0x30
[81388.080649]
[81388.080649] but task is already holding lock:
[81388.086517] 00000000339e9c6f (sb_internal){++++}, at:
percpu_down_write+0xbb/0x410
[81388.094140]
[81388.094140] which lock already depends on the new lock.
[81388.094140]
[81388.102367]
[81388.102367] the existing dependency chain (in reverse order) is:
[81388.109897]
[81388.109897] -> #1 (sb_internal){++++}:
[81388.115163]        __lock_acquire+0x460/0x850
[81388.119549]        lock_acquire+0x1e0/0x3f0
[81388.123764]        __sb_start_write+0x150/0x1e0
[81388.128437]        xfs_trans_alloc+0x49b/0x5e0 [xfs]
[81388.133540]        xfs_setfilesize_trans_alloc+0xa6/0x1a0 [xfs]
[81388.139602]        xfs_submit_ioend+0x239/0x3e0 [xfs]
[81388.144790]        xfs_vm_writepage+0xbc/0x100 [xfs]
[81388.149793]        pageout.isra.2+0x919/0x13c0
[81388.154264]        shrink_page_list+0x3807/0x58a0
[81388.158997]        shrink_inactive_list+0x4b3/0xfc0
[81388.163909]        shrink_node_memcg+0x5e5/0x1660
[81388.168642]        shrink_node+0x2a3/0xaa0
[81388.172766]        balance_pgdat+0x7cc/0xea0
[81388.177067]        kswapd+0x65e/0xc40
[81388.180757]        kthread+0x1d2/0x1f0
[81388.184535]        ret_from_fork+0x27/0x50
[81388.188655]
[81388.188655] -> #0 (fs_reclaim){+.+.}:
[81388.193832]        validate_chain.isra.14+0xd43/0x1910
[81388.199004]        __lock_acquire+0x460/0x850
[81388.203391]        lock_acquire+0x1e0/0x3f0
[81388.207602]        fs_reclaim_acquire.part.19+0x29/0x30
[81388.212862]        fs_reclaim_acquire+0x19/0x20
[81388.217424]        kmem_cache_alloc+0x2f/0x330
[81388.222004]        kmem_zone_alloc+0x6e/0x110 [xfs]
[81388.227023]        xfs_trans_alloc+0xfd/0x5e0 [xfs]
[81388.232034]        xfs_sync_sb+0x76/0x100 [xfs]
[81388.236701]        xfs_log_sbcount+0x8e/0xa0 [xfs]
[81388.241631]        xfs_quiesce_attr+0x112/0x1d0 [xfs]
[81388.246821]        xfs_fs_freeze+0x38/0x50 [xfs]
[81388.251469]        freeze_super+0x122/0x190
[81388.255682]        do_vfs_ioctl+0xa04/0xbe0
[81388.259894]        ksys_ioctl+0x41/0x80
[81388.263758]        __x64_sys_ioctl+0x43/0x4c
[81388.268060]        do_syscall_64+0x164/0x7ea
[81388.272357]        entry_SYSCALL_64_after_hwframe+0x49/0xbe
[81388.277966]
[81388.277966] other info that might help us debug this:
[81388.277966]
[81388.286019]  Possible unsafe locking scenario:
[81388.286019]
[81388.291976]        CPU0                    CPU1
[81388.296537]        ----                    ----
[81388.301096]   lock(sb_internal);
[81388.304346]                                lock(fs_reclaim);
[81388.310041]                                lock(sb_internal);
[81388.315822]   lock(fs_reclaim);
[81388.318986]
[81388.318986]  *** DEADLOCK ***
[81388.318986]
[81388.324942] 4 locks held by fsfreeze/64059:
[81388.329152]  #0: 00000000045ba59e (sb_writers#8){++++}, at:
percpu_down_write+0xbb/0x410
[81388.337300]  #1: 000000008f513ec0 (&type->s_umount_key#27){++++}, at:
freeze_super+0xa9/0x190
[81388.345882]  #2: 000000004ff629d8 (sb_pagefaults){++++}, at:
percpu_down_write+0xbb/0x410
[81388.354115]  #3: 00000000339e9c6f (sb_internal){++++}, at:
percpu_down_write+0xbb/0x410

Also this when running in a low-memory situation.

[  908.284491] WARNING: possible circular locking dependency detected
[  908.284495] 4.20.0+ #21 Not tainted
[  908.290717] hardirqs last disabled at (654034): [<ffffffffb3ac4929>]
bad_range+0x169/0x2e0
[  908.299018] ------------------------------------------------------
[  908.299022] kswapd0/436 is trying to acquire lock:
[  908.305246] softirqs last  enabled at (651950): [<ffffffffb4400582>]
__do_softirq+0x582/0x96e
[  908.308743] 000000003f4658a4 (sb_internal){++++}, at:
xfs_trans_alloc+0x45b/0x590 [xfs]
[  908.317065] softirqs last disabled at (651941): [<ffffffffb38a5e2f>]
irq_exit+0x7f/0xb0
[  908.323269]
[  908.323269] but task is already holding lock:
[  908.323271] 0000000013ffebb0 (fs_reclaim){+.+.}, at:
__fs_reclaim_acquire+0x5/0x30
[  908.366227]
[  908.366227] which lock already depends on the new lock.
[  908.366227]
[  908.374452]
[  908.374452] the existing dependency chain (in reverse order) is:
[  908.381978]
[  908.381978] -> #1 (fs_reclaim){+.+.}:
[  908.387154]        lock_acquire+0x1b3/0x3c0
[  908.391361]        fs_reclaim_acquire.part.18+0x29/0x30
[  908.396623]        kmem_cache_alloc+0x29/0x320
[  908.401189]        kmem_zone_alloc+0x63/0x100 [xfs]
[  908.406213]        xfs_trans_alloc+0xdf/0x590 [xfs]
[  908.411249]        xfs_sync_sb+0x73/0xf0 [xfs]
[  908.415813]        xfs_quiesce_attr+0xfa/0x1c0 [xfs]
[  908.420901]        xfs_fs_freeze+0x34/0x50 [xfs]
[  908.425548]        freeze_super+0x11c/0x190
[  908.429760]        do_vfs_ioctl+0x91c/0xaf0
[  908.433969]        ksys_ioctl+0x3a/0x70
[  908.437828]        __x64_sys_ioctl+0x3d/0x44
[  908.442128]        do_syscall_64+0x141/0x705
[  908.446425]        entry_SYSCALL_64_after_hwframe+0x49/0xbe
[  908.452029]
[  908.452029] -> #0 (sb_internal){++++}:
[  908.457288]        __lock_acquire+0x46d/0x860
[  908.461669]        lock_acquire+0x1b3/0x3c0
[  908.465876]        __sb_start_write+0x145/0x1d0
[  908.470533]        xfs_trans_alloc+0x45b/0x590 [xfs]
[  908.475614]        xfs_setfilesize_trans_alloc+0xa1/0x190 [xfs]
[  908.481658]        xfs_submit_ioend+0x236/0x3d0 [xfs]
[  908.486917]        xfs_vm_writepage+0xae/0xf0 [xfs]
[  908.491824]        pageout.isra.2+0x86e/0x1230
[  908.496293]        shrink_page_list+0x337b/0x5460
[  908.501024]        shrink_inactive_list+0x45d/0xe80
[  908.505930]        shrink_node_memcg+0x5df/0x15d0
[  908.510659]        shrink_node+0x260/0x950
[  908.514778]        balance_pgdat+0x440/0x7c0
[  908.519071]        kswapd+0x5c0/0xb20
[  908.522757]        kthread+0x1c7/0x1f0
[  908.526527]        ret_from_fork+0x3a/0x50
[  908.530646]
[  908.530646] other info that might help us debug this:
[  908.530646]
[  908.538698]  Possible unsafe locking scenario:
[  908.538698]
[  908.544651]        CPU0                    CPU1
[  908.549205]        ----                    ----
[  908.553760]   lock(fs_reclaim);
[  908.556917]                                lock(sb_internal);
[  908.562695]                                lock(fs_reclaim);
[  908.568386]   lock(sb_internal);
[  908.571633]
[  908.571633]  *** DEADLOCK ***
[  908.571633]
[  908.577591] 1 lock held by kswapd0/436:
[  908.581450]  #0: 0000000013ffebb0 (fs_reclaim){+.+.}, at:
__fs_reclaim_acquire+0x5/0x30
