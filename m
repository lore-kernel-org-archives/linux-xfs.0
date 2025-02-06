Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA6632417C9
	for <linux-xfs@vger.kernel.org>; Thu,  6 Feb 2025 22:54:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738882466; cv=none; b=X+3Rm/bF4CYL7wfejXNSLhy0vZZPrkXBWhV3xQ0vQGy038zrjflRtjgKYzOPAhOHbZQlGNduo1Znciu5BEdX6l59KDojt2RyzzyOo9tsx6SN8Fou40z6eHmHvmNA/ceyw1zh5BP+dcw0NoV9gmEds/MMHLEvlu10+BIXvaz5Z6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738882466; c=relaxed/simple;
	bh=TJYoE7+mbCNc5YFWQmSgcoS8HoGSFVgqLMk3lB/ecBQ=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LI5WBxug/olVOSO20kVGgBoelqz/oSK/KIU3VX6caUhvrKjuhvRaIrXplqD8PSurIO9doY/iyMyjlzPfaNd/fPLBP4obfQTJ1qd2sHhDR38H4GpC3KmxR+/DhaqaMHGtx/+8nxa0c6FLCGApL4r4Dg0mHztrb7a+cMVhDO4Q1eM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KYrt8obm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KYrt8obm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E06FC4CEDD;
	Thu,  6 Feb 2025 22:54:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738882466;
	bh=TJYoE7+mbCNc5YFWQmSgcoS8HoGSFVgqLMk3lB/ecBQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=KYrt8obmQLGyzDQIBdfjNGKu3L0cEwTw0XqLtVbTWfBNZDcjpboMlpdMUXcaBLLpK
	 neN4Y6QoE6jSH62bNNicI5GeeY4cC370zvNiXSEkdpGon6V9l9Vq1TQseeOl+u26Td
	 NpmYXe7ozQ4LlEjMI2aYPA6uSUGusu3n3/PNd+CyctzA1Mf9cnZy7EvXQzwpgStFNu
	 SRxZ9HsbToyybZbdZbfpvQb2TwRYE+qml6AuLIZX6M0vOiNYCgiKTnnlpre5fl9DuO
	 tWw6aJl3h2QtUZugQbbHqfQvkFe5fznbsRROlfuwRXc6FXqOBDQ7sdpUfW858YqguK
	 RXNGlVq2QYlPQ==
Date: Thu, 06 Feb 2025 14:54:25 -0800
Subject: [PATCH 18/27] xfs_repair: find and mark the rtrmapbt inodes
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173888088371.2741033.14204258331206705184.stgit@frogsfrogsfrogs>
In-Reply-To: <173888088056.2741033.17433872323468891160.stgit@frogsfrogsfrogs>
References: <173888088056.2741033.17433872323468891160.stgit@frogsfrogsfrogs>
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

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 repair/dino_chunks.c |   13 ++++++++++
 repair/dinode.c      |   65 +++++++++++++++++++++++++++++++++++++++++++++-----
 repair/dir2.c        |    7 +++++
 repair/incore.h      |    1 +
 repair/rmap.c        |   19 ++++++---------
 repair/rmap.h        |    5 ++--
 repair/scan.c        |    8 +++---
 7 files changed, 95 insertions(+), 23 deletions(-)


diff --git a/repair/dino_chunks.c b/repair/dino_chunks.c
index fe106f0b6ab536..8c5387cdf4ea52 100644
--- a/repair/dino_chunks.c
+++ b/repair/dino_chunks.c
@@ -16,6 +16,8 @@
 #include "prefetch.h"
 #include "progress.h"
 #include "rt.h"
