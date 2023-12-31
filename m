Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DC65C12D
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 22:21:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nF5ABrIL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAB05C433C7;
	Sun, 31 Dec 2023 22:21:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704061279;
	bh=5KgCB5lgpmCYEZ9pmGfzy5uOPpCtc6/T+SCu6xk2xQc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=nF5ABrILlGULIEZruG+eM3VLpN85J9cI0g/Ih8lItTgKI+sl/57lga9bj0UwUQZBY
	 HLBFXlG/fMeruSubhnsrAGypXsql7eInIIGXfGk9dTLR2L+XpvfFF2umtkg5i/JuDn
	 1hVFkexgj5z/ICdiqLOQvGWfKz8GgkZmxPJS/xH+5Uw7RMOBg+c0GLUikcYxXQbyLK
	 IduAktyiU9PpcS4Ds9FHbU76S1/5S+lmwIfS3VGVDuxOLuTavZEC6SPcErQzms8jPP
	 kt0NeqwUJbRPPLegZ45Z79U4r8ySAbhtv5E0Pl95piO/y3J3UeWySbVbETgZ4qVRh0
	 iyXoVwKskRyWw==
Date: Sun, 31 Dec 2023 14:21:19 -0800
Subject: [PATCH 6/9] xfs: btree convert xfs_btree_init_block to
 xfs_btree_init_buf calls
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404994069.1795132.2055529925177763976.stgit@frogsfrogsfrogs>
In-Reply-To: <170404993983.1795132.17312636757680803212.stgit@frogsfrogsfrogs>
References: <170404993983.1795132.17312636757680803212.stgit@frogsfrogsfrogs>
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
 libxfs/xfbtree.c   |    3 +--
 libxfs/xfs_bmap.c  |    3 +--
 libxfs/xfs_btree.c |    3 +--
 3 files changed, 3 insertions(+), 6 deletions(-)


diff --git a/libxfs/xfbtree.c b/libxfs/xfbtree.c
index ad4e42d6b2a..7310f29a8c2 100644
--- a/libxfs/xfbtree.c
+++ b/libxfs/xfbtree.c
@@ -402,8 +402,7 @@ xfbtree_init_leaf_block(
 	trace_xfbtree_create_root_buf(xfbt, bp);
 
 	bp->b_ops = cfg->btree_ops->buf_ops;
-	xfs_btree_init_block(mp, bp->b_addr, cfg->btree_ops, daddr, 0, 0,
-			cfg->owner);
+	xfs_btree_init_buf(mp, bp, cfg->btree_ops, 0, 0, cfg->owner);
 	error = xfs_bwrite(bp);
 	xfs_buf_relse(bp);
 	if (error)
diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index 5e3a973e490..1c53204e1d5 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -684,8 +684,7 @@ xfs_bmap_extents_to_btree(
 	 */
 	abp->b_ops = &xfs_bmbt_buf_ops;
 	ablock = XFS_BUF_TO_BLOCK(abp);
-	xfs_btree_init_block(mp, ablock, &xfs_bmbt_ops, xfs_buf_daddr(abp),
-			0, 0, ip->i_ino);
+	xfs_btree_init_buf(mp, abp, &xfs_bmbt_ops, 0, 0, ip->i_ino);
 
 	for_each_xfs_iext(ifp, &icur, &rec) {
 		if (isnullstartblock(rec.br_startblock))
diff --git a/libxfs/xfs_btree.c b/libxfs/xfs_btree.c
index 452ebd7095d..c8bbda80b40 100644
--- a/libxfs/xfs_btree.c
+++ b/libxfs/xfs_btree.c
@@ -1286,8 +1286,7 @@ xfs_btree_init_block_cur(
 	else
 		owner = cur->bc_ag.pag->pag_agno;
 
-	xfs_btree_init_block(cur->bc_mp, XFS_BUF_TO_BLOCK(bp), cur->bc_ops,
-			xfs_buf_daddr(bp), level, numrecs, owner);
+	xfs_btree_init_buf(cur->bc_mp, bp, cur->bc_ops, level, numrecs, owner);
 }
 
 /*

