Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pB76J5a8046684 for <xfs@oss.sgi.com>; Wed, 7 Dec 2011 00:19:05 -0600
Received: from ipmail05.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E83271305D46
	for <xfs@oss.sgi.com>; Tue,  6 Dec 2011 22:19:02 -0800 (PST)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	yVFLaSthXl2MVy8T for <xfs@oss.sgi.com>;
	Tue, 06 Dec 2011 22:19:02 -0800 (PST)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1RYAqA-0003oH-Ap
	for xfs@oss.sgi.com; Wed, 07 Dec 2011 17:18:50 +1100
Received: from dave by disappointment with local (Exim 4.76)
	(envelope-from <dave@disappointment.disaster>) id 1RYApz-0003Up-Sr
	for xfs@oss.sgi.com; Wed, 07 Dec 2011 17:18:39 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 07/12] xfs: switch the buffer get/read API to use irec methods
Date: Wed,  7 Dec 2011 17:18:18 +1100
Message-Id: <1323238703-13198-8-git-send-email-david@fromorbit.com>
In-Reply-To: <1323238703-13198-1-git-send-email-david@fromorbit.com>
References: <1323238703-13198-1-git-send-email-david@fromorbit.com>
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

Before implementing multiple irec support, switch the non-irec
interface to use the irec interface internally. This allows the
buffer initialisation code to be swtiched to an irec interface to
enable multiple irec buffers to be implemented without duplicating
lots of code.

To be able to support sub-fsb addressed blocks (various AG headers)
add a special in-memory only state flag to the xfs_bmbt_irec
structure to allow the structure to hold different unit types. If no
flag is set, the unit type if FSB (as used everywhere right now).
Internally to the buffer cache the XFS_EXT_DADDR flag is used to
indicate the bmbt_irec values are in disk address format rather than
FSB to allow sub-FSB block support.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_bmap_btree.h |    6 ++-
 fs/xfs/xfs_buf.c        |  182 ++++++++++++++++++++++-------------------------
 2 files changed, 89 insertions(+), 99 deletions(-)

