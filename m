Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F6F71D53C
	for <linux-xfs@vger.kernel.org>; Tue, 26 Mar 2024 03:36:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711424190; cv=none; b=dwCz9a2TXIKE+WgTmMpDfIiHJkp3YAM5xuTHzIwwwNKSG04Ge1m6I4jZrB4WUKAFEhQ3TmDhZZcUKrWSbK1FsRym8LZlDAYmSlCwji1QngdxTZqaGOq1nBM0L5R3G4LQ7W1ZnEKeyD56OXRu/NY/JAcZM4cDXD2wDpfQ10IQepA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711424190; c=relaxed/simple;
	bh=b3WsYmQrW47RwTZx78loyqiOgJPekTZ0AayZ98FTsYE=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=i0v8epjF4P1JLjtSmy9IGR4JsPqeuCqgV6YYoLIPwbd77x8IhN06PvB/OaDZv+aPmkrmnHBFMkG6xWS9dK/WqdWPKj38GF+lsz611BfobfCIoojKYny1BtrJ4sWk0LFOGhcgt1rRh0aOPvY/mcu+kLyElaZE0Dir2AyYNeM5Nv0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HZqZ1MDi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HZqZ1MDi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 353A6C433F1;
	Tue, 26 Mar 2024 03:36:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711424190;
	bh=b3WsYmQrW47RwTZx78loyqiOgJPekTZ0AayZ98FTsYE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=HZqZ1MDizwV2LQwMdf499HOnlXeZ8ZbM/eZu/yaBFmC7iu2rQwmG+CAaMnLhvjtG2
	 7cVXZYuVyMiQxK8BXHvBj5E5tbYfG+xZIohF0u0kGi6fk5s6k+Spo5Bh6D3tV+Amfz
	 Lk4su4IvKbRglV2F0qTR80iuxE6LHY3Y3q0BDplggu+tQzJovAG03hAnL2d8EEXDU7
	 ZKtrL/z0+JPxpep3L18aBQvinguwmEIF2L1ISlC6QQTfI+PwpKQR+LzjD6By9GnDs8
	 FONCAASnY3GXqFFGZRbYPtnkubkf+x752zw1S2QwHoLxHL9EKZ3nyj0+wn9jyHQo2a
	 lqLgEYeqUSrNw==
Date: Mon, 25 Mar 2024 20:36:29 -0700
Subject: [PATCH 031/110] xfs: drop XFS_BTREE_CRC_BLOCKS
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <171142131831.2215168.6142774252369504121.stgit@frogsfrogsfrogs>
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

From: Darrick J. Wong <djwong@kernel.org>

Source kernel commit: f9e325bf61d1fb3ef5f705268a22de95809db9fa

All existing btree types set XFS_BTREE_CRC_BLOCKS when running against a
V5 filesystem.  All currently proposed btree types are V5 only and use
the richer XFS_BTREE_CRC_BLOCKS format.  Therefore, we can drop this
flag and change the conditional to xfs_has_crc.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_alloc_btree.c    |    3 ---
 libxfs/xfs_bmap_btree.c     |    2 --
 libxfs/xfs_btree.c          |    8 ++++----
 libxfs/xfs_btree.h          |    1 -
 libxfs/xfs_ialloc_btree.c   |    3 ---
 libxfs/xfs_refcount_btree.c |    2 --
 libxfs/xfs_rmap_btree.c     |    2 +-
 7 files changed, 5 insertions(+), 16 deletions(-)


diff --git a/libxfs/xfs_alloc_btree.c b/libxfs/xfs_alloc_btree.c
index 16f683e1dc84..626d8e4b87a8 100644
--- a/libxfs/xfs_alloc_btree.c
+++ b/libxfs/xfs_alloc_btree.c
@@ -524,9 +524,6 @@ xfs_allocbt_init_common(
 
 	cur->bc_ag.pag = xfs_perag_hold(pag);
 
-	if (xfs_has_crc(mp))
-		cur->bc_flags |= XFS_BTREE_CRC_BLOCKS;
-
 	return cur;
 }
 
