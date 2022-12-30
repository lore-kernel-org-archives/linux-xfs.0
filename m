Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 454AAC4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 01:31:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236102AbiLaBbn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 20:31:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236082AbiLaBbl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 20:31:41 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 551E8DEB7
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 17:31:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0B659B81DFC
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 01:31:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DE46C433D2;
        Sat, 31 Dec 2022 01:31:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672450297;
        bh=L7RxfY9rMIxVcd6ta+cPT8w9NutqU3HrJWcOhk5VY7g=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=VDhmVXd7XwASL0zwxLBJqyhnHcUfv21l0i+ks9yWj7NONSluD2IvR52tpL8Nxa7D/
         njR/4QcxKCP5U4ZlpE1lWwAHUgybHrDRhJDPnLABzo+0NAH6U/0ME18Q7IaXs0xgdz
         xSf1nPAPqKbZAFmfOp0j/A63cUt9k9VBQ6IJIe4irSOIkDiyYlhl9JjYdrSgb5VDq4
         jT/K1Dv3VPJfWLwH6DfKYdT7bMAEJIGLRNoNoJPmIJCO6iXY9/zC7RNX/hHyzmGUte
         N0BUhu5Y0GQoLrXeGH5L8MZhp0NmtSKFQYkRUd5+3MjdX5YOSx4YSo0sYb4B/yKl7Y
         2fTEgwbD/ZEBg==
