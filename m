Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mB2GCLit032660 for <xfs@oss.sgi.com>; Tue, 2 Dec 2008 10:12:22 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5B313164F2E9
	for <xfs@oss.sgi.com>; Tue,  2 Dec 2008 08:12:21 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id duvCLPQxRVOZS592 for
	<xfs@oss.sgi.com>; Tue, 02 Dec 2008 08:12:21 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.68 #1 (Red Hat
	Linux)) id 1L7Xly-0007LA-Ex
	for xfs@oss.sgi.com; Tue, 02 Dec 2008 16:06:50 +0000
Message-Id: <20081202160650.360918000@bombadil.infradead.org>
References: <20081202160430.775774000@bombadil.infradead.org>
Date: Tue, 02 Dec 2008 11:04:36 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [patch 06/22] kill xfs_buf_iostart
Content-Disposition: inline; filename=xfs-bdwrite_cleanup
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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

xfs_buf_iostart is a "shared" helper for xfs_buf_read_flags,
xfs_bawrite, and xfs_bdwrite - except that there isn't much shared
code but rather special cases for each caller.

So remove this function and move the functionality to the caller.
xfs_bawrite and xfs_bdwrite are now big enough to be moved out of
line and the xfs_buf_read_flags is moved into a new helper called
_xfs_buf_read.

(First sent on August 2nd)

Signed-off-by: Christoph Hellwig <hch@lst.de>


Index: xfs-master/fs/xfs/linux-2.6/xfs_buf.c
===================================================================
--- xfs-master.orig/fs/xfs/linux-2.6/xfs_buf.c	2008-12-01 19:26:04.000000000 +0100
+++ xfs-master/fs/xfs/linux-2.6/xfs_buf.c	2008-12-01 19:27:31.000000000 +0100
@@ -630,6 +630,29 @@ xfs_buf_get_flags(
 	return NULL;
 }
 
