Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB53A2356A4
	for <linux-xfs@vger.kernel.org>; Thu, 18 Sep 2025 11:29:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758194954; cv=none; b=sqfPZpJrUVsmBlI4eXxqZMphtN0+Y+9UTSanNbt2FvK0EsnPkZdPpkC1kfCq7asObg7rSfopR33fL0Gt/ON2EmOdfirLezVq2vdH1hDh3dvGnHj0qxsZJSm9rZVK2Ma+iKDoksNE/Og+ewxLaQZDH28oNeEgHVZBFvbCtbN5lqw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758194954; c=relaxed/simple;
	bh=LpUYOIi9iEXmNfYlzzzRobS5mVRricu/AZ+1YWLSXg8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GUOL2/Kne1cqBy0hphsSujk99MwvGbZWIwPGfMd9b5LHa9PSwe6C9roZAgnaH7Lx9UwcDFsM0Hjq7zZwV9G8WTYpZxST36ioiwCBWliL8xuknrB5FGnpSBXvpeu7eNhyzvSHn+ze9xpmeUS31LxJkwCF2VeX8IZCTwpAPaSdl3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HTei3QbZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HTei3QbZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43E1CC4CEE7;
	Thu, 18 Sep 2025 11:29:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758194954;
	bh=LpUYOIi9iEXmNfYlzzzRobS5mVRricu/AZ+1YWLSXg8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=HTei3QbZirlcQoRL7MVoT+bKv1DoMVX1YJ+SJCUxBCl++CqbUpoS94LNl6COanvl3
	 mcuifuS2JlrR5klkMPGoeitOOnJWgsKV7uszH8iPrTRplSj0bnPtOtm+Qe+YPZOS0k
	 +G8pDTQTeyrwVZlsQGyib/aKi9TYwfaEWe9/ImV6xr129WhSPsTojEETFLEz4hqr55
	 UJJuajUMoHADpVv/q9MTleK4OwACNDkRiIZvWf2IdJ4COfUg4G6x8pHqKB0Tv/MsgX
	 KXZlmWnkkDcV2BKjbCVhbk54GIMwUpEwcJYZbjodDj1PBsuaqcKLWSxsSuVNUeWI11
	 ACvEt2WA1it0Q==
Date: Thu, 18 Sep 2025 13:29:09 +0200
From: Carlos Maiolino <cem@kernel.org>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: linux-xfs@vger.kernel.org, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 2/2] xfs: Improve default maximum number of open zones
Message-ID: <2m3osmuu4if44l2abrzt5cnts4og73xfkmjoc4pak32urx7mzs@nl7grwmztfa5>
References: <20250917124802.281686-1-dlemoal@kernel.org>
 <vHqFUYqmELdFlRi_fo6KVxFQ0QVsPbaQqg2vWBs7F3bYvfh1qFWGzHJLM3npupWIB2EFMb76zt6Rp0aNxVt0FQ==@protonmail.internalid>
 <20250917124802.281686-3-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250917124802.281686-3-dlemoal@kernel.org>

On Wed, Sep 17, 2025 at 09:48:02PM +0900, Damien Le Moal wrote:
> For regular block devices using the zoned allocator, the default
> maximum number of open zones is set to 1/4 of the number of realtime
> groups. For a large capacity device, this leads to a very large limit.
> E.g. with a 26 TB HDD:
> 
> mount /dev/sdb /mnt
> ...
> XFS (sdb): 95836 zones of 65536 blocks size (23959 max open)
> 
> In turn such large limit on the number of open zones can lead, depending
> on the workload, on a very large number of concurrent write streams
> which devices generally do not handle well, leading to poor performance.
> 
> Introduce the default limit XFS_DEFAULT_MAX_OPEN_ZONES, defined as 128
> to match the hardware limit of most SMR HDDs available today, and use
> this limit to set mp->m_max_open_zones in xfs_calc_open_zones() instead
> of calling xfs_max_open_zones(), when the user did not specify a limit
> with the max_open_zones mount option.
> 
> For the 26 TB HDD example, we now get:
> 
> mount /dev/sdb /mnt
> ...
> XFS (sdb): 95836 zones of 65536 blocks (128 max open zones)
> 
> This change does not prevent the user from specifying a lareger number
> for the open zones limit. E.g.
> 
> mount -o max_open_zones=4096 /dev/sdb /mnt
> ...
> XFS (sdb): 95836 zones of 65536 blocks (4096 max open zones)
> 
> Finally, since xfs_calc_open_zones() checks and caps the
> mp->m_max_open_zones limit against the value calculated by
> xfs_max_open_zones() for any type of device, this new default limit does
> not increase m_max_open_zones for small capacity devices.
> 
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
> ---
>  fs/xfs/libxfs/xfs_zones.h | 7 +++++++
>  fs/xfs/xfs_zone_alloc.c   | 2 +-
>  2 files changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_zones.h b/fs/xfs/libxfs/xfs_zones.h
> index c4f1367b2cca..6005f5412363 100644
> --- a/fs/xfs/libxfs/xfs_zones.h
> +++ b/fs/xfs/libxfs/xfs_zones.h
> @@ -29,6 +29,13 @@ struct xfs_rtgroup;
>  #define XFS_OPEN_GC_ZONES	1U
>  #define XFS_MIN_OPEN_ZONES	(XFS_OPEN_GC_ZONES + 1U)
> 
> +/*
> + * For zoned device that do not have a limit on the number of open zones, and
	'For a zoned device' perhaps?
> + * for reguilar devices using the zoned allocator, use this value as the default

	regular

> + * limit on the number of open zones.

Perhaps it's also worth to mention you picked 128 for being the most
common limit on available SMR HDDs today, otherwise it would look as a
randomly chosen magic number (unless somebody bothers to check the git
log).

> + */
> +#define XFS_DEFAULT_MAX_OPEN_ZONES	128
> +
>  bool xfs_zone_validate(struct blk_zone *zone, struct xfs_rtgroup *rtg,
>  	xfs_rgblock_t *write_pointer);
> 
> diff --git a/fs/xfs/xfs_zone_alloc.c b/fs/xfs/xfs_zone_alloc.c
> index f152b2182004..1147bacb2da8 100644
> --- a/fs/xfs/xfs_zone_alloc.c
> +++ b/fs/xfs/xfs_zone_alloc.c
> @@ -1131,7 +1131,7 @@ xfs_calc_open_zones(
>  		if (bdev_open_zones)
>  			mp->m_max_open_zones = bdev_open_zones;
>  		else
> -			mp->m_max_open_zones = xfs_max_open_zones(mp);
> +			mp->m_max_open_zones = XFS_DEFAULT_MAX_OPEN_ZONES;
>  	}
> 
>  	if (mp->m_max_open_zones < XFS_MIN_OPEN_ZONES) {

Other than the nitpicks above, you can add:

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>


> --
> 2.51.0
> 
