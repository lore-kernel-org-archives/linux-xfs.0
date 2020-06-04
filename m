Return-Path: <SRS0=uikP=7R=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C3ADC433DF
	for <linux-xfs@archiver.kernel.org>; Thu,  4 Jun 2020 20:23:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 333A3207DA
	for <linux-xfs@archiver.kernel.org>; Thu,  4 Jun 2020 20:23:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="j+TR1oeo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726666AbgFDUXs (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 4 Jun 2020 16:23:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726262AbgFDUXs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 4 Jun 2020 16:23:48 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A00BC08C5C0;
        Thu,  4 Jun 2020 13:23:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=Rv52h7vZZEydQnGtCgw4RqwDXUNpxD1a9zcYJju8GRc=; b=j+TR1oeo8JyiK8aJuAToeSINAL
        ACb7FE8rSdCUA4aOnecddh1NCxv9oHhtVOdAQD+OtqEPoqSyH0VHyotpnI2lDsolEyfyHlueScpLd
        hHwyvH9tAdQ3WOuRaemvg4GsDmrK3Brq9KeXqZtrjZOp47mAVy3XBlX+YPzqz+VNkyl6X1wz2NNkk
        0Lv3Wz6NL1DUFgrNUXWtWHOxRcKCUmTSsmibtXF+yytvKvNakZ8tNt3dOYapaiSP6qRJTh4gYMiW4
        BUyBMwhBvuRSp3MKzWCTpvftPTH+YpksnFmb1MH/xcbtOl0GpMAxDEJzSUQmKyh+wiuwGfelGsN92
        lGTcH+4Q==;
Received: from willy by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jgwOt-0007eM-DY; Thu, 04 Jun 2020 20:23:43 +0000
From:   Matthew Wilcox <willy@infradead.org>
To:     Christoph Hellwig <hch@infradead.org>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: [PATCH] iomap: Handle I/O errors gracefully in page_mkwrite
Date:   Thu,  4 Jun 2020 13:23:40 -0700
Message-Id: <20200604202340.29170-1-willy@infradead.org>
X-Mailer: git-send-email 2.21.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: "Matthew Wilcox (Oracle)" <willy@infradead.org>

Test generic/019 often results in:

WARNING: at fs/iomap/buffered-io.c:1069 iomap_page_mkwrite_actor+0x57/0x70

Since this can happen due to a storage error, we should not WARN for it.
Just return -EIO, which will be converted to a SIGBUS for the hapless
task attempting to write to the page that we can't read.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 fs/iomap/buffered-io.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index 89e21961d1ad..ae6c5e38f0e8 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -1066,7 +1066,8 @@ iomap_page_mkwrite_actor(struct inode *inode, loff_t pos, loff_t length,
 			return ret;
 		block_commit_write(page, 0, length);
 	} else {
-		WARN_ON_ONCE(!PageUptodate(page));
+		if (!PageUptodate(page))
+			return -EIO;
 		iomap_page_create(inode, page);
 		set_page_dirty(page);
 	}
-- 
2.26.2

