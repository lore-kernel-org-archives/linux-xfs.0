Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48FA9BA2B
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 21:12:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="f1SA8c/B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19364C433C8;
	Sun, 31 Dec 2023 21:12:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704057165;
	bh=4P1HIDuJiDjuJ8QMLa2kIx0qYQDrYrNyODRmE6qt80I=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=f1SA8c/B5/s4QYq623K/mj7a+W5g//0rpFa2EfL4P0dwgPlW9yv50u6vwctr8JnUG
	 FQ3r9sMUDjy1QRu2za1I89kdJsFlbyUzvCjNzFwm05Nb4Ak61kL3+XAb4hQwis51dx
	 XBKpGWXuaL3wbo8UKfjsgT1FyCwyaqkFPU2/JOKHG6YdwxRJ4L90AtzSSLsTKQqqc7
	 Fcm2pyNYc+lFm03C2ZkCe9e7D8WukwMPQ4gdFNpEYupRukxr/XBWghXUCKuWvKkDPI
	 jXIySv4Wv9EmA4u5HMgrLoSfjSqqRr0HAhYrlPCUMdfxvGdoiuUSNkocWoCR/J0Wgc
	 +DBOdO6z+vbgQ==
Date: Sun, 31 Dec 2023 13:12:44 -0800
Subject: [PATCH 25/32] xfs: scrub metadata directories
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404845268.1760491.4772784922865082823.stgit@frogsfrogsfrogs>
In-Reply-To: <170404844790.1760491.7084433932242910678.stgit@frogsfrogsfrogs>
References: <170404844790.1760491.7084433932242910678.stgit@frogsfrogsfrogs>
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

Teach online scrub about the metadata directory tree.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/dir.c        |    8 ++++++++
 fs/xfs/scrub/dir_repair.c |    6 ++++++
 fs/xfs/scrub/dirtree.c    |   22 ++++++++++++++++++----
 fs/xfs/scrub/dirtree.h    |    2 ++
 fs/xfs/scrub/findparent.c |   37 +++++++++++++++++++++++++++++++------
 fs/xfs/scrub/parent.c     |   30 +++++++++++++++++++++++-------
 fs/xfs/scrub/trace.h      |    1 +
 7 files changed, 89 insertions(+), 17 deletions(-)


diff --git a/fs/xfs/scrub/dir.c b/fs/xfs/scrub/dir.c
index cfaddde6a34d6..b49ca2d5a160b 100644
--- a/fs/xfs/scrub/dir.c
+++ b/fs/xfs/scrub/dir.c
@@ -102,6 +102,14 @@ xchk_dir_check_ftype(
 
 	if (xfs_mode_to_ftype(VFS_I(ip)->i_mode) != ftype)
 		xchk_fblock_set_corrupt(sc, XFS_DATA_FORK, offset);
+
+	/*
+	 * Metadata and regular inodes cannot cross trees.  This property
+	 * cannot change without a full inode free and realloc cycle, so it's
+	 * safe to check this without holding locks.
+	 */
+	if (xfs_is_metadir_inode(ip) ^ xfs_is_metadir_inode(sc->ip))
+		xchk_fblock_set_corrupt(sc, XFS_DATA_FORK, offset);
 }
 
 /*
diff --git a/fs/xfs/scrub/dir_repair.c b/fs/xfs/scrub/dir_repair.c
index c66838fc144d5..304eb042df7c9 100644
--- a/fs/xfs/scrub/dir_repair.c
+++ b/fs/xfs/scrub/dir_repair.c
@@ -440,6 +440,12 @@ xrep_dir_salvage_entry(
 	if (error)
 		return 0;
 
+	/* Don't mix metadata and regular directory trees. */
+	if (xfs_is_metadir_inode(ip) ^ xfs_is_metadir_inode(rd->sc->ip)) {
+		xchk_irele(sc, ip);
+		return 0;
+	}
+
 	xname.type = xfs_mode_to_ftype(VFS_I(ip)->i_mode);
 	xchk_irele(sc, ip);
 
