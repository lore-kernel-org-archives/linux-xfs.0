Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A3977ED
	for <linux-xfs@vger.kernel.org>; Mon,  1 Jan 2024 00:07:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="C2h7lbip"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07630C433C8;
	Mon,  1 Jan 2024 00:07:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704067628;
	bh=yiuUSiKoX0JnmbQzIXho8VE7dT3aLxSn2CabQdIghfU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=C2h7lbipPsbpYKzZdNFfBOpZKeB64clXnmru8dM2/cuAvEB6VZsfYuEyORxAgf0p8
	 89DpCDZXbe446TgwhhrDGwczJeKsrVDlz/N2xCt26rqnqdwp5DdeHw0DFjBCFaYTx0
	 TyVrpbIYftXX6djbAnBAAAnkq2n9hZCrmz08jFSXcwI5UCQ16txhMAHjLMalq1QhXn
	 Y3I1H/8MgCoZ13imrFdWWYchOOk6mYyQRJm4dVX1Fr7W62UxaZdAs94ekw3ZAqfov6
	 pnkTFRdJDrDlp9ItQ+THKf7Y1e3Mwy4L0l3MQp9+yx2kn15cOSwCWJOVgWr9JLSGtM
	 C0b6fKzrJQapg==
Date: Sun, 31 Dec 2023 16:07:07 +9900
Subject: [PATCH 7/8] xfs: remove xfs_defer_agfl_block
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <170405014134.1814860.17988176700740487416.stgit@frogsfrogsfrogs>
In-Reply-To: <170405014035.1814860.4299784888161945873.stgit@frogsfrogsfrogs>
References: <170405014035.1814860.4299784888161945873.stgit@frogsfrogsfrogs>
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
 libxfs/xfs_alloc.c |   67 +++++++++++++++++-----------------------------------
 1 file changed, 22 insertions(+), 45 deletions(-)


diff --git a/libxfs/xfs_alloc.c b/libxfs/xfs_alloc.c
index 160563b1b26..2cbdbd4c416 100644
--- a/libxfs/xfs_alloc.c
+++ b/libxfs/xfs_alloc.c
@@ -2534,48 +2534,6 @@ xfs_agfl_reset(
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
@@ -2623,7 +2581,13 @@ xfs_defer_extent_free(
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
 
@@ -2881,8 +2845,21 @@ xfs_alloc_fix_freelist(
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

