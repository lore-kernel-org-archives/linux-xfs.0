Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 5284F802A
	for <xfs@oss.sgi.com>; Wed, 11 Dec 2013 05:31:29 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id B1DD8AC018
	for <xfs@oss.sgi.com>; Wed, 11 Dec 2013 03:31:28 -0800 (PST)
Date: Wed, 11 Dec 2013 03:31:26 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v3] xfs: free the efi AIL entry on log recovery failure
Message-ID: <20131211113126.GA6248@infradead.org>
References: <20131206212037.560711585@sgi.com>
	<20131208005224.696001432@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131208005224.696001432@sgi.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Mark Tinguely <tinguely@sgi.com>
Cc: xfs@oss.sgi.com

Btw, I really think we need to get rid of abusing the AIL for
tracking EFIs during log recovery before looking at the various
leaks in this area.  I've actually got a lightly tested patch for
that, but didn't make much progress on that series.  If you have
and interest in that area and some spare QA cycles I'd recommend
to base this on the patch below:

---
>From b90935eaba9eb13c67101e5d723513bc6ca6e722 Mon Sep 17 00:00:00 2001
From: Christoph Hellwig <hch@lst.de>
Date: Sat, 23 Nov 2013 20:11:09 +0100
Subject: [PATCH] xfs: simplify EFI/EFD recovery

Use a cancellation table, similar to how we handle buffers instead of
abusing the AIL during recovery.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_extfree_item.c |    8 +-
 fs/xfs/xfs_extfree_item.h |    6 --
 fs/xfs/xfs_log_priv.h     |    1 +
 fs/xfs/xfs_log_recover.c  |  183 +++++++++++++--------------------------------
 4 files changed, 56 insertions(+), 142 deletions(-)

diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
index fb7a4c1..cc5e9fd 100644
--- a/fs/xfs/xfs_extfree_item.c
+++ b/fs/xfs/xfs_extfree_item.c
@@ -312,14 +312,8 @@ xfs_efi_release(xfs_efi_log_item_t	*efip,
 		uint			nextents)
 {
 	ASSERT(atomic_read(&efip->efi_next_extent) >= nextents);
-	if (atomic_sub_and_test(nextents, &efip->efi_next_extent)) {
-		/* recovery needs us to drop the EFI reference, too */
-		if (test_bit(XFS_EFI_RECOVERED, &efip->efi_flags))
-			__xfs_efi_release(efip);
-
+	if (atomic_sub_and_test(nextents, &efip->efi_next_extent))
 		__xfs_efi_release(efip);
-		/* efip may now have been freed, do not reference it again. */
-	}
 }
 
 static inline struct xfs_efd_log_item *EFD_ITEM(struct xfs_log_item *lip)
diff --git a/fs/xfs/xfs_extfree_item.h b/fs/xfs/xfs_extfree_item.h
index 0ffbce3..6a70bde 100644
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
@@ -47,7 +42,6 @@ typedef struct xfs_efi_log_item {
 	xfs_log_item_t		efi_item;
 	atomic_t		efi_refcount;
 	atomic_t		efi_next_extent;
-	unsigned long		efi_flags;	/* misc flags */
 	xfs_efi_log_format_t	efi_format;
 } xfs_efi_log_item_t;
 
diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
index 9bc403a..0df5ec3 100644
--- a/fs/xfs/xfs_log_priv.h
+++ b/fs/xfs/xfs_log_priv.h
@@ -368,6 +368,7 @@ struct xlog {
 	uint			l_flags;
 	uint			l_quotaoffs_flag; /* XFS_DQ_*, for QUOTAOFFs */
 	struct list_head	*l_buf_cancel_table;
+	struct list_head	l_efi_cancel;
 	int			l_iclog_hsize;  /* size of iclog header */
 	int			l_iclog_heads;  /* # of iclog header sectors */
 	uint			l_sectBBsize;   /* sector size in BBs (2^n) */
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index b6b669d..1a83739 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -75,6 +75,12 @@ struct xfs_buf_cancel {
 	struct list_head	bc_list;
 };
 
+struct xfs_efi_cancel {
+	struct xfs_efi_log_item *ec_efip;
+	xfs_lsn_t		ec_lsn;
+	struct list_head	ec_list;
+};
+
 /*
  * Sector aligned buffer routines for buffer create/read/write/access
  */
@@ -3059,82 +3065,50 @@ xlog_recover_efi_pass2(
 	struct xlog_recover_item	*item,
 	xfs_lsn_t			lsn)
 {
-	int			error;
-	xfs_mount_t		*mp = log->l_mp;
-	xfs_efi_log_item_t	*efip;
-	xfs_efi_log_format_t	*efi_formatp;
+	struct xfs_efi_cancel		*ecp;
+	int				error;
+	xfs_mount_t			*mp = log->l_mp;
+	xfs_efi_log_format_t		*efi_formatp;
 
 	efi_formatp = item->ri_buf[0].i_addr;
 
-	efip = xfs_efi_init(mp, efi_formatp->efi_nextents);
-	if ((error = xfs_efi_copy_format(&(item->ri_buf[0]),
-					 &(efip->efi_format)))) {
-		xfs_efi_item_free(efip);
+	ecp = kmem_alloc(sizeof(struct xfs_efi_cancel), KM_SLEEP);
+	ecp->ec_lsn = lsn;
+	ecp->ec_efip = xfs_efi_init(mp, efi_formatp->efi_nextents);
+
+	error = xfs_efi_copy_format(&item->ri_buf[0],
+				    &ecp->ec_efip->efi_format);
+	if (error) {
+		xfs_efi_item_free(ecp->ec_efip);
 		return error;
 	}
-	atomic_set(&efip->efi_next_extent, efi_formatp->efi_nextents);
-
-	spin_lock(&log->l_ailp->xa_lock);
-	/*
-	 * xfs_trans_ail_update() drops the AIL lock.
-	 */
-	xfs_trans_ail_update(log->l_ailp, &efip->efi_item, lsn);
+	atomic_set(&ecp->ec_efip->efi_next_extent, efi_formatp->efi_nextents);
+	list_add(&ecp->ec_list, &log->l_efi_cancel);
 	return 0;
 }
 
-
-/*
- * This routine is called when an efd format structure is found in
- * a committed transaction in the log.  It's purpose is to cancel
- * the corresponding efi if it was still in the log.  To do this
- * it searches the AIL for the efi with an id equal to that in the
- * efd format structure.  If we find it, we remove the efi from the
- * AIL and free it.
- */
 STATIC int
 xlog_recover_efd_pass2(
 	struct xlog			*log,
 	struct xlog_recover_item	*item)
 {
-	xfs_efd_log_format_t	*efd_formatp;
-	xfs_efi_log_item_t	*efip = NULL;
-	xfs_log_item_t		*lip;
-	__uint64_t		efi_id;
-	struct xfs_ail_cursor	cur;
-	struct xfs_ail		*ailp = log->l_ailp;
-
-	efd_formatp = item->ri_buf[0].i_addr;
+	struct xfs_efd_log_format	*efd_formatp = item->ri_buf[0].i_addr;
+	__uint64_t			efi_id = efd_formatp->efd_efi_id;
+	struct xfs_efi_cancel		*ecp;
+
 	ASSERT((item->ri_buf[0].i_len == (sizeof(xfs_efd_log_format_32_t) +
 		((efd_formatp->efd_nextents - 1) * sizeof(xfs_extent_32_t)))) ||
 	       (item->ri_buf[0].i_len == (sizeof(xfs_efd_log_format_64_t) +
 		((efd_formatp->efd_nextents - 1) * sizeof(xfs_extent_64_t)))));
-	efi_id = efd_formatp->efd_efi_id;
 
-	/*
-	 * Search for the efi with the id in the efd format structure
-	 * in the AIL.
-	 */
-	spin_lock(&ailp->xa_lock);
-	lip = xfs_trans_ail_cursor_first(ailp, &cur, 0);
-	while (lip != NULL) {
-		if (lip->li_type == XFS_LI_EFI) {
-			efip = (xfs_efi_log_item_t *)lip;
-			if (efip->efi_format.efi_id == efi_id) {
-				/*
-				 * xfs_trans_ail_delete() drops the
-				 * AIL lock.
-				 */
-				xfs_trans_ail_delete(ailp, lip,
-						     SHUTDOWN_CORRUPT_INCORE);
-				xfs_efi_item_free(efip);
-				spin_lock(&ailp->xa_lock);
-				break;
-			}
+	list_for_each_entry(ecp, &log->l_efi_cancel, ec_list) {
+		if (ecp->ec_efip->efi_format.efi_id == efi_id) {
+			list_del(&ecp->ec_list);
+			xfs_efi_item_free(ecp->ec_efip);
+			kmem_free(ecp);
+			break;
 		}
-		lip = xfs_trans_ail_cursor_next(ailp, &cur);
 	}
-	xfs_trans_ail_cursor_done(ailp, &cur);
-	spin_unlock(&ailp->xa_lock);
 
 	return 0;
 }
@@ -3618,27 +3592,26 @@ xlog_recover_process_data(
 }
 
 /*
- * Process an extent free intent item that was recovered from
- * the log.  We need to free the extents that it describes.
+ * Process an extent free intent item that was recovered from the log.
+ * We need to free the extents that it describes.
  */
 STATIC int
 xlog_recover_process_efi(
-	xfs_mount_t		*mp,
-	xfs_efi_log_item_t	*efip)
+	struct xlog		*log,
+	struct xfs_efi_cancel	*ecp)
 {
-	xfs_efd_log_item_t	*efdp;
-	xfs_trans_t		*tp;
-	int			i;
-	int			error = 0;
-	xfs_extent_t		*extp;
+	struct xfs_mount	*mp = log->l_mp;
+	struct xfs_efi_log_item	*efip = ecp->ec_efip;
+	struct xfs_efd_log_item	*efdp;
+	struct xfs_trans	*tp;
+	struct xfs_extent	*extp;
 	xfs_fsblock_t		startblock_fsb;
-
-	ASSERT(!test_bit(XFS_EFI_RECOVERED, &efip->efi_flags));
+	int			error = 0;
+	int			i;
 
 	/*
-	 * First check the validity of the extents described by the
-	 * EFI.  If any are bad, then assume that all are bad and
-	 * just toss the EFI.
+	 * First check the validity of the extents described by the EFI.
+	 * If any are bad, then assume that all are bad and just toss the EFI.
 	 */
 	for (i = 0; i < efip->efi_format.efi_nextents; i++) {
 		extp = &(efip->efi_format.efi_extents[i]);
@@ -3652,12 +3625,14 @@ xlog_recover_process_efi(
 			 * This will pull the EFI from the AIL and
 			 * free the memory associated with it.
 			 */
-			set_bit(XFS_EFI_RECOVERED, &efip->efi_flags);
 			xfs_efi_release(efip, efip->efi_format.efi_nextents);
 			return XFS_ERROR(EIO);
 		}
 	}
 
+	spin_lock(&log->l_ailp->xa_lock);
+	xfs_trans_ail_update(log->l_ailp, &efip->efi_item, ecp->ec_lsn);
+
 	tp = xfs_trans_alloc(mp, 0);
 	error = xfs_trans_reserve(tp, &M_RES(mp)->tr_itruncate, 0, 0);
 	if (error)
@@ -3673,78 +3648,27 @@ xlog_recover_process_efi(
 					 extp->ext_len);
 	}
 
-	set_bit(XFS_EFI_RECOVERED, &efip->efi_flags);
-	error = xfs_trans_commit(tp, 0);
-	return error;
+	return xfs_trans_commit(tp, 0);
 
 abort_error:
 	xfs_trans_cancel(tp, XFS_TRANS_ABORT);
 	return error;
 }
 
-/*
- * When this is called, all of the EFIs which did not have
- * corresponding EFDs should be in the AIL.  What we do now
- * is free the extents associated with each one.
- *
- * Since we process the EFIs in normal transactions, they
- * will be removed at some point after the commit.  This prevents
- * us from just walking down the list processing each one.
- * We'll use a flag in the EFI to skip those that we've already
- * processed and use the AIL iteration mechanism's generation
- * count to try to speed this up at least a bit.
- *
- * When we start, we know that the EFIs are the only things in
- * the AIL.  As we process them, however, other items are added
- * to the AIL.  Since everything added to the AIL must come after
- * everything already in the AIL, we stop processing as soon as
- * we see something other than an EFI in the AIL.
- */
 STATIC int
 xlog_recover_process_efis(
 	struct xlog	*log)
 {
-	xfs_log_item_t		*lip;
-	xfs_efi_log_item_t	*efip;
+	struct xfs_efi_cancel	*ecp, *next;
 	int			error = 0;
-	struct xfs_ail_cursor	cur;
-	struct xfs_ail		*ailp;
-
-	ailp = log->l_ailp;
-	spin_lock(&ailp->xa_lock);
-	lip = xfs_trans_ail_cursor_first(ailp, &cur, 0);
-	while (lip != NULL) {
-		/*
-		 * We're done when we see something other than an EFI.
-		 * There should be no EFIs left in the AIL now.
-		 */
-		if (lip->li_type != XFS_LI_EFI) {
-#ifdef DEBUG
-			for (; lip; lip = xfs_trans_ail_cursor_next(ailp, &cur))
-				ASSERT(lip->li_type != XFS_LI_EFI);
-#endif
-			break;
-		}
 
-		/*
-		 * Skip EFIs that we've already processed.
-		 */
-		efip = (xfs_efi_log_item_t *)lip;
-		if (test_bit(XFS_EFI_RECOVERED, &efip->efi_flags)) {
-			lip = xfs_trans_ail_cursor_next(ailp, &cur);
-			continue;
-		}
-
-		spin_unlock(&ailp->xa_lock);
-		error = xlog_recover_process_efi(log->l_mp, efip);
-		spin_lock(&ailp->xa_lock);
+	list_for_each_entry_safe(ecp, next, &log->l_efi_cancel, ec_list) {
+		list_del(&ecp->ec_list);
+		error = xlog_recover_process_efi(log, ecp);
 		if (error)
-			goto out;
-		lip = xfs_trans_ail_cursor_next(ailp, &cur);
+			break; /* XXX: will leak remaining EFIs.. */
 	}
-out:
-	xfs_trans_ail_cursor_done(ailp, &cur);
-	spin_unlock(&ailp->xa_lock);
+
 	return error;
 }
 
@@ -4320,6 +4244,7 @@ xlog_do_log_recovery(
 						 KM_SLEEP);
 	for (i = 0; i < XLOG_BC_TABLE_SIZE; i++)
 		INIT_LIST_HEAD(&log->l_buf_cancel_table[i]);
+	INIT_LIST_HEAD(&log->l_efi_cancel);
 
 	error = xlog_do_recovery_pass(log, head_blk, tail_blk,
 				      XLOG_RECOVER_PASS1);
-- 
1.7.10.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