diff --git a/fs/xfs/scrub/dirtree.c b/fs/xfs/scrub/dirtree.c
index 53fd89e48cfc6..085561b7a1dcc 100644
--- a/fs/xfs/scrub/dirtree.c
+++ b/fs/xfs/scrub/dirtree.c
@@ -350,7 +350,8 @@ xchk_dirpath_set_outcome(
 STATIC int
 xchk_dirpath_step_up(
 	struct xchk_dirtree	*dl,
-	struct xchk_dirpath	*path)
+	struct xchk_dirpath	*path,
+	bool			is_metadir)
 {
 	struct xfs_scrub	*sc = dl->sc;
 	struct xfs_inode	*dp;
@@ -423,6 +424,14 @@ xchk_dirpath_step_up(
 		goto out_scanlock;
 	}
 
+	/* Parent must be in the same directory tree. */
+	if (is_metadir != xfs_is_metadir_inode(dp)) {
+		trace_xchk_dirpath_crosses_tree(dl->sc, dp, path->path_nr,
+				path->nr_steps, &dl->pptr);
+		error = -EFSCORRUPTED;
+		goto out_scanlock;
+	}
+
 	/*
 	 * If the extended attributes look as though they has been zapped by
 	 * the inode record repair code, we cannot scan for parent pointers.
@@ -492,6 +501,7 @@ xchk_dirpath_walk_upwards(
 	struct xchk_dirpath	*path)
 {
 	struct xfs_scrub	*sc = dl->sc;
+	bool			is_metadir;
 	int			error;
 
 	ASSERT(sc->ilock_flags & XFS_ILOCK_EXCL);
@@ -521,6 +531,7 @@ xchk_dirpath_walk_upwards(
 	 * ILOCK state is no longer tracked in the scrub context.  Hence we
 	 * must drop @sc->ip's ILOCK during the walk.
 	 */
+	is_metadir = xfs_is_metadir_inode(sc->ip);
 	mutex_unlock(&dl->lock);
 	xchk_iunlock(sc, XFS_ILOCK_EXCL);
 
@@ -530,7 +541,7 @@ xchk_dirpath_walk_upwards(
 	 * If we see any kind of error here (including corruptions), the parent
 	 * pointer of @sc->ip is corrupt.  Stop the whole scan.
 	 */
-	error = xchk_dirpath_step_up(dl, path);
+	error = xchk_dirpath_step_up(dl, path, is_metadir);
 	if (error) {
 		xchk_ilock(sc, XFS_ILOCK_EXCL);
 		mutex_lock(&dl->lock);
@@ -543,7 +554,7 @@ xchk_dirpath_walk_upwards(
 	 * *somewhere* in the path, but we don't need to stop scanning.
 	 */
 	while (!error && path->outcome == XCHK_DIRPATH_SCANNING)
-		error = xchk_dirpath_step_up(dl, path);
+		error = xchk_dirpath_step_up(dl, path, is_metadir);
 
 	/* Retake the locks we had, mark paths, etc. */
 	xchk_ilock(sc, XFS_ILOCK_EXCL);
@@ -870,7 +881,10 @@ xchk_dirtree(
 	 * scan, because the hook doesn't detach until after sc->ip gets
 	 * released during teardown.
 	 */
-	dl->root_ino = sc->mp->m_rootip->i_ino;
+	if (xfs_is_metadir_inode(sc->ip))
+		dl->root_ino = sc->mp->m_metadirip->i_ino;
+	else
+		dl->root_ino = sc->mp->m_rootip->i_ino;
 	dl->scan_ino = sc->ip->i_ino;
 
 	trace_xchk_dirtree_start(sc->ip, sc->sm, 0);
diff --git a/fs/xfs/scrub/dirtree.h b/fs/xfs/scrub/dirtree.h
index a5dca42906e0e..86c438c20fe7d 100644
--- a/fs/xfs/scrub/dirtree.h
+++ b/fs/xfs/scrub/dirtree.h
@@ -156,6 +156,8 @@ xchk_dirtree_parentless(const struct xchk_dirtree *dl)
 
 	if (sc->ip == sc->mp->m_rootip)
 		return true;
+	if (sc->ip == sc->mp->m_metadirip)
+		return true;
 	if (VFS_I(sc->ip)->i_nlink == 0)
 		return true;
 	return false;
diff --git a/fs/xfs/scrub/findparent.c b/fs/xfs/scrub/findparent.c
index ceb76b26c6cd1..55c83cb3bfd4e 100644
--- a/fs/xfs/scrub/findparent.c
+++ b/fs/xfs/scrub/findparent.c
@@ -172,6 +172,10 @@ xrep_findparent_walk_directory(
 	 */
 	lock_mode = xfs_ilock_data_map_shared(dp);
 
+	/* Don't mix metadata and regular directory trees. */
+	if (xfs_is_metadir_inode(dp) != xfs_is_metadir_inode(sc->ip))
+		goto out_unlock;
+
 	/*
 	 * If this directory is known to be sick, we cannot scan it reliably
 	 * and must abort.
@@ -360,15 +364,30 @@ xrep_findparent_confirm(
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
 
+	/* The metadata root directory always points to itself. */
+	if (sc->ip == sc->mp->m_metadirip) {
+		*parent_ino = sc->mp->m_sb.sb_metadirino;
+		return 0;
+	}
+
+	/*
+	 * Unlinked dirs can point anywhere, so we point them at the root dir
+	 * of whichever tree is appropriate.
+	 */
+	if (VFS_I(sc->ip)->i_nlink == 0) {
+		if (xfs_is_metadir_inode(sc->ip))
+			*parent_ino = sc->mp->m_sb.sb_metadirino;
+		else
+			*parent_ino = sc->mp->m_sb.sb_rootino;
+		return 0;
+	}
+
 	/* Reject garbage parent inode numbers and self-referential parents. */
 	if (*parent_ino == NULLFSINO)
 	       return 0;
@@ -410,8 +429,14 @@ xrep_findparent_self_reference(
 	if (sc->ip->i_ino == sc->mp->m_sb.sb_rootino)
 		return sc->mp->m_sb.sb_rootino;
 
-	if (VFS_I(sc->ip)->i_nlink == 0)
+	if (sc->ip->i_ino == sc->mp->m_sb.sb_metadirino)
+		return sc->mp->m_sb.sb_metadirino;
+
+	if (VFS_I(sc->ip)->i_nlink == 0) {
+		if (xfs_is_metadir_inode(sc->ip))
+			return sc->mp->m_sb.sb_metadirino;
 		return sc->mp->m_sb.sb_rootino;
+	}
 
 	return NULLFSINO;
 }
diff --git a/fs/xfs/scrub/parent.c b/fs/xfs/scrub/parent.c
index 6af212540c631..8c7ce2b9dc324 100644
--- a/fs/xfs/scrub/parent.c
+++ b/fs/xfs/scrub/parent.c
@@ -132,6 +132,14 @@ xchk_parent_validate(
 		return 0;
 	}
 
+	/* Is this the metadata root dir?  Then '..' must point to itself. */
+	if (sc->ip == mp->m_metadirip) {
+		if (sc->ip->i_ino != mp->m_sb.sb_metadirino ||
+		    sc->ip->i_ino != parent_ino)
+			xchk_fblock_set_corrupt(sc, XFS_DATA_FORK, 0);
+		return 0;
+	}
+
 	/* '..' must not point to ourselves. */
 	if (sc->ip->i_ino == parent_ino) {
 		xchk_fblock_set_corrupt(sc, XFS_DATA_FORK, 0);
@@ -185,6 +193,12 @@ xchk_parent_validate(
 		goto out_unlock;
 	}
 
+	/* Metadata and regular inodes cannot cross trees. */
+	if (xfs_is_metadir_inode(dp) != xfs_is_metadir_inode(sc->ip)) {
+		xchk_fblock_set_corrupt(sc, XFS_DATA_FORK, 0);
+		goto out_unlock;
+	}
+
 	/* Look for a directory entry in the parent pointing to the child. */
 	error = xchk_dir_walk(sc, dp, xchk_parent_actor, &spc);
 	if (!xchk_fblock_xref_process_error(sc, XFS_DATA_FORK, 0, &error))
@@ -287,7 +301,7 @@ xchk_parent_pptr_and_dotdot(
 	}
 
 	/* Is this the root dir?  Then '..' must point to itself. */
-	if (sc->ip == sc->mp->m_rootip) {
+	if (sc->ip == sc->mp->m_rootip || sc->ip == sc->mp->m_metadirip) {
 		if (sc->ip->i_ino != pp->parent_ino)
 			xchk_fblock_set_corrupt(sc, XFS_DATA_FORK, 0);
 		return 0;
@@ -721,7 +735,8 @@ xchk_parent_count_pptrs(
 	}
 
 	if (S_ISDIR(VFS_I(sc->ip)->i_mode)) {
-		if (sc->ip == sc->mp->m_rootip)
+		if (sc->ip == sc->mp->m_rootip ||
+		    sc->ip == sc->mp->m_metadirip)
 			pp->pptrs_found++;
 
 		if (VFS_I(sc->ip)->i_nlink == 0 && pp->pptrs_found > 0)
@@ -911,15 +926,16 @@ xchk_pptr_looks_zapped(
 	 * of a parent pointer scan is always the empty set.  It's safe to scan
 	 * them even if the attr fork was zapped.
 	 */
-	if (ip == mp->m_rootip)
+	if (ip == mp->m_rootip || ip == mp->m_metadirip)
 		return false;
 
 	/*
-	 * Metadata inodes are all rooted in the superblock and do not have
-	 * any parents.  Hence the attr fork will not be initialized, but
-	 * there are no parent pointers that might have been zapped.
+	 * Prior to metadata directories, all metadata inodes are rooted in the
+	 * superblock and do not have any parents.  Hence the attr fork will
+	 * not be initialized, but there are no parent pointers that might have
+	 * been zapped.
 	 */
-	if (xfs_is_metadata_inode(ip))
+	if (!xfs_has_metadir(mp) && xfs_is_metadata_inode(ip))
 		return false;
 
 	/*
diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index cc2af405cd3a7..83ad76a18b2c0 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -1763,6 +1763,7 @@ DEFINE_XCHK_DIRPATH_EVENT(xchk_dirpath_badgen);
 DEFINE_XCHK_DIRPATH_EVENT(xchk_dirpath_nondir_parent);
 DEFINE_XCHK_DIRPATH_EVENT(xchk_dirpath_unlinked_parent);
 DEFINE_XCHK_DIRPATH_EVENT(xchk_dirpath_found_next_step);
+DEFINE_XCHK_DIRPATH_EVENT(xchk_dirpath_crosses_tree);
 
 TRACE_DEFINE_ENUM(XCHK_DIRPATH_SCANNING);
 TRACE_DEFINE_ENUM(XCHK_DIRPATH_DELETE);

