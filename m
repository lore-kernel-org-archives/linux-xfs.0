Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE22BC127
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 22:21:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TklNEGJP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45AA1C433C7;
	Sun, 31 Dec 2023 22:21:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704061264;
	bh=AdItQf2FW4KknGl18FRbhRR8h9T5f2//uFWbqGH4T7Q=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=TklNEGJP7yC1L1OupVCRbIE4z5/vg6HRdZS9jjJqLGt48wjJ2rpTL2mn5s6G5Fig0
	 VvAROxUNm7ljVwLskHCAluGuPVrq+/5hDPXzozxbrrSvfmxFME7uWoAkGKsfJd+AsW
	 E25DbqW1J/RInRXYKUy7aA2XOnLPEAE2KZAhpwH2Kzb8q/F774WMMT9a594Nr3vyWu
	 9v11S6R9cL+6Xsd3u5eT/shljAUDgXkzqOGGfsTgkwVWUWv+aOJrbv6a0ml+1wjO9s
	 E4wPFZO6uF9STPuHa4uBpe/9Ihd6AvkBsxSTAaemH0g+bVSAdl5yBFBV1isqqWEiOh
	 58ncWz6pIw8qw==
Date: Sun, 31 Dec 2023 14:21:03 -0800
Subject: [PATCH 5/9] xfs: rename btree block/buffer init functions
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404994055.1795132.3112115897922046848.stgit@frogsfrogsfrogs>
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

Rename xfs_btree_init_block_int to xfs_btree_init_block, and
xfs_btree_init_block to xfs_btree_init_buf so that the name suggests the
type that caller are supposed to pass in.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfbtree.c           |    2 +-
 libxfs/xfs_ag.c            |    6 +++---
 libxfs/xfs_bmap.c          |    6 +++---
 libxfs/xfs_bmap_btree.c    |    2 +-
 libxfs/xfs_btree.c         |    8 ++++----
 libxfs/xfs_btree.h         |    4 ++--
 libxfs/xfs_btree_staging.c |    2 +-
 7 files changed, 15 insertions(+), 15 deletions(-)


