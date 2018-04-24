Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mga05.intel.com ([192.55.52.43]:13615 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751117AbeDXXn0 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 24 Apr 2018 19:43:26 -0400
Subject: [PATCH v9 5/9] mm: fix __gup_device_huge vs unmap
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 24 Apr 2018 16:33:29 -0700
Message-ID: <152461280975.17530.2817946409563456285.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <152461278149.17530.2867511144531572045.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <152461278149.17530.2867511144531572045.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-nvdimm@lists.01.org
Cc: stable@vger.kernel.org, Jan Kara <jack@suse.cz>, david@fromorbit.com, hch@lst.de, linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org, linux-mm@kvack.orgjack@suse.czhch@lst.de

get_user_pages_fast() for device pages is missing the typical validation
that all page references have been taken while the mapping was valid.
Without this validation truncate operations can not reliably coordinate
against new page reference events like O_DIRECT.

Cc: <stable@vger.kernel.org>
Fixes: 3565fce3a659 ("mm, x86: get_user_pages() for dax mappings")
Reported-by: Jan Kara <jack@suse.cz>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 mm/gup.c |   36 ++++++++++++++++++++++++++----------
 1 file changed, 26 insertions(+), 10 deletions(-)

diff --git a/mm/gup.c b/mm/gup.c
index 76af4cfeaf68..84dd2063ca3d 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -1456,32 +1456,48 @@ static int __gup_device_huge(unsigned long pfn, unsigned long addr,
 	return 1;
 }
 
-static int __gup_device_huge_pmd(pmd_t pmd, unsigned long addr,
+static int __gup_device_huge_pmd(pmd_t orig, pmd_t *pmdp, unsigned long addr,
 		unsigned long end, struct page **pages, int *nr)
 {
 	unsigned long fault_pfn;
+	int nr_start = *nr;
+
+	fault_pfn = pmd_pfn(orig) + ((addr & ~PMD_MASK) >> PAGE_SHIFT);
+	if (!__gup_device_huge(fault_pfn, addr, end, pages, nr))
+		return 0;
 
-	fault_pfn = pmd_pfn(pmd) + ((addr & ~PMD_MASK) >> PAGE_SHIFT);
-	return __gup_device_huge(fault_pfn, addr, end, pages, nr);
+	if (unlikely(pmd_val(orig) != pmd_val(*pmdp))) {
+		undo_dev_pagemap(nr, nr_start, pages);
+		return 0;
+	}
+	return 1;
 }
 
-static int __gup_device_huge_pud(pud_t pud, unsigned long addr,
+static int __gup_device_huge_pud(pud_t orig, pud_t *pudp, unsigned long addr,
 		unsigned long end, struct page **pages, int *nr)
 {
 	unsigned long fault_pfn;
+	int nr_start = *nr;
+
+	fault_pfn = pud_pfn(orig) + ((addr & ~PUD_MASK) >> PAGE_SHIFT);
+	if (!__gup_device_huge(fault_pfn, addr, end, pages, nr))
+		return 0;
 
-	fault_pfn = pud_pfn(pud) + ((addr & ~PUD_MASK) >> PAGE_SHIFT);
-	return __gup_device_huge(fault_pfn, addr, end, pages, nr);
+	if (unlikely(pud_val(orig) != pud_val(*pudp))) {
+		undo_dev_pagemap(nr, nr_start, pages);
+		return 0;
+	}
+	return 1;
 }
 #else
-static int __gup_device_huge_pmd(pmd_t pmd, unsigned long addr,
+static int __gup_device_huge_pmd(pmd_t orig, pmd_t *pmdp, unsigned long addr,
 		unsigned long end, struct page **pages, int *nr)
 {
 	BUILD_BUG();
 	return 0;
 }
 
-static int __gup_device_huge_pud(pud_t pud, unsigned long addr,
+static int __gup_device_huge_pud(pud_t pud, pud_t *pudp, unsigned long addr,
 		unsigned long end, struct page **pages, int *nr)
 {
 	BUILD_BUG();
@@ -1499,7 +1515,7 @@ static int gup_huge_pmd(pmd_t orig, pmd_t *pmdp, unsigned long addr,
 		return 0;
 
 	if (pmd_devmap(orig))
-		return __gup_device_huge_pmd(orig, addr, end, pages, nr);
+		return __gup_device_huge_pmd(orig, pmdp, addr, end, pages, nr);
 
 	refs = 0;
 	page = pmd_page(orig) + ((addr & ~PMD_MASK) >> PAGE_SHIFT);
@@ -1537,7 +1553,7 @@ static int gup_huge_pud(pud_t orig, pud_t *pudp, unsigned long addr,
 		return 0;
 
 	if (pud_devmap(orig))
-		return __gup_device_huge_pud(orig, addr, end, pages, nr);
+		return __gup_device_huge_pud(orig, pudp, addr, end, pages, nr);
 
 	refs = 0;
 	page = pud_page(orig) + ((addr & ~PUD_MASK) >> PAGE_SHIFT);

