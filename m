Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01DB420371E;
	Fri, 22 Aug 2025 15:21:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755876100; cv=none; b=LroAT+ZtlOL9IIhzg3Lc7aA3RMaF2fgd2eLnDyupmC06v9bTEPN+IwvyFGF59kDKYxB4GOa4RJyJ8/OehTpEOSRHmt0QuT0FfFnrKKHcXahhhpXm/ghPO5nslZHtVDmJd8+bm4s9dop8sGKYn1qmEix9wH090wLRjHPlknM+6us=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755876100; c=relaxed/simple;
	bh=Rf7CEFvTvQH4upCUHlaBHZ50O7RvcFpKRMNUv3ou5cU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=F9BarC1Ko34Q8Er7yf2LhPYuzEMRdSoeKPOyelb/pd7+J8GHugzzTkRUzsFf8H76rY3CAhYWq5uuoukX1ZQ5h8ck4N7Y7+GAwCYd9EdFJaFaJ9P9CfiFZwQco792Gunb3+26DhjSlLgVAg8qnqDm1cZ/wtB59NXTM4114uyaQrc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=vJpI6Q+Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="vJpI6Q+Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DAF1C4CEED;
	Fri, 22 Aug 2025 15:21:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755876098;
	bh=Rf7CEFvTvQH4upCUHlaBHZ50O7RvcFpKRMNUv3ou5cU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=vJpI6Q+YeulW8yV3EWPl/I7EuVFDT5j0HTa9a/t6wJ49Uu0eO50ItgLkK0pqCK1Gi
	 lNLjztA0kXCdzT5A4dwa/F108f4cx0olkUgau5pxqh3lTkJHy5f0Pi9nGDHJwY/TR/
	 FIgP0DGOFwwbB9aFq2zlgBVGR7ty8XHF4yjaGBmpm9FlfMUQuB/10ktgdQxGQIcOBJ
	 MmgokUD5YkBBtzXBFtsGJC3dWu3g0uA/YxDtWAj0rvzQqZW1W1bxF37yuQ+G0bHdxz
	 XyhppNHBTO+3uH/VvkZ7Sibmk/LzsuaVdjx4nAqeKMdecYqGnkDAxEfmbPeWq73V6S
	 Y5E60NB9Loqww==
Date: Fri, 22 Aug 2025 08:21:37 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Cc: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
	Donald Douwsma <ddouwsma@redhat.com>,
	Dave Chinner <dchinner@redhat.com>,
	Christoph Hellwig <hch@infradead.org>, stable@vger.kernel.org
Subject: Re: [PATCH] xfs: do not propagate ENODATA disk errors into xattr code
Message-ID: <20250822152137.GE7965@frogsfrogsfrogs>
References: <a896ce2b-1c3b-4298-a90c-c2c0e18de4cb@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a896ce2b-1c3b-4298-a90c-c2c0e18de4cb@redhat.com>

