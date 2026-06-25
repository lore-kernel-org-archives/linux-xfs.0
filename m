Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD9873ED3BB
	for <linux-xfs@vger.kernel.org>; Thu, 25 Jun 2026 18:00:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782410403; cv=none; b=rTVOV9+FnaYFF3JQjhjWLX8WHpW4A41dZCrHa85tTTas6NvccCj2OqxZ+XVU5IYKnCwh18XOuxYSplS5PI/zmFpN3QnECI41n8/5jOuR6T4yJAjxMuF7TFXQw4C+eq7ug6s2TDyWQz0JAq/nWMqcM+arZkD6JRF199ELecRwQ6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782410403; c=relaxed/simple;
	bh=8qtMZKy02NsKsoh6rkY1gHgGmqCGeiRaRMnRJfdVz7w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eAmb863XVQYdC4KxPmwq5+9xAmKhhI3eZSrIWR1cIcMcnPbeJJQCMUDAYxnPOUTg0pPowApWVg/m4LbQkYY/R8reuTLE7I5+FwWuu4Lm1bPfSncy2iRTmyyXzq4b5Zlmu4fX5OCEM7OZl010wQqJr2SP2Cno+ChhkaGUpbRREOQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BE5uAxXg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BE5uAxXg"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 9366B1F000E9;
	Thu, 25 Jun 2026 18:00:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782410402;
	bh=ovjP1jhX3GytRXzELOtnRinPYTJet2L4XcvdIHOS6II=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=BE5uAxXglivVWv6//CxfuEzMvqBkcrtW+P0moGMX1ieGBUKQGhvmI9eUw66m85brJ
	 9QLSWLqRJbfN/Oi3FDsUC5JtcoBTqK/WjBDmdNe/WDnm+qppzuQTR0KPpcc1hmaxLh
	 o/8+mz1Pm1BBjN1zk5afD52PC39509bXcICYaLYVTtadIg+HucWeO7sfQnNceKhxGe
	 h6X4aDQ0i9spo2UiV4GB0GaNoTKZEbjXrLjMLSBH47k948XoWKXv5N+4pV8suAEhTV
	 9weUUkQKTrvl087j6aAFtk5u3olivgff3/z9iBHobohoE/K9lYMgygnTZkhpU3wxj9
	 1c9OiO/F3g2Rg==
Date: Thu, 25 Jun 2026 11:00:02 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org,
	Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH 2/6] xfs: also mark the buffer stale on verifier failure
 in xfs_buf_submit
Message-ID: <20260625180002.GG6078@frogsfrogsfrogs>
References: <20260625135849.2494779-1-hch@lst.de>
 <20260625135849.2494779-3-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260625135849.2494779-3-hch@lst.de>

On Thu, Jun 25, 2026 at 03:58:32PM +0200, Christoph Hellwig wrote:
> We should treat the buffer that caused a shutdown the same as handling
> buffers after a shutdown, so use the same stale && !DONE logic here.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
> ---
>  fs/xfs/xfs_buf.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index a108d31996f2..5ce48d8062fa 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -1383,8 +1383,10 @@ xfs_buf_submit(
>  	 * state here rather than mount state to avoid corrupting the log tail
>  	 * on shutdown.
>  	 */
> -	if (bp->b_mount->m_log && xlog_is_shutdown(bp->b_mount->m_log))
> +	if (bp->b_mount->m_log && xlog_is_shutdown(bp->b_mount->m_log)) {
> +		xfs_buf_ioerror(bp, -EIO);
>  		goto ioerror;

IDGI.  If the filesystem was already shut down, we set EIO on the
buffer, stale it, and complete the ioend...

> +	}
>  
>  	if (bp->b_flags & XBF_WRITE)
>  		xfs_buf_wait_unpin(bp);
> @@ -1397,7 +1399,7 @@ xfs_buf_submit(
>  
>  	if ((bp->b_flags & XBF_WRITE) && !xfs_buf_verify_write(bp)) {
>  		xfs_force_shutdown(bp->b_mount, SHUTDOWN_CORRUPT_INCORE);
> -		goto end_io;
> +		goto ioerror;

...but if bp itself causes the shutdown, we now leave b_error at 0, but
do the same stale-and-complete thing?  Shouldn't we set EIO on the
buffer in both cases?

--D

>  	}
>  
>  	/* In-memory targets are directly mapped, no I/O required. */
> @@ -1410,7 +1412,6 @@ xfs_buf_submit(
>  ioerror:
>  	bp->b_flags &= ~XBF_DONE;
>  	xfs_buf_stale(bp);
> -	xfs_buf_ioerror(bp, -EIO);
>  end_io:
>  	xfs_buf_ioend(bp);
>  }
> -- 
> 2.53.0
> 
> 
