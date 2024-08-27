Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F35D1442E8
	for <linux-xfs@vger.kernel.org>; Tue, 27 Aug 2024 23:35:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724801734; cv=none; b=RPYWaaiARkDK3CiwrVMn3eOpMgTnFS4WKdm3Cp2VuBSefYS1n/tMk5F+nEcFbQYfyp9VlU+EJ6L5mhYdzl0aXn3JnnonUqmVoab5jKArMYi4phJu+Q4FzSYQZ44+ZfJT0vsqrNmAJKxRuG8HjV/iZqRaOm5ji44F/k20L3fh0PM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724801734; c=relaxed/simple;
	bh=KypFq5hR2qtY/gxAHPtLsC5fjpwCnCTQOshXQF1knwQ=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SgKFD5GmNjhIVT8TMNfJKs8Gni54QVG01BFKf/2bKChHaFNL7LSjxYXQBHWFDv27OP2wGALKq5Bk26cPpZeO1rukDEgnkhxPXp7jew/h9OUsr50o6OTyMuqmxy6WEkI+TEBoeTJn/y/+OGhjLWJW/eYCh6B3yuTMA/chG8k4j4w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qmCTAwSN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qmCTAwSN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC9C7C5676C;
	Tue, 27 Aug 2024 23:35:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724801733;
	bh=KypFq5hR2qtY/gxAHPtLsC5fjpwCnCTQOshXQF1knwQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=qmCTAwSNNq7o2A8VmG5taYGlBYw2Rygu7oDV7/pVH6F6UtBzjSKdDMJPqKUrtda6F
	 2edYO8SyNPsibDR2YuBLTuryYYPGJ4SyF155luhR59Pdpi6HMzVF2matwdbEBAHTwQ
	 PKuXTUt34/sCmGa4MciBohgGeyMaCUCgdwGOAcKHX/bskjXUIyq9jhsZZ8/fwOdGgw
	 pLZJcYzAA0jINpHDWNUMse1VH6tuQo8NlYp/Lq+FQsETZsb2LyOlkDIEbeG0Kr7ElD
	 HYNzBIuxV6bMjSpDCqGID6fihhI4nQfNyFi9kHPhh29f6P0dk7oO5wQocGpdT8/WuV
	 I5MXP34p/v2EQ==
Date: Tue, 27 Aug 2024 16:35:33 -0700
Subject: [PATCH 07/10] xfs: refactor creation of bmap btree roots
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <172480131627.2291268.8798821424165754100.stgit@frogsfrogsfrogs>
In-Reply-To: <172480131476.2291268.1290356315337515850.stgit@frogsfrogsfrogs>
References: <172480131476.2291268.1290356315337515850.stgit@frogsfrogsfrogs>
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
 fs/xfs/libxfs/xfs_bmap.c       |   20 ++++++--------------
 fs/xfs/libxfs/xfs_bmap_btree.c |   13 +++++++++++++
 fs/xfs/libxfs/xfs_bmap_btree.h |    2 ++
 3 files changed, 21 insertions(+), 14 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 00cac756c9566..e3922cf75381c 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -614,7 +614,7 @@ xfs_bmap_btree_to_extents(
 	xfs_trans_binval(tp, cbp);
 	if (cur->bc_levels[0].bp == cbp)
 		cur->bc_levels[0].bp = NULL;
-	xfs_iroot_realloc(ip, -1, whichfork);
+	xfs_iroot_free(ip, whichfork);
 	ASSERT(ifp->if_broot == NULL);
 	ifp->if_format = XFS_DINODE_FMT_EXTENTS;
 	*logflagsp |= XFS_ILOG_CORE | xfs_ilog_fext(whichfork);
@@ -655,19 +655,10 @@ xfs_bmap_extents_to_btree(
 	ASSERT(ifp->if_format == XFS_DINODE_FMT_EXTENTS);
 
 	/*
-	 * Make space in the inode incore. This needs to be undone if we fail
-	 * to expand the root.
-	 */
-	xfs_iroot_realloc(ip, 1, whichfork);
-
-	/*
-	 * Fill in the root.
-	 */
-	block = ifp->if_broot;
-	xfs_bmbt_init_block(ip, block, NULL, 1, 1);
-	/*
-	 * Need a cursor.  Can't allocate until bb_level is filled in.
+	 * Fill in the root, create a cursor.  Can't allocate until bb_level is
+	 * filled in.
 	 */
+	xfs_bmbt_iroot_alloc(ip, whichfork);
 	cur = xfs_bmbt_init_cursor(mp, tp, ip, whichfork);
 	if (wasdel)
 		cur->bc_flags |= XFS_BTREE_BMBT_WASDEL;
@@ -724,6 +715,7 @@ xfs_bmap_extents_to_btree(
 	/*
 	 * Fill in the root key and pointer.
 	 */
+	block = ifp->if_broot;
 	kp = xfs_bmbt_key_addr(mp, block, 1);
 	arp = xfs_bmbt_rec_addr(mp, ablock, 1);
 	kp->br_startoff = cpu_to_be64(xfs_bmbt_disk_get_startoff(arp));
@@ -745,7 +737,7 @@ xfs_bmap_extents_to_btree(
 out_unreserve_dquot:
 	xfs_trans_mod_dquot_byino(tp, ip, XFS_TRANS_DQ_BCOUNT, -1L);
 out_root_realloc:
-	xfs_iroot_realloc(ip, -1, whichfork);
+	xfs_iroot_free(ip, whichfork);
 	ifp->if_format = XFS_DINODE_FMT_EXTENTS;
 	ASSERT(ifp->if_broot == NULL);
 	xfs_btree_del_cursor(cur, XFS_BTREE_ERROR);
diff --git a/fs/xfs/libxfs/xfs_bmap_btree.c b/fs/xfs/libxfs/xfs_bmap_btree.c
index 3695b3ad07d4d..0769644d30412 100644
--- a/fs/xfs/libxfs/xfs_bmap_btree.c
+++ b/fs/xfs/libxfs/xfs_bmap_btree.c
@@ -759,3 +759,16 @@ xfs_bmbt_destroy_cur_cache(void)
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
+	struct xfs_mount	*mp = ip->i_mount;
+	struct xfs_ifork	*ifp = xfs_ifork_ptr(ip, whichfork);
+
+	xfs_iroot_alloc(ip, whichfork, xfs_bmap_broot_space_calc(mp, 1));
+	xfs_bmbt_init_block(ip, ifp->if_broot, NULL, 1, 1);
+}
diff --git a/fs/xfs/libxfs/xfs_bmap_btree.h b/fs/xfs/libxfs/xfs_bmap_btree.h
index b7842c3420f04..a187f4b120ea1 100644
--- a/fs/xfs/libxfs/xfs_bmap_btree.h
+++ b/fs/xfs/libxfs/xfs_bmap_btree.h
@@ -204,4 +204,6 @@ xfs_bmap_bmdr_space(struct xfs_btree_block *bb)
 	return xfs_bmdr_space_calc(be16_to_cpu(bb->bb_numrecs));
 }
 
+void xfs_bmbt_iroot_alloc(struct xfs_inode *ip, int whichfork);
+
 #endif	/* __XFS_BMAP_BTREE_H__ */

