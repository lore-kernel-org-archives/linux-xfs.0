Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD493C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 02:35:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236248AbiLaCfj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 21:35:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236250AbiLaCfd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 21:35:33 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C51326D9
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 18:35:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B0DE2B81E03
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 02:35:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 590C5C433D2;
        Sat, 31 Dec 2022 02:35:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672454129;
        bh=KlCewcb/dQowMGJcSWNVAnrdyJyIeBeth6pa9G1nN9g=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=QJmLgvR+uy0RdgxVW9OvKp8KCIW2jbf/vkHtt2uurmo31jLrgyIIZb4A5D54CMQGL
         A2Yg/xon3Nrgl/4ba5etjSVrM5+ZIl2LnZUQndFT1sH3UYVlSoCIrEJyrSbYpDQ1fn
         1Oc7FismdhG3I3nv93RkuKGWE2V1h8BU3NK265SiSI5bPU+wXwJq8+WeafOC2l1EWT
         mDS2pRL5oJizPdUx0dY96FdPXlhIF9WChvRMSaD4jrWnZI1FrKMJXO8ooQn7wN7iPl
         4QMeva7YIkstg3loFXivIHEUloGpl5qLMPH6xoc/Gp1qGhTToUhcpwZmpKVoQOPNfP
         qu33YI1dBZspg==
Subject: [PATCH 21/45] xfs_repair: support realtime groups
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:19:46 -0800
Message-ID: <167243878639.731133.5264626503934517536.stgit@magnolia>
In-Reply-To: <167243878346.731133.14642166452774753637.stgit@magnolia>
References: <167243878346.731133.14642166452774753637.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

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
index 4d9499529c0..deadfe2c422 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -238,6 +238,8 @@
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
index 56a04c3de6e..33bc6836f71 100644
--- a/repair/rt.c
+++ b/repair/rt.c
@@ -213,3 +213,72 @@ check_rtsummary(
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
index 16b39c21a67..8e8796aa3c1 100644
--- a/repair/rt.h
+++ b/repair/rt.h
@@ -16,5 +16,8 @@ int generate_rtinfo(struct xfs_mount *mp, union xfs_rtword_ondisk *words,
 
 void check_rtbitmap(struct xfs_mount *mp);
 void check_rtsummary(struct xfs_mount *mp);
+void check_rtsupers(struct xfs_mount *mp);
+
+void rewrite_primary_rt_super(struct xfs_mount *mp);
 
 #endif /* _XFS_REPAIR_RT_H_ */
diff --git a/repair/sb.c b/repair/sb.c
index 6e7f448596e..a1cfeff1e91 100644
--- a/repair/sb.c
+++ b/repair/sb.c
@@ -314,6 +314,37 @@ verify_sb_loginfo(
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
@@ -519,6 +550,12 @@ verify_sb(char *sb_buf, xfs_sb_t *sb, int is_primary_sb)
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
index 92dc0fb2d9f..13e1f2deccf 100644
--- a/repair/xfs_repair.c
+++ b/repair/xfs_repair.c
@@ -27,6 +27,7 @@
 #include "bulkload.h"
 #include "quotacheck.h"
 #include "rcbag_btree.h"
+#include "rt.h"
 
 /*
  * option tables for getsubopt calls
@@ -1510,6 +1511,16 @@ _("Note - stripe unit (%d) and width (%d) were copied from a backup superblock.\
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

