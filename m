Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7UBxW2E192316 for <xfs@oss.sgi.com>; Thu, 30 Aug 2012 06:59:32 -0500
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	9FkAmAQPZm7dxv3q for <xfs@oss.sgi.com>;
	Thu, 30 Aug 2012 05:00:24 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1T73Q4-0003qF-1a
	for xfs@oss.sgi.com; Thu, 30 Aug 2012 22:00:20 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1T73Q3-0000kF-UR
	for xfs@oss.sgi.com; Thu, 30 Aug 2012 22:00:19 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 02/13] xfs: rename the xfs_syncd workqueue
Date: Thu, 30 Aug 2012 22:00:06 +1000
Message-Id: <1346328017-2795-3-git-send-email-david@fromorbit.com>
In-Reply-To: <1346328017-2795-1-git-send-email-david@fromorbit.com>
References: <1346328017-2795-1-git-send-email-david@fromorbit.com>
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

There is nothing "sync" realted to this work queue any more. It is a general
purpose per-filesystem work queue. Rename it appropriately, and remove the
"syncd" naming from various functions.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_mount.c |    1 +
 fs/xfs/xfs_mount.h |    2 ++
 fs/xfs/xfs_super.c |   14 +++++++-------
 fs/xfs/xfs_sync.c  |   19 +++++++++----------
 fs/xfs/xfs_sync.h  |    4 +---
 5 files changed, 20 insertions(+), 20 deletions(-)

diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 29c2f83..e2979ee 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -43,6 +43,7 @@
 #include "xfs_utils.h"
 #include "xfs_trace.h"
 
+struct workqueue_struct	*xfs_mount_wq;
 
 #ifdef HAVE_PERCPU_SB
 STATIC void	xfs_icsb_balance_counter(xfs_mount_t *, xfs_sb_field_t,
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index deee09e..a0113dd 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -60,6 +60,8 @@ struct xfs_nameops;
 struct xfs_ail;
 struct xfs_quotainfo;
 
+extern struct workqueue_struct	*xfs_mount_wq;
+
 #ifdef HAVE_PERCPU_SB
 
 /*
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 116fcb8..d75fdf3 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1298,7 +1298,7 @@ xfs_fs_fill_super(
 	INIT_DELAYED_WORK(&mp->m_sync_work, xfs_sync_worker);
 	INIT_DELAYED_WORK(&mp->m_reclaim_work, xfs_reclaim_worker);
 
-	xfs_syncd_queue_sync(mp);
+	xfs_sync_work_queue(mp);
 
 	error = xfs_mountfs(mp);
 	if (error)
@@ -1542,8 +1542,8 @@ xfs_init_workqueues(void)
 	 * competing for ressources.  Use the default large max_active value
 	 * so that even lots of filesystems can perform these task in parallel.
 	 */
-	xfs_syncd_wq = alloc_workqueue("xfssyncd", WQ_NON_REENTRANT, 0);
-	if (!xfs_syncd_wq)
+	xfs_mount_wq = alloc_workqueue("xfsmount", WQ_NON_REENTRANT, 0);
+	if (!xfs_mount_wq)
 		return -ENOMEM;
 
 	/*
@@ -1554,12 +1554,12 @@ xfs_init_workqueues(void)
 	 */
 	xfs_alloc_wq = alloc_workqueue("xfsalloc", WQ_MEM_RECLAIM, 0);
 	if (!xfs_alloc_wq)
-		goto out_destroy_syncd;
+		goto out_destroy_mount;
 
 	return 0;
 
-out_destroy_syncd:
-	destroy_workqueue(xfs_syncd_wq);
+out_destroy_mount:
+	destroy_workqueue(xfs_mount_wq);
 	return -ENOMEM;
 }
 
@@ -1567,7 +1567,7 @@ STATIC void
 xfs_destroy_workqueues(void)
 {
 	destroy_workqueue(xfs_alloc_wq);
-	destroy_workqueue(xfs_syncd_wq);
+	destroy_workqueue(xfs_mount_wq);
 }
 
 STATIC int __init
diff --git a/fs/xfs/xfs_sync.c b/fs/xfs/xfs_sync.c
index 13830e4..7744ffe 100644
--- a/fs/xfs/xfs_sync.c
+++ b/fs/xfs/xfs_sync.c
@@ -39,7 +39,6 @@
 #include <linux/kthread.h>
 #include <linux/freezer.h>
 
