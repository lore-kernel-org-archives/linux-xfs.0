Return-Path: <SRS0=ByWF=4N=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17942C4BA00
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Feb 2020 21:50:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D485821927
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Feb 2020 21:50:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="N6jgfr4U"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730026AbgBYVt5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 25 Feb 2020 16:49:57 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:43582 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729403AbgBYVso (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Feb 2020 16:48:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=vPF9NaaY8PsSDRBa2cHAONSZtTpSsENUkr5OW69v4N4=; b=N6jgfr4UcsghgCPr+wiUMm9OJE
        LmlbXShTyE3uuQXuWB9sLoUN7crlB7IXyqceex8cavHasV9uKxSqJ9BLozlF43ard08jSqCJoQ6lE
        6lcj8LqkXj8AbvKOHxgdFFAU7ZZ8uKqCzV5A6h1xLTEVucuakXjIKVPlTcrkPAQWplkFYaJuMNsmS
        7zMj/itFsGgD+YgTAHaT/j3sKKdE9XSys6eTPbk0+rFu0f1565yF8M3nkiVjD9PNpZnWjvOfF2JVM
        YW7B3gv0z1vY9f3DS7UHwhGWynkOcPcnAJ1xBXblbZKY4VGUtYRhrkR7/BgkgiZ/GNrK+psbM4g79
        OVsKPQCQ==;
Received: from willy by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1j6i4H-0007q7-Cb; Tue, 25 Feb 2020 21:48:41 +0000
From:   Matthew Wilcox <willy@infradead.org>
To:     linux-fsdevel@vger.kernel.org
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-btrfs@vger.kernel.org, linux-erofs@lists.ozlabs.org,
        linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        cluster-devel@redhat.com, ocfs2-devel@oss.oracle.com,
        linux-xfs@vger.kernel.org
Subject: [PATCH v8 14/25] mm: Document why we don't set PageReadahead
Date:   Tue, 25 Feb 2020 13:48:27 -0800
Message-Id: <20200225214838.30017-15-willy@infradead.org>
X-Mailer: git-send-email 2.21.1
In-Reply-To: <20200225214838.30017-1-willy@infradead.org>
References: <20200225214838.30017-1-willy@infradead.org>
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
index 8ee9036fd681..0afb55a49909 100644
--- a/mm/readahead.c
+++ b/mm/readahead.c
@@ -195,9 +195,12 @@ void page_cache_readahead_unbounded(struct address_space *mapping,
 
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
 			read_pages(&rac, &page_pool, true);
 			continue;
-- 
2.25.0

