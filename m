Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 687E133372A
	for <linux-xfs@vger.kernel.org>; Mon, 16 Mar 2026 16:16:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773677784; cv=none; b=UmwtRtfkRhGwfA/LYWgEjczTlTPdPRWU/kM4x9k+VnyN41zVzCSYu7zAvbrwLXoXkPVU0pe9X3o8SciqEiiWZSylUis3G3AmupQAWhRUX23LOEjwMm+BXQe3ZlqFcaDX1DP3Zxt/UIpcrhsOkgHqdC2lrnLavVQFD/A+ymI12DE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773677784; c=relaxed/simple;
	bh=iMxEvgN9EdIpNQHvAioQRFeK5+ukYUEqmUxoALfXvRE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NMO23foaXdwLWWDXdO04HzXpX/C3HRMU+2b7/PcMPKoRu/du+AtgA801W2UwcQ/oVkPkFcnaebToy3/U+FzKFrYmns5phC7ajZhQtkaRGayGKIJce5D5ZiP4KZEVjcTRdeTgtfYRfzw/ELPwn2Rw87+yQFHrRtuMc+4+XOZtL7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DgEtoq/2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DgEtoq/2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 019D4C19425;
	Mon, 16 Mar 2026 16:16:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773677784;
	bh=iMxEvgN9EdIpNQHvAioQRFeK5+ukYUEqmUxoALfXvRE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=DgEtoq/26ZUAj/9cUruDWQUGXpRMLNdsfYb/QbLzQig4KxUYz/d+gakm66RatlCFi
	 Sks9Q0gfEREPE8aKCBm6sU7Gmrto2HyHnHyCCyYacOOdo0ZDJcPORt4USThMxaoNDe
	 xkakWl+LFGSoh94MVaP+QunDWC2s6xet3j59Fg+4KUt3B1Kr6DCEhRGZNwrQ3C7XJr
	 tl6nNIQaEQVPYv2ck3hL4CFyClv2SqDy+DOWWtDnm5PvDyudwJrgpBEI74LJtMlPoX
	 ciwq0C+kv6uoHaqREht6qK4+mCXhkWjaAS9IMSYj/SAZw1KgSS1JQehZQ4jj1DPFOI
	 UibV6+zMZSg6g==
Date: Mon, 16 Mar 2026 09:16:23 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: cleanup buftarg handling in XFS_IOC_VERIFY_MEDIA
Message-ID: <20260316161623.GV1770774@frogsfrogsfrogs>
References: <20260316153533.1580167-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260316153533.1580167-1-hch@lst.de>

On Mon, Mar 16, 2026 at 04:35:29PM +0100, Christoph Hellwig wrote:
> The newly added XFS_IOC_VERIFY_MEDIA is a bit unusual in how it handles
> buftarg fields.  Update it to be more in line with other XFS code:
> 
>  - use btp->bt_dev instead of btp->bt_bdev->bd_dev to retrieve the device
>    number for tracing
>  - use btp->bt_logical_sectorsize instead of
>    bdev_logical_block_size(btp->bt_bdev) to retrieve the logical sector
>    size

Heh, aliased variables.  I wish I'd remembered that those exist.

>  - compare the buftarg and not the bdev to see if there is a separate
>    log buftarg

<nod> Yeah, that's also correct, and less pointer chasing.

> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_verify_media.c | 18 ++++++++----------
>  1 file changed, 8 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/xfs/xfs_verify_media.c b/fs/xfs/xfs_verify_media.c
> index 8bbd4ec567f8..5ead3976d511 100644
> --- a/fs/xfs/xfs_verify_media.c
> +++ b/fs/xfs/xfs_verify_media.c
> @@ -183,10 +183,9 @@ xfs_verify_iosize(
>  			min_not_zero(SZ_1M, me->me_max_io_size);
>  
>  	BUILD_BUG_ON(BBSHIFT != SECTOR_SHIFT);
> -	ASSERT(BBTOB(bbcount) >= bdev_logical_block_size(btp->bt_bdev));
> +	ASSERT(BBTOB(bbcount) >= btp->bt_logical_sectorsize);
>  
> -	return clamp(iosize, bdev_logical_block_size(btp->bt_bdev),
> -			BBTOB(bbcount));
> +	return clamp(iosize, btp->bt_logical_sectorsize, BBTOB(bbcount));
>  }
>  
>  /* Allocate as much memory as we can get for verification buffer. */
> @@ -218,8 +217,8 @@ xfs_verify_media_error(
>  	unsigned int		bio_bbcount,
>  	blk_status_t		bio_status)
>  {
> -	trace_xfs_verify_media_error(mp, me, btp->bt_bdev->bd_dev, daddr,
> -			bio_bbcount, bio_status);
> +	trace_xfs_verify_media_error(mp, me, btp->bt_dev, daddr, bio_bbcount,
> +			bio_status);
>  
>  	/*
>  	 * Pass any error, I/O or otherwise, up to the caller if we didn't
> @@ -280,7 +279,7 @@ xfs_verify_media(
>  		btp = mp->m_ddev_targp;
>  		break;
>  	case XFS_DEV_LOG:
> -		if (mp->m_logdev_targp->bt_bdev != mp->m_ddev_targp->bt_bdev)
> +		if (mp->m_logdev_targp != mp->m_ddev_targp)
>  			btp = mp->m_logdev_targp;
>  		break;
>  	case XFS_DEV_RT:
> @@ -299,7 +298,7 @@ xfs_verify_media(
>  
>  	/* start and end have to be aligned to the lba size */
>  	if (!IS_ALIGNED(BBTOB(me->me_start_daddr | me->me_end_daddr),
> -			bdev_logical_block_size(btp->bt_bdev)))
> +			btp->bt_logical_sectorsize))
>  		return -EINVAL;
>  
>  	/*
> @@ -331,8 +330,7 @@ xfs_verify_media(
>  	if (!folio)
>  		return -ENOMEM;
>  
> -	trace_xfs_verify_media(mp, me, btp->bt_bdev->bd_dev, daddr, bbcount,
> -			folio);
> +	trace_xfs_verify_media(mp, me, btp->bt_dev, daddr, bbcount, folio);
>  
>  	bio = bio_alloc(btp->bt_bdev, 1, REQ_OP_READ, GFP_KERNEL);
>  	if (!bio) {
> @@ -400,7 +398,7 @@ xfs_verify_media(
>  	 * an operational error.
>  	 */
>  	me->me_start_daddr = daddr;
> -	trace_xfs_verify_media_end(mp, me, btp->bt_bdev->bd_dev);
> +	trace_xfs_verify_media_end(mp, me, btp->bt_dev);
>  	return 0;
>  }
>  
> -- 
> 2.47.3
> 
> 
