Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04974374E73;
	Fri, 18 Sep 2026 07:05:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789715149; cv=none; b=RoMjnp30gDazEiPMgTu9YSJbFu/OiZlwU243fPTLxopVwjhRENVa9qaHidyY7hy1ZRbEh6j7YOw926rddZAkeW6HU7NNx4E8NrweIpwUor11R5tQ/Xw3rwkYzVgJpWQqhu+ytzsaMf4zTiSUkbksybmZs7nzE48B8Bm5uAlqcuM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789715149; c=relaxed/simple;
	bh=eqyhpPKkU+HJFvUf5lHVFoiGRRhKLmU6oeaFauIKZ1c=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=cxwJGsUo6F7v2k9FA/uxjBZVRjFSpk1+l3kEFbXS/o4wMzZrnzxGa3Z0iNTWn7XFBSxwusVsHEY7SglVExXU8fvScy1ipcCFxA3K7ZV5OkylAfAtTzjhDJ938+GObX0AAF5OxpehytsAqh3WK9FZDWXEFzKLIT398LtbVu3HHSE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MiC+Jiuc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MiC+Jiuc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6089A1F00893;
	Fri, 18 Sep 2026 07:05:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789715147;
	bh=bv1OQczK/O9bvYz2sTOyzcEleUuzrNVzZHEHBlwi0iA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=MiC+JiucBpTELdDbpMK0hfvdId+DoZ/dBnrt3HkHo2tYpvVH1STq+QxuEQZaVnKkw
	 W8xAMMY+uJ+n2gPuebdnyAA9KnJLoXLD61u9eP6IWIP4+m70amWTTy48y7M3jBAhvv
	 HCPS6wgUlXIQjqJmRa0hX9EyaupiaQVqi7Zu1/72kB7ITpTuDihda/oR3jf5FdcGXv
	 FsvxPWiCF1V6fH+VWjtAbGUrUnIQ9eJq9h4t5d36K2kTRzA2aLy+lfvb9sC5ZXFtSf
	 txm9gOvUrgKFzVEq66FlQGSNsEDKFM+S6YZ4KIkx1THzUQvdITpkYR390KOrVT98ww
	 DC1l9tOryfBGw==
Message-ID: <9f415dc7-adad-4161-b20d-7c3173f50ff3@kernel.org>
Date: Fri, 18 Sep 2026 09:05:40 +0200
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
To: Johannes Weiner <hannes@cmpxchg.org>, Matt Fleming <matt@readmodwrite.com>
Cc: Salvatore Dipietro <dipiets@amazon.it>, akpm@linux-foundation.org,
 abuehaze@amazon.com, alisaidi@amazon.com, blakgeof@amazon.com,
 brauner@kernel.org, brendan.jackman@linux.dev, david@redhat.com,
 dgc@kernel.org, dipietro.salvatore@gmail.com, djwong@kernel.org,
 hch@infradead.org, hch@lst.de, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-xfs@vger.kernel.org,
 mhocko@suse.com, ritesh.list@gmail.com, rvvandan@amazon.com,
 stable@vger.kernel.org, surenb@google.com, willy@infradead.org,
 ziy@nvidia.com
References: <20260905174239.99e31515fabe220aa7d8e6fa@linux-foundation.org>
 <20260910114602.926944-1-dipiets@amazon.it> <aqQlUr-1h07G8JWM@cmpxchg.org>
 <8d6a8a63-4adc-458a-b548-a47bf5ff8eb7@kernel.org>
 <aqq8pWI0u1IZNWHT@cmpxchg.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <aqq8pWI0u1IZNWHT@cmpxchg.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 9/16/26 17:58, Johannes Weiner wrote:
