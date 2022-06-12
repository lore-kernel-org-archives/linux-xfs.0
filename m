Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E87AFCCA47D
	for <linux-xfs@archiver.kernel.org>; Sun, 12 Jun 2022 21:32:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235950AbiFLVcp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 12 Jun 2022 17:32:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236298AbiFLVcn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 12 Jun 2022 17:32:43 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 467EF9FDF;
        Sun, 12 Jun 2022 14:32:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=KF4owYCbPISYV5a61DiGRvGs/L1LMsz9ReyZ7eXT5t8=; b=geEs3gAVKXk3eNcQdArpYi2DVd
        f/MN4q94FG7FHdgrWVmDI4vEtNGBpS1vD/DP2rHs7ji3PrgfGGHOWvn8A3AAmpRzatm8leS4fNMaR
        Fs6S3luOZoQnLu1wdgThCd5i4g41xF0vblXF68HK3PGR3NF5mHXwdGlK8f7j8EYhpBEMYEy9oRHEH
        qlEW7b8tnYQ0rBpT67IXfWPu99LTz+lOBZmsIyf5LrvwXzKFSHCbS4hUlucLJWK2Wrj8/2TQSpg3W
        i9qz6yiljtaOFgTf83pXjguAzUIl6miPCNqPkGAOUJitBDthtLjXjcCzOkxJg685Cs7EdPJSyQkRX
        IVlGdg9w==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1o0VC9-00GHpy-EN; Sun, 12 Jun 2022 21:32:29 +0000
From:   "Matthew Wilcox (Oracle)" <willy@infradead.org>
To:     Kees Cook <keescook@chromium.org>
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        linux-mm@kvack.org, Uladzislau Rezki <urezki@gmail.com>,
        Zorro Lang <zlang@redhat.com>, linux-xfs@vger.kernel.org,
        linux-hardening@vger.kernel.org
Subject: [PATCH 2/3] usercopy: Cast pointer to an integer once
Date:   Sun, 12 Jun 2022 22:32:26 +0100
Message-Id: <20220612213227.3881769-3-willy@infradead.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220612213227.3881769-1-willy@infradead.org>
References: <20220612213227.3881769-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Get rid of a lot of annoying casts by setting 'addr' once at the top
of the function.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 mm/usercopy.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/mm/usercopy.c b/mm/usercopy.c
index fdd1bed3b90a..31deee7dd2f5 100644
--- a/mm/usercopy.c
+++ b/mm/usercopy.c
@@ -161,19 +161,20 @@ static inline void check_bogus_address(const unsigned long ptr, unsigned long n,
 static inline void check_heap_object(const void *ptr, unsigned long n,
 				     bool to_user)
 {
+	uintptr_t addr = (uintptr_t)ptr;
 	struct folio *folio;
 
 	if (is_kmap_addr(ptr)) {
-		unsigned long page_end = (unsigned long)ptr | (PAGE_SIZE - 1);
+		unsigned long page_end = addr | (PAGE_SIZE - 1);
 
-		if ((unsigned long)ptr + n - 1 > page_end)
+		if (addr + n - 1 > page_end)
 			usercopy_abort("kmap", NULL, to_user,
 					offset_in_page(ptr), n);
 		return;
 	}
 
 	if (is_vmalloc_addr(ptr)) {
-		struct vmap_area *area = find_vmap_area((unsigned long)ptr);
+		struct vmap_area *area = find_vmap_area(addr);
 		unsigned long offset;
 
 		if (!area) {
@@ -183,8 +184,8 @@ static inline void check_heap_object(const void *ptr, unsigned long n,
 
 		/* XXX: We should also abort for free vmap_areas */
 
-		offset = (unsigned long)ptr - area->va_start;
-		if ((unsigned long)ptr + n > area->va_end)
+		offset = addr - area->va_start;
+		if (addr + n > area->va_end)
 			usercopy_abort("vmalloc", NULL, to_user, offset, n);
 		return;
 	}
-- 
2.35.1

