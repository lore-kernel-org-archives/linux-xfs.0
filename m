Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE70043AC7
	for <linux-xfs@vger.kernel.org>; Thu,  1 Feb 2024 19:50:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706817038; cv=none; b=KFsQoAdOQV1cXEypW6YOaL61LGc895fejMk0GSdaXhPJ+lwRJBks7BTmDO2ZnOUeC22+0DdWmA9HJuVWf0OLNHgBJxvWG1i2AF+qwU0PNqFb54dMwPGM9kTUwdISFxvLDMSwqD/jdQfG8PyAL9hBp+0+H/vYuikybiJiAodTZw8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706817038; c=relaxed/simple;
	bh=Oe5oIACyuvZx0RgZqCw0CPFolf/dFwgi0GHpLI+36jY=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PDwNrt+MBaTlejapAsEKm3RzxBsYSwvMmRHTNzSbiKY2/ynCziY5GxFmTs8RzwQnoSLNMrJwLZp57IJuyaqsdpP+7iSBwkQghBkg6b8Z7hNr+sCpUlrI+DdNozm0DMrzFxyodEFCn1AANf7ITolJl2TyVw1RRi1VtOc/4HtMur4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uIgNs2KU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uIgNs2KU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76095C433C7;
	Thu,  1 Feb 2024 19:50:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706817037;
	bh=Oe5oIACyuvZx0RgZqCw0CPFolf/dFwgi0GHpLI+36jY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=uIgNs2KUEoyoEwv5Vb6GrXvYbY9y/lJufiAmlRP5tcNFe8FrF7+H4N7sV17gVnmmN
	 Xl15o2Jy5GhNxFaJfZl5Wb3W9M8sk8w341rf1oyxWylIWe8WGbIdByHffitMIj4m+Z
	 wZ3EjZfBJCX/wZKvncGLFCjJQ3SjNXjOADDW/iVfW7/fklJhqx2QDxTrwplJ7p7s2C
	 O9qvVOPdhQ504KwE828DJp0vRZkxAjz632fv019fPtnl6VjS5sSjLf6YcUXRnnYFKb
	 Tv6Dh8WGAVLzZ+CCLbkdvbhFGnQlJlrDSpDMkal5Fly0g8erTwbJBGOproQNNLmWyZ
	 WPOtNW74SgX2w==
Date: Thu, 01 Feb 2024 11:50:37 -0800
Subject: [PATCH 19/27] xfs: refactor the btree cursor allocation logic in
 xchk_ag_btcur_init
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <170681335097.1605438.484002687955974347.stgit@frogsfrogsfrogs>
In-Reply-To: <170681334718.1605438.17032954797722239513.stgit@frogsfrogsfrogs>
References: <170681334718.1605438.17032954797722239513.stgit@frogsfrogsfrogs>
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

Change xchk_ag_btcur_init to allocate all cursors first and only then
check if we should delete them again because the btree is to damaged.

This allows reusing the sick_mask in struct xfs_btree_ops and simplifies
the code.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/common.c |   60 ++++++++++++++++++++++++++-----------------------
 fs/xfs/scrub/health.c |   54 ++++++++------------------------------------
 fs/xfs/scrub/health.h |    4 ++-
 3 files changed, 44 insertions(+), 74 deletions(-)


diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
index 699092195f41b..689d40578bd5b 100644
--- a/fs/xfs/scrub/common.c
+++ b/fs/xfs/scrub/common.c
@@ -588,46 +588,50 @@ xchk_ag_btcur_init(
 {
 	struct xfs_mount	*mp = sc->mp;
 
-	if (sa->agf_bp &&
-	    xchk_ag_btree_healthy_enough(sc, sa->pag, XFS_BTNUM_BNO)) {
+	if (sa->agf_bp) {
 		/* Set up a bnobt cursor for cross-referencing. */
 		sa->bno_cur = xfs_allocbt_init_cursor(mp, sc->tp, sa->agf_bp,
 				sa->pag, XFS_BTNUM_BNO);
-	}
+		xchk_ag_btree_del_cursor_if_sick(sc, &sa->bno_cur,
+				XFS_SCRUB_TYPE_BNOBT);
 
-	if (sa->agf_bp &&
-	    xchk_ag_btree_healthy_enough(sc, sa->pag, XFS_BTNUM_CNT)) {
 		/* Set up a cntbt cursor for cross-referencing. */
 		sa->cnt_cur = xfs_allocbt_init_cursor(mp, sc->tp, sa->agf_bp,
 				sa->pag, XFS_BTNUM_CNT);
+		xchk_ag_btree_del_cursor_if_sick(sc, &sa->cnt_cur,
+				XFS_SCRUB_TYPE_CNTBT);
+
+		/* Set up a rmapbt cursor for cross-referencing. */
+		if (xfs_has_rmapbt(mp)) {
+			sa->rmap_cur = xfs_rmapbt_init_cursor(mp, sc->tp,
+					sa->agf_bp, sa->pag);
+			xchk_ag_btree_del_cursor_if_sick(sc, &sa->rmap_cur,
+					XFS_SCRUB_TYPE_RMAPBT);
+		}
+
+		/* Set up a refcountbt cursor for cross-referencing. */
+		if (xfs_has_reflink(mp)) {
+			sa->refc_cur = xfs_refcountbt_init_cursor(mp, sc->tp,
+					sa->agf_bp, sa->pag);
+			xchk_ag_btree_del_cursor_if_sick(sc, &sa->refc_cur,
+					XFS_SCRUB_TYPE_REFCNTBT);
+		}
 	}
 
-	/* Set up a inobt cursor for cross-referencing. */
-	if (sa->agi_bp &&
-	    xchk_ag_btree_healthy_enough(sc, sa->pag, XFS_BTNUM_INO)) {
+	if (sa->agi_bp) {
+		/* Set up a inobt cursor for cross-referencing. */
 		sa->ino_cur = xfs_inobt_init_cursor(sa->pag, sc->tp, sa->agi_bp,
 				XFS_BTNUM_INO);
-	}
+		xchk_ag_btree_del_cursor_if_sick(sc, &sa->ino_cur,
+				XFS_SCRUB_TYPE_INOBT);
 
-	/* Set up a finobt cursor for cross-referencing. */
-	if (sa->agi_bp && xfs_has_finobt(mp) &&
-	    xchk_ag_btree_healthy_enough(sc, sa->pag, XFS_BTNUM_FINO)) {
-		sa->fino_cur = xfs_inobt_init_cursor(sa->pag, sc->tp, sa->agi_bp,
-				XFS_BTNUM_FINO);
-	}
-
-	/* Set up a rmapbt cursor for cross-referencing. */
-	if (sa->agf_bp && xfs_has_rmapbt(mp) &&
-	    xchk_ag_btree_healthy_enough(sc, sa->pag, XFS_BTNUM_RMAP)) {
-		sa->rmap_cur = xfs_rmapbt_init_cursor(mp, sc->tp, sa->agf_bp,
-				sa->pag);
-	}
-
-	/* Set up a refcountbt cursor for cross-referencing. */
-	if (sa->agf_bp && xfs_has_reflink(mp) &&
-	    xchk_ag_btree_healthy_enough(sc, sa->pag, XFS_BTNUM_REFC)) {
-		sa->refc_cur = xfs_refcountbt_init_cursor(mp, sc->tp,
-				sa->agf_bp, sa->pag);
+		/* Set up a finobt cursor for cross-referencing. */
+		if (xfs_has_finobt(mp)) {
+			sa->fino_cur = xfs_inobt_init_cursor(sa->pag, sc->tp,
+					sa->agi_bp, XFS_BTNUM_FINO);
+			xchk_ag_btree_del_cursor_if_sick(sc, &sa->fino_cur,
+					XFS_SCRUB_TYPE_FINOBT);
+		}
 	}
 }
 
diff --git a/fs/xfs/scrub/health.c b/fs/xfs/scrub/health.c
index 34db207c7ceff..117de6e764296 100644
--- a/fs/xfs/scrub/health.c
+++ b/fs/xfs/scrub/health.c
@@ -252,13 +252,13 @@ xchk_update_health(
 }
 
 /* Is the given per-AG btree healthy enough for scanning? */
-bool
-xchk_ag_btree_healthy_enough(
+void
+xchk_ag_btree_del_cursor_if_sick(
 	struct xfs_scrub	*sc,
-	struct xfs_perag	*pag,
-	xfs_btnum_t		btnum)
+	struct xfs_btree_cur	**curp,
+	unsigned int		sm_type)
 {
-	unsigned int		mask = 0;
+	unsigned int		mask = (*curp)->bc_ops->sick_mask;
 
 	/*
 	 * We always want the cursor if it's the same type as whatever we're
@@ -267,41 +267,8 @@ xchk_ag_btree_healthy_enough(
 	 * Otherwise, we're only interested in the btree for cross-referencing.
 	 * If we know the btree is bad then don't bother, just set XFAIL.
 	 */
-	switch (btnum) {
-	case XFS_BTNUM_BNO:
-		if (sc->sm->sm_type == XFS_SCRUB_TYPE_BNOBT)
-			return true;
-		mask = XFS_SICK_AG_BNOBT;
-		break;
-	case XFS_BTNUM_CNT:
-		if (sc->sm->sm_type == XFS_SCRUB_TYPE_CNTBT)
-			return true;
-		mask = XFS_SICK_AG_CNTBT;
-		break;
-	case XFS_BTNUM_INO:
-		if (sc->sm->sm_type == XFS_SCRUB_TYPE_INOBT)
-			return true;
-		mask = XFS_SICK_AG_INOBT;
-		break;
-	case XFS_BTNUM_FINO:
-		if (sc->sm->sm_type == XFS_SCRUB_TYPE_FINOBT)
-			return true;
-		mask = XFS_SICK_AG_FINOBT;
-		break;
-	case XFS_BTNUM_RMAP:
-		if (sc->sm->sm_type == XFS_SCRUB_TYPE_RMAPBT)
-			return true;
-		mask = XFS_SICK_AG_RMAPBT;
-		break;
-	case XFS_BTNUM_REFC:
-		if (sc->sm->sm_type == XFS_SCRUB_TYPE_REFCNTBT)
-			return true;
-		mask = XFS_SICK_AG_REFCNTBT;
-		break;
-	default:
-		ASSERT(0);
-		return true;
-	}
+	if (sc->sm->sm_type == sm_type)
+		return;
 
 	/*
 	 * If we just repaired some AG metadata, sc->sick_mask will reflect all
@@ -313,12 +280,11 @@ xchk_ag_btree_healthy_enough(
 	    type_to_health_flag[sc->sm->sm_type].group == XHG_AG)
 		mask &= ~sc->sick_mask;
 
-	if (xfs_ag_has_sickness(pag, mask)) {
+	if (xfs_ag_has_sickness((*curp)->bc_ag.pag, mask)) {
 		sc->sm->sm_flags |= XFS_SCRUB_OFLAG_XFAIL;
-		return false;
+		xfs_btree_del_cursor(*curp, XFS_BTREE_NOERROR);
+		*curp = NULL;
 	}
-
-	return true;
 }
 
 /*
diff --git a/fs/xfs/scrub/health.h b/fs/xfs/scrub/health.h
index 06d17941776cc..63fc426eb5aea 100644
--- a/fs/xfs/scrub/health.h
+++ b/fs/xfs/scrub/health.h
@@ -8,8 +8,8 @@
 
 unsigned int xchk_health_mask_for_scrub_type(__u32 scrub_type);
 void xchk_update_health(struct xfs_scrub *sc);
-bool xchk_ag_btree_healthy_enough(struct xfs_scrub *sc, struct xfs_perag *pag,
-		xfs_btnum_t btnum);
+void xchk_ag_btree_del_cursor_if_sick(struct xfs_scrub *sc,
+		struct xfs_btree_cur **curp, unsigned int sm_type);
 void xchk_mark_healthy_if_clean(struct xfs_scrub *sc, unsigned int mask);
 bool xchk_file_looks_zapped(struct xfs_scrub *sc, unsigned int mask);
 int xchk_health_record(struct xfs_scrub *sc);

