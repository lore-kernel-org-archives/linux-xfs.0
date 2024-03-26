Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E9F01D53C
	for <linux-xfs@vger.kernel.org>; Tue, 26 Mar 2024 03:41:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711424504; cv=none; b=hlzr7kBcR8jOL6aIn3BcXfABZyL3t/nUhpsgxfXUH9c80nk6kYhHSQEGINaICaQNzk9RlNlfY/SyVp3+ttRE1xGB7NGgUSEY6YaJvN9e5WjsO7jvmaAAKdyL/sjCnzwgNVIuRxkfo7Qf72nlDBrb2e0Pkbsgk+yhme/MPMDPEY4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711424504; c=relaxed/simple;
	bh=SIAbGUhdBhswe5B/s5BkOgeIagYsY4qonEtacXAChC0=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fA6KWJWqp5xnw+eC21IaFe+tzIwt8YXrGTDUJ6L5PouzGOTwxBPwhy0atwe/57U2X4ToNy7+vgkGZ3EvqjHeSb7pnocxbml8HZiQK4QOSnm+BhwbY9sTj3alGmr57o7L7a8s5BEbghX9CzEfZwqjL4vjj8k3rdUwTbPyZuQ72SQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RFonYJVj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RFonYJVj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB45FC433C7;
	Tue, 26 Mar 2024 03:41:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711424504;
	bh=SIAbGUhdBhswe5B/s5BkOgeIagYsY4qonEtacXAChC0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=RFonYJVjCo/YledM4GhqwPp3eiu0rjMKjPWpqarkOO0DuOWw0Whz92kNR21vQrpTQ
	 TyreCHY5x2nsfgBKAmf4qWWVJaeP4Lz08e0UVpWFAovm5t7fFPN4C19Xc2RR6xrN5n
	 b4772AC+e+RZS8z5Nt0noEx4G8BYYZ1it07VuCvtdMLZ7N7xWd3AHqCne4neZCrErG
	 u6SYDjkJhv9zY/ticzkApPo1ADve5m67Zsll731rn2hls8kZtqWgO0f674Xj25JsIq
	 WXxNy964D2gbypDrHDvW2GIXrxwVHotnx3j1hgpT85T31y8yuB2G5+OlFTOk/znDlG
	 r5V/gHAvpJPZw==
Date: Mon, 25 Mar 2024 20:41:43 -0700
Subject: [PATCH 051/110] xfs: add a xfs_btree_init_ptr_from_cur
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <171142132119.2215168.15721306181564564411.stgit@frogsfrogsfrogs>
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

From: Christoph Hellwig <hch@lst.de>

Source kernel commit: f9c18129e57df7b33f4257340840525816481da6

Inode-rooted btrees don't need to initialize the root pointer in the
->init_ptr_from_cur method as the root is found by the
xfs_btree_get_iroot method later.  Make ->init_ptr_from_cur option
for inode rooted btrees by providing a helper that does the right
thing for the given btree type and also documents the semantics.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_bmap_btree.c    |    9 ---------
 libxfs/xfs_btree.c         |   27 +++++++++++++++++++++++----
 libxfs/xfs_btree.h         |    2 ++
 libxfs/xfs_btree_staging.c |    1 -
 4 files changed, 25 insertions(+), 14 deletions(-)


diff --git a/libxfs/xfs_bmap_btree.c b/libxfs/xfs_bmap_btree.c
index 9f66eee9a598..7fc325fd344c 100644
--- a/libxfs/xfs_bmap_btree.c
+++ b/libxfs/xfs_bmap_btree.c
@@ -368,14 +368,6 @@ xfs_bmbt_init_rec_from_cur(
 	xfs_bmbt_disk_set_all(&rec->bmbt, &cur->bc_rec.b);
 }
 
