Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A5C5C2C0
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 23:48:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XtUpbZZG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE2A8C433C8;
	Sun, 31 Dec 2023 23:48:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704066501;
	bh=blCpWnXYnXrqfgar3WIKUSA3V3wZ5081QYXjUCm/riw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=XtUpbZZGRac3jfE3elaosS5DyehZCC+S+z+cJJLL1HwZEUO7NaFPvwxXVCwQQjh6m
	 Nctm07EsxaCb0r2vNQkDOUhoJ/c/Zsr604H4CSj0VQgOdn5fByZSCdydWZD9Xd+0qG
	 Hww0dwZ2wcagk58kvKvxr/BVNA1qfRdK6HTMSJM+scWWCXtZUJY+GcXWmI8HxZHxnW
	 ypchQM2R/Gfjn9uIp94goa7W1qdusiOrhDQnte6n6B6K5jFpx/LORXCGtQrGeVXsOg
	 d3JssEHN2uwhYN4PRjSJlJtgYlPTMwk+qaVvEJRMvTIxDxXgc6GL9tjJoiBojOgbtN
	 7IHcFkLfgHqJA==
Date: Sun, 31 Dec 2023 15:48:21 -0800
Subject: [PATCH 03/52] xfs: reduce rt summary file levels for rtgroups
 filesystems
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405012209.1811243.2976584231573653136.stgit@frogsfrogsfrogs>
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
 libxfs/xfs_format.h   |    2 +-
 libxfs/xfs_rtbitmap.c |   11 +++++++++++
 libxfs/xfs_rtbitmap.h |    4 ++--
 libxfs/xfs_sb.c       |    2 +-
 mkfs/xfs_mkfs.c       |    2 +-
 repair/sb.c           |    3 ++-
 6 files changed, 18 insertions(+), 6 deletions(-)


diff --git a/libxfs/xfs_format.h b/libxfs/xfs_format.h
index 8debe925716..43e66740e2a 100644
--- a/libxfs/xfs_format.h
+++ b/libxfs/xfs_format.h
@@ -313,7 +313,7 @@ struct xfs_dsb {
 
 #define	XFS_SB_VERSION_NUM(sbp)	((sbp)->sb_versionnum & XFS_SB_VERSION_NUMBITS)
 
-static inline bool xfs_sb_is_v5(struct xfs_sb *sbp)
+static inline bool xfs_sb_is_v5(const struct xfs_sb *sbp)
 {
 	return XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5;
 }
diff --git a/libxfs/xfs_rtbitmap.c b/libxfs/xfs_rtbitmap.c
index 69c70c89c96..c2970b78ce8 100644
--- a/libxfs/xfs_rtbitmap.c
+++ b/libxfs/xfs_rtbitmap.c
@@ -1142,10 +1142,21 @@ xfs_rtbitmap_blockcount(
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
 
diff --git a/libxfs/xfs_rtbitmap.h b/libxfs/xfs_rtbitmap.h
index 6ac17f0195e..3de0ec2d241 100644
--- a/libxfs/xfs_rtbitmap.h
+++ b/libxfs/xfs_rtbitmap.h
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
diff --git a/libxfs/xfs_sb.c b/libxfs/xfs_sb.c
index 95cb070aab5..b5e4367d4ca 100644
--- a/libxfs/xfs_sb.c
+++ b/libxfs/xfs_sb.c
@@ -581,7 +581,7 @@ xfs_validate_sb_common(
 
 		if (!xfs_validate_rtextents(rexts) ||
 		    sbp->sb_rextents != rexts ||
-		    sbp->sb_rextslog != xfs_compute_rextslog(rexts) ||
+		    sbp->sb_rextslog != xfs_compute_rextslog(sbp, rexts) ||
 		    sbp->sb_rbmblocks != rbmblocks) {
 			xfs_notice(mp,
 				"realtime geometry sanity check failed");
diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 8d2e832d126..2330ebebfae 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -3983,7 +3983,7 @@ finish_superblock_setup(
 	sbp->sb_agcount = (xfs_agnumber_t)cfg->agcount;
 	sbp->sb_rbmblocks = cfg->rtbmblocks;
 	sbp->sb_logblocks = (xfs_extlen_t)cfg->logblocks;
-	sbp->sb_rextslog = libxfs_compute_rextslog(cfg->rtextents);
+	sbp->sb_rextslog = libxfs_compute_rextslog(sbp, cfg->rtextents);
 	sbp->sb_imax_pct = cfg->imaxpct;
 	sbp->sb_icount = 0;
 	sbp->sb_ifree = 0;
diff --git a/repair/sb.c b/repair/sb.c
index 8292a0f3c3e..32602d84f3c 100644
--- a/repair/sb.c
+++ b/repair/sb.c
@@ -482,7 +482,8 @@ verify_sb(char *sb_buf, xfs_sb_t *sb, int is_primary_sb)
 		if (sb->sb_rextents == 0)
 			return XR_BAD_RT_GEO_DATA;
 
-		if (sb->sb_rextslog != libxfs_compute_rextslog(sb->sb_rextents))
+		if (sb->sb_rextslog != libxfs_compute_rextslog(sb,
+							sb->sb_rextents))
 			return(XR_BAD_RT_GEO_DATA);
 
 		if (sb->sb_rbmblocks != (xfs_extlen_t) howmany(sb->sb_rextents,

