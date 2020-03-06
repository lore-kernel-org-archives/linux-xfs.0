Return-Path: <SRS0=P3J0=4X=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9EE9C10DCE
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Mar 2020 14:52:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B167320726
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Mar 2020 14:52:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="PGifgTUS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726954AbgCFOw0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 6 Mar 2020 09:52:26 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:52896 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726182AbgCFOw0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 6 Mar 2020 09:52:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=JJHLNRXIDv0oHxeyD1hcANu4vSU/s28tOODQ8cnCV9k=; b=PGifgTUSkZGa/NXaR0UR97zyja
        vqA8gKfx2VuG8ctlWl1jNMUZzhhtTnmYdQGGH2bDEm+HeBIDAdtISpi7HPvSrnScpt7FkNCH3vx50
        5fkboJNpu5ZdlgiyReGodg56Z4i6bfggK0XWOrdP7LcmUEd473pdJmhL2+ypU16Fqc9A/i1Bj/p5g
        EOYDRUTUZQlWVd2t2gle95oNMuxwKT+UmwBwBM/HE1/R1X+Qh96UgTHvLESL2SYGZ6iwZK+wh2kkA
        nD6lHj4VI5kQNJiGyD0WzTPAh7A/7eUPAEC04pdhL6QpMtoXGZ0oug1WrUvl6GUxgGUK+lp5JbNoN
        xmIUr2Qw==;
Received: from [162.248.129.185] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jAEKv-0008CV-Oy; Fri, 06 Mar 2020 14:52:25 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 6/6] xfs: remove XFS_BUF_TO_SBP
Date:   Fri,  6 Mar 2020 07:52:20 -0700
Message-Id: <20200306145220.242562-7-hch@lst.de>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200306145220.242562-1-hch@lst.de>
References: <20200306145220.242562-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Just dereference bp->b_addr directly and make the code a little
simpler and more clear.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_ag.c         |  2 +-
 fs/xfs/libxfs/xfs_format.h     |  1 -
 fs/xfs/libxfs/xfs_sb.c         | 17 +++++++++--------
 fs/xfs/scrub/agheader.c        |  2 +-
 fs/xfs/scrub/agheader_repair.c |  2 +-
 fs/xfs/xfs_log_recover.c       |  2 +-
 fs/xfs/xfs_mount.c             |  2 +-
 fs/xfs/xfs_trans.c             |  2 +-
 8 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_ag.c b/fs/xfs/libxfs/xfs_ag.c
