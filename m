Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFBC249A3C3;
	Mon, 21 Sep 2026 09:35:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789983351; cv=none; b=jI1eIQ49eBFMehwTF/n7KRmsGV9JNT45yeS+CTkEt/RZodmfNX0kFHAgRCaJ+jIacmCHlZ4isWfbbgk1v8D9YdmnVKB5F9+9u3EdMjfvansR85SJxZFdDePX3scOLz+YdStRDOGfAODqfLW6elmGGceFGD7IVQNxny4OCNtQ3eY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789983351; c=relaxed/simple;
	bh=4N1G44tpWAR4hmfnoY0hydyIPIQlr/hbuUILtJkT6BQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mBJj8Q4/T4ylSzLFp+Bp84lncWzPFTz3KEXd20ShvAnybEGtj9PSTh/qFxrCTQlH5t0STVpwbV7HPB6vaeencUF9oxFmPzStKdDyk4wqYxmG+eTaHELJEHFxizR3t2AozvHjtD6kkYRcmtPV35mLDqM9g+8mg24kxXyJBGleWLY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mW/ciwfo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mW/ciwfo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C8F91F00898;
	Mon, 21 Sep 2026 09:35:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789983349;
	bh=vB6u7hTafA7/3xCUaJmo0nI+NPov+j5mxQHYBu1u2js=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=mW/ciwfoGLhjzMJByNGdweG+U3lhBfjpJfFRxw3fuUVWAHoXAWab+F+wWo6W8TUPA
	 oPZqFSqAc1sfBg758UByY0v43uhFNg5YpP174+lUh0067wc9rBeepQGGoieBUIfPfG
	 wbLXX8Tgt9LjF1AnWKsnTy/MuOWoNQvd56pz5cXhi+welfgIpXeDXF7bgKWC6w/G7Y
	 W9SMLmP8InpfKddJ1hukjOJatG0Qo9VnSTh1nCLHMTG29ut9beEWQXehPILBuu+Bm5
	 HCGwHUkV/5BsUo0d6dU53AsXKU70e57ifNK1RWzwCmIN4UUEOPvqS0MqyRmg6qylac
	 rDNiqGvUnuw7Q==
Message-ID: <6c94405a-48e4-4842-a096-e2fbbbaa862f@kernel.org>
Date: Mon, 21 Sep 2026 11:35:42 +0200
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
To: Matthew Wilcox <willy@infradead.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
 Salvatore Dipietro <dipiets@amazon.it>, abuehaze@amazon.com,
 alisaidi@amazon.com, blakgeof@amazon.com, brauner@kernel.org,
 brendan.jackman@linux.dev, david@redhat.com, dgc@kernel.org,
 dipietro.salvatore@gmail.com, djwong@kernel.org, hch@infradead.org,
 hch@lst.de, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, linux-xfs@vger.kernel.org, mhocko@suse.com,
 ritesh.list@gmail.com, rvvandan@amazon.com, stable@vger.kernel.org,
 surenb@google.com, ziy@nvidia.com
References: <20260905174239.99e31515fabe220aa7d8e6fa@linux-foundation.org>
 <20260910114602.926944-1-dipiets@amazon.it> <aqQlUr-1h07G8JWM@cmpxchg.org>
 <8d6a8a63-4adc-458a-b548-a47bf5ff8eb7@kernel.org>
 <aqq8pWI0u1IZNWHT@cmpxchg.org>
 <20260916153426.3265e2e152cebb6a8d66373d@linux-foundation.org>
 <20260916153540.9a3fb449f5b3fd481ca1b544@linux-foundation.org>
 <aq4L29SBCYwvKrw2@casper.infradead.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <aq4L29SBCYwvKrw2@casper.infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 9/19/26 06:13, Matthew Wilcox wrote:
> On Wed, Sep 16, 2026 at 03:35:40PM -0700, Andrew Morton wrote:
>> From: Salvatore Dipietro <dipiets@amazon.it>
>> Subject: mm/page_alloc: avoid direct compaction for costly __GFP_NORETRY allocations
>> Date: Fri, 4 Sep 2026 11:56:28 +0000
>> 
>> Commit 5d8edfb900d5 ("iomap: Copy larger chunks from userspace")
>> introduced high-order folio allocations in the iomap buffered write path. 
>> When memory is fragmented, each failed costly-order allocation enters
>> __alloc_pages_slowpath() which runs direct compaction and
>> drain_all_pages(), causing a 0.38x throughput drop on PostgreSQL pgbench
>> (simple-update) with 1024 clients on a 96-vCPU arm64 system.
>> 
>> The root issue is that direct compaction is too expensive for hot
>> allocation paths that have fallbacks to smaller allocations. 
>> __filemap_get_folio_mpol() already marks higher-order allocations with
>> __GFP_NORETRY | __GFP_NOWARN, signalling that the caller can handle
>> failure.  However, the page allocator still attempts full direct
>> compaction for costly orders with __GFP_NORETRY, which is unnecessarily
>> aggressive when the caller will simply retry at a lower order.
>> 
>> For costly-order allocations with __GFP_NORETRY, clear
>> __GFP_DIRECT_RECLAIM at the very start of the slowpath, before
>> can_direct_reclaim, can_compact and the nofail checks are evaluated.  This
>> makes the entire slowpath treat the request as non-blocking: no direct
>> reclaim, no direct compaction and no drain_all_pages() IPI across every
>> CPU.  kswapd (and in turn kcompactd) is still woken further down for
>> background defragmentation, so compaction keeps working for long-term
>> system health while being removed from the latency-critical direct
>> allocation path.
>> 
>> Allocations that also request __GFP_THISNODE are exempted.  That flag
>> pairing identifies the local-node-first THP attempt issued by
>> alloc_pages_mpol() (mempolicy.c), which relies on direct compaction to
>> form transparent huge pages.
> 
> This patch is still piling hack on hack.  We haven't made a serious
> effort to understand what's going on, we're just adjusting flags until
> things stop sucking.
> 
> What we know:
>  - Doing compaction every time (which is what we currently do)
>    performs badly
>  - Doing compaction once at the requested large size and then not
>    again until the smallest size also performs badly.  So it's not
>    that we're doing too much compaction, it's that we're doing
>    compaction at all.

