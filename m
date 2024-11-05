Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E426C1DD0D2
	for <linux-xfs@vger.kernel.org>; Tue,  5 Nov 2024 22:22:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730845358; cv=none; b=Y4lci0TExJ3vPDpfzkD+uxolu3Lpvz8AcNhuZY1ln1tQi4wJodMlGnNIIlZ6mgekjx2U4k4m+d7CwVM4ie0cbnpQBehRqKzJtGTMoP9OMryFZu9D2iVzTMIJ6KOBWrmPw46hryitgUlN9wlF/TPwW8HhsI891Sn26p7V1NIt9Pw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730845358; c=relaxed/simple;
	bh=Vs2fnJzrT2GSr4nFGbhqExuczZRFLjTwzR20GMbQW2Q=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lkoNmgckyZmMtbQy6Z25ANFoq2DIjtaMZqpjTj/IU4SYXu2IdOSBl6/6Wx7cYzKCTnu5s4s+G8TKB3UL508+4Fiusus12l2zOPciLR+aYchHd4rztVn7NhPwXarlG1XwXxtgUTjj1QK8eTT/6M0QkF6Ushm1RGMis6wBys4YoLs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=icVRBMxX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="icVRBMxX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95C70C4CECF;
	Tue,  5 Nov 2024 22:22:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730845357;
	bh=Vs2fnJzrT2GSr4nFGbhqExuczZRFLjTwzR20GMbQW2Q=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=icVRBMxXuxUHqtRNRgwXzLTxBw2H6+9aaNNFiNuMt++KWOziH2egz+Yp6feqNK4+8
	 bEkhGbvck20pMWv/Sw4vQGEv0FUhzkoyXiwPwoBc07ym1Dqt5PfkzWCv2BNz60PXOm
	 XCjf1RjdZMPV+ZGJsJPBdE3zAzG76hO3E+QM1nn3CwnFD9OBpwFE/I3gePNuK7dePZ
	 vnEHCdj0CYOu9vxOB3otAHIYfL7FKJAaFxEQdMt0KcTYyxlcEIqUiUQQQ8AWIxmhUQ
	 udNBIyKl/yClFjdysnSDwVuigFGHoGx0TOsK2h2DywRGoAniz7C2LgH+FCFvjrOKHr
	 qIDMvhSExUzlQ==
Date: Tue, 05 Nov 2024 14:22:37 -0800
Subject: [PATCH 23/28] xfs: scrub metadata directories
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <173084396413.1870066.4224138846918723239.stgit@frogsfrogsfrogs>
In-Reply-To: <173084395946.1870066.5846370267426919612.stgit@frogsfrogsfrogs>
References: <173084395946.1870066.5846370267426919612.stgit@frogsfrogsfrogs>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/scrub/dir.c        |    8 ++++++++
 fs/xfs/scrub/dir_repair.c |    6 ++++++
 fs/xfs/scrub/dirtree.c    |   17 ++++++++++++++---
 fs/xfs/scrub/findparent.c |   13 +++++++++++++
 fs/xfs/scrub/parent.c     |   14 ++++++++++++++
 fs/xfs/scrub/trace.h      |    1 +
 6 files changed, 56 insertions(+), 3 deletions(-)


diff --git a/fs/xfs/scrub/dir.c b/fs/xfs/scrub/dir.c
index 6b719c8885ef75..c877bde71e6280 100644
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
index 0c2cd42b3110f2..2456cf1cb74411 100644
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
index e43840733de946..3a9cdf8738b6db 100644
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
index 153d185190d8ad..84487072b6dd6f 100644
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
index d8ea393f505970..3b692c4acc1e6f 100644
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
index 58cc61f2ed5372..bc246d86a5c89f 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -1753,6 +1753,7 @@ DEFINE_XCHK_DIRPATH_EVENT(xchk_dirpath_badgen);
 DEFINE_XCHK_DIRPATH_EVENT(xchk_dirpath_nondir_parent);
 DEFINE_XCHK_DIRPATH_EVENT(xchk_dirpath_unlinked_parent);
 DEFINE_XCHK_DIRPATH_EVENT(xchk_dirpath_found_next_step);
+DEFINE_XCHK_DIRPATH_EVENT(xchk_dirpath_crosses_tree);
 
 TRACE_DEFINE_ENUM(XCHK_DIRPATH_SCANNING);
 TRACE_DEFINE_ENUM(XCHK_DIRPATH_DELETE);

