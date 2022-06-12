Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA308CCA47D
	for <linux-xfs@archiver.kernel.org>; Sun, 12 Jun 2022 21:32:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234215AbiFLVcs (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 12 Jun 2022 17:32:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236111AbiFLVco (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 12 Jun 2022 17:32:44 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 751A3116E;
        Sun, 12 Jun 2022 14:32:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=tvuIUvh4KMt/W3Ck0YL8jqhN/KST+B/kPdeyBtOnYMI=; b=jOcEWP6MokPpHUTnlAkh/E65mL
        4W8V4vdlxVz2zQtkO9qZYuNZFn6zxe5LZMB+22Jesq35WG5x3Nw2E3mICgwIDFOWEmlaEzeLzTZif
        F1GoRcMUDGfoYNRj1nVAjB22aXZ/MwOO1EqMsv4gwAqSiELfP/UKhYIiEePON6kF+HKG7nHdQzv2v
        lQDev+2c7TK3GFkWkjZwQ1dgj9RG1XcUcrKpO8SY1zyRMfgip7xKLuuYv2IEupKC4R2Dp5F8os/YI
        opoHyaafYUTwT8RK0IuVDaP//qQIWKe5VGQMnGY6LVMulBYnbpkT5IkqyQj0zN0ywgWy3VDWwcTGT
        66BdCNUQ==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1o0VC9-00GHpw-CG; Sun, 12 Jun 2022 21:32:29 +0000
From:   "Matthew Wilcox (Oracle)" <willy@infradead.org>
To:     Kees Cook <keescook@chromium.org>
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        linux-mm@kvack.org, Uladzislau Rezki <urezki@gmail.com>,
        Zorro Lang <zlang@redhat.com>, linux-xfs@vger.kernel.org,
        linux-hardening@vger.kernel.org
Subject: [PATCH 1/3] usercopy: Handle vm_map_ram() areas
Date:   Sun, 12 Jun 2022 22:32:25 +0100
Message-Id: <20220612213227.3881769-2-willy@infradead.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220612213227.3881769-1-willy@infradead.org>
References: <20220612213227.3881769-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

vmalloc does not allocate a vm_struct for vm_map_ram() areas.  That causes
us to deny usercopies from those areas.  This affects XFS which uses
vm_map_ram() for its directories.

Fix this by calling find_vmap_area() instead of find_vm_area().

Fixes: 0aef499f3172 ("mm/usercopy: Detect vmalloc overruns")
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 include/linux/vmalloc.h | 1 +
 mm/usercopy.c           | 8 +++++---
 mm/vmalloc.c            | 2 +-
 3 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/include/linux/vmalloc.h b/include/linux/vmalloc.h
index b159c2789961..096d48aa3437 100644
--- a/include/linux/vmalloc.h
+++ b/include/linux/vmalloc.h
@@ -215,6 +215,7 @@ extern struct vm_struct *__get_vm_area_caller(unsigned long size,
 void free_vm_area(struct vm_struct *area);
 extern struct vm_struct *remove_vm_area(const void *addr);
 extern struct vm_struct *find_vm_area(const void *addr);
+struct vmap_area *find_vmap_area(unsigned long addr);
 
 static inline bool is_vm_area_hugepages(const void *addr)
 {
diff --git a/mm/usercopy.c b/mm/usercopy.c
index baeacc735b83..fdd1bed3b90a 100644
--- a/mm/usercopy.c
+++ b/mm/usercopy.c
@@ -173,7 +173,7 @@ static inline void check_heap_object(const void *ptr, unsigned long n,
 	}
 
 	if (is_vmalloc_addr(ptr)) {
-		struct vm_struct *area = find_vm_area(ptr);
+		struct vmap_area *area = find_vmap_area((unsigned long)ptr);
 		unsigned long offset;
 
 		if (!area) {
@@ -181,8 +181,10 @@ static inline void check_heap_object(const void *ptr, unsigned long n,
 			return;
 		}
 
-		offset = ptr - area->addr;
-		if (offset + n > get_vm_area_size(area))
+		/* XXX: We should also abort for free vmap_areas */
+
+		offset = (unsigned long)ptr - area->va_start;
+		if ((unsigned long)ptr + n > area->va_end)
 			usercopy_abort("vmalloc", NULL, to_user, offset, n);
 		return;
 	}
diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 07db42455dd4..effd1ff6a4b4 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -1798,7 +1798,7 @@ static void free_unmap_vmap_area(struct vmap_area *va)
 	free_vmap_area_noflush(va);
 }
 
-static struct vmap_area *find_vmap_area(unsigned long addr)
+struct vmap_area *find_vmap_area(unsigned long addr)
 {
 	struct vmap_area *va;
 
-- 
2.35.1

