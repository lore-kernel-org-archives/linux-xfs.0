Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FA8935028D
	for <linux-xfs@vger.kernel.org>; Mon, 22 Jun 2026 13:18:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782134284; cv=none; b=gI7kT/mCziv7R7yE7QceO0khVSmvX/9PrfMen41JN8nVBcSRnYyAlsWhrYup+C+XU/N8MBOg5X8dHW86i8GhuC8A7qm1K31OBotgAm2EBxAh10yO0YoWS6BevjpP+gizcvIDmLlG3UWnXxJaiIT4vHym5yG4uXnUDIigAiZmh2g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782134284; c=relaxed/simple;
	bh=SOlxIP0ht4s+RgedahJeSv6w/GpnLCwMnhtCKLrIhfw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ordfai9cWyTAKAlA8ySXxwmAVUQethRErodU7uS/uzK2ROQfntE3yT0h0HOJFEncAMTCbhY5OpB0Gs0y6CP3Lj08mY0Giy1w/dTn/LIpKnHmuY+SZUcYK48zDps+XonmvLJinSLt0FAOxQtbMfsVLdAzV2D//lNZGPS7CbgSszU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=B4x8yDtc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="B4x8yDtc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 064DB1F000E9;
	Mon, 22 Jun 2026 13:18:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782134282;
	bh=49Ojn2w3cfil5Oe7MGoyUcTxVpSvz92I6oFA2LewlPw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=B4x8yDtcSuxilt0ebrYOkH8LUM5HMy8tQOOway9+U+FZq+c4UEnX/Mu2fgNdzHLpH
	 FBx3RlPtCtvpjVJeEegXhs9UAACKdKfZdZak0sCPzTIZ1Kii2gH9dtUN8IdWCG6gDq
	 rmjA/EEXgrtboIViHZVan5sgyQnJVZLTIsi++FuwQlWQRRWswh0aJkE86szstSdTyF
	 Qp5eu+hJ1UZtVt3wkJSfsYh9V7S0rAWPtqqKqQtZTAi+N/TpOXGAcbEAYdGGpHoDGI
	 kuQn6cRwCKTIyHzW+8p+YPbE88i2BLHrUWCnQWuIg2l0t43KqoOZnyrm0xtfWHQ8yY
	 6n5rLV6TsTzow==
Date: Mon, 22 Jun 2026 15:17:59 +0200
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/6] xfs: remove xfs_buf_ioend
Message-ID: <ajk17PV_9wdM8T2Y@nidhogg.toxiclabs.cc>
References: <20260622073035.1370904-1-hch@lst.de>
 <20260622073035.1370904-5-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260622073035.1370904-5-hch@lst.de>

On Mon, Jun 22, 2026 at 09:30:03AM +0200, Christoph Hellwig wrote:
> There are two callers of xfs_buf_ioend, one of which always has the
> XBF_ASYNC flag set.  Open code the logic in both callers to prepare for a
> bug fix.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Independent of the bugfix I didn't see yet, I'm happy to see this
function gone...

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

> ---
>  fs/xfs/xfs_buf.c | 22 ++++++++--------------
>  1 file changed, 8 insertions(+), 14 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index ef2ea15a97bb..651add22deea 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -1146,18 +1146,6 @@ __xfs_buf_ioend(
>  	return true;
>  }
>  
> -static void
> -xfs_buf_ioend(
> -	struct xfs_buf	*bp)
> -{
> -	if (!__xfs_buf_ioend(bp))
> -		return;
> -	if (bp->b_flags & XBF_ASYNC)
> -		xfs_buf_relse(bp);
> -	else
> -		complete(&bp->b_iowait);
> -}
> -
>  static void
>  xfs_buf_ioend_work(
>  	struct work_struct	*work)
> @@ -1207,7 +1195,8 @@ xfs_buf_fail(
>  	bp->b_flags &= ~XBF_DONE;
>  	xfs_buf_stale(bp);
>  	xfs_buf_ioerror(bp, -EIO);
> -	xfs_buf_ioend(bp);
> +	if (__xfs_buf_ioend(bp))
> +		xfs_buf_relse(bp);
>  }
>  
>  int
> @@ -1414,7 +1403,12 @@ xfs_buf_submit(
>  	bp->b_flags &= ~XBF_DONE;
>  	xfs_buf_stale(bp);
>  end_io:
> -	xfs_buf_ioend(bp);
> +	if (!__xfs_buf_ioend(bp))
> +		return;
> +	if (bp->b_flags & XBF_ASYNC)
> +		xfs_buf_relse(bp);
> +	else
> +		complete(&bp->b_iowait);
>  }
>  
>  /*
> -- 
> 2.53.0
> 
