Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E20DE394E93
	for <linux-xfs@vger.kernel.org>; Mon, 22 Jun 2026 12:42:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782132150; cv=none; b=KMqIeN6kBTsm60xB6i6hZgeOCydDANQfwqMSLTJsYJSrs1F/omurn15pvOCvkOW32Xus4Zuwi+hvqwr/1fAeQh7WLheJQrHVDsK9Y2EEaS5sPFm0K1eUYugfFt9NCxhJ0BO3igEklUabGuCujsF2KeVCU49+ljh6YQ9FoynVZT4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782132150; c=relaxed/simple;
	bh=80BV5/mPBkKPBCPFkgW+Yya6Ohn/SRsdnEv3W+ipzqs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kgG1uoH+0zGQv+azYJWjWbGjdOB8fwcfzY0pRUizBnjrNF8f+w0mhdwplQ9S5pqU4u/VqEbEqoXlQr5OTmjFVKyDYZrHyHrc8FDhB5EiITTSeTTCWnzX4bLzpkXYq8Jx4TX8ccZGo4I2Ue3ogL/69VN8B+2BxjNcTA1hf3eXCk8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=A+WuEB++; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="A+WuEB++"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D012A1F000E9;
	Mon, 22 Jun 2026 12:42:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782132149;
	bh=GijpNQFp0/eqNAaok8ZUpuTKPX2KbIsbXg7nu9g7FEc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=A+WuEB++IoohMrhdyZRBHwdAoMlJQKm2tz/h1ZalP/p2oCh2l0ePdYTkmV6Qd2QS+
	 uyPd97Nlpbmc3vQPYYVP8yEUJpobg73xsIJpWqNPMFuDUF1UO96GD6kM72K+o01v2P
	 rAG+qbpiGcJNCuDFeedJFi+aVxM64eEc5hxnpejERhg0x/7UPnF6thHp7WATsMKb1Q
	 U6hH8HwuwOU1vKsQX8DJEIFuuQ4BylLx562SsxGeT576iyD+4cLtRai2GvHybSxcnL
	 fLvk/Uw+Oh/ne/VyH0NG7FboIf+PFWR7W8ykZb3tngrI1fu10Fg2w3/zF3Xt1RPaY0
	 K138xJ6nyW/mQ==
Date: Mon, 22 Jun 2026 14:42:26 +0200
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/6] xfs: also mark the buffer stale on verifier failure
 in xfs_buf_submit
Message-ID: <ajktq0belGLqsZHV@nidhogg.toxiclabs.cc>
References: <20260622073035.1370904-1-hch@lst.de>
 <20260622073035.1370904-3-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260622073035.1370904-3-hch@lst.de>

On Mon, Jun 22, 2026 at 09:30:01AM +0200, Christoph Hellwig wrote:
> We should treat the buffer that caused a shutdown the same as handling
> buffers after a shutdown, so use the same stale && !DONE logic here.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

> ---
>  fs/xfs/xfs_buf.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index 9aaa8b87fc33..60ef53acebd2 100644
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
