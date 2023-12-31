Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA0ADC2C5
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 23:41:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uEM3uOvC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8274FC433C7;
	Sun, 31 Dec 2023 23:41:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704066079;
	bh=53DXZrN34nrYzVjtwFlNLxASjeSy3NbolYryVjmKhrk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=uEM3uOvCzYJmq7zztE4UBLu3cSbH5BUpRkA5mXwye1ZQVREnLV4Dn40Vn4UsfQHJd
	 cB68YqgEodys3aO+O0tE3EQRC0Zjb6HMV8G3wh72KKRQmf/fy4eMqWyeysF/TSBiAR
	 xElgHmcBsLZa6GuUEbEO77WByiinWVNl9mpdN0iNypVuvB1C8Y6yuGghAM0Uo6KSz9
	 MJ/2zZkqWcvsCgRt05Pk5MTyqR6aTUtxevU4yKCVce+U9rTQ84xjTSkv7cxHqkYyqz
	 kyUXS+4/xW+CMbN8JUcV+NajYePJ6W2B6tZapuL+pma0BUHDw9Izj168bYMjauFJXY
	 EyH5toR9qG7aw==
Date: Sun, 31 Dec 2023 15:41:19 -0800
Subject: [PATCH 45/58] xfs_repair: rebuild the metadata directory
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405010546.1809361.1266895681831439993.stgit@frogsfrogsfrogs>
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

Check the metadata directory for problems and rebuild it if necessary.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/libxfs_api_defs.h |    2 
 repair/dino_chunks.c     |   12 ++
 repair/dir2.c            |   25 +++
 repair/globals.c         |    3 
 repair/globals.h         |    3 
 repair/phase1.c          |    2 
 repair/phase2.c          |    7 +
 repair/phase4.c          |   16 ++
 repair/phase6.c          |  361 ++++++++++++++++++++++++++++++++++++++++++----
 repair/pptr.c            |   51 ++++++
 repair/pptr.h            |    2 
 repair/sb.c              |    3 
 repair/xfs_repair.c      |   81 ++++++++++
 13 files changed, 526 insertions(+), 42 deletions(-)


diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index e171755a6f0..5f2250ac5e2 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -188,7 +188,7 @@
 #define xfs_imeta_link_space_res	libxfs_imeta_link_space_res
 #define xfs_imeta_lookup		libxfs_imeta_lookup
 #define xfs_imeta_mount			libxfs_imeta_mount
-#define xfs_imeta_set_metaflag		libxfs_imeta_set_metaflag
+#define xfs_imeta_set_iflag		libxfs_imeta_set_iflag
 #define xfs_imeta_start_create		libxfs_imeta_start_create
 #define xfs_imeta_start_link		libxfs_imeta_start_link
 #define xfs_imeta_start_unlink		libxfs_imeta_start_unlink
diff --git a/repair/dino_chunks.c b/repair/dino_chunks.c
index 19536133451..479dc9db760 100644
--- a/repair/dino_chunks.c
+++ b/repair/dino_chunks.c
@@ -932,6 +932,18 @@ process_inode_chunk(
 	_("would clear root inode %" PRIu64 "\n"),
 						ino);
 				}
