Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 771511368
	for <linux-xfs@vger.kernel.org>; Mon,  1 Jan 2024 00:34:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fS0NYefE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45751C433C7;
	Mon,  1 Jan 2024 00:34:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704069270;
	bh=GUZNScwxoW4Fsmy0/tfTQT5bkPRb0dbCft+gyyX82sU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=fS0NYefEJczJScgTV9Wttsvf16Mx9jdfk/1ZoNrzFUFI9R/TztKyaDAcEFwZcJj1u
	 TFz+E2RszYHqX+5amQCejXSVQc2EJiWLtL+m+eG5tLbbfgIT67a5EvweXp6bEj5+A3
	 cYu9jDTH1nShFvf+V3aTM5BbKcC15s2RvfYIAbmbnvLJxTFQypoDsl0/jwqs/2nGax
	 wh+QVrwPVZV0oAWnEbKR4qJ6G/XWnBilHmm6LhHLtU/USeox8bf/nVaMyUzR/HEhTj
	 20VqHbiiyFR5uKhk19ewBfVqq7UA6p6b8myp65tFlIhNWM3s3YXJux8zpU0fjAMMpW
	 t8oM4dPUTdJsA==
Date: Sun, 31 Dec 2023 16:34:29 +9900
Subject: [PATCH 32/42] xfs_repair: find and mark the rtrefcountbt inode
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405017553.1817107.5061364310494033700.stgit@frogsfrogsfrogs>
In-Reply-To: <170405017092.1817107.5442809166380700367.stgit@frogsfrogsfrogs>
References: <170405017092.1817107.5442809166380700367.stgit@frogsfrogsfrogs>
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

Make sure that we find the realtime refcountbt inode and mark it
appropriately, just in case we find a rogue inode claiming to
be an rtrefcount, or just plain garbage in the superblock field.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 repair/dino_chunks.c |   11 ++++++
 repair/dinode.c      |   30 +++++++++++++++
 repair/dir2.c        |    2 +
 repair/incore.h      |    1 +
 repair/rmap.c        |   98 +++++++++++++++++++++++++++++++++++++++++++++++++-
 repair/rmap.h        |    3 +-
 repair/scan.c        |    8 ++--
 7 files changed, 145 insertions(+), 8 deletions(-)


diff --git a/repair/dino_chunks.c b/repair/dino_chunks.c
index b7a5879bf4b..04898643883 100644
--- a/repair/dino_chunks.c
+++ b/repair/dino_chunks.c
@@ -1025,6 +1025,17 @@ process_inode_chunk(
 	_("would clear realtime rmap inode %" PRIu64 "\n"),
 						ino);
 				}
+			} else if (is_rtrefcount_ino(ino)) {
+				refcount_avoid_check(mp);
+				if (!no_modify)  {
+					do_warn(
+	_("cleared realtime refcount inode %" PRIu64 "\n"),
+						ino);
+				} else  {
+					do_warn(
+	_("would clear realtime refcount inode %" PRIu64 "\n"),
+						ino);
+				}
 			} else if (!no_modify)  {
 				do_warn(_("cleared inode %" PRIu64 "\n"),
 					ino);
diff --git a/repair/dinode.c b/repair/dinode.c
index f1cb119df8b..ad4263f9aa8 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -156,6 +156,9 @@ clear_dinode(xfs_mount_t *mp, struct xfs_dinode *dino, xfs_ino_t ino_num)
 	if (is_rtrmap_inode(ino_num))
 		rmap_avoid_check(mp);
 
+	if (is_rtrefcount_ino(ino_num))
+		refcount_avoid_check(mp);
+
 	/* and clear the forks */
 	memset(XFS_DFORK_DPTR(dino), 0, XFS_LITINO(mp));
 	return;
@@ -1067,6 +1070,12 @@ _("rtrefcount inode %" PRIu64 " not flagged as metadata\n"),
 			lino);
 		return 1;
 	}
