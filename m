Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:37140 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751576AbdJSHAX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 19 Oct 2017 03:00:23 -0400
Received: from 212095007233.public.telering.at ([212.95.7.233] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1e54oY-0005Tg-Do
        for linux-xfs@vger.kernel.org; Thu, 19 Oct 2017 07:00:23 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 08/15] xfs: inline xfs_shift_file_space into callers
Date: Thu, 19 Oct 2017 08:59:35 +0200
Message-Id: <20171019065942.18813-9-hch@lst.de>
In-Reply-To: <20171019065942.18813-1-hch@lst.de>
References: <20171019065942.18813-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

The code is sufficiently different for the insert vs collapse cases both
in xfs_shift_file_space itself and the callers that untangling them will
make life a lot easier down the road.

We still keep a common helper for flushing all data and COW state to get
the inode into the right shape for shifting the extents around.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_bmap_util.c | 192 ++++++++++++++++++++++++++-----------------------
 1 file changed, 102 insertions(+), 90 deletions(-)

diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 0543423651ff..47b53c88de7c 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -1260,53 +1260,12 @@ xfs_zero_file_space(
 
 }
 
-/*
- * @next_fsb will keep track of the extent currently undergoing shift.
- * @stop_fsb will keep track of the extent at which we have to stop.
- * If we are shifting left, we will start with block (offset + len) and
- * shift each extent till last extent.
- * If we are shifting right, we will start with last extent inside file space
- * and continue until we reach the block corresponding to offset.
- */
 static int
