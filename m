Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qAKMe9xs218870 for <xfs@oss.sgi.com>; Tue, 20 Nov 2012 16:40:09 -0600
Received: from eagdhcp-232-125.americas.sgi.com
	(eagdhcp-232-125.americas.sgi.com [128.162.232.125])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 349A8304048
	for <xfs@oss.sgi.com>; Tue, 20 Nov 2012 14:42:17 -0800 (PST)
Received: from eagdhcp-232-125.americas.sgi.com (localhost [127.0.0.1])
	by eagdhcp-232-125.americas.sgi.com (8.14.5/8.14.5) with ESMTP id
	qAKMgEbS009256
	for <xfs@oss.sgi.com>; Tue, 20 Nov 2012 16:42:14 -0600 (CST)
	(envelope-from tinguely@sgi.com)
Message-Id: <20121120224146.376767354@sgi.com>
Date: Tue, 20 Nov 2012 16:41:21 -0600
From: Mark Tinguely <tinguely@sgi.com>
Subject: [PATCH 1/2] xfs: use b_maps[] for discontiguous buffers
References: <20121120224120.224166649@sgi.com>
Content-Disposition: inline; filename=xfs-use-xfs_buf-b_maps.patch
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

This patch sets all the b_bmap accesses to be b_maps[0]. b_maps[0]
works for single and multiple segment buffers.

This fixes a bug where xfs_trans_buf_item_match() could not find a
multi-segment buffer associated with the transaction because it was
looking for the block number in the single segment location
b_map.bm.bn rather than the new generic b_maps[0].bm.bn. This
resulted in recursive buffer lock that can never be satisfied.

Signed-off-by: Mark Tinguely <tinguely@sgi.com>

---
 fs/xfs/xfs_buf.c |    8 ++++----
 fs/xfs/xfs_buf.h |    4 ++--
 2 files changed, 6 insertions(+), 6 deletions(-)

Index: b/fs/xfs/xfs_buf.c
===================================================================
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
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
