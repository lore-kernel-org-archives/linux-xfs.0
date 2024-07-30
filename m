Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F0561854
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 03:21:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722309662; cv=none; b=lmR+q0sa8pR9ic+QOdK11PQZUr6n9uwb3VTSxTAwsARCAMAkha8qqyZWfB4N/qyqF/Dhop4V63tMgpvBwH2E0geD4h1iaMT0zQLTVwcV84j7K11DaSBCu9UsvPy7MX6hedOFiL7EwUyI7oCzJhLmBJUUIQx8YlXW3oqnbbzY534=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722309662; c=relaxed/simple;
	bh=XluSV66TUPYcXkTpGz2k281hTA3ix1r+iDqv5aoX1NI=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=j+mOoTCzw5MPUQmdTnqGngNF00YPVRMNRyyI6tbRF54CY575xcGq7pkBdKpPbWuNrZo3B8FG/Cw+kHQWQbGzPTir8EQVd9van0I0jQw2E2t+ekyP3rYRN6l02xwOXzYq99tMo5tyZUCpHfLYavsXkHcJ8GK24XkjOxczw5Sftos=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qzK0me2M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qzK0me2M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27FDEC32786;
	Tue, 30 Jul 2024 03:21:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722309662;
	bh=XluSV66TUPYcXkTpGz2k281hTA3ix1r+iDqv5aoX1NI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=qzK0me2MFNXD2YD1V2HcGPyuOC4GP8j2hrlIZ4WU0yzALghm2cMZFLt5310/ZSKlD
	 1Q9gwUzqmLSVL//e0p0AdQeT6W/9zFTKbgpDyT96Y/Scuv3aHOtffyKq4jkhwgk1Ty
	 ocpWKqUD9wCCXC5/+ERjlHf96g+VWBIbMR167PY9uC93qcT9LJ7tpKfVetnpWGyU2H
	 r8bUHPu1yIqwcxjFVD2te/MFGxeaBaK060KmUZ3kYCW4udLmQYgP9Y8g/wuI8nV5/8
	 4X+Xw1RCfd1B4N4RC2odFiyAMSsfmOfXsjnocLjbnTy4dhKnWeB4Xrz8QrtGNv/1Bi
	 68TUx9Gg1Gpdw==
Date: Mon, 29 Jul 2024 20:21:01 -0700
Subject: [PATCH 5/7] libxfs: pass a transaction context through listxattr
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <172230940647.1543753.663518227766891037.stgit@frogsfrogsfrogs>
In-Reply-To: <172230940561.1543753.1129774775335002180.stgit@frogsfrogsfrogs>
References: <172230940561.1543753.1129774775335002180.stgit@frogsfrogsfrogs>
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

Pass a transaction context so that a new caller can walk the attr names
and query the values all in one go without deadlocking on nested buffer
access.

While we're at it, make the existing xfs_repair callers try to use
empty transactions so that we don't deadlock on cycles in the xattr
structure.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/listxattr.c |   40 +++++++++++++++++++++++-----------------
 libxfs/listxattr.h |    6 ++++--
 repair/pptr.c      |    7 ++++++-
 3 files changed, 33 insertions(+), 20 deletions(-)


diff --git a/libxfs/listxattr.c b/libxfs/listxattr.c
index bedaca678439..34205682f022 100644
--- a/libxfs/listxattr.c
+++ b/libxfs/listxattr.c
@@ -11,6 +11,7 @@
 /* Call a function for every entry in a shortform xattr structure. */
 STATIC int
 xattr_walk_sf(
+	struct xfs_trans		*tp,
 	struct xfs_inode		*ip,
 	xattr_walk_fn			attr_fn,
 	void				*priv)
