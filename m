Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D387C2CC
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 23:33:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EJkkd5cp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1015FC433C7;
	Sun, 31 Dec 2023 23:33:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704065626;
	bh=MC2F6Q7YfONYnFvHKdwpYwt47ePA4MKYkY2oE5uNGvc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=EJkkd5cpkgtliJmsuCN7ayu9yr/BRIqf1xUQ2E269LSHoP5TaeH/oMqoPdqEIvz/6
	 IEsA3gVm92FbErL3bWG158Mtg5YpUXIFxHxtgBvQ/R1JslnUgSEW4ckH1lSIBI/Gn3
	 tfD6wDw9sAQBICWXbEdHtoK7DWwQ23lRMr6wJBTYi4BEKbyf1DXEM81lWDN2nCRC7i
	 pvgTq0YH6nsGvyMeJc3w76V0FgrKyYp4c38FPuJEob39we/aCrgOwkKzrFZ+qDaPg3
	 XEJOu5G6jtmC/Uyfc6DCkHboVEJX03e5NtiKsIZoa65cuD9OPg0Jy53C9n8r2gVAeQ
	 wZgFjHUokg6/A==
Date: Sun, 31 Dec 2023 15:33:45 -0800
Subject: [PATCH 16/58] xfs: disable the agi rotor for metadata inodes
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405010161.1809361.14825279080058332772.stgit@frogsfrogsfrogs>
In-Reply-To: <170405009903.1809361.17191356040741566208.stgit@frogsfrogsfrogs>
References: <170405009903.1809361.17191356040741566208.stgit@frogsfrogsfrogs>
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
 db/iunlink.c        |    2 +-
 libxfs/xfs_ialloc.c |   56 +++++++++++++++++++++++++++++++++++----------------
 libxfs/xfs_ialloc.h |    2 +-
 libxfs/xfs_imeta.c  |    4 ++--
 mkfs/proto.c        |    3 +--
 repair/phase6.c     |    2 +-
 6 files changed, 44 insertions(+), 25 deletions(-)


diff --git a/db/iunlink.c b/db/iunlink.c
index c87b98431e5..fd5ed64c9e2 100644
--- a/db/iunlink.c
+++ b/db/iunlink.c
@@ -221,7 +221,7 @@ create_unlinked(
 		return error;
 	}
 
-	error = -libxfs_dialloc(&tp, 0, args.mode, &ino);
+	error = -libxfs_dialloc(&tp, args.pip, args.mode, &ino);
 	if (error) {
 		dbprintf(_("alloc inode: %s\n"), strerror(error));
 		goto out_cancel;
diff --git a/libxfs/xfs_ialloc.c b/libxfs/xfs_ialloc.c
index 2c941603986..19543f76994 100644
--- a/libxfs/xfs_ialloc.c
+++ b/libxfs/xfs_ialloc.c
@@ -1794,6 +1794,37 @@ xfs_dialloc_try_ag(
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
@@ -1805,34 +1836,23 @@ xfs_dialloc_try_ag(
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
diff --git a/libxfs/xfs_ialloc.h b/libxfs/xfs_ialloc.h
index f1412183bb4..9bfe2d8d84b 100644
--- a/libxfs/xfs_ialloc.h
+++ b/libxfs/xfs_ialloc.h
@@ -37,7 +37,7 @@ xfs_make_iptr(struct xfs_mount *mp, struct xfs_buf *b, int o)
  * Allocate an inode on disk.  Mode is used to tell whether the new inode will
  * need space, and whether it is a directory.
  */
-int xfs_dialloc(struct xfs_trans **tpp, xfs_ino_t parent, umode_t mode,
+int xfs_dialloc(struct xfs_trans **tpp, struct xfs_inode *dp, umode_t mode,
 		xfs_ino_t *new_ino);
 
 int xfs_difree(struct xfs_trans *tp, struct xfs_perag *pag,
diff --git a/libxfs/xfs_imeta.c b/libxfs/xfs_imeta.c
index b1c5c6ec5e6..2defee9562b 100644
--- a/libxfs/xfs_imeta.c
+++ b/libxfs/xfs_imeta.c
@@ -229,7 +229,7 @@ xfs_imeta_sb_create(
 		return -EEXIST;
 
 	/* Create a new inode and set the sb pointer. */
-	error = xfs_dialloc(&upd->tp, 0, mode, &ino);
+	error = xfs_dialloc(&upd->tp, NULL, mode, &ino);
 	if (error)
 		return error;
 	error = xfs_icreate(upd->tp, ino, &args, &upd->ip);
@@ -661,7 +661,7 @@ xfs_imeta_dir_create(
 	 * entry pointing to them, but a directory also the "." entry
 	 * pointing to itself.
 	 */
-	error = xfs_dialloc(&upd->tp, upd->dp->i_ino, mode, &ino);
+	error = xfs_dialloc(&upd->tp, upd->dp, mode, &ino);
 	if (error)
 		return error;
 	error = xfs_icreate(upd->tp, ino, &args, &upd->ip);
diff --git a/mkfs/proto.c b/mkfs/proto.c
index 5e17ea420f4..0103fe54a5d 100644
--- a/mkfs/proto.c
+++ b/mkfs/proto.c
@@ -431,7 +431,6 @@ creatproto(
 				  XFS_ICREATE_ARGS_FORCE_MODE,
 	};
 	struct xfs_inode	*ip;
-	xfs_ino_t		parent_ino = dp ? dp->i_ino : 0;
 	xfs_ino_t		ino;
 	int			error;
 
@@ -442,7 +441,7 @@ creatproto(
 	 * Call the space management code to pick the on-disk inode to be
 	 * allocated.
 	 */
-	error = -libxfs_dialloc(tpp, parent_ino, mode, &ino);
+	error = -libxfs_dialloc(tpp, dp, mode, &ino);
 	if (error)
 		return error;
 
diff --git a/repair/phase6.c b/repair/phase6.c
index 6a3c5e2a37a..fe9a4da62dc 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -870,7 +870,7 @@ mk_orphanage(
 	if (i)
 		res_failed(i);
 
-	error = -libxfs_dialloc(&tp, mp->m_sb.sb_rootino, mode, &ino);
+	error = -libxfs_dialloc(&tp, du.dp, mode, &ino);
 	if (error)
 		do_error(_("%s inode allocation failed %d\n"),
 			ORPHANAGE, error);

