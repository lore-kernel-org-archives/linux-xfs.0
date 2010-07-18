Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o6IKaRjD163626 for <xfs@oss.sgi.com>; Sun, 18 Jul 2010 15:36:27 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D4F9315EC751
	for <xfs@oss.sgi.com>; Sun, 18 Jul 2010 13:39:26 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id MnOyqxBJnzHFdRc6 for
	<xfs@oss.sgi.com>; Sun, 18 Jul 2010 13:39:26 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.72 #1 (Red Hat
	Linux)) id 1Oaady-0003uc-Go
	for xfs@oss.sgi.com; Sun, 18 Jul 2010 20:39:26 +0000
Message-Id: <20100718203926.427127966@bombadil.infradead.org>
Date: Sun, 18 Jul 2010 16:38:52 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 4/6] xfs: kill the b_strat callback in xfs_buf
References: <20100718203848.927859114@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-kill-b_strat
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

The b_strat callback is used by xfs_buf_iostrategy to perform additional
checks before submitting a buffer.  It is used in xfs_bwrite and when
writing out delayed buffers.  In xfs_bwrite it we can de-virtualize the
call easily as b_strat is set a few lines above the call to
xfs_buf_iostrategy.  For the delayed buffers the rationale is a bit
more complicated:

 - there are three callers of xfs_buf_delwri_queue, which places buffers
   on the delwri list:
    (1) xfs_bdwrite - this sets up b_strat, so it's fine
    (2) xfs_buf_iorequest.  None of the callers can have XBF_DELWRI set:
	- xlog_bdstrat is only used for log buffers, which are never delwri
	- _xfs_buf_read explicitly clears the delwri flag
	- xfs_buf_iodone_work retries log buffers only
	- xfsbdstrat - only used for reads, superblock writes without the
	  delwri flag, log I/O and file zeroing with explicitly allocated
	  buffers.
	- xfs_buf_iostrategy - only calls xfs_buf_iorequest if b_strat is
	  not set
    (3) xfs_buf_unlock
	- only puts the buffer on the delwri list if the DELWRI flag is
	  already set.  The DELWRI flag is only ever set in xfs_bwrite,
	  xfs_buf_iodone_callbacks, or xfs_trans_log_buf.  For
	  xfs_buf_iodone_callbacks and xfs_trans_log_buf we require
	  an initialized buf item, which means b_strat was set to
	  xfs_bdstrat_cb in xfs_buf_item_init.