+			} else if (mp->m_sb.sb_metadirino == ino) {
+				need_metadir_inode = true;
+
+				if (!no_modify)  {
+					do_warn(
+	_("cleared metadata directory %" PRIu64 "\n"),
+						ino);
+				} else  {
+					do_warn(
+	_("would clear metadata directory %" PRIu64 "\n"),
+						ino);
+				}
 			} else if (mp->m_sb.sb_rbmino == ino) {
 				need_rbmino = 1;
 
diff --git a/repair/dir2.c b/repair/dir2.c
index 1184392ff47..a7f5018fba2 100644
--- a/repair/dir2.c
+++ b/repair/dir2.c
@@ -146,6 +146,10 @@ is_meta_ino(
 {
 	char			*reason = NULL;
 
+	/* in metadir land we don't have static metadata inodes anymore */
+	if (xfs_has_metadir(mp))
+		return false;
+
 	if (lino == mp->m_sb.sb_rbmino)
 		reason = _("realtime bitmap");
 	else if (lino == mp->m_sb.sb_rsumino)
@@ -160,6 +164,16 @@ is_meta_ino(
 		 (dip->di_flags2 & cpu_to_be64(XFS_DIFLAG2_METADIR)))
 		reason = _("metadata directory file");
 
+	if (xfs_has_metadir(mp) &&
+	    dirino == mp->m_sb.sb_metadirino) {
+		if (reason == NULL) {
+			/* no regular files in the metadir */
+			*junkreason = _("non-metadata inode");
+			return true;
+		}
+		return false;
+	}
+
 	if (reason)
 		*junkreason = reason;
 	return reason != NULL;
@@ -583,7 +597,8 @@ _("corrected root directory %" PRIu64 " .. entry, was %" PRIu64 ", now %" PRIu64
 _("would have corrected root directory %" PRIu64 " .. entry from %" PRIu64" to %" PRIu64 "\n"),
 				ino, *parent, ino);
 		}
-	} else if (ino == *parent && ino != mp->m_sb.sb_rootino)  {
+	} else if (ino == *parent && ino != mp->m_sb.sb_rootino &&
+		   ino != mp->m_sb.sb_metadirino)  {
 		/*
 		 * likewise, non-root directories can't have .. pointing
 		 * to .
@@ -879,7 +894,8 @@ _("entry at block %u offset %" PRIdPTR " in directory inode %" PRIu64 " has ille
 				 * NULLFSINO otherwise.
 				 */
 				if (ino == ent_ino &&
-						ino != mp->m_sb.sb_rootino) {
+				    ino != mp->m_sb.sb_rootino &&
+				    ino != mp->m_sb.sb_metadirino) {
 					*parent = NULLFSINO;
 					do_warn(
 _("bad .. entry in directory inode %" PRIu64 ", points to self: "),
@@ -1520,9 +1536,14 @@ process_dir2(
 	} else if (dotdot == 0 && ino == mp->m_sb.sb_rootino) {
 		do_warn(_("no .. entry for root directory %" PRIu64 "\n"), ino);
 		need_root_dotdot = 1;
+	} else if (dotdot == 0 && ino == mp->m_sb.sb_metadirino) {
+		do_warn(_("no .. entry for metaino directory %" PRIu64 "\n"), ino);
+		need_metadir_dotdot = 1;
 	}
 
 	ASSERT((ino != mp->m_sb.sb_rootino && ino != *parent) ||
+		(ino == mp->m_sb.sb_metadirino &&
+			(ino == *parent || need_metadir_dotdot == 1)) ||
 		(ino == mp->m_sb.sb_rootino &&
 			(ino == *parent || need_root_dotdot == 1)));
 
diff --git a/repair/globals.c b/repair/globals.c
index 7d95e210e8e..22cb096c6a4 100644
--- a/repair/globals.c
+++ b/repair/globals.c
@@ -69,6 +69,9 @@ int	fs_is_dirty;
 int	need_root_inode;
 int	need_root_dotdot;
 
+bool	need_metadir_inode;
+int	need_metadir_dotdot;
+
 int	need_rbmino;
 int	need_rsumino;
 
diff --git a/repair/globals.h b/repair/globals.h
index 71a64b94365..c3709f11874 100644
--- a/repair/globals.h
+++ b/repair/globals.h
@@ -110,6 +110,9 @@ extern int		fs_is_dirty;
 extern int		need_root_inode;
 extern int		need_root_dotdot;
 
+extern bool		need_metadir_inode;
+extern int		need_metadir_dotdot;
+
 extern int		need_rbmino;
 extern int		need_rsumino;
 
diff --git a/repair/phase1.c b/repair/phase1.c
index 00b98584eed..40e7f164c55 100644
--- a/repair/phase1.c
+++ b/repair/phase1.c
@@ -48,6 +48,8 @@ phase1(xfs_mount_t *mp)
 	primary_sb_modified = 0;
 	need_root_inode = 0;
 	need_root_dotdot = 0;
+	need_metadir_inode = false;
+	need_metadir_dotdot = 0;
 	need_rbmino = 0;
 	need_rsumino = 0;
 	lost_quotas = 0;
diff --git a/repair/phase2.c b/repair/phase2.c
index a58fa7d8a7b..5a08cbc31c6 100644
--- a/repair/phase2.c
+++ b/repair/phase2.c
@@ -646,8 +646,11 @@ phase2(
 	 * make sure we know about the root inode chunk
 	 */
 	if ((ino_rec = find_inode_rec(mp, 0, mp->m_sb.sb_rootino)) == NULL)  {
-		ASSERT(mp->m_sb.sb_rbmino == mp->m_sb.sb_rootino + 1 &&
-			mp->m_sb.sb_rsumino == mp->m_sb.sb_rootino + 2);
+		ASSERT(!xfs_has_metadir(mp) ||
+		       mp->m_sb.sb_metadirino == mp->m_sb.sb_rootino + 1);
+		ASSERT(xfs_has_metadir(mp) ||
+		       (mp->m_sb.sb_rbmino == mp->m_sb.sb_rootino + 1 &&
+			mp->m_sb.sb_rsumino == mp->m_sb.sb_rootino + 2));
 		do_warn(_("root inode chunk not found\n"));
 
 		/*
diff --git a/repair/phase4.c b/repair/phase4.c
index 5e5d8c3c7d9..f004111ea4e 100644
--- a/repair/phase4.c
+++ b/repair/phase4.c
@@ -264,6 +264,22 @@ phase4(xfs_mount_t *mp)
 			do_warn(_("root inode lost\n"));
 	}
 
+	/*
+	 * If metadata directory trees are enabled, the metadata root directory
+	 * always comes immediately after the regular root directory, even if
+	 * it's free.
+	 */
+	if (xfs_has_metadir(mp) &&
+	    (is_inode_free(irec, 1) || !inode_isadir(irec, 1))) {
+		need_metadir_inode = true;
+		if (no_modify)
+			do_warn(
+	_("metadata directory root inode would be lost\n"));
+		else
+			do_warn(
+	_("metadata directory root inode lost\n"));
+	}
+
 	for (i = 0; i < mp->m_sb.sb_agcount; i++)  {
 		ag_end = (i < mp->m_sb.sb_agcount - 1) ? mp->m_sb.sb_agblocks :
 			mp->m_sb.sb_dblocks -
diff --git a/repair/phase6.c b/repair/phase6.c
index afb09ff7232..05e0b8ac593 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -471,6 +471,144 @@ reset_root_ino(
 	libxfs_inode_init(tp, &args, ip);
 }
 
+/* Mark a newly allocated inode in use in the incore bitmap. */
+static void
+mark_ino_inuse(
+	struct xfs_mount	*mp,
+	xfs_ino_t		ino,
+	int			mode,
+	xfs_ino_t		parent)
+{
+	struct ino_tree_node	*irec;
+	int			ino_offset;
+	int			i;
+
+	irec = find_inode_rec(mp, XFS_INO_TO_AGNO(mp, ino),
+			XFS_INO_TO_AGINO(mp, ino));
+
+	if (irec == NULL) {
+		/*
+		 * This inode is allocated from a newly created inode
+		 * chunk and therefore did not exist when inode chunks
+		 * were processed in phase3. Add this group of inodes to
+		 * the entry avl tree as if they were discovered in phase3.
+		 */
+		irec = set_inode_free_alloc(mp,
+				XFS_INO_TO_AGNO(mp, ino),
+				XFS_INO_TO_AGINO(mp, ino));
+		alloc_ex_data(irec);
+
+		for (i = 0; i < XFS_INODES_PER_CHUNK; i++)
+			set_inode_free(irec, i);
+	}
+
+	ino_offset = get_inode_offset(mp, ino, irec);
+
+	/*
+	 * Mark the inode allocated so it is not skipped in phase 7.  We'll
+	 * find it with the directory traverser soon, so we don't need to
+	 * mark it reached.
+	 */
+	set_inode_used(irec, ino_offset);
+	set_inode_ftype(irec, ino_offset, libxfs_mode_to_ftype(mode));
+	set_inode_parent(irec, ino_offset, parent);
+	if (S_ISDIR(mode))
+		set_inode_isadir(irec, ino_offset);
+}
+
+/* Make sure this metadata directory path exists. */
+static int
+ensure_imeta_dirpath(
+	struct xfs_mount		*mp,
+	const struct xfs_imeta_path	*path)
+{
+	struct xfs_imeta_path		temp_path = {
+		.im_path		= path->im_path,
+		.im_depth		= 1,
+		.im_ftype		= XFS_DIR3_FT_DIR,
+	};
+	struct xfs_trans		*tp;
+	unsigned int			i;
+	xfs_ino_t			parent;
+	int				error;
+
+	if (!xfs_has_metadir(mp))
+		return 0;
+
+	error = -libxfs_imeta_ensure_dirpath(mp, path);
+	if (error)
+		return error;
+
+	error = -libxfs_trans_alloc_empty(mp, &tp);
+	if (error)
+		return error;
+
+	/* Mark all directories in this path as inuse. */
+	parent = mp->m_metadirip->i_ino;
+	for (i = 0; i < path->im_depth - 1; i++, temp_path.im_depth++) {
+		xfs_ino_t		ino;
+
+		error = -libxfs_imeta_lookup(tp, &temp_path, &ino);
+		if (error)
+			break;
+		if (ino == NULLFSINO) {
+			error = ENOENT;
+			break;
+		}
+
+		mark_ino_inuse(mp, ino, S_IFDIR, parent);
+		parent = ino;
+	}
+
+	libxfs_trans_cancel(tp);
+	return error;
+}
+
+/* Look up the parent of this path. */
+static xfs_ino_t
+lookup_imeta_path_dirname(
+	struct xfs_mount		*mp,
+	const struct xfs_imeta_path	*path)
+{
+	struct xfs_imeta_path		temp_path = {
+		.im_path		= path->im_path,
+		.im_depth		= path->im_depth - 1,
+		.im_ftype		= XFS_DIR3_FT_DIR,
+	};
+	struct xfs_trans		*tp;
+	xfs_ino_t			ino;
+	int				error;
+
+	if (!xfs_has_metadir(mp))
+		return NULLFSINO;
+
+	error = -libxfs_trans_alloc_empty(mp, &tp);
+	if (error)
+		return NULLFSINO;
+	error = -libxfs_imeta_lookup(tp, &temp_path, &ino);
+	libxfs_trans_cancel(tp);
+	if (error)
+		return NULLFSINO;
+
+	return ino;
+}
+
+static inline bool
+is_inode_inuse(
+	struct xfs_mount	*mp,
+	xfs_ino_t		inum)
+{
+	struct ino_tree_node	*irec;
+	int			ino_offset;
+
+	irec = find_inode_rec(mp, XFS_INO_TO_AGNO(mp, inum),
+				XFS_INO_TO_AGINO(mp, inum));
+	if (!irec)
+		return false;
+	ino_offset = XFS_INO_TO_AGINO(mp, inum) - irec->ino_startnum;
+	return !is_inode_free(irec, ino_offset);
+}
+
 /* Load a realtime metadata inode from disk and reset it. */
 static int
 ensure_rtino(
@@ -489,12 +627,95 @@ ensure_rtino(
 	return 0;
 }
 
+/*
+ * Either link the old rtbitmap/summary inode into the (reinitialized) metadata
+ * directory tree, or create new ones.
+ */
+static void
+ensure_rtino_metadir(
+	struct xfs_mount		*mp,
+	const struct xfs_imeta_path	*path,
+	xfs_ino_t			*inop,
+	struct xfs_inode		**ipp,
+	struct xfs_imeta_update		*upd)
+{
+	struct xfs_trans		*tp;
+	xfs_ino_t			ino = *inop;
+	int				error;
+
+	/*
+	 * If the incore inode pointer is null or points to an inode that is
+	 * not allocated, we need to create a new file.
+	 */
+	if (ino == NULLFSINO || !is_inode_inuse(mp, ino)) {
+		error = -libxfs_imeta_start_create(mp, path, upd);
+		if (error)
+			do_error(
+ _("failed to allocate resources to recreate rt metadata inode, error %d\n"),
+					error);
+
+		/* Allocate a new inode. */
+		error = -libxfs_imeta_create(upd, S_IFREG, ipp);
+		if (error)
+			do_error(
+ _("couldn't create new rt metadata inode, error %d\n"), error);
+
+		ASSERT(*inop == upd->ip->i_ino);
+
+		mark_ino_inuse(mp, upd->ip->i_ino, S_IFREG,
+				lookup_imeta_path_dirname(mp, path));
+		return;
+	}
+
+	/*
+	 * We found the old rt metadata file and it looks ok.  Link it into
+	 * the metadata directory tree.  Null out the superblock pointer before
+	 * we re-link this file into it.
+	 */
+	*inop = NULLFSINO;
+
+	error = -libxfs_trans_alloc_empty(mp, &tp);
+	if (error)
+		do_error(
+ _("failed to allocate trans to iget rt metadata inode 0x%llx, error %d\n"),
+				(unsigned long long)ino, error);
+	error = -libxfs_imeta_iget(tp, ino, XFS_DIR3_FT_REG_FILE, ipp);
+	libxfs_trans_cancel(tp);
+	if (error)
+		do_error(
+ _("failed to iget rt metadata inode 0x%llx, error %d\n"),
+				(unsigned long long)ino, error);
+
+	/*
+	 * Since we're reattaching this file to the metadata directory tree,
+	 * try to remove all the parent pointers that might be attached.
+	 */
+	try_erase_parent_ptrs(*ipp);
+
+	error = -libxfs_imeta_start_link(mp, path, *ipp, upd);
+	if (error)
+		do_error(
+ _("failed to allocate resources to reinsert rt metadata inode 0x%llx, error %d\n"),
+				(unsigned long long)ino, error);
+
+	error = -libxfs_imeta_link(upd);
+	if (error)
+		do_error(
+ _("failed to link rt metadata inode 0x%llx, error %d\n"),
+				(unsigned long long)ino, error);
+
+	/* Reset the link count to something sane. */
+	set_nlink(VFS_I(upd->ip), 1);
+	libxfs_trans_log_inode(upd->tp, upd->ip, XFS_ILOG_CORE);
+}
+
 static void
 mk_rbmino(
 	struct xfs_mount	*mp)
 {
-	struct xfs_trans	*tp;
-	struct xfs_inode	*ip;
+	struct xfs_imeta_update	upd = { };
+	struct xfs_trans	*tp = NULL;
+	struct xfs_inode	*ip = NULL;
 	struct xfs_bmbt_irec	*ep;
 	int			i;
 	int			nmap;
@@ -503,23 +724,32 @@ mk_rbmino(
 	struct xfs_bmbt_irec	map[XFS_BMAP_MAX_NMAP];
 	uint			blocks;
 
-	/*
-	 * first set up inode
-	 */
-	i = -libxfs_trans_alloc_rollable(mp, 10, &tp);
-	if (i)
-		res_failed(i);
-
 	/* Reset the realtime bitmap inode. */
-	error = ensure_rtino(tp, mp->m_sb.sb_rbmino, &ip);
-	if (error) {
-		do_error(
-		_("couldn't iget realtime bitmap inode -- error - %d\n"),
-			error);
+	if (!xfs_has_metadir(mp)) {
+		i = -libxfs_trans_alloc_rollable(mp, 10, &upd.tp);
+		if (i)
+			res_failed(i);
+
+		error = ensure_rtino(upd.tp, mp->m_sb.sb_rbmino, &ip);
+		if (error) {
+			do_error(
+ _("couldn't iget realtime bitmap inode -- error - %d\n"),
+				error);
+		}
+	} else {
+		error = ensure_imeta_dirpath(mp, &XFS_IMETA_RTBITMAP);
+		if (error)
+			do_error(
+ _("Couldn't create realtime metadata directory, error %d\n"), error);
+
+		ensure_rtino_metadir(mp, &XFS_IMETA_RTBITMAP,
+				&mp->m_sb.sb_rbmino, &ip, &upd);
 	}
+
 	ip->i_disk_size = mp->m_sb.sb_rbmblocks * mp->m_sb.sb_blocksize;
-	libxfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
-	error = -libxfs_trans_commit(tp);
+	libxfs_trans_log_inode(upd.tp, ip, XFS_ILOG_CORE);
+
+	error = -libxfs_imeta_commit_update(&upd);
 	if (error)
 		do_error(_("%s: commit failed, error %d\n"), __func__, error);
 
@@ -720,8 +950,9 @@ static void
 mk_rsumino(
 	struct xfs_mount	*mp)
 {
-	struct xfs_trans	*tp;
-	struct xfs_inode	*ip;
+	struct xfs_imeta_update	upd = { };
+	struct xfs_trans	*tp = NULL;
+	struct xfs_inode	*ip = NULL;
 	struct xfs_bmbt_irec	*ep;
 	int			i;
 	int			nmap;
@@ -731,23 +962,32 @@ mk_rsumino(
 	struct xfs_bmbt_irec	map[XFS_BMAP_MAX_NMAP];
 	uint			blocks;
 
-	/*
-	 * first set up inode
-	 */
-	i = -libxfs_trans_alloc(mp, &M_RES(mp)->tr_ichange, 10, 0, 0, &tp);
-	if (i)
-		res_failed(i);
+	/* Reset the realtime summary inode. */
+	if (!xfs_has_metadir(mp)) {
+		i = -libxfs_trans_alloc_rollable(mp, 10, &upd.tp);
+		if (i)
+			res_failed(i);
 
-	/* Reset the rt summary inode. */
-	error = ensure_rtino(tp, mp->m_sb.sb_rsumino, &ip);
-	if (error) {
-		do_error(
-		_("couldn't iget realtime summary inode -- error - %d\n"),
-			error);
+		error = ensure_rtino(upd.tp, mp->m_sb.sb_rsumino, &ip);
+		if (error) {
+			do_error(
+ _("couldn't iget realtime summary inode -- error - %d\n"),
+				error);
+		}
+	} else {
+		error = ensure_imeta_dirpath(mp, &XFS_IMETA_RTSUMMARY);
+		if (error)
+			do_error(
+ _("Couldn't create realtime metadata directory, error %d\n"), error);
+
+		ensure_rtino_metadir(mp, &XFS_IMETA_RTSUMMARY,
+				&mp->m_sb.sb_rsumino, &ip, &upd);
 	}
+
 	ip->i_disk_size = mp->m_rsumsize;
-	libxfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
-	error = -libxfs_trans_commit(tp);
+	libxfs_trans_log_inode(upd.tp, ip, XFS_ILOG_CORE);
+
+	error = -libxfs_imeta_commit_update(&upd);
 	if (error)
 		do_error(_("%s: commit failed, error %d\n"), __func__, error);
 
@@ -845,6 +1085,36 @@ mk_root_dir(xfs_mount_t *mp)
 	libxfs_irele(ip);
 }
 
+/* Create a new metadata directory root. */
+static void
+mk_metadir(
+	struct xfs_mount	*mp)
+{
+	struct xfs_trans	*tp;
+	int			error;
+
+	error = init_fs_root_dir(mp, mp->m_sb.sb_metadirino, 0,
+			&mp->m_metadirip);
+	if (error)
+		do_error(
+	_("Initialization of the metadata root directory failed, error %d\n"),
+			error);
+
+	/* Mark the new metadata root dir as metadata. */
+	error = -libxfs_trans_alloc(mp, &M_RES(mp)->tr_ichange, 0, 0, 0, &tp);
+	if (error)
+		do_error(
+	_("Marking metadata root directory failed"));
+
+	libxfs_trans_ijoin(tp, mp->m_metadirip, 0);
+	libxfs_imeta_set_iflag(tp, mp->m_metadirip);
+
+	error = -libxfs_trans_commit(tp);
+	if (error)
+		do_error(
+	_("Marking metadata root directory failed, error %d\n"), error);
+}
+
 /*
  * orphanage name == lost+found
  */
@@ -1354,6 +1624,8 @@ longform_dir2_rebuild(
 
 	if (ino == mp->m_sb.sb_rootino)
 		need_root_dotdot = 0;
+	else if (ino == mp->m_sb.sb_metadirino)
+		need_metadir_dotdot = 0;
 
 	/* go through the hash list and re-add the inodes */
 
@@ -2973,7 +3245,7 @@ process_dir_inode(
 
 	need_dot = dirty = num_illegal = 0;
 
-	if (mp->m_sb.sb_rootino == ino)  {
+	if (mp->m_sb.sb_rootino == ino || mp->m_sb.sb_metadirino == ino) {
 		/*
 		 * mark root inode reached and bump up
 		 * link count for root inode to account
@@ -3048,6 +3320,9 @@ _("error %d fixing shortform directory %llu\n"),
 	dir_hash_done(hashtab);
 
 	fix_dotdot(mp, ino, ip, mp->m_sb.sb_rootino, "root", &need_root_dotdot);
+	if (xfs_has_metadir(mp))
+		fix_dotdot(mp, ino, ip, mp->m_sb.sb_metadirino, "metadata",
+				&need_metadir_dotdot);
 
 	/*
 	 * if we need to create the '.' entry, do so only if
@@ -3127,6 +3402,15 @@ mark_inode(
 static void
 mark_standalone_inodes(xfs_mount_t *mp)
 {
+	if (xfs_has_metadir(mp)) {
+		/*
+		 * The directory connectivity scanner will pick up the metadata
+		 * inode directory, which will mark the rest of the metadata
+		 * inodes.
+		 */
+		return;
+	}
+
 	mark_inode(mp, mp->m_sb.sb_rbmino);
 	mark_inode(mp, mp->m_sb.sb_rsumino);
 
@@ -3305,6 +3589,17 @@ phase6(xfs_mount_t *mp)
 		}
 	}
 
+	if (need_metadir_inode) {
+		if (!no_modify)  {
+			do_warn(_("reinitializing metadata root directory\n"));
+			mk_metadir(mp);
+			need_metadir_inode = false;
+			need_metadir_dotdot = 0;
+		} else  {
+			do_warn(_("would reinitialize metadata root directory\n"));
+		}
+	}
+
 	if (need_rbmino)  {
 		if (!no_modify)  {
 			do_warn(_("reinitializing realtime bitmap inode\n"));
diff --git a/repair/pptr.c b/repair/pptr.c
index 77f49dbcb84..f554919d525 100644
--- a/repair/pptr.c
+++ b/repair/pptr.c
@@ -1301,3 +1301,54 @@ check_parent_ptrs(
 
 	destroy_work_queue(&wq);
 }
+
+static int
+erase_pptrs(
+	struct xfs_inode	*ip,
+	unsigned int		attr_flags,
+	const unsigned char	*name,
+	unsigned int		namelen,
+	const void		*value,
+	unsigned int		valuelen,
+	void			*priv)
+{
+	struct xfs_da_args	args = {
+		.dp		= ip,
+		.attr_filter	= attr_flags,
+		.name		= name,
+		.namelen	= namelen,
+		.value		= (void *)value,
+		.valuelen	= valuelen,
+		.op_flags	= XFS_DA_OP_REMOVE | XFS_DA_OP_NVLOOKUP,
+	};
+	int			error;
+
+	if (!(attr_flags & XFS_ATTR_PARENT))
+		return 0;
+
+	error = -libxfs_attr_set(&args);
+	if (error)
+		do_warn(
+_("removing ino %llu parent pointer failed: %s\n"),
+				(unsigned long long)ip->i_ino,
+				strerror(error));
+
+	return 0;
+}
+
+/* Delete all of this file's parent pointers if we can. */
+void
+try_erase_parent_ptrs(
+	struct xfs_inode	*ip)
+{
+	int			error;
+
+	if (!xfs_has_parent(ip->i_mount))
+		return;
+
+	error = xattr_walk(ip, erase_pptrs, NULL);
+	if (error)
+		do_warn(_("ino %llu parent pointer erasure failed: %s\n"),
+				(unsigned long long)ip->i_ino,
+				strerror(error));
+}
diff --git a/repair/pptr.h b/repair/pptr.h
index f5ffcc137e3..9c9f244cd68 100644
--- a/repair/pptr.h
+++ b/repair/pptr.h
@@ -14,4 +14,6 @@ void add_parent_ptr(xfs_ino_t ino, const unsigned char *fname,
 
 void check_parent_ptrs(struct xfs_mount *mp);
 
+void try_erase_parent_ptrs(struct xfs_inode *ip);
+
 #endif /* __REPAIR_PPTR_H__ */
diff --git a/repair/sb.c b/repair/sb.c
index faf79d9d083..5f2a08136d7 100644
--- a/repair/sb.c
+++ b/repair/sb.c
@@ -28,6 +28,7 @@ copy_sb(xfs_sb_t *source, xfs_sb_t *dest)
 	xfs_ino_t	uquotino;
 	xfs_ino_t	gquotino;
 	xfs_ino_t	pquotino;
+	xfs_ino_t	metadirino;
 	uint16_t	versionnum;
 
 	rootino = dest->sb_rootino;
@@ -36,6 +37,7 @@ copy_sb(xfs_sb_t *source, xfs_sb_t *dest)
 	uquotino = dest->sb_uquotino;
 	gquotino = dest->sb_gquotino;
 	pquotino = dest->sb_pquotino;
+	metadirino = dest->sb_metadirino;
 
 	versionnum = dest->sb_versionnum;
 
@@ -47,6 +49,7 @@ copy_sb(xfs_sb_t *source, xfs_sb_t *dest)
 	dest->sb_uquotino = uquotino;
 	dest->sb_gquotino = gquotino;
 	dest->sb_pquotino = pquotino;
+	dest->sb_metadirino = metadirino;
 
 	dest->sb_versionnum = versionnum;
 
diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
index 32c28a980ff..d881d5ec4ac 100644
--- a/repair/xfs_repair.c
+++ b/repair/xfs_repair.c
@@ -639,6 +639,70 @@ guess_correct_sunit(
 		do_warn(_("Would reset sb_width to %u\n"), new_sunit);
 }
 
+/*
+ * Check that the metadata directory inode comes immediately after the root
+ * directory inode and that it seems to look like a metadata directory.
+ */
+STATIC void
+check_metadir_inode(
+	struct xfs_mount	*mp,
+	xfs_ino_t		rootino)
+{
+	int			error;
+
+	validate_sb_ino(&mp->m_sb.sb_metadirino, rootino + 1,
+			_("metadata root directory"));
+
+	/* If we changed the metadir inode, try reloading it. */
+	if (!mp->m_metadirip ||
+	    mp->m_metadirip->i_ino != mp->m_sb.sb_metadirino) {
+		struct xfs_trans	*tp;
+
+		if (mp->m_metadirip)
+			libxfs_irele(mp->m_metadirip);
+
+		error = -libxfs_trans_alloc_empty(mp, &tp);
+		if (error)
+			do_error(
+ _("could not allocate transaction to load metadir inode"));
+
+		error = -libxfs_imeta_iget(tp, mp->m_sb.sb_metadirino,
+				XFS_DIR3_FT_DIR, &mp->m_metadirip);
+		if (error) {
+			libxfs_trans_cancel(tp);
+			need_metadir_inode = true;
+			goto done;
+		}
+
+		error = -libxfs_imeta_mount(tp);
+		if (error)
+			need_metadir_inode = true;
+
+		libxfs_trans_cancel(tp);
+	}
+
+done:
+	if (need_metadir_inode) {
+		if (!no_modify)
+			do_warn(_("will reset metadata root directory\n"));
+		else
+			do_warn(_("would reset metadata root directory\n"));
+		if (mp->m_metadirip)
+			libxfs_irele(mp->m_metadirip);
+		mp->m_metadirip = NULL;
+	}
+
+	/*
+	 * Since these two realtime inodes are no longer fixed, we must
+	 * remember to regenerate them if we still haven't gotten a pointer to
+	 * a valid realtime inode.
+	 */
+	if (!libxfs_verify_ino(mp, mp->m_sb.sb_rbmino))
+		need_rbmino = 1;
+	if (!libxfs_verify_ino(mp, mp->m_sb.sb_rsumino))
+		need_rsumino = 1;
+}
+
 /*
  * Make sure that the first 3 inodes in the filesystem are the root directory,
  * the realtime bitmap, and the realtime summary, in that order.
@@ -668,10 +732,19 @@ _("sb root inode value %" PRIu64 " valid but in unaligned location (expected %"P
 
 	validate_sb_ino(&mp->m_sb.sb_rootino, rootino,
 			_("root"));
-	validate_sb_ino(&mp->m_sb.sb_rbmino, rootino + 1,
-			_("realtime bitmap"));
-	validate_sb_ino(&mp->m_sb.sb_rsumino, rootino + 2,
-			_("realtime summary"));
+
+	if (xfs_has_metadir(mp)) {
+		check_metadir_inode(mp, rootino);
+	} else {
+		/*
+		 * The realtime bitmap and summary inodes only comes after the
+		 * root directory when the metadir feature is not enabled.
+		 */
+		validate_sb_ino(&mp->m_sb.sb_rbmino, rootino + 1,
+				_("realtime bitmap"));
+		validate_sb_ino(&mp->m_sb.sb_rsumino, rootino + 2,
+				_("realtime summary"));
+	}
 }
 
 /*

