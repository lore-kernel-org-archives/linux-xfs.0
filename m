Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFE308527B
	for <linux-xfs@vger.kernel.org>; Thu,  1 Feb 2024 19:40:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706816444; cv=none; b=lzQBMzQkOdbQdjbGQcDa31UtxodHtvj4m0rV/t75ULrgCXPl1W3wp33TvimYWE0atC/+Sih1HsSDBoJgeh/0Jljc/I2lnOcY3eBNSZPmQ8mECFx2a5Rmx+wPDSea26Z6YSjW5iCVN6wCYXA0PQGeZtM3wP7g+FIjQ+/65y5GV+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706816444; c=relaxed/simple;
	bh=IeoaLL/TD+5fCrSVOJsRGsd6bAAAC1ZoeQtbT0jxmh4=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jICJaenhBj+d2RXSudgSJHvBemaTiv9CW+qGICATEBmVqgjdIIKVfy0g7CS5x/WlIlVkflk2YsmMc3e0WQV/dLRakUYXu5qBd3WkjH6GkY+Vo5mJWwcZUCqz7L5pddI1EMqil3F8ZGlYXLFi2dlZJiYpP2eti6Ht5L6OrKwd6rw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GQRvtpcQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GQRvtpcQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56E2EC433F1;
	Thu,  1 Feb 2024 19:40:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706816443;
	bh=IeoaLL/TD+5fCrSVOJsRGsd6bAAAC1ZoeQtbT0jxmh4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=GQRvtpcQCVDxjAG+ENT8EA1yKgAaheArPmT4NajQmTtn0RL4zuU3PMkloD7IUzRBN
	 bCxibT7hOqmMGlipMkJH5kOLd1jFJU4uNglMn+nRu9TD/QwWvvyQWNKNlxn+j25iy7
	 h1RW9fBYw2lGqzqkab/2xO3gqhU3iBajdY0BjuMu6bKWdJTNFachA8HeJuhsL+HgZr
	 92t355uDa2k0ZmEgchNmx15906g4CwzPJLutq9rUJaLQJiLfMEkSssrI+RYU3CG5tY
	 ms1rl4wrevlGd8alA1+NEvJb5g7BYx45SbJSU+2JvJEfTCEsMz6SEzeJwgbTHzVR/Z
	 hdp4d58+Raoeg==
Date: Thu, 01 Feb 2024 11:40:42 -0800
Subject: [PATCH 04/23] xfs: drop XFS_BTREE_CRC_BLOCKS
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <170681334001.1604831.2802875167307440195.stgit@frogsfrogsfrogs>
In-Reply-To: <170681333879.1604831.1274408743361215078.stgit@frogsfrogsfrogs>
References: <170681333879.1604831.1274408743361215078.stgit@frogsfrogsfrogs>
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

All existing btree types set XFS_BTREE_CRC_BLOCKS when running against a
V5 filesystem.  All currently proposed btree types are V5 only and use
the richer XFS_BTREE_CRC_BLOCKS format.  Therefore, we can drop this
flag and change the conditional to xfs_has_crc.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_alloc_btree.c    |    3 ---
 fs/xfs/libxfs/xfs_bmap_btree.c     |    2 --
 fs/xfs/libxfs/xfs_btree.c          |    8 ++++----
 fs/xfs/libxfs/xfs_btree.h          |    1 -
 fs/xfs/libxfs/xfs_ialloc_btree.c   |    3 ---
 fs/xfs/libxfs/xfs_refcount_btree.c |    2 --
 fs/xfs/libxfs/xfs_rmap_btree.c     |    2 +-
 7 files changed, 5 insertions(+), 16 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_alloc_btree.c b/fs/xfs/libxfs/xfs_alloc_btree.c
index cdcb2358351c6..93a6be0d6cded 100644
--- a/fs/xfs/libxfs/xfs_alloc_btree.c
+++ b/fs/xfs/libxfs/xfs_alloc_btree.c
@@ -526,9 +526,6 @@ xfs_allocbt_init_common(
 
 	cur->bc_ag.pag = xfs_perag_hold(pag);
 
-	if (xfs_has_crc(mp))
-		cur->bc_flags |= XFS_BTREE_CRC_BLOCKS;
-
 	return cur;
 }
 
