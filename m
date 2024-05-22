Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8B6B28EA
	for <linux-xfs@vger.kernel.org>; Wed, 22 May 2024 03:04:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716347050; cv=none; b=N+uJOJ3QqVNIlrn26SZxYiWBPUduLlRlHGvAml+a5MIuuK+s+HVCEF0C9I1K76E6plJaWeCkhk+q8rmK65k0vCv4wQqq78JgUl3qVsjZVkD8fkz0Dj3P9gXowm0MBCGYuYgromoPdcCUgrbbct3nkairA/KahLvegsDrXDVhezk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716347050; c=relaxed/simple;
	bh=UGLvgIqiXBZwld4qVEa4tJcseufRMxe5HUdDrCulOFM=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Bt2S04GZGo6fACyZCJ3HJAHV6Olstf1LkhfVPegslc4hWuEkAxui8oQNeZoWOoB2DXdcvF8TMI4bIHNqIR4wRC6UIxSaoTCIk+WEyX1SGNR+H6HpgN+ijXdBdoYZAxqgO54DtD9y062F3mEfZF1DLJU+CTf7err8rKLF6NDqzao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IuV4KeAB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IuV4KeAB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48F11C2BD11;
	Wed, 22 May 2024 03:04:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716347050;
	bh=UGLvgIqiXBZwld4qVEa4tJcseufRMxe5HUdDrCulOFM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=IuV4KeABHggwPAs075+iJjf3eDtzk10APIY4h515Ni8VF64zpl5w1hMAd817XDZDw
	 BWDgxoIxM31dWv2uTygDKAMoqf4Hk5Rn0dIPKK6x2UsqpvJixwNpuvqOYSDORluml8
	 rfN8poHAdDu+a/p/sO5rE9LPapMYTnMcXCXC04hum/Sp2XJ+u9tteb/O81q5bj3If0
	 5CuzGw31Tld4vxpeVUQaAcdeq6lYsXcvVPqvFEFqq4OBcDJgCDrW2cbGb6hzYbdFtS
	 lP4XYFbl1N81iUd0YHaDXm1hoMNyBvj9hQs/yx7dvQQxFWYfwNxFDdzULsX6izAamn
	 NkBPCoMLJpoCA==
Date: Tue, 21 May 2024 20:04:09 -0700
Subject: [PATCH 059/111] xfs: fold xfs_rmapbt_init_common into
 xfs_rmapbt_init_cursor
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <171634532583.2478931.18435147160295635315.stgit@frogsfrogsfrogs>
In-Reply-To: <171634531590.2478931.8474978645585392776.stgit@frogsfrogsfrogs>
References: <171634531590.2478931.8474978645585392776.stgit@frogsfrogsfrogs>
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
index 52c820108..fabab29e2 100644
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

