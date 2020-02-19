Return-Path: <SRS0=TUUv=4H=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29BFBC7114E
	for <linux-xfs@archiver.kernel.org>; Wed, 19 Feb 2020 21:02:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F32C2207FD
	for <linux-xfs@archiver.kernel.org>; Wed, 19 Feb 2020 21:02:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Rr0Isn6K"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727740AbgBSVBG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 Feb 2020 16:01:06 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:35922 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727648AbgBSVBF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Feb 2020 16:01:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=8zYEi4IG7gzAvMHdDHY3fStOc4dh5wVqKWm99G/lD2Q=; b=Rr0Isn6KV0yiQsuTepKXa8KVhx
        +JyO+IlvzFzA0z8sV2iMvtsm9Pv6cgJBZMIpSg1cP4Tx/ZMk08ueKIw29L1ptgphnFq+2Q+86II+5
        PJNKMmaiCDdBTTJcDI/iXmLXg84N2WswF5/urdiVm5BTv6ykoK2n3od2eyCx5s1P6nY1KF4YFoSKI
        volIkWq8cBw6eiWFrgoZdNhCO9tAL9ZiLKXZMPI9znsj3s/nMwWW9pTQdBxelt0H9avPXVOec5UVz
        t7L9I6CkSyQomfI4fzLa6hPYbkKOJATGVMcI+Zu0LuHW7aFhXW23e3VE3cpt3VyFwn6ldkAqvOfZV
        bM3ipe0w==;
Received: from willy by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1j4WSv-0008VZ-JM; Wed, 19 Feb 2020 21:01:05 +0000
From:   Matthew Wilcox <willy@infradead.org>
To:     linux-fsdevel@vger.kernel.org
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-btrfs@vger.kernel.org, linux-erofs@lists.ozlabs.org,
        linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        cluster-devel@redhat.com, ocfs2-devel@oss.oracle.com,
        linux-xfs@vger.kernel.org
Subject: [PATCH v7 23/24] mm: Document why we don't set PageReadahead
Date:   Wed, 19 Feb 2020 13:01:02 -0800
Message-Id: <20200219210103.32400-24-willy@infradead.org>
X-Mailer: git-send-email 2.21.1
In-Reply-To: <20200219210103.32400-1-willy@infradead.org>
References: <20200219210103.32400-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: "Matthew Wilcox (Oracle)" <willy@infradead.org>

If the page is already in cache, we don't set PageReadahead on it.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 mm/readahead.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/mm/readahead.c b/mm/readahead.c
index 453ef146de83..bbe7208fcc2d 100644
--- a/mm/readahead.c
+++ b/mm/readahead.c
@@ -196,9 +196,12 @@ void page_cache_readahead_unbounded(struct address_space *mapping,
 
 		if (page && !xa_is_value(page)) {
 			/*
-			 * Page already present?  Kick off the current batch of
-			 * contiguous pages before continuing with the next
-			 * batch.
+			 * Page already present?  Kick off the current batch
+			 * of contiguous pages before continuing with the
+			 * next batch.  This page may be the one we would
+			 * have intended to mark as Readahead, but we don't
+			 * have a stable reference to this page, and it's
+			 * not worth getting one just for that.
 			 */
 			read_pages(&rac, &page_pool);
 			continue;
-- 
2.25.0

