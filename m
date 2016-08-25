Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 204C5800D
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 18:44:31 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id E685F8F8035
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:44:30 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id Zm7W95tSyqBESsp7 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:44:28 -0700 (PDT)
Subject: [PATCH 09/20] xfs: prepare rmap functions to deal with rtrmapbt
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 25 Aug 2016 16:44:23 -0700
Message-ID: <147216866373.3688.16417052145703125563.stgit@birch.djwong.org>
In-Reply-To: <147216860614.3688.3200692982609112535.stgit@birch.djwong.org>
References: <147216860614.3688.3200692982609112535.stgit@birch.djwong.org>
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

Prepare the high-level rmap functions to deal with the new realtime
rmapbt and its slightly different conventions.  Provide the ability
to talk to either rmapbt or rtrmapbt formats from the same high
level code.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_rmap.c |  178 +++++++++++++++++++++++++++-------------------
 fs/xfs/libxfs/xfs_rmap.h |    2 -
 fs/xfs/xfs_scrub.c       |    2 -
 3 files changed, 108 insertions(+), 74 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_rmap.c b/fs/xfs/libxfs/xfs_rmap.c
index aa5052f..c654816 100644
--- a/fs/xfs/libxfs/xfs_rmap.c
+++ b/fs/xfs/libxfs/xfs_rmap.c
@@ -39,6 +39,24 @@
 #include "xfs_bmap.h"
 #include "xfs_inode.h"
 
