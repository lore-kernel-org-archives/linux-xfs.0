Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6327979D0
	for <linux-xfs@vger.kernel.org>; Fri, 11 Oct 2024 00:47:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728607656; cv=none; b=S8cWni764QDClnbKctY27EkttZhtdrbFlAL7mYBYvghkjFi7rS4SpOtWbdr7KHcyO85ho4D/GPxauBVAD2q4kxsHa2mMbB6/ScnTYkGce1JGdsjhTNiMM5Ln8oVFf4nLP/zscTEax2fX0iOX8tyZeSAKhGLivQDwrIMUjZ37+bE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728607656; c=relaxed/simple;
	bh=t8YG2Rg2n/3W7YR7qkRsko2dvXjdae7sQ0OU6AjpdQE=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=G7JbEEBLgZlOaN6vFhNpWrzrDRdJ5H2p4tgL0EUH1J05nZYsIN2eZElmfbl4Z4xhYc7pO5Fq+5XcjpVb/RhdqV1uR9lRdfD12iJAnnYQg+ujLGfXGr2y67yRNzkzs8e/ZXTj7YeoA3B2Y03KWfUzO28TgzDxTvGPisPychi3w1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Z4lKDTCy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Z4lKDTCy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C400C4CEC5;
	Fri, 11 Oct 2024 00:47:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728607656;
	bh=t8YG2Rg2n/3W7YR7qkRsko2dvXjdae7sQ0OU6AjpdQE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Z4lKDTCyPYmkC/ODrS+mtpeuIWBA12D28Zx/FGcqSiW/tswT3tU8xgog3IQTj4xP/
	 xNWsaLGnJ981LJmPvLnJv19qHonqmvILdrLzYieSPp6rSiksU2a8JZzqYJYJkTJOSM
	 XMLQ7OncZbm0My+fsBbb1B/Ys/rI0usc0P0H4TQ2DX5IFFKyGyKX0Ob/LARJ12B+Vu
	 VaqM7fU5IaddH0PcMc41SZ69OGZSZ7Ou3OTuFfGT2Wpz5OSEZEFkR2GKKYcKpBc0Qf
	 WP9gT7Dwi/dU6W5p/H3oMi/IC9JbPjOCFLz2RzSGLc4bo4frwgpXSa9g1sbFPxxbtB
	 3C0kLR75rx95Q==
Date: Thu, 10 Oct 2024 17:47:35 -0700
Subject: [PATCH 13/16] xfs: store a generic xfs_group pointer in
 xfs_getfsmap_info
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <172860641491.4176300.17972576030927697561.stgit@frogsfrogsfrogs>
In-Reply-To: <172860641207.4176300.780787546464458623.stgit@frogsfrogsfrogs>
References: <172860641207.4176300.780787546464458623.stgit@frogsfrogsfrogs>
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

Replace the pag and rtg pointers with a generic group pointer.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_fsmap.c |   26 ++++++++++++++------------
 1 file changed, 14 insertions(+), 12 deletions(-)


diff --git a/fs/xfs/xfs_fsmap.c b/fs/xfs/xfs_fsmap.c
index 5d5e54a16f23c8..c59ac36e76ab0e 100644
--- a/fs/xfs/xfs_fsmap.c
+++ b/fs/xfs/xfs_fsmap.c
@@ -158,7 +158,7 @@ struct xfs_getfsmap_info {
 	struct xfs_fsmap_head	*head;
 	struct fsmap		*fsmap_recs;	/* mapping records */
 	struct xfs_buf		*agf_bp;	/* AGF, for refcount queries */
-	struct xfs_perag	*pag;		/* AG info, if applicable */
+	struct xfs_group	*group;		/* group info, if applicable */
 	xfs_daddr_t		next_daddr;	/* next daddr we expect */
 	/* daddr of low fsmap key when we're using the rtbitmap */
 	xfs_daddr_t		low_daddr;
@@ -216,12 +216,13 @@ xfs_getfsmap_is_shared(
 	if (!xfs_has_reflink(mp))
 		return 0;
 	/* rt files will have no perag structure */
-	if (!info->pag)
+	if (!info->group)
 		return 0;
 
 	/* Are there any shared blocks here? */
 	flen = 0;
-	cur = xfs_refcountbt_init_cursor(mp, tp, info->agf_bp, info->pag);
+	cur = xfs_refcountbt_init_cursor(mp, tp, info->agf_bp,
+			to_perag(info->group));
 
 	error = xfs_refcount_find_shared(cur, rec->rm_startblock,
 			rec->rm_blockcount, &fbno, &flen, false);
@@ -353,7 +354,8 @@ xfs_getfsmap_helper(
 		return -ECANCELED;
 
 	trace_xfs_fsmap_mapping(mp, info->dev,
-			info->pag ? pag_agno(info->pag) : NULLAGNUMBER, rec);
+			info->group ? info->group->xg_index : NULLAGNUMBER,
+			rec);
 
 	fmr.fmr_device = info->dev;
 	fmr.fmr_physical = rec_daddr;
@@ -519,7 +521,7 @@ __xfs_getfsmap_datadev(
 		 * Set the AG high key from the fsmap high key if this
 		 * is the last AG that we're querying.
 		 */
-		info->pag = pag;
+		info->group = &pag->pag_group;
 		if (pag_agno(pag) == end_ag) {
 			info->high.rm_startblock = XFS_FSB_TO_AGBNO(mp,
 					end_fsb);
@@ -569,7 +571,7 @@ __xfs_getfsmap_datadev(
 			if (error)
 				break;
 		}
-		info->pag = NULL;
+		info->group = NULL;
 	}
 
 	if (bt_cur)
@@ -579,9 +581,9 @@ __xfs_getfsmap_datadev(
 		xfs_trans_brelse(tp, info->agf_bp);
 		info->agf_bp = NULL;
 	}
-	if (info->pag) {
-		xfs_perag_rele(info->pag);
-		info->pag = NULL;
+	if (info->group) {
+		xfs_perag_rele(pag);
+		info->group = NULL;
 	} else if (pag) {
 		/* loop termination case */
 		xfs_perag_rele(pag);
@@ -604,7 +606,7 @@ xfs_getfsmap_datadev_rmapbt_query(
 
 	/* Allocate cursor for this AG and query_range it. */
 	*curpp = xfs_rmapbt_init_cursor(tp->t_mountp, tp, info->agf_bp,
-			info->pag);
+			to_perag(info->group));
 	return xfs_rmap_query_range(*curpp, &info->low, &info->high,
 			xfs_getfsmap_datadev_helper, info);
 }
@@ -637,7 +639,7 @@ xfs_getfsmap_datadev_bnobt_query(
 
 	/* Allocate cursor for this AG and query_range it. */
 	*curpp = xfs_bnobt_init_cursor(tp->t_mountp, tp, info->agf_bp,
-			info->pag);
+			to_perag(info->group));
 	key->ar_startblock = info->low.rm_startblock;
 	key[1].ar_startblock = info->high.rm_startblock;
 	return xfs_alloc_query_range(*curpp, key, &key[1],
@@ -997,7 +999,7 @@ xfs_getfsmap(
 
 		info.dev = handlers[i].dev;
 		info.last = false;
-		info.pag = NULL;
+		info.group = NULL;
 		info.low_daddr = XFS_BUF_DADDR_NULL;
 		info.low.rm_blockcount = 0;
 		error = handlers[i].fn(tp, dkeys, &info);

