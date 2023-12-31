Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF5C7BA22
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 21:34:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Vl5EssTB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC4BDC433C7;
	Sun, 31 Dec 2023 21:34:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704058448;
	bh=A34v3rmtFN5HWJhDZDZ0Auj9cLXQggVzOGhlw3N0rN0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Vl5EssTBSSG5UiE0pJ+qOMRz5DrVjWFIvRg2pBgBgOznhZbJqndTbyq5tjqiTLvED
	 /tmYxfIq17ApL4BEoklSP0NLF77q21tIOAnB7zhgstyd4opIKnfuP2cvQpKnwLCscm
	 TgFtrXZ02u4Ozjf1Y1OX3jjdi3Zhoq9rBlbagVzjbVVnenCLqWQX20b8K7EW/PE8wJ
	 xfmKaX6K6EexA6gh+bsmE9VewRHpbMoaN5+s+nfnY0p5EdeYR9JH792o6LxfilOnTm
	 h1ezxgN6RuUCldsVv0d4mwV1lb3XJi9jTfUPrTfOnjXSBIWoJiLivRdwxlPS9SyRbu
	 RLGGL86o95dEg==
Date: Sun, 31 Dec 2023 13:34:08 -0800
Subject: [PATCH 09/39] xfs: support recovering rmap intent items targetting
 realtime extents
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404850047.1764998.4734291595014223853.stgit@frogsfrogsfrogs>
In-Reply-To: <170404849811.1764998.10873316890301599216.stgit@frogsfrogsfrogs>
References: <170404849811.1764998.10873316890301599216.stgit@frogsfrogsfrogs>
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

Now that we have rmap on the realtime device, log recovery has to
support remapping extents on the realtime volume.  Make this work.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_rmap_item.c |   21 ++++++++++++++++++---
 1 file changed, 18 insertions(+), 3 deletions(-)


diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
index 229b5127d4716..580baf3b1b1d3 100644
--- a/fs/xfs/xfs_rmap_item.c
+++ b/fs/xfs/xfs_rmap_item.c
@@ -451,6 +451,7 @@ xfs_rmap_update_abort_intent(
 static inline bool
 xfs_rui_validate_map(
 	struct xfs_mount		*mp,
+	bool				isrt,
 	struct xfs_map_extent		*map)
 {
 	if (!xfs_has_rmapbt(mp))
@@ -480,6 +481,9 @@ xfs_rui_validate_map(
 	if (!xfs_verify_fileext(mp, map->me_startoff, map->me_len))
 		return false;
 
+	if (isrt)
+		return xfs_verify_rtbext(mp, map->me_startblock, map->me_len);
+
 	return xfs_verify_fsbext(mp, map->me_startblock, map->me_len);
 }
 
@@ -487,6 +491,7 @@ static inline void
 xfs_rui_recover_work(
 	struct xfs_mount		*mp,
 	struct xfs_defer_pending	*dfp,
+	bool				isrt,
 	const struct xfs_map_extent	*map)
 {
 	struct xfs_rmap_intent		*ri;
@@ -531,7 +536,15 @@ xfs_rui_recover_work(
 	ri->ri_bmap.br_blockcount = map->me_len;
 	ri->ri_bmap.br_state = (map->me_flags & XFS_RMAP_EXTENT_UNWRITTEN) ?
 			XFS_EXT_UNWRITTEN : XFS_EXT_NORM;
-	ri->ri_pag = xfs_perag_intent_get(mp, map->me_startblock);
+	ri->ri_realtime = isrt;
+	if (isrt) {
+		xfs_rgnumber_t	rgno;
+
+		rgno = xfs_rtb_to_rgno(mp, map->me_startblock);
+		ri->ri_rtg = xfs_rtgroup_get(mp, rgno);
+	} else {
+		ri->ri_pag = xfs_perag_intent_get(mp, map->me_startblock);
+	}
 
 	xfs_defer_add_item(dfp, &ri->ri_list);
 }
@@ -550,6 +563,7 @@ xfs_rmap_recover_work(
 	struct xfs_rui_log_item		*ruip = RUI_ITEM(lip);
 	struct xfs_trans		*tp;
 	struct xfs_mount		*mp = lip->li_log->l_mp;
+	bool				isrt = xfs_rui_item_isrt(lip);
 	int				i;
 	int				error = 0;
 
@@ -559,7 +573,7 @@ xfs_rmap_recover_work(
 	 * just toss the RUI.
 	 */
 	for (i = 0; i < ruip->rui_format.rui_nextents; i++) {
-		if (!xfs_rui_validate_map(mp,
+		if (!xfs_rui_validate_map(mp, isrt,
 					&ruip->rui_format.rui_extents[i])) {
 			XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
 					&ruip->rui_format,
@@ -567,7 +581,8 @@ xfs_rmap_recover_work(
 			return -EFSCORRUPTED;
 		}
 
-		xfs_rui_recover_work(mp, dfp, &ruip->rui_format.rui_extents[i]);
+		xfs_rui_recover_work(mp, dfp, isrt,
+				&ruip->rui_format.rui_extents[i]);
 	}
 
 	resv = xlog_recover_resv(&M_RES(mp)->tr_itruncate);

