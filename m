Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:43270 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935036AbcI3DLm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Sep 2016 23:11:42 -0400
Subject: [PATCH 55/63] xfs: convert unwritten status of reverse mappings for
 shared files
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 29 Sep 2016 20:11:37 -0700
Message-ID: <147520509794.29434.12442767454067687441.stgit@birch.djwong.org>
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

Provide a function to convert an unwritten extent to a real one and
vice versa when shared extents are possible.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
v2: Move rmap unwritten bit to rm_offset.
---
 fs/xfs/libxfs/xfs_rmap.c |  385 ++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_rmap_item.c   |    3 
 2 files changed, 387 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/libxfs/xfs_rmap.c b/fs/xfs/libxfs/xfs_rmap.c
index bb5e2f8..3a8cc71 100644
--- a/fs/xfs/libxfs/xfs_rmap.c
+++ b/fs/xfs/libxfs/xfs_rmap.c
@@ -1278,6 +1278,384 @@ xfs_rmap_convert(
 	return error;
 }
 
+/*
+ * Convert an unwritten extent to a real extent or vice versa.  If there is no
+ * possibility of overlapping extents, delegate to the simpler convert
+ * function.
+ */
+STATIC int
+xfs_rmap_convert_shared(
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
+	 * For the initial lookup, look for and exact match or the left-adjacent
+	 * record for our insertion point. This will also give us the record for
+	 * start block contiguity tests.
+	 */
+	error = xfs_rmap_lookup_le_range(cur, bno, owner, offset, flags,
+			&PREV, &i);
+	XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
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
+	/* Is there a left record that abuts our range? */
+	error = xfs_rmap_find_left_neighbor(cur, bno, owner, offset, newext,
+			&LEFT, &i);
+	if (error)
+		goto done;
+	if (i) {
+		state |= RMAP_LEFT_VALID;
+		XFS_WANT_CORRUPTED_GOTO(mp,
+				LEFT.rm_startblock + LEFT.rm_blockcount <= bno,
+				done);
+		if (xfs_rmap_is_mergeable(&LEFT, owner, newext))
+			state |= RMAP_LEFT_CONTIG;
+	}
+
+	/* Is there a right record that abuts our range? */
+	error = xfs_rmap_lookup_eq(cur, bno + len, len, owner, offset + len,
+			newext, &i);
+	if (error)
+		goto done;
+	if (i) {
+		state |= RMAP_RIGHT_VALID;
+		error = xfs_rmap_get_rec(cur, &RIGHT, &i);
+		if (error)
+			goto done;
+		XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
+		XFS_WANT_CORRUPTED_GOTO(mp, bno + len <= RIGHT.rm_startblock,
+				done);
+		trace_xfs_rmap_find_right_neighbor_result(cur->bc_mp,
+				cur->bc_private.a.agno, RIGHT.rm_startblock,
+				RIGHT.rm_blockcount, RIGHT.rm_owner,
+				RIGHT.rm_offset, RIGHT.rm_flags);
+		if (xfs_rmap_is_mergeable(&RIGHT, owner, newext))
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
+		error = xfs_rmap_delete(cur, RIGHT.rm_startblock,
+				RIGHT.rm_blockcount, RIGHT.rm_owner,
+				RIGHT.rm_offset, RIGHT.rm_flags);
+		if (error)
+			goto done;
+		error = xfs_rmap_delete(cur, PREV.rm_startblock,
+				PREV.rm_blockcount, PREV.rm_owner,
+				PREV.rm_offset, PREV.rm_flags);
+		if (error)
+			goto done;
+		NEW = LEFT;
+		error = xfs_rmap_lookup_eq(cur, NEW.rm_startblock,
+				NEW.rm_blockcount, NEW.rm_owner,
+				NEW.rm_offset, NEW.rm_flags, &i);
+		if (error)
+			goto done;
+		XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
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
+		error = xfs_rmap_delete(cur, PREV.rm_startblock,
+				PREV.rm_blockcount, PREV.rm_owner,
+				PREV.rm_offset, PREV.rm_flags);
+		if (error)
+			goto done;
+		NEW = LEFT;
+		error = xfs_rmap_lookup_eq(cur, NEW.rm_startblock,
+				NEW.rm_blockcount, NEW.rm_owner,
+				NEW.rm_offset, NEW.rm_flags, &i);
+		if (error)
+			goto done;
+		XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
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
+		error = xfs_rmap_delete(cur, RIGHT.rm_startblock,
+				RIGHT.rm_blockcount, RIGHT.rm_owner,
+				RIGHT.rm_offset, RIGHT.rm_flags);
+		if (error)
+			goto done;
+		NEW = PREV;
+		error = xfs_rmap_lookup_eq(cur, NEW.rm_startblock,
+				NEW.rm_blockcount, NEW.rm_owner,
+				NEW.rm_offset, NEW.rm_flags, &i);
+		if (error)
+			goto done;
+		XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
+		NEW.rm_blockcount += RIGHT.rm_blockcount;
+		NEW.rm_flags = RIGHT.rm_flags;
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
+		error = xfs_rmap_lookup_eq(cur, NEW.rm_startblock,
+				NEW.rm_blockcount, NEW.rm_owner,
+				NEW.rm_offset, NEW.rm_flags, &i);
+		if (error)
+			goto done;
+		XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
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
+		error = xfs_rmap_delete(cur, NEW.rm_startblock,
+				NEW.rm_blockcount, NEW.rm_owner,
+				NEW.rm_offset, NEW.rm_flags);
+		if (error)
+			goto done;
+		NEW.rm_offset += len;
+		NEW.rm_startblock += len;
+		NEW.rm_blockcount -= len;
+		error = xfs_rmap_insert(cur, NEW.rm_startblock,
+				NEW.rm_blockcount, NEW.rm_owner,
+				NEW.rm_offset, NEW.rm_flags);
+		if (error)
+			goto done;
+		NEW = LEFT;
+		error = xfs_rmap_lookup_eq(cur, NEW.rm_startblock,
+				NEW.rm_blockcount, NEW.rm_owner,
+				NEW.rm_offset, NEW.rm_flags, &i);
+		if (error)
+			goto done;
+		XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
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
+		error = xfs_rmap_delete(cur, NEW.rm_startblock,
+				NEW.rm_blockcount, NEW.rm_owner,
+				NEW.rm_offset, NEW.rm_flags);
+		if (error)
+			goto done;
+		NEW.rm_offset += len;
+		NEW.rm_startblock += len;
+		NEW.rm_blockcount -= len;
+		error = xfs_rmap_insert(cur, NEW.rm_startblock,
+				NEW.rm_blockcount, NEW.rm_owner,
+				NEW.rm_offset, NEW.rm_flags);
+		if (error)
+			goto done;
+		error = xfs_rmap_insert(cur, bno, len, owner, offset, newext);
+		if (error)
+			goto done;
+		break;
+
+	case RMAP_RIGHT_FILLING | RMAP_RIGHT_CONTIG:
+		/*
+		 * Setting the last part of a previous oldext extent to newext.
+		 * The right neighbor is contiguous with the new allocation.
+		 */
+		NEW = PREV;
+		error = xfs_rmap_lookup_eq(cur, NEW.rm_startblock,
+				NEW.rm_blockcount, NEW.rm_owner,
+				NEW.rm_offset, NEW.rm_flags, &i);
+		if (error)
+			goto done;
+		XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
+		NEW.rm_blockcount = offset - NEW.rm_offset;
+		error = xfs_rmap_update(cur, &NEW);
+		if (error)
+			goto done;
+		NEW = RIGHT;
+		error = xfs_rmap_delete(cur, NEW.rm_startblock,
+				NEW.rm_blockcount, NEW.rm_owner,
+				NEW.rm_offset, NEW.rm_flags);
+		if (error)
+			goto done;
+		NEW.rm_offset = offset;
+		NEW.rm_startblock = bno;
+		NEW.rm_blockcount += len;
+		error = xfs_rmap_insert(cur, NEW.rm_startblock,
+				NEW.rm_blockcount, NEW.rm_owner,
+				NEW.rm_offset, NEW.rm_flags);
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
+		error = xfs_rmap_lookup_eq(cur, NEW.rm_startblock,
+				NEW.rm_blockcount, NEW.rm_owner,
+				NEW.rm_offset, NEW.rm_flags, &i);
+		if (error)
+			goto done;
+		XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
+		NEW.rm_blockcount -= len;
+		error = xfs_rmap_update(cur, &NEW);
+		if (error)
+			goto done;
+		error = xfs_rmap_insert(cur, bno, len, owner, offset, newext);
+		if (error)
+			goto done;
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
+		error = xfs_rmap_insert(cur, NEW.rm_startblock,
+				NEW.rm_blockcount, NEW.rm_owner, NEW.rm_offset,
+				NEW.rm_flags);
+		if (error)
+			goto done;
+		/* new left extent - oldext */
+		NEW = PREV;
+		error = xfs_rmap_lookup_eq(cur, NEW.rm_startblock,
+				NEW.rm_blockcount, NEW.rm_owner,
+				NEW.rm_offset, NEW.rm_flags, &i);
+		if (error)
+			goto done;
+		XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
+		NEW.rm_blockcount = offset - NEW.rm_offset;
+		error = xfs_rmap_update(cur, &NEW);
+		if (error)
+			goto done;
+		/* new middle extent - newext */
+		NEW.rm_startblock = bno;
+		NEW.rm_blockcount = len;
+		NEW.rm_owner = owner;
+		NEW.rm_offset = offset;
+		NEW.rm_flags = newext;
+		error = xfs_rmap_insert(cur, NEW.rm_startblock,
+				NEW.rm_blockcount, NEW.rm_owner, NEW.rm_offset,
+				NEW.rm_flags);
+		if (error)
+			goto done;
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
 #undef	NEW
 #undef	LEFT
 #undef	RIGHT
@@ -1754,6 +2132,10 @@ xfs_rmap_finish_one(
 		error = xfs_rmap_convert(rcur, bno, blockcount, !unwritten,
 				&oinfo);
 		break;
+	case XFS_RMAP_CONVERT_SHARED:
+		error = xfs_rmap_convert_shared(rcur, bno, blockcount,
+				!unwritten, &oinfo);
+		break;
 	default:
 		ASSERT(0);
 		error = -EFSCORRUPTED;
@@ -1857,7 +2239,8 @@ xfs_rmap_convert_extent(
 	if (!xfs_rmap_update_is_needed(mp, whichfork))
 		return 0;
 
-	return __xfs_rmap_add(mp, dfops, XFS_RMAP_CONVERT, ip->i_ino,
+	return __xfs_rmap_add(mp, dfops, xfs_is_reflink_inode(ip) ?
+			XFS_RMAP_CONVERT_SHARED : XFS_RMAP_CONVERT, ip->i_ino,
 			whichfork, PREV);
 }
 
diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
index 3b8742e..73c8278 100644
--- a/fs/xfs/xfs_rmap_item.c
+++ b/fs/xfs/xfs_rmap_item.c
@@ -496,6 +496,9 @@ xfs_rui_recover(
 		case XFS_RMAP_EXTENT_CONVERT:
 			type = XFS_RMAP_CONVERT;
 			break;
+		case XFS_RMAP_EXTENT_CONVERT_SHARED:
+			type = XFS_RMAP_CONVERT_SHARED;
+			break;
 		case XFS_RMAP_EXTENT_ALLOC:
 			type = XFS_RMAP_ALLOC;
 			break;

