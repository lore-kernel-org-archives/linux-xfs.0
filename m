Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA5BBC127
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 22:21:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QteMpV7R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A9D4C433C7;
	Sun, 31 Dec 2023 22:21:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704061295;
	bh=8mD7v80Zh3zTC0Gv801scn614GUH0/LBmt159Tv49HA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=QteMpV7RVCWXoCJz2fG6OP1Q88Khhsw6PSNUUbHIuw5Invfk/jnkw5EdCAUIPuUUn
	 ecYVUlYm6bS60K4ZpuM4LfJDyhQZ2rpYrIThkNXGSArWpQ7Je32XbTx1bSLV1Lukgf
	 NE1lLeySDAVVbvuvJmC3diYXoAXrnph7Y6dxdSqCZPkMGERGGZKtpwl/9cWK38hAsi
	 P2/ukZ3/qlU9dXi9VBa55Se5ZGumopSIrHSWkeT8wIHO+TB9CsTR1U5uJIRUi7B9Tz
	 z6EUjrCllg3Pu62u9TDFSHCdxYJ/Ems/5ysrG/8dS2IGQ1yBZ2Z7RT1Jt99JYxn3ip
	 +15lVw2i15nwQ==
Date: Sun, 31 Dec 2023 14:21:35 -0800
Subject: [PATCH 7/9] xfs: remove the unnecessary daddr paramter to _init_block
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404994083.1795132.2433498207897795023.stgit@frogsfrogsfrogs>
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

Now that all of the callers pass XFS_BUF_DADDR_NULL as the daddr
parameter, we can elide that too.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_bmap.c          |    3 +--
 libxfs/xfs_bmap_btree.c    |    3 +--
 libxfs/xfs_btree.c         |   19 ++++++++++++++++---
 libxfs/xfs_btree.h         |    2 +-
 libxfs/xfs_btree_staging.c |    5 ++---
 5 files changed, 21 insertions(+), 11 deletions(-)


diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index 1c53204e1d5..46551021755 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -638,8 +638,7 @@ xfs_bmap_extents_to_btree(
 	 * Fill in the root.
 	 */
 	block = ifp->if_broot;
-	xfs_btree_init_block(mp, block, &xfs_bmbt_ops, XFS_BUF_DADDR_NULL, 1,
-			1, ip->i_ino);
+	xfs_btree_init_block(mp, block, &xfs_bmbt_ops, 1, 1, ip->i_ino);
 	/*
 	 * Need a cursor.  Can't allocate until bb_level is filled in.
 	 */
diff --git a/libxfs/xfs_bmap_btree.c b/libxfs/xfs_bmap_btree.c
index ea6bd791eff..1dd85d4d41c 100644
--- a/libxfs/xfs_bmap_btree.c
+++ b/libxfs/xfs_bmap_btree.c
@@ -42,8 +42,7 @@ xfs_bmdr_to_bmbt(
 	xfs_bmbt_key_t		*tkp;
 	__be64			*tpp;
 
-	xfs_btree_init_block(mp, rblock, &xfs_bmbt_ops, XFS_BUF_DADDR_NULL,
-			0, 0, ip->i_ino);
+	xfs_btree_init_block(mp, rblock, &xfs_bmbt_ops, 0, 0, ip->i_ino);
 	rblock->bb_level = dblock->bb_level;
 	ASSERT(be16_to_cpu(rblock->bb_level) > 0);
 	rblock->bb_numrecs = dblock->bb_numrecs;
diff --git a/libxfs/xfs_btree.c b/libxfs/xfs_btree.c
index c8bbda80b40..218e96d7976 100644
--- a/libxfs/xfs_btree.c
+++ b/libxfs/xfs_btree.c
@@ -1209,8 +1209,8 @@ xfs_btree_set_sibling(
 	}
 }
 
-void
-xfs_btree_init_block(
+static void
+__xfs_btree_init_block(
 	struct xfs_mount	*mp,
 	struct xfs_btree_block	*buf,
 	const struct xfs_btree_ops *ops,
@@ -1251,6 +1251,19 @@ xfs_btree_init_block(
 	}
 }
 
+void
+xfs_btree_init_block(
+	struct xfs_mount	*mp,
+	struct xfs_btree_block	*block,
+	const struct xfs_btree_ops *ops,
+	__u16			level,
+	__u16			numrecs,
+	__u64			owner)
+{
+	__xfs_btree_init_block(mp, block, ops, XFS_BUF_DADDR_NULL, level,
+			numrecs, owner);
+}
+
 void
 xfs_btree_init_buf(
 	struct xfs_mount		*mp,
@@ -1260,7 +1273,7 @@ xfs_btree_init_buf(
 	__u16				numrecs,
 	__u64				owner)
 {
-	xfs_btree_init_block(mp, XFS_BUF_TO_BLOCK(bp), ops,
+	__xfs_btree_init_block(mp, XFS_BUF_TO_BLOCK(bp), ops,
 			xfs_buf_daddr(bp), level, numrecs, owner);
 }
 
diff --git a/libxfs/xfs_btree.h b/libxfs/xfs_btree.h
index 6a27c34e68c..41000bd6ccc 100644
--- a/libxfs/xfs_btree.h
+++ b/libxfs/xfs_btree.h
@@ -456,7 +456,7 @@ void xfs_btree_init_buf(struct xfs_mount *mp, struct xfs_buf *bp,
 		__u64 owner);
 void xfs_btree_init_block(struct xfs_mount *mp,
 		struct xfs_btree_block *buf, const struct xfs_btree_ops *ops,
-		xfs_daddr_t blkno, __u16 level, __u16 numrecs, __u64 owner);
+		__u16 level, __u16 numrecs, __u64 owner);
 
 /*
  * Common btree core entry points.
diff --git a/libxfs/xfs_btree_staging.c b/libxfs/xfs_btree_staging.c
index c2f39702b7b..ec496915433 100644
--- a/libxfs/xfs_btree_staging.c
+++ b/libxfs/xfs_btree_staging.c
@@ -410,9 +410,8 @@ xfs_btree_bload_prep_block(
 		ifp->if_broot_bytes = (int)new_size;
 
 		/* Initialize it and send it out. */
-		xfs_btree_init_block(cur->bc_mp, ifp->if_broot,
-				cur->bc_ops, XFS_BUF_DADDR_NULL, level,
-				nr_this_block, cur->bc_ino.ip->i_ino);
+		xfs_btree_init_block(cur->bc_mp, ifp->if_broot, cur->bc_ops,
+				level, nr_this_block, cur->bc_ino.ip->i_ino);
 
 		*bpp = NULL;
 		*blockp = ifp->if_broot;

