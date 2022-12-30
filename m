Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0EF0C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 03:02:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236243AbiLaDCb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 22:02:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236258AbiLaDCa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 22:02:30 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D54115816
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 19:02:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CDFD961D17
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 03:02:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38D10C433D2;
        Sat, 31 Dec 2022 03:02:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672455748;
        bh=lgjBiSjg1lIyKjjMVIruEaXoaPDkFk0olKirqkS+nL8=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=hVPtoogX6HwAJHSG+Wy40uR0U3K8EHwp8RbtBc04wBEZYSilzrm8LDvAWJfdlssWP
         mcjMLCJazQexMnxrZDmpSQQO9qAL4voDUrZAjEiga5D1vgGebGdbLpEFxZ+hlAdkjG
         wtUVcZ6yWt7suMkdesre4uz+5G9OKY6j+Ko4AHGqUQhrae74pn+LjCL9T/leUeytqc
         /FEGo2izmtZWR/n05kEz0iVNOBgEyZVzWlzHRSUgGrtx8clXSRAUREhZt9L+1RZDXw
         SeVtnnsN7k3UoJWYRL3Nj8dE83eYVHa5z9FEuIAytcvnL9WJiTy+NQjWzcNbXBSIiw
         TdSnp1S6QQGoA==
Subject: [PATCH 32/41] xfs_repair: find and mark the rtrefcountbt inode
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:20:11 -0800
Message-ID: <167243881193.734096.9390789459696226732.stgit@magnolia>
In-Reply-To: <167243880752.734096.171910706541747310.stgit@magnolia>
References: <167243880752.734096.171910706541747310.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Make sure that we find the realtime refcountbt inode and mark it
appropriately, just in case we find a rogue inode claiming to
be an rtrefcount, or just plain garbage in the superblock field.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 repair/dino_chunks.c |   11 ++++++
 repair/dinode.c      |   29 ++++++++++++++++-
 repair/dir2.c        |    2 +
 repair/incore.h      |    1 +
 repair/rmap.c        |   87 +++++++++++++++++++++++++++++++++++++++++++++++++-
 repair/rmap.h        |    3 +-
 repair/scan.c        |    8 ++---
 7 files changed, 133 insertions(+), 8 deletions(-)


