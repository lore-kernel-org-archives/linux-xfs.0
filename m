Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F0E25234
	for <linux-xfs@vger.kernel.org>; Wed, 22 May 2024 02:58:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716346690; cv=none; b=n/3vRFErZo7na+37jva8yIR5F1DvxdhBkSPu38U5yIoCIgg4MvtJKHFZxgV9vvFS3QmeI+AgNAwZ6jvPRU4pzBSFAtj4nsBvcG04q6Xl/B/8VHuO/qS5hCgwU1DyBDoewkZYCEcAuLxBTBNXhONMT8nFmyhMH5MTwf1bv+QSLJQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716346690; c=relaxed/simple;
	bh=Z7WAjKKzNG0qwba1x6ABP0Q+dsLIoXgQWoKnfcW5IBo=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hgs+nCj6I4NBkBprHpPY2Fih2C0i2ajdpTGbrxgGXA/Kc1ElV2+l6f2uSzXZPAcn6pDrxTx8vawonxkTjdDJQlN0Y0iiutuXmyG7PV5hAZvljwxkmC+pYThM/QcP0jdnixlbgg4awBr+xqsmjfePO+Ki+caNyn9FIwAOJ/KkmhM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rbBZ9Qme; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rbBZ9Qme"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29A75C2BD11;
	Wed, 22 May 2024 02:58:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716346690;
	bh=Z7WAjKKzNG0qwba1x6ABP0Q+dsLIoXgQWoKnfcW5IBo=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=rbBZ9QmepwtWqnBdBSlr8V8NbEsOxBr4vsGM4lmcZ0CXRzgEOACxM72blAI6AwtrJ
	 a73zoY8tKysITD+fMt3a2RINirG7OeCGGk9KF9+3WzkXD6zJy6sYu+C/F1kDNh6dgi
	 +KZKCdF4908pvcfy8OC2jnsHpozeAgjaztr0+AggxIWiXsE3vx3/HtuP4XjILW3dwJ
	 H7eh6KxZDudp1x/NDgsm7ill78cUom68dKwwNiMtPp0CK/zgfqdvl8prWPKldG8b9T
	 5PXKT9uigeDLMhOumLXS/i20JLFd3Gu+BFqiq4hnWsdKil7l08tpsY1kw+x9WWz3II
	 92IdxvG45O1RQ==
Date: Tue, 21 May 2024 19:58:09 -0700
Subject: [PATCH 036/111] xfs: extern some btree ops structures
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <171634532252.2478931.14603079680803061796.stgit@frogsfrogsfrogs>
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

Source kernel commit: d8d6df4253adcdb5862a9410d962e9168b973c88

Expose these static btree ops structures so that we can reference them
in the AG initialization code in the next patch.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_alloc_btree.c    |    4 ++--
 libxfs/xfs_bmap_btree.c     |    2 +-
 libxfs/xfs_ialloc_btree.c   |    4 ++--
 libxfs/xfs_refcount_btree.c |    2 +-
 libxfs/xfs_rmap_btree.c     |    2 +-
 libxfs/xfs_shared.h         |    9 +++++++++
 6 files changed, 16 insertions(+), 7 deletions(-)


diff --git a/libxfs/xfs_alloc_btree.c b/libxfs/xfs_alloc_btree.c
index e3c2f90eb..6c9781fcf 100644
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
 	.geom_flags		= XFS_BTGEO_LASTREC_UPDATE,
 
 	.rec_len		= sizeof(xfs_alloc_rec_t),
diff --git a/libxfs/xfs_bmap_btree.c b/libxfs/xfs_bmap_btree.c
index 52a1ce460..41b4419b5 100644
--- a/libxfs/xfs_bmap_btree.c
+++ b/libxfs/xfs_bmap_btree.c
@@ -509,7 +509,7 @@ xfs_bmbt_keys_contiguous(
 				 be64_to_cpu(key2->bmbt.br_startoff));
 }
 
-static const struct xfs_btree_ops xfs_bmbt_ops = {
+const struct xfs_btree_ops xfs_bmbt_ops = {
 	.geom_flags		= XFS_BTGEO_LONG_PTRS | XFS_BTGEO_ROOT_IN_INODE,
 
 	.rec_len		= sizeof(xfs_bmbt_rec_t),
diff --git a/libxfs/xfs_ialloc_btree.c b/libxfs/xfs_ialloc_btree.c
index dea661afc..52cc00e4f 100644
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
index 1ecd670a9..2f91c7b62 100644
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
index 7f815522c..c3a113c88 100644
--- a/libxfs/xfs_rmap_btree.c
+++ b/libxfs/xfs_rmap_btree.c
@@ -470,7 +470,7 @@ xfs_rmapbt_keys_contiguous(
 				 be32_to_cpu(key2->rmap.rm_startblock));
 }
 
-static const struct xfs_btree_ops xfs_rmapbt_ops = {
+const struct xfs_btree_ops xfs_rmapbt_ops = {
 	.geom_flags		= XFS_BTGEO_OVERLAPPING,
 
 	.rec_len		= sizeof(struct xfs_rmap_rec),
diff --git a/libxfs/xfs_shared.h b/libxfs/xfs_shared.h
index 4220d3584..518ea9456 100644
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

