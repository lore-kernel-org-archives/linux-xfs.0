Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id B58727F83
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 20:29:22 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 679E48F804B
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:29:22 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id JTAi4nqEFTE1mvU4 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:29:18 -0700 (PDT)
Subject: [PATCH 105/119] xfs: use interval query for rmap alloc operations
	on shared files
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 16 Jun 2016 18:29:13 -0700
Message-ID: <146612695294.12839.18445352357542834698.stgit@birch.djwong.org>
In-Reply-To: <146612627129.12839.3827886950949809165.stgit@birch.djwong.org>
References: <146612627129.12839.3827886950949809165.stgit@birch.djwong.org>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-fsdevel@vger.kernel.org, vishal.l.verma@intel.com, xfs@oss.sgi.com

When it's possible for reverse mappings to overlap (data fork extents
of files on reflink filesystems), use the interval query function to
find the left neighbor of an extent we're trying to add; and be
careful to use the lookup functions to update the neighbors and/or
add new extents.

v2: xfs_rmap_find_left_neighbor() needs to calculate the high key of a
query range correctly.  We can also add a few shortcuts -- there are
no left neighbors of a query at offset zero.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_rmap.c       |  483 ++++++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_rmap_btree.h |    7 +
 fs/xfs/xfs_log_recover.c       |    6 
 fs/xfs/xfs_trace.h             |   14 +
 4 files changed, 507 insertions(+), 3 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_rmap.c b/fs/xfs/libxfs/xfs_rmap.c
index 611107c..a9bd522 100644
--- a/fs/xfs/libxfs/xfs_rmap.c
+++ b/fs/xfs/libxfs/xfs_rmap.c
@@ -211,6 +211,160 @@ xfs_rmap_get_rec(
 	return xfs_rmapbt_btrec_to_irec(rec, irec);
 }
 
