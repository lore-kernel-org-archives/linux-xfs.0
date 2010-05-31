Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o4VG6Z4A178940 for <xfs@oss.sgi.com>; Mon, 31 May 2010 11:06:35 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E5B67157FD1E
	for <xfs@oss.sgi.com>; Mon, 31 May 2010 09:11:14 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id 7yuremLwPWItfnnB for
	<xfs@oss.sgi.com>; Mon, 31 May 2010 09:11:14 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.69 #1 (Red Hat
	Linux)) id 1OJ7Xx-00011x-99
	for xfs@oss.sgi.com; Mon, 31 May 2010 16:09:01 +0000
Message-Id: <20100531160901.186403532@bombadil.infradead.org>
Date: Mon, 31 May 2010 12:07:37 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 10/17] xfs: simplify buffer pinning
References: <20100531160727.842750532@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-simplify-buffer-pinning
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

Get rid of the xfs_buf_pin/xfs_buf_unpin/xfs_buf_ispin helpers and opencode
them in their only callers, just like we did for the inode pinning a while
ago.  Also remove duplicate trace points - the bufitem tracepoints cover
all the information that is present in a buffer tracepoint.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/linux-2.6/xfs_buf.c
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_buf.c	2010-05-29 18:12:07.996183820 +0200
+++ xfs/fs/xfs/linux-2.6/xfs_buf.c	2010-05-29 18:19:18.653023552 +0200
@@ -896,36 +896,6 @@ xfs_buf_unlock(
 	trace_xfs_buf_unlock(bp, _RET_IP_);
 }
 
-
-/*
- *	Pinning Buffer Storage in Memory
- *	Ensure that no attempt to force a buffer to disk will succeed.
- */
-void
-xfs_buf_pin(
-	xfs_buf_t		*bp)
-{
-	trace_xfs_buf_pin(bp, _RET_IP_);
-	atomic_inc(&bp->b_pin_count);
-}
-
-void
-xfs_buf_unpin(
-	xfs_buf_t		*bp)
-{
-	trace_xfs_buf_unpin(bp, _RET_IP_);
-
-	if (atomic_dec_and_test(&bp->b_pin_count))
-		wake_up_all(&bp->b_waiters);
-}
-
-int
-xfs_buf_ispin(
-	xfs_buf_t		*bp)
-{
-	return atomic_read(&bp->b_pin_count);
-}
-
 STATIC void
 xfs_buf_wait_unpin(
 	xfs_buf_t		*bp)