+	if (type != XR_INO_RTREFC) {
+		do_warn(
+_("rtrefcount inode %" PRIu64 " was not found in the metadata directory tree\n"),
+			lino);
+		return 1;
+	}
 
 	priv.rgno = rtgroup_for_rtrefcount_inode(mp, ino);
 	if (priv.rgno == NULLRGNUMBER) {
@@ -1107,7 +1116,7 @@ _("computed size of rtrefcountbt root (%zu bytes) is greater than space in "
 		error = process_rtrefc_reclist(mp, rp, numrecs,
 				&priv, "rtrefcountbt root");
 		if (error) {
-			refcount_avoid_check();
+			refcount_avoid_check(mp);
 			return 1;
 		}
 		return 0;
@@ -2063,6 +2072,9 @@ process_check_sb_inodes(
 	if (is_rtrmap_inode(lino))
 		return process_check_rt_inode(mp, dinoc, lino, type, dirty,
 				XR_INO_RTRMAP, _("realtime rmap btree"));
+	if (is_rtrefcount_ino(lino))
+		return process_check_rt_inode(mp, dinoc, lino, type, dirty,
+				XR_INO_RTREFC, _("realtime refcount btree"));
 	return 0;
 }
 
@@ -2172,6 +2184,18 @@ _("found inode %" PRIu64 " claiming to be a rtrmapbt file, but rmapbt is disable
 		}
 		break;
 
+	case XR_INO_RTREFC:
+		/*
+		 * if we have no refcountbt, any inode claiming
+		 * to be a real-time file is bogus
+		 */
+		if (!xfs_has_reflink(mp)) {
+			do_warn(
+_("found inode %" PRIu64 " claiming to be a rtrefcountbt file, but reflink is disabled\n"), lino);
+			return 1;
+		}
+		break;
+
 	default:
 		break;
 	}
@@ -2201,6 +2225,7 @@ _("bad attr fork offset %d in dev inode %" PRIu64 ", should be %d\n"),
 		}
 		break;
 	case XFS_DINODE_FMT_RMAP:
