Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 056221D53C
	for <linux-xfs@vger.kernel.org>; Tue, 26 Mar 2024 03:39:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711424363; cv=none; b=RwrM+b6FB12qWHCpG47qxKKLOuCkfKql8fSshw/bWBP4YD1MNErEtXbRk6P4ng7xu6INv+9R9RkNhZQv/Q1ivnAH664NMbcwGbMp2HgKcN7dy9325bQSFIjWIuGAwByyh7+9+r0EasoiJAZezdmsKHg8T4cLUL43gpnWHl+5XAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711424363; c=relaxed/simple;
	bh=UJPB3GT3rDhoVNbsf6IoTKsy1nkIJFPzo8znTRvs4lM=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CadHWPOLTivl0vmoMZ4TPfP2xedcJIvwRlvrHlmFmTFaYAvSBnTPgsUAodxA1ZhoUBDKZ/xQ/pZ3CNDMNP5UV/NSvjX4hgcw5D13aaK0VuEzlzISZCa2V7ZsbJWwusMG+YZJ+pMy08M5zC6bU6BVEvR9fPH548nxstezBAQ4Hj0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pQkyI7Do; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pQkyI7Do"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0D29C433C7;
	Tue, 26 Mar 2024 03:39:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711424362;
	bh=UJPB3GT3rDhoVNbsf6IoTKsy1nkIJFPzo8znTRvs4lM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=pQkyI7DoH5gmc0rR/TtHHggbmIx8o5kvYL1QdzyU2Tuq22d25y6X7bETCyS/VbrXY
	 9EJpy5ALAs8aFdn1vsVZwEEdmxXEQgIK3FUt7MAh/THU1Rm9ywa/GWc4v5sZz0SpbN
	 KB83Du1wYJwkkB5NZafIFV6P7g4WrEo5gW8rNgzhBMp335Jbbrk4bpEa2/R4+jexgZ
	 aYbcL8ESo/yv1Sg+MFVc0aLygQWFsHi0TTbJGVFCxAImXIW5UNnkrL2MAEgQBt9NeB
	 LCHTMBgBYG5C3QAje493/GZRv5BryZ3Gfl2f0XReVMHZjFipwhSoC0ylFWoB1D+lYN
	 qt6lvnMe+rnFQ==
Date: Mon, 25 Mar 2024 20:39:22 -0700
Subject: [PATCH 042/110] xfs: move lru refs to the btree ops structure
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <171142131990.2215168.15884680126480515915.stgit@frogsfrogsfrogs>
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

Source kernel commit: 90cfae818dac5227e94e21d0f5250e098432723e

Move the btree buffer LRU refcount to the btree ops structure so that we
can eliminate the last bc_btnum switch in the generic btree code.  We're
about to create repair-specific btree types, and we don't want that
stuff cluttering up libxfs.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_alloc_btree.c    |    4 ++++
 libxfs/xfs_bmap_btree.c     |    2 ++
 libxfs/xfs_btree.c          |   24 ++----------------------
 libxfs/xfs_btree.h          |    3 +++
 libxfs/xfs_ialloc_btree.c   |    4 ++++
 libxfs/xfs_refcount_btree.c |    2 ++
 libxfs/xfs_rmap_btree.c     |    2 ++
 7 files changed, 19 insertions(+), 22 deletions(-)


