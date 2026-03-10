Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B74B43BB9EC
	for <linux-xfs@vger.kernel.org>; Tue, 10 Mar 2026 13:06:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773148001; cv=none; b=EoSuoPVoDr/7/3vlzOrH4nuibLWqRsYpjaIPTn6EVbXPiywm6flvD45lUYFYhjNjPqHggRYQNUHiODUecB4wkUdlsZ6UUxDd5m6cGWEjBT74S28NKdsAUnDp1LtU1ZPzwjUepfRU5ZOUV4JZ1ExhN/yPsNxPRpJC4oA8RF+XoIs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773148001; c=relaxed/simple;
	bh=eC9JjdQ/anq58QPq1QMnIZv5YJIETdHBBIh9HDJjmqs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Tyt3hjUhlSjQ5G/vQWAXJrBxXZM5/nzDkgh2ntndjePCTmOjJdSwUCQJ3tYBXS0ORRe/qhtqXgnq8F5/QszA8i7K78DK6Hu7sPug2h4trLF4skLKSw/HFZ+PE0QDAKPVhFiQxbW6aPfyCWax95eZoiZWFWnT0uH+NiMcAgliQhk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id B23AD68C4E; Tue, 10 Mar 2026 14:06:37 +0100 (CET)
Date: Tue, 10 Mar 2026 14:06:37 +0100
From: Christoph Hellwig <hch@lst.de>
To: cem@kernel.org
Cc: linux-xfs@vger.kernel.org, david@fromorbit.com, hch@lst.de,
	djwong@kernel.org
Subject: Re: [PATCH 3/3] xfs: remove owner field from xfs_extent_busy
Message-ID: <20260310130637.GC4151@lst.de>
References: <20260310123324.339310-1-cem@kernel.org> <20260310123324.339310-4-cem@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260310123324.339310-4-cem@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Mar 10, 2026 at 01:33:16PM +0100, cem@kernel.org wrote:
> From: Carlos Maiolino <cem@kernel.org>
> 
> Now that xfs_busy_extents is not embedded into a cil context, we can
> get rid of the owner field.
> 
> The struct will be freed upon a call to xfs_discard_extents(), whether
> at IO completion or by direct calling xfs_discard_endio_work().
> 
> What reamains is xlog_cil_commited now being responsible for freeing
> the context itself.
> 
> Worth mentioning that the busy extents still need to be manually freed
> during filesystem shutdown via xlog_cil_destroy() if there is a
> remaining context there.
> 
> Also, xlog_cil_committed() now unconditionally calls xfs_discard_extents.
> This seems safe because it can handle an empty list, and as a bonus,
> it will call xfs_discard_endio_work() for such case, without any extra
> wiring needed to free the busy extents list in case it is empty.
> xfs_discard_endio_work() is also able to properly handle the empty list.

Looking at this series, it feels almost like this should be mostly
merged with the previous patch, with a small caveat:

>  
>  	xlog_cil_free_logvec(&ctx->lv_chain);
>  
> -	if (!list_empty(&ctx->busy_extents->extent_list)) {
> -		ctx->busy_extents->owner = ctx;
> -		xfs_discard_extents(mp, ctx->busy_extents);
> -		return;
> -	}
> -
> -	xfs_busy_extents_free(ctx->busy_extents);
> +	xfs_discard_extents(mp, busy_extents);

I'd probably split this part out as it really neeѕs an explanation
and seems to be something taking advantage of the new dynamic
allocation scheme.

