Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C78B338B
	for <linux-xfs@vger.kernel.org>; Mon,  1 Jan 2024 00:08:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gP0D6Adc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 922C9C433C7;
	Mon,  1 Jan 2024 00:08:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704067737;
	bh=s0csPSDHns2QxgiqM4VvcRJe4lF4KfowfcxCt6ehpak=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=gP0D6Adcl6UGA+UOVKQqz5dQF6sHoyM9HKmqMdZ7ka425H8/qdtQovb2aAuFlO4uI
	 KsN+GIAiXcggPgTYPtKwJ43kdOezzkIcoIMGTz1OGuZ/6kbqw9chN+nTROzHyzo0xX
	 AncVZvargDsfSbOgyyOTRElC4XV5bzJho9RwYbw/uSpyG8IWg5Vzxh7RnIyBMyma1C
	 Bi6eNT0gVcqjfg8PHNocXccOdDPxfggkjxlm/FvttHvR/yqdV8QxfZEj4u01dCxGcX
	 dXpP+TWY/pup4VTXZQ4ycQ65c4autLJU0abWDwKYJIujZ13OJoFj/vYMRiHes0dYG1
	 FgWKjBxAvZ1Wg==
Date: Sun, 31 Dec 2023 16:08:57 +9900
Subject: [PATCH 3/9] xfs: prepare rmap btree tracepoints for widening
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405014858.1815232.5660442449836109892.stgit@frogsfrogsfrogs>
In-Reply-To: <170405014813.1815232.16195473149230327174.stgit@frogsfrogsfrogs>
References: <170405014813.1815232.16195473149230327174.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Prepare the rmap btree tracepoints for use with realtime rmap btrees by
making them take the btree cursor object as a parameter.  This will save
us a lot of trouble later on.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_rmap.c |  184 +++++++++++++++++++++--------------------------------
 1 file changed, 73 insertions(+), 111 deletions(-)


