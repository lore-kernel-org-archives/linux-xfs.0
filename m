Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A945EC4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 01:36:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235911AbiLaBgY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 20:36:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231425AbiLaBgW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 20:36:22 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 074EEBE2D
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 17:36:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 92C38B81E11
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 01:36:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D959C433EF;
        Sat, 31 Dec 2022 01:36:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672450578;
        bh=Yj1N7z1gBTzNAIZM1+B83dUITalHiQ9LnEcmvSynq50=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=H4I+R8yM6YsKXILMpzsqaHACzC0Sd7HT+uTIpgu84QWE+zmWRpsjLpw55y6GX9XPl
         NbvuZp4yzyFFh3RsLiSFS3tBoKRKfRWfk0SQ4U66Dpgc/CiosTm/hSKcl0t0UQGRnj
         +XKsTgfNNLAk8wheCJjwsoNORDXkE7Zjnxa/0rDWUDYUBB3TW41auszA3kNUGVQCum
         knxeCcMkxn0WmWHW/eZv0Xq+M8f4nSZUCOGxFt+TXaY/qZP9/LJ8+jyfflXzKpB+rx
         XLPF9cYxD6uMP3v91YqaT2q634F9tAkHFqUz9Xi/C562p3r1hvVW2Uk4dnLwqCDIwW
         UOkxciS20ZsEw==
Subject: [PATCH 3/5] xfs: prepare rmap btree tracepoints for widening
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:18:12 -0800
Message-ID: <167243869204.714954.13205350379197508983.stgit@magnolia>
In-Reply-To: <167243869156.714954.12346064053546135919.stgit@magnolia>
References: <167243869156.714954.12346064053546135919.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

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
index f85ff3ddb5c4..065cb95a1ce7 100644
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
index aaac43e61e83..3130b8def8ec 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -2834,10 +2834,10 @@ DEFINE_DEFER_PENDING_ITEM_EVENT(xfs_defer_finish_item);
 
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
@@ -2848,8 +2848,8 @@ DECLARE_EVENT_CLASS(xfs_rmap_class,
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
@@ -2869,10 +2869,10 @@ DECLARE_EVENT_CLASS(xfs_rmap_class,
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
@@ -2957,10 +2957,10 @@ TRACE_EVENT(xfs_rmap_convert_state,
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
@@ -2971,8 +2971,8 @@ DECLARE_EVENT_CLASS(xfs_rmapbt_class,
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
@@ -2990,10 +2990,10 @@ DECLARE_EVENT_CLASS(xfs_rmapbt_class,
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

