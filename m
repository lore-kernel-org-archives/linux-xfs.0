Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q8M0aYaG010043 for <xfs@oss.sgi.com>; Fri, 21 Sep 2012 19:36:34 -0500
Received: from trent.utfs.org (trent.utfs.org [94.185.90.103]) by cuda.sgi.com
	with ESMTP id K8vlrLxCD7FxfDEX for <xfs@oss.sgi.com>;
	Fri, 21 Sep 2012 17:37:46 -0700 (PDT)
Received: from trent.utfs.org (localhost [127.0.0.1])
	by trent.utfs.org (Postfix) with ESMTP id 7D2A73DD45
	for <xfs@oss.sgi.com>; Sat, 22 Sep 2012 02:37:43 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by trent.utfs.org (Postfix) with ESMTP id 624C83DAC2
	for <xfs@oss.sgi.com>; Sat, 22 Sep 2012 02:37:43 +0200 (CEST)
Date: Fri, 21 Sep 2012 17:37:43 -0700 (PDT)
From: Christian Kujau <lists@nerdbynature.de>
Subject: 3.6.0-rc6: inconsistent {IN-RECLAIM_FS-W} -> {RECLAIM_FS-ON-W} usage
Message-ID: <alpine.DEB.2.01.1209211723270.27947@trent.utfs.org>
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

After upgrading from 3.5 to 3.6.0-rc6, the lockdep warning below is 
printed after the machine was running for ~1 day. When it was printed, 
disk i/o load was higher than usual as the machine was running backups, so 
this might've triggered it.

I've observed a simliar lockdep warning earlier[0] for 3.5.0-rc5, but with 
a different backtrace. Also, then I was told that I may have run out of 
inode attributes. As I have not reformatted the filesystem, this might 
still be the case.

A more similar backtrace has been posted[1] for 3.5.0-rc1, but I don't 
think a consensus on its solution has been reached.

The .config, mountoptions and full dmesg are here:

  http://nerdbynature.de/bits/3.6.0-rc6

Christian.

[0] http://oss.sgi.com/archives/xfs/2012-07/msg00113.html
[1] https://lkml.org/lkml/2012/6/13/582

=================================
[ INFO: inconsistent lock state ]
3.6.0-rc6-00052-gc46de22 #1 Not tainted
---------------------------------
inconsistent {IN-RECLAIM_FS-W} -> {RECLAIM_FS-ON-W} usage.
rm/12693 [HC0[0]:SC0[0]:HE1:SE1] takes:
 (&(&ip->i_lock)->mr_lock){++++?-}, at: [<c01ab424>] xfs_ilock+0x8c/0xb0
{IN-RECLAIM_FS-W} state was registered at:
  [<c0070224>] lock_acquire+0x50/0x6c
  [<c005626c>] down_write_nested+0x54/0x94
  [<c01ab424>] xfs_ilock+0x8c/0xb0
  [<c01b6334>] xfs_reclaim_inode+0x11c/0x32c
  [<c01b717c>] xfs_reclaim_inodes_ag+0x1c4/0x3c8
  [<c01b74e0>] xfs_reclaim_inodes_nr+0x38/0x4c
  [<c01b3f44>] xfs_fs_free_cached_objects+0x14/0x24
  [<c00c8368>] prune_super+0xf4/0x188
  [<c009b9bc>] shrink_slab+0x1c0/0x2b4
  [<c009ddbc>] kswapd+0x460/0x940
  [<c0050444>] kthread+0x84/0x88
  [<c000ecf8>] kernel_thread+0x4c/0x68
irq event stamp: 6402587
hardirqs last  enabled at (6402587): [<c04ca678>] _raw_spin_unlock_irqrestore+0x3c/0x90
hardirqs last disabled at (6402586): [<c04c9d80>] _raw_spin_lock_irqsave+0x2c/0x7c
softirqs last  enabled at (6401106): [<c0037d74>] __do_softirq+0x138/0x17c
softirqs last disabled at (6401095): [<c000e7f4>] call_do_softirq+0x14/0x24

other info that might help us debug this:
 Possible unsafe locking scenario:

       CPU0
       ----
  lock(&(&ip->i_lock)->mr_lock);
  <Interrupt>
    lock(&(&ip->i_lock)->mr_lock);

 *** DEADLOCK ***

4 locks held by rm/12693:
 #0:  (sb_writers#11){.+.+.+}, at: [<c00e488c>] mnt_want_write+0x24/0x58
 #1:  (&type->i_mutex_dir_key#5/1){+.+.+.}, at: [<c00d38d0>] do_rmdir+0xac/0x110
 #2:  (sb_internal#2){.+.+.+}, at: [<c01f316c>] xfs_trans_alloc+0x28/0x58
 #3:  (&(&ip->i_lock)->mr_lock){++++?-}, at: [<c01ab424>] xfs_ilock+0x8c/0xb0

stack backtrace:
Call Trace:
[d9e35b60] [c00091e4] show_stack+0x48/0x15c (unreliable)
[d9e35ba0] [c04cc4b4] print_usage_bug.part.34+0x260/0x274
[d9e35bd0] [c006e528] mark_lock+0x570/0x644
[d9e35c00] [c00708d4] mark_held_locks+0x98/0x168
[d9e35c40] [c0070fd4] lockdep_trace_alloc+0x84/0xe8
[d9e35c50] [c00c0834] kmem_cache_alloc+0x34/0x124
[d9e35c70] [c00b5088] vm_map_ram+0x228/0x5a0
[d9e35cf0] [c01a3b44] _xfs_buf_map_pages+0x44/0x104
[d9e35d10] [c01a4c1c] xfs_buf_get_map+0x74/0x11c
[d9e35d30] [c01fbd30] xfs_trans_get_buf_map+0xc0/0xdc
[d9e35d50] [c01e55bc] xfs_ifree_cluster+0x3f4/0x5b0
[d9e35de0] [c01e6c78] xfs_ifree+0xec/0xf0
[d9e35e20] [c01b9678] xfs_inactive+0x274/0x448
[d9e35e60] [c01b4930] xfs_fs_evict_inode+0x60/0x74
[d9e35e70] [c00e0858] evict+0xc0/0x1b4
[d9e35e90] [c00dc740] d_delete+0x1b0/0x1f4
[d9e35eb0] [c00d3820] vfs_rmdir+0x124/0x128
[d9e35ed0] [c00d390c] do_rmdir+0xe8/0x110
[d9e35f40] [c0010a4c] ret_from_syscall+0x0/0x38
--- Exception: c01 at 0xff4c918
    LR = 0x10001b2c
 
-- 
BOFH excuse #198:

Post-it Note Sludge leaked into the monitor.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