diff --git a/fs/xfs/xfs_bmap_btree.h b/fs/xfs/xfs_bmap_btree.h
index 0e66c4e..f888c8f 100644
--- a/fs/xfs/xfs_bmap_btree.h
+++ b/fs/xfs/xfs_bmap_btree.h
@@ -99,10 +99,14 @@ typedef enum {
 
 /*
  * Possible extent states.
+ *
+ * XFS_EXT_DADDR does not exist on disk - it is only used in memory to indicate
+ * that the contents of the bmbt_irec are in daddr units, not fsb units.
  */
 typedef enum {
 	XFS_EXT_NORM, XFS_EXT_UNWRITTEN,
-	XFS_EXT_DMAPI_OFFLINE, XFS_EXT_INVALID
+	XFS_EXT_DMAPI_OFFLINE, XFS_EXT_INVALID,
+	XFS_EXT_DADDR,
 } xfs_exntst_t;
 
 /*
diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index aebe954..2ca9086 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -542,10 +542,60 @@ xfs_buf_get(
 	size_t			numblks,
 	xfs_buf_flags_t		flags)
 {
+	struct xfs_bmbt_irec	map = {
+		.br_startblock = blkno,
+		.br_blockcount = numblks,
+		.br_state = XFS_EXT_DADDR,
+	};
+
+	return xfs_buf_get_irec(target, &map, 1, flags);
+}
+
+STATIC int
+_xfs_buf_read(
+	xfs_buf_t		*bp,
+	xfs_buf_flags_t		flags)
+{
+	int			status;
+
+	ASSERT(!(flags & (XBF_DELWRI|XBF_WRITE)));
+	ASSERT(bp->b_vec[0].bv_bn != XFS_BUF_DADDR_NULL);
+
+	bp->b_flags &= ~(XBF_WRITE | XBF_ASYNC | XBF_DELWRI | XBF_READ_AHEAD);
+	bp->b_flags |= flags & (XBF_READ | XBF_ASYNC | XBF_READ_AHEAD);
+
+	status = xfs_buf_iorequest(bp);
+	if (status || bp->b_error || (flags & XBF_ASYNC))
+		return status;
+	return xfs_buf_iowait(bp);
+}
+
+/*
+ * XXX: only supports a single map for now
+ */
+struct xfs_buf *
+xfs_buf_get_irec(
+	struct xfs_buftarg	*target,
+	struct xfs_bmbt_irec	*map,
+	int			nmaps,
+	xfs_buf_flags_t		flags)
+{
+	xfs_daddr_t		blkno;
+	size_t			numblks;
 	struct xfs_buf		*bp;
 	struct xfs_buf		*new_bp;
 	int			error = 0;
 
+	ASSERT_ALWAYS(nmaps == 1);
+
+	if (map->br_state == XFS_EXT_DADDR) {
+		blkno = map->br_startblock;
+		numblks = map->br_blockcount;
+	} else {
+		blkno = XFS_FSB_TO_DADDR(target->bt_mount, map->br_startblock);
+		numblks = XFS_FSB_TO_BB(target->bt_mount, map->br_blockcount);
+	}
+
 	bp = _xfs_buf_find(target, blkno, numblks, flags, NULL);
 	if (likely(bp))
 		goto found;
@@ -596,37 +646,18 @@ no_buffer:
 	return NULL;
 }
 
-STATIC int
-_xfs_buf_read(
-	xfs_buf_t		*bp,
-	xfs_buf_flags_t		flags)
-{
-	int			status;
-
-	ASSERT(!(flags & (XBF_DELWRI|XBF_WRITE)));
-	ASSERT(bp->b_vec[0].bv_bn != XFS_BUF_DADDR_NULL);
-
-	bp->b_flags &= ~(XBF_WRITE | XBF_ASYNC | XBF_DELWRI | XBF_READ_AHEAD);
-	bp->b_flags |= flags & (XBF_READ | XBF_ASYNC | XBF_READ_AHEAD);
-
-	status = xfs_buf_iorequest(bp);
-	if (status || bp->b_error || (flags & XBF_ASYNC))
-		return status;
-	return xfs_buf_iowait(bp);
-}
-
-xfs_buf_t *
-xfs_buf_read(
-	xfs_buftarg_t		*target,
-	xfs_daddr_t		blkno,
-	size_t			numblks,
+struct xfs_buf *
+xfs_buf_read_irec(
+	struct xfs_buftarg	*target,
+	struct xfs_bmbt_irec	*map,
+	int			nmaps,
 	xfs_buf_flags_t		flags)
 {
 	xfs_buf_t		*bp;
 
 	flags |= XBF_READ;
 
-	bp = xfs_buf_get(target, blkno, numblks, flags);
+	bp = xfs_buf_get_irec(target, map, nmaps, flags);
 	if (bp) {
 		trace_xfs_buf_read(bp, flags, _RET_IP_);
 
@@ -654,96 +685,51 @@ xfs_buf_read(
 	return NULL;
 }
 
-/*
- *	If we are not low on memory then do the readahead in a deadlock
- *	safe manner.
- */
 void
-xfs_buf_readahead(
-	xfs_buftarg_t		*target,
-	xfs_daddr_t		blkno,
-	size_t			numblks)
+xfs_buf_readahead_irec(
+	struct xfs_buftarg	*target,
+	struct xfs_bmbt_irec	*map,
+	int			nmaps)
 {
 	if (bdi_read_congested(target->bt_bdi))
 		return;
 
-	xfs_buf_read(target, blkno, numblks,
+	xfs_buf_read_irec(target, map, nmaps,
 		     XBF_TRYLOCK|XBF_ASYNC|XBF_READ_AHEAD|XBF_DONT_BLOCK);
 }
 
-/*
- * XXX: only supports a single map for now
- */
-struct xfs_buf *
-xfs_buf_get_irec(
-	struct xfs_buftarg	*target,
-	struct xfs_bmbt_irec	*map,
-	int			nmaps,
+xfs_buf_t *
+xfs_buf_read(
+	xfs_buftarg_t		*target,
+	xfs_daddr_t		blkno,
+	size_t			numblks,
 	xfs_buf_flags_t		flags)
 {
-	xfs_daddr_t		blkno;
-	size_t			numblks;
-	struct xfs_buf		*bp;
-
-	ASSERT_ALWAYS(nmaps == 1);
-
-	blkno = XFS_FSB_TO_DADDR(target->bt_mount, map->br_startblock);
-	numblks = XFS_FSB_TO_BB(target->bt_mount, map->br_blockcount);
-
-	bp = xfs_buf_get(target, blkno, numblks, flags);
+	struct xfs_bmbt_irec	map = {
+		.br_startblock = blkno,
+		.br_blockcount = numblks,
+		.br_state = XFS_EXT_DADDR,
+	};
 
-	return bp;
-}
-
-struct xfs_buf *
-xfs_buf_read_irec(
-	struct xfs_buftarg	*target,
-	struct xfs_bmbt_irec	*map,
-	int			nmaps,
-	xfs_buf_flags_t		flags)
-{
-	xfs_buf_t		*bp;
-
-	flags |= XBF_READ;
-
-	bp = xfs_buf_get_irec(target, map, nmaps, flags);
-	if (bp) {
-		trace_xfs_buf_read(bp, flags, _RET_IP_);
-
-		if (!XFS_BUF_ISDONE(bp)) {
-			XFS_STATS_INC(xb_get_read);
-			_xfs_buf_read(bp, flags);
-		} else if (flags & XBF_ASYNC) {
-			/*
-			 * Read ahead call which is already satisfied,
-			 * drop the buffer
-			 */
-			goto no_buffer;
-		} else {
-			/* We do not want read in the flags */
-			bp->b_flags &= ~XBF_READ;
-		}
-	}
-
-	return bp;
-
- no_buffer:
-	if (flags & (XBF_LOCK | XBF_TRYLOCK))
-		xfs_buf_unlock(bp);
-	xfs_buf_rele(bp);
-	return NULL;
+	return xfs_buf_read_irec(target, &map, 1, flags);
 }
 
 void
-xfs_buf_readahead_irec(
-	struct xfs_buftarg	*target,
-	struct xfs_bmbt_irec	*map,
-	int			nmaps)
-{
+xfs_buf_readahead(
+	xfs_buftarg_t		*target,
+	xfs_daddr_t		blkno,
+	size_t			numblks)
+ {
+	struct xfs_bmbt_irec	map = {
+		.br_startblock = blkno,
+		.br_blockcount = numblks,
+		.br_state = XFS_EXT_DADDR,
+	};
+
 	if (bdi_read_congested(target->bt_bdi))
 		return;
 
-	xfs_buf_read_irec(target, map, nmaps,
+	xfs_buf_read_irec(target, &map, 1,
 		     XBF_TRYLOCK|XBF_ASYNC|XBF_READ_AHEAD|XBF_DONT_BLOCK);
 }
 
-- 
1.7.5.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
