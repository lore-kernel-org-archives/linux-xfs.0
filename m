Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o6IKaRpw163622 for <xfs@oss.sgi.com>; Sun, 18 Jul 2010 15:36:27 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7EBBB15EC74A
	for <xfs@oss.sgi.com>; Sun, 18 Jul 2010 13:39:26 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id 5LkG0C2x1EnDaYwl for
	<xfs@oss.sgi.com>; Sun, 18 Jul 2010 13:39:26 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.72 #1 (Red Hat
	Linux)) id 1Oaady-0003tJ-50
	for xfs@oss.sgi.com; Sun, 18 Jul 2010 20:39:26 +0000
Message-Id: <20100718203926.050740375@bombadil.infradead.org>
Date: Sun, 18 Jul 2010 16:38:50 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 2/6] xfs: clean up filestreams helpers
References: <20100718203848.927859114@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-cleanup-filestreams-getput
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

Move xfs_filestream_peek_ag, xxfs_filestream_get_ag and xfs_filestream_put_ag
from xfs_filestream.h to xfs_filestream.c where it's only callers are, and
remove the inline marker while we're at it to let the compiler decide on the
inlining.  Also don't return a value from xfs_filestream_put_ag because
we don't need it.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/xfs_filestream.c
===================================================================
--- xfs.orig/fs/xfs/xfs_filestream.c	2010-07-18 15:10:45.662494680 +0200
+++ xfs/fs/xfs/xfs_filestream.c	2010-07-18 15:11:26.526494680 +0200
@@ -123,6 +123,82 @@ typedef struct fstrm_item
 	xfs_inode_t	*pip;	/* Parent directory inode pointer. */
 } fstrm_item_t;
 
+/*
+ * Allocation group filestream associations are tracked with per-ag atomic
+ * counters.  These counters allow _xfs_filestream_pick_ag() to tell whether a
+ * particular AG already has active filestreams associated with it. The mount
+ * point's m_peraglock is used to protect these counters from per-ag array
+ * re-allocation during a growfs operation.  When xfs_growfs_data_private() is
+ * about to reallocate the array, it calls xfs_filestream_flush() with the
+ * m_peraglock held in write mode.
+ *
+ * Since xfs_mru_cache_flush() guarantees that all the free functions for all
+ * the cache elements have finished executing before it returns, it's safe for
+ * the free functions to use the atomic counters without m_peraglock protection.
+ * This allows the implementation of xfs_fstrm_free_func() to be agnostic about
+ * whether it was called with the m_peraglock held in read mode, write mode or
+ * not held at all.  The race condition this addresses is the following:
+ *
+ *  - The work queue scheduler fires and pulls a filestream directory cache
+ *    element off the LRU end of the cache for deletion, then gets pre-empted.
+ *  - A growfs operation grabs the m_peraglock in write mode, flushes all the
+ *    remaining items from the cache and reallocates the mount point's per-ag
+ *    array, resetting all the counters to zero.
+ *  - The work queue thread resumes and calls the free function for the element
+ *    it started cleaning up earlier.  In the process it decrements the
+ *    filestreams counter for an AG that now has no references.
+ *
+ * With a shrinkfs feature, the above scenario could panic the system.
+ *
+ * All other uses of the following macros should be protected by either the
+ * m_peraglock held in read mode, or the cache's internal locking exposed by the
+ * interval between a call to xfs_mru_cache_lookup() and a call to
+ * xfs_mru_cache_done().  In addition, the m_peraglock must be held in read mode
+ * when new elements are added to the cache.
+ *
+ * Combined, these locking rules ensure that no associations will ever exist in
+ * the cache that reference per-ag array elements that have since been
+ * reallocated.
+ */
+static int
+xfs_filestream_peek_ag(
+	xfs_mount_t	*mp,
+	xfs_agnumber_t	agno)
+{
+	struct xfs_perag *pag;
+	int		ret;
+
+	pag = xfs_perag_get(mp, agno);
+	ret = atomic_read(&pag->pagf_fstrms);
+	xfs_perag_put(pag);
+	return ret;
+}
+
+static int
+xfs_filestream_get_ag(
+	xfs_mount_t	*mp,
+	xfs_agnumber_t	agno)
+{
+	struct xfs_perag *pag;
+	int		ret;
+
+	pag = xfs_perag_get(mp, agno);
+	ret = atomic_inc_return(&pag->pagf_fstrms);
+	xfs_perag_put(pag);
+	return ret;
+}
+
+static void
+xfs_filestream_put_ag(
+	xfs_mount_t	*mp,
+	xfs_agnumber_t	agno)
+{
+	struct xfs_perag *pag;
+
+	pag = xfs_perag_get(mp, agno);
+	atomic_dec(&pag->pagf_fstrms);
+	xfs_perag_put(pag);
+}
 
 /*
  * Scan the AGs starting at startag looking for an AG that isn't in use and has
@@ -351,16 +427,14 @@ xfs_fstrm_free_func(
 {
 	fstrm_item_t	*item  = (fstrm_item_t *)data;
 	xfs_inode_t	*ip = item->ip;
-	int ref;
 
 	ASSERT(ip->i_ino == ino);
 
 	xfs_iflags_clear(ip, XFS_IFILESTREAM);
 
 	/* Drop the reference taken on the AG when the item was added. */
