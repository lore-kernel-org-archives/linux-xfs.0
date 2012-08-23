Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7N52kCV134653 for <xfs@oss.sgi.com>; Thu, 23 Aug 2012 00:02:46 -0500
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	EA8EDwVviGNorONn for <xfs@oss.sgi.com>;
	Wed, 22 Aug 2012 22:03:31 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1T4PZq-0003F7-0t
	for xfs@oss.sgi.com; Thu, 23 Aug 2012 15:03:30 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1T4PZf-0003cK-V4
	for xfs@oss.sgi.com; Thu, 23 Aug 2012 15:03:19 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 015/102] xfs: clean up buffer allocation
Date: Thu, 23 Aug 2012 15:01:33 +1000
Message-Id: <1345698180-13612-16-git-send-email-david@fromorbit.com>
In-Reply-To: <1345698180-13612-1-git-send-email-david@fromorbit.com>
References: <1345698180-13612-1-git-send-email-david@fromorbit.com>
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

From: Christoph Hellwig <hch@infradead.org>

Upstream commit: 4347b9d7ad4223474d315c3ab6bc1ce7cce7fa2d

Change _xfs_buf_initialize to allocate the buffer directly and rename it to
xfs_buf_alloc now that is the only buffer allocation routine.  Also remove
the xfs_buf_deallocate wrapper around the kmem_zone_free calls for buffers.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Alex Elder <aelder@sgi.com>
---
 fs/xfs/linux-2.6/xfs_buf.c |   50 ++++++++++++++++----------------------------
 fs/xfs/linux-2.6/xfs_buf.h |    3 ++-
 fs/xfs/xfs_log.c           |    2 +-
 3 files changed, 21 insertions(+), 34 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_buf.c b/fs/xfs/linux-2.6/xfs_buf.c
index 6a2ab95..449ba57 100644
--- a/fs/xfs/linux-2.6/xfs_buf.c
+++ b/fs/xfs/linux-2.6/xfs_buf.c
@@ -66,10 +66,6 @@ struct workqueue_struct *xfsconvertd_workqueue;
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
@@ -544,16 +546,14 @@ xfs_buf_get(
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
 
@@ -562,7 +562,7 @@ xfs_buf_get(
 		if (error)
 			goto no_buffer;
 	} else
-		xfs_buf_deallocate(new_bp);
+		kmem_zone_free(xfs_buf_zone, new_bp);
 
 	/*
 	 * Now we have a workable buffer, fill in the block number so
@@ -703,19 +703,6 @@ xfs_buf_read_uncached(
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
@@ -801,10 +788,9 @@ xfs_buf_get_uncached(
 	int			error, i;
 	xfs_buf_t		*bp;
 
-	bp = xfs_buf_allocate(0);
+	bp = xfs_buf_alloc(target, 0, len, 0);
 	if (unlikely(bp == NULL))
 		goto fail;
-	_xfs_buf_initialize(bp, target, 0, len, 0);
 
 	error = _xfs_buf_get_pages(bp, page_count, 0);
 	if (error)
@@ -834,7 +820,7 @@ xfs_buf_get_uncached(
 		__free_page(bp->b_pages[i]);
 	_xfs_buf_free_pages(bp);
  fail_free_buf:
-	xfs_buf_deallocate(bp);
+	kmem_zone_free(xfs_buf_zone, bp);
  fail:
 	return NULL;
 }
diff --git a/fs/xfs/linux-2.6/xfs_buf.h b/fs/xfs/linux-2.6/xfs_buf.h
index 36d6ee4..ee3714b 100644
--- a/fs/xfs/linux-2.6/xfs_buf.h
+++ b/fs/xfs/linux-2.6/xfs_buf.h
@@ -177,7 +177,8 @@ extern xfs_buf_t *xfs_buf_get(xfs_buftarg_t *, xfs_off_t, size_t,
 extern xfs_buf_t *xfs_buf_read(xfs_buftarg_t *, xfs_off_t, size_t,
 				xfs_buf_flags_t);
 
-extern xfs_buf_t *xfs_buf_get_empty(size_t, xfs_buftarg_t *);
+struct xfs_buf *xfs_buf_alloc(struct xfs_buftarg *, xfs_off_t, size_t,
+			      xfs_buf_flags_t);
 extern void xfs_buf_set_empty(struct xfs_buf *bp, size_t len);
 extern xfs_buf_t *xfs_buf_get_uncached(struct xfs_buftarg *, size_t, int);
 extern int xfs_buf_associate_memory(xfs_buf_t *, void *, size_t);
diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 41d5b8f..8700411 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -1053,7 +1053,7 @@ xlog_alloc_log(xfs_mount_t	*mp,
 	xlog_get_iclog_buffer_size(mp, log);
 
 	error = ENOMEM;
-	bp = xfs_buf_get_empty(log->l_iclog_size, mp->m_logdev_targp);
+	bp = xfs_buf_alloc(mp->m_logdev_targp, 0, log->l_iclog_size, 0);
 	if (!bp)
 		goto out_free_log;
 	XFS_BUF_SET_IODONE_FUNC(bp, xlog_iodone);
-- 
1.7.10

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
