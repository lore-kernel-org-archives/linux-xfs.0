Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:40990 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728073AbfAACZY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 31 Dec 2018 21:25:24 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id x012OnhQ179183
        for <linux-xfs@vger.kernel.org>; Tue, 1 Jan 2019 02:25:20 GMT
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp2120.oracle.com with ESMTP id 2pp1jqx47j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 01 Jan 2019 02:25:20 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id x012PDgr020417
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 1 Jan 2019 02:25:14 GMT
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x012PDPX005196
        for <linux-xfs@vger.kernel.org>; Tue, 1 Jan 2019 02:25:13 GMT
Subject: [PATCH 08/20] xfs: prepare rmap functions to deal with rtrmapbt
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Mon, 31 Dec 2018 18:25:12 -0800
Message-ID: <154630951216.8108.18142382221423470125.stgit@magnolia>
In-Reply-To: <154630945466.8108.16578904812191021263.stgit@magnolia>
References: <154630945466.8108.16578904812191021263.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Prepare the high-level rmap functions to deal with the new realtime
rmapbt and its slightly different conventions.  Provide the ability
to talk to either rmapbt or rtrmapbt formats from the same high
level code.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_rmap.c |  178 +++++++++++++++++++++++++++-------------------
 fs/xfs/libxfs/xfs_rmap.h |    2 -
 fs/xfs/scrub/rmap.c      |    2 -
 3 files changed, 108 insertions(+), 74 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_rmap.c b/fs/xfs/libxfs/xfs_rmap.c
