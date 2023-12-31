Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53BDFBA2E
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 20:19:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Rzx0HgfT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2756CC433C8;
	Sun, 31 Dec 2023 20:19:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704053974;
	bh=XeRK9kRCmvDkHWdtcjLwZ2/OI/aLheehQrMAnDVz28A=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Rzx0HgfTWRTyOHUaD8R9ISxqqhlEOMZQKAwjbsTASxleVdI7avSj1+VPwsf7juGHa
	 +KxQP+yJse3LxV0xS1HglBkUZiKU9FfprWsxrKPCxQDRi/F6KfTuTqWUt1npXV7iIT
	 y0crjpbw6/uueYJG21r1jFr8l6MswX4Y/k74tW0pyDJ0UBZQ8E4i5Yxfu58s52epr7
	 y+aoQigRGnB2OPqAvrxMQk3kQETNGYAuhBbQv7VyA2MpxEWmWmzuATNnq4gMDf7RID
	 m0qd+CrCjoPD8A5DdaFvfMYrhkDAxUwFOJk6Nu2W+IAat2NoZwQIWYkuPTDzUVBFc0
	 7CV77XXJX32QQ==
Date: Sun, 31 Dec 2023 12:19:33 -0800
Subject: [PATCH 1/4] xfs: move lru refs to the btree ops structure
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404831021.1749557.2760974108166727419.stgit@frogsfrogsfrogs>
In-Reply-To: <170404830995.1749557.6135790697605021363.stgit@frogsfrogsfrogs>
References: <170404830995.1749557.6135790697605021363.stgit@frogsfrogsfrogs>
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
 fs/xfs/libxfs/xfs_alloc_btree.c    |    2 ++
 fs/xfs/libxfs/xfs_bmap_btree.c     |    1 +
 fs/xfs/libxfs/xfs_btree.c          |   24 ++----------------------
 fs/xfs/libxfs/xfs_btree.h          |    3 +++
 fs/xfs/libxfs/xfs_ialloc_btree.c   |    2 ++
 fs/xfs/libxfs/xfs_refcount_btree.c |    1 +
 fs/xfs/libxfs/xfs_rmap_btree.c     |    2 ++
 7 files changed, 13 insertions(+), 22 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_alloc_btree.c b/fs/xfs/libxfs/xfs_alloc_btree.c
