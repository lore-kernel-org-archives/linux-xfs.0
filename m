Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EB73BE4A
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 22:20:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mEaYflIg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5A93C433C7;
	Sun, 31 Dec 2023 22:20:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704061232;
	bh=dqtHDQd9kwxMyoya8x1ZCT0ob67YWh0Uy9lvJplFLHA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=mEaYflIgS6U6YAbMYGzMQWiuT/JKaeaygdjH2g+h+7qBuKUw7upVnholCFCY16v7O
	 V91WbucpRmUFSHZgnWRF72kiTur3v73qDPBXh9UcYqmmU9qtGru1OFPnC8n+bemp5L
	 55eq14p92JjonMmy+ZllrhL6jDz4R/dimQkGTsX1YMVjuOwyW+RjiVO4N3PLuTtWEu
	 VR4ZTqAOnUC2A16C9oGd+Cc7svalP8E2Xnn0JesC+N/Ed95B7lKAKeld6pvqWgNXB7
	 R/Mha+L7clICqhewGvnQuMD0O0sv98aGf6jeG2nw1n0oFTzLva4B4mC3mvIi6PyitR
	 ztPOsmWllxk8Q==
Date: Sun, 31 Dec 2023 14:20:32 -0800
Subject: [PATCH 3/9] xfs: export some of the btree ops structures
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404994029.1795132.587464916356781779.stgit@frogsfrogsfrogs>
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

Export these btree ops structures so that we can reference them in the
AG initialization code in the next patch.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_alloc_btree.c    |    4 ++--
 libxfs/xfs_bmap_btree.c     |    2 +-
 libxfs/xfs_ialloc_btree.c   |    4 ++--
 libxfs/xfs_refcount_btree.c |    2 +-
 libxfs/xfs_rmap_btree.c     |    2 +-
 libxfs/xfs_shared.h         |    9 +++++++++
 6 files changed, 16 insertions(+), 7 deletions(-)


diff --git a/libxfs/xfs_alloc_btree.c b/libxfs/xfs_alloc_btree.c
index 2d33e0e66d5..97d19203550 100644
--- a/libxfs/xfs_alloc_btree.c
+++ b/libxfs/xfs_alloc_btree.c
@@ -452,7 +452,7 @@ xfs_allocbt_keys_contiguous(
 				 be32_to_cpu(key2->alloc.ar_startblock));
 }
 
