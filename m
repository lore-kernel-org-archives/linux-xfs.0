Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 401D9226D05
	for <linux-xfs@vger.kernel.org>; Fri, 25 Sep 2026 22:33:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790375596; cv=none; b=h2u3/BgkWeIA+DqEIxaokRbD2+8AtTnw3MvnqRBF9nzqS85css+Y4g6CvnXbrsm2dshD6BLaciDbn/+T6YzedGqmciiSnPFD43inoK4yKjcj66ERNpHWYnkfmSze+Dh2ygN/fTsAxxZGHXMMDONRRLRw/VffA3+iOAoobP3sjZs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790375596; c=relaxed/simple;
	bh=Zq5m4M026msy0j8XGXkZ7q9oa1tkZ3qKsEOCB8KNq00=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sftSo7L4Kc/5Tz0gJPSdc4vKZZjl8W5cpIqIXdLsb0QLxOHOq7yOcEAQwrTQiuRDQljR3UaIvDNyB6w82xTbecW48PaxVN7wZaNXg1LRSAMyqlyegWDeO/IXC287zFMvI6/MvAoxwjtHP1kjRNlwpMc6+sYT4GGs90Hx6mZeJFQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LLDTRhpr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LLDTRhpr"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 9AC351F000FF;
	Fri, 25 Sep 2026 22:33:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790375594;
	bh=z40AEoZCH6dwe9Vwa1E/Fg+Vb9/wjO/oLiaY+k30/Oo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=LLDTRhprT1MtmW5NO2/T7SZTNMJjy3JYh0e8sE2My3d5/nqB+hnuGnxKg5zlliqWH
	 ZyJ5Nid3OvhDeeDimLJ+eztbv4wzQohIyopRceRcGh3RPXb35qDaP2s6v5OHtOEMcQ
	 YOwlKT0floDHCM1rKTqoNJ+OcsgzgsvtIMESgwQX1BKURowuUQSZBhDcXFWB2PbVDP
	 2zR2uKHT3W7kSYIn7itgFlcf8OK2qYHtdQYzEfif+0VjocCeXGx1DIyBd2b+XsLfIy
	 psHnPPgOwWyBZExEz8QemDrTBOeAr5LQ/KXbyuOmQtwOKSS3B3iBIAxrz3yImm8YDw
	 AUO78Fg6QNFuw==
Date: Fri, 25 Sep 2026 15:33:14 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Andrey Albershteyn <aalbersh@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 02/10] libxfs: split error injection option parsing out
 of libxfs_buftarg_init
Message-ID: <20260925223314.GR2705364@frogsfrogsfrogs>
References: <20260925051336.2997014-1-hch@lst.de>
 <20260925051336.2997014-3-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260925051336.2997014-3-hch@lst.de>

