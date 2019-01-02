Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:44880 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726875AbfABWuG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 2 Jan 2019 17:50:06 -0500
Date: Wed, 2 Jan 2019 14:50:05 -0800
From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [BUG, TOT] xfs w/ dax failure in __follow_pte_pmd()
Message-ID: <20190102225005.GL6310@bombadil.infradead.org>
References: <20190102211332.GL4205@dastard>
 <20190102212531.GK6310@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190102212531.GK6310@bombadil.infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org, linux-mm@kvack.org, Dan Williams <dan.j.williams@intel.com>, =?iso-8859-1?B?Suly9G1l?= Glisse <jglisse@redhat.com>, Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>, Jan Kara <jack@suse.cz>, akpm@linux-foundation.org

On Wed, Jan 02, 2019 at 01:25:31PM -0800, Matthew Wilcox wrote:
> On Thu, Jan 03, 2019 at 08:13:32AM +1100, Dave Chinner wrote:
> > Hi folks,
> > 
> > An overnight test run on a current TOT kernel failed generic/413
> > with the following dmesg output:
> > 
> > [ 9487.276402] RIP: 0010:__follow_pte_pmd+0x22d/0x340
> > [ 9487.305065] Call Trace:
> > [ 9487.307310]  dax_entry_mkclean+0xbb/0x1f0
> 
> We've only got one commit touching dax_entry_mkclean and it's Jerome's.
> Looking through ac46d4f3c43241ffa23d5bf36153a0830c0e02cc, I'd say
> it's missing a call to mmu_notifier_range_init().

Could I persuade you to give this a try?

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