@@ -22,7 +23,7 @@ xattr_walk_sf(
 
 	sfe = libxfs_attr_sf_firstentry(hdr);
 	for (i = 0; i < hdr->count; i++) {
-		error = attr_fn(ip, sfe->flags, sfe->nameval, sfe->namelen,
+		error = attr_fn(tp, ip, sfe->flags, sfe->nameval, sfe->namelen,
 				&sfe->nameval[sfe->namelen], sfe->valuelen,
 				priv);
 		if (error)
@@ -37,6 +38,7 @@ xattr_walk_sf(
 /* Call a function for every entry in this xattr leaf block. */
 STATIC int
 xattr_walk_leaf_entries(
+	struct xfs_trans		*tp,
 	struct xfs_inode		*ip,
 	xattr_walk_fn			attr_fn,
 	struct xfs_buf			*bp,
@@ -75,7 +77,7 @@ xattr_walk_leaf_entries(
 			valuelen = be32_to_cpu(name_rmt->valuelen);
 		}
 
-		error = attr_fn(ip, entry->flags, name, namelen, value,
+		error = attr_fn(tp, ip, entry->flags, name, namelen, value,
 				valuelen, priv);
 		if (error)
 			return error;
@@ -91,6 +93,7 @@ xattr_walk_leaf_entries(
  */
 STATIC int
 xattr_walk_leaf(
+	struct xfs_trans		*tp,
 	struct xfs_inode		*ip,
 	xattr_walk_fn			attr_fn,
 	void				*priv)
@@ -98,18 +101,19 @@ xattr_walk_leaf(
 	struct xfs_buf			*leaf_bp;
 	int				error;
 
-	error = -libxfs_attr3_leaf_read(NULL, ip, ip->i_ino, 0, &leaf_bp);
+	error = -libxfs_attr3_leaf_read(tp, ip, ip->i_ino, 0, &leaf_bp);
 	if (error)
 		return error;
 
-	error = xattr_walk_leaf_entries(ip, attr_fn, leaf_bp, priv);
-	libxfs_trans_brelse(NULL, leaf_bp);
+	error = xattr_walk_leaf_entries(tp, ip, attr_fn, leaf_bp, priv);
+	libxfs_trans_brelse(tp, leaf_bp);
 	return error;
 }
 
 /* Find the leftmost leaf in the xattr dabtree. */
 STATIC int
 xattr_walk_find_leftmost_leaf(
+	struct xfs_trans		*tp,
 	struct xfs_inode		*ip,
 	struct bitmap			*seen_blocks,
 	struct xfs_buf			**leaf_bpp)
@@ -127,7 +131,7 @@ xattr_walk_find_leftmost_leaf(
 	for (;;) {
 		uint16_t		magic;
 
-		error = -libxfs_da3_node_read(NULL, ip, blkno, &bp,
+		error = -libxfs_da3_node_read(tp, ip, blkno, &bp,
 				XFS_ATTR_FORK);
 		if (error)
 			return error;
@@ -164,7 +168,7 @@ xattr_walk_find_leftmost_leaf(
 		/* Find the next level towards the leaves of the dabtree. */
 		btree = nodehdr.btree;
 		blkno = be32_to_cpu(btree->before);
-		libxfs_trans_brelse(NULL, bp);
+		libxfs_trans_brelse(tp, bp);
 
 		/* Make sure we haven't seen this new block already. */
 		if (bitmap_test(seen_blocks, blkno, 1))
@@ -184,13 +188,14 @@ xattr_walk_find_leftmost_leaf(
 	return 0;
 
 out_buf:
-	libxfs_trans_brelse(NULL, bp);
+	libxfs_trans_brelse(tp, bp);
 	return error;
 }
 
 /* Call a function for every entry in a node-format xattr structure. */
 STATIC int
 xattr_walk_node(
+	struct xfs_trans		*tp,
 	struct xfs_inode		*ip,
 	xattr_walk_fn			attr_fn,
 	void				*priv)
@@ -204,12 +209,12 @@ xattr_walk_node(
 
 	bitmap_alloc(&seen_blocks);
 
-	error = xattr_walk_find_leftmost_leaf(ip, seen_blocks, &leaf_bp);
+	error = xattr_walk_find_leftmost_leaf(tp, ip, seen_blocks, &leaf_bp);
 	if (error)
 		goto out_bitmap;
 
 	for (;;) {
-		error = xattr_walk_leaf_entries(ip, attr_fn, leaf_bp,
+		error = xattr_walk_leaf_entries(tp, ip, attr_fn, leaf_bp,
 				priv);
 		if (error)
 			goto out_leaf;
@@ -220,13 +225,13 @@ xattr_walk_node(
 		if (leafhdr.forw == 0)
 			goto out_leaf;
 
-		libxfs_trans_brelse(NULL, leaf_bp);
+		libxfs_trans_brelse(tp, leaf_bp);
 
 		/* Make sure we haven't seen this new leaf already. */
 		if (bitmap_test(seen_blocks, leafhdr.forw, 1))
 			goto out_bitmap;
 
-		error = -libxfs_attr3_leaf_read(NULL, ip, ip->i_ino,
+		error = -libxfs_attr3_leaf_read(tp, ip, ip->i_ino,
 				leafhdr.forw, &leaf_bp);
 		if (error)
 			goto out_bitmap;
@@ -238,7 +243,7 @@ xattr_walk_node(
 	}
 
 out_leaf:
-	libxfs_trans_brelse(NULL, leaf_bp);
+	libxfs_trans_brelse(tp, leaf_bp);
 out_bitmap:
 	bitmap_free(&seen_blocks);
 	return error;
@@ -247,6 +252,7 @@ xattr_walk_node(
 /* Call a function for every extended attribute in a file. */
 int
 xattr_walk(
+	struct xfs_trans	*tp,
 	struct xfs_inode	*ip,
 	xattr_walk_fn		attr_fn,
 	void			*priv)
@@ -257,15 +263,15 @@ xattr_walk(
 		return 0;
 
 	if (ip->i_af.if_format == XFS_DINODE_FMT_LOCAL)
-		return xattr_walk_sf(ip, attr_fn, priv);
+		return xattr_walk_sf(tp, ip, attr_fn, priv);
 
 	/* attr functions require that the attr fork is loaded */
-	error = -libxfs_iread_extents(NULL, ip, XFS_ATTR_FORK);
+	error = -libxfs_iread_extents(tp, ip, XFS_ATTR_FORK);
 	if (error)
 		return error;
 
 	if (libxfs_attr_is_leaf(ip))
-		return xattr_walk_leaf(ip, attr_fn, priv);
+		return xattr_walk_leaf(tp, ip, attr_fn, priv);
 
-	return xattr_walk_node(ip, attr_fn, priv);
+	return xattr_walk_node(tp, ip, attr_fn, priv);
 }
diff --git a/libxfs/listxattr.h b/libxfs/listxattr.h
index cddd96af7c0c..933e0f529ec4 100644
--- a/libxfs/listxattr.h
+++ b/libxfs/listxattr.h
@@ -6,10 +6,12 @@
 #ifndef __LIBXFS_LISTXATTR_H__
 #define __LIBXFS_LISTXATTR_H__
 
-typedef int (*xattr_walk_fn)(struct xfs_inode *ip, unsigned int attr_flags,
+typedef int (*xattr_walk_fn)(struct xfs_trans *tp, struct xfs_inode *ip,
+		unsigned int attr_flags,
 		const unsigned char *name, unsigned int namelen,
 		const void *value, unsigned int valuelen, void *priv);
 
-int xattr_walk(struct xfs_inode *ip, xattr_walk_fn attr_fn, void *priv);
+int xattr_walk(struct xfs_trans *tp, struct xfs_inode *ip,
+		xattr_walk_fn attr_fn, void *priv);
 
 #endif /* __LIBXFS_LISTXATTR_H__ */
diff --git a/repair/pptr.c b/repair/pptr.c
index cc66e637217f..ee29e47a87bd 100644
--- a/repair/pptr.c
+++ b/repair/pptr.c
@@ -593,6 +593,7 @@ store_file_pptr_name(
 /* Decide if this is a directory parent pointer and stash it if so. */
 static int
 examine_xattr(
+	struct xfs_trans	*tp,
 	struct xfs_inode	*ip,
 	unsigned int		attr_flags,
 	const unsigned char	*name,
@@ -1205,6 +1206,7 @@ check_file_parent_ptrs(
 	struct xfs_inode	*ip,
 	struct file_scan	*fscan)
 {
+	struct xfs_trans	*tp = NULL;
 	int			error;
 
 	error = -init_slab(&fscan->file_pptr_recs, sizeof(struct file_pptr));
@@ -1215,7 +1217,10 @@ check_file_parent_ptrs(
 	fscan->have_garbage = false;
 	fscan->nr_file_pptrs = 0;
 
-	error = xattr_walk(ip, examine_xattr, fscan);
+	libxfs_trans_alloc_empty(ip->i_mount, &tp);
+	error = xattr_walk(tp, ip, examine_xattr, fscan);
+	if (tp)
+		libxfs_trans_cancel(tp);
 	if (error && !no_modify)
 		do_error(_("ino %llu parent pointer scan failed: %s\n"),
 				(unsigned long long)ip->i_ino,

