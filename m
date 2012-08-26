Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7QGP2h3118128 for <xfs@oss.sgi.com>; Sun, 26 Aug 2012 11:25:02 -0500
Received: from cobra.newdream.net (cobra.newdream.net [66.33.216.30]) by
	cuda.sgi.com with ESMTP id DAI1PMQWPu4hQ0qp for
	<xfs@oss.sgi.com>; Sun, 26 Aug 2012 09:25:51 -0700 (PDT)
Received: from cobra.newdream.net (localhost [127.0.0.1])
	by cobra.newdream.net (Postfix) with ESMTP id 598BC80049
	for <xfs@oss.sgi.com>; Sun, 26 Aug 2012 09:25:50 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
	by cobra.newdream.net (Postfix) with ESMTP id 2642880049
	for <xfs@oss.sgi.com>; Sun, 26 Aug 2012 09:25:50 -0700 (PDT)
Date: Sun, 26 Aug 2012 09:25:50 -0700 (PDT)
From: Sage Weil <sage@inktank.com>
Subject: lockdep warning with sb_internal#2
Message-ID: <alpine.DEB.2.00.1208260924310.13468@cobra.newdream.net>
MIME-Version: 1.0
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
To: xfs@oss.sgi.com

In case nobody has seen this yet:

[10777.847108] ======================================================
[10777.873747] [ INFO: possible circular locking dependency detected ]
[10777.900948] 3.6.0-rc2-ceph-00143-g995fc06 #1 Not tainted
[10777.928082] -------------------------------------------------------
[10777.956154] fill2/17839 is trying to acquire lock:
[10777.982362]  ((&mp->m_flush_work)){+.+.+.}, at: [<ffffffff81072060>] wait_on_work+0x0/0x160
[10778.033864] 
[10778.033864] but task is already holding lock:
[10778.080206]  (sb_internal#2){.+.+.+}, at: [<ffffffffa03dde5d>] xfs_trans_alloc+0x2d/0x50 [xfs]
[10778.132743] 
[10778.132743] which lock already depends on the new lock.
[10778.132743] 
[10778.205654] 
[10778.205654] the existing dependency chain (in reverse order) is:
[10778.257150] 
[10778.257150] -> #1 (sb_internal#2){.+.+.+}:
[10778.306678]        [<ffffffff810b2c82>] lock_acquire+0xa2/0x140
[10778.336430]        [<ffffffff816350dd>] _raw_spin_lock_irq+0x3d/0x50
[10778.367408]        [<ffffffff81633740>] wait_for_common+0x30/0x160
[10778.398486]        [<ffffffff8163394d>] wait_for_completion+0x1d/0x20
[10778.429780]        [<ffffffffa038b86d>] xfs_buf_iowait+0x6d/0xf0 [xfs]
[10778.461388]        [<ffffffffa038ba20>] _xfs_buf_read+0x40/0x50 [xfs]
[10778.493170]        [<ffffffffa038bad3>] xfs_buf_read_map+0xa3/0x110 [xfs]
[10778.525708]        [<ffffffffa03e7f7d>] xfs_trans_read_buf_map+0x1fd/0x4a0 [xfs]
[10778.585740]        [<ffffffffa03a4a18>] xfs_read_agf+0x78/0x1c0 [xfs]
[10778.619869]        [<ffffffffa03a4b9a>] xfs_alloc_read_agf+0x3a/0xf0 [xfs]
[10778.654683]        [<ffffffffa03a511a>] xfs_alloc_pagf_init+0x1a/0x40 [xfs]
[10778.688992]        [<ffffffffa03af034>] xfs_bmap_btalloc_nullfb+0x224/0x370 [xfs]
[10778.749210]        [<ffffffffa03af5b6>] xfs_bmap_btalloc+0x436/0x830 [xfs]
[10778.783502]        [<ffffffffa03af9d4>] xfs_bmap_alloc+0x24/0x40 [xfs]
[10778.816807]        [<ffffffffa03b4e6e>] xfs_bmapi_allocate+0xce/0x2d0 [xfs]
[10778.850048]        [<ffffffffa03b7a8b>] xfs_bmapi_write+0x47b/0x7a0 [xfs]
[10778.882237]        [<ffffffffa03c1128>] xfs_da_grow_inode_int+0xc8/0x2e0 [xfs]
[10778.940695]        [<ffffffffa03c3d8c>] xfs_dir2_grow_inode+0x6c/0x140 [xfs]
[10778.974521]        [<ffffffffa03c603d>] xfs_dir2_sf_to_block+0xbd/0x530 [xfs]
[10779.007733]        [<ffffffffa03cc873>] xfs_dir2_sf_addname+0x3a3/0x520 [xfs]
[10779.041104]        [<ffffffffa03c472c>] xfs_dir_createname+0x14c/0x1a0 [xfs]
[10779.074438]        [<ffffffffa039dec3>] xfs_rename+0x4f3/0x6f0 [xfs]
[10779.107092]        [<ffffffffa0396776>] xfs_vn_rename+0x66/0x70 [xfs]
[10779.140318]        [<ffffffff8118a68d>] vfs_rename+0x31d/0x4f0
[10779.172667]        [<ffffffff8118d026>] sys_renameat+0x1f6/0x230
[10779.204781]        [<ffffffff8118d07b>] sys_rename+0x1b/0x20
[10779.236289]        [<ffffffff8163d569>] system_call_fastpath+0x16/0x1b
[10779.268294] 
[10779.268294] -> #0 ((&mp->m_flush_work)){+.+.+.}:
[10779.323093]        [<ffffffff810b25e8>] __lock_acquire+0x1ac8/0x1b90
[10779.356168]        [<ffffffff810b2c82>] lock_acquire+0xa2/0x140
[10779.388639]        [<ffffffff810720a1>] wait_on_work+0x41/0x160
[10779.420860]        [<ffffffff81072203>] flush_work_sync+0x43/0x90
[10779.453189]        [<ffffffffa039cc7f>] xfs_flush_inodes+0x2f/0x40 [xfs]
[10779.486315]        [<ffffffffa039fd2e>] xfs_create+0x3be/0x640 [xfs]
[10779.518341]        [<ffffffffa039688f>] xfs_vn_mknod+0x8f/0x1c0 [xfs]
[10779.549954]        [<ffffffffa03969f3>] xfs_vn_create+0x13/0x20 [xfs]
[10779.581458]        [<ffffffff8118aeb5>] vfs_create+0xb5/0x120
[10779.611999]        [<ffffffff8118bcc0>] do_last+0xda0/0xf00
[10779.642156]        [<ffffffff8118bed3>] path_openat+0xb3/0x4c0
[10779.671827]        [<ffffffff8118c6f2>] do_filp_open+0x42/0xa0
[10779.700768]        [<ffffffff8117b040>] do_sys_open+0x100/0x1e0
[10779.729733]        [<ffffffff8117b141>] sys_open+0x21/0x30
[10779.758038]        [<ffffffff8163d569>] system_call_fastpath+0x16/0x1b
[10779.787671] 
[10779.787671] other info that might help us debug this:
[10779.787671] 
[10779.861231]  Possible unsafe locking scenario:
[10779.861231] 
[10779.909639]        CPU0                    CPU1
[10779.935308]        ----                    ----
[10779.960439]   lock(sb_internal#2);
[10779.984166]                                lock((&mp->m_flush_work));
[10780.011811]                                lock(sb_internal#2);
[10780.038940]   lock((&mp->m_flush_work));
[10780.064175] 
[10780.064175]  *** DEADLOCK ***
[10780.064175] 
[10780.130488] 3 locks held by fill2/17839:
[10780.153613]  #0:  (sb_writers#13){.+.+.+}, at: [<ffffffff8119b5b4>] mnt_want_write+0x24/0x50
[10780.203004]  #1:  (&type->i_mutex_dir_key#9){+.+.+.}, at: [<ffffffff8118b22b>] do_last+0x30b/0xf00
[10780.256198]  #2:  (sb_internal#2){.+.+.+}, at: [<ffffffffa03dde5d>] xfs_trans_alloc+0x2d/0x50 [xfs]
[10780.312590] 
[10780.312590] stack backtrace:
[10780.363324] Pid: 17839, comm: fill2 Not tainted 3.6.0-rc2-ceph-00143-g995fc06 #1
[10780.419648] Call Trace:
[10780.446606]  [<ffffffff8162a77c>] print_circular_bug+0x1fb/0x20c
[10780.478422]  [<ffffffff810b25e8>] __lock_acquire+0x1ac8/0x1b90
[10780.510238]  [<ffffffff810b3546>] ? mark_held_locks+0x86/0x140
[10780.541977]  [<ffffffff810b379d>] ? trace_hardirqs_on+0xd/0x10
[10780.573289]  [<ffffffff810848c5>] ? finish_task_switch+0x85/0x110
[10780.605032]  [<ffffffff81072060>] ? busy_worker_rebind_fn+0x100/0x100
[10780.637339]  [<ffffffff810b2c82>] lock_acquire+0xa2/0x140
[10780.668511]  [<ffffffff81072060>] ? busy_worker_rebind_fn+0x100/0x100
[10780.701212]  [<ffffffff81634c30>] ? _raw_spin_unlock_irq+0x30/0x40
[10780.734118]  [<ffffffff810720a1>] wait_on_work+0x41/0x160
[10780.766631]  [<ffffffff81072060>] ? busy_worker_rebind_fn+0x100/0x100
[10780.800670]  [<ffffffff810710a8>] ? start_flush_work+0x108/0x180
[10780.833968]  [<ffffffff81634e5f>] ? _raw_spin_unlock_irqrestore+0x3f/0x80
[10780.868526]  [<ffffffff81072203>] flush_work_sync+0x43/0x90
[10780.901562]  [<ffffffff810b379d>] ? trace_hardirqs_on+0xd/0x10
[10780.935025]  [<ffffffff810706c4>] ? __queue_work+0xe4/0x3b0
[10780.968529]  [<ffffffffa039cc7f>] xfs_flush_inodes+0x2f/0x40 [xfs]
[10781.003297]  [<ffffffffa039fd2e>] xfs_create+0x3be/0x640 [xfs]
[10781.037767]  [<ffffffff81192254>] ? d_rehash+0x24/0x40
[10781.070747]  [<ffffffffa039688f>] xfs_vn_mknod+0x8f/0x1c0 [xfs]
[10781.104129]  [<ffffffffa03969f3>] xfs_vn_create+0x13/0x20 [xfs]
[10781.136380]  [<ffffffff8118aeb5>] vfs_create+0xb5/0x120
[10781.167008]  [<ffffffff8118bcc0>] do_last+0xda0/0xf00
[10781.196529]  [<ffffffff8118bed3>] path_openat+0xb3/0x4c0
[10781.225423]  [<ffffffff8118c6f2>] do_filp_open+0x42/0xa0
[10781.254505]  [<ffffffff8132babd>] ? do_raw_spin_unlock+0x5d/0xb0
[10781.284913]  [<ffffffff81634c6b>] ? _raw_spin_unlock+0x2b/0x40
[10781.314576]  [<ffffffff81199a22>] ? alloc_fd+0xd2/0x120
[10781.342807]  [<ffffffff8117b040>] do_sys_open+0x100/0x1e0
[10781.371398]  [<ffffffff8117b141>] sys_open+0x21/0x30
[10781.398981]  [<ffffffff8163d569>] system_call_fastpath+0x16/0x1b

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
