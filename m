Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18F96479873;
	Tue, 22 Sep 2026 11:52:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790077972; cv=none; b=Fm3czwL2Az9li/rRieDCuSR7CU40dnAA4MZVbHxRB0ekEAONDubkij3/D/ah2fD2hYaj/TBYmLAmrr3slwHziSDeoVZgCP2W90RCk11hJY91BYOio4o0JV4WRIjAfEeTVPpkSbIkrtGNQ74iK+eNPmuJykgpwjdQ3gRSUAypaOE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790077972; c=relaxed/simple;
	bh=ITl+A7JNqZMLvnrrGDwMZ/D4b9HeuqMCXw/w8ZB9mmM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WbUU5XCmpIQC4K1p/gpYJMsoe3XGCHOB4NzsiCcQMZhczKUpygCPviBzyoe4Mki5Da4S0P5RghAJk4rOxJRq5M+gwoPbtppCafQP4zJN8ymi88pJ6yzG7pUzXwMjvNSV+DzLBW0ZUb8UF1J0JDdJ2Era/XgVx6qKNwK4Lyalyk4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HY5ld3qY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HY5ld3qY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEE0E1F00899;
	Tue, 22 Sep 2026 11:52:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790077970;
	bh=FyG4SaTJjRm1vWtLZjh7+Uoyc+0fCOtZ94HDYATcA1Y=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=HY5ld3qY+AFaZntw9W7jL9IulMrRT+EHC0706/1iQYw2hgBdp6Gu0koETl9EGGl8O
	 2qifQbo8NQgXd4oXO5U3gFNoNbMN17gAF0IO7i4MU8tuAuYQ7Ading9rt11bQkC6Z+
	 +Cn1TPZZpmE7xk3ujyvNWNEVgnKXe9/H8TicjMDD26gloUM2NQojLBIJchB8ZTulkt
	 lxV7JW/n+4gMhroRxFq78d4bBERVqufMBRGsQ3yjJmI2uTuwP58hkpOgd6N4gCkC+c
	 CoO0j0z05OlKiuUkIvBTlGsrH7e1rd9tgyksnOLCbFjOcqKaorK2HiCNg9Suj/4Zgd
	 4kW6ppeskt0Jw==
Message-ID: <c4a6d3db-8b57-400d-a377-a7acbf45d3ba@kernel.org>
Date: Tue, 22 Sep 2026 13:52:41 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] mm: page_alloc: do not give all non-blocking requests
 reserve access
To: Johannes Weiner <hannes@cmpxchg.org>, Matthew Wilcox <willy@infradead.org>
Cc: Matt Fleming <matt@readmodwrite.com>,
 Salvatore Dipietro <dipiets@amazon.it>, akpm@linux-foundation.org,
 abuehaze@amazon.com, alisaidi@amazon.com, blakgeof@amazon.com,
 brauner@kernel.org, brendan.jackman@linux.dev, david@redhat.com,
 dgc@kernel.org, dipietro.salvatore@gmail.com, djwong@kernel.org,
 hch@infradead.org, hch@lst.de, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-xfs@vger.kernel.org,
 mhocko@suse.com, ritesh.list@gmail.com, rvvandan@amazon.com,
 stable@vger.kernel.org, surenb@google.com, ziy@nvidia.com
References: <20260905174239.99e31515fabe220aa7d8e6fa@linux-foundation.org>
 <20260910114602.926944-1-dipiets@amazon.it> <aqQlUr-1h07G8JWM@cmpxchg.org>
 <8d6a8a63-4adc-458a-b548-a47bf5ff8eb7@kernel.org>
 <aqq8pWI0u1IZNWHT@cmpxchg.org>
 <9f415dc7-adad-4161-b20d-7c3173f50ff3@kernel.org>
 <arFBJdYaRx_iJNDA@cmpxchg.org> <arFBWvzXPYrKuIYi@cmpxchg.org>
 <arFFKGrpPwtTkoCi@casper.infradead.org> <arFUPOi6gadAvD3E@cmpxchg.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Content-Language: en-US
In-Reply-To: <arFUPOi6gadAvD3E@cmpxchg.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 9/21/26 5:58 PM, Johannes Weiner wrote:
> On Mon, Sep 21, 2026 at 03:54:32PM +0100, Matthew Wilcox wrote:
>> On Mon, Sep 21, 2026 at 10:38:18AM -0400, Johannes Weiner wrote:
>>> +++ b/mm/page_alloc.c
>>> @@ -3246,7 +3246,9 @@ struct page *rmqueue_buddy(struct zone *preferred_zone, struct zone *zone,
>>>  			 * reserves as failing now is worse than failing a
>>>  			 * high-order atomic allocation in the future.
>>>  			 */
>>> -			if (!page && (alloc_flags & (ALLOC_OOM|ALLOC_NON_BLOCK)))
>>> +			if (!page &&
>>> +			    ((alloc_flags & ALLOC_OOM) ||
>>> +			     (alloc_flags & ALLOC_MASK_ATOMIC) == ALLOC_MASK_ATOMIC))
>>>  				page = __rmqueue_smallest(zone, order, MIGRATE_HIGHATOMIC);
>>
>> Would this be slightly neater?
>>
>> static inline bool may_access_reserves(unsigned int alloc_flags)
>> {
>> 	if (alloc_flags & ALLOC_OOM)
>> 		return true;
>> 	if (alloc_flags & (ALLOC_NON_BLOCK | ALLOC_MIN_RESERVE)) ==
>> 	    (ALLOC_NON_BLOCK | ALLOC_MIN_RESERVE)
>> 		return true;
>> 	return false;
>> }

I think it should be named e.g. may_access_highatomic_reserves() as
may_access_reserves() is rather generic and would seem to imply an
ALLOC_RESERVES match (see 2/2).

> 
> I tend to be hesitant with single-use abstractions, but no objection
> if people think this is better.

True but single-use ALLOC_MASK_ATOMIC is also not that great, and the
usage makes the code hard to decipher. And see my reply to 2/2.
