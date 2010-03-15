Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o2F2XrXd004751 for <xfs@oss.sgi.com>; Sun, 14 Mar 2010 21:33:53 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 40F052402BC
	for <xfs@oss.sgi.com>; Sun, 14 Mar 2010 19:35:27 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail12.adl6.internode.on.net
	[150.101.137.97]) by cuda.sgi.com with ESMTP id
	Efsm1md9R8yEOMmf for <xfs@oss.sgi.com>;
	Sun, 14 Mar 2010 19:35:27 -0700 (PDT)
Received: from dastard (unverified [121.44.103.80])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	17049942-1927428
	for <xfs@oss.sgi.com>; Mon, 15 Mar 2010 13:05:25 +1030 (CDT)
Received: from disturbed ([192.168.1.9]) by dastard with esmtp (Exim 4.71)
	(envelope-from <dave@fromorbit.com>) id 1Nr09M-00016K-CA
	for xfs@oss.sgi.com; Mon, 15 Mar 2010 13:35:24 +1100
Received: from dave by disturbed with local (Exim 4.71)
	(envelope-from <dave@disturbed.disaster>) id 1Nr09B-0002pi-SR
	for xfs@oss.sgi.com; Mon, 15 Mar 2010 13:35:13 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 7/9] xfs: update and factor xfs_trans_committed()
Date: Mon, 15 Mar 2010 13:35:04 +1100
Message-Id: <1268620506-10799-8-git-send-email-david@fromorbit.com>
In-Reply-To: <1268620506-10799-1-git-send-email-david@fromorbit.com>
References: <1268620506-10799-1-git-send-email-david@fromorbit.com>
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

The function header to xfs-trans_committed has long had this
comment:

 * THIS SHOULD BE REWRITTEN TO USE xfs_trans_next_item()

To prepare for different methods of committing items, convert the
code to use xfs_trans_next_item() and factor the code into smaller,
more digestible chunks.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_trans.c |  224 ++++++++++++++++++++++------------------------------
 1 files changed, 95 insertions(+), 129 deletions(-)

diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index 2bff229..084bd3a 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -49,7 +49,6 @@
 STATIC void	xfs_trans_apply_sb_deltas(xfs_trans_t *);
 STATIC void	xfs_trans_uncommit(xfs_trans_t *, uint);
 STATIC void	xfs_trans_committed(xfs_trans_t *, int);
-STATIC void	xfs_trans_chunk_committed(xfs_log_item_chunk_t *, xfs_lsn_t, int);
 STATIC void	xfs_trans_free(xfs_trans_t *);
 
 kmem_zone_t	*xfs_trans_zone;
@@ -1301,60 +1300,86 @@ xfs_trans_roll(
 }
 
 /*
- * THIS SHOULD BE REWRITTEN TO USE xfs_trans_next_item().
+ * The committed item processing consists of calling the committed routine of
+ * each logged item, updating the item's position in the AIL if necessary, and
+ * unpinning each item.  If the committed routine returns -1, then do nothing
+ * further with the item because it may have been freed.
  *
- * This is typically called by the LM when a transaction has been fully
- * committed to disk.  It needs to unpin the items which have
- * been logged by the transaction and update their positions
- * in the AIL if necessary.
- * This also gets called when the transactions didn't get written out
- * because of an I/O error. Abortflag & XFS_LI_ABORTED is set then.
+ * Since items are unlocked when they are copied to the incore log, it is
+ * possible for two transactions to be completing and manipulating the same
+ * item simultaneously.  The AIL lock will protect the lsn field of each item.
+ * The value of this field can never go backwards.
  *
- * Call xfs_trans_chunk_committed() to process the items in
- * each chunk.
+ * We unpin the items after repositioning them in the AIL, because otherwise
+ * they could be immediately flushed and we'd have to race with the flusher
+ * trying to pull the item from the AIL as we add it.
  */
