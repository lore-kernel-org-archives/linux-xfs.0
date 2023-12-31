Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D809BA2B
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 20:17:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JQezuV4K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC869C433C8;
	Sun, 31 Dec 2023 20:17:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704053864;
	bh=XHdCNcfLdP8YT26RhDwPkI8blpAuw8m9TiU9odF0yo8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=JQezuV4KxNYNlWXrVIIr1MABVHQL7RQLlpq7QojlAtQpIBXydiu7H+Dh8mXDAq55S
	 CCBRXH7M2H0TwJYTqvLY0nefwp/5MhwYDo1jbaNiZh3shjodEBgFk/HbHAfCnePliV
	 1VnfwE2J53NMxw8mupFCNj7H018/4cVhFbf0OtbWbHW3NwKYw4mj30vi6aqB9MqLXg
	 LpK86hNjaXEt8cIJuOzcnzZfuAD2knPmIAExehMUWWhz+vrLbo33/V1zu2UTul+TR8
	 WX1Tpqjh6ExBzXG+439SqeLYhyKW2QS0pvYpRt7mga6P3WeeVwkzUE/5wXwVw2Zq6z
	 MsxEcDl8XJXfg==
Date: Sun, 31 Dec 2023 12:17:44 -0800
Subject: [PATCH 3/9] xfs: export some of the btree ops structures
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404830559.1749286.9827733797493537806.stgit@frogsfrogsfrogs>
In-Reply-To: <170404830490.1749286.17145905891935561298.stgit@frogsfrogsfrogs>
References: <170404830490.1749286.17145905891935561298.stgit@frogsfrogsfrogs>
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
 fs/xfs/libxfs/xfs_alloc_btree.c    |    4 ++--
 fs/xfs/libxfs/xfs_bmap_btree.c     |    2 +-
 fs/xfs/libxfs/xfs_ialloc_btree.c   |    4 ++--
 fs/xfs/libxfs/xfs_refcount_btree.c |    2 +-
 fs/xfs/libxfs/xfs_rmap_btree.c     |    2 +-
 fs/xfs/libxfs/xfs_shared.h         |    9 +++++++++
 6 files changed, 16 insertions(+), 7 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_alloc_btree.c b/fs/xfs/libxfs/xfs_alloc_btree.c
index 76dbfc591cd57..08aa92f574334 100644
--- a/fs/xfs/libxfs/xfs_alloc_btree.c
+++ b/fs/xfs/libxfs/xfs_alloc_btree.c
@@ -454,7 +454,7 @@ xfs_allocbt_keys_contiguous(
 				 be32_to_cpu(key2->alloc.ar_startblock));
 }
 
-static const struct xfs_btree_ops xfs_bnobt_ops = {
+const struct xfs_btree_ops xfs_bnobt_ops = {
 	.rec_len		= sizeof(xfs_alloc_rec_t),
 	.key_len		= sizeof(xfs_alloc_key_t),
 
@@ -477,7 +477,7 @@ static const struct xfs_btree_ops xfs_bnobt_ops = {
 	.keys_contiguous	= xfs_allocbt_keys_contiguous,
 };
 
-static const struct xfs_btree_ops xfs_cntbt_ops = {
+const struct xfs_btree_ops xfs_cntbt_ops = {
 	.rec_len		= sizeof(xfs_alloc_rec_t),
 	.key_len		= sizeof(xfs_alloc_key_t),
 	.geom_flags		= XFS_BTREE_LASTREC_UPDATE,
diff --git a/fs/xfs/libxfs/xfs_bmap_btree.c b/fs/xfs/libxfs/xfs_bmap_btree.c
index ca7ea824b818b..5777c51a0c01d 100644
--- a/fs/xfs/libxfs/xfs_bmap_btree.c
+++ b/fs/xfs/libxfs/xfs_bmap_btree.c
@@ -515,7 +515,7 @@ xfs_bmbt_keys_contiguous(
 				 be64_to_cpu(key2->bmbt.br_startoff));
 }
 
-static const struct xfs_btree_ops xfs_bmbt_ops = {
+const struct xfs_btree_ops xfs_bmbt_ops = {
 	.rec_len		= sizeof(xfs_bmbt_rec_t),
 	.key_len		= sizeof(xfs_bmbt_key_t),
 	.geom_flags		= XFS_BTREE_LONG_PTRS | XFS_BTREE_ROOT_IN_INODE,
diff --git a/fs/xfs/libxfs/xfs_ialloc_btree.c b/fs/xfs/libxfs/xfs_ialloc_btree.c
index 3e65f028f3eea..69086fdc3be6f 100644
--- a/fs/xfs/libxfs/xfs_ialloc_btree.c
+++ b/fs/xfs/libxfs/xfs_ialloc_btree.c
@@ -398,7 +398,7 @@ xfs_inobt_keys_contiguous(
 				 be32_to_cpu(key2->inobt.ir_startino));
 }
 
-static const struct xfs_btree_ops xfs_inobt_ops = {
+const struct xfs_btree_ops xfs_inobt_ops = {
 	.rec_len		= sizeof(xfs_inobt_rec_t),
 	.key_len		= sizeof(xfs_inobt_key_t),
 
@@ -420,7 +420,7 @@ static const struct xfs_btree_ops xfs_inobt_ops = {
 	.keys_contiguous	= xfs_inobt_keys_contiguous,
 };
 
-static const struct xfs_btree_ops xfs_finobt_ops = {
+const struct xfs_btree_ops xfs_finobt_ops = {
 	.rec_len		= sizeof(xfs_inobt_rec_t),
 	.key_len		= sizeof(xfs_inobt_key_t),
 
diff --git a/fs/xfs/libxfs/xfs_refcount_btree.c b/fs/xfs/libxfs/xfs_refcount_btree.c
index 6a3a827dd3663..36e7b26d5e3b2 100644
--- a/fs/xfs/libxfs/xfs_refcount_btree.c
+++ b/fs/xfs/libxfs/xfs_refcount_btree.c
@@ -317,7 +317,7 @@ xfs_refcountbt_keys_contiguous(
 				 be32_to_cpu(key2->refc.rc_startblock));
 }
 
-static const struct xfs_btree_ops xfs_refcountbt_ops = {
+const struct xfs_btree_ops xfs_refcountbt_ops = {
 	.rec_len		= sizeof(struct xfs_refcount_rec),
 	.key_len		= sizeof(struct xfs_refcount_key),
 
diff --git a/fs/xfs/libxfs/xfs_rmap_btree.c b/fs/xfs/libxfs/xfs_rmap_btree.c
index bc01c71982fb6..f5889da0bff76 100644
--- a/fs/xfs/libxfs/xfs_rmap_btree.c
+++ b/fs/xfs/libxfs/xfs_rmap_btree.c
@@ -486,7 +486,7 @@ xfs_rmapbt_keys_contiguous(
 				 be32_to_cpu(key2->rmap.rm_startblock));
 }
 
-static const struct xfs_btree_ops xfs_rmapbt_ops = {
+const struct xfs_btree_ops xfs_rmapbt_ops = {
 	.rec_len		= sizeof(struct xfs_rmap_rec),
 	.key_len		= 2 * sizeof(struct xfs_rmap_key),
 	.geom_flags		= XFS_BTREE_CRC_BLOCKS | XFS_BTREE_OVERLAPPING,
diff --git a/fs/xfs/libxfs/xfs_shared.h b/fs/xfs/libxfs/xfs_shared.h
index 4220d3584c1b0..518ea9456ebae 100644
--- a/fs/xfs/libxfs/xfs_shared.h
+++ b/fs/xfs/libxfs/xfs_shared.h
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

