Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:51684 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726213AbfACAVa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 2 Jan 2019 19:21:30 -0500
Date: Wed, 2 Jan 2019 16:21:26 -0800
From: Matthew Wilcox <willy@infradead.org>
Subject: [PATCH] Initialise mmu_notifier_range correctly
Message-ID: <20190103002126.GM6310@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>, Jan Kara <jack@suse.cz>, =?iso-8859-1?B?Suly9G1l?= Glisse <jglisse@redhat.com>


One of the paths in follow_pte_pmd() initialised the mmu_notifier_range
incorrectly.

Signed-off-by: Matthew Wilcox <willy@infradead.org>
Fixes: ac46d4f3c432 ("mm/mmu_notifier: use structure for invalidate_range_start/end calls v2")
Tested-by: Dave Chinner <dchinner@redhat.com>

diff --git a/mm/memory.c b/mm/memory.c
index 2dd2f9ab57f4..21a650368be0 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -4078,8 +4078,8 @@ static int __follow_pte_pmd(struct mm_struct *mm, unsigned long address,
 		goto out;
 
 	if (range) {
-		range->start = address & PAGE_MASK;
-		range->end = range->start + PAGE_SIZE;
+		mmu_notifier_range_init(range, mm, address & PAGE_MASK,
+				     (address & PAGE_MASK) + PAGE_SIZE);
 		mmu_notifier_invalidate_range_start(range);
 	}
 	ptep = pte_offset_map_lock(mm, pmd, address, ptlp);
