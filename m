Return-Path: <SRS0=aC/G=Y7=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6CF9BC5DF60
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Nov 2019 18:26:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 412E8206DF
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Nov 2019 18:26:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="FOjqqD2Y"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727569AbfKGS0N (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 7 Nov 2019 13:26:13 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:44336 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728943AbfKGS0N (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 Nov 2019 13:26:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From
        :Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=zek/dV/aOsCjcprX0/ib9gEwYwJOAXwBlQ9TIyJ8Kiw=; b=FOjqqD2YxoeZne0qBbkTkFCALU
        RYclw5NvtB3rmjDjRPN3eRnTHQeL13ckxyckIbSh9+wlnDP55GedJ2lylS5x1KerwWk2MfZOi2CQX
        FczUWBUBSA5xir2Z4eiiWoOgDNbghE6EhFj936aoSFhZB2PJyPYXMuC2sjcynaOrKYZ9/FxoqXRLr
        agNOL6RJFAWZWH4RR6qizlKX7+T+6+rG8jhg+hUzjm6KuU84opKxKUtsx5CE7XIyqryPl9tiEt9DX
        dw7oJTG9EFt+BnpPV7GGziPj9G/OP9kCLg58iIuhpFTvJz94+TL9bAw6p84QGQiOh6LpqAxxdC3sE
        yzh+47Hw==;
Received: from [2001:4bb8:184:e48:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iSmU1-0004WB-5d; Thu, 07 Nov 2019 18:26:13 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     "Darrick J . Wong" <darrick.wong@oracle.com>
Subject: [PATCH 46/46] xfs: always pass a valid hdr to xfs_dir3_leaf_check_int
Date:   Thu,  7 Nov 2019 19:24:10 +0100
Message-Id: <20191107182410.12660-47-hch@lst.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191107182410.12660-1-hch@lst.de>
References: <20191107182410.12660-1-hch@lst.de>
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
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_dir2_leaf.c | 31 +++++++++++++------------------
 1 file changed, 13 insertions(+), 18 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_dir2_leaf.c b/fs/xfs/libxfs/xfs_dir2_leaf.c
index 2c67a9e24bd0..e2e4b2c6d6c2 100644
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

