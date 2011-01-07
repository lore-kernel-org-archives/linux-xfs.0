Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p07D0Da0052693 for <xfs@oss.sgi.com>; Fri, 7 Jan 2011 07:00:13 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9ED961D16396
	for <xfs@oss.sgi.com>; Fri,  7 Jan 2011 05:02:23 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id 5GJ4dHxakitgHthR for
	<xfs@oss.sgi.com>; Fri, 07 Jan 2011 05:02:23 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.72 #1 (Red Hat
	Linux)) id 1PbBxX-0003As-6W
	for xfs@oss.sgi.com; Fri, 07 Jan 2011 13:02:23 +0000
Date: Fri, 7 Jan 2011 08:02:23 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH] xfs: fix error handling for synchronous writes
Message-ID: <20110107130223.GB12134@infradead.org>
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

If we get an IO error on a synchronous superblock write, we attach an
error release function to it so that when the last reference goes away
the release function is called and the buffer is invalidated and
unlocked. The buffer is left locked until the release function is
called so that other concurrent users of the buffer will be locked out
until the buffer error is fully processed.

Unfortunately, for the superblock buffer the filesyetm itself holds a
reference to the buffer which prevents the reference count from
dropping to zero and the release function being called. As a result,
once an IO error occurs on a sync write, the buffer will never be
unlocked and all future attempts to lock the buffer will hang.

To make matters worse, this problems is not unique to such buffers;
if there is a concurrent _xfs_buf_find() running, the lookup will grab
a reference to the buffer and then wait on the buffer lock, preventing
the reference count from ever falling to zero and hence unlocking the
buffer.

As such, the whole b_relse function implementation is broken because it
cannot rely on the buffer reference count falling to zero to unlock the
errored buffer. The synchronous write error path is the only path that
uses this callback - it is used to ensure that the synchronous waiter
gets the buffer error before the error state is cleared from the buffer
by the release function.

Given that the only sychronous buffer writes now go through xfs_bwrite
and the error path in question can only occur for a write of a dirty,
logged buffer, we can move most of the b_relse processing to happen
inline in xfs_buf_iodone_callbacks, just like a normal I/O completion.
In addition to that we make sure the error is not cleared in
xfs_buf_iodone_callbacks, so that xfs_bwrite can reliably check it.
Given that xfs_bwrite keeps the buffer locked until it has waited for
it and checked the error this allows to reliably propagate the error
to the caller, and make sure that the buffer is reliably unlocked.

Given that xfs_buf_iodone_callbacks was the only instance of the
b_relse callback we can remove it entirely.

Based on earlier patches by Dave Chinner and Ajeet Yadav.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reported-by: Ajeet Yadav <ajeet.yadav.77@gmail.com>