+struct xfs_find_left_neighbor_info {
+	struct xfs_rmap_irec	high;
+	struct xfs_rmap_irec	*irec;
+	int			*stat;
+};
+
+/* For each rmap given, figure out if it matches the key we want. */
+STATIC int
+xfs_rmap_find_left_neighbor_helper(
+	struct xfs_btree_cur	*cur,
+	struct xfs_rmap_irec	*rec,
+	void			*priv)
+{
+	struct xfs_find_left_neighbor_info	*info = priv;
+
+	trace_xfs_rmap_find_left_neighbor_candidate(cur->bc_mp,
+			cur->bc_private.a.agno, rec->rm_startblock,
+			rec->rm_blockcount, rec->rm_owner, rec->rm_offset,
+			rec->rm_flags);
+
+	if (rec->rm_owner != info->high.rm_owner)
+		return XFS_BTREE_QUERY_RANGE_CONTINUE;
+	if (!XFS_RMAP_NON_INODE_OWNER(rec->rm_owner) &&
+	    !(rec->rm_flags & XFS_RMAP_BMBT_BLOCK) &&
+	    rec->rm_offset + rec->rm_blockcount - 1 != info->high.rm_offset)
+		return XFS_BTREE_QUERY_RANGE_CONTINUE;
+
+	*info->irec = *rec;
+	*info->stat = 1;
+	return XFS_BTREE_QUERY_RANGE_ABORT;
+}
+
+/*
+ * Find the record to the left of the given extent, being careful only to
+ * return a match with the same owner and adjacent physical and logical
+ * block ranges.
+ */
+int
+xfs_rmap_find_left_neighbor(
+	struct xfs_btree_cur	*cur,
+	xfs_agblock_t		bno,
+	uint64_t		owner,
+	uint64_t		offset,
+	unsigned int		flags,
+	struct xfs_rmap_irec	*irec,
+	int			*stat)
+{
+	struct xfs_find_left_neighbor_info	info;
+	int			error;
+
+	*stat = 0;
+	if (bno == 0)
+		return 0;
+	info.high.rm_startblock = bno - 1;
+	info.high.rm_owner = owner;
+	if (!XFS_RMAP_NON_INODE_OWNER(owner) &&
+	    !(flags & XFS_RMAP_BMBT_BLOCK)) {
+		if (offset == 0)
+			return 0;
+		info.high.rm_offset = offset - 1;
+	} else
+		info.high.rm_offset = 0;
+	info.high.rm_flags = flags;
+	info.high.rm_blockcount = 0;
+	info.irec = irec;
+	info.stat = stat;
+
+	trace_xfs_rmap_find_left_neighbor_query(cur->bc_mp,
+			cur->bc_private.a.agno, bno, 0, owner, offset, flags);
+
+	error = xfs_rmapbt_query_range(cur, &info.high, &info.high,
+			xfs_rmap_find_left_neighbor_helper, &info);
+	if (error == XFS_BTREE_QUERY_RANGE_ABORT)
+		error = 0;
+	if (*stat)
+		trace_xfs_rmap_find_left_neighbor_result(cur->bc_mp,
+				cur->bc_private.a.agno, irec->rm_startblock,
+				irec->rm_blockcount, irec->rm_owner,
+				irec->rm_offset, irec->rm_flags);
+	return error;
+}
+
+/* For each rmap given, figure out if it matches the key we want. */
+STATIC int
+xfs_rmap_lookup_le_range_helper(
+	struct xfs_btree_cur	*cur,
+	struct xfs_rmap_irec	*rec,
+	void			*priv)
+{
+	struct xfs_find_left_neighbor_info	*info = priv;
+
+	trace_xfs_rmap_lookup_le_range_candidate(cur->bc_mp,
+			cur->bc_private.a.agno, rec->rm_startblock,
+			rec->rm_blockcount, rec->rm_owner, rec->rm_offset,
+			rec->rm_flags);
+
+	if (rec->rm_owner != info->high.rm_owner)
+		return XFS_BTREE_QUERY_RANGE_CONTINUE;
+	if (!XFS_RMAP_NON_INODE_OWNER(rec->rm_owner) &&
+	    !(rec->rm_flags & XFS_RMAP_BMBT_BLOCK) &&
+	    (rec->rm_offset > info->high.rm_offset ||
+	     rec->rm_offset + rec->rm_blockcount <= info->high.rm_offset))
+		return XFS_BTREE_QUERY_RANGE_CONTINUE;
+
+	*info->irec = *rec;
+	*info->stat = 1;
+	return XFS_BTREE_QUERY_RANGE_ABORT;
+}
+
+/*
+ * Find the record to the left of the given extent, being careful only to
+ * return a match with the same owner and overlapping physical and logical
+ * block ranges.  This is the overlapping-interval version of
+ * xfs_rmap_lookup_le.
+ */
+int
+xfs_rmap_lookup_le_range(
+	struct xfs_btree_cur	*cur,
+	xfs_agblock_t		bno,
+	uint64_t		owner,
+	uint64_t		offset,
+	unsigned int		flags,
+	struct xfs_rmap_irec	*irec,
+	int			*stat)
+{
+	struct xfs_find_left_neighbor_info	info;
+	int			error;
+
+	info.high.rm_startblock = bno;
+	info.high.rm_owner = owner;
+	if (!XFS_RMAP_NON_INODE_OWNER(owner) && !(flags & XFS_RMAP_BMBT_BLOCK))
+		info.high.rm_offset = offset;
+	else
+		info.high.rm_offset = 0;
+	info.high.rm_flags = flags;
+	info.high.rm_blockcount = 0;
+	*stat = 0;
+	info.irec = irec;
+	info.stat = stat;
+
+	trace_xfs_rmap_lookup_le_range(cur->bc_mp,
+			cur->bc_private.a.agno, bno, 0, owner, offset, flags);
+	error = xfs_rmapbt_query_range(cur, &info.high, &info.high,
+			xfs_rmap_lookup_le_range_helper, &info);
+	if (error == XFS_BTREE_QUERY_RANGE_ABORT)
+		error = 0;
+	if (*stat)
+		trace_xfs_rmap_lookup_le_range_result(cur->bc_mp,
+				cur->bc_private.a.agno, irec->rm_startblock,
+				irec->rm_blockcount, irec->rm_owner,
+				irec->rm_offset, irec->rm_flags);
+	return error;
+}
+
 /*
  * Find the extent in the rmap btree and remove it.
  *
@@ -1159,6 +1313,168 @@ xfs_rmap_unmap(
 }
 
 /*
+ * Find an extent in the rmap btree and unmap it.  For rmap extent types that
+ * can overlap (data fork rmaps on reflink filesystems) we must be careful
+ * that the prev/next records in the btree might belong to another owner.
+ * Therefore we must use delete+insert to alter any of the key fields.
+ *
+ * For every other situation there can only be one owner for a given extent,
+ * so we can call the regular _free function.
+ */
+STATIC int
+xfs_rmap_unmap_shared(
+	struct xfs_btree_cur	*cur,
+	xfs_agblock_t		bno,
+	xfs_extlen_t		len,
+	bool			unwritten,
+	struct xfs_owner_info	*oinfo)
+{
+	struct xfs_mount	*mp = cur->bc_mp;
+	struct xfs_rmap_irec	ltrec;
+	uint64_t		ltoff;
+	int			error = 0;
+	int			i;
+	uint64_t		owner;
+	uint64_t		offset;
+	unsigned int		flags;
+
+	xfs_owner_info_unpack(oinfo, &owner, &offset, &flags);
+	if (unwritten)
+		flags |= XFS_RMAP_UNWRITTEN;
+	trace_xfs_rmap_unmap(mp, cur->bc_private.a.agno, bno, len,
+			unwritten, oinfo);
+
+	/*
+	 * We should always have a left record because there's a static record
+	 * for the AG headers at rm_startblock == 0 created by mkfs/growfs that
+	 * will not ever be removed from the tree.
+	 */
+	error = xfs_rmap_lookup_le_range(cur, bno, owner, offset, flags,
+			&ltrec, &i);
+	if (error)
+		goto out_error;
+	XFS_WANT_CORRUPTED_GOTO(mp, i == 1, out_error);
+	ltoff = ltrec.rm_offset;
+
+	/* Make sure the extent we found covers the entire freeing range. */
+	XFS_WANT_CORRUPTED_GOTO(mp, ltrec.rm_startblock <= bno &&
+		ltrec.rm_startblock + ltrec.rm_blockcount >=
+		bno + len, out_error);
+
+	/* Make sure the owner matches what we expect to find in the tree. */
+	XFS_WANT_CORRUPTED_GOTO(mp, owner == ltrec.rm_owner, out_error);
+
+	/* Make sure the unwritten flag matches. */
+	XFS_WANT_CORRUPTED_GOTO(mp, (flags & XFS_RMAP_UNWRITTEN) ==
+			(ltrec.rm_flags & XFS_RMAP_UNWRITTEN), out_error);
+
+	/* Check the offset. */
+	XFS_WANT_CORRUPTED_GOTO(mp, ltrec.rm_offset <= offset, out_error);
+	XFS_WANT_CORRUPTED_GOTO(mp, offset <= ltoff + ltrec.rm_blockcount,
+			out_error);
+
+	if (ltrec.rm_startblock == bno && ltrec.rm_blockcount == len) {
+		/* Exact match, simply remove the record from rmap tree. */
+		error = xfs_rmapbt_delete(cur, ltrec.rm_startblock,
+				ltrec.rm_blockcount, ltrec.rm_owner,
+				ltrec.rm_offset, ltrec.rm_flags);
+		if (error)
+			goto out_error;
+	} else if (ltrec.rm_startblock == bno) {
+		/*
+		 * Overlap left hand side of extent: move the start, trim the
+		 * length and update the current record.
+		 *
+		 *       ltbno                ltlen
+		 * Orig:    |oooooooooooooooooooo|
+		 * Freeing: |fffffffff|
+		 * Result:            |rrrrrrrrrr|
+		 *         bno       len
+		 */
+
+		/* Delete prev rmap. */
+		error = xfs_rmapbt_delete(cur, ltrec.rm_startblock,
+				ltrec.rm_blockcount, ltrec.rm_owner,
+				ltrec.rm_offset, ltrec.rm_flags);
+		if (error)
+			goto out_error;
+
+		/* Add an rmap at the new offset. */
+		ltrec.rm_startblock += len;
+		ltrec.rm_blockcount -= len;
+		ltrec.rm_offset += len;
+		error = xfs_rmapbt_insert(cur, ltrec.rm_startblock,
+				ltrec.rm_blockcount, ltrec.rm_owner,
+				ltrec.rm_offset, ltrec.rm_flags);
+		if (error)
+			goto out_error;
+	} else if (ltrec.rm_startblock + ltrec.rm_blockcount == bno + len) {
+		/*
+		 * Overlap right hand side of extent: trim the length and
+		 * update the current record.
+		 *
+		 *       ltbno                ltlen
+		 * Orig:    |oooooooooooooooooooo|
+		 * Freeing:            |fffffffff|
+		 * Result:  |rrrrrrrrrr|
+		 *                    bno       len
+		 */
+		error = xfs_rmap_lookup_eq(cur, ltrec.rm_startblock,
+				ltrec.rm_blockcount, ltrec.rm_owner,
+				ltrec.rm_offset, ltrec.rm_flags, &i);
+		if (error)
+			goto out_error;
+		XFS_WANT_CORRUPTED_GOTO(mp, i == 1, out_error);
+		ltrec.rm_blockcount -= len;
+		error = xfs_rmap_update(cur, &ltrec);
+		if (error)
+			goto out_error;
+	} else {
+		/*
+		 * Overlap middle of extent: trim the length of the existing
+		 * record to the length of the new left-extent size, increment
+		 * the insertion position so we can insert a new record
+		 * containing the remaining right-extent space.
+		 *
+		 *       ltbno                ltlen
+		 * Orig:    |oooooooooooooooooooo|
+		 * Freeing:       |fffffffff|
+		 * Result:  |rrrrr|         |rrrr|
+		 *               bno       len
+		 */
+		xfs_extlen_t	orig_len = ltrec.rm_blockcount;
+
+		/* Shrink the left side of the rmap */
+		error = xfs_rmap_lookup_eq(cur, ltrec.rm_startblock,
+				ltrec.rm_blockcount, ltrec.rm_owner,
+				ltrec.rm_offset, ltrec.rm_flags, &i);
+		if (error)
+			goto out_error;
+		XFS_WANT_CORRUPTED_GOTO(mp, i == 1, out_error);
+		ltrec.rm_blockcount = bno - ltrec.rm_startblock;
+		error = xfs_rmap_update(cur, &ltrec);
+		if (error)
+			goto out_error;
+
+		/* Add an rmap at the new offset */
+		error = xfs_rmapbt_insert(cur, bno + len,
+				orig_len - len - ltrec.rm_blockcount,
+				ltrec.rm_owner, offset + len,
+				ltrec.rm_flags);
+		if (error)
+			goto out_error;
+	}
+
+	trace_xfs_rmap_unmap_done(mp, cur->bc_private.a.agno, bno, len,
+			unwritten, oinfo);
+out_error:
+	if (error)
+		trace_xfs_rmap_unmap_error(cur->bc_mp,
+				cur->bc_private.a.agno, error, _RET_IP_);
+	return error;
+}
+
+/*
  * Find an extent in the rmap btree and map it.
  */
 STATIC int
