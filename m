Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A3C5C433EF
	for <linux-xfs@archiver.kernel.org>; Sun, 12 Jun 2022 21:32:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232875AbiFLVcp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 12 Jun 2022 17:32:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235950AbiFLVcn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 12 Jun 2022 17:32:43 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4692D9FE8;
        Sun, 12 Jun 2022 14:32:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=HTrppkgyoE0jfkD/I3hwHGO9wel7JMRK5JWmxra0aTw=; b=SEdm11PHMGs3xIT5eFgs1AaLQw
        wBdGhsxowR+3VG3Z0qlqYVd4ShqfwhcvCeXebJDQgFdY21nGO8jGU1DiQ9AnXML62aXC9T9iJ+xqE
        ZaQFMUEEbXRdl1IMHc60ASgvvamq7MuPHSP1mYdaxzNfDsL6pe3370ki95kajTAbs4E9G8M7XpSva
        qayDemMjdO4a79683xTqgJLYpn/2Q+rd2YonUuDU7DgtZ7ppIissSTdoJs4IUW+zX/+2vkE+ezHUC
        tJjdE39HiA2gssJMq9StqsbNVvNpaQY/pdSNrHJbus6q0krzIq7U/nYgXzmP4Q3fh+G+ICbIlUBSl
        lFYersDQ==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1o0VC9-00GHq0-GJ; Sun, 12 Jun 2022 21:32:29 +0000
From:   "Matthew Wilcox (Oracle)" <willy@infradead.org>
To:     Kees Cook <keescook@chromium.org>
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        linux-mm@kvack.org, Uladzislau Rezki <urezki@gmail.com>,
        Zorro Lang <zlang@redhat.com>, linux-xfs@vger.kernel.org,
        linux-hardening@vger.kernel.org
Subject: [PATCH 3/3] usercopy: Make usercopy resilient against ridiculously large copies
Date:   Sun, 12 Jun 2022 22:32:27 +0100
Message-Id: <20220612213227.3881769-4-willy@infradead.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220612213227.3881769-1-willy@infradead.org>
References: <20220612213227.3881769-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

If 'n' is so large that it's negative, we might wrap around and mistakenly
think that the copy is OK when it's not.  Such a copy would probably
crash, but just doing the arithmetic in a more simple way lets us detect
and refuse this case.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 mm/usercopy.c | 19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

diff --git a/mm/usercopy.c b/mm/usercopy.c
index 31deee7dd2f5..ff16083cf1c8 100644
--- a/mm/usercopy.c
+++ b/mm/usercopy.c
@@ -162,20 +162,18 @@ static inline void check_heap_object(const void *ptr, unsigned long n,
 				     bool to_user)
 {
 	uintptr_t addr = (uintptr_t)ptr;
+	unsigned long offset;
 	struct folio *folio;
 
 	if (is_kmap_addr(ptr)) {
-		unsigned long page_end = addr | (PAGE_SIZE - 1);
-
-		if (addr + n - 1 > page_end)
-			usercopy_abort("kmap", NULL, to_user,
-					offset_in_page(ptr), n);
+		offset = offset_in_page(ptr);
+		if (n > PAGE_SIZE - offset)
+			usercopy_abort("kmap", NULL, to_user, offset, n);
 		return;
 	}
 
 	if (is_vmalloc_addr(ptr)) {
 		struct vmap_area *area = find_vmap_area(addr);
-		unsigned long offset;
 
 		if (!area) {
 			usercopy_abort("vmalloc", "no area", to_user, 0, n);
@@ -184,9 +182,10 @@ static inline void check_heap_object(const void *ptr, unsigned long n,
 
 		/* XXX: We should also abort for free vmap_areas */
 
-		offset = addr - area->va_start;
-		if (addr + n > area->va_end)
+		if (n > area->va_end - addr) {
+			offset = addr - area->va_start;
 			usercopy_abort("vmalloc", NULL, to_user, offset, n);
+		}
 		return;
 	}
 
@@ -199,8 +198,8 @@ static inline void check_heap_object(const void *ptr, unsigned long n,
 		/* Check slab allocator for flags and size. */
 		__check_heap_object(ptr, n, folio_slab(folio), to_user);
 	} else if (folio_test_large(folio)) {
-		unsigned long offset = ptr - folio_address(folio);
-		if (offset + n > folio_size(folio))
+		offset = ptr - folio_address(folio);
+		if (n > folio_size(folio) - offset)
 			usercopy_abort("page alloc", NULL, to_user, offset, n);
 	}
 }
-- 
2.35.1

