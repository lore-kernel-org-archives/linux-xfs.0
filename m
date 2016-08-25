Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 5EEB681D2
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 18:50:53 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id D3D58AC003
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:50:52 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id oC0TxiwoRnivQSdx (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:50:49 -0700 (PDT)
Subject: [PATCH 39/71] xfs: use interval query for rmap map and unmap
	operations on shared files
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 25 Aug 2016 16:50:44 -0700
Message-ID: <147216904481.4420.218627288366588607.stgit@birch.djwong.org>
In-Reply-To: <147216879156.4420.2446767701729565218.stgit@birch.djwong.org>
References: <147216879156.4420.2446767701729565218.stgit@birch.djwong.org>
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
Cc: linux-xfs@vger.kernel.org, xfs@oss.sgi.com

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
 include/xfs_trace.h |   14 +
 libxfs/xfs_rmap.c   |  514 +++++++++++++++++++++++++++++++++++++++++++++++++++
 libxfs/xfs_rmap.h   |    7 +
 3 files changed, 532 insertions(+), 3 deletions(-)


diff --git a/include/xfs_trace.h b/include/xfs_trace.h
index b7bf3d0..24b99dd 100644
--- a/include/xfs_trace.h
+++ b/include/xfs_trace.h
@@ -209,7 +209,6 @@
 #define trace_xfs_rmap_defer(...)		((void) 0)
 #define trace_xfs_rmap_deferred(...)		((void) 0)
 #define trace_xfs_rmap_find_right_neighbor_result(...)	((void) 0)
-#define trace_xfs_rmap_find_left_neighbor_result(...)	((void) 0)
 #define trace_xfs_rmap_lookup_le_range_result(...)	((void) 0)
 
 #define trace_xfs_rmapbt_free_block(...)	((void) 0)
@@ -268,6 +267,19 @@
 #define trace_xfs_refcount_cow_increase(...)	((void) 0)
 #define trace_xfs_refcount_cow_decrease(...)	((void) 0)
 
+#define trace_xfs_rmap_find_left_neighbor_candidate(...)	((void) 0)
+#define trace_xfs_rmap_find_left_neighbor_query(...)		((void) 0)
+#define trace_xfs_rmap_find_left_neighbor_result(...)		((void) 0)
+#define trace_xfs_rmap_lookup_le_range_candidate(...)		((void) 0)
+#define trace_xfs_rmap_lookup_le_range(...)	((void) 0)
+#define trace_xfs_rmap_unmap(...)		((void) 0)
+#define trace_xfs_rmap_unmap_done(...)		((void) 0)
+#define trace_xfs_rmap_unmap_error(...)		((void) 0)
+#define trace_xfs_rmap_map(...)			((void) 0)
+#define trace_xfs_rmap_map_done(...)		((void) 0)
+#define trace_xfs_rmap_map_error(...)		((void) 0)
+#define trace_xfs_rmap_delete_error(...)	((void) 0)
+
 /* set c = c to avoid unused var warnings */
 #define trace_xfs_perag_get(a,b,c,d)	((c) = (c))
 #define trace_xfs_perag_get_tag(a,b,c,d) ((c) = (c))
diff --git a/libxfs/xfs_rmap.c b/libxfs/xfs_rmap.c
index 82c2597..17dc7d6 100644
--- a/libxfs/xfs_rmap.c
+++ b/libxfs/xfs_rmap.c
@@ -146,6 +146,37 @@ done:
 	return error;
 }
 