Subject: [PATCH 16/22] xfs: add block headers to realtime summary blocks
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:17:55 -0800
Message-ID: <167243867496.712847.15425012463500364332.stgit@magnolia>
In-Reply-To: <167243867242.712847.10106105868862621775.stgit@magnolia>
References: <167243867242.712847.10106105868862621775.stgit@magnolia>
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
 fs/xfs/libxfs/xfs_format.h      |    1 +
 fs/xfs/libxfs/xfs_rtbitmap.c    |   18 +++++++++++++++---
 fs/xfs/libxfs/xfs_rtbitmap.h    |   18 ++++++++++++++++--
 fs/xfs/libxfs/xfs_shared.h      |    1 +
 fs/xfs/scrub/rtsummary_repair.c |   15 +++++++++++++--
 fs/xfs/xfs_buf_item_recover.c   |   11 +++++++----
 fs/xfs/xfs_rtalloc.c            |    7 +++++--
 7 files changed, 58 insertions(+), 13 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index c7752aaa4478..47b2e31e2560 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -1287,6 +1287,7 @@ static inline bool xfs_dinode_has_large_extent_counts(
  * RT bit manipulation macros.
  */
 #define XFS_RTBITMAP_MAGIC	0x424D505A	/* BMPZ */
+#define XFS_RTSUMMARY_MAGIC	0x53554D59	/* SUMY */
 
 struct xfs_rtbuf_blkinfo {
 	__be32		rt_magic;	/* validity check on block */
diff --git a/fs/xfs/libxfs/xfs_rtbitmap.c b/fs/xfs/libxfs/xfs_rtbitmap.c
index 3e99afea78a6..3d5b14cc0f3a 100644
--- a/fs/xfs/libxfs/xfs_rtbitmap.c
+++ b/fs/xfs/libxfs/xfs_rtbitmap.c
@@ -53,7 +53,7 @@ xfs_rtbuf_verify_read(
 	struct xfs_rtbuf_blkinfo	*hdr = bp->b_addr;
 	xfs_failaddr_t			fa;
 
-	if (!xfs_has_rtgroups(mp) || bp->b_ops != &xfs_rtbitmap_buf_ops)
+	if (!xfs_has_rtgroups(mp))
 		return;
 
 	if (!xfs_log_check_lsn(mp, be64_to_cpu(hdr->rt_lsn))) {
@@ -84,7 +84,7 @@ xfs_rtbuf_verify_write(
 	struct xfs_buf_log_item		*bip = bp->b_log_item;
 	xfs_failaddr_t			fa;
 
-	if (!xfs_has_rtgroups(mp) || bp->b_ops != &xfs_rtbitmap_buf_ops)
+	if (!xfs_has_rtgroups(mp))
 		return;
 
 	fa = xfs_rtbuf_verify(bp);
@@ -112,6 +112,14 @@ const struct xfs_buf_ops xfs_rtbitmap_buf_ops = {
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
@@ -153,7 +161,7 @@ xfs_rtbuf_get(
 	if (error)
 		return error;
 
-	if (xfs_has_rtgroups(mp) && !issum) {
+	if (xfs_has_rtgroups(mp)) {
 		struct xfs_rtbuf_blkinfo *hdr = bp->b_addr;
 
 		if (hdr->rt_owner != cpu_to_be64(ip->i_ino)) {
@@ -1321,6 +1329,10 @@ xfs_rtsummary_blockcount(
 	unsigned long long	rsumwords;
 
 	rsumwords = (unsigned long long)rsumlevels * rbmblocks;
+
+	if (xfs_has_rtgroups(mp))
+		return howmany_64(rsumwords, mp->m_blockwsize);
+
 	return XFS_B_TO_FSB(mp, rsumwords << XFS_WORDLOG);
 }
 
diff --git a/fs/xfs/libxfs/xfs_rtbitmap.h b/fs/xfs/libxfs/xfs_rtbitmap.h
index c1f740fd27b8..cebbb72c4376 100644
--- a/fs/xfs/libxfs/xfs_rtbitmap.h
+++ b/fs/xfs/libxfs/xfs_rtbitmap.h
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
 
diff --git a/fs/xfs/libxfs/xfs_shared.h b/fs/xfs/libxfs/xfs_shared.h
index 1c86163915cf..62839fc87b50 100644
--- a/fs/xfs/libxfs/xfs_shared.h
+++ b/fs/xfs/libxfs/xfs_shared.h
@@ -39,6 +39,7 @@ extern const struct xfs_buf_ops xfs_inode_buf_ra_ops;
 extern const struct xfs_buf_ops xfs_refcountbt_buf_ops;
 extern const struct xfs_buf_ops xfs_rmapbt_buf_ops;
 extern const struct xfs_buf_ops xfs_rtbitmap_buf_ops;
+extern const struct xfs_buf_ops xfs_rtsummary_buf_ops;
 extern const struct xfs_buf_ops xfs_rtbuf_ops;
 extern const struct xfs_buf_ops xfs_rtsb_buf_ops;
 extern const struct xfs_buf_ops xfs_sb_buf_ops;
diff --git a/fs/xfs/scrub/rtsummary_repair.c b/fs/xfs/scrub/rtsummary_repair.c
index 713b79a1f52a..0836c1e10504 100644
--- a/fs/xfs/scrub/rtsummary_repair.c
+++ b/fs/xfs/scrub/rtsummary_repair.c
@@ -88,13 +88,24 @@ xrep_rtsummary_prep_buf(
 	struct xfs_mount	*mp = sc->mp;
 	int			error;
 
-	bp->b_ops = &xfs_rtbuf_ops;
-
 	error = xfsum_copyout(sc, rs->prep_wordoff,
 			xfs_rsumblock_infoptr(bp, 0), mp->m_blockwsize);
 	if (error)
 		return error;
 
+	if (xfs_has_rtgroups(sc->mp)) {
+		struct xfs_rtbuf_blkinfo	*hdr = bp->b_addr;
+
+		hdr->rt_magic = cpu_to_be32(XFS_RTSUMMARY_MAGIC);
+		hdr->rt_owner = cpu_to_be64(sc->ip->i_ino);
+		hdr->rt_blkno = cpu_to_be64(xfs_buf_daddr(bp));
+		hdr->rt_lsn = 0;
+		uuid_copy(&hdr->rt_uuid, &sc->mp->m_sb.sb_meta_uuid);
+		bp->b_ops = &xfs_rtsummary_buf_ops;
+	} else {
+		bp->b_ops = &xfs_rtbuf_ops;
+	}
+
 	rs->prep_wordoff += mp->m_blockwsize;
 	xfs_trans_buf_set_type(sc->tp, bp, XFS_BLFT_RTSUMMARY_BUF);
 	return 0;
diff --git a/fs/xfs/xfs_buf_item_recover.c b/fs/xfs/xfs_buf_item_recover.c
index 4dcd5d9d2c7c..b74d40f5beb1 100644
--- a/fs/xfs/xfs_buf_item_recover.c
+++ b/fs/xfs/xfs_buf_item_recover.c
@@ -399,7 +399,10 @@ xlog_recover_validate_buf_type(
 		bp->b_ops = xfs_rtblock_ops(mp, false);
 		break;
 	case XFS_BLFT_RTSUMMARY_BUF:
-		/* no magic numbers for verification of RT buffers */
+		if (xfs_has_rtgroups(mp) && magic32 != XFS_RTSUMMARY_MAGIC) {
+			warnmsg = "Bad rtsummary magic!";
+			break;
+		}
 		bp->b_ops = xfs_rtblock_ops(mp, true);
 		break;
 #endif /* CONFIG_XFS_RT */
@@ -735,13 +738,13 @@ xlog_recover_get_buf_lsn(
 	 * UUIDs, so we must recover them immediately.
 	 */
 	blft = xfs_blft_from_flags(buf_f);
-	if (!xfs_has_rtgroups(mp) && blft == XFS_BLFT_RTBITMAP_BUF)
-		goto recover_immediately;
-	if (blft == XFS_BLFT_RTSUMMARY_BUF)
+	if (!xfs_has_rtgroups(mp) && (blft == XFS_BLFT_RTBITMAP_BUF ||
+				      blft == XFS_BLFT_RTSUMMARY_BUF))
 		goto recover_immediately;
 
 	magic32 = be32_to_cpu(*(__be32 *)blk);
 	switch (magic32) {
+	case XFS_RTSUMMARY_MAGIC:
 	case XFS_RTBITMAP_MAGIC: {
 		struct xfs_rtbuf_blkinfo	*hdr = blk;
 
diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 9e013a8e3149..f8f0557dc46c 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -814,10 +814,13 @@ xfs_growfs_init_rtbuf(
 	bp->b_ops = xfs_rtblock_ops(mp, buf_type == XFS_BLFT_RTSUMMARY_BUF);
 	memset(bp->b_addr, 0, mp->m_sb.sb_blocksize);
 
-	if (xfs_has_rtgroups(mp) && buf_type == XFS_BLFT_RTBITMAP_BUF) {
+	if (xfs_has_rtgroups(mp)) {
 		struct xfs_rtbuf_blkinfo	*hdr = bp->b_addr;
 
-		hdr->rt_magic = cpu_to_be32(XFS_RTBITMAP_MAGIC);
+		if (buf_type == XFS_BLFT_RTBITMAP_BUF)
+			hdr->rt_magic = cpu_to_be32(XFS_RTBITMAP_MAGIC);
+		else
+			hdr->rt_magic = cpu_to_be32(XFS_RTSUMMARY_MAGIC);
 		hdr->rt_owner = cpu_to_be64(ip->i_ino);
 		hdr->rt_blkno = cpu_to_be64(d);
 		uuid_copy(&hdr->rt_uuid, &mp->m_sb.sb_meta_uuid);

