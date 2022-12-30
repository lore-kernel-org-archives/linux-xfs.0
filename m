Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 876D0C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 02:33:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236147AbiLaCdp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 21:33:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236248AbiLaCdn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 21:33:43 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEBFD1CB1F
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 18:33:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 97F67B81C22
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 02:33:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E2AFC433D2;
        Sat, 31 Dec 2022 02:33:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672454020;
        bh=yoRJUmyHT3mlr6KKAbAAV9kDUeAV4fmkSljR3RaJH/g=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=qC7eD4jjSki7iEz+6Ep6uuPrDsRx4DvRmK2wIFWD4yERBR6Ui8Xe64BFMCTl4CTyc
         Ey133k3TPbf77YhTNzC9PdXGhxgjDPREsv+vbNuMeyTVu2sMBk/Q45qyvX+TQDpSsE
         H2YsukZHCV6LfIaOqLqgw+3GQDlnWK1UuFqCE8gILO0WX+GlQVvNYnhhJBUwzWN6ph
         thJcTwjmDEJS9tsjOQk/Zc4HxiNe2FAc4y/VHQGvvHwJ879WriwHtjEzdrjUbjhWqY
         gqcyTCLYbDY2+vze7lDSuTwOybyJInE5Wk+496KHplBm6aIG/7Xa8/m2C5GY5K5GeK
         wzia4Ojq4La0w==
Subject: [PATCH 14/45] xfs: add block headers to realtime summary blocks
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:19:45 -0800
Message-ID: <167243878549.731133.11237553640942198037.stgit@magnolia>
In-Reply-To: <167243878346.731133.14642166452774753637.stgit@magnolia>
References: <167243878346.731133.14642166452774753637.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Upgrade rtsummary blocks to have self describing metadata like most
every other thing in XFS.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_format.h   |    1 +
 libxfs/xfs_rtbitmap.c |   18 +++++++++++++++---
 libxfs/xfs_rtbitmap.h |   18 ++++++++++++++++--
 libxfs/xfs_shared.h   |    1 +
 4 files changed, 33 insertions(+), 5 deletions(-)