On Fri, Sep 25, 2026 at 07:12:48AM +0200, Christoph Hellwig wrote:
> Add a separate helper to keep this debug code separate from the main
> initialization flow, and only set up the error injection once when
> in libxfs_mount, thus skipping it for sb probing.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Much nicer, thanks for cleaning that up :)
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  libxfs/init.c | 102 +++++++++++++++++++++++++-------------------------
>  1 file changed, 51 insertions(+), 51 deletions(-)
> 
> diff --git a/libxfs/init.c b/libxfs/init.c
> index 63015badc24e..1b5e1e1e8ba8 100644
> --- a/libxfs/init.c
> +++ b/libxfs/init.c
> @@ -445,8 +445,7 @@ static struct xfs_buftarg *
>  libxfs_buftarg_alloc(
>  	struct xfs_mount	*mp,
>  	struct libxfs_init	*xi,
> -	struct libxfs_dev	*dev,
> -	unsigned long		write_fails)
> +	struct libxfs_dev	*dev)
>  {
>  	struct xfs_buftarg	*btp;
>  
> @@ -461,10 +460,6 @@ libxfs_buftarg_alloc(
>  	btp->bt_bdev_fd = dev->fd;
>  	btp->bt_xfile = NULL;
>  	btp->flags = 0;
> -	if (write_fails) {
> -		btp->writes_left = write_fails;
> -		btp->flags |= XFS_BUFTARG_INJECT_WRITE_FAIL;
> -	}
>  	pthread_mutex_init(&btp->lock, NULL);
>  
>  	btp->bcache = cache_init(xi->bcache_flags, libxfs_bhash_size,
> @@ -487,6 +482,52 @@ static char *wf_opts[] = {
>  	[WF_MAX_OPTS]		= NULL,
>  };
>  
> +static void
> +setup_buftarg_write_error(
> +	struct xfs_buftarg	*btp,
> +	char			*val)
> +{
> +	if (!val) {
> +		fprintf(stderr, _("write fail requires a parameter\n"));
> +		exit(1);
> +	}
> +	if (!btp)
> +		return;
> +	btp->writes_left = strtoul(val, NULL, 0);
> +	if (btp->writes_left)
> +		btp->flags |= XFS_BUFTARG_INJECT_WRITE_FAIL;
> +}
> +
> +static void
> +libxfs_setup_write_error_injection(
> +	struct xfs_mount	*mp)
> +{
> +	char			*p = getenv("LIBXFS_DEBUG_WRITE_CRASH");
> +
> +	/* Simulate utility crash after a certain number of writes. */
> +	while (p && *p) {
> +		char *val;
> +
> +		switch (getsubopt(&p, wf_opts, &val)) {
> +		case WF_DATA:
> +			setup_buftarg_write_error(mp->m_ddev_targp, val);
> +			break;
> +		case WF_LOG:
> +			setup_buftarg_write_error(mp->m_logdev_targp, val);
> +			break;
> +		case WF_RT:
> +			if (mp->m_rtdev_targp == mp->m_ddev_targp)
> +				break;
> +			setup_buftarg_write_error(mp->m_rtdev_targp, val);
> +			break;
> +		default:
> +			fprintf(stderr, _("unknown write fail type %s\n"), val);
> +			exit(1);
> +			break;
> +		}
> +	}
> +}
> +
>  static void
>  libxfs_buftarg_reinit(
>  	struct xfs_mount	*mp,
> @@ -529,46 +570,6 @@ libxfs_buftarg_init(
>  	struct xfs_mount	*mp,
>  	struct libxfs_init	*xi)
>  {
> -	char			*p = getenv("LIBXFS_DEBUG_WRITE_CRASH");
> -	unsigned long		dfail = 0, lfail = 0, rfail = 0;
> -
> -	/* Simulate utility crash after a certain number of writes. */
> -	while (p && *p) {
> -		char *val;
> -
> -		switch (getsubopt(&p, wf_opts, &val)) {
> -		case WF_DATA:
> -			if (!val) {
> -				fprintf(stderr,
> -		_("ddev write fail requires a parameter\n"));
> -				exit(1);
> -			}
> -			dfail = strtoul(val, NULL, 0);
> -			break;
> -		case WF_LOG:
> -			if (!val) {
> -				fprintf(stderr,
> -		_("logdev write fail requires a parameter\n"));
> -				exit(1);
> -			}
> -			lfail = strtoul(val, NULL, 0);
> -			break;
> -		case WF_RT:
> -			if (!val) {
> -				fprintf(stderr,
> -		_("rtdev write fail requires a parameter\n"));
> -				exit(1);
> -			}
> -			rfail = strtoul(val, NULL, 0);
> -			break;
> -		default:
> -			fprintf(stderr, _("unknown write fail type %s\n"),
> -					val);
> -			exit(1);
> -			break;
> -		}
> -	}
> -
>  	/*
>  	 * This can happen if the utility called libxfs_buftarg_init manually
>  	 * before libxfs_mount, which calls us again.
> @@ -581,17 +582,15 @@ libxfs_buftarg_init(
>  		return;
>  	}
>  
> -	mp->m_ddev_targp = libxfs_buftarg_alloc(mp, xi, &xi->data, dfail);
> +	mp->m_ddev_targp = libxfs_buftarg_alloc(mp, xi, &xi->data);
>  	if (!xi->log.dev || xi->log.dev == xi->data.dev)
>  		mp->m_logdev_targp = mp->m_ddev_targp;
>  	else
> -		mp->m_logdev_targp = libxfs_buftarg_alloc(mp, xi, &xi->log,
> -				lfail);
> +		mp->m_logdev_targp = libxfs_buftarg_alloc(mp, xi, &xi->log);
>  	if (!xi->rt.dev || xi->rt.dev == xi->data.dev)
>  		mp->m_rtdev_targp = mp->m_ddev_targp;
>  	else
> -		mp->m_rtdev_targp = libxfs_buftarg_alloc(mp, xi, &xi->rt,
> -				rfail);
> +		mp->m_rtdev_targp = libxfs_buftarg_alloc(mp, xi, &xi->rt);
>  }
>  
>  /* Compute maximum possible height for per-AG btree types for this fs. */
> @@ -740,6 +739,7 @@ libxfs_mount(
>  	if (flags & LIBXFS_MOUNT_REPORT_CORRUPTION)
>  		xfs_set_reporting_corruption(mp);
>  	libxfs_buftarg_init(mp, xi);
> +	libxfs_setup_write_error_injection(mp);
>  
>  	if (xi->data.name)
>  		mp->m_fsname = strdup(xi->data.name);
> -- 
> 2.53.0
> 
> 
