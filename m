Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA0655256
	for <linux-xfs@vger.kernel.org>; Fri, 11 Oct 2024 01:09:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728608954; cv=none; b=CgIJlzDf0+erv2O59YygxKrdFeO3UL9nraqqnfHeZbTi/YW89EEYz3oiVHCqxm8rGgXHr91hBTElzu3UzOzrD4b7J+BSwqhVVArBgjSjMTbQTr8hFKvjAF5cwrbnlmDqY0duYJXU7yMmJcWcRl164YaJY018Xm/vY5s9s0j60pc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728608954; c=relaxed/simple;
	bh=DAR+YM9WtPJw7+yrk/BL1T11qebI54C3Y21jBHDJXhE=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mdH14L/sJHWt2EbLhU72wrqMP5UQqmCA3VwiiVVz08I8gaTM8fL1h0GOW6UAWur030k7i6JFhosjnTUEKOjZ2E+jpzaAFVD+9U37ExhrlarE981Wi4OsFLe4Kddw27r8xhgmbwaMahVpAZlfTwl4TJt0cYb1DlLja5ajkin0lFU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QM46Lf+T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QM46Lf+T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66B2EC4CEC5;
	Fri, 11 Oct 2024 01:09:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728608954;
	bh=DAR+YM9WtPJw7+yrk/BL1T11qebI54C3Y21jBHDJXhE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=QM46Lf+TfrPpzIlGQVPCJZWTIqTP7uITWqsjMrWRy6c6JkthOxZl2sdNYGfKCr2P4
	 q6LfjOZDYz2XjNUyvtj5asuScBSkst63E2CwmNI682oWPB1SnhAqheJRQ4X52posZ+
	 HnbxZx6QJQxu8UUTW3/crBSC0GwvUK8dCruc7VwJ9Dc1DAi3u1yH9Z5nSARHd4MwqJ
	 qbVNDG5ROQnbQD95e8/Pl3Wfpof45yLoGrqDIwnzwDyT+gSFNnQTAZvqKO573lHA7t
	 5Tt23DuFg+n4sdSnj0McjZfnnRSEBdQawbozEUFm1PDcpDt+O9r/omwOusgaPy1dnN
	 2dfuCTc2TGrgQ==
Date: Thu, 10 Oct 2024 18:09:14 -0700
Subject: [PATCH 29/36] xfs: make xfs_rtblock_t a segmented address like
 xfs_fsblock_t
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <172860644741.4178701.14170094374963023360.stgit@frogsfrogsfrogs>
In-Reply-To: <172860644112.4178701.15760945842194801432.stgit@frogsfrogsfrogs>
References: <172860644112.4178701.15760945842194801432.stgit@frogsfrogsfrogs>
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

Now that we've finished adding allocation groups to the realtime volume,
let's make the file block mapping address (xfs_rtblock_t) a segmented
value just like we do on the data device.  This means that group number
and block number conversions can be done with shifting and masking
instead of integer division.

