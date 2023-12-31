Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AC14C2D4
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 23:53:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lhZL2ebI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4ECEC433C8;
	Sun, 31 Dec 2023 23:53:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704066829;
	bh=jsui6U3e7jPSqOW2vzTLhdWnmXxzY23yN/TA6nb4jqE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=lhZL2ebIjTZhrMjM9fJYQL+MIICtuzseSiMpbkl633BInbTJIUGF+z57AmL0ZsN8s
	 DdBrQ3XDL1ZdEgmUmzf/HJI85tLy7PFdnuO8/K75cM6YCZFpTTdqcH6TKgkDdnqA8Y
	 EVCQFbeYzQog9tZxp6Fn+2QvMJiX2Ag89BlZpPsP3c1KTjGGxPFtMP+skvct4wgX1O
	 U/MOGbccX3ODeIiiOIaboZkkfHdYN64T6KOJT2YR90oBoL8bJsiRILFdUzDl5OZp7d
	 9t7G3EKnNNH9XfKMd5fFr5hjbvAj3Bbfp3CGFedlgt2Hxy7VL5oqF7MSIwxxZTcWo+
	 Ph2nIUDQFAl9Q==
Date: Sun, 31 Dec 2023 15:53:49 -0800
Subject: [PATCH 24/52] xfs_repair: support realtime groups
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405012487.1811243.8409225834961277648.stgit@frogsfrogsfrogs>
In-Reply-To: <170405012128.1811243.5724050972228209086.stgit@frogsfrogsfrogs>
References: <170405012128.1811243.5724050972228209086.stgit@frogsfrogsfrogs>
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

Support the realtime group feature.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/libxfs_api_defs.h |    2 +
 repair/agheader.c        |    2 +
 repair/incore.c          |   22 +++++++++++++++
 repair/phase3.c          |    3 ++
 repair/rt.c              |   69 ++++++++++++++++++++++++++++++++++++++++++++++
 repair/rt.h              |    3 ++
 repair/sb.c              |   37 +++++++++++++++++++++++++
 repair/xfs_repair.c      |   11 +++++++
 8 files changed, 149 insertions(+)


diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index fff0e6d0f60..a3503e07984 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -283,6 +283,8 @@
 #define xfs_rtsummary_wordcount		libxfs_rtsummary_wordcount
 
 #define xfs_rtfree_extent		libxfs_rtfree_extent
+#define xfs_rtgroup_update_secondary_sbs	libxfs_rtgroup_update_secondary_sbs
+#define xfs_rtgroup_update_super	libxfs_rtgroup_update_super
 #define xfs_sb_from_disk		libxfs_sb_from_disk
 #define xfs_sb_quota_from_disk		libxfs_sb_quota_from_disk
 #define xfs_sb_read_secondary		libxfs_sb_read_secondary
diff --git a/repair/agheader.c b/repair/agheader.c
index af88802ffdf..076860a4451 100644
--- a/repair/agheader.c
+++ b/repair/agheader.c
@@ -412,6 +412,8 @@ secondary_sb_whack(
 			 * super byte for byte.
 			 */
 			sb->sb_metadirino = mp->m_sb.sb_metadirino;
+			sb->sb_rgblocks = mp->m_sb.sb_rgblocks;
+			sb->sb_rgcount = mp->m_sb.sb_rgcount;
 		} else
 			do_warn(
 	_("would zero unused portion of %s superblock (AG #%u)\n"),
diff --git a/repair/incore.c b/repair/incore.c
index 06edaf0d605..27457a7c17e 100644
--- a/repair/incore.c
+++ b/repair/incore.c
@@ -195,6 +195,25 @@ set_rtbmap(
 	 (((uint64_t) state) << ((rtx % XR_BB_NUM) * XR_BB)));
 }
 