diff --git a/libxfs/xfbtree.c b/libxfs/xfbtree.c
index 97edb4a2b2b..ad4e42d6b2a 100644
--- a/libxfs/xfbtree.c
+++ b/libxfs/xfbtree.c
@@ -402,7 +402,7 @@ xfbtree_init_leaf_block(
 	trace_xfbtree_create_root_buf(xfbt, bp);
 
 	bp->b_ops = cfg->btree_ops->buf_ops;
-	xfs_btree_init_block_int(mp, bp->b_addr, cfg->btree_ops, daddr, 0, 0,
+	xfs_btree_init_block(mp, bp->b_addr, cfg->btree_ops, daddr, 0, 0,
 			cfg->owner);
 	error = xfs_bwrite(bp);
 	xfs_buf_relse(bp);
diff --git a/libxfs/xfs_ag.c b/libxfs/xfs_ag.c
index 9ac49e0a66b..ddd5584f23e 100644
--- a/libxfs/xfs_ag.c
+++ b/libxfs/xfs_ag.c
@@ -471,7 +471,7 @@ xfs_btroot_init(
 	struct xfs_buf		*bp,
 	struct aghdr_init_data	*id)
 {
-	xfs_btree_init_block(mp, bp, id->bc_ops, 0, 0, id->agno);
+	xfs_btree_init_buf(mp, bp, id->bc_ops, 0, 0, id->agno);
 }
 
 /* Finish initializing a free space btree. */
@@ -537,7 +537,7 @@ xfs_bnoroot_init(
 	struct xfs_buf		*bp,
 	struct aghdr_init_data	*id)
 {
-	xfs_btree_init_block(mp, bp, id->bc_ops, 0, 0, id->agno);
+	xfs_btree_init_buf(mp, bp, id->bc_ops, 0, 0, id->agno);
 	xfs_freesp_init_recs(mp, bp, id);
 }
 
@@ -553,7 +553,7 @@ xfs_rmaproot_init(
 	struct xfs_btree_block	*block = XFS_BUF_TO_BLOCK(bp);
 	struct xfs_rmap_rec	*rrec;
 
-	xfs_btree_init_block(mp, bp, id->bc_ops, 0, 4, id->agno);
+	xfs_btree_init_buf(mp, bp, id->bc_ops, 0, 4, id->agno);
 
 	/*
 	 * mark the AG header regions as static metadata The BNO
diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index e7c39ec72f0..5e3a973e490 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -638,8 +638,8 @@ xfs_bmap_extents_to_btree(
 	 * Fill in the root.
 	 */
 	block = ifp->if_broot;
-	xfs_btree_init_block_int(mp, block, &xfs_bmbt_ops, XFS_BUF_DADDR_NULL,
-			1, 1, ip->i_ino);
+	xfs_btree_init_block(mp, block, &xfs_bmbt_ops, XFS_BUF_DADDR_NULL, 1,
+			1, ip->i_ino);
 	/*
 	 * Need a cursor.  Can't allocate until bb_level is filled in.
 	 */
@@ -684,7 +684,7 @@ xfs_bmap_extents_to_btree(
 	 */
 	abp->b_ops = &xfs_bmbt_buf_ops;
 	ablock = XFS_BUF_TO_BLOCK(abp);
-	xfs_btree_init_block_int(mp, ablock, &xfs_bmbt_ops, xfs_buf_daddr(abp),
+	xfs_btree_init_block(mp, ablock, &xfs_bmbt_ops, xfs_buf_daddr(abp),
 			0, 0, ip->i_ino);
 
 	for_each_xfs_iext(ifp, &icur, &rec) {
diff --git a/libxfs/xfs_bmap_btree.c b/libxfs/xfs_bmap_btree.c
index b599201d97a..ea6bd791eff 100644
--- a/libxfs/xfs_bmap_btree.c
+++ b/libxfs/xfs_bmap_btree.c
@@ -42,7 +42,7 @@ xfs_bmdr_to_bmbt(
 	xfs_bmbt_key_t		*tkp;
 	__be64			*tpp;
 
-	xfs_btree_init_block_int(mp, rblock, &xfs_bmbt_ops, XFS_BUF_DADDR_NULL,
+	xfs_btree_init_block(mp, rblock, &xfs_bmbt_ops, XFS_BUF_DADDR_NULL,
 			0, 0, ip->i_ino);
 	rblock->bb_level = dblock->bb_level;
 	ASSERT(be16_to_cpu(rblock->bb_level) > 0);
diff --git a/libxfs/xfs_btree.c b/libxfs/xfs_btree.c
index d3b2b903def..452ebd7095d 100644
--- a/libxfs/xfs_btree.c
+++ b/libxfs/xfs_btree.c
@@ -1210,7 +1210,7 @@ xfs_btree_set_sibling(
 }
 
 void
-xfs_btree_init_block_int(
+xfs_btree_init_block(
 	struct xfs_mount	*mp,
 	struct xfs_btree_block	*buf,
 	const struct xfs_btree_ops *ops,
@@ -1252,7 +1252,7 @@ xfs_btree_init_block_int(
 }
 
 void
-xfs_btree_init_block(
+xfs_btree_init_buf(
 	struct xfs_mount		*mp,
 	struct xfs_buf			*bp,
 	const struct xfs_btree_ops	*ops,
@@ -1260,7 +1260,7 @@ xfs_btree_init_block(
 	__u16				numrecs,
 	__u64				owner)
 {
-	xfs_btree_init_block_int(mp, XFS_BUF_TO_BLOCK(bp), ops,
+	xfs_btree_init_block(mp, XFS_BUF_TO_BLOCK(bp), ops,
 			xfs_buf_daddr(bp), level, numrecs, owner);
 }
 
@@ -1286,7 +1286,7 @@ xfs_btree_init_block_cur(
 	else
 		owner = cur->bc_ag.pag->pag_agno;
 
-	xfs_btree_init_block_int(cur->bc_mp, XFS_BUF_TO_BLOCK(bp), cur->bc_ops,
+	xfs_btree_init_block(cur->bc_mp, XFS_BUF_TO_BLOCK(bp), cur->bc_ops,
 			xfs_buf_daddr(bp), level, numrecs, owner);
 }
 
diff --git a/libxfs/xfs_btree.h b/libxfs/xfs_btree.h
index 4ee3f13625e..6a27c34e68c 100644
--- a/libxfs/xfs_btree.h
+++ b/libxfs/xfs_btree.h
@@ -451,10 +451,10 @@ xfs_btree_reada_bufs(
 /*
  * Initialise a new btree block header
  */
-void xfs_btree_init_block(struct xfs_mount *mp, struct xfs_buf *bp,
+void xfs_btree_init_buf(struct xfs_mount *mp, struct xfs_buf *bp,
 		const struct xfs_btree_ops *ops, __u16 level, __u16 numrecs,
 		__u64 owner);
-void xfs_btree_init_block_int(struct xfs_mount *mp,
+void xfs_btree_init_block(struct xfs_mount *mp,
 		struct xfs_btree_block *buf, const struct xfs_btree_ops *ops,
 		xfs_daddr_t blkno, __u16 level, __u16 numrecs, __u64 owner);
 
diff --git a/libxfs/xfs_btree_staging.c b/libxfs/xfs_btree_staging.c
index e535d10e13f..c2f39702b7b 100644
--- a/libxfs/xfs_btree_staging.c
+++ b/libxfs/xfs_btree_staging.c
@@ -410,7 +410,7 @@ xfs_btree_bload_prep_block(
 		ifp->if_broot_bytes = (int)new_size;
 
 		/* Initialize it and send it out. */
-		xfs_btree_init_block_int(cur->bc_mp, ifp->if_broot,
+		xfs_btree_init_block(cur->bc_mp, ifp->if_broot,
 				cur->bc_ops, XFS_BUF_DADDR_NULL, level,
 				nr_this_block, cur->bc_ino.ip->i_ino);
 

