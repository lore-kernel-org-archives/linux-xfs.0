Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 929907F85
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 20:29:28 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 0CFD4AC002
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:29:27 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id NaH3tix9unMRRi70 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:29:24 -0700 (PDT)
Subject: [PATCH 106/119] xfs: convert unwritten status of reverse mappings
	for shared files
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 16 Jun 2016 18:29:19 -0700
Message-ID: <146612695940.12839.9168024514454491402.stgit@birch.djwong.org>
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

Provide a function to convert an unwritten extent to a real one and
vice versa when shared extents are possible.

v2: Move rmap unwritten bit to rm_offset.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_rmap.c |  385 ++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_log_recover.c |    3 
 2 files changed, 387 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/libxfs/xfs_rmap.c b/fs/xfs/libxfs/xfs_rmap.c
index a9bd522..29d08fc 100644
--- a/fs/xfs/libxfs/xfs_rmap.c
+++ b/fs/xfs/libxfs/xfs_rmap.c
@@ -1293,6 +1293,384 @@ xfs_rmap_convert(
 	return __xfs_rmap_convert(cur, bno, len, unwritten, oinfo);
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
+		if (xfs_rmap_is_mergeable(&LEFT, owner, offset, len, newext))
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
+		trace_xfs_rmap_convert_gtrec(cur->bc_mp,
+				cur->bc_private.a.agno, RIGHT.rm_startblock,
+				RIGHT.rm_blockcount, RIGHT.rm_owner,
+				RIGHT.rm_offset, RIGHT.rm_flags);
+		if (xfs_rmap_is_mergeable(&RIGHT, owner, offset, len, newext))
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
+		error = xfs_rmapbt_delete(cur, RIGHT.rm_startblock,
+				RIGHT.rm_blockcount, RIGHT.rm_owner,
+				RIGHT.rm_offset, RIGHT.rm_flags);
+		if (error)
+			goto done;
+		error = xfs_rmapbt_delete(cur, PREV.rm_startblock,
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
+		error = xfs_rmapbt_delete(cur, PREV.rm_startblock,
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
+		error = xfs_rmapbt_delete(cur, RIGHT.rm_startblock,
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
+		error = xfs_rmapbt_delete(cur, NEW.rm_startblock,
+				NEW.rm_blockcount, NEW.rm_owner,
+				NEW.rm_offset, NEW.rm_flags);
+		if (error)
+			goto done;
+		NEW.rm_offset += len;
+		NEW.rm_startblock += len;
+		NEW.rm_blockcount -= len;
+		error = xfs_rmapbt_insert(cur, NEW.rm_startblock,
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
+		error = xfs_rmapbt_delete(cur, NEW.rm_startblock,
+				NEW.rm_blockcount, NEW.rm_owner,
+				NEW.rm_offset, NEW.rm_flags);
+		if (error)
+			goto done;
+		NEW.rm_offset += len;
+		NEW.rm_startblock += len;
+		NEW.rm_blockcount -= len;
+		error = xfs_rmapbt_insert(cur, NEW.rm_startblock,
+				NEW.rm_blockcount, NEW.rm_owner,
+				NEW.rm_offset, NEW.rm_flags);
+		if (error)
+			goto done;
+		error = xfs_rmapbt_insert(cur, bno, len, owner, offset, newext);
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
+		error = xfs_rmapbt_delete(cur, NEW.rm_startblock,
+				NEW.rm_blockcount, NEW.rm_owner,
+				NEW.rm_offset, NEW.rm_flags);
+		if (error)
+			goto done;
+		NEW.rm_offset = offset;
+		NEW.rm_startblock = bno;
+		NEW.rm_blockcount += len;
+		error = xfs_rmapbt_insert(cur, NEW.rm_startblock,
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
+		error = xfs_rmapbt_insert(cur, bno, len, owner, offset, newext);
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
+		error = xfs_rmapbt_insert(cur, NEW.rm_startblock,
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
+		error = xfs_rmapbt_insert(cur, NEW.rm_startblock,
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
@@ -1789,6 +2167,10 @@ xfs_rmap_finish_one(
 		error = xfs_rmap_convert(rcur, bno, blockcount, !unwritten,
 				&oinfo);
 		break;
+	case XFS_RMAP_CONVERT_SHARED:
+		error = xfs_rmap_convert_shared(rcur, bno, blockcount,
+				!unwritten, &oinfo);
+		break;
 	case XFS_RMAP_ALLOC:
 		error = __xfs_rmap_alloc(rcur, bno, blockcount, unwritten,
 				&oinfo);
@@ -1892,7 +2274,8 @@ xfs_rmap_convert_extent(
 {
 	struct xfs_rmap_intent	ri;
 
-	ri.ri_type = XFS_RMAP_CONVERT;
+	ri.ri_type = xfs_is_reflink_inode(ip) ? XFS_RMAP_CONVERT_SHARED :
+			XFS_RMAP_CONVERT;
 	ri.ri_owner = ip->i_ino;
 	ri.ri_whichfork = whichfork;
 	ri.ri_bmap = *PREV;
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index b2d2e0a..9372fc5 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -4786,6 +4786,9 @@ xlog_recover_process_rui(
 		case XFS_RMAP_EXTENT_CONVERT:
 			type = XFS_RMAP_CONVERT;
 			break;
+		case XFS_RMAP_EXTENT_CONVERT_SHARED:
+			type = XFS_RMAP_CONVERT_SHARED;
+			break;
 		case XFS_RMAP_EXTENT_ALLOC:
 			type = XFS_RMAP_ALLOC;
 			break;

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
