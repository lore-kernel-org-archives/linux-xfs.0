Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q3DCBUgn037978 for <xfs@oss.sgi.com>; Fri, 13 Apr 2012 07:11:30 -0500
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	9ylrtBqsdBJT58Yi for <xfs@oss.sgi.com>;
	Fri, 13 Apr 2012 05:11:28 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1SIfLY-00031e-C2
	for xfs@oss.sgi.com; Fri, 13 Apr 2012 22:11:24 +1000
Received: from dave by disappointment with local (Exim 4.77)
	(envelope-from <dave@disappointment.disaster>) id 1SIfLO-0003Oh-9X
	for xfs@oss.sgi.com; Fri, 13 Apr 2012 22:11:14 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 17/18] xfs: kill XBF_DONTBLOCK
Date: Fri, 13 Apr 2012 22:11:00 +1000
Message-Id: <1334319061-12968-18-git-send-email-david@fromorbit.com>
In-Reply-To: <1334319061-12968-1-git-send-email-david@fromorbit.com>
References: <1334319061-12968-1-git-send-email-david@fromorbit.com>
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

From: Dave Chinner <dchinner@redhat.com>

Just about all callers of xfs_buf_read() and xfs_buf_get() use XBF_DONTBLOCK.
This is used to make memory allocation use GFP_NOFS rather than GFP_KERNEL to
avoid recursion through memory reclaim back into the filesystem.

All the blocking get calls in growfs occur inside a transaction, even though
they are no part of the transaction, so all allocation will be GFP_NOFS due to
the task flag PF_TRANS being set. The blocking read calls occur during log
recovery, so they will probably be unaffected by converting to GFP_NOFS
allocations.

Hence make XBF_DONTBLOCK behaviour always occur for buffers and kill the flag.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_attr.c      |    3 +--
 fs/xfs/xfs_buf.c       |   18 +++++++-----------
 fs/xfs/xfs_buf.h       |    2 --
 fs/xfs/xfs_trans_buf.c |   25 ++++---------------------
 fs/xfs/xfs_vnodeops.c  |    4 ++--
 5 files changed, 14 insertions(+), 38 deletions(-)

diff --git a/fs/xfs/xfs_attr.c b/fs/xfs/xfs_attr.c
index ad85bed..0960bb6 100644
--- a/fs/xfs/xfs_attr.c
+++ b/fs/xfs/xfs_attr.c
@@ -2114,8 +2114,7 @@ xfs_attr_rmtval_set(xfs_da_args_t *args)
 		dblkno = XFS_FSB_TO_DADDR(mp, map.br_startblock),
 		blkcnt = XFS_FSB_TO_BB(mp, map.br_blockcount);
 
-		bp = xfs_buf_get(mp->m_ddev_targp, dblkno, blkcnt,
-				 XBF_DONT_BLOCK);
+		bp = xfs_buf_get(mp->m_ddev_targp, dblkno, blkcnt, 0);
 		if (!bp)
 			return ENOMEM;
 
diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 8d76df1..e2e0538 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -56,11 +56,7 @@ static struct workqueue_struct *xfslogd_workqueue;
 #endif
 
 #define xb_to_gfp(flags) \
-	((((flags) & XBF_READ_AHEAD) ? __GFP_NORETRY : \
-	  ((flags) & XBF_DONT_BLOCK) ? GFP_NOFS : GFP_KERNEL) | __GFP_NOWARN)
-
-#define xb_to_km(flags) \
-	 (((flags) & XBF_DONT_BLOCK) ? KM_NOFS : KM_SLEEP)
+	((((flags) & XBF_READ_AHEAD) ? __GFP_NORETRY : GFP_NOFS) | __GFP_NOWARN)
 
 
 static inline int
