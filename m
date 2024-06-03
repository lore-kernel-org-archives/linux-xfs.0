Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C97A259C
	for <linux-xfs@vger.kernel.org>; Mon,  3 Jun 2024 19:05:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717441522; cv=none; b=OE+ud5gpm/9QRRSthmQPg8e970BcN/xWaNHT3Dd696YfZMciFL02RtZ372p2qffZZ8IX6pmIfBNIxnGZ2dR2EeIShNokHobtuRrCpRJ8ucwHfj/Dk8+reyHluwUuMNt04Npxh+vOIT/NDbNLtkOZYCxC0zU0MiSkj92Wzr2ju0Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717441522; c=relaxed/simple;
	bh=95ORSOuvx1faBHu0WJIbepI0cWe0UUuHpB3LxFDE3iY=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=X+Vdc23ABC9WG7GR0daAasw8jeMQi02grhS/QpPZkFPK9X+Er3GdIaVPs43yVhhOtnjBojI/1qD/25PD938GVAoPQbISrZUMHeRJ0HjZ6W1rYBqt37A+p0gXv7oi3N2tAsGkArf47M1NSA5hWtowYRjqwvnyM12eWWpYP4iiOjI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GxrD+tRo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GxrD+tRo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A51CAC2BD10;
	Mon,  3 Jun 2024 19:05:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717441521;
	bh=95ORSOuvx1faBHu0WJIbepI0cWe0UUuHpB3LxFDE3iY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=GxrD+tRojyOuShoESxnRT8tPwYltCbXZ3OS4zoExaGzQU2hDSgGpTay01DyiqP3Sg
	 onw0XrxO4tQvATY1wrw3Gm7DwlUUAObDQ5zIO4O+5IIhruWtiLjBkqkGxoD3mOHNhG
	 rwRB6X4GvQyhHCLl1m8fhs7QgoBOh2TrXXRowFeae4EGKoKbu8bXV+gS4PxdsARDA6
	 618ubmRCmcgxWTgMymPsrRIv78kkkj96lHr6nCRrGb2KHP0vKuYcuDWV5I+fNDZeRP
	 l8Pi9d6xSeZHsFmm53dvyRIJGGclrhyuG2VpfqPdnvM0AJIr8vV7pq6n9LwmEultlN
	 TggOHtx/AdOnw==
Date: Mon, 03 Jun 2024 12:05:21 -0700
Subject: [PATCH 051/111] xfs: add a xfs_btree_init_ptr_from_cur
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cmaiolino@redhat.com>,
 linux-xfs@vger.kernel.org
Message-ID: <171744040139.1443973.10223648611643418885.stgit@frogsfrogsfrogs>
In-Reply-To: <171744039240.1443973.5959953049110025783.stgit@frogsfrogsfrogs>
References: <171744039240.1443973.5959953049110025783.stgit@frogsfrogsfrogs>
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
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
---
 libxfs/xfs_bmap_btree.c    |    9 ---------
 libxfs/xfs_btree.c         |   27 +++++++++++++++++++++++----
 libxfs/xfs_btree.h         |    2 ++
 libxfs/xfs_btree_staging.c |    1 -
 4 files changed, 25 insertions(+), 14 deletions(-)


diff --git a/libxfs/xfs_bmap_btree.c b/libxfs/xfs_bmap_btree.c
index 9f66eee9a..7fc325fd3 100644
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
index 2511462e3..f59fa54e3 100644
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
index 07abc56e0..99194ae94 100644
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
index 07b43da78..656bad6cd 100644
--- a/libxfs/xfs_btree_staging.c
+++ b/libxfs/xfs_btree_staging.c
@@ -225,7 +225,6 @@ xfs_btree_stage_ifakeroot(
 	memcpy(nops, cur->bc_ops, sizeof(struct xfs_btree_ops));
 	nops->alloc_block = xfs_btree_fakeroot_alloc_block;
 	nops->free_block = xfs_btree_fakeroot_free_block;
-	nops->init_ptr_from_cur = xfs_btree_fakeroot_init_ptr_from_cur;
 	nops->dup_cursor = xfs_btree_fakeroot_dup_cursor;
 
 	cur->bc_ino.ifake = ifake;

