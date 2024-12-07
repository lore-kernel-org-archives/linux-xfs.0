Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F7832CA6
	for <linux-xfs@vger.kernel.org>; Sat,  7 Dec 2024 00:08:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733530114; cv=none; b=rGQVUVM+OGk7zCMvqi9VqKzMO7oVTovf8eCRDjP3M8cq8sCjUULz9261oL0vTxboz88m6yvRa2yQly1OHRrPmnvIwTC4DUyoxzRwYyOLvISZpCOuMRLl0bBJBYoIs2c6t4XmZoNwvL/m+w+un3Pd5jDaxAz7YAI6WcJBLRrzpbc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733530114; c=relaxed/simple;
	bh=bUCTMAOTkS4RCEOnyQsrsP0UZCi0E+CCkOZIJYRKrn0=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Cy581YusOrklJG1xOQjUq/7Bl3qgOQQu5Hpu6AC0k0dludQEAybbnQ1o1ZSPl5dc/pY1RLUe6gfF5tSOwqhEuP2dWe5BYpbJRbjtd9EKmc8gKVtWrN5cbT+Z5iJhER8hmipkVjG4Z8HwOjg2s4OTFxITSD3Zw/gpuAHIV1w9eb4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=T5EyelGn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="T5EyelGn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19C52C4CED1;
	Sat,  7 Dec 2024 00:08:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733530114;
	bh=bUCTMAOTkS4RCEOnyQsrsP0UZCi0E+CCkOZIJYRKrn0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=T5EyelGnW8klhAVmIVzzzuw9+WcWYnFL9k8hHQ5bFRUKqwmfFM35WA08wLLMtr6Fo
	 anG1HWPUlTqhfI2LrFrEnvvRfC8ZENXVYRESJbx843q1nZHRqiX3nSWTreujslPVTB
	 Ea6UUaRSDxUnoO5ovzzBMLR6P/V+7DhFBZVPFuJSTTciip0wGGFa0OYzfntqBHUqtX
	 1aKh42o96Vm0GIoJiRiV06qvF8DUxwRktmUg0p7d47bfE1f9umpgdiPrSAyBf28FhE
	 LW2a5WtJaH91+A4Q/TZo0IEeI3gJOcDjb+acgD++wmvsNqtCVSxUbvfEKKUvvlo9gO
	 pdG3R9M07qR3g==
Date: Fri, 06 Dec 2024 16:08:33 -0800
Subject: [PATCH 14/50] xfs_repair: refactor phase4
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173352752159.126362.17278748387791327249.stgit@frogsfrogsfrogs>
In-Reply-To: <173352751867.126362.1763344829761562977.stgit@frogsfrogsfrogs>
References: <173352751867.126362.1763344829761562977.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Christoph Hellwig <hch@lst.de>

Split out helpers to process all duplicate extents in an AG and the RT
duplicate extents.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 repair/phase4.c |  210 ++++++++++++++++++++++++++++++-------------------------
 1 file changed, 114 insertions(+), 96 deletions(-)


diff --git a/repair/phase4.c b/repair/phase4.c
index 40db36f1f93020..036a4ed0e54445 100644
--- a/repair/phase4.c
+++ b/repair/phase4.c
@@ -225,20 +225,122 @@ process_rmap_data(
 	destroy_work_queue(&wq);
 }
 
