Return-Path: <SRS0=aCB+=YX=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7DECCA9EC5
	for <linux-xfs@archiver.kernel.org>; Wed, 30 Oct 2019 18:04:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 77022208E3
	for <linux-xfs@archiver.kernel.org>; Wed, 30 Oct 2019 18:04:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="bUbrglt2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727754AbfJ3SEy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 30 Oct 2019 14:04:54 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:38388 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727752AbfJ3SEy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 30 Oct 2019 14:04:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:
        Reply-To:Cc:Content-Type:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=D9rk7y1zEJSs/ac4QHXB61QeYPOq81oj18YHf0r1fO0=; b=bUbrglt2b+Oi04MwQRFUQZnvG
        mVNrHD1W9Mi+zCxtLhPMWBw4uyJguapWN6C/Jy1lCwwcXplCiY/uOg+qNOz4KlKcNOvUfbThlIr0h
        b67aCanH7Crhnk3ckIz8wtZZIH4qgwG4HN+U81fpYiN1W+gd96mgXqMPcMgfRLs60bN32teHsFKsz
        48A+bw8dZw7TKLs+IpLyAeIsI5maEV8F4rsYFNzK8963QcJujq+sIeGiQk48VbZpTcunF7d3//mSv
        Xdy9D4+RT4+JngGoC3gStS4+461dFd8y0+J0VaaA31q2uNm1XFXuJCr3sS0cjqWdGlg+ny7eXgbqg
        OPpDTYT2A==;
Received: from [199.255.44.128] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iPsKz-0005fb-PQ
        for linux-xfs@vger.kernel.org; Wed, 30 Oct 2019 18:04:53 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 5/9] xfs: don't log the inode in xfs_fs_map_blocks if it wasn't modified
Date:   Wed, 30 Oct 2019 11:04:15 -0700
Message-Id: <20191030180419.13045-6-hch@lst.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191030180419.13045-1-hch@lst.de>
References: <20191030180419.13045-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Even if we are asked for a write layout there is no point in logging
the inode unless we actually modified it in some way.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_pnfs.c | 42 ++++++++++++++++++------------------------
 1 file changed, 18 insertions(+), 24 deletions(-)

diff --git a/fs/xfs/xfs_pnfs.c b/fs/xfs/xfs_pnfs.c
index 3634ffff3b07..ada46e9f5ff1 100644
--- a/fs/xfs/xfs_pnfs.c
+++ b/fs/xfs/xfs_pnfs.c
@@ -150,30 +150,24 @@ xfs_fs_map_blocks(
 
 	ASSERT(!nimaps || imap.br_startblock != DELAYSTARTBLOCK);
 
-	if (write) {
-		enum xfs_prealloc_flags	flags = 0;
-
-		if (!nimaps || imap.br_startblock == HOLESTARTBLOCK) {
-			/*
-			 * xfs_iomap_write_direct() expects to take ownership of
-			 * the shared ilock.
-			 */
-			xfs_ilock(ip, XFS_ILOCK_SHARED);
-			error = xfs_iomap_write_direct(ip, offset, length,
-						       &imap, nimaps);
-			if (error)
-				goto out_unlock;
-
-			/*
-			 * Ensure the next transaction is committed
-			 * synchronously so that the blocks allocated and
-			 * handed out to the client are guaranteed to be
-			 * present even after a server crash.
-			 */
-			flags |= XFS_PREALLOC_SET | XFS_PREALLOC_SYNC;
-		}
-
-		error = xfs_update_prealloc_flags(ip, flags);
+	if (write && (!nimaps || imap.br_startblock == HOLESTARTBLOCK)) {
+		/*
+		 * xfs_iomap_write_direct() expects to take ownership of the
+		 * shared ilock.
+		 */
+		xfs_ilock(ip, XFS_ILOCK_SHARED);
+		error = xfs_iomap_write_direct(ip, offset, length, &imap,
+					       nimaps);
+		if (error)
+			goto out_unlock;
+
+		/*
+		 * Ensure the next transaction is committed synchronously so
+		 * that the blocks allocated and handed out to the client are
+		 * guaranteed to be present even after a server crash.
+		 */
+		error = xfs_update_prealloc_flags(ip,
+				XFS_PREALLOC_SET | XFS_PREALLOC_SYNC);
 		if (error)
 			goto out_unlock;
 	}
-- 
2.20.1

