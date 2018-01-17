Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:54585 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753750AbeAQUWw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 17 Jan 2018 15:22:52 -0500
From: Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v6 62/99] dax: Convert dax_insert_pfn_mkwrite to XArray
Date: Wed, 17 Jan 2018 12:21:26 -0800
Message-Id: <20180117202203.19756-63-willy@infradead.org>
In-Reply-To: <20180117202203.19756-1-willy@infradead.org>
References: <20180117202203.19756-1-willy@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-kernel@vger.kernel.org
Cc: Matthew Wilcox <mawilcox@microsoft.com>, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, linux-nilfs@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-xfs@vger.kernel.org, linux-usb@vger.kernel.org, Bjorn Andersson <bjorn.andersson@linaro.org>, Stefano Stabellini <sstabellini@kernel.org>, iommu@lists.linux-foundation.org, linux-remoteproc@vger.kernel.org, linux-s390@vger.kernel.org, intel-gfx@lists.freedesktop.org, cgroups@vger.kernel.org, linux-sh@vger.kernel.org, David Howells <dhowells@redhat.com>

From: Matthew Wilcox <mawilcox@microsoft.com>

Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
---
 fs/dax.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index b66b8c896ed8..e6b25ef112f2 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -1497,21 +1497,21 @@ static int dax_insert_pfn_mkwrite(struct vm_fault *vmf,
 	void *entry;
 	int vmf_ret, error;
 
-	xa_lock_irq(&mapping->pages);
+	xas_lock_irq(&xas);
 	entry = get_unlocked_mapping_entry(&xas);
 	/* Did we race with someone splitting entry or so? */
 	if (!entry ||
 	    (pe_size == PE_SIZE_PTE && !dax_is_pte_entry(entry)) ||
 	    (pe_size == PE_SIZE_PMD && !dax_is_pmd_entry(entry))) {
 		put_unlocked_mapping_entry(&xas, entry);
-		xa_unlock_irq(&mapping->pages);
+		xas_unlock_irq(&xas);
 		trace_dax_insert_pfn_mkwrite_no_entry(mapping->host, vmf,
 						      VM_FAULT_NOPAGE);
 		return VM_FAULT_NOPAGE;
 	}
-	radix_tree_tag_set(&mapping->pages, index, PAGECACHE_TAG_DIRTY);
+	xas_set_tag(&xas, PAGECACHE_TAG_DIRTY);
 	entry = lock_slot(&xas);
-	xa_unlock_irq(&mapping->pages);
+	xas_unlock_irq(&xas);
 	switch (pe_size) {
 	case PE_SIZE_PTE:
 		error = vm_insert_mixed_mkwrite(vmf->vma, vmf->address, pfn);
-- 
2.15.1

