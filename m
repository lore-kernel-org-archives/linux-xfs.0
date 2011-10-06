Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p96L6fQK201678 for <xfs@oss.sgi.com>; Thu, 6 Oct 2011 16:06:41 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 43E861C6F179
	for <xfs@oss.sgi.com>; Thu,  6 Oct 2011 14:06:40 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	ZYwcU6saY1OFxrV7 for <xfs@oss.sgi.com>;
	Thu, 06 Oct 2011 14:06:40 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1RBv9L-0004F1-IL
	for xfs@oss.sgi.com; Thu, 06 Oct 2011 21:06:39 +0000
Message-Id: <20111006210639.521140680@bombadil.infradead.org>
Date: Thu, 06 Oct 2011 17:06:13 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 6/9] xfs: clean up buffer allocation
References: <20111006210607.175284390@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-cleanup-buffer-allocation
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

Change _xfs_buf_initialize to allocate the buffer directly and rename it to
xfs_buf_alloc now that is the only buffer allocation routine.  Also remove
the xfs_buf_deallocate wrapper around the kmem_zone_free calls for buffers.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/xfs_buf.c
===================================================================
--- xfs.orig/fs/xfs/xfs_buf.c	2011-10-02 16:08:22.484275559 +0200
+++ xfs/fs/xfs/xfs_buf.c	2011-10-02 16:17:59.831271600 +0200
@@ -65,10 +65,6 @@ struct workqueue_struct *xfsconvertd_wor
 #define xb_to_km(flags) \
 	 (((flags) & XBF_DONT_BLOCK) ? KM_NOFS : KM_SLEEP)
 
