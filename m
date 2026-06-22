Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C750394E93
	for <linux-xfs@vger.kernel.org>; Mon, 22 Jun 2026 12:39:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782131949; cv=none; b=d7MVW0WhgNl9oScCqHImo2h036xyBjZv4g3HqOrI9mqxuCNOjj/Zvp0eYRNYo/LclpB6o1bxU4uX+YQlfeUnyCVJGMqXlgOaBfNm9i/qbmr2RwkFNm2/btK3Om5mnDCZrJhR533LHK2pxJPIRW6XRzyYH+iZI142oI8bu7wg7L0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782131949; c=relaxed/simple;
	bh=MRu9Wq16HvxfrBEMgwG07onpLmu3m7Yfpanqk1PjTGY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FJKngQ3KcjZ/yvvXg33f/sZhJyvb8zubb7Tb5KItklLzI7qmoQ4CU0nBQozt14tBWCRPUYzjFs/HvXxf9lmIdFpM6Dz1XMYEqNR7EeC0J48P6MYIoe4hmXK4lWiKUSbCrZLrpyNHdckPOhlGyjoN7zVH5P5tZQfVoTiKPuepeeY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GiMWgFsL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GiMWgFsL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EA4D1F000E9;
	Mon, 22 Jun 2026 12:39:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782131948;
	bh=D6c/rmoRzyPfFuFNlWEMSFmzQlOKa4R5LDAIwCnwdVY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=GiMWgFsLbqUgCB9PsJE+uFczIfjGIwwtg2317Do4/LX2NiBzEZr0zqE0NOCTdpx/Q
	 fNmY3dr6+8bM3CztNPEm80wEKqIb7ds7idFeZAVwwhkaFIOGs3cGyYba0BJE4UBQuO
	 +KMzRnNJRf/T6MsOUrqWt6uG9Zw9+9ZdGsUDuunpnjKAiFmwDxXz8jPdEG1vezsN3n
	 0LiR6AYRcH/8qNgr4qxI/N5OEL+qzhBdU5DMRb929F+Ra5WlJJDpxAMY5dJc0OTt2k
	 O/mWpIqAbdTPtjG4ZyMzhWMzhgqvnuV+cEidf6h6RNO8J8f0+tdHJioA2VsH43Jg3J
	 /alBRs8DoybGQ==
Date: Mon, 22 Jun 2026 14:39:04 +0200
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/6] xfs: open code xfs_buf_ioend_fail in xfs_buf_submit
Message-ID: <ajks4gmGVQDx30MX@nidhogg.toxiclabs.cc>
References: <20260622073035.1370904-1-hch@lst.de>
 <20260622073035.1370904-2-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260622073035.1370904-2-hch@lst.de>

On Mon, Jun 22, 2026 at 09:30:00AM +0200, Christoph Hellwig wrote:
> This better integrates with the other failure handling in xfs_buf_submit,
> and prepares for a better API in xfs_buf_ioend_fail.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

> ---
>  fs/xfs/xfs_buf.c | 23 +++++++++++++----------
>  1 file changed, 13 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index 1ed9f01b3275..9aaa8b87fc33 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -1383,10 +1383,8 @@ xfs_buf_submit(
>  	 * state here rather than mount state to avoid corrupting the log tail
>  	 * on shutdown.
>  	 */
> -	if (bp->b_mount->m_log && xlog_is_shutdown(bp->b_mount->m_log)) {
> -		xfs_buf_ioend_fail(bp);
> -		return;
> -	}
> +	if (bp->b_mount->m_log && xlog_is_shutdown(bp->b_mount->m_log))
> +		goto ioerror;
>  
>  	if (bp->b_flags & XBF_WRITE)
>  		xfs_buf_wait_unpin(bp);
> @@ -1399,17 +1397,22 @@ xfs_buf_submit(
>  
>  	if ((bp->b_flags & XBF_WRITE) && !xfs_buf_verify_write(bp)) {
>  		xfs_force_shutdown(bp->b_mount, SHUTDOWN_CORRUPT_INCORE);
> -		xfs_buf_ioend(bp);
> -		return;
> +		goto end_io;
>  	}
>  
>  	/* In-memory targets are directly mapped, no I/O required. */
> -	if (xfs_buftarg_is_mem(bp->b_target)) {
> -		xfs_buf_ioend(bp);
> -		return;
> -	}
> +	if (xfs_buftarg_is_mem(bp->b_target))
> +		goto end_io;
>  
>  	xfs_buf_submit_bio(bp);
> +	return;
> +
> +ioerror:
> +	bp->b_flags &= ~XBF_DONE;
> +	xfs_buf_stale(bp);
> +	xfs_buf_ioerror(bp, -EIO);
> +end_io:
> +	xfs_buf_ioend(bp);
>  }
>  
>  /*
> -- 
> 2.53.0
> 
> 
