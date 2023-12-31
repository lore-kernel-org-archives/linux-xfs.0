Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEF9BBA2E
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 21:29:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DlzIX/fe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AE96C433C8;
	Sun, 31 Dec 2023 21:29:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704058198;
	bh=3+6JQsiJQPqhzFJ4DgwkMRcfIuBav9gJgZra2v+kXOo=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=DlzIX/fe8rKE/AQ/u78D89pkXYrZANyhoFg6hlNafLHZGDHA4hIkteN7XfQHzSwxQ
	 km+6kb6hJVhAEUUeSeM43kX8RK3pBMLAdEnx0UgMc1afUYTVMwu+nuCsd+QHUHON8b
	 yL/XBG2hP+8XdfPQTwO6z4rnzyu9xnLV0p7TbjH2fZSATMEPDDG16uSUIoKYqXX3za
	 r3uVc5A4iBsU3GZDZPekKaGSP49FXCC2wbZLH4mDfPNyLMxeb1u904/WxpHbGf0EFE
	 X3vlVqsZsocrU0xLw8pcrRIw3NqgCWOfBprgVIrBP9nIA3Z90tM+p716g7Exk6QXCK
	 W2gZHEEjsdPRw==
Date: Sun, 31 Dec 2023 13:29:57 -0800
Subject: [PATCH 03/10] xfs: prepare rmap btree tracepoints for widening
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404849282.1764703.13750713447652216789.stgit@frogsfrogsfrogs>
In-Reply-To: <170404849212.1764703.16534369828563181378.stgit@frogsfrogsfrogs>
References: <170404849212.1764703.16534369828563181378.stgit@frogsfrogsfrogs>
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
 fs/xfs/libxfs/xfs_rmap.c |  184 ++++++++++++++++++----------------------------
 fs/xfs/xfs_trace.h       |   24 +++---
 2 files changed, 85 insertions(+), 123 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_rmap.c b/fs/xfs/libxfs/xfs_rmap.c
