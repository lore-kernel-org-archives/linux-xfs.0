Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7EAF9C433C1
	for <linux-xfs@archiver.kernel.org>; Wed, 24 Mar 2021 14:23:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 56BAA61962
	for <linux-xfs@archiver.kernel.org>; Wed, 24 Mar 2021 14:23:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236104AbhCXOWk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 24 Mar 2021 10:22:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236166AbhCXOWI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 24 Mar 2021 10:22:08 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE53BC0613DE
        for <linux-xfs@vger.kernel.org>; Wed, 24 Mar 2021 07:22:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:
        Reply-To:Cc:Content-Type:Content-ID:Content-Description;
        bh=eBZKLiVS0l/ZEMjAxc5tqYcm6prGaDLlxt/5Nd2BUs8=; b=0f5Olj51VLoKM9GaYqhUwpi7GO
        QrpVIR7h4aN553GM+9uh0b9BafhxqZBnIflPGq0DBNBLsixvaYRjhvsSlzZCXpbrXlvZlZTYp3yis
        dFFnoWe6w01/IHPTBek2xxLz+iAINxTqrn//wHUZB4DbD3VB8/Cyc3ezmAu5hCcFOaJEJuy6FJRlP
        I8K+OMIyq7e1etjUQbF4lNoRzxSTH7I2rSJybvnOf9LKIRR9ad7XnG7GQZTHyHpQp3YFqRwfANDWb
        4xo46GYuQ3N7+ht3aA2VbF0Wvkf4fw6BHvdRdFtWoIGGdEEnLtp5JP3SOET/zKpyhsAYekrbj558N
        b/sNBFaw==;
Received: from [2001:4bb8:191:f692:b499:58dc:411a:54d1] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lP4Oe-0045Xy-43
        for linux-xfs@vger.kernel.org; Wed, 24 Mar 2021 14:22:08 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 14/18] xfs: cleanup xfs_fill_fsxattr
Date:   Wed, 24 Mar 2021 15:21:25 +0100
Message-Id: <20210324142129.1011766-15-hch@lst.de>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210324142129.1011766-1-hch@lst.de>
References: <20210324142129.1011766-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Add a local xfs_mount variable, and use the XFS_FSB_TO_B helper.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_ioctl.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 3405a5f5bacfda..2b32dd4e14890b 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1117,15 +1117,14 @@ xfs_fill_fsxattr(
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
2.30.1

