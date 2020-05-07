Return-Path: <SRS0=M5eb=6V=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C044C4724C
	for <linux-xfs@archiver.kernel.org>; Thu,  7 May 2020 12:20:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0743A21582
	for <linux-xfs@archiver.kernel.org>; Thu,  7 May 2020 12:20:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="JG82hz7K"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725964AbgEGMUL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 7 May 2020 08:20:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725903AbgEGMUL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 May 2020 08:20:11 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23DF9C05BD43
        for <linux-xfs@vger.kernel.org>; Thu,  7 May 2020 05:20:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=9hKKJZ4iEMT19TTp6biTTPV8Fzs8QgRPvG92R65LPI0=; b=JG82hz7KoZQLoXrbzV7iQY+Tpl
        DpS0nqvGXRB9sCCq72u0O0tV4SIvKQm+g09iHRBXMmSPLbH7kiwG+JH6cDDm8nrLLoWHHIJYO8XCA
        57ynZaB//JAjyMHDn+TUvJtOEGEwnOdwGGJsoXMeYOonVmPuehmX5mvr3Ni8rzUBRHVeEbr75BsYy
        rTynw4Mv7H3efowCOXsg2QjQN2iMzc1zBykvzZceq+hRM8DXmQb2AImjwHnFV4YUTbPwBTaagbLKx
        bzjUxtO9AOL/SUoHn94UawjsjAfdWc7Y30PNCZWeExsAG0zJFNJQlxXDUurpXKeiRthjqkDiKpJLL
        sjL8oXqw==;
Received: from [2001:4bb8:180:9d3f:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jWfVZ-0006hb-Ju; Thu, 07 May 2020 12:20:09 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     sandeen@sandeen.net
Cc:     linux-xfs@vger.kernel.org, Brian Foster <bfoster@redhat.com>,
        Eric Sandeen <sandeen@redhat.com>,
        "Darrick J . Wong" <darrick.wong@oracle.com>
Subject: [PATCH 31/58] xfs: remove XFS_BUF_TO_SBP
Date:   Thu,  7 May 2020 14:18:24 +0200
Message-Id: <20200507121851.304002-32-hch@lst.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200507121851.304002-1-hch@lst.de>
References: <20200507121851.304002-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Source kernel commit: 3e6e8afd3abb745871ee215738a899a495c54a66

Just dereference bp->b_addr directly and make the code a little
simpler and more clear.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Eric Sandeen <sandeen@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 copy/xfs_copy.c     |  2 +-
 db/init.c           |  2 +-
 libxfs/xfs_ag.c     |  2 +-
 libxfs/xfs_format.h |  1 -
 libxfs/xfs_sb.c     | 17 +++++++++--------
 mkfs/xfs_mkfs.c     |  8 +++++---
 repair/agheader.c   |  2 +-
 repair/phase5.c     |  2 +-
 repair/scan.c       |  4 ++--
 repair/xfs_repair.c |  4 ++--
 10 files changed, 23 insertions(+), 21 deletions(-)

diff --git a/copy/xfs_copy.c b/copy/xfs_copy.c
index 72ce3fe7..2d087f71 100644
--- a/copy/xfs_copy.c
+++ b/copy/xfs_copy.c
@@ -720,7 +720,7 @@ main(int argc, char **argv)
 	}
 
 	sb = &mbuf.m_sb;
-	libxfs_sb_from_disk(sb, XFS_BUF_TO_SBP(sbp));
+	libxfs_sb_from_disk(sb, sbp->b_addr);
 
 	/* Do it again, now with proper length and verifier */
 	libxfs_buf_relse(sbp);
diff --git a/db/init.c b/db/init.c
index ac649fbd..19f0900a 100644
--- a/db/init.c
+++ b/db/init.c
@@ -119,7 +119,7 @@ init(
 	}
 
 	/* copy SB from buffer to in-core, converting architecture as we go */
-	libxfs_sb_from_disk(&xmount.m_sb, XFS_BUF_TO_SBP(bp));
+	libxfs_sb_from_disk(&xmount.m_sb, bp->b_addr);
 	libxfs_buf_relse(bp);
 
 	sbp = &xmount.m_sb;
