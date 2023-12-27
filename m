Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CD197F9
	for <linux-xfs@vger.kernel.org>; Mon,  1 Jan 2024 00:20:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="A0vdkPmC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABF5BC433C7;
	Mon,  1 Jan 2024 00:20:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704068425;
	bh=xYdWHZmnNQgaVHlIQtsmhVwB7mYll8OOUQns408KLfQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=A0vdkPmCN5o6XoOtZmSP4J37emX/G+mN5vnPBVSHDH5yHAy1lFSdOQSh78Iz5wHcX
	 iZYm3sUnYrS7I3kqkhY5XKZwEQOHknkisf0Ja1Ad32oXh5+ujZlT+j3WO0AWrW6BXx
	 VHeAm6yNEcNrpBdeFpkywtQIWqJODqm3Yv5k9w4fHY0t91AMOfRddWJgdVjh4h/vp2
	 8YmqIl1lUr0B71ZWRrvQ47EVjksZbI1Y39U+N6/FPNWZTZt5gyVrg3YyAsPMyB119c
	 zJ2fOmqmersAnHG+UNnLRGScQAa9FCC19kJGyNlK+GXPIPaKGi7uEoL6mDDr9AAvnF
	 zB/T+/KKNAw7A==
Date: Sun, 31 Dec 2023 16:20:25 +9900
Subject: [PATCH 38/47] xfs_repair: find and mark the rtrmapbt inodes
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405015819.1815505.14152731473765009714.stgit@frogsfrogsfrogs>
In-Reply-To: <170405015275.1815505.16749821217116487639.stgit@frogsfrogsfrogs>
References: <170405015275.1815505.16749821217116487639.stgit@frogsfrogsfrogs>
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

Make sure that we find the realtime rmapbt inodes and mark them
appropriately, just in case we find a rogue inode claiming to be an
rtrmap, or garbage in the metadata directory tree.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 repair/dino_chunks.c |   13 +++++
 repair/dinode.c      |   42 ++++++++++++++++-
 repair/dir2.c        |    4 ++
 repair/incore.h      |    1 
 repair/rmap.c        |  123 +++++++++++++++++++++++++++++++++++++++++++++++++-
 repair/rmap.h        |    5 ++
 repair/scan.c        |    8 ++-
 7 files changed, 187 insertions(+), 9 deletions(-)


