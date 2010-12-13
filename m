Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oBD4WL1i158232 for <xfs@oss.sgi.com>; Sun, 12 Dec 2010 22:32:22 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 367531E2D06
	for <xfs@oss.sgi.com>; Sun, 12 Dec 2010 20:34:11 -0800 (PST)
Received: from mail.internode.on.net (bld-mail20.adl6.internode.on.net
	[150.101.137.105]) by cuda.sgi.com with ESMTP id
	KZ7VxVosiz2iRfYg for <xfs@oss.sgi.com>;
	Sun, 12 Dec 2010 20:34:11 -0800 (PST)
Received: from dastard (unverified [121.44.88.148])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	4435327-1927428
	for <xfs@oss.sgi.com>; Mon, 13 Dec 2010 15:04:11 +1030 (CDT)
Received: from chute ([192.168.1.1] helo=disappointment)
	by dastard with esmtp (Exim 4.72)
	(envelope-from <dave@fromorbit.com>) id 1PS06z-000214-La
	for xfs@oss.sgi.com; Mon, 13 Dec 2010 15:34:09 +1100
Received: from dave by disappointment with local (Exim 4.72)
	(envelope-from <dave@disappointment.disaster>) id 1PS05L-0004iV-JI
	for xfs@oss.sgi.com; Mon, 13 Dec 2010 15:32:27 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 4/9] xfs: bulk AIL insertion during transaction commit
Date: Mon, 13 Dec 2010 15:32:18 +1100
Message-Id: <1292214743-18073-5-git-send-email-david@fromorbit.com>
In-Reply-To: <1292214743-18073-1-git-send-email-david@fromorbit.com>
References: <1292214743-18073-1-git-send-email-david@fromorbit.com>
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

When inserting items into the AIL from the transaction committed
callbacks, we take the AIL lock for every single item that is to be
inserted. For a CIL checkpoint commit, this can be tens of thousands
of individual inserts, yet almost all of the items will be inserted
at the same point in the AIL because they have the same index.

To reduce the overhead and contention on the AIL lock for such
operations, introduce a "bulk insert" operation which allows a list
of log items with the same LSN to be inserted in a single operation
via a list splice. To do this, we need to pre-sort the log items
being committed into a temporary list for insertion.

The complexity is that not every log item will end up with the same
LSN, and not every item is actually inserted into the AIL. Items
that don't match the commit LSN will be inserted and unpinned as per
the current one-at-a-time method (relatively rare), while items that
are not to be inserted will be unpinned and freed immediately. Items
that are to be inserted at the given commit lsn are placed in a
temporary array and inserted into the AIL in bulk each time the
array fills up.

As a result of this, we trade off AIL hold time for a significant
reduction in traffic. lock_stat output shows that the worst case
hold time is unchanged, but contention from AIL inserts drops by an
order of magnitude and the number of lock traversal decreases
significantly.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_log_cil.c    |    9 +---
 fs/xfs/xfs_trans.c      |   80 +++++++++++++++++++++++++++++++++++-
 fs/xfs/xfs_trans_ail.c  |  105 +++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_trans_priv.h |   10 ++++-
 4 files changed, 194 insertions(+), 10 deletions(-)

diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index 23d6ceb..f36f1a2 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -361,15 +361,10 @@ xlog_cil_committed(
 	int	abort)
 {
 	struct xfs_cil_ctx	*ctx = args;
-	struct xfs_log_vec	*lv;
-	int			abortflag = abort ? XFS_LI_ABORTED : 0;
 	struct xfs_busy_extent	*busyp, *n;
 
-	/* unpin all the log items */
-	for (lv = ctx->lv_chain; lv; lv = lv->lv_next ) {
-		xfs_trans_item_committed(lv->lv_item, ctx->start_lsn,
-							abortflag);
-	}
+	xfs_trans_committed_bulk(ctx->cil->xc_log->l_ailp, ctx->lv_chain,
+					ctx->start_lsn, abort);
 
 	list_for_each_entry_safe(busyp, n, &ctx->busy_extents, list)
 		xfs_alloc_busy_clear(ctx->cil->xc_log->l_mp, busyp);
diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index 8139a2e..b0fff07 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -1347,7 +1347,7 @@ xfs_trans_fill_vecs(
  * they could be immediately flushed and we'd have to race with the flusher
  * trying to pull the item from the AIL as we add it.
  */
-void
+static void
 xfs_trans_item_committed(
 	struct xfs_log_item	*lip,
 	xfs_lsn_t		commit_lsn,
@@ -1422,6 +1422,84 @@ xfs_trans_committed(
 	xfs_trans_free(tp);
 }
 
+static inline void
+xfs_log_item_batch_insert(
+	struct xfs_ail		*ailp,
+	struct xfs_log_item	**log_items,
+	int			nr_items,
+	xfs_lsn_t		commit_lsn)
+{
+	int	i;
+
+	spin_lock(&ailp->xa_lock);
+	/* xfs_trans_ail_update_bulk drops ailp->xa_lock */
+	xfs_trans_ail_update_bulk(ailp, log_items, nr_items, commit_lsn);
+
+	for (i = 0; i < nr_items; i++)
+		IOP_UNPIN(log_items[i], 0);
+}
+
+/*
+ * Bulk operation version of xfs_trans_committed that takes a log vector of
+ * items to insert into the AIL. This uses bulk AIL insertion techniques to
+ * minimise lock traffic.
+ */
+void
+xfs_trans_committed_bulk(
+	struct xfs_ail		*ailp,
+	struct xfs_log_vec	*log_vector,
+	xfs_lsn_t		commit_lsn,
+	int			aborted)
+{
+#define LOG_ITEM_BATCH_SIZE	32
+	struct xfs_log_item	*log_items[LOG_ITEM_BATCH_SIZE];
+	struct xfs_log_vec	*lv;
+	int			i = 0;
+
+	/* unpin all the log items */
+	for (lv = log_vector; lv; lv = lv->lv_next ) {
+		struct xfs_log_item	*lip = lv->lv_item;
+		xfs_lsn_t		item_lsn;
+
+		if (aborted)
+			lip->li_flags |= XFS_LI_ABORTED;
+		item_lsn = IOP_COMMITTED(lip, commit_lsn);
+
+		/* item_lsn of -1 means the item was freed */
+		if (XFS_LSN_CMP(item_lsn, (xfs_lsn_t)-1) == 0)
+			continue;
+
+		if (item_lsn != commit_lsn) {
+
+			/*
+			 * Not a bulk update option due to unusual item_lsn.
+			 * Push into AIL immediately, rechecking the lsn once
+			 * we have the ail lock. Then unpin the item.
+			 */
+			spin_lock(&ailp->xa_lock);
+			if (XFS_LSN_CMP(item_lsn, lip->li_lsn) > 0) {
+				xfs_trans_ail_update(ailp, lip, item_lsn);
+			} else {
+				spin_unlock(&ailp->xa_lock);
+			}
+			IOP_UNPIN(lip, 0);
+			continue;
+		}
+
+		/* Item is a candidate for bulk AIL insert.  */
+		log_items[i++] = lv->lv_item;
+		if (i >= LOG_ITEM_BATCH_SIZE) {
+			xfs_log_item_batch_insert(ailp, log_items,
+					LOG_ITEM_BATCH_SIZE, commit_lsn);
+			i = 0;
+		}
+	}
+
+	/* make sure we insert the remainder! */
+	if (i)
+		xfs_log_item_batch_insert(ailp, log_items, i, commit_lsn);
+}
+
 /*
  * Called from the trans_commit code when we notice that
  * the filesystem is in the middle of a forced shutdown.
diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
index 645928c..726785f 100644
--- a/fs/xfs/xfs_trans_ail.c
+++ b/fs/xfs/xfs_trans_ail.c
@@ -29,6 +29,7 @@
 #include "xfs_error.h"
 
 STATIC void xfs_ail_insert(struct xfs_ail *, xfs_log_item_t *);
+STATIC void xfs_ail_splice(struct xfs_ail *, struct list_head *, xfs_lsn_t);
 STATIC void xfs_ail_delete(struct xfs_ail *, xfs_log_item_t *);
 STATIC xfs_log_item_t * xfs_ail_min(struct xfs_ail *);
 STATIC xfs_log_item_t * xfs_ail_next(struct xfs_ail *, xfs_log_item_t *);
@@ -502,6 +503,79 @@ xfs_trans_ail_update(
 }	/* xfs_trans_update_ail */
 
 /*
+ * xfs_trans_ail_update - bulk AIL insertion operation.
+ *
+ * @xfs_trans_ail_update takes an array of log items that all need to be
+ * positioned at the same LSN in the AIL. If an item is not in the AIL, it will
+ * be added.  Otherwise, it will be repositioned  by removing it and re-adding
+ * it to the AIL. If we move the first item in the AIL, update the log tail to
+ * match the new minimum LSN in the AIL.
+ *
+ * This function takes the AIL lock once to execute the update operations on
+ * all the items in the array, and as such should not be called with the AIL
+ * lock held. As a result, once we have the AIL lock, we need to check each log
+ * item LSN to confirm it needs to be moved forward in the AIL.
+ *
+ * To optimise the insert operation, we delete all the items from the AIL in
+ * the first pass, moving them into a temporary list, then splice the temporary
+ * list into the correct position in the AIL. This avoids needing to do an
+ * insert operation on every item.
+ *
+ * This function must be called with the AIL lock held.  The lock is dropped
+ * before returning.
+ */
+void
+xfs_trans_ail_update_bulk(
+	struct xfs_ail		*ailp,
+	struct xfs_log_item	**log_items,
+	int			nr_items,
+	xfs_lsn_t		lsn) __releases(ailp->xa_lock)
+{
+	xfs_log_item_t		*mlip;
+	xfs_lsn_t		tail_lsn;
+	int			mlip_changed = 0;
+	int			i;
+	LIST_HEAD(tmp);
+
+	mlip = xfs_ail_min(ailp);
+
+	for (i = 0; i < nr_items; i++) {
+		struct xfs_log_item *lip = log_items[i];
+		if (lip->li_flags & XFS_LI_IN_AIL) {
+			/* check if we really need to move the item */
+			if (XFS_LSN_CMP(lsn, lip->li_lsn) <= 0)
+				continue;
+
+			xfs_ail_delete(ailp, lip);
+			if (mlip == lip)
+				mlip_changed = 1;
+		} else {
+			lip->li_flags |= XFS_LI_IN_AIL;
+		}
+		lip->li_lsn = lsn;
+		list_add(&lip->li_ail, &tmp);
+	}
+
+	xfs_ail_splice(ailp, &tmp, lsn);
+
+	if (!mlip_changed) {
+		spin_unlock(&ailp->xa_lock);
+		return;
+	}
+
+	/*
+	 * It is not safe to access mlip after the AIL lock is dropped, so we
+	 * must get a copy of li_lsn before we do so.  This is especially
+	 * important on 32-bit platforms where accessing and updating 64-bit
+	 * values like li_lsn is not atomic.
+	 */
+	mlip = xfs_ail_min(ailp);
+	tail_lsn = mlip->li_lsn;
+	spin_unlock(&ailp->xa_lock);
+	xfs_log_move_tail(ailp->xa_mount, tail_lsn);
+}
+
+/*
  * Delete the given item from the AIL.  It must already be in
  * the AIL.
  *
@@ -652,6 +726,37 @@ xfs_ail_insert(
 }
 
 /*
+ * splice the log item list into the AIL at the given LSN.
+ */
+STATIC void
+xfs_ail_splice(
+	struct xfs_ail	*ailp,
+	struct list_head *list,
+	xfs_lsn_t	lsn)
+{
+	xfs_log_item_t	*next_lip;
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
  * Delete the given item from the AIL.  Return a pointer to the item.
  */
 STATIC void
diff --git a/fs/xfs/xfs_trans_priv.h b/fs/xfs/xfs_trans_priv.h
index 62da86c..e039729 100644
--- a/fs/xfs/xfs_trans_priv.h
+++ b/fs/xfs/xfs_trans_priv.h
@@ -22,15 +22,17 @@ struct xfs_log_item;
 struct xfs_log_item_desc;
 struct xfs_mount;
 struct xfs_trans;
+struct xfs_ail;
+struct xfs_log_vec;
 
 void	xfs_trans_add_item(struct xfs_trans *, struct xfs_log_item *);
 void	xfs_trans_del_item(struct xfs_log_item *);
 void	xfs_trans_free_items(struct xfs_trans *tp, xfs_lsn_t commit_lsn,
 				int flags);
-void	xfs_trans_item_committed(struct xfs_log_item *lip,
-				xfs_lsn_t commit_lsn, int aborted);
 void	xfs_trans_unreserve_and_mod_sb(struct xfs_trans *tp);
 
+void	xfs_trans_committed_bulk(struct xfs_ail *ailp, struct xfs_log_vec *lv,
+				xfs_lsn_t commit_lsn, int aborted);
 /*
  * AIL traversal cursor.
  *
@@ -76,6 +78,10 @@ struct xfs_ail {
 void			xfs_trans_ail_update(struct xfs_ail *ailp,
 					struct xfs_log_item *lip, xfs_lsn_t lsn)
 					__releases(ailp->xa_lock);
+void			 xfs_trans_ail_update_bulk(struct xfs_ail *ailp,
+					struct xfs_log_item **log_items,
+					int nr_items, xfs_lsn_t lsn)
+					__releases(ailp->xa_lock);
 void			xfs_trans_ail_delete(struct xfs_ail *ailp,
 					struct xfs_log_item *lip)
 					__releases(ailp->xa_lock);
-- 
1.7.2.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
