Return-Path: <SRS0=59Ki=B7=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5592CC433E1
	for <linux-xfs@archiver.kernel.org>; Fri, 21 Aug 2020 12:46:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 31351207DA
	for <linux-xfs@archiver.kernel.org>; Fri, 21 Aug 2020 12:46:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="bGBUXsVQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728600AbgHUMqT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 21 Aug 2020 08:46:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725935AbgHUMqS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Aug 2020 08:46:18 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE919C061385;
        Fri, 21 Aug 2020 05:46:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=Xw2XPdlhUARRfiex9KVuJH1KdQXCJM8rMs3N5Y9w1yI=; b=bGBUXsVQvmysMuH/LyUNH0kXlQ
        GiqNpYzUnvtFuYVrktImM2WlypAA8HAeFr9hwOuaQoRVA/T3fiAn+6zO1k+uSv2LNtiFQqrYrXCRO
        vEF5oDFWfwO7EnbBPDPHGdNEMJ81bpqH9iNnu4u6FndU36xmEfRFJaqAZZkakVIe+msMs9+G5s5dF
        MIEY+2pdgQiL0NJKc9nE/XPK4kg617GV8EqZ/Uch0UWLm81ZskfNXcEaYdUdtGWLPmR84hZP84ZGg
        SyvxhUyAVH+g+eEevLj9Ks1Kt6OKKZfepiT3zS4nLVOIYhFsAcx65Ed9SVAXCc/Jymv63U1Akj5r+
        JBWvlNPg==;
Received: from willy by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1k96Qu-0002hU-O1; Fri, 21 Aug 2020 12:46:12 +0000
From:   "Matthew Wilcox (Oracle)" <willy@infradead.org>
To:     Yu Kuai <yukuai3@huawei.com>, hch@infradead.org,
        darrick.wong@oracle.com, david@fromorbit.com,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, yi.zhang@huawei.com
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: [PATCH 3/3] iomap: Support arbitrarily many blocks per page
Date:   Fri, 21 Aug 2020 13:46:06 +0100
Message-Id: <20200821124606.10165-3-willy@infradead.org>
X-Mailer: git-send-email 2.21.3
In-Reply-To: <20200821124606.10165-1-willy@infradead.org>
References: <20200821124424.GQ17456@casper.infradead.org>
 <20200821124606.10165-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Size the uptodate array dynamically and add a few debugging assertions.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 fs/iomap/buffered-io.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index dbf9572dabe9..844e95cacea8 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -22,18 +22,19 @@
 #include "../internal.h"
 
 /*
- * Structure allocated for each page when block size < PAGE_SIZE to track
+ * Structure allocated for each page when block size < page size to track
  * sub-page uptodate status and I/O completions.
  */
 struct iomap_page {
 	atomic_t		read_count;
 	atomic_t		write_count;
 	spinlock_t		uptodate_lock;
-	DECLARE_BITMAP(uptodate, PAGE_SIZE / 512);
+	unsigned long		uptodate[];
 };
 
 static inline struct iomap_page *to_iomap_page(struct page *page)
 {
+	VM_BUG_ON_PGFLAGS(PageTail(page), page);
 	if (page_has_private(page))
 		return (struct iomap_page *)page_private(page);
 	return NULL;
@@ -45,11 +46,13 @@ static struct iomap_page *
 iomap_page_create(struct inode *inode, struct page *page)
 {
 	struct iomap_page *iop = to_iomap_page(page);
+	unsigned int nr_blocks = i_blocks_per_page(inode, page);
 
-	if (iop || i_blocks_per_page(inode, page) <= 1)
+	if (iop || nr_blocks <= 1)
 		return iop;
 
-	iop = kzalloc(sizeof(*iop), GFP_NOFS | __GFP_NOFAIL);
+	iop = kzalloc(struct_size(iop, uptodate, BITS_TO_LONGS(nr_blocks)),
+			GFP_NOFS | __GFP_NOFAIL);
 	spin_lock_init(&iop->uptodate_lock);
 	attach_page_private(page, iop);
 	return iop;
@@ -59,11 +62,14 @@ static void
 iomap_page_release(struct page *page)
 {
 	struct iomap_page *iop = detach_page_private(page);
+	unsigned int nr_blocks = i_blocks_per_page(page->mapping->host, page);
 
 	if (!iop)
 		return;
 	WARN_ON_ONCE(atomic_read(&iop->read_count));
 	WARN_ON_ONCE(atomic_read(&iop->write_count));
+	WARN_ON_ONCE(bitmap_full(iop->uptodate, nr_blocks) !=
+			PageUptodate(page));
 	kfree(iop);
 }
 
-- 
2.28.0

