Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C38841760
	for <linux-xfs@vger.kernel.org>; Thu,  1 Feb 2024 19:45:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706816741; cv=none; b=ta6hDQ2BymX7Vjhu5DiGNpO6CkdXrKUtiPmWV6u7u7JClvXt6r4wpHd2pgUN5iP8Id1M7335rmt6VPd9Apa4VnGrhEbzCP0n6QRMM7UZlcg+u/7xhNa92thIYEL0eHM7d2wkhD95u778QUMYEu4VL+kvkx0URDWmF9y9R+m7nzA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706816741; c=relaxed/simple;
	bh=/n679k/dSQnXQQWbfcw0ZIVUYU29ijyYG+VANOQ24mE=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=on5eCi1Wyi49tUzTVzLWKyW5dJAg29RewNmBSh/YELTh2j3jJdyBv14LxyZyjbNpz4MV5K1G3NtLpexSmE/oq91QxPmcCOeFabSlXT2RpKXNs+QqkpuyRv8bRaipQL6reR4O07kYQ+eR6QUY5D5sgFdobh+CYezdIp1tkMyA1vM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=b0XZjEgS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="b0XZjEgS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 757C5C43390;
	Thu,  1 Feb 2024 19:45:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706816740;
	bh=/n679k/dSQnXQQWbfcw0ZIVUYU29ijyYG+VANOQ24mE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=b0XZjEgSqXGOh7Lq9QJmU7zxnxnwAbymCiCK+fr/5u9j60BbNDPoQxMbUN1YdswOS
	 WesSfsJUeyE3nq96NqVVF57eurAFcO6ij41dnLYLwj3E6rjioexEZ1ZcBvl8uP4d6c
	 fhK2IqxllzLY+zMZ/FFOEXzVi+3jYYIX7TD46aOJ604slynkIveI1kYtbfkbGygMOO
	 1hoMfRDZBpIseBIwBFDNSEjwIcvyyFj8Y4UwnQVS3KlRVNWRX86UfpaqWOoVO2+dy8
	 +Fx2T5kDTZWLs034eMKWoIhDGAS+uuMuG3Wg41er5WPVxhZavkTf68nuRNkRhpq0D9
	 41+JiS5oVovLA==
Date: Thu, 01 Feb 2024 11:45:40 -0800
Subject: [PATCH 23/23] xfs: create predicate to determine if cursor is at
 inode root level
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <170681334318.1604831.14019767811861690726.stgit@frogsfrogsfrogs>
In-Reply-To: <170681333879.1604831.1274408743361215078.stgit@frogsfrogsfrogs>
References: <170681333879.1604831.1274408743361215078.stgit@frogsfrogsfrogs>
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

Create a predicate to decide if the given cursor and level point to the
root block in the inode immediate area instead of a disk block, and get
rid of the open-coded logic everywhere.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_btree.c         |   56 ++++++++++++++++---------------------
 fs/xfs/libxfs/xfs_btree.h         |   10 +++++++
 fs/xfs/libxfs/xfs_btree_staging.c |    3 +-
 3 files changed, 35 insertions(+), 34 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index 17ded4ccec75f..87747d259e718 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -749,8 +749,7 @@ xfs_btree_get_block(
 	int			level,	/* level in btree */
 	struct xfs_buf		**bpp)	/* buffer containing the block */
 {
-	if (cur->bc_ops->type == XFS_BTREE_TYPE_INODE &&
-	    level == cur->bc_nlevels - 1) {
+	if (xfs_btree_at_iroot(cur, level)) {
 		*bpp = NULL;
 		return xfs_btree_get_iroot(cur);
 	}
@@ -992,8 +991,7 @@ xfs_btree_readahead(
 	 * No readahead needed if we are at the root level and the
 	 * btree root is stored in the inode.
 	 */
-	if (cur->bc_ops->type == XFS_BTREE_TYPE_INODE &&
-	    lev == cur->bc_nlevels - 1)
+	if (xfs_btree_at_iroot(cur, lev))
 		return 0;
 
 	if ((cur->bc_levels[lev].ra | lr) == cur->bc_levels[lev].ra)
@@ -1814,8 +1812,7 @@ xfs_btree_lookup_get_block(
 	int			error = 0;
 
 	/* special case the root block if in an inode */
-	if (cur->bc_ops->type == XFS_BTREE_TYPE_INODE &&
-	    level == cur->bc_nlevels - 1) {
+	if (xfs_btree_at_iroot(cur, level)) {
 		*blkp = xfs_btree_get_iroot(cur);
 		return 0;
 	}
@@ -2350,8 +2347,7 @@ xfs_btree_lshift(
 	int			error;		/* error return value */
 	int			i;
 
-	if ((cur->bc_ops->type == XFS_BTREE_TYPE_INODE) &&
-	    level == cur->bc_nlevels - 1)
+	if (xfs_btree_at_iroot(cur, level))
 		goto out0;
 
 	/* Set up variables for this block as "right". */
@@ -2546,8 +2542,7 @@ xfs_btree_rshift(
 	int			error;		/* error return value */
 	int			i;		/* loop counter */
 
-	if (cur->bc_ops->type == XFS_BTREE_TYPE_INODE &&
-	    level == cur->bc_nlevels - 1)
+	if (xfs_btree_at_iroot(cur, level))
 		goto out0;
 
 	/* Set up variables for this block as "left". */
@@ -3246,8 +3241,7 @@ xfs_btree_make_block_unfull(
 {
 	int			error = 0;
 
-	if (cur->bc_ops->type == XFS_BTREE_TYPE_INODE &&
-	    level == cur->bc_nlevels - 1) {
+	if (xfs_btree_at_iroot(cur, level)) {
 		struct xfs_inode *ip = cur->bc_ino.ip;
 
 		if (numrecs < cur->bc_ops->get_dmaxrecs(cur, level)) {
@@ -3856,27 +3850,25 @@ xfs_btree_delrec(
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
diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
index 7fc29562164b4..ee0fd16392d81 100644
--- a/fs/xfs/libxfs/xfs_btree.h
+++ b/fs/xfs/libxfs/xfs_btree.h
@@ -745,4 +745,14 @@ void xfs_btree_destroy_cur_caches(void);
 
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
diff --git a/fs/xfs/libxfs/xfs_btree_staging.c b/fs/xfs/libxfs/xfs_btree_staging.c
index 244b22edf6f73..4a8495fbbfb0b 100644
--- a/fs/xfs/libxfs/xfs_btree_staging.c
+++ b/fs/xfs/libxfs/xfs_btree_staging.c
@@ -398,8 +398,7 @@ xfs_btree_bload_prep_block(
 	struct xfs_btree_block		*new_block;
 	int				ret;
 
-	if (cur->bc_ops->type == XFS_BTREE_TYPE_INODE &&
-	    level == cur->bc_nlevels - 1) {
+	if (xfs_btree_at_iroot(cur, level)) {
 		struct xfs_ifork	*ifp = xfs_btree_ifork_ptr(cur);
 		size_t			new_size;
 