+STATIC int
+_xfs_buf_read(
+	xfs_buf_t		*bp,
+	xfs_buf_flags_t		flags)
+{
+	int			status;
+
+	XB_TRACE(bp, "_xfs_buf_read", (unsigned long)flags);
+
+	ASSERT(!(flags & (XBF_DELWRI|XBF_WRITE)));
+	ASSERT(bp->b_bn != XFS_BUF_DADDR_NULL);
+
+	bp->b_flags &= ~(XBF_WRITE | XBF_ASYNC | XBF_DELWRI | \
+			XBF_READ_AHEAD | _XBF_RUN_QUEUES);
+	bp->b_flags |= flags & (XBF_READ | XBF_ASYNC | \
+			XBF_READ_AHEAD | _XBF_RUN_QUEUES);
+
+	status = xfs_buf_iorequest(bp);
+	if (!status && !(flags & XBF_ASYNC))
+		status = xfs_buf_iowait(bp);
+	return status;
+}
+
 xfs_buf_t *
 xfs_buf_read_flags(
 	xfs_buftarg_t		*target,
@@ -646,7 +669,7 @@ xfs_buf_read_flags(
 		if (!XFS_BUF_ISDONE(bp)) {
 			XB_TRACE(bp, "read", (unsigned long)flags);
 			XFS_STATS_INC(xb_get_read);
-			xfs_buf_iostart(bp, flags);
+			_xfs_buf_read(bp, flags);
 		} else if (flags & XBF_ASYNC) {
 			XB_TRACE(bp, "read_async", (unsigned long)flags);
 			/*
@@ -1048,50 +1071,39 @@ xfs_buf_ioerror(
 	XB_TRACE(bp, "ioerror", (unsigned long)error);
 }
 
-/*
- *	Initiate I/O on a buffer, based on the flags supplied.
- *	The b_iodone routine in the buffer supplied will only be called
- *	when all of the subsidiary I/O requests, if any, have been completed.
- */
 int
-xfs_buf_iostart(
-	xfs_buf_t		*bp,
-	xfs_buf_flags_t		flags)
+xfs_bawrite(
+	void			*mp,
+	struct xfs_buf		*bp)
 {
-	int			status = 0;
+	XB_TRACE(bp, "bawrite", 0);
 
-	XB_TRACE(bp, "iostart", (unsigned long)flags);
+	ASSERT(bp->b_bn != XFS_BUF_DADDR_NULL);
 
-	if (flags & XBF_DELWRI) {
-		bp->b_flags &= ~(XBF_READ | XBF_WRITE | XBF_ASYNC);
-		bp->b_flags |= flags & (XBF_DELWRI | XBF_ASYNC);
-		xfs_buf_delwri_queue(bp, 1);
-		return 0;
-	}
+	xfs_buf_delwri_dequeue(bp);
 
-	bp->b_flags &= ~(XBF_READ | XBF_WRITE | XBF_ASYNC | XBF_DELWRI | \
-			XBF_READ_AHEAD | _XBF_RUN_QUEUES);
-	bp->b_flags |= flags & (XBF_READ | XBF_WRITE | XBF_ASYNC | \
-			XBF_READ_AHEAD | _XBF_RUN_QUEUES);
+	bp->b_flags &= ~(XBF_READ | XBF_DELWRI | XBF_READ_AHEAD);
+	bp->b_flags |= (XBF_WRITE | XBF_ASYNC | _XBF_RUN_QUEUES);
+
+	bp->b_fspriv3 = mp;
+	bp->b_strat = xfs_bdstrat_cb;
+	return xfs_bdstrat_cb(bp);
+}
 
-	BUG_ON(bp->b_bn == XFS_BUF_DADDR_NULL);
+void
+xfs_bdwrite(
+	void			*mp,
+	struct xfs_buf		*bp)
+{
+	XB_TRACE(bp, "bdwrite", 0);
 
-	/* For writes allow an alternate strategy routine to precede
-	 * the actual I/O request (which may not be issued at all in
-	 * a shutdown situation, for example).
-	 */
-	status = (flags & XBF_WRITE) ?
-		xfs_buf_iostrategy(bp) : xfs_buf_iorequest(bp);
+	bp->b_strat = xfs_bdstrat_cb;
+	bp->b_fspriv3 = mp;
 
-	/* Wait for I/O if we are not an async request.
-	 * Note: async I/O request completion will release the buffer,
-	 * and that can already be done by this point.  So using the
-	 * buffer pointer from here on, after async I/O, is invalid.
-	 */
-	if (!status && !(flags & XBF_ASYNC))
-		status = xfs_buf_iowait(bp);
+	bp->b_flags &= ~XBF_READ;
+	bp->b_flags |= (XBF_DELWRI | XBF_ASYNC);
 
-	return status;
+	xfs_buf_delwri_queue(bp, 1);
 }
 
 STATIC_INLINE void
Index: xfs-master/fs/xfs/linux-2.6/xfs_buf.h
===================================================================
--- xfs-master.orig/fs/xfs/linux-2.6/xfs_buf.h	2008-12-01 19:26:04.000000000 +0100
+++ xfs-master/fs/xfs/linux-2.6/xfs_buf.h	2008-12-01 19:27:31.000000000 +0100
@@ -214,9 +214,10 @@ extern void xfs_buf_lock(xfs_buf_t *);
 extern void xfs_buf_unlock(xfs_buf_t *);
 
 /* Buffer Read and Write Routines */
+extern int xfs_bawrite(void *mp, xfs_buf_t *bp);
+extern void xfs_bdwrite(void *mp, xfs_buf_t *bp);
 extern void xfs_buf_ioend(xfs_buf_t *,	int);
 extern void xfs_buf_ioerror(xfs_buf_t *, int);
-extern int xfs_buf_iostart(xfs_buf_t *, xfs_buf_flags_t);
 extern int xfs_buf_iorequest(xfs_buf_t *);
 extern int xfs_buf_iowait(xfs_buf_t *);
 extern void xfs_buf_iomove(xfs_buf_t *, size_t, size_t, xfs_caddr_t,
@@ -366,14 +367,6 @@ extern void xfs_buf_trace(xfs_buf_t *, c
 #define XFS_BUF_TARGET(bp)		((bp)->b_target)
 #define XFS_BUFTARG_NAME(target)	xfs_buf_target_name(target)
 
-static inline int xfs_bawrite(void *mp, xfs_buf_t *bp)
-{
-	bp->b_fspriv3 = mp;
-	bp->b_strat = xfs_bdstrat_cb;
-	xfs_buf_delwri_dequeue(bp);
-	return xfs_buf_iostart(bp, XBF_WRITE | XBF_ASYNC | _XBF_RUN_QUEUES);
-}
-
 static inline void xfs_buf_relse(xfs_buf_t *bp)
 {
 	if (!bp->b_relse)
@@ -414,17 +407,6 @@ static inline int XFS_bwrite(xfs_buf_t *
 	return error;
 }
 
-/*
- * No error can be returned from xfs_buf_iostart for delwri
- * buffers as they are queued and no I/O is issued.
- */
-static inline void xfs_bdwrite(void *mp, xfs_buf_t *bp)
-{
-	bp->b_strat = xfs_bdstrat_cb;
-	bp->b_fspriv3 = mp;
-	(void)xfs_buf_iostart(bp, XBF_DELWRI | XBF_ASYNC);
-}
-
 #define XFS_bdstrat(bp) xfs_buf_iorequest(bp)
 
 #define xfs_iowait(bp)	xfs_buf_iowait(bp)

-- 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
