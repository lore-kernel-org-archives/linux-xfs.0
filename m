Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CDF84D0A17;
	Wed, 16 Sep 2026 11:24:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789557891; cv=none; b=aQTvwBwhfPWMxcnlE++t9k/JqT+utSMAeSEkgtcFJ7MmKv4LkbOvBOudesaZ32Hx7pcv5B9B7uAPHJTIl0HbkCoEYx3jWe+qiXCEXskQCXbAT8g76syHOyf6cIBxSHYazHfyDB9TcwMF6t8sUII2NL+g22dTFpVf7Lwvz7gaJF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789557891; c=relaxed/simple;
	bh=RZci0qwO+deyOL1zjEehaH4/1yFnr58F3J6yMrrLkxQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OuNH5e2KZk253mEZTqdMY1I9pA9CZkxkXqXtEugV35UqHGlQxyxYKgjS9DaDkhRNWzAyQ5k/70hwzwzgjSLcgE6JckxlXeA8jImrc8DkvIAyR2KvYsTtngMg1Sq5ZwcKSQRyNgjJBSpP6PZBTDjfEvPu5BgtVQP1yBB7777VEbk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lSY66ISb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lSY66ISb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 880781F00899;
	Wed, 16 Sep 2026 11:24:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789557878;
	bh=9yMRewUVdtk5FTKiyrOjdk+WbBNSVZ/plHkzP6P2SuQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=lSY66ISb3m9U6walw2ED+kaCgM2gABW2AgoPJjdeVg7dafwfXiiS2VY9yNMLoovS0
	 /HCNS6C7dbRdwLV1mezft/EYCTQWtw6Xi2W0ZCbP26gE+1GrfcGaLMTA4/DJvg/n38
	 X/L2iOHwfiwTNOWhnDMCMyh1rNq2RpYqDKDcErBTvZki/edYI8yFEwlyKCn31B4x/k
	 j6xN5+ZIjaHBC0ob6CJz6pWn0+FlGblBUjDWi3ulUKl7e5lIjuwWR2baLBBAH/99MV
	 CbshddnS3zF9W6QG8Nps7bkVMotFH0RLER0n6+Xxw/54ngx0wKejp3dXy08deTuSYr
	 gN0Oz+amFoBEQ==
Message-ID: <8d6a8a63-4adc-458a-b548-a47bf5ff8eb7@kernel.org>
Date: Wed, 16 Sep 2026 13:24:31 +0200
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
To: Johannes Weiner <hannes@cmpxchg.org>,
 Salvatore Dipietro <dipiets@amazon.it>
Cc: akpm@linux-foundation.org, abuehaze@amazon.com, alisaidi@amazon.com,
 blakgeof@amazon.com, brauner@kernel.org, brendan.jackman@linux.dev,
 david@redhat.com, dgc@kernel.org, dipietro.salvatore@gmail.com,
 djwong@kernel.org, hch@infradead.org, hch@lst.de,
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, linux-xfs@vger.kernel.org, mhocko@suse.com,
 ritesh.list@gmail.com, rvvandan@amazon.com, stable@vger.kernel.org,
 surenb@google.com, willy@infradead.org, ziy@nvidia.com
References: <20260905174239.99e31515fabe220aa7d8e6fa@linux-foundation.org>
 <20260910114602.926944-1-dipiets@amazon.it> <aqQlUr-1h07G8JWM@cmpxchg.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <aqQlUr-1h07G8JWM@cmpxchg.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 9/11/26 17:59, Johannes Weiner wrote:
