Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D3A3325737
	for <linux-xfs@vger.kernel.org>; Wed, 29 Oct 2025 15:38:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761752304; cv=none; b=bVK3MIv5zyJaFlpEEUL17uf9xCTbxSe3UE0ubbe47xEpIzV0KZVy44xUDAjNzMO+Q4Ghxqs4tzjfS3rGaao7q4xIglVoNbGaHJTSao42iKxJYOyaeuHl2zmn5wpf2/jYqr/OqZPwk76OA5G3AOAYNhWaY0WmccNTQq2S1Fe79nA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761752304; c=relaxed/simple;
	bh=JPd10LxnfUDSzA3Q7LHQGKN1zEztW60kTUiIx6tRHws=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LcPjCCGTuzdJ5uRCgLQsj4omcduQ20j/L7T/uKrn1T63ZNu0u4qWtB8bDHSVMUtCTS8GOr3Ni074tcPUnfAJLhMVKzJiowqQHXMTA2nxB0UP1gY46Fmc3InEcFhc9iATO5Ln9IZ2LqtlvflKCIF/dbBollKYBVUdPw5pDIM1tMA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dQ+BJqYP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dQ+BJqYP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 088F5C4CEF7;
	Wed, 29 Oct 2025 15:38:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761752304;
	bh=JPd10LxnfUDSzA3Q7LHQGKN1zEztW60kTUiIx6tRHws=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=dQ+BJqYPNxveSoirqOOPH+hcY5ioSmHadlGrxXqTg5nxiNsaXxf1tziVIqk5knd9o
	 4J1OLgngCCe6KzhALJ+LZw49jtpLnMmUvZN2t3h+SxkmkNUyPnQVyJYgugzdUCcXVj
	 FVVVR7/BmfvU9wLnjfYHY/1lE36Hki5Uqk6iDXqgwC9ho5hEtnOT1zg5+SV0CqFVne
	 EVZIz+Ntkpz+ivx1X3yZMDptOJioQs2vHeZ9V0YQiTEOw/PHlqs9nbrk9wQlByXa/u
	 mRRzsm/Q472b2S6bd+QHC36yDL48rYOVwYtD/g07A049RUqpZXU/YVjK4YkmwNfSwz
	 9JrCIWz5Q8S6A==
Date: Wed, 29 Oct 2025 08:38:23 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Andrey Albershteyn <aalbersh@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/4] mkfs: move clearing LIBXFS_DIRECT into
 check_device_type
Message-ID: <20251029153823.GX3356773@frogsfrogsfrogs>
References: <20251029090737.1164049-1-hch@lst.de>
 <20251029090737.1164049-2-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251029090737.1164049-2-hch@lst.de>

On Wed, Oct 29, 2025 at 10:07:29AM +0100, Christoph Hellwig wrote:
> Keep it close to the block device vs regular file logic and remove
> the checks for each device in the caller.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

I guess it makes sense to move the clearing of LIBXFS_DIRECT to where we
determine that one of the device paths pointed to a regular file...

Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  mkfs/xfs_mkfs.c | 27 ++++++++++++++-------------
>  1 file changed, 14 insertions(+), 13 deletions(-)
> 
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index cb7c20e3aa18..3ccd37920321 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -1330,6 +1330,7 @@ nr_cpus(void)
>  
>  static void
>  check_device_type(
> +	struct cli_params	*cli,
>  	struct libxfs_dev	*dev,
>  	bool			no_size,
>  	bool			dry_run,
> @@ -1375,6 +1376,13 @@ check_device_type(
>  			dev->isfile = 1;
>  		else if (!dry_run)
>  			dev->create = 1;
> +
> +		/*
> +		 * Explicitly disable direct IO for image files so we don't
> +		 * error out on sector size mismatches between the new
> +		 * filesystem and the underlying host filesystem.
> +		 */
> +		cli->xi->flags &= ~LIBXFS_DIRECT;
>  		return;
>  	}
>  
> @@ -2378,21 +2386,14 @@ validate_sectorsize(
>  	 * Before anything else, verify that we are correctly operating on
>  	 * files or block devices and set the control parameters correctly.
>  	 */
> -	check_device_type(&cli->xi->data, !cli->dsize, dry_run, "data", "d");
> +	check_device_type(cli, &cli->xi->data, !cli->dsize, dry_run,
> +			"data", "d");
>  	if (!cli->loginternal)
> -		check_device_type(&cli->xi->log, !cli->logsize, dry_run, "log",
> -				"l");
> +		check_device_type(cli, &cli->xi->log, !cli->logsize, dry_run,
> +				"log", "l");
>  	if (cli->xi->rt.name)
> -		check_device_type(&cli->xi->rt, !cli->rtsize, dry_run, "RT",
> -				"r");
> -
> -	/*
> -	 * Explicitly disable direct IO for image files so we don't error out on
> -	 * sector size mismatches between the new filesystem and the underlying
> -	 * host filesystem.
> -	 */
> -	if (cli->xi->data.isfile || cli->xi->log.isfile || cli->xi->rt.isfile)
> -		cli->xi->flags &= ~LIBXFS_DIRECT;
> +		check_device_type(cli, &cli->xi->rt, !cli->rtsize, dry_run,
> +				"RT", "r");
>  
>  	memset(ft, 0, sizeof(*ft));
>  	get_topology(cli->xi, ft, force_overwrite);
> -- 
> 2.47.3
> 
> 