diff --git a/libxfs/xfs_rmap.c b/libxfs/xfs_rmap.c
index 5b2cac8302a..3c4f705ce59 100644
--- a/libxfs/xfs_rmap.c
+++ b/libxfs/xfs_rmap.c
@@ -99,8 +99,7 @@ xfs_rmap_update(
 	union xfs_btree_rec	rec;
 	int			error;
 
-	trace_xfs_rmap_update(cur->bc_mp, cur->bc_ag.pag->pag_agno,
-			irec->rm_startblock, irec->rm_blockcount,
+	trace_xfs_rmap_update(cur, irec->rm_startblock, irec->rm_blockcount,
 			irec->rm_owner, irec->rm_offset, irec->rm_flags);
 
 	rec.rmap.rm_startblock = cpu_to_be32(irec->rm_startblock);
@@ -126,8 +125,7 @@ xfs_rmap_insert(
 	int			i;
 	int			error;
 
-	trace_xfs_rmap_insert(rcur->bc_mp, rcur->bc_ag.pag->pag_agno, agbno,
-			len, owner, offset, flags);
+	trace_xfs_rmap_insert(rcur, agbno, len, owner, offset, flags);
 
 	error = xfs_rmap_lookup_eq(rcur, agbno, len, owner, offset, flags, &i);
 	if (error)
@@ -169,8 +167,7 @@ xfs_rmap_delete(
 	int			i;
 	int			error;
 
-	trace_xfs_rmap_delete(rcur->bc_mp, rcur->bc_ag.pag->pag_agno, agbno,
-			len, owner, offset, flags);
+	trace_xfs_rmap_delete(rcur, agbno, len, owner, offset, flags);
 
 	error = xfs_rmap_lookup_eq(rcur, agbno, len, owner, offset, flags, &i);
 	if (error)
@@ -338,8 +335,7 @@ xfs_rmap_find_left_neighbor_helper(
 {
 	struct xfs_find_left_neighbor_info	*info = priv;
 
-	trace_xfs_rmap_find_left_neighbor_candidate(cur->bc_mp,
-			cur->bc_ag.pag->pag_agno, rec->rm_startblock,
+	trace_xfs_rmap_find_left_neighbor_candidate(cur, rec->rm_startblock,
 			rec->rm_blockcount, rec->rm_owner, rec->rm_offset,
 			rec->rm_flags);
 
@@ -389,8 +385,8 @@ xfs_rmap_find_left_neighbor(
 	info.high.rm_blockcount = 0;
 	info.irec = irec;
 
-	trace_xfs_rmap_find_left_neighbor_query(cur->bc_mp,
-			cur->bc_ag.pag->pag_agno, bno, 0, owner, offset, flags);
+	trace_xfs_rmap_find_left_neighbor_query(cur, bno, 0, owner, offset,
+			flags);
 
 	/*
 	 * Historically, we always used the range query to walk every reverse
@@ -421,8 +417,7 @@ xfs_rmap_find_left_neighbor(
 		return error;
 
 	*stat = 1;
-	trace_xfs_rmap_find_left_neighbor_result(cur->bc_mp,
-			cur->bc_ag.pag->pag_agno, irec->rm_startblock,
+	trace_xfs_rmap_find_left_neighbor_result(cur, irec->rm_startblock,
 			irec->rm_blockcount, irec->rm_owner, irec->rm_offset,
 			irec->rm_flags);
 	return 0;
@@ -437,8 +432,7 @@ xfs_rmap_lookup_le_range_helper(
 {
 	struct xfs_find_left_neighbor_info	*info = priv;
 
-	trace_xfs_rmap_lookup_le_range_candidate(cur->bc_mp,
-			cur->bc_ag.pag->pag_agno, rec->rm_startblock,
+	trace_xfs_rmap_lookup_le_range_candidate(cur, rec->rm_startblock,
 			rec->rm_blockcount, rec->rm_owner, rec->rm_offset,
 			rec->rm_flags);
 
@@ -485,8 +479,7 @@ xfs_rmap_lookup_le_range(
 	*stat = 0;
 	info.irec = irec;
 
-	trace_xfs_rmap_lookup_le_range(cur->bc_mp, cur->bc_ag.pag->pag_agno,
-			bno, 0, owner, offset, flags);
+	trace_xfs_rmap_lookup_le_range(cur, bno, 0, owner, offset, flags);
 
 	/*
 	 * Historically, we always used the range query to walk every reverse
@@ -517,8 +510,7 @@ xfs_rmap_lookup_le_range(
 		return error;
 
 	*stat = 1;
-	trace_xfs_rmap_lookup_le_range_result(cur->bc_mp,
-			cur->bc_ag.pag->pag_agno, irec->rm_startblock,
+	trace_xfs_rmap_lookup_le_range_result(cur, irec->rm_startblock,
 			irec->rm_blockcount, irec->rm_owner, irec->rm_offset,
 			irec->rm_flags);
 	return 0;
@@ -630,8 +622,7 @@ xfs_rmap_unmap(
 			(flags & XFS_RMAP_BMBT_BLOCK);
 	if (unwritten)
 		flags |= XFS_RMAP_UNWRITTEN;
-	trace_xfs_rmap_unmap(mp, cur->bc_ag.pag->pag_agno, bno, len,
-			unwritten, oinfo);
+	trace_xfs_rmap_unmap(cur, bno, len, unwritten, oinfo);
 
 	/*
 	 * We should always have a left record because there's a static record
@@ -647,10 +638,9 @@ xfs_rmap_unmap(
 		goto out_error;
 	}
 
-	trace_xfs_rmap_lookup_le_range_result(cur->bc_mp,
-			cur->bc_ag.pag->pag_agno, ltrec.rm_startblock,
-			ltrec.rm_blockcount, ltrec.rm_owner,
-			ltrec.rm_offset, ltrec.rm_flags);
+	trace_xfs_rmap_lookup_le_range_result(cur, ltrec.rm_startblock,
+			ltrec.rm_blockcount, ltrec.rm_owner, ltrec.rm_offset,
+			ltrec.rm_flags);
 	ltoff = ltrec.rm_offset;
 
 	/*
@@ -717,10 +707,9 @@ xfs_rmap_unmap(
 
 	if (ltrec.rm_startblock == bno && ltrec.rm_blockcount == len) {
 		/* exact match, simply remove the record from rmap tree */
-		trace_xfs_rmap_delete(mp, cur->bc_ag.pag->pag_agno,
-				ltrec.rm_startblock, ltrec.rm_blockcount,
-				ltrec.rm_owner, ltrec.rm_offset,
-				ltrec.rm_flags);
+		trace_xfs_rmap_delete(cur, ltrec.rm_startblock,
+				ltrec.rm_blockcount, ltrec.rm_owner,
+				ltrec.rm_offset, ltrec.rm_flags);
 		error = xfs_btree_delete(cur, &i);
 		if (error)
 			goto out_error;
@@ -796,8 +785,7 @@ xfs_rmap_unmap(
 		else
 			cur->bc_rec.r.rm_offset = offset + len;
 		cur->bc_rec.r.rm_flags = flags;
-		trace_xfs_rmap_insert(mp, cur->bc_ag.pag->pag_agno,
-				cur->bc_rec.r.rm_startblock,
+		trace_xfs_rmap_insert(cur, cur->bc_rec.r.rm_startblock,
 				cur->bc_rec.r.rm_blockcount,
 				cur->bc_rec.r.rm_owner,
 				cur->bc_rec.r.rm_offset,
@@ -808,8 +796,7 @@ xfs_rmap_unmap(
 	}
 
 out_done:
-	trace_xfs_rmap_unmap_done(mp, cur->bc_ag.pag->pag_agno, bno, len,
-			unwritten, oinfo);
+	trace_xfs_rmap_unmap_done(cur, bno, len, unwritten, oinfo);
 out_error:
 	if (error)
 		trace_xfs_rmap_unmap_error(cur, error, _RET_IP_);
@@ -973,8 +960,7 @@ xfs_rmap_map(
 			(flags & XFS_RMAP_BMBT_BLOCK);
 	if (unwritten)
 		flags |= XFS_RMAP_UNWRITTEN;
-	trace_xfs_rmap_map(mp, cur->bc_ag.pag->pag_agno, bno, len,
-			unwritten, oinfo);
+	trace_xfs_rmap_map(cur, bno, len, unwritten, oinfo);
 	ASSERT(!xfs_rmap_should_skip_owner_update(oinfo));
 
 	/*
@@ -987,8 +973,7 @@ xfs_rmap_map(
 	if (error)
 		goto out_error;
 	if (have_lt) {
-		trace_xfs_rmap_lookup_le_range_result(cur->bc_mp,
-				cur->bc_ag.pag->pag_agno, ltrec.rm_startblock,
+		trace_xfs_rmap_lookup_le_range_result(cur, ltrec.rm_startblock,
 				ltrec.rm_blockcount, ltrec.rm_owner,
 				ltrec.rm_offset, ltrec.rm_flags);
 
@@ -1026,10 +1011,10 @@ xfs_rmap_map(
 			error = -EFSCORRUPTED;
 			goto out_error;
 		}
-		trace_xfs_rmap_find_right_neighbor_result(cur->bc_mp,
-			cur->bc_ag.pag->pag_agno, gtrec.rm_startblock,
-			gtrec.rm_blockcount, gtrec.rm_owner,
-			gtrec.rm_offset, gtrec.rm_flags);
+		trace_xfs_rmap_find_right_neighbor_result(cur,
+				gtrec.rm_startblock, gtrec.rm_blockcount,
+				gtrec.rm_owner, gtrec.rm_offset,
+				gtrec.rm_flags);
 		if (!xfs_rmap_is_mergeable(&gtrec, owner, flags))
 			have_gt = 0;
 	}
@@ -1066,12 +1051,9 @@ xfs_rmap_map(
 			 * result: |rrrrrrrrrrrrrrrrrrrrrrrrrrrrr|
 			 */
 			ltrec.rm_blockcount += gtrec.rm_blockcount;
-			trace_xfs_rmap_delete(mp, cur->bc_ag.pag->pag_agno,
-					gtrec.rm_startblock,
-					gtrec.rm_blockcount,
-					gtrec.rm_owner,
-					gtrec.rm_offset,
-					gtrec.rm_flags);
+			trace_xfs_rmap_delete(cur, gtrec.rm_startblock,
+					gtrec.rm_blockcount, gtrec.rm_owner,
+					gtrec.rm_offset, gtrec.rm_flags);
 			error = xfs_btree_delete(cur, &i);
 			if (error)
 				goto out_error;
@@ -1118,8 +1100,7 @@ xfs_rmap_map(
 		cur->bc_rec.r.rm_owner = owner;
 		cur->bc_rec.r.rm_offset = offset;
 		cur->bc_rec.r.rm_flags = flags;
-		trace_xfs_rmap_insert(mp, cur->bc_ag.pag->pag_agno, bno, len,
-			owner, offset, flags);
+		trace_xfs_rmap_insert(cur, bno, len, owner, offset, flags);
 		error = xfs_btree_insert(cur, &i);
 		if (error)
 			goto out_error;
@@ -1130,8 +1111,7 @@ xfs_rmap_map(
 		}
 	}
 
-	trace_xfs_rmap_map_done(mp, cur->bc_ag.pag->pag_agno, bno, len,
-			unwritten, oinfo);
+	trace_xfs_rmap_map_done(cur, bno, len, unwritten, oinfo);
 out_error:
 	if (error)
 		trace_xfs_rmap_map_error(cur, error, _RET_IP_);
@@ -1208,8 +1188,7 @@ xfs_rmap_convert(
 			(flags & (XFS_RMAP_ATTR_FORK | XFS_RMAP_BMBT_BLOCK))));
 	oldext = unwritten ? XFS_RMAP_UNWRITTEN : 0;
 	new_endoff = offset + len;
-	trace_xfs_rmap_convert(mp, cur->bc_ag.pag->pag_agno, bno, len,
-			unwritten, oinfo);
+	trace_xfs_rmap_convert(cur, bno, len, unwritten, oinfo);
 
 	/*
 	 * For the initial lookup, look for an exact match or the left-adjacent
@@ -1225,10 +1204,9 @@ xfs_rmap_convert(
 		goto done;
 	}
 
-	trace_xfs_rmap_lookup_le_range_result(cur->bc_mp,
-			cur->bc_ag.pag->pag_agno, PREV.rm_startblock,
-			PREV.rm_blockcount, PREV.rm_owner,
-			PREV.rm_offset, PREV.rm_flags);
+	trace_xfs_rmap_lookup_le_range_result(cur, PREV.rm_startblock,
+			PREV.rm_blockcount, PREV.rm_owner, PREV.rm_offset,
+			PREV.rm_flags);
 
 	ASSERT(PREV.rm_offset <= offset);
 	ASSERT(PREV.rm_offset + PREV.rm_blockcount >= new_endoff);
@@ -1269,10 +1247,9 @@ xfs_rmap_convert(
 			error = -EFSCORRUPTED;
 			goto done;
 		}
-		trace_xfs_rmap_find_left_neighbor_result(cur->bc_mp,
-				cur->bc_ag.pag->pag_agno, LEFT.rm_startblock,
-				LEFT.rm_blockcount, LEFT.rm_owner,
-				LEFT.rm_offset, LEFT.rm_flags);
+		trace_xfs_rmap_find_left_neighbor_result(cur,
+				LEFT.rm_startblock, LEFT.rm_blockcount,
+				LEFT.rm_owner, LEFT.rm_offset, LEFT.rm_flags);
 		if (LEFT.rm_startblock + LEFT.rm_blockcount == bno &&
 		    LEFT.rm_offset + LEFT.rm_blockcount == offset &&
 		    xfs_rmap_is_mergeable(&LEFT, owner, newext))
@@ -1310,10 +1287,10 @@ xfs_rmap_convert(
 			error = -EFSCORRUPTED;
 			goto done;
 		}
-		trace_xfs_rmap_find_right_neighbor_result(cur->bc_mp,
-				cur->bc_ag.pag->pag_agno, RIGHT.rm_startblock,
-				RIGHT.rm_blockcount, RIGHT.rm_owner,
-				RIGHT.rm_offset, RIGHT.rm_flags);
+		trace_xfs_rmap_find_right_neighbor_result(cur,
+				RIGHT.rm_startblock, RIGHT.rm_blockcount,
+				RIGHT.rm_owner, RIGHT.rm_offset,
+				RIGHT.rm_flags);
 		if (bno + len == RIGHT.rm_startblock &&
 		    offset + len == RIGHT.rm_offset &&
 		    xfs_rmap_is_mergeable(&RIGHT, owner, newext))
@@ -1360,10 +1337,9 @@ xfs_rmap_convert(
 			error = -EFSCORRUPTED;
 			goto done;
 		}
-		trace_xfs_rmap_delete(mp, cur->bc_ag.pag->pag_agno,
-				RIGHT.rm_startblock, RIGHT.rm_blockcount,
-				RIGHT.rm_owner, RIGHT.rm_offset,
-				RIGHT.rm_flags);
+		trace_xfs_rmap_delete(cur, RIGHT.rm_startblock,
+				RIGHT.rm_blockcount, RIGHT.rm_owner,
+				RIGHT.rm_offset, RIGHT.rm_flags);
 		error = xfs_btree_delete(cur, &i);
 		if (error)
 			goto done;
@@ -1380,10 +1356,9 @@ xfs_rmap_convert(
 			error = -EFSCORRUPTED;
 			goto done;
 		}
-		trace_xfs_rmap_delete(mp, cur->bc_ag.pag->pag_agno,
-				PREV.rm_startblock, PREV.rm_blockcount,
-				PREV.rm_owner, PREV.rm_offset,
-				PREV.rm_flags);
+		trace_xfs_rmap_delete(cur, PREV.rm_startblock,
+				PREV.rm_blockcount, PREV.rm_owner,
+				PREV.rm_offset, PREV.rm_flags);
 		error = xfs_btree_delete(cur, &i);
 		if (error)
 			goto done;
@@ -1412,10 +1387,9 @@ xfs_rmap_convert(
 		 * Setting all of a previous oldext extent to newext.
 		 * The left neighbor is contiguous, the right is not.
 		 */
-		trace_xfs_rmap_delete(mp, cur->bc_ag.pag->pag_agno,
-				PREV.rm_startblock, PREV.rm_blockcount,
-				PREV.rm_owner, PREV.rm_offset,
-				PREV.rm_flags);
+		trace_xfs_rmap_delete(cur, PREV.rm_startblock,
+				PREV.rm_blockcount, PREV.rm_owner,
+				PREV.rm_offset, PREV.rm_flags);
 		error = xfs_btree_delete(cur, &i);
 		if (error)
 			goto done;
@@ -1452,10 +1426,9 @@ xfs_rmap_convert(
 			error = -EFSCORRUPTED;
 			goto done;
 		}
-		trace_xfs_rmap_delete(mp, cur->bc_ag.pag->pag_agno,
-				RIGHT.rm_startblock, RIGHT.rm_blockcount,
-				RIGHT.rm_owner, RIGHT.rm_offset,
-				RIGHT.rm_flags);
+		trace_xfs_rmap_delete(cur, RIGHT.rm_startblock,
+				RIGHT.rm_blockcount, RIGHT.rm_owner,
+				RIGHT.rm_offset, RIGHT.rm_flags);
 		error = xfs_btree_delete(cur, &i);
 		if (error)
 			goto done;
@@ -1533,8 +1506,7 @@ xfs_rmap_convert(
 		NEW.rm_blockcount = len;
 		NEW.rm_flags = newext;
 		cur->bc_rec.r = NEW;
-		trace_xfs_rmap_insert(mp, cur->bc_ag.pag->pag_agno, bno,
-				len, owner, offset, newext);
+		trace_xfs_rmap_insert(cur, bno, len, owner, offset, newext);
 		error = xfs_btree_insert(cur, &i);
 		if (error)
 			goto done;
@@ -1592,8 +1564,7 @@ xfs_rmap_convert(
 		NEW.rm_blockcount = len;
 		NEW.rm_flags = newext;
 		cur->bc_rec.r = NEW;
-		trace_xfs_rmap_insert(mp, cur->bc_ag.pag->pag_agno, bno,
-				len, owner, offset, newext);
+		trace_xfs_rmap_insert(cur, bno, len, owner, offset, newext);
 		error = xfs_btree_insert(cur, &i);
 		if (error)
 			goto done;
@@ -1624,9 +1595,8 @@ xfs_rmap_convert(
 		NEW = PREV;
 		NEW.rm_blockcount = offset - PREV.rm_offset;
 		cur->bc_rec.r = NEW;
-		trace_xfs_rmap_insert(mp, cur->bc_ag.pag->pag_agno,
-				NEW.rm_startblock, NEW.rm_blockcount,
-				NEW.rm_owner, NEW.rm_offset,
+		trace_xfs_rmap_insert(cur, NEW.rm_startblock,
+				NEW.rm_blockcount, NEW.rm_owner, NEW.rm_offset,
 				NEW.rm_flags);
 		error = xfs_btree_insert(cur, &i);
 		if (error)
@@ -1653,8 +1623,7 @@ xfs_rmap_convert(
 		/* new middle extent - newext */
 		cur->bc_rec.r.rm_flags &= ~XFS_RMAP_UNWRITTEN;
 		cur->bc_rec.r.rm_flags |= newext;
-		trace_xfs_rmap_insert(mp, cur->bc_ag.pag->pag_agno, bno, len,
-				owner, offset, newext);
+		trace_xfs_rmap_insert(cur, bno, len, owner, offset, newext);
 		error = xfs_btree_insert(cur, &i);
 		if (error)
 			goto done;
@@ -1678,8 +1647,7 @@ xfs_rmap_convert(
 		ASSERT(0);
 	}
 
-	trace_xfs_rmap_convert_done(mp, cur->bc_ag.pag->pag_agno, bno, len,
-			unwritten, oinfo);
+	trace_xfs_rmap_convert_done(cur, bno, len, unwritten, oinfo);
 done:
 	if (error)
 		trace_xfs_rmap_convert_error(cur, error, _RET_IP_);
@@ -1718,8 +1686,7 @@ xfs_rmap_convert_shared(
 			(flags & (XFS_RMAP_ATTR_FORK | XFS_RMAP_BMBT_BLOCK))));
 	oldext = unwritten ? XFS_RMAP_UNWRITTEN : 0;
 	new_endoff = offset + len;
-	trace_xfs_rmap_convert(mp, cur->bc_ag.pag->pag_agno, bno, len,
-			unwritten, oinfo);
+	trace_xfs_rmap_convert(cur, bno, len, unwritten, oinfo);
 
 	/*
 	 * For the initial lookup, look for and exact match or the left-adjacent
@@ -1788,10 +1755,10 @@ xfs_rmap_convert_shared(
 			error = -EFSCORRUPTED;
 			goto done;
 		}
-		trace_xfs_rmap_find_right_neighbor_result(cur->bc_mp,
-				cur->bc_ag.pag->pag_agno, RIGHT.rm_startblock,
-				RIGHT.rm_blockcount, RIGHT.rm_owner,
-				RIGHT.rm_offset, RIGHT.rm_flags);
+		trace_xfs_rmap_find_right_neighbor_result(cur,
+				RIGHT.rm_startblock, RIGHT.rm_blockcount,
+				RIGHT.rm_owner, RIGHT.rm_offset,
+				RIGHT.rm_flags);
 		if (xfs_rmap_is_mergeable(&RIGHT, owner, newext))
 			state |= RMAP_RIGHT_CONTIG;
 	}
@@ -2103,8 +2070,7 @@ xfs_rmap_convert_shared(
 		ASSERT(0);
 	}
 
-	trace_xfs_rmap_convert_done(mp, cur->bc_ag.pag->pag_agno, bno, len,
-			unwritten, oinfo);
+	trace_xfs_rmap_convert_done(cur, bno, len, unwritten, oinfo);
 done:
 	if (error)
 		trace_xfs_rmap_convert_error(cur, error, _RET_IP_);
@@ -2145,8 +2111,7 @@ xfs_rmap_unmap_shared(
 	xfs_owner_info_unpack(oinfo, &owner, &offset, &flags);
 	if (unwritten)
 		flags |= XFS_RMAP_UNWRITTEN;
-	trace_xfs_rmap_unmap(mp, cur->bc_ag.pag->pag_agno, bno, len,
-			unwritten, oinfo);
+	trace_xfs_rmap_unmap(cur, bno, len, unwritten, oinfo);
 
 	/*
 	 * We should always have a left record because there's a static record
@@ -2302,8 +2267,7 @@ xfs_rmap_unmap_shared(
 			goto out_error;
 	}
 
-	trace_xfs_rmap_unmap_done(mp, cur->bc_ag.pag->pag_agno, bno, len,
-			unwritten, oinfo);
+	trace_xfs_rmap_unmap_done(cur, bno, len, unwritten, oinfo);
 out_error:
 	if (error)
 		trace_xfs_rmap_unmap_error(cur, error, _RET_IP_);
@@ -2341,8 +2305,7 @@ xfs_rmap_map_shared(
 	xfs_owner_info_unpack(oinfo, &owner, &offset, &flags);
 	if (unwritten)
 		flags |= XFS_RMAP_UNWRITTEN;
-	trace_xfs_rmap_map(mp, cur->bc_ag.pag->pag_agno, bno, len,
-			unwritten, oinfo);
+	trace_xfs_rmap_map(cur, bno, len, unwritten, oinfo);
 
 	/* Is there a left record that abuts our range? */
 	error = xfs_rmap_find_left_neighbor(cur, bno, owner, offset, flags,
@@ -2367,10 +2330,10 @@ xfs_rmap_map_shared(
 			error = -EFSCORRUPTED;
 			goto out_error;
 		}
-		trace_xfs_rmap_find_right_neighbor_result(cur->bc_mp,
-			cur->bc_ag.pag->pag_agno, gtrec.rm_startblock,
-			gtrec.rm_blockcount, gtrec.rm_owner,
-			gtrec.rm_offset, gtrec.rm_flags);
+		trace_xfs_rmap_find_right_neighbor_result(cur,
+				gtrec.rm_startblock, gtrec.rm_blockcount,
+				gtrec.rm_owner, gtrec.rm_offset,
+				gtrec.rm_flags);
 
 		if (!xfs_rmap_is_mergeable(&gtrec, owner, flags))
 			have_gt = 0;
@@ -2462,8 +2425,7 @@ xfs_rmap_map_shared(
 			goto out_error;
 	}
 
-	trace_xfs_rmap_map_done(mp, cur->bc_ag.pag->pag_agno, bno, len,
-			unwritten, oinfo);
+	trace_xfs_rmap_map_done(cur, bno, len, unwritten, oinfo);
 out_error:
 	if (error)
 		trace_xfs_rmap_map_error(cur, error, _RET_IP_);