diff --git a/repair/dino_chunks.c b/repair/dino_chunks.c
index 277f21c6936..fe394cd637c 100644
--- a/repair/dino_chunks.c
+++ b/repair/dino_chunks.c
@@ -1027,6 +1027,17 @@ process_inode_chunk(
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
index 7722d7762d2..1322f31d47e 100644
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
@@ -3299,6 +3323,8 @@ _("bad (negative) size %" PRId64 " on inode %" PRIu64 "\n"),
 			type = XR_INO_PQUOTA;
 		else if (is_rtrmap_inode(lino))
 			type = XR_INO_RTRMAP;
+		else if (is_rtrefcount_ino(lino))
+			type = XR_INO_RTREFC;
 		else
 			type = XR_INO_DATA;
 		break;
@@ -3405,6 +3431,7 @@ _("Bad CoW extent size %u on inode %" PRIu64 ", "),
 		case XR_INO_GQUOTA:
 		case XR_INO_PQUOTA:
 		case XR_INO_RTRMAP:
+		case XR_INO_RTREFC:
 			/*
 			 * This inode was recognized as being filesystem
 			 * metadata, so preserve the inode and its contents for
diff --git a/repair/dir2.c b/repair/dir2.c
index 4c59ad071de..6f6933f91d5 100644
--- a/repair/dir2.c
+++ b/repair/dir2.c
@@ -157,6 +157,8 @@ is_meta_ino(
 		reason = _("realtime summary");
 	else if (is_rtrmap_inode(lino))
 		reason = _("realtime rmap");
+	else if (is_rtrefcount_ino(lino))
+		reason = _("realtime refcount");
 	else if (lino == mp->m_sb.sb_uquotino)
 		reason = _("user quota");
 	else if (lino == mp->m_sb.sb_gquotino)
diff --git a/repair/incore.h b/repair/incore.h
index 3c0e4ea2b29..aaf5b5b55ba 100644
--- a/repair/incore.h
+++ b/repair/incore.h
@@ -225,6 +225,7 @@ int		count_bcnt_extents(xfs_agnumber_t);
 #define XR_INO_GQUOTA	13		/* group quota inode */
 #define XR_INO_PQUOTA	14		/* project quota inode */
 #define XR_INO_RTRMAP	15		/* realtime rmap */
+#define XR_INO_RTREFC	16		/* realtime refcount */
 
 /* inode allocation tree */
 
diff --git a/repair/rmap.c b/repair/rmap.c
index 69954b448ed..9394720a1b6 100644
--- a/repair/rmap.c
+++ b/repair/rmap.c
@@ -38,6 +38,12 @@ struct xfs_ag_rmap {
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
@@ -48,6 +54,9 @@ static bool refcbt_suspect;
 /* Bitmap of rt group rmap inodes reachable via /realtime/$rgno.rmap. */
 static struct bitmap	*rmap_inodes;
 
+/* Bitmap of rt group refcount inodes reachable via /realtime/$rgno.refcount. */
+static struct bitmap	*refcount_inodes;
+
 static struct xfs_ag_rmap *rmaps_for_group(bool isrt, unsigned int group)
 {
 	if (isrt)
@@ -129,6 +138,7 @@ rmaps_init_rt(
 		goto nomem;
 
 	ag_rmap->rg_rmap_ino = NULLFSINO;
+	ag_rmap->rg_refcount_ino = NULLFSINO;
 	return;
 nomem:
 	do_error(
@@ -210,6 +220,39 @@ set_rtgroup_rmap_inode(
 	return 0;
 }
 
+static inline int
+set_rtgroup_refcount_inode(
+	struct xfs_mount	*mp,
+	xfs_rgnumber_t		rgno)
+{
+	struct xfs_imeta_path	*path;
+	struct xfs_ag_rmap	*ar = rmaps_for_group(true, rgno);
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
+	error = -libxfs_imeta_lookup(mp, path, &ino);
+	libxfs_imeta_free_path(path);
+	if (error)
+		return error;
+
+	if (ino == NULLFSINO || bitmap_test(refcount_inodes, ino, 1))
+		return EFSCORRUPTED;
+
+	error = bitmap_set(refcount_inodes, ino, 1);
+	if (error)
+		return error;
+
+	ar->rg_refcount_ino = ino;
+	return 0;
+}
+
 static void
 discover_rtgroup_inodes(
 	struct xfs_mount	*mp)
@@ -221,10 +264,20 @@ discover_rtgroup_inodes(
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
@@ -240,6 +293,7 @@ discover_rtgroup_inodes(
 static inline void
 free_rtmeta_inode_bitmaps(void)
 {
+	bitmap_free(&refcount_inodes);
 	bitmap_free(&rmap_inodes);
 }
 
@@ -255,10 +309,28 @@ rtgroup_for_rtrefcount_inode(
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
@@ -1816,8 +1888,19 @@ init_refcount_cursor(
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
index 83331c825ec..4f49b19062c 100644
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
@@ -68,5 +68,6 @@ int populate_rtgroup_rmapbt(struct xfs_rtgroup *rtg, struct xfs_inode *ip);
 
 xfs_rgnumber_t rtgroup_for_rtrefcount_inode(struct xfs_mount *mp,
 		xfs_ino_t ino);
+bool is_rtrefcount_ino(xfs_ino_t ino);
 
 #endif /* RMAP_H_ */
diff --git a/repair/scan.c b/repair/scan.c
index 0a37137f019..50ae662d73b 100644
--- a/repair/scan.c
+++ b/repair/scan.c
@@ -1985,7 +1985,7 @@ _("extent (%u/%u) len %u claimed, state is %d\n"),
 	libxfs_perag_put(pag);
 out:
 	if (suspect)
-		refcount_avoid_check();
+		refcount_avoid_check(mp);
 	return;
 }
 
@@ -2275,7 +2275,7 @@ _("%s btree block claimed (state %d), agno %d, agbno %d, suspect %d\n"),
 	}
 out:
 	if (suspect) {
-		refcount_avoid_check();
+		refcount_avoid_check(mp);
 		return 1;
 	}
 
@@ -3138,7 +3138,7 @@ validate_agf(
 		if (levels == 0 || levels > mp->m_refc_maxlevels) {
 			do_warn(_("bad levels %u for refcountbt root, agno %d\n"),
 				levels, agno);
-			refcount_avoid_check();
+			refcount_avoid_check(mp);
 		}
 
 		bno = be32_to_cpu(agf->agf_refcount_root);
@@ -3156,7 +3156,7 @@ validate_agf(
 		} else {
 			do_warn(_("bad agbno %u for refcntbt root, agno %d\n"),
 				bno, agno);
-			refcount_avoid_check();
+			refcount_avoid_check(mp);
 		}
 	}
 

