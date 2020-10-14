Return-Path: <SRS0=c4da=DV=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 768BEC433E7
	for <linux-xfs@archiver.kernel.org>; Wed, 14 Oct 2020 09:20:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D8379221FE
	for <linux-xfs@archiver.kernel.org>; Wed, 14 Oct 2020 09:20:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="G1zcZpij"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730759AbgJNJUJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 14 Oct 2020 05:20:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387823AbgJNJUG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 14 Oct 2020 05:20:06 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02471C0F26EC;
        Tue, 13 Oct 2020 20:04:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=HCUdH2gZ2mH2ZOiD3F29fY5+kaO7fY88tsiSFo4riTw=; b=G1zcZpijkarteofqchFTXXIIQW
        vBzEil6I7JRxpZhCNqz47pCtJDP7jL4ydibo68z1pfHAPcz61TtjnPUJhrlcFcdIlC7bvUYxbzeh/
        gJT6IDybpCuGYNxLXQjLqzgXPCUXNc+/rhDMz/EEzpn9lfb+5bqYrmycSOoFL53Mp4sDaMHYQIBDg
        KPppMqsoDEr3OPtV5qQUzC5jCog+ZAXl8qlkiSXQvHxwA+6vuPrkWEt2CChpDRoyQpKg0ZYufrNph
        5NnMUCqhIq8sstn9ovmiKWm0Jkaz9Xm/8fxX0BQZFzsoatYJ/6tCa7pl6fM+vVThtLsNZsJI/iHWH
        hBn5sAuw==;
Received: from willy by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kSX56-0005ia-FO; Wed, 14 Oct 2020 03:04:00 +0000
From:   "Matthew Wilcox (Oracle)" <willy@infradead.org>
To:     linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>, linux-mm@kvack.org
Subject: [PATCH 05/14] iomap: Support THPs in invalidatepage
Date:   Wed, 14 Oct 2020 04:03:48 +0100
Message-Id: <20201014030357.21898-6-willy@infradead.org>
X-Mailer: git-send-email 2.21.3
In-Reply-To: <20201014030357.21898-1-willy@infradead.org>
References: <20201014030357.21898-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

If we're punching a hole in a THP, we need to remove the per-page
iomap data as the THP is about to be split and each page will need
its own.  This means that writepage can now come across a page with
no iop allocated, so remove the assertion that there is already one,
and just create one (with the uptodate bits set) if there isn't one.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 fs/iomap/buffered-io.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index 95ac66731297..4633ebd03a3f 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -60,6 +60,8 @@ iomap_page_create(struct inode *inode, struct page *page)
 	iop = kzalloc(struct_size(iop, uptodate, BITS_TO_LONGS(nr_blocks)),
 			GFP_NOFS | __GFP_NOFAIL);
 	spin_lock_init(&iop->uptodate_lock);
+	if (PageUptodate(page))
+		bitmap_fill(iop->uptodate, nr_blocks);
 	attach_page_private(page, iop);
 	return iop;
 }
@@ -494,10 +496,14 @@ iomap_invalidatepage(struct page *page, unsigned int offset, unsigned int len)
 	 * If we are invalidating the entire page, clear the dirty state from it
 	 * and release it to avoid unnecessary buildup of the LRU.
 	 */
-	if (offset == 0 && len == PAGE_SIZE) {
+	if (offset == 0 && len == thp_size(page)) {
 		WARN_ON_ONCE(PageWriteback(page));
 		cancel_dirty_page(page);
 		iomap_page_release(page);
+	} else if (PageTransHuge(page)) {
+		/* Punching a hole in a THP requires releasing the iop */
+		WARN_ON_ONCE(!PageUptodate(page) && PageDirty(page));
+		iomap_page_release(page);
 	}
 }
 EXPORT_SYMBOL_GPL(iomap_invalidatepage);
@@ -1363,14 +1369,13 @@ iomap_writepage_map(struct iomap_writepage_ctx *wpc,
 		struct writeback_control *wbc, struct inode *inode,
 		struct page *page, u64 end_offset)
 {
-	struct iomap_page *iop = to_iomap_page(page);
+	struct iomap_page *iop = iomap_page_create(inode, page);
 	struct iomap_ioend *ioend, *next;
 	unsigned len = i_blocksize(inode);
 	u64 file_offset; /* file offset of page */
 	int error = 0, count = 0, i;
 	LIST_HEAD(submit_list);
 
-	WARN_ON_ONCE(i_blocks_per_page(inode, page) > 1 && !iop);
 	WARN_ON_ONCE(iop && atomic_read(&iop->write_bytes_pending) != 0);
 
 	/*
@@ -1415,7 +1420,6 @@ iomap_writepage_map(struct iomap_writepage_ctx *wpc,
 			 */
 			if (wpc->ops->discard_page)
 				wpc->ops->discard_page(page);
-			ClearPageUptodate(page);
 			unlock_page(page);
 			goto done;
 		}
-- 
2.28.0

