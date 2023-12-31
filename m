Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F4FBBA2B
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 21:23:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="efbi5nWY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF2C6C433C7;
	Sun, 31 Dec 2023 21:23:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704057838;
	bh=e94nk7HKuXvJom4sxOWn7qqGHKb0JTAjHs3pjpIvy3Q=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=efbi5nWYnfsquBZ91BzQKJqlGLgdMERhsJP5eX+7Xw+pWBAJ3JVNHBvG1wcazbNHp
	 sq1zvLirungrzANDtsyHmPflxgmWnQ+8ZvPl+HsdTrnUopSvfjBL9D5D8641ygYJQH
	 pqTrOtODEGaFGz0MrLYRHvlh6E5pmYVbTSmyu+4OW4k+I0K6XquB8YIZP8SuP0F2Ce
	 TvJ6b7u4qPsJQzmh2QEyRiOuIJ+9d0URkSvWOb9I4YwRrTOM1LgmgAuaiuvEdJOtzF
	 rSOnyJgp9WwkqXiyxVc6XLUpuRVZgc/h8QmXZ5aSx4CshcxiUlzr2ij2Q2qItwRDba
	 Mm/zk+PNrps5g==
Date: Sun, 31 Dec 2023 13:23:57 -0800
Subject: [PATCH 07/14] xfs: rearrange xfs_iroot_realloc a bit
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404847479.1763835.9522160459812004724.stgit@frogsfrogsfrogs>
In-Reply-To: <170404847334.1763835.8921217007526026461.stgit@frogsfrogsfrogs>
References: <170404847334.1763835.8921217007526026461.stgit@frogsfrogsfrogs>
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

Rearrange the innards of xfs_iroot_realloc so that we can reduce
duplicated code prior to genericizing the function.  No functional
changes.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_inode_fork.c |   49 ++++++++++++++++++----------------------
 1 file changed, 22 insertions(+), 27 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
index fc23087dc2a87..c2de6fbf5d128 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.c
+++ b/fs/xfs/libxfs/xfs_inode_fork.c
@@ -447,44 +447,46 @@ xfs_ifork_move_broot(
  */
 void
 xfs_iroot_realloc(
-	xfs_inode_t		*ip,
+	struct xfs_inode	*ip,
 	int			rec_diff,
 	int			whichfork)
 {
 	struct xfs_mount	*mp = ip->i_mount;
-	int			cur_max;
 	struct xfs_ifork	*ifp = xfs_ifork_ptr(ip, whichfork);
 	struct xfs_btree_block	*new_broot;
-	int			new_max;
 	size_t			new_size;
 	size_t			old_size = ifp->if_broot_bytes;
+	int			cur_max;
+	int			new_max;
+
+	/* Handle degenerate cases. */
+	if (rec_diff == 0)
+		return;
 
 	/*
-	 * Handle the degenerate case quietly.
+	 * If there wasn't any memory allocated before, just allocate it now
+	 * and get out.
 	 */
-	if (rec_diff == 0) {
+	if (old_size == 0) {
+		ASSERT(rec_diff > 0);
+
+		new_size = xfs_bmap_broot_space_calc(mp, rec_diff);
+		xfs_iroot_alloc(ip, whichfork, new_size);
 		return;
 	}
 
+	/* Compute the new and old record count and space requirements. */
+	cur_max = xfs_bmbt_maxrecs(mp, old_size, 0);
+	new_max = cur_max + rec_diff;
+	ASSERT(new_max >= 0);
+	new_size = xfs_bmap_broot_space_calc(mp, new_max);
+
 	if (rec_diff > 0) {
-		/*
-		 * If there wasn't any memory allocated before, just
-		 * allocate it now and get out.
-		 */
-		if (old_size == 0) {
-			new_size = xfs_bmap_broot_space_calc(mp, rec_diff);
-			xfs_iroot_alloc(ip, whichfork, new_size);
-			return;
-		}
-
 		/*
 		 * If there is already an existing if_broot, then we need
 		 * to realloc() it and shift the pointers to their new
 		 * location.
 		 */
-		cur_max = xfs_bmbt_maxrecs(mp, old_size, 0);
-		new_max = cur_max + rec_diff;
-		new_size = xfs_bmap_broot_space_calc(mp, new_max);
 		ifp->if_broot = krealloc(ifp->if_broot, new_size,
 					 GFP_NOFS | __GFP_NOFAIL);
 		ifp->if_broot_bytes = new_size;
@@ -496,14 +498,8 @@ xfs_iroot_realloc(
 	/*
 	 * rec_diff is less than 0.  In this case, we are shrinking the
 	 * if_broot buffer.  It must already exist.  If we go to zero
-	 * records, just get rid of the root and clear the status bit.
+	 * bytes, just get rid of the root and clear the status bit.
 	 */
-	ASSERT((ifp->if_broot != NULL) && (old_size > 0));
-	cur_max = xfs_bmbt_maxrecs(mp, old_size, 0);
-	new_max = cur_max + rec_diff;
-	ASSERT(new_max >= 0);
-
-	new_size = xfs_bmap_broot_space_calc(mp, new_max);
 	if (new_size == 0) {
 		xfs_iroot_free(ip, whichfork);
 		return;
@@ -516,8 +512,7 @@ xfs_iroot_realloc(
 
 	kmem_free(ifp->if_broot);
 	ifp->if_broot = new_broot;
-	ifp->if_broot_bytes = (int)new_size;
-	return;
+	ifp->if_broot_bytes = new_size;
 }
 
 

