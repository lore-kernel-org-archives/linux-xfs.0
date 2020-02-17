Return-Path: <SRS0=xOwi=4F=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 825AEC34028
	for <linux-xfs@archiver.kernel.org>; Mon, 17 Feb 2020 18:47:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 56EAE22527
	for <linux-xfs@archiver.kernel.org>; Mon, 17 Feb 2020 18:47:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="kgYGh8XV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728142AbgBQSrB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 17 Feb 2020 13:47:01 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:48382 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730017AbgBQSqb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 17 Feb 2020 13:46:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=TtX4KO46nep3/dtMPTsaoMXZVI5q6MpM39G5vt8u6vs=; b=kgYGh8XV0tmtk1SvQtt5T9mE+L
        iEDIhgpY9fv8FYxnRE5lKUm/CKMw69PH0iRy/036y/O1hn9EM0Me79CFQVWsn1Hj9XLqb9TazLMoB
        Nx4Aulf/c8G9KxbxDO6v5QvW73Z1jLAyoUjAA/NlImrTHmswWtpboVcd0agWfeUUhOXgkKbn6FsH6
        jReeG0AJ9aUz5vHXMeh2AUU0ZsZDpNgz+UNQEHcvRlCNnfbU+jzskRtuob1OCfFa71cbmy9I9hQs+
        eWVqPk7XmQrKJePd3wPdtxGMhnvxR8J1X8LZq3P4nhxkzrZ5te8xo93dDRwREmzFFZBX/4PnkORvk
        AvwHIyWg==;
Received: from willy by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1j3lPL-00059K-JQ; Mon, 17 Feb 2020 18:46:15 +0000
From:   Matthew Wilcox <willy@infradead.org>
To:     linux-fsdevel@vger.kernel.org
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-btrfs@vger.kernel.org, linux-erofs@lists.ozlabs.org,
        linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        cluster-devel@redhat.com, ocfs2-devel@oss.oracle.com,
        linux-xfs@vger.kernel.org, John Hubbard <jhubbard@nvidia.com>
Subject: [PATCH v6 06/19] mm: rename readahead loop variable to 'i'
Date:   Mon, 17 Feb 2020 10:45:50 -0800
Message-Id: <20200217184613.19668-10-willy@infradead.org>
X-Mailer: git-send-email 2.21.1
In-Reply-To: <20200217184613.19668-1-willy@infradead.org>
References: <20200217184613.19668-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: "Matthew Wilcox (Oracle)" <willy@infradead.org>

Change the type of page_idx to unsigned long, and rename it -- it's
just a loop counter, not a page index.

Suggested-by: John Hubbard <jhubbard@nvidia.com>
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 mm/readahead.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/mm/readahead.c b/mm/readahead.c
index 74791b96013f..bdc5759000d3 100644
--- a/mm/readahead.c
+++ b/mm/readahead.c
@@ -156,7 +156,7 @@ void __do_page_cache_readahead(struct address_space *mapping,
 	struct inode *inode = mapping->host;
 	unsigned long end_index;	/* The last page we want to read */
 	LIST_HEAD(page_pool);
-	int page_idx;
+	unsigned long i;
 	loff_t isize = i_size_read(inode);
 	gfp_t gfp_mask = readahead_gfp_mask(mapping);
 	struct readahead_control rac = {
@@ -174,7 +174,7 @@ void __do_page_cache_readahead(struct address_space *mapping,
 	/*
 	 * Preallocate as many pages as we will need.
 	 */
-	for (page_idx = 0; page_idx < nr_to_read; page_idx++) {
+	for (i = 0; i < nr_to_read; i++) {
 		struct page *page;
 
 		if (offset > end_index)
@@ -198,7 +198,7 @@ void __do_page_cache_readahead(struct address_space *mapping,
 			break;
 		page->index = offset;
 		list_add(&page->lru, &page_pool);
-		if (page_idx == nr_to_read - lookahead_size)
+		if (i == nr_to_read - lookahead_size)
 			SetPageReadahead(page);
 		rac._nr_pages++;
 		offset++;
-- 
2.25.0

