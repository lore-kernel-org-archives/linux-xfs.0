Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q5M8oWXj257050 for <xfs@oss.sgi.com>; Fri, 22 Jun 2012 03:50:32 -0500
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	QExcFopLtAGxzHiN for <xfs@oss.sgi.com>;
	Fri, 22 Jun 2012 01:50:30 -0700 (PDT)
Received: from [192.168.1.1] (helo=disappointment)
	by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1ShzZU-0005Rq-Cz
	for xfs@oss.sgi.com; Fri, 22 Jun 2012 18:50:28 +1000
Received: from dave by disappointment with local (Exim 4.77)
	(envelope-from <dave@disappointment.disaster>) id 1ShzZK-0006qF-Au
	for xfs@oss.sgi.com; Fri, 22 Jun 2012 18:50:18 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 4/9] xfs: add discontiguous buffer map interface
Date: Fri, 22 Jun 2012 18:50:10 +1000
Message-Id: <1340355015-26250-5-git-send-email-david@fromorbit.com>
In-Reply-To: <1340355015-26250-1-git-send-email-david@fromorbit.com>
References: <1340355015-26250-1-git-send-email-david@fromorbit.com>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_buf.c |   37 ++++++++++++++++++-------------------
 fs/xfs/xfs_buf.h |   46 ++++++++++++++++++++++++++++++++++++++++------
 2 files changed, 58 insertions(+), 25 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 82bb812..39c5d76 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -581,22 +581,21 @@ found:
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
 	int			error = 0;
-	DEFINE_SINGLE_BUF_MAP(map, blkno, numblks);
 
-	bp = _xfs_buf_find(target, &map, 1, flags, NULL);
+	bp = _xfs_buf_find(target, map, nmaps, flags, NULL);
 	if (likely(bp))
 		goto found;
 
-	new_bp = _xfs_buf_alloc(target, &map, 1, flags);
+	new_bp = _xfs_buf_alloc(target, map, nmaps, flags);
 	if (unlikely(!new_bp))
 		return NULL;
 
@@ -606,7 +605,7 @@ xfs_buf_get(
 		return NULL;
 	}
 
-	bp = _xfs_buf_find(target, &map, 1, flags, new_bp);
+	bp = _xfs_buf_find(target, map, nmaps, flags, new_bp);
 	if (!bp) {
 		xfs_buf_free(new_bp);
 		return NULL;
@@ -649,17 +648,17 @@ _xfs_buf_read(
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
 
@@ -687,15 +686,15 @@ xfs_buf_read(
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
index 67d1349..aa96bd4 100644
--- a/fs/xfs/xfs_buf.h
+++ b/fs/xfs/xfs_buf.h
@@ -184,12 +184,46 @@ xfs_buf_alloc(
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
+	DEFINE_SINGLE_BUF_MAP(map, blkno, numblks);
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
+	DEFINE_SINGLE_BUF_MAP(map, blkno, numblks);
+	return xfs_buf_read_map(target, &map, 1, flags);
+}
+
+static inline void
+xfs_buf_readahead(
+	struct xfs_buftarg	*target,
+	xfs_daddr_t		blkno,
+	size_t			numblks)
+{
+	DEFINE_SINGLE_BUF_MAP(map, blkno, numblks);
+	return xfs_buf_readahead_map(target, &map, 1);
+}
 
 struct xfs_buf *xfs_buf_get_empty(struct xfs_buftarg *target, size_t numblks);
 void xfs_buf_set_empty(struct xfs_buf *bp, size_t numblks);
-- 
1.7.10

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
