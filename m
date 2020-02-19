Return-Path: <SRS0=TUUv=4H=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40662C11D0C
	for <linux-xfs@archiver.kernel.org>; Wed, 19 Feb 2020 21:02:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0B2B02467B
	for <linux-xfs@archiver.kernel.org>; Wed, 19 Feb 2020 21:02:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="uH+Yj68Z"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726750AbgBSVB4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 Feb 2020 16:01:56 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:35990 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727592AbgBSVBI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Feb 2020 16:01:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=ti/VQbcGx7iB5ZkDtMNebTtjtNZ81oeKJGpMdUNZLV0=; b=uH+Yj68Zq00b1el9IhXvtJg/ER
        JKcDD2sr89kzrbW/CetZp6Fyud1tXA80CjzlzuHIreMpTZdCzt66YpvfxzztwR+HxT6XAzvXxI/iu
        b4YFRc6hamcIFMjpT0TuqEPN+qLrwntKHxJK8PDELA+OzYON8fSCz/Y20rnFMWe49OrohOnwn9yHz
        CGOoG1Lq3O5ypaCkNP2WJtcS91SQhIpHvbhIWNgGw2uR8VbM/wEI+AO28/uJA3ZoEJKzV7jnvLSkG
        3NbrGg91hnS2b8QyqPxskApWNYq11NuSW2lm22pIud33IrSYx0BQAbPqykBUdwrgp/K0HLfPETgOS
        ORq69oYQ==;
Received: from willy by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1j4WSu-0008TS-SZ; Wed, 19 Feb 2020 21:01:04 +0000
From:   Matthew Wilcox <willy@infradead.org>
To:     linux-fsdevel@vger.kernel.org
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-btrfs@vger.kernel.org, linux-erofs@lists.ozlabs.org,
        linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        cluster-devel@redhat.com, ocfs2-devel@oss.oracle.com,
        linux-xfs@vger.kernel.org
Subject: [PATCH v7 04/24] mm: Move readahead nr_pages check into read_pages
Date:   Wed, 19 Feb 2020 13:00:43 -0800
Message-Id: <20200219210103.32400-5-willy@infradead.org>
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

Simplify the callers by moving the check for nr_pages and the BUG_ON
into read_pages().

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 mm/readahead.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/mm/readahead.c b/mm/readahead.c
index 61b15b6b9e72..9fcd4e32b62d 100644
--- a/mm/readahead.c
+++ b/mm/readahead.c
@@ -119,6 +119,9 @@ static void read_pages(struct address_space *mapping, struct file *filp,
 	struct blk_plug plug;
 	unsigned page_idx;
 
+	if (!nr_pages)
+		return;
+
 	blk_start_plug(&plug);
 
 	if (mapping->a_ops->readpages) {
@@ -138,6 +141,8 @@ static void read_pages(struct address_space *mapping, struct file *filp,
 
 out:
 	blk_finish_plug(&plug);
+
+	BUG_ON(!list_empty(pages));
 }
 
 /*
@@ -180,8 +185,7 @@ void __do_page_cache_readahead(struct address_space *mapping,
 			 * contiguous pages before continuing with the next
 			 * batch.
 			 */
-			if (nr_pages)
-				read_pages(mapping, filp, &page_pool, nr_pages,
+			read_pages(mapping, filp, &page_pool, nr_pages,
 						gfp_mask);
 			nr_pages = 0;
 			continue;
@@ -202,9 +206,7 @@ void __do_page_cache_readahead(struct address_space *mapping,
 	 * uptodate then the caller will launch readpage again, and
 	 * will then handle the error.
 	 */
-	if (nr_pages)
-		read_pages(mapping, filp, &page_pool, nr_pages, gfp_mask);
-	BUG_ON(!list_empty(&page_pool));
+	read_pages(mapping, filp, &page_pool, nr_pages, gfp_mask);
 }
 
 /*
-- 
2.25.0

