Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 648D57C6EB
	for <linux-xfs@vger.kernel.org>; Thu, 20 Jun 2024 23:07:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718924853; cv=none; b=oIFZ95eIYJcH6IZwY9Ff3cGSzxd0LtGKYlbx4BPMo5nHkRzhHvcoOJHUNeKobKZzp+hG2ztowy1qmVCbCII51SipHaOuGI6QREzGcHdEyAkVbHjKrTJ/O1ggGc38zhTQGkcmFJmFNfRx1nuyaNXhccKbQ0unW9vF59xzZiqsE/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718924853; c=relaxed/simple;
	bh=2Ydb/GmQkxl+oPI/9Q19flLTyrpRW6A22FiRYoNHA+E=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=I3KwJWsW8KEMOEIORTZzCMcAlhQSEgvrIfIHU8tM8nZOQQe79Vy6apCU0DzJP0Z3i2vBReB0uP9estfR4dLAWY1G3d9+7BmamSasRAbLxBizw40/xpme7QT6A6DXH3v1OqJnnHwHqXDzODJexVJAOZwIWW7KpctQuMZ3y2qS0as=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UdyBdUaK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UdyBdUaK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8F94C2BD10;
	Thu, 20 Jun 2024 23:07:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718924851;
	bh=2Ydb/GmQkxl+oPI/9Q19flLTyrpRW6A22FiRYoNHA+E=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=UdyBdUaKo2/DP2v/ZFQwfpZMzP11NA9E0TaPvTcb0uea+YBeqnyvMS6ExF9kfnNJ9
	 1OJb+so0HfYZqAuvVjRBmpb/BoNXjp3gDa5d//At7Ju5V6J2BREajoU+97q1sMiaEi
	 j6vecuuhqANql4XzKYZq6dRX/Svc90l6dvJP61EYjR2t2t+SzV9v65op3ZpEj3aXg+
	 mIzu/011loLiOUHSXmAMGzZ7+iQY9SQGJC3z9H/MmJI7AAQWJL6vGeA9yub02SszTO
	 gxKkBk3qcTSXbkWQUtUjNmikNhmiSvJKXLr9IlAyLqcEHhzY3aWaaaJydXUUBr1hl5
	 oz9vQh0zsnwEw==
