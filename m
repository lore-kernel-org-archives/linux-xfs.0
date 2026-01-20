Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CBD01B4F2C
	for <linux-xfs@vger.kernel.org>; Tue, 20 Jan 2026 15:53:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768924410; cv=none; b=geH+XIgVlQkQvjw2XY8z5nIgk+91UXtaNpVURL5OBj8RUEEn3UChGOprS1K4wwdUjidvvqJp8lIEnWwS/5dqPOEhtApG5U/yY+1KDizLoVpfiINGGs0/VJb7qvfsCcxL6xz9ReoeepEgApKe+m4WzJAB2nRmG12c9DjQO1C0vY8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768924410; c=relaxed/simple;
	bh=GiZ2QTATZIeMZAtIsB1kbUzhoodwTZXnrzoWV+VFt0E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tPJZxUVsce6j8H81oSB9j8qollpz9JjjXxZelvrNxOXpGETJwtcINPk7GAO2fMRgfgB3K0thDKondAd80nwPrebySbzx2vKEVxjjlx56QesIeDNeNykXkl9r1GV2eeeozceqPglbu7zIZUkhKGTuYfeXySlaPuYW76FCzVKphaA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=t5tEurI9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="t5tEurI9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E93A4C16AAE;
	Tue, 20 Jan 2026 15:53:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768924410;
	bh=GiZ2QTATZIeMZAtIsB1kbUzhoodwTZXnrzoWV+VFt0E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=t5tEurI9Zt0E8w+oU6BXS9e3aDXhB89ie85Gbm4i7vtxwoGsNnHyUvZ47ypzuDtI7
	 1D/rvSiOkkOkHTsBdfi7DO5PaDLmohBeQ6HpSaghrXZbJdCK01df6Kq4PwzIUfzZoA
	 IqhqKgND3xLD3m5+lDg34nzfqNHWX2uZQRhLbz8z1dbteikYux5ip+0Ckh9sh3i91p
	 e8boNz90locUwDF8bhmvHWqglWWKU2LckluNPes7rEauSxwWWQwWB8cYwM8Zp/hWFX
	 DG+4pl26iNP3P6mLoHO+Wm1pmUpacWOanmI7Qo4Dk0GYYmvoA8iRhgAEc+N/2PgWeH
	 LkSz/tCMLD2kg==
Date: Tue, 20 Jan 2026 07:53:29 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Hans Holmberg <hans.holmberg@wdc.com>
Cc: linux-xfs@vger.kernel.org, Carlos Maiolino <cem@kernel.org>,
	Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@lst.de>,
	dlemoal@kernel.org, johannes.thumshirn@wdc.com
Subject: Re: [PATCH] xfs: always allocate the free zone with the lowest index
Message-ID: <20260120155329.GM15551@frogsfrogsfrogs>
References: <20260120085746.29980-1-hans.holmberg@wdc.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260120085746.29980-1-hans.holmberg@wdc.com>

On Tue, Jan 20, 2026 at 09:57:46AM +0100, Hans Holmberg wrote:
> Zones in the beginning of the address space are typically mapped to
> higer bandwidth tracks on HDDs than those at the end of the address
> space. So, in stead of allocating zones "round robin" across the whole
> address space, always allocate the zone with the lowest index.

Does it make any difference if it's a zoned ssd?  I'd imagine not, but I
wonder if there are any longer term side effects like lower-numbered
zones filling up and getting gc'd more often?

--D

