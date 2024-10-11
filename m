Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32ABD4A06
	for <linux-xfs@vger.kernel.org>; Fri, 11 Oct 2024 00:52:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728607970; cv=none; b=oUq4bktOUKX/SK4NrTFiWCEYj33aF7X4vY3MLOiJ+0xxhLF/62GPaDqn2KqqLtsqXfe0Ics8jC0L4L9U7OqRFm91/eUT4KMtH5FB9GjLfxMT9lvS5R+7L6CLJ/Av/yhexhR1fSJk8FZfFFJvXUuiemWhFrbpdXCJ6WcS1dc20zs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728607970; c=relaxed/simple;
	bh=zbSjiSjsRxvgwTppj8yi7iW+aGS+G7ISbzvtn+Mpe8c=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZHG+agutkPCOMaO3i6Um0jn2o/WrxBT343AA00nnKzRvIItvy4zar7F1nPTqGLCADpmPZm/M5cQsfHoTIvf2ElBVBbqPuRCnVq+unGNxzJO/UCFNc9jauxtka9PMegQTqv5K4r6sI/zkEzuVjPGueSd+ncMdGFmnHQ2k8ONaTZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HrCsxZNs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HrCsxZNs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2114C4CEC5;
	Fri, 11 Oct 2024 00:52:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728607969;
	bh=zbSjiSjsRxvgwTppj8yi7iW+aGS+G7ISbzvtn+Mpe8c=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=HrCsxZNsDjuYWWNDOUQtCwOv+guTtnmj6VQRI4RoGGAWH+X7c6KZu7w2P6FZBVQGm
	 jWWe4JdZ03MuxjR2IfxlM9AuMwG/eaY/hdLr7JCqWQwC8m5QzAPLoJmGfqzRHcjEqM
	 0ke8TZm3yhOIFVGP2pAgWUqEkZ5i+xYrBRfXyyPmWQ+kQL1g7gHcnMGLLVH1bpxkA/
	 0jkIL1Ri+8mAjbJS4eggYvVmJwbMTr5nTDTEvOtQZRZ0GPAW8Tehv0Y6P2HkIP9CrQ
	 0oeq8istXhHjmWIYDlXalKlTNWWfu4xb1+sVDNbG6lhDo3/K3SEa81l+unf8th0sBS
	 yiJFUTQiTxndA==
Date: Thu, 10 Oct 2024 17:52:49 -0700
Subject: [PATCH 17/28] xfs: refactor directory tree root predicates
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <172860642310.4176876.17006635182341906760.stgit@frogsfrogsfrogs>
In-Reply-To: <172860641935.4176876.5699259080908526243.stgit@frogsfrogsfrogs>
References: <172860641935.4176876.5699259080908526243.stgit@frogsfrogsfrogs>
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

Metadata directory trees make reasoning about the parent of a file more
difficult.  Traditionally, user files are children of sb_rootino, and
metadata files are "children" of the superblock.  Now, we add a third
possibility -- some metadata files can be children of sb_metadirino, but
the classic ones (rt free space data and quotas) are left alone.

Let's add some helper functions (instead of open-coding the logic
everywhere) to make scrub logic easier to understand.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/scrub/common.c        |   29 +++++++++++++++++++++++++++++
 fs/xfs/scrub/common.h        |    4 ++++
 fs/xfs/scrub/dir.c           |    2 +-
 fs/xfs/scrub/dir_repair.c    |    2 +-
 fs/xfs/scrub/dirtree.c       |   15 ++++++++++++++-
 fs/xfs/scrub/dirtree.h       |   12 +-----------
 fs/xfs/scrub/findparent.c    |   15 +++++++++------
 fs/xfs/scrub/inode_repair.c  |   11 ++---------
 fs/xfs/scrub/nlinks.c        |    4 ++--
 fs/xfs/scrub/nlinks_repair.c |    4 +---
 fs/xfs/scrub/orphanage.c     |    4 +++-
 fs/xfs/scrub/parent.c        |   17 ++++++++---------
 fs/xfs/scrub/parent_repair.c |    2 +-
 13 files changed, 76 insertions(+), 45 deletions(-)


diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
index 9d74c315418ffb..a1e67b0f745f35 100644
--- a/fs/xfs/scrub/common.c
+++ b/fs/xfs/scrub/common.c
@@ -1452,3 +1452,32 @@ xchk_inode_is_allocated(
 	rcu_read_unlock();
 	return error;
 }
