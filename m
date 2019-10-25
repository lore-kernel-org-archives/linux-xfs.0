Return-Path: <SRS0=Pn/S=YS=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5763CA9EA0
	for <linux-xfs@archiver.kernel.org>; Fri, 25 Oct 2019 15:04:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A9E5A20684
	for <linux-xfs@archiver.kernel.org>; Fri, 25 Oct 2019 15:04:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="QKGl/QiC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409510AbfJYPE1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 25 Oct 2019 11:04:27 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:48692 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2408186AbfJYPE1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 25 Oct 2019 11:04:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:
        Reply-To:Cc:Content-Type:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=nkqtly75UUlqBylf2Yrij2xFjKeUnYM1YDeslsGW9aw=; b=QKGl/QiCf6u+ngahR+QV4J711
        ELkxcF86h1namIBIXW3d6u6Fu98uoglpusc0JIUA+nOyyboQXnheWUQ+fYlSAVrDzDIh/EZVtg0DX
        G5yN+TpcY3TiZHAkpjYfeBzg9e2DfFd0gyWu222P/AvdNpJNAzOfiUe1/wGqP6TSCcecwpNthukNB
        lrfQzg6mEWVqFSTTVj0GEilX35gHziomPd15BJtEIuugwa8a9J4YkpaRQvXIYaS4Ec6QYVbG8gYhh
        SJnKJSlm3TyhwWJcaJ7pk8X15y94LNZkiTzl/na1r40sPaPNETYybUj3C16N/sE6fWUavc/y83oXA
        Orn974Wjw==;
Received: from [46.189.28.128] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iO18b-0006Y1-H9
        for linux-xfs@vger.kernel.org; Fri, 25 Oct 2019 15:04:27 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 4/8] xfs: don't log the inode in xfs_fs_map_blocks if it wasn't modified
Date:   Fri, 25 Oct 2019 17:03:32 +0200
Message-Id: <20191025150336.19411-5-hch@lst.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191025150336.19411-1-hch@lst.de>
References: <20191025150336.19411-1-hch@lst.de>
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
 fs/xfs/xfs_pnfs.c | 43 +++++++++++++++++++------------------------
 1 file changed, 19 insertions(+), 24 deletions(-)

diff --git a/fs/xfs/xfs_pnfs.c b/fs/xfs/xfs_pnfs.c
index 9c96493be9e0..fa90c6334c7c 100644
--- a/fs/xfs/xfs_pnfs.c
+++ b/fs/xfs/xfs_pnfs.c
@@ -147,32 +147,27 @@ xfs_fs_map_blocks(
 	if (error)
 		goto out_unlock;
 
-	if (write) {
-		enum xfs_prealloc_flags	flags = 0;
-
+	if (write &&
+	    (!nimaps || imap.br_startblock == HOLESTARTBLOCK)) {
 		ASSERT(imap.br_startblock != DELAYSTARTBLOCK);
 
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