diff --git a/libxfs/xfs_bmap_btree.c b/libxfs/xfs_bmap_btree.c
index 751ae73c55cc..8ffef40bab29 100644
--- a/libxfs/xfs_bmap_btree.c
+++ b/libxfs/xfs_bmap_btree.c
@@ -553,8 +553,6 @@ xfs_bmbt_init_common(
 	cur->bc_statoff = XFS_STATS_CALC_INDEX(xs_bmbt_2);
 
 	cur->bc_flags = XFS_BTREE_LONG_PTRS | XFS_BTREE_ROOT_IN_INODE;
-	if (xfs_has_crc(mp))
-		cur->bc_flags |= XFS_BTREE_CRC_BLOCKS;
 
 	cur->bc_ino.ip = ip;
 	cur->bc_ino.allocated = 0;
diff --git a/libxfs/xfs_btree.c b/libxfs/xfs_btree.c
index 3a2b627fd6be..38d82c03ab52 100644
--- a/libxfs/xfs_btree.c
+++ b/libxfs/xfs_btree.c
@@ -595,11 +595,11 @@ xfs_btree_dup_cursor(
 static inline size_t xfs_btree_block_len(struct xfs_btree_cur *cur)
 {
 	if (cur->bc_flags & XFS_BTREE_LONG_PTRS) {
-		if (cur->bc_flags & XFS_BTREE_CRC_BLOCKS)
+		if (xfs_has_crc(cur->bc_mp))
 			return XFS_BTREE_LBLOCK_CRC_LEN;
 		return XFS_BTREE_LBLOCK_LEN;
 	}
-	if (cur->bc_flags & XFS_BTREE_CRC_BLOCKS)
+	if (xfs_has_crc(cur->bc_mp))
 		return XFS_BTREE_SBLOCK_CRC_LEN;
 	return XFS_BTREE_SBLOCK_LEN;
 }
@@ -1573,7 +1573,7 @@ xfs_btree_log_block(
 	if (bp) {
 		int nbits;
 
-		if (cur->bc_flags & XFS_BTREE_CRC_BLOCKS) {
+		if (xfs_has_crc(cur->bc_mp)) {
 			/*
 			 * We don't log the CRC when updating a btree
 			 * block but instead recreate it during log
@@ -3045,7 +3045,7 @@ xfs_btree_new_iroot(
 	 * In that case have to also ensure the blkno remains correct
 	 */
 	memcpy(cblock, block, xfs_btree_block_len(cur));
-	if (cur->bc_flags & XFS_BTREE_CRC_BLOCKS) {
+	if (xfs_has_crc(cur->bc_mp)) {
 		__be64 bno = cpu_to_be64(xfs_buf_daddr(cbp));
 		if (cur->bc_flags & XFS_BTREE_LONG_PTRS)
 			cblock->bb_u.l.bb_blkno = bno;
diff --git a/libxfs/xfs_btree.h b/libxfs/xfs_btree.h
index c053fb934dc7..36fd07b32daf 100644
--- a/libxfs/xfs_btree.h
+++ b/libxfs/xfs_btree.h
@@ -308,7 +308,6 @@ xfs_btree_cur_sizeof(unsigned int nlevels)
 #define XFS_BTREE_LONG_PTRS		(1<<0)	/* pointers are 64bits long */
 #define XFS_BTREE_ROOT_IN_INODE		(1<<1)	/* root may be variable size */
 #define XFS_BTREE_LASTREC_UPDATE	(1<<2)	/* track last rec externally */
-#define XFS_BTREE_CRC_BLOCKS		(1<<3)	/* uses extended btree blocks */
 #define XFS_BTREE_OVERLAPPING		(1<<4)	/* overlapping intervals */
 /*
  * The root of this btree is a fakeroot structure so that we can stage a btree
diff --git a/libxfs/xfs_ialloc_btree.c b/libxfs/xfs_ialloc_btree.c
index 5ea08cca25b4..dea661afc4df 100644
--- a/libxfs/xfs_ialloc_btree.c
+++ b/libxfs/xfs_ialloc_btree.c
@@ -465,9 +465,6 @@ xfs_inobt_init_common(
 		cur->bc_statoff = XFS_STATS_CALC_INDEX(xs_fibt_2);
 	}
 
-	if (xfs_has_crc(mp))
-		cur->bc_flags |= XFS_BTREE_CRC_BLOCKS;
-
 	cur->bc_ag.pag = xfs_perag_hold(pag);
 	return cur;
 }
diff --git a/libxfs/xfs_refcount_btree.c b/libxfs/xfs_refcount_btree.c
index 561b732b4746..1ecd670a9eba 100644
--- a/libxfs/xfs_refcount_btree.c
+++ b/libxfs/xfs_refcount_btree.c
@@ -356,8 +356,6 @@ xfs_refcountbt_init_common(
 			xfs_refcountbt_cur_cache);
 	cur->bc_statoff = XFS_STATS_CALC_INDEX(xs_refcbt_2);
 
-	cur->bc_flags |= XFS_BTREE_CRC_BLOCKS;
-
 	cur->bc_ag.pag = xfs_perag_hold(pag);
 	cur->bc_ag.refc.nr_ops = 0;
 	cur->bc_ag.refc.shape_changes = 0;
diff --git a/libxfs/xfs_rmap_btree.c b/libxfs/xfs_rmap_btree.c
index 36231272964b..da6bfb901704 100644
--- a/libxfs/xfs_rmap_btree.c
+++ b/libxfs/xfs_rmap_btree.c
@@ -503,7 +503,7 @@ xfs_rmapbt_init_common(
 	/* Overlapping btree; 2 keys per pointer. */
 	cur = xfs_btree_alloc_cursor(mp, tp, XFS_BTNUM_RMAP, &xfs_rmapbt_ops,
 			mp->m_rmap_maxlevels, xfs_rmapbt_cur_cache);
-	cur->bc_flags = XFS_BTREE_CRC_BLOCKS | XFS_BTREE_OVERLAPPING;
+	cur->bc_flags = XFS_BTREE_OVERLAPPING;
 	cur->bc_statoff = XFS_STATS_CALC_INDEX(xs_rmap_2);
 
 	cur->bc_ag.pag = xfs_perag_hold(pag);