diff --git a/libxfs/xfs_format.h b/libxfs/xfs_format.h
index c7752aaa447..47b2e31e256 100644
--- a/libxfs/xfs_format.h
+++ b/libxfs/xfs_format.h
@@ -1287,6 +1287,7 @@ static inline bool xfs_dinode_has_large_extent_counts(
  * RT bit manipulation macros.
  */
 #define XFS_RTBITMAP_MAGIC	0x424D505A	/* BMPZ */
+#define XFS_RTSUMMARY_MAGIC	0x53554D59	/* SUMY */
 
 struct xfs_rtbuf_blkinfo {
 	__be32		rt_magic;	/* validity check on block */
diff --git a/libxfs/xfs_rtbitmap.c b/libxfs/xfs_rtbitmap.c
index db80f740151..4ed3bd261f6 100644
--- a/libxfs/xfs_rtbitmap.c
+++ b/libxfs/xfs_rtbitmap.c
@@ -49,7 +49,7 @@ xfs_rtbuf_verify_read(
 	struct xfs_rtbuf_blkinfo	*hdr = bp->b_addr;
 	xfs_failaddr_t			fa;
 
-	if (!xfs_has_rtgroups(mp) || bp->b_ops != &xfs_rtbitmap_buf_ops)
+	if (!xfs_has_rtgroups(mp))
 		return;
 
 	if (!xfs_log_check_lsn(mp, be64_to_cpu(hdr->rt_lsn))) {
@@ -80,7 +80,7 @@ xfs_rtbuf_verify_write(
 	struct xfs_buf_log_item		*bip = bp->b_log_item;
 	xfs_failaddr_t			fa;
 
-	if (!xfs_has_rtgroups(mp) || bp->b_ops != &xfs_rtbitmap_buf_ops)
+	if (!xfs_has_rtgroups(mp))
 		return;
 
 	fa = xfs_rtbuf_verify(bp);
@@ -108,6 +108,14 @@ const struct xfs_buf_ops xfs_rtbitmap_buf_ops = {
 	.verify_struct	= xfs_rtbuf_verify,
 };
 
+const struct xfs_buf_ops xfs_rtsummary_buf_ops = {
+	.name		= "xfs_rtsummary",
+	.magic		= { 0, cpu_to_be32(XFS_RTSUMMARY_MAGIC) },
+	.verify_read	= xfs_rtbuf_verify_read,
+	.verify_write	= xfs_rtbuf_verify_write,
+	.verify_struct	= xfs_rtbuf_verify,
+};
+
 /*
  * Get a buffer for the bitmap or summary file block specified.
  * The buffer is returned read and locked.
@@ -149,7 +157,7 @@ xfs_rtbuf_get(
 	if (error)
 		return error;
 
-	if (xfs_has_rtgroups(mp) && !issum) {
+	if (xfs_has_rtgroups(mp)) {
 		struct xfs_rtbuf_blkinfo *hdr = bp->b_addr;
 
 		if (hdr->rt_owner != cpu_to_be64(ip->i_ino)) {
@@ -1317,6 +1325,10 @@ xfs_rtsummary_blockcount(
 	unsigned long long	rsumwords;
 
 	rsumwords = (unsigned long long)rsumlevels * rbmblocks;
+
+	if (xfs_has_rtgroups(mp))
+		return howmany_64(rsumwords, mp->m_blockwsize);
+
 	return XFS_B_TO_FSB(mp, rsumwords << XFS_WORDLOG);
 }
 
diff --git a/libxfs/xfs_rtbitmap.h b/libxfs/xfs_rtbitmap.h
index c1f740fd27b..cebbb72c437 100644
--- a/libxfs/xfs_rtbitmap.h
+++ b/libxfs/xfs_rtbitmap.h
@@ -181,6 +181,9 @@ xfs_rtsumoffs_to_block(
 	struct xfs_mount	*mp,
 	xfs_rtsumoff_t		rsumoff)
 {
+	if (xfs_has_rtgroups(mp))
+		return rsumoff / mp->m_blockwsize;
+
 	return XFS_B_TO_FSBT(mp, rsumoff * sizeof(xfs_suminfo_t));
 }
 
@@ -195,16 +198,24 @@ xfs_rtsumoffs_to_infoword(
 {
 	unsigned int		mask = mp->m_blockmask >> XFS_SUMINFOLOG;
 
+	if (xfs_has_rtgroups(mp))
+		return rsumoff % mp->m_blockwsize;
+
 	return rsumoff & mask;
 }
 
 /* Return a pointer to a summary info word within a rt summary block buffer. */
 static inline union xfs_suminfo_ondisk *
 xfs_rsumbuf_infoptr(
+	struct xfs_mount	*mp,
 	void			*buf,
 	unsigned int		infoword)
 {
 	union xfs_suminfo_ondisk *infop = buf;
+	struct xfs_rtbuf_blkinfo *hdr = buf;
+
+	if (xfs_has_rtgroups(mp))
+		infop = (union xfs_suminfo_ondisk *)(hdr + 1);
 
 	return &infop[infoword];
 }
@@ -215,7 +226,7 @@ xfs_rsumblock_infoptr(
 	struct xfs_buf		*bp,
 	unsigned int		infoword)
 {
-	return xfs_rsumbuf_infoptr(bp->b_addr, infoword);
+	return xfs_rsumbuf_infoptr(bp->b_mount, bp->b_addr, infoword);
 }
 
 static inline const struct xfs_buf_ops *
@@ -223,8 +234,11 @@ xfs_rtblock_ops(
 	struct xfs_mount	*mp,
 	bool			issum)
 {
-	if (xfs_has_rtgroups(mp) && !issum)
+	if (xfs_has_rtgroups(mp)) {
+		if (issum)
+			return &xfs_rtsummary_buf_ops;
 		return &xfs_rtbitmap_buf_ops;
+	}
 	return &xfs_rtbuf_ops;
 }
 
diff --git a/libxfs/xfs_shared.h b/libxfs/xfs_shared.h
index 1c86163915c..62839fc87b5 100644
--- a/libxfs/xfs_shared.h
+++ b/libxfs/xfs_shared.h
@@ -39,6 +39,7 @@ extern const struct xfs_buf_ops xfs_inode_buf_ra_ops;
 extern const struct xfs_buf_ops xfs_refcountbt_buf_ops;
 extern const struct xfs_buf_ops xfs_rmapbt_buf_ops;
 extern const struct xfs_buf_ops xfs_rtbitmap_buf_ops;
+extern const struct xfs_buf_ops xfs_rtsummary_buf_ops;
 extern const struct xfs_buf_ops xfs_rtbuf_ops;
 extern const struct xfs_buf_ops xfs_rtsb_buf_ops;
 extern const struct xfs_buf_ops xfs_sb_buf_ops;