-STATIC void
-xfs_bmbt_init_ptr_from_cur(
-	struct xfs_btree_cur	*cur,
-	union xfs_btree_ptr	*ptr)
-{
-	ptr->l = 0;
-}
-
 STATIC int64_t
 xfs_bmbt_key_diff(
 	struct xfs_btree_cur		*cur,
@@ -543,7 +535,6 @@ const struct xfs_btree_ops xfs_bmbt_ops = {
 	.init_key_from_rec	= xfs_bmbt_init_key_from_rec,
 	.init_high_key_from_rec	= xfs_bmbt_init_high_key_from_rec,
 	.init_rec_from_cur	= xfs_bmbt_init_rec_from_cur,
-	.init_ptr_from_cur	= xfs_bmbt_init_ptr_from_cur,
 	.key_diff		= xfs_bmbt_key_diff,
 	.diff_two_keys		= xfs_bmbt_diff_two_keys,
 	.buf_ops		= &xfs_bmbt_buf_ops,
diff --git a/libxfs/xfs_btree.c b/libxfs/xfs_btree.c
index 2511462e3c8f..f59fa54e3ea6 100644
--- a/libxfs/xfs_btree.c
+++ b/libxfs/xfs_btree.c
@@ -1878,6 +1878,25 @@ xfs_lookup_get_search_key(
 	return xfs_btree_key_addr(cur, keyno, block);
 }
 
+/*
+ * Initialize a pointer to the root block.
+ */
+void
+xfs_btree_init_ptr_from_cur(
+	struct xfs_btree_cur	*cur,
+	union xfs_btree_ptr	*ptr)
+{
+	if (cur->bc_ops->type == XFS_BTREE_TYPE_INODE) {
+		/*
+		 * Inode-rooted btrees call xfs_btree_get_iroot to find the root
+		 * in xfs_btree_lookup_get_block and don't need a pointer here.
+		 */
+		ptr->l = 0;
+	} else {
+		cur->bc_ops->init_ptr_from_cur(cur, ptr);
+	}
+}
+
 /*
  * Lookup the record.  The cursor is made to point to it, based on dir.
  * stat is set to 0 if can't find any such record, 1 for success.
@@ -1908,7 +1927,7 @@ xfs_btree_lookup(
 	keyno = 0;
 
 	/* initialise start pointer from cursor */
-	cur->bc_ops->init_ptr_from_cur(cur, &ptr);
+	xfs_btree_init_ptr_from_cur(cur, &ptr);
 	pp = &ptr;
 
 	/*
@@ -3118,7 +3137,7 @@ xfs_btree_new_root(
 	XFS_BTREE_STATS_INC(cur, newroot);
 
 	/* initialise our start point from the cursor */
-	cur->bc_ops->init_ptr_from_cur(cur, &rptr);
+	xfs_btree_init_ptr_from_cur(cur, &rptr);
 
 	/* Allocate the new block. If we can't do it, we're toast. Give up. */
 	error = xfs_btree_alloc_block(cur, &rptr, &lptr, stat);
@@ -4427,7 +4446,7 @@ xfs_btree_visit_blocks(
 	struct xfs_btree_block		*block = NULL;
 	int				error = 0;
 
-	cur->bc_ops->init_ptr_from_cur(cur, &lptr);
+	xfs_btree_init_ptr_from_cur(cur, &lptr);
 
 	/* for each level */
 	for (level = cur->bc_nlevels - 1; level >= 0; level--) {
@@ -4849,7 +4868,7 @@ xfs_btree_overlapped_query_range(
 
 	/* Load the root of the btree. */
 	level = cur->bc_nlevels - 1;
-	cur->bc_ops->init_ptr_from_cur(cur, &ptr);
+	xfs_btree_init_ptr_from_cur(cur, &ptr);
 	error = xfs_btree_lookup_get_block(cur, level, &ptr, &block);
 	if (error)
 		return error;
diff --git a/libxfs/xfs_btree.h b/libxfs/xfs_btree.h
index 07abc56e0395..99194ae94694 100644
--- a/libxfs/xfs_btree.h
+++ b/libxfs/xfs_btree.h
@@ -714,6 +714,8 @@ void xfs_btree_copy_ptrs(struct xfs_btree_cur *cur,
 void xfs_btree_copy_keys(struct xfs_btree_cur *cur,
 		union xfs_btree_key *dst_key,
 		const union xfs_btree_key *src_key, int numkeys);
+void xfs_btree_init_ptr_from_cur(struct xfs_btree_cur *cur,
+		union xfs_btree_ptr *ptr);
 
 static inline struct xfs_btree_cur *
 xfs_btree_alloc_cursor(
diff --git a/libxfs/xfs_btree_staging.c b/libxfs/xfs_btree_staging.c
index 07b43da78752..656bad6cdb77 100644
--- a/libxfs/xfs_btree_staging.c
+++ b/libxfs/xfs_btree_staging.c
@@ -225,7 +225,6 @@ xfs_btree_stage_ifakeroot(
 	memcpy(nops, cur->bc_ops, sizeof(struct xfs_btree_ops));
 	nops->alloc_block = xfs_btree_fakeroot_alloc_block;
 	nops->free_block = xfs_btree_fakeroot_free_block;
-	nops->init_ptr_from_cur = xfs_btree_fakeroot_init_ptr_from_cur;
 	nops->dup_cursor = xfs_btree_fakeroot_dup_cursor;
 
 	cur->bc_ino.ifake = ifake;

