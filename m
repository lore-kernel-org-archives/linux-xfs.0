Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EEE31AAA3F
	for <linux-xfs@vger.kernel.org>; Thu, 19 Dec 2024 19:25:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734636345; cv=none; b=dabhj20hikXg3zSNHu7cJ0//WqOjtSnzZIB4A1VqQLfGWI4NHb7wohomFqUezQifi2RGEYQId4TLCzct88oOCt7j2KhncypP4GLguxbbS7RKhuGMyP7HLjWE2GaBmIDjX4ko6gdgKTNKCD8Mr/p4dJ1Jj4mmeuCK5P5DCcfOxT8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734636345; c=relaxed/simple;
	bh=j4/+z8XATtYC6MA0NIbY4FufmbJlL5R4ffS0qafyohc=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sQARW+o4ahvXZL5KxkoizxBdzKpRFFrI8TRWBX2NFxjWWx4ejBKa2+j4k4uFR4dADGELVNb8ENTF+FHR7WiDL3q7+DbkPK09aik7kF3aXnFGS+ETRVKWLsz1XdBpC1FM2T7VwXPEj40XuNWwUBXKvIhxK0DMGMvnVKaqkJeFr4g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YNcWpCCm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YNcWpCCm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AB12C4CED0;
	Thu, 19 Dec 2024 19:25:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734636345;
	bh=j4/+z8XATtYC6MA0NIbY4FufmbJlL5R4ffS0qafyohc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=YNcWpCCm0wMijXqia/W+VaGaViLnBE5+jKAH7uZhUOnulgsOaTMuFzuDMTM9OkQjP
	 dwcZEOYtI2ps6Ah3sWpxRlzObGD1vLdWVt9RHjCr/YtdIwRt3m/GRunSHjhi3j4da3
	 /EDwA7bEVrO+uCXlKC1dq6bSWVa0dE91gu7+DxFbAXINFSoY4WYC/uLoatZvmAlIXM
	 jG5ZTmcrw1bTYiaM++K6nkm1rWYpdaxV/bExdaf0INpLYmLUfdTxHRX1uzkHJ0TmPT
	 kimFeO4mu7Dwu0bg78TW4DNWtSdkauvLvChZPqSdd70ukQDbr5l0vcb/zQlca0O4wk
	 twT+VS3W2Sqiw==
Date: Thu, 19 Dec 2024 11:25:44 -0800
Subject: [PATCH 09/37] xfs: support recovering rmap intent items targetting
 realtime extents
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <173463579909.1571512.14351368873422789232.stgit@frogsfrogsfrogs>
In-Reply-To: <173463579653.1571512.7862891421559358642.stgit@frogsfrogsfrogs>
References: <173463579653.1571512.7862891421559358642.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Now that we have rmap on the realtime device and rmap intent items that
target the realtime device, log recovery has to support remapping
extents on the realtime volume.  Make this work.  Identify rtrmapbt
blocks in the log correctly so that we can validate them during log
recovery.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_buf_item_recover.c |    4 ++++
 fs/xfs/xfs_rmap_item.c        |   15 ++++++++++++---
 2 files changed, 16 insertions(+), 3 deletions(-)


diff --git a/fs/xfs/xfs_buf_item_recover.c b/fs/xfs/xfs_buf_item_recover.c
index 3d0c6402cb3634..4f2e4ea29e1f57 100644
--- a/fs/xfs/xfs_buf_item_recover.c
+++ b/fs/xfs/xfs_buf_item_recover.c
@@ -262,6 +262,9 @@ xlog_recover_validate_buf_type(
 		case XFS_BMAP_MAGIC:
 			bp->b_ops = &xfs_bmbt_buf_ops;
 			break;
+		case XFS_RTRMAP_CRC_MAGIC:
+			bp->b_ops = &xfs_rtrmapbt_buf_ops;
+			break;
 		case XFS_RMAP_CRC_MAGIC:
 			bp->b_ops = &xfs_rmapbt_buf_ops;
 			break;
@@ -855,6 +858,7 @@ xlog_recover_get_buf_lsn(
 		uuid = &btb->bb_u.s.bb_uuid;
 		break;
 	}
+	case XFS_RTRMAP_CRC_MAGIC:
 	case XFS_BMAP_CRC_MAGIC:
 	case XFS_BMAP_MAGIC: {
 		struct xfs_btree_block *btb = blk;
diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
index e8caa600a95cae..89decffe76c8b5 100644
--- a/fs/xfs/xfs_rmap_item.c
+++ b/fs/xfs/xfs_rmap_item.c
@@ -459,6 +459,7 @@ xfs_rmap_update_abort_intent(
 static inline bool
 xfs_rui_validate_map(
 	struct xfs_mount		*mp,
+	bool				isrt,
 	struct xfs_map_extent		*map)
 {
 	if (!xfs_has_rmapbt(mp))
@@ -488,6 +489,9 @@ xfs_rui_validate_map(
 	if (!xfs_verify_fileext(mp, map->me_startoff, map->me_len))
 		return false;
 
+	if (isrt)
+		return xfs_verify_rtbext(mp, map->me_startblock, map->me_len);
+
 	return xfs_verify_fsbext(mp, map->me_startblock, map->me_len);
 }
 
@@ -495,6 +499,7 @@ static inline void
 xfs_rui_recover_work(
 	struct xfs_mount		*mp,
 	struct xfs_defer_pending	*dfp,
+	bool				isrt,
 	const struct xfs_map_extent	*map)
 {
 	struct xfs_rmap_intent		*ri;
@@ -539,7 +544,9 @@ xfs_rui_recover_work(
 	ri->ri_bmap.br_blockcount = map->me_len;
 	ri->ri_bmap.br_state = (map->me_flags & XFS_RMAP_EXTENT_UNWRITTEN) ?
 			XFS_EXT_UNWRITTEN : XFS_EXT_NORM;
-	ri->ri_group = xfs_group_intent_get(mp, map->me_startblock, XG_TYPE_AG);
+	ri->ri_group = xfs_group_intent_get(mp, map->me_startblock,
+			isrt ? XG_TYPE_RTG : XG_TYPE_AG);
+	ri->ri_realtime = isrt;
 
 	xfs_defer_add_item(dfp, &ri->ri_list);
 }
@@ -558,6 +565,7 @@ xfs_rmap_recover_work(
 	struct xfs_rui_log_item		*ruip = RUI_ITEM(lip);
 	struct xfs_trans		*tp;
 	struct xfs_mount		*mp = lip->li_log->l_mp;
+	bool				isrt = xfs_rui_item_isrt(lip);
 	int				i;
 	int				error = 0;
 
@@ -567,7 +575,7 @@ xfs_rmap_recover_work(
 	 * just toss the RUI.
 	 */
 	for (i = 0; i < ruip->rui_format.rui_nextents; i++) {
-		if (!xfs_rui_validate_map(mp,
+		if (!xfs_rui_validate_map(mp, isrt,
 					&ruip->rui_format.rui_extents[i])) {
 			XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
 					&ruip->rui_format,
@@ -575,7 +583,8 @@ xfs_rmap_recover_work(
 			return -EFSCORRUPTED;
 		}
 
-		xfs_rui_recover_work(mp, dfp, &ruip->rui_format.rui_extents[i]);
+		xfs_rui_recover_work(mp, dfp, isrt,
+				&ruip->rui_format.rui_extents[i]);
 	}
 
 	resv = xlog_recover_resv(&M_RES(mp)->tr_itruncate);