> On Wed, Sep 16, 2026 at 01:24:31PM +0200, Vlastimil Babka (SUSE) wrote:
>> On 9/11/26 17:59, Johannes Weiner wrote:
>> > The access to
>> > MIGRATE_HIGHATOMIC that it points out is in itself too generous. This
>> > seems like a real but separate bug. It will allow GFP_TRANSHUGE_LIGHT
>> > into the highatomic reserves as well, for example.
>> 
>> I don't follow this part. For ALLOC_HIGHATOMIC you need __GFP_HIGH in
>> alloc_flags_nonblocking(). So GFP_TRANSHUGE_LIGHT won't get the access, no?
> 
> rmqueue_buddy() has this:
> 
> 			/*
> 			 * If the allocation fails, allow OOM handling and
> 			 * order-0 (atomic) allocs access to HIGHATOMIC
> 			 * reserves as failing now is worse than failing a
> 			 * high-order atomic allocation in the future.
> 			 */
> 			if (!page && (alloc_flags & (ALLOC_OOM|ALLOC_NON_BLOCK)))
> 				page = __rmqueue_smallest(zone, order, MIGRATE_HIGHATOMIC);

Ah right, comes from Matt's 281dd25c1a01 ("mm/page_alloc: let GFP_ATOMIC
order-0 allocs access highatomic reserves")

> It says "atomic", but it's checking only ALLOC_NON_BLOCK, which is
> broader than GFP_ATOMIC. alloc_flags_nonblocking();
> 
> 	if (gfp_mask & __GFP_DIRECT_RECLAIM)
> 		return 0;
> 
> 	if (gfp_mask & __GFP_NOMEMALLOC)
> 		return 0;
> 
> 	alloc_flags |= ALLOC_NON_BLOCK;
> 
> 	if (order > 0 && (gfp_mask & __GFP_HIGH))
> 		alloc_flags |= ALLOC_HIGHATOMIC;
> 
> So this can apply to random !direct_reclaim requests, no?

Yes, and I agree it shouldn't.

> I have to correct myself on GFP_TRANSHUGE_LIGHT because it happens to
> include __GFP_NOMEMALLOC, and so won't actually get ALLOC_NON_BLOCK.

At least there's that.

> But what about random GFP_NOWAIT and & ~__GFP_DIRECT_RECLAIM sites?
> Those explicitly don't get watermark exemptions already, and weren't
> the intent of the rmqueue_buddy() exemption above.
> 
> Something like this?
> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 12fac9084c48..c79cc7aa4dff 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -3246,7 +3246,8 @@ struct page *rmqueue_buddy(struct zone *preferred_zone, struct zone *zone,
>  			 * reserves as failing now is worse than failing a
>  			 * high-order atomic allocation in the future.
>  			 */
> -			if (!page && (alloc_flags & (ALLOC_OOM|ALLOC_NON_BLOCK)))
> +			if (!page && ((alloc_flags & ALLOC_OOM) ||
> +				      ((alloc_flags & ALLOC_MASK_ATOMIC) == ALLOC_MASK_ATOMIC)))
>  				page = __rmqueue_smallest(zone, order, MIGRATE_HIGHATOMIC);
>  
>  			if (!page) {
> diff --git a/mm/page_alloc.h b/mm/page_alloc.h
> index b9259deddb59..11714ddca254 100644
> --- a/mm/page_alloc.h
> +++ b/mm/page_alloc.h
> @@ -60,6 +60,9 @@
>  /* Flags that allow allocations below the min watermark. */
>  #define ALLOC_RESERVES (ALLOC_NON_BLOCK|ALLOC_MIN_RESERVE|ALLOC_HIGHATOMIC|ALLOC_OOM)
>  
> +/* Flag combination from GFP_ATOMIC */
> +#define ALLOC_MASK_ATOMIC (ALLOC_NON_BLOCK|ALLOC_MIN_RESERVE)
> +
>  /*
>   * Structure for holding the mostly immutable allocation parameters passed
>   * between functions involved in allocations, including the alloc_pages*

Should work.

> 
>> Unless I'm mistaken about that MIGRATE_HIGHATOMIC part, it seems all sashiko
>> concerns can be dismissed and then indeed v4 is the better version.
> 
> It looks like a real issue to me, but one that already exists
> independent of Salvatore's change.

But Salvatore's change (v4, not v5 IIUC) will make it worse because
__GFP_DIRECT_RECLAIM + __GFP_NORETRY costly order opportunistic attempts
with fallback will start eating the highatomic reserves too?

In that case the fix for this should probably be part of the same PR to
Linus and be also stable with Fixes: 281dd25c1a01
