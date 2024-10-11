Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FDB7C2ED
	for <linux-xfs@vger.kernel.org>; Fri, 11 Oct 2024 01:20:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728609641; cv=none; b=RzjrmDwvmrPfiHk1Ox9wY4cOk48MJyeULTXhwKMfrDRoAafPJ/S7gNLWmFcgrRlmBjjaeGMpXUAK5+CjBuXwENPkMGflgNbeQL/CIBk5WIhs5Iwca+iAnsGYCkWrTd+GUmxrhRF+nZ2hysoQvUkFdMFT8CFCeLvv6krMJLPsSW8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728609641; c=relaxed/simple;
	bh=vskb6g5dDGFT0fx0OVyVx6YeJ+7HT7CnNQRbo77+cWA=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NFXwOSm3plSXcQXVO6V0/zsPprAT8bbsce0vRZetERHsy4HFR+9sXmRcUX52Yy0qcOXTI9qk4FnJ+AsLJrMfbSm5dkUZvKUULjT36hJixFkRQsnB47cNQ0NWxuDweLFV4d/YX9Hfblsymblu7/IhrtBRzMxJnk+7V8e3rSa2Zko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rxglSpIx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rxglSpIx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF1D6C4CEC5;
	Fri, 11 Oct 2024 01:20:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728609640;
	bh=vskb6g5dDGFT0fx0OVyVx6YeJ+7HT7CnNQRbo77+cWA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=rxglSpIxJY20KwC7X0BJOlTEyMJpPDKVCT5XPlG96UJq+31rKU4vqHUkiThy2a1sU
	 zotJbWDifCJwLFZUNykDI+ACcammGAzvW091Dy01ddAMs9Qn6znIo1V6wpI6J0JPGO
	 vAG+uXdfQxZD4xKoE9Od9LZ0sRn3koG9qqLy0VlZqGz+b0lbnSsFivJNkDebKrXI9R
	 rrgVZQwv0Qhc7SvPodfOEC9TcsRlc6+g5lWBN6liJ8Z1oCdsax4QDsfo8JGH3r2yEy
	 Ybxqwq1ZU+GRhjC+bh7qBY4MechPd7hOcAtzpVTnKXPzTJWwbaOZLDf7Nd3Hb3TEqS
	 1IToHJfzkKRUg==
Date: Thu, 10 Oct 2024 18:20:40 -0700
Subject: [PATCH 25/38] xfs_repair: rebuild the metadata directory
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <172860654360.4183231.2663647259493420623.stgit@frogsfrogsfrogs>
In-Reply-To: <172860653916.4183231.1358667198522212154.stgit@frogsfrogsfrogs>
References: <172860653916.4183231.1358667198522212154.stgit@frogsfrogsfrogs>
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

Check the dirents in metadata directories for problems and repair them
if necessary.  Also make sure that the sb-rooted inodes (root, metadir
root, rt bitmap, rt summary) are always allocated in that order.

Note that xfs_repair will always rebuild the metadata directory tree
itself, so we only need to report problems, not fix them.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/libxfs_api_defs.h |    1 
 repair/dino_chunks.c     |   12 ++++++
 repair/dir2.c            |   16 +++++++-
 repair/globals.c         |    3 +
 repair/globals.h         |    3 +
 repair/incore.h          |   13 ++++++
 repair/phase1.c          |    2 +
 repair/phase2.c          |   53 +++++++++++++++++++-------
 repair/phase4.c          |   16 ++++++++
 repair/phase6.c          |   73 ++++++++++++++++++++++++++++++++++--
 repair/pptr.c            |   94 ++++++++++++++++++++++++++++++++++++++++++++++
 repair/pptr.h            |    2 +
 repair/sb.c              |    3 +
 repair/xfs_repair.c      |   50 ++++++++++++++++++++++++
 14 files changed, 320 insertions(+), 21 deletions(-)


diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index 978796a5c6a281..beabb47fcd9c40 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -215,6 +215,7 @@
 
 #define xfs_metafile_iget		libxfs_metafile_iget
 #define xfs_trans_metafile_iget		libxfs_trans_metafile_iget
+#define xfs_metafile_set_iflag		libxfs_metafile_set_iflag
 #define xfs_metadir_link		libxfs_metadir_link
 #define xfs_metadir_lookup		libxfs_metadir_lookup
 #define xfs_metadir_start_create	libxfs_metadir_start_create
