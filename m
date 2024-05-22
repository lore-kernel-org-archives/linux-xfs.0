Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D731139E
	for <linux-xfs@vger.kernel.org>; Wed, 22 May 2024 03:01:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716346894; cv=none; b=acQij+3tv8QSXe7arV1Jjnhh94UBbwO2GXt5QsJlWFWadoLa5d+g0SFVFDkhwkTMEDQ74bcBEjjsoZWD9KVHY5WfYYg/Hs511DIe+itMikiWzwTbIBwFaNihHEVTawinfFjpxqAbC7pZjJMnMcf5t49UujwWKlqsV3ZZVD3z2Lw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716346894; c=relaxed/simple;
	bh=rZOIQGYO+PIZzHhriyr6ieNQiOIfL6PNZYZv47RPxx0=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=F8gz8VV5kvkk58M/o6UDYKzhgrSc7HW8yeb+KsBWR/BNRJ4B2+dEEwbjCiMmUXMrZV+loBQW3Gl5WbOu9bIhSNxRiYvtixL7Vk7e3HJmRtk3l/0rC1rEWcYsU3u71m6sX0TdQZ/VriCRTfRbk64u9sYfDn6QSYOf+EFSovWQ0gQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lqOqZveJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lqOqZveJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D903EC2BD11;
	Wed, 22 May 2024 03:01:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716346893;
	bh=rZOIQGYO+PIZzHhriyr6ieNQiOIfL6PNZYZv47RPxx0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=lqOqZveJp+7RUozk/BOeS8+4k+jAJmDq7Yu6jAG3qEuO2bT0JrIHrHL76J+JIXfi1
	 tPwK+i134dSEu2cXAXV6lH461JEMRuOPTACP8xZ4liwWPvpeL4/dW2YFwiC7TPGfEn
	 PU/AGOHlFONDEjMYbSCbf9inflt9ClT0me49SWsf1bIsSf41ALXOxfo+bskFeuYNzl
	 xJ0HU2dnmzeM0//2iNIRM5gWXVX2Pm1ywLr4aZcPEE5mEs2QJVMv5ugoEtFPMFz2m5
	 CZf7vJOmJudhQfjNSW1cFDAcBnu2sjhFUVpHkd451BAuRA1WPhZ9j3A+ECA/Ci6Ye7
	 dk8fI5Oafaq0g==
Date: Tue, 21 May 2024 20:01:33 -0700
Subject: [PATCH 049/111] xfs: create predicate to determine if cursor is at
 inode root level
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <171634532440.2478931.11599422056765558469.stgit@frogsfrogsfrogs>
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

Source kernel commit: f73def90a7cd24a32a42f689efba6a7a35edeb7b

Create a predicate to decide if the given cursor and level point to the
root block in the inode immediate area instead of a disk block, and get
rid of the open-coded logic everywhere.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_btree.c         |   56 +++++++++++++++++++-------------------------
 libxfs/xfs_btree.h         |   10 ++++++++
 libxfs/xfs_btree_staging.c |    3 +-
 3 files changed, 35 insertions(+), 34 deletions(-)


