Return-Path: <SRS0=NqjT=CT=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C5E9C433E2
	for <linux-xfs@archiver.kernel.org>; Thu, 10 Sep 2020 23:48:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CA9D8208CA
	for <linux-xfs@archiver.kernel.org>; Thu, 10 Sep 2020 23:47:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="OlH9lbNA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725648AbgIJXry (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 10 Sep 2020 19:47:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725613AbgIJXrO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 10 Sep 2020 19:47:14 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38553C061573;
        Thu, 10 Sep 2020 16:47:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=toDCz/l3SOhSBoupdSkLKgKXvEF68cxVtDee4X76Z9c=; b=OlH9lbNA4yiWeUzny9lsfQuH1l
        ssaWKtnwNnGZ0V/EMvtGg3WkefT4zUtny7F3ViujFeMnZ6LR+GIIZngAQ8g22Ke7kCGScphc8tvKd
        WlobhHS4Pt8C5P0EIrzmVbII8Jw61GFSF634qo6Uli3BaX3gCyWV3v+ojhTxCWqkIqwj4/cDkVnfy
        VjErnsBNRmbm7u57Es7NEM0nZfjTKysQ1MOIFBsGym6rBgd6i/xGoW1oFmUYMGmPtBxfzkcqEy+e+
        /VlDhSefMf/8RkHoBPRh/BKUG9gpvpeGiaX4Qj5rdfK+giA8/sKzyJwX5ZGTKv0yZSRETCJxpZ9EJ
        I7LN8tUw==;
Received: from willy by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kGWHY-0001Sl-6l; Thu, 10 Sep 2020 23:47:12 +0000
From:   "Matthew Wilcox (Oracle)" <willy@infradead.org>
To:     linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        Christoph Hellwig <hch@infradead.org>,
        linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org,
        Dave Kleikamp <shaggy@kernel.org>,
        jfs-discussion@lists.sourceforge.net,
        Christoph Hellwig <hch@lst.de>
Subject: [PATCH v2 8/9] iomap: Convert iomap_write_end types
Date:   Fri, 11 Sep 2020 00:47:06 +0100
Message-Id: <20200910234707.5504-9-willy@infradead.org>
X-Mailer: git-send-email 2.21.3
In-Reply-To: <20200910234707.5504-1-willy@infradead.org>
References: <20200910234707.5504-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

iomap_write_end cannot return an error, so switch it to return
size_t instead of int and remove the error checking from the callers.
Also convert the arguments to size_t from unsigned int, in case anyone
ever wants to support a page size larger than 2GB.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/iomap/buffered-io.c | 31 ++++++++++++-------------------
 1 file changed, 12 insertions(+), 19 deletions(-)

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index 64a5cb383f30..cb25a7b70401 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -663,9 +663,8 @@ iomap_set_page_dirty(struct page *page)
 }
 EXPORT_SYMBOL_GPL(iomap_set_page_dirty);
 
-static int
-__iomap_write_end(struct inode *inode, loff_t pos, unsigned len,
-		unsigned copied, struct page *page)
+static size_t __iomap_write_end(struct inode *inode, loff_t pos, size_t len,
+		size_t copied, struct page *page)
 {
 	flush_dcache_page(page);
 
@@ -687,9 +686,8 @@ __iomap_write_end(struct inode *inode, loff_t pos, unsigned len,
 	return copied;
 }
 
-static int
-iomap_write_end_inline(struct inode *inode, struct page *page,
-		struct iomap *iomap, loff_t pos, unsigned copied)
+static size_t iomap_write_end_inline(struct inode *inode, struct page *page,
+		struct iomap *iomap, loff_t pos, size_t copied)
 {
 	void *addr;
 
@@ -705,13 +703,14 @@ iomap_write_end_inline(struct inode *inode, struct page *page,
 	return copied;
 }
 
-static int
-iomap_write_end(struct inode *inode, loff_t pos, unsigned len, unsigned copied,
-		struct page *page, struct iomap *iomap, struct iomap *srcmap)
+/* Returns the number of bytes copied.  May be 0.  Cannot be an errno. */
+static size_t iomap_write_end(struct inode *inode, loff_t pos, size_t len,
+		size_t copied, struct page *page, struct iomap *iomap,
+		struct iomap *srcmap)
 {
 	const struct iomap_page_ops *page_ops = iomap->page_ops;
 	loff_t old_size = inode->i_size;
-	int ret;
+	size_t ret;
 
 	if (srcmap->type == IOMAP_INLINE) {
 		ret = iomap_write_end_inline(inode, page, iomap, pos, copied);
@@ -790,11 +789,8 @@ iomap_write_actor(struct inode *inode, loff_t pos, loff_t length, void *data,
 
 		copied = iov_iter_copy_from_user_atomic(page, i, offset, bytes);
 
-		status = iomap_write_end(inode, pos, bytes, copied, page, iomap,
+		copied = iomap_write_end(inode, pos, bytes, copied, page, iomap,
 				srcmap);
-		if (unlikely(status < 0))
-			break;
-		copied = status;
 
 		cond_resched();
 
@@ -868,11 +864,8 @@ iomap_unshare_actor(struct inode *inode, loff_t pos, loff_t length, void *data,
 
 		status = iomap_write_end(inode, pos, bytes, bytes, page, iomap,
 				srcmap);
-		if (unlikely(status <= 0)) {
-			if (WARN_ON_ONCE(status == 0))
-				return -EIO;
-			return status;
-		}
+		if (WARN_ON_ONCE(status == 0))
+			return -EIO;
 
 		cond_resched();
 
-- 
2.28.0