index 08aa92f574334..fd769e62cc35b 100644
--- a/fs/xfs/libxfs/xfs_alloc_btree.c
+++ b/fs/xfs/libxfs/xfs_alloc_btree.c
@@ -457,6 +457,7 @@ xfs_allocbt_keys_contiguous(
 const struct xfs_btree_ops xfs_bnobt_ops = {
 	.rec_len		= sizeof(xfs_alloc_rec_t),
 	.key_len		= sizeof(xfs_alloc_key_t),
+	.lru_refs		= XFS_ALLOC_BTREE_REF,
 
 	.dup_cursor		= xfs_allocbt_dup_cursor,
 	.set_root		= xfs_allocbt_set_root,
@@ -480,6 +481,7 @@ const struct xfs_btree_ops xfs_bnobt_ops = {
 const struct xfs_btree_ops xfs_cntbt_ops = {
 	.rec_len		= sizeof(xfs_alloc_rec_t),
 	.key_len		= sizeof(xfs_alloc_key_t),
+	.lru_refs		= XFS_ALLOC_BTREE_REF,
 	.geom_flags		= XFS_BTREE_LASTREC_UPDATE,
 
 	.dup_cursor		= xfs_allocbt_dup_cursor,
diff --git a/fs/xfs/libxfs/xfs_bmap_btree.c b/fs/xfs/libxfs/xfs_bmap_btree.c
index 54e0a47169487..fd5fb8abf4448 100644
--- a/fs/xfs/libxfs/xfs_bmap_btree.c
+++ b/fs/xfs/libxfs/xfs_bmap_btree.c
@@ -516,6 +516,7 @@ xfs_bmbt_keys_contiguous(
 const struct xfs_btree_ops xfs_bmbt_ops = {
 	.rec_len		= sizeof(xfs_bmbt_rec_t),
 	.key_len		= sizeof(xfs_bmbt_key_t),
+	.lru_refs		= XFS_BMAP_BTREE_REF,
 	.geom_flags		= XFS_BTREE_LONG_PTRS | XFS_BTREE_ROOT_IN_INODE,
 
 	.dup_cursor		= xfs_bmbt_dup_cursor,
diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index 5af19610d8919..4c8e9dd25b739 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -1350,32 +1350,12 @@ xfs_btree_buf_to_ptr(
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
diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
index 41000bd6cccf7..edbcd4f0e9888 100644
--- a/fs/xfs/libxfs/xfs_btree.h
+++ b/fs/xfs/libxfs/xfs_btree.h
@@ -120,6 +120,9 @@ struct xfs_btree_ops {
 	/* XFS_BTREE_* flags that determine the geometry of the btree */
 	unsigned int	geom_flags;
 
+	/* LRU refcount to set on each btree buffer created */
+	int	lru_refs;
+
 	/* cursor operations */
 	struct xfs_btree_cur *(*dup_cursor)(struct xfs_btree_cur *);
 	void	(*update_cursor)(struct xfs_btree_cur *src,
diff --git a/fs/xfs/libxfs/xfs_ialloc_btree.c b/fs/xfs/libxfs/xfs_ialloc_btree.c
index 69086fdc3be6f..cdb1f99970724 100644
--- a/fs/xfs/libxfs/xfs_ialloc_btree.c
+++ b/fs/xfs/libxfs/xfs_ialloc_btree.c
@@ -401,6 +401,7 @@ xfs_inobt_keys_contiguous(
 const struct xfs_btree_ops xfs_inobt_ops = {
 	.rec_len		= sizeof(xfs_inobt_rec_t),
 	.key_len		= sizeof(xfs_inobt_key_t),
+	.lru_refs		= XFS_INO_BTREE_REF,
 
 	.dup_cursor		= xfs_inobt_dup_cursor,
 	.set_root		= xfs_inobt_set_root,
@@ -423,6 +424,7 @@ const struct xfs_btree_ops xfs_inobt_ops = {
 const struct xfs_btree_ops xfs_finobt_ops = {
 	.rec_len		= sizeof(xfs_inobt_rec_t),
 	.key_len		= sizeof(xfs_inobt_key_t),
+	.lru_refs		= XFS_INO_BTREE_REF,
 
 	.dup_cursor		= xfs_inobt_dup_cursor,
 	.set_root		= xfs_finobt_set_root,
diff --git a/fs/xfs/libxfs/xfs_refcount_btree.c b/fs/xfs/libxfs/xfs_refcount_btree.c
index 36e7b26d5e3b2..06a2f062b58cb 100644
--- a/fs/xfs/libxfs/xfs_refcount_btree.c
+++ b/fs/xfs/libxfs/xfs_refcount_btree.c
@@ -320,6 +320,7 @@ xfs_refcountbt_keys_contiguous(
 const struct xfs_btree_ops xfs_refcountbt_ops = {
 	.rec_len		= sizeof(struct xfs_refcount_rec),
 	.key_len		= sizeof(struct xfs_refcount_key),
+	.lru_refs		= XFS_REFC_BTREE_REF,
 
 	.dup_cursor		= xfs_refcountbt_dup_cursor,
 	.set_root		= xfs_refcountbt_set_root,
diff --git a/fs/xfs/libxfs/xfs_rmap_btree.c b/fs/xfs/libxfs/xfs_rmap_btree.c
index b4a8b4b62456b..23841ee6e2ff6 100644
--- a/fs/xfs/libxfs/xfs_rmap_btree.c
+++ b/fs/xfs/libxfs/xfs_rmap_btree.c
@@ -489,6 +489,7 @@ xfs_rmapbt_keys_contiguous(
 const struct xfs_btree_ops xfs_rmapbt_ops = {
 	.rec_len		= sizeof(struct xfs_rmap_rec),
 	.key_len		= 2 * sizeof(struct xfs_rmap_key),
+	.lru_refs		= XFS_RMAP_BTREE_REF,
 	.geom_flags		= XFS_BTREE_CRC_BLOCKS | XFS_BTREE_OVERLAPPING,
 
 	.dup_cursor		= xfs_rmapbt_dup_cursor,
@@ -613,6 +614,7 @@ static const struct xfs_buf_ops xfs_rmapbt_mem_buf_ops = {
 static const struct xfs_btree_ops xfs_rmapbt_mem_ops = {
 	.rec_len		= sizeof(struct xfs_rmap_rec),
 	.key_len		= 2 * sizeof(struct xfs_rmap_key),
+	.lru_refs		= XFS_RMAP_BTREE_REF,
 	.geom_flags		= XFS_BTREE_CRC_BLOCKS | XFS_BTREE_OVERLAPPING |
 				  XFS_BTREE_IN_XFILE,
 