The very first version [1] mentions the associated drain_all_pages(),
interestingly.

> But we don't know why compaction is performing badly.  For example,
> we could specify MIGRATE_ASYNC or MIGRATE_SYNC_LIGHT if __GFP_NORETRY
> is set.  Just as a reminder, here's how __GFP_NORETRY is documented:

That already happens (for costly orders) in __alloc_pages_slowpath() where
it sets INIT_COMPACT_PRIORITY.

>  * %__GFP_NORETRY: The VM implementation will try only very lightweight
>  * memory direct reclaim to get some memory under memory pressure (thus
>  * it can sleep). It will avoid disruptive actions like OOM killer. The
>  * caller must handle the failure which is quite likely to happen under
>  * heavy memory pressure. The flag is suitable when failure can easily be
>  * handled at small cost, such as reduced throughput.
> 
> So the callers aren't doing anything unreasonable when they say
> __GFP_NORETRY.  It's the page allocator (and apparently the compaction
> side of it) that's not living up to the documented contract.

Note that all these different versions of this patch mention compaction, but
implement a removal of __GFP_DIRECT_RECLAIM, thus suppressing both reclaim
and compaction, in response to __GFP_NORETRY. Thus turning this effectively
to a GFP_NOWAIT allocation. So that's also a violation of the contract, no?

In [1] thread and also later on v2 thread by you [2] it was proposed to make
the caller itself do this downgrade to GFP_NOWAIT. But Christoph and Dave
didn't like that approach (that was conditional to costly order, I don't
think yours had a response), which is understandable for the costly-order
case, but for your case it makes sense that if you don't want any
reclaim+compaction, you tell the allocator GFP_NOWAIT and not __GFP_NORETRY.

> So that's one approach which has not, as far as I can tell, been
> investigated.
> 
> The other thing that icks me about this patch is how complex the
> condition is:
> 
>> +	/*
>> +	 * Costly __GFP_NORETRY callers have a cheap fallback, so don't stall
>> +	 * them in reclaim or compaction. __GFP_THISNODE callers are exempt.
>> +	 */
>> +	if (costly_order && (gfp_mask & __GFP_NORETRY) &&
>> +	    !(gfp_mask & __GFP_THISNODE))
>> +		gfp_mask &= ~__GFP_DIRECT_RECLAIM;
> 
> So basically we're saying that __GFP_NORETRY means don't do compaction
> unless __GFP_THISNODE is set, which is just special pleading.  Surely
> the right answer is to remove __GFP_NORETRY from the one caller which
> needs __GFP_THISNODE?
> 
> 
> A slightly unrelated critique of this patch is that it's far too
> complicated for what it does.  We could achieve the same thing by doing:
> 
>  static inline bool gfp_compaction_allowed(gfp_t gfp_mask)
>  {
> -       return IS_ENABLED(CONFIG_COMPACTION) && (gfp_mask & __GFP_IO);
> +       return IS_ENABLED(CONFIG_COMPACTION) && (gfp_mask & __GFP_IO) &&
> +               (!(gfp_mask & __GFP_NORETRY) || (gfp_mask & __GFP_THISNODE));
>  }
> 
> 
> Something I've been noodling on the past day or so is cleaning up the
> GFP flags for "how hard to reclaim".  We currently have five
> possibilities encoded in four bits:
> 
> 1. No direct reclaim (__GFP_DIRECT_RECLAIM clear)
> 2. Light reclaim (__GFP_DIRECT_RECLAIM | __GFP_NORETRY)
> 3. Normal reclaim (__GFP_DIRECT_RECLAIM)
> 4. Extra reclaim (__GFP_DIRECT_RECLAIM | ___GFP_RETRY_MAYFAIL)
> 5. Reclaim forever (__GFP_DIRECT_RECLAIM | __GFP_NOFAIL)
> 
> Clearly we can save ourselves a GFP flag bit by encoding those five
> options into three bits.  Some of the code that manipulates "how hard to
> reclaim" will need to be adjusted, but it shouldn't be that many places
> to change.
> 
> If we do that, we can insert more options into the mix if they're really
> needed.  Like we could have:
> 
> 0 - No direct reclaim
> 1 - Light reclaim, no compaction
> 2 - Light reclaim with compaction
> 3 - Normal reclaim
> 4 - Extra reclaim
> 5 - Reclaim forever

There's also still (for better or worse) the THP special case of light
compaction with no reclaim.
And the long-standing principle (maybe cargo cult? who knows) that for
non-costly-order allocations (with fallback) the tradeoff of e.g. 2 is more
favorable than 0. But we don't want the callers to have to change flags
depending on the order. So it would have to be a distinct option?

> and we'd still have two extra states in case we need to add more
> flavours.

[1] https://lore.kernel.org/all/20260403193535.9970-1-dipiets@amazon.it/
[2] https://lore.kernel.org/all/alEz4Chf7Ibyg-ZG@casper.infradead.org/
