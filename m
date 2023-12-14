Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EAD56E58E
	for <linux-xfs@vger.kernel.org>; Thu, 14 Dec 2023 20:50:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="I4Ayswc4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08320C433C7;
	Thu, 14 Dec 2023 20:50:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1702587039;
	bh=4avrPFiU5QGoHds9DErPv0eI74cmRExi9PF+UUhxlLk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=I4Ayswc4i4cBWeUP03Gm62uqFlbnYmWNEgi25hVvJJeiAbZAXxn4PoxtPVnUagUS7
	 stphlgAuu2ddgxsJh1bEfwYqIdpBMhaDxblyZIp5rLyZmfA2ifka/wcCVLcdIbJJem
	 pJ8p9KWu2mpcpPwSmBAC2fkZIqn97tmswPLizEj2wvcmme74ni9gWLvVMyvZPXUdCz
	 eJwlfcsF+8oSwbpR+JODMbkgmLAFMnpZLfravUvicIf7nqquBd9m2+mj6Mm+eAGZ4T
	 F/0oR03YbB8E2hqcKOMAv2m4dKnXdh8OoqOSjRHrv92qYoalcAxW8soFPjJwgxWjf/
	 pjYMow2E+Iirg==
Date: Thu, 14 Dec 2023 12:50:38 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 06/19] xfs: return -ENOSPC from xfs_rtallocate_*
Message-ID: <20231214205038.GU361584@frogsfrogsfrogs>
References: <20231214063438.290538-1-hch@lst.de>
 <20231214063438.290538-7-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231214063438.290538-7-hch@lst.de>

On Thu, Dec 14, 2023 at 07:34:25AM +0100, Christoph Hellwig wrote:
> Just return -ENOSPC instead of returning 0 and setting the return rt
> extent number to NULLRTEXTNO.  This is turn removes all users of
> NULLRTEXTNO, so remove that as well.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/libxfs/xfs_types.h |   1 -
>  fs/xfs/xfs_rtalloc.c      | 211 +++++++++++++-------------------------
>  2 files changed, 71 insertions(+), 141 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_types.h b/fs/xfs/libxfs/xfs_types.h
> index 533200c4ccc25a..c3636ea21ecd05 100644
> --- a/fs/xfs/libxfs/xfs_types.h
> +++ b/fs/xfs/libxfs/xfs_types.h
> @@ -51,7 +51,6 @@ typedef void *		xfs_failaddr_t;
>  #define	NULLRFSBLOCK	((xfs_rfsblock_t)-1)
>  #define	NULLRTBLOCK	((xfs_rtblock_t)-1)
>  #define	NULLFILEOFF	((xfs_fileoff_t)-1)
> -#define	NULLRTEXTNO	((xfs_rtxnum_t)-1)

Getting rid of this cleans out a nice quantity of if test cruft in the
rt modernization series, so...
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

