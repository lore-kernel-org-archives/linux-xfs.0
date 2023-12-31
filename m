Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD00CBA22
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 21:22:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Uo5DsPo2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D4A8C433C7;
	Sun, 31 Dec 2023 21:22:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704057775;
	bh=AYcKjhv0hfvCAibRPqL87MN3OigW2EQqNFeDayfh+k0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Uo5DsPo2iQaZW9Sub9s14xRRU3qr2upErk3JUuj0aHcW+16gyDrNj3SqeS/bm6Upc
	 +SjrK5La19bDXX1Ydngr/7phnqop2n/ix2aNzmbD8NkPc4mbGil6TUqjGtoJHm1z8d
	 +1Auox9YaX4oap2pQutSZmwFQmGjbF4xN7+MpCmk318fI0LNba/1abv1Y7Ql/b7jeP
	 Pfq2qxA1WDy0d8sF6oILJlN67lIVfkxLQIfvl8R3WM90J5iXORiBmy4RiLuXaGST8N
	 UQWyO5Iu+KKA0C1kJg0q0N95MXdwXKQbXCdilqPG6/4lZtwrY/79snK1MSM1OPyLLs
	 53KA8km0kY+4Q==
Date: Sun, 31 Dec 2023 13:22:55 -0800
Subject: [PATCH 03/14] xfs: refactor creation of bmap btree roots
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404847416.1763835.2597724773463537079.stgit@frogsfrogsfrogs>
In-Reply-To: <170404847334.1763835.8921217007526026461.stgit@frogsfrogsfrogs>
References: <170404847334.1763835.8921217007526026461.stgit@frogsfrogsfrogs>
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

Now that we've created inode fork helpers to allocate and free btree
roots, create a new bmap btree helper to create a new bmbt root, and
refactor the extents <-> btree conversion functions to use our new
helpers.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_bmap.c       |   17 ++++-------------
 fs/xfs/libxfs/xfs_bmap_btree.c |   16 ++++++++++++++++
 fs/xfs/libxfs/xfs_bmap_btree.h |    2 ++
 3 files changed, 22 insertions(+), 13 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index da89a76512776..bfc93cf0bd470 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -597,7 +597,7 @@ xfs_bmap_btree_to_extents(
 	xfs_trans_binval(tp, cbp);
 	if (cur->bc_levels[0].bp == cbp)
 		cur->bc_levels[0].bp = NULL;
-	xfs_iroot_realloc(ip, -1, whichfork);
+	xfs_iroot_free(ip, whichfork);
 	ASSERT(ifp->if_broot == NULL);
 	ifp->if_format = XFS_DINODE_FMT_EXTENTS;
 	*logflagsp |= XFS_ILOG_CORE | xfs_ilog_fext(whichfork);
@@ -637,20 +637,10 @@ xfs_bmap_extents_to_btree(
 	ifp = xfs_ifork_ptr(ip, whichfork);
 	ASSERT(ifp->if_format == XFS_DINODE_FMT_EXTENTS);
 
-	/*
-	 * Make space in the inode incore. This needs to be undone if we fail
-	 * to expand the root.
-	 */
-	xfs_iroot_realloc(ip, 1, whichfork);
-
-	/*
-	 * Fill in the root.
-	 */
-	block = ifp->if_broot;
-	xfs_btree_init_block(mp, block, &xfs_bmbt_ops, 1, 1, ip->i_ino);
 	/*
 	 * Need a cursor.  Can't allocate until bb_level is filled in.
 	 */
+	xfs_bmbt_iroot_alloc(ip, whichfork);
 	cur = xfs_bmbt_init_cursor(mp, tp, ip, whichfork);
 	cur->bc_ino.flags = wasdel ? XFS_BTCUR_BMBT_WASDEL : 0;
 	/*
@@ -706,6 +696,7 @@ xfs_bmap_extents_to_btree(
 	/*
 	 * Fill in the root key and pointer.
 	 */
+	block = ifp->if_broot;
 	kp = xfs_bmbt_key_addr(mp, block, 1);
 	arp = xfs_bmbt_rec_addr(mp, ablock, 1);
 	kp->br_startoff = cpu_to_be64(xfs_bmbt_disk_get_startoff(arp));
@@ -727,7 +718,7 @@ xfs_bmap_extents_to_btree(
 out_unreserve_dquot:
 	xfs_trans_mod_dquot_byino(tp, ip, XFS_TRANS_DQ_BCOUNT, -1L);
 out_root_realloc:
-	xfs_iroot_realloc(ip, -1, whichfork);
+	xfs_iroot_free(ip, whichfork);
 	ifp->if_format = XFS_DINODE_FMT_EXTENTS;
 	ASSERT(ifp->if_broot == NULL);
 	xfs_btree_del_cursor(cur, XFS_BTREE_ERROR);
diff --git a/fs/xfs/libxfs/xfs_bmap_btree.c b/fs/xfs/libxfs/xfs_bmap_btree.c
index da63d64f185c8..1bdb942c87e22 100644
--- a/fs/xfs/libxfs/xfs_bmap_btree.c
+++ b/fs/xfs/libxfs/xfs_bmap_btree.c
@@ -780,3 +780,19 @@ xfs_bmbt_destroy_cur_cache(void)
 	kmem_cache_destroy(xfs_bmbt_cur_cache);
 	xfs_bmbt_cur_cache = NULL;
 }
+
+/* Create an incore bmbt btree root block. */
+void
+xfs_bmbt_iroot_alloc(
+	struct xfs_inode	*ip,
+	int			whichfork)
+{
+	struct xfs_ifork	*ifp = xfs_ifork_ptr(ip, whichfork);
+
+	xfs_iroot_alloc(ip, whichfork,
+			xfs_bmap_broot_space_calc(ip->i_mount, 1));
+
+	/* Fill in the root. */
+	xfs_btree_init_block(ip->i_mount, ifp->if_broot, &xfs_bmbt_ops, 1, 1,
+			ip->i_ino);
+}
diff --git a/fs/xfs/libxfs/xfs_bmap_btree.h b/fs/xfs/libxfs/xfs_bmap_btree.h
index 62fbc4f7c2c40..3fe9c4f7f1a0b 100644
--- a/fs/xfs/libxfs/xfs_bmap_btree.h
+++ b/fs/xfs/libxfs/xfs_bmap_btree.h
@@ -196,4 +196,6 @@ xfs_bmap_bmdr_space(struct xfs_btree_block *bb)
 	return xfs_bmdr_space_calc(be16_to_cpu(bb->bb_numrecs));
 }
 
+void xfs_bmbt_iroot_alloc(struct xfs_inode *ip, int whichfork);
+
 #endif	/* __XFS_BMAP_BTREE_H__ */

