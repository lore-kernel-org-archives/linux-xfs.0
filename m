Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52471 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751482AbdG0NMt (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 27 Jul 2017 09:12:49 -0400
From: Jan Kara <jack@suse.cz>
Subject: [PATCH 1/7] mm: Remove VM_FAULT_HWPOISON_LARGE_MASK
Date: Thu, 27 Jul 2017 15:12:39 +0200
Message-Id: <20170727131245.28279-2-jack@suse.cz>
In-Reply-To: <20170727131245.28279-1-jack@suse.cz>
References: <20170727131245.28279-1-jack@suse.cz>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-fsdevel@vger.kernel.org
Cc: linux-ext4@vger.kernel.org, Ross Zwisler <ross.zwisler@linux.intel.com>, Dan Williams <dan.j.williams@intel.com>, Andy Lutomirski <luto@kernel.org>, linux-nvdimm@lists.01.org, linux-xfs@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Dave Chinner <david@fromorbit.com>, Jan Kara <jack@suse.cz>

It is unused.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 include/linux/mm.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 483e84cf9fc6..fa036093e76c 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1143,8 +1143,6 @@ static inline void clear_page_pfmemalloc(struct page *page)
 #define VM_FAULT_FALLBACK 0x0800	/* huge page fault failed, fall back to small */
 #define VM_FAULT_DONE_COW   0x1000	/* ->fault has fully handled COW */
 
-#define VM_FAULT_HWPOISON_LARGE_MASK 0xf000 /* encodes hpage index for large hwpoison */
-
 #define VM_FAULT_ERROR	(VM_FAULT_OOM | VM_FAULT_SIGBUS | VM_FAULT_SIGSEGV | \
 			 VM_FAULT_HWPOISON | VM_FAULT_HWPOISON_LARGE | \
 			 VM_FAULT_FALLBACK)
-- 
2.12.3

