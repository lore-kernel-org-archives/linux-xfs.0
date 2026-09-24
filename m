Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 463CA4B1289
	for <linux-xfs@vger.kernel.org>; Thu, 24 Sep 2026 20:18:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790281101; cv=none; b=HInpjeGy0k81Svq/2k+rHVFnGCQnj2ypTx/HHWQnaLK5jzMTPDlgRfi29qbUChvuJ9OSWsf0Rd09MpqD10i0OCe2VVX89ZGbNeXD/fL/TJUI52aVCwnlqCDNp/Ma/ffLARH/Soq3F1i3t8SG6VHuID5f3ohYvt8mPbITGPEoc34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790281101; c=relaxed/simple;
	bh=ZcNmPGVOTOzWDvJIXhW2jyoeOk039pAxyOQZ5d4gvOU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=X6vgO7R7nYbgbtDkDPgrypkUv323FgF+CK4I9ON8JMA41GwBBmevmfoWC+V9NMLLttlDt1I3mvrzkHJk8YtgZ3RRfES8+Xc2Xk77rPGtM/1ft737/FtAf4t2JwsVfdZoVeZHZCR8ttUsAOMXqYIltB/KObIsCRVdQdnMDlwWbgo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=k7tf+IkV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="k7tf+IkV"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id ECE3E1F000FF;
	Thu, 24 Sep 2026 20:18:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790281095;
	bh=l6xCep+eNQGgs1YVGJwU1Uz0WEhu/fifBrfsrA0tAyE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=k7tf+IkVTt6MeNmQu0+hJLXyeVgTRo0E8KxHxI4ceaNut+oU10A9mYwd8VEPYl9xG
	 kZmELO0tGRzJTDhDNmjnZjfFXAPG/rWdP+JgAtw94Obo3+Z7/6lllApro7aPCRPhdt
	 qJS1W7SzRrUekl+f5vJ39DkWYYKflHyOsh71UVNPhGj/PbP2fncb1pfAzXxZSdOBEr
	 yTDdYLWjwC9rWQ/T2zORjsU5qptZs42I83zb9RHUeM6OkeyIKLcAZGx3ERdD4YOOec
	 p7/Q757U7zs2mhNNeKw5DqcqQPRomt69Q8Z8pkkqv3oDoGFT9A3+yHTKo0yCeZ4NzX
	 VMlYLV/kpj8+g==
Date: Thu, 24 Sep 2026 13:18:14 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/9] xfs: use bdev_rw_virt in xfs_verify_media
Message-ID: <20260924201814.GU2705364@frogsfrogsfrogs>
References: <20260924095740.2732474-1-hch@lst.de>
 <20260924095740.2732474-6-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260924095740.2732474-6-hch@lst.de>

On Thu, Sep 24, 2026 at 11:57:06AM +0200, Christoph Hellwig wrote:
> Use bdev_rw_virt for reading data from disk.  This simply uses an
> on-stack bio and bio_vec and removes the need to allocate an bio and
> reset it for each iteration.  Because bdev_rw_virt returns a negative
> errno, pass that on to xfs_verify_media_error to avoid a double
> conversion.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Nice cleanup!
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_verify_media.c | 41 +++++++++++----------------------------
>  1 file changed, 11 insertions(+), 30 deletions(-)
> 
> diff --git a/fs/xfs/xfs_verify_media.c b/fs/xfs/xfs_verify_media.c
> index 8ce3773aa875..71f4d6c832a9 100644
> --- a/fs/xfs/xfs_verify_media.c
> +++ b/fs/xfs/xfs_verify_media.c
> @@ -229,8 +229,10 @@ xfs_verify_media_error(
>  	struct xfs_buftarg	*btp,
>  	xfs_daddr_t		daddr,
>  	unsigned int		bio_bbcount,
> -	blk_status_t		bio_status)
> +	int			error)
>  {
> +	blk_status_t		bio_status = errno_to_blk_status(error);
> +
>  	trace_xfs_verify_media_error(mp, me, btp->bt_dev, daddr, bio_bbcount,
>  			bio_status);
>  
> @@ -239,7 +241,7 @@ xfs_verify_media_error(
>  	 * successfully verify any bytes at all.
>  	 */
>  	if (me->me_start_daddr == daddr)
> -		me->me_ioerror = -blk_status_to_errno(bio_status);
> +		me->me_ioerror = -error;
>  
>  	/*
>  	 * PI validation failures, medium errors, or general IO errors are
> @@ -266,7 +268,6 @@ xfs_verify_media(
>  	struct xfs_verify_media	*me)
>  {
>  	struct xfs_buftarg	*btp = NULL;
> -	struct bio		*bio;
>  	struct folio		*folio;
>  	xfs_daddr_t		daddr;
>  	uint64_t		bbcount;
> @@ -332,33 +333,16 @@ xfs_verify_media(
>  
>  	trace_xfs_verify_media(mp, me, btp->bt_dev, daddr, bbcount, folio);
>  
> -	bio = bio_alloc(btp->bt_bdev, 1, REQ_OP_READ, GFP_KERNEL);
> -	if (!bio) {
> -		error = -ENOMEM;
> -		goto out_folio;
> -	}
> -
> -	while (bbcount > 0) {
> +	for (;;) {
>  		unsigned int	bio_bbcount;
> -		blk_status_t	bio_status;
> -
> -		bio_reset(bio, btp->bt_bdev, REQ_OP_READ);
> -		bio->bi_iter.bi_sector = daddr;
> -		bio_add_folio_nofail(bio, folio,
> -				min(bbcount << SECTOR_SHIFT, folio_size(folio)),
> -				0);
>  
> -		/*
> -		 * Save the length of the bio before we submit it, because we
> -		 * need the original daddr and length for reporting IO errors
> -		 * if the bio fails.
> -		 */
> -		bio_bbcount = bio->bi_iter.bi_size >> SECTOR_SHIFT;
> -		submit_bio_wait(bio);
> -		bio_status = bio->bi_status;
> -		if (bio_status != BLK_STS_OK) {
> +		bio_bbcount = min(bbcount, folio_size(folio) >> SECTOR_SHIFT);
> +		error = bdev_rw_virt(btp->bt_bdev, daddr, folio_address(folio),
> +				bio_bbcount << SECTOR_SHIFT,
> +				REQ_OP_READ);
> +		if (error) {
>  			xfs_verify_media_error(mp, me, btp, daddr, bio_bbcount,
> -					bio_status);
> +					error);
>  			error = 0;
>  			break;
>  		}
> @@ -386,10 +370,7 @@ xfs_verify_media(
>  		cond_resched();
>  	}
>  
> -	bio_put(bio);
> -out_folio:
>  	folio_put(folio);
> -
>  	if (error)
>  		return error;
>  
> -- 
> 2.53.0
> 
> 
