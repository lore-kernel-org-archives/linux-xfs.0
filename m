Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE3863B38B5
	for <linux-xfs@vger.kernel.org>; Tue, 10 Mar 2026 13:03:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773147829; cv=none; b=JzTTcs8NXVU+wvu/Esee3SQy5Rmdh8Qf//1eNBIxCO7aVe8ZBtU0xMfGfnWQFwJYkR/ug1l4iVV8wIN+IsvDgrGhSZeFAAwofFwxQH3AWYOknCwP4tdoMakEqvkA5WwLtEOW+oYOMm7CZZD8ulS/D1UfdAZgi22twI7DQD63VgM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773147829; c=relaxed/simple;
	bh=XFg9zCR4kl3WIist/N0ooX0c37ZQPIWlBgdtfQczx6Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qitG2FnqnsWL8EdTwHcaO0hMehdV6Q8lwsCrg1q0A5rpInKiEMbwbEr/TqxI5xzaZRKwUtkUdNWWA6KBaerKeK+Figwsa7GoWl5wAMDAV8NUER/Ud90jFXLJggWN/eP0IthQCtsHgquuZ7CN6oSa36dCc2F9EutI8dNfb4ImIbE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 7FBF468C4E; Tue, 10 Mar 2026 14:03:44 +0100 (CET)
Date: Tue, 10 Mar 2026 14:03:44 +0100
From: Christoph Hellwig <hch@lst.de>
To: cem@kernel.org
Cc: linux-xfs@vger.kernel.org, david@fromorbit.com, hch@lst.de,
	djwong@kernel.org
Subject: Re: [PATCH 1/3] xfs: add a couple helpers to alloc/free
 xfs_busy_extents
Message-ID: <20260310130344.GA4151@lst.de>
References: <20260310123324.339310-1-cem@kernel.org> <20260310123324.339310-2-cem@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260310123324.339310-2-cem@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Mar 10, 2026 at 01:33:14PM +0100, cem@kernel.org wrote:
> The avoid calls like xfs_busy_extents_alloc(0) explicitly pass GFP_KERNEL
> as argument. It looks better to me.

You can't really pass 0 anyway, so I think this part of the commit
log doesn't make much sense.

> +static inline struct xfs_busy_extents *
> +xfs_busy_extents_alloc(gfp_t flags)
> +{
> +	struct xfs_busy_extents *e;
> +	e = kzalloc_obj(*e, flags);

Please keep an empty line between declarations and code.  And in this
case you could probably move the initialization to the declaration line
as well.
>
> +	if (e)
> +		INIT_LIST_HEAD(&e->extent_list);
> +	return e;
> +}
> +
> +static inline void xfs_busy_extents_free(
> +	struct xfs_busy_extents *e)

This is inconsistent with the xfs_busy_extents_alloc prototype above,
which uses the mormal kernel style, which we sometimes do for inlines,
but also doesn't use the XFS style with the return type on a separate
line and the argument names tab indented.

