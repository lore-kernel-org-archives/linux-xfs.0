Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:48313 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935036AbcI3DHD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Sep 2016 23:07:03 -0400
Subject: [PATCH 13/63] xfs: adjust refcount of an extent of blocks in
 refcount btree
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 29 Sep 2016 20:06:58 -0700
Message-ID: <147520481871.29434.5402547811567251580.stgit@birch.djwong.org>
In-Reply-To: <147520472904.29434.15518629624221621056.stgit@birch.djwong.org>
References: <147520472904.29434.15518629624221621056.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

Provide functions to adjust the reference counts for an extent of
physical blocks stored in the refcount btree.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
v2: Refactor the left/right split code into a single function.  Track
the number of btree shape changes and record updates during a refcount
update so that we can decide if we need to get a fresh transaction to
continue.
---
 fs/xfs/libxfs/xfs_refcount.c |  797 ++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_error.h           |    4 
 2 files changed, 800 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/libxfs/xfs_refcount.c b/fs/xfs/libxfs/xfs_refcount.c
index de13406..36946fc 100644
--- a/fs/xfs/libxfs/xfs_refcount.c
+++ b/fs/xfs/libxfs/xfs_refcount.c
@@ -37,6 +37,12 @@
 #include "xfs_bit.h"
 #include "xfs_refcount.h"
 
