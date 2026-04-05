Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 434D77081E;
	Sun,  5 Apr 2026 22:44:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775429045; cv=none; b=qBk1ohbQVRFvqE2EOpGX4rWrAGInVS/8fB/tjptJfy20CvQmLLlQ8hsuYQr07HkiDS+RO9GlXp6wbD4ZAyl8v/LtABBozxQb/9hKbNzOp99W7Bv75p8WvbkH2k1tc06yS187VOjRAeICouWF/gTy0KG5cNnPLNJ2Laa08lXGN9E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775429045; c=relaxed/simple;
	bh=NeUwPmIh/iiZF5hPUgOWlk/Y1+aylRDQjB+lzqom0ls=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MeoDBSTUes7Yk63Bhk0aRKqnpib3IKZrKbOpb/8O3/ZP4Z+xfJAOjmrnOakBN3KrrWUrVcpdfN5e+kxAuDIFstXNiTcJOID5+NxPU7thjXtjQzS3mND4H1jyB7h9Di0aAb7NmC/wyAaKQgepi+E87J/Ii+qrOGSo0AuDebyyRPQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=epBahzGU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="epBahzGU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7A8FC116C6;
	Sun,  5 Apr 2026 22:44:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775429044;
	bh=NeUwPmIh/iiZF5hPUgOWlk/Y1+aylRDQjB+lzqom0ls=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=epBahzGUGkVezEazHJhauPo2gCicTM4PachMhmcB+2eBb6LL5p/g/8DIyvxU1frC5
	 bv1ATFsCGxADzwgeeq1u4sSYMkyjj2DMic1uQx2epQfgoPr3x1FccL/AbRW8rh0dQ4
	 eg8cRb7g1fhkX5OpPp5+ptYhIjZ/HLFgFWjfWQVEpydcNA7rg/ql9DIgzrpFdm2bcF
	 Cgxi059rlM8z/GSO2K2Q9wpbZKwtfNy1vtdjzw1Be7zvuEE6+UaW5AM7qzHLSLRFII
	 4vs6yzszAOoY5xdyF8mdN5mqjXcTG4BTREBYzUiUvpGrk3vW6deNcunYN/P2s8lFYR
	 +L5Lgwl/2+ruQ==
Date: Mon, 6 Apr 2026 08:43:57 +1000
From: Dave Chinner <dgc@kernel.org>
To: Salvatore Dipietro <dipiets@amazon.it>
Cc: linux-kernel@vger.kernel.org, alisaidi@amazon.com, blakgeof@amazon.com,
	abuehaze@amazon.de, dipietro.salvatore@gmail.com,
	willy@infradead.org, stable@vger.kernel.org,
	Christian Brauner <brauner@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 1/1] iomap: avoid compaction for costly folio order
 allocation
Message-ID: <adLlrSZ5oRAa_Hfd@dread>
References: <20260403193535.9970-1-dipiets@amazon.it>
 <20260403193535.9970-2-dipiets@amazon.it>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260403193535.9970-2-dipiets@amazon.it>

On Fri, Apr 03, 2026 at 07:35:34PM +0000, Salvatore Dipietro wrote:
> Commit 5d8edfb900d5 ("iomap: Copy larger chunks from userspace")
> introduced high-order folio allocations in the buffered write
> path. When memory is fragmented, each failed allocation triggers
> compaction and drain_all_pages() via __alloc_pages_slowpath(),
> causing a 0.75x throughput drop on pgbench (simple-update) with 
> 1024 clients on a 96-vCPU arm64 system.
> 
> Strip __GFP_DIRECT_RECLAIM from folio allocations in
> iomap_get_folio() when the order exceeds PAGE_ALLOC_COSTLY_ORDER,
> making them purely opportunistic.
> 
> Fixes: 5d8edfb900d5 ("iomap: Copy larger chunks from userspace")
> Cc: stable@vger.kernel.org
> Signed-off-by: Salvatore Dipietro <dipiets@amazon.it>
> ---
>  fs/iomap/buffered-io.c | 15 ++++++++++++++-
>  1 file changed, 14 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
> index 92a831cf4bf1..cb843d54b4d9 100644
> --- a/fs/iomap/buffered-io.c
> +++ b/fs/iomap/buffered-io.c
> @@ -715,6 +715,7 @@ EXPORT_SYMBOL_GPL(iomap_is_partially_uptodate);
>  struct folio *iomap_get_folio(struct iomap_iter *iter, loff_t pos, size_t len)
>  {
>  	fgf_t fgp = FGP_WRITEBEGIN | FGP_NOFS;
> +	gfp_t gfp;
>  
>  	if (iter->flags & IOMAP_NOWAIT)
>  		fgp |= FGP_NOWAIT;
> @@ -722,8 +723,20 @@ struct folio *iomap_get_folio(struct iomap_iter *iter, loff_t pos, size_t len)
>  		fgp |= FGP_DONTCACHE;
>  	fgp |= fgf_set_order(len);
>  
> +	gfp = mapping_gfp_mask(iter->inode->i_mapping);
> +
> +	/*
> +	 * If the folio order hint exceeds PAGE_ALLOC_COSTLY_ORDER,
> +	 * strip __GFP_DIRECT_RECLAIM to make the allocation purely
> +	 * opportunistic.  This avoids compaction + drain_all_pages()
> +	 * in __alloc_pages_slowpath() that devastate throughput
> +	 * on large systems during buffered writes.
> +	 */
> +	if (FGF_GET_ORDER(fgp) > PAGE_ALLOC_COSTLY_ORDER)
> +		gfp &= ~__GFP_DIRECT_RECLAIM;

Adding these "gfp &= ~__GFP_DIRECT_RECLAIM" hacks everywhere
we need to do high order folio allocation is getting out of hand.

Compaction improves long term system performance, so we don't really
just want to turn it off whenever we have demand for high order
folios.

We should be doing is getting rid of compaction out of the direct
reclaim path - it is -clearly- way too costly for hot paths that use
large allocations, especially those with fallbacks to smaller
allocations or vmalloc.

Instead, memory reclaim should kick background compaction and let it
do the work. If the allocation path really, really needs high order
allocation to succeed, then it can direct the allocation to retry
until it succeeds and the allocator itself can wait for background
compaction to make progress.

For code that has fallbacks to smaller allocations, then there is no
need to wait for compaction - we can attempt fast smaller allocations
and continue that way until an allocation succeeds....

-Dave.
-- 
Dave Chinner
dgc@kernel.org