-STATIC void
-xfs_trans_committed(
-	xfs_trans_t	*tp,
-	int		abortflag)
+static void
+xfs_trans_item_committed(
+	xfs_log_item_t	*lip,
+	xfs_lsn_t	commit_lsn,
+	int		aborted)
 {
-	xfs_log_item_chunk_t	*licp;
-	xfs_log_item_chunk_t	*next_licp;
-	xfs_log_busy_chunk_t	*lbcp;
-	xfs_log_busy_slot_t	*lbsp;
-	int			i;
+	xfs_lsn_t	item_lsn;
+	struct xfs_ail	*ailp;
+
+	if (aborted)
+		lip->li_flags |= XFS_LI_ABORTED;
 
 	/*
-	 * Call the transaction's completion callback if there
-	 * is one.
+	 * Send in the ABORTED flag to the COMMITTED routine so that it knows
+	 * whether the transaction was aborted or not.
 	 */
-	if (tp->t_callback != NULL) {
-		tp->t_callback(tp, tp->t_callarg);
-	}
+	item_lsn = IOP_COMMITTED(lip, commit_lsn);
 
 	/*
-	 * Special case the chunk embedded in the transaction.
+	 * If the committed routine returns -1, item has been freed.
 	 */
-	licp = &(tp->t_items);
-	if (!(xfs_lic_are_all_free(licp))) {
-		xfs_trans_chunk_committed(licp, tp->t_lsn, abortflag);
-	}
+	if (XFS_LSN_CMP(item_lsn, (xfs_lsn_t)-1) == 0)
+		return;
 
 	/*
-	 * Process the items in each chunk in turn.
+	 * If the returned lsn is greater than what it contained before, update
+	 * the location of the item in the AIL.  If it is not, then do nothing.
+	 * Items can never move backwards in the AIL.
+	 *
+	 * While the new lsn should usually be greater, it is possible that a
+	 * later transaction completing simultaneously with an earlier one
+	 * using the same item could complete first with a higher lsn.  This
+	 * would cause the earlier transaction to fail the test below.
 	 */
-	licp = licp->lic_next;
-	while (licp != NULL) {
-		ASSERT(!xfs_lic_are_all_free(licp));
-		xfs_trans_chunk_committed(licp, tp->t_lsn, abortflag);
-		next_licp = licp->lic_next;
-		kmem_free(licp);
-		licp = next_licp;
+	ailp = lip->li_ailp;
+	spin_lock(&ailp->xa_lock);
+	if (XFS_LSN_CMP(item_lsn, lip->li_lsn) > 0) {
+		/*
+		 * This will set the item's lsn to item_lsn and update the
+		 * position of the item in the AIL.
+		 *
+		 * xfs_trans_ail_update() drops the AIL lock.
+		 */
+		xfs_trans_ail_update(ailp, lip, item_lsn);
+	} else {
+		spin_unlock(&ailp->xa_lock);
 	}
 
 	/*
-	 * Clear all the per-AG busy list items listed in this transaction
+	 * Now that we've repositioned the item in the AIL, unpin it so it can
+	 * be flushed. Pass information about buffer stale state down from the
+	 * log item flags, if anyone else stales the buffer we do not want to
+	 * pay any attention to it.
 	 */
+	IOP_UNPIN(lip);
+}
+
+/* Clear all the per-AG busy list items listed in this transaction */
+static void
+xfs_trans_clear_busy_extents(
+	struct xfs_trans	*tp)
+{
+	xfs_log_busy_chunk_t	*lbcp;
+	xfs_log_busy_slot_t	*lbsp;
+	int			i;
+
 	lbcp = &tp->t_busy;
 	while (lbcp != NULL) {
 		for (i = 0, lbsp = lbcp->lbc_busy; i < lbcp->lbc_unused; i++, lbsp++) {
@@ -1366,107 +1391,48 @@ xfs_trans_committed(
 		lbcp = lbcp->lbc_next;
 	}
 	xfs_trans_free_busy(tp);
-
-	/*
-	 * That's it for the transaction structure.  Free it.
-	 */
-	xfs_trans_free(tp);
 }
 
 /*
- * This is called to perform the commit processing for each
- * item described by the given chunk.
- *
- * The commit processing consists of unlocking items which were
- * held locked with the SYNC_UNLOCK attribute, calling the committed
- * routine of each logged item, updating the item's position in the AIL
- * if necessary, and unpinning each item.  If the committed routine
- * returns -1, then do nothing further with the item because it
- * may have been freed.
- *
- * Since items are unlocked when they are copied to the incore
- * log, it is possible for two transactions to be completing
- * and manipulating the same item simultaneously.  The AIL lock
- * will protect the lsn field of each item.  The value of this
- * field can never go backwards.
+ * This is typically called by the LM when a transaction has been fully
+ * committed to disk.  It needs to unpin the items which have
+ * been logged by the transaction and update their positions
+ * in the AIL if necessary.
  *
- * We unpin the items after repositioning them in the AIL, because
- * otherwise they could be immediately flushed and we'd have to race
- * with the flusher trying to pull the item from the AIL as we add it.
+ * This also gets called when the transactions didn't get written out
+ * because of an I/O error. Abortflag & XFS_LI_ABORTED is set then.
  */
 STATIC void
-xfs_trans_chunk_committed(
-	xfs_log_item_chunk_t	*licp,
-	xfs_lsn_t		lsn,
-	int			aborted)
+xfs_trans_committed(
+	xfs_trans_t	*tp,
+	int		abortflag)
 {
 	xfs_log_item_desc_t	*lidp;
-	xfs_log_item_t		*lip;
-	xfs_lsn_t		item_lsn;
-	int			i;
-
-	lidp = licp->lic_descs;
-	for (i = 0; i < licp->lic_unused; i++, lidp++) {
-		struct xfs_ail		*ailp;
-
-		if (xfs_lic_isfree(licp, i)) {
-			continue;
-		}
-
-		lip = lidp->lid_item;
-		if (aborted)
-			lip->li_flags |= XFS_LI_ABORTED;
-
-		/*
-		 * Send in the ABORTED flag to the COMMITTED routine
-		 * so that it knows whether the transaction was aborted
-		 * or not.
-		 */
-		item_lsn = IOP_COMMITTED(lip, lsn);
+	xfs_log_item_chunk_t	*licp;
+	xfs_log_item_chunk_t	*next_licp;
 
-		/*
-		 * If the committed routine returns -1, make
-		 * no more references to the item.
-		 */
-		if (XFS_LSN_CMP(item_lsn, (xfs_lsn_t)-1) == 0) {
-			continue;
-		}
+	/*
+	 * Call the transaction's completion callback if there
+	 * is one.
+	 */
+	if (tp->t_callback != NULL) {
+		tp->t_callback(tp, tp->t_callarg);
+	}
 
-		/*
-		 * If the returned lsn is greater than what it
-		 * contained before, update the location of the
-		 * item in the AIL.  If it is not, then do nothing.
-		 * Items can never move backwards in the AIL.
-		 *
-		 * While the new lsn should usually be greater, it
-		 * is possible that a later transaction completing
-		 * simultaneously with an earlier one using the
-		 * same item could complete first with a higher lsn.
-		 * This would cause the earlier transaction to fail
-		 * the test below.
-		 */
-		ailp = lip->li_ailp;
-		spin_lock(&ailp->xa_lock);
-		if (XFS_LSN_CMP(item_lsn, lip->li_lsn) > 0) {
-			/*
-			 * This will set the item's lsn to item_lsn
-			 * and update the position of the item in
-			 * the AIL.
-			 *
-			 * xfs_trans_ail_update() drops the AIL lock.
-			 */
-			xfs_trans_ail_update(ailp, lip, item_lsn);
-		} else {
-			spin_unlock(&ailp->xa_lock);
-		}
+	for (lidp = xfs_trans_first_item(tp);
+	     lidp != NULL;
+	     lidp = xfs_trans_next_item(tp, lidp)) {
+		xfs_trans_item_committed(lidp->lid_item, tp->t_lsn, abortflag);
+	}
 
-		/*
-		 * Now that we've repositioned the item in the AIL,
-		 * unpin it so it can be flushed. Pass information
-		 * about buffer stale state down from the log item
-		 * flags, if anyone else stales the buffer we do not
-		 * want to pay any attention to it.
-		 */
-		IOP_UNPIN(lip);
+	/* free the item chunks, ignoring the embedded chunk */
+	licp = tp->t_items.lic_next;
+	while (licp != NULL) {
+		next_licp = licp->lic_next;
+		kmem_free(licp);
+		licp = next_licp;
 	}
+
+	xfs_trans_clear_busy_extents(tp);
+	xfs_trans_free(tp);
 }
-- 
1.6.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
