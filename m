Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF99ABA22
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 20:18:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lG4SoHXF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FF04C433C7;
	Sun, 31 Dec 2023 20:18:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704053911;
	bh=d/Ec/fd+xFSCH249P+Q4VRsCVNRUzzwSu6Qe3D3boDw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=lG4SoHXFPHJJGbDpbtMROF3/EhBe+NSszOgk0tdSzPgXtJX4tlW94ohilUqzk885u
	 +KFIOndrsOzJWSzWrgm42apBy6mqf82thp7Ix09MEyIkT0yneU1H1vWRu5tKsPPBtI
	 0YWnMW363AmD9PhKPH+MwKt3L3AdKzkoJTNhBlaRJHCfd8GpvP6co3Rd6YoJWm4WB1
	 sxy7iTmgfho+5cexrg6Eog+0gs5vMDj4IAY9BOxIQGPqVevftSb3w0igYuMi+Rl1ky
	 Wg5CVthLOXzE4DPeJfXIIqeMLitvbvl6SBQRvta1nNJNY9sDBuHW0Yi4aKhkJa7HsL
	 ywV9XDU7LmMaw==
Date: Sun, 31 Dec 2023 12:18:31 -0800
Subject: [PATCH 6/9] xfs: btree convert xfs_btree_init_block to
 xfs_btree_init_buf calls
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404830610.1749286.7818323072611455833.stgit@frogsfrogsfrogs>
In-Reply-To: <170404830490.1749286.17145905891935561298.stgit@frogsfrogsfrogs>
References: <170404830490.1749286.17145905891935561298.stgit@frogsfrogsfrogs>
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

Convert any place we call xfs_btree_init_block with a buffer to use the
_init_buf function.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_bmap.c  |    3 +--
 fs/xfs/libxfs/xfs_btree.c |    3 +--
 fs/xfs/scrub/xfbtree.c    |    3 +--
 3 files changed, 3 insertions(+), 6 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 59cad8b79fb6d..75ab7d203c6de 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -690,8 +690,7 @@ xfs_bmap_extents_to_btree(
 	 */
 	abp->b_ops = &xfs_bmbt_buf_ops;
 	ablock = XFS_BUF_TO_BLOCK(abp);
-	xfs_btree_init_block(mp, ablock, &xfs_bmbt_ops, xfs_buf_daddr(abp),
-			0, 0, ip->i_ino);
+	xfs_btree_init_buf(mp, abp, &xfs_bmbt_ops, 0, 0, ip->i_ino);
 
 	for_each_xfs_iext(ifp, &icur, &rec) {
 		if (isnullstartblock(rec.br_startblock))
diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index 742e24b24ba26..0fdaacefe45e2 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -1289,8 +1289,7 @@ xfs_btree_init_block_cur(
 	else
 		owner = cur->bc_ag.pag->pag_agno;
 
-	xfs_btree_init_block(cur->bc_mp, XFS_BUF_TO_BLOCK(bp), cur->bc_ops,
-			xfs_buf_daddr(bp), level, numrecs, owner);
+	xfs_btree_init_buf(cur->bc_mp, bp, cur->bc_ops, level, numrecs, owner);
 }
 
 /*
diff --git a/fs/xfs/scrub/xfbtree.c b/fs/xfs/scrub/xfbtree.c
index e9445da09845f..f37f35c206354 100644
--- a/fs/xfs/scrub/xfbtree.c
+++ b/fs/xfs/scrub/xfbtree.c
@@ -446,8 +446,7 @@ xfbtree_init_leaf_block(
 	trace_xfbtree_create_root_buf(xfbt, bp);
 
 	bp->b_ops = cfg->btree_ops->buf_ops;
-	xfs_btree_init_block(mp, bp->b_addr, cfg->btree_ops, daddr, 0, 0,
-			cfg->owner);
+	xfs_btree_init_buf(mp, bp, cfg->btree_ops, 0, 0, cfg->owner);
 	error = xfs_bwrite(bp);
 	xfs_buf_relse(bp);
 	if (error)