+static void
+rtgroups_init(
+	struct xfs_mount	*mp)
+{
+	xfs_rgnumber_t		rgno;
+
+	if (!xfs_has_rtgroups(mp) || !rt_bmap)
+		return;
+
+	for (rgno = 0; rgno < mp->m_sb.sb_rgcount; rgno++) {
+		xfs_rtblock_t	start_rtx;
+
+		start_rtx = xfs_rgbno_to_rtb(mp, rgno, 0) /
+				mp->m_sb.sb_rextsize;
+
+		set_rtbmap(start_rtx, XR_E_INUSE_FS);
+	}
+}
+
 static void
 reset_rt_bmap(void)
 {
@@ -219,6 +238,8 @@ init_rt_bmap(
 			mp->m_sb.sb_rextents);
 		return;
 	}
+
+	rtgroups_init(mp);
 }
 
 static void
@@ -271,6 +292,7 @@ reset_bmaps(xfs_mount_t *mp)
 	}
 
 	reset_rt_bmap();
+	rtgroups_init(mp);
 }
 
 void
diff --git a/repair/phase3.c b/repair/phase3.c
index ca4dbee4743..19490dbe9bb 100644
--- a/repair/phase3.c
+++ b/repair/phase3.c
@@ -17,6 +17,7 @@
 #include "progress.h"
 #include "bmap.h"
 #include "threads.h"
