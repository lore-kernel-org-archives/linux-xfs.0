Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2ABA43002A9
	for <linux-xfs@vger.kernel.org>; Mon, 30 Mar 2026 12:16:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774873018; cv=none; b=hYlVSIuWd7KVtq/RaGdZW7HrdYU69thM5Lqt2MTc8hxtkP3fITPPzscDI8z0u9A74ZSvwTtovQwwWgnBGHHL7Sd1ReUbXNyp4gq4VvENj8mc2Cq8SeX3ILv5BEHTKufa2q3bfSw/HPcgZTkUDdrBgJOG8zanDAQRxgHG6h0Pgz0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774873018; c=relaxed/simple;
	bh=p0sWFHfxsN7YF1KmegPFEWi4xxExKZfqrsee27OfE/s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DR0WddgsgiOfkbO0ix8SfZLfe59OwhDDRsvHj3pvchdNkEv7xdC3yHrL/GGp8fvnrXCfQbAvaj5dv0mBgA03Xu6qM5nKacjsxaxpjI4jlwiKpeL2WnhsGAkG7OXgv19RJVM5JyYGFxIiO5Vjji1dnVie0frM68qnEM9yrcK7b8A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GtX/OwoQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GtX/OwoQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A12E1C4CEF7;
	Mon, 30 Mar 2026 12:16:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774873017;
	bh=p0sWFHfxsN7YF1KmegPFEWi4xxExKZfqrsee27OfE/s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=GtX/OwoQXaxbjss33rbAQ2U0OJeUpPszglUtbMfmrDHa51O2MZmF39A02LKmsmQUM
	 a2R1JUAcciYSTlIIiBM19oxOyWgYH7Fvw/OE4tjE+f1M6EQwCnPqN9a7lTmEX/ZQK3
	 yIVfhd0c2sXKOj+He0P156hoeXHiKAYhtWV2tBUYjJzhHsk101kO3TbwVJIZru4Sx/
	 w2gF1VNlBH0fEzPyOcoV/pMlZXIvCdyUZwPnVeq//VBhwDsgZwYNVJ8QuPxFTx2Pqf
	 HSvlJwfgqjYfaeJyEXXltKZbAQ6mOmroV7vZ6QlmyhpiFa7tI3vJOe2pAT5pBK0Gtl
	 xYuBw9Q8VTRKg==
Date: Mon, 30 Mar 2026 14:16:53 +0200
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Damien Le Moal <dlemoal@kernel.org>, 
	Hans Holmberg <hans.holmberg@wdc.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/7] xfs: delay opening the GC zone
Message-ID: <acpnEIzoiBuAJ9E9@nidhogg.toxiclabs.cc>
References: <20260330054533.3856339-1-hch@lst.de>
 <20260330054533.3856339-2-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260330054533.3856339-2-hch@lst.de>

On Mon, Mar 30, 2026 at 07:44:11AM +0200, Christoph Hellwig wrote:
> The code that selects a new GC zone when the previous one is full also
> handles a zone not being set at all.  Make use of that to simplify the
> logic in xfs_zone_gc_mount.
> 

I might be wrong, but the subject looks misleading to me, wouldn't be
better to just set it to something like "simplify xfs_zone_gc_mount"?

Not a big deal for me, just kind of confused me while reading the patch.
But changing subject or not, feel free to add:

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_zone_gc.c | 45 ++++++++++++++++++++------------------------
>  1 file changed, 20 insertions(+), 25 deletions(-)
> 
> diff --git a/fs/xfs/xfs_zone_gc.c b/fs/xfs/xfs_zone_gc.c
> index 0ff710fa0ee7..f076f66c5d57 100644
> --- a/fs/xfs/xfs_zone_gc.c
> +++ b/fs/xfs/xfs_zone_gc.c
> @@ -527,7 +527,7 @@ xfs_zone_gc_select_victim(
>  	return true;
>  }
>  
> -static struct xfs_open_zone *
> +static int
>  xfs_zone_gc_steal_open(
>  	struct xfs_zone_info	*zi)
>  {
> @@ -538,15 +538,18 @@ xfs_zone_gc_steal_open(
>  		if (!found || oz->oz_allocated < found->oz_allocated)
>  			found = oz;
>  	}
> -
> -	if (found) {
> -		found->oz_is_gc = true;
> -		list_del_init(&found->oz_entry);
> -		zi->zi_nr_open_zones--;
> +	if (!found) {
> +		spin_unlock(&zi->zi_open_zones_lock);
> +		return -EIO;
>  	}
>  
> +	trace_xfs_zone_gc_target_opened(found->oz_rtg);
> +	found->oz_is_gc = true;
> +	list_del_init(&found->oz_entry);
> +	zi->zi_nr_open_zones--;
> +	zi->zi_open_gc_zone = found;
>  	spin_unlock(&zi->zi_open_zones_lock);
> -	return found;
> +	return 0;
>  }
>  
>  static struct xfs_open_zone *
> @@ -1177,31 +1180,24 @@ xfs_zone_gc_mount(
>  {
>  	struct xfs_zone_info	*zi = mp->m_zone_info;
>  	struct xfs_zone_gc_data	*data;
> -	struct xfs_open_zone	*oz;
>  	int			error;
>  
>  	/*
> -	 * If there are no free zones available for GC, pick the open zone with
> +	 * If there are no free zones available for GC, or the number of open
> +	 * zones has reached the open zone limit, pick the open zone with
>  	 * the least used space to GC into.  This should only happen after an
> -	 * unclean shutdown near ENOSPC while GC was ongoing.
> -	 *
> -	 * We also need to do this for the first gc zone allocation if we
> -	 * unmounted while at the open limit.
> +	 * unclean shutdown while GC was ongoing.  Otherwise a GC zone will
> +	 * be selected from the free zone pool on demand.
>  	 */
>  	if (!xfs_group_marked(mp, XG_TYPE_RTG, XFS_RTG_FREE) ||
> -	    zi->zi_nr_open_zones == mp->m_max_open_zones)
> -		oz = xfs_zone_gc_steal_open(zi);
> -	else
> -		oz = xfs_open_zone(mp, WRITE_LIFE_NOT_SET, true);
> -	if (!oz) {
> -		xfs_warn(mp, "unable to allocate a zone for gc");
> -		error = -EIO;
> -		goto out;
> +	    zi->zi_nr_open_zones >= mp->m_max_open_zones) {
> +		error = xfs_zone_gc_steal_open(zi);
> +		if (error) {
> +			xfs_warn(mp, "unable to steal an open zone for gc");
> +			return error;
> +		}
>  	}
>  
> -	trace_xfs_zone_gc_target_opened(oz->oz_rtg);
> -	zi->zi_open_gc_zone = oz;
> -
>  	data = xfs_zone_gc_data_alloc(mp);
>  	if (!data) {
>  		error = -ENOMEM;
> @@ -1224,7 +1220,6 @@ xfs_zone_gc_mount(
>  	kfree(data);
>  out_put_gc_zone:
>  	xfs_open_zone_put(zi->zi_open_gc_zone);
> -out:
>  	return error;
>  }
>  
> -- 
> 2.47.3
> 
> 