diff --git a/libxfs/xfs_ag.c b/libxfs/xfs_ag.c
index c6160df7..9ce7abd7 100644
--- a/libxfs/xfs_ag.c
+++ b/libxfs/xfs_ag.c
@@ -231,7 +231,7 @@ xfs_sbblock_init(
 	struct xfs_buf		*bp,
 	struct aghdr_init_data	*id)
 {
-	struct xfs_dsb		*dsb = XFS_BUF_TO_SBP(bp);
+	struct xfs_dsb		*dsb = bp->b_addr;
 
 	xfs_sb_to_disk(dsb, &mp->m_sb);
 	dsb->sb_inprogress = 1;
diff --git a/libxfs/xfs_format.h b/libxfs/xfs_format.h
index 1fec1302..09fd5d23 100644
--- a/libxfs/xfs_format.h
+++ b/libxfs/xfs_format.h
@@ -560,7 +560,6 @@ xfs_is_quota_inode(struct xfs_sb *sbp, xfs_ino_t ino)
 
 #define XFS_SB_DADDR		((xfs_daddr_t)0) /* daddr in filesystem/ag */
 #define	XFS_SB_BLOCK(mp)	XFS_HDR_BLOCK(mp, XFS_SB_DADDR)
-#define XFS_BUF_TO_SBP(bp)	((xfs_dsb_t *)((bp)->b_addr))
 
 #define	XFS_HDR_BLOCK(mp,d)	((xfs_agblock_t)XFS_BB_TO_FSBT(mp,d))
 #define	XFS_DADDR_TO_FSB(mp,d)	XFS_AGB_TO_FSB(mp, \
diff --git a/libxfs/xfs_sb.c b/libxfs/xfs_sb.c
index 687e33d8..e26b9016 100644
--- a/libxfs/xfs_sb.c
+++ b/libxfs/xfs_sb.c
@@ -217,7 +217,7 @@ xfs_validate_sb_common(
 	struct xfs_buf		*bp,
 	struct xfs_sb		*sbp)
 {
-	struct xfs_dsb		*dsb = XFS_BUF_TO_SBP(bp);
+	struct xfs_dsb		*dsb = bp->b_addr;
 	uint32_t		agcount = 0;
 	uint32_t		rem;
 
@@ -658,7 +658,7 @@ xfs_sb_read_verify(
 {
 	struct xfs_sb		sb;
 	struct xfs_mount	*mp = bp->b_mount;
-	struct xfs_dsb		*dsb = XFS_BUF_TO_SBP(bp);
+	struct xfs_dsb		*dsb = bp->b_addr;
 	int			error;
 
 	/*
@@ -684,7 +684,7 @@ xfs_sb_read_verify(
 	 * Check all the superblock fields.  Don't byteswap the xquota flags
 	 * because _verify_common checks the on-disk values.
 	 */
-	__xfs_sb_from_disk(&sb, XFS_BUF_TO_SBP(bp), false);
+	__xfs_sb_from_disk(&sb, dsb, false);
 	error = xfs_validate_sb_common(mp, bp, &sb);
 	if (error)
 		goto out_error;
@@ -707,7 +707,7 @@ static void
 xfs_sb_quiet_read_verify(
 	struct xfs_buf	*bp)
 {
-	struct xfs_dsb	*dsb = XFS_BUF_TO_SBP(bp);
+	struct xfs_dsb	*dsb = bp->b_addr;
 
 	if (dsb->sb_magicnum == cpu_to_be32(XFS_SB_MAGIC)) {
 		/* XFS filesystem, verify noisily! */
@@ -725,13 +725,14 @@ xfs_sb_write_verify(
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
@@ -743,7 +744,7 @@ xfs_sb_write_verify(
 		return;
 
 	if (bip)
-		XFS_BUF_TO_SBP(bp)->sb_lsn = cpu_to_be64(bip->bli_item.li_lsn);
+		dsb->sb_lsn = cpu_to_be64(bip->bli_item.li_lsn);
 
 	xfs_buf_update_cksum(bp, XFS_SB_CRC_OFF);
 	return;
@@ -904,7 +905,7 @@ xfs_log_sb(
 	mp->m_sb.sb_ifree = percpu_counter_sum(&mp->m_ifree);
 	mp->m_sb.sb_fdblocks = percpu_counter_sum(&mp->m_fdblocks);
 
-	xfs_sb_to_disk(XFS_BUF_TO_SBP(bp), &mp->m_sb);
+	xfs_sb_to_disk(bp->b_addr, &mp->m_sb);
 	xfs_trans_buf_set_type(tp, bp, XFS_BLFT_SB_BUF);
 	xfs_trans_log_buf(tp, bp, 0, sizeof(struct xfs_dsb) - 1);
 }
@@ -984,7 +985,7 @@ xfs_update_secondary_sbs(
 		bp->b_ops = &xfs_sb_buf_ops;
 		xfs_buf_oneshot(bp);
 		xfs_buf_zero(bp, 0, BBTOB(bp->b_length));
-		xfs_sb_to_disk(XFS_BUF_TO_SBP(bp), &mp->m_sb);
+		xfs_sb_to_disk(bp->b_addr, &mp->m_sb);
 		xfs_buf_delwri_queue(bp, &buffer_list);
 		xfs_buf_relse(bp);
 
diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 039b1dcc..e76d2a7a 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -3490,6 +3490,7 @@ rewrite_secondary_superblocks(
 	struct xfs_mount	*mp)
 {
 	struct xfs_buf		*buf;
+	struct xfs_dsb		*sb;
 	int			error;
 
 	/* rewrite the last superblock */
@@ -3502,7 +3503,8 @@ rewrite_secondary_superblocks(
 				progname, mp->m_sb.sb_agcount - 1);
 		exit(1);
 	}
-	XFS_BUF_TO_SBP(buf)->sb_rootino = cpu_to_be64(mp->m_sb.sb_rootino);
+	sb = buf->b_addr;
+	sb->sb_rootino = cpu_to_be64(mp->m_sb.sb_rootino);
 	libxfs_buf_mark_dirty(buf);
 	libxfs_buf_relse(buf);
 
@@ -3519,7 +3521,7 @@ rewrite_secondary_superblocks(
 				progname, (mp->m_sb.sb_agcount - 1) / 2);
 		exit(1);
 	}
-	XFS_BUF_TO_SBP(buf)->sb_rootino = cpu_to_be64(mp->m_sb.sb_rootino);
+	sb->sb_rootino = cpu_to_be64(mp->m_sb.sb_rootino);
 	libxfs_buf_mark_dirty(buf);
 	libxfs_buf_relse(buf);
 }
@@ -3867,7 +3869,7 @@ main(
 	buf = libxfs_getsb(mp);
 	if (!buf || buf->b_error)
 		exit(1);
-	(XFS_BUF_TO_SBP(buf))->sb_inprogress = 0;
+	((struct xfs_dsb *)buf->b_addr)->sb_inprogress = 0;
 	libxfs_buf_mark_dirty(buf);
 	libxfs_buf_relse(buf);
 
diff --git a/repair/agheader.c b/repair/agheader.c
index 218ee256..f28d8a7b 100644
--- a/repair/agheader.c
+++ b/repair/agheader.c
@@ -241,7 +241,7 @@ secondary_sb_whack(
 	struct xfs_sb	*sb,
 	xfs_agnumber_t	i)
 {
-	struct xfs_dsb	*dsb = XFS_BUF_TO_SBP(sbuf);
+	struct xfs_dsb	*dsb = sbuf->b_addr;
 	int		do_bzero = 0;
 	int		size;
 	char		*ip;
diff --git a/repair/phase5.c b/repair/phase5.c
index fd7659dc..677297fe 100644
--- a/repair/phase5.c
+++ b/repair/phase5.c
@@ -2263,7 +2263,7 @@ sync_sb(xfs_mount_t *mp)
 
 	update_sb_version(mp);
 
-	libxfs_sb_to_disk(XFS_BUF_TO_SBP(bp), &mp->m_sb);
+	libxfs_sb_to_disk(bp->b_addr, &mp->m_sb);
 	libxfs_buf_mark_dirty(bp);
 	libxfs_buf_relse(bp);
 }
diff --git a/repair/scan.c b/repair/scan.c
index e40ce194..5c8d8b23 100644
--- a/repair/scan.c
+++ b/repair/scan.c
@@ -2375,7 +2375,7 @@ scan_ag(
 		objname = _("root superblock");
 		goto out_free_sb;
 	}
-	libxfs_sb_from_disk(sb, XFS_BUF_TO_SBP(sbbuf));
+	libxfs_sb_from_disk(sb, sbbuf->b_addr);
 
 	error = salvage_buffer(mp->m_dev,
 			XFS_AG_DADDR(mp, agno, XFS_AGF_DADDR(mp)),
@@ -2480,7 +2480,7 @@ scan_ag(
 	if (sb_dirty && !no_modify) {
 		if (agno == 0)
 			memcpy(&mp->m_sb, sb, sizeof(xfs_sb_t));
-		libxfs_sb_to_disk(XFS_BUF_TO_SBP(sbbuf), sb);
+		libxfs_sb_to_disk(sbbuf->b_addr, sb);
 		libxfs_buf_mark_dirty(sbbuf);
 		libxfs_buf_relse(sbbuf);
 	} else
diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
index e509fdeb..9d72fa8e 100644
--- a/repair/xfs_repair.c
+++ b/repair/xfs_repair.c
@@ -478,7 +478,7 @@ guess_correct_sunit(
 		error = -libxfs_sb_read_secondary(mp, NULL, agno, &bp);
 		if (error)
 			continue;
-		libxfs_sb_from_disk(&sb, XFS_BUF_TO_SBP(bp));
+		libxfs_sb_from_disk(&sb, bp->b_addr);
 		libxfs_buf_relse(bp);
 
 		calc_rootino = libxfs_ialloc_calc_rootino(mp, sb.sb_unit);
@@ -1081,7 +1081,7 @@ _("Warning:  project quota information would be cleared.\n"
 	if (!sbp)
 		do_error(_("couldn't get superblock\n"));
 
-	dsb = XFS_BUF_TO_SBP(sbp);
+	dsb = sbp->b_addr;
 
 	if (be16_to_cpu(dsb->sb_qflags) & XFS_ALL_QUOTA_CHKD) {
 		do_warn(_("Note - quota info will be regenerated on next "
-- 
2.26.2

