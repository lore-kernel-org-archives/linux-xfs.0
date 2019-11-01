Return-Path: <SRS0=5kOL=YZ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ACD53CA9ECF
	for <linux-xfs@archiver.kernel.org>; Fri,  1 Nov 2019 22:10:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7F67E2085B
	for <linux-xfs@archiver.kernel.org>; Fri,  1 Nov 2019 22:10:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ecRkiGhL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727307AbfKAWK3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 1 Nov 2019 18:10:29 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:53860 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725989AbfKAWK3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 1 Nov 2019 18:10:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:
        Reply-To:Cc:Content-Type:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=wTMgzEvm+ZKzhVy04EScMrdQiQ6ktQ8RCc9qk/fa4qY=; b=ecRkiGhL3WIz4+EOx4jSNmxAx
        C0WpEAOd3GMcnncyolKjChDtaKXhRtydwpQYYY9zVALiCsHIozzEhAO/llfluH0S3FGxDQG5paw4Y
        HJOgp5jiRfD6xl+xi0Q3O3IShFHM1cTbqhQG8RsFhfXmm/ImYS3i3qGMfPUxEcr77DI6fSPWWY4gQ
        kqsDWNkCbdz635zdQJx78CSC86Ksw2/6r0ALtNQ8Cjk2m0QY/6+zw3+Xh9j7eJ1DKSJnewy+fOhLX
        idiFXRvm152VCZ0h8GLX3FjoBr4YWRruj1ivCdcW3sbc1h1UKWScCBLl7phyYs4MprX/0Pqa2q6wi
        yLcxDeucA==;
Received: from [199.255.44.128] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iQf7k-0007YG-QP
        for linux-xfs@vger.kernel.org; Fri, 01 Nov 2019 22:10:28 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 34/34] xfs: always pass a valid hdr to xfs_dir3_leaf_check_int
Date:   Fri,  1 Nov 2019 15:07:19 -0700
Message-Id: <20191101220719.29100-35-hch@lst.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191101220719.29100-1-hch@lst.de>
References: <20191101220719.29100-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Move the code for extracting the incore header to the only caller that
didn't already do that.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_dir2_leaf.c | 31 +++++++++++++------------------
 1 file changed, 13 insertions(+), 18 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_dir2_leaf.c b/fs/xfs/libxfs/xfs_dir2_leaf.c
index 6912264e081e..fecec1ac8e40 100644
--- a/fs/xfs/libxfs/xfs_dir2_leaf.c
+++ b/fs/xfs/libxfs/xfs_dir2_leaf.c
@@ -137,20 +137,14 @@ xfs_dir3_leaf_check(
 
 xfs_failaddr_t
 xfs_dir3_leaf_check_int(
-	struct xfs_mount	*mp,
-	struct xfs_dir3_icleaf_hdr *hdr,
-	struct xfs_dir2_leaf	*leaf)
+	struct xfs_mount		*mp,
+	struct xfs_dir3_icleaf_hdr	*hdr,
+	struct xfs_dir2_leaf		*leaf)
 {
-	xfs_dir2_leaf_tail_t	*ltp;
-	int			stale;
-	int			i;
-	struct xfs_dir3_icleaf_hdr leafhdr;
-	struct xfs_da_geometry	*geo = mp->m_dir_geo;
-
-	if (!hdr) {
-		xfs_dir2_leaf_hdr_from_disk(mp, &leafhdr, leaf);
-		hdr = &leafhdr;
-	}
+	struct xfs_da_geometry		*geo = mp->m_dir_geo;
+	xfs_dir2_leaf_tail_t		*ltp;
+	int				stale;
+	int				i;
 
 	ltp = xfs_dir2_leaf_tail_p(geo, leaf);
 
@@ -190,17 +184,18 @@ xfs_dir3_leaf_check_int(
  */
 static xfs_failaddr_t
 xfs_dir3_leaf_verify(
-	struct xfs_buf		*bp)
+	struct xfs_buf			*bp)
 {
-	struct xfs_mount	*mp = bp->b_mount;
-	struct xfs_dir2_leaf	*leaf = bp->b_addr;
-	xfs_failaddr_t		fa;
+	struct xfs_mount		*mp = bp->b_mount;
+	struct xfs_dir3_icleaf_hdr	leafhdr;
+	xfs_failaddr_t			fa;
 
 	fa = xfs_da3_blkinfo_verify(bp, bp->b_addr);
 	if (fa)
 		return fa;
 
-	return xfs_dir3_leaf_check_int(mp, NULL, leaf);
+	xfs_dir2_leaf_hdr_from_disk(mp, &leafhdr, bp->b_addr);
+	return xfs_dir3_leaf_check_int(mp, &leafhdr, bp->b_addr);
 }
 
 static void
-- 
2.20.1

