Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D49EE138E
	for <linux-xfs@vger.kernel.org>; Wed,  2 Oct 2024 01:17:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727831879; cv=none; b=oL3Cmckbc6os10cAEhaBnC7Y2IxGYPhiTQ6IL3A7a5xYX6uwZHGd84MuK+r1N57mG6OMtUpAQAlz17d0xGiWyHHWAKQU36XXi4G4IEUXe4WwGs6KLkPVXhN6ygm8jIEeOzyA/ddz/DR/UAUeP9Owcu4T0BCXsfYPlhzBmPKKk0k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727831879; c=relaxed/simple;
	bh=SVPkYP8YZ9xu87y0doitkevG0h5u1oZvnnvDOgzdrzg=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=K4/U9FVk8PoGoPnaElAGr78f8XDZNoQWQybbrvYQ+bzOWwEaZ8Sb+xH2phO5h2KbZwvybMEUuL4OzIqDRyEqPquOUwfETseP2Qsq1YgkcOl6vxY4GVJsf2YW41k+YlJnRXH1X+X+CelBxqS7oAy6oL7bOh8em/C3N4IZrcUlBMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=k3InhsW3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="k3InhsW3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B07C7C4CEC6;
	Wed,  2 Oct 2024 01:17:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727831879;
	bh=SVPkYP8YZ9xu87y0doitkevG0h5u1oZvnnvDOgzdrzg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=k3InhsW3/PvqCCiwiqW70PopaZnJcH1fGZinA6kl7JgTHZjFPD8xsoqEoV/+srF+7
	 AU5OHcFJ57Zz05eK5YLyOAQ7KoeMoD+aGukVlorZbDKZ2sWetnPLwbkqSWKRSmh1Ap
	 b1Os3uu2Glr0s1f8dWUQJbU0dP1UYM6E0/usZeBqGAWhN5ey+LLJFCS6t0bYapZalK
	 yp2b67Vbi6byU0uy/gtMHOjOTUvZCIqphvzfHIy5BybpzgNWUC10EGIODJT2QcvyaB
	 aUtQJiVEVxlddeMdLHO64vhmb2vvyNTlSGX2icntuD3dzDdBSDWLkUxZNL26D0/5Bx
	 7K4YH3DuDFkOw==
Date: Tue, 01 Oct 2024 18:17:59 -0700
Subject: [PATCH 39/64] xfs: remove xfs_defer_agfl_block
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <172783102369.4036371.17292930414162317061.stgit@frogsfrogsfrogs>
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

From: Christoph Hellwig <hch@lst.de>

Source kernel commit: 7272f77c67c0710918e5678266f8dad6e3bfc8d2

xfs_free_extent_later can handle the extra AGFL special casing with
very little extra logic.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_alloc.c |   68 +++++++++++++++++-----------------------------------
 1 file changed, 22 insertions(+), 46 deletions(-)


diff --git a/libxfs/xfs_alloc.c b/libxfs/xfs_alloc.c
index 93e628e8c..60ac73828 100644
--- a/libxfs/xfs_alloc.c
+++ b/libxfs/xfs_alloc.c
@@ -2505,48 +2505,6 @@ xfs_agfl_reset(
 	clear_bit(XFS_AGSTATE_AGFL_NEEDS_RESET, &pag->pag_opstate);
 }
 
-/*
- * Defer an AGFL block free. This is effectively equivalent to
- * xfs_free_extent_later() with some special handling particular to AGFL blocks.
- *
- * Deferring AGFL frees helps prevent log reservation overruns due to too many
- * allocation operations in a transaction. AGFL frees are prone to this problem
- * because for one they are always freed one at a time. Further, an immediate
- * AGFL block free can cause a btree join and require another block free before
- * the real allocation can proceed. Deferring the free disconnects freeing up
- * the AGFL slot from freeing the block.
- */
-static int
-xfs_defer_agfl_block(
-	struct xfs_trans		*tp,
-	xfs_agnumber_t			agno,
-	xfs_agblock_t			agbno,
-	struct xfs_owner_info		*oinfo)
-{
-	struct xfs_mount		*mp = tp->t_mountp;
-	struct xfs_extent_free_item	*xefi;
-	xfs_fsblock_t			fsbno = XFS_AGB_TO_FSB(mp, agno, agbno);
-
-	ASSERT(xfs_extfree_item_cache != NULL);
-	ASSERT(oinfo != NULL);
-
-	if (XFS_IS_CORRUPT(mp, !xfs_verify_fsbno(mp, fsbno)))
-		return -EFSCORRUPTED;
-
-	xefi = kmem_cache_zalloc(xfs_extfree_item_cache,
-			       GFP_KERNEL | __GFP_NOFAIL);
-	xefi->xefi_startblock = fsbno;
-	xefi->xefi_blockcount = 1;
-	xefi->xefi_owner = oinfo->oi_owner;
-	xefi->xefi_agresv = XFS_AG_RESV_AGFL;
-
-	trace_xfs_agfl_free_defer(mp, xefi);
-
-	xfs_extent_free_get_group(mp, xefi);
-	xfs_defer_add(tp, &xefi->xefi_list, &xfs_agfl_free_defer_type);
-	return 0;
-}
-
 /*
  * Add the extent to the list of extents to be free at transaction end.
  * The list is maintained sorted (by block number).
@@ -2567,7 +2525,6 @@ xfs_defer_extent_free(
 	ASSERT(len <= XFS_MAX_BMBT_EXTLEN);
 	ASSERT(!isnullstartblock(bno));
 	ASSERT(!(free_flags & ~XFS_FREE_EXTENT_ALL_FLAGS));
-	ASSERT(type != XFS_AG_RESV_AGFL);
 
 	if (XFS_IS_CORRUPT(mp, !xfs_verify_fsbext(mp, bno, len)))
 		return -EFSCORRUPTED;
@@ -2594,7 +2551,13 @@ xfs_defer_extent_free(
 	trace_xfs_extent_free_defer(mp, xefi);
 
 	xfs_extent_free_get_group(mp, xefi);
-	*dfpp = xfs_defer_add(tp, &xefi->xefi_list, &xfs_extent_free_defer_type);
+
+	if (xefi->xefi_agresv == XFS_AG_RESV_AGFL)
+		*dfpp = xfs_defer_add(tp, &xefi->xefi_list,
+				&xfs_agfl_free_defer_type);
+	else
+		*dfpp = xfs_defer_add(tp, &xefi->xefi_list,
+				&xfs_extent_free_defer_type);
 	return 0;
 }
 
@@ -2852,8 +2815,21 @@ xfs_alloc_fix_freelist(
 		if (error)
 			goto out_agbp_relse;
 
-		/* defer agfl frees */
-		error = xfs_defer_agfl_block(tp, args->agno, bno, &targs.oinfo);
+		/*
+		 * Defer the AGFL block free.
+		 *
+		 * This helps to prevent log reservation overruns due to too
+		 * many allocation operations in a transaction. AGFL frees are
+		 * prone to this problem because for one they are always freed
+		 * one at a time.  Further, an immediate AGFL block free can
+		 * cause a btree join and require another block free before the
+		 * real allocation can proceed.
+		 * Deferring the free disconnects freeing up the AGFL slot from
+		 * freeing the block.
+		 */
+		error = xfs_free_extent_later(tp,
+				XFS_AGB_TO_FSB(mp, args->agno, bno), 1,
+				&targs.oinfo, XFS_AG_RESV_AGFL, 0);
 		if (error)
 			goto out_agbp_relse;
 	}

