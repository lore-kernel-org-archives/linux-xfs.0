Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A80475227
	for <linux-xfs@vger.kernel.org>; Wed,  2 Oct 2024 01:18:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727831926; cv=none; b=PoD/AnPgyfoWWz5SRCqeMcnGZa6uOGFAX/jSFnofRNYMty6PwcLzbxJu8TzyijDFTwibkZaa6JDpxhNmr0oHKxWJUMMdOyhDiEAF5tJ1vOBcqd/nLpEZRjhyGbOLyn52hfUqW7Lajxuzu75EXktn96qRq7F4dI8oPXXRwfqlAUM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727831926; c=relaxed/simple;
	bh=04dpo7NvQnA/VvmkVlnKJNANyn0vDjKA7fTQUZtOrYA=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mXerGNuayIpGAoAtXQF2Z+bBptJlamtIdVvzyA/+BQ9qBTj7e5G/yghG/WtfFZnVQXs8wY+v1rORaK3SUe4SPx4VK8Sx2+Gbtrs80+vaPFdn3HnfnuZihquTSNpgj0WBQNs0sbTy0mXXY0CP+VzTdSV1fIabUV1nfKIxXAWMhsA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Sl7D1m6O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Sl7D1m6O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8186AC4CEC6;
	Wed,  2 Oct 2024 01:18:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727831926;
	bh=04dpo7NvQnA/VvmkVlnKJNANyn0vDjKA7fTQUZtOrYA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Sl7D1m6OIinRb+ofzlcGP3VlvPO+jLl0zZSKCfmBJ9+hGVsSOkhLLYSqzZ21a1HVp
	 IwVNNDx01nNARZZPpNPN9jMj473Kblb+oC7vW6ZPGC1KgVWyQjzhx4rGf38Rr/ElU1
	 m0MV2eVGK8Uxl3C/J7KgK6gLNLtcIDJmA4wInqyG0NyO7ee30cBewJFriZ2r2KDpDz
	 kIvJVAEiMJyLFAoDqIFedOrvSpeYoU1h9wbXJ2C6mezjwaqBzcM4GXP6DMb/31B049
	 T0wXL9bTubwAyp2iIqvBKRWeL4pHQCnCoTv7kug58t7ym8xeas+B2lhARttf0SA8to
	 WdG8j2gjDKX0A==
Date: Tue, 01 Oct 2024 18:18:46 -0700
Subject: [PATCH 42/64] xfs: pass btree cursors to rmap btree tracepoints
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <172783102414.4036371.4136328646372372811.stgit@frogsfrogsfrogs>
In-Reply-To: <172783101710.4036371.10020616537589726441.stgit@frogsfrogsfrogs>
References: <172783101710.4036371.10020616537589726441.stgit@frogsfrogsfrogs>
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

Source kernel commit: 47492ed124219b37acf65cd931c1e45d5bc0c274

Prepare the rmap btree tracepoints for use with realtime rmap btrees by
making them take the btree cursor object as a parameter.  This will save
us a lot of trouble later on.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_rmap.c |  184 +++++++++++++++++++++--------------------------------
 1 file changed, 73 insertions(+), 111 deletions(-)


