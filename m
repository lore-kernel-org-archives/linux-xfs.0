Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 668B9BA34
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 21:16:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FpZn8kaS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39D76C433C7;
	Sun, 31 Dec 2023 21:16:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704057384;
	bh=hTnBwbjAGPp3cUhG0nBI7bBdP1hH/Qzze5u5eXauiug=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=FpZn8kaSypib2sNdTL02eq60eeU/ND+AKnGC1PtDyBXEaHuYiZY2RaJh1dpEFpHRc
	 cpILh39z4x13hZxJmC9uhVP6/Y4G1rI38IRQQ4iLv9RrtP+6d2b/yPIjXa+T+kK26N
	 xazF69jezk7SxeNBMBfNunudJLpClCStqVWbKAQ8+nbSFEM8ywLzhtgH6WaEjrxHvI
	 cM5CCqyJtXa3yZNAyLBBdaZnPJiST0RcWPnRp1Rv1OhEBBVrBSiUjulsCKucON+cpg
	 o94uAkumZZQsh/Ic7YT1VDw7PYjDrI4iinyBHHvKktKWbdW1nl1Sr9VGHfwl1yRpgY
	 UJIXQ8PJrjzuw==
Date: Sun, 31 Dec 2023 13:16:23 -0800
Subject: [PATCH 03/24] xfs: reduce rt summary file levels for rtgroups
 filesystems
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404846290.1763124.4226770473396031658.stgit@frogsfrogsfrogs>
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

The rt summary file is supposed to be large enough to track the number
of log2(rtextentcount) free space extents that start in a given rt
bitmap block.  Prior to rt groups, there could be a single 2^52 block
free extent, which implies a summary file with 53 levels.

However, each rtgroup uses its first rt extent to hold a superblock,
so there can't be any free extents longer than the length of a group.
Groups are limited to 2^32-1 blocks, which means that the longest
freespace will be counted in level 31.  Hence we only need 32 levels.

