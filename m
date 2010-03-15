Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o2F2Xu3O004801 for <xfs@oss.sgi.com>; Sun, 14 Mar 2010 21:33:56 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2FCC8142D329
	for <xfs@oss.sgi.com>; Sun, 14 Mar 2010 19:35:29 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail17.adl2.internode.on.net
	[150.101.137.102]) by cuda.sgi.com with ESMTP id
	MBx6ne8iYk3lxHzp for <xfs@oss.sgi.com>;
	Sun, 14 Mar 2010 19:35:29 -0700 (PDT)
Received: from dastard (unverified [121.44.103.80])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	16864289-1927428
	for <xfs@oss.sgi.com>; Mon, 15 Mar 2010 13:05:26 +1030 (CDT)
Received: from disturbed ([192.168.1.9]) by dastard with esmtp (Exim 4.71)
	(envelope-from <dave@fromorbit.com>) id 1Nr09M-00016S-Lk
	for xfs@oss.sgi.com; Mon, 15 Mar 2010 13:35:24 +1100
Received: from dave by disturbed with local (Exim 4.71)
	(envelope-from <dave@disturbed.disaster>) id 1Nr09B-0002pk-UA
	for xfs@oss.sgi.com; Mon, 15 Mar 2010 13:35:13 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 8/9] xfs: Clean up xfs_trans_committed code after factoring
Date: Mon, 15 Mar 2010 13:35:05 +1100
Message-Id: <1268620506-10799-9-git-send-email-david@fromorbit.com>
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

Now that the code has been factored, clean up all the remaining
style cruft, simplify the code and re-order functions so that it
doesn't need forward declarations.

Also move the remaining functions that require forward declarations
(xfs_trans_uncommit, xfs_trans_free) so that all the forward
declarations can be removed from the file.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_trans.c |  356 ++++++++++++++++++++++++----------------------------
 1 files changed, 166 insertions(+), 190 deletions(-)

diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index 084bd3a..be578ec 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -45,20 +45,12 @@
 #include "xfs_trans_space.h"
 #include "xfs_inode_item.h"
 
-
-STATIC void	xfs_trans_apply_sb_deltas(xfs_trans_t *);
-STATIC void	xfs_trans_uncommit(xfs_trans_t *, uint);
-STATIC void	xfs_trans_committed(xfs_trans_t *, int);
-STATIC void	xfs_trans_free(xfs_trans_t *);
-
 kmem_zone_t	*xfs_trans_zone;
 
-
 /*
  * Reservation functions here avoid a huge stack in xfs_trans_init
  * due to register overflow from temporaries in the calculations.
  */
