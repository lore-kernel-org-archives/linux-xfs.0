Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A54643146
	for <linux-xfs@vger.kernel.org>; Tue, 15 Apr 2025 00:40:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744677620; cv=none; b=lCIZncT/KNTo9zBniQQXAkS1qyXJNu86caiXOqu3VqvOn0ivI7tBkK1Avz6Dua96QtLG4oxMtYW6Q2nBXGCylj88KauLa4taOqH1jlXT7TUYwu8rNmNgJcIRTps/BHpeU1wqvs9Y2OooKv/J84Aj4uSe8nezaLsvkSld4nbP9xE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744677620; c=relaxed/simple;
	bh=/3dQKjQSHnxB4W1AqxtcJ9rpexdTVM4tUhCdyEbHfMw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NN72RmwuHzjZldp20f00d4VuG3eotsaJV9oijAlbILgQ+JofQSCNZddF1ttbRXzNV5fuAuBl2xn/xWjnNPs/+VLElYWBC9da47OcdEEIzkk7Zdex6x9HpVAUnyBM2SCYJEjSiU3arPa8F4V7RsIb/hKFSdRmu+VIZRUYWH2du8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Vf/vuQ7P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Vf/vuQ7P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6757AC4CEE2;
	Tue, 15 Apr 2025 00:40:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744677619;
	bh=/3dQKjQSHnxB4W1AqxtcJ9rpexdTVM4tUhCdyEbHfMw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Vf/vuQ7P20SslYzx+PZQiesTVilFas3u+xKLUkcbZJTK66tp4lH9ATxpCkVlMt60g
	 kKRQciqyk/REhYoVhHUeZOT/tZqT/L4SPQajyKgyAf4VpJkY3DH6iYHBS0nWcT4lNx
	 VU3XGHv4Xlgg3Pf4zxvyz+siqlfHvhQdOoAP3DlQXpBl7eOmJD2ZXyGlhE4F8YAjAS
	 Z/ClOwjOfg22tACOpA2ncDr9IzkBmDqxzqmoCtYzMZ8o2yO/UIYE6D2Q8wCRdIvqMc
	 p59gWJqwZwW8maX1g5/CoSR6iP6YiUOxzBiEcUHLwVq19yS8nKwisdrk0ZuXuOFI4W
	 WNCwFf2yKNHAQ==
Date: Mon, 14 Apr 2025 17:40:18 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Andrey Albershteyn <aalbersh@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 30/43] xfs_mkfs: factor out a validate_rtgroup_geometry
 helper
Message-ID: <20250415004018.GM25675@frogsfrogsfrogs>
References: <20250414053629.360672-1-hch@lst.de>
 <20250414053629.360672-31-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250414053629.360672-31-hch@lst.de>

On Mon, Apr 14, 2025 at 07:36:13AM +0200, Christoph Hellwig wrote:
> Factor out the rtgroup geometry checks so that they can be easily reused
> for the upcoming zoned RT allocator support.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Pretty straightforward, thanks for taking the time to disentangle this!
:)
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  mkfs/xfs_mkfs.c | 67 +++++++++++++++++++++++++++----------------------
>  1 file changed, 37 insertions(+), 30 deletions(-)
> 
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index ec82e05bf4e4..13b746b365e1 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -3950,6 +3950,42 @@ out:
>  	cfg->rgcount = howmany(cfg->rtblocks, cfg->rgsize);
>  }
>  
> +static void
> +validate_rtgroup_geometry(
> +	struct mkfs_params	*cfg)
> +{
> +	if (cfg->rgsize > XFS_MAX_RGBLOCKS) {
> +		fprintf(stderr,
> +_("realtime group size (%llu) must be less than the maximum (%u)\n"),
> +				(unsigned long long)cfg->rgsize,
> +				XFS_MAX_RGBLOCKS);
> +		usage();
> +	}
> +
> +	if (cfg->rgsize % cfg->rtextblocks != 0) {
> +		fprintf(stderr,
> +_("realtime group size (%llu) not a multiple of rt extent size (%llu)\n"),
> +				(unsigned long long)cfg->rgsize,
> +				(unsigned long long)cfg->rtextblocks);
> +		usage();
> +	}
> +
> +	if (cfg->rgsize <= cfg->rtextblocks) {
> +		fprintf(stderr,
> +_("realtime group size (%llu) must be at least two realtime extents\n"),
> +				(unsigned long long)cfg->rgsize);
> +		usage();
> +	}
> +
> +	if (cfg->rgcount > XFS_MAX_RGNUMBER) {
> +		fprintf(stderr,
> +_("realtime group count (%llu) must be less than the maximum (%u)\n"),
> +				(unsigned long long)cfg->rgcount,
> +				XFS_MAX_RGNUMBER);
> +		usage();
> +	}
> +}
> +
>  static void
>  calculate_rtgroup_geometry(
>  	struct mkfs_params	*cfg,
> @@ -4007,36 +4043,7 @@ _("rgsize (%s) not a multiple of fs blk size (%d)\n"),
>  				(cfg->rtblocks % cfg->rgsize != 0);
>  	}
>  
> -	if (cfg->rgsize > XFS_MAX_RGBLOCKS) {
> -		fprintf(stderr,
> -_("realtime group size (%llu) must be less than the maximum (%u)\n"),
> -				(unsigned long long)cfg->rgsize,
> -				XFS_MAX_RGBLOCKS);
> -		usage();
> -	}
> -
> -	if (cfg->rgsize % cfg->rtextblocks != 0) {
> -		fprintf(stderr,
> -_("realtime group size (%llu) not a multiple of rt extent size (%llu)\n"),
> -				(unsigned long long)cfg->rgsize,
> -				(unsigned long long)cfg->rtextblocks);
> -		usage();
> -	}
> -
> -	if (cfg->rgsize <= cfg->rtextblocks) {
> -		fprintf(stderr,
> -_("realtime group size (%llu) must be at least two realtime extents\n"),
> -				(unsigned long long)cfg->rgsize);
> -		usage();
> -	}
> -
> -	if (cfg->rgcount > XFS_MAX_RGNUMBER) {
> -		fprintf(stderr,
> -_("realtime group count (%llu) must be less than the maximum (%u)\n"),
> -				(unsigned long long)cfg->rgcount,
> -				XFS_MAX_RGNUMBER);
> -		usage();
> -	}
> +	validate_rtgroup_geometry(cfg);
>  
>  	if (cfg->rtextents)
>  		cfg->rtbmblocks = howmany(cfg->rgsize / cfg->rtextblocks,
> -- 
> 2.47.2
> 
> 
