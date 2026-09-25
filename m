Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C6B5369D5C
	for <linux-xfs@vger.kernel.org>; Fri, 25 Sep 2026 23:32:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790379178; cv=none; b=Sm61b9zieriPNQp2+UjKd1Y8Vppjj1XA90HlowI9BlL2mrDRNruECB2jXymAJbfn9EiE4LwVX36UJaNAXUaPHx7F6IFlGtXH7oneG8+1WgSLiQW8CqkDA719k3H/ejH4UHvzPrz4qbV3JyyLnaRplJDPfC5bkv6HWwy80ESSr04=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790379178; c=relaxed/simple;
	bh=z5AHwa2nQP+YwD4Njc4YHtL3hpxxyiJTokA8HQW12pM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=edGsWTZkpzznyoAiR2tYGEIHT/pzjiBnWPoOYiJM0muG5VLM63BEGwkG2iV5DCYdxK31pDc9Mn16EQWZj5AkOJwHbzv732SXi7aAupR+d0undxz+vnDgGpRvDwisI3wA1XbbiMDN2i221zHYEibTh8usY1hHj+GflY1ZeCS15Kk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ARlVhjCR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ARlVhjCR"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 64AF41F000FF;
	Fri, 25 Sep 2026 23:32:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790379177;
	bh=oQ2vr1CtlGW+DpAW7qJYRsEmCbAh5ZcIQrq9QISBUZk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ARlVhjCR5I1RYWRrY8hl4awlx/qX3C1b2MlEIJKIU9ZXfrTw8iHR4KM/miuE8jAzb
	 7iyI4M8uXukvVo4VFQPq+qGaMVz4OzEH7XgMiAE7VBxCaJJa4W1/tVM6oa8JKgFlI9
	 ImWgqAQqsDB+KZmAc3rhpbXv8ofAkltmPQwUJJ6YqZaRhnRIzUS75cNzaxkhlQAXaY
	 jxNtwQ+TfafmF8Oym3DHMsk6Y+AdcTh/ZTLp1N2pwxuHkr649N2DI5HajOEOWW+vC1
	 ledBL1xLC4vM78P67aJ0nqj7yIwX9RrxFcUE3DMPreDm55MUkCt1OWqjmsni0UVjgU
	 snhPJE/PtQh+A==
Date: Fri, 25 Sep 2026 16:32:56 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Andrey Albershteyn <aalbersh@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 27/32] libfrog: print csum geometry information
Message-ID: <20260925233256.GM2705364@frogsfrogsfrogs>
References: <20260924100512.2733748-1-hch@lst.de>
 <20260924100512.2733748-28-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260924100512.2733748-28-hch@lst.de>

On Thu, Sep 24, 2026 at 12:04:17PM +0200, Christoph Hellwig wrote:
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good to me,
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  libfrog/fsgeom.c | 23 +++++++++++++++++++++--
>  1 file changed, 21 insertions(+), 2 deletions(-)
> 
> diff --git a/libfrog/fsgeom.c b/libfrog/fsgeom.c
> index ad0476741cf5..324ccdc9b84d 100644
> --- a/libfrog/fsgeom.c
> +++ b/libfrog/fsgeom.c
> @@ -28,6 +28,22 @@ rtdev_name(
>  	return rtname;
>  }
>  
> +static const char *
> +csum_name(
> +	uint8_t			csum)
> +{
> +	switch (csum) {
> +	case XFS_CSUM_TYPE_NONE:
> +		return "none";
> +	case XFS_CSUM_TYPE_CRC32C:
> +		return "crc32";
> +	case XFS_CSUM_TYPE_CRC64:
> +		return "crc64c";
> +	default:
> +		return "invalid";
> +	}
> +};
> +
>  void
>  xfs_report_geom(
>  	struct xfs_fsop_geom	*geo,
> @@ -91,7 +107,8 @@ xfs_report_geom(
>  "         =%-22s sectsz=%-5u sunit=%d blks, lazy-count=%d\n"
>  "realtime =%-22s extsz=%-6d blocks=%lld, rtextents=%lld\n"
>  "         =%-22s rgcount=%-4d rgsize=%u extents\n"
> -"         =%-22s zoned=%-6d start=%llu reserved=%llu\n"),
> +"         =%-22s zoned=%-6d start=%llu reserved=%llu\n"
> +"         =%-22s csum=%-7s csumbsize=%u\n"),
>  		mntpoint, geo->inodesize, geo->agcount, geo->agblocks,
>  		"", geo->sectsize, attrversion, projid32bit,
>  		"", crcs_enabled, finobt_enabled, spinodes, rmapbt_enabled,
> @@ -108,7 +125,9 @@ xfs_report_geom(
>  		geo->rtextsize * geo->blocksize, (unsigned long long)geo->rtblocks,
>  			(unsigned long long)geo->rtextents,
>  		"", geo->rgcount, geo->rgextents,
> -		"", zoned, geo->rtstart, geo->rtreserved);
> +		"", zoned, geo->rtstart, geo->rtreserved,
> +		"", csum_name(geo->rtcsum_type), geo->rtcsum_blklog ?
> +			(1u << geo->rtcsum_blklog) : 0);
>  }
>  
>  /* Try to obtain the xfs geometry.  On error returns a negative error code. */
> -- 
> 2.53.0
> 
> 
