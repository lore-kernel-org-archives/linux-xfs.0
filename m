Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E68F5C127
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 22:22:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="D//ykTTA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D92CC433C8;
	Sun, 31 Dec 2023 22:22:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704061342;
	bh=7EQYHHLDsBPDytJ4qDU7dQ+8G73xkUGoQyMZL9dYfdY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=D//ykTTAeLDBCLo+Q5Bn75ArTR/yMlQRzfhCIdFVZU/sEImMDvMnajVivpWEaL7xD
	 DCd62ih+09YjROHLj6WXmAqfswlkDnWeLvEhgqQj8jFqJr3LnWVVjXFkwKS3aW9/AM
	 uxYXkqHHQPcXIVDHLtMCyeIw8o0IfmCMX3884mZdbwwiKp+72gSEIvSBJGvlxb3gno
	 AYlyV4cAusRyBa7eR60tMPQxC9HE+vPFtMU2WwTZwEms+jk9PqMDEtKWzIrn00kSDB
	 xJbjRhgqa/WQppXF/IwNwadUSkmz7slmzzSOft+K4/PY3m78NYREGlK1GKmgxMRmHr
	 TyS0is+78KMqw==
Date: Sun, 31 Dec 2023 14:22:21 -0800
Subject: [PATCH 1/6] xfs: move lru refs to the btree ops structure
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404994438.1795402.13146912228512793269.stgit@frogsfrogsfrogs>
In-Reply-To: <170404994421.1795402.5021109335646815731.stgit@frogsfrogsfrogs>
References: <170404994421.1795402.5021109335646815731.stgit@frogsfrogsfrogs>
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

Move the btree buffer LRU refcount to the btree ops structure so that we
can eliminate the last bc_btnum switch in the generic btree code.  We're
about to create repair-specific btree types, and we don't want that
stuff cluttering up libxfs.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_alloc_btree.c    |    2 ++
 libxfs/xfs_bmap_btree.c     |    1 +
 libxfs/xfs_btree.c          |   24 ++----------------------
 libxfs/xfs_btree.h          |    3 +++
 libxfs/xfs_ialloc_btree.c   |    2 ++
 libxfs/xfs_refcount_btree.c |    1 +
 libxfs/xfs_rmap_btree.c     |    2 ++
 7 files changed, 13 insertions(+), 22 deletions(-)


