Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89D04CDB475
	for <linux-xfs@archiver.kernel.org>; Wed, 11 Oct 2023 18:06:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234947AbjJKSGT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 11 Oct 2023 14:06:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346207AbjJKSGQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 11 Oct 2023 14:06:16 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3789DBA
        for <linux-xfs@vger.kernel.org>; Wed, 11 Oct 2023 11:06:15 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2EC2C433C7;
        Wed, 11 Oct 2023 18:06:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697047574;
        bh=y7dvVRHDVzVRzNJopYewqTjTimsXb9+XOvx95jY7NRk=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=lNRhampNz4EX7IuPMvsr6K0ots4LAP/WVxWJZyjjbPVo8kE6ztNw0/y81WrunttfY
         Juiwl4kA/QNL0JXgB/wFAeHuGfz+Lx4NiG8P2neHQmDhjfNKmeCorW2EtPJZNntPrT
         T2+QZiGSSsJeXEbIt8HZaFAtloGqjbLCPeFiJlBoVzG+0tFkk3FfkuJt3UIhDrIH65
         9hgtPwP/LHYJbtZ7N8tHdRp8jocAnFuvVWdXVrxFtLVYo4t8O+0f10mpgtS58UfJHN
         37OHxGrYslyQO6S2E6ELZ8hTAgtBJFiVHG6kGhVZ+Pi0/N2AbLX1Oe2A2kDphMqvXi
         2Ny1TXskSWqBQ==
Date:   Wed, 11 Oct 2023 11:06:14 -0700
Subject: [PATCH 7/7] xfs: use shifting and masking when converting rt extents,
 if possible
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, osandov@osandov.com, hch@lst.de
Message-ID: <169704721284.1773611.1915589661676489.stgit@frogsfrogsfrogs>
In-Reply-To: <169704721170.1773611.12311239321983752854.stgit@frogsfrogsfrogs>
References: <169704721170.1773611.12311239321983752854.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Avoid the costs of integer division (32-bit and 64-bit) if the realtime
extent size is a power of two.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_rtbitmap.h |   20 ++++++++++++++++++++
 fs/xfs/libxfs/xfs_sb.c       |    2 ++
 fs/xfs/xfs_linux.h           |   12 ++++++++++++
 fs/xfs/xfs_mount.h           |    2 ++
 fs/xfs/xfs_rtalloc.c         |    1 +
 fs/xfs/xfs_trans.c           |    4 ++++
 6 files changed, 41 insertions(+)


diff --git a/fs/xfs/libxfs/xfs_rtbitmap.h b/fs/xfs/libxfs/xfs_rtbitmap.h
index bc51d3bfc7c45..9dd791181ca2b 100644
--- a/fs/xfs/libxfs/xfs_rtbitmap.h
+++ b/fs/xfs/libxfs/xfs_rtbitmap.h
@@ -11,6 +11,9 @@ xfs_rtx_to_rtb(
 	struct xfs_mount	*mp,
 	xfs_rtxnum_t		rtx)
 {
+	if (mp->m_rtxblklog >= 0)
+		return rtx << mp->m_rtxblklog;
+
 	return rtx * mp->m_sb.sb_rextsize;
 }
 
@@ -19,6 +22,9 @@ xfs_rtxlen_to_extlen(
 	struct xfs_mount	*mp,
 	xfs_rtxlen_t		rtxlen)
 {
+	if (mp->m_rtxblklog >= 0)
+		return rtxlen << mp->m_rtxblklog;
+
 	return rtxlen * mp->m_sb.sb_rextsize;
 }
 
@@ -28,6 +34,9 @@ xfs_extlen_to_rtxmod(
 	struct xfs_mount	*mp,
 	xfs_extlen_t		len)
 {
+	if (mp->m_rtxblklog >= 0)
+		return len & mp->m_rtxblkmask;
+
 	return len % mp->m_sb.sb_rextsize;
 }
 
@@ -36,6 +45,9 @@ xfs_extlen_to_rtxlen(
 	struct xfs_mount	*mp,
 	xfs_extlen_t		len)
 {
+	if (mp->m_rtxblklog >= 0)
+		return len >> mp->m_rtxblklog;
+
 	return len / mp->m_sb.sb_rextsize;
 }
 
@@ -45,6 +57,11 @@ xfs_rtb_to_rtx(
 	xfs_rtblock_t		rtbno,
 	xfs_extlen_t		*mod)
 {
+	if (mp->m_rtxblklog >= 0) {
+		*mod = rtbno & mp->m_rtxblkmask;
+		return rtbno >> mp->m_rtxblklog;
+	}
+
 	return div_u64_rem(rtbno, mp->m_sb.sb_rextsize, mod);
 }
 