+/* By convention, the rtrmapbt's "AG" number is NULLAGNUMBER. */
+static xfs_agnumber_t
+xfs_rmap_cur_agno(
+	struct xfs_btree_cur	*cur)
+{
+	return (cur->bc_flags & XFS_BTREE_LONG_PTRS) ?
+			NULLAGNUMBER : cur->bc_private.a.agno;
+}
+
+/* Return the maximum length of an rmap record. */
+static xfs_filblks_t
+xfs_rmap_len_max(
+	struct xfs_btree_cur	*cur)
+{
+	return (cur->bc_flags & XFS_BTREE_LONG_PTRS) ?
+			XFS_RTRMAP_LEN_MAX : XFS_RMAP_LEN_MAX;
+}
+
 /*
  * Lookup the first record less than or equal to [bno, len, owner, offset]
  * in the btree given by cur.
@@ -96,19 +114,27 @@ xfs_rmap_update(
 	union xfs_btree_rec	rec;
 	int			error;
 
-	trace_xfs_rmap_update(cur->bc_mp, cur->bc_private.a.agno,
+	trace_xfs_rmap_update(cur->bc_mp, xfs_rmap_cur_agno(cur),
 			irec->rm_startblock, irec->rm_blockcount,
 			irec->rm_owner, irec->rm_offset, irec->rm_flags);
 
-	rec.rmap.rm_startblock = cpu_to_be32(irec->rm_startblock);
-	rec.rmap.rm_blockcount = cpu_to_be32(irec->rm_blockcount);
-	rec.rmap.rm_owner = cpu_to_be64(irec->rm_owner);
-	rec.rmap.rm_offset = cpu_to_be64(
-			xfs_rmap_irec_offset_pack(irec));
+	if (cur->bc_flags & XFS_BTREE_LONG_PTRS) {
+		rec.rtrmap.rm_startblock = cpu_to_be64(irec->rm_startblock);
+		rec.rtrmap.rm_blockcount = cpu_to_be64(irec->rm_blockcount);
+		rec.rtrmap.rm_owner = cpu_to_be64(irec->rm_owner);
+		rec.rtrmap.rm_offset = cpu_to_be64(
+				xfs_rmap_irec_offset_pack(irec));
+	} else {
+		rec.rmap.rm_startblock = cpu_to_be32(irec->rm_startblock);
+		rec.rmap.rm_blockcount = cpu_to_be32(irec->rm_blockcount);
+		rec.rmap.rm_owner = cpu_to_be64(irec->rm_owner);
+		rec.rmap.rm_offset = cpu_to_be64(
+				xfs_rmap_irec_offset_pack(irec));
+	}
 	error = xfs_btree_update(cur, &rec);
 	if (error)
 		trace_xfs_rmap_update_error(cur->bc_mp,
-				cur->bc_private.a.agno, error, _RET_IP_);
+				xfs_rmap_cur_agno(cur), error, _RET_IP_);
 	return error;
 }
 
@@ -124,7 +150,7 @@ xfs_rmap_insert(
 	int			i;
 	int			error;
 
-	trace_xfs_rmap_insert(rcur->bc_mp, rcur->bc_private.a.agno, agbno,
+	trace_xfs_rmap_insert(rcur->bc_mp, xfs_rmap_cur_agno(rcur), agbno,
 			len, owner, offset, flags);
 
 	error = xfs_rmap_lookup_eq(rcur, agbno, len, owner, offset, flags, &i);
@@ -144,7 +170,7 @@ xfs_rmap_insert(
 done:
 	if (error)
 		trace_xfs_rmap_insert_error(rcur->bc_mp,
-				rcur->bc_private.a.agno, error, _RET_IP_);
+				xfs_rmap_cur_agno(rcur), error, _RET_IP_);
 	return error;
 }
 
@@ -160,7 +186,7 @@ xfs_rmap_delete(
 	int			i;
 	int			error;
 
-	trace_xfs_rmap_delete(rcur->bc_mp, rcur->bc_private.a.agno, agbno,
+	trace_xfs_rmap_delete(rcur->bc_mp, xfs_rmap_cur_agno(rcur), agbno,
 			len, owner, offset, flags);
 
 	error = xfs_rmap_lookup_eq(rcur, agbno, len, owner, offset, flags, &i);
@@ -175,22 +201,31 @@ xfs_rmap_delete(
 done:
 	if (error)
 		trace_xfs_rmap_delete_error(rcur->bc_mp,
-				rcur->bc_private.a.agno, error, _RET_IP_);
+				xfs_rmap_cur_agno(rcur), error, _RET_IP_);
 	return error;
 }
 
 /* Convert an internal btree record to an rmap record. */
 int
 xfs_rmap_btrec_to_irec(
+	struct xfs_btree_cur	*cur,
 	union xfs_btree_rec	*rec,
 	struct xfs_rmap_irec	*irec)
 {
 	irec->rm_flags = 0;
-	irec->rm_startblock = be32_to_cpu(rec->rmap.rm_startblock);
-	irec->rm_blockcount = be32_to_cpu(rec->rmap.rm_blockcount);
-	irec->rm_owner = be64_to_cpu(rec->rmap.rm_owner);
-	return xfs_rmap_irec_offset_unpack(be64_to_cpu(rec->rmap.rm_offset),
-			irec);
+	if (cur->bc_flags & XFS_BTREE_LONG_PTRS) {
+		irec->rm_startblock = be64_to_cpu(rec->rtrmap.rm_startblock);
+		irec->rm_blockcount = be64_to_cpu(rec->rtrmap.rm_blockcount);
+		irec->rm_owner = be64_to_cpu(rec->rtrmap.rm_owner);
+		return xfs_rmap_irec_offset_unpack(
+				be64_to_cpu(rec->rtrmap.rm_offset), irec);
+	} else {
+		irec->rm_startblock = be32_to_cpu(rec->rmap.rm_startblock);
+		irec->rm_blockcount = be32_to_cpu(rec->rmap.rm_blockcount);
+		irec->rm_owner = be64_to_cpu(rec->rmap.rm_owner);
+		return xfs_rmap_irec_offset_unpack(
+				be64_to_cpu(rec->rmap.rm_offset), irec);
+	}
 }
 
 /*
@@ -209,7 +244,7 @@ xfs_rmap_get_rec(
 	if (error || !*stat)
 		return error;
 
-	return xfs_rmap_btrec_to_irec(rec, irec);
+	return xfs_rmap_btrec_to_irec(cur, rec, irec);
 }
 
 struct xfs_find_left_neighbor_info {
@@ -228,7 +263,7 @@ xfs_rmap_find_left_neighbor_helper(
 	struct xfs_find_left_neighbor_info	*info = priv;
 
 	trace_xfs_rmap_find_left_neighbor_candidate(cur->bc_mp,
-			cur->bc_private.a.agno, rec->rm_startblock,
+			xfs_rmap_cur_agno(cur), rec->rm_startblock,
 			rec->rm_blockcount, rec->rm_owner, rec->rm_offset,
 			rec->rm_flags);
 
@@ -280,7 +315,7 @@ xfs_rmap_find_left_neighbor(
 	info.stat = stat;
 
 	trace_xfs_rmap_find_left_neighbor_query(cur->bc_mp,
-			cur->bc_private.a.agno, bno, 0, owner, offset, flags);
+			xfs_rmap_cur_agno(cur), bno, 0, owner, offset, flags);
 
 	error = xfs_rmap_query_range(cur, &info.high, &info.high,
 			xfs_rmap_find_left_neighbor_helper, &info);
@@ -288,7 +323,7 @@ xfs_rmap_find_left_neighbor(
 		error = 0;
 	if (*stat)
 		trace_xfs_rmap_find_left_neighbor_result(cur->bc_mp,
-				cur->bc_private.a.agno, irec->rm_startblock,
+				xfs_rmap_cur_agno(cur), irec->rm_startblock,
 				irec->rm_blockcount, irec->rm_owner,
 				irec->rm_offset, irec->rm_flags);
 	return error;
@@ -304,7 +339,7 @@ xfs_rmap_lookup_le_range_helper(
 	struct xfs_find_left_neighbor_info	*info = priv;
 
 	trace_xfs_rmap_lookup_le_range_candidate(cur->bc_mp,
-			cur->bc_private.a.agno, rec->rm_startblock,
+			xfs_rmap_cur_agno(cur), rec->rm_startblock,
 			rec->rm_blockcount, rec->rm_owner, rec->rm_offset,
 			rec->rm_flags);
 
@@ -353,14 +388,14 @@ xfs_rmap_lookup_le_range(
 	info.stat = stat;
 
 	trace_xfs_rmap_lookup_le_range(cur->bc_mp,
-			cur->bc_private.a.agno, bno, 0, owner, offset, flags);
+			xfs_rmap_cur_agno(cur), bno, 0, owner, offset, flags);
 	error = xfs_rmap_query_range(cur, &info.high, &info.high,
 			xfs_rmap_lookup_le_range_helper, &info);
 	if (error == XFS_BTREE_QUERY_RANGE_ABORT)
 		error = 0;
 	if (*stat)
 		trace_xfs_rmap_lookup_le_range_result(cur->bc_mp,
-				cur->bc_private.a.agno, irec->rm_startblock,
+				xfs_rmap_cur_agno(cur), irec->rm_startblock,
 				irec->rm_blockcount, irec->rm_owner,
 				irec->rm_offset, irec->rm_flags);
 	return error;
@@ -407,7 +442,7 @@ xfs_rmap_unmap(
 			(flags & XFS_RMAP_BMBT_BLOCK);
 	if (unwritten)
 		flags |= XFS_RMAP_UNWRITTEN;
-	trace_xfs_rmap_unmap(mp, cur->bc_private.a.agno, bno, len,
+	trace_xfs_rmap_unmap(mp, xfs_rmap_cur_agno(cur), bno, len,
 			unwritten, oinfo);
 
 	/*
@@ -425,7 +460,7 @@ xfs_rmap_unmap(
 		goto out_error;
 	XFS_WANT_CORRUPTED_GOTO(mp, i == 1, out_error);
 	trace_xfs_rmap_lookup_le_range_result(cur->bc_mp,
-			cur->bc_private.a.agno, ltrec.rm_startblock,
+			xfs_rmap_cur_agno(cur), ltrec.rm_startblock,
 			ltrec.rm_blockcount, ltrec.rm_owner,
 			ltrec.rm_offset, ltrec.rm_flags);
 	ltoff = ltrec.rm_offset;
@@ -473,7 +508,7 @@ xfs_rmap_unmap(
 
 	if (ltrec.rm_startblock == bno && ltrec.rm_blockcount == len) {
 		/* exact match, simply remove the record from rmap tree */