diff --git a/repair/dino_chunks.c b/repair/dino_chunks.c
index 1953613345190d..479dc9db76094a 100644
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
index dab6523f676a34..d233c724488182 100644
--- a/repair/dir2.c
+++ b/repair/dir2.c
@@ -271,6 +271,9 @@ process_sf_dir2(
 		} else if (lino == mp->m_sb.sb_pquotino)  {
 			junkit = 1;
 			junkreason = _("project quota");
+		} else if (lino == mp->m_sb.sb_metadirino)  {
+			junkit = 1;
+			junkreason = _("metadata directory root");
 		} else if ((irec_p = find_inode_rec(mp,
 					XFS_INO_TO_AGNO(mp, lino),
 					XFS_INO_TO_AGINO(mp, lino))) != NULL) {
@@ -564,7 +567,8 @@ _("corrected root directory %" PRIu64 " .. entry, was %" PRIu64 ", now %" PRIu64
 _("would have corrected root directory %" PRIu64 " .. entry from %" PRIu64" to %" PRIu64 "\n"),
 				ino, *parent, ino);
 		}
-	} else if (ino == *parent && ino != mp->m_sb.sb_rootino)  {
+	} else if (ino == *parent && ino != mp->m_sb.sb_rootino &&
+		   ino != mp->m_sb.sb_metadirino)  {
 		/*
 		 * likewise, non-root directories can't have .. pointing
 		 * to .
@@ -743,6 +747,8 @@ process_dir2_data(
 			clearreason = _("group quota");
 		} else if (ent_ino == mp->m_sb.sb_pquotino) {
 			clearreason = _("project quota");
+		} else if (ent_ino == mp->m_sb.sb_metadirino)  {
+			clearreason = _("metadata directory root");
 		} else {
 			irec_p = find_inode_rec(mp,
 						XFS_INO_TO_AGNO(mp, ent_ino),
@@ -864,7 +870,8 @@ _("entry at block %u offset %" PRIdPTR " in directory inode %" PRIu64 " has ille
 				 * NULLFSINO otherwise.
 				 */
 				if (ino == ent_ino &&
-						ino != mp->m_sb.sb_rootino) {
+				    ino != mp->m_sb.sb_rootino &&
+				    ino != mp->m_sb.sb_metadirino) {
 					*parent = NULLFSINO;
 					do_warn(
 _("bad .. entry in directory inode %" PRIu64 ", points to self: "),
@@ -1519,9 +1526,14 @@ process_dir2(
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
index c0c45df51d562a..07f7526a73a0b1 100644
--- a/repair/globals.c
+++ b/repair/globals.c
@@ -66,6 +66,9 @@ int	fs_is_dirty;
 int	need_root_inode;
 int	need_root_dotdot;
 
+bool	need_metadir_inode;
+int	need_metadir_dotdot;
+
 int	need_rbmino;
 int	need_rsumino;
 
diff --git a/repair/globals.h b/repair/globals.h
index 1eadfdbf9ae4f2..7db710a266b3c7 100644
--- a/repair/globals.h
+++ b/repair/globals.h
@@ -107,6 +107,9 @@ extern int		fs_is_dirty;
 extern int		need_root_inode;
 extern int		need_root_dotdot;
 
+extern bool		need_metadir_inode;
+extern int		need_metadir_dotdot;
+
 extern int		need_rbmino;
 extern int		need_rsumino;
 
diff --git a/repair/incore.h b/repair/incore.h
index 9ad5f1972d3dee..4f32ad3377faed 100644
--- a/repair/incore.h
+++ b/repair/incore.h
@@ -661,4 +661,17 @@ inorec_set_freecount(
 		rp->ir_u.f.ir_freecount = cpu_to_be32(freecount);
 }
 
+/*
+ * Number of inodes assumed to be always allocated because they are created
+ * by mkfs.
+ */
+static inline unsigned int
+xfs_rootrec_inodes_inuse(
+	struct xfs_mount	*mp)
+{
+	if (xfs_has_metadir(mp))
+		return 4; /* sb_rootino, sb_rbmino, sb_rsumino, sb_metadirino */
+	return 3; /* sb_rootino, sb_rbmino, sb_rsumino */
+}
+
 #endif /* XFS_REPAIR_INCORE_H */
diff --git a/repair/phase1.c b/repair/phase1.c
index 8e3d0a748bdfc9..bac382b5eba670 100644
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
index 17966bb54db09d..17c16e94a600c2 100644
--- a/repair/phase2.c
+++ b/repair/phase2.c
@@ -496,8 +496,8 @@ phase2(
 	struct xfs_mount	*mp,
 	int			scan_threads)
 {
-	int			j;
 	ino_tree_node_t		*ino_rec;
+	unsigned int		inuse = xfs_rootrec_inodes_inuse(mp), j;
 
 	/* now we can start using the buffer cache routines */
 	set_mp(mp);
@@ -541,58 +541,81 @@ phase2(
 	 * make sure we know about the root inode chunk
 	 */
 	if ((ino_rec = find_inode_rec(mp, 0, mp->m_sb.sb_rootino)) == NULL)  {
-		ASSERT(mp->m_sb.sb_rbmino == mp->m_sb.sb_rootino + 1 &&
-			mp->m_sb.sb_rsumino == mp->m_sb.sb_rootino + 2);
+		struct xfs_sb	*sb = &mp->m_sb;
+
+		if (xfs_has_metadir(mp))
+			ASSERT(sb->sb_metadirino == sb->sb_rootino + 1 &&
+			       sb->sb_rbmino  == sb->sb_rootino + 2 &&
+			       sb->sb_rsumino == sb->sb_rootino + 3);
+		else
+			ASSERT(sb->sb_rbmino  == sb->sb_rootino + 1 &&
+			       sb->sb_rsumino == sb->sb_rootino + 2);
 		do_warn(_("root inode chunk not found\n"));
 
 		/*
-		 * mark the first 3 used, the rest are free
+		 * mark the first 3-4 inodes used, the rest are free
 		 */
 		ino_rec = set_inode_used_alloc(mp, 0,
-				(xfs_agino_t) mp->m_sb.sb_rootino);
-		set_inode_used(ino_rec, 1);
-		set_inode_used(ino_rec, 2);
+				XFS_INO_TO_AGINO(mp, sb->sb_rootino));
+		for (j = 1; j < inuse; j++)
+			set_inode_used(ino_rec, j);
 
-		for (j = 3; j < XFS_INODES_PER_CHUNK; j++)
+		for (j = inuse; j < XFS_INODES_PER_CHUNK; j++)
 			set_inode_free(ino_rec, j);
 
 		/*
 		 * also mark blocks
 		 */
-		set_bmap_ext(0, XFS_INO_TO_AGBNO(mp, mp->m_sb.sb_rootino),
+		set_bmap_ext(0, XFS_INO_TO_AGBNO(mp, sb->sb_rootino),
 			     M_IGEO(mp)->ialloc_blks, XR_E_INO);
 	} else  {
 		do_log(_("        - found root inode chunk\n"));
+		j = 0;
 
 		/*
 		 * blocks are marked, just make sure they're in use
 		 */
-		if (is_inode_free(ino_rec, 0))  {
+		if (is_inode_free(ino_rec, j)) {
 			do_warn(_("root inode marked free, "));
-			set_inode_used(ino_rec, 0);
+			set_inode_used(ino_rec, j);
 			if (!no_modify)
 				do_warn(_("correcting\n"));
 			else
 				do_warn(_("would correct\n"));
 		}
+		j++;
 
-		if (is_inode_free(ino_rec, 1))  {
+		if (xfs_has_metadir(mp)) {
+			if (is_inode_free(ino_rec, j))  {
+				do_warn(_("metadata root inode marked free, "));
+				set_inode_used(ino_rec, j);
+				if (!no_modify)
+					do_warn(_("correcting\n"));
+				else
+					do_warn(_("would correct\n"));
+			}
+			j++;
+		}
+
+		if (is_inode_free(ino_rec, j))  {
 			do_warn(_("realtime bitmap inode marked free, "));
-			set_inode_used(ino_rec, 1);
+			set_inode_used(ino_rec, j);
 			if (!no_modify)
 				do_warn(_("correcting\n"));
 			else
 				do_warn(_("would correct\n"));
 		}
+		j++;
 
-		if (is_inode_free(ino_rec, 2))  {
+		if (is_inode_free(ino_rec, j))  {
 			do_warn(_("realtime summary inode marked free, "));
-			set_inode_used(ino_rec, 2);
+			set_inode_used(ino_rec, j);
 			if (!no_modify)
 				do_warn(_("correcting\n"));
 			else
 				do_warn(_("would correct\n"));
 		}
+		j++;
 	}
 
 	/*
diff --git a/repair/phase4.c b/repair/phase4.c
index 071f20ed736e4b..7efef86245fbe7 100644
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
index 84d2676e34fa53..95c44352883d7c 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -478,12 +478,25 @@ reset_sbroot_ino(
 static int
 ensure_rtino(
 	struct xfs_trans		*tp,
-	xfs_ino_t			ino,
+	enum xfs_metafile_type		metafile_type,
 	struct xfs_inode		**ipp)
 {
 	struct xfs_mount		*mp = tp->t_mountp;
+	xfs_ino_t			ino;
 	int				error;
 
+	switch (metafile_type) {
+	case XFS_METAFILE_RTBITMAP:
+		ino = mp->m_sb.sb_rbmino;
+		break;
+	case XFS_METAFILE_RTSUMMARY:
+		ino = mp->m_sb.sb_rsumino;
+		break;
+	default:
+		ASSERT(0);
+		return -EFSCORRUPTED;
+	}
+
 	/*
 	 * Don't use metafile iget here because we're resetting sb-rooted
 	 * inodes that live at fixed inumbers, but these inodes could be in
@@ -494,6 +507,8 @@ ensure_rtino(
 		return error;
 
 	reset_sbroot_ino(tp, S_IFREG, *ipp);
+	if (xfs_has_metadir(mp))
+		libxfs_metafile_set_iflag(tp, *ipp, metafile_type);
 	return 0;
 }
 
@@ -510,7 +525,7 @@ mk_rbmino(
 		res_failed(error);
 
 	/* Reset the realtime bitmap inode. */
-	error = ensure_rtino(tp, mp->m_sb.sb_rbmino, &ip);
+	error = ensure_rtino(tp, XFS_METAFILE_RTBITMAP, &ip);
 	if (error) {
 		do_error(
 		_("couldn't iget realtime bitmap inode -- error - %d\n"),
@@ -584,7 +599,7 @@ mk_rsumino(
 		res_failed(error);
 
 	/* Reset the rt summary inode. */
-	error = ensure_rtino(tp, mp->m_sb.sb_rsumino, &ip);
+	error = ensure_rtino(tp, XFS_METAFILE_RTSUMMARY, &ip);
 	if (error) {
 		do_error(
 		_("couldn't iget realtime summary inode -- error - %d\n"),
@@ -655,6 +670,36 @@ mk_root_dir(xfs_mount_t *mp)
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
+	libxfs_metafile_set_iflag(tp, mp->m_metadirip, XFS_METAFILE_DIR);
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
@@ -1168,6 +1213,8 @@ longform_dir2_rebuild(
 
 	if (ino == mp->m_sb.sb_rootino)
 		need_root_dotdot = 0;
+	else if (ino == mp->m_sb.sb_metadirino)
+		need_metadir_dotdot = 0;
 
 	/* go through the hash list and re-add the inodes */
 
@@ -2789,7 +2836,7 @@ process_dir_inode(
 
 	need_dot = dirty = num_illegal = 0;
 
-	if (mp->m_sb.sb_rootino == ino)  {
+	if (mp->m_sb.sb_rootino == ino || mp->m_sb.sb_metadirino == ino) {
 		/*
 		 * mark root inode reached and bump up
 		 * link count for root inode to account
@@ -2864,6 +2911,9 @@ _("error %d fixing shortform directory %llu\n"),
 	dir_hash_done(hashtab);
 
 	fix_dotdot(mp, ino, ip, mp->m_sb.sb_rootino, "root", &need_root_dotdot);
+	if (xfs_has_metadir(mp))
+		fix_dotdot(mp, ino, ip, mp->m_sb.sb_metadirino, "metadata",
+				&need_metadir_dotdot);
 
 	/*
 	 * if we need to create the '.' entry, do so only if
@@ -3121,6 +3171,21 @@ phase6(xfs_mount_t *mp)
 		}
 	}
 
+	if (!no_modify && xfs_has_metadir(mp)) {
+		/*
+		 * In write mode, we always rebuild the metadata directory
+		 * tree, even if the old one was correct.  However, we still
+		 * want to log something if we couldn't find the old root.
+		 */
+		if (need_metadir_inode)
+			do_warn(_("reinitializing metadata root directory\n"));
+		mk_metadir(mp);
+		need_metadir_inode = false;
+		need_metadir_dotdot = 0;
+	} else if (need_metadir_inode) {
+		do_warn(_("would reinitialize metadata root directory\n"));
+	}
+
 	if (need_rbmino)  {
 		if (!no_modify)  {
 			do_warn(_("reinitializing realtime bitmap inode\n"));
diff --git a/repair/pptr.c b/repair/pptr.c
index ee29e47a87bd07..ac0a9c618bc87d 100644
--- a/repair/pptr.c
+++ b/repair/pptr.c
@@ -1334,3 +1334,97 @@ check_parent_ptrs(
 
 	destroy_work_queue(&wq);
 }
+
+static int
+erase_pptrs(
+	struct xfs_trans	*tp,
+	struct xfs_inode	*ip,
+	unsigned int		attr_flags,
+	const unsigned char	*name,
+	unsigned int		namelen,
+	const void		*value,
+	unsigned int		valuelen,
+	void			*priv)
+{
+	struct garbage_xattr	garbage_xattr = {
+		.attr_filter	= attr_flags,
+		.attrnamelen	= namelen,
+		.attrvaluelen	= valuelen,
+	};
+	struct file_scan	*fscan = priv;
+	int			error;
+
+	if (!(attr_flags & XFS_ATTR_PARENT))
+		return 0;
+
+	error = -xfblob_store(fscan->garbage_xattr_names,
+			&garbage_xattr.attrname_cookie, name, namelen);
+	if (error)
+		do_error(_("storing ino %llu garbage pptr failed: %s\n"),
+				(unsigned long long)ip->i_ino,
+				strerror(error));
+
+	error = -xfblob_store(fscan->garbage_xattr_names,
+			&garbage_xattr.attrvalue_cookie, value, valuelen);
+	if (error)
+		do_error(_("storing ino %llu garbage pptr failed: %s\n"),
+				(unsigned long long)ip->i_ino,
+				strerror(error));
+
+	error = -slab_add(fscan->garbage_xattr_recs, &garbage_xattr);
+	if (error)
+		do_error(_("storing ino %llu garbage pptr rec failed: %s\n"),
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
+	struct file_scan	fscan = {
+		.have_garbage	= true,
+	};
+	struct xfs_mount	*mp = ip->i_mount;
+	struct xfs_trans	*tp = NULL;
+	char			*descr;
+	int			error;
+
+	if (!xfs_has_parent(ip->i_mount))
+		return;
+
+	if (no_modify) {
+		do_warn(
+ _("would delete garbage parent pointers in metadata ino %llu\n"),
+				(unsigned long long)ip->i_ino);
+		return;
+	}
+
+	error = -init_slab(&fscan.garbage_xattr_recs,
+			sizeof(struct garbage_xattr));
+	if (error)
+		do_error(_("init garbage pptr recs failed: %s\n"),
+				strerror(error));
+
+	descr = kasprintf(GFP_KERNEL, "xfs_repair (%s): garbage pptr names",
+			mp->m_fsname);
+	error = -xfblob_create(descr, &fscan.garbage_xattr_names);
+	kfree(descr);
+	if (error)
+		do_error("init garbage pptr names failed: %s\n",
+				strerror(error));
+
+	libxfs_trans_alloc_empty(ip->i_mount, &tp);
+	error = xattr_walk(tp, ip, erase_pptrs, &fscan);
+	if (tp)
+		libxfs_trans_cancel(tp);
+	if (error)
+		do_warn(_("ino %llu garbage pptr collection failed: %s\n"),
+				(unsigned long long)ip->i_ino,
+				strerror(error));
+
+	remove_garbage_xattrs(ip, &fscan);
+}
diff --git a/repair/pptr.h b/repair/pptr.h
index 65acff963a3fe9..38d5c4052ea86c 100644
--- a/repair/pptr.h
+++ b/repair/pptr.h
@@ -14,4 +14,6 @@ void add_parent_ptr(xfs_ino_t ino, const unsigned char *fname,
 
 void check_parent_ptrs(struct xfs_mount *mp);
 
+void try_erase_parent_ptrs(struct xfs_inode *ip);
+
 #endif /* __REPAIR_PPTR_H__ */
diff --git a/repair/sb.c b/repair/sb.c
index 80b09225cd97d2..afed4ba9d1cab6 100644
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
index 3ade85bbcbb7fd..70cab1ad852a21 100644
--- a/repair/xfs_repair.c
+++ b/repair/xfs_repair.c
@@ -644,6 +644,46 @@ guess_correct_sunit(
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
+		error = -libxfs_metafile_iget(mp, mp->m_sb.sb_metadirino,
+				XFS_METAFILE_DIR, &mp->m_metadirip);
+		if (error) {
+			need_metadir_inode = true;
+			goto done;
+		}
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
+}
+
 /*
  * Make sure that the first 3 inodes in the filesystem are the root directory,
  * the realtime bitmap, and the realtime summary, in that order.
@@ -673,6 +713,16 @@ _("sb root inode value %" PRIu64 " valid but in unaligned location (expected %"P
 
 	validate_sb_ino(&mp->m_sb.sb_rootino, rootino,
 			_("root"));
+
+	if (xfs_has_metadir(mp)) {
+		/*
+		 * The metadata root directory comes after the regular root
+		 * directory.
+		 */
+		check_metadir_inode(mp, rootino);
+		rootino++;
+	}
+
 	validate_sb_ino(&mp->m_sb.sb_rbmino, rootino + 1,
 			_("realtime bitmap"));
 	validate_sb_ino(&mp->m_sb.sb_rsumino, rootino + 2,

