Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNWANTED_LANGUAGE_BODY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5FD5C49EB7
	for <linux-xfs@archiver.kernel.org>; Mon, 28 Jun 2021 17:27:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C284161C4D
	for <linux-xfs@archiver.kernel.org>; Mon, 28 Jun 2021 17:27:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233362AbhF1RaU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 28 Jun 2021 13:30:20 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:27597 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233558AbhF1RaT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 28 Jun 2021 13:30:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624901273;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qx+pJPqGuDwHEVclhC42irAu7Sb7G7yMiMuZ9iVPouQ=;
        b=PmsTDEjMMNGWi+SbEpF4kMiwtCzGCslN4wICMC2n9RBngc59SwPQl+8e/nqdmggdkeOQCB
        OWw2n0nMElyeaefJfSUJSmwMApHhu0a3APQ2IoIUQYRKtmI+AYN0zKOKKo+xsdcbHaSxxj
        oX81bR1PJRdp9h3yt9nxPPd9oikHDmo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-164-G6OJ9atuPv29LUSjW8nF4g-1; Mon, 28 Jun 2021 13:27:51 -0400
X-MC-Unique: G6OJ9atuPv29LUSjW8nF4g-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 033021922962;
        Mon, 28 Jun 2021 17:27:50 +0000 (UTC)
Received: from max.com (unknown [10.40.193.232])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 197E45D6AD;
        Mon, 28 Jun 2021 17:27:38 +0000 (UTC)
From:   Andreas Gruenbacher <agruenba@redhat.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     "Darrick J . Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, cluster-devel@redhat.com,
        Bob Peterson <rpeterso@redhat.com>,
        Andreas Gruenbacher <agruenba@redhat.com>
Subject: [PATCH 2/2] iomap: Add helper for un-inlining an inline inode
Date:   Mon, 28 Jun 2021 19:27:27 +0200
Message-Id: <20210628172727.1894503-3-agruenba@redhat.com>
In-Reply-To: <20210628172727.1894503-1-agruenba@redhat.com>
References: <20210628172727.1894503-1-agruenba@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Bob Peterson <rpeterso@redhat.com>

Add function iomap_uninline_inode for converting an inline inode into a
non-inline inode.  This takes care of attaching a new iomap_page object
to page->private if the block size is smaller than the page size.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
---
 fs/iomap/buffered-io.c | 24 ++++++++++++++++++++++++
 include/linux/iomap.h  |  2 ++
 2 files changed, 26 insertions(+)

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index 03537ecb2a94..44acb59191b2 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -226,6 +226,30 @@ iomap_read_inline_data(struct inode *inode, struct page *page,
 	SetPageUptodate(page);
 }
 
+int iomap_uninline_inode(struct inode *inode,
+		int (*uninline)(struct inode *, struct page *))
+{
+	struct page *page = NULL;
+	int ret;
+
+	if (i_size_read(inode)) {
+		page = find_or_create_page(inode->i_mapping, 0, GFP_NOFS);
+		if (!page)
+			return -ENOMEM;
+	}
+	ret = uninline(inode, page);
+	if (page) {
+		if (PageUptodate(page)) {
+			iomap_page_create(inode, page);
+			iomap_set_range_uptodate(page, 0, PAGE_SIZE);
+		}
+		unlock_page(page);
+		put_page(page);
+	}
+	return ret;
+}
+EXPORT_SYMBOL_GPL(iomap_uninline_inode);
+
 static inline bool iomap_block_needs_zeroing(struct inode *inode,
 		struct iomap *iomap, loff_t pos)
 {
diff --git a/include/linux/iomap.h b/include/linux/iomap.h
index c87d0cb0de6d..90c924eec09b 100644
--- a/include/linux/iomap.h
+++ b/include/linux/iomap.h
@@ -157,6 +157,8 @@ loff_t iomap_apply(struct inode *inode, loff_t pos, loff_t length,
 
 ssize_t iomap_file_buffered_write(struct kiocb *iocb, struct iov_iter *from,
 		const struct iomap_ops *ops);
+int iomap_uninline_inode(struct inode *inode,
+                int (*uninline)(struct inode *, struct page *));
 int iomap_readpage(struct page *page, const struct iomap_ops *ops);
 void iomap_readahead(struct readahead_control *, const struct iomap_ops *ops);
 int iomap_set_page_dirty(struct page *page);
-- 
2.26.3

