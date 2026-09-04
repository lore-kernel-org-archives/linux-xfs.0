Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60F3E3E3169;
	Fri,  4 Sep 2026 14:12:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788531125; cv=none; b=oVzHoOYN6AmfUm6+l246XYs8+56+htIH0cga2/bIHy1Fp60AXHzjRtJW4WmC55KHpQs+bRAYL2xfQRYREENVUV6GfXNL88XPsLI4z+eWVm7daNQGYcjn/oGB+tmy+Z9nbm3JokMzQ8NtdFhlbmLMGgyki1mvPhf+Gz4gYuzQsNU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788531125; c=relaxed/simple;
	bh=4hPXPpMVtufBarZhUpztHFuCmYQv+MJIYTrof+gNltY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=IQ8XghXWW8l1LxvAWDOXdVO1VsJDgY3zi4aLWY45xdsaYjB5zD9s31ItdSekkfSlr5QSOcsxTFvphp7JSIPz3w1Y+nCsYNlUDSX+zWQB4HYA0ZhgXr0fcq28oRV9CDC8hI0p06U4jcS03OwbaqZdAcuQ+vqG6BjGhrrgrdXlyiA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BrE+ZMtf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BrE+ZMtf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D4211F00A3D;
	Fri,  4 Sep 2026 14:11:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788531124;
	bh=HslPyUpRcbehZSDwq6RcvWYGlQd9VOcvDUYf4trg7Og=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=BrE+ZMtfse74Rx9gXb8TBDlul9CFpphp+iDqcuvaKvn+la0P4nw5x+dpLJxpxymss
	 Fs3KqhtyP8Y5icHlBfXtie/e7n3oDDCiUPhZMb2z4zlcBvtOi8L+OmAJuavGfAlGrs
	 cXtecutkELrLQLHpstHEKDgODcyKR1f9W8IYLMCJ5IN1eY5iumCefMXOEHCTqsuitP
	 ny3AZ/M7WoDBugBXgLtjoiKCabNy4omvWzIwPrvn8EX3kpo73VlkRer+YmR0M1jHGH
	 kROjVJDipV2iUMvn9dIfWNAesAHo6z6phJRoseA1bL5GIfnFKW3k4F/FOU9ZFkNNN+
	 E/dfVEFGq0SAg==
Message-ID: <8cc503d9-04a1-4d90-874c-ada6c0ac5147@kernel.org>
Date: Fri, 4 Sep 2026 16:11:57 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4] mm/page_alloc: avoid direct compaction for costly
 __GFP_NORETRY allocations
Content-Language: en-US
To: Salvatore Dipietro <dipiets@amazon.it>, linux-kernel@vger.kernel.org,
 hch@infradead.org
Cc: abuehaze@amazon.com, akpm@linux-foundation.org, alisaidi@amazon.com,
 blakgeof@amazon.com, brauner@kernel.org, dgc@kernel.org,
 dipietro.salvatore@gmail.com, djwong@kernel.org, hannes@cmpxchg.org,
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
 linux-xfs@vger.kernel.org, mhocko@suse.com, ritesh.list@gmail.com,
 rvvandan@amazon.com, stable@vger.kernel.org, surenb@google.com,
 willy@infradead.org, ziy@nvidia.com, David Hildenbrand <david@redhat.com>,
 Christoph Hellwig <hch@lst.de>, Brendan Jackman <brendan.jackman@linux.dev>
