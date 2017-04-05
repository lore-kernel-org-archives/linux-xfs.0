Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46372 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752653AbdDEUwN (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 5 Apr 2017 16:52:13 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 90F99C04BD28
        for <linux-xfs@vger.kernel.org>; Wed,  5 Apr 2017 20:52:12 +0000 (UTC)
Received: from horse.redhat.com (unknown [10.18.25.132])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5F4A582EE4
        for <linux-xfs@vger.kernel.org>; Wed,  5 Apr 2017 20:52:12 +0000 (UTC)
Date: Wed, 5 Apr 2017 16:52:11 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Subject: lockdep warning on 4.11.0-rc5 kernel
Message-ID: <20170405205211.GB4475@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Hi,

I am running 4.11.0-rc5 kernel and did a kernel build and noticed
following lockdep warning on console. Have not analyzed it. Lots of
xfs in backtrace, so sending it to xfs mailing list.

Thanks
Vivek

login: [ 4931.174758] 
[ 4931.175065] =================================
[ 4931.175731] [ INFO: inconsistent lock state ]
[ 4931.176365] 4.11.0-rc5+ #87 Not tainted
[ 4931.176920] ---------------------------------
[ 4931.177537] inconsistent {RECLAIM_FS-ON-W} -> {IN-RECLAIM_FS-W} usage.
[ 4931.178463] kswapd0/128 [HC0[0]:SC0[0]:HE1:SE1] takes:
[ 4931.179198]  (&sb->s_type->i_mutex_key#12){++++?+}, at: [<ffffffffa01fcb0a>] xfs_ilock+0x13a/0x210 [xfs]
[ 4931.180584] {RECLAIM_FS-ON-W} state was registered at:
[ 4931.181320]   mark_held_locks+0x6f/0xa0
[ 4931.181878]   lockdep_trace_alloc+0x7d/0xe0
[ 4931.182474]   kmem_cache_alloc+0x2f/0x2a0
[ 4931.183083]   kmem_zone_alloc+0x81/0x120 [xfs]
[ 4931.183739]   xfs_trans_alloc+0x6c/0x130 [xfs]
[ 4931.184407]   xfs_setattr_nonsize+0x239/0x560 [xfs]
[ 4931.185135]   xfs_vn_setattr_nonsize+0x59/0x150 [xfs]
[ 4931.185890]   xfs_vn_setattr+0x22/0x70 [xfs]
[ 4931.186503]   notify_change+0x2ee/0x440
[ 4931.187058]   chmod_common+0xc5/0x150
[ 4931.187582]   SyS_fchmod+0x53/0x90
[ 4931.188077]   do_syscall_64+0x6c/0x1f0
[ 4931.188616]   return_from_SYSCALL_64+0x0/0x7a
[ 4931.189238] irq event stamp: 397343
[ 4931.189739] hardirqs last  enabled at (397343): [<ffffffff81135cca>] __call_rcu+0x1fa/0x340
[ 4931.190909] hardirqs last disabled at (397342): [<ffffffff81135b21>] __call_rcu+0x51/0x340
[ 4931.192070] softirqs last  enabled at (397192): [<ffffffff818fb86d>] __do_softirq+0x38d/0x4c3
[ 4931.193263] softirqs last disabled at (397185): [<ffffffff810bae27>] irq_exit+0xf7/0x100
[ 4931.194397] 
[ 4931.194397] other info that might help us debug this:
[ 4931.195318]  Possible unsafe locking scenario:
[ 4931.195318] 
[ 4931.196155]        CPU0
[ 4931.196511]        ----
[ 4931.196874]   lock(&sb->s_type->i_mutex_key#12);
[ 4931.197526]   <Interrupt>
[ 4931.197912]     lock(&sb->s_type->i_mutex_key#12);
[ 4931.198591] 
[ 4931.198591]  *** DEADLOCK ***
[ 4931.198591] 
[ 4931.199429] 2 locks held by kswapd0/128:
[ 4931.199990]  #0:  (shrinker_rwsem){++++..}, at: [<ffffffff8121a16e>] shrink_slab.part.46+0x5e/0x600
[ 4931.201261]  #1:  (&type->s_umount_key#48){++++++}, at: [<ffffffff812aa54b>] trylock_super+0x1b/0x50
[ 4931.202832] 
[ 4931.202832] stack backtrace:
[ 4931.203878] CPU: 2 PID: 128 Comm: kswapd0 Not tainted 4.11.0-rc5+ #87
[ 4931.204998] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.8.2-20150714_191134- 04/01/2014
[ 4931.206533] Call Trace:
[ 4931.207114]  dump_stack+0x86/0xc3
[ 4931.207807]  print_usage_bug+0x1d0/0x1e0
[ 4931.208573]  mark_lock+0x559/0x5c0
[ 4931.209274]  ? print_shortest_lock_dependencies+0x1a0/0x1a0
[ 4931.210274]  __lock_acquire+0x6ce/0x13c0
[ 4931.211049]  lock_acquire+0xe3/0x1d0
[ 4931.211776]  ? lock_acquire+0xe3/0x1d0
[ 4931.212556]  ? xfs_ilock+0x13a/0x210 [xfs]
[ 4931.213373]  ? xfs_inactive+0xec/0x130 [xfs]
[ 4931.214231]  down_write_nested+0x46/0x80
[ 4931.215038]  ? xfs_ilock+0x13a/0x210 [xfs]
[ 4931.215851]  xfs_ilock+0x13a/0x210 [xfs]
[ 4931.216634]  xfs_inactive+0xec/0x130 [xfs]
[ 4931.217699]  xfs_fs_destroy_inode+0xbb/0x2d0 [xfs]
[ 4931.218594]  destroy_inode+0x3b/0x60
[ 4931.219314]  evict+0x139/0x1c0
[ 4931.220061]  dispose_list+0x56/0x80
[ 4931.220765]  prune_icache_sb+0x5a/0x80
[ 4931.221498]  super_cache_scan+0x14e/0x1a0
[ 4931.222269]  shrink_slab.part.46+0x216/0x600
[ 4931.223075]  shrink_slab+0x29/0x30
[ 4931.223883]  shrink_node+0x108/0x320
[ 4931.224588]  kswapd+0x391/0x990
[ 4931.225246]  kthread+0x10c/0x140
[ 4931.225902]  ? mem_cgroup_shrink_node+0x300/0x300
[ 4931.226760]  ? kthread_create_on_node+0x70/0x70
[ 4931.227579]  ret_from_fork+0x31/0x40

