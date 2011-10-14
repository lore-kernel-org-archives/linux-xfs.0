Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p9EIr6re043342 for <xfs@oss.sgi.com>; Fri, 14 Oct 2011 13:53:06 -0500
Message-Id: <20111014185301.154618605@bombadil.infradead.org>
Date: Fri, 14 Oct 2011 14:50:50 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 2/5] xfs: use a cursor for bulk AIL insertion
References: <20111014185048.893798829@bombadil.infradead.org>
Content-Disposition: inline; filename=backport2.diff
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
To: stable@kernel.org
Cc: Alex Elder <aelder@sgi.com>, Dave Chinner <dchinner@redhat.com>, xfs@oss.sgi.com

From: Dave Chinner <dchinner@redhat.com>

commit 1d8c95a363bf8cd4d4182dd19c01693b635311c2 upstream


xfs: use a cursor for bulk AIL insertion

Delayed logging can insert tens of thousands of log items into the
AIL at the same LSN. When the committing of log commit records
occur, we can get insertions occurring at an LSN that is not at the
end of the AIL. If there are thousands of items in the AIL on the
tail LSN, each insertion has to walk the AIL to find the correct
place to insert the new item into the AIL. This can consume large
amounts of CPU time and block other operations from occurring while
the traversals are in progress.

To avoid this repeated walk, use a AIL cursor to record
where we should be inserting the new items into the AIL without
having to repeat the walk. The cursor infrastructure already
provides this functionality for push walks, so is a simple extension
of existing code. While this will not avoid the initial walk, it
will avoid repeating it tens of thousands of times during a single
checkpoint commit.

This version includes logic improvements from Christoph Hellwig.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Alex Elder <aelder@sgi.com>

diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index c83f63b..efc147f 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -1426,6 +1426,7 @@ xfs_trans_committed(
 static inline void
 xfs_log_item_batch_insert(
 	struct xfs_ail		*ailp,
+	struct xfs_ail_cursor	*cur,
 	struct xfs_log_item	**log_items,
 	int			nr_items,
 	xfs_lsn_t		commit_lsn)
@@ -1434,7 +1435,7 @@ xfs_log_item_batch_insert(
 
 	spin_lock(&ailp->xa_lock);
 	/* xfs_trans_ail_update_bulk drops ailp->xa_lock */
-	xfs_trans_ail_update_bulk(ailp, log_items, nr_items, commit_lsn);
+	xfs_trans_ail_update_bulk(ailp, cur, log_items, nr_items, commit_lsn);
 
 	for (i = 0; i < nr_items; i++)
 		IOP_UNPIN(log_items[i], 0);
@@ -1452,6 +1453,13 @@ xfs_log_item_batch_insert(
  * as an iclog write error even though we haven't started any IO yet. Hence in
  * this case all we need to do is IOP_COMMITTED processing, followed by an
  * IOP_UNPIN(aborted) call.
+ *
+ * The AIL cursor is used to optimise the insert process. If commit_lsn is not
+ * at the end of the AIL, the insert cursor avoids the need to walk
+ * the AIL to find the insertion point on every xfs_log_item_batch_insert()
+ * call. This saves a lot of needless list walking and is a net win, even
+ * though it slightly increases that amount of AIL lock traffic to set it up
+ * and tear it down.
  */
 void
 xfs_trans_committed_bulk(
@@ -1463,8 +1471,13 @@ xfs_trans_committed_bulk(
 #define LOG_ITEM_BATCH_SIZE	32
 	struct xfs_log_item	*log_items[LOG_ITEM_BATCH_SIZE];
 	struct xfs_log_vec	*lv;
+	struct xfs_ail_cursor	cur;
 	int			i = 0;
 
+	spin_lock(&ailp->xa_lock);
+	xfs_trans_ail_cursor_last(ailp, &cur, commit_lsn);
+	spin_unlock(&ailp->xa_lock);
+
 	/* unpin all the log items */
 	for (lv = log_vector; lv; lv = lv->lv_next ) {
 		struct xfs_log_item	*lip = lv->lv_item;
@@ -1493,7 +1506,9 @@ xfs_trans_committed_bulk(
 			/*
 			 * Not a bulk update option due to unusual item_lsn.
 			 * Push into AIL immediately, rechecking the lsn once
-			 * we have the ail lock. Then unpin the item.
+			 * we have the ail lock. Then unpin the item. This does
+			 * not affect the AIL cursor the bulk insert path is
+			 * using.
 			 */
 			spin_lock(&ailp->xa_lock);
 			if (XFS_LSN_CMP(item_lsn, lip->li_lsn) > 0)
@@ -1507,7 +1522,7 @@ xfs_trans_committed_bulk(
 		/* Item is a candidate for bulk AIL insert.  */
 		log_items[i++] = lv->lv_item;
 		if (i >= LOG_ITEM_BATCH_SIZE) {
-			xfs_log_item_batch_insert(ailp, log_items,
+			xfs_log_item_batch_insert(ailp, &cur, log_items,
 					LOG_ITEM_BATCH_SIZE, commit_lsn);
 			i = 0;
 		}
@@ -1515,7 +1530,11 @@ xfs_trans_committed_bulk(
 
 	/* make sure we insert the remainder! */
 	if (i)
-		xfs_log_item_batch_insert(ailp, log_items, i, commit_lsn);
+		xfs_log_item_batch_insert(ailp, &cur, log_items, i, commit_lsn);
+
+	spin_lock(&ailp->xa_lock);
+	xfs_trans_ail_cursor_done(ailp, &cur);
+	spin_unlock(&ailp->xa_lock);
 }
 
 /*
diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
index 5fc2380..9a69dc0 100644
--- a/fs/xfs/xfs_trans_ail.c
+++ b/fs/xfs/xfs_trans_ail.c
@@ -272,9 +272,9 @@ xfs_trans_ail_cursor_clear(
 }
 
 /*
- * Return the item in the AIL with the current lsn.
- * Return the current tree generation number for use
- * in calls to xfs_trans_next_ail().
+ * Initialise the cursor to the first item in the AIL with the given @lsn.
+ * This searches the list from lowest LSN to highest. Pass a @lsn of zero
+ * to initialise the cursor to the first item in the AIL.
  */
 xfs_log_item_t *
 xfs_trans_ail_cursor_first(
@@ -300,31 +300,97 @@ out:
 }
 
 /*
- * splice the log item list into the AIL at the given LSN.
+ * Initialise the cursor to the last item in the AIL with the given @lsn.
+ * This searches the list from highest LSN to lowest. If there is no item with
+ * the value of @lsn, then it sets the cursor to the last item with an LSN lower
+ * than @lsn.
+ */
+static struct xfs_log_item *
+__xfs_trans_ail_cursor_last(
+	struct xfs_ail		*ailp,
+	xfs_lsn_t		lsn)
+{
+	xfs_log_item_t		*lip;
+
+	list_for_each_entry_reverse(lip, &ailp->xa_ail, li_ail) {
+		if (XFS_LSN_CMP(lip->li_lsn, lsn) <= 0)
+			return lip;
+	}
+	return NULL;
+}
+
+/*
+ * Initialise the cursor to the last item in the AIL with the given @lsn.
+ * This searches the list from highest LSN to lowest.
+ */
+struct xfs_log_item *
+xfs_trans_ail_cursor_last(
+	struct xfs_ail		*ailp,
+	struct xfs_ail_cursor	*cur,
+	xfs_lsn_t		lsn)
+{
+	xfs_trans_ail_cursor_init(ailp, cur);
+	cur->item = __xfs_trans_ail_cursor_last(ailp, lsn);
+	return cur->item;
+}
+
+/*
+ * splice the log item list into the AIL at the given LSN. We splice to the
+ * tail of the given LSN to maintain insert order for push traversals. The
+ * cursor is optional, allowing repeated updates to the same LSN to avoid
+ * repeated traversals.
  */
 static void
 xfs_ail_splice(
-	struct xfs_ail  *ailp,
-	struct list_head *list,
-	xfs_lsn_t       lsn)
+	struct xfs_ail		*ailp,
+	struct xfs_ail_cursor	*cur,
+	struct list_head	*list,
+	xfs_lsn_t		lsn)
 {
-	xfs_log_item_t  *next_lip;
+	struct xfs_log_item	*lip = cur ? cur->item : NULL;
+	struct xfs_log_item	*next_lip;
 
-	/* If the list is empty, just insert the item.  */
-	if (list_empty(&ailp->xa_ail)) {
-		list_splice(list, &ailp->xa_ail);
-		return;
+	/*
+	 * Get a new cursor if we don't have a placeholder or the existing one
+	 * has been invalidated.
+	 */
+	if (!lip || (__psint_t)lip & 1) {
+		lip = __xfs_trans_ail_cursor_last(ailp, lsn);
+
+		if (!lip) {
+			/* The list is empty, so just splice and return.  */
+			if (cur)
+				cur->item = NULL;
+			list_splice(list, &ailp->xa_ail);
+			return;
+		}
 	}
 
-	list_for_each_entry_reverse(next_lip, &ailp->xa_ail, li_ail) {
-		if (XFS_LSN_CMP(next_lip->li_lsn, lsn) <= 0)
-			break;
+	/*
+	 * Our cursor points to the item we want to insert _after_, so we have
+	 * to update the cursor to point to the end of the list we are splicing
+	 * in so that it points to the correct location for the next splice.
+	 * i.e. before the splice
+	 *
+	 *  lsn -> lsn -> lsn + x -> lsn + x ...
+	 *          ^
+	 *          | cursor points here
+	 *
+	 * After the splice we have:
+	 *
+	 *  lsn -> lsn -> lsn -> lsn -> .... -> lsn -> lsn + x -> lsn + x ...
+	 *          ^                            ^
+	 *          | cursor points here         | needs to move here
+	 *
+	 * So we set the cursor to the last item in the list to be spliced
+	 * before we execute the splice, resulting in the cursor pointing to
+	 * the correct item after the splice occurs.
+	 */
+	if (cur) {
+		next_lip = list_entry(list->prev, struct xfs_log_item, li_ail);
+		cur->item = next_lip;
 	}
-
-	ASSERT(&next_lip->li_ail == &ailp->xa_ail ||
-	       XFS_LSN_CMP(next_lip->li_lsn, lsn) <= 0);
-
-	list_splice_init(list, &next_lip->li_ail);
+	list_splice(list, &lip->li_ail);
 }
 
 /*
@@ -645,6 +711,7 @@ xfs_trans_unlocked_item(
 void
 xfs_trans_ail_update_bulk(
 	struct xfs_ail		*ailp,
+	struct xfs_ail_cursor	*cur,
 	struct xfs_log_item	**log_items,
 	int			nr_items,
 	xfs_lsn_t		lsn) __releases(ailp->xa_lock)
@@ -674,7 +741,7 @@ xfs_trans_ail_update_bulk(
 		list_add(&lip->li_ail, &tmp);
 	}
 
-	xfs_ail_splice(ailp, &tmp, lsn);
+	xfs_ail_splice(ailp, cur, &tmp, lsn);
 
 	if (!mlip_changed) {
 		spin_unlock(&ailp->xa_lock);
diff --git a/fs/xfs/xfs_trans_priv.h b/fs/xfs/xfs_trans_priv.h
index 6b164e9..c0cb408 100644
--- a/fs/xfs/xfs_trans_priv.h
+++ b/fs/xfs/xfs_trans_priv.h
@@ -82,6 +82,7 @@ struct xfs_ail {
 extern struct workqueue_struct	*xfs_ail_wq;	/* AIL workqueue */
 
 void	xfs_trans_ail_update_bulk(struct xfs_ail *ailp,
+				struct xfs_ail_cursor *cur,
 				struct xfs_log_item **log_items, int nr_items,
 				xfs_lsn_t lsn) __releases(ailp->xa_lock);
 static inline void
@@ -90,7 +91,7 @@ xfs_trans_ail_update(
 	struct xfs_log_item	*lip,
 	xfs_lsn_t		lsn) __releases(ailp->xa_lock)
 {
-	xfs_trans_ail_update_bulk(ailp, &lip, 1, lsn);
+	xfs_trans_ail_update_bulk(ailp, NULL, &lip, 1, lsn);
 }
 
 void	xfs_trans_ail_delete_bulk(struct xfs_ail *ailp,
@@ -111,10 +112,13 @@ xfs_lsn_t		xfs_ail_min_lsn(struct xfs_ail *ailp);
 void			xfs_trans_unlocked_item(struct xfs_ail *,
 					xfs_log_item_t *);
 
-struct xfs_log_item	*xfs_trans_ail_cursor_first(struct xfs_ail *ailp,
+struct xfs_log_item *	xfs_trans_ail_cursor_first(struct xfs_ail *ailp,
 					struct xfs_ail_cursor *cur,
 					xfs_lsn_t lsn);
-struct xfs_log_item	*xfs_trans_ail_cursor_next(struct xfs_ail *ailp,
+struct xfs_log_item *	xfs_trans_ail_cursor_last(struct xfs_ail *ailp,
+					struct xfs_ail_cursor *cur,
+					xfs_lsn_t lsn);
+struct xfs_log_item *	xfs_trans_ail_cursor_next(struct xfs_ail *ailp,
 					struct xfs_ail_cursor *cur);
 void			xfs_trans_ail_cursor_done(struct xfs_ail *ailp,
 					struct xfs_ail_cursor *cur);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
