Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4A3082D90
	for <linux-xfs@vger.kernel.org>; Mon, 29 Apr 2024 15:48:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714405737; cv=none; b=ECTl6XhabX2CsZLf4AKoMZHB4LA2fo3Psi+eAssvzApupv0xT0EqU+ZmMrgQmqiuAbrANZ2Tqeq03kUNhZPE+gOt5bkTfDzjh7dVHk0m93lk877KNNv5SNw0oBLZRCxyP5+OWMzNmuKuBv5k603YjTz8hVZWzrBzHRR1P7rciOM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714405737; c=relaxed/simple;
	bh=ZDJpw9RPWxyvEmZu0SGij4kUwgp6hKgaUwggRj1QF7o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LV7PgHxc6Efs3QfDhLbxxAurj+1ZgFtHS0G9KwFZ+RicEM3wy8JO+DRI2yQrbLjeydZv2xE/CTWl79xhE2EMyYfUJJ4QyvMC4O9TzPrM2Fi3yTHr3BN+7QAayOgrIyBR46yX8t8X84N8Jh1hn/Suv7obivPydlZA0Ji1/WC3GGk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eqvX5/I0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eqvX5/I0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51E8AC113CD;
	Mon, 29 Apr 2024 15:48:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1714405736;
	bh=ZDJpw9RPWxyvEmZu0SGij4kUwgp6hKgaUwggRj1QF7o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=eqvX5/I04xqyvP42gmKQk6ZlOgwhalnNBUtJnblqWuj+pU97Z+QZHlzC5aAZaH5dF
	 PEUMfEGpnjFAg08o/8kJMxbIlCHf1Qr0ktUBMWk1Qh02eMysTsBDGeD3S0SzOAEGTf
	 IWUtOeNghrfVyMDkzkORptBcH9U03xY04TB53Pw99wfzhxMt0rnTEVQo1vYQyoR2RR
	 r/YgT0RJvHd3JUA13cuE8WTHx58fl45O44D7PjZt8VQp5LqILKfK19sQYWrJS4zIGA
	 w55mAmvo3IxPX50+y1C/L2x0BQU1VxO8EUhRc2xCRuTnX+YmLiJGHhcjszBdjFaA4c
	 /KFlUAFwWNWSA==
Date: Mon, 29 Apr 2024 08:48:55 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>,
	Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 7/9] xfs: fix xfs_bmap_add_extent_delay_real for partial
 conversions
Message-ID: <20240429154855.GC360919@frogsfrogsfrogs>
References: <20240429061529.1550204-1-hch@lst.de>
 <20240429061529.1550204-8-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240429061529.1550204-8-hch@lst.de>

On Mon, Apr 29, 2024 at 08:15:27AM +0200, Christoph Hellwig wrote:
> xfs_bmap_add_extent_delay_real takes parts or all of a delalloc extent
> and converts them to a real extent.  It is written to deal with any
> potential overlap of the to be converted range with the delalloc extent,
> but it turns out that currently only converting the entire extents, or a
> part starting at the beginning is actually exercised, as the only caller
> always tries to convert the entire delalloc extent, and either succeeds
> or at least progresses partially from the start.
> 
> If it only converts a tiny part of a delalloc extent, the indirect block
> calculation for the new delalloc extent (da_new) might be equivalent to that
> of the existing delalloc extent (da_old).  If this extent conversion now
> requires allocating an indirect block that gets accounted into da_new,
> leading to the assert that da_new must be smaller or equal to da_new
> unless we split the extent to trigger.
> 
> Except for the assert that case is actually handled by just trying to
> allocate more space, as that already handled for the split case (which
> currently can't be reached at all), so just reusing it should be fine.
> Except that without dipping into the reserved block pool that would make
> it a bit too easy to trigger a fs shutdown due to ENOSPC.  So in addition
> to adjusting the assert, also dip into the reserved block pool.
> 
> Note that I could only reproduce the assert with a change to only convert
> the actually asked range instead of the full delalloc extent from
> xfs_bmapi_write.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good now,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/libxfs/xfs_bmap.c | 15 ++++++++++-----
>  1 file changed, 10 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 472c795beb8add..42c5a2efa656a5 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -1570,6 +1570,7 @@ xfs_bmap_add_extent_delay_real(
>  			if (error)
>  				goto done;
>  		}
> +		ASSERT(da_new <= da_old);
>  		break;
>  
>  	case BMAP_LEFT_FILLING | BMAP_RIGHT_FILLING | BMAP_LEFT_CONTIG:
> @@ -1600,6 +1601,7 @@ xfs_bmap_add_extent_delay_real(
>  			if (error)
>  				goto done;
>  		}
> +		ASSERT(da_new <= da_old);
>  		break;
>  
>  	case BMAP_LEFT_FILLING | BMAP_RIGHT_FILLING | BMAP_RIGHT_CONTIG:
> @@ -1634,6 +1636,7 @@ xfs_bmap_add_extent_delay_real(
>  			if (error)
>  				goto done;
>  		}
> +		ASSERT(da_new <= da_old);
>  		break;
>  
>  	case BMAP_LEFT_FILLING | BMAP_RIGHT_FILLING:
> @@ -1668,6 +1671,7 @@ xfs_bmap_add_extent_delay_real(
>  				goto done;
>  			}
>  		}
> +		ASSERT(da_new <= da_old);
>  		break;
>  
>  	case BMAP_LEFT_FILLING | BMAP_LEFT_CONTIG:
> @@ -1706,6 +1710,7 @@ xfs_bmap_add_extent_delay_real(
>  			if (error)
>  				goto done;
>  		}
> +		ASSERT(da_new <= da_old);
>  		break;
>  
>  	case BMAP_LEFT_FILLING:
> @@ -1796,6 +1801,7 @@ xfs_bmap_add_extent_delay_real(
>  		xfs_iext_update_extent(bma->ip, state, &bma->icur, &PREV);
>  		xfs_iext_next(ifp, &bma->icur);
>  		xfs_iext_update_extent(bma->ip, state, &bma->icur, &RIGHT);
> +		ASSERT(da_new <= da_old);
>  		break;
>  
>  	case BMAP_RIGHT_FILLING:
> @@ -1845,6 +1851,7 @@ xfs_bmap_add_extent_delay_real(
>  		PREV.br_blockcount = temp;
>  		xfs_iext_insert(bma->ip, &bma->icur, &PREV, state);
>  		xfs_iext_next(ifp, &bma->icur);
> +		ASSERT(da_new <= da_old);
>  		break;
>  
>  	case 0:
> @@ -1967,12 +1974,10 @@ xfs_bmap_add_extent_delay_real(
>  	}
>  
>  	/* adjust for changes in reserved delayed indirect blocks */
> -	if (da_new < da_old) {
> +	if (da_new < da_old)
>  		xfs_add_fdblocks(mp, da_old - da_new);
> -	} else if (da_new > da_old) {
> -		ASSERT(state == 0);
> -		error = xfs_dec_fdblocks(mp, da_new - da_old, false);
> -	}
> +	else if (da_new > da_old)
> +		error = xfs_dec_fdblocks(mp, da_new - da_old, true);
>  
>  	xfs_bmap_check_leaf_extents(bma->cur, bma->ip, whichfork);
>  done:
> -- 
> 2.39.2
> 
> 