While in theory we could continue caching the rgno shift value in
m_rgblklog, the fact that we now always use the shift value means that
we have an opportunity to increase the redundancy of the rt geometry by
storing it in the ondisk superblock and adding more sb verifier code.
Reuse the space vacated by sb_bad_feature2 to store the rgblklog value.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_bmap.c     |    4 +--
 fs/xfs/libxfs/xfs_format.h   |   16 ++++++++---
 fs/xfs/libxfs/xfs_rtbitmap.h |    6 +++-
 fs/xfs/libxfs/xfs_rtgroup.h  |   36 ++++++++++++++----------
 fs/xfs/libxfs/xfs_sb.c       |   62 +++++++++++++++++++++++++++++++++++-------
 fs/xfs/libxfs/xfs_sb.h       |    4 ++-
 fs/xfs/libxfs/xfs_types.c    |    7 ++---
 fs/xfs/scrub/agheader.c      |    4 ++-
 fs/xfs/xfs_mount.h           |    2 +
 fs/xfs/xfs_rtalloc.c         |    4 +--
 fs/xfs/xfs_trans.c           |   21 +++++++++++---
 11 files changed, 116 insertions(+), 50 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index d715c72d0dffef..f2efab1e8a42af 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -3152,10 +3152,8 @@ xfs_bmap_adjacent_valid(
 
 	if (XFS_IS_REALTIME_INODE(ap->ip) &&
 	    (ap->datatype & XFS_ALLOC_USERDATA)) {
-		if (x >= mp->m_sb.sb_rblocks)
-			return false;
 		if (!xfs_has_rtgroups(mp))
-			return true;
+			return x < mp->m_sb.sb_rblocks;
 
 		return xfs_rtb_to_rgno(mp, x) == xfs_rtb_to_rgno(mp, y) &&
 			xfs_rtb_to_rgno(mp, x) < mp->m_sb.sb_rgcount &&
diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index 2462f128955cad..ac1fbc6ca28870 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -165,7 +165,11 @@ typedef struct xfs_sb {
 		 * Metadir filesystems define this field to be zero since they
 		 * have never had this 64-bit alignment problem.
 		 */
-		uint32_t	sb_metadirpad;
+		struct {
+			uint8_t	sb_rgblklog;    /* rt group number shift */
+			uint8_t	sb_metadirpad0; /* zeroes */
+			uint16_t sb_metadirpad1; /* zeroes */
+		};
 	} __packed;
 
 	/* version 5 superblock fields start here */
@@ -261,10 +265,14 @@ struct xfs_dsb {
 		__be32		sb_bad_features2;
 
 		/*
-		 * Metadir filesystems define this field to be zero since they
-		 * have never had this 64-bit alignment problem.
+		 * Metadir filesystems use this space since they have never had
+		 * this 64-bit alignment problem.
 		 */
-		__be32		sb_metadirpad;
+		struct {
+			__u8	sb_rgblklog;    /* rt group number shift */
+			__u8	sb_metadirpad0; /* zeroes */
+			__u16	sb_metadirpad1; /* zeroes */
+		};
 	} __packed;
 
 	/* version 5 superblock fields start here */
diff --git a/fs/xfs/libxfs/xfs_rtbitmap.h b/fs/xfs/libxfs/xfs_rtbitmap.h
index e0fb36f181cc9e..25bf121f7126a2 100644
--- a/fs/xfs/libxfs/xfs_rtbitmap.h
+++ b/fs/xfs/libxfs/xfs_rtbitmap.h
@@ -141,10 +141,12 @@ xfs_rtb_to_rtxoff(
 	struct xfs_mount	*mp,
 	xfs_rtblock_t		rtbno)
 {
+	uint64_t		__rgbno = __xfs_rtb_to_rgbno(mp, rtbno);
+
 	if (likely(mp->m_rtxblklog >= 0))
-		return rtbno & mp->m_rtxblkmask;
+		return __rgbno & mp->m_rtxblkmask;
 
-	return do_div(rtbno, mp->m_sb.sb_rextsize);
+	return do_div(__rgbno, mp->m_sb.sb_rextsize);
 }
 
 /* Round this file block offset up to the nearest rt extent size. */
diff --git a/fs/xfs/libxfs/xfs_rtgroup.h b/fs/xfs/libxfs/xfs_rtgroup.h
index 185138837832d8..baa445b15b8523 100644
--- a/fs/xfs/libxfs/xfs_rtgroup.h
+++ b/fs/xfs/libxfs/xfs_rtgroup.h
@@ -122,9 +122,9 @@ xfs_rgno_start_rtb(
 	struct xfs_mount	*mp,
 	xfs_rgnumber_t		rgno)
 {
-	if (mp->m_rgblklog >= 0)
-		return ((xfs_rtblock_t)rgno << mp->m_rgblklog);
-	return ((xfs_rtblock_t)rgno * mp->m_rgblocks);
+	if (!xfs_has_rtgroups(mp))
+		return 0;
+	return ((xfs_rtblock_t)rgno << mp->m_sb.sb_rgblklog);
 }
 
 static inline xfs_rtblock_t
@@ -152,10 +152,7 @@ xfs_rtb_to_rgno(
 	if (!xfs_has_rtgroups(mp))
 		return 0;
 
-	if (mp->m_rgblklog >= 0)
-		return rtbno >> mp->m_rgblklog;
-
-	return div_u64(rtbno, mp->m_rgblocks);
+	return rtbno >> mp->m_sb.sb_rgblklog;
 }
 
 static inline uint64_t
@@ -163,16 +160,10 @@ __xfs_rtb_to_rgbno(
 	struct xfs_mount	*mp,
 	xfs_rtblock_t		rtbno)
 {
-	uint32_t		rem;
-
 	if (!xfs_has_rtgroups(mp))
 		return rtbno;
 
-	if (mp->m_rgblklog >= 0)
-		return rtbno & mp->m_rgblkmask;
-
-	div_u64_rem(rtbno, mp->m_rgblocks, &rem);
-	return rem;
+	return rtbno & mp->m_rgblkmask;
 }
 
 static inline xfs_rgblock_t
@@ -188,7 +179,10 @@ xfs_rtb_to_daddr(
 	struct xfs_mount	*mp,
 	xfs_rtblock_t		rtbno)
 {
-	return rtbno << mp->m_blkbb_log;
+	xfs_rgnumber_t		rgno = xfs_rtb_to_rgno(mp, rtbno);
+	uint64_t		start_bno = (xfs_rtblock_t)rgno * mp->m_rgblocks;
+
+	return XFS_FSB_TO_BB(mp, start_bno + (rtbno & mp->m_rgblkmask));
 }
 
 static inline xfs_rtblock_t
@@ -196,7 +190,17 @@ xfs_daddr_to_rtb(
 	struct xfs_mount	*mp,
 	xfs_daddr_t		daddr)
 {
-	return daddr >> mp->m_blkbb_log;
+	xfs_rfsblock_t		bno = XFS_BB_TO_FSBT(mp, daddr);
+
+	if (xfs_has_rtgroups(mp)) {
+		xfs_rgnumber_t	rgno;
+		uint32_t	rgbno;
+
+		rgno = div_u64_rem(bno, mp->m_rgblocks, &rgbno);
+		return ((xfs_rtblock_t)rgno << mp->m_sb.sb_rgblklog) + rgbno;
+	}
+
+	return bno;
 }
 
 #ifdef CONFIG_XFS_RT
diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index f6b3b377b850aa..ce09c40cfd265f 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -366,12 +366,23 @@ xfs_validate_sb_write(
 	return 0;
 }
 
+int
+xfs_compute_rgblklog(
+	xfs_rtxlen_t	rgextents,
+	xfs_rgblock_t	rextsize)
+{
+	uint64_t	rgblocks = (uint64_t)rgextents * rextsize;
+
+	return xfs_highbit64(rgblocks - 1) + 1;
+}
+
 static int
 xfs_validate_sb_rtgroups(
 	struct xfs_mount	*mp,
 	struct xfs_sb		*sbp)
 {
 	uint64_t		groups;
+	int			rgblklog;
 
 	if (sbp->sb_rextsize == 0) {
 		xfs_warn(mp,
@@ -416,6 +427,14 @@ xfs_validate_sb_rtgroups(
 		return -EINVAL;
 	}
 
+	rgblklog = xfs_compute_rgblklog(sbp->sb_rgextents, sbp->sb_rextsize);
+	if (sbp->sb_rgblklog != rgblklog) {
+		xfs_warn(mp,
+"Realtime group log (%d) does not match expected value (%d).",
+				sbp->sb_rgblklog, rgblklog);
+		return -EINVAL;
+	}
+
 	return 0;
 }
 
@@ -482,10 +501,9 @@ xfs_validate_sb_common(
 		}
 
 		if (sbp->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_METADIR) {
-			if (sbp->sb_metadirpad) {
+			if (sbp->sb_metadirpad0 || sbp->sb_metadirpad1) {
 				xfs_warn(mp,
-"Metadir superblock padding field (%d) must be zero.",
-						sbp->sb_metadirpad);
+"Metadir superblock padding fields must be zero.");
 				return -EINVAL;
 			}
 
@@ -792,7 +810,9 @@ __xfs_sb_from_disk(
 
 	if (to->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_METADIR) {
 		to->sb_metadirino = be64_to_cpu(from->sb_metadirino);
-		to->sb_metadirpad = be32_to_cpu(from->sb_metadirpad);
+		to->sb_rgblklog = from->sb_rgblklog;
+		to->sb_metadirpad0 = from->sb_metadirpad0;
+		to->sb_metadirpad1 = be16_to_cpu(from->sb_metadirpad1);
 		to->sb_rgcount = be32_to_cpu(from->sb_rgcount);
 		to->sb_rgextents = be32_to_cpu(from->sb_rgextents);
 		to->sb_rbmino = NULLFSINO;
@@ -962,7 +982,9 @@ xfs_sb_to_disk(
 
 	if (from->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_METADIR) {
 		to->sb_metadirino = cpu_to_be64(from->sb_metadirino);
-		to->sb_metadirpad = 0;
+		to->sb_rgblklog = from->sb_rgblklog;
+		to->sb_metadirpad0 = 0;
+		to->sb_metadirpad1 = 0;
 		to->sb_rgcount = cpu_to_be32(from->sb_rgcount);
 		to->sb_rgextents = cpu_to_be32(from->sb_rgextents);
 		to->sb_rbmino = cpu_to_be64(0);
@@ -1097,17 +1119,37 @@ const struct xfs_buf_ops xfs_sb_quiet_buf_ops = {
 	.verify_write = xfs_sb_write_verify,
 };
 
+/* Compute cached rt geometry from the incore sb. */
 void
-xfs_mount_sb_set_rextsize(
+xfs_sb_mount_rextsize(
 	struct xfs_mount	*mp,
 	struct xfs_sb		*sbp)
 {
 	mp->m_rtxblklog = log2_if_power2(sbp->sb_rextsize);
 	mp->m_rtxblkmask = mask64_if_power2(sbp->sb_rextsize);
 
-	mp->m_rgblocks = sbp->sb_rgextents * sbp->sb_rextsize;
-	mp->m_rgblklog = log2_if_power2(mp->m_rgblocks);
-	mp->m_rgblkmask = mask64_if_power2(mp->m_rgblocks);
+	if (xfs_sb_version_hasmetadir(sbp)) {
+		mp->m_rgblocks = sbp->sb_rgextents * sbp->sb_rextsize;
+		mp->m_rgblkmask = (1ULL << sbp->sb_rgblklog) - 1;
+	} else {
+		mp->m_rgblocks = 0;
+		mp->m_rgblkmask = 0;
+	}
+}
+
+/* Update incore sb rt extent size, then recompute the cached rt geometry. */
+void
+xfs_mount_sb_set_rextsize(
+	struct xfs_mount	*mp,
+	struct xfs_sb		*sbp,
+	xfs_agblock_t		rextsize)
+{
+	sbp->sb_rextsize = rextsize;
+	if (xfs_sb_version_hasmetadir(sbp))
+		sbp->sb_rgblklog = xfs_compute_rgblklog(sbp->sb_rgextents,
+							rextsize);
+
+	xfs_sb_mount_rextsize(mp, sbp);
 }
 
 /*
@@ -1134,7 +1176,7 @@ xfs_sb_mount_common(
 	mp->m_blockmask = sbp->sb_blocksize - 1;
 	mp->m_blockwsize = xfs_rtbmblock_size(sbp) >> XFS_WORDLOG;
 	mp->m_rtx_per_rbmblock = mp->m_blockwsize << XFS_NBWORDLOG;
-	xfs_mount_sb_set_rextsize(mp, sbp);
+	xfs_sb_mount_rextsize(mp, sbp);
 
 	mp->m_alloc_mxr[0] = xfs_allocbt_maxrecs(mp, sbp->sb_blocksize, true);
 	mp->m_alloc_mxr[1] = xfs_allocbt_maxrecs(mp, sbp->sb_blocksize, false);
diff --git a/fs/xfs/libxfs/xfs_sb.h b/fs/xfs/libxfs/xfs_sb.h
index 999dcfccdaf960..34d0dd374e9b0b 100644
--- a/fs/xfs/libxfs/xfs_sb.h
+++ b/fs/xfs/libxfs/xfs_sb.h
@@ -17,8 +17,9 @@ extern void	xfs_log_sb(struct xfs_trans *tp);
 extern int	xfs_sync_sb(struct xfs_mount *mp, bool wait);
 extern int	xfs_sync_sb_buf(struct xfs_mount *mp, bool update_rtsb);
 extern void	xfs_sb_mount_common(struct xfs_mount *mp, struct xfs_sb *sbp);
+void		xfs_sb_mount_rextsize(struct xfs_mount *mp, struct xfs_sb *sbp);
 void		xfs_mount_sb_set_rextsize(struct xfs_mount *mp,
-			struct xfs_sb *sbp);
+			struct xfs_sb *sbp, xfs_agblock_t rextsize);
 extern void	xfs_sb_from_disk(struct xfs_sb *to, struct xfs_dsb *from);
 extern void	xfs_sb_to_disk(struct xfs_dsb *to, struct xfs_sb *from);
 extern void	xfs_sb_quota_from_disk(struct xfs_sb *sbp);
@@ -43,5 +44,6 @@ bool	xfs_validate_stripe_geometry(struct xfs_mount *mp,
 bool	xfs_validate_rt_geometry(struct xfs_sb *sbp);
 
 uint8_t xfs_compute_rextslog(xfs_rtbxlen_t rtextents);
+int xfs_compute_rgblklog(xfs_rtxlen_t rgextents, xfs_rgblock_t rextsize);
 
 #endif	/* __XFS_SB_H__ */
diff --git a/fs/xfs/libxfs/xfs_types.c b/fs/xfs/libxfs/xfs_types.c
index 0396fb751688d0..cdd36c1983efaf 100644
--- a/fs/xfs/libxfs/xfs_types.c
+++ b/fs/xfs/libxfs/xfs_types.c
@@ -146,9 +146,6 @@ xfs_verify_rtbno(
 	struct xfs_mount	*mp,
 	xfs_rtblock_t		rtbno)
 {
-	if (rtbno >= mp->m_sb.sb_rblocks)
-		return false;
-
 	if (xfs_has_rtgroups(mp)) {
 		xfs_rgnumber_t	rgno = xfs_rtb_to_rgno(mp, rtbno);
 		xfs_rtxnum_t	rtx = xfs_rtb_to_rtx(mp, rtbno);
@@ -159,8 +156,10 @@ xfs_verify_rtbno(
 			return false;
 		if (xfs_has_rtsb(mp) && rgno == 0 && rtx == 0)
 			return false;
+		return true;
 	}
-	return true;
+
+	return rtbno < mp->m_sb.sb_rblocks;
 }
 
 /*
diff --git a/fs/xfs/scrub/agheader.c b/fs/xfs/scrub/agheader.c
index a9ab6da20e9c8b..31467d71c63e91 100644
--- a/fs/xfs/scrub/agheader.c
+++ b/fs/xfs/scrub/agheader.c
@@ -280,7 +280,9 @@ xchk_superblock(
 			xchk_block_set_corrupt(sc, bp);
 
 		if (xfs_has_metadir(mp)) {
-			if (sb->sb_metadirpad)
+			if (sb->sb_rgblklog != mp->m_sb.sb_rgblklog)
+				xchk_block_set_corrupt(sc, bp);
+			if (sb->sb_metadirpad0 || sb->sb_metadirpad1)
 				xchk_block_set_preen(sc, bp);
 		} else {
 			if (sb->sb_features2 != sb->sb_bad_features2)
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 7aaa42fff8b92b..07fb3d91a88331 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -117,7 +117,7 @@ typedef struct xfs_mount {
 	uint8_t			m_agno_log;	/* log #ag's */
 	uint8_t			m_sectbb_log;	/* sectlog - BBSHIFT */
 	int8_t			m_rtxblklog;	/* log2 of rextsize, if possible */
-	int8_t			m_rgblklog;	/* log2 of rt group sz if possible */
+
 	uint			m_blockmask;	/* sb_blocksize-1 */
 	uint			m_blockwsize;	/* sb_blocksize in words */
 	/* number of rt extents per rt bitmap block if rtgroups enabled */
diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 783674fd42ead1..db09c086ff1c01 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -745,8 +745,7 @@ xfs_growfs_rt_alloc_fake_mount(
 	nmp = kmemdup(mp, sizeof(*mp), GFP_KERNEL);
 	if (!nmp)
 		return NULL;
-	nmp->m_sb.sb_rextsize = rextsize;
-	xfs_mount_sb_set_rextsize(nmp, &nmp->m_sb);
+	xfs_mount_sb_set_rextsize(nmp, &nmp->m_sb, rextsize);
 	nmp->m_sb.sb_rblocks = rblocks;
 	nmp->m_sb.sb_rextents = xfs_blen_to_rtbxlen(nmp, nmp->m_sb.sb_rblocks);
 	nmp->m_sb.sb_rbmblocks = xfs_rtbitmap_blockcount(nmp);
@@ -968,7 +967,6 @@ xfs_growfs_rt_bmblock(
 	 */
 	mp->m_rsumlevels = nmp->m_rsumlevels;
 	mp->m_rsumblocks = nmp->m_rsumblocks;
-	xfs_mount_sb_set_rextsize(mp, &mp->m_sb);
 
 	/*
 	 * Recompute the growfsrt reservation from the new rsumsize.
diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index a29a181e684041..4db022c189e134 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -26,6 +26,7 @@
 #include "xfs_icache.h"
 #include "xfs_rtbitmap.h"
 #include "xfs_rtgroup.h"
+#include "xfs_sb.h"
 
 struct kmem_cache	*xfs_trans_cache;
 
@@ -547,6 +548,18 @@ xfs_trans_apply_sb_deltas(
 	}
 	if (tp->t_rextsize_delta) {
 		be32_add_cpu(&sbp->sb_rextsize, tp->t_rextsize_delta);
+
+		/*
+		 * Because the ondisk sb records rtgroup size in units of rt
+		 * extents, any time we update the rt extent size we have to
+		 * recompute the ondisk rtgroup block log.  The incore values
+		 * will be recomputed in xfs_trans_unreserve_and_mod_sb.
+		 */
+		if (xfs_has_rtgroups(tp->t_mountp)) {
+			sbp->sb_rgblklog = xfs_compute_rgblklog(
+						be32_to_cpu(sbp->sb_rgextents),
+						be32_to_cpu(sbp->sb_rextsize));
+		}
 		whole = 1;
 	}
 	if (tp->t_rbmblocks_delta) {
@@ -673,11 +686,9 @@ xfs_trans_unreserve_and_mod_sb(
 	mp->m_sb.sb_dblocks += tp->t_dblocks_delta;
 	mp->m_sb.sb_agcount += tp->t_agcount_delta;
 	mp->m_sb.sb_imax_pct += tp->t_imaxpct_delta;
-	mp->m_sb.sb_rextsize += tp->t_rextsize_delta;
-	if (tp->t_rextsize_delta) {
-		mp->m_rtxblklog = log2_if_power2(mp->m_sb.sb_rextsize);
-		mp->m_rtxblkmask = mask64_if_power2(mp->m_sb.sb_rextsize);
-	}
+	if (tp->t_rextsize_delta)
+		xfs_mount_sb_set_rextsize(mp, &mp->m_sb,
+				mp->m_sb.sb_rextsize + tp->t_rextsize_delta);
 	mp->m_sb.sb_rbmblocks += tp->t_rbmblocks_delta;
 	mp->m_sb.sb_rblocks += tp->t_rblocks_delta;
 	mp->m_sb.sb_rextents += tp->t_rextents_delta;

