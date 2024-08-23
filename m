Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5683FA21
	for <linux-xfs@vger.kernel.org>; Fri, 23 Aug 2024 00:07:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724371658; cv=none; b=AESeXjHhUjYrvqireD3fjDAmudiFN/uvSsQF0gWWMR56mxmus7q2Fkl8ciHRmKcUYwDbGSIfE08vxkezrVO8nV5afkSGl0HNHIgO0+Lea2hJisDVzxBUNfKVt0F5ySo7EmJRG7hqevV5IHc6LwdnJFpTZsYEUJUdyiZlVGIhGlc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724371658; c=relaxed/simple;
	bh=kuaMKB2sO49QFdmxcmKHOMLyMlVmyGWsYd++kcP59gs=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qQcD0vZNhWCkGNw7t6r6zpMOCSh3WHmbV5IKSQbwALPBAdpJ5bpH18qOQb027POGez0ffh/TwSC4mrpyMdBzEUX0fwlCdy9y4HNFNLxiKB21T/AN65Z8o1HMtYSPgI1D4Ibd6DK82GkBe5qK52Nzhy6/D5LW+UXFIw8Ugy2QQoA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ktaoJnEX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ktaoJnEX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33FD3C32782;
	Fri, 23 Aug 2024 00:07:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724371658;
	bh=kuaMKB2sO49QFdmxcmKHOMLyMlVmyGWsYd++kcP59gs=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ktaoJnEX0ZL7Rw0b93YMVWW/zx8NKI5jOusI1+5PjwmvEhXD2q7HNyI2+elB9iwqX
	 /5FtH16PnYJ673vKypWFYF5i2zfWB+f6VUsiiMIqRLlv1EPEdzerBEVgb0M2WqMU2D
	 36TFw/TKQxrXBS2RUkmTXlplsSuO2eHq7pz7gzn5cE2Q0nJwd0Q+iPkzaaR4xgydTH
	 8ZRWJz/oxvDHp8ggJy5J8jMENw8Kv9T1e53cuwjtKtQwHR1y4ygpjB2h2lhrUCpzus
	 6NQ/wt1boXCmmzMiFC3Oc82FLE6CaP82aWSa38QAWsoIyaq07uwl1F5sJg/Zq0yD3k
	 vfRWbNYwWg3+w==
Date: Thu, 22 Aug 2024 17:07:37 -0700
Subject: [PATCH 21/26] xfs: scrub metadata directories
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <172437085535.57482.8296127723634916281.stgit@frogsfrogsfrogs>
In-Reply-To: <172437085093.57482.7844640009051679935.stgit@frogsfrogsfrogs>
References: <172437085093.57482.7844640009051679935.stgit@frogsfrogsfrogs>
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
 fs/xfs/scrub/dirtree.c    |   17 ++++++++++++++---
 fs/xfs/scrub/findparent.c |   13 +++++++++++++
 fs/xfs/scrub/parent.c     |   14 ++++++++++++++
 fs/xfs/scrub/trace.h      |    1 +
 6 files changed, 56 insertions(+), 3 deletions(-)


diff --git a/fs/xfs/scrub/dir.c b/fs/xfs/scrub/dir.c
index 6b719c8885ef7..c877bde71e628 100644
--- a/fs/xfs/scrub/dir.c
+++ b/fs/xfs/scrub/dir.c
@@ -100,6 +100,14 @@ xchk_dir_check_ftype(
 
 	if (xfs_mode_to_ftype(VFS_I(ip)->i_mode) != ftype)
 		xchk_fblock_set_corrupt(sc, XFS_DATA_FORK, offset);
+
+	/*
+	 * Metadata and regular inodes cannot cross trees.  This property
+	 * cannot change without a full inode free and realloc cycle, so it's
+	 * safe to check this without holding locks.
+	 */
+	if (xfs_is_metadir_inode(ip) != xfs_is_metadir_inode(sc->ip))
+		xchk_fblock_set_corrupt(sc, XFS_DATA_FORK, offset);
 }
 
 /*
diff --git a/fs/xfs/scrub/dir_repair.c b/fs/xfs/scrub/dir_repair.c
index 0c2cd42b3110f..2456cf1cb7441 100644
--- a/fs/xfs/scrub/dir_repair.c
+++ b/fs/xfs/scrub/dir_repair.c
@@ -415,6 +415,12 @@ xrep_dir_salvage_entry(
 	if (error)
 		return 0;
 
+	/* Don't mix metadata and regular directory trees. */
+	if (xfs_is_metadir_inode(ip) != xfs_is_metadir_inode(rd->sc->ip)) {
+		xchk_irele(sc, ip);
+		return 0;
+	}
+
 	xname.type = xfs_mode_to_ftype(VFS_I(ip)->i_mode);
 	xchk_irele(sc, ip);
 
