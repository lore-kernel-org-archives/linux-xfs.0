Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD9E63203B6
	for <linux-xfs@vger.kernel.org>; Mon,  8 Jun 2026 09:49:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780912198; cv=none; b=acmmInRGGhQOx0NKEq3RVsyqhjWAP741R2RqDuauQD0Y7FoTD8ltclh35nz88S/nPQGWt12yyb131PRq29Qssflt65AWcBI5jyCsm7JNJHEPKf58z4f9XizixwmehTS0kSfMbJBGvLJKVFfQfM3vfR8oBeyCF+n/UqVoZxPypek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780912198; c=relaxed/simple;
	bh=urIW+8OmLAPml5InQg6fqvNUc2XdgZoS8JDhMjA8jTY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SN4SPAgN10pJ+x4Pt45MJhCQx82Okm6W7K8ItNOi+rEoqCpyy9JXlOPIOLQOdfH7KDFzNLHbxFpT/Ne/bvKp+pLe/Ar4nWsrqcqzD9ux+MIJ4X/9LybIFRWRJQrxFYlGJbuQqCkNgrLig7GHePI+G9cH/EScZuL1oaEmHisimoA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Rx5BpotC; arc=none smtp.client-ip=91.218.175.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Rx5BpotC"
Date: Mon, 8 Jun 2026 11:49:42 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1780912194;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=spIBMtgCBjfJOn+Mw2NyiswnyB3JQ3tySSXWh9mAHMc=;
	b=Rx5BpotCMH0yOhMLdA8lNM8tJsglix3J9on3O/p6UhJ+PlwTJgRb3HUq2YmkL2M918EF2u
	GyINw1JQ6Z4ndlocxowSQrztvJMEWGYv6TbhaxeB1LiVMT5Ad07UcAuxS9jT172RjWZ7P1
	f/ktTYtq84n4L30qdOjPwcumO+KBziY=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "Pankaj Raghav (Samsung)" <pankaj.raghav@linux.dev>
To: Brandon Allard <brandon@redpanda.com>
Cc: linux-xfs@vger.kernel.org, cem@kernel.org, 
	linux-kernel@vger.kernel.org, p.raghav@samsung.com, pankaj.raghav@linux.dev
Subject: Re: [PATCH] xfs: coalesce contiguous unwritten suffix into iomap for
 NOWAIT writes
Message-ID: <6csdtjn33va4ivyycr4uh2ogac22xput4kgzxzt3mczdkvwjaf@37audfdijskv>
References: <20260529191100.4142371-1-brandon@redpanda.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260529191100.4142371-1-brandon@redpanda.com>
X-Migadu-Flow: FLOW_OUT

On Fri, May 29, 2026 at 03:11:00PM -0400, Brandon Allard wrote:
> In append-only direct-IO workloads with fallocate(with KEEP_SIZE +
> ZERO_RANGE) writes can span the written/unwritten boundary of the
> preallocated extent. This is from callers needing to overwrite the
> previously written block if the last write didn't completely fill it.
> 
> Prior to commit 883a790a8440 ("xfs: don't allow NOWAIT DIO across extent
> boundaries") these writes succeeded by issuing two bios: one against the

Also add this info in as Fixes tag.

> NORM head, one against the UNWRITTEN tail. That commit closed off the
> two-bio path to prevent NOWAIT callers from observing short writes when
> one bio succeeded and another returned -EAGAIN. The side effect is that
> the workload above now returns -EAGAIN on the spanning write.
> 
>  static bool
>  xfs_bmap_hw_atomic_write_possible(
>  	struct xfs_inode	*ip,
> @@ -961,7 +996,14 @@ xfs_direct_write_iomap_begin(
>  	 */
>  	if (flags & (IOMAP_NOWAIT | IOMAP_OVERWRITE_ONLY)) {

I am wondering if adding this imap_extend_into_unwritten() inside
(IOMAP_NOWAIT | IOMAP_OVERWRITE_ONLY) will have some side effect in the 
next check for IOMAP_OVERWRITE_ONLY [1]:
	if (flags & IOMAP_OVERWRITE_ONLY) {
		error = -EAGAIN;
		if (imap.br_state != XFS_EXT_NORM &&
	            ((offset | length) & mp->m_blockmask))
			goto out_unlock;
	}

We are changing the br_state to NORM->UNWRITTEN. Should you guard the
imap_extend_into_unwritten() only for NOWAIT case? Did you also test
this scenario?

>  		error = -EAGAIN;
> -		if (!imap_spans_range(&imap, offset_fsb, end_fsb))
> +		/*
> +		 * Sequential append workloads with adaptive preallocation can
> +		 * span the NORM->UNWRITTEN boundary that unwritten conversion
> +		 * leaves behind. Try to coalesce the next contiguous unwritten record
> +		 * into imap before returning -EAGAIN.
> +		 */
> +		if (!imap_spans_range(&imap, offset_fsb, end_fsb) &&
> +		    !imap_extend_into_unwritten(ip, &imap, end_fsb))
>  			goto out_unlock;
>  	}
>  
> -- 
> 2.48.1
> 

[1] https://elixir.bootlin.com/linux/v7.0.11/source/fs/xfs/xfs_iomap.c#L974

-- 
Pankaj
