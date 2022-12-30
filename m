Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A17CC4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 02:18:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236199AbiLaCSo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 21:18:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236196AbiLaCSn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 21:18:43 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0848B13F7E
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 18:18:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 86E77B81DFC
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 02:18:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DCC4C433EF;
        Sat, 31 Dec 2022 02:18:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672453118;
        bh=7E3oMWKNt5NZWhY1Kci1pY8Vixtm0h7uJCHcESUWd4Y=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=okf/rLtEG6NUnueNclmdYU1oZJP5TvbyRiHXAIR9V4W5Qetr9VykjALhG8AWoiWRo
         XeFzdD8Iiqr9t4AifIBI6LkduU9mmkdDj2DAiowJ4gqJXWrzY/MkE+KD6SbXegdPdZ
         vfGfUDoo7ogqp26W48NW2R09xS/KgcpFrFnTmqwWdot2MtKZih5H+6syFOl4ho7oeK
         hUkZ1Vu1WSqcb/Lfeo9OrAQiOBkBEiidqnTLoiCzl9ENGoUTmSQfa3k4q9+RB8m+WR
         pRMTjsOXfqbhkFQdue0isMC4Ad/sPkK3a75ABG8kwh6nbOPfsQiy7zQ7JBvl+bxWe7
         lGcHfBAZ7ESTA==
Subject: [PATCH 34/46] xfs_repair: rebuild the metadata directory
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:19:23 -0800
Message-ID: <167243876377.725900.960867686956652917.stgit@magnolia>
In-Reply-To: <167243875924.725900.7061782826830118387.stgit@magnolia>
References: <167243875924.725900.7061782826830118387.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Check the metadata directory for problems and rebuild it if necessary.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/libxfs_api_defs.h |    1 
 repair/dino_chunks.c     |   12 ++
 repair/dir2.c            |   25 ++++
 repair/globals.c         |    3 
 repair/globals.h         |    3 
 repair/phase1.c          |    2 
 repair/phase2.c          |    7 +
 repair/phase4.c          |   16 +++
 repair/phase6.c          |  280 +++++++++++++++++++++++++++++++++++++++++++++-
 repair/sb.c              |    3 
 repair/xfs_repair.c      |   71 +++++++++++-
 11 files changed, 410 insertions(+), 13 deletions(-)


diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index 65fa90c8a2f..494172b213b 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -167,6 +167,7 @@
 #define xfs_imeta_link			libxfs_imeta_link
 #define xfs_imeta_lookup		libxfs_imeta_lookup
 #define xfs_imeta_mount			libxfs_imeta_mount
+#define xfs_imeta_set_metaflag		libxfs_imeta_set_metaflag
 #define xfs_imeta_start_update		libxfs_imeta_start_update
 #define xfs_imeta_unlink		libxfs_imeta_unlink
 #define xfs_imeta_unlink_space_res	libxfs_imeta_unlink_space_res
