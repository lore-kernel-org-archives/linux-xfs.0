Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q3O6Y2EQ031632 for <xfs@oss.sgi.com>; Tue, 24 Apr 2012 01:34:02 -0500
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	XrsRCTgRgpxzbYdO for <xfs@oss.sgi.com>;
	Mon, 23 Apr 2012 23:34:00 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1SMZJo-0004NO-4q
	for xfs@oss.sgi.com; Tue, 24 Apr 2012 16:33:44 +1000
Received: from dave by disappointment with local (Exim 4.77)
	(envelope-from <dave@disappointment.disaster>) id 1SMZJo-0005tD-0T
	for xfs@oss.sgi.com; Tue, 24 Apr 2012 16:33:44 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 04/10] xfs: add discontiguous buffer map interface
Date: Tue, 24 Apr 2012 16:33:34 +1000
Message-Id: <1335249220-22274-5-git-send-email-david@fromorbit.com>
In-Reply-To: <1335249220-22274-1-git-send-email-david@fromorbit.com>
References: <1335249220-22274-1-git-send-email-david@fromorbit.com>
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

With the internal interfaces supporting discontiguous buffer maps,
add external lookup, read and get interfaces so they can start to be
used.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_buf.c |   42 +++++++++++++++++++----------------------
 fs/xfs/xfs_buf.h |   55 ++++++++++++++++++++++++++++++++++++++++++++++++------
 2 files changed, 68 insertions(+), 29 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 1766edd..1503094 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -588,25 +588,21 @@ found:
  * more hits than misses.
  */
 struct xfs_buf *
-xfs_buf_get(
-	xfs_buftarg_t		*target,
-	xfs_daddr_t		blkno,
-	size_t			numblks,
+xfs_buf_get_map(
+	struct xfs_buftarg	*target,
+	struct xfs_buf_map	*map,
+	int			nmaps,
 	xfs_buf_flags_t		flags)
 {
 	struct xfs_buf		*bp;
 	struct xfs_buf		*new_bp;
-	struct xfs_buf_map	map = {
-		.bm_bn = blkno,
-		.bm_len = numblks,
-	};
 	int			error = 0;
 
-	bp = _xfs_buf_find(target, &map, 1, flags, NULL);
+	bp = _xfs_buf_find(target, map, nmaps, flags, NULL);
 	if (likely(bp))
 		goto found;
 
-	new_bp = _xfs_buf_alloc(target, &map, 1, flags);
+	new_bp = _xfs_buf_alloc(target, map, nmaps, flags);
 	if (unlikely(!new_bp))
 		return NULL;
 
@@ -616,7 +612,7 @@ xfs_buf_get(
 		return NULL;
 	}
 
-	bp = _xfs_buf_find(target, &map, 1, flags, new_bp);
+	bp = _xfs_buf_find(target, map, nmaps, flags, new_bp);
 	if (!bp) {
 		xfs_buf_free(new_bp);
 		return NULL;
@@ -629,7 +625,7 @@ xfs_buf_get(
 	 * Now we have a workable buffer, fill in the block number so
 	 * that we can do IO on it.
 	 */
-	bp->b_bn = blkno;
+	bp->b_bn = map[0].bm_bn;
 
 found:
 	if (!bp->b_addr) {
@@ -665,17 +661,17 @@ _xfs_buf_read(
 }
 
 xfs_buf_t *
-xfs_buf_read(
-	xfs_buftarg_t		*target,
-	xfs_daddr_t		blkno,
-	size_t			numblks,
+xfs_buf_read_map(
+	struct xfs_buftarg	*target,
+	struct xfs_buf_map	*map,
+	int			nmaps,
 	xfs_buf_flags_t		flags)
 {
-	xfs_buf_t		*bp;
+	struct xfs_buf		*bp;
 
 	flags |= XBF_READ;
 
-	bp = xfs_buf_get(target, blkno, numblks, flags);
+	bp = xfs_buf_get_map(target, map, nmaps, flags);
 	if (bp) {
 		trace_xfs_buf_read(bp, flags, _RET_IP_);
 
@@ -703,15 +699,15 @@ xfs_buf_read(
  *	safe manner.
  */
 void
-xfs_buf_readahead(
-	xfs_buftarg_t		*target,
-	xfs_daddr_t		blkno,
-	size_t			numblks)
+xfs_buf_readahead_map(
+	struct xfs_buftarg	*target,
+	struct xfs_buf_map	*map,
+	int			nmaps)
 {
 	if (bdi_read_congested(target->bt_bdi))
 		return;
 
-	xfs_buf_read(target, blkno, numblks,
+	xfs_buf_read_map(target, map, nmaps,
 		     XBF_TRYLOCK|XBF_ASYNC|XBF_READ_AHEAD);
 }
 
diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
index 3de9e80..118d586 100644
--- a/fs/xfs/xfs_buf.h
+++ b/fs/xfs/xfs_buf.h
@@ -187,12 +187,55 @@ xfs_buf_alloc(
 	return _xfs_buf_alloc(target, &map, 1, flags);
 }
 
-struct xfs_buf *xfs_buf_get(struct xfs_buftarg *target, xfs_daddr_t blkno,
-				size_t numblks, xfs_buf_flags_t flags);
-struct xfs_buf *xfs_buf_read(struct xfs_buftarg *target, xfs_daddr_t blkno,
-				size_t numblks, xfs_buf_flags_t flags);
-void xfs_buf_readahead(struct xfs_buftarg *target, xfs_daddr_t blkno,
-				size_t numblks);
+struct xfs_buf *xfs_buf_get_map(struct xfs_buftarg *target,
+			       struct xfs_buf_map *map, int nmaps,
+			       xfs_buf_flags_t flags);
+struct xfs_buf *xfs_buf_read_map(struct xfs_buftarg *target,
+			       struct xfs_buf_map *map, int nmaps,
+			       xfs_buf_flags_t flags);
+void xfs_buf_readahead_map(struct xfs_buftarg *target,
+			       struct xfs_buf_map *map, int nmaps);
+
+static inline struct xfs_buf *
+xfs_buf_get(
+	struct xfs_buftarg	*target,
+	xfs_daddr_t		blkno,
+	size_t			numblks,
+	xfs_buf_flags_t		flags)
+{
+	struct xfs_buf_map	map = {
+		.bm_bn = blkno,
+		.bm_len = numblks,
+	};
+	return xfs_buf_get_map(target, &map, 1, flags);
+}
+
+static inline struct xfs_buf *
+xfs_buf_read(
+	struct xfs_buftarg	*target,
+	xfs_daddr_t		blkno,
+	size_t			numblks,
+	xfs_buf_flags_t		flags)
+{
+	struct xfs_buf_map	map = {
+		.bm_bn = blkno,
+		.bm_len = numblks,
+	};
+	return xfs_buf_read_map(target, &map, 1, flags);
+}
+
+static inline void
+xfs_buf_readahead(
+	struct xfs_buftarg	*target,
+	xfs_daddr_t		blkno,
+	size_t			numblks)
+{
+	struct xfs_buf_map	map = {
+		.bm_bn = blkno,
+		.bm_len = numblks,
+	};
+	return xfs_buf_readahead_map(target, &map, 1);
+}
 
 struct xfs_buf *xfs_buf_get_empty(struct xfs_buftarg *target, size_t numblks);
 void xfs_buf_set_empty(struct xfs_buf *bp, size_t numblks);
-- 
1.7.9.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