@@ -1172,6 +1488,159 @@ xfs_rmap_map(
 	return __xfs_rmap_alloc(cur, bno, len, unwritten, oinfo);
 }
 
+/*
+ * Find an extent in the rmap btree and map it.  For rmap extent types that
+ * can overlap (data fork rmaps on reflink filesystems) we must be careful
+ * that the prev/next records in the btree might belong to another owner.
+ * Therefore we must use delete+insert to alter any of the key fields.
+ *
+ * For every other situation there can only be one owner for a given extent,
+ * so we can call the regular _alloc function.
+ */
+STATIC int
+xfs_rmap_map_shared(
+	struct xfs_btree_cur	*cur,
+	xfs_agblock_t		bno,
+	xfs_extlen_t		len,
+	bool			unwritten,
+	struct xfs_owner_info	*oinfo)
+{
+	struct xfs_mount	*mp = cur->bc_mp;
+	struct xfs_rmap_irec	ltrec;
+	struct xfs_rmap_irec	gtrec;
+	int			have_gt;
+	int			have_lt;
+	int			error = 0;
+	int			i;
+	uint64_t		owner;
+	uint64_t		offset;
+	unsigned int		flags = 0;
+
+	xfs_owner_info_unpack(oinfo, &owner, &offset, &flags);
+	if (unwritten)
+		flags |= XFS_RMAP_UNWRITTEN;
+	trace_xfs_rmap_map(mp, cur->bc_private.a.agno, bno, len,
+			unwritten, oinfo);
+
+	/* Is there a left record that abuts our range? */
+	error = xfs_rmap_find_left_neighbor(cur, bno, owner, offset, flags,
+			&ltrec, &have_lt);
+	if (error)
+		goto out_error;
+	if (have_lt &&
+	    !xfs_rmap_is_mergeable(&ltrec, owner, offset, len, flags))
+		have_lt = 0;
+
+	/* Is there a right record that abuts our range? */
+	error = xfs_rmap_lookup_eq(cur, bno + len, len, owner, offset + len,
+			flags, &have_gt);
+	if (error)
+		goto out_error;
+	if (have_gt) {
+		error = xfs_rmap_get_rec(cur, &gtrec, &have_gt);
+		if (error)
+			goto out_error;
+		XFS_WANT_CORRUPTED_GOTO(mp, have_gt == 1, out_error);
+		trace_xfs_rmap_map_gtrec(cur->bc_mp,
+			cur->bc_private.a.agno, gtrec.rm_startblock,
+			gtrec.rm_blockcount, gtrec.rm_owner,
+			gtrec.rm_offset, gtrec.rm_flags);
+
+		if (!xfs_rmap_is_mergeable(&gtrec, owner, offset, len, flags))
+			have_gt = 0;
+	}
+
+	if (have_lt &&
+	    ltrec.rm_startblock + ltrec.rm_blockcount == bno &&
+	    ltrec.rm_offset + ltrec.rm_blockcount == offset) {
+		/*
+		 * Left edge contiguous, merge into left record.
+		 *
+		 *       ltbno     ltlen
+		 * orig:   |ooooooooo|
+		 * adding:           |aaaaaaaaa|
+		 * result: |rrrrrrrrrrrrrrrrrrr|
+		 *                  bno       len
+		 */
+		ltrec.rm_blockcount += len;
+		if (have_gt &&
+		    bno + len == gtrec.rm_startblock &&
+		    offset + len == gtrec.rm_offset) {
+			/*
+			 * Right edge also contiguous, delete right record
+			 * and merge into left record.
+			 *
+			 *       ltbno     ltlen    gtbno     gtlen
+			 * orig:   |ooooooooo|         |ooooooooo|
+			 * adding:           |aaaaaaaaa|
+			 * result: |rrrrrrrrrrrrrrrrrrrrrrrrrrrrr|
+			 */
+			ltrec.rm_blockcount += gtrec.rm_blockcount;
+			error = xfs_rmapbt_delete(cur, gtrec.rm_startblock,
+					gtrec.rm_blockcount, gtrec.rm_owner,
+					gtrec.rm_offset, gtrec.rm_flags);
+			if (error)
+				goto out_error;
+		}
+
+		/* Point the cursor back to the left record and update. */
+		error = xfs_rmap_lookup_eq(cur, ltrec.rm_startblock,
+				ltrec.rm_blockcount, ltrec.rm_owner,
+				ltrec.rm_offset, ltrec.rm_flags, &i);
+		if (error)
+			goto out_error;
+		XFS_WANT_CORRUPTED_GOTO(mp, i == 1, out_error);
+
+		error = xfs_rmap_update(cur, &ltrec);
+		if (error)
+			goto out_error;
+	} else if (have_gt &&
+		   bno + len == gtrec.rm_startblock &&
+		   offset + len == gtrec.rm_offset) {
+		/*
+		 * Right edge contiguous, merge into right record.
+		 *
+		 *                 gtbno     gtlen
+		 * Orig:             |ooooooooo|
+		 * adding: |aaaaaaaaa|
+		 * Result: |rrrrrrrrrrrrrrrrrrr|
+		 *        bno       len
+		 */
+		/* Delete the old record. */
+		error = xfs_rmapbt_delete(cur, gtrec.rm_startblock,
+				gtrec.rm_blockcount, gtrec.rm_owner,
+				gtrec.rm_offset, gtrec.rm_flags);
+		if (error)
+			goto out_error;
+
+		/* Move the start and re-add it. */
+		gtrec.rm_startblock = bno;
+		gtrec.rm_blockcount += len;
+		gtrec.rm_offset = offset;
+		error = xfs_rmapbt_insert(cur, gtrec.rm_startblock,
+				gtrec.rm_blockcount, gtrec.rm_owner,
+				gtrec.rm_offset, gtrec.rm_flags);
+		if (error)
+			goto out_error;
+	} else {
+		/*
+		 * No contiguous edge with identical owner, insert
+		 * new record at current cursor position.
+		 */
+		error = xfs_rmapbt_insert(cur, bno, len, owner, offset, flags);
+		if (error)
+			goto out_error;
+	}
+
+	trace_xfs_rmap_map_done(mp, cur->bc_private.a.agno, bno, len,
+			unwritten, oinfo);
+out_error:
+	if (error)
+		trace_xfs_rmap_map_error(cur->bc_mp,
+				cur->bc_private.a.agno, error, _RET_IP_);
+	return error;
+}
+
 struct xfs_rmapbt_query_range_info {
 	xfs_rmapbt_query_range_fn	fn;
 	void				*priv;
@@ -1304,10 +1773,18 @@ xfs_rmap_finish_one(
 	case XFS_RMAP_MAP:
 		error = xfs_rmap_map(rcur, bno, blockcount, unwritten, &oinfo);
 		break;
+	case XFS_RMAP_MAP_SHARED:
+		error = xfs_rmap_map_shared(rcur, bno, blockcount, unwritten,
+				&oinfo);
+		break;
 	case XFS_RMAP_UNMAP:
 		error = xfs_rmap_unmap(rcur, bno, blockcount, unwritten,
 				&oinfo);
 		break;
+	case XFS_RMAP_UNMAP_SHARED:
+		error = xfs_rmap_unmap_shared(rcur, bno, blockcount, unwritten,
+				&oinfo);
+		break;
 	case XFS_RMAP_CONVERT:
 		error = xfs_rmap_convert(rcur, bno, blockcount, !unwritten,
 				&oinfo);
@@ -1375,7 +1852,8 @@ xfs_rmap_map_extent(
 {
 	struct xfs_rmap_intent	ri;
 
-	ri.ri_type = XFS_RMAP_MAP;
+	ri.ri_type = xfs_is_reflink_inode(ip) ? XFS_RMAP_MAP_SHARED :
+			XFS_RMAP_MAP;
 	ri.ri_owner = ip->i_ino;
 	ri.ri_whichfork = whichfork;
 	ri.ri_bmap = *PREV;
@@ -1394,7 +1872,8 @@ xfs_rmap_unmap_extent(
 {
 	struct xfs_rmap_intent	ri;
 
-	ri.ri_type = XFS_RMAP_UNMAP;
+	ri.ri_type = xfs_is_reflink_inode(ip) ? XFS_RMAP_UNMAP_SHARED :
+			XFS_RMAP_UNMAP;
 	ri.ri_owner = ip->i_ino;
 	ri.ri_whichfork = whichfork;
 	ri.ri_bmap = *PREV;
diff --git a/fs/xfs/libxfs/xfs_rmap_btree.h b/fs/xfs/libxfs/xfs_rmap_btree.h
index f398e8b..5baa81f 100644
--- a/fs/xfs/libxfs/xfs_rmap_btree.h
+++ b/fs/xfs/libxfs/xfs_rmap_btree.h
@@ -70,6 +70,13 @@ int xfs_rmapbt_insert(struct xfs_btree_cur *rcur, xfs_agblock_t agbno,
 int xfs_rmap_get_rec(struct xfs_btree_cur *cur, struct xfs_rmap_irec *irec,
 		int *stat);
 
+int xfs_rmap_find_left_neighbor(struct xfs_btree_cur *cur, xfs_agblock_t bno,
+		uint64_t owner, uint64_t offset, unsigned int flags,
+		struct xfs_rmap_irec *irec, int	*stat);
+int xfs_rmap_lookup_le_range(struct xfs_btree_cur *cur, xfs_agblock_t bno,
+		uint64_t owner, uint64_t offset, unsigned int flags,
+		struct xfs_rmap_irec *irec, int	*stat);
+
 /* functions for updating the rmapbt for bmbt blocks and AG btree blocks */
 int xfs_rmap_alloc(struct xfs_trans *tp, struct xfs_buf *agbp,
 		   xfs_agnumber_t agno, xfs_agblock_t bno, xfs_extlen_t len,
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 58a700b..b2d2e0a 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -4774,9 +4774,15 @@ xlog_recover_process_rui(
 		case XFS_RMAP_EXTENT_MAP:
 			type = XFS_RMAP_MAP;
 			break;
+		case XFS_RMAP_EXTENT_MAP_SHARED:
+			type = XFS_RMAP_MAP_SHARED;
+			break;
 		case XFS_RMAP_EXTENT_UNMAP:
 			type = XFS_RMAP_UNMAP;
 			break;
+		case XFS_RMAP_EXTENT_UNMAP_SHARED:
+			type = XFS_RMAP_UNMAP_SHARED;
+			break;
 		case XFS_RMAP_EXTENT_CONVERT:
 			type = XFS_RMAP_CONVERT;
 			break;
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 1d89f8f..d64bab7 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -2509,6 +2509,13 @@ DEFINE_RMAP_EVENT(xfs_rmap_convert_done);
 DEFINE_AG_ERROR_EVENT(xfs_rmap_convert_error);
 DEFINE_AG_ERROR_EVENT(xfs_rmap_convert_state);
 
+DEFINE_RMAP_EVENT(xfs_rmap_unmap);
+DEFINE_RMAP_EVENT(xfs_rmap_unmap_done);
+DEFINE_AG_ERROR_EVENT(xfs_rmap_unmap_error);
+DEFINE_RMAP_EVENT(xfs_rmap_map);
+DEFINE_RMAP_EVENT(xfs_rmap_map_done);
+DEFINE_AG_ERROR_EVENT(xfs_rmap_map_error);
+
 DECLARE_EVENT_CLASS(xfs_rmapbt_class,
 	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno,
 		 xfs_agblock_t agbno, xfs_extlen_t len,
@@ -2560,10 +2567,15 @@ DEFINE_RMAPBT_EVENT(xfs_rmapbt_delete);
 DEFINE_AG_ERROR_EVENT(xfs_rmapbt_insert_error);
 DEFINE_AG_ERROR_EVENT(xfs_rmapbt_delete_error);
 DEFINE_AG_ERROR_EVENT(xfs_rmapbt_update_error);
+
+DEFINE_RMAPBT_EVENT(xfs_rmap_find_left_neighbor_candidate);
+DEFINE_RMAPBT_EVENT(xfs_rmap_find_left_neighbor_result);
+DEFINE_RMAPBT_EVENT(xfs_rmap_find_left_neighbor_query);
+DEFINE_RMAPBT_EVENT(xfs_rmap_lookup_le_range_candidate);
 DEFINE_RMAPBT_EVENT(xfs_rmap_lookup_le_range_result);
+DEFINE_RMAPBT_EVENT(xfs_rmap_lookup_le_range);
 DEFINE_RMAPBT_EVENT(xfs_rmap_map_gtrec);
 DEFINE_RMAPBT_EVENT(xfs_rmap_convert_gtrec);
-DEFINE_RMAPBT_EVENT(xfs_rmap_find_left_neighbor_result);
 
 /* deferred bmbt updates */
 #define DEFINE_BMAP_DEFERRED_EVENT	DEFINE_RMAP_DEFERRED_EVENT

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