diff --git a/fs/xfs/scrub/dirtree.c b/fs/xfs/scrub/dirtree.c
index e43840733de94..3a9cdf8738b6d 100644
--- a/fs/xfs/scrub/dirtree.c
+++ b/fs/xfs/scrub/dirtree.c
@@ -362,7 +362,8 @@ xchk_dirpath_set_outcome(
 STATIC int
 xchk_dirpath_step_up(
 	struct xchk_dirtree	*dl,
-	struct xchk_dirpath	*path)
+	struct xchk_dirpath	*path,
+	bool			is_metadir)
 {
 	struct xfs_scrub	*sc = dl->sc;
 	struct xfs_inode	*dp;
@@ -435,6 +436,14 @@ xchk_dirpath_step_up(
 		goto out_scanlock;
 	}
 
+	/* Parent must be in the same directory tree. */
+	if (is_metadir != xfs_is_metadir_inode(dp)) {
+		trace_xchk_dirpath_crosses_tree(dl->sc, dp, path->path_nr,
+				path->nr_steps, &dl->xname, &dl->pptr_rec);
+		error = -EFSCORRUPTED;
+		goto out_scanlock;
+	}
+
 	/*
 	 * If the extended attributes look as though they has been zapped by
 	 * the inode record repair code, we cannot scan for parent pointers.
@@ -508,6 +517,7 @@ xchk_dirpath_walk_upwards(
 	struct xchk_dirpath	*path)
 {
 	struct xfs_scrub	*sc = dl->sc;
+	bool			is_metadir;
 	int			error;
 
 	ASSERT(sc->ilock_flags & XFS_ILOCK_EXCL);
@@ -538,6 +548,7 @@ xchk_dirpath_walk_upwards(
 	 * ILOCK state is no longer tracked in the scrub context.  Hence we
 	 * must drop @sc->ip's ILOCK during the walk.
 	 */
+	is_metadir = xfs_is_metadir_inode(sc->ip);
 	mutex_unlock(&dl->lock);
 	xchk_iunlock(sc, XFS_ILOCK_EXCL);
 
@@ -547,7 +558,7 @@ xchk_dirpath_walk_upwards(
 	 * If we see any kind of error here (including corruptions), the parent
 	 * pointer of @sc->ip is corrupt.  Stop the whole scan.
 	 */
-	error = xchk_dirpath_step_up(dl, path);
+	error = xchk_dirpath_step_up(dl, path, is_metadir);
 	if (error) {
 		xchk_ilock(sc, XFS_ILOCK_EXCL);
 		mutex_lock(&dl->lock);
@@ -560,7 +571,7 @@ xchk_dirpath_walk_upwards(
 	 * *somewhere* in the path, but we don't need to stop scanning.
 	 */
 	while (!error && path->outcome == XCHK_DIRPATH_SCANNING)
-		error = xchk_dirpath_step_up(dl, path);
+		error = xchk_dirpath_step_up(dl, path, is_metadir);
 
 	/* Retake the locks we had, mark paths, etc. */
 	xchk_ilock(sc, XFS_ILOCK_EXCL);
diff --git a/fs/xfs/scrub/findparent.c b/fs/xfs/scrub/findparent.c
index 153d185190d8a..84487072b6dd6 100644
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
@@ -368,6 +372,12 @@ xrep_findparent_confirm(
 		return 0;
 	}
 
+	/* The metadata root directory always points to itself. */
+	if (sc->ip == sc->mp->m_metadirip) {
+		*parent_ino = sc->mp->m_sb.sb_metadirino;
+		return 0;
+	}
+
 	/* Unlinked dirs can point anywhere; point them up to the root dir. */
 	if (VFS_I(sc->ip)->i_nlink == 0) {
 		*parent_ino = xchk_inode_rootdir_inum(sc->ip);
@@ -415,6 +425,9 @@ xrep_findparent_self_reference(
 	if (sc->ip->i_ino == sc->mp->m_sb.sb_rootino)
 		return sc->mp->m_sb.sb_rootino;
 
+	if (sc->ip->i_ino == sc->mp->m_sb.sb_metadirino)
+		return sc->mp->m_sb.sb_metadirino;
+
 	if (VFS_I(sc->ip)->i_nlink == 0)
 		return xchk_inode_rootdir_inum(sc->ip);
 
diff --git a/fs/xfs/scrub/parent.c b/fs/xfs/scrub/parent.c
index d8ea393f50597..3b692c4acc1e6 100644
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
diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index c886d5d0eb021..f9d37db6fa5d2 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -1752,6 +1752,7 @@ DEFINE_XCHK_DIRPATH_EVENT(xchk_dirpath_badgen);
 DEFINE_XCHK_DIRPATH_EVENT(xchk_dirpath_nondir_parent);
 DEFINE_XCHK_DIRPATH_EVENT(xchk_dirpath_unlinked_parent);
 DEFINE_XCHK_DIRPATH_EVENT(xchk_dirpath_found_next_step);
+DEFINE_XCHK_DIRPATH_EVENT(xchk_dirpath_crosses_tree);
 
 TRACE_DEFINE_ENUM(XCHK_DIRPATH_SCANNING);
 TRACE_DEFINE_ENUM(XCHK_DIRPATH_DELETE);