+
+/* Is this inode a root directory for either tree? */
+bool
+xchk_inode_is_dirtree_root(const struct xfs_inode *ip)
+{
+	struct xfs_mount	*mp = ip->i_mount;
+
+	return ip == mp->m_rootip ||
+		(xfs_has_metadir(mp) && ip == mp->m_metadirip);
+}
+
+/* Does the superblock point down to this inode? */
+bool
+xchk_inode_is_sb_rooted(const struct xfs_inode *ip)
+{
+	return xchk_inode_is_dirtree_root(ip) ||
+	       xfs_internal_inum(ip->i_mount, ip->i_ino);
+}
+
+/* What is the root directory inumber for this inode? */
+xfs_ino_t
+xchk_inode_rootdir_inum(const struct xfs_inode *ip)
+{
+	struct xfs_mount	*mp = ip->i_mount;
+
+	if (xfs_is_metadir_inode(ip))
+		return mp->m_metadirip->i_ino;
+	return mp->m_rootip->i_ino;
+}
diff --git a/fs/xfs/scrub/common.h b/fs/xfs/scrub/common.h
index f3db628b14e1b9..b419adc6e7cf2a 100644
--- a/fs/xfs/scrub/common.h
+++ b/fs/xfs/scrub/common.h
@@ -242,4 +242,8 @@ void xchk_fsgates_enable(struct xfs_scrub *sc, unsigned int scrub_fshooks);
 int xchk_inode_is_allocated(struct xfs_scrub *sc, xfs_agino_t agino,
 		bool *inuse);
 
+bool xchk_inode_is_dirtree_root(const struct xfs_inode *ip);
+bool xchk_inode_is_sb_rooted(const struct xfs_inode *ip);
+xfs_ino_t xchk_inode_rootdir_inum(const struct xfs_inode *ip);
+
 #endif	/* __XFS_SCRUB_COMMON_H__ */
diff --git a/fs/xfs/scrub/dir.c b/fs/xfs/scrub/dir.c
index bf9199e8df633f..6b719c8885ef75 100644
--- a/fs/xfs/scrub/dir.c
+++ b/fs/xfs/scrub/dir.c
@@ -253,7 +253,7 @@ xchk_dir_actor(
 		 * If this is ".." in the root inode, check that the inum
 		 * matches this dir.
 		 */
-		if (dp->i_ino == mp->m_sb.sb_rootino && ino != dp->i_ino)
+		if (xchk_inode_is_dirtree_root(dp) && ino != dp->i_ino)
 			xchk_fblock_set_corrupt(sc, XFS_DATA_FORK, offset);
 	}
 