diff --git a/libxfs/xfs_btree.c b/libxfs/xfs_btree.c
index 6d90e10b3..2511462e3 100644
--- a/libxfs/xfs_btree.c
+++ b/libxfs/xfs_btree.c
@@ -746,8 +746,7 @@ xfs_btree_get_block(
 	int			level,	/* level in btree */
 	struct xfs_buf		**bpp)	/* buffer containing the block */
 {
-	if (cur->bc_ops->type == XFS_BTREE_TYPE_INODE &&
-	    level == cur->bc_nlevels - 1) {
+	if (xfs_btree_at_iroot(cur, level)) {
 		*bpp = NULL;
 		return xfs_btree_get_iroot(cur);
 	}
@@ -989,8 +988,7 @@ xfs_btree_readahead(
 	 * No readahead needed if we are at the root level and the
 	 * btree root is stored in the inode.
 	 */
-	if (cur->bc_ops->type == XFS_BTREE_TYPE_INODE &&
-	    lev == cur->bc_nlevels - 1)
+	if (xfs_btree_at_iroot(cur, lev))
 		return 0;
 
 	if ((cur->bc_levels[lev].ra | lr) == cur->bc_levels[lev].ra)
@@ -1811,8 +1809,7 @@ xfs_btree_lookup_get_block(
 	int			error = 0;
 
 	/* special case the root block if in an inode */
-	if (cur->bc_ops->type == XFS_BTREE_TYPE_INODE &&
-	    level == cur->bc_nlevels - 1) {
+	if (xfs_btree_at_iroot(cur, level)) {
 		*blkp = xfs_btree_get_iroot(cur);
 		return 0;
 	}
@@ -2347,8 +2344,7 @@ xfs_btree_lshift(
 	int			error;		/* error return value */
 	int			i;
 
-	if ((cur->bc_ops->type == XFS_BTREE_TYPE_INODE) &&
-	    level == cur->bc_nlevels - 1)
+	if (xfs_btree_at_iroot(cur, level))
 		goto out0;
 
 	/* Set up variables for this block as "right". */
@@ -2543,8 +2539,7 @@ xfs_btree_rshift(
 	int			error;		/* error return value */
 	int			i;		/* loop counter */
 
-	if (cur->bc_ops->type == XFS_BTREE_TYPE_INODE &&
-	    level == cur->bc_nlevels - 1)
+	if (xfs_btree_at_iroot(cur, level))
 		goto out0;
 
 	/* Set up variables for this block as "left". */
@@ -3243,8 +3238,7 @@ xfs_btree_make_block_unfull(
 {
 	int			error = 0;
 
-	if (cur->bc_ops->type == XFS_BTREE_TYPE_INODE &&
-	    level == cur->bc_nlevels - 1) {
+	if (xfs_btree_at_iroot(cur, level)) {
 		struct xfs_inode *ip = cur->bc_ino.ip;
 
 		if (numrecs < cur->bc_ops->get_dmaxrecs(cur, level)) {
@@ -3853,27 +3847,25 @@ xfs_btree_delrec(
 	 * Try to get rid of the next level down.  If we can't then there's
 	 * nothing left to do.
 	 */
+	if (xfs_btree_at_iroot(cur, level)) {
+		xfs_iroot_realloc(cur->bc_ino.ip, -1, cur->bc_ino.whichfork);
+
+		error = xfs_btree_kill_iroot(cur);
+		if (error)
+			goto error0;
+
+		error = xfs_btree_dec_cursor(cur, level, stat);
+		if (error)
+			goto error0;
+		*stat = 1;
+		return 0;
+	}
+
+	/*
+	 * If this is the root level, and there's only one entry left, and it's
+	 * NOT the leaf level, then we can get rid of this level.
+	 */
 	if (level == cur->bc_nlevels - 1) {
-		if (cur->bc_ops->type == XFS_BTREE_TYPE_INODE) {
-			xfs_iroot_realloc(cur->bc_ino.ip, -1,
-					  cur->bc_ino.whichfork);
-
-			error = xfs_btree_kill_iroot(cur);
-			if (error)
-				goto error0;
-
-			error = xfs_btree_dec_cursor(cur, level, stat);
-			if (error)
-				goto error0;
-			*stat = 1;
-			return 0;
-		}
-
-		/*
-		 * If this is the root level, and there's only one entry left,
-		 * and it's NOT the leaf level, then we can get rid of this
-		 * level.
-		 */
 		if (numrecs == 1 && level > 0) {
 			union xfs_btree_ptr	*pp;
 			/*
diff --git a/libxfs/xfs_btree.h b/libxfs/xfs_btree.h
index 153d86725..07abc56e0 100644
--- a/libxfs/xfs_btree.h
+++ b/libxfs/xfs_btree.h
@@ -747,4 +747,14 @@ void xfs_btree_destroy_cur_caches(void);
 
 int xfs_btree_goto_left_edge(struct xfs_btree_cur *cur);
 
+/* Does this level of the cursor point to the inode root (and not a block)? */
+static inline bool
+xfs_btree_at_iroot(
+	const struct xfs_btree_cur	*cur,
+	int				level)
+{
+	return cur->bc_ops->type == XFS_BTREE_TYPE_INODE &&
+	       level == cur->bc_nlevels - 1;
+}
+
 #endif	/* __XFS_BTREE_H__ */
diff --git a/libxfs/xfs_btree_staging.c b/libxfs/xfs_btree_staging.c
index 80bcb7ba2..07b43da78 100644
--- a/libxfs/xfs_btree_staging.c
+++ b/libxfs/xfs_btree_staging.c
@@ -398,8 +398,7 @@ xfs_btree_bload_prep_block(
 	struct xfs_btree_block		*new_block;
 	int				ret;
 
-	if (cur->bc_ops->type == XFS_BTREE_TYPE_INODE &&
-	    level == cur->bc_nlevels - 1) {
+	if (xfs_btree_at_iroot(cur, level)) {
 		struct xfs_ifork	*ifp = xfs_btree_ifork_ptr(cur);
 		size_t			new_size;
 

