Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09F16157476
	for <linux-xfs@vger.kernel.org>; Tue,  9 Apr 2024 23:16:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712704606; cv=none; b=hRfrhJi9vDePuvsBMC0FwNKwyJarsKgn/4x4WaBT7iUfv7KbipCy0VotxppYy+ZPmZBilIQb2Bgx4v9DM68eiFHbpOKG5EncmtRifHEQM8dMXoimMwHXe/Qry33UuYh5UopITAG0v21h4LtAC9OT25ddGjoSPPdt27jHwBI/NlA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712704606; c=relaxed/simple;
	bh=Asfv+2nV+QfPfp0VawA4A5VsuHFseOXVyucD9o25JW4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tceHydKSkbFmGKtFPnHpoBnuWFeEg09pnNLcnLtp0iNdqZnWTa2btialJfHRmUxYUdVRMglirvKCtanjX1w0ENB8YA/9GBwPB1mjfRgThDMpvUuTiJpsUDu+PRsCYA7FK8O+ZyWNCDa4fiM7QmE1aNj4kvQktbU4EhUIzk8mvsY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hgxbeHyG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hgxbeHyG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAAEBC433F1;
	Tue,  9 Apr 2024 23:16:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712704605;
	bh=Asfv+2nV+QfPfp0VawA4A5VsuHFseOXVyucD9o25JW4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=hgxbeHyG2jN57h7PyBkfNDamWUL5iDS9c+tleuWfKgIzxgfVdtvE2wZjQUNRVaMyd
	 Y0L0tw+qQwjM6DUqD7QWoyzXQ40G6P3wtDHBLSBMHXv3rQUylbsnhoyEcxLwkqrxsH
	 4XSDQOXeIqaQxcqLqeeZAblTG7+75DYohwyS7TfmKqDLSOL0Y3cMdvvQuic/3UZpsq
	 iRJdaPhEu8DS95XbXTdO2yKJNgqBkTAg4HeGNbH8bLoNXdsPaOHg/xvjK1NFsrSlA6
	 JWJ3P/gSsDSnHJizckkBipiDUjkZu/RmFFgDgWlUNqmOXC418i921fe23jep921n5I
	 teWb3mpV0NIpA==
Date: Tue, 9 Apr 2024 16:16:45 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>,
	Dave Chinner <david@fromorbit.com>,
	"open list:XFS FILESYSTEM" <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 7/8] xfs: fix xfs_bmap_add_extent_delay_real for partial
 conversions
Message-ID: <20240409231645.GK6390@frogsfrogsfrogs>
References: <20240408145454.718047-1-hch@lst.de>
 <20240408145454.718047-8-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240408145454.718047-8-hch@lst.de>

On Mon, Apr 08, 2024 at 04:54:53PM +0200, Christoph Hellwig wrote:
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
> of the existing delalloc extent (da_new).  If this extent conversion now

                                   da_old?

The code changes make sense to me otherwise.

--D

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
> ---
>  fs/xfs/libxfs/xfs_bmap.c | 13 +++++++++----
>  1 file changed, 9 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 08e13ebdee1b53..7700a48e013d5a 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -1586,6 +1586,7 @@ xfs_bmap_add_extent_delay_real(
>  			if (error)
>  				goto done;
>  		}
> +		ASSERT(da_new <= da_old);
>  		break;
>  
>  	case BMAP_LEFT_FILLING | BMAP_RIGHT_FILLING | BMAP_LEFT_CONTIG:
> @@ -1616,6 +1617,7 @@ xfs_bmap_add_extent_delay_real(
>  			if (error)
>  				goto done;
>  		}
> +		ASSERT(da_new <= da_old);
>  		break;
>  
>  	case BMAP_LEFT_FILLING | BMAP_RIGHT_FILLING | BMAP_RIGHT_CONTIG:
> @@ -1650,6 +1652,7 @@ xfs_bmap_add_extent_delay_real(
>  			if (error)
>  				goto done;
>  		}
> +		ASSERT(da_new <= da_old);
>  		break;
>  
>  	case BMAP_LEFT_FILLING | BMAP_RIGHT_FILLING:
> @@ -1684,6 +1687,7 @@ xfs_bmap_add_extent_delay_real(
>  				goto done;
>  			}
>  		}
> +		ASSERT(da_new <= da_old);
>  		break;
>  
>  	case BMAP_LEFT_FILLING | BMAP_LEFT_CONTIG:
> @@ -1722,6 +1726,7 @@ xfs_bmap_add_extent_delay_real(
>  			if (error)
>  				goto done;
>  		}
> +		ASSERT(da_new <= da_old);
>  		break;
>  
>  	case BMAP_LEFT_FILLING:
> @@ -1812,6 +1817,7 @@ xfs_bmap_add_extent_delay_real(
>  		xfs_iext_update_extent(bma->ip, state, &bma->icur, &PREV);
>  		xfs_iext_next(ifp, &bma->icur);
>  		xfs_iext_update_extent(bma->ip, state, &bma->icur, &RIGHT);
> +		ASSERT(da_new <= da_old);
>  		break;
>  
>  	case BMAP_RIGHT_FILLING:
> @@ -1861,6 +1867,7 @@ xfs_bmap_add_extent_delay_real(
>  		PREV.br_blockcount = temp;
>  		xfs_iext_insert(bma->ip, &bma->icur, &PREV, state);
>  		xfs_iext_next(ifp, &bma->icur);
> +		ASSERT(da_new <= da_old);
>  		break;
>  
>  	case 0:
> @@ -1983,11 +1990,9 @@ xfs_bmap_add_extent_delay_real(
>  	}
>  
>  	/* adjust for changes in reserved delayed indirect blocks */
> -	if (da_new != da_old) {
> -		ASSERT(state == 0 || da_new < da_old);
> +	if (da_new != da_old)
>  		error = xfs_mod_fdblocks(mp, (int64_t)(da_old - da_new),
> -				false);
> -	}
> +				da_new > da_old);
>  
>  	xfs_bmap_check_leaf_extents(bma->cur, bma->ip, whichfork);
>  done:
> -- 
> 2.39.2
> 
> 