diff --git a/libxfs/xfs_alloc_btree.c b/libxfs/xfs_alloc_btree.c
index 97d19203550..93faa832e5b 100644
--- a/libxfs/xfs_alloc_btree.c
+++ b/libxfs/xfs_alloc_btree.c
@@ -455,6 +455,7 @@ xfs_allocbt_keys_contiguous(
 const struct xfs_btree_ops xfs_bnobt_ops = {
 	.rec_len		= sizeof(xfs_alloc_rec_t),
 	.key_len		= sizeof(xfs_alloc_key_t),
+	.lru_refs		= XFS_ALLOC_BTREE_REF,
 
 	.dup_cursor		= xfs_allocbt_dup_cursor,
 	.set_root		= xfs_allocbt_set_root,
@@ -478,6 +479,7 @@ const struct xfs_btree_ops xfs_bnobt_ops = {
 const struct xfs_btree_ops xfs_cntbt_ops = {
 	.rec_len		= sizeof(xfs_alloc_rec_t),
 	.key_len		= sizeof(xfs_alloc_key_t),
+	.lru_refs		= XFS_ALLOC_BTREE_REF,
 	.geom_flags		= XFS_BTREE_LASTREC_UPDATE,
 
 	.dup_cursor		= xfs_allocbt_dup_cursor,
diff --git a/libxfs/xfs_bmap_btree.c b/libxfs/xfs_bmap_btree.c
index 1dd85d4d41c..160f7b08ffd 100644
--- a/libxfs/xfs_bmap_btree.c
+++ b/libxfs/xfs_bmap_btree.c
@@ -514,6 +514,7 @@ xfs_bmbt_keys_contiguous(
 const struct xfs_btree_ops xfs_bmbt_ops = {
 	.rec_len		= sizeof(xfs_bmbt_rec_t),
 	.key_len		= sizeof(xfs_bmbt_key_t),
+	.lru_refs		= XFS_BMAP_BTREE_REF,
 	.geom_flags		= XFS_BTREE_LONG_PTRS | XFS_BTREE_ROOT_IN_INODE,
 
 	.dup_cursor		= xfs_bmbt_dup_cursor,
diff --git a/libxfs/xfs_btree.c b/libxfs/xfs_btree.c
index 6705a6d83f3..7cc6379a113 100644
--- a/libxfs/xfs_btree.c
+++ b/libxfs/xfs_btree.c
@@ -1347,32 +1347,12 @@ xfs_btree_buf_to_ptr(
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
index 41000bd6ccc..edbcd4f0e98 100644
--- a/libxfs/xfs_btree.h
+++ b/libxfs/xfs_btree.h
@@ -120,6 +120,9 @@ struct xfs_btree_ops {
 	/* XFS_BTREE_* flags that determine the geometry of the btree */
 	unsigned int	geom_flags;
 
+	/* LRU refcount to set on each btree buffer created */
+	int	lru_refs;
+
 	/* cursor operations */
 	struct xfs_btree_cur *(*dup_cursor)(struct xfs_btree_cur *);
 	void	(*update_cursor)(struct xfs_btree_cur *src,
diff --git a/libxfs/xfs_ialloc_btree.c b/libxfs/xfs_ialloc_btree.c
index 52cc00e4ff1..4275244b15c 100644
--- a/libxfs/xfs_ialloc_btree.c
+++ b/libxfs/xfs_ialloc_btree.c
@@ -400,6 +400,7 @@ xfs_inobt_keys_contiguous(
 const struct xfs_btree_ops xfs_inobt_ops = {
 	.rec_len		= sizeof(xfs_inobt_rec_t),
 	.key_len		= sizeof(xfs_inobt_key_t),
+	.lru_refs		= XFS_INO_BTREE_REF,
 
 	.dup_cursor		= xfs_inobt_dup_cursor,
 	.set_root		= xfs_inobt_set_root,
@@ -422,6 +423,7 @@ const struct xfs_btree_ops xfs_inobt_ops = {
 const struct xfs_btree_ops xfs_finobt_ops = {
 	.rec_len		= sizeof(xfs_inobt_rec_t),
 	.key_len		= sizeof(xfs_inobt_key_t),
+	.lru_refs		= XFS_INO_BTREE_REF,
 
 	.dup_cursor		= xfs_inobt_dup_cursor,
 	.set_root		= xfs_finobt_set_root,
diff --git a/libxfs/xfs_refcount_btree.c b/libxfs/xfs_refcount_btree.c
index 2f91c7b62ef..ab8925051a9 100644
--- a/libxfs/xfs_refcount_btree.c
+++ b/libxfs/xfs_refcount_btree.c
@@ -319,6 +319,7 @@ xfs_refcountbt_keys_contiguous(
 const struct xfs_btree_ops xfs_refcountbt_ops = {
 	.rec_len		= sizeof(struct xfs_refcount_rec),
 	.key_len		= sizeof(struct xfs_refcount_key),
+	.lru_refs		= XFS_REFC_BTREE_REF,
 
 	.dup_cursor		= xfs_refcountbt_dup_cursor,
 	.set_root		= xfs_refcountbt_set_root,
diff --git a/libxfs/xfs_rmap_btree.c b/libxfs/xfs_rmap_btree.c
index e36237bf750..a378bd5daf8 100644
--- a/libxfs/xfs_rmap_btree.c
+++ b/libxfs/xfs_rmap_btree.c
@@ -487,6 +487,7 @@ xfs_rmapbt_keys_contiguous(
 const struct xfs_btree_ops xfs_rmapbt_ops = {
 	.rec_len		= sizeof(struct xfs_rmap_rec),
 	.key_len		= 2 * sizeof(struct xfs_rmap_key),
+	.lru_refs		= XFS_RMAP_BTREE_REF,
 	.geom_flags		= XFS_BTREE_CRC_BLOCKS | XFS_BTREE_OVERLAPPING,
 
 	.dup_cursor		= xfs_rmapbt_dup_cursor,
@@ -611,6 +612,7 @@ static const struct xfs_buf_ops xfs_rmapbt_mem_buf_ops = {
 static const struct xfs_btree_ops xfs_rmapbt_mem_ops = {
 	.rec_len		= sizeof(struct xfs_rmap_rec),
 	.key_len		= 2 * sizeof(struct xfs_rmap_key),
+	.lru_refs		= XFS_RMAP_BTREE_REF,
 	.geom_flags		= XFS_BTREE_CRC_BLOCKS | XFS_BTREE_OVERLAPPING |
 				  XFS_BTREE_IN_XFILE,
 