> On Thu, Sep 10, 2026 at 11:46:02AM +0000, Salvatore Dipietro wrote:
>> 
>> On Sat, 05 Sep 2026 17:42:39 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:
>> 
>> > Is there anything particularly unusual about this test case?
>> 
>> It is a stock pgbench simple-update PostgreSQL workload on a large
>> instance (96 vCPUs), using standard PostgreSQL settings and with no huge
>> pages assigned to the database. We deliberately overprovision the
>> pgbench clients: 1024 clients over 96 threads. That keeps enough writers
>> in the buffered write path concurrently to hit the costly-order
>> allocation failure path continuously. The memory fragmentation comes from 
>> page tables: PostgreSQL spawns a new process per client, and those page
>> tables consume ~40% of memory, which significantly limits the page cache
>> and the free memory available.
>> 
>> 
>> > > Results (average of 3 runs, TPS):
>> > >
>> > >   Config                   Avg TPS      % vs Baseline
>> > >   baseline (no patch)       59,408       -
>> > >   With this patch          155,409      +161.6%
>> >
>> > Is this back to pre-5d8edfb900d5 performance?
>> 
>> Yes - fully recovered. Here is the summary, same host and workload
>> throughout, average of 3 runs:
>> 
>>   Config                                        Avg TPS   % vs baseline
>>   AL2023 stock 6.1 kernel                       136,942            n/a
>>   v7.3-rc1 baseline (no patch)                   59,408             -
>>   v7.3-rc1, 5d8edfb900d5 behaviour reverted     151,184        +154.5%
>>   v7.3-rc1 + v4                                 155,409        +161.6%
>> 
>> The 6.1 row predates 5d8edfb900d5 entirely. A different kernel version,
>> so not directly comparable, but it shows the performance this workload
>> used to get on this host.
>> 
>> A literal "git revert 5d8edfb900d5" does not apply to v7.3-rc1 -
>> iomap_write_iter() has been rewritten since - so the reverted row is a
>> one-line behavioural revert, forcing the write loop back to copying at
>> most PAGE_SIZE per iteration:
>> 
>>   -	size_t chunk = mapping_max_folio_size(mapping);
>>   +	size_t chunk = PAGE_SIZE;
>> 
>> which is what the pre-5d8edfb900d5 loop computed. That makes
>> iomap_get_folio() pass no order hint, so the path issues only order-0
>> allocations.
>> 
>> 
>> > AI review asked a few serious-looking questions:
>> > 	https://sashiko.dev/#/patchset/20260904115629.3993331-1-dipiets@amazon.it
>> 
>> Thanks for pointing that out. To address them, we can have something
>> like the patch below. Performance results are still similar to v4. Happy
>> to submit a formal v5 patch with it if you would like.
> 
> The feedback looks misleading to me.

Agreed.

> ALLOC_NON_BLOCKING itself is fine, it usually only means something in
> conjunction with other flags, like __GFP_HIGH.

+1

> The access to
> MIGRATE_HIGHATOMIC that it points out is in itself too generous. This
> seems like a real but separate bug. It will allow GFP_TRANSHUGE_LIGHT
> into the highatomic reserves as well, for example.

I don't follow this part. For ALLOC_HIGHATOMIC you need __GFP_HIGH in
alloc_flags_nonblocking(). So GFP_TRANSHUGE_LIGHT won't get the access, no?

> The rt issue seems made up too. We're talking about costly_order &&
> __GFP_NORETRY allocations. Why would they need access to reserves?

Yep.

And the concern about warning is also moot as __GFP_NORETRY is still needed
and its users virtually always add __GFP_NOWARN as well.

>>   Config                                        Avg TPS   % vs baseline
>>   v7.3-rc1 baseline (no patch)                   59,408             -
>>   v7.3-rc1 + v4                                 155,409        +161.6%
>>   v7.3-rc1 + proposed patch                     161,994        +172.7%
>> 
>> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
>> index 12fac9084c48..be8b0d72a2db 100644
>> --- a/mm/page_alloc.c
>> +++ b/mm/page_alloc.c
>> @@ -4784,10 +4784,22 @@ static inline struct page *
>>  __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
>>  						struct alloc_context *ac)
>>  {
>> -	bool can_direct_reclaim = gfp_mask & __GFP_DIRECT_RECLAIM;
>> +	const bool costly_order = order > PAGE_ALLOC_COSTLY_ORDER;
>> +	/*
>> +	 * Costly __GFP_NORETRY callers have a cheap fallback to a lower order,
>> +	 * so don't stall them in direct reclaim or direct compaction.  Exempt
>> +	 * __GFP_THISNODE (the THP attempt from alloc_pages_mpol() needs direct
>> +	 * compaction) and __GFP_NOFAIL (must not be made to fail).  Don't
>> +	 * clear __GFP_DIRECT_RECLAIM from gfp_mask instead: that would also
>> +	 * change the alloc_flags derived by alloc_flags_slowpath().
>> +	 */
>> +	const bool costly_noretry = costly_order &&
>> +		(gfp_mask & __GFP_NORETRY) &&
>> +		!(gfp_mask & (__GFP_THISNODE | __GFP_NOFAIL));
>> +	bool can_direct_reclaim = !costly_noretry &&
>> +		(gfp_mask & __GFP_DIRECT_RECLAIM);
> 
> IMO this is worse because now there is a disconnect between these
> flags and the gfp mask again. This sets us up for subtle bugs.
> 
> I much preferred v4.

Unless I'm mistaken about that MIGRATE_HIGHATOMIC part, it seems all sashiko
concerns can be dismissed and then indeed v4 is the better version.

