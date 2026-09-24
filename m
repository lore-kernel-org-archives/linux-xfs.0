Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 893C13CB2E9;
	Thu, 24 Sep 2026 14:34:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790260453; cv=none; b=Jp4cPnmlG+4AeU3aHlMQIQvr1MFUR2L7pv9Lbnd5jtKDM2levQTn+F6R8e6SArWIYHavNWYkd8YIzMGt/uJBEaQfdIPzwG0upbqchRij4Ws4WfIVGayJjJR87bJG9url61HOsixMFptBDfYz+Kxg3E+YQPdKWqkA6nC9AJjXkys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790260453; c=relaxed/simple;
	bh=7jT32T51qObWY1wqjMDG5dVQft2v5PNq7oRvCSDGF3A=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HNlhlqqMxe1b48tQkME1xu/nCQrn9LNZ3ElrOiYXmd+wg2ds8qEgWV3Wz+d6dff7yTnTAmcdVyg1a1NdKAQUfqe2RrjTV9gQbGFw8PmtclOh/++RNPD0GNi9p+QmelhqAdX4uoThhF7Bo1j9UO2AiQ4/0lu1dIkEG8/nJhLlnmM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fAWWQW+Y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fAWWQW+Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 540A11F00899;
	Thu, 24 Sep 2026 14:34:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790260451;
	bh=5s/G29r5xlQqoidU08e1WfbzuhCV/MEnckaYH46M6N4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=fAWWQW+Y+CK3KEpZnau1N5gWdiMD5xMnDis+H57BJy3MqgvUHH0XsZQk4NWb8zNNk
	 f3SDtdDFKtuMQ5MA0WwSbrS6KAn2N74/Z13FOIFHz5d3nF7ShGg9HI/QvHTWv70K7c
	 KPT+cvyOZ9HYFuABx/SF3GmfHk/ciVcwh9LPb9joqlpBoW2UegkoDDKLO95vgbr3ll
	 FN3hfCKgVv7ucxPdDlyuKuuKPMafYDGmB6Wmlwelp5VgqMqKAgaMF0kEQJHKsAVv2n
	 oFXv3CqbdOGk9GJ52+JsBnl6NedYm4nQUAVFUzLCjLl8P8fTDQUvy+lNvRLn5S8HMY
	 JM/hjbJV4adBA==
Message-ID: <54f42979-fc19-44ff-bd11-cb43f13bcd32@kernel.org>
Date: Thu, 24 Sep 2026 16:34:04 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] mm: page_alloc: do not give all non-blocking requests
 reserve access
Content-Language: en-US
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Matthew Wilcox <willy@infradead.org>, Matt Fleming
 <matt@readmodwrite.com>, Salvatore Dipietro <dipiets@amazon.it>,
 akpm@linux-foundation.org, abuehaze@amazon.com, alisaidi@amazon.com,
 blakgeof@amazon.com, brauner@kernel.org, brendan.jackman@linux.dev,
 david@redhat.com, dgc@kernel.org, dipietro.salvatore@gmail.com,
 djwong@kernel.org, hch@infradead.org, hch@lst.de,
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, linux-xfs@vger.kernel.org, mhocko@suse.com,
 ritesh.list@gmail.com, rvvandan@amazon.com, stable@vger.kernel.org,
 surenb@google.com, ziy@nvidia.com
References: <20260910114602.926944-1-dipiets@amazon.it>
 <aqQlUr-1h07G8JWM@cmpxchg.org>
 <8d6a8a63-4adc-458a-b548-a47bf5ff8eb7@kernel.org>
 <aqq8pWI0u1IZNWHT@cmpxchg.org>
 <9f415dc7-adad-4161-b20d-7c3173f50ff3@kernel.org>
 <arFBJdYaRx_iJNDA@cmpxchg.org> <arFBWvzXPYrKuIYi@cmpxchg.org>
 <arFFKGrpPwtTkoCi@casper.infradead.org> <arFUPOi6gadAvD3E@cmpxchg.org>
 <c4a6d3db-8b57-400d-a377-a7acbf45d3ba@kernel.org>
 <arKI_AwXQxicc_iH@cmpxchg.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <arKI_AwXQxicc_iH@cmpxchg.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 9/22/26 15:56, Johannes Weiner wrote:
> On Tue, Sep 22, 2026 at 01:52:41PM +0200, Vlastimil Babka (SUSE) wrote:
>> 
>> 
>> On 9/21/26 5:58 PM, Johannes Weiner wrote:
>> > On Mon, Sep 21, 2026 at 03:54:32PM +0100, Matthew Wilcox wrote:
>> >> On Mon, Sep 21, 2026 at 10:38:18AM -0400, Johannes Weiner wrote:
>> >>> +++ b/mm/page_alloc.c
>> >>> @@ -3246,7 +3246,9 @@ struct page *rmqueue_buddy(struct zone *preferred_zone, struct zone *zone,
>> >>>  			 * reserves as failing now is worse than failing a
>> >>>  			 * high-order atomic allocation in the future.
>> >>>  			 */
>> >>> -			if (!page && (alloc_flags & (ALLOC_OOM|ALLOC_NON_BLOCK)))
>> >>> +			if (!page &&
>> >>> +			    ((alloc_flags & ALLOC_OOM) ||
>> >>> +			     (alloc_flags & ALLOC_MASK_ATOMIC) == ALLOC_MASK_ATOMIC))
>> >>>  				page = __rmqueue_smallest(zone, order, MIGRATE_HIGHATOMIC);
>> >>
>> >> Would this be slightly neater?
>> >>
>> >> static inline bool may_access_reserves(unsigned int alloc_flags)
>> >> {
>> >> 	if (alloc_flags & ALLOC_OOM)
>> >> 		return true;
>> >> 	if (alloc_flags & (ALLOC_NON_BLOCK | ALLOC_MIN_RESERVE)) ==
>> >> 	    (ALLOC_NON_BLOCK | ALLOC_MIN_RESERVE)
>> >> 		return true;
>> >> 	return false;
>> >> }
>> 
>> I think it should be named e.g. may_access_highatomic_reserves() as
>> may_access_reserves() is rather generic and would seem to imply an
>> ALLOC_RESERVES match (see 2/2).
> 
> Note that it doesn't actually check ALLOC_HIGHATOMIC itself. It's just
> the hail-mary AFTER trying the primary migratetype. So the name still
> doesn't look right, and rmqueue_buddy() reads kind of awkardly:
> 
> if (alloc_flags & ALLOC_HIGHATOMIC)
> 	page = __rmqueue_smallest(..., MIGRATE_HIGHATOMIC);
> if (!page) {
> 	page = __rmqueue(..., migratetype, ...);
> 
> 	/* Allow OOM and order-0 atomic */
> 	if (!page && may_access_highatomic_reserve())
> 		page = __rmqueue_smallest(..., MIGRATE_HIGHATOMIC);
> }
> 
> It would have to be may_access_highatomic_reserve_as_last_resort() or
> something?
> 
> Hm, this is a mess. Looking closer, I think there is more breakage,
> name aside.
> 
> You suggest in 2/2 to use the same helper in unusable_free. But I
> think that's broken. My 2/2 does not look like the full fix either:
> 
> The fundamental problem is including the highatomics reserves in the
> watermark check for any allocations that first prefer a different
> migratetype - "regular memory". Any time we do this, we allow those
> allocations to draw down regular memory to 0 based on the presence of
> the highatomic reserves. And when reclaim, swap etc. come along there
> is nothing left for them. ALLOC_NO_WATERMARKS e.g. permits ignoring
> the wmarks but doesn't grant access to highatomic *freelists*.

Hmm yes, we'd have to be nuanced about which freelists we allow allocating
from depending on their particular watermarks. I.e. if we passed the
watermark checks only thanks to zone->nr_free_highatomic, we would have to
try those first. I assume it would be complicated and perhaps with perf
impact. But maybe if we managed to keep this complexity outside of fastpath
attempts?

The CMA handling had a similar issue and now we have that balancing
heuristic since 16867664936e ("mm,page_alloc,cma: conditionally prefer cma
pageblocks for movable allocations")

> So I think there are two choices:
> 
> (1) Let *everything* with some sort of reserve access fall back to
> highatomic, or
> 
> (2) Only allow ALLOC_HIGHATOMIC to include highatomic reserves in
> their watermarks check. With limited opportunistic fallback to the
> highatomics *freelists*, like the order-0 atomics above.
> 
> My intuition is that (1) might weaken the highatomic reserves to the
> point of uselessness, and we should probably go with (2):

I think the goal of commit 281dd25c1a01 ("mm/page_alloc: let GFP_ATOMIC
order-0 allocs access highatomic reserves") would be defeated with (2). The
order-0 atomic fallback to MIGRATE_HIGHATOMIC freelists would be there, but
the watermark check would never let such allocation through anymore, if
there wasn't a free page on the regular freelists? So it would become (some
races aside maybe) a dead code?

I guess your current patches are a compromise that can work, as patch 2/2
improves the current worse-than-(1) state to exclude the plain non-block
allocations.

> watermarks:
> if (alloc_flags & ALLOC_HIGHATOMIC)
> 	unusable_free += zone->nr_free_highatomic
> 
> freelists:
> if (alloc_flags & ALLOC_HIGHATOMIC)
> 	page = __rmqueue_smallest(..., MIGRATE_HIGHATOMIC);
> if (!page) {
> 	page = __rmqueue(..., migratetype, ...);
> 	/* Opportunistic fallback for order-0 atomics */
> 	if (!page && opportunistic_highatomic_fallback())
> 		page = __rmqueue_smallest(..., MIGRATE_HIGHATOMIC);
> }
> 
>> > I tend to be hesitant with single-use abstractions, but no objection
>> > if people think this is better.
>> 
>> True but single-use ALLOC_MASK_ATOMIC is also not that great, and the
>> usage makes the code hard to decipher. And see my reply to 2/2.
> 
> There is one small upside, which is that it pairs with the
> ALLOC_HIGHATOMIC check that precedes it. The comment says "order-0
> atomics" get a hail mary, but there is no order check. That order-0
> comes out of the sequence of events here: we first check highatomic,
> which is order > 0 && atomic. If that, and the native type, fail, we
> do the hail mary for atomic, which must be by definition order-0.
> 
> If you abstract that privilege into a generic "can access highatomic
> reserves" without an order check, it tempts refactors that cause bugs
> like the above.

Ack.