diff --git a/libxfs/xfs_rmap.c b/libxfs/xfs_rmap.c
index 74a30ed81..46bee57cc 100644
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
@@ -982,8 +969,7 @@ xfs_rmap_map(
 			(flags & XFS_RMAP_BMBT_BLOCK);
 	if (unwritten)
 		flags |= XFS_RMAP_UNWRITTEN;
-	trace_xfs_rmap_map(mp, cur->bc_ag.pag->pag_agno, bno, len,
-			unwritten, oinfo);
+	trace_xfs_rmap_map(cur, bno, len, unwritten, oinfo);
 	ASSERT(!xfs_rmap_should_skip_owner_update(oinfo));
 
 	/*
@@ -996,8 +982,7 @@ xfs_rmap_map(
 	if (error)
 		goto out_error;
 	if (have_lt) {
-		trace_xfs_rmap_lookup_le_range_result(cur->bc_mp,
-				cur->bc_ag.pag->pag_agno, ltrec.rm_startblock,
+		trace_xfs_rmap_lookup_le_range_result(cur, ltrec.rm_startblock,
 				ltrec.rm_blockcount, ltrec.rm_owner,
 				ltrec.rm_offset, ltrec.rm_flags);
 
@@ -1035,10 +1020,10 @@ xfs_rmap_map(
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
@@ -1075,12 +1060,9 @@ xfs_rmap_map(
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
@@ -1127,8 +1109,7 @@ xfs_rmap_map(
 		cur->bc_rec.r.rm_owner = owner;
 		cur->bc_rec.r.rm_offset = offset;
 		cur->bc_rec.r.rm_flags = flags;
-		trace_xfs_rmap_insert(mp, cur->bc_ag.pag->pag_agno, bno, len,
-			owner, offset, flags);
+		trace_xfs_rmap_insert(cur, bno, len, owner, offset, flags);
 		error = xfs_btree_insert(cur, &i);
 		if (error)
 			goto out_error;
@@ -1139,8 +1120,7 @@ xfs_rmap_map(
 		}
 	}
 
-	trace_xfs_rmap_map_done(mp, cur->bc_ag.pag->pag_agno, bno, len,
-			unwritten, oinfo);
+	trace_xfs_rmap_map_done(cur, bno, len, unwritten, oinfo);
 out_error:
 	if (error)
 		trace_xfs_rmap_map_error(cur, error, _RET_IP_);
@@ -1217,8 +1197,7 @@ xfs_rmap_convert(
 			(flags & (XFS_RMAP_ATTR_FORK | XFS_RMAP_BMBT_BLOCK))));
 	oldext = unwritten ? XFS_RMAP_UNWRITTEN : 0;
 	new_endoff = offset + len;
-	trace_xfs_rmap_convert(mp, cur->bc_ag.pag->pag_agno, bno, len,
-			unwritten, oinfo);
+	trace_xfs_rmap_convert(cur, bno, len, unwritten, oinfo);
 
 	/*
 	 * For the initial lookup, look for an exact match or the left-adjacent
@@ -1234,10 +1213,9 @@ xfs_rmap_convert(
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
@@ -1278,10 +1256,9 @@ xfs_rmap_convert(
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
@@ -1319,10 +1296,10 @@ xfs_rmap_convert(
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
@@ -1369,10 +1346,9 @@ xfs_rmap_convert(
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
@@ -1389,10 +1365,9 @@ xfs_rmap_convert(
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
@@ -1421,10 +1396,9 @@ xfs_rmap_convert(
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
@@ -1461,10 +1435,9 @@ xfs_rmap_convert(
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
@@ -1542,8 +1515,7 @@ xfs_rmap_convert(
 		NEW.rm_blockcount = len;
 		NEW.rm_flags = newext;
 		cur->bc_rec.r = NEW;
-		trace_xfs_rmap_insert(mp, cur->bc_ag.pag->pag_agno, bno,
-				len, owner, offset, newext);
+		trace_xfs_rmap_insert(cur, bno, len, owner, offset, newext);
 		error = xfs_btree_insert(cur, &i);
 		if (error)
 			goto done;
@@ -1601,8 +1573,7 @@ xfs_rmap_convert(
 		NEW.rm_blockcount = len;
 		NEW.rm_flags = newext;
 		cur->bc_rec.r = NEW;
-		trace_xfs_rmap_insert(mp, cur->bc_ag.pag->pag_agno, bno,
-				len, owner, offset, newext);
+		trace_xfs_rmap_insert(cur, bno, len, owner, offset, newext);
 		error = xfs_btree_insert(cur, &i);
 		if (error)
 			goto done;
@@ -1633,9 +1604,8 @@ xfs_rmap_convert(
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
@@ -1662,8 +1632,7 @@ xfs_rmap_convert(
 		/* new middle extent - newext */
 		cur->bc_rec.r.rm_flags &= ~XFS_RMAP_UNWRITTEN;
 		cur->bc_rec.r.rm_flags |= newext;
-		trace_xfs_rmap_insert(mp, cur->bc_ag.pag->pag_agno, bno, len,
-				owner, offset, newext);
+		trace_xfs_rmap_insert(cur, bno, len, owner, offset, newext);
 		error = xfs_btree_insert(cur, &i);
 		if (error)
 			goto done;
@@ -1687,8 +1656,7 @@ xfs_rmap_convert(
 		ASSERT(0);
 	}
 
-	trace_xfs_rmap_convert_done(mp, cur->bc_ag.pag->pag_agno, bno, len,
-			unwritten, oinfo);
+	trace_xfs_rmap_convert_done(cur, bno, len, unwritten, oinfo);
 done:
 	if (error)
 		trace_xfs_rmap_convert_error(cur, error, _RET_IP_);
@@ -1727,8 +1695,7 @@ xfs_rmap_convert_shared(
 			(flags & (XFS_RMAP_ATTR_FORK | XFS_RMAP_BMBT_BLOCK))));
 	oldext = unwritten ? XFS_RMAP_UNWRITTEN : 0;
 	new_endoff = offset + len;