Index: xfs/fs/xfs/linux-2.6/xfs_buf.h
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_buf.h	2011-01-04 09:42:44.763003651 +0100
+++ xfs/fs/xfs/linux-2.6/xfs_buf.h	2011-01-04 09:54:08.443255013 +0100
@@ -152,8 +152,6 @@ typedef struct xfs_buftarg {
 
 struct xfs_buf;
 typedef void (*xfs_buf_iodone_t)(struct xfs_buf *);
-typedef void (*xfs_buf_relse_t)(struct xfs_buf *);
-typedef int (*xfs_buf_bdstrat_t)(struct xfs_buf *);
 
 #define XB_PAGES	2
 
@@ -183,7 +181,6 @@ typedef struct xfs_buf {
 	void			*b_addr;	/* virtual address of buffer */
 	struct work_struct	b_iodone_work;
 	xfs_buf_iodone_t	b_iodone;	/* I/O completion function */
-	xfs_buf_relse_t		b_relse;	/* releasing function */
 	struct completion	b_iowait;	/* queue for I/O waiters */
 	void			*b_fspriv;
 	void			*b_fspriv2;
@@ -323,7 +320,6 @@ void xfs_buf_stale(struct xfs_buf *bp);
 #define XFS_BUF_FSPRIVATE2(bp, type)		((type)(bp)->b_fspriv2)
 #define XFS_BUF_SET_FSPRIVATE2(bp, val)		((bp)->b_fspriv2 = (void*)(val))
 #define XFS_BUF_SET_START(bp)			do { } while (0)
-#define XFS_BUF_SET_BRELSE_FUNC(bp, func)	((bp)->b_relse = (func))
 
 #define XFS_BUF_PTR(bp)			(xfs_caddr_t)((bp)->b_addr)
 #define XFS_BUF_SET_PTR(bp, val, cnt)	xfs_buf_associate_memory(bp, val, cnt)
@@ -360,8 +356,7 @@ xfs_buf_set_ref(
 
 static inline void xfs_buf_relse(xfs_buf_t *bp)
 {
-	if (!bp->b_relse)
-		xfs_buf_unlock(bp);
+	xfs_buf_unlock(bp);
 	xfs_buf_rele(bp);
 }
 
Index: xfs/fs/xfs/xfs_buf_item.c
===================================================================
--- xfs.orig/fs/xfs/xfs_buf_item.c	2011-01-04 09:42:44.779005117 +0100
+++ xfs/fs/xfs/xfs_buf_item.c	2011-01-04 09:47:40.798004000 +0100
@@ -141,7 +141,6 @@ xfs_buf_item_log_check(
 #define		xfs_buf_item_log_check(x)
 #endif
 
-STATIC void	xfs_buf_error_relse(xfs_buf_t *bp);
 STATIC void	xfs_buf_do_callbacks(struct xfs_buf *bp);
 
 /*
@@ -959,128 +958,76 @@ xfs_buf_do_callbacks(
  */
 void
 xfs_buf_iodone_callbacks(
-	xfs_buf_t	*bp)
+	struct xfs_buf		*bp)
 {
-	xfs_log_item_t	*lip;
-	static ulong	lasttime;
-	static xfs_buftarg_t *lasttarg;
-	xfs_mount_t	*mp;
+	struct xfs_log_item	*lip = bp->b_fspriv;
+	struct xfs_mount	*mp = lip->li_mountp;
+	static ulong		lasttime;
+	static xfs_buftarg_t	*lasttarg;
 
-	ASSERT(XFS_BUF_FSPRIVATE(bp, void *) != NULL);
-	lip = XFS_BUF_FSPRIVATE(bp, xfs_log_item_t *);
+	if (likely(!XFS_BUF_GETERROR(bp)))
+		goto do_callbacks;
 
-	if (XFS_BUF_GETERROR(bp) != 0) {
-		/*
-		 * If we've already decided to shutdown the filesystem
-		 * because of IO errors, there's no point in giving this
-		 * a retry.
-		 */
-		mp = lip->li_mountp;
-		if (XFS_FORCED_SHUTDOWN(mp)) {
-			ASSERT(XFS_BUF_TARGET(bp) == mp->m_ddev_targp);
-			XFS_BUF_SUPER_STALE(bp);
-			trace_xfs_buf_item_iodone(bp, _RET_IP_);
-			xfs_buf_do_callbacks(bp);
-			XFS_BUF_SET_FSPRIVATE(bp, NULL);
-			XFS_BUF_CLR_IODONE_FUNC(bp);
-			xfs_buf_ioend(bp, 0);
-			return;
-		}
+	/*
+	 * If we've already decided to shutdown the filesystem because of
+	 * I/O errors, there's no point in giving this a retry.
+	 */
+	if (XFS_FORCED_SHUTDOWN(mp)) {
+		XFS_BUF_SUPER_STALE(bp);
+		trace_xfs_buf_item_iodone(bp, _RET_IP_);
+		goto do_callbacks;
+	}
 
-		if ((XFS_BUF_TARGET(bp) != lasttarg) ||
-		    (time_after(jiffies, (lasttime + 5*HZ)))) {
-			lasttime = jiffies;
-			cmn_err(CE_ALERT, "Device %s, XFS metadata write error"
-					" block 0x%llx in %s",
-				XFS_BUFTARG_NAME(XFS_BUF_TARGET(bp)),
-			      (__uint64_t)XFS_BUF_ADDR(bp), mp->m_fsname);
-		}
-		lasttarg = XFS_BUF_TARGET(bp);
+	if (XFS_BUF_TARGET(bp) != lasttarg ||
+	    time_after(jiffies, (lasttime + 5*HZ))) {
+		lasttime = jiffies;
+		cmn_err(CE_ALERT, "Device %s, XFS metadata write error"
+				" block 0x%llx in %s",
+			XFS_BUFTARG_NAME(XFS_BUF_TARGET(bp)),
+		      (__uint64_t)XFS_BUF_ADDR(bp), mp->m_fsname);
+	}
+	lasttarg = XFS_BUF_TARGET(bp);
 
-		if (XFS_BUF_ISASYNC(bp)) {
-			/*
-			 * If the write was asynchronous then noone will be
-			 * looking for the error.  Clear the error state
-			 * and write the buffer out again delayed write.
-			 *
-			 * XXXsup This is OK, so long as we catch these
-			 * before we start the umount; we don't want these
-			 * DELWRI metadata bufs to be hanging around.
-			 */
-			XFS_BUF_ERROR(bp,0); /* errno of 0 unsets the flag */
+	/*
+	 * If the write was asynchronous then noone will be looking for the
+	 * error.  Clear the error state and write the buffer out again.
+	 *
+	 * During sync or umount we'll write all pending buffers again
+	 * synchronous, which will catch these errors if they keep hanging
+	 * around.
+	 */
+	if (XFS_BUF_ISASYNC(bp)) {
+		XFS_BUF_ERROR(bp, 0); /* errno of 0 unsets the flag */
 
-			if (!(XFS_BUF_ISSTALE(bp))) {
-				XFS_BUF_DELAYWRITE(bp);
-				XFS_BUF_DONE(bp);
-				XFS_BUF_SET_START(bp);
-			}
-			ASSERT(XFS_BUF_IODONE_FUNC(bp));
-			trace_xfs_buf_item_iodone_async(bp, _RET_IP_);
-			xfs_buf_relse(bp);
-		} else {
-			/*
-			 * If the write of the buffer was not asynchronous,
-			 * then we want to make sure to return the error
-			 * to the caller of bwrite().  Because of this we
-			 * cannot clear the B_ERROR state at this point.
-			 * Instead we install a callback function that
-			 * will be called when the buffer is released, and
-			 * that routine will clear the error state and
-			 * set the buffer to be written out again after
-			 * some delay.
-			 */
-			/* We actually overwrite the existing b-relse
-			   function at times, but we're gonna be shutting down
-			   anyway. */
-			XFS_BUF_SET_BRELSE_FUNC(bp,xfs_buf_error_relse);
+		if (!XFS_BUF_ISSTALE(bp)) {
+			XFS_BUF_DELAYWRITE(bp);
 			XFS_BUF_DONE(bp);
-			XFS_BUF_FINISH_IOWAIT(bp);
+			XFS_BUF_SET_START(bp);
 		}
+		ASSERT(XFS_BUF_IODONE_FUNC(bp));
+		trace_xfs_buf_item_iodone_async(bp, _RET_IP_);
+		xfs_buf_relse(bp);
 		return;
 	}
 
-	xfs_buf_do_callbacks(bp);
-	XFS_BUF_SET_FSPRIVATE(bp, NULL);
-	XFS_BUF_CLR_IODONE_FUNC(bp);
-	xfs_buf_ioend(bp, 0);
-}
-
-/*
- * This is a callback routine attached to a buffer which gets an error
- * when being written out synchronously.
- */
-STATIC void
-xfs_buf_error_relse(
-	xfs_buf_t	*bp)
-{
-	xfs_log_item_t	*lip;
-	xfs_mount_t	*mp;
-
-	lip = XFS_BUF_FSPRIVATE(bp, xfs_log_item_t *);
-	mp = (xfs_mount_t *)lip->li_mountp;
-	ASSERT(XFS_BUF_TARGET(bp) == mp->m_ddev_targp);
-
+	/*
+	 * If the write of the buffer was synchronous, we want to make
+	 * sure to return the error to the caller of xfs_bwrite().
+	 */
 	XFS_BUF_STALE(bp);
 	XFS_BUF_DONE(bp);
 	XFS_BUF_UNDELAYWRITE(bp);
-	XFS_BUF_ERROR(bp,0);
 
 	trace_xfs_buf_error_relse(bp, _RET_IP_);
+	xfs_force_shutdown(mp, SHUTDOWN_META_IO_ERROR);
 
-	if (! XFS_FORCED_SHUTDOWN(mp))
-		xfs_force_shutdown(mp, SHUTDOWN_META_IO_ERROR);
-	/*
-	 * We have to unpin the pinned buffers so do the
-	 * callbacks.
-	 */
+do_callbacks:
 	xfs_buf_do_callbacks(bp);
 	XFS_BUF_SET_FSPRIVATE(bp, NULL);
 	XFS_BUF_CLR_IODONE_FUNC(bp);
-	XFS_BUF_SET_BRELSE_FUNC(bp,NULL);
-	xfs_buf_relse(bp);
+	xfs_buf_ioend(bp, 0);
 }
 
-
 /*
  * This is the iodone() function for buffers which have been
  * logged.  It is called when they are eventually flushed out.
Index: xfs/fs/xfs/linux-2.6/xfs_buf.c
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_buf.c	2011-01-04 09:42:44.770009657 +0100
+++ xfs/fs/xfs/linux-2.6/xfs_buf.c	2011-01-04 09:46:41.233255990 +0100
@@ -896,7 +896,6 @@ xfs_buf_rele(
 	trace_xfs_buf_rele(bp, _RET_IP_);
 
 	if (!pag) {
-		ASSERT(!bp->b_relse);
 		ASSERT(list_empty(&bp->b_lru));
 		ASSERT(RB_EMPTY_NODE(&bp->b_rbnode));
 		if (atomic_dec_and_test(&bp->b_hold))
@@ -908,11 +907,7 @@ xfs_buf_rele(
 
 	ASSERT(atomic_read(&bp->b_hold) > 0);
 	if (atomic_dec_and_lock(&bp->b_hold, &pag->pag_buf_lock)) {
-		if (bp->b_relse) {
-			atomic_inc(&bp->b_hold);
-			spin_unlock(&pag->pag_buf_lock);
-			bp->b_relse(bp);
-		} else if (!(bp->b_flags & XBF_STALE) &&
+		if (!(bp->b_flags & XBF_STALE) &&
 			   atomic_read(&bp->b_lru_ref)) {
 			xfs_buf_lru_add(bp);
 			spin_unlock(&pag->pag_buf_lock);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