-#define xfs_buf_allocate(flags) \
-	kmem_zone_alloc(xfs_buf_zone, xb_to_km(flags))
-#define xfs_buf_deallocate(bp) \
-	kmem_zone_free(xfs_buf_zone, (bp));
 
 static inline int
 xfs_buf_is_vmapped(
@@ -167,14 +163,19 @@ xfs_buf_stale(
 	ASSERT(atomic_read(&bp->b_hold) >= 1);
 }
 
-STATIC void
-_xfs_buf_initialize(
-	xfs_buf_t		*bp,
-	xfs_buftarg_t		*target,
+struct xfs_buf *
+xfs_buf_alloc(
+	struct xfs_buftarg	*target,
 	xfs_off_t		range_base,
 	size_t			range_length,
 	xfs_buf_flags_t		flags)
 {
+	struct xfs_buf		*bp;
+
+	bp = kmem_zone_alloc(xfs_buf_zone, xb_to_km(flags));
+	if (unlikely(!bp))
+		return NULL;
+
 	/*
 	 * We don't want certain flags to appear in b_flags.
 	 */
@@ -203,8 +204,9 @@ _xfs_buf_initialize(
 	init_waitqueue_head(&bp->b_waiters);
 
 	XFS_STATS_INC(xb_create);
-
 	trace_xfs_buf_init(bp, _RET_IP_);
+
+	return bp;
 }
 
 /*
@@ -277,7 +279,7 @@ xfs_buf_free(
 	} else if (bp->b_flags & _XBF_KMEM)
 		kmem_free(bp->b_addr);
 	_xfs_buf_free_pages(bp);
-	xfs_buf_deallocate(bp);
+	kmem_zone_free(xfs_buf_zone, bp);
 }
 
 /*
@@ -539,16 +541,14 @@ xfs_buf_get(
 	if (likely(bp))
 		goto found;
 
-	new_bp = xfs_buf_allocate(flags);
+	new_bp = xfs_buf_alloc(target, ioff << BBSHIFT, isize << BBSHIFT,
+			       flags);
 	if (unlikely(!new_bp))
 		return NULL;
 
-	_xfs_buf_initialize(new_bp, target,
-			    ioff << BBSHIFT, isize << BBSHIFT, flags);
-
 	bp = _xfs_buf_find(target, ioff, isize, flags, new_bp);
 	if (!bp) {
-		xfs_buf_deallocate(new_bp);
+		kmem_zone_free(xfs_buf_zone, new_bp);
 		return NULL;
 	}
 
@@ -557,7 +557,7 @@ xfs_buf_get(
 		if (error)
 			goto no_buffer;
 	} else
-		xfs_buf_deallocate(new_bp);
+		kmem_zone_free(xfs_buf_zone, new_bp);
 
 	/*
 	 * Now we have a workable buffer, fill in the block number so
@@ -694,19 +694,6 @@ xfs_buf_read_uncached(
 	return bp;
 }
 
-xfs_buf_t *
-xfs_buf_get_empty(
-	size_t			len,
-	xfs_buftarg_t		*target)
-{
-	xfs_buf_t		*bp;
-
-	bp = xfs_buf_allocate(0);
-	if (bp)
-		_xfs_buf_initialize(bp, target, 0, len, 0);
-	return bp;
-}
-
 /*
  * Return a buffer allocated as an empty buffer and associated to external
  * memory via xfs_buf_associate_memory() back to it's empty state.
@@ -792,10 +779,9 @@ xfs_buf_get_uncached(
 	int			error, i;
 	xfs_buf_t		*bp;
 
-	bp = xfs_buf_allocate(0);
+	bp = xfs_buf_alloc(target, 0, len, 0);
 	if (unlikely(bp == NULL))
 		goto fail;
-	_xfs_buf_initialize(bp, target, 0, len, 0);
 
 	error = _xfs_buf_get_pages(bp, page_count, 0);
 	if (error)
@@ -823,7 +809,7 @@ xfs_buf_get_uncached(
 		__free_page(bp->b_pages[i]);
 	_xfs_buf_free_pages(bp);
  fail_free_buf:
-	xfs_buf_deallocate(bp);
+	kmem_zone_free(xfs_buf_zone, bp);
  fail:
 	return NULL;
 }
Index: xfs/fs/xfs/xfs_buf.h
===================================================================
--- xfs.orig/fs/xfs/xfs_buf.h	2011-10-02 16:15:08.656771306 +0200
+++ xfs/fs/xfs/xfs_buf.h	2011-10-02 16:16:39.771770418 +0200
@@ -175,7 +175,8 @@ extern xfs_buf_t *xfs_buf_get(xfs_buftar
 extern xfs_buf_t *xfs_buf_read(xfs_buftarg_t *, xfs_off_t, size_t,
 				xfs_buf_flags_t);
 
-extern xfs_buf_t *xfs_buf_get_empty(size_t, xfs_buftarg_t *);
+struct xfs_buf *xfs_buf_alloc(struct xfs_buftarg *, xfs_off_t, size_t,
+			      xfs_buf_flags_t);
 extern void xfs_buf_set_empty(struct xfs_buf *bp, size_t len);
 extern xfs_buf_t *xfs_buf_get_uncached(struct xfs_buftarg *, size_t, int);
 extern int xfs_buf_associate_memory(xfs_buf_t *, void *, size_t);
Index: xfs/fs/xfs/xfs_log.c
===================================================================
--- xfs.orig/fs/xfs/xfs_log.c	2011-10-02 16:15:08.636789023 +0200
+++ xfs/fs/xfs/xfs_log.c	2011-10-02 16:15:36.039418844 +0200
@@ -1035,7 +1035,7 @@ xlog_alloc_log(xfs_mount_t	*mp,
 	xlog_get_iclog_buffer_size(mp, log);
 
 	error = ENOMEM;
-	bp = xfs_buf_get_empty(log->l_iclog_size, mp->m_logdev_targp);
+	bp = xfs_buf_alloc(mp->m_logdev_targp, 0, log->l_iclog_size, 0);
 	if (!bp)
 		goto out_free_log;
 	bp->b_iodone = xlog_iodone;

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
