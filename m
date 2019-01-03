Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54234 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726259AbfACPFZ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 3 Jan 2019 10:05:25 -0500
Date: Thu, 3 Jan 2019 10:05:21 -0500
From: Jerome Glisse <jglisse@redhat.com>
Subject: Re: [PATCH] Initialise mmu_notifier_range correctly
Message-ID: <20190103150521.GF3395@redhat.com>
References: <20190103002126.GM6310@bombadil.infradead.org>
 <20190103143116.GB3395@redhat.com>
 <20190103144313.GR6310@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190103144313.GR6310@bombadil.infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Matthew Wilcox <willy@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>, Jan Kara <jack@suse.cz>

On Thu, Jan 03, 2019 at 06:43:13AM -0800, Matthew Wilcox wrote:
> On Thu, Jan 03, 2019 at 09:31:16AM -0500, Jerome Glisse wrote:
> > On Wed, Jan 02, 2019 at 04:21:26PM -0800, Matthew Wilcox wrote:
> > > 
> > > One of the paths in follow_pte_pmd() initialised the mmu_notifier_range
> > > incorrectly.
> > > 
> > > Signed-off-by: Matthew Wilcox <willy@infradead.org>
> > > Fixes: ac46d4f3c432 ("mm/mmu_notifier: use structure for invalidate_range_start/end calls v2")
> > > Tested-by: Dave Chinner <dchinner@redhat.com>
> > 
> > Actually now that i have read the code again this is not ok to
> > do so. The caller of follow_pte_pmd() will call range_init and
> > follow pmd will only update the range address. So existing code
> > is ok.
> 
> I think you need to re-read your own patch.
> 
> `git show ac46d4f3c43241ffa23d5bf36153a0830c0e02cc`
> 
> @@ -4058,10 +4059,10 @@ static int __follow_pte_pmd(struct mm_struct *mm, unsigned long address,
>                 if (!pmdpp)
>                         goto out;
>  
> -               if (start && end) {
> -                       *start = address & PMD_MASK;
> -                       *end = *start + PMD_SIZE;
> -                       mmu_notifier_invalidate_range_start(mm, *start, *end);
> +               if (range) {
> +                       mmu_notifier_range_init(range, mm, address & PMD_MASK,
> +                                            (address & PMD_MASK) + PMD_SIZE);
> +                       mmu_notifier_invalidate_range_start(range);
> 
> ... so it's fine to call range_init() *here*.
> 
> @@ -4069,17 +4070,17 @@ static int __follow_pte_pmd(struct mm_struct *mm, unsign
> ed long address,
> [...]
>         if (pmd_none(*pmd) || unlikely(pmd_bad(*pmd)))
>                 goto out;
>  
> -       if (start && end) {
> -               *start = address & PAGE_MASK;
> -               *end = *start + PAGE_SIZE;
> -               mmu_notifier_invalidate_range_start(mm, *start, *end);
> +       if (range) {
> +               range->start = address & PAGE_MASK;
> +               range->end = range->start + PAGE_SIZE;
> +               mmu_notifier_invalidate_range_start(range);
> 
> ... but then *not* here later in the same function?  You're not making
> any sense.

Ok i see that the patch that add the reason why mmu notifier is
call have been drop. So yes using range_init in follow_pte_pmd
is fine. With that other patch the reasons is set by the caller
of follow_pte_pmd and using range_init would have overwritten
it.

So this patch is fine for current tree. Sorry i was thinking with
the other patch included in mind.

Cheers,
Jérôme
