Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34011 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752304AbdJSNIl (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 19 Oct 2017 09:08:41 -0400
From: Jan Kara <jack@suse.cz>
Subject: [PATCH 02/17] mm: Remove VM_FAULT_HWPOISON_LARGE_MASK
Date: Thu, 19 Oct 2017 14:58:01 +0200
Message-Id: <20171019125817.11580-3-jack@suse.cz>
In-Reply-To: <20171019125817.11580-1-jack@suse.cz>
References: <20171019125817.11580-1-jack@suse.cz>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-fsdevel@vger.kernel.org
Cc: linux-nvdimm@lists.01.org, Ross Zwisler <ross.zwisler@linux.intel.com>, Dan Williams <dan.j.williams@intel.com>, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, linux-api@vger.kernel.org, Jan Kara <jack@suse.cz>

It is unused.

Reviewed-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 include/linux/mm.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 065d99deb847..ca72b67153d5 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1182,8 +1182,6 @@ static inline void clear_page_pfmemalloc(struct page *page)
 #define VM_FAULT_FALLBACK 0x0800	/* huge page fault failed, fall back to small */
 #define VM_FAULT_DONE_COW   0x1000	/* ->fault has fully handled COW */
 
-#define VM_FAULT_HWPOISON_LARGE_MASK 0xf000 /* encodes hpage index for large hwpoison */
-
 #define VM_FAULT_ERROR	(VM_FAULT_OOM | VM_FAULT_SIGBUS | VM_FAULT_SIGSEGV | \
 			 VM_FAULT_HWPOISON | VM_FAULT_HWPOISON_LARGE | \
 			 VM_FAULT_FALLBACK)
-- 
2.12.3