-	ref = xfs_filestream_put_ag(ip->i_mount, item->ag);
+	xfs_filestream_put_ag(ip->i_mount, item->ag);
 
-	ASSERT(ref >= 0);
 	TRACE_FREE(ip->i_mount, ip, item->pip, item->ag,
 		xfs_filestream_peek_ag(ip->i_mount, item->ag));
 
Index: xfs/fs/xfs/xfs_filestream.h
===================================================================
--- xfs.orig/fs/xfs/xfs_filestream.h	2010-07-18 15:10:45.676494680 +0200
+++ xfs/fs/xfs/xfs_filestream.h	2010-07-18 15:10:48.212494681 +0200
@@ -42,88 +42,6 @@ extern ktrace_t *xfs_filestreams_trace_b
 
 #endif
 
-/*
- * Allocation group filestream associations are tracked with per-ag atomic
- * counters.  These counters allow _xfs_filestream_pick_ag() to tell whether a
- * particular AG already has active filestreams associated with it. The mount
- * point's m_peraglock is used to protect these counters from per-ag array
- * re-allocation during a growfs operation.  When xfs_growfs_data_private() is
- * about to reallocate the array, it calls xfs_filestream_flush() with the
- * m_peraglock held in write mode.
- *
- * Since xfs_mru_cache_flush() guarantees that all the free functions for all
- * the cache elements have finished executing before it returns, it's safe for
- * the free functions to use the atomic counters without m_peraglock protection.
- * This allows the implementation of xfs_fstrm_free_func() to be agnostic about
- * whether it was called with the m_peraglock held in read mode, write mode or
- * not held at all.  The race condition this addresses is the following:
- *
- *  - The work queue scheduler fires and pulls a filestream directory cache
- *    element off the LRU end of the cache for deletion, then gets pre-empted.
- *  - A growfs operation grabs the m_peraglock in write mode, flushes all the
- *    remaining items from the cache and reallocates the mount point's per-ag
- *    array, resetting all the counters to zero.
- *  - The work queue thread resumes and calls the free function for the element
- *    it started cleaning up earlier.  In the process it decrements the
- *    filestreams counter for an AG that now has no references.
- *
- * With a shrinkfs feature, the above scenario could panic the system.
- *
- * All other uses of the following macros should be protected by either the
- * m_peraglock held in read mode, or the cache's internal locking exposed by the
- * interval between a call to xfs_mru_cache_lookup() and a call to
- * xfs_mru_cache_done().  In addition, the m_peraglock must be held in read mode
- * when new elements are added to the cache.
- *
- * Combined, these locking rules ensure that no associations will ever exist in
- * the cache that reference per-ag array elements that have since been
- * reallocated.
- */
-/*
- * xfs_filestream_peek_ag is only used in tracing code
- */
-static inline int
-xfs_filestream_peek_ag(
-	xfs_mount_t	*mp,
-	xfs_agnumber_t	agno)
-{
-	struct xfs_perag *pag;
-	int		ret;
-
-	pag = xfs_perag_get(mp, agno);
-	ret = atomic_read(&pag->pagf_fstrms);
-	xfs_perag_put(pag);
-	return ret;
-}
-
-static inline int
-xfs_filestream_get_ag(
-	xfs_mount_t	*mp,
-	xfs_agnumber_t	agno)
-{
-	struct xfs_perag *pag;
-	int		ret;
-
-	pag = xfs_perag_get(mp, agno);
-	ret = atomic_inc_return(&pag->pagf_fstrms);
-	xfs_perag_put(pag);
-	return ret;
-}
-
-static inline int
-xfs_filestream_put_ag(
-	xfs_mount_t	*mp,
-	xfs_agnumber_t	agno)
-{
-	struct xfs_perag *pag;
-	int		ret;
-
-	pag = xfs_perag_get(mp, agno);
-	ret = atomic_dec_return(&pag->pagf_fstrms);
-	xfs_perag_put(pag);
-	return ret;
-}
-
 /* allocation selection flags */
 typedef enum xfs_fstrm_alloc {
 	XFS_PICK_USERDATA = 1,

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
