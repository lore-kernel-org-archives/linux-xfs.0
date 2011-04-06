Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with SMTP id
	p366Gggn019763 for <xfs@oss.sgi.com>; Wed, 6 Apr 2011 01:16:42 -0500
Received: from ipmail06.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 79895148766C
	for <xfs@oss.sgi.com>; Tue,  5 Apr 2011 23:19:33 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	nLBiSWyREI8vVskm for <xfs@oss.sgi.com>;
	Tue, 05 Apr 2011 23:19:33 -0700 (PDT)
Received: from chute ([192.168.1.1] helo=disappointment)
	by dastard with esmtp (Exim 4.72)
	(envelope-from <dave@fromorbit.com>) id 1Q7M5H-00040W-04
	for xfs@oss.sgi.com; Wed, 06 Apr 2011 16:19:19 +1000
Received: from dave by disappointment with local (Exim 4.72)
	(envelope-from <dave@disappointment.disaster>) id 1Q7M5I-0004WR-Q4
	for xfs@oss.sgi.com; Wed, 06 Apr 2011 16:19:20 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 6/9] xfs: clean up code layout in xfs_trans_ail.c
Date: Wed,  6 Apr 2011 16:19:15 +1000
Message-Id: <1302070758-17312-7-git-send-email-david@fromorbit.com>
In-Reply-To: <1302070758-17312-1-git-send-email-david@fromorbit.com>
References: <1302070758-17312-1-git-send-email-david@fromorbit.com>
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

This patch rearranges the location of functions in xfs_trans_ail.c
to remove the need for forward declarations of those functions in
preparation for adding new functions without the need for forward
declarations.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_trans_ail.c |  247 +++++++++++++++++++++++-------------------------
 1 files changed, 117 insertions(+), 130 deletions(-)

diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
index b252009..cfbb6c6 100644
--- a/fs/xfs/xfs_trans_ail.c
+++ b/fs/xfs/xfs_trans_ail.c
@@ -30,17 +30,81 @@
 
 struct workqueue_struct	*xfs_ail_wq;	/* AIL workqueue */
 
-STATIC void xfs_ail_splice(struct xfs_ail *, struct list_head *, xfs_lsn_t);
-STATIC void xfs_ail_delete(struct xfs_ail *, xfs_log_item_t *);
-STATIC xfs_log_item_t * xfs_ail_min(struct xfs_ail *);
-STATIC xfs_log_item_t * xfs_ail_next(struct xfs_ail *, xfs_log_item_t *);
-
 #ifdef DEBUG
-STATIC void xfs_ail_check(struct xfs_ail *, xfs_log_item_t *);
-#else
+/*
+ * Check that the list is sorted as it should be.
+ */
+STATIC void
+xfs_ail_check(
+	struct xfs_ail	*ailp,
+	xfs_log_item_t	*lip)
+{
+	xfs_log_item_t	*prev_lip;
+
+	if (list_empty(&ailp->xa_ail))
+		return;
+
+	/*
+	 * Check the next and previous entries are valid.
+	 */
+	ASSERT((lip->li_flags & XFS_LI_IN_AIL) != 0);
+	prev_lip = list_entry(lip->li_ail.prev, xfs_log_item_t, li_ail);
+	if (&prev_lip->li_ail != &ailp->xa_ail)
+		ASSERT(XFS_LSN_CMP(prev_lip->li_lsn, lip->li_lsn) <= 0);
+
+	prev_lip = list_entry(lip->li_ail.next, xfs_log_item_t, li_ail);
+	if (&prev_lip->li_ail != &ailp->xa_ail)
+		ASSERT(XFS_LSN_CMP(prev_lip->li_lsn, lip->li_lsn) >= 0);
+
+
+#ifdef XFS_TRANS_DEBUG
+	/*
+	 * Walk the list checking lsn ordering, and that every entry has the
+	 * XFS_LI_IN_AIL flag set. This is really expensive, so only do it
+	 * when specifically debugging the transaction subsystem.
+	 */
+	prev_lip = list_entry(&ailp->xa_ail, xfs_log_item_t, li_ail);
+	list_for_each_entry(lip, &ailp->xa_ail, li_ail) {
+		if (&prev_lip->li_ail != &ailp->xa_ail)
+			ASSERT(XFS_LSN_CMP(prev_lip->li_lsn, lip->li_lsn) <= 0);
+		ASSERT((lip->li_flags & XFS_LI_IN_AIL) != 0);
+		prev_lip = lip;
+	}
+#endif /* XFS_TRANS_DEBUG */
+}
+#else /* !DEBUG */
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
@@ -55,16 +119,13 @@ xfs_lsn_t
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
 		lsn = lip->li_lsn;
-	}
 	spin_unlock(&ailp->xa_lock);
 
 	return lsn;
@@ -208,6 +269,50 @@ out:
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
@@ -663,121 +768,3 @@ xfs_trans_ail_destroy(
 	cancel_delayed_work_sync(&ailp->xa_work);
 	kmem_free(ailp);
 }
-
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
-#ifdef DEBUG
-/*
- * Check that the list is sorted as it should be.
- */
-STATIC void
-xfs_ail_check(
-	struct xfs_ail	*ailp,
-	xfs_log_item_t	*lip)
-{
-	xfs_log_item_t	*prev_lip;
-
-	if (list_empty(&ailp->xa_ail))
-		return;
-
-	/*
-	 * Check the next and previous entries are valid.
-	 */
-	ASSERT((lip->li_flags & XFS_LI_IN_AIL) != 0);
-	prev_lip = list_entry(lip->li_ail.prev, xfs_log_item_t, li_ail);
-	if (&prev_lip->li_ail != &ailp->xa_ail)
-		ASSERT(XFS_LSN_CMP(prev_lip->li_lsn, lip->li_lsn) <= 0);
-
-	prev_lip = list_entry(lip->li_ail.next, xfs_log_item_t, li_ail);
-	if (&prev_lip->li_ail != &ailp->xa_ail)
-		ASSERT(XFS_LSN_CMP(prev_lip->li_lsn, lip->li_lsn) >= 0);
-
-
-#ifdef XFS_TRANS_DEBUG
-	/*
-	 * Walk the list checking lsn ordering, and that every entry has the
-	 * XFS_LI_IN_AIL flag set. This is really expensive, so only do it
-	 * when specifically debugging the transaction subsystem.
-	 */
-	prev_lip = list_entry(&ailp->xa_ail, xfs_log_item_t, li_ail);
-	list_for_each_entry(lip, &ailp->xa_ail, li_ail) {
-		if (&prev_lip->li_ail != &ailp->xa_ail)
-			ASSERT(XFS_LSN_CMP(prev_lip->li_lsn, lip->li_lsn) <= 0);
-		ASSERT((lip->li_flags & XFS_LI_IN_AIL) != 0);
-		prev_lip = lip;
-	}
-#endif /* XFS_TRANS_DEBUG */
-}
-#endif /* DEBUG */
-- 
1.7.2.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
