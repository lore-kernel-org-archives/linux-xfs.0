Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 437872BE03B
	for <linux-xfs@vger.kernel.org>; Mon, 12 Jan 2026 10:15:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768212910; cv=none; b=uN/c/304uYd5rdmkGPcjq5NsGe1X/bFZ9JvEeax/6Nqh4OuOMwsGhOZcVCOWutTdNVvWl4nZwmlBUry3aQlDiEID6mXhHLJVeazyyhR+uaxyk1QvcbeNpZHpkAANBOZiN7Em2jBnOIYxPm2aGVBSa+10Gl7Wqb6CuXR15rsAcTE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768212910; c=relaxed/simple;
	bh=7soK8ayfyAs0Es4xsDG0sQD1SkJCGRdHQRJ7AbLRrbw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=cWcUJ3ej5CAePvyxD1TxNTZ1xBJZ5RHLT8z8QaJPdMx0I1iS8Tzzb2nZSLYJyzj7wftffyGkW9vStMbAeTpWLwEUIWiWp/HrbfI0uy0SMQGA9qGxXWBAu+91AlMbhhJbLUqV8ZzCZFTzfTFusYusKrLUOu8Rdj4zVNgNf0xUL3w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VsK0Deg5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VsK0Deg5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5364C16AAE;
	Mon, 12 Jan 2026 10:15:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768212909;
	bh=7soK8ayfyAs0Es4xsDG0sQD1SkJCGRdHQRJ7AbLRrbw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=VsK0Deg5NCkyXsrtsL2rQWZ7u5EuoHqooYZ3GaRkI5KLknHwlb8X26gXWrTxxVj6q
	 lHjMyZs9AT5TDlofWwoAnKe7WGn0LGCgWIJKhIBdi1yyDhYFWsWflVHz9/9NiVW4Hc
	 NamwM1MfneeYOYfwezaHT7ESONY0bcpA22ZFExgFRCK7Zkz5COMofJ6y0JOzkvGkob
	 LUEIbZ2GiCNzB7IXnwkj18lElOMOULdTYBef+3OQIO1CnkssXLEay74ZXtNq9eljVh
	 sWuKWYqh4X7HoXlrpxne695uL2ssS306oPN11GNFSU7WkCYL8vks5sy+ALUUfj0OIZ
	 dThmIVWrlkYew==
Message-ID: <ce23e24a-d671-43bc-a5e1-28ccf7083aff@kernel.org>
Date: Mon, 12 Jan 2026 11:15:07 +0100
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/6] xfs: pass the write pointer to xfs_init_zone
To: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org
References: <20260109172139.2410399-1-hch@lst.de>
 <20260109172139.2410399-4-hch@lst.de>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20260109172139.2410399-4-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 1/9/26 18:20, Christoph Hellwig wrote:
> Move the two methods to query the write pointer out of xfs_init_zone into
> the callers, so that xfs_init_zone doesn't have to bother with the
> blk_zone structure and instead operates purely at the XFS realtime group
> level.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_zone_alloc.c | 66 +++++++++++++++++++++++------------------
>  1 file changed, 37 insertions(+), 29 deletions(-)
> 
> diff --git a/fs/xfs/xfs_zone_alloc.c b/fs/xfs/xfs_zone_alloc.c
> index bbcf21704ea0..013228eab0ac 100644
> --- a/fs/xfs/xfs_zone_alloc.c
> +++ b/fs/xfs/xfs_zone_alloc.c
> @@ -981,43 +981,43 @@ struct xfs_init_zones {
>  	uint64_t		reclaimable;
>  };
>  
> +/*
> + * For sequential write required zones, we restart writing at the hardware write
> + * pointer.
> + *
> + * For conventional zones or conventional devices we have query the rmap to
> + * find the highest recorded block and set the write pointer to the block after
> + * that.  In case of a power loss this misses blocks where the data I/O has
> + * completed but not recorded in the rmap yet, and it also rewrites blocks if
> + * the most recently written ones got deleted again before unmount, but this is
> + * the best we can do without hardware support.
> + */

I find this comment and the function name confusing since we are not looking at
a zone write pointer at all. So maybe rename this to something like:

xfs_rmap_get_highest_rgbno()

? Also, I think the comment block should go...


> +static xfs_rgblock_t
> +xfs_rmap_write_pointer(
> +	struct xfs_rtgroup	*rtg)
> +{
> +	xfs_rgblock_t		highest_rgbno;
> +
> +	xfs_rtgroup_lock(rtg, XFS_RTGLOCK_RMAP);
> +	highest_rgbno = xfs_rtrmap_highest_rgbno(rtg);
> +	xfs_rtgroup_unlock(rtg, XFS_RTGLOCK_RMAP);
> +
> +	if (highest_rgbno == NULLRGBLOCK)
> +		return 0;
> +	return highest_rgbno + 1;
> +}

[...]

>  	/*
>  	 * If there are no used blocks, but the zone is not in empty state yet
>  	 * we lost power before the zoned reset.  In that case finish the work
> @@ -1066,6 +1066,7 @@ xfs_get_zone_info_cb(
>  	struct xfs_mount	*mp = iz->mp;
>  	xfs_fsblock_t		zsbno = xfs_daddr_to_rtb(mp, zone->start);
>  	xfs_rgnumber_t		rgno;
> +	xfs_rgblock_t		write_pointer;
>  	struct xfs_rtgroup	*rtg;
>  	int			error;
>  
> @@ -1080,7 +1081,13 @@ xfs_get_zone_info_cb(
>  		xfs_warn(mp, "realtime group not found for zone %u.", rgno);
>  		return -EFSCORRUPTED;
>  	}
> -	error = xfs_init_zone(iz, rtg, zone);

...here.
This code is also hard to follow without a comment indicating that write_pointer
is not set by xfs_zone_validate() for conventional zones. Ideally, we should
move the call to xfs_rmap_write_pointer() in xfs_zone_validate(). That would be
cleaner, no ?

> +	if (!xfs_zone_validate(zone, rtg, &write_pointer)) {
> +		xfs_rtgroup_rele(rtg);
> +		return -EFSCORRUPTED;
> +	}
> +	if (zone->cond == BLK_ZONE_COND_NOT_WP)
> +		write_pointer = xfs_rmap_write_pointer(rtg);
> +	error = xfs_init_zone(iz, rtg, write_pointer);
>  	xfs_rtgroup_rele(rtg);
>  	return error;
>  }
> @@ -1290,7 +1297,8 @@ xfs_mount_zones(
>  		struct xfs_rtgroup	*rtg = NULL;
>  
>  		while ((rtg = xfs_rtgroup_next(mp, rtg))) {
> -			error = xfs_init_zone(&iz, rtg, NULL);
> +			error = xfs_init_zone(&iz, rtg,
> +					xfs_rmap_write_pointer(rtg));
>  			if (error) {
>  				xfs_rtgroup_rele(rtg);
>  				goto out_free_zone_info;


-- 
Damien Le Moal
Western Digital Research
