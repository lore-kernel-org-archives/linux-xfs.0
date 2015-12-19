Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id C4571809B
	for <xfs@oss.sgi.com>; Sat, 19 Dec 2015 03:01:22 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id B6FB830404E
	for <xfs@oss.sgi.com>; Sat, 19 Dec 2015 01:01:22 -0800 (PST)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id d9PKAEjbHbEhpHYa (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sat, 19 Dec 2015 01:01:18 -0800 (PST)
Subject: [PATCH 44/76] libxfs: adjust refcount of an extent of blocks in
	refcount btree
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Sat, 19 Dec 2015 01:01:12 -0800
Message-ID: <20151219090112.12713.95771.stgit@birch.djwong.org>
In-Reply-To: <20151219085622.12713.88678.stgit@birch.djwong.org>
References: <20151219085622.12713.88678.stgit@birch.djwong.org>
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
Cc: xfs@oss.sgi.com

Provide functions to adjust the reference counts for an extent of
physical blocks stored in the refcount btree.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_refcount.c |  803 ++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_refcount.h |    8 
 2 files changed, 811 insertions(+)


diff --git a/fs/xfs/libxfs/xfs_refcount.c b/fs/xfs/libxfs/xfs_refcount.c
index b3f2c25..dae6453 100644
--- a/fs/xfs/libxfs/xfs_refcount.c
+++ b/fs/xfs/libxfs/xfs_refcount.c
@@ -167,3 +167,806 @@ xfs_refcountbt_delete(
 out_error:
 	return error;
 }
+
+/*
+ * Adjusting the Reference Count
+ *
+ * As stated elsewhere, the reference count btree (refcbt) stores
+ * >1 reference counts for extents of physical blocks.  In this
+ * operation, we're either raising or lowering the reference count of
+ * some subrange stored in the tree:
+ *
+ *      <------ adjustment range ------>
+ * ----+   +---+-----+ +--+--------+---------
+ *  2  |   | 3 |  4  | |17|   55   |   10
+ * ----+   +---+-----+ +--+--------+---------
+ * X axis is physical blocks number;
+ * reference counts are the numbers inside the rectangles
+ *
+ * The first thing we need to do is to ensure that there are no
+ * refcount extents crossing either boundary of the range to be
+ * adjusted.  For any extent that does cross a boundary, split it into
+ * two extents so that we can increment the refcount of one of the
+ * pieces later:
+ *
+ *      <------ adjustment range ------>
+ * ----+   +---+-----+ +--+--------+----+----
+ *  2  |   | 3 |  2  | |17|   55   | 10 | 10
+ * ----+   +---+-----+ +--+--------+----+----
+ *
+ * For this next step, let's assume that all the physical blocks in
+ * the adjustment range are mapped to a file and are therefore in use
+ * at least once.  Therefore, we can infer that any gap in the
+ * refcount tree within the adjustment range represents a physical
+ * extent with refcount == 1:
+ *
+ *      <------ adjustment range ------>
+ * ----+---+---+-----+-+--+--------+----+----
+ *  2  |"1"| 3 |  2  |1|17|   55   | 10 | 10
+ * ----+---+---+-----+-+--+--------+----+----
+ *      ^
+ *
+ * For each extent that falls within the interval range, figure out
+ * which extent is to the left or the right of that extent.  Now we
+ * have a left, current, and right extent.  If the new reference count
+ * of the center extent enables us to merge left, center, and right
+ * into one record covering all three, do so.  If the center extent is
+ * at the left end of the range, abuts the left extent, and its new
+ * reference count matches the left extent's record, then merge them.
+ * If the center extent is at the right end of the range, abuts the
+ * right extent, and the reference counts match, merge those.  In the
+ * example, we can left merge (assuming an increment operation):
+ *
+ *      <------ adjustment range ------>
+ * --------+---+-----+-+--+--------+----+----
+ *    2    | 3 |  2  |1|17|   55   | 10 | 10
+ * --------+---+-----+-+--+--------+----+----
+ *          ^
+ *
+ * For all other extents within the range, adjust the reference count
+ * or delete it if the refcount falls below 2.  If we were
+ * incrementing, the end result looks like this:
+ *
+ *      <------ adjustment range ------>
+ * --------+---+-----+-+--+--------+----+----
+ *    2    | 4 |  3  |2|18|   56   | 11 | 10
+ * --------+---+-----+-+--+--------+----+----
+ *
+ * The result of a decrement operation looks as such:
+ *
+ *      <------ adjustment range ------>
+ * ----+   +---+       +--+--------+----+----
+ *  2  |   | 2 |       |16|   54   |  9 | 10
+ * ----+   +---+       +--+--------+----+----
+ *      DDDD    111111DD
+ *
+ * The blocks marked "D" are freed; the blocks marked "1" are only
+ * referenced once and therefore the record is removed from the
+ * refcount btree.
+ */
+
+#define RCNEXT(rc)	((rc).rc_startblock + (rc).rc_blockcount)
+/*
+ * Split a left rcextent that crosses agbno.
+ */
+STATIC int
+try_split_left_rcextent(
+	struct xfs_btree_cur		*cur,
+	xfs_agblock_t			agbno)
+{
+	struct xfs_refcount_irec	left, tmp;
+	int				found_rec;
+	int				error;
+
+	error = xfs_refcountbt_lookup_le(cur, agbno, &found_rec);
+	if (error)
+		goto out_error;
+	if (!found_rec)
+		return 0;
+
+	error = xfs_refcountbt_get_rec(cur, &left, &found_rec);
+	if (error)
+		goto out_error;
+	XFS_WANT_CORRUPTED_GOTO(cur->bc_mp, found_rec == 1, out_error);
+	if (left.rc_startblock >= agbno || RCNEXT(left) <= agbno)
+		return 0;
+
+	trace_xfs_refcount_split_left_extent(cur->bc_mp, cur->bc_private.a.agno,
+			&left, agbno);
+	tmp = left;
+	tmp.rc_blockcount = agbno - left.rc_startblock;
+	error = xfs_refcountbt_update(cur, &tmp);
+	if (error)
+		goto out_error;
+
+	error = xfs_btree_increment(cur, 0, &found_rec);
+	if (error)
+		goto out_error;
+
+	tmp = left;
+	tmp.rc_startblock = agbno;
+	tmp.rc_blockcount -= (agbno - left.rc_startblock);
+	error = xfs_refcountbt_insert(cur, &tmp, &found_rec);
+	if (error)
+		goto out_error;
+	XFS_WANT_CORRUPTED_GOTO(cur->bc_mp, found_rec == 1, out_error);
+	return error;
+
+out_error:
+	trace_xfs_refcount_split_left_extent_error(cur->bc_mp,
+			cur->bc_private.a.agno, error, _RET_IP_);
+	return error;
+}
+
+/*
+ * Split a right rcextent that crosses agbno.
+ */
+STATIC int
+try_split_right_rcextent(
+	struct xfs_btree_cur	*cur,
+	xfs_agblock_t		agbnext)
+{
+	struct xfs_refcount_irec	right, tmp;
+	int				found_rec;
+	int				error;
+
+	error = xfs_refcountbt_lookup_le(cur, agbnext - 1, &found_rec);
+	if (error)
+		goto out_error;
+	if (!found_rec)
+		return 0;
+
+	error = xfs_refcountbt_get_rec(cur, &right, &found_rec);
+	if (error)
+		goto out_error;
+	XFS_WANT_CORRUPTED_GOTO(cur->bc_mp, found_rec == 1, out_error);
+	if (RCNEXT(right) <= agbnext)
+		return 0;
+
+	trace_xfs_refcount_split_right_extent(cur->bc_mp,
+			cur->bc_private.a.agno, &right, agbnext);
+	tmp = right;
+	tmp.rc_startblock = agbnext;
+	tmp.rc_blockcount -= (agbnext - right.rc_startblock);
+	error = xfs_refcountbt_update(cur, &tmp);
+	if (error)
+		goto out_error;
+
+	tmp = right;
+	tmp.rc_blockcount = agbnext - right.rc_startblock;
+	error = xfs_refcountbt_insert(cur, &tmp, &found_rec);
+	if (error)
+		goto out_error;
+	XFS_WANT_CORRUPTED_GOTO(cur->bc_mp, found_rec == 1, out_error);
+	return error;
+
+out_error:
+	trace_xfs_refcount_split_right_extent_error(cur->bc_mp,
+			cur->bc_private.a.agno, error, _RET_IP_);
+	return error;
+}
+
+/*
+ * Merge the left, center, and right extents.
+ */
+STATIC int
+merge_center(
+	struct xfs_btree_cur		*cur,
+	struct xfs_refcount_irec	*left,
+	struct xfs_refcount_irec	*center,
+	unsigned long long		extlen,
+	xfs_agblock_t			*agbno,
+	xfs_extlen_t			*aglen)
+{
+	int				error;
+	int				found_rec;
+
+	error = xfs_refcountbt_lookup_ge(cur, center->rc_startblock,
+			&found_rec);
+	if (error)
+		goto out_error;
+	XFS_WANT_CORRUPTED_GOTO(cur->bc_mp, found_rec == 1, out_error);
+
+	error = xfs_refcountbt_delete(cur, &found_rec);
+	if (error)
+		goto out_error;
+	XFS_WANT_CORRUPTED_GOTO(cur->bc_mp, found_rec == 1, out_error);
+
+	if (center->rc_refcount > 1) {
+		error = xfs_refcountbt_delete(cur, &found_rec);
+		if (error)
+			goto out_error;
+		XFS_WANT_CORRUPTED_GOTO(cur->bc_mp, found_rec == 1,
+				out_error);
+	}
+
+	error = xfs_refcountbt_lookup_le(cur, left->rc_startblock,
+			&found_rec);
+	if (error)
+		goto out_error;
+	XFS_WANT_CORRUPTED_GOTO(cur->bc_mp, found_rec == 1, out_error);
+
+	left->rc_blockcount = extlen;
+	error = xfs_refcountbt_update(cur, left);
+	if (error)
+		goto out_error;
+
+	*aglen = 0;
+	return error;
+
+out_error:
+	trace_xfs_refcount_merge_center_extents_error(cur->bc_mp,
+			cur->bc_private.a.agno, error, _RET_IP_);
+	return error;
+}
+
+/*
+ * Merge with the left extent.
+ */
+STATIC int
+merge_left(
+	struct xfs_btree_cur		*cur,
+	struct xfs_refcount_irec	*left,
+	struct xfs_refcount_irec	*cleft,
+	xfs_agblock_t			*agbno,
+	xfs_extlen_t			*aglen)
+{
+	int				error;
+	int				found_rec;
+
+	if (cleft->rc_refcount > 1) {
+		error = xfs_refcountbt_lookup_le(cur, cleft->rc_startblock,
+				&found_rec);
+		if (error)
+			goto out_error;
+		XFS_WANT_CORRUPTED_GOTO(cur->bc_mp, found_rec == 1,
+				out_error);
+
+		error = xfs_refcountbt_delete(cur, &found_rec);
+		if (error)
+			goto out_error;
+		XFS_WANT_CORRUPTED_GOTO(cur->bc_mp, found_rec == 1,
+				out_error);
+	}
+
+	error = xfs_refcountbt_lookup_le(cur, left->rc_startblock,
+			&found_rec);
+	if (error)
+		goto out_error;
+	XFS_WANT_CORRUPTED_GOTO(cur->bc_mp, found_rec == 1, out_error);
+
+	left->rc_blockcount += cleft->rc_blockcount;
+	error = xfs_refcountbt_update(cur, left);
+	if (error)
+		goto out_error;
+
+	*agbno += cleft->rc_blockcount;
+	*aglen -= cleft->rc_blockcount;
+	return error;
+
+out_error:
+	trace_xfs_refcount_merge_left_extent_error(cur->bc_mp,
+			cur->bc_private.a.agno, error, _RET_IP_);
+	return error;
+}
+
+/*
+ * Merge with the right extent.
+ */
+STATIC int
+merge_right(
+	struct xfs_btree_cur		*cur,
+	struct xfs_refcount_irec	*right,
+	struct xfs_refcount_irec	*cright,
+	xfs_agblock_t			*agbno,
+	xfs_extlen_t			*aglen)
+{
+	int				error;
+	int				found_rec;
+
+	if (cright->rc_refcount > 1) {
+		error = xfs_refcountbt_lookup_le(cur, cright->rc_startblock,
+			&found_rec);
+		if (error)
+			goto out_error;
+		XFS_WANT_CORRUPTED_GOTO(cur->bc_mp, found_rec == 1,
+				out_error);
+
+		error = xfs_refcountbt_delete(cur, &found_rec);
+		if (error)
+			goto out_error;
+		XFS_WANT_CORRUPTED_GOTO(cur->bc_mp, found_rec == 1,
+				out_error);
+	}
+
+	error = xfs_refcountbt_lookup_le(cur, right->rc_startblock,
+			&found_rec);
+	if (error)
+		goto out_error;
+	XFS_WANT_CORRUPTED_GOTO(cur->bc_mp, found_rec == 1, out_error);
+
+	right->rc_startblock -= cright->rc_blockcount;
+	right->rc_blockcount += cright->rc_blockcount;
+	error = xfs_refcountbt_update(cur, right);
+	if (error)
+		goto out_error;
+
+	*aglen -= cright->rc_blockcount;
+	return error;
+
+out_error:
+	trace_xfs_refcount_merge_right_extent_error(cur->bc_mp,
+			cur->bc_private.a.agno, error, _RET_IP_);
+	return error;
+}
+
+/*
+ * Find the left extent and the one after it (cleft).  This function assumes
+ * that we've already split any extent crossing agbno.
+ */
+STATIC int
+find_left_extent(
+	struct xfs_btree_cur		*cur,
+	struct xfs_refcount_irec	*left,
+	struct xfs_refcount_irec	*cleft,
+	xfs_agblock_t			agbno,
+	xfs_extlen_t			aglen)
+{
+	struct xfs_refcount_irec	tmp;
+	int				error;
+	int				found_rec;
+
+	left->rc_blockcount = cleft->rc_blockcount = 0;
+	error = xfs_refcountbt_lookup_le(cur, agbno - 1, &found_rec);
+	if (error)
+		goto out_error;
+	if (!found_rec)
+		return 0;
+
+	error = xfs_refcountbt_get_rec(cur, &tmp, &found_rec);
+	if (error)
+		goto out_error;
+	XFS_WANT_CORRUPTED_GOTO(cur->bc_mp, found_rec == 1, out_error);
+
+	if (RCNEXT(tmp) != agbno)
+		return 0;
+	/* We have a left extent; retrieve (or invent) the next right one */
+	*left = tmp;
+
+	error = xfs_btree_increment(cur, 0, &found_rec);
+	if (error)
+		goto out_error;
+	if (found_rec) {
+		error = xfs_refcountbt_get_rec(cur, &tmp, &found_rec);
+		if (error)
+			goto out_error;
+		XFS_WANT_CORRUPTED_GOTO(cur->bc_mp, found_rec == 1,
+				out_error);
+
+		/* if tmp starts at the end of our range, just use that */
+		if (tmp.rc_startblock == agbno)
+			*cleft = tmp;
+		else {
+			/*
+			 * There's a gap in the refcntbt at the start of the
+			 * range we're interested in (refcount == 1) so
+			 * create the implied extent and pass it back.
+			 */
+			cleft->rc_startblock = agbno;
+			cleft->rc_blockcount = min(aglen,
+					tmp.rc_startblock - agbno);
+			cleft->rc_refcount = 1;
+		}
+	} else {
+		/*
+		 * No extents, so pretend that there's one covering the whole
+		 * range.
+		 */
+		cleft->rc_startblock = agbno;
+		cleft->rc_blockcount = aglen;
+		cleft->rc_refcount = 1;
+	}
+	trace_xfs_refcount_find_left_extent(cur->bc_mp, cur->bc_private.a.agno,
+			left, cleft, agbno);
+	return error;
+
+out_error:
+	trace_xfs_refcount_find_left_extent_error(cur->bc_mp,
+			cur->bc_private.a.agno, error, _RET_IP_);
+	return error;
+}
+
+/*
+ * Find the right extent and the one before it (cright).  This function
+ * assumes that we've already split any extents crossing agbno + aglen.
+ */
+STATIC int
+find_right_extent(
+	struct xfs_btree_cur		*cur,
+	struct xfs_refcount_irec	*right,
+	struct xfs_refcount_irec	*cright,
+	xfs_agblock_t			agbno,
+	xfs_extlen_t			aglen)
+{
+	struct xfs_refcount_irec	tmp;
+	int				error;
+	int				found_rec;
+
+	right->rc_blockcount = cright->rc_blockcount = 0;
+	error = xfs_refcountbt_lookup_ge(cur, agbno + aglen, &found_rec);
+	if (error)
+		goto out_error;
+	if (!found_rec)
+		return 0;
+
+	error = xfs_refcountbt_get_rec(cur, &tmp, &found_rec);
+	if (error)
+		goto out_error;
+	XFS_WANT_CORRUPTED_GOTO(cur->bc_mp, found_rec == 1, out_error);
+
+	if (tmp.rc_startblock != agbno + aglen)
+		return 0;
+	/* We have a right extent; retrieve (or invent) the next left one */
+	*right = tmp;
+
+	error = xfs_btree_decrement(cur, 0, &found_rec);
+	if (error)
+		goto out_error;
+	if (found_rec) {
+		error = xfs_refcountbt_get_rec(cur, &tmp, &found_rec);
+		if (error)
+			goto out_error;
+		XFS_WANT_CORRUPTED_GOTO(cur->bc_mp, found_rec == 1,
+				out_error);
+
+		/* if tmp ends at the end of our range, just use that */
+		if (RCNEXT(tmp) == agbno + aglen)
+			*cright = tmp;
+		else {
+			/*
+			 * There's a gap in the refcntbt at the end of the
+			 * range we're interested in (refcount == 1) so
+			 * create the implied extent and pass it back.
+			 */
+			cright->rc_startblock = max(agbno, RCNEXT(tmp));
+			cright->rc_blockcount = right->rc_startblock -
+					cright->rc_startblock;
+			cright->rc_refcount = 1;
+		}
+	} else {
+		/*
+		 * No extents, so pretend that there's one covering the whole
+		 * range.
+		 */
+		cright->rc_startblock = agbno;
+		cright->rc_blockcount = aglen;
+		cright->rc_refcount = 1;
+	}
+	trace_xfs_refcount_find_right_extent(cur->bc_mp, cur->bc_private.a.agno,
+			cright, right, agbno + aglen);
+	return error;
+
+out_error:
+	trace_xfs_refcount_find_right_extent_error(cur->bc_mp,
+			cur->bc_private.a.agno, error, _RET_IP_);
+	return error;
+}
+#undef RCNEXT
+
+/*
+ * Try to merge with any extents on the boundaries of the adjustment range.
+ */
+STATIC int
+try_merge_rcextents(
+	struct xfs_btree_cur	*cur,
+	xfs_agblock_t		*agbno,
+	xfs_extlen_t		*aglen,
+	int			adjust)
+{
+	struct xfs_refcount_irec	left = {0}, cleft = {0};
+	struct xfs_refcount_irec	cright = {0}, right = {0};
+	int				error;
+	unsigned long long		ulen;
+	bool				cequal;
+
+	/*
+	 * Find the extent just below agbno [left], just above agbno [cleft],
+	 * just below (agbno + aglen) [cright], and just above (agbno + aglen)
+	 * [right].
+	 */
+	error = find_left_extent(cur, &left, &cleft, *agbno, *aglen);
+	if (error)
+		return error;
+	error = find_right_extent(cur, &right, &cright, *agbno, *aglen);
+	if (error)
+		return error;
+
+	/* No left or right extent to merge; exit. */
+	if (left.rc_blockcount == 0 && right.rc_blockcount == 0)
+		return 0;
+
+	cequal = (cleft.rc_startblock == cright.rc_startblock) &&
+		 (cleft.rc_blockcount == cright.rc_blockcount);
+
+	/* Try to merge left, cleft, and right.  cleft must == cright. */
+	ulen = (unsigned long long)left.rc_blockcount + cleft.rc_blockcount +
+			right.rc_blockcount;
+	if (left.rc_blockcount != 0 && right.rc_blockcount != 0 &&
+	    cleft.rc_blockcount != 0 && cright.rc_blockcount != 0 &&
+	    cequal &&
+	    left.rc_refcount == cleft.rc_refcount + adjust &&
+	    right.rc_refcount == cleft.rc_refcount + adjust &&
+	    ulen < MAXREFCEXTLEN) {
+		trace_xfs_refcount_merge_center_extents(cur->bc_mp,
+			cur->bc_private.a.agno, &left, &cleft, &right);
+		return merge_center(cur, &left, &cleft, ulen, agbno, aglen);
+	}
+
+	/* Try to merge left and cleft. */
+	ulen = (unsigned long long)left.rc_blockcount + cleft.rc_blockcount;
+	if (left.rc_blockcount != 0 && cleft.rc_blockcount != 0 &&
+	    left.rc_refcount == cleft.rc_refcount + adjust &&
+	    ulen < MAXREFCEXTLEN) {
+		trace_xfs_refcount_merge_left_extent(cur->bc_mp,
+			cur->bc_private.a.agno, &left, &cleft);
+		error = merge_left(cur, &left, &cleft, agbno, aglen);
+		if (error)
+			return error;
+
+		/*
+		 * If we just merged left + cleft and cleft == cright,
+		 * we no longer have a cright to merge with right.  We're done.
+		 */
+		if (cequal)
+			return 0;
+	}
+
+	/* Try to merge cright and right. */
+	ulen = (unsigned long long)right.rc_blockcount + cright.rc_blockcount;
+	if (right.rc_blockcount != 0 && cright.rc_blockcount != 0 &&
+	    right.rc_refcount == cright.rc_refcount + adjust &&
+	    ulen < MAXREFCEXTLEN) {
+		trace_xfs_refcount_merge_right_extent(cur->bc_mp,
+			cur->bc_private.a.agno, &cright, &right);
+		return merge_right(cur, &right, &cright, agbno, aglen);
+	}
+
+	return error;
+}
+
+/*
+ * Adjust the refcounts of middle extents.  At this point we should have
+ * split extents that crossed the adjustment range; merged with adjacent
+ * extents; and updated agbno/aglen to reflect the merges.  Therefore,
+ * all we have to do is update the extents inside [agbno, agbno + aglen].
+ */
+STATIC int
+adjust_rcextents(
+	struct xfs_btree_cur	*cur,
+	xfs_agblock_t		agbno,
+	xfs_extlen_t		aglen,
+	int			adj,
+	struct xfs_bmap_free	*flist,
+	struct xfs_owner_info	*oinfo)
+{
+	struct xfs_refcount_irec	ext, tmp;
+	int				error;
+	int				found_rec, found_tmp;
+	xfs_fsblock_t			fsbno;
+
+	error = xfs_refcountbt_lookup_ge(cur, agbno, &found_rec);
+	if (error)
+		goto out_error;
+
+	while (aglen > 0) {
+		error = xfs_refcountbt_get_rec(cur, &ext, &found_rec);
+		if (error)
+			goto out_error;
+		if (!found_rec) {
+			ext.rc_startblock = cur->bc_mp->m_sb.sb_agblocks;
+			ext.rc_blockcount = 0;
+			ext.rc_refcount = 0;
+		}
+
+		/*
+		 * Deal with a hole in the refcount tree; if a file maps to
+		 * these blocks and there's no refcountbt recourd, pretend that
+		 * there is one with refcount == 1.
+		 */
+		if (ext.rc_startblock != agbno) {
+			tmp.rc_startblock = agbno;
+			tmp.rc_blockcount = min(aglen,
+					ext.rc_startblock - agbno);
+			tmp.rc_refcount = 1 + adj;
+			trace_xfs_refcount_modify_extent(cur->bc_mp,
+					cur->bc_private.a.agno, &tmp);
+
+			/*
+			 * Either cover the hole (increment) or
+			 * delete the range (decrement).
+			 */
+			if (tmp.rc_refcount) {
+				error = xfs_refcountbt_insert(cur, &tmp,
+						&found_tmp);
+				if (error)
+					goto out_error;
+				XFS_WANT_CORRUPTED_GOTO(cur->bc_mp,
+						found_tmp == 1, out_error);
+			} else {
+				fsbno = XFS_AGB_TO_FSB(cur->bc_mp,
+						cur->bc_private.a.agno,
+						tmp.rc_startblock);
+				xfs_bmap_add_free(cur->bc_mp, flist, fsbno,
+						tmp.rc_blockcount, oinfo);
+			}
+
+			agbno += tmp.rc_blockcount;
+			aglen -= tmp.rc_blockcount;
+
+			error = xfs_refcountbt_lookup_ge(cur, agbno,
+					&found_rec);
+			if (error)
+				goto out_error;
+		}
+
+		/* Stop if there's nothing left to modify */
+		if (aglen == 0)
+			break;
+
+		/*
+		 * Adjust the reference count and either update the tree
+		 * (incr) or free the blocks (decr).
+		 */
+		ext.rc_refcount += adj;
+		trace_xfs_refcount_modify_extent(cur->bc_mp,
+				cur->bc_private.a.agno, &ext);
+		if (ext.rc_refcount > 1) {
+			error = xfs_refcountbt_update(cur, &ext);
+			if (error)
+				goto out_error;
+		} else if (ext.rc_refcount == 1) {
+			error = xfs_refcountbt_delete(cur, &found_rec);
+			if (error)
+				goto out_error;
+			XFS_WANT_CORRUPTED_GOTO(cur->bc_mp,
+					found_rec == 1, out_error);
+			goto advloop;
+		} else {
+			fsbno = XFS_AGB_TO_FSB(cur->bc_mp,
+					cur->bc_private.a.agno,
+					ext.rc_startblock);
+			xfs_bmap_add_free(cur->bc_mp, flist, fsbno,
+					ext.rc_blockcount, oinfo);
+		}
+
+		error = xfs_btree_increment(cur, 0, &found_rec);
+		if (error)
+			goto out_error;
+
+advloop:
+		agbno += ext.rc_blockcount;
+		aglen -= ext.rc_blockcount;
+	}
+
+	return error;
+out_error:
+	trace_xfs_refcount_modify_extent_error(cur->bc_mp,
+			cur->bc_private.a.agno, error, _RET_IP_);
+	return error;
+}
+
+/*
+ * Adjust the reference count of a range of AG blocks.
+ *
+ * @mp: XFS mount object
+ * @tp: XFS transaction object
+ * @agbp: Buffer containing the AGF
+ * @agno: AG number
+ * @agbno: Start of range to adjust
+ * @aglen: Length of range to adjust
+ * @adj: +1 to increment, -1 to decrement reference count
+ * @flist: freelist (only required if adj == -1)
+ * @owner: owner of the blocks (only required if adj == -1)
+ */
+STATIC int
+xfs_refcountbt_adjust_refcount(
+	struct xfs_mount	*mp,
+	struct xfs_trans	*tp,
+	struct xfs_buf		*agbp,
+	xfs_agnumber_t		agno,
+	xfs_agblock_t		agbno,
+	xfs_extlen_t		aglen,
+	int			adj,
+	struct xfs_bmap_free	*flist,
+	struct xfs_owner_info	*oinfo)
+{
+	struct xfs_btree_cur	*cur;
+	int			error;
+
+	cur = xfs_refcountbt_init_cursor(mp, tp, agbp, agno, flist);
+
+	/*
+	 * Ensure that no rcextents cross the boundary of the adjustment range.
+	 */
+	error = try_split_left_rcextent(cur, agbno);
+	if (error)
+		goto out_error;
+
+	error = try_split_right_rcextent(cur, agbno + aglen);
+	if (error)
+		goto out_error;
+
+	/*
+	 * Try to merge with the left or right extents of the range.
+	 */
+	error = try_merge_rcextents(cur, &agbno, &aglen, adj);
+	if (error)
+		goto out_error;
+
+	/* Now that we've taken care of the ends, adjust the middle extents */
+	error = adjust_rcextents(cur, agbno, aglen, adj, flist, oinfo);
+	if (error)
+		goto out_error;
+
+	xfs_btree_del_cursor(cur, XFS_BTREE_NOERROR);
+	return 0;
+
+out_error:
+	trace_xfs_refcount_adjust_error(mp, agno, error, _RET_IP_);
+	xfs_btree_del_cursor(cur, XFS_BTREE_ERROR);
+	return error;
+}
+
+/**
+ * Increase the reference count of a range of AG blocks.
+ *
+ * @mp: XFS mount object
+ * @tp: XFS transaction object
+ * @agbp: Buffer containing the AGF
+ * @agno: AG number
+ * @agbno: Start of range to adjust
+ * @aglen: Length of range to adjust
+ * @flist: List of blocks to free
+ */
+int
+xfs_refcount_increase(
+	struct xfs_mount	*mp,
+	struct xfs_trans	*tp,
+	struct xfs_buf		*agbp,
+	xfs_agnumber_t		agno,
+	xfs_agblock_t		agbno,
+	xfs_extlen_t		aglen,
+	struct xfs_bmap_free	*flist)
+{
+	trace_xfs_refcount_increase(mp, agno, agbno, aglen);
+	return xfs_refcountbt_adjust_refcount(mp, tp, agbp, agno, agbno,
+			aglen, 1, flist, NULL);
+}
+
+/**
+ * Decrease the reference count of a range of AG blocks.
+ *
+ * @mp: XFS mount object
+ * @tp: XFS transaction object
+ * @agbp: Buffer containing the AGF
+ * @agno: AG number
+ * @agbno: Start of range to adjust
+ * @aglen: Length of range to adjust
+ * @flist: List of blocks to free
+ * @owner: Extent owner
+ */
+int
+xfs_refcount_decrease(
+	struct xfs_mount	*mp,
+	struct xfs_trans	*tp,
+	struct xfs_buf		*agbp,
+	xfs_agnumber_t		agno,
+	xfs_agblock_t		agbno,
+	xfs_extlen_t		aglen,
+	struct xfs_bmap_free	*flist,
+	struct xfs_owner_info	*oinfo)
+{
+	trace_xfs_refcount_decrease(mp, agno, agbno, aglen);
+	return xfs_refcountbt_adjust_refcount(mp, tp, agbp, agno, agbno,
+			aglen, -1, flist, oinfo);
+}
diff --git a/fs/xfs/libxfs/xfs_refcount.h b/fs/xfs/libxfs/xfs_refcount.h
index 033a9b1..6640e3d 100644
--- a/fs/xfs/libxfs/xfs_refcount.h
+++ b/fs/xfs/libxfs/xfs_refcount.h
@@ -26,4 +26,12 @@ extern int xfs_refcountbt_lookup_ge(struct xfs_btree_cur *cur,
 extern int xfs_refcountbt_get_rec(struct xfs_btree_cur *cur,
 		struct xfs_refcount_irec *irec, int *stat);
 
+extern int xfs_refcount_increase(struct xfs_mount *mp, struct xfs_trans *tp,
+		struct xfs_buf *agbp, xfs_agnumber_t agno, xfs_agblock_t agbno,
+		xfs_extlen_t  aglen, struct xfs_bmap_free *flist);
+extern int xfs_refcount_decrease(struct xfs_mount *mp, struct xfs_trans *tp,
+		struct xfs_buf *agbp, xfs_agnumber_t agno, xfs_agblock_t agbno,
+		xfs_extlen_t aglen, struct xfs_bmap_free *flist,
+		struct xfs_owner_info *oinfo);
+
 #endif	/* __XFS_REFCOUNT_H__ */

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
