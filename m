Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qASMOp0o218575 for <xfs@oss.sgi.com>; Wed, 28 Nov 2012 16:24:51 -0600
Received: from eagdhcp-232-125.americas.sgi.com
	(eagdhcp-232-125.americas.sgi.com [128.162.232.125])
	by relay3.corp.sgi.com (Postfix) with ESMTP id DE2E2AC004
	for <xfs@oss.sgi.com>; Wed, 28 Nov 2012 14:27:05 -0800 (PST)
Received: from eagdhcp-232-125.americas.sgi.com (localhost [127.0.0.1])
	by eagdhcp-232-125.americas.sgi.com (8.14.5/8.14.5) with ESMTP id
	qASMR6J5003587
	for <xfs@oss.sgi.com>; Wed, 28 Nov 2012 16:27:06 -0600 (CST)
	(envelope-from tinguely@sgi.com)
Message-Id: <20121128222622.688093599@sgi.com>
Date: Wed, 28 Nov 2012 16:23:10 -0600
From: Mark Tinguely <tinguely@sgi.com>
Subject: [PATCH v2 1/3] xfs: use b_maps[] for discontiguous buffers
References: <20121128222309.109033307@.sgi.com>
Content-Disposition: inline; filename=1-3-xfs-use-xfs_buf-b_maps.patch
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

Commits starting at 77c1a08 introduced a multiple segment support
to xfs_buf. xfs_trans_buf_item_match() could not find a multi-segment
buffer in the transaction because it was looking at the single segment
block number rather than the multi-segment b_maps[0].bm.bn. This
results on a recursive buffer lock that can never be satisfied.

This patch:
 1) Changed the remaining b_map accesses to be b_maps[0] accesses.
 2) Renames the single segment b_map structure to __b_map to avoid
    future confusion.

Signed-off-by: Mark Tinguely <tinguely@sgi.com>

---
 fs/xfs/xfs_buf.c |   12 ++++++------
 fs/xfs/xfs_buf.h |    6 +++---
 2 files changed, 9 insertions(+), 9 deletions(-)

Index: b/fs/xfs/xfs_buf.c
===================================================================
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -175,7 +175,7 @@ xfs_buf_get_maps(
 	bp->b_map_count = map_count;
 
 	if (map_count == 1) {
-		bp->b_maps = &bp->b_map;
+		bp->b_maps = &bp->__b_map;
 		return 0;
 	}
 
@@ -193,7 +193,7 @@ static void
 xfs_buf_free_maps(
 	struct xfs_buf	*bp)
 {
-	if (bp->b_maps != &bp->b_map) {
+	if (bp->b_maps != &bp->__b_map) {
 		kmem_free(bp->b_maps);
 		bp->b_maps = NULL;
 	}
@@ -377,8 +377,8 @@ xfs_buf_allocate_memory(
 	}
 
 use_alloc_page:
-	start = BBTOB(bp->b_map.bm_bn) >> PAGE_SHIFT;
-	end = (BBTOB(bp->b_map.bm_bn + bp->b_length) + PAGE_SIZE - 1)
+	start = BBTOB(bp->b_maps[0].bm_bn) >> PAGE_SHIFT;
+	end = (BBTOB(bp->b_maps[0].bm_bn + bp->b_length) + PAGE_SIZE - 1)
 								>> PAGE_SHIFT;
 	page_count = end - start;
 	error = _xfs_buf_get_pages(bp, page_count, flags);
@@ -640,7 +640,7 @@ _xfs_buf_read(
 	xfs_buf_flags_t		flags)
 {
 	ASSERT(!(flags & XBF_WRITE));
-	ASSERT(bp->b_map.bm_bn != XFS_BUF_DADDR_NULL);
+	ASSERT(bp->b_maps[0].bm_bn != XFS_BUF_DADDR_NULL);
 
 	bp->b_flags &= ~(XBF_WRITE | XBF_ASYNC | XBF_READ_AHEAD);
 	bp->b_flags |= flags & (XBF_READ | XBF_ASYNC | XBF_READ_AHEAD);
@@ -1709,7 +1709,7 @@ xfs_buf_cmp(
 	struct xfs_buf	*bp = container_of(b, struct xfs_buf, b_list);
 	xfs_daddr_t		diff;
 
-	diff = ap->b_map.bm_bn - bp->b_map.bm_bn;
+	diff = ap->b_maps[0].bm_bn - bp->b_maps[0].bm_bn;
 	if (diff < 0)
 		return -1;
 	if (diff > 0)
Index: b/fs/xfs/xfs_buf.h
===================================================================
--- a/fs/xfs/xfs_buf.h
+++ b/fs/xfs/xfs_buf.h
@@ -151,7 +151,7 @@ typedef struct xfs_buf {
 	struct page		**b_pages;	/* array of page pointers */
 	struct page		*b_page_array[XB_PAGES]; /* inline pages */
 	struct xfs_buf_map	*b_maps;	/* compound buffer map */
-	struct xfs_buf_map	b_map;		/* inline compound buffer map */
+	struct xfs_buf_map	__b_map;	/* inline compound buffer map */
 	int			b_map_count;
 	int			b_io_length;	/* IO size in BBs */
 	atomic_t		b_pin_count;	/* pin count */
@@ -330,8 +330,8 @@ void xfs_buf_stale(struct xfs_buf *bp);
  * In future, uncached buffers will pass the block number directly to the io
  * request function and hence these macros will go away at that point.
  */
-#define XFS_BUF_ADDR(bp)		((bp)->b_map.bm_bn)
-#define XFS_BUF_SET_ADDR(bp, bno)	((bp)->b_map.bm_bn = (xfs_daddr_t)(bno))
+#define XFS_BUF_ADDR(bp)		((bp)->b_maps[0].bm_bn)
+#define XFS_BUF_SET_ADDR(bp, bno)	((bp)->b_maps[0].bm_bn = (xfs_daddr_t)(bno))
 
 static inline void xfs_buf_set_ref(struct xfs_buf *bp, int lru_ref)
 {


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
