Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDD3385289
	for <linux-xfs@vger.kernel.org>; Thu,  1 Feb 2024 19:46:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706816772; cv=none; b=GMpRg89fmkY+Iy1AHD41CIfkCzD/Lvq9Dby3V8LFuyPWjBUi/usq2RVKKELQrAGkcRTJEzmL/SvVPVrIIoXuwizsT4W1qhg6MUkBeagBr2wqxPv+zie9C/eedgCYdq5+8gG8ts5KzXxIQlobVjc//KWCpuzkpKC3zv8FLooGKPE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706816772; c=relaxed/simple;
	bh=UiW5tWDG05GpMmI18b1f2usx+wcgLO1SzlkpCgNIbQw=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lp1vvKFiU9SUxgSuDCeR3M9Bz7gc4cYeoNZUS1CgQyQaatqL2qlTf9VyXgJ+fv+30Vw4m/x7RwMBh7pNklliUQLueAD8o4grxlpCjefkQfr+S4z8pEr7qw7siz95sWprLHbuoPb4uD3fVEFfePCFPxkB+GwasbN0xC94UWusgp8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dR2n4uIO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dR2n4uIO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5E43C433C7;
	Thu,  1 Feb 2024 19:46:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706816771;
	bh=UiW5tWDG05GpMmI18b1f2usx+wcgLO1SzlkpCgNIbQw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=dR2n4uIOIvxIWQv2C9aX86wfVnteoBFEZiH8SYUP0PLQtqsZSj921dUKeJ4jgUslC
	 eE7pTMQudXxgGdvrGBHnBNko+klsutzQgZkkqL7Acg+37edJJgv/HsSWlfIE/BTZ9X
	 v+W2Uo5Y6dqM7LsUh65SP68jZkW7Ig+zjSHkA6wqHlHGTZOcF9/iaBV5x1BaO7RqlY
	 GfKWHZMtZ8qBnQ0NSFaOWV9c6tLHIbVIF1QV6gRYY2nIFMgbt4GIUSlo6rjW1Q8eIu
	 IbIM8GbFIcqWzsqNVUmxGBxMai87CqnreOoqrrK3ROPk5CqI9l26dAm8OQRneyi6oy
	 QQJDMUKTZTlLw==
Date: Thu, 01 Feb 2024 11:46:11 -0800
Subject: [PATCH 02/27] xfs: add a xfs_btree_init_ptr_from_cur
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <170681334818.1605438.10689427619767273540.stgit@frogsfrogsfrogs>
In-Reply-To: <170681334718.1605438.17032954797722239513.stgit@frogsfrogsfrogs>
References: <170681334718.1605438.17032954797722239513.stgit@frogsfrogsfrogs>
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

Inode-rooted btrees don't need to initialize the root pointer in the
->init_ptr_from_cur method as the root is found by the
xfs_btree_get_iroot method later.  Make ->init_ptr_from_cur option
for inode rooted btrees by providing a helper that does the right
thing for the given btree type and also documents the semantics.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_bmap_btree.c    |    9 ---------
 fs/xfs/libxfs/xfs_btree.c         |   27 +++++++++++++++++++++++----
 fs/xfs/libxfs/xfs_btree.h         |    2 ++
 fs/xfs/libxfs/xfs_btree_staging.c |    1 -
 fs/xfs/scrub/btree.c              |    2 +-
 5 files changed, 26 insertions(+), 15 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_bmap_btree.c b/fs/xfs/libxfs/xfs_bmap_btree.c
