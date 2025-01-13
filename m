Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC8FA231CA0
	for <linux-xfs@vger.kernel.org>; Mon, 13 Jan 2025 07:13:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736752411; cv=none; b=Or9LbtC0FOtL3CuafJpxfXwZBOQLVgxrbIJr2ZbmsCybm1s8x0K4Eeg3rdkgwjL7eCPwz6tMQ3TiaK6LJRL7fi+5KOHHgGFSanXFeEgqX5rjJCXg9x83A7p2VJd1FdDHCbgKmZnMXu7nuNiiUNyBeRrTcaRM9afPbycbkvaRLLA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736752411; c=relaxed/simple;
	bh=PElNDL8pxsA7195nDXcsrkKhwhh/+H5PaapC08PgsMk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gyH11ID+G9oyNGwNaVBFSPZs73fj3T7MqUq8OPm1c3LoucGI1nfYb7pjljm3S8lRDEFfDu2WhDaoHoNK9kSO0VIhCqTcox4PQRbQtY4EaHDV4xWBVuIUAsLW5JQTt9L2oF11jSUOE4sjuRpTn7jSca/2FXp74q1TRqAAePek7pQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ISI17AnU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ISI17AnU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CC70C4CED6;
	Mon, 13 Jan 2025 07:13:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736752410;
	bh=PElNDL8pxsA7195nDXcsrkKhwhh/+H5PaapC08PgsMk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ISI17AnUBScQGGUBFkvKPCEi6FT8SmZWYiqJNPBgiQZ5jUIKVwkUIYTFSuoHpaYDk
	 Rvx4WegkQJXIN7zh0Lazhr5GAsXNw0rqgApLxbpuTnEjnHacuWcBgusW+b4XbL5+py
	 SQy+5yS3BT19cVW7/0JHuTF/7xGBKRCbQw+jFA4k7LV2gcXR/cl6KgN1UdaZjWhg1D
	 eqstIBM5c+B2tiErgjCvygSedRn0dli+3t09AzaMUoH+MNbRfNjDPIZykA7ao1uA+p
	 voXnsqA7T7F5utWqz+MHv3V+ZVIhM8ntoIxi2ncVhTRO+lKGw+1rekj1Ow/tgZQr3Q
	 HQaFHFuYqY1lA==
Date: Sun, 12 Jan 2025 23:13:29 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 11/15] xfs: remove the extra buffer reference in
 xfs_buf_submit
Message-ID: <20250113071329.GZ1306365@frogsfrogsfrogs>
References: <20250106095613.847700-1-hch@lst.de>
 <20250106095613.847700-12-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250106095613.847700-12-hch@lst.de>

On Mon, Jan 06, 2025 at 10:54:48AM +0100, Christoph Hellwig wrote:
> Nothing touches the buffer after it has been submitted now, so the need for
> the extra transient reference went away as well.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Ooops, forgot this one.

Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_buf.c | 17 +----------------
>  1 file changed, 1 insertion(+), 16 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index 49df4adf0e98..352cc50aeea5 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -1646,13 +1646,6 @@ xfs_buf_submit(
>  		return -EIO;
>  	}
>  
> -	/*
> -	 * Grab a reference so the buffer does not go away underneath us. For
> -	 * async buffers, I/O completion drops the callers reference, which
> -	 * could occur before submission returns.
> -	 */
> -	xfs_buf_hold(bp);
> -
>  	if (bp->b_flags & XBF_WRITE)
>  		xfs_buf_wait_unpin(bp);
>  
> @@ -1675,20 +1668,12 @@ xfs_buf_submit(
>  		goto done;
>  
>  	xfs_buf_submit_bio(bp);
> -	goto rele;
> -
> +	return 0;
>  done:
>  	if (bp->b_error || !(bp->b_flags & XBF_ASYNC))
>  		xfs_buf_ioend(bp);
>  	else
>  		xfs_buf_ioend_async(bp);
> -rele:
> -	/*
> -	 * Release the hold that keeps the buffer referenced for the entire
> -	 * I/O. Note that if the buffer is async, it is not safe to reference
> -	 * after this release.
> -	 */
> -	xfs_buf_rele(bp);
>  	return 0;
>  }
>  
> -- 
> 2.45.2
> 
> 
