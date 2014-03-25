Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id D3D6229DFE
	for <xfs@oss.sgi.com>; Tue, 25 Mar 2014 15:12:05 -0500 (CDT)
Received: from eagdhcp-232-205.americas.sgi.com
	(eagdhcp-232-205.americas.sgi.com [128.162.232.205])
	by relay1.corp.sgi.com (Postfix) with ESMTP id D2B7B8F8049
	for <xfs@oss.sgi.com>; Tue, 25 Mar 2014 13:12:02 -0700 (PDT)
Received: from eagdhcp-232-205.americas.sgi.com (localhost [127.0.0.1])
	by eagdhcp-232-205.americas.sgi.com (8.14.5/8.14.5) with ESMTP id
	s2PKC30I003851
	for <xfs@oss.sgi.com>; Tue, 25 Mar 2014 15:12:03 -0500 (CDT)
	(envelope-from tinguely@eagdhcp-232-205.americas.sgi.com)
Message-Id: <20140325195819.740387237@sgi.com>
Date: Tue, 25 Mar 2014 15:06:35 -0500
From: Mark Tinguely <tinguely@sgi.com>
Subject: [PATCH 2/2] xfs: free the EFI entries from AIL on forced shutdown
References: <20140325195733.510384972@sgi.com>
Content-Disposition: inline; filename=xfs-fix-efi-xfs_bmapi_finish-error.patch
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

The extent free intention (EFI) and extent free done (EFD)
log items are in separate transactions. It is possible that
the EFI can be pushed to the AIL before a forced shutdown
where it gets stuck for following reasons:

 No complete EFD in the transaction. This can happen if the
 transaction fails to reserve space or the freeing the extent
 fails in xfs_bmap_finish().

 EFD IOP Abort processing. If xfs_trans_cancel() is called with
 an abort flag, or if the xfs_trans_commit() is called when the
 file system is in forced shutdown or if the log buffer write fails,
 then the EFD iop commands will not remove the EFI from the AIL.

If the EFI entry is left on the AIL, xfs_ail_push all_sync() will
fail to complete, the unmount will hang, and a reboot is required
to get the complete the unmount.

Do not free the EFI structure immediately on forced shutdowns, but
instead use the IOP calls to match the EFI/EFD entries. A small
wrinkle in the mix is the EFI is not automatically placed on the
AIL by the IOP routines in the cases but may have made it to the
AIL before the abort. We now have to check if the EFI is on the AIL
in the abort IOP cases.

Signed-off-by: Mark Tinguely <tinguely@sgi.com>
---
Dave, as I tried to explain, if the error in extent free happen early
enough, the EFD is not usable and is not in the transaction to cause
IOP commands to clean up the EFI. It too must be done manually.

The "in the AIL" test must be done in the abort IOP commands.

 fs/xfs/xfs_bmap_util.c    |   21 +++++++++++++++----
 fs/xfs/xfs_extfree_item.c |   49 +++++++++++++++++++++++++++++++++-------------
 fs/xfs/xfs_log_recover.c  |    3 +-
 fs/xfs/xfs_trans.h        |    2 -
 4 files changed, 56 insertions(+), 19 deletions(-)

