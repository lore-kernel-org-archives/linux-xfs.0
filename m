Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793866543;
	b=Yh9FujEtLZc3N/iRzn2Jgn7z3JQGBhTdaElH7uqHl2zhKYmop5gjFRYfvFwUe/wlQ8cC
	 h1ytVTC0glbII5nbN1MCP5ZhPXFTlO6CGkzMI97aosEnuamwNbBS3x8nOaWVXH5lqoFD7
	 YpmrUo64mWw++PwKC5us3j+1s3mBFAK8za4B8qW+maGMx4K3UGESB3QXHdDLMux5Ajz2a
	 xneVbHi+5P7BUEIRCEZ7qDpNmPqV9S6o94RcGFk3KrrqC97dgomojJCMvB+iBtX1wYp0h
	 dt8AD+yngAb1Ylg43n+gIElza6DpK+O1l7uKMrVRp0jWB4Zavl/cocl6vfnSbo0Yvcw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793866543;
	h=Received:DKIM-Signature:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:Content-Language:To:Cc:References:From:Autocrypt:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding;
	bh=PqVJrqCplD2272hpkWFwVcPUGoXg+HOijFlxAT2SeNM=;
	b=eAw6bMmMe2uKYsHR0G9LZKSCpkUyiXXvBtTjy0LaEgcVB5ZCR/E6huIMn5GCtP4nu/O1
	 4BACHAndKtzJZzQ16TtMSJbWLoPi8SW9hs//E9pBmeDhvlcslZ26vAyKkjjkH2O6Y6wX8
	 +SRDt/sC+J7+92oiSSObm9ptRtqf3n/B1QGEFiLPZfFQjMgamAtwI1iKb33uSUxLRbgrP
	 cSmSdMHwr4xi9cLgH+b4zmEwEXsmCFsGK5jiIpW5aNYCIx5ykr/q0E3rBAIEtE85WX0fQ
	 MLIJYnZczNuXFbHq4aUDbNJ8rt7QGoq+03yVrJ/zmK59JlK4rno/lSIGqipQEqiwbeQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oNg+UfgH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1481F606A32F;
	Thu,  5 Nov 2026 08:15:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oNg+UfgH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B75A1F000C1;
	Thu,  5 Nov 2026 08:15:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793866542;
	bh=PqVJrqCplD2272hpkWFwVcPUGoXg+HOijFlxAT2SeNM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=oNg+UfgHD4ZLaUNBVkRFIHRA0gfjeajdzdUqRzfc5YLfimMgw73C7hTCGf2evUoiF
	 o5aQenWk3lkesNtxN94qsYzqGbZ0sBeTkX4R0jeWMQ9hEwbMcMT6dX8TZkqtwCgwHf
	 /y2LwIjZb3LYKBmcFxbd22p4oPOpyg4FeUYhPzUtJS+JxE9SEnh+5KpiuWrC+8LKY/
	 wYXeba5Onzm117aObPxW4rGT+jZM89C5TkGsduI2ZfVhugghwGliz6ctTNZreFj56z
	 9Ldf6gTscVYTguXZLVnnFXqTGgJq1fFT2dZFLjJuMOlqip46X01str7vxXoIy0V0Of
	 /762uRT+HKBrA==
Message-ID: <4d0e9017-18cb-4344-8f7f-414d708b4e9d@kernel.org>
Date: Thu, 5 Nov 2026 09:15:35 +0100
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6] mm/page_alloc: avoid direct reclaim and compaction for
 costly __GFP_NORETRY allocations
Content-Language: en-US
To: Thadeu Lima de Souza Cascardo <cascardo@igalia.com>,
 Salvatore Dipietro <dipiets@amazon.it>
Cc: linux-kernel@vger.kernel.org, hch@infradead.org, abuehaze@amazon.com,
 akpm@linux-foundation.org, alisaidi@amazon.com, blakgeof@amazon.com,
 brauner@kernel.org, dgc@kernel.org, dipietro.salvatore@gmail.com,
 djwong@kernel.org, hannes@cmpxchg.org, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, linux-xfs@vger.kernel.org, mhocko@suse.com,
 ritesh.list@gmail.com, rvvandan@amazon.com, stable@vger.kernel.org,
 surenb@google.com, willy@infradead.org, ziy@nvidia.com,
 David Hildenbrand <david@redhat.com>, Christoph Hellwig <hch@lst.de>,
 Dmitry Ilvokhin <d@ilvokhin.com>, Brendan Jackman
 <brendan.jackman@linux.dev>, =?UTF-8?Q?Christian_K=C3=B6nig?=
 <christian.koenig@amd.com>
References: <20261001082152.2879289-1-dipiets@amazon.it>
 <auuDXDglZ-Z1LZhA@quatroqueijos.cascardo.eti.br>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <auuDXDglZ-Z1LZhA@quatroqueijos.cascardo.eti.br>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/4/26 20:11, Thadeu Lima de Souza Cascardo wrote:
> On Thu, Oct 01, 2026 at 08:21:51AM +0000, Salvatore Dipietro wrote:
>> Commit 5d8edfb900d5 ("iomap: Copy larger chunks from userspace")
>> introduced high-order folio allocations in the iomap buffered write
>> path.  When memory is fragmented, each failed costly-order allocation
>> enters __alloc_pages_slowpath() which runs direct reclaim, direct
>> compaction and drain_all_pages(), causing a 0.38x throughput drop on
>> PostgreSQL pgbench (simple-update) with 1024 clients on a 96-vCPU arm64
>> system.
>> 
>> The root issue is that direct reclaim and direct compaction are too
>> expensive for hot allocation paths that have fallbacks to smaller
>> allocations.  __filemap_get_folio_mpol() already marks higher-order
>> allocations with __GFP_NORETRY | __GFP_NOWARN, signalling that the
>> caller can handle failure.  However, the page allocator still enters the
>> full blocking slowpath for costly orders with __GFP_NORETRY, which is
>> unnecessarily aggressive when the caller will simply retry at a lower
>> order.
>> 
>> For costly-order allocations with __GFP_NORETRY, clear
>> __GFP_DIRECT_RECLAIM at the very start of the slowpath, before
>> can_direct_reclaim, can_compact and the nofail checks are evaluated.
>> This makes the entire slowpath treat the request as non-blocking: no
>> direct reclaim, no direct compaction and no drain_all_pages() IPI
>> across every CPU.  Reclaim and compaction move to the background
>> instead: kswapd is still woken for reclaim, and it wakes kcompactd for
>> defragmentation.  The system keeps its long-term health while the
>> latency-critical direct allocation path no longer stalls.
>> 
>> Allocations that also request __GFP_THISNODE are exempted.  That flag
>> pairing identifies the local-node-first THP attempt issued by
>> alloc_pages_mpol() (mempolicy.c), which relies on direct compaction to
>> form transparent huge pages.
>> 
>> Clearing __GFP_DIRECT_RECLAIM makes these allocations reach the
>> !can_direct_reclaim bailout, which since commit 4c0ed883e051
>> ("mm/page_alloc: fix defrag_mode for non-reclaimable allocations") drops
>> ALLOC_NOFRAGMENT and retries instead of failing when defrag_mode is on.
>> With vm.defrag_mode=1 a __GFP_NORETRY allocation could therefore succeed
>> by fragmenting another migratetype's pageblock.  That is the wrong trade
>> for a caller that has already communicated it can handle failure and has
>> a cheap lower-order fallback, so exclude __GFP_NORETRY from the
>> relaxation.  The exclusion is not restricted to costly orders: any
>> __GFP_NORETRY caller has said it can cope with failure, so failing is
>> preferable to fragmenting for all of them.
>> 
>> Test environment:
>>   Hardware:  AWS EC2 m8g.24xlarge (96 vCPU, arm64)
>>              12x 1TB IO2 32000 IOPS RAID0 XFS
>>   OS:        AL2023
>>   Kernel:    v7.3-rc1
>>   Database:  PostgreSQL 18.4
>>   Workload:  pgbench simple-update, 1024 clients, 96 threads, 1200s
>> 
>> Results (average of 3 runs, TPS):
>> 
>>   Config                                       Avg TPS   % vs baseline
>>   v7.3-rc1 baseline (vm.defrag_mode=0)          58,602               -
>>   v7.3-rc1 + this patch (vm.defrag_mode=0)     157,246         +168.3%
>>   v7.3-rc1 baseline (vm.defrag_mode=1)         109,012               -
>>   v7.3-rc1 + this patch (vm.defrag_mode=1)     157,778          +44.7%
>> 
>> Link: https://lore.kernel.org/all/20260403193535.9970-1-dipiets@amazon.it/T/#t [v1]
>> Link: https://lore.kernel.org/linux-mm/20260420161404.642-1-dipiets@amazon.it/T/#u [v2]
>> Link: https://lore.kernel.org/all/20260710143437.12379-1-dipiets@amazon.it/T/#u [v3]
>> Link: https://lore.kernel.org/all/20260904115629.3993331-1-dipiets@amazon.it/T/#u [v4]
>> Link: https://lore.kernel.org/all/20260911142102.2294202-1-dipiets@amazon.it/T/#u [v5]
>> Fixes: 5d8edfb900d5 ("iomap: Copy larger chunks from userspace")
>> Cc: stable@vger.kernel.org
>> Cc: Andrew Morton <akpm@linux-foundation.org>
>> Cc: Vlastimil Babka <vbabka@kernel.org>
>> Cc: David Hildenbrand <david@redhat.com>
>> Cc: Michal Hocko <mhocko@suse.com>
>> Cc: Johannes Weiner <hannes@cmpxchg.org>
>> Cc: Matthew Wilcox <willy@infradead.org>
>> Cc: Christoph Hellwig <hch@lst.de>
>> Cc: Dave Chinner <dgc@kernel.org>
>> Cc: Ritesh Harjani <ritesh.list@gmail.com>
>> Cc: Zi Yan <ziy@nvidia.com>
>> Cc: Dmitry Ilvokhin <d@ilvokhin.com>
>> Cc: linux-mm@kvack.org
>> Cc: linux-fsdevel@vger.kernel.org
>> Cc: linux-xfs@vger.kernel.org
>> Cc: linux-kernel@vger.kernel.org
>> Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
>> Acked-by: Zi Yan <ziy@nvidia.com>
>> Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>
>> Reviewed-by: Christoph Hellwig <hch@lst.de>
>> Signed-off-by: Salvatore Dipietro <dipiets@amazon.it>
>> ---
>>  mm/page_alloc.c | 21 ++++++++++++++++++---
>>  1 file changed, 18 insertions(+), 3 deletions(-)
>> 
>> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
>> index 12fac9084c48..64d09964ca77 100644
>> --- a/mm/page_alloc.c
>> +++ b/mm/page_alloc.c
>> @@ -4784,10 +4784,10 @@ static inline struct page *
>>  __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
>>  						struct alloc_context *ac)
>>  {
>> -	bool can_direct_reclaim = gfp_mask & __GFP_DIRECT_RECLAIM;
>> -	bool can_compact = can_direct_reclaim && gfp_compaction_allowed(gfp_mask);
>> -	bool nofail = gfp_mask & __GFP_NOFAIL;
>>  	const bool costly_order = order > PAGE_ALLOC_COSTLY_ORDER;
>> +	bool can_direct_reclaim;
>> +	bool can_compact;
>> +	bool nofail;
>>  	struct page *page = NULL;
>>  	unsigned int alloc_flags;
>>  	unsigned long did_some_progress;
>> @@ -4802,6 +4802,18 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
>>  	bool can_retry_reserves = true;
>>  	unsigned long alloc_start_time = jiffies;
>>  
>> +	/*
>> +	 * Costly __GFP_NORETRY callers have a cheap fallback, so don't stall
>> +	 * them in reclaim or compaction. __GFP_THISNODE callers are exempt.
>> +	 */
>> +	if (costly_order && (gfp_mask & __GFP_NORETRY) &&
>> +	    !(gfp_mask & __GFP_THISNODE))
>> +		gfp_mask &= ~__GFP_DIRECT_RECLAIM;
>> +
>> +	can_direct_reclaim = gfp_mask & __GFP_DIRECT_RECLAIM;
>> +	can_compact = can_direct_reclaim && gfp_compaction_allowed(gfp_mask);
>> +	nofail = gfp_mask & __GFP_NOFAIL;
>> +
>>  	if (unlikely(nofail)) {
>>  		/*
>>  		 * Also we don't support __GFP_NOFAIL without __GFP_DIRECT_RECLAIM,
> 
> This would trigger a warning if __GFP_NOFAIL and __GFP_NORETRY were ever
> used together, though that does not make sense and I haven't found a case
> where it is used in practice.

Right. But always there is some risk someone does that unintentionally by
trying to turn an allocation with incoming gfp flags (including unexpected
__GFP_NOFAIL) to an opportunistic one first by appending __GFP_NORETRY, etc.

> Aside from either warning for the specific case of these flags being used
> together or adding a comment right here to that effect, I don't think any
> other change is needed, though.

Indeed. I thought we did have such warnings. Also a combination with
__GFP_RETRY_MAYFAIL would make no sense. So we should perhaps add them.

> Another comment about the general approach: TTM pool page allocator does
> use __GFP_NORETRY and __GFP_DIRECT_RECLAIM for high orders and when we
> previously suggested to drop __GFP_DIRECT_RECLAIM to avoid compaction, it
> was frowned upon. In the end, a lot of other changes were made and for the
> relevant cases, this does not seem to change its current behavior, amongst
> other things, because it uses __GFP_THISNODE.
> 
> I did run some TTM GTT allocations with some fragmentation workload and I
> haven't seen much change in the latency for these high order allocations,
> so:
> 
> Tested-by: Thadeu Lima de Souza Cascardo <cascardo@igalia.com>

Thanks!

>> @@ -4918,8 +4930,11 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
>>  		 * Reclaim/compaction cannot run, so defrag_mode's strategy
>>  		 * of enforcing ALLOC_NOFRAGMENT cannot be fulfilled. Allow
>>  		 * fallbacks rather than failing the allocation outright.
>> +		 * Not for __GFP_NORETRY: those have a cheap lower order
>> +		 * fallback, so failing beats fragmenting.
>>  		 */
>>  		if (defrag_mode && (alloc_flags & ALLOC_NOFRAGMENT) &&
>> +		    !(gfp_mask & __GFP_NORETRY) &&
>>  		    (gfp_mask & __GFP_KSWAPD_RECLAIM)) {
>>  			alloc_flags &= ~ALLOC_NOFRAGMENT;
>>  			goto retry;
>> 
>> base-commit: cee9395acd8043be0644b25c34bfa86623f2b935
>> -- 
>> 2.50.1
>> 
>> 
>> 
>> 
>> AMAZON DEVELOPMENT CENTER ITALY SRL, viale Monte Grappa 3/5, 20124 Milano, Italia, Registro delle Imprese di Milano Monza Brianza Lodi REA n. 2504859, Capitale Sociale: 10.000 EUR i.v., Cod. Fisc. e P.IVA 10100050961, Societa con Socio Unico
>> 
>> 
>> 

