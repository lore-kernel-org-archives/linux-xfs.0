Return-Path: <SRS0=FA12=W2=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E9DDC3A5A4
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Aug 2019 10:23:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2FE6C21721
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Aug 2019 10:23:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Bp6dda9V"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728042AbfH3KXS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Aug 2019 06:23:18 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:34634 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727976AbfH3KXS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Aug 2019 06:23:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=w6a1pesTyPSJ1F0b0xfS2IRTp25MeefqEssqvqkRLpE=; b=Bp6dda9V3bIJaeKGTJmXEwShJ
        z07FrqJjXljQD8JgtImEJ4yzQPh/p5TLJBh3dvRwJuVLYkspEu4d7tdmKCn/XFOjsyg5I5ZuZL4lV
        VFB75p8YRi61NqewkW7/gl1ZZiEt6eM0tII9rHGsidxAOo2BbQrFg9k4mdqoiGsOq/+ueUwVedfp9
        vMQkQiEqDQGOClEPmpEWkSlI9PSpqtdpaQJ3jaEqKw3jcY2IXDAliGRwFWhwdfRveK8rzfa0ymzMF
        KxloJmHTocu/93DyROm1NSSFo3FKRObMPM+kvq297oFWKMXxuhUxsptCdcc/WKKS5SL2BW1O14pt9
        2sLTg3bfA==;
Received: from [2001:4bb8:180:3f4c:863:2ead:e9d4:da9f] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92 #3 (Red Hat Linux))
        id 1i3e3p-0003mv-US
        for linux-xfs@vger.kernel.org; Fri, 30 Aug 2019 10:23:18 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH] xfs: fix the dax supported check in xfs_ioctl_setattr_dax_invalidate
Date:   Fri, 30 Aug 2019 12:23:15 +0200
Message-Id: <20190830102315.27325-1-hch@lst.de>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Setting the DAX flag on the directory of a file system that is not on a
DAX capable device makes as little sense as setting it on a regular file
on the same file system.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_ioctl.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 9ea51664932e..d1d0929aa462 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1309,8 +1309,7 @@ xfs_ioctl_setattr_dax_invalidate(
 	if (fa->fsx_xflags & FS_XFLAG_DAX) {
 		if (!(S_ISREG(inode->i_mode) || S_ISDIR(inode->i_mode)))
 			return -EINVAL;
-		if (S_ISREG(inode->i_mode) &&
-		    !bdev_dax_supported(xfs_find_bdev_for_inode(VFS_I(ip)),
+		if (!bdev_dax_supported(xfs_find_bdev_for_inode(VFS_I(ip)),
 				sb->s_blocksize))
 			return -EINVAL;
 	}
-- 
2.20.1

