Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:55677 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753400AbdLFAmS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 5 Dec 2017 19:42:18 -0500
From: Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v4 65/73] dax: Fix sparse warning
Date: Tue,  5 Dec 2017 16:41:51 -0800
Message-Id: <20171206004159.3755-66-willy@infradead.org>
In-Reply-To: <20171206004159.3755-1-willy@infradead.org>
References: <20171206004159.3755-1-willy@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
Cc: Matthew Wilcox <mawilcox@microsoft.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, Jens Axboe <axboe@kernel.dk>, Rehas Sachdeva <aquannie@gmail.com>, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, linux-nilfs@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-xfs@vger.kernel.org, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org

From: Matthew Wilcox <mawilcox@microsoft.com>

sparse doesn't know that follow_pte_pmd conditionally acquires the ptl,
so add an annotation to let it know what's going on.

Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
---
 fs/dax.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/dax.c b/fs/dax.c
index c663d82e8ba3..7a86ff1153dd 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -531,6 +531,7 @@ static void dax_mapping_entry_mkclean(struct address_space *mapping,
 		 */
 		if (follow_pte_pmd(vma->vm_mm, address, &start, &end, &ptep, &pmdp, &ptl))
 			continue;
+		__acquire(ptl); /* Conditionally acquired above */
 
 		/*
 		 * No need to call mmu_notifier_invalidate_range() as we are
-- 
2.15.0

