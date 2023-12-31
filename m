Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD0EEBA22
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 21:10:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YeYfADzL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD97FC433C7;
	Sun, 31 Dec 2023 21:10:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704057008;
	bh=eWG5Vd2WgKS/YcAvdI0dtZgjqQkrwdrENRdRcvrC4XY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=YeYfADzLFBL0VDbtVHj2KONPweqe8djb4pCqTNJuegbV1fARJmHim2Sb//QK+1wAB
	 sWpc5RLz9zwHFiqriaDXJRti5AB6K1xaXUL3wBUF/+EKDqHFGTlHyyAzLlHtusiRy7
	 /gGpEI+EaZh1VThlae1IoZxb3SaPE1VG1CwlnOzZTBUNIlpzwO0vzTUvmhD8q7fwUX
	 nfkgPeB7tcZXBZRjQRALWYQi4n+k/22POtUjDewbqg+fC98G2eINV3JQy4OlPXjqnD
	 4ZW+uNchu7DRYc6EssUJskEhvC1S8E3CM6qeTG0nHAI8pDhXBVdc23uoGl38J2YIzr
	 gcY9NCc8NJWSA==
Date: Sun, 31 Dec 2023 13:10:08 -0800
Subject: [PATCH 15/32] xfs: disable the agi rotor for metadata inodes
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404845107.1760491.12920292704065730816.stgit@frogsfrogsfrogs>
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

Ideally, we'd put all the metadata inodes in one place if we could, so
that the metadata all stay reasonably close together instead of
spreading out over the disk.  Furthermore, if the log is internal we'd
probably prefer to keep the metadata near the log.  Therefore, disable
AGI rotoring for metadata inode allocations.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_ialloc.c |   56 ++++++++++++++++++++++++++++++--------------
 fs/xfs/libxfs/xfs_ialloc.h |    2 +-
 fs/xfs/libxfs/xfs_imeta.c  |    4 ++-
 fs/xfs/scrub/tempfile.c    |    2 +-
 fs/xfs/xfs_inode.c         |    4 ++-
 fs/xfs/xfs_symlink.c       |    2 +-
 6 files changed, 45 insertions(+), 25 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index d58d700ed8a8b..96d22f9698a7a 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -1799,6 +1799,37 @@ xfs_dialloc_try_ag(
 	return error;
 }
 
+/*
+ * Pick an AG for the new inode.
+ *
+ * Directories, symlinks, and regular files frequently allocate at least one
+ * block, so factor that potential expansion when we examine whether an AG has
+ * enough space for file creation.  Try to keep metadata files all in the same
+ * AG.
+ */
+static inline xfs_agnumber_t
+xfs_dialloc_pick_ag(
+	struct xfs_mount	*mp,
+	struct xfs_inode	*dp,
+	umode_t			mode)
+{
+	xfs_agnumber_t		start_agno;
+
+	if (!dp)
+		return 0;
+	if (xfs_is_metadir_inode(dp))
+		return 0;
+
+	if (S_ISDIR(mode))
+		return (atomic_inc_return(&mp->m_agirotor) - 1) % mp->m_maxagi;
+
+	start_agno = XFS_INO_TO_AGNO(mp, dp->i_ino);
+	if (start_agno >= mp->m_maxagi)
+		start_agno = 0;
+
+	return start_agno;
+}
+
 /*
  * Allocate an on-disk inode.
  *
@@ -1810,34 +1841,23 @@ xfs_dialloc_try_ag(
 int
 xfs_dialloc(
 	struct xfs_trans	**tpp,
-	xfs_ino_t		parent,
+	struct xfs_inode	*dp,
 	umode_t			mode,
 	xfs_ino_t		*new_ino)
 {
 	struct xfs_mount	*mp = (*tpp)->t_mountp;
-	xfs_agnumber_t		agno;
-	int			error = 0;
-	xfs_agnumber_t		start_agno;
 	struct xfs_perag	*pag;
 	struct xfs_ino_geometry	*igeo = M_IGEO(mp);
+	xfs_ino_t		ino = NULLFSINO;
+	xfs_ino_t		parent = dp ? dp->i_ino : 0;
+	xfs_agnumber_t		agno;
+	xfs_agnumber_t		start_agno;
 	bool			ok_alloc = true;
 	bool			low_space = false;
 	int			flags;
-	xfs_ino_t		ino = NULLFSINO;
+	int			error = 0;
 
-	/*
-	 * Directories, symlinks, and regular files frequently allocate at least
-	 * one block, so factor that potential expansion when we examine whether
-	 * an AG has enough space for file creation.
-	 */
-	if (S_ISDIR(mode))
-		start_agno = (atomic_inc_return(&mp->m_agirotor) - 1) %
-				mp->m_maxagi;
-	else {
-		start_agno = XFS_INO_TO_AGNO(mp, parent);
-		if (start_agno >= mp->m_maxagi)
-			start_agno = 0;
-	}
+	start_agno = xfs_dialloc_pick_ag(mp, dp, mode);
 
 	/*
 	 * If we have already hit the ceiling of inode blocks then clear
diff --git a/fs/xfs/libxfs/xfs_ialloc.h b/fs/xfs/libxfs/xfs_ialloc.h
index f1412183bb44b..9bfe2d8d84b1d 100644
--- a/fs/xfs/libxfs/xfs_ialloc.h
+++ b/fs/xfs/libxfs/xfs_ialloc.h
@@ -37,7 +37,7 @@ xfs_make_iptr(struct xfs_mount *mp, struct xfs_buf *b, int o)
  * Allocate an inode on disk.  Mode is used to tell whether the new inode will
  * need space, and whether it is a directory.
  */