Adjust the rextslog computation to create smaller rt summary files for
rtgroups filesystems.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_format.h   |    2 +-
 fs/xfs/libxfs/xfs_rtbitmap.c |   11 +++++++++++
 fs/xfs/libxfs/xfs_rtbitmap.h |    4 ++--
 fs/xfs/libxfs/xfs_sb.c       |    2 +-
 fs/xfs/scrub/rtbitmap.c      |    2 +-
 fs/xfs/scrub/rtsummary.c     |    2 +-
 fs/xfs/xfs_rtalloc.c         |    5 +++--
 7 files changed, 20 insertions(+), 8 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index 8debe92571692..43e66740e2aec 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -313,7 +313,7 @@ struct xfs_dsb {
 
 #define	XFS_SB_VERSION_NUM(sbp)	((sbp)->sb_versionnum & XFS_SB_VERSION_NUMBITS)
 
-static inline bool xfs_sb_is_v5(struct xfs_sb *sbp)
+static inline bool xfs_sb_is_v5(const struct xfs_sb *sbp)
 {
 	return XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5;
 }
diff --git a/fs/xfs/libxfs/xfs_rtbitmap.c b/fs/xfs/libxfs/xfs_rtbitmap.c
index 795035556c4b4..a8e5c702a7515 100644
--- a/fs/xfs/libxfs/xfs_rtbitmap.c
+++ b/fs/xfs/libxfs/xfs_rtbitmap.c
@@ -1144,10 +1144,21 @@ xfs_rtbitmap_blockcount(
  */
 uint8_t
 xfs_compute_rextslog(
+	const struct xfs_sb	*sbp,
 	xfs_rtbxlen_t		rtextents)
 {
 	if (!rtextents)
 		return 0;
+
+	/*
+	 * Realtime groups are never larger than 2^32 extents and are never
+	 * fully free, so we can use highbit32 on the number of rtextents per
+	 * group.
+	 */
+	if (xfs_sb_is_v5(sbp) &&
+	    (sbp->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_RTGROUPS))
+		return xfs_highbit32(sbp->sb_rgblocks / sbp->sb_rextsize);
+
 	return xfs_highbit64(rtextents);
 }
 
diff --git a/fs/xfs/libxfs/xfs_rtbitmap.h b/fs/xfs/libxfs/xfs_rtbitmap.h
index 6ac17f0195ea1..3de0ec2d24123 100644
--- a/fs/xfs/libxfs/xfs_rtbitmap.h
+++ b/fs/xfs/libxfs/xfs_rtbitmap.h
@@ -351,7 +351,7 @@ xfs_rtfree_extent(
 int xfs_rtfree_blocks(struct xfs_trans *tp, xfs_fsblock_t rtbno,
 		xfs_filblks_t rtlen);
 
-uint8_t xfs_compute_rextslog(xfs_rtbxlen_t rtextents);
+uint8_t xfs_compute_rextslog(const struct xfs_sb *sbp, xfs_rtbxlen_t rtextents);
 
 /* Do we support an rt volume having this number of rtextents? */
 static inline bool
@@ -396,7 +396,7 @@ void xfs_rtbitmap_unlock_shared(struct xfs_mount *mp,
 # define xfs_rtsummary_read_buf(a,b)			(-ENOSYS)
 # define xfs_rtbuf_cache_relse(a)			(0)
 # define xfs_rtalloc_extent_is_free(m,t,s,l,i)		(-ENOSYS)
-# define xfs_compute_rextslog(rtx)			(0)
+# define xfs_compute_rextslog(sbp, rtx)			(0)
 # define xfs_validate_rtextents(rtx)			(false)
 static inline xfs_filblks_t
 xfs_rtbitmap_blockcount(struct xfs_mount *mp, xfs_rtbxlen_t rtextents)
diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index 638de2f7c8dc1..6a6877c365ae9 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -583,7 +583,7 @@ xfs_validate_sb_common(
 
 		if (!xfs_validate_rtextents(rexts) ||
 		    sbp->sb_rextents != rexts ||
-		    sbp->sb_rextslog != xfs_compute_rextslog(rexts) ||
+		    sbp->sb_rextslog != xfs_compute_rextslog(sbp, rexts) ||
 		    sbp->sb_rbmblocks != rbmblocks) {
 			xfs_notice(mp,
 				"realtime geometry sanity check failed");
diff --git a/fs/xfs/scrub/rtbitmap.c b/fs/xfs/scrub/rtbitmap.c
index c018376256a86..7f910fed7de95 100644
--- a/fs/xfs/scrub/rtbitmap.c
+++ b/fs/xfs/scrub/rtbitmap.c
@@ -61,7 +61,7 @@ xchk_setup_rtbitmap(
 	 */
 	if (mp->m_sb.sb_rblocks) {
 		rtb->rextents = xfs_rtb_to_rtx(mp, mp->m_sb.sb_rblocks);
-		rtb->rextslog = xfs_compute_rextslog(rtb->rextents);
+		rtb->rextslog = xfs_compute_rextslog(&mp->m_sb, rtb->rextents);
 		rtb->rbmblocks = xfs_rtbitmap_blockcount(mp, rtb->rextents);
 	}
 	return 0;
diff --git a/fs/xfs/scrub/rtsummary.c b/fs/xfs/scrub/rtsummary.c
index 829036b50b0c1..df9aa29cb94c6 100644
--- a/fs/xfs/scrub/rtsummary.c
+++ b/fs/xfs/scrub/rtsummary.c
@@ -92,7 +92,7 @@ xchk_setup_rtsummary(
 		int		rextslog;
 
 		rts->rextents = xfs_rtb_to_rtx(mp, mp->m_sb.sb_rblocks);
-		rextslog = xfs_compute_rextslog(rts->rextents);
+		rextslog = xfs_compute_rextslog(&mp->m_sb, rts->rextents);
 		rts->rsumlevels = rextslog + 1;
 		rts->rbmblocks = xfs_rtbitmap_blockcount(mp, rts->rextents);
 		rsumblocks = xfs_rtsummary_blockcount(mp, rts->rsumlevels,
diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 59ded74c9007e..ba9116b6e8de7 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -981,7 +981,7 @@ xfs_growfs_rt(
 	if (!xfs_validate_rtextents(nrextents))
 		return -EINVAL;
 	nrbmblocks = xfs_rtbitmap_blockcount(mp, nrextents);
-	nrextslog = xfs_compute_rextslog(nrextents);
+	nrextslog = xfs_compute_rextslog(&mp->m_sb, nrextents);
 	nrsumlevels = nrextslog + 1;
 	nrsumblocks = xfs_rtsummary_blockcount(mp, nrsumlevels, nrbmblocks);
 	nrsumsize = XFS_FSB_TO_B(mp, nrsumblocks);
@@ -1048,7 +1048,8 @@ xfs_growfs_rt(
 		nsbp->sb_rblocks = min(nrblocks, nrblocks_step);
 		nsbp->sb_rextents = xfs_rtb_to_rtx(nmp, nsbp->sb_rblocks);
 		ASSERT(nsbp->sb_rextents != 0);
-		nsbp->sb_rextslog = xfs_compute_rextslog(nsbp->sb_rextents);
+		nsbp->sb_rextslog = xfs_compute_rextslog(&mp->m_sb,
+				nsbp->sb_rextents);
 		nrsumlevels = nmp->m_rsumlevels = nsbp->sb_rextslog + 1;
 		nrsumblocks = xfs_rtsummary_blockcount(mp, nrsumlevels,
 				nsbp->sb_rbmblocks);

