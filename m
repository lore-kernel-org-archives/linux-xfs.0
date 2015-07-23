Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id CA94A7F94
	for <xfs@oss.sgi.com>; Thu, 23 Jul 2015 15:13:37 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id B154830404E
	for <xfs@oss.sgi.com>; Thu, 23 Jul 2015 13:13:34 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id K9ZnWJTAx24nBmIu (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 23 Jul 2015 13:13:33 -0700 (PDT)
Received: from int-mx09.intmail.prod.int.phx2.redhat.com
	(int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (Postfix) with ESMTPS id E137CA98
	for <xfs@oss.sgi.com>; Thu, 23 Jul 2015 20:13:32 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-76.bos.redhat.com [10.18.41.76])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id t6NKDWJS011311
	for <xfs@oss.sgi.com>; Thu, 23 Jul 2015 16:13:32 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH RFC 2/2] xfs: fix efi/efd error handling to avoid fs shutdown
	hangs
Date: Thu, 23 Jul 2015 16:13:30 -0400
Message-Id: <1437682410-51778-3-git-send-email-bfoster@redhat.com>
In-Reply-To: <1437682410-51778-1-git-send-email-bfoster@redhat.com>
References: <1437682410-51778-1-git-send-email-bfoster@redhat.com>
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

Freeing an extent in XFS involves logging an EFI (extent free
intention), freeing the actual extent, and logging an EFD (extent free
done). The EFI object is created with a reference count of 2: one for
the current transaction and one for the subsequently created EFD. Under
normal circumstances, the first reference is dropped when the EFI is
unpinned and the second reference is dropped when the EFD is committed
to the on-disk log.

In event of errors or filesystem shutdown, there are various potential
cleanup scenarios depending on the state of the EFI/EFD. The cleanup
scenarios are confusing and racy, as demonstrated by the following test
sequence:

	# mount $dev $mnt
	# fsstress -d $mnt -n 99999 -p 16 -z -f fallocate=1 \
		-f punch=1 -f creat=1 -f unlink=1 &
	# sleep 5
	# killall -9 fsstress; wait
	# godown -f $mnt
	# umount

... in which the final umount can hang due to the AIL being pinned
indefinitely by one or more EFI items. This can occur due to several
conditions. For example, if the shutdown occurs after the EFI is
committed to the on-disk log and the EFD committed to the CIL, but
before the EFD committed to the log, the EFD iop_committed() abort
handler does not drop its reference to the EFI. Alternatively, manual
error injection in the xfs_bmap_finish() codepath shows that if an error
occurs after the EFI transaction is committed but before the EFD is
constructed and logged, the EFI is never released from the AIL.

Update the EFI/EFD item handling code to use a more straightforward and
reliable approach to error handling. If the EFI transaction is
cancelled, the EFI is freed when the log item is unlocked. If the EFI
transaction is committed successfully, from that point forward it is the
responsibility of the EFD to drop its EFI reference. This means that the
EFI unpin callback only ever drops the log reference to the EFI. It does
not free the EFI in the event of log I/O error. This also means that the
EFD item must drop its EFI reference either if the EFD transaction is
cancelled, committed or itself aborted due to log I/O error. Finally,
update xfs_bmap_finish() to ensure that once an EFI transaction is
committed, we are guaranteed to construct and log the associated EFD.
This ensures that the EFD is aborted and drops the reference to the EFI.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_bmap_util.c    | 35 ++++++++++++++++++++--------
 fs/xfs/xfs_extfree_item.c | 59 +++++++++++++++++++++++++----------------------
 2 files changed, 57 insertions(+), 37 deletions(-)

diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 0f34886c..878b33a 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -88,20 +88,36 @@ xfs_bmap_finish(
 		xfs_trans_log_efi_extent(*tp, efi, free->xbfi_startblock,
 			free->xbfi_blockcount);
 
-	error = xfs_trans_roll(tp, NULL);
-	*committed = 1;
+	error = __xfs_trans_roll(tp, NULL, committed);
+
 	/*
-	 * We have a new transaction, so we should return committed=1,
-	 * even though we're returning an error.
+	 * We have a new transaction, so we should return committed=1, even
+	 * though we're returning an error. If an error was returned after the
+	 * original transaction was committed, defer the error handling until
+	 * the EFD is logged. We do this because a committed EFI requires an EFD
+	 * transaction to be processed to ensure the EFI is released.
 	 */
-	if (error)
+	if (error && *committed == 0) {
+		*committed = 1;
 		return error;
+	}
 
 	efd = xfs_trans_get_efd(*tp, efi, flist->xbf_count);
 	for (free = flist->xbf_first; free != NULL; free = next) {
 		next = free->xbfi_next;
-		if ((error = xfs_free_extent(*tp, free->xbfi_startblock,
-				free->xbfi_blockcount))) {
+
+		/*
+		 * Free the extent if the above trans roll hasn't failed and log
+		 * the EFD before handling errors from either call to ensure the
+		 * EFI reference is accounted for in the tp. Otherwise, the EFI
+		 * is never released on abort and pins the AIL indefinitely.
+		 */
+		if (!error)
+			error = xfs_free_extent(*tp, free->xbfi_startblock,
+						free->xbfi_blockcount);
+		xfs_trans_log_efd_extent(*tp, efd, free->xbfi_startblock,
+					 free->xbfi_blockcount);
+		if (error) {
 			/*
 			 * The bmap free list will be cleaned up at a
 			 * higher level.  The EFI will be canceled when
@@ -118,11 +134,10 @@ xfs_bmap_finish(
 						   SHUTDOWN_META_IO_ERROR);
 			return error;
 		}
-		xfs_trans_log_efd_extent(*tp, efd, free->xbfi_startblock,
-			free->xbfi_blockcount);
 		xfs_bmap_del_free(flist, NULL, free);
 	}
-	return 0;
+
+	return error;
 }
 
 int
diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
index adc8f8f..0e426ab 100644
--- a/fs/xfs/xfs_extfree_item.c
+++ b/fs/xfs/xfs_extfree_item.c
@@ -128,12 +128,12 @@ xfs_efi_item_pin(
 }
 
 /*
- * While EFIs cannot really be pinned, the unpin operation is the last place at
- * which the EFI is manipulated during a transaction.  If we are being asked to
- * remove the EFI it's because the transaction has been cancelled and by
- * definition that means the EFI cannot be in the AIL so remove it from the
- * transaction and free it.  Otherwise coordinate with xfs_efi_release()
- * to determine who gets to free the EFI.
+ * The unpin operation is the last place an EFI is manipulated in the log. It is
+ * either inserted in the AIL or aborted in the event of a log I/O error. In
+ * either case, the EFI transaction has been successfully committed to make it
+ * this far. Therefore, we expect whoever committed the EFI to construct the EFD
+ * and manage the EFD's reference to the EFI appropriately. Simply drop the
+ * log's EFI reference now that the log is done with it.
  */
 STATIC void
 xfs_efi_item_unpin(
@@ -141,14 +141,6 @@ xfs_efi_item_unpin(
 	int			remove)
 {
 	struct xfs_efi_log_item	*efip = EFI_ITEM(lip);
-
-	if (remove) {
-		ASSERT(!(lip->li_flags & XFS_LI_IN_AIL));
-		if (lip->li_desc)
-			xfs_trans_del_item(lip);
-		xfs_efi_item_free(efip);
-		return;
-	}
 	__xfs_efi_release(efip);
 }
 
@@ -167,6 +159,11 @@ xfs_efi_item_push(
 	return XFS_ITEM_PINNED;
 }
 
+/*
+ * The EFI has been either committed or aborted if the transaction has been
+ * cancelled. If the transaction was cancelled, an EFD isn't going to be
+ * constructed and thus we free the EFI here directly.
+ */
 STATIC void
 xfs_efi_item_unlock(
 	struct xfs_log_item	*lip)
@@ -415,20 +412,27 @@ xfs_efd_item_push(
 	return XFS_ITEM_PINNED;
 }
 
+/*
+ * The EFD is either committed or aborted if the transaction is cancelled. If
+ * the transaction is cancelled, drop our reference to the EFI and free the EFD.
+ */
 STATIC void
 xfs_efd_item_unlock(
 	struct xfs_log_item	*lip)
 {
-	if (lip->li_flags & XFS_LI_ABORTED)
-		xfs_efd_item_free(EFD_ITEM(lip));
+	struct xfs_efd_log_item	*efdp = EFD_ITEM(lip);
+
+	if (lip->li_flags & XFS_LI_ABORTED) {
+		xfs_efi_release(efdp->efd_efip, efdp->efd_format.efd_nextents);
+		xfs_efd_item_free(efdp);
+	}
 }
 
 /*
- * When the efd item is committed to disk, all we need to do
- * is delete our reference to our partner efi item and then
- * free ourselves.  Since we're freeing ourselves we must
- * return -1 to keep the transaction code from further referencing
- * this item.
+ * When the efd item is committed to disk, all we need to do is delete our
+ * reference to our partner efi item and then free ourselves. Since we're
+ * freeing ourselves we must return -1 to keep the transaction code from further
+ * referencing this item.
  */
 STATIC xfs_lsn_t
 xfs_efd_item_committed(
@@ -438,14 +442,15 @@ xfs_efd_item_committed(
 	struct xfs_efd_log_item	*efdp = EFD_ITEM(lip);
 
 	/*
-	 * If we got a log I/O error, it's always the case that the LR with the
-	 * EFI got unpinned and freed before the EFD got aborted.
+	 * Drop the efi reference regardless of whether this item has been
+	 * aborted. Once the EFI transaction is successfully committed, it is
+	 * the sole responsibility of the EFD to clean up the EFI (even if the
+	 * EFI is aborted due to log I/O error).
 	 */
-	if (!(lip->li_flags & XFS_LI_ABORTED))
-		xfs_efi_release(efdp->efd_efip, efdp->efd_format.efd_nextents);
-
+	xfs_efi_release(efdp->efd_efip, efdp->efd_format.efd_nextents);
 	xfs_efd_item_free(efdp);
-	return (xfs_lsn_t)-1;
+
+	return (xfs_lsn_t) -1;
 }
 
 /*
-- 
2.1.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
