Return-Path: <SRS0=XuOj=AU=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C0BCC433E0
	for <linux-xfs@archiver.kernel.org>; Thu,  9 Jul 2020 15:13:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4EC5C206C3
	for <linux-xfs@archiver.kernel.org>; Thu,  9 Jul 2020 15:13:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="WW4BcWUY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726834AbgGIPNw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 9 Jul 2020 11:13:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726410AbgGIPNw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 9 Jul 2020 11:13:52 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 820E3C08C5CE
        for <linux-xfs@vger.kernel.org>; Thu,  9 Jul 2020 08:13:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:
        Content-Type:Content-ID:Content-Description;
        bh=BLwoA9xF/qBD0UDnno1hZwTITS5H0IxaIl315LRXd1c=; b=WW4BcWUYLfDdZv6qLI0cA6m/Ot
        gqOSdhezUfM3wSdT7QpttSz5VH6CDdApNA2qhA548aDQuE1Q906HSJZfUgsM39agrWCEzGvZlhy7o
        cwFhGuwkClVBl/JXvyWbLIwvvMROObzvgAXtpNiYJUpVs4YLeq275Wlfa3iQgyzQ8MC8fsv7AfCZS
        K0V4ywafc00t2lJBuMnnT6VuXYrOv2oOpcslrdFX3+3SPCmh7H5Sbtin/ayUR8159sGA6lu68LpTY
        OIVwhXpCFXRp8TBU3DfUPyxg4pH+2sSAKRHMemayZQJbLufjx2Y8GJIIUsI1Pm1u4VbF/jsjC8D/s
        jD4ZoDrQ==;
Received: from [2001:4bb8:188:5f50:7053:304b:bf82:82cf] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jtYFD-00058K-0Q
        for linux-xfs@vger.kernel.org; Thu, 09 Jul 2020 15:13:51 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 08/13] xfs: lift the XBF_IOEND_FAIL handling into xfs_buf_ioend_disposition
Date:   Thu,  9 Jul 2020 17:04:48 +0200
Message-Id: <20200709150453.109230-9-hch@lst.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200709150453.109230-1-hch@lst.de>
References: <20200709150453.109230-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Keep all the error handling code together.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_buf.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index e5592563dda6a1..e3e80615c5ed9e 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -1285,6 +1285,14 @@ xfs_buf_ioend_disposition(
 	}
 
 	/* Still considered a transient error. Caller will schedule retries. */
+	if (bp->b_flags & _XBF_INODES)
+		xfs_buf_inode_io_fail(bp);
+	else if (bp->b_flags & _XBF_DQUOTS)
+		xfs_buf_dquot_io_fail(bp);
+	else
+		ASSERT(list_empty(&bp->b_li_list));
+	xfs_buf_ioerror(bp, 0);
+	xfs_buf_relse(bp);
 	return XBF_IOEND_FAIL;
 
 resubmit:
@@ -1338,14 +1346,6 @@ xfs_buf_ioend(
 		case XBF_IOEND_DONE:
 			return;
 		case XBF_IOEND_FAIL:
-			if (bp->b_flags & _XBF_INODES)
-				xfs_buf_inode_io_fail(bp);
-			else if (bp->b_flags & _XBF_DQUOTS)
-				xfs_buf_dquot_io_fail(bp);
-			else
-				ASSERT(list_empty(&bp->b_li_list));
-			xfs_buf_ioerror(bp, 0);
-			xfs_buf_relse(bp);
 			return;
 		default:
 			break;
-- 
2.26.2

