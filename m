Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6AKoLfQ153486 for <xfs@oss.sgi.com>; Sun, 10 Jul 2011 15:50:21 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 89E2417955AE
	for <xfs@oss.sgi.com>; Sun, 10 Jul 2011 13:50:18 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	3CXvc6ptoIfHa3bK for <xfs@oss.sgi.com>;
	Sun, 10 Jul 2011 13:50:18 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1Qg0xF-0002vp-T9
	for xfs@oss.sgi.com; Sun, 10 Jul 2011 20:50:17 +0000
Message-Id: <20110710205017.863949257@bombadil.infradead.org>
Date: Sun, 10 Jul 2011 16:49:22 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 06/11] xfs: remove wrappers around b_fspriv
References: <20110710204916.856267100@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-simplify-b_fspriv
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/linux-2.6/xfs_buf.h
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_buf.h	2011-07-09 09:34:12.288966468 +0200
+++ xfs/fs/xfs/linux-2.6/xfs_buf.h	2011-07-09 09:34:13.248966419 +0200
@@ -280,8 +280,6 @@ void xfs_buf_stale(struct xfs_buf *bp);
 #define XFS_BUF_SET_IODONE_FUNC(bp, func)	((bp)->b_iodone = (func))
 #define XFS_BUF_CLR_IODONE_FUNC(bp)		((bp)->b_iodone = NULL)
 
-#define XFS_BUF_FSPRIVATE(bp, type)		((type)(bp)->b_fspriv)
-#define XFS_BUF_SET_FSPRIVATE(bp, val)		((bp)->b_fspriv = (void*)(val))
 #define XFS_BUF_SET_START(bp)			do { } while (0)
 
 #define XFS_BUF_PTR(bp)			(xfs_caddr_t)((bp)->b_addr)