-struct workqueue_struct	*xfs_syncd_wq;	/* sync workqueue */
 
 /*
  * The inode lookup is done in batches to keep the amount of lock traffic and
@@ -371,10 +370,10 @@ xfs_quiesce_attr(
 }
 
 void
-xfs_syncd_queue_sync(
+xfs_sync_work_queue(
 	struct xfs_mount        *mp)
 {
-	queue_delayed_work(xfs_syncd_wq, &mp->m_sync_work,
+	queue_delayed_work(xfs_mount_wq, &mp->m_sync_work,
 				msecs_to_jiffies(xfs_syncd_centisecs * 10));
 }
 
@@ -415,7 +414,7 @@ xfs_sync_worker(
 	}
 
 	/* queue us up again */
-	xfs_syncd_queue_sync(mp);
+	xfs_sync_work_queue(mp);
 }
 
 /*
@@ -426,13 +425,13 @@ xfs_sync_worker(
  * aggressive.
  */
 static void
-xfs_syncd_queue_reclaim(
+xfs_reclaim_queue_work(
 	struct xfs_mount        *mp)
 {
 
 	rcu_read_lock();
 	if (radix_tree_tagged(&mp->m_perag_tree, XFS_ICI_RECLAIM_TAG)) {
-		queue_delayed_work(xfs_syncd_wq, &mp->m_reclaim_work,
+		queue_delayed_work(xfs_mount_wq, &mp->m_reclaim_work,
 			msecs_to_jiffies(xfs_syncd_centisecs / 6 * 10));
 	}
 	rcu_read_unlock();
@@ -453,7 +452,7 @@ xfs_reclaim_worker(
 					struct xfs_mount, m_reclaim_work);
 
 	xfs_reclaim_inodes(mp, SYNC_TRYLOCK);
-	xfs_syncd_queue_reclaim(mp);
+	xfs_reclaim_queue_work(mp);
 }
 
 /*
@@ -474,7 +473,7 @@ xfs_flush_inodes(
 {
 	struct xfs_mount	*mp = ip->i_mount;
 
-	queue_work(xfs_syncd_wq, &mp->m_flush_work);
+	queue_work(xfs_mount_wq, &mp->m_flush_work);
 	flush_work_sync(&mp->m_flush_work);
 }
 
@@ -507,7 +506,7 @@ __xfs_inode_set_reclaim_tag(
 		spin_unlock(&ip->i_mount->m_perag_lock);
 
 		/* schedule periodic background inode reclaim */
-		xfs_syncd_queue_reclaim(ip->i_mount);
+		xfs_reclaim_queue_work(ip->i_mount);
 
 		trace_xfs_perag_set_reclaim(ip->i_mount, pag->pag_agno,
 							-1, _RET_IP_);
@@ -923,7 +922,7 @@ xfs_reclaim_inodes_nr(
 	int			nr_to_scan)
 {
 	/* kick background reclaimer and push the AIL */
-	xfs_syncd_queue_reclaim(mp);
+	xfs_reclaim_queue_work(mp);
 	xfs_ail_push_all(mp->m_ail);
 
 	xfs_reclaim_inodes_ag(mp, SYNC_TRYLOCK | SYNC_WAIT, &nr_to_scan);
diff --git a/fs/xfs/xfs_sync.h b/fs/xfs/xfs_sync.h
index 3f59e5b..3c22f3d 100644
--- a/fs/xfs/xfs_sync.h
+++ b/fs/xfs/xfs_sync.h
@@ -24,9 +24,7 @@ struct xfs_perag;
 #define SYNC_WAIT		0x0001	/* wait for i/o to complete */
 #define SYNC_TRYLOCK		0x0002  /* only try to lock inodes */
 
-extern struct workqueue_struct	*xfs_syncd_wq;	/* sync workqueue */
-
-void xfs_syncd_queue_sync(struct xfs_mount *mp);
+void xfs_sync_work_queue(struct xfs_mount *mp);
 void xfs_sync_worker(struct work_struct *work);
 void xfs_flush_worker(struct work_struct *work);
 void xfs_reclaim_worker(struct work_struct *work);
-- 
1.7.10

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