diff --git a/repair/dino_chunks.c b/repair/dino_chunks.c
index 5c7799b1888..3de0c24b1d8 100644
--- a/repair/dino_chunks.c
+++ b/repair/dino_chunks.c
@@ -934,6 +934,18 @@ process_inode_chunk(
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
index 24d0dd84aaf..e1fb195df34 100644
--- a/repair/dir2.c
+++ b/repair/dir2.c
@@ -145,6 +145,10 @@ is_meta_ino(
 {
 	char			*reason = NULL;
 
+	/* in metadir land we don't have static metadata inodes anymore */
+	if (xfs_has_metadir(mp))
+		return false;
+
 	if (lino == mp->m_sb.sb_rbmino)
 		reason = _("realtime bitmap");
 	else if (lino == mp->m_sb.sb_rsumino)
@@ -156,6 +160,16 @@ is_meta_ino(
 	else if (lino == mp->m_sb.sb_pquotino)
 		reason = _("project quota");
 
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
@@ -547,7 +561,8 @@ _("corrected root directory %" PRIu64 " .. entry, was %" PRIu64 ", now %" PRIu64
 _("would have corrected root directory %" PRIu64 " .. entry from %" PRIu64" to %" PRIu64 "\n"),
 				ino, *parent, ino);
 		}
-	} else if (ino == *parent && ino != mp->m_sb.sb_rootino)  {
+	} else if (ino == *parent && ino != mp->m_sb.sb_rootino &&
+		   ino != mp->m_sb.sb_metadirino)  {
 		/*
 		 * likewise, non-root directories can't have .. pointing
 		 * to .
@@ -833,7 +848,8 @@ _("entry at block %u offset %" PRIdPTR " in directory inode %" PRIu64 " has ille
 				 * NULLFSINO otherwise.
 				 */
 				if (ino == ent_ino &&
-						ino != mp->m_sb.sb_rootino) {
+				    ino != mp->m_sb.sb_rootino &&
+				    ino != mp->m_sb.sb_metadirino) {
 					*parent = NULLFSINO;
 					do_warn(
 _("bad .. entry in directory inode %" PRIu64 ", points to self: "),
@@ -1474,9 +1490,14 @@ process_dir2(
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
index ec11bc67139..c731d6bdff1 100644
--- a/repair/globals.c
+++ b/repair/globals.c
@@ -68,6 +68,9 @@ int	fs_is_dirty;
 int	need_root_inode;
 int	need_root_dotdot;
 
+bool	need_metadir_inode;
+int	need_metadir_dotdot;
+
 int	need_rbmino;
 int	need_rsumino;
 
diff --git a/repair/globals.h b/repair/globals.h
index d5a04a75d41..6bd4be20cb1 100644
--- a/repair/globals.h
+++ b/repair/globals.h
@@ -109,6 +109,9 @@ extern int		fs_is_dirty;
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
index 05964b3d23c..77324a976a1 100644
--- a/repair/phase2.c
+++ b/repair/phase2.c
@@ -628,8 +628,11 @@ phase2(
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
index b5e713aaa82..fdc5d777be4 100644
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
index aaaebc79098..4bdea2a2a38 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -469,6 +469,130 @@ reset_root_ino(
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
+	/* Mark all directories in this path as inuse. */
+	parent = mp->m_metadirip->i_ino;
+	for (i = 0; i < path->im_depth - 1; i++, temp_path.im_depth++) {
+		xfs_ino_t		ino;
+
+		error = -libxfs_imeta_lookup(mp, &temp_path, &ino);
+		if (error)
+			return error;
+		if (ino == NULLFSINO)
+			return ENOENT;
+		mark_ino_inuse(mp, ino, S_IFDIR, parent);
+		parent = ino;
+	}
+
+	return 0;
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
+	xfs_ino_t			ino;
+	int				error;
+
+	if (!xfs_has_metadir(mp))
+		return NULLFSINO;
+
+	error = -libxfs_imeta_lookup(mp, &temp_path, &ino);
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
@@ -487,10 +611,66 @@ ensure_rtino(
 	return 0;
 }
 
+/*
+ * Either link the old rtbitmap/summary inode into the (reinitialized) metadata
+ * directory tree, or create new ones.
+ */
+static int
+ensure_rtino_metadir(
+	struct xfs_trans		**tpp,
+	const struct xfs_imeta_path	*path,
+	xfs_ino_t			ino,
+	struct xfs_inode		**ipp,
+	struct xfs_imeta_update		*upd)
+{
+	struct xfs_mount		*mp = (*tpp)->t_mountp;
+	int				error;
+
+	/*
+	 * We've already voided the old metadata directory, which means that we
+	 * cannot call libxfs_imeta_lookup.  Hence we're reliant on the caller
+	 * to have saved the rbmino/rsumino values and to have marked the inode
+	 * inuse if it proved to be ok.
+	 */
+	if (ino != NULLFSINO && is_inode_inuse(mp, ino)) {
+		/*
+		 * This rt metadata inode was fine, so we'll just link it
+		 * into the new metadata directory tree.
+		 */
+		error = -libxfs_imeta_iget(mp, ino, XFS_DIR3_FT_REG_FILE,
+				ipp);
+		if (error)
+			do_error(
+	_("failed to iget rt metadata inode 0x%llx, error %d\n"),
+					(unsigned long long)ino, error);
+
+		error = -libxfs_imeta_link(*tpp, path, *ipp, upd);
+		if (error)
+			do_error(
+	_("failed to link rt metadata inode 0x%llx, error %d\n"),
+					(unsigned long long)ino, error);
+
+		set_nlink(VFS_I(*ipp), 1);
+		libxfs_trans_log_inode(*tpp, *ipp, XFS_ILOG_CORE);
+		return 0;
+	}
+
+	/* Allocate a new inode. */
+	error = -libxfs_imeta_create(tpp, path, S_IFREG, 0, ipp, upd);
+	if (error)
+		do_error(
+_("couldn't create new metadata inode, error %d\n"), error);
+
+	mark_ino_inuse(mp, (*ipp)->i_ino, S_IFREG,
+			lookup_imeta_path_dirname(mp, path));
+	return 0;
+}
+
 static void
 mk_rbmino(
 	struct xfs_mount	*mp)
 {
+	struct xfs_imeta_update	upd;
 	struct xfs_trans	*tp;
 	struct xfs_inode	*ip;
 	struct xfs_bmbt_irec	*ep;
@@ -501,15 +681,31 @@ mk_rbmino(
 	struct xfs_bmbt_irec	map[XFS_BMAP_MAX_NMAP];
 	uint			blocks;
 
+	error = ensure_imeta_dirpath(mp, &XFS_IMETA_RTBITMAP);
+	if (error)
+		do_error(
+	_("Couldn't create realtime metadata directory, error %d\n"), error);
+
+	error = -libxfs_imeta_start_update(mp, &XFS_IMETA_RTBITMAP, &upd);
+	if (error)
+		do_error(
+_("Couldn't find realtime bitmap parent, error %d\n"),
+				error);
+
 	/*
 	 * first set up inode
 	 */
-	i = -libxfs_trans_alloc_rollable(mp, 10, &tp);
+	i = -libxfs_trans_alloc(mp, &M_RES(mp)->tr_imeta_create,
+			libxfs_imeta_create_space_res(mp), 0, 0, &tp);
 	if (i)
 		res_failed(i);
 
 	/* Reset the realtime bitmap inode. */
-	error = ensure_rtino(&tp, mp->m_sb.sb_rbmino, &ip);
+	if (xfs_has_metadir(mp))
+		error = ensure_rtino_metadir(&tp, &XFS_IMETA_RTBITMAP,
+				mp->m_sb.sb_rbmino, &ip, &upd);
+	else
+		error = ensure_rtino(&tp, mp->m_sb.sb_rbmino, &ip);
 	if (error) {
 		do_error(
 		_("couldn't iget realtime bitmap inode -- error - %d\n"),
@@ -520,6 +716,7 @@ mk_rbmino(
 	error = -libxfs_trans_commit(tp);
 	if (error)
 		do_error(_("%s: commit failed, error %d\n"), __func__, error);
+	libxfs_imeta_end_update(mp, &upd, error);
 
 	/*
 	 * then allocate blocks for file and fill with zeroes (stolen
@@ -702,6 +899,7 @@ static void
 mk_rsumino(
 	struct xfs_mount	*mp)
 {
+	struct xfs_imeta_update	upd;
 	struct xfs_trans	*tp;
 	struct xfs_inode	*ip;
 	struct xfs_bmbt_irec	*ep;
@@ -713,15 +911,31 @@ mk_rsumino(
 	struct xfs_bmbt_irec	map[XFS_BMAP_MAX_NMAP];
 	uint			blocks;
 
+	error = ensure_imeta_dirpath(mp, &XFS_IMETA_RTSUMMARY);
+	if (error)
+		do_error(
+	_("Couldn't create realtime metadata directory, error %d\n"), error);
+
+	error = -libxfs_imeta_start_update(mp, &XFS_IMETA_RTSUMMARY, &upd);
+	if (error)
+		do_error(
+_("Couldn't find realtime summary parent, error %d\n"),
+				error);
+
 	/*
 	 * first set up inode
 	 */
-	i = -libxfs_trans_alloc(mp, &M_RES(mp)->tr_ichange, 10, 0, 0, &tp);
+	i = -libxfs_trans_alloc(mp, &M_RES(mp)->tr_imeta_create,
+			libxfs_imeta_create_space_res(mp), 0, 0, &tp);
 	if (i)
 		res_failed(i);
 
 	/* Reset the rt summary inode. */
-	error = ensure_rtino(&tp, mp->m_sb.sb_rsumino, &ip);
+	if (xfs_has_metadir(mp))
+		error = ensure_rtino_metadir(&tp, &XFS_IMETA_RTSUMMARY,
+				mp->m_sb.sb_rsumino, &ip, &upd);
+	else
+		error = ensure_rtino(&tp, mp->m_sb.sb_rsumino, &ip);
 	if (error) {
 		do_error(
 		_("couldn't iget realtime summary inode -- error - %d\n"),
@@ -732,6 +946,7 @@ mk_rsumino(
 	error = -libxfs_trans_commit(tp);
 	if (error)
 		do_error(_("%s: commit failed, error %d\n"), __func__, error);
+	libxfs_imeta_end_update(mp, &upd, error);
 
 	/*
 	 * then allocate blocks for file and fill with zeroes (stolen
@@ -827,6 +1042,36 @@ mk_root_dir(xfs_mount_t *mp)
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
+	libxfs_imeta_set_metaflag(tp, mp->m_metadirip);
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
@@ -1265,6 +1510,8 @@ longform_dir2_rebuild(
 
 	if (ino == mp->m_sb.sb_rootino)
 		need_root_dotdot = 0;
+	else if (ino == mp->m_sb.sb_metadirino)
+		need_metadir_dotdot = 0;
 
 	/* go through the hash list and re-add the inodes */
 
@@ -2855,7 +3102,7 @@ process_dir_inode(
 
 	need_dot = dirty = num_illegal = 0;
 
-	if (mp->m_sb.sb_rootino == ino)  {
+	if (mp->m_sb.sb_rootino == ino || mp->m_sb.sb_metadirino == ino) {
 		/*
 		 * mark root inode reached and bump up
 		 * link count for root inode to account
@@ -2929,6 +3176,9 @@ _("error %d fixing shortform directory %llu\n"),
 	dir_hash_done(hashtab);
 
 	fix_dotdot(mp, ino, ip, mp->m_sb.sb_rootino, "root", &need_root_dotdot);
+	if (xfs_has_metadir(mp))
+		fix_dotdot(mp, ino, ip, mp->m_sb.sb_metadirino, "metadata",
+				&need_metadir_dotdot);
 
 	/*
 	 * if we need to create the '.' entry, do so only if
@@ -3008,6 +3258,15 @@ mark_inode(
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
 
@@ -3184,6 +3443,17 @@ phase6(xfs_mount_t *mp)
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
diff --git a/repair/sb.c b/repair/sb.c
index 7391cf043fd..c5dbc6c2062 100644
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
index c461bc8eb07..53d45c5b189 100644
--- a/repair/xfs_repair.c
+++ b/repair/xfs_repair.c
@@ -628,6 +628,60 @@ guess_correct_sunit(
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
+		if (mp->m_metadirip)
+			libxfs_irele(mp->m_metadirip);
+
+		error = -libxfs_imeta_iget(mp, mp->m_sb.sb_metadirino,
+				XFS_DIR3_FT_DIR, &mp->m_metadirip);
+		if (error) {
+			need_metadir_inode = true;
+			goto done;
+		}
+
+		error = -libxfs_imeta_mount(mp);
+		if (error)
+			need_metadir_inode = true;
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
@@ -657,10 +711,19 @@ _("sb root inode value %" PRIu64 " valid but in unaligned location (expected %"P
 
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

