Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75905195
	for <linux-xfs@vger.kernel.org>; Fri, 23 Aug 2024 00:11:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724371877; cv=none; b=Eo0YJwl2xsJLkaCrzsiUK7REox6Yxk6jac0xxlyrQVhu4fOvi3vaERYsDJCErc/2TGn6+yHX4yi61DdpT92baekWnNYj+DysWllY4eVYIDAtA6jMXDb/tuFzoTLlOqDl8vj+JPv5qMzIRzpWwqBiUdS6dbH/1PQ7fHFowElJonw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724371877; c=relaxed/simple;
	bh=otpFKQNJJrxGcu4mH8bRc3tS27jAQRfem2c3NNk7oFE=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kuw8072Cx66Jhnio9V/hofgEpujT6mpiZVjV5j4zWtLEjnBXmEoDBNm7vS6CcDJDkOoe7MBa5qLGdfT2YkPxzzrTcHftwAZWPu8QjEeByH5Sqei3I407uG87bt30vwKO8EFMjDUHqraXSoDnFjmDYeAk1xfYVW4017wG4Bq1vP4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YVjsqjtb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YVjsqjtb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05097C32782;
	Fri, 23 Aug 2024 00:11:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724371877;
	bh=otpFKQNJJrxGcu4mH8bRc3tS27jAQRfem2c3NNk7oFE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=YVjsqjtbaHTfUlFpfBomH/i2orfUd5OOL7KRJSpBS0BGuSkjF+bUbDOx52oDseU4P
	 Xssz8gvmAJpwNqi+rT5S9AgkvhQTr1KoZ7l5nazW1wEpg7oEdQ72CHyhvX+cwOSU+M
	 +EJZ+G/uZQb5XtblYB8vllZwrGZXtH2jlQjverZpPgKDVOljAHfEUwsPxqUbjXmIYT
	 z+8u3m/5i2FWuMtLyO/b+3QhzqDwzjOc7uaXO8PvPAlgJpQliIlbNUCv2eUkB4Xljz
	 I1A8Hs6NdX+QnosYjS2nFmUJi5QAASNm4JPabUG7jnTCU/3RlV/K68rZWWR2v35+KN
	 5tjKfS6B3PvcA==
Date: Thu, 22 Aug 2024 17:11:16 -0700
Subject: [PATCH 09/12] xfs: factor out a xfs_growfs_rt_bmblock helper
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <172437086174.58604.171404452828623959.stgit@frogsfrogsfrogs>
In-Reply-To: <172437085987.58604.7735951538617329546.stgit@frogsfrogsfrogs>
References: <172437085987.58604.7735951538617329546.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Christoph Hellwig <hch@lst.de>

Add a helper to contain the per-rtbitmap block logic in xfs_growfs_rt.

Note that this helper now allocates a new fake mount structure for
each rtbitmap block iteration instead of reusing the memory for an
entire growfs call.  Compared to all the other work done when freeing
the blocks the overhead for this is in the noise and it keeps the code
nicely modular.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_rtalloc.c |  317 +++++++++++++++++++++++++-------------------------
 1 file changed, 158 insertions(+), 159 deletions(-)


diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index a98e22c76280b..5a637166cc788 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -807,9 +807,148 @@ xfs_growfs_rt_fixup_extsize(
 	return error;
 }
 