References: <20260904115629.3993331-1-dipiets@amazon.it>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20260904115629.3993331-1-dipiets@amazon.it>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 9/4/26 13:56, Salvatore Dipietro wrote:
> Commit 5d8edfb900d5 ("iomap: Copy larger chunks from userspace")
> introduced high-order folio allocations in the iomap buffered write
> path.  When memory is fragmented, each failed costly-order allocation
> enters __alloc_pages_slowpath() which runs direct compaction and
> drain_all_pages(), causing a 0.38x throughput drop on PostgreSQL
> pgbench (simple-update) with 1024 clients on a 96-vCPU arm64 system.
> 
> The root issue is that direct compaction is too expensive for hot
> allocation paths that have fallbacks to smaller allocations.
> __filemap_get_folio_mpol() already marks higher-order allocations with
> __GFP_NORETRY | __GFP_NOWARN, signalling that the caller can handle
> failure.  However, the page allocator still attempts full direct
> compaction for costly orders with __GFP_NORETRY, which is unnecessarily
> aggressive when the caller will simply retry at a lower order.
> 
> For costly-order allocations with __GFP_NORETRY, clear
> __GFP_DIRECT_RECLAIM at the very start of the slowpath, before
> can_direct_reclaim, can_compact and the nofail checks are evaluated.
> This makes the entire slowpath treat the request as non-blocking: no
> direct reclaim, no direct compaction and no drain_all_pages() IPI
> across every CPU. kswapd (and in turn kcompactd) is still woken further
> down for background defragmentation, so compaction keeps working for
> long-term system health while being removed from the latency-critical
> direct allocation path.
> 
> Allocations that also request __GFP_THISNODE are exempted.  That flag
> pairing identifies the local-node-first THP attempt issued by
> alloc_pages_mpol() (mempolicy.c), which relies on direct compaction to
> form transparent huge pages.
> 
> Test environment:
>   Hardware:  AWS EC2 m8g.24xlarge (96 vCPU, arm64)
>              12x 1TB IO2 32000 IOPS RAID0 XFS
>   OS:        AL2023
>   Kernel:    v7.3-rc1
>   Database:  PostgreSQL 18.4
>   Workload:  pgbench simple-update, 1024 clients, 96 threads, 1200s
> 
> Results (average of 3 runs, TPS):
> 
>   Config                   Avg TPS      % vs Baseline
>   baseline (no patch)       59,408       -
>   With this patch          155,409      +161.6%
> 
> Link: https://lore.kernel.org/all/20260403193535.9970-1-dipiets@amazon.it/T/#t [v1]
> Link: https://lore.kernel.org/linux-mm/20260420161404.642-1-dipiets@amazon.it/T/#u [v2]
> Link: https://lore.kernel.org/all/20260710143437.12379-1-dipiets@amazon.it/T/#u [v3]
> Fixes: 5d8edfb900d5 ("iomap: Copy larger chunks from userspace")
> Cc: stable@vger.kernel.org
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Vlastimil Babka <vbabka@suse.cz>
> Cc: David Hildenbrand <david@redhat.com>
> Cc: Michal Hocko <mhocko@suse.com>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Matthew Wilcox <willy@infradead.org>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Dave Chinner <dgc@kernel.org>
> Cc: Ritesh Harjani <ritesh.list@gmail.com>
> Cc: linux-mm@kvack.org
> Cc: linux-fsdevel@vger.kernel.org
> Cc: linux-xfs@vger.kernel.org
> Signed-off-by: Salvatore Dipietro <dipiets@amazon.it>

I guess this will have to do until unlikely(we figure out a better API)...

Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

> ---
> v4: Clear __GFP_DIRECT_RECLAIM early in the slowpath and exempt
>     __GFP_THISNODE so THP attempt keeps using direct compaction
> v3: Move to mm/page_alloc.c, wake kcompactd instead of avoiding it
> v2: Move from fs/iomap/buffered-io.c to mm/filemap.c
> v1: Avoid compaction in iomap folio allocation
> 
>  mm/page_alloc.c | 18 +++++++++++++++---
>  1 file changed, 15 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 12fac9084c48..542c2ec31061 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -4784,10 +4784,10 @@ static inline struct page *
>  __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
>  						struct alloc_context *ac)
>  {
> -	bool can_direct_reclaim = gfp_mask & __GFP_DIRECT_RECLAIM;
> -	bool can_compact = can_direct_reclaim && gfp_compaction_allowed(gfp_mask);
> -	bool nofail = gfp_mask & __GFP_NOFAIL;
>  	const bool costly_order = order > PAGE_ALLOC_COSTLY_ORDER;
> +	bool can_direct_reclaim;
> +	bool can_compact;
> +	bool nofail;
>  	struct page *page = NULL;
>  	unsigned int alloc_flags;
>  	unsigned long did_some_progress;
> @@ -4802,6 +4802,18 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
>  	bool can_retry_reserves = true;
>  	unsigned long alloc_start_time = jiffies;
>  
> +	/*
> +	 * Costly __GFP_NORETRY callers have a cheap fallback, so don't stall
> +	 * them in reclaim or compaction. __GFP_THISNODE callers are exempt.
> +	 */
> +	if (costly_order && (gfp_mask & __GFP_NORETRY) &&
> +	    !(gfp_mask & __GFP_THISNODE))
> +		gfp_mask &= ~__GFP_DIRECT_RECLAIM;
> +
> +	can_direct_reclaim = gfp_mask & __GFP_DIRECT_RECLAIM;
> +	can_compact = can_direct_reclaim && gfp_compaction_allowed(gfp_mask);
> +	nofail = gfp_mask & __GFP_NOFAIL;
> +
>  	if (unlikely(nofail)) {
>  		/*
>  		 * Also we don't support __GFP_NOFAIL without __GFP_DIRECT_RECLAIM,

