Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 652DD7F59
	for <xfs@oss.sgi.com>; Fri,  7 Aug 2015 16:15:34 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id D648FAC008
	for <xfs@oss.sgi.com>; Fri,  7 Aug 2015 14:15:33 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id dfveeJF65zKK0YR3 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 07 Aug 2015 14:15:32 -0700 (PDT)
Received: from int-mx10.intmail.prod.int.phx2.redhat.com
	(int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (Postfix) with ESMTPS id 002DB9D1DD
	for <xfs@oss.sgi.com>; Fri,  7 Aug 2015 21:15:31 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-76.bos.redhat.com [10.18.41.76])
	by int-mx10.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id t77LFVVW020044
	for <xfs@oss.sgi.com>; Fri, 7 Aug 2015 17:15:31 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v2 05/12] xfs: use EFI refcount consistently in log recovery
Date: Fri,  7 Aug 2015 17:15:21 -0400
Message-Id: <1438982128-38618-6-git-send-email-bfoster@redhat.com>
In-Reply-To: <1438982128-38618-1-git-send-email-bfoster@redhat.com>
References: <1438982128-38618-1-git-send-email-bfoster@redhat.com>
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

The EFI is initialized with a reference count of 2. One for the EFI to
ensure the item makes it to the AIL and one for the subsequently created
EFD to release the EFI once the EFD is committed. Log recovery uses the
EFI in a similar manner, but implements a hack to remove both references
in one call once the EFD is handled.

Update log recovery to use EFI reference counting in a manner consistent
with the log. When an EFI is encountered during recovery, an EFI item is
allocated and inserted to the AIL directly. Since the EFI reference is
typically dropped when the EFI is unpinned and this is analogous with
AIL insertion, drop the EFI reference at this point.

When a corresponding EFD is encountered in the log, this indicates that
the extents were freed, no processing is required and the EFI can be
dropped. Update xlog_recover_efd_pass2() to simply drop the EFD
reference at this point rather than open code the AIL removal and EFI
free.

Remaining EFIs (i.e., with no corresponding EFD) are processed in
xlog_recover_finish(). An EFD transaction is allocated and the extents
are freed, which transfers ownership of the EFI reference to the EFD
item in the log.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_extfree_item.c | 57 +++++++++++++++++------------------------------
 fs/xfs/xfs_log_recover.c  | 43 ++++++++++++++++++-----------------
 2 files changed, 43 insertions(+), 57 deletions(-)

diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
index aceb54f..2b2acac 100644
--- a/fs/xfs/xfs_extfree_item.c
+++ b/fs/xfs/xfs_extfree_item.c
@@ -47,34 +47,6 @@ xfs_efi_item_free(
 }
 
 /*
- * Freeing the efi requires that we remove it from the AIL if it has already
- * been placed there. However, the EFI may not yet have been placed in the AIL
- * when called by xfs_efi_release() from EFD processing due to the ordering of
- * committed vs unpin operations in bulk insert operations. Hence the reference
- * count to ensure only the last caller frees the EFI.
- */
-STATIC void
-__xfs_efi_release(
-	struct xfs_efi_log_item	*efip)
-{
-	struct xfs_ail		*ailp = efip->efi_item.li_ailp;
-
-	if (atomic_dec_and_test(&efip->efi_refcount)) {
-		spin_lock(&ailp->xa_lock);
-		/*
-		 * We don't know whether the EFI made it to the AIL. Remove it
-		 * if so. Note that xfs_trans_ail_delete() drops the AIL lock.
-		 */
-		if (efip->efi_item.li_flags & XFS_LI_IN_AIL)
-			xfs_trans_ail_delete(ailp, &efip->efi_item,
-					     SHUTDOWN_LOG_IO_ERROR);
-		else
-			spin_unlock(&ailp->xa_lock);
-		xfs_efi_item_free(efip);
-	}
-}
-
-/*
  * This returns the number of iovecs needed to log the given efi item.
  * We only need 1 iovec for an efi item.  It just logs the efi_log_format
  * structure.
@@ -304,20 +276,31 @@ xfs_efi_copy_format(xfs_log_iovec_t *buf, xfs_efi_log_format_t *dst_efi_fmt)
 }
 
 /*
- * This is called by the efd item code below to release references to the given
- * efi item.  Each efd calls this with the number of extents that it has
- * logged, and when the sum of these reaches the total number of extents logged
- * by this efi item we can free the efi item.
+ * Freeing the efi requires that we remove it from the AIL if it has already
+ * been placed there. However, the EFI may not yet have been placed in the AIL
+ * when called by xfs_efi_release() from EFD processing due to the ordering of
+ * committed vs unpin operations in bulk insert operations. Hence the reference
+ * count to ensure only the last caller frees the EFI.
  */
 void
 xfs_efi_release(struct xfs_efi_log_item	*efip)
 {
-	/* recovery needs us to drop the EFI reference, too */
-	if (test_bit(XFS_EFI_RECOVERED, &efip->efi_flags))
-		__xfs_efi_release(efip);
+	struct xfs_ail		*ailp = efip->efi_item.li_ailp;
 
-	__xfs_efi_release(efip);
-	/* efip may now have been freed, do not reference it again. */
+	if (atomic_dec_and_test(&efip->efi_refcount)) {
+		spin_lock(&ailp->xa_lock);
+		/*
+		 * We don't know whether the EFI made it to the AIL. Remove it
+		 * if so. Note that xfs_trans_ail_delete() drops the AIL lock.
+		 */
+		if (efip->efi_item.li_flags & XFS_LI_IN_AIL)
+			xfs_trans_ail_delete(ailp, &efip->efi_item,
+					     SHUTDOWN_LOG_IO_ERROR);
+		else
+			spin_unlock(&ailp->xa_lock);
+
+		xfs_efi_item_free(efip);
+	}
 }
 
 static inline struct xfs_efd_log_item *EFD_ITEM(struct xfs_log_item *lip)
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 3433b7b..113042e 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -2933,16 +2933,16 @@ xlog_recover_efi_pass2(
 	struct xlog_recover_item	*item,
 	xfs_lsn_t			lsn)
 {
-	int			error;
-	xfs_mount_t		*mp = log->l_mp;
-	xfs_efi_log_item_t	*efip;
-	xfs_efi_log_format_t	*efi_formatp;
+	int				error;
+	struct xfs_mount		*mp = log->l_mp;
+	struct xfs_efi_log_item		*efip;
+	struct xfs_efi_log_format	*efi_formatp;
 
 	efi_formatp = item->ri_buf[0].i_addr;
 
 	efip = xfs_efi_init(mp, efi_formatp->efi_nextents);
-	if ((error = xfs_efi_copy_format(&(item->ri_buf[0]),
-					 &(efip->efi_format)))) {
+	error = xfs_efi_copy_format(&item->ri_buf[0], &efip->efi_format);
+	if (error) {
 		xfs_efi_item_free(efip);
 		return error;
 	}
@@ -2950,20 +2950,23 @@ xlog_recover_efi_pass2(
 
 	spin_lock(&log->l_ailp->xa_lock);
 	/*
-	 * xfs_trans_ail_update() drops the AIL lock.
+	 * The EFI has two references. One for the EFD and one for EFI to ensure
+	 * it makes it into the AIL. Insert the EFI into the AIL directly and
+	 * drop the EFI reference. Note that xfs_trans_ail_update() drops the
+	 * AIL lock.
 	 */
 	xfs_trans_ail_update(log->l_ailp, &efip->efi_item, lsn);
+	xfs_efi_release(efip);
 	return 0;
 }
 
 
 /*
- * This routine is called when an efd format structure is found in
- * a committed transaction in the log.  It's purpose is to cancel
- * the corresponding efi if it was still in the log.  To do this
- * it searches the AIL for the efi with an id equal to that in the
- * efd format structure.  If we find it, we remove the efi from the
- * AIL and free it.
+ * This routine is called when an EFD format structure is found in a committed
+ * transaction in the log. Its purpose is to cancel the corresponding EFI if it
+ * was still in the log. To do this it searches the AIL for the EFI with an id
+ * equal to that in the EFD format structure. If we find it we drop the EFD
+ * reference, which removes the EFI from the AIL and frees it.
  */
 STATIC int
 xlog_recover_efd_pass2(
@@ -2985,8 +2988,8 @@ xlog_recover_efd_pass2(
 	efi_id = efd_formatp->efd_efi_id;
 
 	/*
-	 * Search for the efi with the id in the efd format structure
-	 * in the AIL.
+	 * Search for the EFI with the id in the EFD format structure in the
+	 * AIL.
 	 */
 	spin_lock(&ailp->xa_lock);
 	lip = xfs_trans_ail_cursor_first(ailp, &cur, 0);
@@ -2995,18 +2998,18 @@ xlog_recover_efd_pass2(
 			efip = (xfs_efi_log_item_t *)lip;
 			if (efip->efi_format.efi_id == efi_id) {
 				/*
-				 * xfs_trans_ail_delete() drops the
-				 * AIL lock.
+				 * Drop the EFD reference to the EFI. This
+				 * removes the EFI from the AIL and frees it.
 				 */
-				xfs_trans_ail_delete(ailp, lip,
-						     SHUTDOWN_CORRUPT_INCORE);
-				xfs_efi_item_free(efip);
+				spin_unlock(&ailp->xa_lock);
+				xfs_efi_release(efip);
 				spin_lock(&ailp->xa_lock);
 				break;
 			}
 		}
 		lip = xfs_trans_ail_cursor_next(ailp, &cur);
 	}
+
 	xfs_trans_ail_cursor_done(&cur);
 	spin_unlock(&ailp->xa_lock);
 
-- 
2.1.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
