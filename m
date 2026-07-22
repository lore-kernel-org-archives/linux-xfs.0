Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B51CB1A6806;
	Wed, 22 Jul 2026 12:35:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784723758; cv=none; b=jg0pXiX1jvzSRcg62jtTKY77w/UiFHLhBwcznwiuiPw7K4Ygz4lhCvF9nDffJcNKhFjKo1v0iVRMWw0hpa0eYR2B0sMx7PAd4CvOZgH34lb6oD/yl1ygxhcsEseQvGzhleuQaOJVLDcXYz9kBVxHGyimiMfg3UiSKXWwBM3Uybg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784723758; c=relaxed/simple;
	bh=jGMB6iE9lxJe5nKtxoXNDfrLRI4gR7M3ptjh6wD6/WI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ayLc+oGGCXmHSIxirEdTDXtqoxf3l1lxLfNqju/5ZF5XX6cWMnZ97QAmVNITCv1up7ShQuI+JgcKkCfHGl9QGlHJyKgdOoIx+gY82QTVICL8BrTg64LLd7eq5gmRR8jlXxIzHQvbiHCPqAZLMPmH8KEH24quz+BBjxPFov/zv/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HyIzudcH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HyIzudcH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 003651F000E9;
	Wed, 22 Jul 2026 12:35:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784723757;
	bh=2Jd1GANGwM+PXpSKQ+CRzq/E6/EDkcfhb0HgkIh9hJw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=HyIzudcHgwOZMnwvnVThzTbiSoYQgWKiZ7BSA5Nn93yO5ZwK9lei72TD5EsIyvErW
	 IBdApPWF/AFiQzqCq6bhBEkYP7OBWar0qnqBy6tDn0UVNS/UQDyr4Tr49g9ife1kGG
	 PjgiL6sCmL5DZQR2/qRy3V6BSx7RPXHJ9QG9Tsm6etiWSMv+PcWkqBXCseFJR0wKjC
	 2EiLaTBxgsBcsTcEPY6IrLBGKcD5HpS4iTaK+Ep2QcVcZ/xQT6/7WZKjkyW0RbAhX4
	 2QTChyiE4YyE/kBFyhpYK/tppcL5nZQpL7EuRWN9qfuuxq3FtATsfFiTdrsAKf0uIE
	 phOj7bGLdPLfQ==
Message-ID: <7ddb704c-76a9-4071-8969-06fa1403eb07@kernel.org>
Date: Wed, 22 Jul 2026 14:35:51 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] mm/page_alloc: avoid direct compaction for costly
 __GFP_NORETRY allocations
Content-Language: en-US
To: Salvatore Dipietro <dipiets@amazon.it>, hannes@cmpxchg.org,
 willy@infradead.org
Cc: abuehaze@amazon.com, akpm@linux-foundation.org, alisaidi@amazon.com,
 blakgeof@amazon.com, brauner@kernel.org, dgc@kernel.org,
 dipietro.salvatore@gmail.com, djwong@kernel.org, hch@infradead.org,
 jackmanb@google.com, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-xfs@vger.kernel.org,
 mhocko@suse.com, ritesh.list@gmail.com, stable@vger.kernel.org,
 surenb@google.com, ziy@nvidia.com
References: <alEz4Chf7Ibyg-ZG@casper.infradead.org>
 <20260714120204.542300-1-dipiets@amazon.it>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20260714120204.542300-1-dipiets@amazon.it>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 7/14/26 14:02, Salvatore Dipietro wrote:
> 
> Hi Johannes, Matthew,
> 
> Thank you both for the alternative proposals. I've tested both
> approaches on the same test environment used for v3.
> 
> Results (4 runs each):
> 
>   Config                   Avg TPS      % vs Baseline
>   --------------------------------------------------------
>   baseline (no patch)       70,735       -
>   Johannes' approach       156,908      +121.8%
>   Matthew's approach        70,145       -0.8% (within noise)
> 
> 
> Johannes' approach (clearing __GFP_DIRECT_RECLAIM early in the
> slowpath for costly __GFP_NORETRY) delivers the same ~2.2x speedup
> as v3, as expected - it prevents the entire direct reclaim and
> compaction machinery from running for these opportunistic allocations.

AFAICS both your v3 and the implemented Johannes' suggestion effectively
make all the compact_first logic dead code - at least for the intended THP
use case based on costly_order. It will only continue to do something for
the non-movable order>0  case. So that's a significant change which will not
show up in your results, but might affect other workloads (I'd expect mainly
by having fewer THPs).

> Matthew's filemap.c approach does not help in this workload.  The
> reason is that the first allocation attempt at max order still carries
> __GFP_DIRECT_RECLAIM and enters the slowpath with direct compaction
> enabled.  The __GFP_DIRECT_RECLAIM clearing only takes effect for 
> subsequent lower-order attempts in the fallback loop, but the costly 
> compaction has already executed on the first try.
> 
> Let me know if you have any other variant you want me to test, 
> or if I should prepare a v4 based on Johannes' suggestion.
> 
> This is what I tested for Johannes' approach:
> 
> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index a63733dac659..6e960c969e67 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -4733,10 +4733,10 @@ static inline struct page *
>  __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
>  					struct alloc_context *ac)
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
> @@ -4751,6 +4751,20 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
>  	bool can_retry_reserves = true;
>  	unsigned long alloc_start_time = jiffies;
>  
> +	/*
> +	 * Costly __GFP_NORETRY allocations are opportunistic: the caller
> +	 * can fall back to smaller orders.  Don't stall on direct reclaim
> +	 * or compaction; clearing __GFP_DIRECT_RECLAIM makes the entire
> +	 * slowpath treat this as a non-blocking request.  kswapd will wake
> +	 * kcompactd as needed for background defragmentation.
> +	 */
> +	if (costly_order && (gfp_mask & __GFP_NORETRY))
> +		gfp_mask &= ~__GFP_DIRECT_RECLAIM;
> +
> +	can_direct_reclaim = gfp_mask & __GFP_DIRECT_RECLAIM;
> +	can_compact = can_direct_reclaim && gfp_compaction_allowed(gfp_mask);
> +	nofail = gfp_mask & __GFP_NOFAIL;
> +
>  	if (unlikely(nofail)) {
>  		/*
>  		 * Also we don't support __GFP_NOFAIL without __GFP_DIRECT_RECLAIM,
> 
> 
> Thanks,
> Salvatore
> 
> 
> 
> 
> 
> AMAZON DEVELOPMENT CENTER ITALY SRL, viale Monte Grappa 3/5, 20124 Milano, Italia, Registro delle Imprese di Milano Monza Brianza Lodi REA n. 2504859, Capitale Sociale: 10.000 EUR i.v., Cod. Fisc. e P.IVA 10100050961, Societa con Socio Unico
> 
> 
> 