+#include "rt.h"
 
 static void
 process_agi_unlinked(
@@ -116,6 +117,8 @@ phase3(
 
 	set_progress_msg(PROG_FMT_AGI_UNLINKED, (uint64_t) glob_agcount);
 
+	check_rtsupers(mp);
+
 	/* first clear the agi unlinked AGI list */
 	if (!no_modify) {
 		for (i = 0; i < mp->m_sb.sb_agcount; i++)
diff --git a/repair/rt.c b/repair/rt.c
index ded968b7d82..5576511e7a0 100644
--- a/repair/rt.c
+++ b/repair/rt.c
@@ -239,3 +239,72 @@ check_rtsummary(
 	check_rtfile_contents(mp, "rtsummary", mp->m_sb.sb_rsumino, sumcompute,
 			XFS_B_TO_FSB(mp, mp->m_rsumsize));
 }
+
+void
+check_rtsupers(
+	struct xfs_mount	*mp)
+{
+	struct xfs_buf		*bp;
+	xfs_rtblock_t		rtbno;
+	xfs_rgnumber_t		rgno;
+	int			error;
+
+	if (!xfs_has_rtgroups(mp))
+		return;
+
+	for (rgno = 0; rgno < mp->m_sb.sb_rgcount; rgno++) {
+		rtbno = xfs_rgbno_to_rtb(mp, rgno, 0);
+		error = -libxfs_buf_read_uncached(mp->m_rtdev_targp,
+				xfs_rtb_to_daddr(mp, rtbno),
+				XFS_FSB_TO_BB(mp, 1), 0, &bp,
+				&xfs_rtsb_buf_ops);
+		if (!error) {
+			libxfs_buf_relse(bp);
+			continue;
+		}
+
+		if (no_modify) {
+			do_warn(
+	_("would rewrite realtime group %u superblock\n"),
+					rgno);
+		} else {
+			do_warn(
+	_("will rewrite realtime group %u superblock\n"),
+					rgno);
+			/*
+			 * Rewrite the primary rt superblock before an update
+			 * to the primary fs superblock trips over the rt super
+			 * being corrupt.
+			 */
+			if (rgno == 0)
+				rewrite_primary_rt_super(mp);
+		}
+	}
+}
+
+void
+rewrite_primary_rt_super(
+	struct xfs_mount	*mp)
+{
+	struct xfs_buf		*rtsb_bp;
+	struct xfs_buf		*sb_bp = libxfs_getsb(mp);
+	int			error;
+
+	if (!sb_bp)
+		do_error(
+ _("couldn't grab primary sb to update rt superblocks\n"));
+
+	error = -libxfs_buf_get_uncached(mp->m_rtdev_targp,
+			XFS_FSB_TO_BB(mp, 1), 0, &rtsb_bp);
+	if (error)
+		do_error(
+ _("couldn't grab primary rt superblock\n"));
+
+	rtsb_bp->b_maps[0].bm_bn = XFS_RTSB_DADDR;
+	rtsb_bp->b_ops = &xfs_rtsb_buf_ops;
+
+	libxfs_rtgroup_update_super(rtsb_bp, sb_bp);
+	libxfs_buf_mark_dirty(rtsb_bp);
+	libxfs_buf_relse(rtsb_bp);
+	libxfs_buf_relse(sb_bp);
+}
diff --git a/repair/rt.h b/repair/rt.h
index 862695487bc..912150ce8be 100644
--- a/repair/rt.h
+++ b/repair/rt.h
@@ -16,5 +16,8 @@ int generate_rtinfo(struct xfs_mount *mp, union xfs_rtword_raw *words,
 
 void check_rtbitmap(struct xfs_mount *mp);
 void check_rtsummary(struct xfs_mount *mp);
+void check_rtsupers(struct xfs_mount *mp);
+
+void rewrite_primary_rt_super(struct xfs_mount *mp);
 
 #endif /* _XFS_REPAIR_RT_H_ */
diff --git a/repair/sb.c b/repair/sb.c
index 32602d84f3c..b0f85e9cff8 100644
--- a/repair/sb.c
+++ b/repair/sb.c
@@ -312,6 +312,37 @@ verify_sb_loginfo(
 	return true;
 }
 
+static int
+verify_sb_rtgroups(
+	struct xfs_sb		*sbp)
+{
+	uint64_t		groups;
+
+	if (!(sbp->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_METADIR))
+		return XR_BAD_RT_GEO_DATA;
+
+	if (sbp->sb_rgblocks > XFS_MAX_RGBLOCKS)
+		return XR_BAD_RT_GEO_DATA;
+
+	if (sbp->sb_rextsize == 0)
+		return XR_BAD_RT_GEO_DATA;
+
+	if (sbp->sb_rgblocks % sbp->sb_rextsize != 0)
+		return XR_BAD_RT_GEO_DATA;
+
+	if (sbp->sb_rgblocks < (sbp->sb_rextsize << 1))
+		return XR_BAD_RT_GEO_DATA;
+
+	if (sbp->sb_rgcount > XFS_MAX_RGNUMBER)
+		return XR_BAD_RT_GEO_DATA;
+
+	groups = howmany(sbp->sb_rblocks, sbp->sb_rgblocks);
+	if (groups != sbp->sb_rgcount)
+		return XR_BAD_RT_GEO_DATA;
+
+	return 0;
+}
+
 /*
  * verify a superblock -- does not verify root inode #
  *	can only check that geometry info is internally
@@ -520,6 +551,12 @@ verify_sb(char *sb_buf, xfs_sb_t *sb, int is_primary_sb)
 	if (sb->sb_blocklog + sb->sb_dirblklog > XFS_MAX_BLOCKSIZE_LOG)
 		return XR_BAD_DIR_SIZE_DATA;
 
+	if (sb->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_RTGROUPS) {
+		int err = verify_sb_rtgroups(sb);
+		if (err)
+			return err;
+	}
+
 	return(XR_OK);
 }
 
diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
index bab8aa70f7a..811e89317f1 100644
--- a/repair/xfs_repair.c
+++ b/repair/xfs_repair.c
@@ -27,6 +27,7 @@
 #include "bulkload.h"
 #include "quotacheck.h"
 #include "rcbag_btree.h"
+#include "rt.h"
 
 /*
  * option tables for getsubopt calls
@@ -1543,6 +1544,16 @@ _("Note - stripe unit (%d) and width (%d) were copied from a backup superblock.\
 				XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR;
 	}
 
+	/* Always rewrite the realtime superblocks. */
+	if (xfs_has_rtgroups(mp)) {
+		if (mp->m_sb.sb_rgcount > 0)
+			rewrite_primary_rt_super(mp);
+
+		error = -libxfs_rtgroup_update_secondary_sbs(mp);
+		if (error)
+			do_error(_("updating rt superblocks, err %d"), error);
+	}
+
 	/*
 	 * Done. Flush all cached buffers and inodes first to ensure all
 	 * verifiers are run (where we discover the max metadata LSN), reformat