-	trace_xfs_rmap_convert(mp, cur->bc_ag.pag->pag_agno, bno, len,
-			unwritten, oinfo);
+	trace_xfs_rmap_convert(cur, bno, len, unwritten, oinfo);
 
 	/*
 	 * For the initial lookup, look for and exact match or the left-adjacent
@@ -1797,10 +1764,10 @@ xfs_rmap_convert_shared(
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
@@ -2112,8 +2079,7 @@ xfs_rmap_convert_shared(
 		ASSERT(0);
 	}
 
-	trace_xfs_rmap_convert_done(mp, cur->bc_ag.pag->pag_agno, bno, len,
-			unwritten, oinfo);
+	trace_xfs_rmap_convert_done(cur, bno, len, unwritten, oinfo);
 done:
 	if (error)
 		trace_xfs_rmap_convert_error(cur, error, _RET_IP_);
@@ -2154,8 +2120,7 @@ xfs_rmap_unmap_shared(
 	xfs_owner_info_unpack(oinfo, &owner, &offset, &flags);
 	if (unwritten)
 		flags |= XFS_RMAP_UNWRITTEN;
-	trace_xfs_rmap_unmap(mp, cur->bc_ag.pag->pag_agno, bno, len,
-			unwritten, oinfo);
+	trace_xfs_rmap_unmap(cur, bno, len, unwritten, oinfo);
 
 	/*
 	 * We should always have a left record because there's a static record
@@ -2311,8 +2276,7 @@ xfs_rmap_unmap_shared(
 			goto out_error;
 	}
 
-	trace_xfs_rmap_unmap_done(mp, cur->bc_ag.pag->pag_agno, bno, len,
-			unwritten, oinfo);
+	trace_xfs_rmap_unmap_done(cur, bno, len, unwritten, oinfo);
 out_error:
 	if (error)
 		trace_xfs_rmap_unmap_error(cur, error, _RET_IP_);
@@ -2350,8 +2314,7 @@ xfs_rmap_map_shared(
 	xfs_owner_info_unpack(oinfo, &owner, &offset, &flags);
 	if (unwritten)
 		flags |= XFS_RMAP_UNWRITTEN;
-	trace_xfs_rmap_map(mp, cur->bc_ag.pag->pag_agno, bno, len,
-			unwritten, oinfo);
+	trace_xfs_rmap_map(cur, bno, len, unwritten, oinfo);
 
 	/* Is there a left record that abuts our range? */
 	error = xfs_rmap_find_left_neighbor(cur, bno, owner, offset, flags,
@@ -2376,10 +2339,10 @@ xfs_rmap_map_shared(
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
@@ -2471,8 +2434,7 @@ xfs_rmap_map_shared(
 			goto out_error;
 	}
 
-	trace_xfs_rmap_map_done(mp, cur->bc_ag.pag->pag_agno, bno, len,
-			unwritten, oinfo);
+	trace_xfs_rmap_map_done(cur, bno, len, unwritten, oinfo);
 out_error:
 	if (error)
 		trace_xfs_rmap_map_error(cur, error, _RET_IP_);