@@ -1802,7 +1772,7 @@ xfs_buf_delwri_split(
 		trace_xfs_buf_delwri_split(bp, _RET_IP_);
 		ASSERT(bp->b_flags & XBF_DELWRI);
 
-		if (!xfs_buf_ispin(bp) && !xfs_buf_cond_lock(bp)) {
+		if (!XFS_BUF_ISPINNED(bp) && !xfs_buf_cond_lock(bp)) {
 			if (!force &&
 			    time_before(jiffies, bp->b_queuetime + age)) {
 				xfs_buf_unlock(bp);
Index: xfs/fs/xfs/linux-2.6/xfs_buf.h
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_buf.h	2010-05-22 00:40:37.889004315 +0200
+++ xfs/fs/xfs/linux-2.6/xfs_buf.h	2010-05-29 18:19:18.654010422 +0200
@@ -258,11 +258,6 @@ static inline int xfs_buf_geterror(xfs_b
 /* Buffer Utility Routines */
 extern xfs_caddr_t xfs_buf_offset(xfs_buf_t *, size_t);
 
-/* Pinning Buffer Storage in Memory */
-extern void xfs_buf_pin(xfs_buf_t *);
-extern void xfs_buf_unpin(xfs_buf_t *);
-extern int xfs_buf_ispin(xfs_buf_t *);
-
 /* Delayed Write Buffer Routines */
 extern void xfs_buf_delwri_dequeue(xfs_buf_t *);
 extern void xfs_buf_delwri_promote(xfs_buf_t *);
@@ -351,7 +346,7 @@ extern void xfs_buf_terminate(void);
 #define XFS_BUF_SET_VTYPE(bp, type)		do { } while (0)
 #define XFS_BUF_SET_REF(bp, ref)		do { } while (0)
 
-#define XFS_BUF_ISPINNED(bp)	xfs_buf_ispin(bp)
+#define XFS_BUF_ISPINNED(bp)	atomic_read(&((bp)->b_pin_count))
 
 #define XFS_BUF_VALUSEMA(bp)	xfs_buf_lock_value(bp)
 #define XFS_BUF_CPSEMA(bp)	(xfs_buf_cond_lock(bp) == 0)
@@ -370,8 +365,6 @@ static inline void xfs_buf_relse(xfs_buf
 	xfs_buf_rele(bp);
 }
 
-#define xfs_bpin(bp)		xfs_buf_pin(bp)
-#define xfs_bunpin(bp)		xfs_buf_unpin(bp)
 #define xfs_biodone(bp)		xfs_buf_ioend(bp, 0)
 
 #define xfs_biomove(bp, off, len, data, rw) \
Index: xfs/fs/xfs/linux-2.6/xfs_trace.h
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_trace.h	2010-05-29 12:30:33.890033540 +0200
+++ xfs/fs/xfs/linux-2.6/xfs_trace.h	2010-05-29 18:19:18.660003717 +0200
@@ -314,8 +314,6 @@ DEFINE_BUF_EVENT(xfs_buf_init);
 DEFINE_BUF_EVENT(xfs_buf_free);
 DEFINE_BUF_EVENT(xfs_buf_hold);
 DEFINE_BUF_EVENT(xfs_buf_rele);
-DEFINE_BUF_EVENT(xfs_buf_pin);
-DEFINE_BUF_EVENT(xfs_buf_unpin);
 DEFINE_BUF_EVENT(xfs_buf_iodone);
 DEFINE_BUF_EVENT(xfs_buf_iorequest);
 DEFINE_BUF_EVENT(xfs_buf_bawrite);
Index: xfs/fs/xfs/xfs_buf_item.c
===================================================================
--- xfs.orig/fs/xfs/xfs_buf_item.c	2010-05-29 18:17:16.277004555 +0200
+++ xfs/fs/xfs/xfs_buf_item.c	2010-05-29 18:19:18.662028022 +0200
@@ -359,14 +359,13 @@ xfs_buf_item_format(
 
 /*
  * This is called to pin the buffer associated with the buf log item in memory
- * so it cannot be written out.  Simply call bpin() on the buffer to do this.
+ * so it cannot be written out.
  *
  * We also always take a reference to the buffer log item here so that the bli
  * is held while the item is pinned in memory. This means that we can
  * unconditionally drop the reference count a transaction holds when the
  * transaction is completed.
  */
-
 STATIC void
 xfs_buf_item_pin(
 	struct xfs_log_item	*lip)
@@ -378,15 +377,15 @@ xfs_buf_item_pin(
 	ASSERT((bip->bli_flags & XFS_BLI_LOGGED) ||
 	       (bip->bli_flags & XFS_BLI_STALE));
 
-	atomic_inc(&bip->bli_refcount);
 	trace_xfs_buf_item_pin(bip);
-	xfs_bpin(bip->bli_buf);
+
+	atomic_inc(&bip->bli_refcount);
+	atomic_inc(&bip->bli_buf->b_pin_count);
 }
 
 /*
  * This is called to unpin the buffer associated with the buf log
  * item which was previously pinned with a call to xfs_buf_item_pin().
- * Just call bunpin() on the buffer to do this.
  *
  * Also drop the reference to the buf item for the current transaction.
  * If the XFS_BLI_STALE flag is set and we are the last reference,
@@ -414,7 +413,9 @@ xfs_buf_item_unpin(
 	trace_xfs_buf_item_unpin(bip);
 
 	freed = atomic_dec_and_test(&bip->bli_refcount);
-	xfs_bunpin(bp);
+
+	if (atomic_dec_and_test(&bp->b_pin_count))
+		wake_up_all(&bp->b_waiters);
 
 	if (freed && stale) {
 		ASSERT(bip->bli_flags & XFS_BLI_STALE);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