On Thu, Aug 21, 2025 at 04:36:10PM -0500, Eric Sandeen wrote:
> ENODATA (aka ENOATTR) has a very specific meaning in the xfs xattr code;
> namely, that the requested attribute name could not be found.
> 
> However, a medium error from disk may also return ENODATA. At best,
> this medium error may escape to userspace as "attribute not found"
> when in fact it's an IO (disk) error.
> 
> At worst, we may oops in xfs_attr_leaf_get() when we do:
> 
> 	error = xfs_attr_leaf_hasname(args, &bp);
> 	if (error == -ENOATTR)  {
> 		xfs_trans_brelse(args->trans, bp);
> 		return error;
> 	}
> 
> because an ENODATA/ENOATTR error from disk leaves us with a null bp,
> and the xfs_trans_brelse will then null-deref it.
> 
> As discussed on the list, we really need to modify the lower level
> IO functions to trap all disk errors and ensure that we don't let
> unique errors like this leak up into higher xfs functions - many
> like this should be remapped to EIO.
> 
> However, this patch directly addresses a reported bug in the xattr
> code, and should be safe to backport to stable kernels. A larger-scope
> patch to handle more unique errors at lower levels can follow later.
> 
> (Note, prior to 07120f1abdff we did not oops, but we did return the
> wrong error code to userspace.)
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> Fixes: 07120f1abdff ("xfs: Add xfs_has_attr and subroutines")
> Cc: <stable@vger.kernel.org> # v5.9+
> ---
> 
> (I get it that sprinkling this around to 3 places might have an ick
> factor but I think it's necessary to make a surgical strike on this bug
> before we address the general problem.)
> 
> Thanks,
> -Eric
> 
> diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
> index fddb55605e0c..9b54cfb0e13d 100644
> --- a/fs/xfs/libxfs/xfs_attr_leaf.c
> +++ b/fs/xfs/libxfs/xfs_attr_leaf.c
> @@ -478,6 +478,12 @@ xfs_attr3_leaf_read(
>  
>  	err = xfs_da_read_buf(tp, dp, bno, 0, bpp, XFS_ATTR_FORK,
>  			&xfs_attr3_leaf_buf_ops);
> +	/*
> +	 * ENODATA from disk implies a disk medium failure; ENODATA for
> +	 * xattrs means attribute not found, so disambiguate that here.
> +	 */
> +	if (err == -ENODATA)
> +		err = -EIO;

I think this first chunk isn't needed since you also changed
xfs_da_read_buf to filter the error code, right?

(Shifting towards the giant reconsideration of ENODATA -> EIO filtering)

Do we now also need to adjust the online fsck code to turn ENODATA into
a corruption report?  From __xchk_process_error:

	case -EFSBADCRC:
	case -EFSCORRUPTED:
		/* Note the badness but don't abort. */
		sc->sm->sm_flags |= errflag;
		*error = 0;
		fallthrough;
	default:
		trace_xchk_op_error(sc, agno, bno, *error, ret_ip);
		break;
	}

We only flag corruptions for these two error codes, but ENODATA from the
block layer means "critical medium error".  I take that to mean the
media has permanently lost whatever was persisted there, right?

--D

>  	if (err || !(*bpp))
>  		return err;
>  
> diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_remote.c
> index 4c44ce1c8a64..bff3dc226f81 100644
> --- a/fs/xfs/libxfs/xfs_attr_remote.c
> +++ b/fs/xfs/libxfs/xfs_attr_remote.c
> @@ -435,6 +435,13 @@ xfs_attr_rmtval_get(
>  					0, &bp, &xfs_attr3_rmt_buf_ops);
>  			if (xfs_metadata_is_sick(error))
>  				xfs_dirattr_mark_sick(args->dp, XFS_ATTR_FORK);
> +			/*
> +			 * ENODATA from disk implies a disk medium failure;
> +			 * ENODATA for xattrs means attribute not found, so
> +			 * disambiguate that here.
> +			 */
> +			if (error == -ENODATA)
> +				error = -EIO;
>  			if (error)
>  				return error;
>  
> diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
> index 17d9e6154f19..723a0643b838 100644
> --- a/fs/xfs/libxfs/xfs_da_btree.c
> +++ b/fs/xfs/libxfs/xfs_da_btree.c
> @@ -2833,6 +2833,12 @@ xfs_da_read_buf(
>  			&bp, ops);
>  	if (xfs_metadata_is_sick(error))
>  		xfs_dirattr_mark_sick(dp, whichfork);
> +	/*
> +	 * ENODATA from disk implies a disk medium failure; ENODATA for
> +	 * xattrs means attribute not found, so disambiguate that here.
> +	 */
> +	if (error == -ENODATA && whichfork == XFS_ATTR_FORK)
> +		error = -EIO;
>  	if (error)
>  		goto out_free;
>  
> 
> 
