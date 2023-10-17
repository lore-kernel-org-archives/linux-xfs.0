Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B8E1CDB474
	for <linux-xfs@archiver.kernel.org>; Tue, 17 Oct 2023 15:51:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235034AbjJQPvu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 17 Oct 2023 11:51:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233016AbjJQPvt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 Oct 2023 11:51:49 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9EB19E
        for <linux-xfs@vger.kernel.org>; Tue, 17 Oct 2023 08:51:47 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E6E9C433C7;
        Tue, 17 Oct 2023 15:51:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697557907;
        bh=0ZS+kcoW8jdr1rBi+ywpu04WSUEVnM+Q4HM5VWyxY8k=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=WxSgVPmyAzSa37GiB9T4+zxDLxbgKuXE5fsN1H3ezUtRU0rrigsUitq1noB1BIs8B
         6fIbenIXVt8Al/ISai8ETGS2S8mk7SQc089x0HKyLuir+uLAGuBAHyJkWpy2KT15RZ
         QbuIjfRfSeqvVd9NCGeJHq0UTtY/6pLaxKUm4tQe1+BIrW4czky5o0l9WoFHwZC2w7
         U2FKO2o8FMLmKFJ+Tgir5mL/kaFJTpK3cJcih8kpAbd3LRGvUyHQcJTeIpYFZs5QEj
         2kapkzt9TlWBPh/rY1ci3VDhoQOKzkU41BIPD8/MAGgHqI6mGiLyJDpJAgw/KFEG8E
         Y7dFi+mC2gjhw==
Date:   Tue, 17 Oct 2023 08:51:47 -0700
Subject: [PATCH 7/7] xfs: use shifting and masking when converting rt extents,
 if possible
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Christoph Hellwig <hch@lst.de>, osandov@fb.com,
        linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <169755741836.3165781.829058471536663523.stgit@frogsfrogsfrogs>
In-Reply-To: <169755741717.3165781.12142780069035126128.stgit@frogsfrogsfrogs>
References: <169755741717.3165781.12142780069035126128.stgit@frogsfrogsfrogs>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_rtbitmap.h |   29 +++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_sb.c       |    2 ++
 fs/xfs/xfs_linux.h           |   12 ++++++++++++
 fs/xfs/xfs_mount.h           |    2 ++
 fs/xfs/xfs_rtalloc.c         |    1 +
 fs/xfs/xfs_trans.c           |    4 ++++
 6 files changed, 50 insertions(+)


diff --git a/fs/xfs/libxfs/xfs_rtbitmap.h b/fs/xfs/libxfs/xfs_rtbitmap.h
index ecf5645dd670..3686a53e0aed 100644
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
 
@@ -45,6 +57,9 @@ xfs_rtb_to_rtx(
 	struct xfs_mount	*mp,
 	xfs_rtblock_t		rtbno)
 {
+	if (likely(mp->m_rtxblklog >= 0))
+		return rtbno >> mp->m_rtxblklog;
+
 	return div_u64(rtbno, mp->m_sb.sb_rextsize);
 }
 
@@ -54,6 +69,9 @@ xfs_rtb_to_rtxoff(
 	struct xfs_mount	*mp,
 	xfs_rtblock_t		rtbno)
 {
+	if (likely(mp->m_rtxblklog >= 0))
+		return rtbno & mp->m_rtxblkmask;
+
 	return do_div(rtbno, mp->m_sb.sb_rextsize);
 }
 
@@ -67,6 +85,11 @@ xfs_rtb_to_rtxrem(
 	xfs_rtblock_t		rtbno,
 	xfs_extlen_t		*off)
 {
+	if (likely(mp->m_rtxblklog >= 0)) {
+		*off = rtbno & mp->m_rtxblkmask;
+		return rtbno >> mp->m_rtxblklog;
+	}
+
 	return div_u64_rem(rtbno, mp->m_sb.sb_rextsize, off);
 }
 
@@ -79,6 +102,12 @@ xfs_rtb_to_rtxup(
 	struct xfs_mount	*mp,
 	xfs_rtblock_t		rtbno)
 {
+	if (likely(mp->m_rtxblklog >= 0)) {
+		if (rtbno & mp->m_rtxblkmask)
+			return (rtbno >> mp->m_rtxblklog) + 1;
+		return rtbno >> mp->m_rtxblklog;
+	}
+
 	if (do_div(rtbno, mp->m_sb.sb_rextsize))
 		rtbno++;
 	return rtbno;
diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index 6264daaab37b..1f74d0cd1618 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -975,6 +975,8 @@ xfs_sb_mount_common(
 	mp->m_blockmask = sbp->sb_blocksize - 1;
 	mp->m_blockwsize = sbp->sb_blocksize >> XFS_WORDLOG;
 	mp->m_blockwmask = mp->m_blockwsize - 1;
+	mp->m_rtxblklog = log2_if_power2(sbp->sb_rextsize);
+	mp->m_rtxblkmask = mask64_if_power2(sbp->sb_rextsize);
 
 	mp->m_alloc_mxr[0] = xfs_allocbt_maxrecs(mp, sbp->sb_blocksize, 1);
 	mp->m_alloc_mxr[1] = xfs_allocbt_maxrecs(mp, sbp->sb_blocksize, 0);
diff --git a/fs/xfs/xfs_linux.h b/fs/xfs/xfs_linux.h
index e9d317a3dafe..d7873e0360f0 100644
--- a/fs/xfs/xfs_linux.h
+++ b/fs/xfs/xfs_linux.h
@@ -198,6 +198,18 @@ static inline uint64_t howmany_64(uint64_t x, uint32_t y)
 	return x;
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
index d19cca099bc3..d8769dc5f6dd 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -119,6 +119,7 @@ typedef struct xfs_mount {
 	uint8_t			m_blkbb_log;	/* blocklog - BBSHIFT */
 	uint8_t			m_agno_log;	/* log #ag's */
 	uint8_t			m_sectbb_log;	/* sectlog - BBSHIFT */
+	int8_t			m_rtxblklog;	/* log2 of rextsize, if possible */
 	uint			m_blockmask;	/* sb_blocksize-1 */
 	uint			m_blockwsize;	/* sb_blocksize in words */
 	uint			m_blockwmask;	/* blockwsize-1 */
@@ -152,6 +153,7 @@ typedef struct xfs_mount {
 	uint64_t		m_features;	/* active filesystem features */
 	uint64_t		m_low_space[XFS_LOWSP_MAX];
 	uint64_t		m_low_rtexts[XFS_LOWSP_MAX];
+	uint64_t		m_rtxblkmask;	/* rt extent block mask */
 	struct xfs_ino_geometry	m_ino_geo;	/* inode geometry */
 	struct xfs_trans_resv	m_resv;		/* precomputed res values */
 						/* low free space thresholds */
diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index ac7c269ad547..e5a3200cea72 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -1054,6 +1054,7 @@ xfs_growfs_rt(
 		 * Calculate new sb and mount fields for this round.
 		 */
 		nsbp->sb_rextsize = in->extsize;
+		nmp->m_rtxblklog = -1; /* don't use shift or masking */
 		nsbp->sb_rbmblocks = bmbno + 1;
 		nrblocks_step = (bmbno + 1) * NBBY * nsbp->sb_blocksize *
 				nsbp->sb_rextsize;
diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index 338dd3774507..305c9d07bf1b 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -656,6 +656,10 @@ xfs_trans_unreserve_and_mod_sb(
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