+STATIC int
+xfs_rmap_delete(
+	struct xfs_btree_cur	*rcur,
+	xfs_agblock_t		agbno,
+	xfs_extlen_t		len,
+	uint64_t		owner,
+	uint64_t		offset,
+	unsigned int		flags)
+{
+	int			i;
+	int			error;
+
+	trace_xfs_rmap_delete(rcur->bc_mp, rcur->bc_private.a.agno, agbno,
+			len, owner, offset, flags);
+
+	error = xfs_rmap_lookup_eq(rcur, agbno, len, owner, offset, flags, &i);
+	if (error)
+		goto done;
+	XFS_WANT_CORRUPTED_GOTO(rcur->bc_mp, i == 1, done);
+
+	error = xfs_btree_delete(rcur, &i);
+	if (error)
+		goto done;
+	XFS_WANT_CORRUPTED_GOTO(rcur->bc_mp, i == 1, done);
+done:
+	if (error)
+		trace_xfs_rmap_delete_error(rcur->bc_mp,
+				rcur->bc_private.a.agno, error, _RET_IP_);
+	return error;
+}
+
 static int
 xfs_rmap_btrec_to_irec(
 	union xfs_btree_rec	*rec,
@@ -178,6 +209,160 @@ xfs_rmap_get_rec(
 	return xfs_rmap_btrec_to_irec(rec, irec);
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
+	error = xfs_rmap_query_range(cur, &info.high, &info.high,
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
+	error = xfs_rmap_query_range(cur, &info.high, &info.high,
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
@@ -1096,6 +1281,321 @@ done:
 #undef	RIGHT
 #undef	PREV
 
+/*
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
+		error = xfs_rmap_delete(cur, ltrec.rm_startblock,
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
+		error = xfs_rmap_delete(cur, ltrec.rm_startblock,
+				ltrec.rm_blockcount, ltrec.rm_owner,
+				ltrec.rm_offset, ltrec.rm_flags);
+		if (error)
+			goto out_error;
+
+		/* Add an rmap at the new offset. */
+		ltrec.rm_startblock += len;
+		ltrec.rm_blockcount -= len;
+		ltrec.rm_offset += len;
+		error = xfs_rmap_insert(cur, ltrec.rm_startblock,
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
+		error = xfs_rmap_insert(cur, bno + len,
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
+	    !xfs_rmap_is_mergeable(&ltrec, owner, flags))
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
+		trace_xfs_rmap_find_right_neighbor_result(cur->bc_mp,
+			cur->bc_private.a.agno, gtrec.rm_startblock,
+			gtrec.rm_blockcount, gtrec.rm_owner,
+			gtrec.rm_offset, gtrec.rm_flags);
+
+		if (!xfs_rmap_is_mergeable(&gtrec, owner, flags))
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
+			error = xfs_rmap_delete(cur, gtrec.rm_startblock,
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
+		error = xfs_rmap_delete(cur, gtrec.rm_startblock,
+				gtrec.rm_blockcount, gtrec.rm_owner,
+				gtrec.rm_offset, gtrec.rm_flags);
+		if (error)
+			goto out_error;
+
+		/* Move the start and re-add it. */
+		gtrec.rm_startblock = bno;
+		gtrec.rm_blockcount += len;
+		gtrec.rm_offset = offset;
+		error = xfs_rmap_insert(cur, gtrec.rm_startblock,
+				gtrec.rm_blockcount, gtrec.rm_owner,
+				gtrec.rm_offset, gtrec.rm_flags);
+		if (error)
+			goto out_error;
+	} else {
+		/*
+		 * No contiguous edge with identical owner, insert
+		 * new record at current cursor position.
+		 */
+		error = xfs_rmap_insert(cur, bno, len, owner, offset, flags);
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
 struct xfs_rmap_query_range_info {
 	xfs_rmap_query_range_fn	fn;
 	void				*priv;
@@ -1235,11 +1735,19 @@ xfs_rmap_finish_one(
 	case XFS_RMAP_MAP:
 		error = xfs_rmap_map(rcur, bno, blockcount, unwritten, &oinfo);
 		break;
+	case XFS_RMAP_MAP_SHARED:
+		error = xfs_rmap_map_shared(rcur, bno, blockcount, unwritten,
+				&oinfo);
+		break;
 	case XFS_RMAP_FREE:
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
@@ -1313,7 +1821,8 @@ xfs_rmap_map_extent(
 	if (!xfs_rmap_update_is_needed(mp, whichfork))
 		return 0;
 
-	return __xfs_rmap_add(mp, dfops, XFS_RMAP_MAP, ip->i_ino,
+	return __xfs_rmap_add(mp, dfops, xfs_is_reflink_inode(ip) ?
+			XFS_RMAP_MAP_SHARED : XFS_RMAP_MAP, ip->i_ino,
 			whichfork, PREV);
 }
 
@@ -1329,7 +1838,8 @@ xfs_rmap_unmap_extent(
 	if (!xfs_rmap_update_is_needed(mp, whichfork))
 		return 0;
 
-	return __xfs_rmap_add(mp, dfops, XFS_RMAP_UNMAP, ip->i_ino,
+	return __xfs_rmap_add(mp, dfops, xfs_is_reflink_inode(ip) ?
+			XFS_RMAP_UNMAP_SHARED : XFS_RMAP_UNMAP, ip->i_ino,
 			whichfork, PREV);
 }
 
diff --git a/libxfs/xfs_rmap.h b/libxfs/xfs_rmap.h
index 71cf99a..7899305 100644
--- a/libxfs/xfs_rmap.h
+++ b/libxfs/xfs_rmap.h
@@ -206,4 +206,11 @@ int xfs_rmap_finish_one(struct xfs_trans *tp, enum xfs_rmap_intent_type type,
 		xfs_fsblock_t startblock, xfs_filblks_t blockcount,
 		xfs_exntst_t state, struct xfs_btree_cur **pcur);
 
+int xfs_rmap_find_left_neighbor(struct xfs_btree_cur *cur, xfs_agblock_t bno,
+		uint64_t owner, uint64_t offset, unsigned int flags,
+		struct xfs_rmap_irec *irec, int	*stat);
+int xfs_rmap_lookup_le_range(struct xfs_btree_cur *cur, xfs_agblock_t bno,
+		uint64_t owner, uint64_t offset, unsigned int flags,
+		struct xfs_rmap_irec *irec, int	*stat);
+
 #endif	/* __XFS_RMAP_H__ */

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
