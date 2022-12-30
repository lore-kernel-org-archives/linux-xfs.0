Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BEB76C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 01:24:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236088AbiLaBYo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 20:24:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236079AbiLaBYm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 20:24:42 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC41F1E3CE
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 17:24:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6990761B80
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 01:24:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB3A5C433EF;
        Sat, 31 Dec 2022 01:24:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672449876;
        bh=yz/zWHRKKe4nGWcY8Dxc/iQ5updlVht8sXlnSoC8Xtw=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=bUVPWXH++5JGHIfKs8UgMkuHOHoW3mgTSZCpAcrHCKVZdNoZ76nOvoTS+uT3V85nH
         AZFui76p/eCsBMj9P29GiCFLwEgw4VmRI2fPArV8xE/1/axA0GQ0XiIqcjoeZbnoGT
         AzQ/6PwupApSqzar4+b2cpqM9KzBMm8wIk8yALUgxChS72ZaEO/yiT3sYAUEdqqsFd
         15aXX3k7A9QSItsez2A+p9mQs32pc9rOd/MEkDlIYxzsD/3JHIey0N9tOt/8hOrUEh
         9/+M2uEKNrnilf9Pt7FiJn+39CzMtHKoL8lOetDABKUMEOp/J1/UXgyyS0U2sJTljm
         CHUxHsqi/eveg==
Subject: [PATCH 7/7] xfs: use shifting and masking when converting rt extents,
 if possible
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:17:41 -0800
Message-ID: <167243866172.711673.13765071209876015308.stgit@magnolia>
In-Reply-To: <167243866067.711673.17279545989126573423.stgit@magnolia>
References: <167243866067.711673.17279545989126573423.stgit@magnolia>
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
index bc51d3bfc7c4..9dd791181ca2 100644
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
index 8ebedfe55b15..83930abf935f 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -952,6 +952,8 @@ xfs_sb_mount_common(
 	mp->m_blockmask = sbp->sb_blocksize - 1;
 	mp->m_blockwsize = sbp->sb_blocksize >> XFS_WORDLOG;
 	mp->m_blockwmask = mp->m_blockwsize - 1;
+	mp->m_rtxblklog = log2_if_power2(sbp->sb_rextsize);
+	mp->m_rtxblkmask = mask64_if_power2(sbp->sb_rextsize);
 
 	mp->m_alloc_mxr[0] = xfs_allocbt_maxrecs(mp, sbp->sb_blocksize, 1);
 	mp->m_alloc_mxr[1] = xfs_allocbt_maxrecs(mp, sbp->sb_blocksize, 0);
diff --git a/fs/xfs/xfs_linux.h b/fs/xfs/xfs_linux.h
index 2cdb3411aabb..7455cbadc262 100644
--- a/fs/xfs/xfs_linux.h
+++ b/fs/xfs/xfs_linux.h
@@ -200,6 +200,18 @@ static inline bool isaligned_64(uint64_t x, uint32_t y)
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
index 88fbbaee8806..bad926f3e102 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -118,6 +118,7 @@ typedef struct xfs_mount {
 	uint8_t			m_blkbb_log;	/* blocklog - BBSHIFT */
 	uint8_t			m_agno_log;	/* log #ag's */
 	uint8_t			m_sectbb_log;	/* sectlog - BBSHIFT */
+	int8_t			m_rtxblklog;	/* log2 of rextsize, if possible */
 	uint			m_blockmask;	/* sb_blocksize-1 */
 	uint			m_blockwsize;	/* sb_blocksize in words */
 	uint			m_blockwmask;	/* blockwsize-1 */
@@ -151,6 +152,7 @@ typedef struct xfs_mount {
 	uint64_t		m_features;	/* active filesystem features */
 	uint64_t		m_low_space[XFS_LOWSP_MAX];
 	uint64_t		m_low_rtexts[XFS_LOWSP_MAX];
+	uint64_t		m_rtxblkmask;	/* rt extent block mask */
 	struct xfs_ino_geometry	m_ino_geo;	/* inode geometry */
 	struct xfs_trans_resv	m_resv;		/* precomputed res values */
 						/* low free space thresholds */
diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index b74ba5e51cf8..3573dfef5dd7 100644
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
index 3e81826c9a0a..f39c5daeef86 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -710,6 +710,10 @@ xfs_trans_unreserve_and_mod_sb(
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