Index: xfs/fs/xfs/xfs_buf_item.c
===================================================================
--- xfs.orig/fs/xfs/xfs_buf_item.c	2011-07-09 09:34:12.292299803 +0200
+++ xfs/fs/xfs/xfs_buf_item.c	2011-07-09 09:34:13.252299751 +0200
@@ -90,13 +90,11 @@ xfs_buf_item_flush_log_debug(
 	uint		first,
 	uint		last)
 {
-	xfs_buf_log_item_t	*bip;
+	xfs_buf_log_item_t	*bip = bp->b_fspriv;
 	uint			nbytes;
 
-	bip = XFS_BUF_FSPRIVATE(bp, xfs_buf_log_item_t*);
-	if ((bip == NULL) || (bip->bli_item.li_type != XFS_LI_BUF)) {
+	if (bip == NULL || (bip->bli_item.li_type != XFS_LI_BUF))
 		return;
-	}
 
 	ASSERT(bip->bli_logged != NULL);
 	nbytes = last - first + 1;
@@ -408,7 +406,7 @@ xfs_buf_item_unpin(
 	int		stale = bip->bli_flags & XFS_BLI_STALE;
 	int		freed;
 
-	ASSERT(XFS_BUF_FSPRIVATE(bp, xfs_buf_log_item_t *) == bip);
+	ASSERT(bp->b_fspriv == bip);
 	ASSERT(atomic_read(&bip->bli_refcount) > 0);
 
 	trace_xfs_buf_item_unpin(bip);
@@ -454,13 +452,13 @@ xfs_buf_item_unpin(
 		 */
 		if (bip->bli_flags & XFS_BLI_STALE_INODE) {
 			xfs_buf_do_callbacks(bp);
-			XFS_BUF_SET_FSPRIVATE(bp, NULL);
+			bp->b_fspriv = NULL;
 			XFS_BUF_CLR_IODONE_FUNC(bp);
 		} else {
 			spin_lock(&ailp->xa_lock);
 			xfs_trans_ail_delete(ailp, (xfs_log_item_t *)bip);
 			xfs_buf_item_relse(bp);
-			ASSERT(XFS_BUF_FSPRIVATE(bp, void *) == NULL);
+			ASSERT(bp->b_fspriv == NULL);
 		}
 		xfs_buf_relse(bp);
 	}
@@ -684,7 +682,7 @@ xfs_buf_item_init(
 	xfs_buf_t	*bp,
 	xfs_mount_t	*mp)
 {
-	xfs_log_item_t		*lip;
+	xfs_log_item_t		*lip = bp->b_fspriv;
 	xfs_buf_log_item_t	*bip;
 	int			chunks;
 	int			map_size;
@@ -696,12 +694,8 @@ xfs_buf_item_init(
 	 * nothing to do here so return.
 	 */
 	ASSERT(bp->b_target->bt_mount == mp);
-	if (XFS_BUF_FSPRIVATE(bp, void *) != NULL) {
-		lip = XFS_BUF_FSPRIVATE(bp, xfs_log_item_t *);
-		if (lip->li_type == XFS_LI_BUF) {
-			return;
-		}
-	}
+	if (lip != NULL && lip->li_type == XFS_LI_BUF)
+		return;
 
 	/*
 	 * chunks is the number of XFS_BLF_CHUNK size pieces
@@ -740,11 +734,9 @@ xfs_buf_item_init(
 	 * Put the buf item into the list of items attached to the
 	 * buffer at the front.
 	 */
-	if (XFS_BUF_FSPRIVATE(bp, void *) != NULL) {
-		bip->bli_item.li_bio_list =
-				XFS_BUF_FSPRIVATE(bp, xfs_log_item_t *);
-	}
-	XFS_BUF_SET_FSPRIVATE(bp, bip);
+	if (bp->b_fspriv)
+		bip->bli_item.li_bio_list = bp->b_fspriv;
+	bp->b_fspriv = bip;
 }
 
 
@@ -876,12 +868,11 @@ xfs_buf_item_relse(
 
 	trace_xfs_buf_item_relse(bp, _RET_IP_);
 
-	bip = XFS_BUF_FSPRIVATE(bp, xfs_buf_log_item_t*);
-	XFS_BUF_SET_FSPRIVATE(bp, bip->bli_item.li_bio_list);
-	if ((XFS_BUF_FSPRIVATE(bp, void *) == NULL) &&
-	    (XFS_BUF_IODONE_FUNC(bp) != NULL)) {
+	bip = bp->b_fspriv;
+	bp->b_fspriv = bip->bli_item.li_bio_list;
+	if (bp->b_fspriv == NULL && XFS_BUF_IODONE_FUNC(bp) != NULL)
 		XFS_BUF_CLR_IODONE_FUNC(bp);
-	}
+
 	xfs_buf_rele(bp);
 	xfs_buf_item_free(bip);
 }
@@ -908,12 +899,12 @@ xfs_buf_attach_iodone(
 	ASSERT(xfs_buf_islocked(bp));
 
 	lip->li_cb = cb;
-	if (XFS_BUF_FSPRIVATE(bp, void *) != NULL) {
-		head_lip = XFS_BUF_FSPRIVATE(bp, xfs_log_item_t *);
+	head_lip = bp->b_fspriv;
+	if (head_lip) {
 		lip->li_bio_list = head_lip->li_bio_list;
 		head_lip->li_bio_list = lip;
 	} else {
-		XFS_BUF_SET_FSPRIVATE(bp, lip);
+		bp->b_fspriv = lip;
 	}
 
 	ASSERT((XFS_BUF_IODONE_FUNC(bp) == xfs_buf_iodone_callbacks) ||
@@ -939,8 +930,8 @@ xfs_buf_do_callbacks(
 {
 	struct xfs_log_item	*lip;
 
-	while ((lip = XFS_BUF_FSPRIVATE(bp, xfs_log_item_t *)) != NULL) {
-		XFS_BUF_SET_FSPRIVATE(bp, lip->li_bio_list);
+	while ((lip = bp->b_fspriv) != NULL) {
+		bp->b_fspriv = lip->li_bio_list;
 		ASSERT(lip->li_cb != NULL);
 		/*
 		 * Clear the next pointer so we don't have any
@@ -1026,7 +1017,7 @@ xfs_buf_iodone_callbacks(
 
 do_callbacks:
 	xfs_buf_do_callbacks(bp);
-	XFS_BUF_SET_FSPRIVATE(bp, NULL);
+	bp->b_fspriv = NULL;
 	XFS_BUF_CLR_IODONE_FUNC(bp);
 	xfs_buf_ioend(bp, 0);
 }
Index: xfs/fs/xfs/xfs_inode.c
===================================================================
--- xfs.orig/fs/xfs/xfs_inode.c	2011-07-09 09:16:01.012355050 +0200
+++ xfs/fs/xfs/xfs_inode.c	2011-07-09 09:34:13.255633083 +0200
@@ -1698,7 +1698,7 @@ xfs_ifree_cluster(
 		 * stale first, we will not attempt to lock them in the loop
 		 * below as the XFS_ISTALE flag will be set.
 		 */
-		lip = XFS_BUF_FSPRIVATE(bp, xfs_log_item_t *);
+		lip = bp->b_fspriv;
 		while (lip) {
 			if (lip->li_type == XFS_LI_INODE) {
 				iip = (xfs_inode_log_item_t *)lip;
@@ -2811,7 +2811,7 @@ xfs_iflush_int(
 		 */
 		xfs_buf_attach_iodone(bp, xfs_iflush_done, &iip->ili_item);
 
-		ASSERT(XFS_BUF_FSPRIVATE(bp, void *) != NULL);
+		ASSERT(bp->b_fspriv != NULL);
 		ASSERT(XFS_BUF_IODONE_FUNC(bp) != NULL);
 	} else {
 		/*
Index: xfs/fs/xfs/xfs_log.c
===================================================================
--- xfs.orig/fs/xfs/xfs_log.c	2011-07-09 09:34:12.292299803 +0200
+++ xfs/fs/xfs/xfs_log.c	2011-07-09 09:34:13.258966416 +0200
@@ -871,13 +871,9 @@ xlog_space_left(
 void
 xlog_iodone(xfs_buf_t *bp)
 {
-	xlog_in_core_t	*iclog;
-	xlog_t		*l;
-	int		aborted;
-
-	iclog = XFS_BUF_FSPRIVATE(bp, xlog_in_core_t *);
-	aborted = 0;
-	l = iclog->ic_log;
+	xlog_in_core_t	*iclog = bp->b_fspriv;
+	xlog_t		*l = iclog->ic_log;
+	int		aborted = 0;
 
 	/*
 	 * Race to shutdown the filesystem if we see an error.
@@ -1249,9 +1245,8 @@ STATIC int
 xlog_bdstrat(
 	struct xfs_buf		*bp)
 {
-	struct xlog_in_core	*iclog;
+	struct xlog_in_core	*iclog = bp->b_fspriv;
 
-	iclog = XFS_BUF_FSPRIVATE(bp, xlog_in_core_t *);
 	if (iclog->ic_state & XLOG_STATE_IOERROR) {
 		XFS_BUF_ERROR(bp, EIO);
 		XFS_BUF_STALE(bp);
@@ -1358,7 +1353,7 @@ xlog_sync(xlog_t		*log,
 		iclog->ic_bwritecnt = 1;
 	}
 	XFS_BUF_SET_COUNT(bp, count);
-	XFS_BUF_SET_FSPRIVATE(bp, iclog);	/* save for later */
+	bp->b_fspriv = iclog;
 	XFS_BUF_ZEROFLAGS(bp);
 	XFS_BUF_BUSY(bp);
 	XFS_BUF_ASYNC(bp);
@@ -1405,7 +1400,7 @@ xlog_sync(xlog_t		*log,
 		XFS_BUF_SET_ADDR(bp, 0);	     /* logical 0 */
 		XFS_BUF_SET_PTR(bp, (xfs_caddr_t)((__psint_t)&(iclog->ic_header)+
 					    (__psint_t)count), split);
-		XFS_BUF_SET_FSPRIVATE(bp, iclog);
+		bp->b_fspriv = iclog;
 		XFS_BUF_ZEROFLAGS(bp);
 		XFS_BUF_BUSY(bp);
 		XFS_BUF_ASYNC(bp);
Index: xfs/fs/xfs/xfs_trans_buf.c
===================================================================
--- xfs.orig/fs/xfs/xfs_trans_buf.c	2011-07-09 09:34:12.295633137 +0200
+++ xfs/fs/xfs/xfs_trans_buf.c	2011-07-09 09:34:13.258966416 +0200
@@ -89,7 +89,7 @@ _xfs_trans_bjoin(
 	 * The checks to see if one is there are in xfs_buf_item_init().
 	 */
 	xfs_buf_item_init(bp, tp->t_mountp);
-	bip = XFS_BUF_FSPRIVATE(bp, xfs_buf_log_item_t *);
+	bip = bp->b_fspriv;
 	ASSERT(!(bip->bli_flags & XFS_BLI_STALE));
 	ASSERT(!(bip->bli_format.blf_flags & XFS_BLF_CANCEL));
 	ASSERT(!(bip->bli_flags & XFS_BLI_LOGGED));
@@ -173,7 +173,7 @@ xfs_trans_get_buf(xfs_trans_t	*tp,
 			ASSERT(!XFS_BUF_ISDELAYWRITE(bp));
 
 		ASSERT(bp->b_transp == tp);
-		bip = XFS_BUF_FSPRIVATE(bp, xfs_buf_log_item_t *);
+		bip = bp->b_fspriv;
 		ASSERT(bip != NULL);
 		ASSERT(atomic_read(&bip->bli_refcount) > 0);
 		bip->bli_recur++;
@@ -233,7 +233,7 @@ xfs_trans_getsb(xfs_trans_t	*tp,
 	 */
 	bp = mp->m_sb_bp;
 	if (bp->b_transp == tp) {
-		bip = XFS_BUF_FSPRIVATE(bp, xfs_buf_log_item_t*);
+		bip = bp->b_fspriv;
 		ASSERT(bip != NULL);
 		ASSERT(atomic_read(&bip->bli_refcount) > 0);
 		bip->bli_recur++;
@@ -329,7 +329,7 @@ xfs_trans_read_buf(
 	if (bp != NULL) {
 		ASSERT(xfs_buf_islocked(bp));
 		ASSERT(bp->b_transp == tp);
-		ASSERT(XFS_BUF_FSPRIVATE(bp, void *) != NULL);
+		ASSERT(bp->b_fspriv != NULL);
 		ASSERT((XFS_BUF_ISERROR(bp)) == 0);
 		if (!(XFS_BUF_ISDONE(bp))) {
 			trace_xfs_trans_read_buf_io(bp, _RET_IP_);
@@ -363,7 +363,7 @@ xfs_trans_read_buf(
 		}
 
 
-		bip = XFS_BUF_FSPRIVATE(bp, xfs_buf_log_item_t*);
+		bip = bp->b_fspriv;
 		bip->bli_recur++;
 
 		ASSERT(atomic_read(&bip->bli_refcount) > 0);
@@ -460,32 +460,30 @@ xfs_trans_brelse(xfs_trans_t	*tp,
 		 xfs_buf_t	*bp)
 {
 	xfs_buf_log_item_t	*bip;
-	xfs_log_item_t		*lip;
 
 	/*
 	 * Default to a normal brelse() call if the tp is NULL.
 	 */
 	if (tp == NULL) {
+		struct xfs_log_item	*lip = bp->b_fspriv;
+
 		ASSERT(bp->b_transp == NULL);
+
 		/*
 		 * If there's a buf log item attached to the buffer,
 		 * then let the AIL know that the buffer is being
 		 * unlocked.
 		 */
-		if (XFS_BUF_FSPRIVATE(bp, void *) != NULL) {
-			lip = XFS_BUF_FSPRIVATE(bp, xfs_log_item_t *);
-			if (lip->li_type == XFS_LI_BUF) {
-				bip = XFS_BUF_FSPRIVATE(bp,xfs_buf_log_item_t*);
-				xfs_trans_unlocked_item(bip->bli_item.li_ailp,
-							lip);
-			}
+		if (lip != NULL && lip->li_type == XFS_LI_BUF) {
+			bip = bp->b_fspriv;
+			xfs_trans_unlocked_item(bip->bli_item.li_ailp, lip);
 		}
 		xfs_buf_relse(bp);
 		return;
 	}
 
 	ASSERT(bp->b_transp == tp);
-	bip = XFS_BUF_FSPRIVATE(bp, xfs_buf_log_item_t *);
+	bip = bp->b_fspriv;
 	ASSERT(bip->bli_item.li_type == XFS_LI_BUF);
 	ASSERT(!(bip->bli_flags & XFS_BLI_STALE));
 	ASSERT(!(bip->bli_format.blf_flags & XFS_BLF_CANCEL));
@@ -581,16 +579,15 @@ void
 xfs_trans_bhold(xfs_trans_t	*tp,
 		xfs_buf_t	*bp)
 {
-	xfs_buf_log_item_t	*bip;
+	xfs_buf_log_item_t	*bip = bp->b_fspriv;
 
 	ASSERT(XFS_BUF_ISBUSY(bp));
 	ASSERT(bp->b_transp == tp);
-	ASSERT(XFS_BUF_FSPRIVATE(bp, void *) != NULL);
-
-	bip = XFS_BUF_FSPRIVATE(bp, xfs_buf_log_item_t *);
+	ASSERT(bip != NULL);
 	ASSERT(!(bip->bli_flags & XFS_BLI_STALE));
 	ASSERT(!(bip->bli_format.blf_flags & XFS_BLF_CANCEL));
 	ASSERT(atomic_read(&bip->bli_refcount) > 0);
+
 	bip->bli_flags |= XFS_BLI_HOLD;
 	trace_xfs_trans_bhold(bip);
 }
@@ -603,19 +600,17 @@ void
 xfs_trans_bhold_release(xfs_trans_t	*tp,
 			xfs_buf_t	*bp)
 {
-	xfs_buf_log_item_t	*bip;
+	xfs_buf_log_item_t	*bip = bp->b_fspriv;
 
 	ASSERT(XFS_BUF_ISBUSY(bp));
 	ASSERT(bp->b_transp == tp);
-	ASSERT(XFS_BUF_FSPRIVATE(bp, void *) != NULL);
-
-	bip = XFS_BUF_FSPRIVATE(bp, xfs_buf_log_item_t *);
+	ASSERT(bip != NULL);
 	ASSERT(!(bip->bli_flags & XFS_BLI_STALE));
 	ASSERT(!(bip->bli_format.blf_flags & XFS_BLF_CANCEL));
 	ASSERT(atomic_read(&bip->bli_refcount) > 0);
 	ASSERT(bip->bli_flags & XFS_BLI_HOLD);
-	bip->bli_flags &= ~XFS_BLI_HOLD;
 
+	bip->bli_flags &= ~XFS_BLI_HOLD;
 	trace_xfs_trans_bhold_release(bip);
 }
 
@@ -634,11 +629,11 @@ xfs_trans_log_buf(xfs_trans_t	*tp,
 		  uint		first,
 		  uint		last)
 {
-	xfs_buf_log_item_t	*bip;
+	xfs_buf_log_item_t	*bip = bp->b_fspriv;
 
 	ASSERT(XFS_BUF_ISBUSY(bp));
 	ASSERT(bp->b_transp == tp);
-	ASSERT(XFS_BUF_FSPRIVATE(bp, void *) != NULL);
+	ASSERT(bip != NULL);
 	ASSERT((first <= last) && (last < XFS_BUF_COUNT(bp)));
 	ASSERT((XFS_BUF_IODONE_FUNC(bp) == NULL) ||
 	       (XFS_BUF_IODONE_FUNC(bp) == xfs_buf_iodone_callbacks));
@@ -656,7 +651,6 @@ xfs_trans_log_buf(xfs_trans_t	*tp,
 	XFS_BUF_DELAYWRITE(bp);
 	XFS_BUF_DONE(bp);
 
-	bip = XFS_BUF_FSPRIVATE(bp, xfs_buf_log_item_t *);
 	ASSERT(atomic_read(&bip->bli_refcount) > 0);
 	XFS_BUF_SET_IODONE_FUNC(bp, xfs_buf_iodone_callbacks);
 	bip->bli_item.li_cb = xfs_buf_iodone;
@@ -706,13 +700,11 @@ xfs_trans_binval(
 	xfs_trans_t	*tp,
 	xfs_buf_t	*bp)
 {
-	xfs_buf_log_item_t	*bip;
+	xfs_buf_log_item_t	*bip = bp->b_fspriv;
 
 	ASSERT(XFS_BUF_ISBUSY(bp));
 	ASSERT(bp->b_transp == tp);
-	ASSERT(XFS_BUF_FSPRIVATE(bp, void *) != NULL);
-
-	bip = XFS_BUF_FSPRIVATE(bp, xfs_buf_log_item_t *);
+	ASSERT(bip != NULL);
 	ASSERT(atomic_read(&bip->bli_refcount) > 0);
 
 	trace_xfs_trans_binval(bip);
@@ -780,13 +772,11 @@ xfs_trans_inode_buf(
 	xfs_trans_t	*tp,
 	xfs_buf_t	*bp)
 {
-	xfs_buf_log_item_t	*bip;
+	xfs_buf_log_item_t	*bip = bp->b_fspriv;
 
 	ASSERT(XFS_BUF_ISBUSY(bp));
 	ASSERT(bp->b_transp == tp);
-	ASSERT(XFS_BUF_FSPRIVATE(bp, void *) != NULL);
-
-	bip = XFS_BUF_FSPRIVATE(bp, xfs_buf_log_item_t *);
+	ASSERT(bip != NULL);
 	ASSERT(atomic_read(&bip->bli_refcount) > 0);
 
 	bip->bli_flags |= XFS_BLI_INODE_BUF;
@@ -806,13 +796,11 @@ xfs_trans_stale_inode_buf(
 	xfs_trans_t	*tp,
 	xfs_buf_t	*bp)
 {
-	xfs_buf_log_item_t	*bip;
+	xfs_buf_log_item_t	*bip = bp->b_fspriv;
 
 	ASSERT(XFS_BUF_ISBUSY(bp));
 	ASSERT(bp->b_transp == tp);
-	ASSERT(XFS_BUF_FSPRIVATE(bp, void *) != NULL);
-
-	bip = XFS_BUF_FSPRIVATE(bp, xfs_buf_log_item_t *);
+	ASSERT(bip != NULL);
 	ASSERT(atomic_read(&bip->bli_refcount) > 0);
 
 	bip->bli_flags |= XFS_BLI_STALE_INODE;
@@ -833,13 +821,11 @@ xfs_trans_inode_alloc_buf(
 	xfs_trans_t	*tp,
 	xfs_buf_t	*bp)
 {
-	xfs_buf_log_item_t	*bip;
+	xfs_buf_log_item_t	*bip = bp->b_fspriv;
 
 	ASSERT(XFS_BUF_ISBUSY(bp));
 	ASSERT(bp->b_transp == tp);
-	ASSERT(XFS_BUF_FSPRIVATE(bp, void *) != NULL);
-
-	bip = XFS_BUF_FSPRIVATE(bp, xfs_buf_log_item_t *);
+	ASSERT(bip != NULL);
 	ASSERT(atomic_read(&bip->bli_refcount) > 0);
 
 	bip->bli_flags |= XFS_BLI_INODE_ALLOC_BUF;
@@ -863,16 +849,14 @@ xfs_trans_dquot_buf(
 	xfs_buf_t	*bp,
 	uint		type)
 {
-	xfs_buf_log_item_t	*bip;
+	xfs_buf_log_item_t	*bip = bp->b_fspriv;
 
 	ASSERT(XFS_BUF_ISBUSY(bp));
 	ASSERT(bp->b_transp == tp);
-	ASSERT(XFS_BUF_FSPRIVATE(bp, void *) != NULL);
+	ASSERT(bip != NULL);
 	ASSERT(type == XFS_BLF_UDQUOT_BUF ||
 	       type == XFS_BLF_PDQUOT_BUF ||
 	       type == XFS_BLF_GDQUOT_BUF);
-
-	bip = XFS_BUF_FSPRIVATE(bp, xfs_buf_log_item_t *);
 	ASSERT(atomic_read(&bip->bli_refcount) > 0);
 
 	bip->bli_format.blf_flags |= type;
Index: xfs/fs/xfs/xfs_inode_item.c
===================================================================
--- xfs.orig/fs/xfs/xfs_inode_item.c	2011-07-09 09:16:01.012355050 +0200
+++ xfs/fs/xfs/xfs_inode_item.c	2011-07-09 09:34:13.262299750 +0200
@@ -874,7 +874,7 @@ xfs_iflush_done(
 	 * Scan the buffer IO completions for other inodes being completed and
 	 * attach them to the current inode log item.
 	 */
-	blip = XFS_BUF_FSPRIVATE(bp, xfs_log_item_t *);
+	blip = bp->b_fspriv;
 	prev = NULL;
 	while (blip != NULL) {
 		if (lip->li_cb != xfs_iflush_done) {
@@ -886,7 +886,7 @@ xfs_iflush_done(
 		/* remove from list */
 		next = blip->li_bio_list;
 		if (!prev) {
-			XFS_BUF_SET_FSPRIVATE(bp, next);
+			bp->b_fspriv = next;
 		} else {
 			prev->li_bio_list = next;
 		}

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