Index: b/fs/xfs/xfs_bmap_util.c
===================================================================
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -116,12 +116,14 @@ xfs_bmap_finish(
 
 	error = xfs_trans_reserve(ntp, &tres, 0, 0);
 	if (error)
-		return error;
+		goto error_return;
+
 	efd = xfs_trans_get_efd(ntp, efi, flist->xbf_count);
 	for (free = flist->xbf_first; free != NULL; free = next) {
 		next = free->xbfi_next;
-		if ((error = xfs_free_extent(ntp, free->xbfi_startblock,
-				free->xbfi_blockcount))) {
+		error = xfs_free_extent(ntp, free->xbfi_startblock,
+				free->xbfi_blockcount);
+		if (error) {
 			/*
 			 * The bmap free list will be cleaned up at a
 			 * higher level.  The EFI will be canceled when
@@ -136,13 +138,24 @@ xfs_bmap_finish(
 						   (error == EFSCORRUPTED) ?
 						   SHUTDOWN_CORRUPT_INCORE :
 						   SHUTDOWN_META_IO_ERROR);
-			return error;
+			goto error_return;
 		}
 		xfs_trans_log_efd_extent(ntp, efd, free->xbfi_startblock,
 			free->xbfi_blockcount);
 		xfs_bmap_del_free(flist, NULL, free);
 	}
 	return 0;
+
+ error_return:
+	/*
+	 * No EFD in the transaction matching the EFI can be used at this
+	 * point Manually release the EFI and remove from AIL if necessary.
+	 * If the EFI did not make it into the AIL, then the transaction
+	 * cancel of the EFI will decrement the EFI/EFD counter and will not
+	 * attempt to remove itself from the AIL.
+	 */
+	xfs_efi_release(efi, efi->efi_format.efi_nextents, 0);
+	return error;
 }
 
 int
Index: b/fs/xfs/xfs_extfree_item.c
===================================================================
--- a/fs/xfs/xfs_extfree_item.c
+++ b/fs/xfs/xfs_extfree_item.c
@@ -56,15 +56,22 @@ xfs_efi_item_free(
  */
 STATIC void
 __xfs_efi_release(
-	struct xfs_efi_log_item	*efip)
+	struct xfs_efi_log_item	*efip,
+	int			abort)
 {
 	struct xfs_ail		*ailp = efip->efi_item.li_ailp;
 
 	if (atomic_dec_and_test(&efip->efi_refcount)) {
 		spin_lock(&ailp->xa_lock);
-		/* xfs_trans_ail_delete() drops the AIL lock. */
-		xfs_trans_ail_delete(ailp, &efip->efi_item,
-				     SHUTDOWN_LOG_IO_ERROR);
+		/*
+		 * The EFI may not be on the AIL on abort.
+		 * xfs_trans_ail_delete() drops the AIL lock.
+		 */
+		if (abort)
+			spin_unlock(&ailp->xa_lock);
+		else
+			xfs_trans_ail_delete(ailp, &efip->efi_item,
+					     SHUTDOWN_LOG_IO_ERROR);
 		xfs_efi_item_free(efip);
 	}
 }
@@ -148,10 +155,10 @@ xfs_efi_item_unpin(
 		ASSERT(!(lip->li_flags & XFS_LI_IN_AIL));
 		if (lip->li_desc)
 			xfs_trans_del_item(lip);
-		xfs_efi_item_free(efip);
+		__xfs_efi_release(efip, 1);
 		return;
 	}
-	__xfs_efi_release(efip);
+	__xfs_efi_release(efip, 0);
 }
 
 /*
@@ -173,8 +180,9 @@ STATIC void
 xfs_efi_item_unlock(
 	struct xfs_log_item	*lip)
 {
+	/* EFI will not be on the AIL if called on abort */
 	if (lip->li_flags & XFS_LI_ABORTED)
-		xfs_efi_item_free(EFI_ITEM(lip));
+		__xfs_efi_release(EFI_ITEM(lip), 1);
 }
 
 /*
@@ -310,11 +318,12 @@ xfs_efi_copy_format(xfs_log_iovec_t *buf
  */
 void
 xfs_efi_release(xfs_efi_log_item_t	*efip,
-		uint			nextents)
+		uint			nextents,
+		int			abort)
 {
 	ASSERT(atomic_read(&efip->efi_next_extent) >= nextents);
 	if (atomic_sub_and_test(nextents, &efip->efi_next_extent)) {
-		__xfs_efi_release(efip);
+		__xfs_efi_release(efip, abort);
 		/* efip may now have been freed, do not reference it again. */
 	}
 }
@@ -417,8 +426,19 @@ STATIC void
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
+	 * before the EFD unlock. In either case we can check the AIL
+	 * status now.
+	 */
+	xfs_efi_release(efdp->efd_efip, efdp->efd_format.efd_nextents,
+			!(efdp->efd_efip->efi_item.li_flags & XFS_LI_IN_AIL));
+	xfs_efd_item_free(efdp);
 }
 
 /*
@@ -434,14 +454,17 @@ xfs_efd_item_committed(
 	xfs_lsn_t		lsn)
 {
 	struct xfs_efd_log_item	*efdp = EFD_ITEM(lip);
+	int abort = 0;
 
 	/*
 	 * If we got a log I/O error, it's always the case that the LR with the
 	 * EFI got unpinned and freed before the EFD got aborted.
 	 */
-	if (!(lip->li_flags & XFS_LI_ABORTED))
-		xfs_efi_release(efdp->efd_efip, efdp->efd_format.efd_nextents);
+	if (lip->li_flags & XFS_LI_ABORTED &&
+	    !(efdp->efd_efip->efi_item.li_flags & XFS_LI_IN_AIL))
+		abort = 1;
 
+	xfs_efi_release(efdp->efd_efip, efdp->efd_format.efd_nextents, abort);
 	xfs_efd_item_free(efdp);
 	return (xfs_lsn_t)-1;
 }
Index: b/fs/xfs/xfs_log_recover.c
===================================================================
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -3754,8 +3754,9 @@ xlog_recover_process_efis(
 		/* Skip all EFIs after first EFI in error. */
 		if (!error)
 			error = xlog_recover_process_efi(log->l_mp, efip);
+		/* EFI will be on the AIL, so abort == 0 */
 		if (error)
-			xfs_efi_release(efip, efip->efi_format.efi_nextents);
+			xfs_efi_release(efip, efip->efi_format.efi_nextents, 0);
 		spin_lock(&ailp->xa_lock);
 		lip = xfs_trans_ail_cursor_next(ailp, &cur);
 	}
Index: b/fs/xfs/xfs_trans.h
===================================================================
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -217,7 +217,7 @@ void		xfs_trans_log_buf(xfs_trans_t *, s
 void		xfs_trans_log_inode(xfs_trans_t *, struct xfs_inode *, uint);
 struct xfs_efi_log_item	*xfs_trans_get_efi(xfs_trans_t *, uint);
 void		xfs_efi_item_unpin(struct xfs_log_item *, int);
-void		xfs_efi_release(struct xfs_efi_log_item *, uint);
+void		xfs_efi_release(struct xfs_efi_log_item *, uint, int);
 void		xfs_trans_log_efi_extent(xfs_trans_t *,
 					 struct xfs_efi_log_item *,
 					 xfs_fsblock_t,


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
