Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA23C21353
	for <linux-xfs@vger.kernel.org>; Tue, 26 Mar 2024 03:43:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711424629; cv=none; b=PE/4AUn4TfFsBTcnic1qrVv7KTSM2qcmEtj2Whq6swH4ooSssYT4TmVVgmGb2cZkqlFZ2SnLL+tbdX7VBRKs4bMHnqHdW83D2o6AygGwgCi+3jAgCzCcDoDAgwfaeDlIhywknAx1y0zwG1Hjp5pYn256Rex71wi38OKFQcSm1R0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711424629; c=relaxed/simple;
	bh=R+vtwQX1964NBA5/7JSkGyIe2DOH7/Qg0yJiVpm3jls=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=m5l4HPHI2rddR/IAxp2d41BOG1d7KDrmNWDnm5cliet0gwwhK74qZ0PqrAdeiZGbx9I64Nc9hl3NXQhBe7giRjdxBKlQbGG/Xa8a0BMcwEYPnxLYFlbz5mveVb6ngqPQMkjZhUy6v2wYWJmSWoqdA7xDm5yh5UMmh48eRjk+bxk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lWze2ZdL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lWze2ZdL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CDCCC433F1;
	Tue, 26 Mar 2024 03:43:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711424629;
	bh=R+vtwQX1964NBA5/7JSkGyIe2DOH7/Qg0yJiVpm3jls=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=lWze2ZdLQWZAYeEPon+BXjKXOYe6WWnzMd9QrarZbtz1jbUEJA1aHpn87E1ACZP3h
	 C7WNKUbEGNEHEfFVUaUvDwT2JErkj2PkUr5eZBU70fEnVsG8nbWK22RMlV3EAqYy+K
	 0P1lVo5YxJwCxzMQ2XuE6wlMIdWjhk5eS2wEAfTNAWEZUUCTDvNt9wpSw6+2rkb2Pg
	 gZPNY8Uf501JLDzA2uXlZYHR/oqNgZELXWFMuwF9fVeW6F3AidJDw8O2NmJY6zrSd2
	 zBKp4UrGta4XkOUlcB6THCtktcBb1xKI4ia76NafUOjf3TBz0ZYPPk2DEjmIwjy57r
	 qrYokaQ4dS5dg==
Date: Mon, 25 Mar 2024 20:43:48 -0700
Subject: [PATCH 059/110] xfs: fold xfs_rmapbt_init_common into
 xfs_rmapbt_init_cursor
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <171142132233.2215168.8340083383680974902.stgit@frogsfrogsfrogs>
In-Reply-To: <171142131228.2215168.2795743548791967397.stgit@frogsfrogsfrogs>
References: <171142131228.2215168.2795743548791967397.stgit@frogsfrogsfrogs>
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

Source kernel commit: c49a4b2f0ef0ac5daee5c2a3cfd2b537345c34eb

Make the levels initialization in xfs_rmapbt_init_cursor conditional
and merge the two helpers.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_rmap_btree.c |   33 ++++++++++++++-------------------
 1 file changed, 14 insertions(+), 19 deletions(-)


diff --git a/libxfs/xfs_rmap_btree.c b/libxfs/xfs_rmap_btree.c
index 52c820108c55..fabab29e25ce 100644
--- a/libxfs/xfs_rmap_btree.c
+++ b/libxfs/xfs_rmap_btree.c
@@ -500,10 +500,16 @@ const struct xfs_btree_ops xfs_rmapbt_ops = {
 	.keys_contiguous	= xfs_rmapbt_keys_contiguous,
 };
 
-static struct xfs_btree_cur *
-xfs_rmapbt_init_common(
+/*
+ * Create a new reverse mapping btree cursor.
+ *
+ * For staging cursors tp and agbp are NULL.
+ */
+struct xfs_btree_cur *
+xfs_rmapbt_init_cursor(
 	struct xfs_mount	*mp,
 	struct xfs_trans	*tp,
+	struct xfs_buf		*agbp,
 	struct xfs_perag	*pag)
 {
 	struct xfs_btree_cur	*cur;
@@ -511,23 +517,12 @@ xfs_rmapbt_init_common(
 	cur = xfs_btree_alloc_cursor(mp, tp, XFS_BTNUM_RMAP, &xfs_rmapbt_ops,
 			mp->m_rmap_maxlevels, xfs_rmapbt_cur_cache);
 	cur->bc_ag.pag = xfs_perag_hold(pag);
-	return cur;
-}
-
-/* Create a new reverse mapping btree cursor. */
-struct xfs_btree_cur *
-xfs_rmapbt_init_cursor(
-	struct xfs_mount	*mp,
-	struct xfs_trans	*tp,
-	struct xfs_buf		*agbp,
-	struct xfs_perag	*pag)
-{
-	struct xfs_agf		*agf = agbp->b_addr;
-	struct xfs_btree_cur	*cur;
-
-	cur = xfs_rmapbt_init_common(mp, tp, pag);
-	cur->bc_nlevels = be32_to_cpu(agf->agf_levels[XFS_BTNUM_RMAP]);
 	cur->bc_ag.agbp = agbp;
+	if (agbp) {
+		struct xfs_agf		*agf = agbp->b_addr;
+
+		cur->bc_nlevels = be32_to_cpu(agf->agf_levels[XFS_BTNUM_RMAP]);
+	}
 	return cur;
 }
 
@@ -540,7 +535,7 @@ xfs_rmapbt_stage_cursor(
 {
 	struct xfs_btree_cur	*cur;
 
-	cur = xfs_rmapbt_init_common(mp, NULL, pag);
+	cur = xfs_rmapbt_init_cursor(mp, NULL, NULL, pag);
 	xfs_btree_stage_afakeroot(cur, afake);
 	return cur;
 }

