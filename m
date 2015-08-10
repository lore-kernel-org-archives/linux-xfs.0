Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 8AB117F47
	for <xfs@oss.sgi.com>; Mon, 10 Aug 2015 14:01:55 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 3B8B8AC002
	for <xfs@oss.sgi.com>; Mon, 10 Aug 2015 12:01:52 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 8atrkkz8hYdtSSPh (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 10 Aug 2015 12:01:51 -0700 (PDT)
Received: from int-mx14.intmail.prod.int.phx2.redhat.com
	(int-mx14.intmail.prod.int.phx2.redhat.com [10.5.11.27])
	by mx1.redhat.com (Postfix) with ESMTPS id 050228F266
	for <xfs@oss.sgi.com>; Mon, 10 Aug 2015 19:01:51 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-184.bos.redhat.com [10.18.41.184])
	by int-mx14.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id t7AJ1oU4002497
	for <xfs@oss.sgi.com>; Mon, 10 Aug 2015 15:01:50 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v3 03/13] xfs: fix efi/efd error handling to avoid fs shutdown
	hangs
Date: Mon, 10 Aug 2015 15:01:39 -0400
Message-Id: <1439233309-19959-4-git-send-email-bfoster@redhat.com>
In-Reply-To: <1439233309-19959-1-git-send-email-bfoster@redhat.com>
References: <1439233309-19959-1-git-send-email-bfoster@redhat.com>
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
reliable approach to error handling. If an error occurs after the EFI
transaction is committed and before the EFD is constructed, release the
EFI explicitly from xfs_bmap_finish(). If the EFI transaction is
cancelled, release the EFI in the unlock handler.

Once the EFD is constructed, it is responsible for releasing the EFI
under any circumstances (including whether the EFI item aborts due to
log I/O error). Update the EFD item handlers to release the EFI if the
transaction is cancelled or aborts due to log I/O error. Finally, update
xfs_bmap_finish() to log at least one EFD extent to the transaction
before xfs_free_extent() errors are handled to ensure the transaction is
dirty and EFD item error handling is triggered.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_bmap_util.c    | 84 +++++++++++++++++++++++++++--------------------
 fs/xfs/xfs_extfree_item.c | 69 ++++++++++++++++++++++----------------
 fs/xfs/xfs_extfree_item.h | 25 ++++++++++++--
 3 files changed, 111 insertions(+), 67 deletions(-)

diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 0f34886c..fa65f67 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -67,16 +67,15 @@ xfs_fsb_to_db(struct xfs_inode *ip, xfs_fsblock_t fsb)
  */
 int						/* error */
 xfs_bmap_finish(
-	xfs_trans_t		**tp,		/* transaction pointer addr */
-	xfs_bmap_free_t		*flist,		/* i/o: list extents to free */
-	int			*committed)	/* xact committed or not */
+	struct xfs_trans		**tp,	/* transaction pointer addr */
+	struct xfs_bmap_free		*flist,	/* i/o: list extents to free */
+	int				*committed)/* xact committed or not */
 {
-	xfs_efd_log_item_t	*efd;		/* extent free data */
-	xfs_efi_log_item_t	*efi;		/* extent free intention */
-	int			error;		/* error return value */
-	xfs_bmap_free_item_t	*free;		/* free extent item */
-	xfs_mount_t		*mp;		/* filesystem mount structure */
-	xfs_bmap_free_item_t	*next;		/* next item on free list */
+	struct xfs_efd_log_item		*efd;	/* extent free data */
+	struct xfs_efi_log_item		*efi;	/* extent free intention */
+	int				error;	/* error return value */
+	struct xfs_bmap_free_item	*free;	/* free extent item */
+	struct xfs_bmap_free_item	*next;	/* next item on free list */
 
 	ASSERT((*tp)->t_flags & XFS_TRANS_PERM_LOG_RES);
 	if (flist->xbf_count == 0) {
@@ -88,40 +87,55 @@ xfs_bmap_finish(
 		xfs_trans_log_efi_extent(*tp, efi, free->xbfi_startblock,
 			free->xbfi_blockcount);
 
-	error = xfs_trans_roll(tp, NULL);
-	*committed = 1;
-	/*
-	 * We have a new transaction, so we should return committed=1,
-	 * even though we're returning an error.
-	 */
-	if (error)
+	error = __xfs_trans_roll(tp, NULL, committed);
+	if (error) {
+		/*
+		 * If the transaction was committed, drop the EFD reference
+		 * since we're bailing out of here. The other reference is
+		 * dropped when the EFI hits the AIL.
+		 *
+		 * If the transaction was not committed, the EFI is freed by the
+		 * EFI item unlock handler on abort. Also, we have a new
+		 * transaction so we should return committed=1 even though we're
+		 * returning an error.
+		 */
+		if (*committed) {
+			xfs_efi_release(efi);
+			xfs_force_shutdown((*tp)->t_mountp,
+				(error == -EFSCORRUPTED) ?
+					SHUTDOWN_CORRUPT_INCORE :
+					SHUTDOWN_META_IO_ERROR);
+		} else {
+			*committed = 1;
+		}
+
 		return error;
+	}
 
 	efd = xfs_trans_get_efd(*tp, efi, flist->xbf_count);
 	for (free = flist->xbf_first; free != NULL; free = next) {
 		next = free->xbfi_next;
-		if ((error = xfs_free_extent(*tp, free->xbfi_startblock,
-				free->xbfi_blockcount))) {
-			/*
-			 * The bmap free list will be cleaned up at a
-			 * higher level.  The EFI will be canceled when
-			 * this transaction is aborted.
-			 * Need to force shutdown here to make sure it
-			 * happens, since this transaction may not be
-			 * dirty yet.
-			 */
-			mp = (*tp)->t_mountp;
-			if (!XFS_FORCED_SHUTDOWN(mp))
-				xfs_force_shutdown(mp,
-						   (error == -EFSCORRUPTED) ?
-						   SHUTDOWN_CORRUPT_INCORE :
-						   SHUTDOWN_META_IO_ERROR);
-			return error;
-		}
+
+		/*
+		 * Free the extent and log the EFD to dirty the transaction
+		 * before handling errors. This ensures that the transaction is
+		 * aborted, which:
+		 *
+		 * 1.) releases the EFI and frees the EFD
+		 * 2.) shuts down the filesystem
+		 *
+		 * The bmap free list is cleaned up at a higher level.
+		 */
+		error = xfs_free_extent(*tp, free->xbfi_startblock,
+					free->xbfi_blockcount);
 		xfs_trans_log_efd_extent(*tp, efd, free->xbfi_startblock,
-			free->xbfi_blockcount);
+					 free->xbfi_blockcount);
+		if (error)
+			return error;
+
 		xfs_bmap_del_free(flist, NULL, free);
 	}
+
 	return 0;
 }
 
diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
index 6ff738f..475b9f0 100644
--- a/fs/xfs/xfs_extfree_item.c
+++ b/fs/xfs/xfs_extfree_item.c
@@ -61,9 +61,15 @@ __xfs_efi_release(
 
 	if (atomic_dec_and_test(&efip->efi_refcount)) {
 		spin_lock(&ailp->xa_lock);
-		/* xfs_trans_ail_delete() drops the AIL lock. */
-		xfs_trans_ail_delete(ailp, &efip->efi_item,
-				     SHUTDOWN_LOG_IO_ERROR);
+		/*
+		 * We don't know whether the EFI made it to the AIL. Remove it
+		 * if so. Note that xfs_trans_ail_delete() drops the AIL lock.
+		 */
+		if (efip->efi_item.li_flags & XFS_LI_IN_AIL)
+			xfs_trans_ail_delete(ailp, &efip->efi_item,
+					     SHUTDOWN_LOG_IO_ERROR);
+		else
+			spin_unlock(&ailp->xa_lock);
 		xfs_efi_item_free(efip);
 	}
 }
@@ -128,12 +134,12 @@ xfs_efi_item_pin(
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
+ * this far. Therefore, we expect whoever committed the EFI to either construct
+ * and commit the EFD or drop the EFD's reference in the event of error. Simply
+ * drop the log's EFI reference now that the log is done with it.
  */
 STATIC void
 xfs_efi_item_unpin(
@@ -141,14 +147,6 @@ xfs_efi_item_unpin(
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
 	xfs_efi_release(efip);
 }
 
@@ -167,6 +165,11 @@ xfs_efi_item_push(
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
@@ -412,20 +415,27 @@ xfs_efd_item_push(
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
+		xfs_efi_release(efdp->efd_efip);
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
@@ -435,13 +445,14 @@ xfs_efd_item_committed(
 	struct xfs_efd_log_item	*efdp = EFD_ITEM(lip);
 
 	/*
-	 * If we got a log I/O error, it's always the case that the LR with the
-	 * EFI got unpinned and freed before the EFD got aborted.
+	 * Drop the EFI reference regardless of whether the EFD has been
+	 * aborted. Once the EFD transaction is constructed, it is the sole
+	 * responsibility of the EFD to release the EFI (even if the EFI is
+	 * aborted due to log I/O error).
 	 */
-	if (!(lip->li_flags & XFS_LI_ABORTED))
-		xfs_efi_release(efdp->efd_efip);
-
+	xfs_efi_release(efdp->efd_efip);
 	xfs_efd_item_free(efdp);
+
 	return (xfs_lsn_t)-1;
 }
 
diff --git a/fs/xfs/xfs_extfree_item.h b/fs/xfs/xfs_extfree_item.h
index 399562e..8fa8651 100644
--- a/fs/xfs/xfs_extfree_item.h
+++ b/fs/xfs/xfs_extfree_item.h
@@ -39,9 +39,28 @@ struct kmem_zone;
  * "extent free done" log item described below.
  *
  * The EFI is reference counted so that it is not freed prior to both the EFI
- * and EFD being committed and unpinned. This ensures that when the last
- * reference goes away the EFI will always be in the AIL as it has been
- * unpinned, regardless of whether the EFD is processed before or after the EFI.
+ * and EFD being committed and unpinned. This ensures the EFI is inserted into
+ * the AIL even in the event of out of order EFI/EFD processing. In other words,
+ * an EFI is born with two references:
+ *
+ * 	1.) an EFI held reference to track EFI AIL insertion
+ * 	2.) an EFD held reference to track EFD commit
+ *
+ * On allocation, both references are the responsibility of the caller. Once the
+ * EFI is added to and dirtied in a transaction, ownership of reference one
+ * transfers to the transaction. The reference is dropped once the EFI is
+ * inserted to the AIL or in the event of failure along the way (e.g., commit
+ * failure, log I/O error, etc.). Note that the caller remains responsible for
+ * the EFD reference under all circumstances to this point. The caller has no
+ * means to detect failure once the transaction is committed, however.
+ * Therefore, an EFD is required after this point, even in the event of
+ * unrelated failure.
+ *
+ * Once an EFD is allocated and dirtied in a transaction, reference two
+ * transfers to the transaction. The EFD reference is dropped once it reaches
+ * the unpin handler. Similar to the EFI, the reference also drops in the event
+ * of commit failure or log I/O errors. Note that the EFD is not inserted in the
+ * AIL, so at this point both the EFI and EFD are freed.
  */
 typedef struct xfs_efi_log_item {
 	xfs_log_item_t		efi_item;
-- 
2.1.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
