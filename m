Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87D2585289
	for <linux-xfs@vger.kernel.org>; Thu,  1 Feb 2024 19:49:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706816959; cv=none; b=AdUqu8GhXwpaRE873CGvSBCzFKNmkvZfgHX4dkZzZW9JsPKzMa2zvC5prrWUWu+FIWX21jnq2s1cohgchviqOdn+gUCOcH/c6FeEKYUABUQFgydCxqDkhlI+83cet9Dch1jy9+JG/HIVrs0pY3nFz1ILHwvWX4Lc9N+O5raW9dY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706816959; c=relaxed/simple;
	bh=sIK95JghIVrW8Xm4HMGzNMD1DjJRYRTkzLge9g1as8M=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IjXByvL7wjrzrr1SXN1sZcXw5kw3syQG5tlLc8gR24nlpHXgdSbWLHUVuc2ghrR+Kmt1Mcrnob3Dn8hmMa8/H9j4dhupktr0PlQ6hfNnd94MIoN1qv6IyNuHgBNOAJ/G/cVWpig2G/2AlJEMlPHclldKHLwp1cmNAGgMOHEF+Kg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=n3SRPKTm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="n3SRPKTm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55868C433C7;
	Thu,  1 Feb 2024 19:49:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706816959;
	bh=sIK95JghIVrW8Xm4HMGzNMD1DjJRYRTkzLge9g1as8M=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=n3SRPKTm4gVFSmoPkmpr99TT9ohIND4iwsxS2JRcWScKlrN95DGx8R+MA+qlF/bxu
	 sWFAZ0n3hLgUR2YCXYvUWTff4kypONd/6eUzdnCWjZSwDrleypjPFImy/Fn6VzrAOq
	 cHvsN3CAUmngRFOElcaCd1+M4zIKZXHwUEx5VujLP1pLSkBB2lZa8fdeOMNMd6VnwI
	 L6xtLacdq9zt9oqZvR5mIdraZVEg6lpuk4AFzk6UHXBtgkpDuEq+9R2kNh4txBZwJ7
	 Cg/BvCK8+yxR3aBGBrLG/L2Tg9cFQHF69iu4+pPkG00dpSSZPdvIJCqJpf7hC4UVp5
	 u2wl7zgxZoNfg==
Date: Thu, 01 Feb 2024 11:49:18 -0800
Subject: [PATCH 14/27] xfs: fold xfs_bmbt_init_common into
 xfs_bmbt_init_cursor
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <170681335011.1605438.18394075552185732861.stgit@frogsfrogsfrogs>
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

Make the levels initialization in xfs_bmbt_init_cursor conditional
and merge the two helpers.

This requires the fakeroot case to now pass a -1 whichfork directly
into xfs_bmbt_init_cursor, and some special casing for that, but
at least this scheme to deal with the fake btree root is handled and
documented in once place now.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
[djwong: tidy up a multline ternary]
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_bmap_btree.c |   58 +++++++++++++++++++---------------------
 1 file changed, 28 insertions(+), 30 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_bmap_btree.c b/fs/xfs/libxfs/xfs_bmap_btree.c
index 7381e507b32ba..c338c5be4c67a 100644
--- a/fs/xfs/libxfs/xfs_bmap_btree.c
+++ b/fs/xfs/libxfs/xfs_bmap_btree.c
@@ -544,44 +544,46 @@ const struct xfs_btree_ops xfs_bmbt_ops = {
 	.keys_contiguous	= xfs_bmbt_keys_contiguous,
 };
 
-static struct xfs_btree_cur *
-xfs_bmbt_init_common(
+/*
+ * Create a new bmap btree cursor.
+ *
+ * For staging cursors -1 in passed in whichfork.
+ */
+struct xfs_btree_cur *
+xfs_bmbt_init_cursor(
 	struct xfs_mount	*mp,
 	struct xfs_trans	*tp,
 	struct xfs_inode	*ip,
 	int			whichfork)
 {
 	struct xfs_btree_cur	*cur;
+	unsigned int		maxlevels;
 
 	ASSERT(whichfork != XFS_COW_FORK);
 
+	/*
+	 * The Data fork always has larger maxlevel, so use that for staging
+	 * cursors.
+	 */
+	switch (whichfork) {
+	case XFS_STAGING_FORK:
+		maxlevels = mp->m_bm_maxlevels[XFS_DATA_FORK];
+		break;
+	default:
+		maxlevels = mp->m_bm_maxlevels[whichfork];
+		break;
+	}
 	cur = xfs_btree_alloc_cursor(mp, tp, XFS_BTNUM_BMAP, &xfs_bmbt_ops,
-			mp->m_bm_maxlevels[whichfork], xfs_bmbt_cur_cache);
-
+			maxlevels, xfs_bmbt_cur_cache);
 	cur->bc_ino.ip = ip;
-	cur->bc_bmap.allocated = 0;
-	return cur;
-}
-
-/*
- * Allocate a new bmap btree cursor.
- */
-struct xfs_btree_cur *
-xfs_bmbt_init_cursor(
-	struct xfs_mount	*mp,
-	struct xfs_trans	*tp,
-	struct xfs_inode	*ip,
-	int			whichfork)
-{
-	struct xfs_ifork	*ifp = xfs_ifork_ptr(ip, whichfork);
-	struct xfs_btree_cur	*cur;
-
-	cur = xfs_bmbt_init_common(mp, tp, ip, whichfork);
-
-	cur->bc_nlevels = be16_to_cpu(ifp->if_broot->bb_level) + 1;
-	cur->bc_ino.forksize = xfs_inode_fork_size(ip, whichfork);
 	cur->bc_ino.whichfork = whichfork;
+	cur->bc_bmap.allocated = 0;
+	if (whichfork != XFS_STAGING_FORK) {
+		struct xfs_ifork	*ifp = xfs_ifork_ptr(ip, whichfork);
 
+		cur->bc_nlevels = be16_to_cpu(ifp->if_broot->bb_level) + 1;
+		cur->bc_ino.forksize = xfs_inode_fork_size(ip, whichfork);
+	}
 	return cur;
 }
 
@@ -610,11 +612,7 @@ xfs_bmbt_stage_cursor(
 {
 	struct xfs_btree_cur	*cur;
 
-	/* data fork always has larger maxheight */
-	cur = xfs_bmbt_init_common(mp, NULL, ip, XFS_DATA_FORK);
-
-	/* Don't let anyone think we're attached to the real fork yet. */
-	cur->bc_ino.whichfork = XFS_STAGING_FORK;
+	cur = xfs_bmbt_init_cursor(mp, NULL, ip, XFS_STAGING_FORK);
 	xfs_btree_stage_ifakeroot(cur, ifake);
 	return cur;
 }

