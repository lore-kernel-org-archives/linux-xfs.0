Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:37015 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753589AbeAQUWh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 17 Jan 2018 15:22:37 -0500
From: Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v6 29/99] page cache: Convert filemap_range_has_page to XArray
Date: Wed, 17 Jan 2018 12:20:53 -0800
Message-Id: <20180117202203.19756-30-willy@infradead.org>
In-Reply-To: <20180117202203.19756-1-willy@infradead.org>
References: <20180117202203.19756-1-willy@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-kernel@vger.kernel.org
Cc: Matthew Wilcox <mawilcox@microsoft.com>, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, linux-nilfs@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-xfs@vger.kernel.org, linux-usb@vger.kernel.org, Bjorn Andersson <bjorn.andersson@linaro.org>, Stefano Stabellini <sstabellini@kernel.org>, iommu@lists.linux-foundation.org, linux-remoteproc@vger.kernel.org, linux-s390@vger.kernel.org, intel-gfx@lists.freedesktop.org, cgroups@vger.kernel.org, linux-sh@vger.kernel.org, David Howells <dhowells@redhat.com>

From: Matthew Wilcox <mawilcox@microsoft.com>

Instead of calling find_get_pages_range() and putting any reference,
just use xa_find() to look for a page in the right range.

Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
---
 mm/filemap.c | 9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/mm/filemap.c b/mm/filemap.c
index 2536fcacb5bc..cd01f353cf6a 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -461,18 +461,11 @@ bool filemap_range_has_page(struct address_space *mapping,
 {
 	pgoff_t index = start_byte >> PAGE_SHIFT;
 	pgoff_t end = end_byte >> PAGE_SHIFT;
-	struct page *page;
 
 	if (end_byte < start_byte)
 		return false;
 
-	if (mapping->nrpages == 0)
-		return false;
-
-	if (!find_get_pages_range(mapping, &index, end, 1, &page))
-		return false;
-	put_page(page);
-	return true;
+	return xa_find(&mapping->pages, &index, end, XA_PRESENT);
 }
 EXPORT_SYMBOL(filemap_range_has_page);
 
-- 
2.15.1

