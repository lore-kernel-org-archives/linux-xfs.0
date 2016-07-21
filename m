Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 641417D46
	for <xfs@oss.sgi.com>; Thu, 21 Jul 2016 00:00:11 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 33893304043
	for <xfs@oss.sgi.com>; Wed, 20 Jul 2016 22:00:11 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id YVVfDhn1h4BqA6gK (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 20 Jul 2016 22:00:08 -0700 (PDT)
Subject: [PATCH 36/47] xfs: convert unwritten status of reverse mappings
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Wed, 20 Jul 2016 22:00:02 -0700
Message-ID: <146907720267.25461.12865808398854547794.stgit@birch.djwong.org>
In-Reply-To: <146907695530.25461.3225785294902719773.stgit@birch.djwong.org>
References: <146907695530.25461.3225785294902719773.stgit@birch.djwong.org>
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
Cc: linux-fsdevel@vger.kernel.org, vishal.l.verma@intel.com, bfoster@redhat.com, xfs@oss.sgi.com

Provide a function to convert an unwritten extent to a real one and
vice versa.

v2: Move unwritten bit to rm_offset.

v3: Fix a bug where we touched the wrong btree_irec field due to a
stupid cut-and-paste error.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_rmap.c |  441 ++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_trace.h       |    5 +
 2 files changed, 446 insertions(+)


diff --git a/fs/xfs/libxfs/xfs_rmap.c b/fs/xfs/libxfs/xfs_rmap.c
index 1e48a0b..7439272 100644
--- a/fs/xfs/libxfs/xfs_rmap.c
+++ b/fs/xfs/libxfs/xfs_rmap.c
@@ -610,6 +610,447 @@ out_error:
 	return error;
 }
 