-xfs_shift_file_space(
-	struct xfs_inode        *ip,
-	xfs_off_t               offset,
-	xfs_off_t               len,
-	enum shift_direction	direction)
+xfs_prepare_shift(
+	struct xfs_inode	*ip,
+	loff_t			offset)
 {
-	int			done = 0;
-	struct xfs_mount	*mp = ip->i_mount;
-	struct xfs_trans	*tp;
 	int			error;
-	struct xfs_defer_ops	dfops;
-	xfs_fsblock_t		first_block;
-	xfs_fileoff_t		stop_fsb;
-	xfs_fileoff_t		next_fsb;
-	xfs_fileoff_t		shift_fsb;
-	uint			resblks;
-
-	ASSERT(direction == SHIFT_LEFT || direction == SHIFT_RIGHT);
-
-	if (direction == SHIFT_LEFT) {
-		/*
-		 * Reserve blocks to cover potential extent merges after left
-		 * shift operations.
-		 */
-		resblks = XFS_DIOSTRAT_SPACE_RES(mp, 0);
-		next_fsb = XFS_B_TO_FSB(mp, offset + len);
-		stop_fsb = XFS_B_TO_FSB(mp, VFS_I(ip)->i_size);
-	} else {
-		/*
-		 * If right shift, delegate the work of initialization of
-		 * next_fsb to xfs_bmap_shift_extent as it has ilock held.
-		 */
-		resblks = 0;
-		next_fsb = NULLFSBLOCK;
-		stop_fsb = XFS_B_TO_FSB(mp, offset);
-	}
-
-	shift_fsb = XFS_B_TO_FSB(mp, len);
 
 	/*
 	 * Trim eofblocks to avoid shifting uninitialized post-eof preallocation
@@ -1322,8 +1281,7 @@ xfs_shift_file_space(
 	 * Writeback and invalidate cache for the remainder of the file as we're
 	 * about to shift down every extent from offset to EOF.
 	 */
-	error = filemap_write_and_wait_range(VFS_I(ip)->i_mapping,
-					     offset, -1);
+	error = filemap_write_and_wait_range(VFS_I(ip)->i_mapping, offset, -1);
 	if (error)
 		return error;
 	error = invalidate_inode_pages2_range(VFS_I(ip)->i_mapping,
@@ -1343,16 +1301,48 @@ xfs_shift_file_space(
 			return error;
 	}
 
-	/*
-	 * The extent shifting code works on extent granularity. So, if
-	 * stop_fsb is not the starting block of extent, we need to split
-	 * the extent at stop_fsb.
-	 */
-	if (direction == SHIFT_RIGHT) {
-		error = xfs_bmap_split_extent(ip, stop_fsb);
-		if (error)
-			return error;
-	}
+	return 0;
+}
+
+/*
+ * xfs_collapse_file_space()
+ *	This routine frees disk space and shift extent for the given file.
+ *	The first thing we do is to free data blocks in the specified range
+ *	by calling xfs_free_file_space(). It would also sync dirty data
+ *	and invalidate page cache over the region on which collapse range
+ *	is working. And Shift extent records to the left to cover a hole.
+ * RETURNS:
+ *	0 on success
+ *	errno on error
+ *
+ */
+int
+xfs_collapse_file_space(
+	struct xfs_inode	*ip,
+	xfs_off_t		offset,
+	xfs_off_t		len)
+{
+	int			done = 0;
+	struct xfs_mount	*mp = ip->i_mount;
+	struct xfs_trans	*tp;
+	int			error;
+	struct xfs_defer_ops	dfops;
+	xfs_fsblock_t		first_block;
+	xfs_fileoff_t		stop_fsb = XFS_B_TO_FSB(mp, VFS_I(ip)->i_size);
+	xfs_fileoff_t		next_fsb = XFS_B_TO_FSB(mp, offset + len);
+	xfs_fileoff_t		shift_fsb = XFS_B_TO_FSB(mp, len);
+	uint			resblks = XFS_DIOSTRAT_SPACE_RES(mp, 0);
+
+	ASSERT(xfs_isilocked(ip, XFS_IOLOCK_EXCL));
+	trace_xfs_collapse_file_space(ip);
+
+	error = xfs_free_file_space(ip, offset, len);
+	if (error)
+		return error;
+
+	error = xfs_prepare_shift(ip, offset);
+	if (error)
+		return error;
 
 	while (!error && !done) {
 		error = xfs_trans_alloc(mp, &M_RES(mp)->tr_write, resblks, 0, 0,
@@ -1366,7 +1356,6 @@ xfs_shift_file_space(
 				XFS_QMOPT_RES_REGBLKS);
 		if (error)
 			goto out_trans_cancel;
-
 		xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
 
 		xfs_defer_init(&dfops, &first_block);
@@ -1377,14 +1366,13 @@ xfs_shift_file_space(
 		 */
 		error = xfs_bmap_shift_extents(tp, ip, &next_fsb, shift_fsb,
 				&done, stop_fsb, &first_block, &dfops,
-				direction, XFS_BMAP_MAX_SHIFT_EXTENTS);
+				SHIFT_LEFT, XFS_BMAP_MAX_SHIFT_EXTENTS);
 		if (error)
 			goto out_bmap_cancel;
 
 		error = xfs_defer_finish(&tp, &dfops);
 		if (error)
 			goto out_bmap_cancel;
-
 		error = xfs_trans_commit(tp);
 	}
 
@@ -1397,36 +1385,6 @@ xfs_shift_file_space(
 	return error;
 }
 
-/*
- * xfs_collapse_file_space()
- *	This routine frees disk space and shift extent for the given file.
- *	The first thing we do is to free data blocks in the specified range
- *	by calling xfs_free_file_space(). It would also sync dirty data
- *	and invalidate page cache over the region on which collapse range
- *	is working. And Shift extent records to the left to cover a hole.
- * RETURNS:
- *	0 on success
- *	errno on error
- *
- */
-int
-xfs_collapse_file_space(
-	struct xfs_inode	*ip,
-	xfs_off_t		offset,
-	xfs_off_t		len)
-{
-	int error;
-
-	ASSERT(xfs_isilocked(ip, XFS_IOLOCK_EXCL));
-	trace_xfs_collapse_file_space(ip);
-
-	error = xfs_free_file_space(ip, offset, len);
-	if (error)
-		return error;
-
-	return xfs_shift_file_space(ip, offset, len, SHIFT_LEFT);
-}
-
 /*
  * xfs_insert_file_space()
  *	This routine create hole space by shifting extents for the given file.
@@ -1445,10 +1403,64 @@ xfs_insert_file_space(
 	loff_t			offset,
 	loff_t			len)
 {
+	struct xfs_mount	*mp = ip->i_mount;
+	struct xfs_trans	*tp;
+	int			error;
+	struct xfs_defer_ops	dfops;
+	xfs_fsblock_t		first_block;
+	xfs_fileoff_t		stop_fsb = XFS_B_TO_FSB(mp, offset);
+	xfs_fileoff_t		next_fsb = NULLFSBLOCK;
+	xfs_fileoff_t		shift_fsb = XFS_B_TO_FSB(mp, len);
+	int			done = 0;
+
 	ASSERT(xfs_isilocked(ip, XFS_IOLOCK_EXCL));
 	trace_xfs_insert_file_space(ip);
 
-	return xfs_shift_file_space(ip, offset, len, SHIFT_RIGHT);
+	error = xfs_prepare_shift(ip, offset);
+	if (error)
+		return error;
+
+	/*
+	 * The extent shifting code works on extent granularity. So, if stop_fsb
+	 * is not the starting block of extent, we need to split the extent at
+	 * stop_fsb.
+	 */
+	error = xfs_bmap_split_extent(ip, stop_fsb);
+	if (error)
+		return error;
+
+	while (!error && !done) {
+		error = xfs_trans_alloc(mp, &M_RES(mp)->tr_write, 0, 0, 0,
+					&tp);
+		if (error)
+			break;
+
+		xfs_ilock(ip, XFS_ILOCK_EXCL);
+		xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
+		xfs_defer_init(&dfops, &first_block);
+
+		/*
+		 * We are using the write transaction in which max 2 bmbt
+		 * updates are allowed
+		 */
+		error = xfs_bmap_shift_extents(tp, ip, &next_fsb, shift_fsb,
+				&done, stop_fsb, &first_block, &dfops,
+				SHIFT_RIGHT, XFS_BMAP_MAX_SHIFT_EXTENTS);
+		if (error)
+			goto out_bmap_cancel;
+
+		error = xfs_defer_finish(&tp, &dfops);
+		if (error)
+			goto out_bmap_cancel;
+		error = xfs_trans_commit(tp);
+	}
+
+	return error;
+
+out_bmap_cancel:
+	xfs_defer_cancel(&dfops);
+	xfs_trans_cancel(tp);
+	return error;
 }
 
 /*
-- 
2.14.1