index 5dad3db4affa0..726cb506bbbfa 100644
--- a/fs/xfs/libxfs/xfs_bmap_btree.c
+++ b/fs/xfs/libxfs/xfs_bmap_btree.c
@@ -369,14 +369,6 @@ xfs_bmbt_init_rec_from_cur(
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
@@ -544,7 +536,6 @@ const struct xfs_btree_ops xfs_bmbt_ops = {
 	.init_key_from_rec	= xfs_bmbt_init_key_from_rec,
 	.init_high_key_from_rec	= xfs_bmbt_init_high_key_from_rec,
 	.init_rec_from_cur	= xfs_bmbt_init_rec_from_cur,
-	.init_ptr_from_cur	= xfs_bmbt_init_ptr_from_cur,
 	.key_diff		= xfs_bmbt_key_diff,
 	.diff_two_keys		= xfs_bmbt_diff_two_keys,
 	.buf_ops		= &xfs_bmbt_buf_ops,
diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index 87747d259e718..a5313e5e09eae 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -1881,6 +1881,25 @@ xfs_lookup_get_search_key(
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
@@ -1911,7 +1930,7 @@ xfs_btree_lookup(
 	keyno = 0;
 
 	/* initialise start pointer from cursor */
-	cur->bc_ops->init_ptr_from_cur(cur, &ptr);
+	xfs_btree_init_ptr_from_cur(cur, &ptr);
 	pp = &ptr;
 
 	/*
@@ -3121,7 +3140,7 @@ xfs_btree_new_root(
 	XFS_BTREE_STATS_INC(cur, newroot);
 
 	/* initialise our start point from the cursor */
-	cur->bc_ops->init_ptr_from_cur(cur, &rptr);
+	xfs_btree_init_ptr_from_cur(cur, &rptr);
 
 	/* Allocate the new block. If we can't do it, we're toast. Give up. */
 	error = xfs_btree_alloc_block(cur, &rptr, &lptr, stat);
@@ -4430,7 +4449,7 @@ xfs_btree_visit_blocks(
 	struct xfs_btree_block		*block = NULL;
 	int				error = 0;
 
-	cur->bc_ops->init_ptr_from_cur(cur, &lptr);
+	xfs_btree_init_ptr_from_cur(cur, &lptr);
 
 	/* for each level */
 	for (level = cur->bc_nlevels - 1; level >= 0; level--) {
@@ -4852,7 +4871,7 @@ xfs_btree_overlapped_query_range(
 
 	/* Load the root of the btree. */
 	level = cur->bc_nlevels - 1;
-	cur->bc_ops->init_ptr_from_cur(cur, &ptr);
+	xfs_btree_init_ptr_from_cur(cur, &ptr);
 	error = xfs_btree_lookup_get_block(cur, level, &ptr, &block);
 	if (error)
 		return error;
diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
index ee0fd16392d81..273027515296a 100644
--- a/fs/xfs/libxfs/xfs_btree.h
+++ b/fs/xfs/libxfs/xfs_btree.h
@@ -714,6 +714,8 @@ void xfs_btree_copy_ptrs(struct xfs_btree_cur *cur,
 void xfs_btree_copy_keys(struct xfs_btree_cur *cur,
 		union xfs_btree_key *dst_key,
 		const union xfs_btree_key *src_key, int numkeys);
+void xfs_btree_init_ptr_from_cur(struct xfs_btree_cur *cur,
+		union xfs_btree_ptr *ptr);
 
 static inline struct xfs_btree_cur *
 xfs_btree_alloc_cursor(
diff --git a/fs/xfs/libxfs/xfs_btree_staging.c b/fs/xfs/libxfs/xfs_btree_staging.c
index 4a8495fbbfb0b..f0600314335ed 100644
--- a/fs/xfs/libxfs/xfs_btree_staging.c
+++ b/fs/xfs/libxfs/xfs_btree_staging.c
@@ -225,7 +225,6 @@ xfs_btree_stage_ifakeroot(
 	memcpy(nops, cur->bc_ops, sizeof(struct xfs_btree_ops));
 	nops->alloc_block = xfs_btree_fakeroot_alloc_block;
 	nops->free_block = xfs_btree_fakeroot_free_block;
-	nops->init_ptr_from_cur = xfs_btree_fakeroot_init_ptr_from_cur;
 	nops->dup_cursor = xfs_btree_fakeroot_dup_cursor;
 
 	cur->bc_ino.ifake = ifake;
diff --git a/fs/xfs/scrub/btree.c b/fs/xfs/scrub/btree.c
index 71cfb2a454682..1ec3339755b92 100644
--- a/fs/xfs/scrub/btree.c
+++ b/fs/xfs/scrub/btree.c
@@ -733,7 +733,7 @@ xchk_btree(
 	 * error codes for us.
 	 */
 	level = cur->bc_nlevels - 1;
-	cur->bc_ops->init_ptr_from_cur(cur, &ptr);
+	xfs_btree_init_ptr_from_cur(cur, &ptr);
 	if (!xchk_btree_ptr_ok(bs, cur->bc_nlevels, &ptr))
 		goto out;
 	error = xchk_btree_get_block(bs, level, &ptr, &block, &bp);

