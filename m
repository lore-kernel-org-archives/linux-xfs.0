Return-Path: <SRS0=P3J0=4X=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53CD6C10F25
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Mar 2020 14:52:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2F05F2084E
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Mar 2020 14:52:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ROGpw0EP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726910AbgCFOwW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 6 Mar 2020 09:52:22 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:52848 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726182AbgCFOwW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 6 Mar 2020 09:52:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=KgeCOb0vm5piuigOH1Q9+rB1Nf+8g5NrkfRQ5tTJ67U=; b=ROGpw0EPG9Sv9w98epUZBflAMy
        N9nRA094FrWWzJYt+hfnrqeXULAURO1KcSGyKOtSB8fsjNrT3jPWXe4ra5+9s2tc0DNKgWliReI2b
        ouLK+t+eGlIkwzMSVXXMBs3wxyjplwfCqGWJAg1c3jw46owu5BdZgYX9UbslcZAJ2A/6kK4lezUNd
        Fi8yLmtdfGK7SKiqFbIcqSPSxagRB3eeDaOIINMKSvwBia6Z7XE9Kd1Zm5/jILYMn1aEzrmwfgSyU
        n2P0sQkSouXY2LsnrAKXWhW5o8YDtmixMEOL0VtGQNqZ9E7yfVkY4plChZmMqBs9/tUR2p7ADlbAi
        isn7jYLg==;
Received: from [162.248.129.185] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jAEKr-0008Be-Vg; Fri, 06 Mar 2020 14:52:22 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 3/6] xfs: remove XFS_BUF_TO_AGFL
Date:   Fri,  6 Mar 2020 07:52:17 -0700
Message-Id: <20200306145220.242562-4-hch@lst.de>
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
Reviewed-by: Eric Sandeen <sandeen@redhat.com>
---
 fs/xfs/libxfs/xfs_ag.c         | 2 +-
 fs/xfs/libxfs/xfs_alloc.c      | 7 ++++---
 fs/xfs/libxfs/xfs_format.h     | 1 -
 fs/xfs/scrub/agheader_repair.c | 3 +--
 4 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_ag.c b/fs/xfs/libxfs/xfs_ag.c
index 831bdd035900..32ceba66456f 100644
--- a/fs/xfs/libxfs/xfs_ag.c
+++ b/fs/xfs/libxfs/xfs_ag.c
@@ -291,7 +291,7 @@ xfs_agflblock_init(
 	struct xfs_buf		*bp,
 	struct aghdr_init_data	*id)
 {
-	struct xfs_agfl		*agfl = XFS_BUF_TO_AGFL(bp);
+	struct xfs_agfl		*agfl = bp->b_addr;
 	__be32			*agfl_bno;
 	int			bucket;
 
diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index f668e62acc56..58874150b0ce 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -588,7 +588,7 @@ xfs_agfl_verify(
 	struct xfs_buf	*bp)
 {
 	struct xfs_mount *mp = bp->b_mount;
-	struct xfs_agfl	*agfl = XFS_BUF_TO_AGFL(bp);
+	struct xfs_agfl	*agfl = bp->b_addr;
 	__be32		*agfl_bno = xfs_buf_to_agfl_bno(bp);
 	int		i;
 
@@ -620,7 +620,7 @@ xfs_agfl_verify(
 			return __this_address;
 	}
 
-	if (!xfs_log_check_lsn(mp, be64_to_cpu(XFS_BUF_TO_AGFL(bp)->agfl_lsn)))
+	if (!xfs_log_check_lsn(mp, be64_to_cpu(agfl->agfl_lsn)))
 		return __this_address;
 	return NULL;
 }
@@ -656,6 +656,7 @@ xfs_agfl_write_verify(
 {
 	struct xfs_mount	*mp = bp->b_mount;
 	struct xfs_buf_log_item	*bip = bp->b_log_item;
+	struct xfs_agfl		*agfl = bp->b_addr;
 	xfs_failaddr_t		fa;
 
 	/* no verification of non-crc AGFLs */
@@ -669,7 +670,7 @@ xfs_agfl_write_verify(
 	}
 
 	if (bip)
-		XFS_BUF_TO_AGFL(bp)->agfl_lsn = cpu_to_be64(bip->bli_item.li_lsn);
+		agfl->agfl_lsn = cpu_to_be64(bip->bli_item.li_lsn);
 
 	xfs_buf_update_cksum(bp, XFS_AGFL_CRC_OFF);
 }
diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index 11a450e00231..fe685ad91e0f 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -783,7 +783,6 @@ typedef struct xfs_agi {
  */
 #define XFS_AGFL_DADDR(mp)	((xfs_daddr_t)(3 << (mp)->m_sectbb_log))
 #define	XFS_AGFL_BLOCK(mp)	XFS_HDR_BLOCK(mp, XFS_AGFL_DADDR(mp))
-#define	XFS_BUF_TO_AGFL(bp)	((struct xfs_agfl *)((bp)->b_addr))
 
 struct xfs_agfl {
 	__be32		agfl_magicnum;
diff --git a/fs/xfs/scrub/agheader_repair.c b/fs/xfs/scrub/agheader_repair.c
index 68ee1ce1ae36..6da2e87d19a8 100644
--- a/fs/xfs/scrub/agheader_repair.c
+++ b/fs/xfs/scrub/agheader_repair.c
@@ -580,7 +580,7 @@ xrep_agfl_init_header(
 	__be32			*agfl_bno;
 	struct xfs_bitmap_range	*br;
 	struct xfs_bitmap_range	*n;
-	struct xfs_agfl		*agfl;
+	struct xfs_agfl		*agfl = agfl_bp->b_addr;
 	xfs_agblock_t		agbno;
 	unsigned int		fl_off;
 
@@ -590,7 +590,6 @@ xrep_agfl_init_header(
 	 * Start rewriting the header by setting the bno[] array to
 	 * NULLAGBLOCK, then setting AGFL header fields.
 	 */
-	agfl = XFS_BUF_TO_AGFL(agfl_bp);
 	memset(agfl, 0xFF, BBTOB(agfl_bp->b_length));
 	agfl->agfl_magicnum = cpu_to_be32(XFS_AGFL_MAGIC);
 	agfl->agfl_seqno = cpu_to_be32(sc->sa.agno);
-- 
2.24.1

