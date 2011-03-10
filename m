Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p2A03kVs068888 for <xfs@oss.sgi.com>; Wed, 9 Mar 2011 18:03:51 -0600
Received: from ipmail07.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 741D110B7DC6
	for <xfs@oss.sgi.com>; Wed,  9 Mar 2011 16:06:24 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	kuT5RophBMPqB9w4 for <xfs@oss.sgi.com>;
	Wed, 09 Mar 2011 16:06:24 -0800 (PST)
Received: from chute ([192.168.1.1] helo=disappointment)
	by dastard with esmtp (Exim 4.72)
	(envelope-from <dave@fromorbit.com>) id 1PxTNd-0002vd-76
	for xfs@oss.sgi.com; Thu, 10 Mar 2011 11:05:25 +1100
Received: from dave by disappointment with local (Exim 4.72)
	(envelope-from <dave@disappointment.disaster>) id 1PxTNl-0002tI-3D
	for xfs@oss.sgi.com; Thu, 10 Mar 2011 11:05:33 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 6/6] xfs: push the AIL from memory reclaim and periodic sync
Date: Thu, 10 Mar 2011 11:05:29 +1100
Message-Id: <1299715529-11026-7-git-send-email-david@fromorbit.com>
In-Reply-To: <1299715529-11026-1-git-send-email-david@fromorbit.com>
References: <1299715529-11026-1-git-send-email-david@fromorbit.com>
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

When we are short on memory, we want to expedite the cleaning of
dirty objects.  Hence when we run short on memory, we need to kick
the AIL flushing into action to clean as many dirty objects as
quickly as possible.  To implement this, sample the lsn of the log
item at the head of the AIL and use that as the push target for the
AIL flush.

Further, we keep items in the AIL that are dirty that are not
tracked any other way, so we can get objects sitting in the AIL that
don't get written back until the AIL is pushed. Hence to get the
filesystem to the idle state, we might need to push the AIL to flush
out any remaining dirty objects sitting in the AIL. This requires
the same push mechanism as the reclaim push.

This patch rearranges the location of functions in xfs_trans_ail.c
to remove the need for forward declarations of those functions and
new functions added in this commit.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/linux-2.6/xfs_sync.c |    7 ++-
 fs/xfs/xfs_trans_ail.c      |  206 +++++++++++++++++++++++++------------------
 fs/xfs/xfs_trans_priv.h     |    1 +
 3 files changed, 129 insertions(+), 85 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_sync.c b/fs/xfs/linux-2.6/xfs_sync.c
index 3f39d83..7ab79671 100644
--- a/fs/xfs/linux-2.6/xfs_sync.c
+++ b/fs/xfs/linux-2.6/xfs_sync.c
@@ -22,6 +22,7 @@
 #include "xfs_log.h"
 #include "xfs_inum.h"
 #include "xfs_trans.h"
+#include "xfs_trans_priv.h"
 #include "xfs_sb.h"
 #include "xfs_ag.h"
 #include "xfs_mount.h"
@@ -463,6 +464,9 @@ xfs_sync_worker(
 			xfs_log_force(mp, 0);
 		xfs_reclaim_inodes(mp, 0);
 		error = xfs_qm_sync(mp, SYNC_TRYLOCK);
+
+		/* start pushing all the metadata that is currently dirty */
+		xfs_trans_ail_push_all(mp->m_ail);
 	}
 
 	/* queue us up again */
