Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 08 Nov 2007 17:02:34 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id lA912QOj021135
	for <xfs@oss.sgi.com>; Thu, 8 Nov 2007 17:02:29 -0800
Message-ID: <4733B1CA.9030109@sgi.com>
Date: Fri, 09 Nov 2007 12:03:06 +1100
From: Lachlan McIlroy <lachlan@sgi.com>
Reply-To: lachlan@sgi.com
MIME-Version: 1.0
Subject: Re: [PATCH] Turn off XBF_READ_AHEAD in io completion
References: <47296FF7.8080607@sgi.com> <20071101100012.GA20065@infradead.org>
In-Reply-To: <20071101100012.GA20065@infradead.org>
Content-Type: multipart/mixed;
 boundary="------------020301010005050909020108"
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

This is a multi-part message in MIME format.
--------------020301010005050909020108
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Christoph Hellwig wrote:
> On Thu, Nov 01, 2007 at 05:19:35PM +1100, Lachlan McIlroy wrote:
>> Read-ahead of an inode cluster will set XBF_READ_AHEAD in the buffer.
>> If we don't remove the flag it will still be set when we flush the
>> buffer back to disk.  Not sure if leaving this flag set causes any
>> serious problems but it does trigger an assert.
> 
> It might be better if such temporary flags never actually make it to
> bp->b_flags.  Just pass down a flags variable all the way to
> _xfs_buf_ioapply and keep the flags just for this I/O separate from
> those that are permanent and in bp->b_flags.
> 

Okay, I've done that (new patch attached).  It's certainly not as
clean as the last patch.

--------------020301010005050909020108
Content-Type: text/x-patch;
 name="readahead.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="readahead.diff"

--- fs/xfs/linux-2.6/xfs_buf.c_1.247	2007-10-29 16:01:29.000000000 +1100
+++ fs/xfs/linux-2.6/xfs_buf.c	2007-11-02 13:39:48.000000000 +1100
@@ -1020,7 +1020,7 @@ xfs_buf_iodone_work(
 	    (bp->b_flags & (XBF_ORDERED|XBF_ASYNC)) == (XBF_ORDERED|XBF_ASYNC)) {
 		XB_TRACE(bp, "ordered_retry", bp->b_iodone);
 		bp->b_flags &= ~XBF_ORDERED;
-		xfs_buf_iorequest(bp);
+		xfs_buf_iorequest(bp, bp->b_flags);
 	} else if (bp->b_iodone)
 		(*(bp->b_iodone))(bp);
 	else if (bp->b_flags & XBF_ASYNC)
@@ -1082,9 +1082,9 @@ xfs_buf_iostart(
 	}
 
 	bp->b_flags &= ~(XBF_READ | XBF_WRITE | XBF_ASYNC | XBF_DELWRI | \
-			XBF_READ_AHEAD | _XBF_RUN_QUEUES);
+			_XBF_RUN_QUEUES);
 	bp->b_flags |= flags & (XBF_READ | XBF_WRITE | XBF_ASYNC | \
-			XBF_READ_AHEAD | _XBF_RUN_QUEUES);
+			_XBF_RUN_QUEUES);
 
 	BUG_ON(bp->b_bn == XFS_BUF_DADDR_NULL);
 
@@ -1093,7 +1093,7 @@ xfs_buf_iostart(
 	 * a shutdown situation, for example).
 	 */
 	status = (flags & XBF_WRITE) ?
-		xfs_buf_iostrategy(bp) : xfs_buf_iorequest(bp);
+		xfs_buf_iostrategy(bp, flags) : xfs_buf_iorequest(bp, flags);
 
 	/* Wait for I/O if we are not an async request.
 	 * Note: async I/O request completion will release the buffer,
@@ -1172,7 +1172,8 @@ xfs_buf_bio_end_io(
 
 STATIC void
 _xfs_buf_ioapply(
-	xfs_buf_t		*bp)
+	xfs_buf_t		*bp,
+	xfs_buf_flags_t		flags)
 {
 	int			i, rw, map_i, total_nr_pages, nr_pages;
 	struct bio		*bio;
@@ -1194,7 +1195,7 @@ _xfs_buf_ioapply(
 		rw = (bp->b_flags & XBF_WRITE) ? WRITE_SYNC : READ_SYNC;
 	} else {
 		rw = (bp->b_flags & XBF_WRITE) ? WRITE :
-		     (bp->b_flags & XBF_READ_AHEAD) ? READA : READ;
+		     (flags & XBF_READ_AHEAD) ? READA : READ;
 	}
 
 	/* Special code path for reading a sub page size buffer in --
@@ -1279,7 +1280,8 @@ submit_io:
 
 int
 xfs_buf_iorequest(
-	xfs_buf_t		*bp)
+	xfs_buf_t		*bp,
+	xfs_buf_flags_t		flags)
 {
 	XB_TRACE(bp, "iorequest", 0);
 
@@ -1299,7 +1301,7 @@ xfs_buf_iorequest(
 	 * all the I/O from calling xfs_buf_ioend too early.
 	 */
 	atomic_set(&bp->b_io_remaining, 1);