-		trace_xfs_rmap_delete(mp, cur->bc_private.a.agno,
+		trace_xfs_rmap_delete(mp, xfs_rmap_cur_agno(cur),
 				ltrec.rm_startblock, ltrec.rm_blockcount,
 				ltrec.rm_owner, ltrec.rm_offset,
 				ltrec.rm_flags);
@@ -548,7 +583,7 @@ xfs_rmap_unmap(
 		else
 			cur->bc_rec.r.rm_offset = offset + len;
 		cur->bc_rec.r.rm_flags = flags;
-		trace_xfs_rmap_insert(mp, cur->bc_private.a.agno,
+		trace_xfs_rmap_insert(mp, xfs_rmap_cur_agno(cur),
 				cur->bc_rec.r.rm_startblock,
 				cur->bc_rec.r.rm_blockcount,
 				cur->bc_rec.r.rm_owner,
@@ -560,11 +595,11 @@ xfs_rmap_unmap(
 	}
 
 out_done:
-	trace_xfs_rmap_unmap_done(mp, cur->bc_private.a.agno, bno, len,
+	trace_xfs_rmap_unmap_done(mp, xfs_rmap_cur_agno(cur), bno, len,
 			unwritten, oinfo);
 out_error:
 	if (error)
-		trace_xfs_rmap_unmap_error(mp, cur->bc_private.a.agno,
+		trace_xfs_rmap_unmap_error(mp, xfs_rmap_cur_agno(cur),
 				error, _RET_IP_);
 	return error;
 }
@@ -661,7 +696,7 @@ xfs_rmap_map(
 			(flags & XFS_RMAP_BMBT_BLOCK);
 	if (unwritten)
 		flags |= XFS_RMAP_UNWRITTEN;
-	trace_xfs_rmap_map(mp, cur->bc_private.a.agno, bno, len,
+	trace_xfs_rmap_map(mp, xfs_rmap_cur_agno(cur), bno, len,
 			unwritten, oinfo);
 
 	/*
@@ -680,7 +715,7 @@ xfs_rmap_map(
 		goto out_error;
 	XFS_WANT_CORRUPTED_GOTO(mp, have_lt == 1, out_error);
 	trace_xfs_rmap_lookup_le_range_result(cur->bc_mp,
-			cur->bc_private.a.agno, ltrec.rm_startblock,
+			xfs_rmap_cur_agno(cur), ltrec.rm_startblock,
 			ltrec.rm_blockcount, ltrec.rm_owner,
 			ltrec.rm_offset, ltrec.rm_flags);
 
@@ -707,7 +742,7 @@ xfs_rmap_map(
 		XFS_WANT_CORRUPTED_GOTO(mp, bno + len <= gtrec.rm_startblock,
 					out_error);
 		trace_xfs_rmap_find_right_neighbor_result(cur->bc_mp,
-			cur->bc_private.a.agno, gtrec.rm_startblock,
+			xfs_rmap_cur_agno(cur), gtrec.rm_startblock,
 			gtrec.rm_blockcount, gtrec.rm_owner,
 			gtrec.rm_offset, gtrec.rm_flags);
 		if (!xfs_rmap_is_mergeable(&gtrec, owner, flags))
@@ -734,8 +769,8 @@ xfs_rmap_map(
 		if (have_gt &&
 		    bno + len == gtrec.rm_startblock &&
 		    (ignore_off || offset + len == gtrec.rm_offset) &&
-		    (unsigned long)ltrec.rm_blockcount + len +
-				gtrec.rm_blockcount <= XFS_RMAP_LEN_MAX) {
+		    ltrec.rm_blockcount + len + gtrec.rm_blockcount <=
+		    xfs_rmap_len_max(cur)) {
 			/*
 			 * right edge also contiguous, delete right record
 			 * and merge into left record.
@@ -746,7 +781,7 @@ xfs_rmap_map(
 			 * result: |rrrrrrrrrrrrrrrrrrrrrrrrrrrrr|
 			 */
 			ltrec.rm_blockcount += gtrec.rm_blockcount;
-			trace_xfs_rmap_delete(mp, cur->bc_private.a.agno,
+			trace_xfs_rmap_delete(mp, xfs_rmap_cur_agno(cur),
 					gtrec.rm_startblock,
 					gtrec.rm_blockcount,
 					gtrec.rm_owner,
@@ -794,7 +829,7 @@ xfs_rmap_map(
 		cur->bc_rec.r.rm_owner = owner;
 		cur->bc_rec.r.rm_offset = offset;
 		cur->bc_rec.r.rm_flags = flags;
-		trace_xfs_rmap_insert(mp, cur->bc_private.a.agno, bno, len,
+		trace_xfs_rmap_insert(mp, xfs_rmap_cur_agno(cur), bno, len,
 			owner, offset, flags);
 		error = xfs_btree_insert(cur, &i);
 		if (error)
@@ -802,11 +837,11 @@ xfs_rmap_map(
 		XFS_WANT_CORRUPTED_GOTO(mp, i == 1, out_error);
 	}
 
-	trace_xfs_rmap_map_done(mp, cur->bc_private.a.agno, bno, len,
+	trace_xfs_rmap_map_done(mp, xfs_rmap_cur_agno(cur), bno, len,
 			unwritten, oinfo);
 out_error:
 	if (error)
-		trace_xfs_rmap_map_error(mp, cur->bc_private.a.agno,
+		trace_xfs_rmap_map_error(mp, xfs_rmap_cur_agno(cur),
 				error, _RET_IP_);
 	return error;
 }
@@ -886,7 +921,7 @@ xfs_rmap_convert(
 			(flags & (XFS_RMAP_ATTR_FORK | XFS_RMAP_BMBT_BLOCK))));
 	oldext = unwritten ? XFS_RMAP_UNWRITTEN : 0;
 	new_endoff = offset + len;
-	trace_xfs_rmap_convert(mp, cur->bc_private.a.agno, bno, len,
+	trace_xfs_rmap_convert(mp, xfs_rmap_cur_agno(cur), bno, len,
 			unwritten, oinfo);
 
 	/*
@@ -904,7 +939,7 @@ xfs_rmap_convert(
 		goto done;
 	XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
 	trace_xfs_rmap_lookup_le_range_result(cur->bc_mp,
-			cur->bc_private.a.agno, PREV.rm_startblock,
+			xfs_rmap_cur_agno(cur), PREV.rm_startblock,
 			PREV.rm_blockcount, PREV.rm_owner,
 			PREV.rm_offset, PREV.rm_flags);
 
@@ -940,7 +975,7 @@ xfs_rmap_convert(
 				LEFT.rm_startblock + LEFT.rm_blockcount <= bno,
 				done);
 		trace_xfs_rmap_find_left_neighbor_result(cur->bc_mp,
-				cur->bc_private.a.agno, LEFT.rm_startblock,
+				xfs_rmap_cur_agno(cur), LEFT.rm_startblock,
 				LEFT.rm_blockcount, LEFT.rm_owner,
 				LEFT.rm_offset, LEFT.rm_flags);
 		if (LEFT.rm_startblock + LEFT.rm_blockcount == bno &&
@@ -970,7 +1005,7 @@ xfs_rmap_convert(
 		XFS_WANT_CORRUPTED_GOTO(mp, bno + len <= RIGHT.rm_startblock,
 					done);
 		trace_xfs_rmap_find_right_neighbor_result(cur->bc_mp,
-				cur->bc_private.a.agno, RIGHT.rm_startblock,
+				xfs_rmap_cur_agno(cur), RIGHT.rm_startblock,
 				RIGHT.rm_blockcount, RIGHT.rm_owner,
 				RIGHT.rm_offset, RIGHT.rm_flags);
 		if (bno + len == RIGHT.rm_startblock &&
@@ -984,11 +1019,11 @@ xfs_rmap_convert(
 			 RMAP_RIGHT_FILLING | RMAP_RIGHT_CONTIG)) ==
 	    (RMAP_LEFT_FILLING | RMAP_LEFT_CONTIG |
 	     RMAP_RIGHT_FILLING | RMAP_RIGHT_CONTIG) &&
-	    (unsigned long)LEFT.rm_blockcount + len +
-	     RIGHT.rm_blockcount > XFS_RMAP_LEN_MAX)
+	    LEFT.rm_blockcount + len + RIGHT.rm_blockcount >
+	    xfs_rmap_len_max(cur))
 		state &= ~RMAP_RIGHT_CONTIG;
 
-	trace_xfs_rmap_convert_state(mp, cur->bc_private.a.agno, state,
+	trace_xfs_rmap_convert_state(mp, xfs_rmap_cur_agno(cur), state,
 			_RET_IP_);
 
 	/* reset the cursor back to PREV */
@@ -1012,7 +1047,7 @@ xfs_rmap_convert(
 		if (error)
 			goto done;
 		XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
-		trace_xfs_rmap_delete(mp, cur->bc_private.a.agno,
+		trace_xfs_rmap_delete(mp, xfs_rmap_cur_agno(cur),
 				RIGHT.rm_startblock, RIGHT.rm_blockcount,
 				RIGHT.rm_owner, RIGHT.rm_offset,
 				RIGHT.rm_flags);
@@ -1024,7 +1059,7 @@ xfs_rmap_convert(
 		if (error)
 			goto done;
 		XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
-		trace_xfs_rmap_delete(mp, cur->bc_private.a.agno,
+		trace_xfs_rmap_delete(mp, xfs_rmap_cur_agno(cur),
 				PREV.rm_startblock, PREV.rm_blockcount,
 				PREV.rm_owner, PREV.rm_offset,
 				PREV.rm_flags);
@@ -1048,7 +1083,7 @@ xfs_rmap_convert(
 		 * Setting all of a previous oldext extent to newext.
 		 * The left neighbor is contiguous, the right is not.
 		 */
-		trace_xfs_rmap_delete(mp, cur->bc_private.a.agno,
+		trace_xfs_rmap_delete(mp, xfs_rmap_cur_agno(cur),
 				PREV.rm_startblock, PREV.rm_blockcount,
 				PREV.rm_owner, PREV.rm_offset,
 				PREV.rm_flags);
@@ -1076,7 +1111,7 @@ xfs_rmap_convert(
 		if (error)
 			goto done;
 		XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
-		trace_xfs_rmap_delete(mp, cur->bc_private.a.agno,
+		trace_xfs_rmap_delete(mp, xfs_rmap_cur_agno(cur),
 				RIGHT.rm_startblock, RIGHT.rm_blockcount,
 				RIGHT.rm_owner, RIGHT.rm_offset,
 				RIGHT.rm_flags);
@@ -1149,7 +1184,7 @@ xfs_rmap_convert(
 		NEW.rm_blockcount = len;
 		NEW.rm_flags = newext;
 		cur->bc_rec.r = NEW;
-		trace_xfs_rmap_insert(mp, cur->bc_private.a.agno, bno,
+		trace_xfs_rmap_insert(mp, xfs_rmap_cur_agno(cur), bno,
 				len, owner, offset, newext);
 		error = xfs_btree_insert(cur, &i);
 		if (error)
@@ -1200,7 +1235,7 @@ xfs_rmap_convert(
 		NEW.rm_blockcount = len;
 		NEW.rm_flags = newext;
 		cur->bc_rec.r = NEW;
-		trace_xfs_rmap_insert(mp, cur->bc_private.a.agno, bno,
+		trace_xfs_rmap_insert(mp, xfs_rmap_cur_agno(cur), bno,
 				len, owner, offset, newext);
 		error = xfs_btree_insert(cur, &i);
 		if (error)
@@ -1228,7 +1263,7 @@ xfs_rmap_convert(
 		NEW = PREV;
 		NEW.rm_blockcount = offset - PREV.rm_offset;
 		cur->bc_rec.r = NEW;
-		trace_xfs_rmap_insert(mp, cur->bc_private.a.agno,
+		trace_xfs_rmap_insert(mp, xfs_rmap_cur_agno(cur),
 				NEW.rm_startblock, NEW.rm_blockcount,
 				NEW.rm_owner, NEW.rm_offset,
 				NEW.rm_flags);
@@ -1249,7 +1284,7 @@ xfs_rmap_convert(
 		/* new middle extent - newext */
 		cur->bc_rec.r.rm_flags &= ~XFS_RMAP_UNWRITTEN;
 		cur->bc_rec.r.rm_flags |= newext;
-		trace_xfs_rmap_insert(mp, cur->bc_private.a.agno, bno, len,
+		trace_xfs_rmap_insert(mp, xfs_rmap_cur_agno(cur), bno, len,
 				owner, offset, newext);
 		error = xfs_btree_insert(cur, &i);
 		if (error)
@@ -1270,12 +1305,12 @@ xfs_rmap_convert(
 		ASSERT(0);
 	}
 
-	trace_xfs_rmap_convert_done(mp, cur->bc_private.a.agno, bno, len,
+	trace_xfs_rmap_convert_done(mp, xfs_rmap_cur_agno(cur), bno, len,
 			unwritten, oinfo);
 done:
 	if (error)
 		trace_xfs_rmap_convert_error(cur->bc_mp,
-				cur->bc_private.a.agno, error, _RET_IP_);
+				xfs_rmap_cur_agno(cur), error, _RET_IP_);
 	return error;
 }
 
@@ -1311,7 +1346,7 @@ xfs_rmap_convert_shared(
 			(flags & (XFS_RMAP_ATTR_FORK | XFS_RMAP_BMBT_BLOCK))));
 	oldext = unwritten ? XFS_RMAP_UNWRITTEN : 0;
 	new_endoff = offset + len;
-	trace_xfs_rmap_convert(mp, cur->bc_private.a.agno, bno, len,
+	trace_xfs_rmap_convert(mp, xfs_rmap_cur_agno(cur), bno, len,
 			unwritten, oinfo);
 
 	/*
@@ -1365,7 +1400,7 @@ xfs_rmap_convert_shared(
 		XFS_WANT_CORRUPTED_GOTO(mp, bno + len <= RIGHT.rm_startblock,
 				done);
 		trace_xfs_rmap_find_right_neighbor_result(cur->bc_mp,
-				cur->bc_private.a.agno, RIGHT.rm_startblock,
+				xfs_rmap_cur_agno(cur), RIGHT.rm_startblock,
 				RIGHT.rm_blockcount, RIGHT.rm_owner,
 				RIGHT.rm_offset, RIGHT.rm_flags);
 		if (xfs_rmap_is_mergeable(&RIGHT, owner, newext))
@@ -1377,11 +1412,11 @@ xfs_rmap_convert_shared(
 			 RMAP_RIGHT_FILLING | RMAP_RIGHT_CONTIG)) ==
 	    (RMAP_LEFT_FILLING | RMAP_LEFT_CONTIG |
 	     RMAP_RIGHT_FILLING | RMAP_RIGHT_CONTIG) &&
-	    (unsigned long)LEFT.rm_blockcount + len +
-	     RIGHT.rm_blockcount > XFS_RMAP_LEN_MAX)
+	    LEFT.rm_blockcount + len + RIGHT.rm_blockcount >
+	    xfs_rmap_len_max(cur))
 		state &= ~RMAP_RIGHT_CONTIG;
 
-	trace_xfs_rmap_convert_state(mp, cur->bc_private.a.agno, state,
+	trace_xfs_rmap_convert_state(mp, xfs_rmap_cur_agno(cur), state,
 			_RET_IP_);
 	/*
 	 * Switch out based on the FILLING and CONTIG state bits.
@@ -1648,12 +1683,12 @@ xfs_rmap_convert_shared(
 		ASSERT(0);
 	}
 
-	trace_xfs_rmap_convert_done(mp, cur->bc_private.a.agno, bno, len,
+	trace_xfs_rmap_convert_done(mp, xfs_rmap_cur_agno(cur), bno, len,
 			unwritten, oinfo);
 done:
 	if (error)
 		trace_xfs_rmap_convert_error(cur->bc_mp,
-				cur->bc_private.a.agno, error, _RET_IP_);
+				xfs_rmap_cur_agno(cur), error, _RET_IP_);
 	return error;
 }
 
@@ -1691,7 +1726,7 @@ xfs_rmap_unmap_shared(
 	xfs_owner_info_unpack(oinfo, &owner, &offset, &flags);
 	if (unwritten)
 		flags |= XFS_RMAP_UNWRITTEN;
-	trace_xfs_rmap_unmap(mp, cur->bc_private.a.agno, bno, len,
+	trace_xfs_rmap_unmap(mp, xfs_rmap_cur_agno(cur), bno, len,
 			unwritten, oinfo);
 
 	/*
@@ -1815,12 +1850,12 @@ xfs_rmap_unmap_shared(
 			goto out_error;
 	}
 
-	trace_xfs_rmap_unmap_done(mp, cur->bc_private.a.agno, bno, len,
+	trace_xfs_rmap_unmap_done(mp, xfs_rmap_cur_agno(cur), bno, len,
 			unwritten, oinfo);
 out_error:
 	if (error)
 		trace_xfs_rmap_unmap_error(cur->bc_mp,
-				cur->bc_private.a.agno, error, _RET_IP_);
+				xfs_rmap_cur_agno(cur), error, _RET_IP_);
 	return error;
 }
 
@@ -1855,7 +1890,7 @@ xfs_rmap_map_shared(
 	xfs_owner_info_unpack(oinfo, &owner, &offset, &flags);
 	if (unwritten)
 		flags |= XFS_RMAP_UNWRITTEN;
-	trace_xfs_rmap_map(mp, cur->bc_private.a.agno, bno, len,
+	trace_xfs_rmap_map(mp, xfs_rmap_cur_agno(cur), bno, len,
 			unwritten, oinfo);
 
 	/* Is there a left record that abuts our range? */
@@ -1878,7 +1913,7 @@ xfs_rmap_map_shared(
 			goto out_error;
 		XFS_WANT_CORRUPTED_GOTO(mp, have_gt == 1, out_error);
 		trace_xfs_rmap_find_right_neighbor_result(cur->bc_mp,
-			cur->bc_private.a.agno, gtrec.rm_startblock,
+			xfs_rmap_cur_agno(cur), gtrec.rm_startblock,
 			gtrec.rm_blockcount, gtrec.rm_owner,
 			gtrec.rm_offset, gtrec.rm_flags);
 
@@ -1968,12 +2003,12 @@ xfs_rmap_map_shared(
 			goto out_error;
 	}
 
-	trace_xfs_rmap_map_done(mp, cur->bc_private.a.agno, bno, len,
+	trace_xfs_rmap_map_done(mp, xfs_rmap_cur_agno(cur), bno, len,
 			unwritten, oinfo);
 out_error:
 	if (error)
 		trace_xfs_rmap_map_error(cur->bc_mp,
-				cur->bc_private.a.agno, error, _RET_IP_);
+				xfs_rmap_cur_agno(cur), error, _RET_IP_);
 	return error;
 }
 
@@ -1993,7 +2028,7 @@ xfs_rmap_query_range_helper(
 	struct xfs_rmap_irec			irec;
 	int					error;
 
-	error = xfs_rmap_btrec_to_irec(rec, &irec);
+	error = xfs_rmap_btrec_to_irec(cur, rec, &irec);
 	if (error)
 		return error;
 	return query->fn(cur, &irec, query->priv);
@@ -2076,13 +2111,12 @@ xfs_rmap_finish_one(
 			XFS_ERRTAG_RMAP_FINISH_ONE,
 			XFS_RANDOM_RMAP_FINISH_ONE))
 		return -EIO;
-
 	/*
 	 * If we haven't gotten a cursor or the cursor AG doesn't match
 	 * the startblock, get one now.
 	 */
 	rcur = *pcur;
-	if (rcur != NULL && rcur->bc_private.a.agno != agno) {
+	if (rcur != NULL && xfs_rmap_cur_agno(rcur) != agno) {
 		xfs_rmap_finish_one_cleanup(tp, rcur, 0);
 		rcur = NULL;
 		*pcur = NULL;
diff --git a/fs/xfs/libxfs/xfs_rmap.h b/fs/xfs/libxfs/xfs_rmap.h
index 06f7e73..3574377 100644
--- a/fs/xfs/libxfs/xfs_rmap.h
+++ b/fs/xfs/libxfs/xfs_rmap.h
@@ -213,7 +213,7 @@ int xfs_rmap_lookup_le_range(struct xfs_btree_cur *cur, xfs_fsblock_t bno,
 		uint64_t owner, uint64_t offset, unsigned int flags,
 		struct xfs_rmap_irec *irec, int	*stat);
 union xfs_btree_rec;
-int xfs_rmap_btrec_to_irec(union xfs_btree_rec *rec,
+int xfs_rmap_btrec_to_irec(struct xfs_btree_cur *cur, union xfs_btree_rec *rec,
 		struct xfs_rmap_irec *irec);
 int xfs_rmap_has_record(struct xfs_btree_cur *cur, xfs_fsblock_t bno,
 		xfs_filblks_t len, bool *exists);
diff --git a/fs/xfs/xfs_scrub.c b/fs/xfs/xfs_scrub.c
index e4e3210..590bef8 100644
--- a/fs/xfs/xfs_scrub.c
+++ b/fs/xfs/xfs_scrub.c
@@ -1778,7 +1778,7 @@ xfs_scrub_rmapbt_helper(
 	int				error = 0;
 	int				err2;
 
-	error = xfs_rmap_btrec_to_irec(rec, &irec);
+	error = xfs_rmap_btrec_to_irec(bs->cur, rec, &irec);
 	if (error)
 		return error;
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