> This increases average write bandwidth for overwrite workloads
> when less than the full capacity is being used. At ~50% utilization
> this improves bandwidth for a random file overwrite benchmark
> with 128MiB files and 256MiB zone capacity by 30%.
> 
> Running the same benchmark with small 2-8 MiB files at 67% capacity
> shows no significant difference in performance. Due to heavy
> fragmentation the whole zone range is in use, greatly limiting the 
> number of free zones with high bw.
> 
> Signed-off-by: Hans Holmberg <hans.holmberg@wdc.com>
> ---
> 
>  fs/xfs/xfs_zone_alloc.c | 47 +++++++++++++++--------------------------
>  fs/xfs/xfs_zone_priv.h  |  1 -
>  2 files changed, 17 insertions(+), 31 deletions(-)
> 
> diff --git a/fs/xfs/xfs_zone_alloc.c b/fs/xfs/xfs_zone_alloc.c
> index bbcf21704ea0..d6c97026f733 100644
> --- a/fs/xfs/xfs_zone_alloc.c
> +++ b/fs/xfs/xfs_zone_alloc.c
> @@ -408,31 +408,6 @@ xfs_zone_free_blocks(
>  	return 0;
>  }
>  
> -static struct xfs_group *
> -xfs_find_free_zone(
> -	struct xfs_mount	*mp,
> -	unsigned long		start,
> -	unsigned long		end)
> -{
> -	struct xfs_zone_info	*zi = mp->m_zone_info;
> -	XA_STATE		(xas, &mp->m_groups[XG_TYPE_RTG].xa, start);
> -	struct xfs_group	*xg;
> -
> -	xas_lock(&xas);
> -	xas_for_each_marked(&xas, xg, end, XFS_RTG_FREE)
> -		if (atomic_inc_not_zero(&xg->xg_active_ref))
> -			goto found;
> -	xas_unlock(&xas);
> -	return NULL;
> -
> -found:
> -	xas_clear_mark(&xas, XFS_RTG_FREE);
> -	atomic_dec(&zi->zi_nr_free_zones);
> -	zi->zi_free_zone_cursor = xg->xg_gno;
> -	xas_unlock(&xas);
> -	return xg;
> -}
> -
>  static struct xfs_open_zone *
>  xfs_init_open_zone(
>  	struct xfs_rtgroup	*rtg,
> @@ -472,13 +447,25 @@ xfs_open_zone(
>  	bool			is_gc)
>  {
>  	struct xfs_zone_info	*zi = mp->m_zone_info;
> +	XA_STATE		(xas, &mp->m_groups[XG_TYPE_RTG].xa, 0);
>  	struct xfs_group	*xg;
>  
> -	xg = xfs_find_free_zone(mp, zi->zi_free_zone_cursor, ULONG_MAX);
> -	if (!xg)
> -		xg = xfs_find_free_zone(mp, 0, zi->zi_free_zone_cursor);
> -	if (!xg)
> -		return NULL;
> +	/*
> +	 * Pick the free zone with lowest index. Zones in the beginning of the
> +	 * address space typically provides higher bandwidth than those at the
> +	 * end of the address space on HDDs.
> +	 */
> +	xas_lock(&xas);
> +	xas_for_each_marked(&xas, xg, ULONG_MAX, XFS_RTG_FREE)
> +		if (atomic_inc_not_zero(&xg->xg_active_ref))
> +			goto found;
> +	xas_unlock(&xas);
> +	return NULL;
> +
> +found:
> +	xas_clear_mark(&xas, XFS_RTG_FREE);
> +	atomic_dec(&zi->zi_nr_free_zones);
> +	xas_unlock(&xas);
>  
>  	set_current_state(TASK_RUNNING);
>  	return xfs_init_open_zone(to_rtg(xg), 0, write_hint, is_gc);
> diff --git a/fs/xfs/xfs_zone_priv.h b/fs/xfs/xfs_zone_priv.h
> index ce7f0e2f4598..8fbf9a52964e 100644
> --- a/fs/xfs/xfs_zone_priv.h
> +++ b/fs/xfs/xfs_zone_priv.h
> @@ -72,7 +72,6 @@ struct xfs_zone_info {
>  	/*
>  	 * Free zone search cursor and number of free zones:
>  	 */
> -	unsigned long		zi_free_zone_cursor;
>  	atomic_t		zi_nr_free_zones;
>  
>  	/*
> -- 
> 2.40.1
> 
> 
