Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 6E8D07F62
	for <xfs@oss.sgi.com>; Wed,  2 Jul 2014 09:52:22 -0500 (CDT)
Received: from eagdhcp-232-174.americas.sgi.com
	(eagdhcp-232-174.americas.sgi.com [128.162.232.174])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 2C8A78F8039
	for <xfs@oss.sgi.com>; Wed,  2 Jul 2014 07:52:19 -0700 (PDT)
Received: from eagdhcp-232-174.americas.sgi.com (localhost [127.0.0.1])
	by eagdhcp-232-174.americas.sgi.com (8.14.5/8.14.5) with ESMTP id
	s62EqEDo005625
	for <xfs@oss.sgi.com>; Wed, 2 Jul 2014 09:52:14 -0500 (CDT)
	(envelope-from tinguely@eagdhcp-232-174.americas.sgi.com)
Message-Id: <20140702144139.620473576@sgi.com>
Date: Wed, 02 Jul 2014 09:32:07 -0500
From: Mark Tinguely <tinguely@sgi.com>
Subject: [PATCH 1/5] xfs: remove efi from AIL in log recovery
References: <20140702143206.438456679@sgi.com>
Content-Disposition: inline; filename=xfs-fix-efi-in-log-recovery-error.patch
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

The log recovery functions xlog_recover_process_efi{s} are
responsible for freeing extents that did not complete in
xfs_bmap_finish before a forced shutdown or system crash.
If the extent removal fails in log recovery, then the EFI
will stay on the AIL and is will hang the filesystem
requiring a system reboot.

This patch removes the special log recovery flag, XFS_EFI_RECOVERED.
That flag used to be used to decrement the EFI/EFD counter. Instead
call the decrement function just like we do in the log IOP sequence.

Remove all other unprocessed EFIs from the log recovery AIL
when one is discovered in error.

Signed-off-by: Mark Tinguely <tinguely@sgi.com>
---
 fs/xfs/xfs_extfree_item.c |   54 +++++++++++++++++++++++--------------
 fs/xfs/xfs_extfree_item.h |    5 ---
 fs/xfs/xfs_log_recover.c  |   67 ++++++++++++++++++++++++++--------------------
 fs/xfs/xfs_trans.h        |    1 
 4 files changed, 73 insertions(+), 54 deletions(-)

Index: b/fs/xfs/xfs_extfree_item.c
===================================================================
--- a/fs/xfs/xfs_extfree_item.c
+++ b/fs/xfs/xfs_extfree_item.c
@@ -62,9 +62,15 @@ __xfs_efi_release(
 
 	if (atomic_dec_and_test(&efip->efi_refcount)) {
 		spin_lock(&ailp->xa_lock);
-		/* xfs_trans_ail_delete() drops the AIL lock. */
-		xfs_trans_ail_delete(ailp, &efip->efi_item,
-				     SHUTDOWN_LOG_IO_ERROR);
+		/*
+		 * The EFI may not be on the AIL on abort.
+		 * xfs_trans_ail_delete() drops the AIL lock.
+		 */
+		if (efip->efi_item.li_flags & XFS_LI_IN_AIL)
+			xfs_trans_ail_delete(ailp, &efip->efi_item,
+					     SHUTDOWN_LOG_IO_ERROR);
+		else
+			spin_unlock(&ailp->xa_lock);
 		xfs_efi_item_free(efip);
 	}
 }
@@ -134,9 +140,10 @@ xfs_efi_item_pin(
  * remove the EFI it's because the transaction has been cancelled and by
  * definition that means the EFI cannot be in the AIL so remove it from the
  * transaction and free it.  Otherwise coordinate with xfs_efi_release()
- * to determine who gets to free the EFI.
+ * to determine who gets to free the EFI. Call from log recovery of EFI
+ * entries so the EFD or error handling will remove the entry.
  */
-STATIC void
+void
 xfs_efi_item_unpin(
 	struct xfs_log_item	*lip,
 	int			remove)
@@ -147,8 +154,6 @@ xfs_efi_item_unpin(
 		ASSERT(!(lip->li_flags & XFS_LI_IN_AIL));
 		if (lip->li_desc)
 			xfs_trans_del_item(lip);
-		xfs_efi_item_free(efip);
-		return;
 	}
 	__xfs_efi_release(efip);
 }
@@ -168,12 +173,17 @@ xfs_efi_item_push(
 	return XFS_ITEM_PINNED;
 }
 
