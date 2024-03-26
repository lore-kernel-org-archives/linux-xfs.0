Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC3241292E8
	for <linux-xfs@vger.kernel.org>; Tue, 26 Mar 2024 03:37:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711424268; cv=none; b=XmrbHybSzT3+orCklyhItmh/YKJpmQubiIih0AhiQPG8fjxHHBLDRc8U+fJYxPC3wOsaymPkiCubHCKlo8SDvfADnYUWLKCbuiXhYR51kEdEzvdX6cmj/8KtAB3IFBiM+WjAoN7MxfYrNWieOKgC0b2vgivmJdEwX7lxdVg1Dto=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711424268; c=relaxed/simple;
	bh=HZbHqDehyM0yMhhb/UKe0I0sAXizZZgWhK8Vd5BT3/c=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=W8u3ENrLUazEIhWU7nwRjFB/2bP81d5XeLjPlFqeQg0QfZsYXKtAKNTK7kM0heUj7PLdXsnppeKa5EXnrhDmA+mmNfgeY5yeGz2zL6syZ6MJ8yMUnHIUGp9oHJHVbP/og4R+H3BqLIfBl8irypAOD6vgDwFAX0U2aXYzdMWOFHc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TUWnYVS2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TUWnYVS2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B071EC433F1;
	Tue, 26 Mar 2024 03:37:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711424268;
	bh=HZbHqDehyM0yMhhb/UKe0I0sAXizZZgWhK8Vd5BT3/c=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=TUWnYVS2kXPsdFPbe1TsiVY1GtWrD6fAC9Z1b0jIHMdZ4izloBmpnft7fbjVXnezp
	 rLGWc6A1Q89kcPrmO9dQhHezPpd/jDfFvpRNXdaJ2Z2bWAoZU7nHes2x7/Q5rpJCbc
	 kVPg/pdN+rmOOxsf6PzobMIUdwJWTIubpxTNkDuKw54sU12zhZADJfJcZdPEnqLPLc
	 jeyhuYJBkdIiAPKAhmINQytG4GaZWljwQSUs0zkMADBUQxlSBTfzVogfsLBtAKxrrP
	 6mR6O5E6OdXPQQ5bipL5bNgiYF54SORN2qcmBacCAKPO7956z3ryJDOL/pKNYYdq/M
	 R03J2jUOJH4DQ==
Date: Mon, 25 Mar 2024 20:37:48 -0700
Subject: [PATCH 036/110] xfs: extern some btree ops structures
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <171142131903.2215168.1127896654994421611.stgit@frogsfrogsfrogs>
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
index e3c2f90eb57a..6c9781fcf0d2 100644
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
index 52a1ce460a1b..41b4419b5e70 100644
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
index dea661afc4df..52cc00e4ff1c 100644
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
index 1ecd670a9eba..2f91c7b62ef1 100644
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
index 7f815522c820..c3a113c881d8 100644
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
index 4220d3584c1b..518ea9456eba 100644
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