-static const struct xfs_btree_ops xfs_bnobt_ops = {
+const struct xfs_btree_ops xfs_bnobt_ops = {
 	.rec_len		= sizeof(xfs_alloc_rec_t),
 	.key_len		= sizeof(xfs_alloc_key_t),
 
@@ -475,7 +475,7 @@ static const struct xfs_btree_ops xfs_bnobt_ops = {
 	.keys_contiguous	= xfs_allocbt_keys_contiguous,
 };
 
-static const struct xfs_btree_ops xfs_cntbt_ops = {
+const struct xfs_btree_ops xfs_cntbt_ops = {
 	.rec_len		= sizeof(xfs_alloc_rec_t),
 	.key_len		= sizeof(xfs_alloc_key_t),
 	.geom_flags		= XFS_BTREE_LASTREC_UPDATE,
diff --git a/libxfs/xfs_bmap_btree.c b/libxfs/xfs_bmap_btree.c
index 020b8274c47..aa19b214ad6 100644
--- a/libxfs/xfs_bmap_btree.c
+++ b/libxfs/xfs_bmap_btree.c
@@ -513,7 +513,7 @@ xfs_bmbt_keys_contiguous(
 				 be64_to_cpu(key2->bmbt.br_startoff));
 }
 
-static const struct xfs_btree_ops xfs_bmbt_ops = {
+const struct xfs_btree_ops xfs_bmbt_ops = {
 	.rec_len		= sizeof(xfs_bmbt_rec_t),
 	.key_len		= sizeof(xfs_bmbt_key_t),
 	.geom_flags		= XFS_BTREE_LONG_PTRS | XFS_BTREE_ROOT_IN_INODE,
diff --git a/libxfs/xfs_ialloc_btree.c b/libxfs/xfs_ialloc_btree.c
index dea661afc4d..52cc00e4ff1 100644
--- a/libxfs/xfs_ialloc_btree.c
+++ b/libxfs/xfs_ialloc_btree.c
@@ -397,7 +397,7 @@ xfs_inobt_keys_contiguous(
 				 be32_to_cpu(key2->inobt.ir_startino));
 }
 
-static const struct xfs_btree_ops xfs_inobt_ops = {
+const struct xfs_btree_ops xfs_inobt_ops = {
 	.rec_len		= sizeof(xfs_inobt_rec_t),
 	.key_len		= sizeof(xfs_inobt_key_t),
 
@@ -419,7 +419,7 @@ static const struct xfs_btree_ops xfs_inobt_ops = {
 	.keys_contiguous	= xfs_inobt_keys_contiguous,
 };
 
-static const struct xfs_btree_ops xfs_finobt_ops = {
+const struct xfs_btree_ops xfs_finobt_ops = {
 	.rec_len		= sizeof(xfs_inobt_rec_t),
 	.key_len		= sizeof(xfs_inobt_key_t),
 
diff --git a/libxfs/xfs_refcount_btree.c b/libxfs/xfs_refcount_btree.c
index 1ecd670a9eb..2f91c7b62ef 100644
--- a/libxfs/xfs_refcount_btree.c
+++ b/libxfs/xfs_refcount_btree.c
@@ -316,7 +316,7 @@ xfs_refcountbt_keys_contiguous(
 				 be32_to_cpu(key2->refc.rc_startblock));
 }
 
-static const struct xfs_btree_ops xfs_refcountbt_ops = {
+const struct xfs_btree_ops xfs_refcountbt_ops = {
 	.rec_len		= sizeof(struct xfs_refcount_rec),
 	.key_len		= sizeof(struct xfs_refcount_key),
 
diff --git a/libxfs/xfs_rmap_btree.c b/libxfs/xfs_rmap_btree.c
index bedadb8b5bc..f1325586433 100644
--- a/libxfs/xfs_rmap_btree.c
+++ b/libxfs/xfs_rmap_btree.c
@@ -484,7 +484,7 @@ xfs_rmapbt_keys_contiguous(
 				 be32_to_cpu(key2->rmap.rm_startblock));
 }
 
-static const struct xfs_btree_ops xfs_rmapbt_ops = {
+const struct xfs_btree_ops xfs_rmapbt_ops = {
 	.rec_len		= sizeof(struct xfs_rmap_rec),
 	.key_len		= 2 * sizeof(struct xfs_rmap_key),
 	.geom_flags		= XFS_BTREE_CRC_BLOCKS | XFS_BTREE_OVERLAPPING,
diff --git a/libxfs/xfs_shared.h b/libxfs/xfs_shared.h
index 4220d3584c1..518ea9456eb 100644
--- a/libxfs/xfs_shared.h
+++ b/libxfs/xfs_shared.h
@@ -43,6 +43,15 @@ extern const struct xfs_buf_ops xfs_sb_buf_ops;
 extern const struct xfs_buf_ops xfs_sb_quiet_buf_ops;
 extern const struct xfs_buf_ops xfs_symlink_buf_ops;
 
+/* btree ops */
+extern const struct xfs_btree_ops xfs_bnobt_ops;
+extern const struct xfs_btree_ops xfs_cntbt_ops;
+extern const struct xfs_btree_ops xfs_inobt_ops;
+extern const struct xfs_btree_ops xfs_finobt_ops;
+extern const struct xfs_btree_ops xfs_bmbt_ops;
+extern const struct xfs_btree_ops xfs_refcountbt_ops;
+extern const struct xfs_btree_ops xfs_rmapbt_ops;
+
 /* log size calculation functions */
 int	xfs_log_calc_unit_res(struct xfs_mount *mp, int unit_bytes);
 int	xfs_log_calc_minimum_size(struct xfs_mount *);