+/*
+ * Remove EFI entry on abort.
+ */
 STATIC void
 xfs_efi_item_unlock(
 	struct xfs_log_item	*lip)
 {
-	if (lip->li_flags & XFS_LI_ABORTED)
-		xfs_efi_item_free(EFI_ITEM(lip));
+	if (lip->li_flags & XFS_LI_ABORTED) {
+		ASSERT(!(lip->li_flags & XFS_LI_IN_AIL));
+		__xfs_efi_release(EFI_ITEM(lip));
+	}
 }
 
 /*
@@ -313,10 +323,6 @@ xfs_efi_release(xfs_efi_log_item_t	*efip
 {
 	ASSERT(atomic_read(&efip->efi_next_extent) >= nextents);
 	if (atomic_sub_and_test(nextents, &efip->efi_next_extent)) {
-		/* recovery needs us to drop the EFI reference, too */
-		if (test_bit(XFS_EFI_RECOVERED, &efip->efi_flags))
-			__xfs_efi_release(efip);
-
 		__xfs_efi_release(efip);
 		/* efip may now have been freed, do not reference it again. */
 	}
@@ -420,8 +426,17 @@ STATIC void
 xfs_efd_item_unlock(
 	struct xfs_log_item	*lip)
 {
-	if (lip->li_flags & XFS_LI_ABORTED)
-		xfs_efd_item_free(EFD_ITEM(lip));
+	struct xfs_efd_log_item	*efdp = EFD_ITEM(lip);
+
+	if (!(lip->li_flags & XFS_LI_ABORTED))
+		return;
+
+	/* Free the EFI when aborting a commit. The EFI will be either
+	 * added to the AIL in a CIL push before this abort or unlocked
+	 * before the EFD unlock.
+	 */
+	xfs_efi_release(efdp->efd_efip, efdp->efd_format.efd_nextents);
+	xfs_efd_item_free(efdp);
 }
 
 /*
@@ -439,12 +454,11 @@ xfs_efd_item_committed(
 	struct xfs_efd_log_item	*efdp = EFD_ITEM(lip);
 
 	/*
-	 * If we got a log I/O error, it's always the case that the LR with the
-	 * EFI got unpinned and freed before the EFD got aborted.
+	 * EFI and EFDs can be in different CIL pushes. Therefore the EFI could
+	 * be on the AIL when an abort occurs, so try to release the EFI in
+	 * all cases.
 	 */
-	if (!(lip->li_flags & XFS_LI_ABORTED))
-		xfs_efi_release(efdp->efd_efip, efdp->efd_format.efd_nextents);
-
+	xfs_efi_release(efdp->efd_efip, efdp->efd_format.efd_nextents);
 	xfs_efd_item_free(efdp);
 	return (xfs_lsn_t)-1;
 }
Index: b/fs/xfs/xfs_extfree_item.h
===================================================================
--- a/fs/xfs/xfs_extfree_item.h
+++ b/fs/xfs/xfs_extfree_item.h
@@ -29,11 +29,6 @@ struct kmem_zone;
 #define	XFS_EFI_MAX_FAST_EXTENTS	16
 
 /*
- * Define EFI flag bits. Manipulated by set/clear/test_bit operators.
- */
-#define	XFS_EFI_RECOVERED	1
-
-/*
  * This is the "extent free intention" log item.  It is used to log the fact
  * that some extents need to be free.  It is used in conjunction with the
  * "extent free done" log item described below.
Index: b/fs/xfs/xfs_log_recover.c
===================================================================
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -3093,6 +3093,12 @@ xlog_recover_efi_pass2(
 	 * xfs_trans_ail_update() drops the AIL lock.
 	 */
 	xfs_trans_ail_update(log->l_ailp, &efip->efi_item, lsn);
+
+	/*
+	 * Decrement the EFI/EFD counter so the EFI is removed after
+	 * processing the EFD or error handling in the caller.
+	 */
+	xfs_efi_item_unpin(&efip->efi_item, 0);
 	return 0;
 }
 
