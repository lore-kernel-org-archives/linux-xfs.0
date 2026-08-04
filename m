Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB4062E8B83;
	Tue,  4 Aug 2026 18:01:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785866481; cv=none; b=M3fvLe/rOE+TL/pnSncjdIfXRXejk0NtnqS25MdedrvI0P6JL3K48T7QtkMSsSpFvk1sQFaQ4SMSvbEe3TG8/vluFsW1KUL6RkAsph1dLlxR7dl0uIMQd6ZmcGJ8l3BxX3/lyNCczzXLazlxt+BpUwtl7aMckfIXiuDxdvgzsIE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785866481; c=relaxed/simple;
	bh=kQrul+/OUumM2Ya+kto/IwI4Np7MEBBN384/W5APbp0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EMZ87e5p0lrfTiAoJC/jz+hIejSAKA6jBLdNQahybUUpkF4/O/tK7+21Ff08siyIqBFybTUOmFex4kUkQdLxn1AgenT+lfEO3yhiQ0haPDxee9APm/ZZ/fhjrLEwTxGsrak+3PKBSZugnGIjTQiEIAI2FEjHtxHg39ZTPt2389k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nPfLkZ4u; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nPfLkZ4u"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 549B71F000E9;
	Tue,  4 Aug 2026 18:01:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785866480;
	bh=RSCZdlfHoN3MNNuFMvr7QIlKkJ47f+bwICwB/uhDA4Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=nPfLkZ4uC1++e501adfyJeG5XBlMkJCQJrbKrS23H9Mjw345JgvBtH6qU3al983b7
	 Ethpm/m0+i9ddrwk/suuKrr1w54NrTCGTZuK0n1x2zemEqczgexKrTGp1KpHMRy/IY
	 q4PMEa7clRn3ObuGZ1v0bNSxl4MXSWVW+j8cQSg8XUl55tPBsoRtx5tFZLUChR0lsB
	 uEGgbK/BslSqTxu/Z0hPy0cn4f6eNbjiTKSLWFXgbbfWGq5RMHIFuFxJLdXm0WNBRl
	 mWvDPFJw+ghJuVPnaKObQCenvV/8BLnSxIu3cQkzoBMECywmXCsbbdaF1FnFQw/io2
	 D/9zxSMt8KuTg==
Date: Tue, 4 Aug 2026 11:01:19 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: linux-xfs@vger.kernel.org, fsverity@lists.linux.dev,
	linux-fsdevel@vger.kernel.org, ebiggers@kernel.org, hch@lst.de,
	linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
	linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v14 05/21] fsverity: improve flushing performance of
 fsverity_fill_zerohash
Message-ID: <20260804180119.GJ3556460@frogsfrogsfrogs>
References: <20260803200820.393203-1-aalbersh@kernel.org>
 <20260803200820.393203-6-aalbersh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260803200820.393203-6-aalbersh@kernel.org>

On Mon, Aug 03, 2026 at 10:07:55PM +0200, Andrey Albershteyn wrote:
> The current version calls flush_dcache_folio(), in memcpy_to_folio(), to
> flush whole folio on every digest (which is 128 for 4k) on the HIGHMEM
> systems. Open code folio mapping and flushing to copy all digests at
> once.

Do we really have to care about HIGHMEM performance?  I thought that
was going soon anyway[1].  The code change *looks* reasonable but ugh
it adds more complexity and how many 32-bit phones and servers are
there?

(For Andrey: Why is this bolted onto an XFS patchset?  Nobody
should run XFS on 32-bit at all these days.)

--D

[1] https://lwn.net/Articles/1051010/

> Reported-by: Eric Biggers <ebiggers@kernel.org>
> Link: https://lore.kernel.org/linux-fsdevel/20260401222717.GH2466@quark/
> Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
> ---
>  fs/verity/pagecache.c | 28 ++++++++++++++++++++++++++--
>  1 file changed, 26 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/verity/pagecache.c b/fs/verity/pagecache.c
> index 9d82e6b74ba1..911207dc0ef7 100644
> --- a/fs/verity/pagecache.c
> +++ b/fs/verity/pagecache.c
> @@ -68,14 +68,38 @@ EXPORT_SYMBOL_GPL(generic_readahead_merkle_tree);
>  void fsverity_fill_zerohash(struct folio *folio, size_t offset, size_t len,
>  			      struct fsverity_info *vi)
>  {
> -	size_t off = offset;
> +	size_t off;
>  
>  	WARN_ON_ONCE(!IS_ALIGNED(offset, vi->tree_params.digest_size));
>  	WARN_ON_ONCE(!IS_ALIGNED(len, vi->tree_params.digest_size));
> +#ifdef CONFIG_HIGHMEM
> +	WARN_ON_ONCE(offset + len > folio_size(folio));
>  
> -	for (; off < (offset + len); off += vi->tree_params.digest_size)
> +	do {
> +		void *vaddr = kmap_local_folio(folio, offset);
> +		void *to = vaddr;
> +
> +		off = len;
> +
> +		if (folio_test_partial_kmap(folio) &&
> +		    off > PAGE_SIZE - offset_in_page(offset))
> +			off = PAGE_SIZE - offset_in_page(offset);
> +		for (; to < (vaddr + off); to += vi->tree_params.digest_size)
> +			memcpy(to, vi->tree_params.zero_digest,
> +				vi->tree_params.digest_size);
> +		kunmap_local(vaddr);
> +
> +		offset += off;
> +		len -= off;
> +	} while (len > 0);
> +
> +	flush_dcache_folio(folio);
> +#else
> +	for (off = offset; off < (offset + len);
> +			off += vi->tree_params.digest_size)
>  		memcpy_to_folio(folio, off, vi->tree_params.zero_digest,
>  				vi->tree_params.digest_size);
> +#endif
>  }
>  EXPORT_SYMBOL_GPL(fsverity_fill_zerohash);
>  
> -- 
> 2.54.0
> 
> 
