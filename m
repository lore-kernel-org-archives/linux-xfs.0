Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 239BD29E19
	for <xfs@oss.sgi.com>; Fri,  6 Dec 2013 15:23:36 -0600 (CST)
Received: from eagdhcp-232-151.americas.sgi.com
	(eagdhcp-232-151.americas.sgi.com [128.162.232.151])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 040CB304053
	for <xfs@oss.sgi.com>; Fri,  6 Dec 2013 13:23:32 -0800 (PST)
Received: from eagdhcp-232-151.americas.sgi.com (localhost [127.0.0.1])
	by eagdhcp-232-151.americas.sgi.com (8.14.5/8.14.5) with ESMTP id
	rB6LNUVw006861
	for <xfs@oss.sgi.com>; Fri, 6 Dec 2013 15:23:30 -0600 (CST)
	(envelope-from tinguely@eagdhcp-232-151.americas.sgi.com)
Message-Id: <20131206212037.560711585@sgi.com>
Date: Fri, 06 Dec 2013 15:20:29 -0600
From: Mark Tinguely <tinguely@sgi.com>
Subject: [PATCH 2/2] xfs: free the efi AIL entry on log recovery failure
References: <20131206212027.846346746@sgi.com>
Content-Disposition: inline;
	filename=v2-xfs-remove-efi-entry-before-log-unmount.patch
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

If an extent free fails during recovery, the filesystem will be
forced down. The efi entry is still on the AIL and the log
shutdown function xfs_ail_push_all_sync() will hang.

This patch is similar to the patches that removed the dquot and
inode in commits 32ce90a and dea9609 but removes all the EFI
entries from the AIL.

Cleaned up the typedefs while modifying the function.

Signed-off-by: Mark Tinguely <tinguely@sgi.com>
---
v2 remove all the EFIs from the AIL rather than the current entry
   per Dave's suggestion.
   move the cleaning routine to caller.

 fs/xfs/xfs_log_recover.c |   33 +++++++++++++++++++++------------
 1 file changed, 21 insertions(+), 12 deletions(-)

Index: b/fs/xfs/xfs_log_recover.c
===================================================================
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -3635,11 +3635,11 @@ xlog_recover_process_data(
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
@@ -3660,12 +3660,7 @@ xlog_recover_process_efi(
 		    (extp->ext_len == 0) ||
 		    (startblock_fsb >= mp->m_sb.sb_dblocks) ||
 		    (extp->ext_len >= mp->m_sb.sb_agblocks)) {
-			/*
-			 * This will pull the EFI from the AIL and
-			 * free the memory associated with it.
-			 */
-			set_bit(XFS_EFI_RECOVERED, &efip->efi_flags);
-			xfs_efi_release(efip, efip->efi_format.efi_nextents);
+			/* The caller will free all efi entries on error. */
 			return XFS_ERROR(EIO);
 		}
 	}
@@ -3691,6 +3686,7 @@ xlog_recover_process_efi(
 
 abort_error:
 	xfs_trans_cancel(tp, XFS_TRANS_ABORT);
+	/* The caller will free all efi entries on error. */
 	return error;
 }
 
@@ -3716,8 +3712,8 @@ STATIC int
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
@@ -3756,7 +3752,20 @@ xlog_recover_process_efis(
 	}
 out:
 	xfs_trans_ail_cursor_done(ailp, &cur);
+	lip = xfs_ail_min(ailp);
 	spin_unlock(&ailp->xa_lock);
+	/* Free all the EFI from the AIL upon error */
+	while (lip) {
+		if (lip->li_type == XFS_LI_EFI) {
+			efip = (xfs_efi_log_item_t *)lip;
+			if (!test_bit(XFS_EFI_RECOVERED, &efip->efi_flags))
+				set_bit(XFS_EFI_RECOVERED, &efip->efi_flags);
+			xfs_efi_release(efip, efip->efi_format.efi_nextents);
+		}
+		spin_lock(&ailp->xa_lock);
+		lip = xfs_ail_min(ailp);
+		spin_unlock(&ailp->xa_lock);
+	}
 	return error;
 }
 


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
