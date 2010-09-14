Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8EAuUqT121315 for <xfs@oss.sgi.com>; Tue, 14 Sep 2010 05:56:30 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id BE41A1E65326
	for <xfs@oss.sgi.com>; Tue, 14 Sep 2010 03:57:17 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail18.adl2.internode.on.net
	[150.101.137.103]) by cuda.sgi.com with ESMTP id
	77FLw2hUEfj1rLYq for <xfs@oss.sgi.com>;
	Tue, 14 Sep 2010 03:57:17 -0700 (PDT)
Received: from dastard (unverified [121.44.127.68])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	38735027-1927428
	for <xfs@oss.sgi.com>; Tue, 14 Sep 2010 20:27:16 +0930 (CST)
Received: from disturbed ([192.168.1.9]) by dastard with esmtp (Exim 4.71)
	(envelope-from <dave@fromorbit.com>) id 1OvTCM-0004PQ-UH
	for xfs@oss.sgi.com; Tue, 14 Sep 2010 20:57:14 +1000
Received: from dave by disturbed with local (Exim 4.72)
	(envelope-from <dave@disturbed.disaster>) id 1OvTC0-0000Qg-I6
	for xfs@oss.sgi.com; Tue, 14 Sep 2010 20:56:52 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 16/18] xfs: convert xfsbud shrinker to a per-buftarg shrinker.
Date: Tue, 14 Sep 2010 20:56:15 +1000
Message-Id: <1284461777-1496-17-git-send-email-david@fromorbit.com>
In-Reply-To: <1284461777-1496-1-git-send-email-david@fromorbit.com>
References: <1284461777-1496-1-git-send-email-david@fromorbit.com>
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

Before we introduce per-buftarg LRU lists, split the shrinker
implementation into per-buftarg shrinker callbacks. At the moment
we wake all the xfsbufds to run the delayed write queues to free
the dirty buffers and make their pages available for reclaim.
However, with an LRU, we want to be able to free clean, unused
buffers as well, so we need to separate the xfsbufd from the
shrinker callbacks.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/linux-2.6/xfs_buf.c |   89 ++++++++++++--------------------------------
 fs/xfs/linux-2.6/xfs_buf.h |    4 +-
 2 files changed, 27 insertions(+), 66 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_buf.c b/fs/xfs/linux-2.6/xfs_buf.c
index cce427d..3b54fee 100644
--- a/fs/xfs/linux-2.6/xfs_buf.c
+++ b/fs/xfs/linux-2.6/xfs_buf.c
@@ -44,12 +44,7 @@
 
 static kmem_zone_t *xfs_buf_zone;
 STATIC int xfsbufd(void *);
-STATIC int xfsbufd_wakeup(struct shrinker *, int, gfp_t);
 STATIC void xfs_buf_delwri_queue(xfs_buf_t *, int);
-static struct shrinker xfs_buf_shake = {
-	.shrink = xfsbufd_wakeup,
-	.seeks = DEFAULT_SEEKS,
-};
 
 static struct workqueue_struct *xfslogd_workqueue;
 struct workqueue_struct *xfsdatad_workqueue;
@@ -337,7 +332,6 @@ _xfs_buf_lookup_pages(
 					__func__, gfp_mask);
 
 			XFS_STATS_INC(xb_page_retries);
-			xfsbufd_wakeup(NULL, 0, gfp_mask);
 			congestion_wait(BLK_RW_ASYNC, HZ/50);
 			goto retry;
 		}
@@ -1475,28 +1469,23 @@ xfs_wait_buftarg(
 	}
 }
 
-/*
- *	buftarg list for delwrite queue processing
- */
-static LIST_HEAD(xfs_buftarg_list);
-static DEFINE_SPINLOCK(xfs_buftarg_lock);
-
-STATIC void
-xfs_register_buftarg(
-	xfs_buftarg_t           *btp)
-{
-	spin_lock(&xfs_buftarg_lock);
-	list_add(&btp->bt_list, &xfs_buftarg_list);
-	spin_unlock(&xfs_buftarg_lock);
-}
-
-STATIC void
-xfs_unregister_buftarg(
-	xfs_buftarg_t           *btp)
+int
+xfs_buftarg_shrink(
+	struct shrinker		*shrink,
+	int			nr_to_scan,
+	gfp_t			mask)
 {
-	spin_lock(&xfs_buftarg_lock);
-	list_del(&btp->bt_list);
-	spin_unlock(&xfs_buftarg_lock);
+	struct xfs_buftarg	*btp = container_of(shrink,
+					struct xfs_buftarg, bt_shrinker);
+	if (nr_to_scan) {
+		if (test_bit(XBT_FORCE_SLEEP, &btp->bt_flags))
+			return -1;
+		if (list_empty(&btp->bt_delwrite_queue))
+			return -1;
+		set_bit(XBT_FORCE_FLUSH, &btp->bt_flags);
+		wake_up_process(btp->bt_task);
+	}
+	return list_empty(&btp->bt_delwrite_queue) ? -1 : 1;
 }
 
 void