-
 STATIC uint
 xfs_calc_write_reservation(xfs_mount_t *mp)
 {
@@ -258,6 +250,19 @@ _xfs_trans_alloc(
 }
 
 /*
+ * Free the transaction structure.  If there is more clean up
+ * to do when the structure is freed, add it here.
+ */
+STATIC void
+xfs_trans_free(
+	xfs_trans_t	*tp)
+{
+	atomic_dec(&tp->t_mountp->m_active_trans);
+	xfs_trans_free_dqinfo(tp);
+	kmem_zone_free(xfs_trans_zone, tp);
+}
+
+/*
  * This is called to create a new transaction which will share the
  * permanent log reservation of the given transaction.  The remaining
  * unused block and rt extent reservations are also inherited.  This
@@ -769,7 +774,7 @@ xfs_trans_unreserve_and_mod_sb(
  */
 static uint
 xfs_trans_count_vecs(
-	xfs_trans_t	*tp)
+	struct xfs_trans	*tp)
 {
 	int			nvecs;
 	xfs_log_item_desc_t	*lidp;
@@ -861,6 +866,158 @@ xfs_trans_fill_vecs(
 }
 
 /*
+ * The committed item processing consists of calling the committed routine of
+ * each logged item, updating the item's position in the AIL if necessary, and
+ * unpinning each item.  If the committed routine returns -1, then do nothing
+ * further with the item because it may have been freed.
+ *
+ * Since items are unlocked when they are copied to the incore log, it is
+ * possible for two transactions to be completing and manipulating the same
+ * item simultaneously.  The AIL lock will protect the lsn field of each item.
+ * The value of this field can never go backwards.
+ *
+ * We unpin the items after repositioning them in the AIL, because otherwise
+ * they could be immediately flushed and we'd have to race with the flusher
+ * trying to pull the item from the AIL as we add it.
+ */
+static void
+xfs_trans_item_committed(
+	struct xfs_log_item	*lip,
+	xfs_lsn_t		commit_lsn,
+	int			aborted)
+{
+	xfs_lsn_t		item_lsn;
+	struct xfs_ail		*ailp;
+
+	if (aborted)
+		lip->li_flags |= XFS_LI_ABORTED;
+	item_lsn = IOP_COMMITTED(lip, commit_lsn);
+
+	/* If the committed routine returns -1, item has been freed. */
+	if (XFS_LSN_CMP(item_lsn, (xfs_lsn_t)-1) == 0)
+		return;
+
+	/*
+	 * If the returned lsn is greater than what it contained before, update
+	 * the location of the item in the AIL.  If it is not, then do nothing.
+	 * Items can never move backwards in the AIL.
+	 *
+	 * While the new lsn should usually be greater, it is possible that a
+	 * later transaction completing simultaneously with an earlier one
+	 * using the same item could complete first with a higher lsn.  This
+	 * would cause the earlier transaction to fail the test below.
+	 */
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
+	}
+
+	/*
+	 * Now that we've repositioned the item in the AIL, unpin it so it can
+	 * be flushed. Pass information about buffer stale state down from the
+	 * log item flags, if anyone else stales the buffer we do not want to
+	 * pay any attention to it.
+	 */
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
+	for (lbcp = &tp->t_busy; lbcp != NULL; lbcp = lbcp->lbc_next) {
+		i = 0;
+		for (lbsp = lbcp->lbc_busy; i < lbcp->lbc_unused; i++, lbsp++) {
+			if (XFS_LBC_ISFREE(lbcp, i))
+				continue;
+			xfs_alloc_clear_busy(tp, lbsp->lbc_ag, lbsp->lbc_idx);
+		}
+	}
+	xfs_trans_free_busy(tp);
+}
+
+/*
+ * This is typically called by the LM when a transaction has been fully
+ * committed to disk.  It needs to unpin the items which have
+ * been logged by the transaction and update their positions
+ * in the AIL if necessary.
+ *
+ * This also gets called when the transactions didn't get written out
+ * because of an I/O error. Abortflag & XFS_LI_ABORTED is set then.
+ */
+STATIC void
+xfs_trans_committed(
+	struct xfs_trans	*tp,
+	int			abortflag)
+{
+	xfs_log_item_desc_t	*lidp;
+	xfs_log_item_chunk_t	*licp;
+	xfs_log_item_chunk_t	*next_licp;
+
+	/* Call the transaction's completion callback if there is one. */
+	if (tp->t_callback != NULL)
+		tp->t_callback(tp, tp->t_callarg);
+
+	for (lidp = xfs_trans_first_item(tp);
+	     lidp != NULL;
+	     lidp = xfs_trans_next_item(tp, lidp)) {
+		xfs_trans_item_committed(lidp->lid_item, tp->t_lsn, abortflag);
+	}
+
+	/* free the item chunks, ignoring the embedded chunk */
+	for (licp = tp->t_items.lic_next; licp != NULL; licp = next_licp) {
+		next_licp = licp->lic_next;
+		kmem_free(licp);
+	}
+
+	xfs_trans_clear_busy_extents(tp);
+	xfs_trans_free(tp);
+}
+
+/*
+ * Called from the trans_commit code when we notice that
+ * the filesystem is in the middle of a forced shutdown.
+ */
+STATIC void
+xfs_trans_uncommit(
+	struct xfs_trans	*tp,
+	uint			flags)
+{
+	xfs_log_item_desc_t	*lidp;
+
+	for (lidp = xfs_trans_first_item(tp);
+	     lidp != NULL;
+	     lidp = xfs_trans_next_item(tp, lidp)) {
+		/*
+		 * Unpin all but those that aren't dirty.
+		 */
+		if (lidp->lid_flags & XFS_LID_DIRTY)
+			IOP_UNPIN_REMOVE(lidp->lid_item, tp);
+	}
+
+	xfs_trans_unreserve_and_mod_sb(tp);
+	xfs_trans_unreserve_and_mod_dquots(tp);
+
+	xfs_trans_free_items(tp, flags);
+	xfs_trans_free_busy(tp);
+	xfs_trans_free(tp);
+}
+
+/*
  * Format the transaction direct to the iclog. This isolates the physical
  * transaction commit operation from the logical operation and hence allows
  * other methods to be introduced without affecting the existing commit path.
@@ -1111,35 +1268,6 @@ out_unreserve:
 }
 
 /*
- * Called from the trans_commit code when we notice that
- * the filesystem is in the middle of a forced shutdown.
- */
-STATIC void
-xfs_trans_uncommit(
-	xfs_trans_t	*tp,
-	uint		flags)
-{
-	xfs_log_item_desc_t	*lidp;
-
-	for (lidp = xfs_trans_first_item(tp);
-	     lidp != NULL;
-	     lidp = xfs_trans_next_item(tp, lidp)) {
-		/*
-		 * Unpin all but those that aren't dirty.
-		 */
-		if (lidp->lid_flags & XFS_LID_DIRTY)
-			IOP_UNPIN_REMOVE(lidp->lid_item, tp);
-	}
-
-	xfs_trans_unreserve_and_mod_sb(tp);
-	xfs_trans_unreserve_and_mod_dquots(tp);
-
-	xfs_trans_free_items(tp, flags);
-	xfs_trans_free_busy(tp);
-	xfs_trans_free(tp);
-}
-
-/*
  * Unlock all of the transaction's items and free the transaction.
  * The transaction must not have modified any of its items, because
  * there is no way to restore them to their previous state.
@@ -1215,20 +1343,6 @@ xfs_trans_cancel(
 	xfs_trans_free(tp);
 }
 
-
-/*
- * Free the transaction structure.  If there is more clean up
- * to do when the structure is freed, add it here.
- */
-STATIC void
-xfs_trans_free(
-	xfs_trans_t	*tp)
-{
-	atomic_dec(&tp->t_mountp->m_active_trans);
-	xfs_trans_free_dqinfo(tp);
-	kmem_zone_free(xfs_trans_zone, tp);
-}
-
 /*
  * Roll from one trans in the sequence of PERMANENT transactions to
  * the next: permanent transactions are only flushed out when
@@ -1298,141 +1412,3 @@ xfs_trans_roll(
 	xfs_trans_ihold(trans, dp);
 	return 0;
 }
-
-/*
- * The committed item processing consists of calling the committed routine of
- * each logged item, updating the item's position in the AIL if necessary, and
- * unpinning each item.  If the committed routine returns -1, then do nothing
- * further with the item because it may have been freed.
- *
- * Since items are unlocked when they are copied to the incore log, it is
- * possible for two transactions to be completing and manipulating the same
- * item simultaneously.  The AIL lock will protect the lsn field of each item.
- * The value of this field can never go backwards.
- *
- * We unpin the items after repositioning them in the AIL, because otherwise
- * they could be immediately flushed and we'd have to race with the flusher
- * trying to pull the item from the AIL as we add it.
- */
-static void
-xfs_trans_item_committed(
-	xfs_log_item_t	*lip,
-	xfs_lsn_t	commit_lsn,
-	int		aborted)
-{
-	xfs_lsn_t	item_lsn;
-	struct xfs_ail	*ailp;
-
-	if (aborted)
-		lip->li_flags |= XFS_LI_ABORTED;
-
-	/*
-	 * Send in the ABORTED flag to the COMMITTED routine so that it knows
-	 * whether the transaction was aborted or not.
-	 */
-	item_lsn = IOP_COMMITTED(lip, commit_lsn);
-
-	/*
-	 * If the committed routine returns -1, item has been freed.
-	 */
-	if (XFS_LSN_CMP(item_lsn, (xfs_lsn_t)-1) == 0)
-		return;
-
-	/*
-	 * If the returned lsn is greater than what it contained before, update
-	 * the location of the item in the AIL.  If it is not, then do nothing.
-	 * Items can never move backwards in the AIL.
-	 *
-	 * While the new lsn should usually be greater, it is possible that a
-	 * later transaction completing simultaneously with an earlier one
-	 * using the same item could complete first with a higher lsn.  This
-	 * would cause the earlier transaction to fail the test below.
-	 */
-	ailp = lip->li_ailp;
-	spin_lock(&ailp->xa_lock);
-	if (XFS_LSN_CMP(item_lsn, lip->li_lsn) > 0) {
-		/*
-		 * This will set the item's lsn to item_lsn and update the
-		 * position of the item in the AIL.
-		 *
-		 * xfs_trans_ail_update() drops the AIL lock.
-		 */
-		xfs_trans_ail_update(ailp, lip, item_lsn);
-	} else {
-		spin_unlock(&ailp->xa_lock);
-	}
-
-	/*
-	 * Now that we've repositioned the item in the AIL, unpin it so it can
-	 * be flushed. Pass information about buffer stale state down from the
-	 * log item flags, if anyone else stales the buffer we do not want to
-	 * pay any attention to it.
-	 */
-	IOP_UNPIN(lip);
-}
-
-/* Clear all the per-AG busy list items listed in this transaction */
-static void
-xfs_trans_clear_busy_extents(
-	struct xfs_trans	*tp)
-{
-	xfs_log_busy_chunk_t	*lbcp;
-	xfs_log_busy_slot_t	*lbsp;
-	int			i;
-
-	lbcp = &tp->t_busy;
-	while (lbcp != NULL) {
-		for (i = 0, lbsp = lbcp->lbc_busy; i < lbcp->lbc_unused; i++, lbsp++) {
-			if (!XFS_LBC_ISFREE(lbcp, i)) {
-				xfs_alloc_clear_busy(tp, lbsp->lbc_ag,
-						     lbsp->lbc_idx);
-			}
-		}
-		lbcp = lbcp->lbc_next;
-	}
-	xfs_trans_free_busy(tp);
-}
-
-/*
- * This is typically called by the LM when a transaction has been fully
- * committed to disk.  It needs to unpin the items which have
- * been logged by the transaction and update their positions
- * in the AIL if necessary.
- *
- * This also gets called when the transactions didn't get written out
- * because of an I/O error. Abortflag & XFS_LI_ABORTED is set then.
- */
-STATIC void
-xfs_trans_committed(
-	xfs_trans_t	*tp,
-	int		abortflag)
-{
-	xfs_log_item_desc_t	*lidp;
-	xfs_log_item_chunk_t	*licp;
-	xfs_log_item_chunk_t	*next_licp;
-
-	/*
-	 * Call the transaction's completion callback if there
-	 * is one.
-	 */
-	if (tp->t_callback != NULL) {
-		tp->t_callback(tp, tp->t_callarg);
-	}
-
-	for (lidp = xfs_trans_first_item(tp);
-	     lidp != NULL;
-	     lidp = xfs_trans_next_item(tp, lidp)) {
-		xfs_trans_item_committed(lidp->lid_item, tp->t_lsn, abortflag);
-	}
-
-	/* free the item chunks, ignoring the embedded chunk */
-	licp = tp->t_items.lic_next;
-	while (licp != NULL) {
-		next_licp = licp->lic_next;
-		kmem_free(licp);
-		licp = next_licp;
-	}
-
-	xfs_trans_clear_busy_extents(tp);
-	xfs_trans_free(tp);
-}
-- 
1.6.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
