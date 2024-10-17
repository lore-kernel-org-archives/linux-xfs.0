Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8130C219CA6
	for <linux-xfs@vger.kernel.org>; Thu, 17 Oct 2024 19:05:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729191905; cv=none; b=tW8R5XDj8XgPnecnnO96o7Rc7Ng9ySYp4xDX5xYNdBIhLug8QJdkG1yIgYRO5xE0XdlnuEAlJaMgOyvRIDJUU8BV/jpvy3Rozxx9bxBjmU51bTIqTji64qhOuEK1STM8DTHN0/grTDpN7BQHJTRgQQ29FKv5YcibWW8tPEIZZGQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729191905; c=relaxed/simple;
	bh=Kf4OGCBwEryZinaVODl+gy8LCKsEetfQ/nDiw2Jr15M=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UeUeEW075pNVbTlPYNF6BQpBl3b9cO8b+yNiXn55pUys7XevsTwCKhhnijxM3S9HkGZohFbTN8Bevbj61mlOWX6H55QjY2wGn7e2Ca3kxa2pqkRIT34IuKgH94/VxPjJFCndox5h2Hct8zbKBVJYJi4St70C2fUPakMrkzkpDr0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aj5kwcLs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aj5kwcLs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0ED17C4CEC3;
	Thu, 17 Oct 2024 19:05:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729191905;
	bh=Kf4OGCBwEryZinaVODl+gy8LCKsEetfQ/nDiw2Jr15M=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=aj5kwcLs2zInkX4zKDgCpN3LvPqpwdD5qvNYTZMIyiLD4rwZSEKrE/7wDwUmuZ4sj
	 ktqCA/Q4M98WeBbDAyT7fbXCRwnRnIKkw3qOCyEVSxJBplJj+knVnyIsBnJOmgTk+i
	 CuN+gjBy4428TkuslHnlLFgl9HwyVIl0exqpSNnP+bNX7PO1+fEobPH+mwpbXsmnUo
	 jngnK9wgB5bWrWjv0ZFLF4FY4EWcW0W0PpVRNXjjeEn3Ltd/rltv9ucGwK8XNxRVGM
	 i9F+XiCfmoCS5So+pHnc22mvQVjJOLuUuRcjpF8oYwn2jgNZVJTzsff+QwUQutIfLl
	 9f8bnNvYaltLw==
