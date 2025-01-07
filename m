Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 166EB1DED66
	for <linux-xfs@vger.kernel.org>; Tue,  7 Jan 2025 06:33:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736231631; cv=none; b=PmppKOrUpx4tWqQCuGHsinABX7qoVek4PmK5WPcgcXcDu2RmmXKUMBUaNnarbxulx2Lu0nRRttzbX6zcL6JKEms3wGFVQzNQcjiCN1F9iwoRJlyuLNxWaY0rM00mIp8nldiIs2VMp8aWgjMJsWo0PifxPTd+DjytQ5/nJvoV+Bk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736231631; c=relaxed/simple;
	bh=Uz73uQzU9yYF4ug6b5rAANfQ/se/YlkJ1Cr8HOh7MvY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Kh0rKUM6o2DXuc08IHeOW3jflM+qNeh4sX7MrgdoCjfb6QDGYzooatruLf9X31xpByrdzjPXPifHc02qreEbLnUaz265mnbqEixF0uHyNDwRH3lHLqosho0ExptLHt/5+z7PUz4gstn4UtQPO0M0amFBmXbKvVmEzyk3484FQm0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Oa8xq0Ro; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Oa8xq0Ro"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0EC3C4CED6;
	Tue,  7 Jan 2025 06:33:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736231630;
	bh=Uz73uQzU9yYF4ug6b5rAANfQ/se/YlkJ1Cr8HOh7MvY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Oa8xq0RodMwZgTtoQdew3f2RpC3QkO7uUwNL4C8xBhQ6cgvzYTAzyJI8y2Ujhje8i
	 V40MsZOMlZYLrD6wpuNTA2POwjpkzg81wkXEfgoUXdvwh962k0NAV21zcelASgM9qs
	 J7LfmkJyC82dg54YB20ljeUsnsbQfXYXbwPVKQ243ir24l72LY2TduwVMpXzlSC6tZ
	 nIRKa10qMlaXgE5Rp+Sdw14sHx3AUzBaSpJdDWyhBuWD/6oAzcyKll467FTEoLYC/J
	 QPjTFqvrnScV7srjru72kTDdofNIHvYhvsRmbsT6MNcxeVg1XniO7IfCWjWrVXG3wy
	 G6yJAKFftNfng==
Date: Mon, 6 Jan 2025 22:33:50 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 07/15] xfs: move write verification out of
 _xfs_buf_ioapply
Message-ID: <20250107063350.GY6174@frogsfrogsfrogs>
References: <20250106095613.847700-1-hch@lst.de>
 <20250106095613.847700-8-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250106095613.847700-8-hch@lst.de>

On Mon, Jan 06, 2025 at 10:54:44AM +0100, Christoph Hellwig wrote:
> Split the write verification logic out of _xfs_buf_ioapply into a new
> xfs_buf_verify_write helper called by xfs_buf_submit given that it isn't
> about applying the I/O and doesn't really fit in with the rest of
> _xfs_buf_ioapply.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Yeah, it's useful to break up this function...
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_buf.c | 67 ++++++++++++++++++++++++++----------------------
>  1 file changed, 37 insertions(+), 30 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index e48d796c786b..18e830c4e990 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -1615,36 +1615,6 @@ _xfs_buf_ioapply(
>  
>  	if (bp->b_flags & XBF_WRITE) {
>  		op = REQ_OP_WRITE;
> -
> -		/*
> -		 * Run the write verifier callback function if it exists. If
> -		 * this function fails it will mark the buffer with an error and
> -		 * the IO should not be dispatched.
> -		 */
> -		if (bp->b_ops) {
> -			bp->b_ops->verify_write(bp);
> -			if (bp->b_error) {
> -				xfs_force_shutdown(bp->b_mount,
> -						   SHUTDOWN_CORRUPT_INCORE);
> -				return;
> -			}
> -		} else if (bp->b_rhash_key != XFS_BUF_DADDR_NULL) {
> -			struct xfs_mount *mp = bp->b_mount;
> -
> -			/*
> -			 * non-crc filesystems don't attach verifiers during
> -			 * log recovery, so don't warn for such filesystems.
> -			 */
> -			if (xfs_has_crc(mp)) {
> -				xfs_warn(mp,
> -					"%s: no buf ops on daddr 0x%llx len %d",
> -					__func__, xfs_buf_daddr(bp),
> -					bp->b_length);
> -				xfs_hex_dump(bp->b_addr,
> -						XFS_CORRUPTION_DUMP_LEN);
> -				dump_stack();
> -			}
> -		}
>  	} else {
>  		op = REQ_OP_READ;
>  		if (bp->b_flags & XBF_READ_AHEAD)
> @@ -1693,6 +1663,36 @@ xfs_buf_iowait(
>  	return bp->b_error;
>  }
>  
> +/*
> + * Run the write verifier callback function if it exists. If this fails, mark
> + * the buffer with an error and do not dispatch the I/O.
> + */
> +static bool
> +xfs_buf_verify_write(
> +	struct xfs_buf		*bp)
> +{
> +	if (bp->b_ops) {
> +		bp->b_ops->verify_write(bp);
> +		if (bp->b_error)
> +			return false;
> +	} else if (bp->b_rhash_key != XFS_BUF_DADDR_NULL) {
> +		/*
> +		 * Non-crc filesystems don't attach verifiers during log
> +		 * recovery, so don't warn for such filesystems.
> +		 */
> +		if (xfs_has_crc(bp->b_mount)) {
> +			xfs_warn(bp->b_mount,
> +				"%s: no buf ops on daddr 0x%llx len %d",
> +				__func__, xfs_buf_daddr(bp),
> +				bp->b_length);
> +			xfs_hex_dump(bp->b_addr, XFS_CORRUPTION_DUMP_LEN);
> +			dump_stack();
> +		}
> +	}
> +
> +	return true;
> +}
> +
>  /*
>   * Buffer I/O submission path, read or write. Asynchronous submission transfers
>   * the buffer lock ownership and the current reference to the IO. It is not
> @@ -1751,8 +1751,15 @@ xfs_buf_submit(
>  	atomic_set(&bp->b_io_remaining, 1);
>  	if (bp->b_flags & XBF_ASYNC)
>  		xfs_buf_ioacct_inc(bp);
> +
> +	if ((bp->b_flags & XBF_WRITE) && !xfs_buf_verify_write(bp)) {
> +		xfs_force_shutdown(bp->b_mount, SHUTDOWN_CORRUPT_INCORE);
> +		goto done;
> +	}
> +
>  	_xfs_buf_ioapply(bp);
>  
> +done:
>  	/*
>  	 * If _xfs_buf_ioapply failed, we can get back here with only the IO
>  	 * reference we took above. If we drop it to zero, run completion so
> -- 
> 2.45.2
> 
> 
