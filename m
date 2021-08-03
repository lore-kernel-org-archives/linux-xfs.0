Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97E9CC4338F
	for <linux-xfs@archiver.kernel.org>; Tue,  3 Aug 2021 19:32:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 772B861037
	for <linux-xfs@archiver.kernel.org>; Tue,  3 Aug 2021 19:32:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239715AbhHCTcu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 3 Aug 2021 15:32:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239696AbhHCTct (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 3 Aug 2021 15:32:49 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61261C061757;
        Tue,  3 Aug 2021 12:32:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=+wBJFC8oMvKDVA3sJoFvFUIFVvQ+URjZI/q5tk1JJLU=; b=l3a9KlTS0+mkoAyzS3qkRtlX7d
        t2wvMINLr9m3x3G5LI8ketWMXHNcampRKnv2syjHWugf5ddf3+vJLTRd7y7Dcviydb1eNDYsBeNk4
        IgppHsTe2eOFRBqLMKplz5+OX+zlSdkors3bmFMQZLONAQvOrncvqEThMnFaKN2dQQkmrDtBX+o4I
        ZiGZ7pHVu/Q6Cjjh9CqKkZoR2f9EXD+/aw1SATyo1/OmwxGdarQjS215YTZOLUkab5pIbZnyE6JlY
        qZlUVw0kYXGXVoNsxv8y2WBEffwP1lz/hLTd7OiRNRDWhfTbSvWLTWqVdmSuP5UiLJusnJnJp5Qsz
        2wHBMSog==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mB08w-0051sP-Tt; Tue, 03 Aug 2021 19:32:08 +0000
From:   "Matthew Wilcox (Oracle)" <willy@infradead.org>
To:     linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: [PATCH 2/2] iomap: Add another assertion to inline data handling
Date:   Tue,  3 Aug 2021 20:31:34 +0100
Message-Id: <20210803193134.1198733-2-willy@infradead.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210803193134.1198733-1-willy@infradead.org>
References: <20210803193134.1198733-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Check that the file tail does not cross a page boundary.  Requested by
Andreas.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 fs/iomap/buffered-io.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index 8ee0211bea86..586d9d078ce1 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -215,6 +215,8 @@ static int iomap_read_inline_data(struct inode *inode, struct page *page,
 	if (PageUptodate(page))
 		return PAGE_SIZE - poff;
 
+	if (WARN_ON_ONCE(size > PAGE_SIZE - poff))
+		return -EIO;
 	if (WARN_ON_ONCE(size > PAGE_SIZE -
 			 offset_in_page(iomap->inline_data)))
 		return -EIO;
-- 
2.30.2

