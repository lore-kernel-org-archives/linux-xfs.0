Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E353044F570;
	Tue, 22 Sep 2026 12:06:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790078805; cv=none; b=Xdad+dES3xLNF5AUiJuxsjBq0kZY8m/y4Y/KMJaFWAlkVYOLDiw1tWYtTq69oeJ8BxeL0HFiGB1La3Clk3Wf1/qlv/3q51rAHNhmLdhBOUnJ1q10hcSgJJbjNZfJ5uPMYoecWiRwT7Sqlvf19C92aD+YTEKd3SAk8LlCLEWZ+nI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790078805; c=relaxed/simple;
	bh=JbTek8NifptJuhIjthmOlnWrIkdaIEQ9cNEG/llkN14=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hwgv2YL4uCXYU29fE6zdme200ii2DIp/5PZQho6NSQiwvqyQ7wvbWOFHtZy0Mo/ZpYhR5+DEWMrI7DCSpE6Q4+Vz+6fasa3AVcvCUd21/Mt1m/EDRbdViVM0GobLP8deuKw2g76uhjL30JTlhhUiALC4tsc1Sqh0CA5l4NhFteA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LGGg4AAA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LGGg4AAA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2674A1F000FF;
	Tue, 22 Sep 2026 12:06:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790078803;
	bh=MxlDmX+e0b6KB3MhtozDXlgLx/F3M53sleUSkCPy1qI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=LGGg4AAAsAjFT7XGGUb3i++YdPBigXKt+aF0zsZUSNXyCIoK3TGwC+O2xBL7RaF7n
	 kokh7RjEair7AA8ebNERqQJ9dbHbj4SIedSt9G1+ITtzEBWns+AGXAdh85zjhpblZ2
	 MYrylunDpGT9u0f8adSMMDEP9taQjsGslJ/4mxEWkqDSkYfYysREuPf0ly+iqsD05N
	 gVjM/HLTV4gWrPvxkF5jBzrFxj+6cCUdVRK21Wbsx1vP6WESj9I7lVu6/nd0c3fyE2
	 HYbqTlUe1iSizJYw3fmSPg3Bnt+80bNK8gxmBUH8A8JNJprG5MChZ7GRaOsOza8YPQ
	 TOmOyO4+jIaEQ==
Message-ID: <72674485-6ec2-4cb4-a854-b937333cbf97@kernel.org>
Date: Tue, 22 Sep 2026 14:06:34 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] mm: page_alloc: remove ALLOC_NON_BLOCK from
 ALLOC_RESERVES
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Matt Fleming <matt@readmodwrite.com>,
 Salvatore Dipietro <dipiets@amazon.it>, akpm@linux-foundation.org,
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
 <9f415dc7-adad-4161-b20d-7c3173f50ff3@kernel.org>
 <arFBJdYaRx_iJNDA@cmpxchg.org> <arFBr22V60BMmVpl@cmpxchg.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Content-Language: en-US
