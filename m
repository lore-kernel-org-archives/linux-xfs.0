Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1129931F98E
	for <linux-xfs@vger.kernel.org>; Fri, 24 Jul 2026 16:57:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784912228; cv=none; b=kk3PrWOfNFau5FsQb6VavqSWgeYpvxxJ/Df/eX6TfXsK4Jga4gMMZLFz9crILC3+Ta7Blu23OMPGFJqJzOm03xEpREf1p34z59/FLuDP8Ch96ZMicXuaQniL3W/JkWN9basAyjpDXpFQXqf6ughikM90OIVT0b7P4YUTFM1bQ7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784912228; c=relaxed/simple;
	bh=l8S6KGfrs3Mdfor90AtKIWCT8zG3Y/Wl3rjFZ8GvxYU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QvY8z8+aQMFhtksE2DCMIbWD5HVLoVMx+0ty6O8ZJCf+t2qb+9e+lvq24d2l4E7jC6Gc04Q4ooBhvicmojMbuqtfJn4Q0/BDNXhxJY8qjGn8W00Rj9UPk7Y3ZLniRz5hRmoS3G++SGs78Ede1PtN4kuBMayBiMoQ1K390MnA/9c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=C6dbcUj1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="C6dbcUj1"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 7478F1F000E9;
	Fri, 24 Jul 2026 16:57:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784912226;
	bh=Ha3RwsDp+IT/z5IihGHiYC5K8DVVEEC3dvHhTvv2C1c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=C6dbcUj1iY7LF8/VF9n/0w/JV51/TAjZxXwKxRgXshalpYXsxaxd+5Ts3j82nI9Ql
	 S6ORCIdqWRvnNnCCHgnJpavSj0GDxiuiEcbd6uVkxDvTgafuzPbVP97vZ+DZOyJLUQ
	 2NfHFUx08siFN2m9j56wzDy2A2JvSTZFEhYvV3KM9IA2Ocnr42pRIggxvjQBmn+IEQ
	 smLaITi/xJxacdl8tM4yk2Pz6qFXFw/gx0oob/aDffEdaFoXohJDwWwWjewIVA/D0m
	 ePPJMWUwHmKG8M566ok0RpxHgm3sCpo1UQQunNBjlsTxYOcbWaPHe4YO7qHxsYaVoS
	 Fu/018siGNbUA==
Date: Fri, 24 Jul 2026 09:57:06 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 09/12] xfs: use goto based error unwinding in
 xfs_buf_read_map
Message-ID: <20260724165706.GW2901224@frogsfrogsfrogs>
References: <20260715145147.95654-1-hch@lst.de>
 <20260715145147.95654-10-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260715145147.95654-10-hch@lst.de>

On Wed, Jul 15, 2026 at 04:51:02PM +0200, Christoph Hellwig wrote:
> This keeps the I/O error handling contained at the end of the function
> and removes the indentation for it.  It also allows to reorder the
> comments so that they are closer to the logic that they describe.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good to me,
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_buf.c | 47 ++++++++++++++++++++++++-----------------------
>  1 file changed, 24 insertions(+), 23 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index 4430da3259f1..21c21491d72e 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -699,6 +699,23 @@ xfs_buf_read_map(
>  		ASSERT(bp->b_ops != NULL || ops == NULL);
>  	}
>  
> +	if (error)
> +		goto out_ioerror;
> +
> +	*bpp = bp;
> +	return 0;
> +
> +out_ioerror:
> +	/*
> +	 * Check against log shutdown for error reporting because metadata
> +	 * writeback may require a read first and we need to report errors in
> +	 * metadata writeback until the log is shut down.  High level
> +	 * transaction read functions already check against mount shutdown, so
> +	 * we only need to be concerned about low level/ IO interactions here.
> +	 */
> +	if (!xlog_is_shutdown(target->bt_mount->m_log))
> +		xfs_buf_ioerror_alert(bp, fa);
> +
>  	/*
>  	 * If we've had a read error, then the contents of the buffer are
>  	 * invalid and should not be used. To ensure that a followup read tries
> @@ -708,30 +725,14 @@ xfs_buf_read_map(
>  	 * future cache lookups will also treat it as an empty, uninitialised
>  	 * buffer.
>  	 */
> -	if (error) {
> -		/*
> -		 * Check against log shutdown for error reporting because
> -		 * metadata writeback may require a read first and we need to
> -		 * report errors in metadata writeback until the log is shut
> -		 * down. High level transaction read functions already check
> -		 * against mount shutdown, anyway, so we only need to be
> -		 * concerned about low level IO interactions here.
> -		 */
> -		if (!xlog_is_shutdown(target->bt_mount->m_log))
> -			xfs_buf_ioerror_alert(bp, fa);
> -
> -		xfs_buf_clear_flags(bp, XBF_DONE);
> -		xfs_buf_stale(bp);
> -		xfs_buf_relse(bp);
> -
> -		/* bad CRC means corrupted metadata */
> -		if (error == -EFSBADCRC)
> -			error = -EFSCORRUPTED;
> -		return error;
> -	}
> +	xfs_buf_clear_flags(bp, XBF_DONE);
> +	xfs_buf_stale(bp);
> +	xfs_buf_relse(bp);
>  
> -	*bpp = bp;
> -	return 0;
> +	/* bad CRC means corrupted metadata */
> +	if (error == -EFSBADCRC)
> +		return -EFSCORRUPTED;
> +	return error;
>  }
>  
>  /*
> -- 
> 2.53.0
> 
> 
