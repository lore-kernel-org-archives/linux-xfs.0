Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5469FBA22
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 21:17:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="r5qA56yt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBC13C433C7;
	Sun, 31 Dec 2023 21:17:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704057446;
	bh=ocFZXlM/xyYgtYZiF1K/P4uEfPCT/oYOA4/8oW1E+SI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=r5qA56ytkzr5Tv8t/1plzvmR7kd/VY1xfnVZGwdsQKorM03yQRJaVHjTQlenC25Sj
	 2hRVmiSFccOydx5Og9EJi5Ulswb7iqjMP/FMHP+mkG/iGKf+wqMY2ufmMYpOPvpMXH
	 gx/nrH6Fjpc18zZrAW58cKEkxKhayOdVQsXi9QdPy0MnjIF34siDFHmPzDAo84RH1s
	 mmr2X37gd9gINmySkFRVMQ25T1VQPwVOgolYiBdOpxhuly10Pr4p5VkuEYzAZ85uLw
	 bI492rIMnjOaR13uGMBYyW7MZQr2E6dsqp2w0HncrEwKq5Rr8maypVmbQeWGWnEaVb
	 zOkbuE9rvuKgQ==
Date: Sun, 31 Dec 2023 13:17:26 -0800
Subject: [PATCH 07/24] xfs: grow the realtime section when realtime groups are
 enabled
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404846354.1763124.8063727469645216799.stgit@frogsfrogsfrogs>
In-Reply-To: <170404846187.1763124.7316400597964398308.stgit@frogsfrogsfrogs>
References: <170404846187.1763124.7316400597964398308.stgit@frogsfrogsfrogs>
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

Enable growing the rt section when realtime groups are enabled.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_shared.h |    1 
 fs/xfs/xfs_rtalloc.c       |  136 +++++++++++++++++++++++++++++++++++++++++++-
 fs/xfs/xfs_trans.c         |   10 +++
 fs/xfs/xfs_trans.h         |    1 
 4 files changed, 144 insertions(+), 4 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_shared.h b/fs/xfs/libxfs/xfs_shared.h