Conclusion: we can just get rid of the callback and replace it with
explicit calls to xfs_bdstrat_cb.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/linux-2.6/xfs_buf.c
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_buf.c	2010-07-18 07:16:09.101494681 +0200
+++ xfs/fs/xfs/linux-2.6/xfs_buf.c	2010-07-18 07:16:10.646494682 +0200
@@ -987,13 +987,12 @@ xfs_bwrite(
 {
 	int			error;
 
-	bp->b_strat = xfs_bdstrat_cb;
 	bp->b_mount = mp;
 	bp->b_flags |= XBF_WRITE;
 	bp->b_flags &= ~(XBF_ASYNC | XBF_READ);
 
 	xfs_buf_delwri_dequeue(bp);
-	xfs_buf_iostrategy(bp);
+	xfs_bdstrat_cb(bp);
 
 	error = xfs_buf_iowait(bp);
 	if (error)
@@ -1009,7 +1008,6 @@ xfs_bdwrite(
 {
 	trace_xfs_buf_bdwrite(bp, _RET_IP_);
 
-	bp->b_strat = xfs_bdstrat_cb;
 	bp->b_mount = mp;
 
 	bp->b_flags &= ~XBF_READ;
@@ -1044,7 +1042,6 @@ xfs_bioerror(
 	XFS_BUF_UNDONE(bp);
 	XFS_BUF_STALE(bp);
 
-	XFS_BUF_CLR_BDSTRAT_FUNC(bp);
 	xfs_biodone(bp);
 
 	return EIO;
@@ -1074,7 +1071,6 @@ xfs_bioerror_relse(
 	XFS_BUF_DONE(bp);
 	XFS_BUF_STALE(bp);
 	XFS_BUF_CLR_IODONE_FUNC(bp);
-	XFS_BUF_CLR_BDSTRAT_FUNC(bp);
 	if (!(fl & XBF_ASYNC)) {
 		/*
 		 * Mark b_error and B_ERROR _both_.
@@ -1857,7 +1853,7 @@ xfsbufd(
 			struct xfs_buf *bp;
 			bp = list_first_entry(&tmp, struct xfs_buf, b_list);
 			list_del_init(&bp->b_list);
-			xfs_buf_iostrategy(bp);
+			xfs_bdstrat_cb(bp);
 			count++;
 		}
 		if (count)
@@ -1904,7 +1900,7 @@ xfs_flush_buftarg(
 			bp->b_flags &= ~XBF_ASYNC;
 			list_add(&bp->b_list, &wait_list);
 		}
-		xfs_buf_iostrategy(bp);
+		xfs_bdstrat_cb(bp);
 	}
 
 	if (wait) {
Index: xfs/fs/xfs/linux-2.6/xfs_buf.h
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_buf.h	2010-07-18 07:16:09.108494681 +0200
+++ xfs/fs/xfs/linux-2.6/xfs_buf.h	2010-07-18 07:16:10.647494682 +0200
@@ -187,7 +187,6 @@ typedef struct xfs_buf {
 	atomic_t		b_io_remaining;	/* #outstanding I/O requests */
 	xfs_buf_iodone_t	b_iodone;	/* I/O completion function */
 	xfs_buf_relse_t		b_relse;	/* releasing function */
-	xfs_buf_bdstrat_t	b_strat;	/* pre-write function */
 	struct completion	b_iowait;	/* queue for I/O waiters */
 	void			*b_fspriv;
 	void			*b_fspriv2;
@@ -245,11 +244,6 @@ extern int xfs_buf_iowait(xfs_buf_t *);
 extern void xfs_buf_iomove(xfs_buf_t *, size_t, size_t, void *,
 				xfs_buf_rw_t);
 
-static inline int xfs_buf_iostrategy(xfs_buf_t *bp)
-{
-	return bp->b_strat ? bp->b_strat(bp) : xfs_buf_iorequest(bp);
-}
-
 static inline int xfs_buf_geterror(xfs_buf_t *bp)
 {
 	return bp ? bp->b_error : ENOMEM;
@@ -321,8 +315,6 @@ extern void xfs_buf_terminate(void);
 #define XFS_BUF_IODONE_FUNC(bp)			((bp)->b_iodone)
 #define XFS_BUF_SET_IODONE_FUNC(bp, func)	((bp)->b_iodone = (func))
 #define XFS_BUF_CLR_IODONE_FUNC(bp)		((bp)->b_iodone = NULL)
-#define XFS_BUF_SET_BDSTRAT_FUNC(bp, func)	((bp)->b_strat = (func))
-#define XFS_BUF_CLR_BDSTRAT_FUNC(bp)		((bp)->b_strat = NULL)
 
 #define XFS_BUF_FSPRIVATE(bp, type)		((type)(bp)->b_fspriv)
 #define XFS_BUF_SET_FSPRIVATE(bp, val)		((bp)->b_fspriv = (void*)(val))
Index: xfs/fs/xfs/xfs_buf_item.c
===================================================================
--- xfs.orig/fs/xfs/xfs_buf_item.c	2010-07-18 07:16:09.117494681 +0200
+++ xfs/fs/xfs/xfs_buf_item.c	2010-07-18 07:16:10.654494682 +0200
@@ -694,7 +694,6 @@ xfs_buf_item_init(
 	 */
 	if (bp->b_mount != mp)
 		bp->b_mount = mp;
-	XFS_BUF_SET_BDSTRAT_FUNC(bp, xfs_bdstrat_cb);
 	if (XFS_BUF_FSPRIVATE(bp, void *) != NULL) {
 		lip = XFS_BUF_FSPRIVATE(bp, xfs_log_item_t *);
 		if (lip->li_type == XFS_LI_BUF) {
Index: xfs/fs/xfs/xfs_inode.c
===================================================================
--- xfs.orig/fs/xfs/xfs_inode.c	2010-07-18 07:16:09.127494681 +0200
+++ xfs/fs/xfs/xfs_inode.c	2010-07-18 07:16:10.662494682 +0200
@@ -2717,7 +2717,6 @@ cluster_corrupt_out:
 		 * mark it as stale and brelse.
 		 */
 		if (XFS_BUF_IODONE_FUNC(bp)) {
-			XFS_BUF_CLR_BDSTRAT_FUNC(bp);
 			XFS_BUF_UNDONE(bp);
 			XFS_BUF_STALE(bp);
 			XFS_BUF_ERROR(bp,EIO);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