-	_xfs_buf_ioapply(bp);
+	_xfs_buf_ioapply(bp, flags);
 	_xfs_buf_ioend(bp, 0);
 
 	xfs_buf_rele(bp);
@@ -1775,7 +1777,7 @@ xfsbufd(
 			ASSERT(target == bp->b_target);
 
 			list_del_init(&bp->b_list);
-			xfs_buf_iostrategy(bp);
+			xfs_buf_iostrategy(bp, bp->b_flags);
 			count++;
 		}
 
@@ -1819,7 +1821,7 @@ xfs_flush_buftarg(
 		else
 			list_del_init(&bp->b_list);
 
-		xfs_buf_iostrategy(bp);
+		xfs_buf_iostrategy(bp, bp->b_flags);
 	}
 
 	if (wait)
--- fs/xfs/linux-2.6/xfs_buf.h_1.122	2007-11-02 13:34:39.000000000 +1100
+++ fs/xfs/linux-2.6/xfs_buf.h	2007-11-02 13:38:35.000000000 +1100
@@ -191,14 +191,14 @@ extern void xfs_buf_unlock(xfs_buf_t *);
 extern void xfs_buf_ioend(xfs_buf_t *,	int);
 extern void xfs_buf_ioerror(xfs_buf_t *, int);
 extern int xfs_buf_iostart(xfs_buf_t *, xfs_buf_flags_t);
-extern int xfs_buf_iorequest(xfs_buf_t *);
+extern int xfs_buf_iorequest(xfs_buf_t *, xfs_buf_flags_t);
 extern int xfs_buf_iowait(xfs_buf_t *);
 extern void xfs_buf_iomove(xfs_buf_t *, size_t, size_t, xfs_caddr_t,
 				xfs_buf_rw_t);
 
-static inline int xfs_buf_iostrategy(xfs_buf_t *bp)
+static inline int xfs_buf_iostrategy(xfs_buf_t *bp, xfs_buf_flags_t flags)
 {
-	return bp->b_strat ? bp->b_strat(bp) : xfs_buf_iorequest(bp);
+	return bp->b_strat ? bp->b_strat(bp) : xfs_buf_iorequest(bp, flags);
 }
 
 static inline int xfs_buf_geterror(xfs_buf_t *bp)
@@ -380,7 +380,7 @@ static inline int XFS_bwrite(xfs_buf_t *
 		bp->b_flags |= _XBF_RUN_QUEUES;
 
 	xfs_buf_delwri_dequeue(bp);
-	xfs_buf_iostrategy(bp);
+	xfs_buf_iostrategy(bp, bp->b_flags);
 	if (iowait) {
 		error = xfs_buf_iowait(bp);
 		xfs_buf_relse(bp);
@@ -395,7 +395,7 @@ static inline int xfs_bdwrite(void *mp, 
 	return xfs_buf_iostart(bp, XBF_DELWRI | XBF_ASYNC);
 }
 
-#define XFS_bdstrat(bp) xfs_buf_iorequest(bp)
+#define XFS_bdstrat(bp) xfs_buf_iorequest(bp, (bp)->b_flags)
 
 #define xfs_iowait(bp)	xfs_buf_iowait(bp)
 
--- fs/xfs/linux-2.6/xfs_lrw.c_1.271	2007-11-09 11:58:53.000000000 +1100
+++ fs/xfs/linux-2.6/xfs_lrw.c	2007-11-09 11:57:50.000000000 +1100
@@ -878,7 +878,7 @@ xfs_bdstrat_cb(struct xfs_buf *bp)
 
 	mp = XFS_BUF_FSPRIVATE3(bp, xfs_mount_t *);
 	if (!XFS_FORCED_SHUTDOWN(mp)) {
-		xfs_buf_iorequest(bp);
+		xfs_buf_iorequest(bp, bp->b_flags);
 		return 0;
 	} else {
 		xfs_buftrace("XFS__BDSTRAT IOERROR", bp);
@@ -912,7 +912,7 @@ xfsbdstrat(
 		 * if (XFS_BUF_IS_GRIO(bp)) {
 		 */
 
-		xfs_buf_iorequest(bp);
+		xfs_buf_iorequest(bp, bp->b_flags);
 		return 0;
 	}
 

--------------020301010005050909020108--