@@ -172,14 +168,14 @@ xfs_buf_alloc(
 {
 	struct xfs_buf		*bp;
 
-	bp = kmem_zone_zalloc(xfs_buf_zone, xb_to_km(flags));
+	bp = kmem_zone_zalloc(xfs_buf_zone, KM_NOFS);
 	if (unlikely(!bp))
 		return NULL;
 
 	/*
 	 * We don't want certain flags to appear in b_flags.
 	 */
-	flags &= ~(XBF_MAPPED|XBF_DONT_BLOCK|XBF_READ_AHEAD);
+	flags &= ~(XBF_MAPPED|XBF_READ_AHEAD);
 
 	atomic_set(&bp->b_hold, 1);
 	atomic_set(&bp->b_lru_ref, 1);
@@ -233,7 +229,7 @@ _xfs_buf_get_pages(
 			bp->b_pages = bp->b_page_array;
 		} else {
 			bp->b_pages = kmem_alloc(sizeof(struct page *) *
-					page_count, xb_to_km(flags));
+						 page_count, KM_NOFS);
 			if (bp->b_pages == NULL)
 				return -ENOMEM;
 		}
@@ -310,7 +306,7 @@ xfs_buf_allocate_memory(
 	 */
 	size = BBTOB(bp->b_length);
 	if (size < PAGE_SIZE) {
-		bp->b_addr = kmem_alloc(size, xb_to_km(flags));
+		bp->b_addr = kmem_alloc(size, KM_NOFS);
 		if (!bp->b_addr) {
 			/* low memory - use alloc_page loop instead */
 			goto use_alloc_page;
@@ -653,7 +649,7 @@ xfs_buf_readahead(
 		return;
 
 	xfs_buf_read(target, blkno, numblks,
-		     XBF_TRYLOCK|XBF_ASYNC|XBF_READ_AHEAD|XBF_DONT_BLOCK);
+		     XBF_TRYLOCK|XBF_ASYNC|XBF_READ_AHEAD);
 }
 
 /*
@@ -744,7 +740,7 @@ xfs_buf_associate_memory(
 	bp->b_pages = NULL;
 	bp->b_addr = mem;
 
-	rval = _xfs_buf_get_pages(bp, page_count, XBF_DONT_BLOCK);
+	rval = _xfs_buf_get_pages(bp, page_count, 0);
 	if (rval)
 		return rval;
 
diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
index 512d9a6..846dee3 100644
--- a/fs/xfs/xfs_buf.h
+++ b/fs/xfs/xfs_buf.h
@@ -53,7 +53,6 @@ typedef enum {
 
 /* flags used only as arguments to access routines */
 #define XBF_TRYLOCK	(1 << 16)/* lock requested, but do not wait */
-#define XBF_DONT_BLOCK	(1 << 17)/* do not block in current thread */
 
 /* flags used only internally */
 #define _XBF_PAGES	(1 << 20)/* backed by refcounted pages */
@@ -74,7 +73,6 @@ typedef unsigned int xfs_buf_flags_t;
 	{ XBF_FUA,		"FUA" }, \
 	{ XBF_FLUSH,		"FLUSH" }, \
 	{ XBF_TRYLOCK,		"TRYLOCK" }, 	/* should never be set */\
-	{ XBF_DONT_BLOCK,	"DONT_BLOCK" },	/* ditto */\
 	{ _XBF_PAGES,		"PAGES" }, \
 	{ _XBF_KMEM,		"KMEM" }, \
 	{ _XBF_DELWRI_Q,	"DELWRI_Q" }
diff --git a/fs/xfs/xfs_trans_buf.c b/fs/xfs/xfs_trans_buf.c
index 5e4cf61..ccc6da1 100644
--- a/fs/xfs/xfs_trans_buf.c
+++ b/fs/xfs/xfs_trans_buf.c
@@ -148,8 +148,7 @@ xfs_trans_get_buf(xfs_trans_t	*tp,
 	 * Default to a normal get_buf() call if the tp is NULL.
 	 */
 	if (tp == NULL)
-		return xfs_buf_get(target_dev, blkno, len,
-				   flags | XBF_DONT_BLOCK);
+		return xfs_buf_get(target_dev, blkno, len, flags);
 
 	/*
 	 * If we find the buffer in the cache with this transaction
@@ -174,15 +173,7 @@ xfs_trans_get_buf(xfs_trans_t	*tp,
 		return (bp);
 	}
 
-	/*
-	 * We always specify the XBF_DONT_BLOCK flag within a transaction
-	 * so that get_buf does not try to push out a delayed write buffer
-	 * which might cause another transaction to take place (if the
-	 * buffer was delayed alloc).  Such recursive transactions can
-	 * easily deadlock with our current transaction as well as cause
-	 * us to run out of stack space.
-	 */
-	bp = xfs_buf_get(target_dev, blkno, len, flags | XBF_DONT_BLOCK);
+	bp = xfs_buf_get(target_dev, blkno, len, flags);
 	if (bp == NULL) {
 		return NULL;
 	}
@@ -283,7 +274,7 @@ xfs_trans_read_buf(
 	 * Default to a normal get_buf() call if the tp is NULL.
 	 */
 	if (tp == NULL) {
-		bp = xfs_buf_read(target, blkno, len, flags | XBF_DONT_BLOCK);
+		bp = xfs_buf_read(target, blkno, len, flags);
 		if (!bp)
 			return (flags & XBF_TRYLOCK) ?
 					EAGAIN : XFS_ERROR(ENOMEM);
@@ -367,15 +358,7 @@ xfs_trans_read_buf(
 		return 0;
 	}
 
-	/*
-	 * We always specify the XBF_DONT_BLOCK flag within a transaction
-	 * so that get_buf does not try to push out a delayed write buffer
-	 * which might cause another transaction to take place (if the
-	 * buffer was delayed alloc).  Such recursive transactions can
-	 * easily deadlock with our current transaction as well as cause
-	 * us to run out of stack space.
-	 */
-	bp = xfs_buf_read(target, blkno, len, flags | XBF_DONT_BLOCK);
+	bp = xfs_buf_read(target, blkno, len, flags);
 	if (bp == NULL) {
 		*bpp = NULL;
 		return (flags & XBF_TRYLOCK) ?
diff --git a/fs/xfs/xfs_vnodeops.c b/fs/xfs/xfs_vnodeops.c
index 8f99c77..6c18745 100644
--- a/fs/xfs/xfs_vnodeops.c
+++ b/fs/xfs/xfs_vnodeops.c
@@ -82,7 +82,7 @@ xfs_readlink_bmap(
 		byte_cnt = XFS_FSB_TO_B(mp, mval[n].br_blockcount);
 
 		bp = xfs_buf_read(mp->m_ddev_targp, d, BTOBB(byte_cnt),
-				  XBF_MAPPED | XBF_DONT_BLOCK);
+				  XBF_MAPPED);
 		if (!bp)
 			return XFS_ERROR(ENOMEM);
 		error = bp->b_error;
@@ -1966,7 +1966,7 @@ xfs_zero_remaining_bytes(
 
 	bp = xfs_buf_get_uncached(XFS_IS_REALTIME_INODE(ip) ?
 					mp->m_rtdev_targp : mp->m_ddev_targp,
-				BTOBB(mp->m_sb.sb_blocksize), XBF_DONT_BLOCK);
+				  BTOBB(mp->m_sb.sb_blocksize), 0);
 	if (!bp)
 		return XFS_ERROR(ENOMEM);
 
-- 
1.7.9.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
