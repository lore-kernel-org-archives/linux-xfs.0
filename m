Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id CADC97F3F
	for <xfs@oss.sgi.com>; Fri, 14 Mar 2014 11:37:25 -0500 (CDT)
Received: from eagdhcp-232-183.americas.sgi.com
	(eagdhcp-232-183.americas.sgi.com [128.162.232.183])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 9A8528F8040
	for <xfs@oss.sgi.com>; Fri, 14 Mar 2014 09:37:22 -0700 (PDT)
Received: from eagdhcp-232-183.americas.sgi.com (localhost [127.0.0.1])
	by eagdhcp-232-183.americas.sgi.com (8.14.5/8.14.5) with ESMTP id
	s2EGbMPt002476
	for <xfs@oss.sgi.com>; Fri, 14 Mar 2014 11:37:22 -0500 (CDT)
	(envelope-from tinguely@eagdhcp-232-183.americas.sgi.com)
Message-Id: <20140314163723.916178776@sgi.com>
Date: Fri, 14 Mar 2014 11:37:01 -0500
From: Mark Tinguely <tinguely@sgi.com>
Subject: [PATCH] xfs: free the EFI entries from AIL on forced shutdown
Content-Disposition: inline;
	filename=xfs-remove-efi-entry-before-log-unmount.patch
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

 No EFD. If freeing the extent fails in xfs_bmap_finish() or
 xfs_recover_process_efi(), then the corresponding extent
 free done (EFD) entry will not be created.

 EFD IOP Abort processing. If xfs_trans_cancel() is called with
 an abort flag, or if the xfs_trans_commit() is called when the
 file system is in forced shutdown or if the log buffer write fails,
 then the EFD iop commands will not remove the EFI from the AIL.

If the EFI entry is left on the AIL, xfs_ail_push all_sync() will
fail to complete, the unmount will hang, and a reboot is required
to get the complete the unmount.

A forced shutdown pushs the CIL, so the EFI/EFD on the CIL before
the forced shutdown will be processed normally. Aborted EFI/EFD will
remove themself. All that remains to be done to is to remove the EFI
entries from the AIL in the above listed shutdown cases.

Signed-off-by: Mark Tinguely <tinguely@sgi.com>
---
Note to Christoph about the xfs_recover_process_efi part of patch:
  From b90935eaba9eb13c67101e5d723513bc6ca6e722 Mon Sep 17 00:00:00 2001
  Date: Sat, 23 Nov 2013 20:11:09 +0100
  Subject: [PATCH] xfs: simplify EFI/EFD recovery

  Use a cancellation table, similar to how we handle buffers instead of
  abusing the AIL during recovery.

 http://oss.sgi.com/archives/xfs/2013-12/msg00438.html

will place the EFI onto the AIL in xfs_recover_process_efi() by the time
the xfs_free_extent() error happens. Therefore the changes
in xfs_recover_process_efis() would be the same with or without
your new feature.

Tested:
 Recovery - metadata with bad extent.
 xfs_bmap_finish()
	- placed errors as if the free extent call failed.
	- forced shutdown (as if from a different thread) before EFD created.
	- forced shutdown (as if from a different thread) after EFD created
	   but before xfs_trans_commit()
	- forced shutdown after xfs_trans_commit()
	- xfstests ...

 fs/xfs/xfs_bmap_util.c    |    9 +++++--
 fs/xfs/xfs_extfree_item.c |   55 ++++++++++++++++++++++++++++++++++++++++++----
 fs/xfs/xfs_extfree_item.h |    1 
 fs/xfs/xfs_log_recover.c  |   27 ++++++++++------------
 4 files changed, 71 insertions(+), 21 deletions(-)

Index: b/fs/xfs/xfs_bmap_util.c
===================================================================
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -124,8 +124,12 @@ xfs_bmap_finish(
 				free->xbfi_blockcount))) {
 			/*
 			 * The bmap free list will be cleaned up at a
-			 * higher level.  The EFI will be canceled when
-			 * this transaction is aborted.
+			 * higher level. If the EFI is still on the CIL,
+			 * then it will be canceled when this transaction
+			 * is aborted. But if the EFI has been pushed onto
+			 * the AIL, then it must be manually removed from
+			 * the AIL.
+			 *
 			 * Need to force shutdown here to make sure it
 			 * happens, since this transaction may not be
 			 * dirty yet.
@@ -136,6 +140,7 @@ xfs_bmap_finish(
 						   (error == EFSCORRUPTED) ?
 						   SHUTDOWN_CORRUPT_INCORE :
 						   SHUTDOWN_META_IO_ERROR);
+			xfs_efi_clear_ail(mp->m_ail);
 			return error;
 		}
 		xfs_trans_log_efd_extent(ntp, efd, free->xbfi_startblock,
Index: b/fs/xfs/xfs_extfree_item.c
===================================================================
--- a/fs/xfs/xfs_extfree_item.c
+++ b/fs/xfs/xfs_extfree_item.c
@@ -420,8 +420,15 @@ STATIC void
 xfs_efd_item_unlock(
 	struct xfs_log_item	*lip)
 {
-	if (lip->li_flags & XFS_LI_ABORTED)
+	/*
+	 * Clear the EFI if on AIL when aborting xfs_bmap_finish.
+	 * The forced shutdown will force the log, so other EFDs
+	 * should not be processed from the CIL.
+	 */
+	if (lip->li_flags & XFS_LI_ABORTED) {
+		xfs_efi_clear_ail(lip->li_ailp);
 		xfs_efd_item_free(EFD_ITEM(lip));
+	}
 }
 
 /*
@@ -439,10 +446,15 @@ xfs_efd_item_committed(
 	struct xfs_efd_log_item	*efdp = EFD_ITEM(lip);
 
 	/*
-	 * If we got a log I/O error, it's always the case that the LR with the
-	 * EFI got unpinned and freed before the EFD got aborted.
+	 * If we got a log I/O error and the EFI is also in this buffer, it
+	 * will be unpinned and freed before the EFD got aborted. But the EFI
+	 * is in an earlier transaction and could be on the AIL when the log
+	 * I/O error happened for this EFD. In that case, manually remove the
+	 * remaining EFIs from the AIL.
 	 */
