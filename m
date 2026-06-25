Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E59D1E8320;
	Thu, 25 Jun 2026 13:00:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782392457; cv=none; b=p78eWkx+zFP3axO39eIMPYJKtywjc09LLfQkRiI6J8ofy11BejjvcNVUxSyGHbZK8x/h7eGWSOT1vxq7rq1FVgVhPMU8p9vl+IV94zudSv0X9vws+rKBdFxheVn8VkotNr1ZKKPtYVS4hKjnK+8v6YW/Wzfon6zcZ7cPtM1SgZ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782392457; c=relaxed/simple;
	bh=YLV4awuj/dO6hSE/OY89FyIN61gKeXwzN07Q/yxwXl4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ebr41/no5DU/SRVDlmFPPxRPWxh0iWL23xRgcraPYL6kP86o2LSzISh2H/4g6l0fecsPpGPTyu3394spKNWiNl59UoUQPw7nD3AdK1f3vaXFD7nhVt4VBrLGZiWzdFwkzMXoXGXk2ulh6zvsVgyPJojklQNGykd7NDWSBhI7a+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id A616268B05; Thu, 25 Jun 2026 15:00:52 +0200 (CEST)
Date: Thu, 25 Jun 2026 15:00:52 +0200
From: Christoph Hellwig <hch@lst.de>
To: Joanne Koong <joannelkoong@gmail.com>
Cc: willy@infradead.org, djwong@kernel.org, linux-fsdevel@vger.kernel.org,
	linux-xfs@vger.kernel.org, Fengnan <changfengnan@bytedance.com>
Subject: Re: [RFC PATCH v1 3/3] xfs: example of devirtualizing buffered
 write iomap callbacks
Message-ID: <20260625130052.GB22620@lst.de>
References: <20260625024723.1611000-1-joannelkoong@gmail.com> <20260625024723.1611000-4-joannelkoong@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260625024723.1611000-4-joannelkoong@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Jun 24, 2026 at 07:47:23PM -0700, Joanne Koong wrote:
> This is an example of what removing the indirect call would look like.
> With the inlined iomap_buffered_write_inline() that gets passed
> xfs_buffered_write_iomap_begin() and xfs_buffered_write_iomap_end() as
> constant callbacks, the compiler is able to call the callbacks directly
> and drop the indirect call through struct iomap_ops:

Nice.  Btw, a more critical path would be direct I/O.

Fengnan, maybe you can play around with this series and your direct read
fast path?

> +	/*
> +	 * Call inlined iomap buffered write and pass constant begin/end
> +	 * function pointers so the compiler can devirtualize them and avoid the
> +	 * indirect call through struct iomap_ops.
> +	 */
> +	iter = (struct iomap_iter){
> +		.inode		= inode,
> +		.pos		= iocb->ki_pos,
> +		.len		= iov_iter_count(from),
> +		.flags		= IOMAP_WRITE,
> +	};
> +	if (iocb->ki_flags & IOCB_NOWAIT)
> +		iter.flags |= IOMAP_NOWAIT;
> +	if (iocb->ki_flags & IOCB_DONTCACHE)
> +		iter.flags |= IOMAP_DONTCACHE;

We'll probably want a helper for this initializion boilerplate.
Or make it part of iomap_buffered_write_inline somehow?

> +	ret = iomap_buffered_write_inline(&iter, from,
> +			xfs_buffered_write_iomap_begin,
> +			xfs_buffered_write_iomap_end,

So we're not even doing the _next scheme here and already get
results, nice!

> +	if (ret > 0)
> +		iocb->ki_pos = iter.pos;

Similarly here, it would be great if we could somehow avoid
too much boilerplate.