index f76d2789e1c2d..65691af0488e7 100644
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
index 430d63e5ba751..23a15700d3596 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -902,6 +902,88 @@ xfs_alloc_rsum_cache(
  * Visible (exported) functions.
  */
 
+static int
+xfs_growfs_rt_free_new(
+	struct xfs_mount	*mp,
+	struct xfs_rtalloc_args	*nargs,
+	xfs_rtbxlen_t		*freed_rtx)
+{
+	struct xfs_mount	*nmp = nargs->mp;
+	struct xfs_sb		*sbp = &mp->m_sb;
+	struct xfs_sb		*nsbp = &nmp->m_sb;
+	xfs_rtblock_t		rtbno, next_rtbno;
+	int			error = 0;
+
+	if (!xfs_has_rtgroups(mp)) {
+		*freed_rtx = nsbp->sb_rextents - sbp->sb_rextents;
+		return xfs_rtfree_range(nargs, sbp->sb_rextents, *freed_rtx);
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
+		start_rtx = xfs_rtb_to_rtx(nmp, rtbno);
+
+		/*
+		 * Stop freeing either at the end of the new rt section or at
+		 * the start of the next realtime group.
+		 */
+		next_free_rtbno = xfs_rgbno_to_rtb(nmp, rgno + 1, 0);
+		next_rtx = xfs_rtb_to_rtx(nmp, next_free_rtbno);
+		next_rtx = min(next_rtx, nsbp->sb_rextents);
+
+		*freed_rtx += next_rtx - start_rtx;
+		error = xfs_rtfree_range(nargs, start_rtx,
+				next_rtx - start_rtx);
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
@@ -992,6 +1074,35 @@ xfs_growfs_rt(
 	 */
 	if (nrsumblocks > (mp->m_sb.sb_logblocks >> 1))
 		return -EINVAL;
+
+	/* Allocate the new rt group structures */
+	if (xfs_has_rtgroups(mp)) {
+		uint64_t	new_rgcount;
+
+		new_rgcount = howmany_64(nrblocks, mp->m_sb.sb_rgblocks);
+		if (new_rgcount > XFS_MAX_RGNUMBER)
+			return -EINVAL;
+
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
@@ -1033,7 +1144,10 @@ xfs_growfs_rt(
 			.mp		= nmp,
 		};
 		struct xfs_trans	*tp;
+		struct xfs_rtgroup	*rtg;
 		xfs_rfsblock_t		nrblocks_step;
+		xfs_rtbxlen_t		freed_rtx = 0;
+		xfs_rgnumber_t		last_rgno = mp->m_sb.sb_rgcount - 1;
 
 		*nmp = *mp;
 		nsbp = &nmp->m_sb;
@@ -1057,6 +1171,10 @@ xfs_growfs_rt(
 		/* recompute growfsrt reservation from new rsumsize */
 		xfs_trans_resv_calc(nmp, &nmp->m_resv);
 
+		if (xfs_has_rtgroups(mp))
+			nsbp->sb_rgcount = howmany_64(nsbp->sb_rblocks,
+						      nsbp->sb_rgblocks);
+
 		/*
 		 * Start a transaction, get the log reservation.
 		 */
@@ -1099,6 +1217,7 @@ xfs_growfs_rt(
 			if (error)
 				goto error_cancel;
 		}
+
 		/*
 		 * Update superblock fields.
 		 */
@@ -1117,11 +1236,13 @@ xfs_growfs_rt(
 		if (nsbp->sb_rextslog != sbp->sb_rextslog)
 			xfs_trans_mod_sb(tp, XFS_TRANS_SB_REXTSLOG,
 				nsbp->sb_rextslog - sbp->sb_rextslog);
+		if (nsbp->sb_rgcount != sbp->sb_rgcount)
+			xfs_trans_mod_sb(tp, XFS_TRANS_SB_RGCOUNT,
+				nsbp->sb_rgcount - sbp->sb_rgcount);
 		/*
 		 * Free new extent.
 		 */
-		error = xfs_rtfree_range(&nargs, sbp->sb_rextents,
-				nsbp->sb_rextents - sbp->sb_rextents);
+		error = xfs_growfs_rt_free_new(mp, &nargs, &freed_rtx);
 		xfs_rtbuf_cache_relse(&nargs);
 		if (error) {
 error_cancel:
@@ -1131,8 +1252,7 @@ xfs_growfs_rt(
 		/*
 		 * Mark more blocks free in the superblock.
 		 */
-		xfs_trans_mod_sb(tp, XFS_TRANS_SB_FREXTENTS,
-			nsbp->sb_rextents - sbp->sb_rextents);
+		xfs_trans_mod_sb(tp, XFS_TRANS_SB_FREXTENTS, freed_rtx);
 		/*
 		 * Update mp values into the real mp structure.
 		 */
@@ -1145,6 +1265,10 @@ xfs_growfs_rt(
 		if (error)
 			break;
 
+		for_each_rtgroup_from(mp, last_rgno, rtg)
+			rtg->rtg_blockcount = xfs_rtgroup_block_count(mp,
+								rtg->rtg_rgno);
+
 		/* Ensure the mount RT feature flag is now set. */
 		mp->m_features |= XFS_FEAT_REALTIME;
 	}
@@ -1153,6 +1277,10 @@ xfs_growfs_rt(
 
 	/* Update secondary superblocks now the physical grow has completed */
 	error = xfs_update_secondary_sbs(mp);
+	if (error)
+		goto out_free;
+
+	error = xfs_rtgroup_update_secondary_sbs(mp);
 
 out_free:
 	/*
diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index fab625f64189f..1eaf32422bf66 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -456,6 +456,10 @@ xfs_trans_mod_sb(
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
@@ -561,6 +565,11 @@ xfs_trans_apply_sb_deltas(
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
@@ -674,6 +683,7 @@ xfs_trans_unreserve_and_mod_sb(
 	mp->m_sb.sb_rblocks += tp->t_rblocks_delta;
 	mp->m_sb.sb_rextents += tp->t_rextents_delta;
 	mp->m_sb.sb_rextslog += tp->t_rextslog_delta;
+	mp->m_sb.sb_rgcount += tp->t_rgcount_delta;
 	spin_unlock(&mp->m_sb_lock);
 
 	/*
diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
index f3ddb05f3bcc6..2046ee06fe88f 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -146,6 +146,7 @@ typedef struct xfs_trans {
 	int64_t			t_rblocks_delta;/* superblock rblocks change */
 	int64_t			t_rextents_delta;/* superblocks rextents chg */
 	int64_t			t_rextslog_delta;/* superblocks rextslog chg */
+	int64_t			t_rgcount_delta; /* realtime group count */
 	struct list_head	t_items;	/* log item descriptors */
 	struct list_head	t_busy;		/* list of busy extents */
 	struct list_head	t_dfops;	/* deferred operations */

