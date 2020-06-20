Return-Path: <SRS0=7N5F=AB=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0DA3C433DF
	for <linux-xfs@archiver.kernel.org>; Sat, 20 Jun 2020 07:11:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A457A22D6D
	for <linux-xfs@archiver.kernel.org>; Sat, 20 Jun 2020 07:11:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="EqUtOtic"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725977AbgFTHLd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 20 Jun 2020 03:11:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725852AbgFTHLd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 20 Jun 2020 03:11:33 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC7C1C06174E
        for <linux-xfs@vger.kernel.org>; Sat, 20 Jun 2020 00:11:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:
        Reply-To:Cc:Content-Type:Content-ID:Content-Description;
        bh=v3khmof8LSVec37GD4OiBs0ZApcLbolhp+rsVcXAotI=; b=EqUtOticGD7WDsKPQftocu33o7
        nvFDHUAJFu2vvIoMmolLDiKF1PtMpPVbFcJ1qWMiFLfQ7gkndt3x44Ul5hGy9X8dmzbDaXax+RRy8
        bIafo4cyxk2cKhHEJOmwocJacfGs8EyhXQIkFR6gBR4VxI14q6QKQck4chy4bGB72nCDeKchJkt/m
        fsyloLXwvvsWiwC80WDka1UfTeVJAfbUiy7xlflePb8Y2SlYhoniSqzBDzvgZB06z9sJZ2N8Gf6Py
        PsYIBOrtAjEqzwFanjG1GUmLrKTi5ScfexdihueI49vqhuYP/PjqSeXtpMnKHyxbJ+uHXyTfqltpR
        cBSSb6QQ==;
Received: from 195-192-102-148.dyn.cablelink.at ([195.192.102.148] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jmXf2-00010i-1J
        for linux-xfs@vger.kernel.org; Sat, 20 Jun 2020 07:11:32 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 09/15] xfs: cleanup xfs_fill_fsxattr
Date:   Sat, 20 Jun 2020 09:10:56 +0200
Message-Id: <20200620071102.462554-10-hch@lst.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200620071102.462554-1-hch@lst.de>
References: <20200620071102.462554-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Add a local xfs_mount variable, and use the XFS_FSB_TO_B helper.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_ioctl.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 60544dd0f875b8..cabc86ed6756bc 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1104,15 +1104,14 @@ xfs_fill_fsxattr(
 	bool			attr,
 	struct fsxattr		*fa)
 {
+	struct xfs_mount	*mp = ip->i_mount;
 	struct xfs_ifork	*ifp = attr ? ip->i_afp : &ip->i_df;
 
 	simple_fill_fsxattr(fa, xfs_ip2xflags(ip));
-	fa->fsx_extsize = ip->i_extsize << ip->i_mount->m_sb.sb_blocklog;
-	if (xfs_sb_version_has_v3inode(&ip->i_mount->m_sb) &&
-	    (ip->i_d.di_flags2 & XFS_DIFLAG2_COWEXTSIZE)) {
-		fa->fsx_cowextsize =
-			ip->i_cowextsize << ip->i_mount->m_sb.sb_blocklog;
-	}
+	fa->fsx_extsize = XFS_FSB_TO_B(mp, ip->i_extsize);
+	if (xfs_sb_version_has_v3inode(&mp->m_sb) &&
+	    (ip->i_d.di_flags2 & XFS_DIFLAG2_COWEXTSIZE))
+		fa->fsx_cowextsize = XFS_FSB_TO_B(mp, ip->i_cowextsize);
 	fa->fsx_projid = ip->i_projid;
 	if (ifp && (ifp->if_flags & XFS_IFEXTENTS))
 		fa->fsx_nextents = xfs_iext_count(ifp);
-- 
2.26.2

