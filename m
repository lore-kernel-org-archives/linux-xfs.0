Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A130116EC0B
	for <linux-xfs@vger.kernel.org>; Fri,  5 Apr 2024 15:44:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712331870; cv=none; b=Wg8qDqEAadNeyD/QZ4QXOFwGNVzJ9SIH6kUJf8UC1AgQxoYCbiFIqFUX7Hj10ubb1OvcDAXYqGPBC7NqQQvSyYm1booxocLFunSX0aGHZi0hgN/gajVuO/xEP78MwF/UTWEwATG1W3nrBEb21xAKJA/TuCIoeC1JRKRyBJ1gxUo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712331870; c=relaxed/simple;
	bh=C7d3ghMdprrypqa6qNV3v92XAwVPNAZTwHuWd6xnTjc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RGIPKr9Qfcgq2SxxKliaDvHa77ScMtqLu/aZOVlX6FweY+KjONQvhyiz+JUPuyWgDcvBhL5UaRI8P7hO3kQSTDb45wrsTFecSJ+ifd2EMNGH3n2YruUHEx5JXUJS75emTUhX3XNwqfc4BcdukpcPv7xq40xkHRi6jtivUyrW3uA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AL7eIkZh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AL7eIkZh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 273F1C433F1;
	Fri,  5 Apr 2024 15:44:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712331870;
	bh=C7d3ghMdprrypqa6qNV3v92XAwVPNAZTwHuWd6xnTjc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=AL7eIkZhUTjArPTX9rO4TOV3eT2sRFXQkscwoy1SvEY6GLz4u+s7qmY//Qfq/qNZO
	 wDnvyTL308O8bUB0vZ3kK+s5aGERuliPQivRcb738TLm3keBRA6muIMpfhf7oHrW2y
	 c6FlBbQZPpBbvfFtaWGmHJqS8bgeRiuMTe9xUTsvwSCEz/3ieW2uMwYzU32+xzMaBW
	 9pwqA8Tka7q7SHBh48q0toyiOGseUubGNrpIKXWC/RYi932r56YQ5m1qberrJHHyGa
	 iEmn3IOvfmPq5MXKidteytduIDmGTGzJ3kFvf0XM3nBbi2Zsxp91Ho3s+MSIIgpXMA
	 Hsv2E061qME9g==
Date: Fri, 5 Apr 2024 08:44:29 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>,
	Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/3] xfs: move more logic into xfs_extent_busy_clear_one
Message-ID: <20240405154429.GZ6390@frogsfrogsfrogs>
References: <20240405060710.227096-1-hch@lst.de>
 <20240405060710.227096-2-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240405060710.227096-2-hch@lst.de>

On Fri, Apr 05, 2024 at 08:07:08AM +0200, Christoph Hellwig wrote:
> Move the handling of discarded entries into xfs_extent_busy_clear_one
> to reuse the length check and tidy up the logic in the caller.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

AFAICT, the return value of xfs_extent_busy_clear_one is whether
or not it actually changed the pagb_tree, right?  And if that return
value is true, then we want to wake up anyone who might be waiting on
busy extents to clear the pagb_tree, which is what the @wakeup logic
does, right?

If the answers are yes and yes, then:
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D


> ---
>  fs/xfs/xfs_extent_busy.c | 23 ++++++++++++-----------
>  1 file changed, 12 insertions(+), 11 deletions(-)
> 
> diff --git a/fs/xfs/xfs_extent_busy.c b/fs/xfs/xfs_extent_busy.c
> index 56cfa1498571e3..6fbffa46e5e94b 100644
> --- a/fs/xfs/xfs_extent_busy.c
> +++ b/fs/xfs/xfs_extent_busy.c
> @@ -518,20 +518,26 @@ xfs_extent_busy_trim(
>  	goto out;
>  }
>  
> -STATIC void
> +static bool
>  xfs_extent_busy_clear_one(
> -	struct xfs_mount	*mp,
>  	struct xfs_perag	*pag,
> -	struct xfs_extent_busy	*busyp)
> +	struct xfs_extent_busy	*busyp,
> +	bool			do_discard)
>  {
>  	if (busyp->length) {
> -		trace_xfs_extent_busy_clear(mp, busyp->agno, busyp->bno,
> -						busyp->length);
> +		if (do_discard &&
> +		    !(busyp->flags & XFS_EXTENT_BUSY_SKIP_DISCARD)) {
> +			busyp->flags = XFS_EXTENT_BUSY_DISCARDED;
> +			return false;
> +		}
> +		trace_xfs_extent_busy_clear(pag->pag_mount, busyp->agno,
> +				busyp->bno, busyp->length);
>  		rb_erase(&busyp->rb_node, &pag->pagb_tree);
>  	}
>  
>  	list_del_init(&busyp->list);
>  	kfree(busyp);
> +	return true;
>  }
>  
>  static void
> @@ -575,13 +581,8 @@ xfs_extent_busy_clear(
>  			wakeup = false;
>  		}
>  
> -		if (do_discard && busyp->length &&
> -		    !(busyp->flags & XFS_EXTENT_BUSY_SKIP_DISCARD)) {
> -			busyp->flags = XFS_EXTENT_BUSY_DISCARDED;
> -		} else {
> -			xfs_extent_busy_clear_one(mp, pag, busyp);
> +		if (xfs_extent_busy_clear_one(pag, busyp, do_discard))
>  			wakeup = true;
> -		}
>  	}
>  
>  	if (pag)
> -- 
> 2.39.2
> 
> 
