Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3AED3002BD
	for <linux-xfs@vger.kernel.org>; Tue, 14 Oct 2025 17:24:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760462684; cv=none; b=teOOxgD+rT36kSj4YPuUo7T6nTvuiHzSsN+UeOKG0RtzG9p6oqbHlr1H2os3iwMn8V5eP57i7H9w65dWYj0VZw9oBjwCfVcAtwtwJd7gNwduTlBVIJI1qgj9d942tXs7U4vvAQVSZVNz8ICChj3wTzhZlhv8P0XDPvechjfNg9I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760462684; c=relaxed/simple;
	bh=hOPAiV5GDIaAIwovQoPQsj08womC0sxIiDW0Z3R8Z8U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JSNH5lt0g+gPyDZi6nZQe/+yV7fv2xmCVqV21IPLS6On3tYuvOWV/VbzzE1HLg8sEF8sQiP8Hg/ectbi5s7lYmtTOeIiKQ12GBhyEc6tCaLERhn9Xignal25DajSC9r5sQ4QUm5v+jcBtfqvWNPBhhvgGT3FneLkEC5UCBDLVoQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GzF/g1p/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GzF/g1p/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71CFAC4CEE7;
	Tue, 14 Oct 2025 17:24:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760462683;
	bh=hOPAiV5GDIaAIwovQoPQsj08womC0sxIiDW0Z3R8Z8U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=GzF/g1p/n8yBk3TrKkp8E6WB4SsM6wiq3PI2CtE4HdCr5gtmz3PAL/q5knTkM8tJE
	 9wF7chvJTnEbHGcu7ITZi3E1dPmE4nfryBBkG2abOGX9HaGBXfJE00oI1M/BGDiCfD
	 /D9s4QE1SlttG2COGvodNfCnqy8HDdnM+XYI99BwGDXHw2TLChSqKwoK58ZOWN0Yi7
	 lYW9XwPc8DTadK+K9GO4pXD/xlnz4FQtg/bjdOZBB7ZLarDM1g85ptDwQLwJLtZ9gU
	 feO87RPrVF8PPPop5TDkZ4phlBypsETG4cAj0f5E2QJ7aai1QFZ3Rf8GmsTQJbXAnb
	 W7fhgeEMVcIPg==
Date: Tue, 14 Oct 2025 10:24:42 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Torsten Rupp <torsten.rupp@gmx.net>
Cc: linux-xfs@vger.kernel.org
Subject: Re: Double alloc/free of cache item
Message-ID: <20251014172442.GV6188@frogsfrogsfrogs>
References: <f45c9b48-eb0d-4314-aeb0-6b5e75c54a8e@gmx.net>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f45c9b48-eb0d-4314-aeb0-6b5e75c54a8e@gmx.net>

On Tue, Oct 14, 2025 at 08:51:12AM +0200, Torsten Rupp wrote:
> Dear XFS developers,
> 
> there is a double alloc/free of the cache item "xfs_extfree_item_cache" in
> xfsprogs 6.16.0. If the environment variable LIBXFS_LEAK_CHECK is set this
> also cause a segmenation fault due to a NULL pointer access (the cache item
> is already freed). Please find attached a patch which fix this issue.
> 
> I discussed this issue and the fix already with Darrick.
> 
> Thank you for your work on xfsprogs!
> 
> Best regards,
> 
> Torsten

> From 4c669fd1db79564d8b5240c7464dd28f3bc27bb1 Mon Sep 17 00:00:00 2001
> From: Torsten Rupp <torsten.rupp@gmx.net>
> Date: Sun, 12 Oct 2025 09:23:58 +0200
> Subject: [PATCH 1/1] Fix alloc/free of cache item
> 
> xfs_extfree_item_cache is allocated and freed twice. Remove the
> obsolete alloc/free.
> 
> Signed-off-by: Torsten Rupp <torsten.rupp@gmx.net>

Usually patches are pasted inline in the message and not as attachments
to avoid picky MTAs, but whatever, it got through lore/vger.

Looks correct,
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  libxfs/init.c | 4 ----
>  1 file changed, 4 deletions(-)
> 
> diff --git a/libxfs/init.c b/libxfs/init.c
> index 393a9467..a5e89853 100644
> --- a/libxfs/init.c
> +++ b/libxfs/init.c
> @@ -214,9 +214,6 @@ init_caches(void)
>  		fprintf(stderr, "Could not allocate btree cursor caches.\n");
>  		abort();
>  	}
> -	xfs_extfree_item_cache = kmem_cache_init(
> -			sizeof(struct xfs_extent_free_item),
> -			"xfs_extfree_item");
>  	xfs_trans_cache = kmem_cache_init(
>  			sizeof(struct xfs_trans), "xfs_trans");
>  	xfs_parent_args_cache = kmem_cache_init(
> @@ -236,7 +233,6 @@ destroy_caches(void)
>  	leaked += kmem_cache_destroy(xfs_da_state_cache);
>  	xfs_defer_destroy_item_caches();
>  	xfs_btree_destroy_cur_caches();
> -	leaked += kmem_cache_destroy(xfs_extfree_item_cache);
>  	leaked += kmem_cache_destroy(xfs_trans_cache);
>  	leaked += kmem_cache_destroy(xfs_parent_args_cache);
>  
> -- 
> 2.43.0
> 