+#include "slab.h"
+#include "rmap.h"
 
 /*
  * validates inode block or chunk, returns # of good inodes
@@ -1023,6 +1025,17 @@ process_inode_chunk(
 	_("would clear rtgroup summary inode %" PRIu64 "\n"),
 						ino);
 				}
+			} else if (is_rtrmap_inode(ino)) {
+				rmap_avoid_check(mp);
+				if (!no_modify)  {
+					do_warn(
+	_("cleared rtgroup rmap inode %" PRIu64 "\n"),
+						ino);
+				} else  {
+					do_warn(
+	_("would clear rtgroup rmap inode %" PRIu64 "\n"),
+						ino);
+				}
 			} else if (!no_modify)  {
 				do_warn(_("cleared inode %" PRIu64 "\n"),
 					ino);
diff --git a/repair/dinode.c b/repair/dinode.c
index 628f02714abc05..58691b196bc4cb 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -178,6 +178,9 @@ clear_dinode(
 
 	if (is_rtsummary_inode(ino_num))
 		mark_rtgroup_inodes_bad(mp, XFS_RTGI_SUMMARY);
+
+	if (is_rtrmap_inode(ino_num))
+		rmap_avoid_check(mp);
 }
 
 /*
@@ -823,6 +826,14 @@ get_agino_buf(
 	return bp;
 }
 
+static inline xfs_rgnumber_t
+metafile_rgnumber(
+	const struct xfs_dinode	*dip)
+{
+	return (xfs_rgnumber_t)be16_to_cpu(dip->di_projid_hi) << 16 |
+			       be16_to_cpu(dip->di_projid_lo);
+}
+
 /*
  * higher level inode processing stuff starts here:
  * first, one utility routine for each type of inode
@@ -870,7 +881,10 @@ process_rtrmap(
 
 	lino = XFS_AGINO_TO_INO(mp, agno, ino);
 
-	/* This rmap btree inode must be a metadata inode. */
+	/*
+	 * This rmap btree inode must be a metadata inode reachable via
+	 * /rtgroups/$rgno.rmap in the metadata directory tree.
+	 */
 	if (!(dip->di_flags2 & be64_to_cpu(XFS_DIFLAG2_METADATA))) {
 		do_warn(
 _("rtrmap inode %" PRIu64 " not flagged as metadata\n"),
@@ -878,11 +892,25 @@ _("rtrmap inode %" PRIu64 " not flagged as metadata\n"),
 		return 1;
 	}
 
-	if (!is_rtrmap_inode(lino)) {
-		do_warn(
+	/*
+	 * If this rtrmap file claims to be from an rtgroup that actually
+	 * exists, check that inode discovery actually found it.  Note that
+	 * we can have stray rtrmap files from failed growfsrt operations.
+	 */
+	if (metafile_rgnumber(dip) < mp->m_sb.sb_rgcount) {
+		if (type != XR_INO_RTRMAP) {
+			do_warn(
+_("rtrmap inode %" PRIu64 " was not found in the metadata directory tree\n"),
+				lino);
+			return 1;
+		}
+
+		if (!is_rtrmap_inode(lino)) {
+			do_warn(
 _("could not associate rtrmap inode %" PRIu64 " with any rtgroup\n"),
-			lino);
-		return 1;
+				lino);
+			return 1;
+		}
 	}
 
 	memset(&priv.high_key, 0xFF, sizeof(priv.high_key));
@@ -921,7 +949,7 @@ _("computed size of rtrmapbt root (%zu bytes) is greater than space in "
 		error = process_rtrmap_reclist(mp, rp, numrecs,
 				&priv.last_rec, NULL, "rtrmapbt root");
 		if (error) {
-			rmap_avoid_check();
+			rmap_avoid_check(mp);
 			return 1;
 		}
 		return 0;
@@ -1891,6 +1919,9 @@ process_check_metadata_inodes(
 	if (lino == mp->m_sb.sb_rbmino || is_rtbitmap_inode(lino))
 		return process_check_rt_inode(mp, dinoc, lino, type, dirty,
 				XR_INO_RTBITMAP, _("realtime bitmap"));
+	if (is_rtrmap_inode(lino))
+		return process_check_rt_inode(mp, dinoc, lino, type, dirty,
+				XR_INO_RTRMAP, _("realtime rmap btree"));
 	return 0;
 }
 
@@ -1989,6 +2020,18 @@ _("realtime summary inode %" PRIu64 " has bad size %" PRIu64 " (should be %" PRI
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
@@ -2017,6 +2060,14 @@ _("bad attr fork offset %d in dev inode %" PRIu64 ", should be %d\n"),
 			return 1;
 		}
 		break;
+	case XFS_DINODE_FMT_META_BTREE:
+		if (!xfs_has_metadir(mp) || !xfs_has_parent(mp)) {
+			do_warn(
+_("metadata inode %" PRIu64 " type %d cannot have attr fork\n"),
+				lino, dino->di_format);
+			return 1;
+		}
+		fallthrough;
 	case XFS_DINODE_FMT_LOCAL:
 	case XFS_DINODE_FMT_EXTENTS:
 	case XFS_DINODE_FMT_BTREE:
@@ -3173,6 +3224,8 @@ _("bad (negative) size %" PRId64 " on inode %" PRIu64 "\n"),
 			type = XR_INO_GQUOTA;
 		else if (is_quota_inode(XFS_DQTYPE_PROJ, lino))
 			type = XR_INO_PQUOTA;
+		else if (is_rtrmap_inode(lino))
+			type = XR_INO_RTRMAP;
 		else
 			type = XR_INO_DATA;
 		break;
diff --git a/repair/dir2.c b/repair/dir2.c
index ed615662009957..af00b2d8d6c852 100644
--- a/repair/dir2.c
+++ b/repair/dir2.c
@@ -15,6 +15,8 @@
 #include "da_util.h"
 #include "prefetch.h"
 #include "progress.h"
+#include "slab.h"
+#include "rmap.h"
 #include "rt.h"
 
 /*
@@ -277,6 +279,9 @@ process_sf_dir2(
 		} else if (lino == mp->m_sb.sb_metadirino)  {
 			junkit = 1;
 			junkreason = _("metadata directory root");
+		} else if (is_rtrmap_inode(lino)) {
+			junkit = 1;
+			junkreason = _("realtime rmap");
 		} else if ((irec_p = find_inode_rec(mp,
 					XFS_INO_TO_AGNO(mp, lino),
 					XFS_INO_TO_AGINO(mp, lino))) != NULL) {
@@ -754,6 +759,8 @@ process_dir2_data(
 			clearreason = _("project quota");
 		} else if (ent_ino == mp->m_sb.sb_metadirino)  {
 			clearreason = _("metadata directory root");
+		} else if (is_rtrmap_inode(ent_ino)) {
+			clearreason = _("realtime rmap");
 		} else {
 			irec_p = find_inode_rec(mp,
 						XFS_INO_TO_AGNO(mp, ent_ino),
diff --git a/repair/incore.h b/repair/incore.h
index 61730c330911f7..4add12615e0a04 100644
--- a/repair/incore.h
+++ b/repair/incore.h
@@ -241,6 +241,7 @@ int		count_bcnt_extents(xfs_agnumber_t);
 #define XR_INO_UQUOTA	12		/* user quota inode */
 #define XR_INO_GQUOTA	13		/* group quota inode */
 #define XR_INO_PQUOTA	14		/* project quota inode */
+#define XR_INO_RTRMAP	15		/* realtime rmap */
 
 /* inode allocation tree */
 
diff --git a/repair/rmap.c b/repair/rmap.c
index 13e9a06b04f370..8656c8df3cbc83 100644
--- a/repair/rmap.c
+++ b/repair/rmap.c
@@ -15,6 +15,7 @@
 #include "libfrog/bitmap.h"
 #include "libfrog/platform.h"
 #include "rcbag.h"
+#include "rt.h"
 
 #undef RMAP_DEBUG
 
@@ -169,15 +170,6 @@ rmaps_init_ag(
 _("Insufficient memory while allocating realtime reverse mapping btree."));
 }
 
-xfs_rgnumber_t
-rtgroup_for_rtrmap_inode(
-	struct xfs_mount	*mp,
-	xfs_ino_t		ino)
-{
-	/* This will be implemented later. */
-	return NULLRGNUMBER;
-}
-
 /*
  * Initialize per-AG reverse map data.
  */
@@ -203,6 +195,8 @@ rmaps_init(
 
 	for (i = 0; i < mp->m_sb.sb_rgcount; i++)
 		rmaps_init_rt(mp, i, &rg_rmaps[i]);
+
+	discover_rtgroup_inodes(mp);
 }
 
 /*
@@ -1142,11 +1136,14 @@ rmap_record_count(
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
+	if (xfs_has_rtgroups(mp))
+		mark_rtgroup_inodes_bad(mp, XFS_RTGI_RMAP);
 	rmapbt_suspect = true;
 }
 
diff --git a/repair/rmap.h b/repair/rmap.h
index 23871e6d60e774..b5c8b4f0bef794 100644
--- a/repair/rmap.h
+++ b/repair/rmap.h
@@ -28,7 +28,7 @@ int rmap_commit_agbtree_mappings(struct xfs_mount *mp, xfs_agnumber_t agno);
 
 uint64_t rmap_record_count(struct xfs_mount *mp, bool isrt,
 		xfs_agnumber_t agno);
-extern void rmap_avoid_check(void);
+extern void rmap_avoid_check(struct xfs_mount *mp);
 void rmaps_verify_btree(struct xfs_mount *mp, xfs_agnumber_t agno);
 
 extern int64_t rmap_diffkeys(struct xfs_rmap_irec *kp1,
@@ -56,6 +56,7 @@ int rmap_init_mem_cursor(struct xfs_mount *mp, struct xfs_trans *tp,
 		bool isrt, xfs_agnumber_t agno, struct xfs_btree_cur **rmcurp);
 int rmap_get_mem_rec(struct xfs_btree_cur *rmcur, struct xfs_rmap_irec *irec);
 
-xfs_rgnumber_t rtgroup_for_rtrmap_inode(struct xfs_mount *mp, xfs_ino_t ino);
+void populate_rtgroup_rmapbt(struct xfs_rtgroup *rtg,
+		xfs_filblks_t est_fdblocks);
 
 #endif /* RMAP_H_ */
diff --git a/repair/scan.c b/repair/scan.c
index 386aaa15f78c33..7a74f87c5f0c61 100644
--- a/repair/scan.c
+++ b/repair/scan.c
@@ -1348,7 +1348,7 @@ _("out of order key %u in %s btree block (%u/%u)\n"),
 
 out:
 	if (suspect)
-		rmap_avoid_check();
+		rmap_avoid_check(mp);
 }
 
 int
@@ -1728,7 +1728,7 @@ _("bad %s btree ptr 0x%llx in ino %" PRIu64 "\n"),
 
 out:
 	if (hdr_errors || suspect) {
-		rmap_avoid_check();
+		rmap_avoid_check(mp);
 		return 1;
 	}
 	return 0;
@@ -2811,7 +2811,7 @@ validate_agf(
 		if (levels == 0 || levels > mp->m_rmap_maxlevels) {
 			do_warn(_("bad levels %u for rmapbt root, agno %d\n"),
 				levels, agno);
-			rmap_avoid_check();
+			rmap_avoid_check(mp);
 		}
 
 		bno = be32_to_cpu(agf->agf_rmap_root);
@@ -2826,7 +2826,7 @@ validate_agf(
 		} else {
 			do_warn(_("bad agbno %u for rmapbt root, agno %d\n"),
 				bno, agno);
-			rmap_avoid_check();
+			rmap_avoid_check(mp);
 		}
 	}
 