index 447e363d8468..f9b8c177ebc3 100644
--- a/fs/xfs/libxfs/xfs_ag.c
+++ b/fs/xfs/libxfs/xfs_ag.c
@@ -231,7 +231,7 @@ xfs_sbblock_init(
 	struct xfs_buf		*bp,
 	struct aghdr_init_data	*id)
 {
-	struct xfs_dsb		*dsb = XFS_BUF_TO_SBP(bp);
+	struct xfs_dsb		*dsb = bp->b_addr;
 
 	xfs_sb_to_disk(dsb, &mp->m_sb);
 	dsb->sb_inprogress = 1;
diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index 03531f0f537a..81a1b7084008 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -560,7 +560,6 @@ xfs_is_quota_inode(struct xfs_sb *sbp, xfs_ino_t ino)
 
 #define XFS_SB_DADDR		((xfs_daddr_t)0) /* daddr in filesystem/ag */
 #define	XFS_SB_BLOCK(mp)	XFS_HDR_BLOCK(mp, XFS_SB_DADDR)
-#define XFS_BUF_TO_SBP(bp)	((xfs_dsb_t *)((bp)->b_addr))
 
 #define	XFS_HDR_BLOCK(mp,d)	((xfs_agblock_t)XFS_BB_TO_FSBT(mp,d))
 #define	XFS_DADDR_TO_FSB(mp,d)	XFS_AGB_TO_FSB(mp, \
diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index 2f60fc3c99a0..00266de58954 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -220,7 +220,7 @@ xfs_validate_sb_common(
 	struct xfs_buf		*bp,
 	struct xfs_sb		*sbp)
 {
-	struct xfs_dsb		*dsb = XFS_BUF_TO_SBP(bp);
+	struct xfs_dsb		*dsb = bp->b_addr;
 	uint32_t		agcount = 0;
 	uint32_t		rem;
 
@@ -681,7 +681,7 @@ xfs_sb_read_verify(
 {
 	struct xfs_sb		sb;
 	struct xfs_mount	*mp = bp->b_mount;
-	struct xfs_dsb		*dsb = XFS_BUF_TO_SBP(bp);
+	struct xfs_dsb		*dsb = bp->b_addr;
 	int			error;
 
 	/*
@@ -707,7 +707,7 @@ xfs_sb_read_verify(
 	 * Check all the superblock fields.  Don't byteswap the xquota flags
 	 * because _verify_common checks the on-disk values.
 	 */
-	__xfs_sb_from_disk(&sb, XFS_BUF_TO_SBP(bp), false);
+	__xfs_sb_from_disk(&sb, dsb, false);
 	error = xfs_validate_sb_common(mp, bp, &sb);
 	if (error)
 		goto out_error;
@@ -730,7 +730,7 @@ static void
 xfs_sb_quiet_read_verify(
 	struct xfs_buf	*bp)
 {
-	struct xfs_dsb	*dsb = XFS_BUF_TO_SBP(bp);
+	struct xfs_dsb	*dsb = bp->b_addr;
 
 	if (dsb->sb_magicnum == cpu_to_be32(XFS_SB_MAGIC)) {
 		/* XFS filesystem, verify noisily! */
@@ -748,13 +748,14 @@ xfs_sb_write_verify(
 	struct xfs_sb		sb;
 	struct xfs_mount	*mp = bp->b_mount;
 	struct xfs_buf_log_item	*bip = bp->b_log_item;
+	struct xfs_dsb		*dsb = bp->b_addr;
 	int			error;
 
 	/*
 	 * Check all the superblock fields.  Don't byteswap the xquota flags
 	 * because _verify_common checks the on-disk values.
 	 */
-	__xfs_sb_from_disk(&sb, XFS_BUF_TO_SBP(bp), false);
+	__xfs_sb_from_disk(&sb, dsb, false);
 	error = xfs_validate_sb_common(mp, bp, &sb);
 	if (error)
 		goto out_error;
@@ -766,7 +767,7 @@ xfs_sb_write_verify(
 		return;
 
 	if (bip)
-		XFS_BUF_TO_SBP(bp)->sb_lsn = cpu_to_be64(bip->bli_item.li_lsn);
+		dsb->sb_lsn = cpu_to_be64(bip->bli_item.li_lsn);
 
 	xfs_buf_update_cksum(bp, XFS_SB_CRC_OFF);
 	return;
@@ -927,7 +928,7 @@ xfs_log_sb(
 	mp->m_sb.sb_ifree = percpu_counter_sum(&mp->m_ifree);
 	mp->m_sb.sb_fdblocks = percpu_counter_sum(&mp->m_fdblocks);
 
-	xfs_sb_to_disk(XFS_BUF_TO_SBP(bp), &mp->m_sb);
+	xfs_sb_to_disk(bp->b_addr, &mp->m_sb);
 	xfs_trans_buf_set_type(tp, bp, XFS_BLFT_SB_BUF);
 	xfs_trans_log_buf(tp, bp, 0, sizeof(struct xfs_dsb) - 1);
 }
@@ -1007,7 +1008,7 @@ xfs_update_secondary_sbs(
 		bp->b_ops = &xfs_sb_buf_ops;
 		xfs_buf_oneshot(bp);
 		xfs_buf_zero(bp, 0, BBTOB(bp->b_length));
-		xfs_sb_to_disk(XFS_BUF_TO_SBP(bp), &mp->m_sb);
+		xfs_sb_to_disk(bp->b_addr, &mp->m_sb);
 		xfs_buf_delwri_queue(bp, &buffer_list);
 		xfs_buf_relse(bp);
 
diff --git a/fs/xfs/scrub/agheader.c b/fs/xfs/scrub/agheader.c
index 163478855e7b..e9bcf1faa183 100644
--- a/fs/xfs/scrub/agheader.c
+++ b/fs/xfs/scrub/agheader.c
@@ -92,7 +92,7 @@ xchk_superblock(
 	if (!xchk_process_error(sc, agno, XFS_SB_BLOCK(mp), &error))
 		return error;
 
-	sb = XFS_BUF_TO_SBP(bp);
+	sb = bp->b_addr;
 
 	/*
 	 * Verify the geometries match.  Fields that are permanently
diff --git a/fs/xfs/scrub/agheader_repair.c b/fs/xfs/scrub/agheader_repair.c
index c801f5892210..31dbb5d556fd 100644
--- a/fs/xfs/scrub/agheader_repair.c
+++ b/fs/xfs/scrub/agheader_repair.c
@@ -49,7 +49,7 @@ xrep_superblock(
 
 	/* Copy AG 0's superblock to this one. */
 	xfs_buf_zero(bp, 0, BBTOB(bp->b_length));
-	xfs_sb_to_disk(XFS_BUF_TO_SBP(bp), &mp->m_sb);
+	xfs_sb_to_disk(bp->b_addr, &mp->m_sb);
 
 	/* Write this to disk. */
 	xfs_trans_buf_set_type(sc->tp, bp, XFS_BLFT_SB_BUF);
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index b6cf99f7153f..6abc0863c9c3 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -5636,7 +5636,7 @@ xlog_do_recover(
 
 	/* Convert superblock from on-disk format */
 	sbp = &mp->m_sb;
-	xfs_sb_from_disk(sbp, XFS_BUF_TO_SBP(bp));
+	xfs_sb_from_disk(sbp, bp->b_addr);
 	xfs_buf_relse(bp);
 
 	/* re-initialise in-core superblock and geometry structures */
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 56efe140c923..c5513e5a226a 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -310,7 +310,7 @@ xfs_readsb(
 	/*
 	 * Initialize the mount structure from the superblock.
 	 */
-	xfs_sb_from_disk(sbp, XFS_BUF_TO_SBP(bp));
+	xfs_sb_from_disk(sbp, bp->b_addr);
 
 	/*
 	 * If we haven't validated the superblock, do so now before we try
diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index 3b208f9a865c..73c534093f09 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -450,7 +450,7 @@ xfs_trans_apply_sb_deltas(
 	int		whole = 0;
 
 	bp = xfs_trans_getsb(tp, tp->t_mountp);
-	sbp = XFS_BUF_TO_SBP(bp);
+	sbp = bp->b_addr;
 
 	/*
 	 * Check that superblock mods match the mods made to AGF counters.
-- 
2.24.1

