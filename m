Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 430CB6F067
	for <linux-xfs@vger.kernel.org>; Wed, 22 May 2024 03:05:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716347113; cv=none; b=aUmJKsR/h3U2WcnCobZuI11+qi1EDSQhVW8fuwGFGS5+NZUHWh+wd9W6e4Hf3+X9gSLFUX/ZUHWx7DcVm2kEvG7LkYNscT0HaA8JhhPlJSga4XuUorZkbPEi9ESLU0m5TaBZTNa/HXQ9FOSqge9vkVqCdBsAxIViX+iHi70eeg4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716347113; c=relaxed/simple;
	bh=Hi3M0xfbW4hbWMxdCxszsFONeOck4FiaeN6MO1ws8zM=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cCTrJvtXsvRbiMMuB6wo2SymcM1z/oEfHY3oKKCip4pGiKyb0qOi0iFUcrUi++aTCpk0vE2qdmU6joEZG76zf8IPJMDtnHBVO4K5n2zz9iucs7PVh6IfyhvpXGhX/C+tk0IS9G1zq58CzVmNPk5EVd1yGQsS8LKuynhlx8+w+UI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MGO5d8Cx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MGO5d8Cx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5766C2BD11;
	Wed, 22 May 2024 03:05:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716347112;
	bh=Hi3M0xfbW4hbWMxdCxszsFONeOck4FiaeN6MO1ws8zM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=MGO5d8CxYnk3v1C0eCxUmvEW3til881fRfMxW9+QEYvOAcqtcYeJYFCA00OFvPQVq
	 GCFHPMFlDlOGvV9zBjN72puwM0Sv1e/UyJcYmNYM0gnJq3IWOSxQjAznN/9z+B5Y5t
	 2+rhTgP3yIv61BMbyfElhFG0uWR3FaM2Lodm74ezhHuU3zBbpkNDmBueH2h4LBkBu8
	 Z3pSzrvVJ8VJJB3G3aKZzJ50WPBgvyn66TIJoJY2pPDA/D28LkV0wdYKdZ1HldL+13
	 zbpsuLYCPc5eXI+QezxsEwTbz2d9NBVMj8NiV6+ypCWPKbBPQhhAXH4DXotJ49Lxnz
	 aXcYMvqRBdoiA==
Date: Tue, 21 May 2024 20:05:12 -0700
Subject: [PATCH 063/111] xfs: fold xfs_bmbt_init_common into
 xfs_bmbt_init_cursor
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <171634532643.2478931.17111664387925009710.stgit@frogsfrogsfrogs>
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

Source kernel commit: 802f91f7b1d535ac975e2d696bf5b5dea82816e7

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
 libxfs/xfs_bmap_btree.c |   58 +++++++++++++++++++++++------------------------
 1 file changed, 28 insertions(+), 30 deletions(-)


diff --git a/libxfs/xfs_bmap_btree.c b/libxfs/xfs_bmap_btree.c
index 6b377d129..0afe541c5 100644
--- a/libxfs/xfs_bmap_btree.c
+++ b/libxfs/xfs_bmap_btree.c
@@ -543,44 +543,46 @@ const struct xfs_btree_ops xfs_bmbt_ops = {
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
 
@@ -609,11 +611,7 @@ xfs_bmbt_stage_cursor(
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