diff --git a/fs/xfs/libxfs/xfs_bmap_btree.c b/fs/xfs/libxfs/xfs_bmap_btree.c
index 19414c7118867..0bc64c07fa1ce 100644
--- a/fs/xfs/libxfs/xfs_bmap_btree.c
+++ b/fs/xfs/libxfs/xfs_bmap_btree.c
@@ -554,8 +554,6 @@ xfs_bmbt_init_common(
 	cur->bc_statoff = XFS_STATS_CALC_INDEX(xs_bmbt_2);
 
 	cur->bc_flags = XFS_BTREE_LONG_PTRS | XFS_BTREE_ROOT_IN_INODE;
-	if (xfs_has_crc(mp))
-		cur->bc_flags |= XFS_BTREE_CRC_BLOCKS;
 
 	cur->bc_ino.ip = ip;
 	cur->bc_ino.allocated = 0;
diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index fbed51b4462e8..86938a826447e 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -598,11 +598,11 @@ xfs_btree_dup_cursor(
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
@@ -1576,7 +1576,7 @@ xfs_btree_log_block(
 	if (bp) {
 		int nbits;
 
-		if (cur->bc_flags & XFS_BTREE_CRC_BLOCKS) {
+		if (xfs_has_crc(cur->bc_mp)) {
 			/*
 			 * We don't log the CRC when updating a btree
 			 * block but instead recreate it during log
@@ -3048,7 +3048,7 @@ xfs_btree_new_iroot(
 	 * In that case have to also ensure the blkno remains correct
 	 */
 	memcpy(cblock, block, xfs_btree_block_len(cur));
-	if (cur->bc_flags & XFS_BTREE_CRC_BLOCKS) {
+	if (xfs_has_crc(cur->bc_mp)) {
 		__be64 bno = cpu_to_be64(xfs_buf_daddr(cbp));
 		if (cur->bc_flags & XFS_BTREE_LONG_PTRS)
 			cblock->bb_u.l.bb_blkno = bno;
diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
index 63765346a26a0..3024e2502cd2a 100644
--- a/fs/xfs/libxfs/xfs_btree.h
+++ b/fs/xfs/libxfs/xfs_btree.h
@@ -308,7 +308,6 @@ xfs_btree_cur_sizeof(unsigned int nlevels)
 #define XFS_BTREE_LONG_PTRS		(1<<0)	/* pointers are 64bits long */
 #define XFS_BTREE_ROOT_IN_INODE		(1<<1)	/* root may be variable size */
 #define XFS_BTREE_LASTREC_UPDATE	(1<<2)	/* track last rec externally */
-#define XFS_BTREE_CRC_BLOCKS		(1<<3)	/* uses extended btree blocks */
 #define XFS_BTREE_OVERLAPPING		(1<<4)	/* overlapping intervals */
 /*
  * The root of this btree is a fakeroot structure so that we can stage a btree
diff --git a/fs/xfs/libxfs/xfs_ialloc_btree.c b/fs/xfs/libxfs/xfs_ialloc_btree.c
index 8b705cc62d3d3..3e65f028f3eea 100644
--- a/fs/xfs/libxfs/xfs_ialloc_btree.c
+++ b/fs/xfs/libxfs/xfs_ialloc_btree.c
@@ -466,9 +466,6 @@ xfs_inobt_init_common(
 		cur->bc_statoff = XFS_STATS_CALC_INDEX(xs_fibt_2);
 	}
 
-	if (xfs_has_crc(mp))
-		cur->bc_flags |= XFS_BTREE_CRC_BLOCKS;
-
 	cur->bc_ag.pag = xfs_perag_hold(pag);
 	return cur;
 }
diff --git a/fs/xfs/libxfs/xfs_refcount_btree.c b/fs/xfs/libxfs/xfs_refcount_btree.c
index 1eb164816825f..6a3a827dd3663 100644
--- a/fs/xfs/libxfs/xfs_refcount_btree.c
+++ b/fs/xfs/libxfs/xfs_refcount_btree.c
@@ -357,8 +357,6 @@ xfs_refcountbt_init_common(
 			xfs_refcountbt_cur_cache);
 	cur->bc_statoff = XFS_STATS_CALC_INDEX(xs_refcbt_2);
 
-	cur->bc_flags |= XFS_BTREE_CRC_BLOCKS;
-
 	cur->bc_ag.pag = xfs_perag_hold(pag);
 	cur->bc_ag.refc.nr_ops = 0;
 	cur->bc_ag.refc.shape_changes = 0;
diff --git a/fs/xfs/libxfs/xfs_rmap_btree.c b/fs/xfs/libxfs/xfs_rmap_btree.c
index 370c36921f659..058305fb070bf 100644
--- a/fs/xfs/libxfs/xfs_rmap_btree.c
+++ b/fs/xfs/libxfs/xfs_rmap_btree.c
@@ -505,7 +505,7 @@ xfs_rmapbt_init_common(
 	/* Overlapping btree; 2 keys per pointer. */
 	cur = xfs_btree_alloc_cursor(mp, tp, XFS_BTNUM_RMAP, &xfs_rmapbt_ops,
 			mp->m_rmap_maxlevels, xfs_rmapbt_cur_cache);
-	cur->bc_flags = XFS_BTREE_CRC_BLOCKS | XFS_BTREE_OVERLAPPING;
+	cur->bc_flags = XFS_BTREE_OVERLAPPING;
 	cur->bc_statoff = XFS_STATS_CALC_INDEX(xs_rmap_2);
 
 	cur->bc_ag.pag = xfs_perag_hold(pag);

