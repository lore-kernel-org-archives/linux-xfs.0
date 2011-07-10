Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6AKoLUE153473 for <xfs@oss.sgi.com>; Sun, 10 Jul 2011 15:50:21 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5324A179463C
	for <xfs@oss.sgi.com>; Sun, 10 Jul 2011 13:50:18 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	Drjh0okbBvFqQEju for <xfs@oss.sgi.com>;
	Sun, 10 Jul 2011 13:50:18 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1Qg0xF-0002vJ-Mj
	for xfs@oss.sgi.com; Sun, 10 Jul 2011 20:50:17 +0000
Message-Id: <20110710205017.667546845@bombadil.infradead.org>
Date: Sun, 10 Jul 2011 16:49:21 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 05/11] xfs: add a proper transaction pointer to struct xfs_buf
References: <20110710204916.856267100@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-add-b_trans
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

Replace the typeless b_fspriv2 and the ugly macros around it with a properly
typed transaction pointer.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/linux-2.6/xfs_buf.h
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_buf.h	2011-07-01 11:35:50.000000000 +0200
+++ xfs/fs/xfs/linux-2.6/xfs_buf.h	2011-07-01 11:43:33.737416011 +0200
@@ -149,7 +149,7 @@ typedef struct xfs_buf {
 	xfs_buf_iodone_t	b_iodone;	/* I/O completion function */
 	struct completion	b_iowait;	/* queue for I/O waiters */
 	void			*b_fspriv;
-	void			*b_fspriv2;
+	struct xfs_trans	*b_transp;
 	struct page		**b_pages;	/* array of page pointers */
 	struct page		*b_page_array[XB_PAGES]; /* inline pages */
 	unsigned long		b_queuetime;	/* time buffer was queued */
@@ -282,8 +282,6 @@ void xfs_buf_stale(struct xfs_buf *bp);
 
 #define XFS_BUF_FSPRIVATE(bp, type)		((type)(bp)->b_fspriv)
 #define XFS_BUF_SET_FSPRIVATE(bp, val)		((bp)->b_fspriv = (void*)(val))
-#define XFS_BUF_FSPRIVATE2(bp, type)		((type)(bp)->b_fspriv2)
-#define XFS_BUF_SET_FSPRIVATE2(bp, val)		((bp)->b_fspriv2 = (void*)(val))
 #define XFS_BUF_SET_START(bp)			do { } while (0)
 
 #define XFS_BUF_PTR(bp)			(xfs_caddr_t)((bp)->b_addr)
Index: xfs/fs/xfs/xfs_buf_item.c
===================================================================
--- xfs.orig/fs/xfs/xfs_buf_item.c	2011-07-01 11:35:50.000000000 +0200
+++ xfs/fs/xfs/xfs_buf_item.c	2011-07-01 11:43:33.737416011 +0200
@@ -443,7 +443,7 @@ xfs_buf_item_unpin(
 			 * Since the transaction no longer refers to the buffer,
 			 * the buffer should no longer refer to the transaction.
 			 */
-			XFS_BUF_SET_FSPRIVATE2(bp, NULL);
+			bp->b_transp = NULL;
 		}
 
 		/*
@@ -525,7 +525,7 @@ xfs_buf_item_unlock(
 	uint			hold;
 
 	/* Clear the buffer's association with this transaction. */
-	XFS_BUF_SET_FSPRIVATE2(bp, NULL);
+	bp->b_transp = NULL;
 
 	/*
 	 * If this is a transaction abort, don't return early.  Instead, allow
Index: xfs/fs/xfs/xfs_log.c
===================================================================
--- xfs.orig/fs/xfs/xfs_log.c	2011-07-01 11:35:51.000000000 +0200
+++ xfs/fs/xfs/xfs_log.c	2011-07-01 11:43:33.740749344 +0200
@@ -876,8 +876,6 @@ xlog_iodone(xfs_buf_t *bp)
 	int		aborted;
 
 	iclog = XFS_BUF_FSPRIVATE(bp, xlog_in_core_t *);
-	ASSERT(XFS_BUF_FSPRIVATE2(bp, unsigned long) == (unsigned long) 2);
-	XFS_BUF_SET_FSPRIVATE2(bp, (unsigned long)1);
 	aborted = 0;
 	l = iclog->ic_log;
 
@@ -1057,7 +1055,6 @@ xlog_alloc_log(xfs_mount_t	*mp,
 	if (!bp)
 		goto out_free_log;
 	XFS_BUF_SET_IODONE_FUNC(bp, xlog_iodone);
-	XFS_BUF_SET_FSPRIVATE2(bp, (unsigned long)1);
 	ASSERT(XFS_BUF_ISBUSY(bp));
 	ASSERT(xfs_buf_islocked(bp));
 	log->l_xbuf = bp;
@@ -1092,7 +1089,6 @@ xlog_alloc_log(xfs_mount_t	*mp,
 			goto out_free_iclog;
 
 		XFS_BUF_SET_IODONE_FUNC(bp, xlog_iodone);
-		XFS_BUF_SET_FSPRIVATE2(bp, (unsigned long)1);
 		iclog->ic_bp = bp;
 		iclog->ic_data = bp->b_addr;
 #ifdef DEBUG
@@ -1349,8 +1345,6 @@ xlog_sync(xlog_t		*log,
 	}
 
 	bp = iclog->ic_bp;
-	ASSERT(XFS_BUF_FSPRIVATE2(bp, unsigned long) == (unsigned long)1);
-	XFS_BUF_SET_FSPRIVATE2(bp, (unsigned long)2);
 	XFS_BUF_SET_ADDR(bp, BLOCK_LSN(be64_to_cpu(iclog->ic_header.h_lsn)));
 
 	XFS_STATS_ADD(xs_log_blocks, BTOBB(count));
@@ -1408,9 +1402,6 @@ xlog_sync(xlog_t		*log,
 	}
 	if (split) {
 		bp = iclog->ic_log->l_xbuf;
-		ASSERT(XFS_BUF_FSPRIVATE2(bp, unsigned long) ==
-							(unsigned long)1);
-		XFS_BUF_SET_FSPRIVATE2(bp, (unsigned long)2);
 		XFS_BUF_SET_ADDR(bp, 0);	     /* logical 0 */
 		XFS_BUF_SET_PTR(bp, (xfs_caddr_t)((__psint_t)&(iclog->ic_header)+
 					    (__psint_t)count), split);
Index: xfs/fs/xfs/xfs_trans_buf.c
===================================================================
--- xfs.orig/fs/xfs/xfs_trans_buf.c	2011-07-01 11:35:50.000000000 +0200
+++ xfs/fs/xfs/xfs_trans_buf.c	2011-07-01 11:44:04.924082291 +0200
@@ -81,7 +81,7 @@ _xfs_trans_bjoin(
 	struct xfs_buf_log_item	*bip;
 
 	ASSERT(XFS_BUF_ISBUSY(bp));
-	ASSERT(XFS_BUF_FSPRIVATE2(bp, void *) == NULL);
+	ASSERT(bp->b_transp == NULL);
 
 	/*
 	 * The xfs_buf_log_item pointer is stored in b_fsprivate.  If
@@ -110,7 +110,7 @@ _xfs_trans_bjoin(
 	 * Initialize b_fsprivate2 so we can find it with incore_match()
 	 * in xfs_trans_get_buf() and friends above.
 	 */
-	XFS_BUF_SET_FSPRIVATE2(bp, tp);
+	bp->b_transp = tp;
 
 }
 
@@ -172,7 +172,7 @@ xfs_trans_get_buf(xfs_trans_t	*tp,
 		else if (XFS_BUF_ISSTALE(bp))
 			ASSERT(!XFS_BUF_ISDELAYWRITE(bp));
 
-		ASSERT(XFS_BUF_FSPRIVATE2(bp, xfs_trans_t *) == tp);
+		ASSERT(bp->b_transp == tp);
 		bip = XFS_BUF_FSPRIVATE(bp, xfs_buf_log_item_t *);
 		ASSERT(bip != NULL);
 		ASSERT(atomic_read(&bip->bli_refcount) > 0);
@@ -232,7 +232,7 @@ xfs_trans_getsb(xfs_trans_t	*tp,
 	 * recursion count and return the buffer to the caller.
 	 */
 	bp = mp->m_sb_bp;
-	if (XFS_BUF_FSPRIVATE2(bp, xfs_trans_t *) == tp) {
+	if (bp->b_transp == tp) {
 		bip = XFS_BUF_FSPRIVATE(bp, xfs_buf_log_item_t*);
 		ASSERT(bip != NULL);
 		ASSERT(atomic_read(&bip->bli_refcount) > 0);
@@ -328,7 +328,7 @@ xfs_trans_read_buf(
 	bp = xfs_trans_buf_item_match(tp, target, blkno, len);
 	if (bp != NULL) {
 		ASSERT(xfs_buf_islocked(bp));
-		ASSERT(XFS_BUF_FSPRIVATE2(bp, xfs_trans_t *) == tp);
+		ASSERT(bp->b_transp == tp);
 		ASSERT(XFS_BUF_FSPRIVATE(bp, void *) != NULL);
 		ASSERT((XFS_BUF_ISERROR(bp)) == 0);
 		if (!(XFS_BUF_ISDONE(bp))) {
@@ -466,7 +466,7 @@ xfs_trans_brelse(xfs_trans_t	*tp,
 	 * Default to a normal brelse() call if the tp is NULL.
 	 */
 	if (tp == NULL) {
-		ASSERT(XFS_BUF_FSPRIVATE2(bp, void *) == NULL);
+		ASSERT(bp->b_transp == NULL);
 		/*
 		 * If there's a buf log item attached to the buffer,
 		 * then let the AIL know that the buffer is being
@@ -484,7 +484,7 @@ xfs_trans_brelse(xfs_trans_t	*tp,
 		return;
 	}
 
-	ASSERT(XFS_BUF_FSPRIVATE2(bp, xfs_trans_t *) == tp);
+	ASSERT(bp->b_transp == tp);
 	bip = XFS_BUF_FSPRIVATE(bp, xfs_buf_log_item_t *);
 	ASSERT(bip->bli_item.li_type == XFS_LI_BUF);
 	ASSERT(!(bip->bli_flags & XFS_BLI_STALE));
@@ -556,7 +556,7 @@ xfs_trans_brelse(xfs_trans_t	*tp,
 		xfs_buf_item_relse(bp);
 		bip = NULL;
 	}
-	XFS_BUF_SET_FSPRIVATE2(bp, NULL);
+	bp->b_transp = NULL;
 
 	/*
 	 * If we've still got a buf log item on the buffer, then
@@ -584,7 +584,7 @@ xfs_trans_bhold(xfs_trans_t	*tp,
 	xfs_buf_log_item_t	*bip;
 
 	ASSERT(XFS_BUF_ISBUSY(bp));
-	ASSERT(XFS_BUF_FSPRIVATE2(bp, xfs_trans_t *) == tp);
+	ASSERT(bp->b_transp == tp);
 	ASSERT(XFS_BUF_FSPRIVATE(bp, void *) != NULL);
 
 	bip = XFS_BUF_FSPRIVATE(bp, xfs_buf_log_item_t *);
@@ -606,7 +606,7 @@ xfs_trans_bhold_release(xfs_trans_t	*tp,
 	xfs_buf_log_item_t	*bip;
 
 	ASSERT(XFS_BUF_ISBUSY(bp));
-	ASSERT(XFS_BUF_FSPRIVATE2(bp, xfs_trans_t *) == tp);
+	ASSERT(bp->b_transp == tp);
 	ASSERT(XFS_BUF_FSPRIVATE(bp, void *) != NULL);
 
 	bip = XFS_BUF_FSPRIVATE(bp, xfs_buf_log_item_t *);
@@ -637,7 +637,7 @@ xfs_trans_log_buf(xfs_trans_t	*tp,
 	xfs_buf_log_item_t	*bip;
 
 	ASSERT(XFS_BUF_ISBUSY(bp));
-	ASSERT(XFS_BUF_FSPRIVATE2(bp, xfs_trans_t *) == tp);
+	ASSERT(bp->b_transp == tp);
 	ASSERT(XFS_BUF_FSPRIVATE(bp, void *) != NULL);
 	ASSERT((first <= last) && (last < XFS_BUF_COUNT(bp)));
 	ASSERT((XFS_BUF_IODONE_FUNC(bp) == NULL) ||
@@ -709,7 +709,7 @@ xfs_trans_binval(
 	xfs_buf_log_item_t	*bip;
 
 	ASSERT(XFS_BUF_ISBUSY(bp));
-	ASSERT(XFS_BUF_FSPRIVATE2(bp, xfs_trans_t *) == tp);
+	ASSERT(bp->b_transp == tp);
 	ASSERT(XFS_BUF_FSPRIVATE(bp, void *) != NULL);
 
 	bip = XFS_BUF_FSPRIVATE(bp, xfs_buf_log_item_t *);
@@ -783,7 +783,7 @@ xfs_trans_inode_buf(
 	xfs_buf_log_item_t	*bip;
 
 	ASSERT(XFS_BUF_ISBUSY(bp));
-	ASSERT(XFS_BUF_FSPRIVATE2(bp, xfs_trans_t *) == tp);
+	ASSERT(bp->b_transp == tp);
 	ASSERT(XFS_BUF_FSPRIVATE(bp, void *) != NULL);
 
 	bip = XFS_BUF_FSPRIVATE(bp, xfs_buf_log_item_t *);
@@ -809,7 +809,7 @@ xfs_trans_stale_inode_buf(
 	xfs_buf_log_item_t	*bip;
 
 	ASSERT(XFS_BUF_ISBUSY(bp));
-	ASSERT(XFS_BUF_FSPRIVATE2(bp, xfs_trans_t *) == tp);
+	ASSERT(bp->b_transp == tp);
 	ASSERT(XFS_BUF_FSPRIVATE(bp, void *) != NULL);
 
 	bip = XFS_BUF_FSPRIVATE(bp, xfs_buf_log_item_t *);
@@ -836,7 +836,7 @@ xfs_trans_inode_alloc_buf(
 	xfs_buf_log_item_t	*bip;
 
 	ASSERT(XFS_BUF_ISBUSY(bp));
-	ASSERT(XFS_BUF_FSPRIVATE2(bp, xfs_trans_t *) == tp);
+	ASSERT(bp->b_transp == tp);
 	ASSERT(XFS_BUF_FSPRIVATE(bp, void *) != NULL);
 
 	bip = XFS_BUF_FSPRIVATE(bp, xfs_buf_log_item_t *);
@@ -866,7 +866,7 @@ xfs_trans_dquot_buf(
 	xfs_buf_log_item_t	*bip;
 
 	ASSERT(XFS_BUF_ISBUSY(bp));
-	ASSERT(XFS_BUF_FSPRIVATE2(bp, xfs_trans_t *) == tp);
+	ASSERT(bp->b_transp == tp);
 	ASSERT(XFS_BUF_FSPRIVATE(bp, void *) != NULL);
 	ASSERT(type == XFS_BLF_UDQUOT_BUF ||
 	       type == XFS_BLF_PDQUOT_BUF ||

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
