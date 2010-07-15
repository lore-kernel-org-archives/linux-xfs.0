Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o6F0a5Lc173212 for <xfs@oss.sgi.com>; Wed, 14 Jul 2010 19:36:06 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6F4D91199888
	for <xfs@oss.sgi.com>; Wed, 14 Jul 2010 17:45:12 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail17.adl2.internode.on.net
	[150.101.137.102]) by cuda.sgi.com with ESMTP id
	UjCEqJFBDfOh8B6g for <xfs@oss.sgi.com>;
	Wed, 14 Jul 2010 17:45:12 -0700 (PDT)
Received: from dastard (unverified [121.44.38.238])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	31354925-1927428
	for <xfs@oss.sgi.com>; Thu, 15 Jul 2010 10:08:59 +0930 (CST)
Received: from disturbed ([192.168.1.9]) by dastard with esmtp (Exim 4.71)
	(envelope-from <dave@fromorbit.com>) id 1OZCTP-0002zI-Qr
	for xfs@oss.sgi.com; Thu, 15 Jul 2010 10:38:47 +1000
Received: from dave by disturbed with local (Exim 4.71)
	(envelope-from <dave@disturbed.disaster>) id 1OZCTC-0000Xx-AL
	for xfs@oss.sgi.com; Thu, 15 Jul 2010 10:38:34 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 3/5] xfs: fix xfs_trans_add_item() lockdep warnings
Date: Thu, 15 Jul 2010 10:38:18 +1000
Message-Id: <1279154300-2018-4-git-send-email-david@fromorbit.com>
In-Reply-To: <1279154300-2018-1-git-send-email-david@fromorbit.com>
References: <1279154300-2018-1-git-send-email-david@fromorbit.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

From: Dave Chinner <dchinner@redhat.com>

xfs_trans_add_item() is called with ip->i_ilock held, which means it
is unsafe for memory reclaim to recurse back into the filesystem
(ilock is required in writeback). Hence the allocation needs to be
KM_NOFS to avoid recursion.

Lockdep report indicating memory allocation being called with the
ip->i_ilock held is as follows:

[ 1749.866796] =================================
[ 1749.867788] [ INFO: inconsistent lock state ]
[ 1749.868327] 2.6.35-rc3-dgc+ #25
[ 1749.868741] ---------------------------------
[ 1749.868741] inconsistent {IN-RECLAIM_FS-W} -> {RECLAIM_FS-ON-W} usage.
[ 1749.868741] dd/2835 [HC0[0]:SC0[0]:HE1:SE1] takes:
[ 1749.868741]  (&(&ip->i_lock)->mr_lock){++++?.}, at: [<ffffffff813170fb>] xfs_ilock+0x10b/0x190
[ 1749.868741] {IN-RECLAIM_FS-W} state was registered at:
[ 1749.868741]   [<ffffffff810b3a97>] __lock_acquire+0x437/0x1450
[ 1749.868741]   [<ffffffff810b4b56>] lock_acquire+0xa6/0x160
[ 1749.868741]   [<ffffffff810a20b5>] down_write_nested+0x65/0xb0
[ 1749.868741]   [<ffffffff813170fb>] xfs_ilock+0x10b/0x190
[ 1749.868741]   [<ffffffff8134e819>] xfs_reclaim_inode+0x99/0x310
[ 1749.868741]   [<ffffffff8134f56b>] xfs_inode_ag_walk+0x8b/0x150
[ 1749.868741]   [<ffffffff8134f6bb>] xfs_inode_ag_iterator+0x8b/0xf0
[ 1749.868741]   [<ffffffff8134f7a8>] xfs_reclaim_inode_shrink+0x88/0x90
[ 1749.868741]   [<ffffffff81119d07>] shrink_slab+0x137/0x1a0
[ 1749.868741]   [<ffffffff8111bbe1>] balance_pgdat+0x421/0x6a0
[ 1749.868741]   [<ffffffff8111bf7d>] kswapd+0x11d/0x320
[ 1749.868741]   [<ffffffff8109ce56>] kthread+0x96/0xa0
[ 1749.868741]   [<ffffffff81035de4>] kernel_thread_helper+0x4/0x10
[ 1749.868741] irq event stamp: 4234335
[ 1749.868741] hardirqs last  enabled at (4234335): [<ffffffff81147d25>] kmem_cache_free+0x115/0x220
[ 1749.868741] hardirqs last disabled at (4234334): [<ffffffff81147c4d>] kmem_cache_free+0x3d/0x220
[ 1749.868741] softirqs last  enabled at (4233112): [<ffffffff81084dd2>] __do_softirq+0x142/0x260
[ 1749.868741] softirqs last disabled at (4233095): [<ffffffff81035edc>] call_softirq+0x1c/0x50
[ 1749.868741]
[ 1749.868741] other info that might help us debug this:
[ 1749.868741] 2 locks held by dd/2835:
[ 1749.868741]  #0:  (&(&ip->i_iolock)->mr_lock#2){+.+.+.}, at: [<ffffffff81316edd>] xfs_ilock_nowait+0xed/0x200
[ 1749.868741]  #1:  (&(&ip->i_lock)->mr_lock){++++?.}, at: [<ffffffff813170fb>] xfs_ilock+0x10b/0x190
[ 1749.868741]
[ 1749.868741] stack backtrace:
[ 1749.868741] Pid: 2835, comm: dd Not tainted 2.6.35-rc3-dgc+ #25
[ 1749.868741] Call Trace:
[ 1749.868741]  [<ffffffff810b1faa>] print_usage_bug+0x18a/0x190
[ 1749.868741]  [<ffffffff8104264f>] ? save_stack_trace+0x2f/0x50
[ 1749.868741]  [<ffffffff810b2400>] ? check_usage_backwards+0x0/0xf0
[ 1749.868741]  [<ffffffff810b2f11>] mark_lock+0x331/0x400
[ 1749.868741]  [<ffffffff810b3047>] mark_held_locks+0x67/0x90
[ 1749.868741]  [<ffffffff810b3111>] lockdep_trace_alloc+0xa1/0xe0
[ 1749.868741]  [<ffffffff81147419>] kmem_cache_alloc+0x39/0x1e0
[ 1749.868741]  [<ffffffff8133f954>] kmem_zone_alloc+0x94/0xe0
[ 1749.868741]  [<ffffffff8133f9be>] kmem_zone_zalloc+0x1e/0x50
[ 1749.868741]  [<ffffffff81335f02>] xfs_trans_add_item+0x72/0xb0
[ 1749.868741]  [<ffffffff81339e41>] xfs_trans_ijoin+0xa1/0xd0
[ 1749.868741]  [<ffffffff81319f82>] xfs_itruncate_finish+0x312/0x5d0
[ 1749.868741]  [<ffffffff8133cb87>] xfs_free_eofblocks+0x227/0x280
[ 1749.868741]  [<ffffffff8133cd18>] xfs_release+0x138/0x190
[ 1749.868741]  [<ffffffff813464c5>] xfs_file_release+0x15/0x20
[ 1749.868741]  [<ffffffff81150ebf>] fput+0x13f/0x260
[ 1749.868741]  [<ffffffff8114d8c2>] filp_close+0x52/0x80
[ 1749.868741]  [<ffffffff8114d9a9>] sys_close+0xb9/0x120
[ 1749.868741]  [<ffffffff81034ff2>] system_call_fastpath+0x16/0x1b

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_trans.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index f2065cc..3680a47 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -1134,7 +1134,7 @@ xfs_trans_add_item(
 	ASSERT(lip->li_mountp = tp->t_mountp);
 	ASSERT(lip->li_ailp = tp->t_mountp->m_ail);
 
-	lidp = kmem_zone_zalloc(xfs_log_item_desc_zone, KM_SLEEP);
+	lidp = kmem_zone_zalloc(xfs_log_item_desc_zone, KM_SLEEP|KM_NOFS);
 
 	lidp->lid_item = lip;
 	lidp->lid_flags = 0;
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
