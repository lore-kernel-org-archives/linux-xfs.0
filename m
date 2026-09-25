Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B10747884F
	for <linux-xfs@vger.kernel.org>; Fri, 25 Sep 2026 22:32:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790375526; cv=none; b=diI29Oqofb3af5dMPTOwqga0D0HCEfGX7iBuiVn3nXGu3PbtjynQADrsCWYTtDr6HAx/VblXSTiFtSJ0hX1kx/ky0Uh2sIn2CbNT73HB/Bie6j/11R21I2ij2YCUM1F41m0FEupNPeVuy08i5QV9QHyRfGIk3ej+kVTTWvQLXwg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790375526; c=relaxed/simple;
	bh=knKyGkf90/6B4KMXUv7A5RzXAN99AEE2wPF406iW0kE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Arg3KKRzW8E8ZkfFnmfg9WnRACb8Ue3MzbzlyY5vVq/FrYd1FNqUw8v9a21dV0jE2SBedNd04kSwkRWiQVEav1Tr3EpJVmS2EfAX7cHm/x56zz4I+kWDS11aIpxqpXjwc/xherZF+J4w5Gwo2ylO5PkIdg+2UYg9ksZUqBFuZnc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=W6j7jCnt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="W6j7jCnt"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 892651F00893;
	Fri, 25 Sep 2026 22:32:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790375522;
	bh=1bI3/UpobmFOqx+KBeJKkQ80b+IAhUkuvBUBJ4Q//44=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=W6j7jCntS+zpWk4ysVn5E5/7m11s0PL+ufOpAkQttA2Rh+yHyow2/H0Bf+KlWNKyP
	 BAR7HLyGnNFgI4IQMNMJD3pb8dgOiP237+VoHpOui2g/giX4m6+Lj6p/jyppKQXPHx
	 AK7qgP8Bf+G1NAKlwrydTa43F1UNdkKU8hWHlxxrMTy71m6Dhq8jwq/Er78zrSjqle
	 TO2rtwO5wHsBazJpxkXj+DcA/TClnHxSboGTVsZFhlEkiCMbZd3d+VIyNal2cW7ePe
	 1lWAHyKyGpXqVGA/97Mqr58Q8sn53QVEh8PmedV3qEeRPm9Z+KqoFjZrqNBJjXHNMh
	 H59DHYI59jmFw==
Date: Fri, 25 Sep 2026 15:32:02 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Andrey Albershteyn <aalbersh@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 01/10] libxfs: refactor the reinit case in
 libxfs_buftarg_init
Message-ID: <20260925223202.GQ2705364@frogsfrogsfrogs>
References: <20260925051336.2997014-1-hch@lst.de>
 <20260925051336.2997014-2-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260925051336.2997014-2-hch@lst.de>

On Fri, Sep 25, 2026 at 07:12:47AM +0200, Christoph Hellwig wrote:
> I had to wade through this to understand what is going on here.  Factor
> the reinit code into a well-name helper and dump the rationale for it
> into a comment to make it easier for the next person to understand the
> logic.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Straightforward hoist, so
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  libxfs/init.c | 75 ++++++++++++++++++++++++++++++---------------------
>  1 file changed, 45 insertions(+), 30 deletions(-)
> 
> diff --git a/libxfs/init.c b/libxfs/init.c
> index b89c9fe360d4..63015badc24e 100644
> --- a/libxfs/init.c
> +++ b/libxfs/init.c
> @@ -487,6 +487,43 @@ static char *wf_opts[] = {
>  	[WF_MAX_OPTS]		= NULL,
>  };
>  
> +static void
> +libxfs_buftarg_reinit(
> +	struct xfs_mount	*mp,
> +	struct libxfs_init	*xi)
> +{
> +	if (mp->m_ddev_targp->bt_bdev != xi->data.dev ||
> +	    mp->m_ddev_targp->bt_mount != mp) {
> +		fprintf(stderr,
> +			_("%s: bad buftarg reinit, ddev\n"),
> +			progname);
> +		exit(1);
> +	}
> +
> +	if (!xi->log.dev || xi->log.dev == xi->data.dev) {
> +		if (mp->m_logdev_targp != mp->m_ddev_targp) {
> +			fprintf(stderr,
> +			_("%s: bad buftarg reinit, ldev mismatch\n"),
> +				progname);
> +			exit(1);
> +		}
> +	} else if (mp->m_logdev_targp->bt_bdev != xi->log.dev ||
> +		   mp->m_logdev_targp->bt_mount != mp) {
> +		fprintf(stderr,
> +			_("%s: bad buftarg reinit, logdev\n"),
> +			progname);
> +		exit(1);
> +	}
> +	if ((xi->rt.dev || xi->rt.dev == xi->data.dev) &&
> +	    (mp->m_rtdev_targp->bt_bdev != xi->rt.dev ||
> +	     mp->m_rtdev_targp->bt_mount != mp)) {
> +		fprintf(stderr,
> +			_("%s: bad buftarg reinit, rtdev\n"),
> +			progname);
> +		exit(1);
> +	}
> +}
> +
>  void
>  libxfs_buftarg_init(
>  	struct xfs_mount	*mp,
> @@ -532,37 +569,15 @@ libxfs_buftarg_init(
>  		}
>  	}
>  
> +	/*
> +	 * This can happen if the utility called libxfs_buftarg_init manually
> +	 * before libxfs_mount, which calls us again.
> +	 *
> +	 * In this case all buftargs should be initialized already, and we just
> +	 * ensure the values are sane and match the current mount.
> +	 */
>  	if (mp->m_ddev_targp) {
> -		/* should already have all buftargs initialised */
> -		if (mp->m_ddev_targp->bt_bdev != xi->data.dev ||
> -		    mp->m_ddev_targp->bt_mount != mp) {
> -			fprintf(stderr,
> -				_("%s: bad buftarg reinit, ddev\n"),
> -				progname);
> -			exit(1);
> -		}
> -		if (!xi->log.dev || xi->log.dev == xi->data.dev) {
> -			if (mp->m_logdev_targp != mp->m_ddev_targp) {
> -				fprintf(stderr,
> -				_("%s: bad buftarg reinit, ldev mismatch\n"),
> -					progname);
> -				exit(1);
> -			}
> -		} else if (mp->m_logdev_targp->bt_bdev != xi->log.dev ||
> -			   mp->m_logdev_targp->bt_mount != mp) {
> -			fprintf(stderr,
> -				_("%s: bad buftarg reinit, logdev\n"),
> -				progname);
> -			exit(1);
> -		}
> -		if ((xi->rt.dev || xi->rt.dev == xi->data.dev) &&
> -		    (mp->m_rtdev_targp->bt_bdev != xi->rt.dev ||
> -		     mp->m_rtdev_targp->bt_mount != mp)) {
> -			fprintf(stderr,
> -				_("%s: bad buftarg reinit, rtdev\n"),
> -				progname);
> -			exit(1);
> -		}
> +		libxfs_buftarg_reinit(mp, xi);
>  		return;
>  	}
>  
> -- 
> 2.53.0
> 
> 