-/*
- * Visible (exported) functions.
- */
+static int
+xfs_growfs_rt_bmblock(
+	struct xfs_mount	*mp,
+	xfs_rfsblock_t		nrblocks,
+	xfs_agblock_t		rextsize,
+	xfs_fileoff_t		bmbno)
+{
+	struct xfs_inode	*rbmip = mp->m_rbmip;
+	struct xfs_inode	*rsumip = mp->m_rsumip;
+	struct xfs_rtalloc_args	args = {
+		.mp		= mp,
+	};
+	struct xfs_rtalloc_args	nargs = {
+	};
+	struct xfs_mount	*nmp;
+	xfs_rfsblock_t		nrblocks_step;
+	xfs_rtbxlen_t		freed_rtx;
+	int			error;
+
+
+	nrblocks_step = (bmbno + 1) * NBBY * mp->m_sb.sb_blocksize * rextsize;
+
+	nmp = nargs.mp = kmemdup(mp, sizeof(*mp), GFP_KERNEL);
+	if (!nmp)
+		return -ENOMEM;
+
+	/*
+	 * Calculate new sb and mount fields for this round.
+	 */
+	nmp->m_rtxblklog = -1; /* don't use shift or masking */
+	nmp->m_sb.sb_rextsize = rextsize;
+	nmp->m_sb.sb_rbmblocks = bmbno + 1;
+	nmp->m_sb.sb_rblocks = min(nrblocks, nrblocks_step);
+	nmp->m_sb.sb_rextents = xfs_rtb_to_rtx(nmp, nmp->m_sb.sb_rblocks);
+	nmp->m_sb.sb_rextslog = xfs_compute_rextslog(nmp->m_sb.sb_rextents);
+	nmp->m_rsumlevels = nmp->m_sb.sb_rextslog + 1;
+	nmp->m_rsumsize = XFS_FSB_TO_B(mp,
+		xfs_rtsummary_blockcount(mp, nmp->m_rsumlevels,
+			nmp->m_sb.sb_rbmblocks));
+
+	/* recompute growfsrt reservation from new rsumsize */
+	xfs_trans_resv_calc(nmp, &nmp->m_resv);
+
+	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_growrtfree, 0, 0, 0,
+			&args.tp);
+	if (error)
+		goto out_free;
+	nargs.tp = args.tp;
+
+	xfs_rtbitmap_lock(args.tp, mp);
+
+	/*
+	 * Update the bitmap inode's size ondisk and incore.  We need to update
+	 * the incore size so that inode inactivation won't punch what it thinks
+	 * are "posteof" blocks.
+	 */
+	rbmip->i_disk_size = nmp->m_sb.sb_rbmblocks * nmp->m_sb.sb_blocksize;
+	i_size_write(VFS_I(rbmip), rbmip->i_disk_size);
+	xfs_trans_log_inode(args.tp, rbmip, XFS_ILOG_CORE);
+
+	/*
+	 * Update the summary inode's size.  We need to update the incore size
+	 * so that inode inactivation won't punch what it thinks are "posteof"
+	 * blocks.
+	 */
+	rsumip->i_disk_size = nmp->m_rsumsize;
+	i_size_write(VFS_I(rsumip), rsumip->i_disk_size);
+	xfs_trans_log_inode(args.tp, rsumip, XFS_ILOG_CORE);
+
+	/*
+	 * Copy summary data from old to new sizes when the real size (not
+	 * block-aligned) changes.
+	 */
+	if (mp->m_sb.sb_rbmblocks != nmp->m_sb.sb_rbmblocks ||
+	    mp->m_rsumlevels != nmp->m_rsumlevels) {
+		error = xfs_rtcopy_summary(&args, &nargs);
+		if (error)
+			goto out_cancel;
+	}
+
+	/*
+	 * Update superblock fields.
+	 */
+	if (nmp->m_sb.sb_rextsize != mp->m_sb.sb_rextsize)
+		xfs_trans_mod_sb(args.tp, XFS_TRANS_SB_REXTSIZE,
+			nmp->m_sb.sb_rextsize - mp->m_sb.sb_rextsize);
+	if (nmp->m_sb.sb_rbmblocks != mp->m_sb.sb_rbmblocks)
+		xfs_trans_mod_sb(args.tp, XFS_TRANS_SB_RBMBLOCKS,
+			nmp->m_sb.sb_rbmblocks - mp->m_sb.sb_rbmblocks);
+	if (nmp->m_sb.sb_rblocks != mp->m_sb.sb_rblocks)
+		xfs_trans_mod_sb(args.tp, XFS_TRANS_SB_RBLOCKS,
+			nmp->m_sb.sb_rblocks - mp->m_sb.sb_rblocks);
+	if (nmp->m_sb.sb_rextents != mp->m_sb.sb_rextents)
+		xfs_trans_mod_sb(args.tp, XFS_TRANS_SB_REXTENTS,
+			nmp->m_sb.sb_rextents - mp->m_sb.sb_rextents);
+	if (nmp->m_sb.sb_rextslog != mp->m_sb.sb_rextslog)
+		xfs_trans_mod_sb(args.tp, XFS_TRANS_SB_REXTSLOG,
+			nmp->m_sb.sb_rextslog - mp->m_sb.sb_rextslog);
+
+	/*
+	 * Free the new extent.
+	 */
+	freed_rtx = nmp->m_sb.sb_rextents - mp->m_sb.sb_rextents;
+	error = xfs_rtfree_range(&nargs, mp->m_sb.sb_rextents, freed_rtx);
+	xfs_rtbuf_cache_relse(&nargs);
+	if (error)
+		goto out_cancel;
+
+	/*
+	 * Mark more blocks free in the superblock.
+	 */
+	xfs_trans_mod_sb(args.tp, XFS_TRANS_SB_FREXTENTS, freed_rtx);
+
+	/*
+	 * Update mp values into the real mp structure.
+	 */
+	mp->m_rsumlevels = nmp->m_rsumlevels;
+	mp->m_rsumsize = nmp->m_rsumsize;
+
+	/*
+	 * Recompute the growfsrt reservation from the new rsumsize.
+	 */
+	xfs_trans_resv_calc(mp, &mp->m_resv);
+
+	error = xfs_trans_commit(args.tp);
+	if (error)
+		goto out_free;
+
+	/*
+	 * Ensure the mount RT feature flag is now set.
+	 */
+	mp->m_features |= XFS_FEAT_REALTIME;
+
+	kfree(nmp);
+	return 0;
+
+out_cancel:
+	xfs_trans_cancel(args.tp);
+out_free:
+	kfree(nmp);
+	return error;
+}
 
 /*
  * Grow the realtime area of the filesystem.
@@ -822,23 +961,14 @@ xfs_growfs_rt(
 	xfs_fileoff_t	bmbno;		/* bitmap block number */
 	struct xfs_buf	*bp;		/* temporary buffer */
 	int		error;		/* error return value */