+#define RMAP_LEFT_CONTIG	(1 << 0)
+#define RMAP_RIGHT_CONTIG	(1 << 1)
+#define RMAP_LEFT_FILLING	(1 << 2)
+#define RMAP_RIGHT_FILLING	(1 << 3)
+#define RMAP_LEFT_VALID		(1 << 6)
+#define RMAP_RIGHT_VALID	(1 << 7)
+
+#define LEFT		r[0]
+#define RIGHT		r[1]
+#define PREV		r[2]
+#define NEW		r[3]
+
+/*
+ * Convert an unwritten extent to a real extent or vice versa.
+ * Does not handle overlapping extents.
+ */
+STATIC int
+xfs_rmap_convert(
+	struct xfs_btree_cur	*cur,
+	xfs_agblock_t		bno,
+	xfs_extlen_t		len,
+	bool			unwritten,
+	struct xfs_owner_info	*oinfo)
+{
+	struct xfs_mount	*mp = cur->bc_mp;
+	struct xfs_rmap_irec	r[4];	/* neighbor extent entries */
+					/* left is 0, right is 1, prev is 2 */
+					/* new is 3 */
+	uint64_t		owner;
+	uint64_t		offset;
+	uint64_t		new_endoff;
+	unsigned int		oldext;
+	unsigned int		newext;
+	unsigned int		flags = 0;
+	int			i;
+	int			state = 0;
+	int			error;
+
+	xfs_owner_info_unpack(oinfo, &owner, &offset, &flags);
+	ASSERT(!(XFS_RMAP_NON_INODE_OWNER(owner) ||
+			(flags & (XFS_RMAP_ATTR_FORK | XFS_RMAP_BMBT_BLOCK))));
+	oldext = unwritten ? XFS_RMAP_UNWRITTEN : 0;
+	new_endoff = offset + len;
+	trace_xfs_rmap_convert(mp, cur->bc_private.a.agno, bno, len,
+			unwritten, oinfo);
+
+	/*
+	 * For the initial lookup, look for an exact match or the left-adjacent
+	 * record for our insertion point. This will also give us the record for
+	 * start block contiguity tests.
+	 */
+	error = xfs_rmap_lookup_le(cur, bno, len, owner, offset, oldext, &i);
+	if (error)
+		goto done;
+	XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
+
+	error = xfs_rmap_get_rec(cur, &PREV, &i);
+	if (error)
+		goto done;
+	XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
+	trace_xfs_rmap_lookup_le_range_result(cur->bc_mp,
+			cur->bc_private.a.agno, PREV.rm_startblock,
+			PREV.rm_blockcount, PREV.rm_owner,
+			PREV.rm_offset, PREV.rm_flags);
+
+	ASSERT(PREV.rm_offset <= offset);
+	ASSERT(PREV.rm_offset + PREV.rm_blockcount >= new_endoff);
+	ASSERT((PREV.rm_flags & XFS_RMAP_UNWRITTEN) == oldext);
+	newext = ~oldext & XFS_RMAP_UNWRITTEN;
+
+	/*
+	 * Set flags determining what part of the previous oldext allocation
+	 * extent is being replaced by a newext allocation.
+	 */
+	if (PREV.rm_offset == offset)
+		state |= RMAP_LEFT_FILLING;
+	if (PREV.rm_offset + PREV.rm_blockcount == new_endoff)
+		state |= RMAP_RIGHT_FILLING;
+
+	/*
+	 * Decrement the cursor to see if we have a left-adjacent record to our
+	 * insertion point. This will give us the record for end block
+	 * contiguity tests.
+	 */
+	error = xfs_btree_decrement(cur, 0, &i);
+	if (error)
+		goto done;
+	if (i) {
+		state |= RMAP_LEFT_VALID;
+		error = xfs_rmap_get_rec(cur, &LEFT, &i);
+		if (error)
+			goto done;
+		XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
+		XFS_WANT_CORRUPTED_GOTO(mp,
+				LEFT.rm_startblock + LEFT.rm_blockcount <= bno,
+				done);
+		trace_xfs_rmap_find_left_neighbor_result(cur->bc_mp,
+				cur->bc_private.a.agno, LEFT.rm_startblock,
+				LEFT.rm_blockcount, LEFT.rm_owner,
+				LEFT.rm_offset, LEFT.rm_flags);
+		if (LEFT.rm_startblock + LEFT.rm_blockcount == bno &&
+		    LEFT.rm_offset + LEFT.rm_blockcount == offset &&
+		    xfs_rmap_is_mergeable(&LEFT, owner, newext))
+			state |= RMAP_LEFT_CONTIG;
+	}
+
+	/*
+	 * Increment the cursor to see if we have a right-adjacent record to our
+	 * insertion point. This will give us the record for end block
+	 * contiguity tests.
+	 */
+	error = xfs_btree_increment(cur, 0, &i);
+	if (error)
+		goto done;
+	XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
+	error = xfs_btree_increment(cur, 0, &i);
+	if (error)
+		goto done;
+	if (i) {
+		state |= RMAP_RIGHT_VALID;
+		error = xfs_rmap_get_rec(cur, &RIGHT, &i);
+		if (error)
+			goto done;
+		XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
+		XFS_WANT_CORRUPTED_GOTO(mp, bno + len <= RIGHT.rm_startblock,
+					done);
+		trace_xfs_rmap_find_right_neighbor_result(cur->bc_mp,
+				cur->bc_private.a.agno, RIGHT.rm_startblock,
+				RIGHT.rm_blockcount, RIGHT.rm_owner,
+				RIGHT.rm_offset, RIGHT.rm_flags);
+		if (bno + len == RIGHT.rm_startblock &&
+		    offset + len == RIGHT.rm_offset &&
+		    xfs_rmap_is_mergeable(&RIGHT, owner, newext))
+			state |= RMAP_RIGHT_CONTIG;
+	}
+
+	/* check that left + prev + right is not too long */
+	if ((state & (RMAP_LEFT_FILLING | RMAP_LEFT_CONTIG |
+			 RMAP_RIGHT_FILLING | RMAP_RIGHT_CONTIG)) ==
+	    (RMAP_LEFT_FILLING | RMAP_LEFT_CONTIG |
+	     RMAP_RIGHT_FILLING | RMAP_RIGHT_CONTIG) &&
+	    (unsigned long)LEFT.rm_blockcount + len +
+	     RIGHT.rm_blockcount > XFS_RMAP_LEN_MAX)
+		state &= ~RMAP_RIGHT_CONTIG;
+
+	trace_xfs_rmap_convert_state(mp, cur->bc_private.a.agno, state,
+			_RET_IP_);
+
+	/* reset the cursor back to PREV */
+	error = xfs_rmap_lookup_le(cur, bno, len, owner, offset, oldext, &i);
+	if (error)
+		goto done;
+	XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
+
+	/*
+	 * Switch out based on the FILLING and CONTIG state bits.
+	 */
+	switch (state & (RMAP_LEFT_FILLING | RMAP_LEFT_CONTIG |
+			 RMAP_RIGHT_FILLING | RMAP_RIGHT_CONTIG)) {
+	case RMAP_LEFT_FILLING | RMAP_LEFT_CONTIG |
+	     RMAP_RIGHT_FILLING | RMAP_RIGHT_CONTIG:
+		/*
+		 * Setting all of a previous oldext extent to newext.
+		 * The left and right neighbors are both contiguous with new.
+		 */
+		error = xfs_btree_increment(cur, 0, &i);
+		if (error)
+			goto done;
+		XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
+		trace_xfs_rmap_delete(mp, cur->bc_private.a.agno,
+				RIGHT.rm_startblock, RIGHT.rm_blockcount,
+				RIGHT.rm_owner, RIGHT.rm_offset,
+				RIGHT.rm_flags);
+		error = xfs_btree_delete(cur, &i);
+		if (error)
+			goto done;
+		XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
+		error = xfs_btree_decrement(cur, 0, &i);
+		if (error)
+			goto done;
+		XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
+		trace_xfs_rmap_delete(mp, cur->bc_private.a.agno,
+				PREV.rm_startblock, PREV.rm_blockcount,
+				PREV.rm_owner, PREV.rm_offset,
+				PREV.rm_flags);
+		error = xfs_btree_delete(cur, &i);
+		if (error)
+			goto done;
+		XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
+		error = xfs_btree_decrement(cur, 0, &i);
+		if (error)
+			goto done;
+		XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
+		NEW = LEFT;
+		NEW.rm_blockcount += PREV.rm_blockcount + RIGHT.rm_blockcount;
+		error = xfs_rmap_update(cur, &NEW);
+		if (error)
+			goto done;
+		break;
+
+	case RMAP_LEFT_FILLING | RMAP_RIGHT_FILLING | RMAP_LEFT_CONTIG:
+		/*
+		 * Setting all of a previous oldext extent to newext.
+		 * The left neighbor is contiguous, the right is not.
+		 */
+		trace_xfs_rmap_delete(mp, cur->bc_private.a.agno,
+				PREV.rm_startblock, PREV.rm_blockcount,
+				PREV.rm_owner, PREV.rm_offset,
+				PREV.rm_flags);
+		error = xfs_btree_delete(cur, &i);
+		if (error)
+			goto done;
+		XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
+		error = xfs_btree_decrement(cur, 0, &i);
+		if (error)
+			goto done;
+		XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
+		NEW = LEFT;
+		NEW.rm_blockcount += PREV.rm_blockcount;
+		error = xfs_rmap_update(cur, &NEW);
+		if (error)
+			goto done;
+		break;
+
+	case RMAP_LEFT_FILLING | RMAP_RIGHT_FILLING | RMAP_RIGHT_CONTIG:
+		/*
+		 * Setting all of a previous oldext extent to newext.
+		 * The right neighbor is contiguous, the left is not.
+		 */
+		error = xfs_btree_increment(cur, 0, &i);
+		if (error)
+			goto done;
+		XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
+		trace_xfs_rmap_delete(mp, cur->bc_private.a.agno,
+				RIGHT.rm_startblock, RIGHT.rm_blockcount,
+				RIGHT.rm_owner, RIGHT.rm_offset,
+				RIGHT.rm_flags);
+		error = xfs_btree_delete(cur, &i);
+		if (error)
+			goto done;
+		XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
+		error = xfs_btree_decrement(cur, 0, &i);
+		if (error)
+			goto done;
+		XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
+		NEW = PREV;
+		NEW.rm_blockcount = len + RIGHT.rm_blockcount;
+		NEW.rm_flags = newext;
+		error = xfs_rmap_update(cur, &NEW);
+		if (error)
+			goto done;
+		break;
+
+	case RMAP_LEFT_FILLING | RMAP_RIGHT_FILLING:
+		/*
+		 * Setting all of a previous oldext extent to newext.
+		 * Neither the left nor right neighbors are contiguous with
+		 * the new one.
+		 */
+		NEW = PREV;
+		NEW.rm_flags = newext;
+		error = xfs_rmap_update(cur, &NEW);
+		if (error)
+			goto done;
+		break;
+
+	case RMAP_LEFT_FILLING | RMAP_LEFT_CONTIG:
+		/*
+		 * Setting the first part of a previous oldext extent to newext.
+		 * The left neighbor is contiguous.
+		 */
+		NEW = PREV;
+		NEW.rm_offset += len;
+		NEW.rm_startblock += len;
+		NEW.rm_blockcount -= len;
+		error = xfs_rmap_update(cur, &NEW);
+		if (error)
+			goto done;
+		error = xfs_btree_decrement(cur, 0, &i);
+		if (error)
+			goto done;
+		NEW = LEFT;
+		NEW.rm_blockcount += len;
+		error = xfs_rmap_update(cur, &NEW);
+		if (error)
+			goto done;
+		break;
+
+	case RMAP_LEFT_FILLING:
+		/*
+		 * Setting the first part of a previous oldext extent to newext.
+		 * The left neighbor is not contiguous.
+		 */
+		NEW = PREV;
+		NEW.rm_startblock += len;
+		NEW.rm_offset += len;
+		NEW.rm_blockcount -= len;
+		error = xfs_rmap_update(cur, &NEW);
+		if (error)
+			goto done;
+		NEW.rm_startblock = bno;
+		NEW.rm_owner = owner;
+		NEW.rm_offset = offset;
+		NEW.rm_blockcount = len;
+		NEW.rm_flags = newext;
+		cur->bc_rec.r = NEW;
+		trace_xfs_rmap_insert(mp, cur->bc_private.a.agno, bno,
+				len, owner, offset, newext);
+		error = xfs_btree_insert(cur, &i);
+		if (error)
+			goto done;
+		XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
+		break;
+
+	case RMAP_RIGHT_FILLING | RMAP_RIGHT_CONTIG:
+		/*
+		 * Setting the last part of a previous oldext extent to newext.
+		 * The right neighbor is contiguous with the new allocation.
+		 */
+		NEW = PREV;
+		NEW.rm_blockcount -= len;
+		error = xfs_rmap_update(cur, &NEW);
+		if (error)
+			goto done;
+		error = xfs_btree_increment(cur, 0, &i);
+		if (error)
+			goto done;
+		NEW = RIGHT;
+		NEW.rm_offset = offset;
+		NEW.rm_startblock = bno;
+		NEW.rm_blockcount += len;
+		error = xfs_rmap_update(cur, &NEW);
+		if (error)
+			goto done;
+		break;
+
+	case RMAP_RIGHT_FILLING:
+		/*
+		 * Setting the last part of a previous oldext extent to newext.
+		 * The right neighbor is not contiguous.
+		 */
+		NEW = PREV;
+		NEW.rm_blockcount -= len;
+		error = xfs_rmap_update(cur, &NEW);
+		if (error)
+			goto done;
+		error = xfs_rmap_lookup_eq(cur, bno, len, owner, offset,
+				oldext, &i);
+		if (error)
+			goto done;
+		XFS_WANT_CORRUPTED_GOTO(mp, i == 0, done);
+		NEW.rm_startblock = bno;
+		NEW.rm_owner = owner;
+		NEW.rm_offset = offset;
+		NEW.rm_blockcount = len;
+		NEW.rm_flags = newext;
+		cur->bc_rec.r = NEW;
+		trace_xfs_rmap_insert(mp, cur->bc_private.a.agno, bno,
+				len, owner, offset, newext);
+		error = xfs_btree_insert(cur, &i);
+		if (error)
+			goto done;
+		XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
+		break;
+
+	case 0:
+		/*
+		 * Setting the middle part of a previous oldext extent to
+		 * newext.  Contiguity is impossible here.
+		 * One extent becomes three extents.
+		 */
+		/* new right extent - oldext */
+		NEW.rm_startblock = bno + len;
+		NEW.rm_owner = owner;
+		NEW.rm_offset = new_endoff;
+		NEW.rm_blockcount = PREV.rm_offset + PREV.rm_blockcount -
+				new_endoff;
+		NEW.rm_flags = PREV.rm_flags;
+		error = xfs_rmap_update(cur, &NEW);
+		if (error)
+			goto done;
+		/* new left extent - oldext */
+		NEW = PREV;
+		NEW.rm_blockcount = offset - PREV.rm_offset;
+		cur->bc_rec.r = NEW;
+		trace_xfs_rmap_insert(mp, cur->bc_private.a.agno,
+				NEW.rm_startblock, NEW.rm_blockcount,
+				NEW.rm_owner, NEW.rm_offset,
+				NEW.rm_flags);
+		error = xfs_btree_insert(cur, &i);
+		if (error)
+			goto done;
+		XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
+		/*
+		 * Reset the cursor to the position of the new extent
+		 * we are about to insert as we can't trust it after
+		 * the previous insert.
+		 */
+		error = xfs_rmap_lookup_eq(cur, bno, len, owner, offset,
+				oldext, &i);
+		if (error)
+			goto done;
+		XFS_WANT_CORRUPTED_GOTO(mp, i == 0, done);
+		/* new middle extent - newext */
+		cur->bc_rec.r.rm_flags &= ~XFS_RMAP_UNWRITTEN;
+		cur->bc_rec.r.rm_flags |= newext;
+		trace_xfs_rmap_insert(mp, cur->bc_private.a.agno, bno, len,
+				owner, offset, newext);
+		error = xfs_btree_insert(cur, &i);
+		if (error)
+			goto done;
+		XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
+		break;
+
+	case RMAP_LEFT_FILLING | RMAP_LEFT_CONTIG | RMAP_RIGHT_CONTIG:
+	case RMAP_RIGHT_FILLING | RMAP_LEFT_CONTIG | RMAP_RIGHT_CONTIG:
+	case RMAP_LEFT_FILLING | RMAP_RIGHT_CONTIG:
+	case RMAP_RIGHT_FILLING | RMAP_LEFT_CONTIG:
+	case RMAP_LEFT_CONTIG | RMAP_RIGHT_CONTIG:
+	case RMAP_LEFT_CONTIG:
+	case RMAP_RIGHT_CONTIG:
+		/*
+		 * These cases are all impossible.
+		 */
+		ASSERT(0);
+	}
+
+	trace_xfs_rmap_convert_done(mp, cur->bc_private.a.agno, bno, len,
+			unwritten, oinfo);
+done:
+	if (error)
+		trace_xfs_rmap_convert_error(cur->bc_mp,
+				cur->bc_private.a.agno, error, _RET_IP_);
+	return error;
+}
+
+#undef	NEW
+#undef	LEFT
+#undef	RIGHT
+#undef	PREV
+
 struct xfs_rmap_query_range_info {
 	xfs_rmap_query_range_fn	fn;
 	void				*priv;
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index e099eda..551b7e2 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -2499,6 +2499,10 @@ DEFINE_AG_ERROR_EVENT(xfs_rmap_unmap_error);
 DEFINE_RMAP_EVENT(xfs_rmap_map);
 DEFINE_RMAP_EVENT(xfs_rmap_map_done);
 DEFINE_AG_ERROR_EVENT(xfs_rmap_map_error);
+DEFINE_RMAP_EVENT(xfs_rmap_convert);
+DEFINE_RMAP_EVENT(xfs_rmap_convert_done);
+DEFINE_AG_ERROR_EVENT(xfs_rmap_convert_error);
+DEFINE_AG_ERROR_EVENT(xfs_rmap_convert_state);
 
 DECLARE_EVENT_CLASS(xfs_rmapbt_class,
 	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno,
@@ -2553,6 +2557,7 @@ DEFINE_AG_ERROR_EVENT(xfs_rmap_delete_error);
 DEFINE_AG_ERROR_EVENT(xfs_rmap_update_error);
 DEFINE_RMAPBT_EVENT(xfs_rmap_lookup_le_range_result);
 DEFINE_RMAPBT_EVENT(xfs_rmap_find_right_neighbor_result);
+DEFINE_RMAPBT_EVENT(xfs_rmap_find_left_neighbor_result);
 
 #endif /* _TRACE_XFS_H */
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