-	if (!(lip->li_flags & XFS_LI_ABORTED))
+	if (lip->li_flags & XFS_LI_ABORTED)
+		xfs_efi_clear_ail(lip->li_ailp);
+	else
 		xfs_efi_release(efdp->efd_efip, efdp->efd_format.efd_nextents);
 
 	xfs_efd_item_free(efdp);
@@ -506,3 +518,38 @@ xfs_efd_init(
 
 	return efdp;
 }
+
+/* Remove all the EFI entries from the AIL using a cursor.
+ * An error that forces down the filesystem will leave the EFI on
+ * the AIL and thus prevening xfs_ail_push_all_sync to complete hanging
+ * the filesystem.
+ *
+ * xfs_free_extent failures in xfs_bmap_finish will not even have an EFD
+ * to match the one on the AIL.
+ */
+void
+xfs_efi_clear_ail(
+	struct xfs_ail		*ailp)
+{
+	struct xfs_log_item	*lip;
+	struct xfs_efi_log_item	*efip;
+	struct xfs_ail_cursor	cur;
+
+	spin_lock(&ailp->xa_lock);
+
+	for (lip = xfs_trans_ail_cursor_first(ailp, &cur, 0); lip != NULL;
+	     lip = xfs_trans_ail_cursor_next(ailp, &cur)) {
+		/* Ignore non EFI entries.  */
+		if (lip->li_type != XFS_LI_EFI)
+			continue;
+
+		/* Remove the EFI entry from the AIL */
+		efip = (xfs_efi_log_item_t *)lip;
+		spin_unlock(&ailp->xa_lock);
+		xfs_efi_release(efip, efip->efi_format.efi_nextents);
+		spin_lock(&ailp->xa_lock);
+		lip = xfs_trans_ail_cursor_next(ailp, &cur);
+	}
+	xfs_trans_ail_cursor_done(ailp, &cur);
+	spin_unlock(&ailp->xa_lock);
+}
Index: b/fs/xfs/xfs_extfree_item.h
===================================================================
--- a/fs/xfs/xfs_extfree_item.h
+++ b/fs/xfs/xfs_extfree_item.h
@@ -77,5 +77,6 @@ xfs_efd_log_item_t	*xfs_efd_init(struct
 int			xfs_efi_copy_format(xfs_log_iovec_t *buf,
 					    xfs_efi_log_format_t *dst_efi_fmt);
 void			xfs_efi_item_free(xfs_efi_log_item_t *);
+void			xfs_efi_clear_ail(struct xfs_ail *ailp);
 
 #endif	/* __XFS_EXTFREE_ITEM_H__ */
Index: b/fs/xfs/xfs_log_recover.c
===================================================================
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -3634,20 +3634,23 @@ xlog_recover_process_data(
 /*
  * Process an extent free intent item that was recovered from
  * the log.  We need to free the extents that it describes.
+ * The caller will free all EFI entries on error.
  */
 STATIC int
 xlog_recover_process_efi(
-	xfs_mount_t		*mp,
-	xfs_efi_log_item_t	*efip)
+	struct xfs_mount	*mp,
+	struct xfs_efi_log_item	*efip)
 {
-	xfs_efd_log_item_t	*efdp;
-	xfs_trans_t		*tp;
+	struct xfs_efd_log_item	*efdp;
+	struct xfs_trans	*tp;
 	int			i;
 	int			error = 0;
 	xfs_extent_t		*extp;
 	xfs_fsblock_t		startblock_fsb;
 
 	ASSERT(!test_bit(XFS_EFI_RECOVERED, &efip->efi_flags));
+	/* All paths need the XFS_EFI_RECOVERED flag set. Do it here. */
+	set_bit(XFS_EFI_RECOVERED, &efip->efi_flags);
 
 	/*
 	 * First check the validity of the extents described by the
@@ -3662,12 +3665,6 @@ xlog_recover_process_efi(
 		    (extp->ext_len == 0) ||
 		    (startblock_fsb >= mp->m_sb.sb_dblocks) ||
 		    (extp->ext_len >= mp->m_sb.sb_agblocks)) {
-			/*
-			 * This will pull the EFI from the AIL and
-			 * free the memory associated with it.
-			 */
-			set_bit(XFS_EFI_RECOVERED, &efip->efi_flags);
-			xfs_efi_release(efip, efip->efi_format.efi_nextents);
 			return XFS_ERROR(EIO);
 		}
 	}
@@ -3687,7 +3684,6 @@ xlog_recover_process_efi(
 					 extp->ext_len);
 	}
 
-	set_bit(XFS_EFI_RECOVERED, &efip->efi_flags);
 	error = xfs_trans_commit(tp, 0);
 	return error;
 
@@ -3718,8 +3714,8 @@ STATIC int
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
@@ -3753,12 +3749,13 @@ xlog_recover_process_efis(
 		error = xlog_recover_process_efi(log->l_mp, efip);
 		spin_lock(&ailp->xa_lock);
 		if (error)
-			goto out;
+			break;
 		lip = xfs_trans_ail_cursor_next(ailp, &cur);
 	}
-out:
 	xfs_trans_ail_cursor_done(ailp, &cur);
 	spin_unlock(&ailp->xa_lock);
+	if (error)
+		xfs_efi_clear_ail(ailp);
 	return error;
 }
 


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
