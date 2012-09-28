Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q8S4i6Sc174901 for <xfs@oss.sgi.com>; Thu, 27 Sep 2012 23:44:06 -0500
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	DFVqb5c5TtvGjcRO for <xfs@oss.sgi.com>;
	Thu, 27 Sep 2012 21:45:24 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1THSRV-0007Lf-KT
	for xfs@oss.sgi.com; Fri, 28 Sep 2012 14:44:49 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1THSRV-0005Gc-6M
	for xfs@oss.sgi.com; Fri, 28 Sep 2012 14:44:49 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 07/13] xfs: syncd workqueue is no more
Date: Fri, 28 Sep 2012 14:44:39 +1000
Message-Id: <1348807485-20165-8-git-send-email-david@fromorbit.com>
In-Reply-To: <1348807485-20165-1-git-send-email-david@fromorbit.com>
References: <1348807485-20165-1-git-send-email-david@fromorbit.com>
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

With the syncd functions moved to the log and/or removed, the syncd
workqueue is the only remaining bit left. It is used by the log
covering/ail pushing work, as well as by the inode reclaim work.

Given how cheap workqueues are these days, give the log and inode
reclaim work their own work queues and kill the syncd work queue.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_log.c   |    2 +-
 fs/xfs/xfs_mount.h |    2 ++
 fs/xfs/xfs_super.c |   38 ++++++++++++++++++--------------------
 fs/xfs/xfs_sync.c  |   20 +++++++++-----------
 fs/xfs/xfs_sync.h  |    2 --
 5 files changed, 30 insertions(+), 34 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index a400e71..96ea9ed 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -1191,7 +1191,7 @@ void
 xfs_log_work_queue(
 	struct xfs_mount        *mp)
 {
-	queue_delayed_work(xfs_syncd_wq, &mp->m_log->l_work,
+	queue_delayed_work(mp->m_log_workqueue, &mp->m_log->l_work,
 				msecs_to_jiffies(xfs_syncd_centisecs * 10));
 }
 
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index a54b5aa..7c417b6 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -207,6 +207,8 @@ typedef struct xfs_mount {
 	struct workqueue_struct	*m_data_workqueue;
 	struct workqueue_struct	*m_unwritten_workqueue;
 	struct workqueue_struct	*m_cil_workqueue;
+	struct workqueue_struct	*m_reclaim_workqueue;
+	struct workqueue_struct	*m_log_workqueue;
 } xfs_mount_t;
 
 /*
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index fed1eb2..65cf42c 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -776,8 +776,23 @@ xfs_init_mount_workqueues(
 			WQ_MEM_RECLAIM, 0, mp->m_fsname);
 	if (!mp->m_cil_workqueue)
 		goto out_destroy_unwritten;
+
+	mp->m_reclaim_workqueue = alloc_workqueue("xfs-reclaim/%s",
+			WQ_NON_REENTRANT, 0, mp->m_fsname);
+	if (!mp->m_reclaim_workqueue)
+		goto out_destroy_cil;
+
+	mp->m_log_workqueue = alloc_workqueue("xfs-reclaim/%s",
+			WQ_NON_REENTRANT, 0, mp->m_fsname);
+	if (!mp->m_log_workqueue)
+		goto out_destroy_reclaim;
+
 	return 0;
 
+out_destroy_reclaim:
+	destroy_workqueue(mp->m_reclaim_workqueue);
+out_destroy_cil:
+	destroy_workqueue(mp->m_cil_workqueue);
 out_destroy_unwritten:
 	destroy_workqueue(mp->m_unwritten_workqueue);
 out_destroy_data_iodone_queue:
@@ -790,6 +805,8 @@ STATIC void
 xfs_destroy_mount_workqueues(
 	struct xfs_mount	*mp)
 {
+	destroy_workqueue(mp->m_log_workqueue);
+	destroy_workqueue(mp->m_reclaim_workqueue);
 	destroy_workqueue(mp->m_cil_workqueue);
 	destroy_workqueue(mp->m_data_workqueue);
 	destroy_workqueue(mp->m_unwritten_workqueue);
@@ -1280,10 +1297,6 @@ xfs_fs_fill_super(
 	/*
 	 * we must configure the block size in the superblock before we run the
 	 * full mount process as the mount process can lookup and cache inodes.
-	 * For the same reason we must also initialise the syncd and register
-	 * the inode cache shrinker so that inodes can be reclaimed during
-	 * operations like a quotacheck that iterate all inodes in the
-	 * filesystem.
 	 */
 	sb->s_magic = XFS_SB_MAGIC;
 	sb->s_blocksize = mp->m_sb.sb_blocksize;
@@ -1523,16 +1536,6 @@ STATIC int __init
 xfs_init_workqueues(void)
 {
 	/*
-	 * We never want to the same work item to run twice, reclaiming inodes
-	 * or idling the log is not going to get any faster by multiple CPUs
-	 * competing for ressources.  Use the default large max_active value
-	 * so that even lots of filesystems can perform these task in parallel.
-	 */
-	xfs_syncd_wq = alloc_workqueue("xfssyncd", WQ_NON_REENTRANT, 0);
-	if (!xfs_syncd_wq)
-		return -ENOMEM;
-
-	/*
 	 * The allocation workqueue can be used in memory reclaim situations
 	 * (writepage path), and parallelism is only limited by the number of
 	 * AGs in all the filesystems mounted. Hence use the default large
@@ -1540,20 +1543,15 @@ xfs_init_workqueues(void)
 	 */
 	xfs_alloc_wq = alloc_workqueue("xfsalloc", WQ_MEM_RECLAIM, 0);
 	if (!xfs_alloc_wq)
-		goto out_destroy_syncd;
+		return -ENOMEM;
 
 	return 0;
-
-out_destroy_syncd:
-	destroy_workqueue(xfs_syncd_wq);
-	return -ENOMEM;
 }
 
 STATIC void
 xfs_destroy_workqueues(void)
 {
 	destroy_workqueue(xfs_alloc_wq);
-	destroy_workqueue(xfs_syncd_wq);
 }
 
 STATIC int __init
diff --git a/fs/xfs/xfs_sync.c b/fs/xfs/xfs_sync.c
index 6a2ada3..15be21f 100644
--- a/fs/xfs/xfs_sync.c
+++ b/fs/xfs/xfs_sync.c
@@ -40,8 +40,6 @@
 #include <linux/kthread.h>
 #include <linux/freezer.h>
 
-struct workqueue_struct	*xfs_syncd_wq;	/* sync workqueue */
-
 /*
  * The inode lookup is done in batches to keep the amount of lock traffic and
  * radix tree lookups to a minimum. The batch size is a trade off between
@@ -335,18 +333,18 @@ xfs_quiesce_attr(
 /*
  * Queue a new inode reclaim pass if there are reclaimable inodes and there
  * isn't a reclaim pass already in progress. By default it runs every 5s based
- * on the xfs syncd work default of 30s. Perhaps this should have it's own
+ * on the xfs periodic sync default of 30s. Perhaps this should have it's own
  * tunable, but that can be done if this method proves to be ineffective or too
  * aggressive.
  */
 static void
-xfs_syncd_queue_reclaim(
+xfs_reclaim_work_queue(
 	struct xfs_mount        *mp)
 {
 
 	rcu_read_lock();
 	if (radix_tree_tagged(&mp->m_perag_tree, XFS_ICI_RECLAIM_TAG)) {
-		queue_delayed_work(xfs_syncd_wq, &mp->m_reclaim_work,
+		queue_delayed_work(mp->m_reclaim_workqueue, &mp->m_reclaim_work,
 			msecs_to_jiffies(xfs_syncd_centisecs / 6 * 10));
 	}
 	rcu_read_unlock();
@@ -367,7 +365,7 @@ xfs_reclaim_worker(
 					struct xfs_mount, m_reclaim_work);
 
 	xfs_reclaim_inodes(mp, SYNC_TRYLOCK);
-	xfs_syncd_queue_reclaim(mp);
+	xfs_reclaim_work_queue(mp);
 }
 
 void
@@ -388,7 +386,7 @@ __xfs_inode_set_reclaim_tag(
 		spin_unlock(&ip->i_mount->m_perag_lock);
 
 		/* schedule periodic background inode reclaim */
-		xfs_syncd_queue_reclaim(ip->i_mount);
+		xfs_reclaim_work_queue(ip->i_mount);
 
 		trace_xfs_perag_set_reclaim(ip->i_mount, pag->pag_agno,
 							-1, _RET_IP_);
@@ -646,9 +644,9 @@ out:
 	/*
 	 * We could return EAGAIN here to make reclaim rescan the inode tree in
 	 * a short while. However, this just burns CPU time scanning the tree
-	 * waiting for IO to complete and xfssyncd never goes back to the idle
-	 * state. Instead, return 0 to let the next scheduled background reclaim
-	 * attempt to reclaim the inode again.
+	 * waiting for IO to complete and the reclaim work never goes back to
+	 * the idle state. Instead, return 0 to let the next scheduled
+	 * background reclaim attempt to reclaim the inode again.
 	 */
 	return 0;
 }
@@ -804,7 +802,7 @@ xfs_reclaim_inodes_nr(
 	int			nr_to_scan)
 {
 	/* kick background reclaimer and push the AIL */
-	xfs_syncd_queue_reclaim(mp);
+	xfs_reclaim_work_queue(mp);
 	xfs_ail_push_all(mp->m_ail);
 
 	xfs_reclaim_inodes_ag(mp, SYNC_TRYLOCK | SYNC_WAIT, &nr_to_scan);
diff --git a/fs/xfs/xfs_sync.h b/fs/xfs/xfs_sync.h
index 0018e84..0beabea 100644
--- a/fs/xfs/xfs_sync.h
+++ b/fs/xfs/xfs_sync.h
@@ -24,8 +24,6 @@ struct xfs_perag;
 #define SYNC_WAIT		0x0001	/* wait for i/o to complete */
 #define SYNC_TRYLOCK		0x0002  /* only try to lock inodes */
 
-extern struct workqueue_struct	*xfs_syncd_wq;	/* sync workqueue */
-
 void xfs_reclaim_worker(struct work_struct *work);
 
 int xfs_quiesce_data(struct xfs_mount *mp);
-- 
1.7.10

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