@@ -1504,17 +1493,14 @@ xfs_free_buftarg(
 	struct xfs_mount	*mp,
 	struct xfs_buftarg	*btp)
 {
+	unregister_shrinker(&btp->bt_shrinker);
+
 	xfs_flush_buftarg(btp, 1);
 	if (mp->m_flags & XFS_MOUNT_BARRIER)
 		xfs_blkdev_issue_flush(btp);
 	iput(btp->bt_mapping->host);
 
-	/* Unregister the buftarg first so that we don't get a
-	 * wakeup finding a non-existent task
-	 */
-	xfs_unregister_buftarg(btp);
 	kthread_stop(btp->bt_task);
-
 	kmem_free(btp);
 }
 
@@ -1610,20 +1596,13 @@ xfs_alloc_delwrite_queue(
 	xfs_buftarg_t		*btp,
 	const char		*fsname)
 {
-	int	error = 0;
-
-	INIT_LIST_HEAD(&btp->bt_list);
 	INIT_LIST_HEAD(&btp->bt_delwrite_queue);
 	spin_lock_init(&btp->bt_delwrite_lock);
 	btp->bt_flags = 0;
 	btp->bt_task = kthread_run(xfsbufd, btp, "xfsbufd/%s", fsname);
-	if (IS_ERR(btp->bt_task)) {
-		error = PTR_ERR(btp->bt_task);
-		goto out_error;
-	}
-	xfs_register_buftarg(btp);
-out_error:
-	return error;
+	if (IS_ERR(btp->bt_task))
+		return PTR_ERR(btp->bt_task);
+	return 0;
 }
 
 xfs_buftarg_t *
@@ -1646,6 +1625,9 @@ xfs_alloc_buftarg(
 		goto error;
 	if (xfs_alloc_delwrite_queue(btp, fsname))
 		goto error;
+	btp->bt_shrinker.shrink = xfs_buftarg_shrink,
+	btp->bt_shrinker.seeks = DEFAULT_SEEKS,
+	register_shrinker(&btp->bt_shrinker);
 	return btp;
 
 error:
@@ -1750,27 +1732,6 @@ xfs_buf_runall_queues(
 	flush_workqueue(queue);
 }
 
-STATIC int
-xfsbufd_wakeup(
-	struct shrinker		*shrink,
-	int			priority,
-	gfp_t			mask)
-{
-	xfs_buftarg_t		*btp;
-
-	spin_lock(&xfs_buftarg_lock);
-	list_for_each_entry(btp, &xfs_buftarg_list, bt_list) {
-		if (test_bit(XBT_FORCE_SLEEP, &btp->bt_flags))
-			continue;
-		if (list_empty(&btp->bt_delwrite_queue))
-			continue;
-		set_bit(XBT_FORCE_FLUSH, &btp->bt_flags);
-		wake_up_process(btp->bt_task);
-	}
-	spin_unlock(&xfs_buftarg_lock);
-	return 0;
-}
-
 /*
  * Move as many buffers as specified to the supplied list
  * idicating if we skipped any buffers to prevent deadlocks.
@@ -1965,7 +1926,6 @@ xfs_buf_init(void)
 	if (!xfsconvertd_workqueue)
 		goto out_destroy_xfsdatad_workqueue;
 
-	register_shrinker(&xfs_buf_shake);
 	return 0;
 
  out_destroy_xfsdatad_workqueue:
@@ -1981,7 +1941,6 @@ xfs_buf_init(void)
 void
 xfs_buf_terminate(void)
 {
-	unregister_shrinker(&xfs_buf_shake);
 	destroy_workqueue(xfsconvertd_workqueue);
 	destroy_workqueue(xfsdatad_workqueue);
 	destroy_workqueue(xfslogd_workqueue);
diff --git a/fs/xfs/linux-2.6/xfs_buf.h b/fs/xfs/linux-2.6/xfs_buf.h
index 44f66cd..6e9310b 100644
--- a/fs/xfs/linux-2.6/xfs_buf.h
+++ b/fs/xfs/linux-2.6/xfs_buf.h
@@ -137,10 +137,12 @@ typedef struct xfs_buftarg {
 
 	/* per device delwri queue */
 	struct task_struct	*bt_task;
-	struct list_head	bt_list;
 	struct list_head	bt_delwrite_queue;
 	spinlock_t		bt_delwrite_lock;
 	unsigned long		bt_flags;
+
+	/* LRU control structures */
+	struct shrinker		bt_shrinker;
 } xfs_buftarg_t;
 
 /*
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
