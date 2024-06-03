Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E8EF259C
	for <linux-xfs@vger.kernel.org>; Mon,  3 Jun 2024 19:08:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717441709; cv=none; b=HH95X2bakI7BaU344gx3GgNjuvnA1uvv726/4ctQNaea4nVaCOGYnAzTIuHqpZoUBp0o3kv0u0fboceGh8QdEBVanbFRdbIgQlPVusx33t8t25n6wx2hH8bPtUwUGvFTOxqAyLQwqwuRCuoCYDMk/c8s9gvhWxB2xb1MPYPL0V0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717441709; c=relaxed/simple;
	bh=dgRucX5Ble5l5b7tFLwaJBxQLsC98YbF1MuuThkKj+U=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CiOxYlIqOE5abNZDfql8z0QP6vV0Hm+4p21Ts6sTnUV446oxjovKVV8ZAd3NODCNxGzzHIo03OImeOepyg9D4Nd/7MU7bzfmFFsIPxwPPVX9ikmyvGXWStdNhIot0TF29Phnj4VEjaJEYj8tWRyq5UjRV6yQkSxFKj8tKi3N4lI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=inb/iQz6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="inb/iQz6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37E07C2BD10;
	Mon,  3 Jun 2024 19:08:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717441709;
	bh=dgRucX5Ble5l5b7tFLwaJBxQLsC98YbF1MuuThkKj+U=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=inb/iQz6FbV3T2OfHJlcYwVf2nVgitKTKJ7iswtdbq9+ASelqaADsWdEIVwnfrbOa
	 PElmH35zaV+kwu2/Qj9Jug/t3SMnHRPMSElau0/J0vvxnRZdnDQZVTNf90tj8cObN7
	 sf1xX9ivhnCaLo6dL26nzvN9TR20nu7i+Qq2WYnNILnxxb/oVx+XSkTYR1YjySEuUx
	 tdP0gdCmQtMs25b35WCs9vF1MbKzMPZo/0M/lympwsG1hgO1DCMH19ciDZdclyHnU3
	 IB5KYoiAjQixHxq73TIE+/+iZgqltIoCZclYtd/XhhuJiQN3wXqs3MSTA2fZc33i/G
	 HoczBXyN4x73Q==
Date: Mon, 03 Jun 2024 12:08:28 -0700
Subject: [PATCH 063/111] xfs: fold xfs_bmbt_init_common into
 xfs_bmbt_init_cursor
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cmaiolino@redhat.com>,
 linux-xfs@vger.kernel.org
Message-ID: <171744040320.1443973.15911039779735795986.stgit@frogsfrogsfrogs>
In-Reply-To: <171744039240.1443973.5959953049110025783.stgit@frogsfrogsfrogs>
References: <171744039240.1443973.5959953049110025783.stgit@frogsfrogsfrogs>
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
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
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

