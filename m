Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 136317F88
	for <xfs@oss.sgi.com>; Thu,  5 Dec 2013 15:41:28 -0600 (CST)
Received: from eagdhcp-232-151.americas.sgi.com
	(eagdhcp-232-151.americas.sgi.com [128.162.232.151])
	by relay2.corp.sgi.com (Postfix) with ESMTP id E821730407F
	for <xfs@oss.sgi.com>; Thu,  5 Dec 2013 13:41:27 -0800 (PST)
Received: from eagdhcp-232-151.americas.sgi.com (localhost [127.0.0.1])
	by eagdhcp-232-151.americas.sgi.com (8.14.5/8.14.5) with ESMTP id
	rB5LfR2Y003231
	for <xfs@oss.sgi.com>; Thu, 5 Dec 2013 15:41:27 -0600 (CST)
	(envelope-from tinguely@eagdhcp-232-151.americas.sgi.com)
Message-Id: <20131205214054.330817383@sgi.com>
Date: Thu, 05 Dec 2013 15:40:07 -0600
From: Mark Tinguely <tinguely@sgi.com>
Subject: [PATCH] xfs: free the efi AIL entry on log recovery failure
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

If freeing an extent fails during recovery, then the filesystem
will be forced down with the EFI entry still on the AIL. This
will result in hanging the function xfs_ail_push_all_sync().

This patch is similar to the patches that removed the dquot and
inode in commits 32ce90a and dea9609.

Found by mounting an metadata dump that triggers a
XFS_WANT_CORRUPTED_RETURN() on log recovery.

Signed-off-by: Mark Tinguely <tinguely@sgi.com>
---
 fs/xfs/xfs_log_recover.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

Index: b/fs/xfs/xfs_log_recover.c
===================================================================
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -3668,7 +3668,7 @@ xlog_recover_process_efi(
 		extp = &(efip->efi_format.efi_extents[i]);
 		error = xfs_free_extent(tp, extp->ext_start, extp->ext_len);
 		if (error)
-			goto abort_error;
+			goto free_abort;
 		xfs_trans_log_efd_extent(tp, efdp, extp->ext_start,
 					 extp->ext_len);
 	}
@@ -3677,6 +3677,9 @@ xlog_recover_process_efi(
 	error = xfs_trans_commit(tp, 0);
 	return error;
 
+free_abort:
+	set_bit(XFS_EFI_RECOVERED, &efip->efi_flags);
+	xfs_efi_release(efip, efip->efi_format.efi_nextents);
 abort_error:
 	xfs_trans_cancel(tp, XFS_TRANS_ABORT);
 	return error;


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