index 813c2f77c9b3d..b8425ae7807cc 100644
--- a/fs/xfs/libxfs/xfs_rmap.c
+++ b/fs/xfs/libxfs/xfs_rmap.c
@@ -100,8 +100,7 @@ xfs_rmap_update(
 	union xfs_btree_rec	rec;
 	int			error;
 
-	trace_xfs_rmap_update(cur->bc_mp, cur->bc_ag.pag->pag_agno,
-			irec->rm_startblock, irec->rm_blockcount,
+	trace_xfs_rmap_update(cur, irec->rm_startblock, irec->rm_blockcount,
 			irec->rm_owner, irec->rm_offset, irec->rm_flags);
 
 	rec.rmap.rm_startblock = cpu_to_be32(irec->rm_startblock);
@@ -127,8 +126,7 @@ xfs_rmap_insert(
 	int			i;
 	int			error;
 
-	trace_xfs_rmap_insert(rcur->bc_mp, rcur->bc_ag.pag->pag_agno, agbno,
-			len, owner, offset, flags);
+	trace_xfs_rmap_insert(rcur, agbno, len, owner, offset, flags);
 
 	error = xfs_rmap_lookup_eq(rcur, agbno, len, owner, offset, flags, &i);
 	if (error)
@@ -170,8 +168,7 @@ xfs_rmap_delete(
 	int			i;
 	int			error;
 
-	trace_xfs_rmap_delete(rcur->bc_mp, rcur->bc_ag.pag->pag_agno, agbno,
-			len, owner, offset, flags);
+	trace_xfs_rmap_delete(rcur, agbno, len, owner, offset, flags);
 
 	error = xfs_rmap_lookup_eq(rcur, agbno, len, owner, offset, flags, &i);
 	if (error)
@@ -339,8 +336,7 @@ xfs_rmap_find_left_neighbor_helper(
 {
 	struct xfs_find_left_neighbor_info	*info = priv;
 
-	trace_xfs_rmap_find_left_neighbor_candidate(cur->bc_mp,
-			cur->bc_ag.pag->pag_agno, rec->rm_startblock,
+	trace_xfs_rmap_find_left_neighbor_candidate(cur, rec->rm_startblock,
 			rec->rm_blockcount, rec->rm_owner, rec->rm_offset,
 			rec->rm_flags);
 
@@ -390,8 +386,8 @@ xfs_rmap_find_left_neighbor(
 	info.high.rm_blockcount = 0;
 	info.irec = irec;
 
-	trace_xfs_rmap_find_left_neighbor_query(cur->bc_mp,
-			cur->bc_ag.pag->pag_agno, bno, 0, owner, offset, flags);
+	trace_xfs_rmap_find_left_neighbor_query(cur, bno, 0, owner, offset,
+			flags);
 
 	/*
 	 * Historically, we always used the range query to walk every reverse
@@ -422,8 +418,7 @@ xfs_rmap_find_left_neighbor(
 		return error;
 
 	*stat = 1;
-	trace_xfs_rmap_find_left_neighbor_result(cur->bc_mp,
-			cur->bc_ag.pag->pag_agno, irec->rm_startblock,
+	trace_xfs_rmap_find_left_neighbor_result(cur, irec->rm_startblock,
 			irec->rm_blockcount, irec->rm_owner, irec->rm_offset,
 			irec->rm_flags);
 	return 0;
@@ -438,8 +433,7 @@ xfs_rmap_lookup_le_range_helper(
 {
 	struct xfs_find_left_neighbor_info	*info = priv;
 
-	trace_xfs_rmap_lookup_le_range_candidate(cur->bc_mp,
-			cur->bc_ag.pag->pag_agno, rec->rm_startblock,
+	trace_xfs_rmap_lookup_le_range_candidate(cur, rec->rm_startblock,
 			rec->rm_blockcount, rec->rm_owner, rec->rm_offset,
 			rec->rm_flags);
 
@@ -486,8 +480,7 @@ xfs_rmap_lookup_le_range(
 	*stat = 0;
 	info.irec = irec;
 
-	trace_xfs_rmap_lookup_le_range(cur->bc_mp, cur->bc_ag.pag->pag_agno,
-			bno, 0, owner, offset, flags);
+	trace_xfs_rmap_lookup_le_range(cur, bno, 0, owner, offset, flags);
 
 	/*
 	 * Historically, we always used the range query to walk every reverse
@@ -518,8 +511,7 @@ xfs_rmap_lookup_le_range(
 		return error;
 
 	*stat = 1;
-	trace_xfs_rmap_lookup_le_range_result(cur->bc_mp,
-			cur->bc_ag.pag->pag_agno, irec->rm_startblock,
+	trace_xfs_rmap_lookup_le_range_result(cur, irec->rm_startblock,
 			irec->rm_blockcount, irec->rm_owner, irec->rm_offset,
 			irec->rm_flags);
 	return 0;
@@ -631,8 +623,7 @@ xfs_rmap_unmap(
 			(flags & XFS_RMAP_BMBT_BLOCK);
 	if (unwritten)
 		flags |= XFS_RMAP_UNWRITTEN;
-	trace_xfs_rmap_unmap(mp, cur->bc_ag.pag->pag_agno, bno, len,
-			unwritten, oinfo);
+	trace_xfs_rmap_unmap(cur, bno, len, unwritten, oinfo);
 
 	/*
 	 * We should always have a left record because there's a static record
@@ -648,10 +639,9 @@ xfs_rmap_unmap(
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
@@ -718,10 +708,9 @@ xfs_rmap_unmap(
 
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
@@ -797,8 +786,7 @@ xfs_rmap_unmap(
 		else
 			cur->bc_rec.r.rm_offset = offset + len;
 		cur->bc_rec.r.rm_flags = flags;
-		trace_xfs_rmap_insert(mp, cur->bc_ag.pag->pag_agno,
-				cur->bc_rec.r.rm_startblock,
+		trace_xfs_rmap_insert(cur, cur->bc_rec.r.rm_startblock,
 				cur->bc_rec.r.rm_blockcount,
 				cur->bc_rec.r.rm_owner,
 				cur->bc_rec.r.rm_offset,
@@ -809,8 +797,7 @@ xfs_rmap_unmap(
 	}
 
 out_done:
-	trace_xfs_rmap_unmap_done(mp, cur->bc_ag.pag->pag_agno, bno, len,
-			unwritten, oinfo);
+	trace_xfs_rmap_unmap_done(cur, bno, len, unwritten, oinfo);
 out_error:
 	if (error)
 		trace_xfs_rmap_unmap_error(cur, error, _RET_IP_);
@@ -974,8 +961,7 @@ xfs_rmap_map(
 			(flags & XFS_RMAP_BMBT_BLOCK);
 	if (unwritten)
 		flags |= XFS_RMAP_UNWRITTEN;
-	trace_xfs_rmap_map(mp, cur->bc_ag.pag->pag_agno, bno, len,
-			unwritten, oinfo);
+	trace_xfs_rmap_map(cur, bno, len, unwritten, oinfo);
 	ASSERT(!xfs_rmap_should_skip_owner_update(oinfo));
 
 	/*
@@ -988,8 +974,7 @@ xfs_rmap_map(
 	if (error)
 		goto out_error;
 	if (have_lt) {
-		trace_xfs_rmap_lookup_le_range_result(cur->bc_mp,
-				cur->bc_ag.pag->pag_agno, ltrec.rm_startblock,
+		trace_xfs_rmap_lookup_le_range_result(cur, ltrec.rm_startblock,
 				ltrec.rm_blockcount, ltrec.rm_owner,
 				ltrec.rm_offset, ltrec.rm_flags);
 
@@ -1027,10 +1012,10 @@ xfs_rmap_map(
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
@@ -1067,12 +1052,9 @@ xfs_rmap_map(
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
@@ -1119,8 +1101,7 @@ xfs_rmap_map(
 		cur->bc_rec.r.rm_owner = owner;
 		cur->bc_rec.r.rm_offset = offset;
 		cur->bc_rec.r.rm_flags = flags;
-		trace_xfs_rmap_insert(mp, cur->bc_ag.pag->pag_agno, bno, len,
-			owner, offset, flags);
+		trace_xfs_rmap_insert(cur, bno, len, owner, offset, flags);
 		error = xfs_btree_insert(cur, &i);
 		if (error)
 			goto out_error;
@@ -1131,8 +1112,7 @@ xfs_rmap_map(
 		}
 	}
 
-	trace_xfs_rmap_map_done(mp, cur->bc_ag.pag->pag_agno, bno, len,
-			unwritten, oinfo);
+	trace_xfs_rmap_map_done(cur, bno, len, unwritten, oinfo);
 out_error:
 	if (error)
 		trace_xfs_rmap_map_error(cur, error, _RET_IP_);
@@ -1209,8 +1189,7 @@ xfs_rmap_convert(
 			(flags & (XFS_RMAP_ATTR_FORK | XFS_RMAP_BMBT_BLOCK))));
 	oldext = unwritten ? XFS_RMAP_UNWRITTEN : 0;
 	new_endoff = offset + len;
-	trace_xfs_rmap_convert(mp, cur->bc_ag.pag->pag_agno, bno, len,
-			unwritten, oinfo);
+	trace_xfs_rmap_convert(cur, bno, len, unwritten, oinfo);
 
 	/*
 	 * For the initial lookup, look for an exact match or the left-adjacent
@@ -1226,10 +1205,9 @@ xfs_rmap_convert(
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
@@ -1270,10 +1248,9 @@ xfs_rmap_convert(
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
@@ -1311,10 +1288,10 @@ xfs_rmap_convert(
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
@@ -1361,10 +1338,9 @@ xfs_rmap_convert(
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
@@ -1381,10 +1357,9 @@ xfs_rmap_convert(
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
@@ -1413,10 +1388,9 @@ xfs_rmap_convert(
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
@@ -1453,10 +1427,9 @@ xfs_rmap_convert(
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
@@ -1534,8 +1507,7 @@ xfs_rmap_convert(
 		NEW.rm_blockcount = len;
 		NEW.rm_flags = newext;
 		cur->bc_rec.r = NEW;
-		trace_xfs_rmap_insert(mp, cur->bc_ag.pag->pag_agno, bno,
-				len, owner, offset, newext);
+		trace_xfs_rmap_insert(cur, bno, len, owner, offset, newext);
 		error = xfs_btree_insert(cur, &i);
 		if (error)
 			goto done;
@@ -1593,8 +1565,7 @@ xfs_rmap_convert(
 		NEW.rm_blockcount = len;
 		NEW.rm_flags = newext;
 		cur->bc_rec.r = NEW;
-		trace_xfs_rmap_insert(mp, cur->bc_ag.pag->pag_agno, bno,
-				len, owner, offset, newext);
+		trace_xfs_rmap_insert(cur, bno, len, owner, offset, newext);
 		error = xfs_btree_insert(cur, &i);
 		if (error)
 			goto done;
@@ -1625,9 +1596,8 @@ xfs_rmap_convert(
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
@@ -1654,8 +1624,7 @@ xfs_rmap_convert(
 		/* new middle extent - newext */
 		cur->bc_rec.r.rm_flags &= ~XFS_RMAP_UNWRITTEN;
 		cur->bc_rec.r.rm_flags |= newext;
-		trace_xfs_rmap_insert(mp, cur->bc_ag.pag->pag_agno, bno, len,
-				owner, offset, newext);
+		trace_xfs_rmap_insert(cur, bno, len, owner, offset, newext);
 		error = xfs_btree_insert(cur, &i);
 		if (error)
 			goto done;
@@ -1679,8 +1648,7 @@ xfs_rmap_convert(
 		ASSERT(0);
 	}
 
-	trace_xfs_rmap_convert_done(mp, cur->bc_ag.pag->pag_agno, bno, len,
-			unwritten, oinfo);
+	trace_xfs_rmap_convert_done(cur, bno, len, unwritten, oinfo);
 done:
 	if (error)
 		trace_xfs_rmap_convert_error(cur, error, _RET_IP_);
@@ -1719,8 +1687,7 @@ xfs_rmap_convert_shared(
 			(flags & (XFS_RMAP_ATTR_FORK | XFS_RMAP_BMBT_BLOCK))));
 	oldext = unwritten ? XFS_RMAP_UNWRITTEN : 0;
 	new_endoff = offset + len;
-	trace_xfs_rmap_convert(mp, cur->bc_ag.pag->pag_agno, bno, len,
-			unwritten, oinfo);
+	trace_xfs_rmap_convert(cur, bno, len, unwritten, oinfo);
 
 	/*
 	 * For the initial lookup, look for and exact match or the left-adjacent
@@ -1789,10 +1756,10 @@ xfs_rmap_convert_shared(
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
@@ -2104,8 +2071,7 @@ xfs_rmap_convert_shared(
 		ASSERT(0);
 	}
 
-	trace_xfs_rmap_convert_done(mp, cur->bc_ag.pag->pag_agno, bno, len,
-			unwritten, oinfo);
+	trace_xfs_rmap_convert_done(cur, bno, len, unwritten, oinfo);
 done:
 	if (error)
 		trace_xfs_rmap_convert_error(cur, error, _RET_IP_);
@@ -2146,8 +2112,7 @@ xfs_rmap_unmap_shared(
 	xfs_owner_info_unpack(oinfo, &owner, &offset, &flags);
 	if (unwritten)
 		flags |= XFS_RMAP_UNWRITTEN;
-	trace_xfs_rmap_unmap(mp, cur->bc_ag.pag->pag_agno, bno, len,
-			unwritten, oinfo);
+	trace_xfs_rmap_unmap(cur, bno, len, unwritten, oinfo);
 
 	/*
 	 * We should always have a left record because there's a static record
@@ -2303,8 +2268,7 @@ xfs_rmap_unmap_shared(
 			goto out_error;
 	}
 
-	trace_xfs_rmap_unmap_done(mp, cur->bc_ag.pag->pag_agno, bno, len,
-			unwritten, oinfo);
+	trace_xfs_rmap_unmap_done(cur, bno, len, unwritten, oinfo);
 out_error:
 	if (error)
 		trace_xfs_rmap_unmap_error(cur, error, _RET_IP_);
@@ -2342,8 +2306,7 @@ xfs_rmap_map_shared(
 	xfs_owner_info_unpack(oinfo, &owner, &offset, &flags);
 	if (unwritten)
 		flags |= XFS_RMAP_UNWRITTEN;
-	trace_xfs_rmap_map(mp, cur->bc_ag.pag->pag_agno, bno, len,
-			unwritten, oinfo);
+	trace_xfs_rmap_map(cur, bno, len, unwritten, oinfo);
 
 	/* Is there a left record that abuts our range? */
 	error = xfs_rmap_find_left_neighbor(cur, bno, owner, offset, flags,
@@ -2368,10 +2331,10 @@ xfs_rmap_map_shared(
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
@@ -2463,8 +2426,7 @@ xfs_rmap_map_shared(
 			goto out_error;
 	}
 
-	trace_xfs_rmap_map_done(mp, cur->bc_ag.pag->pag_agno, bno, len,
-			unwritten, oinfo);
+	trace_xfs_rmap_map_done(cur, bno, len, unwritten, oinfo);
 out_error:
 	if (error)
 		trace_xfs_rmap_map_error(cur, error, _RET_IP_);
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index a7c752023f662..67c73e1d9b95c 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -2838,10 +2838,10 @@ DEFINE_DEFER_PENDING_ITEM_EVENT(xfs_defer_finish_item);
 
 /* rmap tracepoints */
 DECLARE_EVENT_CLASS(xfs_rmap_class,
-	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno,
+	TP_PROTO(struct xfs_btree_cur *cur,
 		 xfs_agblock_t agbno, xfs_extlen_t len, bool unwritten,
 		 const struct xfs_owner_info *oinfo),
-	TP_ARGS(mp, agno, agbno, len, unwritten, oinfo),
+	TP_ARGS(cur, agbno, len, unwritten, oinfo),
 	TP_STRUCT__entry(
 		__field(dev_t, dev)
 		__field(xfs_agnumber_t, agno)
@@ -2852,8 +2852,8 @@ DECLARE_EVENT_CLASS(xfs_rmap_class,
 		__field(unsigned long, flags)
 	),
 	TP_fast_assign(
-		__entry->dev = mp->m_super->s_dev;
-		__entry->agno = agno;
+		__entry->dev = cur->bc_mp->m_super->s_dev;
+		__entry->agno = cur->bc_ag.pag->pag_agno;
 		__entry->agbno = agbno;
 		__entry->len = len;
 		__entry->owner = oinfo->oi_owner;
@@ -2873,10 +2873,10 @@ DECLARE_EVENT_CLASS(xfs_rmap_class,
 );
 #define DEFINE_RMAP_EVENT(name) \
 DEFINE_EVENT(xfs_rmap_class, name, \
-	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno, \
+	TP_PROTO(struct xfs_btree_cur *cur, \
 		 xfs_agblock_t agbno, xfs_extlen_t len, bool unwritten, \
 		 const struct xfs_owner_info *oinfo), \
-	TP_ARGS(mp, agno, agbno, len, unwritten, oinfo))
+	TP_ARGS(cur, agbno, len, unwritten, oinfo))
 
 /* btree cursor error/%ip tracepoint class */
 DECLARE_EVENT_CLASS(xfs_btree_error_class,
@@ -2961,10 +2961,10 @@ TRACE_EVENT(xfs_rmap_convert_state,
 );
 
 DECLARE_EVENT_CLASS(xfs_rmapbt_class,
-	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno,
+	TP_PROTO(struct xfs_btree_cur *cur,
 		 xfs_agblock_t agbno, xfs_extlen_t len,
 		 uint64_t owner, uint64_t offset, unsigned int flags),
-	TP_ARGS(mp, agno, agbno, len, owner, offset, flags),
+	TP_ARGS(cur, agbno, len, owner, offset, flags),
 	TP_STRUCT__entry(
 		__field(dev_t, dev)
 		__field(xfs_agnumber_t, agno)
@@ -2975,8 +2975,8 @@ DECLARE_EVENT_CLASS(xfs_rmapbt_class,
 		__field(unsigned int, flags)
 	),
 	TP_fast_assign(
-		__entry->dev = mp->m_super->s_dev;
-		__entry->agno = agno;
+		__entry->dev = cur->bc_mp->m_super->s_dev;
+		__entry->agno = cur->bc_ag.pag->pag_agno;
 		__entry->agbno = agbno;
 		__entry->len = len;
 		__entry->owner = owner;
@@ -2994,10 +2994,10 @@ DECLARE_EVENT_CLASS(xfs_rmapbt_class,
 );
 #define DEFINE_RMAPBT_EVENT(name) \
 DEFINE_EVENT(xfs_rmapbt_class, name, \
-	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno, \
+	TP_PROTO(struct xfs_btree_cur *cur, \
 		 xfs_agblock_t agbno, xfs_extlen_t len, \
 		 uint64_t owner, uint64_t offset, unsigned int flags), \
-	TP_ARGS(mp, agno, agbno, len, owner, offset, flags))
+	TP_ARGS(cur, agbno, len, owner, offset, flags))
 
 DECLARE_EVENT_CLASS(xfs_rmap_deferred_class,
 	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno,

