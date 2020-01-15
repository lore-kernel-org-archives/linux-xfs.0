Return-Path: <SRS0=S7Al=3E=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84185C33CB1
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Jan 2020 13:46:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5708D222C3
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Jan 2020 13:46:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="mopz2QEO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726085AbgAONq5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 15 Jan 2020 08:46:57 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:36126 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726071AbgAONq5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 15 Jan 2020 08:46:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=2jtXTDke+BrXIybk6dSMNeMSL+k8ECu2JOk9wYP0qFI=; b=mopz2QEOPGy01VvNH/647UhCC
        9PhpUQqT9C1LUNfJngAmejVOBY1m8MF46Y9HxtKYu59EnCV0z/D4GkFN5n7Bp3+/oUq6ySGSI4/Hx
        Gy5vFRjrQrMoopf0o3psK+YiN2ypYl3GuMfFFsoQKPW3l6NkLIbgzbV52NzCvnCnfSBimX+79CCcN
        RcEdPfJPr+vyRmxzAgdo8bcudFG0k+OLt9jvFUjCK3ITHeG0opm1A6Sly1KW1G5tZbfivUOmzB38H
        VilBMkfto3VMeK00P6ahAz7x6memvsdm+7basheR3sp8Lj/BBJSnt6WmKQU96wBDpudW11ZUhkZWg
        sWYuOzziA==;
Received: from clnet-p19-102.ikbnet.co.at ([83.175.77.102] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1irj0b-0005ce-33
        for linux-xfs@vger.kernel.org; Wed, 15 Jan 2020 13:46:57 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH] xfs: fix IOCB_NOWAIT handling in xfs_file_dio_aio_read
Date:   Wed, 15 Jan 2020 14:46:53 +0100
Message-Id: <20200115134653.433559-1-hch@lst.de>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Direct I/O reads can also be used with RWF_NOWAIT & co.  Fix the inode
locking in xfs_file_dio_aio_read to take IOCB_NOWAIT into account.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---

Resending standalone to get a little more attention.

 fs/xfs/xfs_file.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index c93250108952..b8a4a3f29b36 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -187,7 +187,12 @@ xfs_file_dio_aio_read(
 
 	file_accessed(iocb->ki_filp);
 
-	xfs_ilock(ip, XFS_IOLOCK_SHARED);
+	if (iocb->ki_flags & IOCB_NOWAIT) {
+		if (!xfs_ilock_nowait(ip, XFS_IOLOCK_SHARED))
+			return -EAGAIN;
+	} else {
+		xfs_ilock(ip, XFS_IOLOCK_SHARED);
+	}
 	ret = iomap_dio_rw(iocb, to, &xfs_read_iomap_ops, NULL,
 			is_sync_kiocb(iocb));
 	xfs_iunlock(ip, XFS_IOLOCK_SHARED);
-- 
2.24.1