Date: Thu, 20 Jun 2024 16:07:31 -0700
Subject: [PATCH 2/9] xfs: prepare rmap btree tracepoints for widening
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <171892419266.3184396.5637689260987491987.stgit@frogsfrogsfrogs>
In-Reply-To: <171892419209.3184396.10441735798864910501.stgit@frogsfrogsfrogs>
References: <171892419209.3184396.10441735798864910501.stgit@frogsfrogsfrogs>
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
index bf047cdb95a4e..ce8ea3c842839 100644
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
@@ -983,8 +970,7 @@ xfs_rmap_map(
 			(flags & XFS_RMAP_BMBT_BLOCK);
 	if (unwritten)
 		flags |= XFS_RMAP_UNWRITTEN;
-	trace_xfs_rmap_map(mp, cur->bc_ag.pag->pag_agno, bno, len,
-			unwritten, oinfo);
+	trace_xfs_rmap_map(cur, bno, len, unwritten, oinfo);
 	ASSERT(!xfs_rmap_should_skip_owner_update(oinfo));
 
 	/*
@@ -997,8 +983,7 @@ xfs_rmap_map(
 	if (error)
 		goto out_error;
 	if (have_lt) {
-		trace_xfs_rmap_lookup_le_range_result(cur->bc_mp,
-				cur->bc_ag.pag->pag_agno, ltrec.rm_startblock,
+		trace_xfs_rmap_lookup_le_range_result(cur, ltrec.rm_startblock,
 				ltrec.rm_blockcount, ltrec.rm_owner,
 				ltrec.rm_offset, ltrec.rm_flags);
 
@@ -1036,10 +1021,10 @@ xfs_rmap_map(
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
@@ -1076,12 +1061,9 @@ xfs_rmap_map(
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
@@ -1128,8 +1110,7 @@ xfs_rmap_map(
 		cur->bc_rec.r.rm_owner = owner;
 		cur->bc_rec.r.rm_offset = offset;
 		cur->bc_rec.r.rm_flags = flags;
-		trace_xfs_rmap_insert(mp, cur->bc_ag.pag->pag_agno, bno, len,
-			owner, offset, flags);
+		trace_xfs_rmap_insert(cur, bno, len, owner, offset, flags);
 		error = xfs_btree_insert(cur, &i);
 		if (error)
 			goto out_error;
@@ -1140,8 +1121,7 @@ xfs_rmap_map(
 		}
 	}
 
-	trace_xfs_rmap_map_done(mp, cur->bc_ag.pag->pag_agno, bno, len,
-			unwritten, oinfo);
+	trace_xfs_rmap_map_done(cur, bno, len, unwritten, oinfo);
 out_error:
 	if (error)
 		trace_xfs_rmap_map_error(cur, error, _RET_IP_);
@@ -1218,8 +1198,7 @@ xfs_rmap_convert(
 			(flags & (XFS_RMAP_ATTR_FORK | XFS_RMAP_BMBT_BLOCK))));
 	oldext = unwritten ? XFS_RMAP_UNWRITTEN : 0;
 	new_endoff = offset + len;
-	trace_xfs_rmap_convert(mp, cur->bc_ag.pag->pag_agno, bno, len,
-			unwritten, oinfo);
+	trace_xfs_rmap_convert(cur, bno, len, unwritten, oinfo);
 
 	/*
 	 * For the initial lookup, look for an exact match or the left-adjacent
@@ -1235,10 +1214,9 @@ xfs_rmap_convert(
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
@@ -1279,10 +1257,9 @@ xfs_rmap_convert(
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
@@ -1320,10 +1297,10 @@ xfs_rmap_convert(
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
@@ -1370,10 +1347,9 @@ xfs_rmap_convert(
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
@@ -1390,10 +1366,9 @@ xfs_rmap_convert(
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
@@ -1422,10 +1397,9 @@ xfs_rmap_convert(
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
@@ -1462,10 +1436,9 @@ xfs_rmap_convert(
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
@@ -1543,8 +1516,7 @@ xfs_rmap_convert(
 		NEW.rm_blockcount = len;
 		NEW.rm_flags = newext;
 		cur->bc_rec.r = NEW;
-		trace_xfs_rmap_insert(mp, cur->bc_ag.pag->pag_agno, bno,
-				len, owner, offset, newext);
+		trace_xfs_rmap_insert(cur, bno, len, owner, offset, newext);
 		error = xfs_btree_insert(cur, &i);
 		if (error)
 			goto done;
@@ -1602,8 +1574,7 @@ xfs_rmap_convert(
 		NEW.rm_blockcount = len;
 		NEW.rm_flags = newext;
 		cur->bc_rec.r = NEW;
-		trace_xfs_rmap_insert(mp, cur->bc_ag.pag->pag_agno, bno,
-				len, owner, offset, newext);
+		trace_xfs_rmap_insert(cur, bno, len, owner, offset, newext);
 		error = xfs_btree_insert(cur, &i);
 		if (error)
 			goto done;
@@ -1634,9 +1605,8 @@ xfs_rmap_convert(
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
@@ -1663,8 +1633,7 @@ xfs_rmap_convert(
 		/* new middle extent - newext */
 		cur->bc_rec.r.rm_flags &= ~XFS_RMAP_UNWRITTEN;
 		cur->bc_rec.r.rm_flags |= newext;
-		trace_xfs_rmap_insert(mp, cur->bc_ag.pag->pag_agno, bno, len,
-				owner, offset, newext);
+		trace_xfs_rmap_insert(cur, bno, len, owner, offset, newext);
 		error = xfs_btree_insert(cur, &i);
 		if (error)
 			goto done;
@@ -1688,8 +1657,7 @@ xfs_rmap_convert(
 		ASSERT(0);
 	}
 
-	trace_xfs_rmap_convert_done(mp, cur->bc_ag.pag->pag_agno, bno, len,
-			unwritten, oinfo);
+	trace_xfs_rmap_convert_done(cur, bno, len, unwritten, oinfo);
 done:
 	if (error)
 		trace_xfs_rmap_convert_error(cur, error, _RET_IP_);
@@ -1728,8 +1696,7 @@ xfs_rmap_convert_shared(
 			(flags & (XFS_RMAP_ATTR_FORK | XFS_RMAP_BMBT_BLOCK))));
 	oldext = unwritten ? XFS_RMAP_UNWRITTEN : 0;
 	new_endoff = offset + len;
