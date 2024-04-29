Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C225C8288C
	for <linux-xfs@vger.kernel.org>; Mon, 29 Apr 2024 15:48:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714405698; cv=none; b=f2FgQcjmBj0WFljc4VvCxsp63WwdyuePefic3+guo9KjqGfwRRhuRWmMQd7U4KinSsKExYWqsQRsZ/lZO378RS4azF2gCh68gi/uI2xS1IB4ddjyxG5zAcGqgJK5YICkUzg7tkoJdiIY9QfkGdRxnqE1zHviO94s79OMLg0f48M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714405698; c=relaxed/simple;
	bh=qiBAeztJ4X43DeVI04DHBtlYxVmLf8Dyk5yPRUUmNdc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Tf/q6/okfqwenqfEac4AANsVzk1CAdq/EbCQmsuKAYc8NPZ82xzdXHsW7K3BNC6dgYC+ifqcLFRhOUvrQ0wlNXYqVleqPfa4MBYvzx3f44BETDezfKLH3zcNlwWfU6ZXYJQ14Wbz0LnXDnYjTJ2cmjqYczxm2g3SGPnBER42i+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VYBmz0pX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VYBmz0pX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51389C4AF1A;
	Mon, 29 Apr 2024 15:48:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1714405698;
	bh=qiBAeztJ4X43DeVI04DHBtlYxVmLf8Dyk5yPRUUmNdc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=VYBmz0pX6pCiIBhuUm/xn06w86pkZGEBJllndgtmxzsRecYzFJvntHMsUpFVjReEO
	 ufihdTD9iHV0CDdlwutK/d+JMPocdpU9g5aM8kTWcwixMoAcsnGAXdnBlmNwFvnFjO
	 cJwsVmVydFw8M9O9Wt4ASBOHNIFmE3poY06AF+78WLXGdY9M8bUDGywx3NUnThK8L8
	 jkTu0sNC917/0UFybRB+WDlY2MT3R1MMYNoEJ3DSwhbnCFOAMsedX6TNV58SLf9ylM
	 x/X1IQPvn9bxntJ/KeZcNoVtRGUfwrWFh7IldSZa5KFuLeROdqH8a3PDgxwnvgKhjx
	 bbTv3Nnu3xKGQ==
Date: Mon, 29 Apr 2024 08:48:17 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>,
	Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/9] xfs: pass the actual offset and len to allocate to
 xfs_bmapi_allocate
Message-ID: <20240429154817.GB360919@frogsfrogsfrogs>
References: <20240429061529.1550204-1-hch@lst.de>
 <20240429061529.1550204-6-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240429061529.1550204-6-hch@lst.de>

On Mon, Apr 29, 2024 at 08:15:25AM +0200, Christoph Hellwig wrote:
> xfs_bmapi_allocate currently overwrites offset and len when converting
> delayed allocations, and duplicates the length cap done for non-delalloc
> allocations.  Move all that logic into the callers to avoid duplication
> and to make the calling conventions more obvious.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/libxfs/xfs_bmap.c | 32 ++++++++++++++++++--------------
>  1 file changed, 18 insertions(+), 14 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index f7b263d0b0cf1c..fe1ccc083eb3c4 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -4185,21 +4185,11 @@ xfs_bmapi_allocate(
>  	int			error;
>  
>  	ASSERT(bma->length > 0);
> +	ASSERT(bma->length <= XFS_MAX_BMBT_EXTLEN);
>  
> -	/*
> -	 * For the wasdelay case, we could also just allocate the stuff asked
> -	 * for in this bmap call but that wouldn't be as good.
> -	 */
>  	if (bma->wasdel) {
> -		bma->length = (xfs_extlen_t)bma->got.br_blockcount;
> -		bma->offset = bma->got.br_startoff;
>  		if (!xfs_iext_peek_prev_extent(ifp, &bma->icur, &bma->prev))
>  			bma->prev.br_startoff = NULLFILEOFF;
> -	} else {
> -		bma->length = XFS_FILBLKS_MIN(bma->length, XFS_MAX_BMBT_EXTLEN);
> -		if (!bma->eof)
> -			bma->length = XFS_FILBLKS_MIN(bma->length,
> -					bma->got.br_startoff - bma->offset);
>  	}
>  
>  	if (bma->flags & XFS_BMAPI_CONTIG)
> @@ -4533,6 +4523,15 @@ xfs_bmapi_write(
>  			 */
>  			bma.length = XFS_FILBLKS_MIN(len, XFS_MAX_BMBT_EXTLEN);
>  
> +			if (wasdelay) {
> +				bma.offset = bma.got.br_startoff;
> +				bma.length = bma.got.br_blockcount;
> +			} else {
> +				if (!eof)
> +					bma.length = XFS_FILBLKS_MIN(bma.length,
> +						bma.got.br_startoff - bno);
> +			}

Referencing
https://lore.kernel.org/linux-xfs/20240410040353.GC1883@lst.de/

Did you decide against "[moving] the assignments into the other
branch here to make things more obvious"?

--D

> +
>  			ASSERT(bma.length > 0);
>  			error = xfs_bmapi_allocate(&bma);
>  			if (error) {
> @@ -4685,11 +4684,16 @@ xfs_bmapi_convert_delalloc(
>  	bma.tp = tp;
>  	bma.ip = ip;
>  	bma.wasdel = true;
> -	bma.offset = bma.got.br_startoff;
> -	bma.length = max_t(xfs_filblks_t, bma.got.br_blockcount,
> -			XFS_MAX_BMBT_EXTLEN);
>  	bma.minleft = xfs_bmapi_minleft(tp, ip, whichfork);
>  
> +	/*
> +	 * Always allocate convert from the start of the delalloc extent even if
> +	 * that is outside the passed in range to create large contiguous
> +	 * extents on disk.
> +	 */
> +	bma.offset = bma.got.br_startoff;
> +	bma.length = bma.got.br_blockcount;
> +
>  	/*
>  	 * When we're converting the delalloc reservations backing dirty pages
>  	 * in the page cache, we must be careful about how we create the new
> -- 
> 2.39.2
> 
> 
