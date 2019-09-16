Return-Path: <SRS0=IYS1=XL=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05205C49ED7
	for <linux-xfs@archiver.kernel.org>; Mon, 16 Sep 2019 12:20:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C39E8214DE
	for <linux-xfs@archiver.kernel.org>; Mon, 16 Sep 2019 12:20:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="cMq6S1Wg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732418AbfIPMUs (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 16 Sep 2019 08:20:48 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:50598 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727810AbfIPMUs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 16 Sep 2019 08:20:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:
        Reply-To:Cc:Content-Type:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=T3iHOo1oHQMvUs4U5zg6Lv1G/4yMuiwne7DOHWcHXv4=; b=cMq6S1WgTEI16I/IwkC+2S6EL
        5fkTOhP5+G1BIy7tg4pzwUy83dcJ1+dgaAioEmJyiarsv0+TTLyO1llgtaIhemDnk3C/UNP2/CsPU
        P3nCYWn9qwwxYJVQePX2oVrFyjSYtOPTD+8wUrfamzKJLn+/0fVZzoFQWZTJMcDHDwZ6dizWIaVe4
        hwwnBtwp9O8b1kfJChGefi+IIOYSsx2c984wOQjyZdxUHQQBi99fdkIZyvA1F7+siacepm3LaXf3H
        1qWPaH7kaHY89ToTXwLsLah5WiPj2MK6MVEExOmqGySDvgTVDnh072FCi3jYct0CmbojGVXH30aVl
        TgmHr1qxA==;
Received: from clnet-p19-102.ikbnet.co.at ([83.175.77.102] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.2 #3 (Red Hat Linux))
        id 1i9pzr-0001OI-QT
        for linux-xfs@vger.kernel.org; Mon, 16 Sep 2019 12:20:48 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 2/2] xfs: shortcut xfs_file_release for read-only file descriptors
Date:   Mon, 16 Sep 2019 14:20:41 +0200
Message-Id: <20190916122041.24636-3-hch@lst.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190916122041.24636-1-hch@lst.de>
References: <20190916122041.24636-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

xfs_file_release currently performs flushing of truncated blocks and
freeing of the post-EOF speculative preallocation for all file
descriptors as long as they are not on a read-only mount.  Switch to
check for FMODE_WRITE instead as we should only perform these actions
on writable file descriptors, and no such file descriptors can be
created on a read-only mount.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_file.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 72680edf2ceb..06f0eb25c7cc 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -1066,7 +1066,7 @@ xfs_file_release(
 	struct xfs_inode	*ip = XFS_I(inode);
 	struct xfs_mount	*mp = ip->i_mount;
 
-	if (mp->m_flags & XFS_MOUNT_RDONLY)
+	if (!(file->f_mode & FMODE_WRITE))
 		return 0;
 	
 	if (XFS_FORCED_SHUTDOWN(mp))
-- 
2.20.1

