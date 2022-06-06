Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89F46CCA482
	for <linux-xfs@archiver.kernel.org>; Mon,  6 Jun 2022 20:51:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234846AbiFFUvd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 6 Jun 2022 16:51:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234410AbiFFUtb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 6 Jun 2022 16:49:31 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01A74BC16;
        Mon,  6 Jun 2022 13:41:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=sw3xGMu8EIPPhanldW93F5IagC/JMQIeTrByOXSqams=; b=JRGvxIipv7m6v6BYy6Iv5o96an
        NjXbRwZx1kTpdL1gggi3uNnj2ZYHaGoDzYgFT9yWRY6RNrAPmjSRZuyOiiwaQM/1+M4AVwuYk+PBK
        EhpIMqcN0q2USPv0aKU3dVjpSas0DHRDV7v4Cj/0tVzmx9G3IVaaTh1VHsmINPnXLtdg0pn0oK/os
        mZ5HSWwosmZWEQkulkmXHnZdh3UXU16V/nVWQplhy19ME/Fyl4IioqID8E9V19f67diSrjjEsp+Bj
        J6Yy4FA8M6KmTvtuBy+S1CbohBt8Z1KKKPT8ganbhA1EGJjXoSXsZPQfL0++fMRIBpXima3JffJKS
        uzjNM9wQ==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nyJWx-00B19o-Ro; Mon, 06 Jun 2022 20:40:55 +0000
From:   "Matthew Wilcox (Oracle)" <willy@infradead.org>
To:     linux-fsdevel@vger.kernel.org
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
        linux-aio@kvack.org, linux-btrfs@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        cluster-devel@redhat.com, linux-mm@kvack.org,
        linux-xfs@vger.kernel.org, linux-nfs@vger.kernel.org,
        linux-ntfs-dev@lists.sourceforge.net, ocfs2-devel@oss.oracle.com,
        linux-mtd@lists.infradead.org,
        virtualization@lists.linux-foundation.org
Subject: [PATCH 16/20] secretmem: Convert to migrate_folio
Date:   Mon,  6 Jun 2022 21:40:46 +0100
Message-Id: <20220606204050.2625949-17-willy@infradead.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220606204050.2625949-1-willy@infradead.org>
References: <20220606204050.2625949-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This is little more than changing the types over; there's no real work
being done in this function.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 mm/secretmem.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/mm/secretmem.c b/mm/secretmem.c
index 206ed6b40c1d..9c7f6e3bf3e1 100644
--- a/mm/secretmem.c
+++ b/mm/secretmem.c
@@ -138,8 +138,8 @@ static bool secretmem_isolate_page(struct page *page, isolate_mode_t mode)
 	return false;
 }
 
-static int secretmem_migratepage(struct address_space *mapping,
-				 struct page *newpage, struct page *page,
+static int secretmem_migrate_folio(struct address_space *mapping,
+				 struct folio *dst, struct folio *src,
 				 enum migrate_mode mode)
 {
 	return -EBUSY;
@@ -154,7 +154,7 @@ static void secretmem_free_folio(struct folio *folio)
 const struct address_space_operations secretmem_aops = {
 	.dirty_folio	= noop_dirty_folio,
 	.free_folio	= secretmem_free_folio,
-	.migratepage	= secretmem_migratepage,
+	.migrate_folio	= secretmem_migrate_folio,
 	.isolate_page	= secretmem_isolate_page,
 };
 
-- 
2.35.1

