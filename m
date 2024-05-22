Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 529DB42A89
	for <linux-xfs@vger.kernel.org>; Wed, 22 May 2024 02:59:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716346784; cv=none; b=FrHBpoWdTQgxhQHhHawS0J4cP1Q60/l1K1Go9A6ri66L1PuPdNKj4zUpUYrh+5CqS5UQzKu8/sf7rnNlERPWhMYUe7s2YJo07h796eAk3CYHSuHJydPSG1lWwlk8I2NGU6eIRGYm7Mw9U2eq06m8v2TyOCalT35sGnegMxcP6yw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716346784; c=relaxed/simple;
	bh=QvAPoBXY1D50Mb7qi92eqSMgo8BBkRYyfFo/Dap0JdQ=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=krfcEhUI+JdowDaO3U4E7E/Kcfd059wcT/L8CoWvXYaIJALmN6Ax0jam/4853dLsrFpeXB2UOlcngWnR7ev2EI9XSqwMxBSCh6jeuDUpgKMk0ssuPhgLBq74cxIxQaJoeRNVPMw9hLYNIzTdfNit6aUweS5J+LxGt2Xqkb3L2Mk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YixFiOwQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YixFiOwQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A17EC2BD11;
	Wed, 22 May 2024 02:59:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716346784;
	bh=QvAPoBXY1D50Mb7qi92eqSMgo8BBkRYyfFo/Dap0JdQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=YixFiOwQcqus84rOvCWL+nsPaXtAPCin+Avd26TZLiocyoBEEjznG54XCm7DAK9mt
	 cxJ6/eDVQmfz24uPMwqIx8iA4r3GeKhJIXMiBDRDuW3YMtzDs5+6enIR63IfWabtL9
	 mEJWDPeMib0E0enSmc4+MH0FelXI0kUj1Kle5tY69EHAQFxIKFIiCsTBTHsm6Lwt4y
	 g0BoPJnZdeliufc1Thzki0M7sdFNnM/FyZP5iB8PygIXtPRG4qAWg4LMrd/GXSJQ63
	 WsaFfgEGmewjV5nyiruVaHoIRkW3mHf0bPkF/8ACHlYC4XrJQqZNaJIm6XXLFGL72U
	 ZxByY508zbE6w==
Date: Tue, 21 May 2024 19:59:43 -0700
Subject: [PATCH 042/111] xfs: move lru refs to the btree ops structure
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <171634532342.2478931.16091061611806879504.stgit@frogsfrogsfrogs>
In-Reply-To: <171634531590.2478931.8474978645585392776.stgit@frogsfrogsfrogs>
References: <171634531590.2478931.8474978645585392776.stgit@frogsfrogsfrogs>
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
index 6c9781fcf..51c6703db 100644
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
index 2d8411809..966e793b0 100644
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
index 95041d626..150f8ac23 100644
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
index 80be40ca8..39df108a3 100644
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
index 52cc00e4f..332d497ea 100644
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
index 2f91c7b62..1774b0477 100644
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
index c3a113c88..6a7a9a176 100644
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

