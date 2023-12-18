Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0135B125A1
	for <linux-xfs@vger.kernel.org>; Mon, 18 Dec 2023 09:23:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CiElS5jw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9345C433C8;
	Mon, 18 Dec 2023 09:23:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1702891423;
	bh=tIy2fuVgXt54BooTirFiT7zhisx9jZNmTD1ju/JH1xI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=CiElS5jwiXVGS0RiC6L7bBrmqPs0CacShN/T7liL/qZhJmBT54PUFI39bv+c7qhFd
	 G3wbiQAVrL4XVWwBqs3E0Ytxe6iNem6gPYD0D5i0eBx8ZbxabLViZ7l0GuWiSEcO5Q
	 A8dRbLEIdJjGgGQR95mSSzDS0oTNFRUG2XbxWKVrsy9IdeiByTW4UdW1LVjNE6sFFx
	 usvriiSdIYV3DSyERezhn4Rqti6iPlaRxxZ/UbppwLHkpCETv+mjIOZucJkm83pm5K
	 xqCDFK20qG8eFuqhj2CSsbLmJlzJkEGgUjklThiAAVL0/pPx1/CjnsV9gIL3tSCm8A
	 HHoGTX18V98Og==
Date: Mon, 18 Dec 2023 10:23:39 +0100
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 13/23] libxfs: merge the file vs device cases in
 libxfs_init
Message-ID: <mtlvntnhktogrrgivbrrcxj3goot42mff3nvjcuauflamgmsyx@ondqhe7e6n73>
References: <20231211163742.837427-1-hch@lst.de>
 <4Sqd1FPWto1vyT5WdaxNk84Bqi6l4r_MfRwGnqVUNJQEPeMbyuyURgEyO-B7WKIqrksiFGy4L0AM-dx832bD2A==@protonmail.internalid>
 <20231211163742.837427-14-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231211163742.837427-14-hch@lst.de>

On Mon, Dec 11, 2023 at 05:37:32PM +0100, Christoph Hellwig wrote:
> The only special handling for an XFS device on a regular file is that
> we skip the checks in check_open.  Simplify perform those conditionally
> instead of duplicating the entire sequence.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

> ---
>  libxfs/init.c | 74 ++++++++++++++++-----------------------------------
>  1 file changed, 23 insertions(+), 51 deletions(-)
> 
> diff --git a/libxfs/init.c b/libxfs/init.c
> index 14962b9fa..86b810bfe 100644
> --- a/libxfs/init.c
> +++ b/libxfs/init.c
> @@ -313,59 +313,31 @@ libxfs_init(struct libxfs_init *a)
>  	radix_tree_init();
> 
>  	if (dname) {
> -		if (a->disfile) {
> -			a->ddev= libxfs_device_open(dname, a->dcreat, flags,
> -						    a->setblksize);
> -			a->dfd = libxfs_device_to_fd(a->ddev);
> -			platform_findsizes(dname, a->dfd, &a->dsize,
> -					   &a->dbsize);
> -		} else {
> -			if (!check_open(dname, flags))
> -				goto done;
> -			a->ddev = libxfs_device_open(dname,
> -					a->dcreat, flags, a->setblksize);
> -			a->dfd = libxfs_device_to_fd(a->ddev);
> -			platform_findsizes(dname, a->dfd,
> -					   &a->dsize, &a->dbsize);
> -		}
> -	} else
> -		a->dsize = 0;
> +		if (!a->disfile && !check_open(dname, flags))
> +			goto done;
> +		a->ddev = libxfs_device_open(dname, a->dcreat, flags,
> +				a->setblksize);
> +		a->dfd = libxfs_device_to_fd(a->ddev);
> +		platform_findsizes(dname, a->dfd, &a->dsize, &a->dbsize);
> +	}
>  	if (logname) {
> -		if (a->lisfile) {
> -			a->logdev = libxfs_device_open(logname,
> -					a->lcreat, flags, a->setblksize);
> -			a->logfd = libxfs_device_to_fd(a->logdev);
> -			platform_findsizes(dname, a->logfd, &a->logBBsize,
> -					   &a->lbsize);
> -		} else {
> -			if (!check_open(logname, flags))
> -				goto done;
> -			a->logdev = libxfs_device_open(logname,
> -					a->lcreat, flags, a->setblksize);
> -			a->logfd = libxfs_device_to_fd(a->logdev);
> -			platform_findsizes(logname, a->logfd,
> -					   &a->logBBsize, &a->lbsize);
> -		}
> -	} else
> -		a->logBBsize = 0;
> +		if (!a->lisfile && !check_open(logname, flags))
> +			goto done;
> +		a->logdev = libxfs_device_open(logname, a->lcreat, flags,
> +				a->setblksize);
> +		a->logfd = libxfs_device_to_fd(a->logdev);
> +		platform_findsizes(logname, a->logfd, &a->logBBsize,
> +				&a->lbsize);
> +	}
>  	if (rtname) {
> -		if (a->risfile) {
> -			a->rtdev = libxfs_device_open(rtname,
> -					a->rcreat, flags, a->setblksize);
> -			a->rtfd = libxfs_device_to_fd(a->rtdev);
> -			platform_findsizes(dname, a->rtfd, &a->rtsize,
> -					   &a->rtbsize);
> -		} else {
> -			if (!check_open(rtname, flags))
> -				goto done;
> -			a->rtdev = libxfs_device_open(rtname,
> -					a->rcreat, flags, a->setblksize);
> -			a->rtfd = libxfs_device_to_fd(a->rtdev);
> -			platform_findsizes(rtname, a->rtfd,
> -					   &a->rtsize, &a->rtbsize);
> -		}
> -	} else
> -		a->rtsize = 0;
> +		if (a->risfile && !check_open(rtname, flags))
> +			goto done;
> +		a->rtdev = libxfs_device_open(rtname, a->rcreat, flags,
> +				a->setblksize);
> +		a->rtfd = libxfs_device_to_fd(a->rtdev);
> +		platform_findsizes(dname, a->rtfd, &a->rtsize, &a->rtbsize);
> +	}
> +
>  	if (a->dsize < 0) {
>  		fprintf(stderr, _("%s: can't get size for data subvolume\n"),
>  			progname);
> --
> 2.39.2
> 