-	xfs_mount_t	*nmp;		/* new (fake) mount structure */
-	xfs_rfsblock_t	nrblocks;	/* new number of realtime blocks */
 	xfs_extlen_t	nrbmblocks;	/* new number of rt bitmap blocks */
 	xfs_rtxnum_t	nrextents;	/* new number of realtime extents */
-	uint8_t		nrextslog;	/* new log2 of sb_rextents */
 	xfs_extlen_t	nrsumblocks;	/* new number of summary blocks */
-	uint		nrsumlevels;	/* new rt summary levels */
-	uint		nrsumsize;	/* new size of rt summary, bytes */
-	xfs_sb_t	*nsbp;		/* new superblock */
 	xfs_extlen_t	rbmblocks;	/* current number of rt bitmap blocks */
 	xfs_extlen_t	rsumblocks;	/* current number of rt summary blks */
-	xfs_sb_t	*sbp;		/* old superblock */
 	uint8_t		*rsum_cache;	/* old summary cache */
 	xfs_agblock_t	old_rextsize = mp->m_sb.sb_rextsize;
 
-	sbp = &mp->m_sb;
-
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
 
@@ -857,11 +987,10 @@ xfs_growfs_rt(
 		goto out_unlock;
 
 	/* Shrink not supported. */
-	if (in->newblocks <= sbp->sb_rblocks)
+	if (in->newblocks <= mp->m_sb.sb_rblocks)
 		goto out_unlock;
-
 	/* Can only change rt extent size when adding rt volume. */
-	if (sbp->sb_rblocks > 0 && in->extsize != sbp->sb_rextsize)
+	if (mp->m_sb.sb_rblocks > 0 && in->extsize != mp->m_sb.sb_rextsize)
 		goto out_unlock;
 
 	/* Range check the extent size. */
@@ -874,15 +1003,14 @@ xfs_growfs_rt(
 	if (xfs_has_rmapbt(mp) || xfs_has_reflink(mp) || xfs_has_quota(mp))
 		goto out_unlock;
 
-	nrblocks = in->newblocks;
-	error = xfs_sb_validate_fsb_count(sbp, nrblocks);
+	error = xfs_sb_validate_fsb_count(&mp->m_sb, in->newblocks);
 	if (error)
 		goto out_unlock;
 	/*
 	 * Read in the last block of the device, make sure it exists.
 	 */
 	error = xfs_buf_read_uncached(mp->m_rtdev_targp,
-				XFS_FSB_TO_BB(mp, nrblocks - 1),
+				XFS_FSB_TO_BB(mp, in->newblocks - 1),
 				XFS_FSB_TO_BB(mp, 1), 0, &bp, NULL);
 	if (error)
 		goto out_unlock;
@@ -891,17 +1019,15 @@ xfs_growfs_rt(
 	/*
 	 * Calculate new parameters.  These are the final values to be reached.
 	 */
-	nrextents = nrblocks;
-	do_div(nrextents, in->extsize);
+	nrextents = div_u64(in->newblocks, in->extsize);
 	if (nrextents == 0) {
 		error = -EINVAL;
 		goto out_unlock;
 	}
 	nrbmblocks = xfs_rtbitmap_blockcount(mp, nrextents);
-	nrextslog = xfs_compute_rextslog(nrextents);
-	nrsumlevels = nrextslog + 1;
-	nrsumblocks = xfs_rtsummary_blockcount(mp, nrsumlevels, nrbmblocks);
-	nrsumsize = XFS_FSB_TO_B(mp, nrsumblocks);
+	nrsumblocks = xfs_rtsummary_blockcount(mp,
+			xfs_compute_rextslog(nrextents) + 1, nrbmblocks);
+
 	/*
 	 * New summary size can't be more than half the size of
 	 * the log.  This prevents us from getting a log overflow,
@@ -929,149 +1055,27 @@ xfs_growfs_rt(
 		goto out_unlock;
 
 	rsum_cache = mp->m_rsum_cache;
-	if (nrbmblocks != sbp->sb_rbmblocks) {
+	if (nrbmblocks != mp->m_sb.sb_rbmblocks) {
 		error = xfs_alloc_rsum_cache(mp, nrbmblocks);
 		if (error)
 			goto out_unlock;
 	}
 
-	/*
-	 * Allocate a new (fake) mount/sb.
-	 */
-	nmp = kmalloc(sizeof(*nmp), GFP_KERNEL | __GFP_NOFAIL);
 	/*
 	 * Loop over the bitmap blocks.
 	 * We will do everything one bitmap block at a time.
 	 * Skip the current block if it is exactly full.
 	 * This also deals with the case where there were no rtextents before.
 	 */
-	for (bmbno = sbp->sb_rbmblocks -
-		     ((sbp->sb_rextents & ((1 << mp->m_blkbit_log) - 1)) != 0);
-	     bmbno < nrbmblocks;
-	     bmbno++) {
-		struct xfs_rtalloc_args	args = {
-			.mp		= mp,
-		};
-		struct xfs_rtalloc_args	nargs = {
-			.mp		= nmp,
-		};
-		struct xfs_trans	*tp;
-		xfs_rfsblock_t		nrblocks_step;
-
-		*nmp = *mp;
-		nsbp = &nmp->m_sb;
-		/*
-		 * Calculate new sb and mount fields for this round.
-		 */
-		nsbp->sb_rextsize = in->extsize;
-		nmp->m_rtxblklog = -1; /* don't use shift or masking */
-		nsbp->sb_rbmblocks = bmbno + 1;
-		nrblocks_step = (bmbno + 1) * NBBY * nsbp->sb_blocksize *
-				nsbp->sb_rextsize;
-		nsbp->sb_rblocks = min(nrblocks, nrblocks_step);
-		nsbp->sb_rextents = xfs_rtb_to_rtx(nmp, nsbp->sb_rblocks);
-		ASSERT(nsbp->sb_rextents != 0);
-		nsbp->sb_rextslog = xfs_compute_rextslog(nsbp->sb_rextents);
-		nrsumlevels = nmp->m_rsumlevels = nsbp->sb_rextslog + 1;
-		nrsumblocks = xfs_rtsummary_blockcount(mp, nrsumlevels,
-				nsbp->sb_rbmblocks);
-		nmp->m_rsumsize = nrsumsize = XFS_FSB_TO_B(mp, nrsumblocks);
-		/* recompute growfsrt reservation from new rsumsize */
-		xfs_trans_resv_calc(nmp, &nmp->m_resv);
-
-		/*
-		 * Start a transaction, get the log reservation.
-		 */
-		error = xfs_trans_alloc(mp, &M_RES(mp)->tr_growrtfree, 0, 0, 0,
-				&tp);
+	bmbno = mp->m_sb.sb_rbmblocks;
+	if (xfs_rtx_to_rbmword(mp, mp->m_sb.sb_rextents) != 0)
+		bmbno--;
+	for (; bmbno < nrbmblocks; bmbno++) {
+		error = xfs_growfs_rt_bmblock(mp, in->newblocks, in->extsize,
+				bmbno);
 		if (error)
-			break;
-		args.tp = tp;
-		nargs.tp = tp;
-
-		/*
-		 * Lock out other callers by grabbing the bitmap and summary
-		 * inode locks and joining them to the transaction.
-		 */
-		xfs_rtbitmap_lock(tp, mp);
-		/*
-		 * Update the bitmap inode's size ondisk and incore.  We need
-		 * to update the incore size so that inode inactivation won't
-		 * punch what it thinks are "posteof" blocks.
-		 */
-		mp->m_rbmip->i_disk_size =
-			nsbp->sb_rbmblocks * nsbp->sb_blocksize;
-		i_size_write(VFS_I(mp->m_rbmip), mp->m_rbmip->i_disk_size);
-		xfs_trans_log_inode(tp, mp->m_rbmip, XFS_ILOG_CORE);
-		/*
-		 * Update the summary inode's size.  We need to update the
-		 * incore size so that inode inactivation won't punch what it
-		 * thinks are "posteof" blocks.
-		 */
-		mp->m_rsumip->i_disk_size = nmp->m_rsumsize;
-		i_size_write(VFS_I(mp->m_rsumip), mp->m_rsumip->i_disk_size);
-		xfs_trans_log_inode(tp, mp->m_rsumip, XFS_ILOG_CORE);
-		/*
-		 * Copy summary data from old to new sizes.
-		 * Do this when the real size (not block-aligned) changes.
-		 */
-		if (sbp->sb_rbmblocks != nsbp->sb_rbmblocks ||
-		    mp->m_rsumlevels != nmp->m_rsumlevels) {
-			error = xfs_rtcopy_summary(&args, &nargs);
-			if (error)
-				goto error_cancel;
-		}
-		/*
-		 * Update superblock fields.
-		 */
-		if (nsbp->sb_rextsize != sbp->sb_rextsize)
-			xfs_trans_mod_sb(tp, XFS_TRANS_SB_REXTSIZE,
-				nsbp->sb_rextsize - sbp->sb_rextsize);
-		if (nsbp->sb_rbmblocks != sbp->sb_rbmblocks)
-			xfs_trans_mod_sb(tp, XFS_TRANS_SB_RBMBLOCKS,
-				nsbp->sb_rbmblocks - sbp->sb_rbmblocks);
-		if (nsbp->sb_rblocks != sbp->sb_rblocks)
-			xfs_trans_mod_sb(tp, XFS_TRANS_SB_RBLOCKS,
-				nsbp->sb_rblocks - sbp->sb_rblocks);
-		if (nsbp->sb_rextents != sbp->sb_rextents)
-			xfs_trans_mod_sb(tp, XFS_TRANS_SB_REXTENTS,
-				nsbp->sb_rextents - sbp->sb_rextents);
-		if (nsbp->sb_rextslog != sbp->sb_rextslog)
-			xfs_trans_mod_sb(tp, XFS_TRANS_SB_REXTSLOG,
-				nsbp->sb_rextslog - sbp->sb_rextslog);
-		/*
-		 * Free new extent.
-		 */
-		error = xfs_rtfree_range(&nargs, sbp->sb_rextents,
-				nsbp->sb_rextents - sbp->sb_rextents);
-		xfs_rtbuf_cache_relse(&nargs);
-		if (error) {
-error_cancel:
-			xfs_trans_cancel(tp);
-			break;
-		}
-		/*
-		 * Mark more blocks free in the superblock.
-		 */
-		xfs_trans_mod_sb(tp, XFS_TRANS_SB_FREXTENTS,
-			nsbp->sb_rextents - sbp->sb_rextents);
-		/*
-		 * Update mp values into the real mp structure.
-		 */
-		mp->m_rsumlevels = nrsumlevels;
-		mp->m_rsumsize = nrsumsize;
-		/* recompute growfsrt reservation from new rsumsize */
-		xfs_trans_resv_calc(mp, &mp->m_resv);
-
-		error = xfs_trans_commit(tp);
-		if (error)
-			break;
-
-		/* Ensure the mount RT feature flag is now set. */
-		mp->m_features |= XFS_FEAT_REALTIME;
+			goto out_free;
 	}
-	if (error)
-		goto out_free;
 
 	if (old_rextsize != in->extsize) {
 		error = xfs_growfs_rt_fixup_extsize(mp);
@@ -1083,11 +1087,6 @@ xfs_growfs_rt(
 	error = xfs_update_secondary_sbs(mp);
 
 out_free:
-	/*
-	 * Free the fake mp structure.
-	 */
-	kfree(nmp);
-
 	/*
 	 * If we had to allocate a new rsum_cache, we either need to free the
 	 * old one (if we succeeded) or free the new one and restore the old one