+/* Allowable refcount adjustment amounts. */
+enum xfs_refc_adjust_op {
+	XFS_REFCOUNT_ADJUST_INCREASE	= 1,
+	XFS_REFCOUNT_ADJUST_DECREASE	= -1,
+};
+
 /*
  * Look up the first record less than or equal to [bno, len] in the btree
  * given by cur.
@@ -175,3 +181,794 @@ xfs_refcount_delete(
 				cur->bc_private.a.agno, error, _RET_IP_);
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
+ * Split a refcount extent that crosses agbno.
+ */
+STATIC int
+xfs_refcount_split_extent(
+	struct xfs_btree_cur		*cur,
+	xfs_agblock_t			agbno,
+	bool				*shape_changed)
+{
+	struct xfs_refcount_irec	rcext, tmp;
+	int				found_rec;
+	int				error;
+
+	*shape_changed = false;
+	error = xfs_refcount_lookup_le(cur, agbno, &found_rec);
+	if (error)
+		goto out_error;
+	if (!found_rec)
+		return 0;
+
+	error = xfs_refcount_get_rec(cur, &rcext, &found_rec);
+	if (error)
+		goto out_error;
+	XFS_WANT_CORRUPTED_GOTO(cur->bc_mp, found_rec == 1, out_error);
+	if (rcext.rc_startblock == agbno || RCNEXT(rcext) <= agbno)
+		return 0;
+
+	*shape_changed = true;
+	trace_xfs_refcount_split_extent(cur->bc_mp, cur->bc_private.a.agno,
+			&rcext, agbno);
+
+	/* Establish the right extent. */
+	tmp = rcext;
+	tmp.rc_startblock = agbno;
+	tmp.rc_blockcount -= (agbno - rcext.rc_startblock);
+	error = xfs_refcount_update(cur, &tmp);
+	if (error)
+		goto out_error;
+
+	/* Insert the left extent. */
+	tmp = rcext;
+	tmp.rc_blockcount = agbno - rcext.rc_startblock;
+	error = xfs_refcount_insert(cur, &tmp, &found_rec);
+	if (error)
+		goto out_error;
+	XFS_WANT_CORRUPTED_GOTO(cur->bc_mp, found_rec == 1, out_error);
+	return error;
+
+out_error:
+	trace_xfs_refcount_split_extent_error(cur->bc_mp,
+			cur->bc_private.a.agno, error, _RET_IP_);
+	return error;
+}
+
+/*
+ * Merge the left, center, and right extents.
+ */
+STATIC int
+xfs_refcount_merge_center_extents(
+	struct xfs_btree_cur		*cur,
+	struct xfs_refcount_irec	*left,
+	struct xfs_refcount_irec	*center,
+	struct xfs_refcount_irec	*right,
+	unsigned long long		extlen,
+	xfs_agblock_t			*agbno,
+	xfs_extlen_t			*aglen)
+{
+	int				error;
+	int				found_rec;
+
+	trace_xfs_refcount_merge_center_extents(cur->bc_mp,
+			cur->bc_private.a.agno, left, center, right);
+
+	error = xfs_refcount_lookup_ge(cur, center->rc_startblock,
+			&found_rec);
+	if (error)
+		goto out_error;
+	XFS_WANT_CORRUPTED_GOTO(cur->bc_mp, found_rec == 1, out_error);
+
+	error = xfs_refcount_delete(cur, &found_rec);
+	if (error)
+		goto out_error;
+	XFS_WANT_CORRUPTED_GOTO(cur->bc_mp, found_rec == 1, out_error);
+
+	/*
+	 * If the center extent wasn't synthesized, remove it.
+	 * See the comments in _reflink_find_left_extents explaining
+	 * when this is possible.
+	 */
+	if (center->rc_refcount > 1) {
+		error = xfs_refcount_delete(cur, &found_rec);
+		if (error)
+			goto out_error;
+		XFS_WANT_CORRUPTED_GOTO(cur->bc_mp, found_rec == 1,
+				out_error);
+	}
+
+	error = xfs_refcount_lookup_le(cur, left->rc_startblock,
+			&found_rec);
+	if (error)
+		goto out_error;
+	XFS_WANT_CORRUPTED_GOTO(cur->bc_mp, found_rec == 1, out_error);
+
+	left->rc_blockcount = extlen;
+	error = xfs_refcount_update(cur, left);
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
+xfs_refcount_merge_left_extent(
+	struct xfs_btree_cur		*cur,
+	struct xfs_refcount_irec	*left,
+	struct xfs_refcount_irec	*cleft,
+	xfs_agblock_t			*agbno,
+	xfs_extlen_t			*aglen)
+{
+	int				error;
+	int				found_rec;
+
+	trace_xfs_refcount_merge_left_extent(cur->bc_mp,
+			cur->bc_private.a.agno, left, cleft);
+
+	/* If the left extent wasn't synthesized, remove it. */
+	if (cleft->rc_refcount > 1) {
+		error = xfs_refcount_lookup_le(cur, cleft->rc_startblock,
+				&found_rec);
+		if (error)
+			goto out_error;
+		XFS_WANT_CORRUPTED_GOTO(cur->bc_mp, found_rec == 1,
+				out_error);
+
+		error = xfs_refcount_delete(cur, &found_rec);
+		if (error)
+			goto out_error;
+		XFS_WANT_CORRUPTED_GOTO(cur->bc_mp, found_rec == 1,
+				out_error);
+	}
+
+	error = xfs_refcount_lookup_le(cur, left->rc_startblock,
+			&found_rec);
+	if (error)
+		goto out_error;
+	XFS_WANT_CORRUPTED_GOTO(cur->bc_mp, found_rec == 1, out_error);
+
+	left->rc_blockcount += cleft->rc_blockcount;
+	error = xfs_refcount_update(cur, left);
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
+xfs_refcount_merge_right_extent(
+	struct xfs_btree_cur		*cur,
+	struct xfs_refcount_irec	*right,
+	struct xfs_refcount_irec	*cright,
+	xfs_agblock_t			*agbno,
+	xfs_extlen_t			*aglen)
+{
+	int				error;
+	int				found_rec;
+
+	trace_xfs_refcount_merge_right_extent(cur->bc_mp,
+			cur->bc_private.a.agno, cright, right);
+
+	/* If the right extent wasn't synthesized, remove it. */
+	if (cright->rc_refcount > 1) {
+		error = xfs_refcount_lookup_le(cur, cright->rc_startblock,
+			&found_rec);
+		if (error)
+			goto out_error;
+		XFS_WANT_CORRUPTED_GOTO(cur->bc_mp, found_rec == 1,
+				out_error);
+
+		error = xfs_refcount_delete(cur, &found_rec);
+		if (error)
+			goto out_error;
+		XFS_WANT_CORRUPTED_GOTO(cur->bc_mp, found_rec == 1,
+				out_error);
+	}
+
+	error = xfs_refcount_lookup_le(cur, right->rc_startblock,
+			&found_rec);
+	if (error)
+		goto out_error;
+	XFS_WANT_CORRUPTED_GOTO(cur->bc_mp, found_rec == 1, out_error);
+
+	right->rc_startblock -= cright->rc_blockcount;
+	right->rc_blockcount += cright->rc_blockcount;
+	error = xfs_refcount_update(cur, right);
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
+xfs_refcount_find_left_extents(
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
+	left->rc_startblock = cleft->rc_startblock = NULLAGBLOCK;
+	error = xfs_refcount_lookup_le(cur, agbno - 1, &found_rec);
+	if (error)
+		goto out_error;
+	if (!found_rec)
+		return 0;
+
+	error = xfs_refcount_get_rec(cur, &tmp, &found_rec);
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
+		error = xfs_refcount_get_rec(cur, &tmp, &found_rec);
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
+			 * synthesize the implied extent and pass it back.
+			 * We assume here that the agbno/aglen range was
+			 * passed in from a data fork extent mapping and
+			 * therefore is allocated to exactly one owner.
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
+xfs_refcount_find_right_extents(
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
+	right->rc_startblock = cright->rc_startblock = NULLAGBLOCK;
+	error = xfs_refcount_lookup_ge(cur, agbno + aglen, &found_rec);
+	if (error)
+		goto out_error;
+	if (!found_rec)
+		return 0;
+
+	error = xfs_refcount_get_rec(cur, &tmp, &found_rec);
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
+		error = xfs_refcount_get_rec(cur, &tmp, &found_rec);
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
+			 * We assume here that the agbno/aglen range was
+			 * passed in from a data fork extent mapping and
+			 * therefore is allocated to exactly one owner.
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
+#define IS_VALID_RCEXT(ext)	((ext).rc_startblock != NULLAGBLOCK)
+/*
+ * Try to merge with any extents on the boundaries of the adjustment range.
+ */
+STATIC int
+xfs_refcount_merge_extents(
+	struct xfs_btree_cur	*cur,
+	xfs_agblock_t		*agbno,
+	xfs_extlen_t		*aglen,
+	enum xfs_refc_adjust_op adjust,
+	bool			*shape_changed)
+{
+	struct xfs_refcount_irec	left = {0}, cleft = {0};
+	struct xfs_refcount_irec	cright = {0}, right = {0};
+	int				error;
+	unsigned long long		ulen;
+	bool				cequal;
+
+	*shape_changed = false;
+	/*
+	 * Find the extent just below agbno [left], just above agbno [cleft],
+	 * just below (agbno + aglen) [cright], and just above (agbno + aglen)
+	 * [right].
+	 */
+	error = xfs_refcount_find_left_extents(cur, &left, &cleft, *agbno,
+			*aglen);
+	if (error)
+		return error;
+	error = xfs_refcount_find_right_extents(cur, &right, &cright, *agbno,
+			*aglen);
+	if (error)
+		return error;
+
+	/* No left or right extent to merge; exit. */
+	if (!IS_VALID_RCEXT(left) && !IS_VALID_RCEXT(right))
+		return 0;
+
+	cequal = (cleft.rc_startblock == cright.rc_startblock) &&
+		 (cleft.rc_blockcount == cright.rc_blockcount);
+
+	/* Try to merge left, cleft, and right.  cleft must == cright. */
+	ulen = (unsigned long long)left.rc_blockcount + cleft.rc_blockcount +
+			right.rc_blockcount;
+	if (IS_VALID_RCEXT(left) && IS_VALID_RCEXT(right) &&
+	    IS_VALID_RCEXT(cleft) && IS_VALID_RCEXT(cright) && cequal &&
+	    left.rc_refcount == cleft.rc_refcount + adjust &&
+	    right.rc_refcount == cleft.rc_refcount + adjust &&
+	    ulen < MAXREFCEXTLEN) {
+		*shape_changed = true;
+		return xfs_refcount_merge_center_extents(cur, &left, &cleft,
+				&right, ulen, agbno, aglen);
+	}
+
+	/* Try to merge left and cleft. */
+	ulen = (unsigned long long)left.rc_blockcount + cleft.rc_blockcount;
+	if (IS_VALID_RCEXT(left) && IS_VALID_RCEXT(cleft) &&
+	    left.rc_refcount == cleft.rc_refcount + adjust &&
+	    ulen < MAXREFCEXTLEN) {
+		*shape_changed = true;
+		error = xfs_refcount_merge_left_extent(cur, &left, &cleft,
+				agbno, aglen);
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
+	if (IS_VALID_RCEXT(right) && IS_VALID_RCEXT(cright) &&
+	    right.rc_refcount == cright.rc_refcount + adjust &&
+	    ulen < MAXREFCEXTLEN) {
+		*shape_changed = true;
+		return xfs_refcount_merge_right_extent(cur, &right, &cright,
+				agbno, aglen);
+	}
+
+	return error;
+}
+#undef IS_VALID_RCEXT
+
+/*
+ * While we're adjusting the refcounts records of an extent, we have
+ * to keep an eye on the number of extents we're dirtying -- run too
+ * many in a single transaction and we'll exceed the transaction's
+ * reservation and crash the fs.  Each record adds 12 bytes to the
+ * log (plus any key updates) so we'll conservatively assume 24 bytes
+ * per record.  We must also leave space for btree splits on both ends
+ * of the range and space for the CUD and a new CUI.
+ *
+ * XXX: This is a pretty hand-wavy estimate.  The penalty for guessing
+ * true incorrectly is a shutdown FS; the penalty for guessing false
+ * incorrectly is more transaction rolls than might be necessary.
+ * Be conservative here.
+ */
+static bool
+xfs_refcount_still_have_space(
+	struct xfs_btree_cur		*cur)
+{
+	unsigned long			overhead;
+
+	overhead = cur->bc_private.a.priv.refc.shape_changes *
+			xfs_allocfree_log_count(cur->bc_mp, 1);
+	overhead *= cur->bc_mp->m_sb.sb_blocksize;
+
+	/*
+	 * Only allow 2 refcount extent updates per transaction if the
+	 * refcount continue update "error" has been injected.
+	 */
+	if (cur->bc_private.a.priv.refc.nr_ops > 2 &&
+	    XFS_TEST_ERROR(false, cur->bc_mp,
+			XFS_ERRTAG_REFCOUNT_CONTINUE_UPDATE,
+			XFS_RANDOM_REFCOUNT_CONTINUE_UPDATE))
+		return false;
+
+	if (cur->bc_private.a.priv.refc.nr_ops == 0)
+		return true;
+	else if (overhead > cur->bc_tp->t_log_res)
+		return false;
+	return  cur->bc_tp->t_log_res - overhead >
+		cur->bc_private.a.priv.refc.nr_ops * 32;
+}
+
+/*
+ * Adjust the refcounts of middle extents.  At this point we should have
+ * split extents that crossed the adjustment range; merged with adjacent
+ * extents; and updated agbno/aglen to reflect the merges.  Therefore,
+ * all we have to do is update the extents inside [agbno, agbno + aglen].
+ */
+STATIC int
+xfs_refcount_adjust_extents(
+	struct xfs_btree_cur	*cur,
+	xfs_agblock_t		agbno,
+	xfs_extlen_t		aglen,
+	xfs_extlen_t		*adjusted,
+	enum xfs_refc_adjust_op	adj,
+	struct xfs_defer_ops	*dfops,
+	struct xfs_owner_info	*oinfo)
+{
+	struct xfs_refcount_irec	ext, tmp;
+	int				error;
+	int				found_rec, found_tmp;
+	xfs_fsblock_t			fsbno;
+
+	/* Merging did all the work already. */
+	if (aglen == 0)
+		return 0;
+
+	error = xfs_refcount_lookup_ge(cur, agbno, &found_rec);
+	if (error)
+		goto out_error;
+
+	while (aglen > 0 && xfs_refcount_still_have_space(cur)) {
+		error = xfs_refcount_get_rec(cur, &ext, &found_rec);
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
+		 * these blocks and there's no refcountbt record, pretend that
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
+				error = xfs_refcount_insert(cur, &tmp,
+						&found_tmp);
+				if (error)
+					goto out_error;
+				XFS_WANT_CORRUPTED_GOTO(cur->bc_mp,
+						found_tmp == 1, out_error);
+				cur->bc_private.a.priv.refc.nr_ops++;
+			} else {
+				fsbno = XFS_AGB_TO_FSB(cur->bc_mp,
+						cur->bc_private.a.agno,
+						tmp.rc_startblock);
+				xfs_bmap_add_free(cur->bc_mp, dfops, fsbno,
+						tmp.rc_blockcount, oinfo);
+			}
+
+			(*adjusted) += tmp.rc_blockcount;
+			agbno += tmp.rc_blockcount;
+			aglen -= tmp.rc_blockcount;
+
+			error = xfs_refcount_lookup_ge(cur, agbno,
+					&found_rec);
+			if (error)
+				goto out_error;
+		}
+
+		/* Stop if there's nothing left to modify */
+		if (aglen == 0 || !xfs_refcount_still_have_space(cur))
+			break;
+
+		/*
+		 * Adjust the reference count and either update the tree
+		 * (incr) or free the blocks (decr).
+		 */
+		if (ext.rc_refcount == MAXREFCOUNT)
+			goto skip;
+		ext.rc_refcount += adj;
+		trace_xfs_refcount_modify_extent(cur->bc_mp,
+				cur->bc_private.a.agno, &ext);
+		if (ext.rc_refcount > 1) {
+			error = xfs_refcount_update(cur, &ext);
+			if (error)
+				goto out_error;
+			cur->bc_private.a.priv.refc.nr_ops++;
+		} else if (ext.rc_refcount == 1) {
+			error = xfs_refcount_delete(cur, &found_rec);
+			if (error)
+				goto out_error;
+			XFS_WANT_CORRUPTED_GOTO(cur->bc_mp,
+					found_rec == 1, out_error);
+			cur->bc_private.a.priv.refc.nr_ops++;
+			goto advloop;
+		} else {
+			fsbno = XFS_AGB_TO_FSB(cur->bc_mp,
+					cur->bc_private.a.agno,
+					ext.rc_startblock);
+			xfs_bmap_add_free(cur->bc_mp, dfops, fsbno,
+					ext.rc_blockcount, oinfo);
+		}
+
+skip:
+		error = xfs_btree_increment(cur, 0, &found_rec);
+		if (error)
+			goto out_error;
+
+advloop:
+		(*adjusted) += ext.rc_blockcount;
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
+/* Adjust the reference count of a range of AG blocks. */
+STATIC int
+xfs_refcount_adjust(
+	struct xfs_btree_cur	*cur,
+	xfs_agblock_t		agbno,
+	xfs_extlen_t		aglen,
+	xfs_extlen_t		*adjusted,
+	enum xfs_refc_adjust_op	adj,
+	struct xfs_defer_ops	*dfops,
+	struct xfs_owner_info	*oinfo)
+{
+	xfs_extlen_t		orig_aglen;
+	bool			shape_changed;
+	int			shape_changes = 0;
+	int			error;
+
+	*adjusted = 0;
+	if (adj == XFS_REFCOUNT_ADJUST_INCREASE)
+		trace_xfs_refcount_increase(cur->bc_mp, cur->bc_private.a.agno,
+				agbno, aglen);
+	else
+		trace_xfs_refcount_decrease(cur->bc_mp, cur->bc_private.a.agno,
+				agbno, aglen);
+
+	/*
+	 * Ensure that no rcextents cross the boundary of the adjustment range.
+	 */
+	error = xfs_refcount_split_extent(cur, agbno, &shape_changed);
+	if (error)
+		goto out_error;
+	if (shape_changed)
+		shape_changes++;
+
+	error = xfs_refcount_split_extent(cur, agbno + aglen, &shape_changed);
+	if (error)
+		goto out_error;
+	if (shape_changed)
+		shape_changes++;
+
+	/*
+	 * Try to merge with the left or right extents of the range.
+	 */
+	orig_aglen = aglen;
+	error = xfs_refcount_merge_extents(cur, &agbno, &aglen, adj,
+			&shape_changed);
+	if (error)
+		goto out_error;
+	if (shape_changed)
+		shape_changes++;
+	(*adjusted) += orig_aglen - aglen;
+	if (shape_changes)
+		cur->bc_private.a.priv.refc.shape_changes++;
+
+	/* Now that we've taken care of the ends, adjust the middle extents */
+	error = xfs_refcount_adjust_extents(cur, agbno, aglen, adjusted, adj,
+			dfops, oinfo);
+	if (error)
+		goto out_error;
+
+	return 0;
+
+out_error:
+	trace_xfs_refcount_adjust_error(cur->bc_mp, cur->bc_private.a.agno,
+			error, _RET_IP_);
+	return error;
+}
diff --git a/fs/xfs/xfs_error.h b/fs/xfs/xfs_error.h
index 3d22470..d9675c64 100644
--- a/fs/xfs/xfs_error.h
+++ b/fs/xfs/xfs_error.h
@@ -92,7 +92,8 @@ extern void xfs_verifier_error(struct xfs_buf *bp);
 #define XFS_ERRTAG_BMAPIFORMAT				21
 #define XFS_ERRTAG_FREE_EXTENT				22
 #define XFS_ERRTAG_RMAP_FINISH_ONE			23
-#define XFS_ERRTAG_MAX					24
+#define XFS_ERRTAG_REFCOUNT_CONTINUE_UPDATE		24
+#define XFS_ERRTAG_MAX					25
 
 /*
  * Random factors for above tags, 1 means always, 2 means 1/2 time, etc.
@@ -121,6 +122,7 @@ extern void xfs_verifier_error(struct xfs_buf *bp);
 #define	XFS_RANDOM_BMAPIFORMAT				XFS_RANDOM_DEFAULT
 #define XFS_RANDOM_FREE_EXTENT				1
 #define XFS_RANDOM_RMAP_FINISH_ONE			1
+#define XFS_RANDOM_REFCOUNT_CONTINUE_UPDATE		1
 
 #ifdef DEBUG
 extern int xfs_error_test_active;

