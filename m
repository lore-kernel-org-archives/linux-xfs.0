Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q3O6Xpc7031551 for <xfs@oss.sgi.com>; Tue, 24 Apr 2012 01:33:51 -0500
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	ECFmVVJm4QhxmlWx for <xfs@oss.sgi.com>;
	Mon, 23 Apr 2012 23:33:48 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1SMZJo-0004Nb-EQ
	for xfs@oss.sgi.com; Tue, 24 Apr 2012 16:33:44 +1000
Received: from dave by disappointment with local (Exim 4.77)
	(envelope-from <dave@disappointment.disaster>) id 1SMZJo-0005tH-2C
	for xfs@oss.sgi.com; Tue, 24 Apr 2012 16:33:44 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 05/10] xfs: add discontiguous buffer support to transactions
Date: Tue, 24 Apr 2012 16:33:35 +1000
Message-Id: <1335249220-22274-6-git-send-email-david@fromorbit.com>
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

Now that the buffer cache supports discontiguous buffers, add
support to the transaction buffer interface for getting and reading
buffers.

Note that this patch does not convert the buffer item logging to
support discontiguous buffers. That will be done as a separate
commit.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_trans.h     |   50 +++++++++++++++++++++++++++++++----
 fs/xfs/xfs_trans_buf.c |   68 ++++++++++++++++++++++++------------------------
 2 files changed, 79 insertions(+), 39 deletions(-)

diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
index a5d31d5..7a50ad3 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -450,11 +450,51 @@ xfs_trans_t	*xfs_trans_dup(xfs_trans_t *);
 int		xfs_trans_reserve(xfs_trans_t *, uint, uint, uint,
 				  uint, uint);
 void		xfs_trans_mod_sb(xfs_trans_t *, uint, int64_t);
-struct xfs_buf	*xfs_trans_get_buf(xfs_trans_t *, struct xfs_buftarg *, xfs_daddr_t,
-				   int, uint);
-int		xfs_trans_read_buf(struct xfs_mount *, xfs_trans_t *,
-				   struct xfs_buftarg *, xfs_daddr_t, int, uint,
-				   struct xfs_buf **);
+
+struct xfs_buf	*xfs_trans_get_buf_map(struct xfs_trans *tp,
+				       struct xfs_buftarg *target,
+				       struct xfs_buf_map *map, int nmaps,
+				       uint flags);
+
+static inline struct xfs_buf *
+xfs_trans_get_buf(
+	struct xfs_trans	*tp,
+	struct xfs_buftarg	*target,
+	xfs_daddr_t		blkno,
+	int			numblks,
+	uint			flags)
+{
+	struct xfs_buf_map	map = {
+		.bm_bn = blkno,
+		.bm_len = numblks,
+	};
+	return xfs_trans_get_buf_map(tp, target, &map, 1, flags);
+}
+
+int		xfs_trans_read_buf_map(struct xfs_mount *mp,
+				       struct xfs_trans *tp,
+				       struct xfs_buftarg *target,
+				       struct xfs_buf_map *map, int nmaps,
+				       xfs_buf_flags_t flags,
+				       struct xfs_buf **bpp);
+
+static inline int
+xfs_trans_read_buf(
+	struct xfs_mount	*mp,
+	struct xfs_trans	*tp,
+	struct xfs_buftarg	*target,
+	xfs_daddr_t		blkno,
+	int			numblks,
+	xfs_buf_flags_t		flags,
+	struct xfs_buf		**bpp)
+{
+	struct xfs_buf_map	map = {
+		.bm_bn = blkno,
+		.bm_len = numblks,
+	};
+	return xfs_trans_read_buf_map(mp, tp, target, &map, 1, flags, bpp);
+}
+
 struct xfs_buf	*xfs_trans_getsb(xfs_trans_t *, struct xfs_mount *, int);
 
 void		xfs_trans_brelse(xfs_trans_t *, struct xfs_buf *);
diff --git a/fs/xfs/xfs_trans_buf.c b/fs/xfs/xfs_trans_buf.c
index 21c5a5e..6311b99 100644
--- a/fs/xfs/xfs_trans_buf.c
+++ b/fs/xfs/xfs_trans_buf.c
@@ -41,20 +41,26 @@ STATIC struct xfs_buf *
 xfs_trans_buf_item_match(
 	struct xfs_trans	*tp,
 	struct xfs_buftarg	*target,
-	xfs_daddr_t		blkno,
-	int			len)
+	struct xfs_buf_map	*map,
+	int			nmaps)
 {
 	struct xfs_log_item_desc *lidp;
 	struct xfs_buf_log_item	*blip;
+	int			len = 0;
+	int			i;
+
+	for (i = 0; i < nmaps; i++)
+		len += map[i].bm_len;
 
-	len = BBTOB(len);
 	list_for_each_entry(lidp, &tp->t_items, lid_trans) {
 		blip = (struct xfs_buf_log_item *)lidp->lid_item;
 		if (blip->bli_item.li_type == XFS_LI_BUF &&
 		    blip->bli_buf->b_target == target &&
-		    XFS_BUF_ADDR(blip->bli_buf) == blkno &&
-		    BBTOB(blip->bli_buf->b_length) == len)
+		    XFS_BUF_ADDR(blip->bli_buf) == map[0].bm_bn &&
+		    blip->bli_buf->b_length == len) {
+			ASSERT(blip->bli_buf->b_map_count == nmaps);
 			return blip->bli_buf;
+		}
 	}
 
 	return NULL;