+static void
+process_dup_rt_extents(
+	struct xfs_mount	*mp)
+{
+	xfs_rtxnum_t		rt_start = 0;
+	xfs_rtxlen_t		rt_len = 0;
+	xfs_rtxnum_t		rtx;
+
+	for (rtx = 0; rtx < mp->m_sb.sb_rextents; rtx++)  {
+		int state;
+
+		state = get_rtbmap(rtx);
+		switch (state) {
+		case XR_E_BAD_STATE:
+		default:
+			do_warn(
+	_("unknown rt extent state %d, extent %" PRIu64 "\n"),
+				state, rtx);
+			fallthrough;
+		case XR_E_METADATA:
+		case XR_E_UNKNOWN:
+		case XR_E_FREE1:
+		case XR_E_FREE:
+		case XR_E_INUSE:
+		case XR_E_INUSE_FS:
+		case XR_E_INO:
+		case XR_E_FS_MAP:
+			if (rt_start == 0)
+				continue;
+			/*
+			 * Add extent and reset extent state.
+			 */
+			add_rt_dup_extent(rt_start, rt_len);
+			rt_start = 0;
+			rt_len = 0;
+			break;
+		case XR_E_MULT:
+			switch (rt_start)  {
+			case 0:
+				rt_start = rtx;
+				rt_len = 1;
+				break;
+			case XFS_MAX_BMBT_EXTLEN:
+				/*
+				 * Large extent case.
+				 */
+				add_rt_dup_extent(rt_start, rt_len);
+				rt_start = rtx;
+				rt_len = 1;
+				break;
+			default:
+				rt_len++;
+				break;
+			}
+			break;
+		}
+	}
+
+	/*
+	 * Catch the tail case, extent hitting the end of the RTG.
+	 */
+	if (rt_start != 0)
+		add_rt_dup_extent(rt_start, rt_len);
+}
+
+/*
+ * Set up duplicate extent list for an AG or RTG.
+ */
+static void
+process_dup_extents(
+	xfs_agnumber_t		agno,
+	xfs_agblock_t		agbno,
+	xfs_agblock_t		ag_end)
+{
+	do {
+		int		bstate;
+		xfs_extlen_t	blen;
+
+		bstate = get_bmap_ext(agno, agbno, ag_end, &blen);
+		switch (bstate) {
+		case XR_E_FREE1:
+			if (no_modify)
+				do_warn(
+_("free space (%u,%u-%u) only seen by one free space btree\n"),
+					agno, agbno, agbno + blen - 1);
+			break;
+		case XR_E_METADATA:
+		case XR_E_UNKNOWN:
+		case XR_E_FREE:
+		case XR_E_INUSE:
+		case XR_E_INUSE_FS:
+		case XR_E_INO:
+		case XR_E_FS_MAP:
+			break;
+		case XR_E_MULT:
+			add_dup_extent(agno, agbno, blen);
+			break;
+		case XR_E_BAD_STATE:
+		default:
+			do_warn(
+_("unknown block state, ag %d, blocks %u-%u\n"),
+				agno, agbno, agbno + blen - 1);
+			break;
+		}
+
+		agbno += blen;
+	} while (agbno < ag_end);
+}
+
 void
 phase4(xfs_mount_t *mp)
 {
 	ino_tree_node_t		*irec;
-	xfs_rtxnum_t		rtx;
-	xfs_rtxnum_t		rt_start;
-	xfs_rtxlen_t		rt_len;
 	xfs_agnumber_t		i;
-	xfs_agblock_t		j;
-	xfs_agblock_t		ag_end;
-	xfs_extlen_t		blen;
 	int			ag_hdr_len = 4 * mp->m_sb.sb_sectsize;
 	int			ag_hdr_block;
-	int			bstate;
 
 	if (rmap_needs_work(mp))
 		collect_rmaps = true;
@@ -281,102 +383,19 @@ phase4(xfs_mount_t *mp)
 	}
 
 	for (i = 0; i < mp->m_sb.sb_agcount; i++)  {
+		xfs_agblock_t		ag_end;
+
 		ag_end = (i < mp->m_sb.sb_agcount - 1) ? mp->m_sb.sb_agblocks :
 			mp->m_sb.sb_dblocks -
 				(xfs_rfsblock_t) mp->m_sb.sb_agblocks * i;
 
-		/*
-		 * set up duplicate extent list for this ag
-		 */
-		for (j = ag_hdr_block; j < ag_end; j += blen)  {
-			bstate = get_bmap_ext(i, j, ag_end, &blen);
-			switch (bstate) {
-			case XR_E_FREE1:
-				if (no_modify)
-					do_warn(
-	_("free space (%u,%u-%u) only seen by one free space btree\n"),
-						i, j, j + blen - 1);
-				break;
-			case XR_E_BAD_STATE:
-			default:
-				do_warn(
-				_("unknown block state, ag %d, blocks %u-%u\n"),
-					i, j, j + blen - 1);
-				fallthrough;
-			case XR_E_METADATA:
-			case XR_E_UNKNOWN:
-			case XR_E_FREE:
-			case XR_E_INUSE:
-			case XR_E_INUSE_FS:
-			case XR_E_INO:
-			case XR_E_FS_MAP:
-				break;
-			case XR_E_MULT:
-				add_dup_extent(i, j, blen);
-				break;
-			}
-		}
+		process_dup_extents(i, ag_hdr_block, ag_end);
 
 		PROG_RPT_INC(prog_rpt_done[i], 1);
 	}
 	print_final_rpt();
 
-	/*
-	 * initialize realtime bitmap
-	 */
-	rt_start = 0;
-	rt_len = 0;
-
-	for (rtx = 0; rtx < mp->m_sb.sb_rextents; rtx++)  {
-		bstate = get_rtbmap(rtx);
-		switch (bstate)  {
-		case XR_E_BAD_STATE:
-		default:
-			do_warn(
-	_("unknown rt extent state, extent %" PRIu64 "\n"),
-				rtx);
-			fallthrough;
-		case XR_E_METADATA:
-		case XR_E_UNKNOWN:
-		case XR_E_FREE1:
-		case XR_E_FREE:
-		case XR_E_INUSE:
-		case XR_E_INUSE_FS:
-		case XR_E_INO:
-		case XR_E_FS_MAP:
-			if (rt_start == 0)
-				continue;
-			else  {
-				/*
-				 * add extent and reset extent state
-				 */
-				add_rt_dup_extent(rt_start, rt_len);
-				rt_start = 0;
-				rt_len = 0;
-			}
-			break;
-		case XR_E_MULT:
-			if (rt_start == 0)  {
-				rt_start = rtx;
-				rt_len = 1;
-			} else if (rt_len == XFS_MAX_BMBT_EXTLEN)  {
-				/*
-				 * large extent case
-				 */
-				add_rt_dup_extent(rt_start, rt_len);
-				rt_start = rtx;
-				rt_len = 1;
-			} else
-				rt_len++;
-			break;
-		}
-	}
-
-	/*
-	 * catch tail-case, extent hitting the end of the ag
-	 */
-	if (rt_start != 0)
-		add_rt_dup_extent(rt_start, rt_len);
+	process_dup_rt_extents(mp);
 
 	/*
 	 * initialize bitmaps for all AGs
@@ -410,8 +429,7 @@ phase4(xfs_mount_t *mp)
 	/*
 	 * free up memory used to track trealtime duplicate extents
 	 */
-	if (rt_start != 0)
-		free_rt_dup_extent_tree(mp);
+	free_rt_dup_extent_tree(mp);
 
 	/*
 	 * ensure consistency of quota inode pointers in superblock,

