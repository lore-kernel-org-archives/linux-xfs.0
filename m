Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77B5CC4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 01:29:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236094AbiLaB3G (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 20:29:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235752AbiLaB3F (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 20:29:05 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8663C1C93A
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 17:29:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 33FE6B81DD0
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 01:29:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2442C433D2;
        Sat, 31 Dec 2022 01:29:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672450142;
        bh=9esKn37BJ/++77uXwoBht9uWOcjbeeMyeX4LmJiOeHw=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=SJTUOdSZSmxqvwyGanv3VF3h57In0H3kf55TeurDGGEMFfbEIo1YofAZ+vkGzlxVx
         gCwsUi5yS9Q87Be8QDepZCDD1LHUn3QQuR/abFILLQWNgHZB3g7LwY87XkdP41o/tb
         LZUoARtwdXagKajCrPUGilCK2CEvmz4Y2aMnLxnRRCqFEHexTB0RGYkUa7oDdssr67
         PLZZdMW+mm5NHDcLOqm93V8GG9ARY297RaIdfOqRn3vqHmlpYEXD/410ZZlLsV8+rv
         fEGfp7PVcAWw8R+p2xhPCy88JKM1lso0F/XuFa4lBDsAhBlDgwLXfbSHZ5eeosUmET
         cvCsGy4VJH3TA==
Subject: [PATCH 06/22] xfs: grow the realtime section when realtime groups are
 enabled
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:17:53 -0800
Message-ID: <167243867356.712847.17316307632362464090.stgit@magnolia>
In-Reply-To: <167243867242.712847.10106105868862621775.stgit@magnolia>
References: <167243867242.712847.10106105868862621775.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Enable growing the rt section when realtime groups are enabled.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_shared.h |    1 
 fs/xfs/xfs_rtalloc.c       |  139 ++++++++++++++++++++++++++++++++++++++++++--
 fs/xfs/xfs_trans.c         |   10 +++
 fs/xfs/xfs_trans.h         |    1 
 4 files changed, 145 insertions(+), 6 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_shared.h b/fs/xfs/libxfs/xfs_shared.h
index e76e735b1d05..bcdf298889af 100644
--- a/fs/xfs/libxfs/xfs_shared.h
+++ b/fs/xfs/libxfs/xfs_shared.h
@@ -111,6 +111,7 @@ void	xfs_log_get_max_trans_res(struct xfs_mount *mp,
 #define	XFS_TRANS_SB_RBLOCKS		0x00000800
 #define	XFS_TRANS_SB_REXTENTS		0x00001000
 #define	XFS_TRANS_SB_REXTSLOG		0x00002000
+#define XFS_TRANS_SB_RGCOUNT		0x00004000
 
 /*
  * Here we centralize the specification of XFS meta-data buffer reference count
diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 9c842237c452..9d8d91fa0ecf 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -930,6 +930,92 @@ xfs_alloc_rsum_cache(
  * Visible (exported) functions.
  */
 
+static int
+xfs_growfs_rt_free_new(
+	struct xfs_trans	*tp,
+	struct xfs_mount	*nmp,
+	xfs_rtbxlen_t		*freed_rtx)
+{
+	struct xfs_mount	*mp = tp->t_mountp;
+	struct xfs_sb		*sbp = &mp->m_sb;
+	struct xfs_sb		*nsbp = &nmp->m_sb;
+	struct xfs_buf		*bp = NULL;
+	xfs_fileoff_t		sumbno;
+	xfs_rtblock_t		rtbno, next_rtbno;
+	int			error = 0;
+
+	if (!xfs_has_rtgroups(mp)) {
+		*freed_rtx = nsbp->sb_rextents - sbp->sb_rextents;
+		return xfs_rtfree_range(nmp, tp, sbp->sb_rextents, *freed_rtx,
+				&bp, &sumbno);
+	}
+
+	*freed_rtx = 0;
+
+	rtbno = xfs_rtx_to_rtb(nmp, sbp->sb_rextents);
+	next_rtbno = xfs_rtx_to_rtb(nmp, nsbp->sb_rextents);
+	while (rtbno < next_rtbno) {
+		xfs_rtxnum_t	start_rtx, next_rtx;
+		xfs_rtblock_t	next_free_rtbno;
+		xfs_rgnumber_t	rgno;
+		xfs_rgblock_t	rgbno;
+
+		/*
+		 * Compute the first new extent that we want to free, being
+		 * careful to skip past a realtime superblock at the start of
+		 * the new region.
+		 */
+		rgbno = xfs_rtb_to_rgbno(nmp, rtbno, &rgno);
+		if (rgbno == 0) {
+			rtbno += nsbp->sb_rextsize;
+			if (rtbno >= next_rtbno)
+				break;
+		}
+
+		start_rtx = xfs_rtb_to_rtxt(nmp, rtbno);
+
+		/*
+		 * Stop freeing either at the end of the new rt section or at
+		 * the start of the next realtime group.
+		 */
+		next_free_rtbno = xfs_rgbno_to_rtb(nmp, rgno + 1, 0);
+		next_rtx = xfs_rtb_to_rtxt(nmp, next_free_rtbno);
+		next_rtx = min(next_rtx, nsbp->sb_rextents);
+
+		bp = NULL;
+		*freed_rtx += next_rtx - start_rtx;
+		error = xfs_rtfree_range(nmp, tp, start_rtx,
+				next_rtx - start_rtx, &bp, &sumbno);
+		if (error)
+			break;
+
+		rtbno = next_free_rtbno;
+	}
+
+	return error;
+}
+
+static int
+xfs_growfs_rt_init_primary(
+	struct xfs_mount	*mp)
+{
+	struct xfs_buf		*rtsb_bp;
+	int			error;
+
+	error = xfs_buf_get_uncached(mp->m_rtdev_targp, XFS_FSB_TO_BB(mp, 1),
+			0, &rtsb_bp);
+	if (error)
+		return error;
+
+	rtsb_bp->b_maps[0].bm_bn = XFS_RTSB_DADDR;
+	rtsb_bp->b_ops = &xfs_rtsb_buf_ops;
+
+	xfs_rtgroup_update_super(rtsb_bp, mp->m_sb_bp);
+	mp->m_rtsb_bp = rtsb_bp;
+	xfs_buf_unlock(rtsb_bp);
+	return 0;
+}
+
 /*
  * Grow the realtime area of the filesystem.
  */
@@ -953,8 +1039,8 @@ xfs_growfs_rt(
 	xfs_extlen_t	rbmblocks;	/* current number of rt bitmap blocks */
 	xfs_extlen_t	rsumblocks;	/* current number of rt summary blks */
 	xfs_sb_t	*sbp;		/* old superblock */
-	xfs_fileoff_t	sumbno;		/* summary block number */
 	uint8_t		*rsum_cache;	/* old summary cache */
+	xfs_rgnumber_t	new_rgcount = 0;
 
 	sbp = &mp->m_sb;
 
@@ -1019,6 +1105,30 @@ xfs_growfs_rt(
 	 */
 	if (nrsumblocks > (mp->m_sb.sb_logblocks >> 1))
 		return -EINVAL;
+
+	/* Allocate the new rt group structures */
+	if (xfs_has_rtgroups(mp)) {
+		/*
+		 * We don't support changing the group size to match the extent
+		 * size, even if the size of the rt section is currently zero.
+		 */
+		if (mp->m_sb.sb_rgblocks % in->extsize != 0)
+			return -EOPNOTSUPP;
+
+		if (mp->m_sb.sb_rblocks == 0) {
+			error = xfs_growfs_rt_init_primary(mp);
+			if (error)
+				return error;
+		}
+
+		new_rgcount = howmany_64(nrblocks, mp->m_sb.sb_rgblocks);
+		if (new_rgcount > mp->m_sb.sb_rgcount) {
+			error = xfs_initialize_rtgroups(mp, new_rgcount);
+			if (error)
+				return error;
+		}
+	}
+
 	/*
 	 * Get the old block counts for bitmap and summary inodes.
 	 * These can't change since other growfs callers are locked out.
@@ -1054,7 +1164,10 @@ xfs_growfs_rt(
 	     bmbno < nrbmblocks;
 	     bmbno++) {
 		struct xfs_trans	*tp;
+		struct xfs_rtgroup	*rtg;
 		xfs_rfsblock_t		nrblocks_step;
+		xfs_rtbxlen_t		freed_rtx = 0;
+		xfs_rgnumber_t		last_rgno = mp->m_sb.sb_rgcount - 1;
 
 		*nmp = *mp;
 		nsbp = &nmp->m_sb;
@@ -1074,6 +1187,11 @@ xfs_growfs_rt(
 		nrsumblocks = xfs_rtsummary_blockcount(mp, nrsumlevels,
 				nsbp->sb_rbmblocks);
 		nmp->m_rsumsize = nrsumsize = XFS_FSB_TO_B(mp, nrsumblocks);
+
+		if (xfs_has_rtgroups(mp))
+			nsbp->sb_rgcount = howmany_64(nsbp->sb_rblocks,
+						      nsbp->sb_rgblocks);
+
 		/*
 		 * Start a transaction, get the log reservation.
 		 */
@@ -1113,6 +1231,7 @@ xfs_growfs_rt(
 			if (error)
 				goto error_cancel;
 		}
+
 		/*
 		 * Update superblock fields.
 		 */
@@ -1131,12 +1250,13 @@ xfs_growfs_rt(
 		if (nsbp->sb_rextslog != sbp->sb_rextslog)
 			xfs_trans_mod_sb(tp, XFS_TRANS_SB_REXTSLOG,
 				nsbp->sb_rextslog - sbp->sb_rextslog);
+		if (nsbp->sb_rgcount != sbp->sb_rgcount)
+			xfs_trans_mod_sb(tp, XFS_TRANS_SB_RGCOUNT,
+				nsbp->sb_rgcount - sbp->sb_rgcount);
 		/*
 		 * Free new extent.
 		 */
-		bp = NULL;
-		error = xfs_rtfree_range(nmp, tp, sbp->sb_rextents,
-			nsbp->sb_rextents - sbp->sb_rextents, &bp, &sumbno);
+		error = xfs_growfs_rt_free_new(tp, nmp, &freed_rtx);
 		if (error) {
 error_cancel:
 			xfs_trans_cancel(tp);
@@ -1145,8 +1265,7 @@ xfs_growfs_rt(
 		/*
 		 * Mark more blocks free in the superblock.
 		 */
-		xfs_trans_mod_sb(tp, XFS_TRANS_SB_FREXTENTS,
-			nsbp->sb_rextents - sbp->sb_rextents);
+		xfs_trans_mod_sb(tp, XFS_TRANS_SB_FREXTENTS, freed_rtx);
 		/*
 		 * Update mp values into the real mp structure.
 		 */
@@ -1157,6 +1276,10 @@ xfs_growfs_rt(
 		if (error)
 			break;
 
+		for_each_rtgroup_from(mp, last_rgno, rtg)
+			rtg->rtg_blockcount = xfs_rtgroup_block_count(mp,
+								rtg->rtg_rgno);
+
 		/* Ensure the mount RT feature flag is now set. */
 		mp->m_features |= XFS_FEAT_REALTIME;
 	}
@@ -1165,6 +1288,10 @@ xfs_growfs_rt(
 
 	/* Update secondary superblocks now the physical grow has completed */
 	error = xfs_update_secondary_sbs(mp);
+	if (error)
+		goto out_free;
+
+	error = xfs_rtgroup_update_secondary_sbs(mp);
 
 out_free:
 	/*
diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index 979aba1b2fc8..a6f46cd9e60c 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -510,6 +510,10 @@ xfs_trans_mod_sb(
 	case XFS_TRANS_SB_REXTSLOG:
 		tp->t_rextslog_delta += delta;
 		break;
+	case XFS_TRANS_SB_RGCOUNT:
+		ASSERT(delta > 0);
+		tp->t_rgcount_delta += delta;
+		break;
 	default:
 		ASSERT(0);
 		return;
@@ -615,6 +619,11 @@ xfs_trans_apply_sb_deltas(
 		whole = 1;
 		update_rtsb = true;
 	}
+	if (tp->t_rgcount_delta) {
+		be32_add_cpu(&sbp->sb_rgcount, tp->t_rgcount_delta);
+		whole = 1;
+		update_rtsb = true;
+	}
 
 	xfs_trans_buf_set_type(tp, bp, XFS_BLFT_SB_BUF);
 	if (whole)
@@ -728,6 +737,7 @@ xfs_trans_unreserve_and_mod_sb(
 	mp->m_sb.sb_rblocks += tp->t_rblocks_delta;
 	mp->m_sb.sb_rextents += tp->t_rextents_delta;
 	mp->m_sb.sb_rextslog += tp->t_rextslog_delta;
+	mp->m_sb.sb_rgcount += tp->t_rgcount_delta;
 	spin_unlock(&mp->m_sb_lock);
 
 	/*
diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
index 37cde68f3a31..efa7eace0859 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -150,6 +150,7 @@ typedef struct xfs_trans {
 	int64_t			t_rblocks_delta;/* superblock rblocks change */
 	int64_t			t_rextents_delta;/* superblocks rextents chg */
 	int64_t			t_rextslog_delta;/* superblocks rextslog chg */
+	int64_t			t_rgcount_delta; /* realtime group count */
 	struct list_head	t_items;	/* log item descriptors */
 	struct list_head	t_busy;		/* list of busy extents */
 	struct list_head	t_dfops;	/* deferred operations */

