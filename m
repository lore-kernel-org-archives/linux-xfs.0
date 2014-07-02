Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 66D737F61
	for <xfs@oss.sgi.com>; Wed,  2 Jul 2014 09:52:22 -0500 (CDT)
Received: from eagdhcp-232-174.americas.sgi.com
	(eagdhcp-232-174.americas.sgi.com [128.162.232.174])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 3CE428F8049
	for <xfs@oss.sgi.com>; Wed,  2 Jul 2014 07:52:19 -0700 (PDT)
Received: from eagdhcp-232-174.americas.sgi.com (localhost [127.0.0.1])
	by eagdhcp-232-174.americas.sgi.com (8.14.5/8.14.5) with ESMTP id
	s62EqEoS005629
	for <xfs@oss.sgi.com>; Wed, 2 Jul 2014 09:52:14 -0500 (CDT)
	(envelope-from tinguely@eagdhcp-232-174.americas.sgi.com)
Message-Id: <20140702144139.705337423@sgi.com>
Date: Wed, 02 Jul 2014 09:32:08 -0500
From: Mark Tinguely <tinguely@sgi.com>
Subject: [PATCH 2/5] xfs: free the EFI entries from AIL on forced shutdown
References: <20140702143206.438456679@sgi.com>
Content-Disposition: inline; filename=xfs-fix-efi-on-filesystem-errors.patch
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

The extent free intention (EFI) entry and extent free done (EFD)
log items are in separate transactions. It is possible that
the EFI can be pushed to the AIL before a forced shutdown
where it gets stuck on the AIL and requires a reboot in the
following places:

1) xfs_bmap_finish:
  The EFD is not in the transaction. This can happen if the
  transaction in xfs_bmap_finish() fails to reserve space.

  The EFD will not be dirty in the transaction if the error
  happened while freeing the first extent in the list.

2) EFD IOP Abort processing:
  If xfs_trans_cancel() is called with an abort flag, or if the
  xfs_trans_commit() is called when the file system is in forced
  shutdown or if the log buffer write fails.

 
Do not free the EFI structure immediately on forced shutdowns, but
instead use the IOP calls to match the EFI/EFD entries. A small
wrinkle in the mix is the EFI is not automatically placed on the
AIL by the IOP routines in the cases but may have made it to the
AIL before the abort. We now have to check if the EFI is on the AIL
in the abort IOP cases.

Remove the debug code, because the EFD could be in the log item list
on a xfs_trans_cancel.

Signed-off-by: Mark Tinguely <tinguely@sgi.com>
---
 fs/xfs/xfs_bmap_util.c |   36 ++++++++++++++++++------------------
 fs/xfs/xfs_trans.c     |    8 --------
 2 files changed, 18 insertions(+), 26 deletions(-)

Index: b/fs/xfs/xfs_bmap_util.c
===================================================================
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -79,7 +79,6 @@ xfs_bmap_finish(
 	int			error;		/* error return value */
 	xfs_bmap_free_item_t	*free;		/* free extent item */
 	struct xfs_trans_res	tres;		/* new log reservation */
-	xfs_mount_t		*mp;		/* filesystem mount structure */
 	xfs_bmap_free_item_t	*next;		/* next item on free list */
 	xfs_trans_t		*ntp;		/* new transaction pointer */
 
@@ -115,31 +114,32 @@ xfs_bmap_finish(
 	xfs_log_ticket_put(ntp->t_ticket);
 
 	error = xfs_trans_reserve(ntp, &tres, 0, 0);
-	if (error)
+	if (error) {
+		/*
+		 * EFD is not in the transaction. Manually release the EFI
+		 * and remove it from AIL if necessary.
+		 */
+		xfs_efi_release(efi, efi->efi_format.efi_nextents);
 		return error;
+	}
+
 	efd = xfs_trans_get_efd(ntp, efi, flist->xbf_count);
 	for (free = flist->xbf_first; free != NULL; free = next) {
 		next = free->xbfi_next;
-		if ((error = xfs_free_extent(ntp, free->xbfi_startblock,
-				free->xbfi_blockcount))) {
+		error = xfs_free_extent(ntp, free->xbfi_startblock,
+				free->xbfi_blockcount);
+		xfs_trans_log_efd_extent(ntp, efd, free->xbfi_startblock,
+					 free->xbfi_blockcount);
+		if (error) {
 			/*
-			 * The bmap free list will be cleaned up at a
-			 * higher level.  The EFI will be canceled when
-			 * this transaction is aborted.
-			 * Need to force shutdown here to make sure it
-			 * happens, since this transaction may not be
-			 * dirty yet.
+			 * Encountered an error while freeing the extent.
+			 * The bmap free list will be cleaned up at a higher
+			 * level. The caller will call xfs_trans_cancel on
+			 * error, the filesystem will be shutdown and the
+			 * EFI and EFD will be freed.
 			 */
-			mp = ntp->t_mountp;
-			if (!XFS_FORCED_SHUTDOWN(mp))
-				xfs_force_shutdown(mp,
-						   (error == EFSCORRUPTED) ?
-						   SHUTDOWN_CORRUPT_INCORE :
-						   SHUTDOWN_META_IO_ERROR);
 			return error;
 		}
-		xfs_trans_log_efd_extent(ntp, efd, free->xbfi_startblock,
-			free->xbfi_blockcount);
 		xfs_bmap_del_free(flist, NULL, free);
 	}
 	return 0;
Index: b/fs/xfs/xfs_trans.c
===================================================================
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -958,14 +958,6 @@ xfs_trans_cancel(
 		XFS_ERROR_REPORT("xfs_trans_cancel", XFS_ERRLEVEL_LOW, mp);
 		xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
 	}
-#ifdef DEBUG
-	if (!(flags & XFS_TRANS_ABORT) && !XFS_FORCED_SHUTDOWN(mp)) {
-		struct xfs_log_item_desc *lidp;
-
-		list_for_each_entry(lidp, &tp->t_items, lid_trans)
-			ASSERT(!(lidp->lid_item->li_type == XFS_LI_EFD));
-	}
-#endif
 	xfs_trans_unreserve_and_mod_sb(tp);
 	xfs_trans_unreserve_and_mod_dquots(tp);
 


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
