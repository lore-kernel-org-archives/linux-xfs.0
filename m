Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67FC71D7E47
	for <linux-xfs@vger.kernel.org>; Mon, 27 Jan 2025 21:37:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738013865; cv=none; b=FYOMuuD9zRPmoOKmE5e298yN8cl/HIOzINZXphwExds+LH/FGRab8+80aCRpL2U0hTdg2SmPhHI/gRKXkgqVPFE1FiVdbaJu0a+p8piLQmdqC3K1jXgYFZSKatFh6UdIcFDQsteODt529Bf1HziwakYOO4wJtdmJFoVcivB682g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738013865; c=relaxed/simple;
	bh=DPTLQB/EXwTXShCO1vpPkKYl2QSljKxLumdA6RUuH0Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Q6C2htnEt9ybYaZuue1spxzptuLgvgo16EfdzgPVItFOP/JaDyiImqUhAQ2oaZKTPSlPD/KQ9ljUF5PMYGY2EVAXWlpteb7La0WEUmna+OWzovalfzAN9B84udHn/4ysx5rDUu1FpeQI//P3nRdr6p/QkWwhxeQjW/i2sPZ1rHc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bz0h5lZf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bz0h5lZf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6492C4CED2;
	Mon, 27 Jan 2025 21:37:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738013864;
	bh=DPTLQB/EXwTXShCO1vpPkKYl2QSljKxLumdA6RUuH0Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=bz0h5lZf031pEJt2niXMgpdY8wYNhQJfAC0oQDe3Ig3xYfDx6+2SU1Be/y4//lyP4
	 3JZM4hCM37ykGaZfzeGW1nCAn+v9f6uHAHsBTWXJZ0Td9rXo2ItyOpqlhXhpF34aHt
	 YNs8HzEPNYhT2w4VeXaLiFgOwZTTRaLonU7W5RHoU2Bu++/a/J2icV4zLZfv8iEx8j
	 QrlYPYvXtoDbcXi69wucuagcA+VWYKqnSTjhfPKFFd7HeD9sJ9ONhcYILWBdgXxwQv
	 qTvJEa7BK0OaXHz459kMFuswDoVyK1kMQAVXonOjRb5YJ7Vw1VGl2KWYbHENvX140s
	 Q9shyEEN12rBQ==
Date: Mon, 27 Jan 2025 13:37:44 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: aalbersh@redhat.com, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] mkfs: use a default sector size that is also suitable
 for the rtdev
Message-ID: <20250127213744.GK1611770@frogsfrogsfrogs>
References: <20250127135403.525965-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250127135403.525965-1-hch@lst.de>

On Mon, Jan 27, 2025 at 02:54:03PM +0100, Christoph Hellwig wrote:
> When creating a filesytem where the data device has a sector size
> smalle than that of the RT device without further options, mkfs
> currently fails with:
> 
> mkfs.xfs: error - cannot set blocksize 512 on block device $RTDEV: Invalid argument
> 
> This is because XFS sets the sector size based on logical block size
> of the data device, but not that of the RT device.  Change the code
> so that is uses the larger of the two values.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

That makes sense to me.
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  mkfs/xfs_mkfs.c | 16 ++++++++++++++--
>  1 file changed, 14 insertions(+), 2 deletions(-)
> 
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index 6cc7e6439ca1..0627af81da37 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -2368,7 +2368,9 @@ validate_sectorsize(
>  		 * advertised sector size of the device.  We use the physical
>  		 * sector size unless the requested block size is smaller
>  		 * than that, then we can use logical, but warn about the
> -		 * inefficiency.
> +		 * inefficiency.  If the file system has a RT device, the
> +		 * sectorsize needs to be the maximum of the data and RT
> +		 * device.
>  		 *
>  		 * Some architectures have a page size > XFS_MAX_SECTORSIZE.
>  		 * In that case, a ramdisk or persistent memory device may
> @@ -2378,8 +2380,18 @@ validate_sectorsize(
>  			ft->data.physical_sector_size =
>  				ft->data.logical_sector_size;
>  		}
> -
>  		cfg->sectorsize = ft->data.physical_sector_size;
> +
> +		if (cli->xi->rt.name) {
> +			if (ft->rt.physical_sector_size > XFS_MAX_SECTORSIZE) {
> +				ft->rt.physical_sector_size =
> +					ft->rt.logical_sector_size;
> +			}
> +
> +			if (cfg->sectorsize < ft->rt.physical_sector_size)
> +				cfg->sectorsize = ft->rt.physical_sector_size;
> +		}
> +
>  		if (cfg->blocksize < cfg->sectorsize &&
>  		    cfg->blocksize >= ft->data.logical_sector_size) {
>  			fprintf(stderr,
> -- 
> 2.45.2
> 
> 