Date: Thu, 17 Oct 2024 12:05:04 -0700
Subject: [PATCH 07/34] xfs: add frextents to the lazysbcounters when rtgroups
 enabled
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <172919071787.3453179.10280926363632024087.stgit@frogsfrogsfrogs>
In-Reply-To: <172919071571.3453179.15753475627202483418.stgit@frogsfrogsfrogs>
References: <172919071571.3453179.15753475627202483418.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Make the free rt extent count a part of the lazy sb counters when the
realtime groups feature is enabled.  This is possible because the patch
to recompute frextents from the rtbitmap during log recovery predates
the code adding rtgroup support, hence we know that the value will
always be correct during runtime.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_sb.c           |   15 ++++++++++-----
 fs/xfs/scrub/fscounters_repair.c |    9 +++++----
 fs/xfs/xfs_trans.c               |   33 +++++++++++++++++++--------------
 3 files changed, 34 insertions(+), 23 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index b1e12c7e7dbe23..d5bf886e18ab9e 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -1152,11 +1152,6 @@ xfs_log_sb(
 	 * reservations that have been taken out percpu counters. If we have an
 	 * unclean shutdown, this will be corrected by log recovery rebuilding
 	 * the counters from the AGF block counts.
-	 *
-	 * Do not update sb_frextents here because it is not part of the lazy
-	 * sb counters, despite having a percpu counter. It is always kept
-	 * consistent with the ondisk rtbitmap by xfs_trans_apply_sb_deltas()
-	 * and hence we don't need have to update it here.
 	 */
 	if (xfs_has_lazysbcount(mp)) {
 		mp->m_sb.sb_icount = percpu_counter_sum_positive(&mp->m_icount);
@@ -1167,6 +1162,16 @@ xfs_log_sb(
 				percpu_counter_sum_positive(&mp->m_fdblocks);
 	}
 
+	/*
+	 * sb_frextents was added to the lazy sb counters when the rt groups
+	 * feature was introduced.  This counter can go negative due to the way
+	 * we handle nearly-lockless reservations, so we must use the _positive
+	 * variant here to avoid writing out nonsense frextents.
+	 */
+	if (xfs_has_rtgroups(mp))
+		mp->m_sb.sb_frextents =
+				percpu_counter_sum_positive(&mp->m_frextents);
+
 	xfs_sb_to_disk(bp->b_addr, &mp->m_sb);
 	xfs_trans_buf_set_type(tp, bp, XFS_BLFT_SB_BUF);
 	xfs_trans_log_buf(tp, bp, 0, sizeof(struct xfs_dsb) - 1);
diff --git a/fs/xfs/scrub/fscounters_repair.c b/fs/xfs/scrub/fscounters_repair.c
index 469bf645dbea52..cda13447a373e1 100644
--- a/fs/xfs/scrub/fscounters_repair.c
+++ b/fs/xfs/scrub/fscounters_repair.c
@@ -68,15 +68,16 @@ xrep_fscounters(
 
 	/*
 	 * Online repair is only supported on v5 file systems, which require
-	 * lazy sb counters and thus no update of sb_fdblocks here.  But as of
-	 * now we don't support lazy counting sb_frextents yet, and thus need
-	 * to also update it directly here.  And for that we need to keep
+	 * lazy sb counters and thus no update of sb_fdblocks here.  But
+	 * sb_frextents only uses a lazy counter with rtgroups, and thus needs
+	 * to be updated directly here otherwise.  And for that we need to keep
 	 * track of the delalloc reservations separately, as they are are
 	 * subtracted from m_frextents, but not included in sb_frextents.
 	 */
 	percpu_counter_set(&mp->m_frextents,
 		fsc->frextents - fsc->frextents_delayed);
-	mp->m_sb.sb_frextents = fsc->frextents;
+	if (!xfs_has_rtgroups(mp))
+		mp->m_sb.sb_frextents = fsc->frextents;
 
 	return 0;
 }
diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index 118d31e11127be..01b5f5b32af467 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -421,6 +421,8 @@ xfs_trans_mod_sb(
 			ASSERT(tp->t_rtx_res_used <= tp->t_rtx_res);
 		}
 		tp->t_frextents_delta += delta;
+		if (xfs_has_rtgroups(mp))
+			flags &= ~XFS_TRANS_SB_DIRTY;
 		break;
 	case XFS_TRANS_SB_RES_FREXTENTS:
 		/*
@@ -430,6 +432,8 @@ xfs_trans_mod_sb(
 		 */
 		ASSERT(delta < 0);
 		tp->t_res_frextents_delta += delta;
+		if (xfs_has_rtgroups(mp))
+			flags &= ~XFS_TRANS_SB_DIRTY;
 		break;
 	case XFS_TRANS_SB_DBLOCKS:
 		tp->t_dblocks_delta += delta;
@@ -498,20 +502,22 @@ xfs_trans_apply_sb_deltas(
 	}
 
 	/*
-	 * Updating frextents requires careful handling because it does not
-	 * behave like the lazysb counters because we cannot rely on log
-	 * recovery in older kenels to recompute the value from the rtbitmap.
-	 * This means that the ondisk frextents must be consistent with the
-	 * rtbitmap.
+	 * sb_frextents was added to the lazy sb counters when the rt groups
+	 * feature was introduced.  This is possible because we know that all
+	 * kernels supporting rtgroups will also recompute frextents from the
+	 * realtime bitmap.
+	 *
+	 * For older file systems, updating frextents requires careful handling
+	 * because we cannot rely on log recovery in older kernels to recompute
+	 * the value from the rtbitmap.  This means that the ondisk frextents
+	 * must be consistent with the rtbitmap.
 	 *
 	 * Therefore, log the frextents change to the ondisk superblock and
 	 * update the incore superblock so that future calls to xfs_log_sb
 	 * write the correct value ondisk.
-	 *
-	 * Don't touch m_frextents because it includes incore reservations,
-	 * and those are handled by the unreserve function.
 	 */
-	if (tp->t_frextents_delta || tp->t_res_frextents_delta) {
+	if ((tp->t_frextents_delta || tp->t_res_frextents_delta) &&
+	    !xfs_has_rtgroups(tp->t_mountp)) {
 		struct xfs_mount	*mp = tp->t_mountp;
 		int64_t			rtxdelta;
 
@@ -619,7 +625,7 @@ xfs_trans_unreserve_and_mod_sb(
 	}
 
 	ASSERT(tp->t_rtx_res || tp->t_frextents_delta >= 0);
-	if (tp->t_flags & XFS_TRANS_SB_DIRTY) {
+	if (xfs_has_rtgroups(mp) || (tp->t_flags & XFS_TRANS_SB_DIRTY)) {
 		rtxdelta += tp->t_frextents_delta;
 		ASSERT(rtxdelta >= 0);
 	}
@@ -652,10 +658,9 @@ xfs_trans_unreserve_and_mod_sb(
 	mp->m_sb.sb_icount += idelta;
 	mp->m_sb.sb_ifree += ifreedelta;
 	/*
-	 * Do not touch sb_frextents here because we are dealing with incore
-	 * reservation.  sb_frextents is not part of the lazy sb counters so it
-	 * must be consistent with the ondisk rtbitmap and must never include
-	 * incore reservations.
+	 * Do not touch sb_frextents here because it is handled in
+	 * xfs_trans_apply_sb_deltas for file systems where it isn't a lazy
+	 * counter anyway.
 	 */
 	mp->m_sb.sb_dblocks += tp->t_dblocks_delta;
 	mp->m_sb.sb_agcount += tp->t_agcount_delta;