@@ -1017,8 +1021,9 @@ xfs_reclaim_inode_shrink(
 
 	mp = container_of(shrink, struct xfs_mount, m_inode_shrink);
 	if (nr_to_scan) {
-		/* kick background reclaimer */
+		/* kick background reclaimer and push the AIL */
 		xfs_syncd_queue_reclaim(mp);
+		xfs_trans_ail_push_all(mp->m_ail);
 
 		if (!(gfp_mask & __GFP_FS))
 			return -1;
diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
index 8b68679..62da328 100644
--- a/fs/xfs/xfs_trans_ail.c
+++ b/fs/xfs/xfs_trans_ail.c
@@ -30,17 +30,55 @@
 
 struct workqueue_struct	*xfs_ail_wq;	/* AIL workqueue */
 
-STATIC void xfs_ail_splice(struct xfs_ail *, struct list_head *, xfs_lsn_t);
-STATIC void xfs_ail_delete(struct xfs_ail *, xfs_log_item_t *);
-STATIC xfs_log_item_t * xfs_ail_min(struct xfs_ail *);
-STATIC xfs_log_item_t * xfs_ail_next(struct xfs_ail *, xfs_log_item_t *);
-
 #ifdef DEBUG
 STATIC void xfs_ail_check(struct xfs_ail *, xfs_log_item_t *);
 #else
 #define	xfs_ail_check(a,l)
 #endif /* DEBUG */
 
+/*
+ * Return a pointer to the first item in the AIL.
+ * If the AIL is empty, then return NULL.
+ */
+static xfs_log_item_t *
+xfs_ail_min(
+	struct xfs_ail  *ailp)
+{
+	if (list_empty(&ailp->xa_ail))
+		return NULL;
+
+	return list_first_entry(&ailp->xa_ail, xfs_log_item_t, li_ail);
+}
+
+/*
+ * Return a pointer to the last item in the AIL.
+ * If the AIL is empty, then return NULL.
+ */
+static xfs_log_item_t *
+xfs_ail_max(
+	struct xfs_ail  *ailp)
+{
+	if (list_empty(&ailp->xa_ail))
+		return NULL;
+
+	return list_entry(ailp->xa_ail.prev, xfs_log_item_t, li_ail);
+}
+
+/*
+ * Return a pointer to the item which follows
+ * the given item in the AIL.  If the given item
+ * is the last item in the list, then return NULL.
+ */
+static xfs_log_item_t *
+xfs_ail_next(
+	struct xfs_ail  *ailp,
+	xfs_log_item_t  *lip)
+{
+	if (lip->li_ail.next == &ailp->xa_ail)
+		return NULL;
+
+	return list_first_entry(&lip->li_ail, xfs_log_item_t, li_ail);
+}
 
 /*
  * This is called by the log manager code to determine the LSN
@@ -55,16 +93,32 @@ xfs_lsn_t
 xfs_trans_ail_tail(
 	struct xfs_ail	*ailp)
 {
-	xfs_lsn_t	lsn;
+	xfs_lsn_t	lsn = 0;
 	xfs_log_item_t	*lip;
 
 	spin_lock(&ailp->xa_lock);
 	lip = xfs_ail_min(ailp);
-	if (lip == NULL) {
-		lsn = (xfs_lsn_t)0;
-	} else {
+	if (lip)
+		lsn = lip->li_lsn;
+	spin_unlock(&ailp->xa_lock);
+
+	return lsn;
+}
+
+/*
+ * Return the maximum lsn held in the AIL, or zero if the AIl is empty.
+ */
+static xfs_lsn_t
+xfs_ail_max_lsn(
+	struct xfs_ail  *ailp)
+{
+	xfs_lsn_t       lsn = 0;
+	xfs_log_item_t  *lip;
+
+	spin_lock(&ailp->xa_lock);
+	lip = xfs_ail_max(ailp);
+	if (lip)
 		lsn = lip->li_lsn;
-	}
 	spin_unlock(&ailp->xa_lock);
 
 	return lsn;
@@ -208,6 +262,50 @@ out:
 }
 
 /*
+ * splice the log item list into the AIL at the given LSN.
+ */
+static void
+xfs_ail_splice(
+	struct xfs_ail  *ailp,
+	struct list_head *list,
+	xfs_lsn_t       lsn)
+{
+	xfs_log_item_t  *next_lip;
+
+	/*
+	 * If the list is empty, just insert the item.
+	 */
+	if (list_empty(&ailp->xa_ail)) {
+		list_splice(list, &ailp->xa_ail);
+		return;
+	}
+
+	list_for_each_entry_reverse(next_lip, &ailp->xa_ail, li_ail) {
+		if (XFS_LSN_CMP(next_lip->li_lsn, lsn) <= 0)
+			break;
+	}
+
+	ASSERT((&next_lip->li_ail == &ailp->xa_ail) ||
+	       (XFS_LSN_CMP(next_lip->li_lsn, lsn) <= 0));
+
+	list_splice_init(list, &next_lip->li_ail);
+	return;
+}
+
+/*
+ * Delete the given item from the AIL.  Return a pointer to the item.
+ */
+static void
+xfs_ail_delete(
+	struct xfs_ail  *ailp,
+	xfs_log_item_t  *lip)
+{
+	xfs_ail_check(ailp, lip);
+	list_del(&lip->li_ail);
+	xfs_trans_ail_cursor_clear(ailp, lip);
+}
+
+/*
  * xfs_ail_worker does the work of pushing on the AIL. It will requeue itself
  * to run at a later time if there is more work to do to complete the push.
  */
@@ -431,6 +529,20 @@ xfs_trans_ail_push(
 }
 
 /*
+ * similar to xfs_trans_push_ail(), except we are trying to push out all items
+ * in the AIL immediately
+ */
+void
+xfs_trans_ail_push_all(
+	struct xfs_ail  *ailp)
+{
+	xfs_lsn_t       threshold_lsn = xfs_ail_max_lsn(ailp);
+
+	if (threshold_lsn && !XFS_FORCED_SHUTDOWN(ailp->xa_mount))
+		xfs_ail_push_queue(ailp, threshold_lsn, 0);
+}
+
+/*
  * This is to be called when an item is unlocked that may have
  * been in the AIL.  It will wake up the first member of the AIL
  * wait list if this item's unlocking might allow it to progress.
@@ -663,80 +775,6 @@ xfs_trans_ail_destroy(
 	kmem_free(ailp);
 }
 
-/*
- * splice the log item list into the AIL at the given LSN.
- */
-STATIC void
-xfs_ail_splice(
-	struct xfs_ail	*ailp,
-	struct list_head *list,
-	xfs_lsn_t	lsn)
-{
-	xfs_log_item_t	*next_lip;
-
-	/*
-	 * If the list is empty, just insert the item.
-	 */
-	if (list_empty(&ailp->xa_ail)) {
-		list_splice(list, &ailp->xa_ail);
-		return;
-	}
-
-	list_for_each_entry_reverse(next_lip, &ailp->xa_ail, li_ail) {
-		if (XFS_LSN_CMP(next_lip->li_lsn, lsn) <= 0)
-			break;
-	}
-
-	ASSERT((&next_lip->li_ail == &ailp->xa_ail) ||
-	       (XFS_LSN_CMP(next_lip->li_lsn, lsn) <= 0));
-
-	list_splice_init(list, &next_lip->li_ail);
-	return;
-}
-
-/*
- * Delete the given item from the AIL.  Return a pointer to the item.
- */
-STATIC void
-xfs_ail_delete(
-	struct xfs_ail	*ailp,
-	xfs_log_item_t	*lip)
-{
-	xfs_ail_check(ailp, lip);
-	list_del(&lip->li_ail);
-	xfs_trans_ail_cursor_clear(ailp, lip);
-}
-
-/*
- * Return a pointer to the first item in the AIL.
- * If the AIL is empty, then return NULL.
- */
-STATIC xfs_log_item_t *
-xfs_ail_min(
-	struct xfs_ail	*ailp)
-{
-	if (list_empty(&ailp->xa_ail))
-		return NULL;
-
-	return list_first_entry(&ailp->xa_ail, xfs_log_item_t, li_ail);
-}
-
-/*
- * Return a pointer to the item which follows
- * the given item in the AIL.  If the given item
- * is the last item in the list, then return NULL.
- */
-STATIC xfs_log_item_t *
-xfs_ail_next(
-	struct xfs_ail	*ailp,
-	xfs_log_item_t	*lip)
-{
-	if (lip->li_ail.next == &ailp->xa_ail)
-		return NULL;
-
-	return list_first_entry(&lip->li_ail, xfs_log_item_t, li_ail);
-}
-
 #ifdef DEBUG
 /*
  * Check that the list is sorted as it should be.
diff --git a/fs/xfs/xfs_trans_priv.h b/fs/xfs/xfs_trans_priv.h
index 2410da4..dbd93e6 100644
--- a/fs/xfs/xfs_trans_priv.h
+++ b/fs/xfs/xfs_trans_priv.h
@@ -103,6 +103,7 @@ xfs_trans_ail_delete(
 }
 
 void			xfs_trans_ail_push(struct xfs_ail *, xfs_lsn_t);
+void			xfs_trans_ail_push_all(struct xfs_ail *);
 void			xfs_trans_unlocked_item(struct xfs_ail *,
 					xfs_log_item_t *);
 
-- 
1.7.2.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
