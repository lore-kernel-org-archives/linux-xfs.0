Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3E17BA2B
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 21:18:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DDeaSkIZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F4C9C433C7;
	Sun, 31 Dec 2023 21:18:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704057509;
	bh=SnOyY19T959CG09L7R9Nip3ljHw5aPePNAVvannmheo=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=DDeaSkIZeCBXs894pP9/+kTb3MA7Z76Qdv+hX8WLr0JxFBivijqICztXlzzXd4ynf
	 z1IYnAJ74QX7Fu87B/gxqg+/vVd4i43OvRZiDvtSiqmPDNMBVBr9Z8yKgbpRtYe/uM
	 SJWTk/mM60sfbP5GPKAOnk4Oc/w5trREuNXH0K2kYbXZt4GTUoZCUnXNYPiBBdA29A
	 kg/T/AbeLD/j67ns7WiRSBXL8CYKK1iQGNO4SBJNCJc3+lYfTY5usth9YvJ3KQCWWQ
	 IqBtqnntoxoiPiSn77H6zdGyIXzl67VHDvX/sHDBeZbf/dh/7+bFQcfci4yLsKLKa2
	 PLRkZ4zKuts3Q==
Date: Sun, 31 Dec 2023 13:18:29 -0800
Subject: [PATCH 11/24] xfs: add frextents to the lazysbcounters when rtgroups
 enabled
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404846417.1763124.7673702968469339561.stgit@frogsfrogsfrogs>
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

Make the free rt extent count a part of the lazy sb counters when the
realtime groups feature is enabled.  This is possible because the patch
to recompute frextents from the rtbitmap during log recovery predates
the code adding rtgroup support, hence we know that the value will
always be correct during runtime.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_sb.c |    5 +++++
 fs/xfs/xfs_trans.c     |   18 +++++++++++++++---
 2 files changed, 20 insertions(+), 3 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index cf94417aa9faa..da20189bbe199 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -1150,6 +1150,9 @@ xfs_log_sb(
 	 * sb counters, despite having a percpu counter. It is always kept
 	 * consistent with the ondisk rtbitmap by xfs_trans_apply_sb_deltas()
 	 * and hence we don't need have to update it here.
+	 *
+	 * sb_frextents was added to the lazy sb counters when the rt groups
+	 * feature was introduced.
 	 */
 	if (xfs_has_lazysbcount(mp)) {
 		mp->m_sb.sb_icount = percpu_counter_sum(&mp->m_icount);
@@ -1158,6 +1161,8 @@ xfs_log_sb(
 				mp->m_sb.sb_icount);
 		mp->m_sb.sb_fdblocks = percpu_counter_sum(&mp->m_fdblocks);
 	}
+	if (xfs_has_rtgroups(mp))
+		mp->m_sb.sb_frextents = percpu_counter_sum(&mp->m_frextents);
 
 	xfs_sb_to_disk(bp->b_addr, &mp->m_sb);
 	xfs_trans_buf_set_type(tp, bp, XFS_BLFT_SB_BUF);
diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index 1eaf32422bf66..d4952be8f2498 100644
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
@@ -515,8 +517,14 @@ xfs_trans_apply_sb_deltas(
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
 
@@ -630,7 +638,8 @@ xfs_trans_unreserve_and_mod_sb(
 	if (tp->t_rtx_res > 0)
 		rtxdelta = tp->t_rtx_res;
 	if ((tp->t_frextents_delta != 0) &&
-	    (tp->t_flags & XFS_TRANS_SB_DIRTY))
+	    (xfs_has_rtgroups(mp) ||
+	     (tp->t_flags & XFS_TRANS_SB_DIRTY)))
 		rtxdelta += tp->t_frextents_delta;
 
 	if (xfs_has_lazysbcount(mp) ||
@@ -669,8 +678,11 @@ xfs_trans_unreserve_and_mod_sb(
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