@@ -53,6 +70,9 @@ xfs_rtb_to_rtxt(
 	struct xfs_mount	*mp,
 	xfs_rtblock_t		rtbno)
 {
+	if (mp->m_rtxblklog >= 0)
+		return rtbno >> mp->m_rtxblklog;
+
 	return div_u64(rtbno, mp->m_sb.sb_rextsize);
 }
 
diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index 5fb142b8e3d92..db04378f287a6 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -1011,6 +1011,8 @@ xfs_sb_mount_common(
 	mp->m_blockmask = sbp->sb_blocksize - 1;
 	mp->m_blockwsize = sbp->sb_blocksize >> XFS_WORDLOG;
 	mp->m_blockwmask = mp->m_blockwsize - 1;
+	mp->m_rtxblklog = log2_if_power2(sbp->sb_rextsize);
+	mp->m_rtxblkmask = mask64_if_power2(sbp->sb_rextsize);
 
 	mp->m_alloc_mxr[0] = xfs_allocbt_maxrecs(mp, sbp->sb_blocksize, 1);
 	mp->m_alloc_mxr[1] = xfs_allocbt_maxrecs(mp, sbp->sb_blocksize, 0);
diff --git a/fs/xfs/xfs_linux.h b/fs/xfs/xfs_linux.h
index dfde4021905b7..953466922ddf7 100644
--- a/fs/xfs/xfs_linux.h
+++ b/fs/xfs/xfs_linux.h
@@ -203,6 +203,18 @@ static inline bool isaligned_64(uint64_t x, uint32_t y)
 	return do_div(x, y) == 0;
 }
 
+/* If @b is a power of 2, return log2(b).  Else return -1. */
+static inline int8_t log2_if_power2(unsigned long b)
+{
+	return is_power_of_2(b) ? ilog2(b) : -1;
+}
+
+/* If @b is a power of 2, return a mask of the lower bits, else return zero. */
+static inline unsigned long long mask64_if_power2(unsigned long b)
+{
+	return is_power_of_2(b) ? b - 1 : 0;
+}
+
 int xfs_rw_bdev(struct block_device *bdev, sector_t sector, unsigned int count,
 		char *data, enum req_op op);
 
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index f42679a6569ff..3c5b0327164bc 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -120,6 +120,7 @@ typedef struct xfs_mount {
 	uint8_t			m_blkbb_log;	/* blocklog - BBSHIFT */
 	uint8_t			m_agno_log;	/* log #ag's */
 	uint8_t			m_sectbb_log;	/* sectlog - BBSHIFT */
+	int8_t			m_rtxblklog;	/* log2 of rextsize, if possible */
 	uint			m_blockmask;	/* sb_blocksize-1 */
 	uint			m_blockwsize;	/* sb_blocksize in words */
 	uint			m_blockwmask;	/* blockwsize-1 */
@@ -153,6 +154,7 @@ typedef struct xfs_mount {
 	uint64_t		m_features;	/* active filesystem features */
 	uint64_t		m_low_space[XFS_LOWSP_MAX];
 	uint64_t		m_low_rtexts[XFS_LOWSP_MAX];
+	uint64_t		m_rtxblkmask;	/* rt extent block mask */
 	struct xfs_ino_geometry	m_ino_geo;	/* inode geometry */
 	struct xfs_trans_resv	m_resv;		/* precomputed res values */
 						/* low free space thresholds */
diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index e62ca51b995ba..dc4874776c2cb 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -1052,6 +1052,7 @@ xfs_growfs_rt(
 		 * Calculate new sb and mount fields for this round.
 		 */
 		nsbp->sb_rextsize = in->extsize;
+		nmp->m_rtxblklog = -1; /* don't use shift or masking */
 		nsbp->sb_rbmblocks = bmbno + 1;
 		nrblocks_step = (bmbno + 1) * NBBY * nsbp->sb_blocksize *
 				nsbp->sb_rextsize;
diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index 22aa2111b6cab..35161074c4e7d 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -712,6 +712,10 @@ xfs_trans_unreserve_and_mod_sb(
 	mp->m_sb.sb_agcount += tp->t_agcount_delta;
 	mp->m_sb.sb_imax_pct += tp->t_imaxpct_delta;
 	mp->m_sb.sb_rextsize += tp->t_rextsize_delta;
+	if (tp->t_rextsize_delta) {
+		mp->m_rtxblklog = log2_if_power2(mp->m_sb.sb_rextsize);
+		mp->m_rtxblkmask = mask64_if_power2(mp->m_sb.sb_rextsize);
+	}
 	mp->m_sb.sb_rbmblocks += tp->t_rbmblocks_delta;
 	mp->m_sb.sb_rblocks += tp->t_rblocks_delta;
 	mp->m_sb.sb_rextents += tp->t_rextents_delta;

