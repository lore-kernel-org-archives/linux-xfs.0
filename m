Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 293C7196C7C
	for <linux-xfs@vger.kernel.org>; Thu, 28 May 2026 08:14:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779956099; cv=none; b=gk/OZdiUh2A/pzBWKaDxhVBpBZ5f36ru2iPHXd2WrqxxGRw1nU0Ku0X3H/gRCmauzxa1OpyObBJVjbUp63BIHNniIBqBZ0IHHGpizdI11mW2ISgjT84pZxZau5cN0iJrsmj6Gbaj+GgZaIjVvj+HkcZppmuXdfjhJgvX8JfW2dA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779956099; c=relaxed/simple;
	bh=HmcZ3VApbDy/lXQdmkOjNfPHm8YZ9+QvNAFUa84Hwbw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dljYLcczUWIRravd+eTpnhSw6OF9UaIhczHNKVOBhhUZ1PJojvobBCqcw5fbLHPEDYqHWJS9jgAGxKTi7+BS2v9V+LN8mk3TmXqSMeBzCIL9SEk6PXsssSmpUhtyMIib1D9i5ViCqmse9NrSNt6vb3Q2sEIQX1dQw1eKr8ETEzg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AnEm0lQg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AnEm0lQg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 137861F00A3A;
	Thu, 28 May 2026 08:14:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779956097;
	bh=XDDarSC93wHYmuVWj94luIfTClqurBw3pLC/xss7uG4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=AnEm0lQgba5dccQVMYsppxXpuVD53vGsJBEK0kRz/EmTZG0HH96qHUgoe/2ToJY1t
	 hJIggmMbKMQmHhqyHhlk8VJ7IjYXPfullBGkc0DwUOQs02ZSSkAuce1n4Cc68MqI0d
	 I+75AZzYfbboiJpiIrtO7lweexUyB1nDeaAWXvq1yeze6YKa6epRhWdiY9+iRfaNlE
	 zNe4jt7/8lGgNOTzWLWvUAJ42n2cugEDsPEbu95YsiabEltQReMNtGwQiUiW9ZaYGC
	 e/L0P4XQYaZtnDp6s6ZZqqNLXb4xhQqfAoCeK1a0/q+yDowx9tFcgePaqAwye26Hiz
	 MONSyof7+O1tw==
Date: Thu, 28 May 2026 10:14:52 +0200
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Wilfred Mallawa <wilfred.mallawa@wdc.com>, 
	Damien Le Moal <dlemoal@kernel.org>, Hans Holmberg <hans.holmberg@wdc.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/3] xfs: factor rtgroup geom write pointer reporting
 into a helper
Message-ID: <ahf5dd0sZm_GezKY@nidhogg.toxiclabs.cc>
References: <20260527123941.2319377-1-hch@lst.de>
 <20260527123941.2319377-3-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260527123941.2319377-3-hch@lst.de>

On Wed, May 27, 2026 at 02:39:29PM +0200, Christoph Hellwig wrote:
> Sticks out a bit better if we add a separate helper for it.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

> ---
>  fs/xfs/xfs_ioctl.c | 38 ++++++++++++++++++++++----------------
>  1 file changed, 22 insertions(+), 16 deletions(-)
> 
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index 737afcb5652a..96af6b62ce39 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -409,6 +409,26 @@ xfs_ioc_ag_geometry(
>  	return 0;
>  }
>  
> +static void
> +xfs_rtgroup_report_write_pointer(
> +	struct xfs_rtgroup	*rtg,
> +	struct xfs_rtgroup_geometry *rgeo)
> +{
> +	xfs_rtgroup_lock(rtg, XFS_RTGLOCK_RMAP);
> +	if (rtg->rtg_open_zone) {
> +		rgeo->rg_writepointer = rtg->rtg_open_zone->oz_allocated;
> +	} else {
> +		xfs_rgblock_t	highest_rgbno = xfs_rtrmap_highest_rgbno(rtg);
> +
> +		if (highest_rgbno == NULLRGBLOCK)
> +			rgeo->rg_writepointer = 0;
> +		else
> +			rgeo->rg_writepointer = highest_rgbno + 1;
> +	}
> +	xfs_rtgroup_unlock(rtg, XFS_RTGLOCK_RMAP);
> +	rgeo->rg_flags |= XFS_RTGROUP_GEOM_WRITEPOINTER;
> +}
> +
>  STATIC int
>  xfs_ioc_rtgroup_geometry(
>  	struct xfs_mount	*mp,
> @@ -416,7 +436,6 @@ xfs_ioc_rtgroup_geometry(
>  {
>  	struct xfs_rtgroup	*rtg;
>  	struct xfs_rtgroup_geometry rgeo;
> -	xfs_rgblock_t		highest_rgbno;
>  	int			error;
>  
>  	if (copy_from_user(&rgeo, arg, sizeof(rgeo)))
> @@ -435,21 +454,8 @@ xfs_ioc_rtgroup_geometry(
>  	error = xfs_rtgroup_get_geometry(rtg, &rgeo);
>  	if (error)
>  		goto out_put_rtg;
> -
> -	if (xfs_has_zoned(mp)) {
> -		xfs_rtgroup_lock(rtg, XFS_RTGLOCK_RMAP);
> -		if (rtg->rtg_open_zone) {
> -			rgeo.rg_writepointer = rtg->rtg_open_zone->oz_allocated;
> -		} else {
> -			highest_rgbno = xfs_rtrmap_highest_rgbno(rtg);
> -			if (highest_rgbno == NULLRGBLOCK)
> -				rgeo.rg_writepointer = 0;
> -			else
> -				rgeo.rg_writepointer = highest_rgbno + 1;
> -		}
> -		xfs_rtgroup_unlock(rtg, XFS_RTGLOCK_RMAP);
> -		rgeo.rg_flags |= XFS_RTGROUP_GEOM_WRITEPOINTER;
> -	}
> +	if (xfs_has_zoned(mp))
> +		xfs_rtgroup_report_write_pointer(rtg, &rgeo);
>  
>  	if (copy_to_user(arg, &rgeo, sizeof(rgeo)))
>  		error = -EFAULT;
> -- 
> 2.53.0
> 
> 