In-Reply-To: <arFBr22V60BMmVpl@cmpxchg.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 9/21/26 4:39 PM, Johannes Weiner wrote:
> 1ebbb21811b7 ("mm/page_alloc: explicitly define how __GFP_HIGH
> non-blocking allocations accesses reserves") stopped handing out
> reserve access for ALLOC_NON_BLOCK on its own: the extra 25% below the
> min watermark is now only granted on top of ALLOC_MIN_RESERVE. But the
> flag was left in ALLOC_RESERVES, which produces something odd:
> 
> With the ALLOC_RESERVES match, __zone_watermark_unusable_free() doesn't
> subtract the free highatomic pages for them. So in the slowpath, they
> get to consume regular blocks below the min watermark by the number of
> free highatomic pages. The highatomic reserve is capped at 1% of the
> zone, which on any decently sized machine is a multiple of the min
> watermark: GFP_NOWAIT can drain regular memory to zero.
> 
> The user-visible result is brutal hiccups during bursts of GFP_NOWAIT
> allocations under memory pressure. On a 32G box with an anonymous
> working set, swap, and a filled 290M highatomic reserve, a GFP_NOWAIT
> burst drove regular free memory in the 28G Normal zone (min=60M) to
> 28M, 0.8M and 0.6M in three runs. Swapout failed to allocate its swap
> table, reclaim scanned 13M pages to reclaim 200k, page faults stalled
> for tens to hundreds of milliseconds. The machine survives it, but not
> by design: direct reclaimers eventually fail and start unreserving
> highatomic blocks, until the allocation succeeds or the reserve is
> gone and the OOM killer runs. That reserve exists for high-order
> atomic allocations; here it is destroyed to bail out a GFP_NOWAIT
> consumer that was never entitled to the memory.

This suggests to me that a LLM review of 1/2 spotted this issue and also
(or you) constructed a test doing the GFP_NOWAIT bursts to confirm the
impact, but it has not been observed in production? But if it was, can
we make it clear?

> Remove ALLOC_NON_BLOCK from ALLOC_RESERVES. With that, the GFP_NOWAIT
> burst is stopped short at the min watermark. No direct reclaim, no
> stalls, no failed allocations, and the highatomic reserve stays intact
> for the requests it exists for.
> 
> __zone_watermark_ok() is unaffected, since everything it keys on
> ALLOC_NON_BLOCK is already nested under ALLOC_MIN_RESERVE. Update the
> flag comments accordingly: ALLOC_NON_BLOCK just means the caller can't
> block; the reserve math belongs with ALLOC_MIN_RESERVE.
> 
> Fixes: 1ebbb21811b7 ("mm/page_alloc: explicitly define how __GFP_HIGH non-blocking allocations accesses reserves")
> Cc: stable@vger.kernel.org
> Assisted-by: LLM
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

The change itself is fine and we don't need ALLOC_NON_BLOCK in
ALLOC_RESERVES. But I wonder if we should also make the
__zone_watermark_unusable_free() check more precise, by using
may_access_highatomic_reserves() there instead of ALLOC_RESERVES?
Which would mean that the function should however also evaluate
ALLOC_HIGHATOMIC, and restrict the other checks to order=0, to be usable
from both callers.

> ---
>  mm/page_alloc.h | 11 +++++------
>  1 file changed, 5 insertions(+), 6 deletions(-)
> 
> diff --git a/mm/page_alloc.h b/mm/page_alloc.h
> index ad89f83d1dab..c8af79decbd0 100644
> --- a/mm/page_alloc.h
> +++ b/mm/page_alloc.h
> @@ -32,12 +32,11 @@
>  #define ALLOC_OOM		ALLOC_NO_WATERMARKS
>  #endif
>  
> -#define ALLOC_NON_BLOCK		 0x10 /* Caller cannot block. Allow access
> -				       * to 25% of the min watermark or
> -				       * 62.5% if __GFP_HIGH is set.
> -				       */
> +#define ALLOC_NON_BLOCK		 0x10 /* Caller cannot block. */
>  #define ALLOC_MIN_RESERVE	 0x20 /* __GFP_HIGH set. Allow access to 50%
> -				       * of the min watermark.
> +				       * of the min watermark, or 62.5% if
> +				       * the caller cannot block either
> +				       * (ALLOC_NON_BLOCK).
>  				       */
>  #define ALLOC_CPUSET		 0x40 /* check for correct cpuset */
>  #define ALLOC_CMA		 0x80 /* allow allocations from CMA areas */
> @@ -58,7 +57,7 @@
>  #define ALLOC_NO_CODETAG       0x1000
>  
>  /* Flags that allow allocations below the min watermark. */
> -#define ALLOC_RESERVES (ALLOC_NON_BLOCK|ALLOC_MIN_RESERVE|ALLOC_HIGHATOMIC|ALLOC_OOM)
> +#define ALLOC_RESERVES (ALLOC_MIN_RESERVE|ALLOC_HIGHATOMIC|ALLOC_OOM)
>  
>  /* Flags that mean GFP_ATOMIC */
>  #define ALLOC_MASK_ATOMIC (ALLOC_NON_BLOCK|ALLOC_MIN_RESERVE)