@@ -3635,6 +3641,8 @@ xlog_recover_process_data(
 /*
  * Process an extent free intent item that was recovered from
  * the log.  We need to free the extents that it describes.
+ * The processing of the EFD will free the EFI and remove it from the AIL.
+ * The caller will remove any other EFIs on the the AIL.
  */
 STATIC int
 xlog_recover_process_efi(
@@ -3648,8 +3656,6 @@ xlog_recover_process_efi(
 	xfs_extent_t		*extp;
 	xfs_fsblock_t		startblock_fsb;
 
-	ASSERT(!test_bit(XFS_EFI_RECOVERED, &efip->efi_flags));
-
 	/*
 	 * First check the validity of the extents described by the
 	 * EFI.  If any are bad, then assume that all are bad and
@@ -3663,13 +3669,8 @@ xlog_recover_process_efi(
 		    (extp->ext_len == 0) ||
 		    (startblock_fsb >= mp->m_sb.sb_dblocks) ||
 		    (extp->ext_len >= mp->m_sb.sb_agblocks)) {
-			/*
-			 * This will pull the EFI from the AIL and
-			 * free the memory associated with it.
-			 */
-			set_bit(XFS_EFI_RECOVERED, &efip->efi_flags);
-			xfs_efi_release(efip, efip->efi_format.efi_nextents);
-			return XFS_ERROR(EIO);
+			error = XFS_ERROR(EIO);
+			goto return_free;
 		}
 	}
 
@@ -3682,45 +3683,58 @@ xlog_recover_process_efi(
 	for (i = 0; i < efip->efi_format.efi_nextents; i++) {
 		extp = &(efip->efi_format.efi_extents[i]);
 		error = xfs_free_extent(tp, extp->ext_start, extp->ext_len);
-		if (error)
-			goto abort_error;
 		xfs_trans_log_efd_extent(tp, efdp, extp->ext_start,
 					 extp->ext_len);
+		if (error) {
+			/* The error may be the first extent or there may the
+			 * EFD may be dirty on the transaction by another
+			 * extent. Make the EFD dirty on the transactions
+			 * so the xfs_trans_cancel frees EFI/EFD and removes
+			 * EFI from AIL.
+ 			*/
+			xfs_trans_cancel(tp, XFS_TRANS_ABORT);
+			return error;
+		}
 	}
 
-	set_bit(XFS_EFI_RECOVERED, &efip->efi_flags);
 	error = xfs_trans_commit(tp, 0);
-	return error;
+	if (error)
+		goto return_free;
+	return 0;
 
 abort_error:
 	xfs_trans_cancel(tp, XFS_TRANS_ABORT);
+return_free:
+	xfs_efi_release(efip, efip->efi_format.efi_nextents);
 	return error;
 }
 
 /*
  * When this is called, all of the EFIs which did not have
- * corresponding EFDs should be in the AIL.  What we do now
- * is free the extents associated with each one.
+ * corresponding EFDs should be in the AIL. The initial decrement
+ * on the EFI/EFD sequence counter has been done when the EFI is placed
+ * on the AIL. What we do now is free the extents associated with each one.
  *
  * Since we process the EFIs in normal transactions, they
  * will be removed at some point after the commit.  This prevents
  * us from just walking down the list processing each one.
- * We'll use a flag in the EFI to skip those that we've already
- * processed and use the AIL iteration mechanism's generation
- * count to try to speed this up at least a bit.
  *
  * When we start, we know that the EFIs are the only things in
  * the AIL.  As we process them, however, other items are added
  * to the AIL.  Since everything added to the AIL must come after
  * everything already in the AIL, we stop processing as soon as
  * we see something other than an EFI in the AIL.
+ *
+ * If an error is detected while freeing extents in the EFI, discard all
+ * future EFI on the AIL. This is done by the xfs_efi_release() which is
+ * the same processing as a successful EFD completion processing.
  */
 STATIC int
 xlog_recover_process_efis(
 	struct xlog	*log)
 {
-	xfs_log_item_t		*lip;
-	xfs_efi_log_item_t	*efip;
+	struct xfs_log_item	*lip;
+	struct xfs_efi_log_item	*efip;
 	int			error = 0;
 	struct xfs_ail_cursor	cur;
 	struct xfs_ail		*ailp;
@@ -3745,19 +3759,14 @@ xlog_recover_process_efis(
 		 * Skip EFIs that we've already processed.
 		 */
 		efip = (xfs_efi_log_item_t *)lip;
-		if (test_bit(XFS_EFI_RECOVERED, &efip->efi_flags)) {
-			lip = xfs_trans_ail_cursor_next(ailp, &cur);
-			continue;
-		}
-
 		spin_unlock(&ailp->xa_lock);
-		error = xlog_recover_process_efi(log->l_mp, efip);
+		if (!error)
+			error = xlog_recover_process_efi(log->l_mp, efip);
+		else
+			xfs_efi_release(efip, efip->efi_format.efi_nextents);
 		spin_lock(&ailp->xa_lock);
-		if (error)
-			goto out;
 		lip = xfs_trans_ail_cursor_next(ailp, &cur);
 	}
-out:
 	xfs_trans_ail_cursor_done(&cur);
 	spin_unlock(&ailp->xa_lock);
 	return error;
Index: b/fs/xfs/xfs_trans.h
===================================================================
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -216,6 +216,7 @@ void		xfs_trans_ijoin(struct xfs_trans *
 void		xfs_trans_log_buf(xfs_trans_t *, struct xfs_buf *, uint, uint);
 void		xfs_trans_log_inode(xfs_trans_t *, struct xfs_inode *, uint);
 struct xfs_efi_log_item	*xfs_trans_get_efi(xfs_trans_t *, uint);
+void		xfs_efi_item_unpin(struct xfs_log_item *, int);
 void		xfs_efi_release(struct xfs_efi_log_item *, uint);
 void		xfs_trans_log_efi_extent(xfs_trans_t *,
 					 struct xfs_efi_log_item *,


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
