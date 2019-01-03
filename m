Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55032 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726167AbfACB46 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 2 Jan 2019 20:56:58 -0500
Date: Wed, 2 Jan 2019 20:56:55 -0500
From: Jerome Glisse <jglisse@redhat.com>
Subject: Re: [PATCH] Initialise mmu_notifier_range correctly
Message-ID: <20190103015654.GB15619@redhat.com>
References: <20190103002126.GM6310@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190103002126.GM6310@bombadil.infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Matthew Wilcox <willy@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>, Jan Kara <jack@suse.cz>

On Wed, Jan 02, 2019 at 04:21:26PM -0800, Matthew Wilcox wrote:
> 
> One of the paths in follow_pte_pmd() initialised the mmu_notifier_range
> incorrectly.
> 
> Signed-off-by: Matthew Wilcox <willy@infradead.org>
> Fixes: ac46d4f3c432 ("mm/mmu_notifier: use structure for invalidate_range_start/end calls v2")
> Tested-by: Dave Chinner <dchinner@redhat.com>

Reviewed-by: Jérôme Glisse <jglisse@redhat.com>

> 
> diff --git a/mm/memory.c b/mm/memory.c
> index 2dd2f9ab57f4..21a650368be0 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -4078,8 +4078,8 @@ static int __follow_pte_pmd(struct mm_struct *mm, unsigned long address,
>  		goto out;
>  
>  	if (range) {
> -		range->start = address & PAGE_MASK;
> -		range->end = range->start + PAGE_SIZE;
> +		mmu_notifier_range_init(range, mm, address & PAGE_MASK,
> +				     (address & PAGE_MASK) + PAGE_SIZE);
>  		mmu_notifier_invalidate_range_start(range);
>  	}
>  	ptep = pte_offset_map_lock(mm, pmd, address, ptlp);