diff --git a/fs/xfs/scrub/dir_repair.c b/fs/xfs/scrub/dir_repair.c
index 64679fe0844650..0c2cd42b3110f2 100644
--- a/fs/xfs/scrub/dir_repair.c
+++ b/fs/xfs/scrub/dir_repair.c
@@ -1270,7 +1270,7 @@ xrep_dir_scan_dirtree(
 	int			error;
 
 	/* Roots of directory trees are their own parents. */
-	if (sc->ip == sc->mp->m_rootip)
+	if (xchk_inode_is_dirtree_root(sc->ip))
 		xrep_findparent_scan_found(&rd->pscan, sc->ip->i_ino);
 
 	/*
diff --git a/fs/xfs/scrub/dirtree.c b/fs/xfs/scrub/dirtree.c
index bde58fb561ea18..e43840733de946 100644
--- a/fs/xfs/scrub/dirtree.c
+++ b/fs/xfs/scrub/dirtree.c
@@ -917,7 +917,7 @@ xchk_dirtree(
 	 * scan, because the hook doesn't detach until after sc->ip gets
 	 * released during teardown.
 	 */
-	dl->root_ino = sc->mp->m_rootip->i_ino;
+	dl->root_ino = xchk_inode_rootdir_inum(sc->ip);
 	dl->scan_ino = sc->ip->i_ino;
 
 	trace_xchk_dirtree_start(sc->ip, sc->sm, 0);
@@ -983,3 +983,16 @@ xchk_dirtree(
 	trace_xchk_dirtree_done(sc->ip, sc->sm, error);
 	return error;
 }
+
+/* Does the directory targetted by this scrub have no parents? */
+bool
+xchk_dirtree_parentless(const struct xchk_dirtree *dl)
+{
+	struct xfs_scrub	*sc = dl->sc;
+
+	if (xchk_inode_is_dirtree_root(sc->ip))
+		return true;
+	if (VFS_I(sc->ip)->i_nlink == 0)
+		return true;
+	return false;
+}
diff --git a/fs/xfs/scrub/dirtree.h b/fs/xfs/scrub/dirtree.h
index 1e1686365c61c6..9e5d95492717d6 100644
--- a/fs/xfs/scrub/dirtree.h
+++ b/fs/xfs/scrub/dirtree.h
@@ -156,17 +156,7 @@ struct xchk_dirtree {
 #define xchk_dirtree_for_each_path(dl, path) \
 	list_for_each_entry((path), &(dl)->path_list, list)
 
-static inline bool
-xchk_dirtree_parentless(const struct xchk_dirtree *dl)
-{
-	struct xfs_scrub	*sc = dl->sc;
-
-	if (sc->ip == sc->mp->m_rootip)
-		return true;
-	if (VFS_I(sc->ip)->i_nlink == 0)
-		return true;
-	return false;
-}
+bool xchk_dirtree_parentless(const struct xchk_dirtree *dl);
 
 int xchk_dirtree_find_paths_to_root(struct xchk_dirtree *dl);
 int xchk_dirpath_append(struct xchk_dirtree *dl, struct xfs_inode *ip,
diff --git a/fs/xfs/scrub/findparent.c b/fs/xfs/scrub/findparent.c
index 01766041ba2cd8..153d185190d8ad 100644
--- a/fs/xfs/scrub/findparent.c
+++ b/fs/xfs/scrub/findparent.c
@@ -362,15 +362,18 @@ xrep_findparent_confirm(
 	};
 	int			error;
 
-	/*
-	 * The root directory always points to itself.  Unlinked dirs can point
-	 * anywhere, so we point them at the root dir too.
-	 */
-	if (sc->ip == sc->mp->m_rootip || VFS_I(sc->ip)->i_nlink == 0) {
+	/* The root directory always points to itself. */
+	if (sc->ip == sc->mp->m_rootip) {
 		*parent_ino = sc->mp->m_sb.sb_rootino;
 		return 0;
 	}
 
+	/* Unlinked dirs can point anywhere; point them up to the root dir. */
+	if (VFS_I(sc->ip)->i_nlink == 0) {
+		*parent_ino = xchk_inode_rootdir_inum(sc->ip);
+		return 0;
+	}
+
 	/* Reject garbage parent inode numbers and self-referential parents. */
 	if (*parent_ino == NULLFSINO)
 	       return 0;
@@ -413,7 +416,7 @@ xrep_findparent_self_reference(
 		return sc->mp->m_sb.sb_rootino;
 
 	if (VFS_I(sc->ip)->i_nlink == 0)
-		return sc->mp->m_sb.sb_rootino;
+		return xchk_inode_rootdir_inum(sc->ip);
 
 	return NULLFSINO;
 }
diff --git a/fs/xfs/scrub/inode_repair.c b/fs/xfs/scrub/inode_repair.c
index 1a7d2dfc2f405d..7700fcd8170448 100644
--- a/fs/xfs/scrub/inode_repair.c
+++ b/fs/xfs/scrub/inode_repair.c
@@ -1767,15 +1767,8 @@ xrep_inode_pptr(
 	if (inode->i_nlink == 0 && !(inode->i_state & I_LINKABLE))
 		return 0;
 
-	/* The root directory doesn't have a parent pointer. */
-	if (ip == mp->m_rootip)
-		return 0;
-
-	/*
-	 * Metadata inodes are rooted in the superblock and do not have any
-	 * parents.
-	 */
-	if (xfs_is_metadata_inode(ip))
+	/* Children of the superblock do not have parent pointers. */
+	if (xchk_inode_is_sb_rooted(ip))
 		return 0;
 
 	/* Inode already has an attr fork; no further work possible here. */
diff --git a/fs/xfs/scrub/nlinks.c b/fs/xfs/scrub/nlinks.c
index 80aee30886c456..4a47d0aabf73bd 100644
--- a/fs/xfs/scrub/nlinks.c
+++ b/fs/xfs/scrub/nlinks.c
@@ -279,7 +279,7 @@ xchk_nlinks_collect_dirent(
 	 * determine the backref count.
 	 */
 	if (dotdot) {
-		if (dp == sc->mp->m_rootip)
+		if (xchk_inode_is_dirtree_root(dp))
 			error = xchk_nlinks_update_incore(xnc, ino, 1, 0, 0);
 		else if (!xfs_has_parent(sc->mp))
 			error = xchk_nlinks_update_incore(xnc, ino, 0, 1, 0);
@@ -735,7 +735,7 @@ xchk_nlinks_compare_inode(
 		}
 	}
 
-	if (ip == sc->mp->m_rootip) {
+	if (xchk_inode_is_dirtree_root(ip)) {
 		/*
 		 * For the root of a directory tree, both the '.' and '..'
 		 * entries should point to the root directory.  The dotdot
diff --git a/fs/xfs/scrub/nlinks_repair.c b/fs/xfs/scrub/nlinks_repair.c
index b3e707f47b7b52..4ebdee09542807 100644
--- a/fs/xfs/scrub/nlinks_repair.c
+++ b/fs/xfs/scrub/nlinks_repair.c
@@ -60,11 +60,9 @@ xrep_nlinks_is_orphaned(
 	unsigned int		actual_nlink,
 	const struct xchk_nlink	*obs)
 {
-	struct xfs_mount	*mp = ip->i_mount;
-
 	if (obs->parents != 0)
 		return false;
-	if (ip == mp->m_rootip || ip == sc->orphanage)
+	if (xchk_inode_is_dirtree_root(ip) || ip == sc->orphanage)
 		return false;
 	return actual_nlink != 0;
 }
diff --git a/fs/xfs/scrub/orphanage.c b/fs/xfs/scrub/orphanage.c
index 7148d8362db833..11d7b8a62ebe11 100644
--- a/fs/xfs/scrub/orphanage.c
+++ b/fs/xfs/scrub/orphanage.c
@@ -295,7 +295,9 @@ xrep_orphanage_can_adopt(
 		return false;
 	if (sc->ip == sc->orphanage)
 		return false;
-	if (xfs_internal_inum(sc->mp, sc->ip->i_ino))
+	if (xchk_inode_is_sb_rooted(sc->ip))
+		return false;
+	if (xfs_is_metadata_inode(sc->ip))
 		return false;
 	return true;
 }
diff --git a/fs/xfs/scrub/parent.c b/fs/xfs/scrub/parent.c
index 91e7b51ce0680b..582536076433a4 100644
--- a/fs/xfs/scrub/parent.c
+++ b/fs/xfs/scrub/parent.c
@@ -300,7 +300,7 @@ xchk_parent_pptr_and_dotdot(
 	}
 
 	/* Is this the root dir?  Then '..' must point to itself. */
-	if (sc->ip == sc->mp->m_rootip) {
+	if (xchk_inode_is_dirtree_root(sc->ip)) {
 		if (sc->ip->i_ino != pp->parent_ino)
 			xchk_fblock_set_corrupt(sc, XFS_DATA_FORK, 0);
 		return 0;
@@ -711,7 +711,7 @@ xchk_parent_count_pptrs(
 	}
 
 	if (S_ISDIR(VFS_I(sc->ip)->i_mode)) {
-		if (sc->ip == sc->mp->m_rootip)
+		if (xchk_inode_is_dirtree_root(sc->ip))
 			pp->pptrs_found++;
 
 		if (VFS_I(sc->ip)->i_nlink == 0 && pp->pptrs_found > 0)
@@ -885,10 +885,9 @@ bool
 xchk_pptr_looks_zapped(
 	struct xfs_inode	*ip)
 {
-	struct xfs_mount	*mp = ip->i_mount;
 	struct inode		*inode = VFS_I(ip);
 
-	ASSERT(xfs_has_parent(mp));
+	ASSERT(xfs_has_parent(ip->i_mount));
 
 	/*
 	 * Temporary files that cannot be linked into the directory tree do not
@@ -902,15 +901,15 @@ xchk_pptr_looks_zapped(
 	 * of a parent pointer scan is always the empty set.  It's safe to scan
 	 * them even if the attr fork was zapped.
 	 */
-	if (ip == mp->m_rootip)
+	if (xchk_inode_is_dirtree_root(ip))
 		return false;
 
 	/*
-	 * Metadata inodes are all rooted in the superblock and do not have
-	 * any parents.  Hence the attr fork will not be initialized, but
-	 * there are no parent pointers that might have been zapped.
+	 * Metadata inodes that are rooted in the superblock do not have any
+	 * parents.  Hence the attr fork will not be initialized, but there are
+	 * no parent pointers that might have been zapped.
 	 */
-	if (xfs_is_metadata_inode(ip))
+	if (xchk_inode_is_sb_rooted(ip))
 		return false;
 
 	/*
diff --git a/fs/xfs/scrub/parent_repair.c b/fs/xfs/scrub/parent_repair.c
index 7b42b7f65a0bd3..f4e4845b7ec099 100644
--- a/fs/xfs/scrub/parent_repair.c
+++ b/fs/xfs/scrub/parent_repair.c
@@ -1334,7 +1334,7 @@ xrep_parent_rebuild_pptrs(
 	 * so that we can decide if we're moving this file to the orphanage.
 	 * For this purpose, root directories are their own parents.
 	 */
-	if (sc->ip == sc->mp->m_rootip) {
+	if (xchk_inode_is_dirtree_root(sc->ip)) {
 		xrep_findparent_scan_found(&rp->pscan, sc->ip->i_ino);
 	} else {
 		error = xrep_parent_lookup_pptrs(sc, &parent_ino);

