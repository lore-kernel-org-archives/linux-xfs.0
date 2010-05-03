Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o43DWe3v156458 for <xfs@oss.sgi.com>; Mon, 3 May 2010 08:32:40 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 572EB1554454
	for <xfs@oss.sgi.com>; Mon,  3 May 2010 06:34:48 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id PBFBbK0gy8iletOz for
	<xfs@oss.sgi.com>; Mon, 03 May 2010 06:34:48 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.69 #1 (Red Hat
	Linux)) id 1O8vnL-0005bJ-Gz
	for xfs@oss.sgi.com; Mon, 03 May 2010 13:34:47 +0000
Date: Mon, 3 May 2010 09:34:47 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH] xfs: kill xfs_trans_find_item
Message-ID: <20100503133447.GA21325@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

xfs_trans_find_item is just and awkward way to derefence ->li_desc in
the log_item structure.  So replace the calls to it with the direct
reference, and while we're at it also make these type-safe instead using
casts.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/quota/xfs_trans_dquot.c
===================================================================
--- xfs.orig/fs/xfs/quota/xfs_trans_dquot.c	2010-04-30 18:33:49.928263075 +0200
+++ xfs/fs/xfs/quota/xfs_trans_dquot.c	2010-05-03 15:28:51.713004310 +0200
@@ -93,12 +93,10 @@ xfs_trans_log_dquot(
 	xfs_trans_t	*tp,
 	xfs_dquot_t	*dqp)
 {
-	xfs_log_item_desc_t	*lidp;
+	xfs_log_item_desc_t	*lidp = dqp->q_logitem.qli_item.li_desc;
 
 	ASSERT(dqp->q_transp == tp);
 	ASSERT(XFS_DQ_IS_LOCKED(dqp));
-
-	lidp = xfs_trans_find_item(tp, (xfs_log_item_t*)(&dqp->q_logitem));
 	ASSERT(lidp != NULL);
 
 	tp->t_flags |= XFS_TRANS_DIRTY;
@@ -890,9 +888,8 @@ xfs_trans_log_quotaoff_item(
 	xfs_trans_t		*tp,
 	xfs_qoff_logitem_t	*qlp)
 {
-	xfs_log_item_desc_t	*lidp;
+	xfs_log_item_desc_t	*lidp = qlp->qql_item.li_desc;
 
-	lidp = xfs_trans_find_item(tp, (xfs_log_item_t *)qlp);
 	ASSERT(lidp != NULL);
 
 	tp->t_flags |= XFS_TRANS_DIRTY;
Index: xfs/fs/xfs/xfs_buf_item.c
===================================================================
--- xfs.orig/fs/xfs/xfs_buf_item.c	2010-05-01 15:06:36.160254276 +0200
+++ xfs/fs/xfs/xfs_buf_item.c	2010-05-03 15:28:51.714004520 +0200
@@ -441,13 +441,10 @@ xfs_buf_item_unpin_remove(
 		 * occurs later in the xfs_trans_uncommit() will try to
 		 * reference the buffer which we no longer have a hold on.
 		 */
-		struct xfs_log_item_desc *lidp;
-
 		ASSERT(XFS_BUF_VALUSEMA(bip->bli_buf) <= 0);
 		trace_xfs_buf_item_unpin_stale(bip);
 
-		lidp = xfs_trans_find_item(tp, (xfs_log_item_t *)bip);
-		xfs_trans_free_item(tp, lidp);
+		xfs_trans_free_item(tp, bip->bli_item.li_desc);
 
 		/*
 		 * Since the transaction no longer refers to the buffer, the
Index: xfs/fs/xfs/xfs_extfree_item.c
===================================================================
--- xfs.orig/fs/xfs/xfs_extfree_item.c	2010-04-30 18:33:49.911254275 +0200
+++ xfs/fs/xfs/xfs_extfree_item.c	2010-05-03 15:28:51.719004170 +0200
@@ -132,18 +132,18 @@ STATIC void
 xfs_efi_item_unpin_remove(xfs_efi_log_item_t *efip, xfs_trans_t *tp)
 {
 	struct xfs_ail		*ailp = efip->efi_item.li_ailp;
-	xfs_log_item_desc_t	*lidp;
 
 	spin_lock(&ailp->xa_lock);
 	if (efip->efi_flags & XFS_EFI_CANCELED) {
+		xfs_log_item_t	*lip = &efip->efi_item;
+
 		/*
 		 * free the xaction descriptor pointing to this item
 		 */
-		lidp = xfs_trans_find_item(tp, (xfs_log_item_t *) efip);
-		xfs_trans_free_item(tp, lidp);
+		xfs_trans_free_item(tp, lip->li_desc);
 
 		/* xfs_trans_ail_delete() drops the AIL lock. */
-		xfs_trans_ail_delete(ailp, (xfs_log_item_t *)efip);
+		xfs_trans_ail_delete(ailp, lip);
 		xfs_efi_item_free(efip);
 	} else {
 		efip->efi_flags |= XFS_EFI_COMMITTED;
Index: xfs/fs/xfs/xfs_trans_buf.c
===================================================================
--- xfs.orig/fs/xfs/xfs_trans_buf.c	2010-05-01 14:59:07.653003960 +0200
+++ xfs/fs/xfs/xfs_trans_buf.c	2010-05-03 15:28:51.723003751 +0200
@@ -518,7 +518,7 @@ xfs_trans_brelse(xfs_trans_t	*tp,
 	 * Find the item descriptor pointing to this buffer's
 	 * log item.  It must be there.
 	 */
-	lidp = xfs_trans_find_item(tp, (xfs_log_item_t*)bip);
+	lidp = bip->bli_item.li_desc;
 	ASSERT(lidp != NULL);
 
 	trace_xfs_trans_brelse(bip);
@@ -707,7 +707,7 @@ xfs_trans_log_buf(xfs_trans_t	*tp,
 		bip->bli_format.blf_flags &= ~XFS_BLI_CANCEL;
 	}
 
-	lidp = xfs_trans_find_item(tp, (xfs_log_item_t*)bip);
+	lidp = bip->bli_item.li_desc;
 	ASSERT(lidp != NULL);
 
 	tp->t_flags |= XFS_TRANS_DIRTY;
@@ -748,7 +748,7 @@ xfs_trans_binval(
 	ASSERT(XFS_BUF_FSPRIVATE(bp, void *) != NULL);
 
 	bip = XFS_BUF_FSPRIVATE(bp, xfs_buf_log_item_t *);
-	lidp = xfs_trans_find_item(tp, (xfs_log_item_t*)bip);
+	lidp = bip->bli_item.li_desc;
 	ASSERT(lidp != NULL);
 	ASSERT(atomic_read(&bip->bli_refcount) > 0);
 
Index: xfs/fs/xfs/xfs_trans_extfree.c
===================================================================
--- xfs.orig/fs/xfs/xfs_trans_extfree.c	2010-05-01 14:59:07.653003960 +0200
+++ xfs/fs/xfs/xfs_trans_extfree.c	2010-05-03 15:28:51.728005428 +0200
@@ -65,11 +65,10 @@ xfs_trans_log_efi_extent(xfs_trans_t		*t
 			 xfs_fsblock_t		start_block,
 			 xfs_extlen_t		ext_len)
 {
-	xfs_log_item_desc_t	*lidp;
+	xfs_log_item_desc_t	*lidp = efip->efi_item.li_desc;
 	uint			next_extent;
 	xfs_extent_t		*extp;
 
-	lidp = xfs_trans_find_item(tp, (xfs_log_item_t*)efip);
 	ASSERT(lidp != NULL);
 
 	tp->t_flags |= XFS_TRANS_DIRTY;
@@ -122,11 +121,10 @@ xfs_trans_log_efd_extent(xfs_trans_t		*t
 			 xfs_fsblock_t		start_block,
 			 xfs_extlen_t		ext_len)
 {
-	xfs_log_item_desc_t	*lidp;
+	xfs_log_item_desc_t	*lidp = efdp->efd_item.li_desc;
 	uint			next_extent;
 	xfs_extent_t		*extp;
 
-	lidp = xfs_trans_find_item(tp, (xfs_log_item_t*)efdp);
 	ASSERT(lidp != NULL);
 
 	tp->t_flags |= XFS_TRANS_DIRTY;
Index: xfs/fs/xfs/xfs_trans_inode.c
===================================================================
--- xfs.orig/fs/xfs/xfs_trans_inode.c	2010-04-30 18:33:49.886254554 +0200
+++ xfs/fs/xfs/xfs_trans_inode.c	2010-05-03 15:28:51.732005497 +0200
@@ -149,13 +149,11 @@ xfs_trans_log_inode(
 	xfs_inode_t	*ip,
 	uint		flags)
 {
-	xfs_log_item_desc_t	*lidp;
+	xfs_log_item_desc_t	*lidp = ip->i_itemp->ili_item.li_desc;
 
 	ASSERT(ip->i_transp == tp);
 	ASSERT(ip->i_itemp != NULL);
 	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
-
-	lidp = xfs_trans_find_item(tp, (xfs_log_item_t*)(ip->i_itemp));
 	ASSERT(lidp != NULL);
 
 	tp->t_flags |= XFS_TRANS_DIRTY;
Index: xfs/fs/xfs/xfs_trans_item.c
===================================================================
--- xfs.orig/fs/xfs/xfs_trans_item.c	2010-05-01 14:59:07.653003960 +0200
+++ xfs/fs/xfs/xfs_trans_item.c	2010-05-03 15:28:51.736005218 +0200
@@ -177,25 +177,6 @@ xfs_trans_free_item(xfs_trans_t	*tp, xfs
 }
 
 /*
- * This is called to find the descriptor corresponding to the given
- * log item.  It returns a pointer to the descriptor.
- * The log item MUST have a corresponding descriptor in the given
- * transaction.  This routine does not return NULL, it panics.
- *
- * The descriptor pointer is kept in the log item's li_desc field.
- * Just return it.
- */
-/*ARGSUSED*/
-xfs_log_item_desc_t *
-xfs_trans_find_item(xfs_trans_t	*tp, xfs_log_item_t *lip)
-{
-	ASSERT(lip->li_desc != NULL);
-
-	return lip->li_desc;
-}
-
-
-/*
  * Return a pointer to the first descriptor in the chunk list.
  * This does not return NULL if there are none, it panics.
  *
Index: xfs/fs/xfs/xfs_trans_priv.h
===================================================================
--- xfs.orig/fs/xfs/xfs_trans_priv.h	2010-05-01 14:59:07.654003960 +0200
+++ xfs/fs/xfs/xfs_trans_priv.h	2010-05-03 15:28:51.740033714 +0200
@@ -30,8 +30,6 @@ struct xfs_log_item_desc	*xfs_trans_add_
 					    struct xfs_log_item *);
 void				xfs_trans_free_item(struct xfs_trans *,
 					    struct xfs_log_item_desc *);
-struct xfs_log_item_desc	*xfs_trans_find_item(struct xfs_trans *,
-					     struct xfs_log_item *);
 struct xfs_log_item_desc	*xfs_trans_first_item(struct xfs_trans *);
 struct xfs_log_item_desc	*xfs_trans_next_item(struct xfs_trans *,
 					     struct xfs_log_item_desc *);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
