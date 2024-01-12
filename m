Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 913037762B
	for <linux-xfs@vger.kernel.org>; Fri, 12 Jan 2024 16:53:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AZAASFm7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CF9AC433F1;
	Fri, 12 Jan 2024 16:53:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1705078416;
	bh=LrmxggWLZa9z4x+ODSPHRIuINdVBinbDEdv4hJag8HY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=AZAASFm7sXaEMBXCp5bhj9xthaYnUl91pp4QexQzXBrJcgrxdBLy46xmmDScBHHlN
	 RxPh2IRfEjUeizVfQLq73MqP1BVtoRStgubrhNAfOZ6xzo3mCRCynXb11YBqkAWQAy
	 4/oQ5q1NhJGykL3n968VrgwAbcNOSohBwYN56XJOaYA0EVNcWM7fU6yPv96fXI16lV
	 nI5yUMdKFpropILDxz9qf9+NWbJpjSealBrCKU3/4poCLNWq+F/7FKTZ0FzuhxtGEn
	 faknyu1BSGdD5D6wm/vo6ljP0inZaF3K6lJvaQReHaR/9rbv9GHbAAa8MBpzyj5byO
	 GOCImyS4ktoGA==
Date: Fri, 12 Jan 2024 08:53:35 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cmaiolino@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/4] mkfs: use a sensible log sector size default
Message-ID: <20240112165335.GX722975@frogsfrogsfrogs>
References: <20240112044743.2254211-1-hch@lst.de>
 <20240112044743.2254211-5-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240112044743.2254211-5-hch@lst.de>

On Fri, Jan 12, 2024 at 05:47:43AM +0100, Christoph Hellwig wrote:
> Currently the XFS log sector size defaults to the 512 bytes unless
> explicitly overriden.  Default to the device logical block size queried
> by get_topology instead.  If that is also 512 nothing changes, and if
> the device logical block size is larged this prevents a mkfs failure

                                   larger

> because the libxfs buffer cache blows up and as we obviously can't
> use a smaller than hardware supported sector size.  This fixes xfs/157
> with a 4k block size device.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  mkfs/xfs_mkfs.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index be65ccc1e..022a11a7f 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -2075,7 +2075,8 @@ static void
>  validate_log_sectorsize(
>  	struct mkfs_params	*cfg,
>  	struct cli_params	*cli,
> -	struct mkfs_default_params *dft)
> +	struct mkfs_default_params *dft,
> +	struct fs_topology	*ft)
>  {
>  
>  	if (cli->loginternal && cli->lsectorsize &&
> @@ -2090,7 +2091,7 @@ _("Can't change sector size on internal log!\n"));
>  	else if (cli->loginternal)
>  		cfg->lsectorsize = cfg->sectorsize;
>  	else
> -		cfg->lsectorsize = dft->sectorsize;
> +		cfg->lsectorsize = ft->log.logical_sector_size;

Yessssssssss!

With the typo fixed,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

>  	cfg->lsectorlog = libxfs_highbit32(cfg->lsectorsize);
>  
>  	if (cfg->lsectorsize < XFS_MIN_SECTORSIZE ||
> @@ -4196,7 +4197,7 @@ main(
>  	blocksize = cfg.blocksize;
>  	sectorsize = cfg.sectorsize;
>  
> -	validate_log_sectorsize(&cfg, &cli, &dft);
> +	validate_log_sectorsize(&cfg, &cli, &dft, &ft);
>  	validate_sb_features(&cfg, &cli);
>  
>  	/*
> -- 
> 2.39.2
> 
> 
