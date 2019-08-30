Return-Path: <SRS0=FA12=W2=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52004C3A5A4
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Aug 2019 10:24:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 19C7C21670
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Aug 2019 10:24:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="eZw94dRd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727788AbfH3KYU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Aug 2019 06:24:20 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:34684 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727417AbfH3KYU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Aug 2019 06:24:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:
        Reply-To:Cc:Content-Type:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=V0f3Oirj3hv++bmBPXiDjm3i0MZMksovb7Xpg16zinY=; b=eZw94dRd/xLeniBazdw2lJaAL
        Zx8enQtMkX9MtnMyPKau4A/V7NCic226z5eY3cPbGcPNlfFoZ4UHPHLFqkulwXAdYCB941+lwHbtS
        6HnveqKHgAhT+SsIK6BYZJFjdLKNxizIDzMAxGwwsnRnIoPzxunqUNnHtgzsryix9e6QgAeW8jICl
        kAFLS/ZXR2WMy7xWV7H2d2k104kiA3bAsKLKnY6Crbkc7keLIW0GnLtumOp4jwFUO3QoXGZ4xOlwj
        OzqY8zXFK0eJ8QtE00mNWF0LQgQU0+CO5sGXMTNYHYdLvb28Nwwj2Jjuv1daF4IWCO2Zj9pvzv9k2
        oDBtZ6sMQ==;
Received: from [2001:4bb8:180:3f4c:863:2ead:e9d4:da9f] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92 #3 (Red Hat Linux))
        id 1i3e4q-0003om-32
        for linux-xfs@vger.kernel.org; Fri, 30 Aug 2019 10:24:20 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 2/3] xfs: cleanup xfs_fsb_to_db
Date:   Fri, 30 Aug 2019 12:24:10 +0200
Message-Id: <20190830102411.519-3-hch@lst.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190830102411.519-1-hch@lst.de>
References: <20190830102411.519-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This function isn't a macro anymore, so remove various superflous braces,
and explicit cast that is done implicitly due to the return value, use
a normal if statement instead of trying to squeeze everything together.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_bmap_util.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index e12f0ba7f2eb..0910cb75b65d 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -39,9 +39,9 @@
 xfs_daddr_t
 xfs_fsb_to_db(struct xfs_inode *ip, xfs_fsblock_t fsb)
 {
-	return (XFS_IS_REALTIME_INODE(ip) ? \
-		 (xfs_daddr_t)XFS_FSB_TO_BB((ip)->i_mount, (fsb)) : \
-		 XFS_FSB_TO_DADDR((ip)->i_mount, (fsb)));
+	if (XFS_IS_REALTIME_INODE(ip))
+		return XFS_FSB_TO_BB(ip->i_mount, fsb);
+	return XFS_FSB_TO_DADDR(ip->i_mount, fsb);
 }
 
 /*
-- 
2.20.1