+	case XFS_DINODE_FMT_REFCOUNT:
 		if (!(xfs_has_metadir(mp) && xfs_has_parent(mp))) {
 			do_warn(
 _("metadata inode %" PRIu64 " type %d cannot have attr fork\n"),
@@ -3311,6 +3336,8 @@ _("bad (negative) size %" PRId64 " on inode %" PRIu64 "\n"),
 			type = XR_INO_PQUOTA;
 		else if (is_rtrmap_inode(lino))
 			type = XR_INO_RTRMAP;
+		else if (is_rtrefcount_ino(lino))
+			type = XR_INO_RTREFC;
 		else
 			type = XR_INO_DATA;
 		break;
@@ -3417,6 +3444,7 @@ _("Bad CoW extent size %u on inode %" PRIu64 ", "),
 		case XR_INO_GQUOTA:
 		case XR_INO_PQUOTA:
 		case XR_INO_RTRMAP:
+		case XR_INO_RTREFC:
 			/*
 			 * This inode was recognized as being filesystem
 			 * metadata, so preserve the inode and its contents for
diff --git a/repair/dir2.c b/repair/dir2.c
index 43229b3cd9b..9fd9569ec9f 100644
--- a/repair/dir2.c
+++ b/repair/dir2.c
@@ -158,6 +158,8 @@ is_meta_ino(
 		reason = _("realtime summary");
 	else if (is_rtrmap_inode(lino))
 		reason = _("realtime rmap");
+	else if (is_rtrefcount_ino(lino))
+		reason = _("realtime refcount");
 	else if (lino == mp->m_sb.sb_uquotino)
 		reason = _("user quota");
 	else if (lino == mp->m_sb.sb_gquotino)
diff --git a/repair/incore.h b/repair/incore.h
index 6ee7a662930..5014a2d303c 100644
--- a/repair/incore.h
+++ b/repair/incore.h
@@ -222,6 +222,7 @@ int		count_bcnt_extents(xfs_agnumber_t);
 #define XR_INO_GQUOTA	13		/* group quota inode */
 #define XR_INO_PQUOTA	14		/* project quota inode */
 #define XR_INO_RTRMAP	15		/* realtime rmap */
+#define XR_INO_RTREFC	16		/* realtime refcount */
 
 /* inode allocation tree */
 
diff --git a/repair/rmap.c b/repair/rmap.c
index b27e3079155..55b41cfa540 100644
--- a/repair/rmap.c
+++ b/repair/rmap.c
@@ -40,6 +40,12 @@ struct xfs_ag_rmap {
 	 * NULLFSINO to signal to phase 6 to link a new inode into the metadir.
 	 */
 	xfs_ino_t	rg_rmap_ino;
+
+	/*
+	 * inumber of the refcount btree for this rtgroup.  This can be set to
+	 * NULLFSINO to signal to phase 6 to link a new inode into the metadir.
+	 */
+	xfs_ino_t	rg_refcount_ino;
 };
 
 static struct xfs_ag_rmap *ag_rmaps;
@@ -50,6 +56,9 @@ static bool refcbt_suspect;
 /* Bitmap of rt group rmap inodes reachable via /realtime/$rgno.rmap. */
 static struct bitmap	*rmap_inodes;
 
+/* Bitmap of rt group refcount inodes reachable via /realtime/$rgno.refcount. */
+static struct bitmap	*refcount_inodes;
+
 static struct xfs_ag_rmap *rmaps_for_group(bool isrt, unsigned int group)
 {
 	if (isrt)
@@ -127,6 +136,7 @@ rmaps_init_rt(
 		goto nomem;
 
 	ag_rmap->rg_rmap_ino = NULLFSINO;
+	ag_rmap->rg_refcount_ino = NULLFSINO;
 	return;
 nomem:
 	do_error(
@@ -218,6 +228,50 @@ set_rtgroup_rmap_inode(
 	return error;
 }
 
+static inline int
+set_rtgroup_refcount_inode(
+	struct xfs_mount	*mp,
+	xfs_rgnumber_t		rgno)
+{
+	struct xfs_imeta_path	*path;
+	struct xfs_ag_rmap	*ar = rmaps_for_group(true, rgno);
+	struct xfs_trans	*tp;
+	xfs_ino_t		ino;
+	int			error;
+
+	if (!xfs_has_rtreflink(mp))
+		return 0;
+
+	error = -libxfs_rtrefcountbt_create_path(mp, rgno, &path);
+	if (error)
+		return error;
+
+	error = -libxfs_trans_alloc_empty(mp, &tp);
+	if (error)
+		goto out_path;
+
+	error = -libxfs_imeta_lookup(tp, path, &ino);
+	if (error)
+		goto out_trans;
+
+	if (ino == NULLFSINO || bitmap_test(refcount_inodes, ino, 1)) {
+		error = EFSCORRUPTED;
+		goto out_trans;
+	}
+
+	error = bitmap_set(refcount_inodes, ino, 1);
+	if (error)
+		goto out_trans;
+
+	ar->rg_refcount_ino = ino;
+
+out_trans:
+	libxfs_trans_cancel(tp);
+out_path:
+	libxfs_imeta_free_path(path);
+	return error;
+}
+
 static void
 discover_rtgroup_inodes(
 	struct xfs_mount	*mp)
@@ -229,10 +283,20 @@ discover_rtgroup_inodes(
 	if (error)
 		goto out;
 
+	error = bitmap_alloc(&refcount_inodes);
+	if (error) {
+		bitmap_free(&rmap_inodes);
+		goto out;
+	}
+
 	for (rgno = 0; rgno < mp->m_sb.sb_rgcount; rgno++) {
 		int err2 = set_rtgroup_rmap_inode(mp, rgno);
 		if (err2 && !error)
 			error = err2;
+
+		err2 = set_rtgroup_refcount_inode(mp, rgno);
+		if (err2 && !error)
+			error = err2;
 	}
 
 out:
@@ -248,6 +312,7 @@ discover_rtgroup_inodes(
 static inline void
 free_rtmeta_inode_bitmaps(void)
 {
+	bitmap_free(&refcount_inodes);
 	bitmap_free(&rmap_inodes);
 }
 
@@ -263,10 +328,28 @@ rtgroup_for_rtrefcount_inode(
 	struct xfs_mount	*mp,
 	xfs_ino_t		ino)
 {
-	/* This will be implemented later. */
+	xfs_rgnumber_t		rgno;
+
+	if (!refcount_inodes)
+		return NULLRGNUMBER;
+
+	for (rgno = 0; rgno < mp->m_sb.sb_rgcount; rgno++) {
+		if (rg_rmaps[rgno].rg_refcount_ino == ino)
+			return rgno;
+	}
+
 	return NULLRGNUMBER;
 }
 
+bool
+is_rtrefcount_ino(
+	xfs_ino_t		ino)
+{
+	if (!refcount_inodes)
+		return false;
+	return bitmap_test(refcount_inodes, ino, 1);
+}
+
 /*
  * Initialize per-AG reverse map data.
  */
@@ -1864,8 +1947,19 @@ init_refcount_cursor(
  * Disable the refcount btree check.
  */
 void
-refcount_avoid_check(void)
+refcount_avoid_check(
+	struct xfs_mount	*mp)
 {
+	struct xfs_rtgroup	*rtg;
+	xfs_rgnumber_t		rgno;
+
+	for_each_rtgroup(mp, rgno, rtg) {
+		struct xfs_ag_rmap *ar = rmaps_for_group(true, rtg->rtg_rgno);
+
+		ar->rg_refcount_ino = NULLFSINO;
+	}
+
+	bitmap_clear(refcount_inodes, 0, XFS_MAXINUMBER);
 	refcbt_suspect = true;
 }
 
diff --git a/repair/rmap.h b/repair/rmap.h
index 051481d2e2d..3e210fac87b 100644
--- a/repair/rmap.h
+++ b/repair/rmap.h
@@ -41,7 +41,7 @@ extern void rmap_high_key_from_rec(struct xfs_rmap_irec *rec,
 extern int compute_refcounts(struct xfs_mount *, xfs_agnumber_t);
 uint64_t refcount_record_count(struct xfs_mount *mp, xfs_agnumber_t agno);
 extern int init_refcount_cursor(xfs_agnumber_t, struct xfs_slab_cursor **);
-extern void refcount_avoid_check(void);
+extern void refcount_avoid_check(struct xfs_mount *mp);
 void check_refcounts(struct xfs_mount *mp, xfs_agnumber_t agno);
 
 extern void record_inode_reflink_flag(struct xfs_mount *, struct xfs_dinode *,
@@ -73,5 +73,6 @@ xfs_filblks_t estimate_rtrmapbt_blocks(struct xfs_rtgroup *rtg);
 
 xfs_rgnumber_t rtgroup_for_rtrefcount_inode(struct xfs_mount *mp,
 		xfs_ino_t ino);
+bool is_rtrefcount_ino(xfs_ino_t ino);
 
 #endif /* RMAP_H_ */
diff --git a/repair/scan.c b/repair/scan.c
index abf605e4978..88ca5acc040 100644
--- a/repair/scan.c
+++ b/repair/scan.c
@@ -1987,7 +1987,7 @@ _("extent (%u/%u) len %u claimed, state is %d\n"),
 	libxfs_perag_put(pag);
 out:
 	if (suspect)
-		refcount_avoid_check();
+		refcount_avoid_check(mp);
 	return;
 }
 
@@ -2277,7 +2277,7 @@ _("%s btree block claimed (state %d), agno %d, agbno %d, suspect %d\n"),
 	}
 out:
 	if (suspect) {
-		refcount_avoid_check();
+		refcount_avoid_check(mp);
 		return 1;
 	}
 
@@ -3140,7 +3140,7 @@ validate_agf(
 		if (levels == 0 || levels > mp->m_refc_maxlevels) {
 			do_warn(_("bad levels %u for refcountbt root, agno %d\n"),
 				levels, agno);
-			refcount_avoid_check();
+			refcount_avoid_check(mp);
 		}
 
 		bno = be32_to_cpu(agf->agf_refcount_root);
@@ -3158,7 +3158,7 @@ validate_agf(
 		} else {
 			do_warn(_("bad agbno %u for refcntbt root, agno %d\n"),
 				bno, agno);
-			refcount_avoid_check();
+			refcount_avoid_check(mp);
 		}
 	}
 

