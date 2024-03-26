Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43D1E21353
	for <linux-xfs@vger.kernel.org>; Tue, 26 Mar 2024 03:44:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711424692; cv=none; b=TkBfIiIJwKJDEV4cSOnmvpXRY0d5ZUq8lA93BUgsC+BB2X+JQaPlhsy+CI7N6XW0LoB+tMG6zKNSGZ0qhnXkWkLKzJRUTakqFYuDlS+BrGR8vqlXad+xh0Jg02XKiCupaQsnmFqIPET1TkTPs7hOj4Fq9ILTLgtHj8EjtijzeTA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711424692; c=relaxed/simple;
	bh=u+Hlv1SMq1wRJxqyDlL60GdZomr2ClWrTJk2S9VTw50=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aC7jQMH3pVEtHNRAXOEoCT1ga93SrWjpWZf0Prvf/8SJkiCYowgAcq6VwtrWz1yeFTfP4JOSW5wno854Vnu/VeWuA5zhF+fgN2tTM72WKSQR0QdeHigQdd8qd+rNBD6Ec965+L5AiiT2E7VykOcjXSe9Q/JIft7VRmP3CR07H4I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DtquyrPo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DtquyrPo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1917CC43390;
	Tue, 26 Mar 2024 03:44:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711424692;
	bh=u+Hlv1SMq1wRJxqyDlL60GdZomr2ClWrTJk2S9VTw50=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=DtquyrPoaDTGXdHndQEBsXjh9Sr+Njj9Qp48hiaFGIio7Pw3Ihjl5Qatxa+Fhj2KX
	 fwHxcDDq+KBgc5nDzMGkZ8avFsHvr2UiwNN4dg8xStOcEXjMnEUnko901xlF4Gg8R/
	 GkFHFNDVeKzeRgX46CUdEbEq+e5LwyTYw6Km7V/uMPP38uYzQbJ2npqjiRECtNI/18
	 EOub81GpSFtsAbrxMLQLxqonluOTBFhduk4p/596S/sQJfLvSyeAKVnyqbojGqJfyY
	 DdneF2YxFQ0awqmDyWYR1h/OtPkERN/zzc7KQr/X4fe9PhCOK64BfCXHHrqEv5Rhya
	 yiQbPEO84ts0Q==
Date: Mon, 25 Mar 2024 20:44:51 -0700
Subject: [PATCH 063/110] xfs: fold xfs_bmbt_init_common into
 xfs_bmbt_init_cursor
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <171142132285.2215168.11945292114926479927.stgit@frogsfrogsfrogs>
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
index 6b377d129c33..0afe541c52cd 100644
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

