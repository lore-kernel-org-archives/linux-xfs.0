Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 728E122A4FC;
	Mon, 25 Aug 2025 15:34:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756136095; cv=none; b=AowAmwDkluhg1TANMpLQAYrI1TGJmBISw2irA9whSNNKCHReWCWFluEQkwWpCiSw8Z9WTOEn0JaFJtuVQFEgbqjwpHVxjK8oadmJ+wniaa6UwExdHRPYIScLFn8aslPf2g2VyXcDihyMf3BB8W3mhjYzHkOn4YUlngWc2ka8YeE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756136095; c=relaxed/simple;
	bh=93WjmWmv98uW6CWBXIe87q2NVPy62VRzd3+wmMkUvm4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gf/oM6fwtt8whDin9KM0nNOt70bMUYj8VVfNikRfNmhLodmw6Hltbou1gfSqVC3bLUKdnUWYcO43qJokaAiIVgJhqyvZTPqO+O6do6XZm1vtsa7PeveZ56qAYTfFw5sCj8CtjUn7xOy07B8/5CKjt+yVamHc11Z0/mxuqU2sk7w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Yees0J03; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Yees0J03"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8D3DC4CEF4;
	Mon, 25 Aug 2025 15:34:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756136095;
	bh=93WjmWmv98uW6CWBXIe87q2NVPy62VRzd3+wmMkUvm4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Yees0J03TA5nNO8j7AVY7eEPgh+ufm8d83jghnz6tz5aEkdXVSqrMG7Fcyr7gjVyx
	 bMUSsqhI1M97znMqyUuCoa47UAg+YJQn8q2ED1dTySh1fdNArM+BP32HbAwLobM8oZ
	 ejh8fCpAZDrf3bSbYOfDagfgIzkJ0Yx6DDgu3lWh16l2HSaruK6Hr6xEZYx+yVMrzu
	 UDzsro1xZ/Qw/sMPOYsISEu6NAo1iWaYhGHBzHb3MdCkj9I0E1Iea98YILwYVj+JnB
	 YmuAFKiFzT4CEnhUm2E4FmgoQk4eUhjjIH8nFQSPY5XGWophgYi1Ou6am37oiJpFTF
	 BoydFRjnj7DVw==
Date: Mon, 25 Aug 2025 08:34:54 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Cc: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
	Donald Douwsma <ddouwsma@redhat.com>,
	Dave Chinner <dchinner@redhat.com>,
	Christoph Hellwig <hch@infradead.org>, stable@vger.kernel.org
Subject: Re: [PATCH V2] xfs: do not propagate ENODATA disk errors into xattr
 code
Message-ID: <20250825153454.GD812310@frogsfrogsfrogs>
References: <06c9617f-a753-40f3-a632-ab08fe0c4d4d@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <06c9617f-a753-40f3-a632-ab08fe0c4d4d@redhat.com>

On Fri, Aug 22, 2025 at 12:55:56PM -0500, Eric Sandeen wrote:
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

Yeah, seems fine to me.  Thanks for putting this together.
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
> 
> V2: Remove the extraneous trap point as pointed out by djwong, oops.
> 
> (I get it that sprinkling this around in 2 places might have an ick
> factor but I think it's necessary to make a surgical strike on this bug
> before we address the general problem.)
> 
> Thanks,
> -Eric
> 
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
> 
