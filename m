Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1C4FC3DA7C
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 02:51:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236264AbiLaCvb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 21:51:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236258AbiLaCvH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 21:51:07 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1FAC11178
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 18:51:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A84DDB81E70
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 02:51:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B059C433EF;
        Sat, 31 Dec 2022 02:51:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672455063;
        bh=Kaki/K5TGQWpAoOJBpbmOoWw/VVTQ784adwHc/nZygs=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=lOVRJd2a/mynQfXjOtTtAuHHtdBAglBVqxsHKX8iZA9GSqiMOlmXFutiOL2WGX3Dp
         kOXXBUaQmZRrw3Tr4gkNzh/oxOSwdVryFpt8mZeBSLr5/PTHudU8aSpSqaMKX+gpiu
         vZXXJxXdmxgInvAY5lwFouD/ZuylZqZzj0+53tr0Gxgdv5gEUDxATYgaGlkPRszezs
         8hp4u+6A5o+wEDf4tJSWQyNnGTbDpehWeKWPrcDC9UDpz/2eFMAKb1JjAxnc8VGcf7
         a2dsvDvHgrEc+jDSnG6/ngEqWXYKycMTcwI2re+TOL2QBJsrLRANvNxEt5XHWBBkT9
         tdve+DTYQB5vA==
Subject: [PATCH 33/41] xfs_repair: find and mark the rtrmapbt inodes
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:20:00 -0800
Message-ID: <167243880031.732820.11939027053574118167.stgit@magnolia>
In-Reply-To: <167243879574.732820.4725863402652761218.stgit@magnolia>
References: <167243879574.732820.4725863402652761218.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Make sure that we find the realtime rmapbt inodes and mark them
appropriately, just in case we find a rogue inode claiming to be an
rtrmap, or garbage in the metadata directory tree.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 repair/dino_chunks.c |   13 ++++++
 repair/dinode.c      |   34 ++++++++++++++-
 repair/dir2.c        |    4 ++
 repair/incore.h      |    1 
 repair/rmap.c        |  111 +++++++++++++++++++++++++++++++++++++++++++++++++-
 repair/rmap.h        |    5 ++
 repair/scan.c        |    8 ++--
 7 files changed, 167 insertions(+), 9 deletions(-)


diff --git a/repair/dino_chunks.c b/repair/dino_chunks.c
index c68d92a4d88..277f21c6936 100644
--- a/repair/dino_chunks.c
+++ b/repair/dino_chunks.c
@@ -15,6 +15,8 @@
 #include "versions.h"
 #include "prefetch.h"
 #include "progress.h"
+#include "slab.h"
+#include "rmap.h"
 
 /*
  * validates inode block or chunk, returns # of good inodes
@@ -1014,6 +1016,17 @@ process_inode_chunk(
 	_("would clear realtime summary inode %" PRIu64 "\n"),
 						ino);
 				}
+			} else if (is_rtrmap_inode(ino)) {
+				rmap_avoid_check(mp);
+				if (!no_modify)  {
+					do_warn(
+	_("cleared realtime rmap inode %" PRIu64 "\n"),
+						ino);
+				} else  {
+					do_warn(
+	_("would clear realtime rmap inode %" PRIu64 "\n"),
+						ino);
+				}
 			} else if (!no_modify)  {
 				do_warn(_("cleared inode %" PRIu64 "\n"),
 					ino);
diff --git a/repair/dinode.c b/repair/dinode.c
index 3e55434c849..782a36172ad 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -153,6 +153,9 @@ clear_dinode(xfs_mount_t *mp, struct xfs_dinode *dino, xfs_ino_t ino_num)
 	clear_dinode_core(mp, dino, ino_num);
 	clear_dinode_unlinked(mp, dino);
 
+	if (is_rtrmap_inode(ino_num))
+		rmap_avoid_check(mp);
+
 	/* and clear the forks */
 	memset(XFS_DFORK_DPTR(dino), 0, XFS_LITINO(mp));
 	return;
