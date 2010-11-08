Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oA88sr9J089531 for <xfs@oss.sgi.com>; Mon, 8 Nov 2010 02:54:54 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A20E715F7AD
	for <xfs@oss.sgi.com>; Mon,  8 Nov 2010 00:56:19 -0800 (PST)
Received: from mail.internode.on.net (bld-mail16.adl2.internode.on.net
	[150.101.137.101]) by cuda.sgi.com with ESMTP id
	4AO3hDFEqj2MufTN for <xfs@oss.sgi.com>;
	Mon, 08 Nov 2010 00:56:19 -0800 (PST)
Received: from dastard (unverified [121.44.100.105])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	45631758-1927428
	for <xfs@oss.sgi.com>; Mon, 08 Nov 2010 19:26:18 +1030 (CDT)
Received: from chute ([192.168.1.1] helo=disappointment)
	by dastard with esmtp (Exim 4.71)
	(envelope-from <dave@fromorbit.com>) id 1PFNWS-0001Cq-Qv
	for xfs@oss.sgi.com; Mon, 08 Nov 2010 19:56:16 +1100
Received: from dave by disappointment with local (Exim 4.72)
	(envelope-from <dave@disappointment.disaster>) id 1PFNVk-0004ng-W0
	for xfs@oss.sgi.com; Mon, 08 Nov 2010 19:55:32 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 09/16] xfs: convert xfsbud shrinker to a per-buftarg shrinker.
Date: Mon,  8 Nov 2010 19:55:12 +1100
Message-Id: <1289206519-18377-10-git-send-email-david@fromorbit.com>
In-Reply-To: <1289206519-18377-1-git-send-email-david@fromorbit.com>
References: <1289206519-18377-1-git-send-email-david@fromorbit.com>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Alex Elder <aelder@sgi.com>
---
 fs/xfs/linux-2.6/xfs_buf.c |   89 ++++++++++++--------------------------------
 fs/xfs/linux-2.6/xfs_buf.h |    4 +-
 2 files changed, 27 insertions(+), 66 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_buf.c b/fs/xfs/linux-2.6/xfs_buf.c
index aa1d353..f21803b 100644
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
@@ -1464,28 +1458,23 @@ xfs_wait_buftarg(
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
@@ -1493,17 +1482,14 @@ xfs_free_buftarg(
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
 
@@ -1600,20 +1586,13 @@ xfs_alloc_delwrite_queue(
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
@@ -1636,6 +1615,9 @@ xfs_alloc_buftarg(
 		goto error;
 	if (xfs_alloc_delwrite_queue(btp, fsname))
 		goto error;
+	btp->bt_shrinker.shrink = xfs_buftarg_shrink;
+	btp->bt_shrinker.seeks = DEFAULT_SEEKS;
+	register_shrinker(&btp->bt_shrinker);
 	return btp;
 
 error:
@@ -1740,27 +1722,6 @@ xfs_buf_runall_queues(
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
@@ -1955,7 +1916,6 @@ xfs_buf_init(void)
 	if (!xfsconvertd_workqueue)
 		goto out_destroy_xfsdatad_workqueue;
 
-	register_shrinker(&xfs_buf_shake);
 	return 0;
 
  out_destroy_xfsdatad_workqueue:
@@ -1971,7 +1931,6 @@ xfs_buf_init(void)
 void
 xfs_buf_terminate(void)
 {
-	unregister_shrinker(&xfs_buf_shake);
 	destroy_workqueue(xfsconvertd_workqueue);
 	destroy_workqueue(xfsdatad_workqueue);
 	destroy_workqueue(xfslogd_workqueue);
diff --git a/fs/xfs/linux-2.6/xfs_buf.h b/fs/xfs/linux-2.6/xfs_buf.h
index 383a3f3..9344103 100644
--- a/fs/xfs/linux-2.6/xfs_buf.h
+++ b/fs/xfs/linux-2.6/xfs_buf.h
@@ -128,10 +128,12 @@ typedef struct xfs_buftarg {
 
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
1.7.2.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
