Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6790938DD3;
	Sun,  3 May 2026 11:55:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777809358; cv=none; b=HKa3l1R+XVaV8fDwp0RuxnUR8w8l8kozpNi4DeucLpgNh6+q1UlhEO1qoPQAtAWlFhvg43D+trzZXpaXVpNNKVGgScObLkmJLkL17EsAerpzX/H0I1fRkcWQK92Bh1uvoeSjxVF1i8LVMFPiGjJc48yIwFF0doxylnF6eGvMwCQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777809358; c=relaxed/simple;
	bh=GhxPynsqlQoPstEW4fv2fa4C/Cb9zcVZcHddhrTFQos=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SCcI8YcJy7x8vf2U9hSNzv5yGwp23rIuZ9HZevHve5XW3HEp7WpPfw7qPe65DgcNY41L5ztZv2zFcLqhXDJOrChQkzlOcjbESffwnnvy03TMTVrm78Yx28RxxjMPn7ynrpyPqrRDgUbFCrco5AMi938iZ1sFuypyai3dGkLU/FU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=gyiR4lME; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="gyiR4lME"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Transfer-Encoding:
	Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=CE0IODkixju0+rcNdA3JHyloJEzjxQGb1seeQBb+Rz0=; b=gyiR4lMEmEdCdQiJcUiy0/H8IQ
	9prnP/1UmTUCdQJZViZhxCo7RbhgQyuTyMbYCriAdYf4fLEU2PtrM0JCI/hQV1hyzuHZftBHXBysU
	oX+Xdre6gg0mqdZ5sqHXsRB1IWlS+3gP2T5afTfNz80luUvxOuc9B931xnZmMe+MdV70dF0CGp4v9
	9Rv7l3EBFQ9Th1XhsSgbrNUAAkQkSJzG429IAUTh9kbWr3dEA4aX4axR5hHJdp3zWcOiKfwQq96b2
	mpnP8L3G6AeWEDeCFrwvPYrtbdTiawmfq18HoE6Fm6KAsB08pKNxk6Pon+n9mQHAZ0u+9J/OIE6FU
	2e7Tl+cw==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1wJVQK-0000000Gx1K-2mC4;
	Sun, 03 May 2026 11:55:48 +0000
Date: Sun, 3 May 2026 12:55:48 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Ritesh Harjani <ritesh.list@gmail.com>
Cc: Salvatore Dipietro <dipiets@amazon.it>,
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
	Vlastimil Babka <vbabka@suse.com>, abuehaze@amazon.com,
	alisaidi@amazon.com, blakgeof@amazon.com, brauner@kernel.org,
	dipietro.salvatore@gmail.com, djwong@kernel.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-xfs@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 1/1] iomap: avoid compaction for costly folio order
 allocation
Message-ID: <afc3xFgKogxF5Lbq@casper.infradead.org>
References: <cxztt8nw.ritesh.list@gmail.com>
 <20260428150240.3009-1-dipiets@amazon.it>
 <a4uhrqet.ritesh.list@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <a4uhrqet.ritesh.list@gmail.com>

On Sun, May 03, 2026 at 11:22:10AM +0530, Ritesh Harjani wrote:
> Now this is what I believe could be the reason for memory fragmentation
> with this workload - 
> In Linux, each PTE page table uses 4KB size (assuming you are using 4KB
> system PAGE_SIZE). When your workload forks a
> child process for each new connection, child gets its own copy of the
> page tables which maps the shared buffer.
> Since each PTE table is a single 4KB page, hundreds of connections
> spawning means hundreds of thousands of single-page allocations for page
> tables. So it looks like, the major source of your memory fragmentation
> problem must be these several order-0 allocations for PTE page table
> pages.

While memory is fragmented, the _problem_ is that we try too hard to
defragment.  From the original post:

: When memory is fragmented, each failed allocation triggers
: compaction and drain_all_pages() via __alloc_pages_slowpath()

We really should only try compaction once.  If it didn't make useful
progress last time, it won't this time either.

> > | Patch                |    Run 1   |    Run 2   |    Run 3   |   Average   | % vs Baseline |
> > |----------------------|-----------:|-----------:|-----------:|------------:|:-------------:|
> > | Baseline             | 107,064.61 |  97,043.86 | 101,830.78 | 101,979.75  |       —       |
> > | Proposed patch       | 146,012.23 | 136,392.36 | 141,178.00 | 141,194.20  |    +38.45%    |
> > | Ritesh's suggestion  | 147,481.50 | 133,069.03 | 137,051.30 | 139,200.61  |    +36.50%    |
> > | Matthew's suggestion | 145,653.91 | 144,169.24 | 141,768.31 | 143,863.82  |    +41.07%    |
> 
> 
> The main reason, why I proposed the below patch was because, this only
> affects costly order allocation (i.e for order > PAGE_ALLOC_COSTLY_ORDER)
> by skipping direct reclaim for those orders, while still keeping the
> behaviour same for others.
> 
> So, for smaller orders (order > min_order and <=
> PAGE_ALLOC_COSTLY_ORDER), the allocator will still attempt for direct
> reclaim and compaction (which I guess is required to avoid oom too?) And
> also, this looks like a change which could be easily backportable :)
> 
> diff --git a/mm/filemap.c b/mm/filemap.c
> index 4e636647100c..f2343c26dd63 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -2007,8 +2007,13 @@ struct folio *__filemap_get_folio_mpol(struct address_space *mapping,
>  			gfp_t alloc_gfp = gfp;
>  
>  			err = -ENOMEM;
> -			if (order > min_order)
> -				alloc_gfp |= __GFP_NORETRY | __GFP_NOWARN;
> +			if (order > min_order) {
> +				alloc_gfp |= __GFP_NOWARN;
> +				if (order > PAGE_ALLOC_COSTLY_ORDER)
> +					alloc_gfp &= ~__GFP_DIRECT_RECLAIM;
> +				else
> +					alloc_gfp |= __GFP_NORETRY;
> +			}
> 
> 
> But of course let's hear from others on their suggestions / thoughts.
> Maybe the filemap is not the right place to fix this as Matthew, Andrew
> and others were pointing. Any other suggestions on how to approach this,
> please?

filemap.c REALLY shouldn't know about PAGE_ALLOC_COSTLY_ORDER.
That's an internal detail of the memory allocator.

Either we want an API to say "allocate me a folio between orders A and B"
or we need more understandable GFP flags.  Or the page allocator could
use the __GFP_NORETRY flag to say "oh well, this allocation has a fallback,
I'll kick kcompactd to try to compact some more memory, but I'll fail
the allocation".
