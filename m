Return-Path: <SRS0=K4IM=45=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F664C2BB1D
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Mar 2020 14:22:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 28B2120650
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Mar 2020 14:22:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="uoQ4rRaC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727556AbgCLOWp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 12 Mar 2020 10:22:45 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:45270 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727320AbgCLOWp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 12 Mar 2020 10:22:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:
        Reply-To:Cc:Content-Type:Content-ID:Content-Description;
        bh=9wn/kbySCMN+j3mLzIz4BUul9KpiWVKlmpeNQ0I7Ju0=; b=uoQ4rRaCVo5I21c9ohje5ae5zh
        Xm679ZiQQEROBcZjsuo8N8PhplM1XhePtfkJ/TAUNbb4J3PiUtF8tXLZ6DLoulL88xMKSnl/rx9r8
        8O+aJSpZgYWA8MFaNI5r2/L0y6wY0Z0OxT8TVn8RkR8EBTv5gsD4TpipJMywQOcmk0sBU71C2+TIc
        rpGF8HV7lMlCQYio5wnyd0FL95lbZBq2QFCKB98U2jOAC2M5ucqE5ZjxU3/NBMoQ/9DBQW6fdXt9o
        alqss5OcGEHQBVurN3WBRqfa/lSVFFr8eTRGb4KxVoW3vc/JHt6xKebjaul+00mI5JvjhK4pg39Z8
        GLAb4FTw==;
Received: from [2001:4bb8:184:5cad:8026:d98c:a056:3e33] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jCOjV-0003iw-5S
        for linux-xfs@vger.kernel.org; Thu, 12 Mar 2020 14:22:45 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 3/5] xfs: simplify a check in xfs_ioctl_setattr_check_cowextsize
Date:   Thu, 12 Mar 2020 15:22:33 +0100
Message-Id: <20200312142235.550766-4-hch@lst.de>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200312142235.550766-1-hch@lst.de>
References: <20200312142235.550766-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Only v5 file systems can have the reflink feature, and those will
always use the large dinode format.  Remove the extra check for the
inode version.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_ioctl.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 5a1d2b9cb05a..ad825ffa7e4c 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1473,8 +1473,7 @@ xfs_ioctl_setattr_check_cowextsize(
 	if (!(fa->fsx_xflags & FS_XFLAG_COWEXTSIZE))
 		return 0;
 
-	if (!xfs_sb_version_hasreflink(&ip->i_mount->m_sb) ||
-	    ip->i_d.di_version != 3)
+	if (!xfs_sb_version_hasreflink(&ip->i_mount->m_sb))
 		return -EINVAL;
 
 	if (fa->fsx_cowextsize == 0)
-- 
2.24.1