>  
>  #define	NULLAGBLOCK	((xfs_agblock_t)-1)
>  #define	NULLAGNUMBER	((xfs_agnumber_t)-1)
> diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
> index 74edea8579818d..dac148d53af3ec 100644
> --- a/fs/xfs/xfs_rtalloc.c
> +++ b/fs/xfs/xfs_rtalloc.c
> @@ -156,17 +156,17 @@ xfs_rtallocate_range(
>  	 * properly update the summary.
>  	 */
>  	error = xfs_rtfind_back(args, start, 0, &preblock);
> -	if (error) {
> +	if (error)
>  		return error;
> -	}
> +
>  	/*
>  	 * Find the next allocated block (end of free extent).
>  	 */
>  	error = xfs_rtfind_forw(args, end, mp->m_sb.sb_rextents - 1,
>  			&postblock);
> -	if (error) {
> +	if (error)
>  		return error;
> -	}
> +
>  	/*
>  	 * Decrement the summary information corresponding to the entire
>  	 * (old) free extent.
> @@ -174,9 +174,9 @@ xfs_rtallocate_range(
>  	error = xfs_rtmodify_summary(args,
>  			XFS_RTBLOCKLOG(postblock + 1 - preblock),
>  			xfs_rtx_to_rbmblock(mp, preblock), -1);
> -	if (error) {
> +	if (error)
>  		return error;
> -	}
> +
>  	/*
>  	 * If there are blocks not being allocated at the front of the
>  	 * old extent, add summary data for them to be free.
> @@ -185,10 +185,10 @@ xfs_rtallocate_range(
>  		error = xfs_rtmodify_summary(args,
>  				XFS_RTBLOCKLOG(start - preblock),
>  				xfs_rtx_to_rbmblock(mp, preblock), 1);
> -		if (error) {
> +		if (error)
>  			return error;
> -		}
>  	}
> +
>  	/*
>  	 * If there are blocks not being allocated at the end of the
>  	 * old extent, add summary data for them to be free.
> @@ -197,15 +197,14 @@ xfs_rtallocate_range(
>  		error = xfs_rtmodify_summary(args,
>  				XFS_RTBLOCKLOG(postblock - end),
>  				xfs_rtx_to_rbmblock(mp, end + 1), 1);
> -		if (error) {
> +		if (error)
>  			return error;
> -		}
>  	}
> +
>  	/*
>  	 * Modify the bitmap to mark this extent allocated.
>  	 */
> -	error = xfs_rtmodify_range(args, start, len, 0);
> -	return error;
> +	return xfs_rtmodify_range(args, start, len, 0);
>  }
>  
>  /*
> @@ -267,17 +266,17 @@ xfs_rtallocate_extent_block(
>  		 * If it's not so then next will contain the first non-free.
>  		 */
>  		error = xfs_rtcheck_range(args, i, maxlen, 1, &next, &stat);
> -		if (error) {
> +		if (error)
>  			return error;
> -		}
> +
>  		if (stat) {
>  			/*
>  			 * i for maxlen is all free, allocate and return that.
>  			 */
>  			error = xfs_rtallocate_range(args, i, maxlen);
> -			if (error) {
> +			if (error)
>  				return error;
> -			}
> +
>  			*len = maxlen;
>  			*rtx = i;
>  			return 0;
> @@ -302,9 +301,8 @@ xfs_rtallocate_extent_block(
>  		 */
>  		if (next < end) {
>  			error = xfs_rtfind_forw(args, next, end, &i);
> -			if (error) {
> +			if (error)
>  				return error;
> -			}
>  		} else
>  			break;
>  	}
> @@ -327,9 +325,8 @@ xfs_rtallocate_extent_block(
>  		 * Allocate besti for bestlen & return that.
>  		 */
>  		error = xfs_rtallocate_range(args, besti, bestlen);
> -		if (error) {
> +		if (error)
>  			return error;
> -		}
>  		*len = bestlen;
>  		*rtx = besti;
>  		return 0;
> @@ -338,8 +335,7 @@ xfs_rtallocate_extent_block(
>  	 * Allocation failed.  Set *nextp to the next block to try.
>  	 */
>  	*nextp = next;
> -	*rtx = NULLRTEXTNO;
> -	return 0;
> +	return -ENOSPC;
>  }
>  
>  /*
> @@ -369,17 +365,16 @@ xfs_rtallocate_extent_exact(
>  	 * Check if the range in question (for maxlen) is free.
>  	 */
>  	error = xfs_rtcheck_range(args, start, maxlen, 1, &next, &isfree);
> -	if (error) {
> +	if (error)
>  		return error;
> -	}
> +
>  	if (isfree) {
>  		/*
>  		 * If it is, allocate it and return success.
>  		 */
>  		error = xfs_rtallocate_range(args, start, maxlen);
> -		if (error) {
> +		if (error)
>  			return error;
> -		}
>  		*len = maxlen;
>  		*rtx = start;
>  		return 0;
> @@ -388,33 +383,23 @@ xfs_rtallocate_extent_exact(
>  	 * If not, allocate what there is, if it's at least minlen.
>  	 */
>  	maxlen = next - start;
> -	if (maxlen < minlen) {
> -		/*
> -		 * Failed, return failure status.
> -		 */
> -		*rtx = NULLRTEXTNO;
> -		return 0;
> -	}
> +	if (maxlen < minlen)
> +		return -ENOSPC;
> +
>  	/*
>  	 * Trim off tail of extent, if prod is specified.
>  	 */
>  	if (prod > 1 && (i = maxlen % prod)) {
>  		maxlen -= i;
> -		if (maxlen < minlen) {
> -			/*
> -			 * Now we can't do it, return failure status.
> -			 */
> -			*rtx = NULLRTEXTNO;
> -			return 0;
> -		}
> +		if (maxlen < minlen)
> +			return -ENOSPC;
>  	}
>  	/*
>  	 * Allocate what we can and return it.
>  	 */
>  	error = xfs_rtallocate_range(args, start, maxlen);
> -	if (error) {
> +	if (error)
>  		return error;
> -	}
>  	*len = maxlen;
>  	*rtx = start;
>  	return 0;
> @@ -443,7 +428,6 @@ xfs_rtallocate_extent_near(
>  	int			j;	/* secondary loop control */
>  	int			log2len; /* log2 of minlen */
>  	xfs_rtxnum_t		n;	/* next rtext to try */
> -	xfs_rtxnum_t		r;	/* result rtext */
>  
>  	ASSERT(minlen % prod == 0);
>  	ASSERT(maxlen % prod == 0);
> @@ -457,26 +441,18 @@ xfs_rtallocate_extent_near(
>  
>  	/* Make sure we don't run off the end of the rt volume. */
>  	maxlen = xfs_rtallocate_clamp_len(mp, start, maxlen, prod);
> -	if (maxlen < minlen) {
> -		*rtx = NULLRTEXTNO;
> -		return 0;
> -	}
> +	if (maxlen < minlen)
> +		return -ENOSPC;
>  
>  	/*
>  	 * Try the exact allocation first.
>  	 */
>  	error = xfs_rtallocate_extent_exact(args, start, minlen, maxlen, len,
> -			prod, &r);
> -	if (error) {
> +			prod, rtx);
> +	if (error != -ENOSPC)
>  		return error;
> -	}
> -	/*
> -	 * If the exact allocation worked, return that.
> -	 */
> -	if (r != NULLRTEXTNO) {
> -		*rtx = r;
> -		return 0;
> -	}
> +
> +
>  	bbno = xfs_rtx_to_rbmblock(mp, start);
>  	i = 0;
>  	j = -1;
> @@ -492,9 +468,9 @@ xfs_rtallocate_extent_near(
>  		 */
>  		error = xfs_rtany_summary(args, log2len, mp->m_rsumlevels - 1,
>  				bbno + i, &maxlog);
> -		if (error) {
> +		if (error)
>  			return error;
> -		}
> +
>  		/*
>  		 * If there are any useful extents starting here, try
>  		 * allocating one.
> @@ -513,17 +489,9 @@ xfs_rtallocate_extent_near(
>  				 */
>  				error = xfs_rtallocate_extent_block(args,
>  						bbno + i, minlen, maxavail, len,
> -						&n, prod, &r);
> -				if (error) {
> +						&n, prod, rtx);
> +				if (error != -ENOSPC)
>  					return error;
> -				}
> -				/*
> -				 * If it worked, return it.
> -				 */
> -				if (r != NULLRTEXTNO) {
> -					*rtx = r;
> -					return 0;
> -				}
>  			}
>  			/*
>  			 * On the negative side of the starting location.
> @@ -557,17 +525,9 @@ xfs_rtallocate_extent_near(
>  					error = xfs_rtallocate_extent_block(args,
>  							bbno + j, minlen,
>  							maxavail, len, &n, prod,
> -							&r);
> -					if (error) {
> +							rtx);
> +					if (error != -ENOSPC)
>  						return error;
> -					}
> -					/*
> -					 * If it works, return the extent.
> -					 */
> -					if (r != NULLRTEXTNO) {
> -						*rtx = r;
> -						return 0;
> -					}
>  				}
>  			}
>  		}
> @@ -601,8 +561,7 @@ xfs_rtallocate_extent_near(
>  		else
>  			break;
>  	}
> -	*rtx = NULLRTEXTNO;
> -	return 0;
> +	return -ENOSPC;
>  }
>  
>  /*
> @@ -624,7 +583,6 @@ xfs_rtallocate_extent_size(
>  	xfs_fileoff_t		i;	/* bitmap block number */
>  	int			l;	/* level number (loop control) */
>  	xfs_rtxnum_t		n;	/* next rtext to be tried */
> -	xfs_rtxnum_t		r;	/* result rtext number */
>  	xfs_suminfo_t		sum;	/* summary information for extents */
>  
>  	ASSERT(minlen % prod == 0);
> @@ -647,9 +605,8 @@ xfs_rtallocate_extent_size(
>  			 * Get the summary for this level/block.
>  			 */
>  			error = xfs_rtget_summary(args, l, i, &sum);
> -			if (error) {
> +			if (error)
>  				return error;
> -			}
>  			/*
>  			 * Nothing there, on to the next block.
>  			 */
> @@ -659,17 +616,9 @@ xfs_rtallocate_extent_size(
>  			 * Try allocating the extent.
>  			 */
>  			error = xfs_rtallocate_extent_block(args, i, maxlen,
> -					maxlen, len, &n, prod, &r);
> -			if (error) {
> +					maxlen, len, &n, prod, rtx);
> +			if (error != -ENOSPC)
>  				return error;
> -			}
> -			/*
> -			 * If it worked, return that.
> -			 */
> -			if (r != NULLRTEXTNO) {
> -				*rtx = r;
> -				return 0;
> -			}
>  			/*
>  			 * If the "next block to try" returned from the
>  			 * allocator is beyond the next bitmap block,
> @@ -683,10 +632,8 @@ xfs_rtallocate_extent_size(
>  	 * Didn't find any maxlen blocks.  Try smaller ones, unless
>  	 * we're asking for a fixed size extent.
>  	 */
> -	if (minlen > --maxlen) {
> -		*rtx = NULLRTEXTNO;
> -		return 0;
> -	}
> +	if (minlen > --maxlen)
> +		return -ENOSPC;
>  	ASSERT(minlen != 0);
>  	ASSERT(maxlen != 0);
>  
> @@ -705,9 +652,9 @@ xfs_rtallocate_extent_size(
>  			 * Get the summary information for this level/block.
>  			 */
>  			error =	xfs_rtget_summary(args, l, i, &sum);
> -			if (error) {
> +			if (error)
>  				return error;
> -			}
> +
>  			/*
>  			 * If nothing there, go on to next.
>  			 */
> @@ -721,17 +668,10 @@ xfs_rtallocate_extent_size(
>  			error = xfs_rtallocate_extent_block(args, i,
>  					XFS_RTMAX(minlen, 1 << l),
>  					XFS_RTMIN(maxlen, (1 << (l + 1)) - 1),
> -					len, &n, prod, &r);
> -			if (error) {
> +					len, &n, prod, rtx);
> +			if (error != -ENOSPC)
>  				return error;
> -			}
> -			/*
> -			 * If it worked, return that extent.
> -			 */
> -			if (r != NULLRTEXTNO) {
> -				*rtx = r;
> -				return 0;
> -			}
> +
>  			/*
>  			 * If the "next block to try" returned from the
>  			 * allocator is beyond the next bitmap block,
> @@ -744,8 +684,7 @@ xfs_rtallocate_extent_size(
>  	/*
>  	 * Got nothing, return failure.
>  	 */
> -	*rtx = NULLRTEXTNO;
> -	return 0;
> +	return -ENOSPC;
>  }
>  
>  /*
> @@ -1177,14 +1116,13 @@ xfs_rtallocate_extent(
>  	xfs_rtxlen_t		*len,	/* out: actual length allocated */
>  	int			wasdel,	/* was a delayed allocation extent */
>  	xfs_rtxlen_t		prod,	/* extent product factor */
> -	xfs_rtxnum_t		*rtblock) /* out: start rtext allocated */
> +	xfs_rtxnum_t		*rtx)	/* out: start rtext allocated */
>  {
>  	struct xfs_rtalloc_args	args = {
>  		.mp		= tp->t_mountp,
>  		.tp		= tp,
>  	};
>  	int			error;	/* error value */
> -	xfs_rtxnum_t		r;	/* result allocated rtext */
>  
>  	ASSERT(xfs_isilocked(args.mp->m_rbmip, XFS_ILOCK_EXCL));
>  	ASSERT(minlen > 0 && minlen <= maxlen);
> @@ -1199,42 +1137,35 @@ xfs_rtallocate_extent(
>  			maxlen -= i;
>  		if ((i = minlen % prod))
>  			minlen += prod - i;
> -		if (maxlen < minlen) {
> -			*rtblock = NULLRTEXTNO;
> -			return 0;
> -		}
> +		if (maxlen < minlen)
> +			return -ENOSPC;
>  	}
>  
>  retry:
>  	if (start == 0) {
>  		error = xfs_rtallocate_extent_size(&args, minlen,
> -				maxlen, len, prod, &r);
> +				maxlen, len, prod, rtx);
>  	} else {
>  		error = xfs_rtallocate_extent_near(&args, start, minlen,
> -				maxlen, len, prod, &r);
> +				maxlen, len, prod, rtx);
>  	}
> -
>  	xfs_rtbuf_cache_relse(&args);
> -	if (error)
> +	if (error) {
> +		if (error == -ENOSPC && prod > 1) {
> +			prod = 1;
> +			goto retry;
> +		}
>  		return error;
> +	}
>  
>  	/*
>  	 * If it worked, update the superblock.
>  	 */
> -	if (r != NULLRTEXTNO) {
> -		long	slen = (long)*len;
> -
> -		ASSERT(*len >= minlen && *len <= maxlen);
> -		if (wasdel)
> -			xfs_trans_mod_sb(tp, XFS_TRANS_SB_RES_FREXTENTS, -slen);
> -		else
> -			xfs_trans_mod_sb(tp, XFS_TRANS_SB_FREXTENTS, -slen);
> -	} else if (prod > 1) {
> -		prod = 1;
> -		goto retry;
> -	}
> -
> -	*rtblock = r;
> +	ASSERT(*len >= minlen && *len <= maxlen);
> +	if (wasdel)
> +		xfs_trans_mod_sb(tp, XFS_TRANS_SB_RES_FREXTENTS, -(long)*len);
> +	else
> +		xfs_trans_mod_sb(tp, XFS_TRANS_SB_FREXTENTS, -(long)*len);
>  	return 0;
>  }
>  
> @@ -1548,16 +1479,16 @@ xfs_bmap_rtalloc(
>  	raminlen = max_t(xfs_rtxlen_t, 1, xfs_extlen_to_rtxlen(mp, minlen));
>  	error = xfs_rtallocate_extent(ap->tp, rtx, raminlen, ralen, &ralen,
>  			ap->wasdel, prod, &rtx);
> -	if (error)
> -		return error;
> -
> -	if (rtx != NULLRTEXTNO) {
> +	if (!error) {
>  		ap->blkno = xfs_rtx_to_rtb(mp, rtx);
>  		ap->length = xfs_rtxlen_to_extlen(mp, ralen);
>  		xfs_bmap_alloc_account(ap);
>  		return 0;
>  	}
>  
> +	if (error != -ENOSPC)
> +		return error;
> +
>  	if (align > mp->m_sb.sb_rextsize) {
>  		/*
>  		 * We previously enlarged the request length to try to satisfy
> -- 
> 2.39.2
> 
> 
