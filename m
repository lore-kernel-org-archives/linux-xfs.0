Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A15E7C6EB
	for <linux-xfs@vger.kernel.org>; Thu, 20 Jun 2024 23:06:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718924805; cv=none; b=ujF4gHKzkH8BzN+FUUOkoeJAGTf3/Sq1vWN6jmqzrfGqfyVd71cLaVCQPkUWsB8xg5sKeUQjiCSCNluR91b4ZGvYep/FL8Yw8qXmWGY3nlZF9l25hCnoZBkDL87vbr+zcp+Oux4AXP6+FMYLo5rGZvWFUcWXADwP1Omkp4Ac1OA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718924805; c=relaxed/simple;
	bh=Smyf0902YMxrV6i6WZnO3PM1L6SGk19BOZLi41QOZTw=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TjjTPPUiY7/cYTRMu2bZjB/W5p69FUW2pWRNGJQdV5hVXmMFMXKMB+zCw2HZBDPk1SAU+HeQBHcpyG0BRTY22JJCVbQLPMgSn3uTj/aD0RKYQSknCaf2tZv6XN3+koFDsCsDT2cCLcw0RuBN7SUnw11YU0CS6CA+QRajHm5gmPE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=go/WoFoT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="go/WoFoT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 188B7C2BD10;
	Thu, 20 Jun 2024 23:06:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718924805;
	bh=Smyf0902YMxrV6i6WZnO3PM1L6SGk19BOZLi41QOZTw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=go/WoFoTGUnWiroYAwRiSzfYmebJ2aQXrqOTHS1a6Ncf8tEOKoWmD4aDDmGqsYOjG
	 zs3or8zwqIIK03zKYy2vepwTdt180lAFwJBjO99+kMfPI71xlPQbuM/3F5gjIdyU2O
	 A+PY3f83l4L6D/siKcGyayRCsUECgMZdhx/rHKmoyfTWh7nY3a3g+FvEbVAAmrQwVY
	 I7CrrHIGjcl6pSKnhhlBgNQ9GaGrfJ6Yy5bjZ41eQd99HGDqWLnJIUG1RLVPDzv68k
	 e6XfgrHIRPS4W0YjZEdBMZdrWoOWbUpHwg/tMR5lNuhmhzCQKT0MclfaekRgT7k1wa
	 ecKSqPRIIF5Iw==
Date: Thu, 20 Jun 2024 16:06:44 -0700
Subject: [PATCH 8/9] xfs: remove xfs_defer_agfl_block
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <171892418834.3183906.376857417040987772.stgit@frogsfrogsfrogs>
In-Reply-To: <171892418670.3183906.4770669498640039656.stgit@frogsfrogsfrogs>
References: <171892418670.3183906.4770669498640039656.stgit@frogsfrogsfrogs>
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

xfs_free_extent_later can handle the extra AGFL special casing with
very little extra logic.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_alloc.c |   67 +++++++++++++++------------------------------
 1 file changed, 22 insertions(+), 45 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 03a0a4289d943..1da3b1f741300 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -2535,48 +2535,6 @@ xfs_agfl_reset(
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
@@ -2624,7 +2582,13 @@ xfs_defer_extent_free(
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
 
@@ -2882,8 +2846,21 @@ xfs_alloc_fix_freelist(
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