diff --git a/repair/dino_chunks.c b/repair/dino_chunks.c
index d132556d9dc..b7a5879bf4b 100644
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
@@ -1012,6 +1014,17 @@ process_inode_chunk(
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
index 450f19eba4f..e08b23a9454 100644
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
 	if (!(dip->di_flags2 & be64_to_cpu(XFS_DIFLAG2_METADIR))) {
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
@@ -1954,6 +1981,14 @@ _("bad attr fork offset %d in dev inode %" PRIu64 ", should be %d\n"),
 			return 1;
 		}
 		break;
+	case XFS_DINODE_FMT_RMAP:
+		if (!(xfs_has_metadir(mp) && xfs_has_parent(mp))) {
+			do_warn(
+_("metadata inode %" PRIu64 " type %d cannot have attr fork\n"),
+				lino, dino->di_format);
+			return 1;
+		}
+		fallthrough;
 	case XFS_DINODE_FMT_LOCAL:
 	case XFS_DINODE_FMT_EXTENTS:
 	case XFS_DINODE_FMT_BTREE:
@@ -3050,6 +3085,8 @@ _("bad (negative) size %" PRId64 " on inode %" PRIu64 "\n"),
 			type = XR_INO_GQUOTA;
 		else if (lino == mp->m_sb.sb_pquotino)
 			type = XR_INO_PQUOTA;
+		else if (is_rtrmap_inode(lino))
+			type = XR_INO_RTRMAP;
 		else
 			type = XR_INO_DATA;
 		break;
@@ -3155,6 +3192,7 @@ _("Bad CoW extent size %u on inode %" PRIu64 ", "),
 		case XR_INO_UQUOTA:
 		case XR_INO_GQUOTA:
 		case XR_INO_PQUOTA:
+		case XR_INO_RTRMAP:
 			/*
 			 * This inode was recognized as being filesystem
 			 * metadata, so preserve the inode and its contents for
diff --git a/repair/dir2.c b/repair/dir2.c
index a7f5018fba2..43229b3cd9b 100644
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
@@ -154,6 +156,8 @@ is_meta_ino(
 		reason = _("realtime bitmap");
 	else if (lino == mp->m_sb.sb_rsumino)
 		reason = _("realtime summary");
+	else if (is_rtrmap_inode(lino))
+		reason = _("realtime rmap");
 	else if (lino == mp->m_sb.sb_uquotino)
 		reason = _("user quota");
 	else if (lino == mp->m_sb.sb_gquotino)
diff --git a/repair/incore.h b/repair/incore.h
index 645cc5317c8..6ee7a662930 100644
--- a/repair/incore.h
+++ b/repair/incore.h
@@ -221,6 +221,7 @@ int		count_bcnt_extents(xfs_agnumber_t);
 #define XR_INO_UQUOTA	12		/* user quota inode */
 #define XR_INO_GQUOTA	13		/* group quota inode */
 #define XR_INO_PQUOTA	14		/* project quota inode */
+#define XR_INO_RTRMAP	15		/* realtime rmap */
 
 /* inode allocation tree */
 
diff --git a/repair/rmap.c b/repair/rmap.c
index aa47013baec..b7e7fbe3f47 100644
--- a/repair/rmap.c
+++ b/repair/rmap.c
@@ -33,6 +33,12 @@ struct xfs_ag_rmap {
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
@@ -40,6 +46,9 @@ static struct xfs_ag_rmap *rg_rmaps;
 bool rmapbt_suspect;
 static bool refcbt_suspect;
 
+/* Bitmap of rt group rmap inodes reachable via /realtime/$rgno.rmap. */
+static struct bitmap	*rmap_inodes;
+
 static struct xfs_ag_rmap *rmaps_for_group(bool isrt, unsigned int group)
 {
 	if (isrt)
@@ -116,6 +125,7 @@ rmaps_init_rt(
 	if (error)
 		goto nomem;
 
+	ag_rmap->rg_rmap_ino = NULLFSINO;
 	return;
 nomem:
 	do_error(
@@ -163,6 +173,90 @@ rmaps_init_ag(
 _("Insufficient memory while allocating realtime reverse mapping btree."));
 }
 
+static inline int
+set_rtgroup_rmap_inode(
+	struct xfs_mount	*mp,
+	xfs_rgnumber_t		rgno)
+{
+	struct xfs_imeta_path	*path;
+	struct xfs_ag_rmap	*ar = rmaps_for_group(true, rgno);
+	struct xfs_trans	*tp;
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
+	error = -libxfs_trans_alloc_empty(mp, &tp);
+	if (error)
+		goto out_path;
+
+	error = -libxfs_imeta_lookup(tp, path, &ino);
+	if (error)
+		goto out_trans;
+
+	if (ino == NULLFSINO || bitmap_test(rmap_inodes, ino, 1)) {
+		error = EFSCORRUPTED;
+		goto out_trans;
+	}
+
+	error = bitmap_set(rmap_inodes, ino, 1);
+	if (error)
+		goto out_trans;
+
+	ar->rg_rmap_ino = ino;
+
+out_trans:
+	libxfs_trans_cancel(tp);
+out_path:
+	libxfs_imeta_free_path(path);
+	return error;
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
@@ -188,6 +282,8 @@ rmaps_init(
 
 	for (i = 0; i < mp->m_sb.sb_rgcount; i++)
 		rmaps_init_rt(mp, i, &rg_rmaps[i]);
+
+	discover_rtgroup_inodes(mp);
 }
 
 /*
@@ -202,6 +298,8 @@ rmaps_free(
 	if (!rmap_needs_work(mp))
 		return;
 
+	free_rtmeta_inode_bitmaps();
+
 	for (i = 0; i < mp->m_sb.sb_rgcount; i++)
 		rmaps_destroy(mp, &rg_rmaps[i]);
 	free(rg_rmaps);
@@ -1148,11 +1246,22 @@ rmap_record_count(
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
 
@@ -1831,3 +1940,13 @@ estimate_refcountbt_blocks(
 	return libxfs_refcountbt_calc_size(mp,
 			slab_count(x->ar_refcount_items));
 }
+
+/* Retrieve the rtrmapbt inode number for a given rtgroup. */
+xfs_ino_t
+rtgroup_rmap_ino(
+	struct xfs_rtgroup	*rtg)
+{
+	struct xfs_ag_rmap	*ar = rmaps_for_group(true, rtg->rtg_rgno);
+
+	return ar->rg_rmap_ino;
+}
diff --git a/repair/rmap.h b/repair/rmap.h
index 7a94ed6f90a..dd55ba3cc29 100644
--- a/repair/rmap.h
+++ b/repair/rmap.h
@@ -28,7 +28,7 @@ int rmap_commit_agbtree_mappings(struct xfs_mount *mp, xfs_agnumber_t agno);
 
 uint64_t rmap_record_count(struct xfs_mount *mp, bool isrt,
 		xfs_agnumber_t agno);
-extern void rmap_avoid_check(void);
+extern void rmap_avoid_check(struct xfs_mount *mp);
 void rmaps_verify_btree(struct xfs_mount *mp, xfs_agnumber_t agno);
 
 extern int64_t rmap_diffkeys(struct xfs_rmap_irec *kp1,
@@ -63,4 +63,7 @@ void rmap_free_mem_cursor(struct xfs_trans *tp, struct rmap_mem_cur *rmcur,
 		int error);
 int rmap_get_mem_rec(struct rmap_mem_cur *rmcur, struct xfs_rmap_irec *irec);
 
+bool is_rtrmap_inode(xfs_ino_t ino);
+xfs_ino_t rtgroup_rmap_ino(struct xfs_rtgroup *rtg);
+
 #endif /* RMAP_H_ */
diff --git a/repair/scan.c b/repair/scan.c
index 27aeb341bf3..2f414898078 100644
--- a/repair/scan.c
+++ b/repair/scan.c
@@ -1357,7 +1357,7 @@ _("out of order key %u in %s btree block (%u/%u)\n"),
 
 out:
 	if (suspect)
-		rmap_avoid_check();
+		rmap_avoid_check(mp);
 }
 
 int
@@ -1737,7 +1737,7 @@ _("bad %s btree ptr 0x%llx in ino %" PRIu64 "\n"),
 
 out:
 	if (hdr_errors || suspect) {
-		rmap_avoid_check();
+		rmap_avoid_check(mp);
 		return 1;
 	}
 	return 0;
@@ -2818,7 +2818,7 @@ validate_agf(
 		if (levels == 0 || levels > mp->m_rmap_maxlevels) {
 			do_warn(_("bad levels %u for rmapbt root, agno %d\n"),
 				levels, agno);
-			rmap_avoid_check();
+			rmap_avoid_check(mp);
 		}
 
 		bno = be32_to_cpu(agf->agf_roots[XFS_BTNUM_RMAP]);
@@ -2833,7 +2833,7 @@ validate_agf(
 		} else {
 			do_warn(_("bad agbno %u for rmapbt root, agno %d\n"),
 				bno, agno);
-			rmap_avoid_check();
+			rmap_avoid_check(mp);
 		}
 	}
 

