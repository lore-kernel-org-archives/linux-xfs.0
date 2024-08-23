Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63823195
	for <linux-xfs@vger.kernel.org>; Fri, 23 Aug 2024 00:23:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724372580; cv=none; b=mRUIqCNB4cvhKfNNDo9f6fYijv42WauaU0y1yvcvbG8HCfWp+arYCWGkAiQUcl2Q/NIXOwZ0yDVtadLKsrqfnobXaqwYZr3qPLnrhgzfcArMHTyEWf+QSCiR3VadCC38iiA/+p/fi0+J2TCHmxYu6qxQm505bIY/C9tWwHCKjh4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724372580; c=relaxed/simple;
	bh=yBbPEYGqoX6v/ndyUJYZggAmV3C/0u8kYXInVej2KQI=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=vAEf4FAPI2dtHIDCjGZiHiT3pDb65mxDJTeNC5STL6ONKZdqJ1QAJU/V/ib8hwDSMnrJZuUCw/KJdp7640vOcZPdJTPPTVK2V4cgRKjWcRA5RIkyZnVnbmaCHQ1qS2Ucfk4vHsG/ExVQJGK5taPjYzQBQZ6QCeaxD7uG1RT5mFc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gbPwnssc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gbPwnssc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4261EC32782;
	Fri, 23 Aug 2024 00:23:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724372580;
	bh=yBbPEYGqoX6v/ndyUJYZggAmV3C/0u8kYXInVej2KQI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=gbPwnsscIyammsqT59XzovYIPCgrlB6qlWgmlAgOTs/OE4J2coyR0P+XLbcA2tvzT
	 lIbRvJSM5YqTjiJtKbbE1jnLRsKiMfbXglYqM5IVRS0+pr3zgNW1j3y3C6HG6lqMa0
	 uwaJ5ueGaUUKNtmS0vIpIO9IVxoZ5lUI2XSnY5GgzgL44ZxzLn3l7bl43/UaZ5Ocib
	 SG5hIm64rTQ309ZEBjX5XZWcrAu3mZ5kogBmD8QuvQ+Ynkf50XOXbHAasqh0Qqm7S4
	 4AnLvY5byQUhQYYNhcTao7+y11l7D2HS3PDPxCZHpuVIGfUtzyejuWFNcTNcKTCWqF
	 DbEMUnPczTiag==
Date: Thu, 22 Aug 2024 17:22:59 -0700
Subject: [PATCH 07/26] xfs: add frextents to the lazysbcounters when rtgroups
 enabled
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <172437088640.60592.9292030505966688400.stgit@frogsfrogsfrogs>
In-Reply-To: <172437088439.60592.14498225725916348568.stgit@frogsfrogsfrogs>
References: <172437088439.60592.14498225725916348568.stgit@frogsfrogsfrogs>
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

Make the free rt extent count a part of the lazy sb counters when the
realtime groups feature is enabled.  This is possible because the patch
to recompute frextents from the rtbitmap during log recovery predates
the code adding rtgroup support, hence we know that the value will
always be correct during runtime.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_sb.c           |    8 ++++++++
 fs/xfs/scrub/fscounters_repair.c |    9 +++++----
 fs/xfs/xfs_trans.c               |   17 ++++++++++++++---
 3 files changed, 27 insertions(+), 7 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index 2a0155d946c1e..109be10c6e84f 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -1146,6 +1146,11 @@ xfs_log_sb(
 	 * sb counters, despite having a percpu counter. It is always kept
 	 * consistent with the ondisk rtbitmap by xfs_trans_apply_sb_deltas()
 	 * and hence we don't need have to update it here.
+	 *
+	 * sb_frextents was added to the lazy sb counters when the rt groups
+	 * feature was introduced.  This counter can go negative due to the way
+	 * we handle nearly-lockless reservations, so we must use the _positive
+	 * variant here to avoid writing out nonsense frextents.
 	 */
 	if (xfs_has_lazysbcount(mp)) {
 		mp->m_sb.sb_icount = percpu_counter_sum_positive(&mp->m_icount);
@@ -1155,6 +1160,9 @@ xfs_log_sb(
 		mp->m_sb.sb_fdblocks =
 				percpu_counter_sum_positive(&mp->m_fdblocks);
 	}
+	if (xfs_has_rtgroups(mp))
+		mp->m_sb.sb_frextents =
+				percpu_counter_sum_positive(&mp->m_frextents);
 
 	xfs_sb_to_disk(bp->b_addr, &mp->m_sb);
 	xfs_trans_buf_set_type(tp, bp, XFS_BLFT_SB_BUF);
diff --git a/fs/xfs/scrub/fscounters_repair.c b/fs/xfs/scrub/fscounters_repair.c
index 469bf645dbea5..cda13447a373e 100644
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
index 5fd1765b3dcd8..552e3a149346c 100644
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
@@ -510,8 +512,14 @@ xfs_trans_apply_sb_deltas(
 	 *
 	 * Don't touch m_frextents because it includes incore reservations,
 	 * and those are handled by the unreserve function.
+	 *
+	 * sb_frextents was added to the lazy sb counters when the rt groups
+	 * feature was introduced.  This is possible because we know that all
+	 * kernels supporting rtgroups will also recompute frextents from the
+	 * realtime bitmap.
 	 */
-	if (tp->t_frextents_delta || tp->t_res_frextents_delta) {
+	if ((tp->t_frextents_delta || tp->t_res_frextents_delta) &&
+	    !xfs_has_rtgroups(tp->t_mountp)) {
 		struct xfs_mount	*mp = tp->t_mountp;
 		int64_t			rtxdelta;
 
@@ -619,7 +627,7 @@ xfs_trans_unreserve_and_mod_sb(
 	}
 
 	ASSERT(tp->t_rtx_res || tp->t_frextents_delta >= 0);
-	if (tp->t_flags & XFS_TRANS_SB_DIRTY) {
+	if (xfs_has_rtgroups(mp) || (tp->t_flags & XFS_TRANS_SB_DIRTY)) {
 		rtxdelta += tp->t_frextents_delta;
 		ASSERT(rtxdelta >= 0);
 	}
@@ -655,8 +663,11 @@ xfs_trans_unreserve_and_mod_sb(
 	 * Do not touch sb_frextents here because we are dealing with incore
 	 * reservation.  sb_frextents is not part of the lazy sb counters so it
 	 * must be consistent with the ondisk rtbitmap and must never include
-	 * incore reservations.
+	 * incore reservations.  sb_frextents was added to the lazy sb counters
+	 * when the realtime groups feature was introduced.
 	 */
+	if (xfs_has_rtgroups(mp))
+		mp->m_sb.sb_frextents += rtxdelta;
 	mp->m_sb.sb_dblocks += tp->t_dblocks_delta;
 	mp->m_sb.sb_agcount += tp->t_agcount_delta;
 	mp->m_sb.sb_imax_pct += tp->t_imaxpct_delta;