@@ -823,13 +826,22 @@ process_rtrmap(
 
 	lino = XFS_AGINO_TO_INO(mp, agno, ino);
 
-	/* This rmap btree inode must be a metadata inode. */
+	/*
+	 * This rmap btree inode must be a metadata inode reachable via
+	 * /realtime/$rgno.rmap in the metadata directory tree.
+	 */
 	if (!(dip->di_flags2 & be64_to_cpu(XFS_DIFLAG2_METADATA))) {
 		do_warn(
 _("rtrmap inode %" PRIu64 " not flagged as metadata\n"),
 			lino);
 		return 1;
 	}
+	if (type != XR_INO_RTRMAP) {
+		do_warn(
+_("rtrmap inode %" PRIu64 " was not found in the metadata directory tree\n"),
+			lino);
+		return 1;
+	}
 
 	memset(&priv.high_key, 0xFF, sizeof(priv.high_key));
 	priv.high_key.rm_blockcount = 0;
@@ -867,7 +879,7 @@ _("computed size of rtrmapbt root (%zu bytes) is greater than space in "
 		error = process_rtrmap_reclist(mp, rp, numrecs,
 				&priv.last_rec, NULL, "rtrmapbt root");
 		if (error) {
-			rmap_avoid_check();
+			rmap_avoid_check(mp);
 			return 1;
 		}
 		return 0;
@@ -1829,6 +1841,9 @@ process_check_sb_inodes(
 	if (lino == mp->m_sb.sb_rbmino)
 		return process_check_rt_inode(mp, dinoc, lino, type, dirty,
 				XR_INO_RTBITMAP, _("realtime bitmap"));
+	if (is_rtrmap_inode(lino))
+		return process_check_rt_inode(mp, dinoc, lino, type, dirty,
+				XR_INO_RTRMAP, _("realtime rmap btree"));
 	return 0;
 }
 
@@ -1926,6 +1941,18 @@ _("realtime summary inode %" PRIu64 " has bad size %" PRId64 " (should be %d)\n"
 		}
 		break;
 
+	case XR_INO_RTRMAP:
+		/*
+		 * if we have no rmapbt, any inode claiming
+		 * to be a real-time file is bogus
+		 */
+		if (!xfs_has_rmapbt(mp)) {
+			do_warn(
+_("found inode %" PRIu64 " claiming to be a rtrmapbt file, but rmapbt is disabled\n"), lino);
+			return 1;
+		}
+		break;
+
 	default:
 		break;
 	}
@@ -3046,6 +3073,8 @@ _("bad (negative) size %" PRId64 " on inode %" PRIu64 "\n"),
 			type = XR_INO_GQUOTA;
 		else if (lino == mp->m_sb.sb_pquotino)
 			type = XR_INO_PQUOTA;
+		else if (is_rtrmap_inode(lino))
+			type = XR_INO_RTRMAP;
 		else
 			type = XR_INO_DATA;
 		break;
@@ -3151,6 +3180,7 @@ _("Bad CoW extent size %u on inode %" PRIu64 ", "),
 		case XR_INO_UQUOTA:
 		case XR_INO_GQUOTA:
 		case XR_INO_PQUOTA:
+		case XR_INO_RTRMAP:
 			/*
 			 * This inode was recognized as being filesystem
 			 * metadata, so preserve the inode and its contents for
diff --git a/repair/dir2.c b/repair/dir2.c
index e1fb195df34..4c59ad071de 100644
--- a/repair/dir2.c
+++ b/repair/dir2.c
@@ -15,6 +15,8 @@
 #include "da_util.h"
 #include "prefetch.h"
 #include "progress.h"
+#include "slab.h"
+#include "rmap.h"
 
 /*
  * Known bad inode list.  These are seen when the leaf and node
@@ -153,6 +155,8 @@ is_meta_ino(
 		reason = _("realtime bitmap");
 	else if (lino == mp->m_sb.sb_rsumino)
 		reason = _("realtime summary");
+	else if (is_rtrmap_inode(lino))
+		reason = _("realtime rmap");
 	else if (lino == mp->m_sb.sb_uquotino)
 		reason = _("user quota");
 	else if (lino == mp->m_sb.sb_gquotino)
diff --git a/repair/incore.h b/repair/incore.h
index c31b778a0fb..3c0e4ea2b29 100644
--- a/repair/incore.h
+++ b/repair/incore.h
@@ -224,6 +224,7 @@ int		count_bcnt_extents(xfs_agnumber_t);
 #define XR_INO_UQUOTA	12		/* user quota inode */
 #define XR_INO_GQUOTA	13		/* group quota inode */
 #define XR_INO_PQUOTA	14		/* project quota inode */
+#define XR_INO_RTRMAP	15		/* realtime rmap */
 
 /* inode allocation tree */
 
diff --git a/repair/rmap.c b/repair/rmap.c
index 9550377df16..4d7ed98ad17 100644
--- a/repair/rmap.c
+++ b/repair/rmap.c
@@ -32,6 +32,12 @@ struct xfs_ag_rmap {
 	int		ar_flcount;		/* agfl entries from leftover */
 						/* agbt allocations */
 	struct xfs_slab	*ar_refcount_items;	/* refcount items, p4-5 */
+
+	/*
+	 * inumber of the rmap btree for this rtgroup.  This can be set to
+	 * NULLFSINO to signal to phase 6 to link a new inode into the metadir.
+	 */
+	xfs_ino_t	rg_rmap_ino;
 };
 
 static struct xfs_ag_rmap *ag_rmaps;
@@ -39,6 +45,9 @@ static struct xfs_ag_rmap *rg_rmaps;
 bool rmapbt_suspect;
 static bool refcbt_suspect;
 
+/* Bitmap of rt group rmap inodes reachable via /realtime/$rgno.rmap. */
+static struct bitmap	*rmap_inodes;
+
 static struct xfs_ag_rmap *rmaps_for_group(bool isrt, unsigned int group)
 {
 	if (isrt)
@@ -119,6 +128,7 @@ rmaps_init_rt(
 	if (error)
 		goto nomem;
 
+	ag_rmap->rg_rmap_ino = NULLFSINO;
 	return;
 nomem:
 	do_error(
@@ -167,6 +177,79 @@ rmaps_init_ag(
 _("Insufficient memory while allocating realtime reverse mapping btree."));
 }
 
+static inline int
+set_rtgroup_rmap_inode(
+	struct xfs_mount	*mp,
+	xfs_rgnumber_t		rgno)
+{
+	struct xfs_imeta_path	*path;
+	struct xfs_ag_rmap	*ar = rmaps_for_group(true, rgno);
+	xfs_ino_t		ino;
+	int			error;
+
+	if (!xfs_has_rtrmapbt(mp))
+		return 0;
+
+	error = -libxfs_rtrmapbt_create_path(mp, rgno, &path);
+	if (error)
+		return error;
+
+	error = -libxfs_imeta_lookup(mp, path, &ino);
+	libxfs_imeta_free_path(path);
+	if (error)
+		return error;
+
+	if (ino == NULLFSINO || bitmap_test(rmap_inodes, ino, 1))
+		return EFSCORRUPTED;
+
+	error = bitmap_set(rmap_inodes, ino, 1);
+	if (error)
+		return error;
+
+	ar->rg_rmap_ino = ino;
+	return 0;
+}
+
+static void
+discover_rtgroup_inodes(
+	struct xfs_mount	*mp)
+{
+	xfs_rgnumber_t		rgno;
+	int			error;
+
+	error = bitmap_alloc(&rmap_inodes);
+	if (error)
+		goto out;
+
+	for (rgno = 0; rgno < mp->m_sb.sb_rgcount; rgno++) {
+		int err2 = set_rtgroup_rmap_inode(mp, rgno);
+		if (err2 && !error)
+			error = err2;
+	}
+
+out:
+	if (error == EFSCORRUPTED)
+		do_warn(
+ _("corruption in metadata directory tree while discovering rt group inodes\n"));
+	if (error)
+		do_warn(
+ _("couldn't discover rt group inodes, err %d\n"),
+				error);
+}
+
+static inline void
+free_rtmeta_inode_bitmaps(void)
+{
+	bitmap_free(&rmap_inodes);
+}
+
+bool is_rtrmap_inode(xfs_ino_t ino)
+{
+	if (!rmap_inodes)
+		return false;
+	return bitmap_test(rmap_inodes, ino, 1);
+}
+
 /*
  * Initialize per-AG reverse map data.
  */
@@ -192,6 +275,8 @@ rmaps_init(
 
 	for (i = 0; i < mp->m_sb.sb_rgcount; i++)
 		rmaps_init_rt(mp, i, &rg_rmaps[i]);
+
+	discover_rtgroup_inodes(mp);
 }
 
 /*
@@ -206,6 +291,8 @@ rmaps_free(
 	if (!rmap_needs_work(mp))
 		return;
 
+	free_rtmeta_inode_bitmaps();
+
 	for (i = 0; i < mp->m_sb.sb_rgcount; i++)
 		rmaps_destroy(mp, &rg_rmaps[i]);
 	free(rg_rmaps);
@@ -1152,11 +1239,22 @@ rmap_record_count(
 }
 
 /*
- * Disable the refcount btree check.
+ * Disable the rmap btree check.
  */
 void
-rmap_avoid_check(void)
+rmap_avoid_check(
+	struct xfs_mount	*mp)
 {
+	struct xfs_rtgroup	*rtg;
+	xfs_rgnumber_t		rgno;
+
+	for_each_rtgroup(mp, rgno, rtg) {
+		struct xfs_ag_rmap *ar = rmaps_for_group(true, rtg->rtg_rgno);
+
+		ar->rg_rmap_ino = NULLFSINO;
+	}
+
+	bitmap_clear(rmap_inodes, 0, XFS_MAXINUMBER);
 	rmapbt_suspect = true;
 }
 
@@ -1790,3 +1888,12 @@ rmap_store_agflcount(
 
 	rmaps_for_group(false, agno)->ar_flcount = count;
 }
+
+xfs_ino_t
+rtgroup_rmap_ino(
+	struct xfs_rtgroup	*rtg)
+{
+	struct xfs_ag_rmap	*ar = rmaps_for_group(true, rtg->rtg_rgno);
+
+	return ar->rg_rmap_ino;
+}
diff --git a/repair/rmap.h b/repair/rmap.h
index 008b96a38f4..0cb5759086b 100644
--- a/repair/rmap.h
+++ b/repair/rmap.h
@@ -28,7 +28,7 @@ int rmap_commit_agbtree_mappings(struct xfs_mount *mp, xfs_agnumber_t agno);
 
 uint64_t rmap_record_count(struct xfs_mount *mp, bool isrt,
 		xfs_agnumber_t agno);
-extern void rmap_avoid_check(void);
+extern void rmap_avoid_check(struct xfs_mount *mp);
 void rmaps_verify_btree(struct xfs_mount *mp, xfs_agnumber_t agno);
 
 extern int64_t rmap_diffkeys(struct xfs_rmap_irec *kp1,
@@ -60,4 +60,7 @@ void rmap_free_mem_cursor(struct xfs_trans *tp, struct rmap_mem_cur *rmcur,
 		int error);
 int rmap_get_mem_rec(struct rmap_mem_cur *rmcur, struct xfs_rmap_irec *irec);
 
+bool is_rtrmap_inode(xfs_ino_t ino);
+xfs_ino_t rtgroup_rmap_ino(struct xfs_rtgroup *rtg);
+
 #endif /* RMAP_H_ */
diff --git a/repair/scan.c b/repair/scan.c
index 09ca037f47d..40e8007e698 100644
--- a/repair/scan.c
+++ b/repair/scan.c
@@ -1355,7 +1355,7 @@ _("out of order key %u in %s btree block (%u/%u)\n"),
 
 out:
 	if (suspect)
-		rmap_avoid_check();
+		rmap_avoid_check(mp);
 }
 
 int
@@ -1735,7 +1735,7 @@ _("bad %s btree ptr 0x%llx in ino %" PRIu64 "\n"),
 
 out:
 	if (hdr_errors || suspect) {
-		rmap_avoid_check();
+		rmap_avoid_check(mp);
 		return 1;
 	}
 	return 0;
@@ -2816,7 +2816,7 @@ validate_agf(
 		if (levels == 0 || levels > mp->m_rmap_maxlevels) {
 			do_warn(_("bad levels %u for rmapbt root, agno %d\n"),
 				levels, agno);
-			rmap_avoid_check();
+			rmap_avoid_check(mp);
 		}
 
 		bno = be32_to_cpu(agf->agf_roots[XFS_BTNUM_RMAP]);
@@ -2831,7 +2831,7 @@ validate_agf(
 		} else {
 			do_warn(_("bad agbno %u for rmapbt root, agno %d\n"),
 				bno, agno);
-			rmap_avoid_check();
+			rmap_avoid_check(mp);
 		}
 	}
 

