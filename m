Return-Path: <SRS0=BK4F=CC=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C91E8C433DF
	for <linux-xfs@archiver.kernel.org>; Mon, 24 Aug 2020 15:24:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A1B26207CD
	for <linux-xfs@archiver.kernel.org>; Mon, 24 Aug 2020 15:24:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="oOk8U/QD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727097AbgHXPXp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 24 Aug 2020 11:23:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727838AbgHXPR4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Aug 2020 11:17:56 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F914C06179B;
        Mon, 24 Aug 2020 08:17:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=Huo6sRbyJX9efH4aMnmRbcXQABN82YlWzJMQK7nzbq8=; b=oOk8U/QDtTn5eoOaAbpATFETeZ
        RO5j/88tOn7AiH6SAv7tSpzye6OMyYDvhOKVfTs9Rv04yGxu1zLhlxg2z5pBJDB3qNzoFAvQ2YZCK
        Xc2BwJyRybfzVEhAhLVarz3sEuywitv0peWEW7G2anq/cOFH0oDDER1Nwhy9zpVLuSlIadNEqpDtB
        YTeLFVX5FCN00qjYm83jsVT7jyxAXHkOE/DwswSNis1nLInBZBlg8B2N7vNAz+TnYKGhrjq5omxpv
        b6ZHaMFKe8uinPq6Hdn0gW65hyGzXYlGYw3YUbAnXVupRW3Sdgyln54DIVwUv42pL0M6WOyvXnQQ8
        ZiFY94nQ==;
Received: from willy by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kAEDZ-0004E1-RG; Mon, 24 Aug 2020 15:17:05 +0000
From:   "Matthew Wilcox (Oracle)" <willy@infradead.org>
To:     linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        linux-block@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 11/11] iomap: Handle tail pages in iomap_page_mkwrite
Date:   Mon, 24 Aug 2020 16:17:00 +0100
Message-Id: <20200824151700.16097-12-willy@infradead.org>
X-Mailer: git-send-email 2.21.3
In-Reply-To: <20200824151700.16097-1-willy@infradead.org>
References: <20200824151700.16097-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

iomap_page_mkwrite() can be called with a tail page.  If we are,
operate on the head page, since we're treating the entire thing as a
single unit and the whole page is dirtied at the same time.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 fs/iomap/buffered-io.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index ca2aa1995519..eb8202424665 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -1043,7 +1043,7 @@ iomap_page_mkwrite_actor(struct inode *inode, loff_t pos, loff_t length,
 
 vm_fault_t iomap_page_mkwrite(struct vm_fault *vmf, const struct iomap_ops *ops)
 {
-	struct page *page = vmf->page;
+	struct page *page = thp_head(vmf->page);
 	struct inode *inode = file_inode(vmf->vma->vm_file);
 	unsigned long length;
 	loff_t offset;
-- 
2.28.0