index 2f0b79aa89c5..1ba04510b9d0 100644
--- a/fs/xfs/libxfs/xfs_rmap.c
+++ b/fs/xfs/libxfs/xfs_rmap.c
@@ -29,6 +29,24 @@
 #include "xfs_inode.h"
 #include "xfs_ialloc.h"
 
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
@@ -86,19 +104,27 @@ xfs_rmap_update(
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
 
@@ -114,7 +140,7 @@ xfs_rmap_insert(
 	int			i;
 	int			error;
 
-	trace_xfs_rmap_insert(rcur->bc_mp, rcur->bc_private.a.agno, agbno,
+	trace_xfs_rmap_insert(rcur->bc_mp, xfs_rmap_cur_agno(rcur), agbno,
 			len, owner, offset, flags);
 
 	error = xfs_rmap_lookup_eq(rcur, agbno, len, owner, offset, flags, &i);
@@ -134,7 +160,7 @@ xfs_rmap_insert(
 done:
 	if (error)
 		trace_xfs_rmap_insert_error(rcur->bc_mp,
-				rcur->bc_private.a.agno, error, _RET_IP_);
+				xfs_rmap_cur_agno(rcur), error, _RET_IP_);
 	return error;
 }
 
@@ -150,7 +176,7 @@ xfs_rmap_delete(
 	int			i;
 	int			error;
 
-	trace_xfs_rmap_delete(rcur->bc_mp, rcur->bc_private.a.agno, agbno,
+	trace_xfs_rmap_delete(rcur->bc_mp, xfs_rmap_cur_agno(rcur), agbno,
 			len, owner, offset, flags);
 
 	error = xfs_rmap_lookup_eq(rcur, agbno, len, owner, offset, flags, &i);
@@ -165,22 +191,31 @@ xfs_rmap_delete(
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
@@ -206,7 +241,7 @@ xfs_rmap_get_rec(
 	else
 		agno = cur->bc_private.a.agno;
 
-	if (xfs_rmap_btrec_to_irec(rec, irec))
+	if (xfs_rmap_btrec_to_irec(cur, rec, irec))
 		goto out_bad_rec;
 
 	if (irec->rm_blockcount == 0)
@@ -272,7 +307,7 @@ xfs_rmap_find_left_neighbor_helper(
 	struct xfs_find_left_neighbor_info	*info = priv;
 
 	trace_xfs_rmap_find_left_neighbor_candidate(cur->bc_mp,
-			cur->bc_private.a.agno, rec->rm_startblock,
+			xfs_rmap_cur_agno(cur), rec->rm_startblock,
 			rec->rm_blockcount, rec->rm_owner, rec->rm_offset,
 			rec->rm_flags);
 
@@ -324,7 +359,7 @@ xfs_rmap_find_left_neighbor(
 	info.stat = stat;
 
 	trace_xfs_rmap_find_left_neighbor_query(cur->bc_mp,
-			cur->bc_private.a.agno, bno, 0, owner, offset, flags);
+			xfs_rmap_cur_agno(cur), bno, 0, owner, offset, flags);
 
 	error = xfs_rmap_query_range(cur, &info.high, &info.high,
 			xfs_rmap_find_left_neighbor_helper, &info);
@@ -332,7 +367,7 @@ xfs_rmap_find_left_neighbor(
 		error = 0;
 	if (*stat)
 		trace_xfs_rmap_find_left_neighbor_result(cur->bc_mp,
-				cur->bc_private.a.agno, irec->rm_startblock,
+				xfs_rmap_cur_agno(cur), irec->rm_startblock,
 				irec->rm_blockcount, irec->rm_owner,
 				irec->rm_offset, irec->rm_flags);
 	return error;
@@ -348,7 +383,7 @@ xfs_rmap_lookup_le_range_helper(
 	struct xfs_find_left_neighbor_info	*info = priv;
 
 	trace_xfs_rmap_lookup_le_range_candidate(cur->bc_mp,
-			cur->bc_private.a.agno, rec->rm_startblock,
+			xfs_rmap_cur_agno(cur), rec->rm_startblock,
 			rec->rm_blockcount, rec->rm_owner, rec->rm_offset,
 			rec->rm_flags);
 
@@ -397,14 +432,14 @@ xfs_rmap_lookup_le_range(
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
@@ -495,7 +530,7 @@ xfs_rmap_unmap(
 			(flags & XFS_RMAP_BMBT_BLOCK);
 	if (unwritten)
 		flags |= XFS_RMAP_UNWRITTEN;
-	trace_xfs_rmap_unmap(mp, cur->bc_private.a.agno, bno, len,
+	trace_xfs_rmap_unmap(mp, xfs_rmap_cur_agno(cur), bno, len,
 			unwritten, oinfo);
 
 	/*
@@ -513,7 +548,7 @@ xfs_rmap_unmap(
 		goto out_error;
 	XFS_WANT_CORRUPTED_GOTO(mp, i == 1, out_error);
 	trace_xfs_rmap_lookup_le_range_result(cur->bc_mp,
-			cur->bc_private.a.agno, ltrec.rm_startblock,
+			xfs_rmap_cur_agno(cur), ltrec.rm_startblock,
 			ltrec.rm_blockcount, ltrec.rm_owner,
 			ltrec.rm_offset, ltrec.rm_flags);
 	ltoff = ltrec.rm_offset;
@@ -568,7 +603,7 @@ xfs_rmap_unmap(
 
 	if (ltrec.rm_startblock == bno && ltrec.rm_blockcount == len) {
 		/* exact match, simply remove the record from rmap tree */
-		trace_xfs_rmap_delete(mp, cur->bc_private.a.agno,
+		trace_xfs_rmap_delete(mp, xfs_rmap_cur_agno(cur),
 				ltrec.rm_startblock, ltrec.rm_blockcount,
 				ltrec.rm_owner, ltrec.rm_offset,
 				ltrec.rm_flags);
@@ -643,7 +678,7 @@ xfs_rmap_unmap(
 		else
 			cur->bc_rec.r.rm_offset = offset + len;
 		cur->bc_rec.r.rm_flags = flags;
-		trace_xfs_rmap_insert(mp, cur->bc_private.a.agno,
+		trace_xfs_rmap_insert(mp, xfs_rmap_cur_agno(cur),
 				cur->bc_rec.r.rm_startblock,
 				cur->bc_rec.r.rm_blockcount,
 				cur->bc_rec.r.rm_owner,
@@ -655,11 +690,11 @@ xfs_rmap_unmap(
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
@@ -750,7 +785,7 @@ xfs_rmap_map(
 			(flags & XFS_RMAP_BMBT_BLOCK);
 	if (unwritten)
 		flags |= XFS_RMAP_UNWRITTEN;
-	trace_xfs_rmap_map(mp, cur->bc_private.a.agno, bno, len,
+	trace_xfs_rmap_map(mp, xfs_rmap_cur_agno(cur), bno, len,
 			unwritten, oinfo);
 	ASSERT(!xfs_rmap_should_skip_owner_update(oinfo));
 
@@ -769,7 +804,7 @@ xfs_rmap_map(
 			goto out_error;
 		XFS_WANT_CORRUPTED_GOTO(mp, have_lt == 1, out_error);
 		trace_xfs_rmap_lookup_le_range_result(cur->bc_mp,
-				cur->bc_private.a.agno, ltrec.rm_startblock,
+				xfs_rmap_cur_agno(cur), ltrec.rm_startblock,
 				ltrec.rm_blockcount, ltrec.rm_owner,
 				ltrec.rm_offset, ltrec.rm_flags);
 
@@ -797,7 +832,7 @@ xfs_rmap_map(
 		XFS_WANT_CORRUPTED_GOTO(mp, bno + len <= gtrec.rm_startblock,
 					out_error);
 		trace_xfs_rmap_find_right_neighbor_result(cur->bc_mp,
-			cur->bc_private.a.agno, gtrec.rm_startblock,
+			xfs_rmap_cur_agno(cur), gtrec.rm_startblock,
 			gtrec.rm_blockcount, gtrec.rm_owner,
 			gtrec.rm_offset, gtrec.rm_flags);
 		if (!xfs_rmap_is_mergeable(&gtrec, owner, flags))
@@ -824,8 +859,8 @@ xfs_rmap_map(
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
@@ -836,7 +871,7 @@ xfs_rmap_map(
 			 * result: |rrrrrrrrrrrrrrrrrrrrrrrrrrrrr|
 			 */
 			ltrec.rm_blockcount += gtrec.rm_blockcount;
-			trace_xfs_rmap_delete(mp, cur->bc_private.a.agno,
+			trace_xfs_rmap_delete(mp, xfs_rmap_cur_agno(cur),
 					gtrec.rm_startblock,
 					gtrec.rm_blockcount,
 					gtrec.rm_owner,
@@ -884,7 +919,7 @@ xfs_rmap_map(
 		cur->bc_rec.r.rm_owner = owner;
 		cur->bc_rec.r.rm_offset = offset;
 		cur->bc_rec.r.rm_flags = flags;
-		trace_xfs_rmap_insert(mp, cur->bc_private.a.agno, bno, len,
+		trace_xfs_rmap_insert(mp, xfs_rmap_cur_agno(cur), bno, len,
 			owner, offset, flags);
 		error = xfs_btree_insert(cur, &i);
 		if (error)
@@ -892,11 +927,11 @@ xfs_rmap_map(
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
@@ -970,7 +1005,7 @@ xfs_rmap_convert(
 			(flags & (XFS_RMAP_ATTR_FORK | XFS_RMAP_BMBT_BLOCK))));
 	oldext = unwritten ? XFS_RMAP_UNWRITTEN : 0;
 	new_endoff = offset + len;
-	trace_xfs_rmap_convert(mp, cur->bc_private.a.agno, bno, len,
+	trace_xfs_rmap_convert(mp, xfs_rmap_cur_agno(cur), bno, len,
 			unwritten, oinfo);
 
 	/*
@@ -988,7 +1023,7 @@ xfs_rmap_convert(
 		goto done;
 	XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
 	trace_xfs_rmap_lookup_le_range_result(cur->bc_mp,
-			cur->bc_private.a.agno, PREV.rm_startblock,
+			xfs_rmap_cur_agno(cur), PREV.rm_startblock,
 			PREV.rm_blockcount, PREV.rm_owner,
 			PREV.rm_offset, PREV.rm_flags);
 
@@ -1024,7 +1059,7 @@ xfs_rmap_convert(
 				LEFT.rm_startblock + LEFT.rm_blockcount <= bno,
 				done);
 		trace_xfs_rmap_find_left_neighbor_result(cur->bc_mp,
-				cur->bc_private.a.agno, LEFT.rm_startblock,
+				xfs_rmap_cur_agno(cur), LEFT.rm_startblock,
 				LEFT.rm_blockcount, LEFT.rm_owner,
 				LEFT.rm_offset, LEFT.rm_flags);
 		if (LEFT.rm_startblock + LEFT.rm_blockcount == bno &&
@@ -1054,7 +1089,7 @@ xfs_rmap_convert(
 		XFS_WANT_CORRUPTED_GOTO(mp, bno + len <= RIGHT.rm_startblock,
 					done);
 		trace_xfs_rmap_find_right_neighbor_result(cur->bc_mp,
-				cur->bc_private.a.agno, RIGHT.rm_startblock,
+				xfs_rmap_cur_agno(cur), RIGHT.rm_startblock,
 				RIGHT.rm_blockcount, RIGHT.rm_owner,
 				RIGHT.rm_offset, RIGHT.rm_flags);
 		if (bno + len == RIGHT.rm_startblock &&
@@ -1068,11 +1103,11 @@ xfs_rmap_convert(
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
@@ -1096,7 +1131,7 @@ xfs_rmap_convert(
 		if (error)
 			goto done;
 		XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
-		trace_xfs_rmap_delete(mp, cur->bc_private.a.agno,
+		trace_xfs_rmap_delete(mp, xfs_rmap_cur_agno(cur),
 				RIGHT.rm_startblock, RIGHT.rm_blockcount,
 				RIGHT.rm_owner, RIGHT.rm_offset,
 				RIGHT.rm_flags);
@@ -1108,7 +1143,7 @@ xfs_rmap_convert(
 		if (error)
 			goto done;
 		XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
-		trace_xfs_rmap_delete(mp, cur->bc_private.a.agno,
+		trace_xfs_rmap_delete(mp, xfs_rmap_cur_agno(cur),
 				PREV.rm_startblock, PREV.rm_blockcount,
 				PREV.rm_owner, PREV.rm_offset,
 				PREV.rm_flags);
@@ -1132,7 +1167,7 @@ xfs_rmap_convert(
 		 * Setting all of a previous oldext extent to newext.
 		 * The left neighbor is contiguous, the right is not.
 		 */
-		trace_xfs_rmap_delete(mp, cur->bc_private.a.agno,
+		trace_xfs_rmap_delete(mp, xfs_rmap_cur_agno(cur),
 				PREV.rm_startblock, PREV.rm_blockcount,
 				PREV.rm_owner, PREV.rm_offset,
 				PREV.rm_flags);
@@ -1160,7 +1195,7 @@ xfs_rmap_convert(
 		if (error)
 			goto done;
 		XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
-		trace_xfs_rmap_delete(mp, cur->bc_private.a.agno,
+		trace_xfs_rmap_delete(mp, xfs_rmap_cur_agno(cur),
 				RIGHT.rm_startblock, RIGHT.rm_blockcount,
 				RIGHT.rm_owner, RIGHT.rm_offset,
 				RIGHT.rm_flags);
@@ -1233,7 +1268,7 @@ xfs_rmap_convert(
 		NEW.rm_blockcount = len;
 		NEW.rm_flags = newext;
 		cur->bc_rec.r = NEW;
-		trace_xfs_rmap_insert(mp, cur->bc_private.a.agno, bno,
+		trace_xfs_rmap_insert(mp, xfs_rmap_cur_agno(cur), bno,
 				len, owner, offset, newext);
 		error = xfs_btree_insert(cur, &i);
 		if (error)
@@ -1284,7 +1319,7 @@ xfs_rmap_convert(
 		NEW.rm_blockcount = len;
 		NEW.rm_flags = newext;
 		cur->bc_rec.r = NEW;
-		trace_xfs_rmap_insert(mp, cur->bc_private.a.agno, bno,
+		trace_xfs_rmap_insert(mp, xfs_rmap_cur_agno(cur), bno,
 				len, owner, offset, newext);
 		error = xfs_btree_insert(cur, &i);
 		if (error)
@@ -1312,7 +1347,7 @@ xfs_rmap_convert(
 		NEW = PREV;
 		NEW.rm_blockcount = offset - PREV.rm_offset;
 		cur->bc_rec.r = NEW;
-		trace_xfs_rmap_insert(mp, cur->bc_private.a.agno,
+		trace_xfs_rmap_insert(mp, xfs_rmap_cur_agno(cur),
 				NEW.rm_startblock, NEW.rm_blockcount,
 				NEW.rm_owner, NEW.rm_offset,
 				NEW.rm_flags);
@@ -1333,7 +1368,7 @@ xfs_rmap_convert(
 		/* new middle extent - newext */
 		cur->bc_rec.r.rm_flags &= ~XFS_RMAP_UNWRITTEN;
 		cur->bc_rec.r.rm_flags |= newext;
-		trace_xfs_rmap_insert(mp, cur->bc_private.a.agno, bno, len,
+		trace_xfs_rmap_insert(mp, xfs_rmap_cur_agno(cur), bno, len,
 				owner, offset, newext);
 		error = xfs_btree_insert(cur, &i);
 		if (error)
@@ -1354,12 +1389,12 @@ xfs_rmap_convert(
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
 
@@ -1395,7 +1430,7 @@ xfs_rmap_convert_shared(
 			(flags & (XFS_RMAP_ATTR_FORK | XFS_RMAP_BMBT_BLOCK))));
 	oldext = unwritten ? XFS_RMAP_UNWRITTEN : 0;
 	new_endoff = offset + len;
-	trace_xfs_rmap_convert(mp, cur->bc_private.a.agno, bno, len,
+	trace_xfs_rmap_convert(mp, xfs_rmap_cur_agno(cur), bno, len,
 			unwritten, oinfo);
 
 	/*
@@ -1451,7 +1486,7 @@ xfs_rmap_convert_shared(
 		XFS_WANT_CORRUPTED_GOTO(mp, bno + len <= RIGHT.rm_startblock,
 				done);
 		trace_xfs_rmap_find_right_neighbor_result(cur->bc_mp,
-				cur->bc_private.a.agno, RIGHT.rm_startblock,
+				xfs_rmap_cur_agno(cur), RIGHT.rm_startblock,
 				RIGHT.rm_blockcount, RIGHT.rm_owner,
 				RIGHT.rm_offset, RIGHT.rm_flags);
 		if (xfs_rmap_is_mergeable(&RIGHT, owner, newext))
@@ -1463,11 +1498,11 @@ xfs_rmap_convert_shared(
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
@@ -1734,12 +1769,12 @@ xfs_rmap_convert_shared(
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
 
@@ -1777,7 +1812,7 @@ xfs_rmap_unmap_shared(
 	xfs_owner_info_unpack(oinfo, &owner, &offset, &flags);
 	if (unwritten)
 		flags |= XFS_RMAP_UNWRITTEN;
-	trace_xfs_rmap_unmap(mp, cur->bc_private.a.agno, bno, len,
+	trace_xfs_rmap_unmap(mp, xfs_rmap_cur_agno(cur), bno, len,
 			unwritten, oinfo);
 
 	/*
@@ -1901,12 +1936,12 @@ xfs_rmap_unmap_shared(
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
 
@@ -1941,7 +1976,7 @@ xfs_rmap_map_shared(
 	xfs_owner_info_unpack(oinfo, &owner, &offset, &flags);
 	if (unwritten)
 		flags |= XFS_RMAP_UNWRITTEN;
-	trace_xfs_rmap_map(mp, cur->bc_private.a.agno, bno, len,
+	trace_xfs_rmap_map(mp, xfs_rmap_cur_agno(cur), bno, len,
 			unwritten, oinfo);
 
 	/* Is there a left record that abuts our range? */
@@ -1964,7 +1999,7 @@ xfs_rmap_map_shared(
 			goto out_error;
 		XFS_WANT_CORRUPTED_GOTO(mp, have_gt == 1, out_error);
 		trace_xfs_rmap_find_right_neighbor_result(cur->bc_mp,
-			cur->bc_private.a.agno, gtrec.rm_startblock,
+			xfs_rmap_cur_agno(cur), gtrec.rm_startblock,
 			gtrec.rm_blockcount, gtrec.rm_owner,
 			gtrec.rm_offset, gtrec.rm_flags);
 
@@ -2054,12 +2089,12 @@ xfs_rmap_map_shared(
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
 
@@ -2107,7 +2142,7 @@ xfs_rmap_query_range_helper(
 	struct xfs_rmap_irec			irec;
 	int					error;
 
-	error = xfs_rmap_btrec_to_irec(rec, &irec);
+	error = xfs_rmap_btrec_to_irec(cur, rec, &irec);
 	if (error)
 		return error;
 	return query->fn(cur, &irec, query->priv);
@@ -2203,13 +2238,12 @@ xfs_rmap_finish_one(
 	if (XFS_TEST_ERROR(false, mp,
 			XFS_ERRTAG_RMAP_FINISH_ONE))
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
index b536cdd596ec..2edb6e93860a 100644
--- a/fs/xfs/libxfs/xfs_rmap.h
+++ b/fs/xfs/libxfs/xfs_rmap.h
@@ -189,7 +189,7 @@ int xfs_rmap_lookup_le_range(struct xfs_btree_cur *cur, xfs_fsblock_t bno,
 int xfs_rmap_compare(const struct xfs_rmap_irec *a,
 		const struct xfs_rmap_irec *b);
 union xfs_btree_rec;
-int xfs_rmap_btrec_to_irec(union xfs_btree_rec *rec,
+int xfs_rmap_btrec_to_irec(struct xfs_btree_cur *cur, union xfs_btree_rec *rec,
 		struct xfs_rmap_irec *irec);
 int xfs_rmap_has_record(struct xfs_btree_cur *cur, xfs_fsblock_t bno,
 		xfs_filblks_t len, bool *exists);
diff --git a/fs/xfs/scrub/rmap.c b/fs/xfs/scrub/rmap.c
index c7a2401ad36f..753c8078ee80 100644
--- a/fs/xfs/scrub/rmap.c
+++ b/fs/xfs/scrub/rmap.c
@@ -112,7 +112,7 @@ xchk_rmapbt_rec(
 	bool			is_attr;
 	int			error;
 
-	error = xfs_rmap_btrec_to_irec(rec, &irec);
+	error = xfs_rmap_btrec_to_irec(bs->cur, rec, &irec);
 	if (!xchk_btree_process_error(bs->sc, bs->cur, 0, &error))
 		goto out;
 