diff --git a/libxfs/xfs_alloc_btree.c b/libxfs/xfs_alloc_btree.c
index 6c9781fcf0d2..51c6703db6b1 100644
--- a/libxfs/xfs_alloc_btree.c
+++ b/libxfs/xfs_alloc_btree.c
@@ -456,6 +456,8 @@ const struct xfs_btree_ops xfs_bnobt_ops = {
 	.rec_len		= sizeof(xfs_alloc_rec_t),
 	.key_len		= sizeof(xfs_alloc_key_t),
 
+	.lru_refs		= XFS_ALLOC_BTREE_REF,
+
 	.dup_cursor		= xfs_allocbt_dup_cursor,
 	.set_root		= xfs_allocbt_set_root,
 	.alloc_block		= xfs_allocbt_alloc_block,
@@ -481,6 +483,8 @@ const struct xfs_btree_ops xfs_cntbt_ops = {
 	.rec_len		= sizeof(xfs_alloc_rec_t),
 	.key_len		= sizeof(xfs_alloc_key_t),
 
+	.lru_refs		= XFS_ALLOC_BTREE_REF,
+
 	.dup_cursor		= xfs_allocbt_dup_cursor,
 	.set_root		= xfs_allocbt_set_root,
 	.alloc_block		= xfs_allocbt_alloc_block,
diff --git a/libxfs/xfs_bmap_btree.c b/libxfs/xfs_bmap_btree.c
index 2d84118099d8..966e793b08d2 100644
--- a/libxfs/xfs_bmap_btree.c
+++ b/libxfs/xfs_bmap_btree.c
@@ -529,6 +529,8 @@ const struct xfs_btree_ops xfs_bmbt_ops = {
 	.rec_len		= sizeof(xfs_bmbt_rec_t),
 	.key_len		= sizeof(xfs_bmbt_key_t),
 
+	.lru_refs		= XFS_BMAP_BTREE_REF,
+
 	.dup_cursor		= xfs_bmbt_dup_cursor,
 	.update_cursor		= xfs_bmbt_update_cursor,
 	.alloc_block		= xfs_bmbt_alloc_block,
diff --git a/libxfs/xfs_btree.c b/libxfs/xfs_btree.c
index 95041d626c4c..150f8ac23d9d 100644
--- a/libxfs/xfs_btree.c
+++ b/libxfs/xfs_btree.c
@@ -1281,32 +1281,12 @@ xfs_btree_buf_to_ptr(
 	}
 }
 
-STATIC void
+static inline void
 xfs_btree_set_refs(
 	struct xfs_btree_cur	*cur,
 	struct xfs_buf		*bp)
 {
-	switch (cur->bc_btnum) {
-	case XFS_BTNUM_BNO:
-	case XFS_BTNUM_CNT:
-		xfs_buf_set_ref(bp, XFS_ALLOC_BTREE_REF);
-		break;
-	case XFS_BTNUM_INO:
-	case XFS_BTNUM_FINO:
-		xfs_buf_set_ref(bp, XFS_INO_BTREE_REF);
-		break;
-	case XFS_BTNUM_BMAP:
-		xfs_buf_set_ref(bp, XFS_BMAP_BTREE_REF);
-		break;
-	case XFS_BTNUM_RMAP:
-		xfs_buf_set_ref(bp, XFS_RMAP_BTREE_REF);
-		break;
-	case XFS_BTNUM_REFC:
-		xfs_buf_set_ref(bp, XFS_REFC_BTREE_REF);
-		break;
-	default:
-		ASSERT(0);
-	}
+	xfs_buf_set_ref(bp, cur->bc_ops->lru_refs);
 }
 
 int
diff --git a/libxfs/xfs_btree.h b/libxfs/xfs_btree.h
index 80be40ca8954..39df108a32ef 100644
--- a/libxfs/xfs_btree.h
+++ b/libxfs/xfs_btree.h
@@ -120,6 +120,9 @@ struct xfs_btree_ops {
 	size_t	key_len;
 	size_t	rec_len;
 
+	/* LRU refcount to set on each btree buffer created */
+	unsigned int		lru_refs;
+
 	/* cursor operations */
 	struct xfs_btree_cur *(*dup_cursor)(struct xfs_btree_cur *);
 	void	(*update_cursor)(struct xfs_btree_cur *src,
diff --git a/libxfs/xfs_ialloc_btree.c b/libxfs/xfs_ialloc_btree.c
index 52cc00e4ff1c..332d497eaf71 100644
--- a/libxfs/xfs_ialloc_btree.c
+++ b/libxfs/xfs_ialloc_btree.c
@@ -401,6 +401,8 @@ const struct xfs_btree_ops xfs_inobt_ops = {
 	.rec_len		= sizeof(xfs_inobt_rec_t),
 	.key_len		= sizeof(xfs_inobt_key_t),
 
+	.lru_refs		= XFS_INO_BTREE_REF,
+
 	.dup_cursor		= xfs_inobt_dup_cursor,
 	.set_root		= xfs_inobt_set_root,
 	.alloc_block		= xfs_inobt_alloc_block,
@@ -423,6 +425,8 @@ const struct xfs_btree_ops xfs_finobt_ops = {
 	.rec_len		= sizeof(xfs_inobt_rec_t),
 	.key_len		= sizeof(xfs_inobt_key_t),
 
+	.lru_refs		= XFS_INO_BTREE_REF,
+
 	.dup_cursor		= xfs_inobt_dup_cursor,
 	.set_root		= xfs_finobt_set_root,
 	.alloc_block		= xfs_finobt_alloc_block,
diff --git a/libxfs/xfs_refcount_btree.c b/libxfs/xfs_refcount_btree.c
index 2f91c7b62ef1..1774b047726f 100644
--- a/libxfs/xfs_refcount_btree.c
+++ b/libxfs/xfs_refcount_btree.c
@@ -320,6 +320,8 @@ const struct xfs_btree_ops xfs_refcountbt_ops = {
 	.rec_len		= sizeof(struct xfs_refcount_rec),
 	.key_len		= sizeof(struct xfs_refcount_key),
 
+	.lru_refs		= XFS_REFC_BTREE_REF,
+
 	.dup_cursor		= xfs_refcountbt_dup_cursor,
 	.set_root		= xfs_refcountbt_set_root,
 	.alloc_block		= xfs_refcountbt_alloc_block,
diff --git a/libxfs/xfs_rmap_btree.c b/libxfs/xfs_rmap_btree.c
index c3a113c881d8..6a7a9a176c62 100644
--- a/libxfs/xfs_rmap_btree.c
+++ b/libxfs/xfs_rmap_btree.c
@@ -476,6 +476,8 @@ const struct xfs_btree_ops xfs_rmapbt_ops = {
 	.rec_len		= sizeof(struct xfs_rmap_rec),
 	.key_len		= 2 * sizeof(struct xfs_rmap_key),
 
+	.lru_refs		= XFS_RMAP_BTREE_REF,
+
 	.dup_cursor		= xfs_rmapbt_dup_cursor,
 	.set_root		= xfs_rmapbt_set_root,
 	.alloc_block		= xfs_rmapbt_alloc_block,