-int xfs_dialloc(struct xfs_trans **tpp, xfs_ino_t parent, umode_t mode,
+int xfs_dialloc(struct xfs_trans **tpp, struct xfs_inode *dp, umode_t mode,
 		xfs_ino_t *new_ino);
 
 int xfs_difree(struct xfs_trans *tp, struct xfs_perag *pag,
diff --git a/fs/xfs/libxfs/xfs_imeta.c b/fs/xfs/libxfs/xfs_imeta.c
index 5c5a801386a29..e3651c7bba2b3 100644
--- a/fs/xfs/libxfs/xfs_imeta.c
+++ b/fs/xfs/libxfs/xfs_imeta.c
@@ -230,7 +230,7 @@ xfs_imeta_sb_create(
 		return -EEXIST;
 
 	/* Create a new inode and set the sb pointer. */
-	error = xfs_dialloc(&upd->tp, 0, mode, &ino);
+	error = xfs_dialloc(&upd->tp, NULL, mode, &ino);
 	if (error)
 		return error;
 	error = xfs_icreate(upd->tp, ino, &args, &upd->ip);
@@ -662,7 +662,7 @@ xfs_imeta_dir_create(
 	 * entry pointing to them, but a directory also the "." entry
 	 * pointing to itself.
 	 */
-	error = xfs_dialloc(&upd->tp, upd->dp->i_ino, mode, &ino);
+	error = xfs_dialloc(&upd->tp, upd->dp, mode, &ino);
 	if (error)
 		return error;
 	error = xfs_icreate(upd->tp, ino, &args, &upd->ip);
diff --git a/fs/xfs/scrub/tempfile.c b/fs/xfs/scrub/tempfile.c
index 6d207559df989..db3a9a47e1f82 100644
--- a/fs/xfs/scrub/tempfile.c
+++ b/fs/xfs/scrub/tempfile.c
@@ -87,7 +87,7 @@ xrep_tempfile_create(
 		goto out_release_dquots;
 
 	/* Allocate inode, set up directory. */
-	error = xfs_dialloc(&tp, dp->i_ino, mode, &ino);
+	error = xfs_dialloc(&tp, dp, mode, &ino);
 	if (error)
 		goto out_trans_cancel;
 	error = xfs_icreate(tp, ino, &args, &sc->tempip);
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 7f5ad390b6c7c..66aa8bbcb1045 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -768,7 +768,7 @@ xfs_create(
 	 * entry pointing to them, but a directory also the "." entry
 	 * pointing to itself.
 	 */
-	error = xfs_dialloc(&tp, dp->i_ino, args->mode, &ino);
+	error = xfs_dialloc(&tp, dp, args->mode, &ino);
 	if (!error)
 		error = xfs_icreate(tp, ino, args, &du.ip);
 	if (error)
@@ -879,7 +879,7 @@ xfs_create_tmpfile(
 	if (error)
 		goto out_release_dquots;
 
-	error = xfs_dialloc(&tp, dp->i_ino, args->mode, &ino);
+	error = xfs_dialloc(&tp, dp, args->mode, &ino);
 	if (!error)
 		error = xfs_icreate(tp, ino, args, &ip);
 	if (error)
diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
index e7936858dfcf5..973be5e8b14be 100644
--- a/fs/xfs/xfs_symlink.c
+++ b/fs/xfs/xfs_symlink.c
@@ -169,7 +169,7 @@ xfs_symlink(
 	/*
 	 * Allocate an inode for the symlink.
 	 */
-	error = xfs_dialloc(&tp, dp->i_ino, S_IFLNK, &ino);
+	error = xfs_dialloc(&tp, dp, S_IFLNK, &ino);
 	if (!error)
 		error = xfs_icreate(tp, ino, &args, &du.ip);
 	if (error)