@@ -128,21 +134,19 @@ xfs_trans_bjoin(
  * If the transaction pointer is NULL, make this just a normal
  * get_buf() call.
  */
-xfs_buf_t *
-xfs_trans_get_buf(xfs_trans_t	*tp,
-		  xfs_buftarg_t	*target_dev,
-		  xfs_daddr_t	blkno,
-		  int		len,
-		  uint		flags)
+struct xfs_buf *
+xfs_trans_get_buf_map(
+	struct xfs_trans	*tp,
+	struct xfs_buftarg	*target,
+	struct xfs_buf_map	*map,
+	int			nmaps,
+	xfs_buf_flags_t		flags)
 {
 	xfs_buf_t		*bp;
 	xfs_buf_log_item_t	*bip;
 
-	/*
-	 * Default to a normal get_buf() call if the tp is NULL.
-	 */
-	if (tp == NULL)
-		return xfs_buf_get(target_dev, blkno, len, flags);
+	if (!tp)
+		return xfs_buf_get_map(target, map, nmaps, flags);
 
 	/*
 	 * If we find the buffer in the cache with this transaction
@@ -150,7 +154,7 @@ xfs_trans_get_buf(xfs_trans_t	*tp,
 	 * have it locked.  In this case we just increment the lock
 	 * recursion count and return the buffer to the caller.
 	 */
-	bp = xfs_trans_buf_item_match(tp, target_dev, blkno, len);
+	bp = xfs_trans_buf_item_match(tp, target, map, nmaps);
 	if (bp != NULL) {
 		ASSERT(xfs_buf_islocked(bp));
 		if (XFS_FORCED_SHUTDOWN(tp->t_mountp)) {
@@ -167,7 +171,7 @@ xfs_trans_get_buf(xfs_trans_t	*tp,
 		return (bp);
 	}
 
-	bp = xfs_buf_get(target_dev, blkno, len, flags);
+	bp = xfs_buf_get_map(target, map, nmaps, flags);
 	if (bp == NULL) {
 		return NULL;
 	}
@@ -246,26 +250,22 @@ int	xfs_error_mod = 33;
  * read_buf() call.
  */
 int
-xfs_trans_read_buf(
-	xfs_mount_t	*mp,
-	xfs_trans_t	*tp,
-	xfs_buftarg_t	*target,
-	xfs_daddr_t	blkno,
-	int		len,
-	uint		flags,
-	xfs_buf_t	**bpp)
+xfs_trans_read_buf_map(
+	struct xfs_mount	*mp,
+	struct xfs_trans	*tp,
+	struct xfs_buftarg	*target,
+	struct xfs_buf_map	*map,
+	int			nmaps,
+	xfs_buf_flags_t		flags,
+	struct xfs_buf		**bpp)
 {
 	xfs_buf_t		*bp;
 	xfs_buf_log_item_t	*bip;
 	int			error;
 
 	*bpp = NULL;
-
-	/*
-	 * Default to a normal get_buf() call if the tp is NULL.
-	 */
-	if (tp == NULL) {
-		bp = xfs_buf_read(target, blkno, len, flags);
+	if (!tp) {
+		bp = xfs_buf_read_map(target, map, nmaps, flags);
 		if (!bp)
 			return (flags & XBF_TRYLOCK) ?
 					EAGAIN : XFS_ERROR(ENOMEM);
@@ -303,7 +303,7 @@ xfs_trans_read_buf(
 	 * If the buffer is not yet read in, then we read it in, increment
 	 * the lock recursion count, and return it to the caller.
 	 */
-	bp = xfs_trans_buf_item_match(tp, target, blkno, len);
+	bp = xfs_trans_buf_item_match(tp, target, map, nmaps);
 	if (bp != NULL) {
 		ASSERT(xfs_buf_islocked(bp));
 		ASSERT(bp->b_transp == tp);
@@ -349,7 +349,7 @@ xfs_trans_read_buf(
 		return 0;
 	}
 
-	bp = xfs_buf_read(target, blkno, len, flags);
+	bp = xfs_buf_read_map(target, map, nmaps, flags);
 	if (bp == NULL) {
 		*bpp = NULL;
 		return (flags & XBF_TRYLOCK) ?
-- 
1.7.9.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