-	trace_xfs_rmap_convert(mp, cur->bc_ag.pag->pag_agno, bno, len,
-			unwritten, oinfo);
+	trace_xfs_rmap_convert(cur, bno, len, unwritten, oinfo);
 
 	/*
 	 * For the initial lookup, look for and exact match or the left-adjacent
@@ -1798,10 +1765,10 @@ xfs_rmap_convert_shared(
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
@@ -2113,8 +2080,7 @@ xfs_rmap_convert_shared(
 		ASSERT(0);
 	}
 
-	trace_xfs_rmap_convert_done(mp, cur->bc_ag.pag->pag_agno, bno, len,
-			unwritten, oinfo);
+	trace_xfs_rmap_convert_done(cur, bno, len, unwritten, oinfo);
 done:
 	if (error)
 		trace_xfs_rmap_convert_error(cur, error, _RET_IP_);
@@ -2155,8 +2121,7 @@ xfs_rmap_unmap_shared(
 	xfs_owner_info_unpack(oinfo, &owner, &offset, &flags);
 	if (unwritten)
 		flags |= XFS_RMAP_UNWRITTEN;
-	trace_xfs_rmap_unmap(mp, cur->bc_ag.pag->pag_agno, bno, len,
-			unwritten, oinfo);
+	trace_xfs_rmap_unmap(cur, bno, len, unwritten, oinfo);
 
 	/*
 	 * We should always have a left record because there's a static record
@@ -2312,8 +2277,7 @@ xfs_rmap_unmap_shared(
 			goto out_error;
 	}
 
-	trace_xfs_rmap_unmap_done(mp, cur->bc_ag.pag->pag_agno, bno, len,
-			unwritten, oinfo);
+	trace_xfs_rmap_unmap_done(cur, bno, len, unwritten, oinfo);
 out_error:
 	if (error)
 		trace_xfs_rmap_unmap_error(cur, error, _RET_IP_);
@@ -2351,8 +2315,7 @@ xfs_rmap_map_shared(
 	xfs_owner_info_unpack(oinfo, &owner, &offset, &flags);
 	if (unwritten)
 		flags |= XFS_RMAP_UNWRITTEN;
-	trace_xfs_rmap_map(mp, cur->bc_ag.pag->pag_agno, bno, len,
-			unwritten, oinfo);
+	trace_xfs_rmap_map(cur, bno, len, unwritten, oinfo);
 
 	/* Is there a left record that abuts our range? */
 	error = xfs_rmap_find_left_neighbor(cur, bno, owner, offset, flags,
@@ -2377,10 +2340,10 @@ xfs_rmap_map_shared(
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
@@ -2472,8 +2435,7 @@ xfs_rmap_map_shared(
 			goto out_error;
 	}
 
-	trace_xfs_rmap_map_done(mp, cur->bc_ag.pag->pag_agno, bno, len,
-			unwritten, oinfo);
+	trace_xfs_rmap_map_done(cur, bno, len, unwritten, oinfo);
 out_error:
 	if (error)
 		trace_xfs_rmap_map_error(cur, error, _RET_IP_);
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 7527db2c04426..95ea53060bc6d 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -2757,10 +2757,10 @@ DEFINE_DEFER_PENDING_ITEM_EVENT(xfs_defer_finish_item);
 
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
@@ -2771,8 +2771,8 @@ DECLARE_EVENT_CLASS(xfs_rmap_class,
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
@@ -2792,10 +2792,10 @@ DECLARE_EVENT_CLASS(xfs_rmap_class,
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
@@ -2891,10 +2891,10 @@ TRACE_EVENT(xfs_rmap_convert_state,
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
@@ -2905,8 +2905,8 @@ DECLARE_EVENT_CLASS(xfs_rmapbt_class,
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
@@ -2924,10 +2924,10 @@ DECLARE_EVENT_CLASS(xfs_rmapbt_class,
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

