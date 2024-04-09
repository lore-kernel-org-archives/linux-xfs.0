Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C885158DBE
	for <linux-xfs@vger.kernel.org>; Tue,  9 Apr 2024 23:19:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712704758; cv=none; b=jXJvC4gkxoxanRrZKKmCU15ksaduLITrufaIwDFXrUeWXdIoEfIc4uCj2YCz1lZuLtFDnR0DowY7M8Wfy0ugrcn7pX1oICr+nu9KXFY7p3bGf+xltz9Cxsx/9HfKdH2iTyLjtbVGD5m8WesjsA4bAqQCC24kvST6o6C+aPzESs4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712704758; c=relaxed/simple;
	bh=qAO2K8z7y+UgL4jhpq5KiDxlPEORJLne8L+7K7gzeCU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=m/GJi9R08JlUt60a6KxW/ei2HKnFkkN3HdIOBNnMTHQGyXeEB9wXMmFslsUX3UNjTTta4IVAEYF9nLH12Sy3eHBI8h+S5D4G10COAintolF7nJl8jR6M07jFYwt1sSgiuuWqJrnhRKgZzQsIVmVdLxazEBTu3S0FsXkxYKsGbBs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Pe12Kzc8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Pe12Kzc8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 867E9C433B2;
	Tue,  9 Apr 2024 23:19:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712704757;
	bh=qAO2K8z7y+UgL4jhpq5KiDxlPEORJLne8L+7K7gzeCU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Pe12Kzc84de9dqP5yRYRDbG2OGe4835nR8w7t20AsKmIWJPhCour4K4IKCZpAWT+6
	 3myKklxGnnZnXpHqbCGK+qPkU9fwMOfc1osLQzH4APLlvDAftjvVW04RytaVn4xaXm
	 cclMKZFsCssGs6cx+3QtKBbPUMJ+aHL6CArlVGTULUx2HyTzMYsr9NEVuK20dty/Jm
	 DgAhp56kcquHmsKjuhW+ik6eV7ZA7UcuWetxTMpBJEWkB/PIkGVhjztj2bHua7g5RI
	 Yt3UNYHarQWyME6bxlVm+s5JTylLw4EeeidkIqE/2WzDjToIvPNBkC+4JTkQ/KU41U
	 JPv3wqyavIpEg==
Date: Tue, 9 Apr 2024 16:19:17 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>,
	Dave Chinner <david@fromorbit.com>,
	"open list:XFS FILESYSTEM" <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 1/8] xfs: fix error returns from xfs_bmapi_write
Message-ID: <20240409231917.GP6390@frogsfrogsfrogs>
References: <20240408145454.718047-1-hch@lst.de>
 <20240408145454.718047-2-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240408145454.718047-2-hch@lst.de>

On Mon, Apr 08, 2024 at 04:54:47PM +0200, Christoph Hellwig wrote:
> xfs_bmapi_write can return 0 without actually returning a mapping in
> mval in two different cases:
> 
>  1) when there is absolutely no space available to do an allocation
>  2) when converting delalloc space, and the allocation is so small
>     that it only covers parts of the delalloc extent before the
>     range requested by the caller
> 
> Callers at best can handle one of these cases, but in many cases can't
> cope with either one.  Switch xfs_bmapi_write to always return a
> mapping or return an error code instead.  For case 1) above ENOSPC is
> the obvious choice which is very much what the callers expect anyway.
> For case 2) there is no really good error code, so pick a funky one
> from the SysV streams portfolio.
> 
> This fixes the reproducer here:
> 
>     https://lore.kernel.org/linux-xfs/CAEJPjCvT3Uag-pMTYuigEjWZHn1sGMZ0GCjVVCv29tNHK76Cgg@mail.gmail.com0/
> 
> which uses reserved blocks to create file systems that are gravely
> out of space and thus cause at least xfs_file_alloc_space to hang
> and trigger the lack of ENOSPC handling in xfs_dquot_disk_alloc.
> 
> Note that this patch does not actually make any caller but
> xfs_alloc_file_space deal intelligently with case 2) above.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Hmm.  So I think the answer to my questions earlier is that with the
series applied, ENOSR should never leak out because bmapi_write calls
will always do the piece that the caller asked for, right?

If yes, then
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/libxfs/xfs_attr_remote.c |  1 -
>  fs/xfs/libxfs/xfs_bmap.c        | 46 ++++++++++++++++++++++++++-------
>  fs/xfs/libxfs/xfs_da_btree.c    | 20 ++++----------
>  fs/xfs/scrub/quota_repair.c     |  6 -----
>  fs/xfs/scrub/rtbitmap_repair.c  |  2 --
>  fs/xfs/xfs_bmap_util.c          | 31 +++++++++++-----------
>  fs/xfs/xfs_dquot.c              |  1 -
>  fs/xfs/xfs_iomap.c              |  8 ------
>  fs/xfs/xfs_reflink.c            | 14 ----------
>  fs/xfs/xfs_rtalloc.c            |  2 --
>  10 files changed, 57 insertions(+), 74 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_remote.c
> index ff04128287720a..41a02dcc2541b0 100644
> --- a/fs/xfs/libxfs/xfs_attr_remote.c
> +++ b/fs/xfs/libxfs/xfs_attr_remote.c
> @@ -626,7 +626,6 @@ xfs_attr_rmtval_set_blk(
>  	if (error)
>  		return error;
>  
> -	ASSERT(nmap == 1);
>  	ASSERT((map->br_startblock != DELAYSTARTBLOCK) &&
>  	       (map->br_startblock != HOLESTARTBLOCK));
>  
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 656c95a22f2e6d..14196d918865ba 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -4226,8 +4226,10 @@ xfs_bmapi_allocate(
>  	} else {
>  		error = xfs_bmap_alloc_userdata(bma);
>  	}
> -	if (error || bma->blkno == NULLFSBLOCK)
> +	if (error)
>  		return error;
> +	if (bma->blkno == NULLFSBLOCK)
> +		return -ENOSPC;
>  
>  	if (bma->flags & XFS_BMAPI_ZERO) {
>  		error = xfs_zero_extent(bma->ip, bma->blkno, bma->length);
> @@ -4406,6 +4408,15 @@ xfs_bmapi_finish(
>   * extent state if necessary.  Details behaviour is controlled by the flags
>   * parameter.  Only allocates blocks from a single allocation group, to avoid
>   * locking problems.
> + *
> + * Returns 0 on success and places the extent mappings in mval.  nmaps is used
> + * as an input/output parameter where the caller specifies the maximum number
> + * of mappings that may be returned and xfs_bmapi_write passes back the number
> + * of mappings (including existing mappings) it found.
> + *
> + * Returns a negative error code on failure, including -ENOSPC when it could not
> + * allocate any blocks and -ENOSR when it did allocate blocks to convert a
> + * delalloc range, but those blocks were before the passed in range.
>   */
>  int
>  xfs_bmapi_write(
> @@ -4534,10 +4545,16 @@ xfs_bmapi_write(
>  			ASSERT(len > 0);
>  			ASSERT(bma.length > 0);
>  			error = xfs_bmapi_allocate(&bma);
> -			if (error)
> +			if (error) {
> +				/*
> +				 * If we already allocated space in a previous
> +				 * iteration return what we go so far when
> +				 * running out of space.
> +				 */
> +				if (error == -ENOSPC && bma.nallocs)
> +					break;
>  				goto error0;
> -			if (bma.blkno == NULLFSBLOCK)
> -				break;
> +			}
>  
>  			/*
>  			 * If this is a CoW allocation, record the data in
> @@ -4575,7 +4592,6 @@ xfs_bmapi_write(
>  		if (!xfs_iext_next_extent(ifp, &bma.icur, &bma.got))
>  			eof = true;
>  	}
> -	*nmap = n;
>  
>  	error = xfs_bmap_btree_to_extents(tp, ip, bma.cur, &bma.logflags,
>  			whichfork);
> @@ -4586,7 +4602,22 @@ xfs_bmapi_write(
>  	       ifp->if_nextents > XFS_IFORK_MAXEXT(ip, whichfork));
>  	xfs_bmapi_finish(&bma, whichfork, 0);
>  	xfs_bmap_validate_ret(orig_bno, orig_len, orig_flags, orig_mval,
> -		orig_nmap, *nmap);
> +		orig_nmap, n);
> +
> +	/*
> +	 * When converting delayed allocations, xfs_bmapi_allocate ignores
> +	 * the passed in bno and always converts from the start of the found
> +	 * delalloc extent.
> +	 *
> +	 * To avoid a successful return with *nmap set to 0, return the magic
> +	 * -ENOSR error code for this particular case so that the caller can
> +	 * handle it.
> +	 */
> +	if (!n) {
> +		ASSERT(bma.nallocs >= *nmap);
> +		return -ENOSR;
> +	}
> +	*nmap = n;
>  	return 0;
>  error0:
>  	xfs_bmapi_finish(&bma, whichfork, error);
> @@ -4693,9 +4724,6 @@ xfs_bmapi_convert_delalloc(
>  	if (error)
>  		goto out_finish;
>  
> -	error = -ENOSPC;
> -	if (WARN_ON_ONCE(bma.blkno == NULLFSBLOCK))
> -		goto out_finish;
>  	if (WARN_ON_ONCE(!xfs_valid_startblock(ip, bma.got.br_startblock))) {
>  		xfs_bmap_mark_sick(ip, whichfork);
>  		error = -EFSCORRUPTED;
> diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
> index 718d071bb21ae3..276c710548b5a7 100644
> --- a/fs/xfs/libxfs/xfs_da_btree.c
> +++ b/fs/xfs/libxfs/xfs_da_btree.c
> @@ -2167,8 +2167,8 @@ xfs_da_grow_inode_int(
>  	struct xfs_inode	*dp = args->dp;
>  	int			w = args->whichfork;
>  	xfs_rfsblock_t		nblks = dp->i_nblocks;
> -	struct xfs_bmbt_irec	map, *mapp;
> -	int			nmap, error, got, i, mapi;
> +	struct xfs_bmbt_irec	map, *mapp = &map;
> +	int			nmap, error, got, i, mapi = 1;
>  
>  	/*
>  	 * Find a spot in the file space to put the new block.
> @@ -2184,14 +2184,7 @@ xfs_da_grow_inode_int(
>  	error = xfs_bmapi_write(tp, dp, *bno, count,
>  			xfs_bmapi_aflag(w)|XFS_BMAPI_METADATA|XFS_BMAPI_CONTIG,
>  			args->total, &map, &nmap);
> -	if (error)
> -		return error;
> -
> -	ASSERT(nmap <= 1);
> -	if (nmap == 1) {
> -		mapp = &map;
> -		mapi = 1;
> -	} else if (nmap == 0 && count > 1) {
> +	if (error == -ENOSPC && count > 1) {
>  		xfs_fileoff_t		b;
>  		int			c;
>  
> @@ -2209,16 +2202,13 @@ xfs_da_grow_inode_int(
>  					args->total, &mapp[mapi], &nmap);
>  			if (error)
>  				goto out_free_map;
> -			if (nmap < 1)
> -				break;
>  			mapi += nmap;
>  			b = mapp[mapi - 1].br_startoff +
>  			    mapp[mapi - 1].br_blockcount;
>  		}
> -	} else {
> -		mapi = 0;
> -		mapp = NULL;
>  	}
> +	if (error)
> +		goto out_free_map;
>  
>  	/*
>  	 * Count the blocks we got, make sure it matches the total.
> diff --git a/fs/xfs/scrub/quota_repair.c b/fs/xfs/scrub/quota_repair.c
> index 0bab4c30cb85ab..90cd1512bba961 100644
> --- a/fs/xfs/scrub/quota_repair.c
> +++ b/fs/xfs/scrub/quota_repair.c
> @@ -77,8 +77,6 @@ xrep_quota_item_fill_bmap_hole(
>  			irec, &nmaps);
>  	if (error)
>  		return error;
> -	if (nmaps != 1)
> -		return -ENOSPC;
>  
>  	dq->q_blkno = XFS_FSB_TO_DADDR(mp, irec->br_startblock);
>  
> @@ -444,10 +442,6 @@ xrep_quota_data_fork(
>  					XFS_BMAPI_CONVERT, 0, &nrec, &nmap);
>  			if (error)
>  				goto out;
> -			if (nmap != 1) {
> -				error = -ENOSPC;
> -				goto out;
> -			}
>  			ASSERT(nrec.br_startoff == irec.br_startoff);
>  			ASSERT(nrec.br_blockcount == irec.br_blockcount);
>  
> diff --git a/fs/xfs/scrub/rtbitmap_repair.c b/fs/xfs/scrub/rtbitmap_repair.c
> index 46f5d5f605c915..0fef98e9f83409 100644
> --- a/fs/xfs/scrub/rtbitmap_repair.c
> +++ b/fs/xfs/scrub/rtbitmap_repair.c
> @@ -108,8 +108,6 @@ xrep_rtbitmap_data_mappings(
>  				0, &map, &nmaps);
>  		if (error)
>  			return error;
> -		if (nmaps != 1)
> -			return -EFSCORRUPTED;
>  
>  		/* Commit new extent and all deferred work. */
>  		error = xrep_defer_finish(sc);
> diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> index 19e11d1da66074..fbca94170cd386 100644
> --- a/fs/xfs/xfs_bmap_util.c
> +++ b/fs/xfs/xfs_bmap_util.c
> @@ -721,33 +721,32 @@ xfs_alloc_file_space(
>  		if (error)
>  			goto error;
>  
> -		error = xfs_bmapi_write(tp, ip, startoffset_fsb,
> -				allocatesize_fsb, XFS_BMAPI_PREALLOC, 0, imapp,
> -				&nimaps);
> -		if (error)
> -			goto error;
> -
> -		ip->i_diflags |= XFS_DIFLAG_PREALLOC;
> -		xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
> -
> -		error = xfs_trans_commit(tp);
> -		xfs_iunlock(ip, XFS_ILOCK_EXCL);
> -		if (error)
> -			break;
> -
>  		/*
>  		 * If the allocator cannot find a single free extent large
>  		 * enough to cover the start block of the requested range,
> -		 * xfs_bmapi_write will return 0 but leave *nimaps set to 0.
> +		 * xfs_bmapi_write will return -ENOSR.
>  		 *
>  		 * In that case we simply need to keep looping with the same
>  		 * startoffset_fsb so that one of the following allocations
>  		 * will eventually reach the requested range.
>  		 */
> -		if (nimaps) {
> +		error = xfs_bmapi_write(tp, ip, startoffset_fsb,
> +				allocatesize_fsb, XFS_BMAPI_PREALLOC, 0, imapp,
> +				&nimaps);
> +		if (error) {
> +			if (error != -ENOSR)
> +				goto error;
> +			error = 0;
> +		} else {
>  			startoffset_fsb += imapp->br_blockcount;
>  			allocatesize_fsb -= imapp->br_blockcount;
>  		}
> +
> +		ip->i_diflags |= XFS_DIFLAG_PREALLOC;
> +		xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
> +
> +		error = xfs_trans_commit(tp);
> +		xfs_iunlock(ip, XFS_ILOCK_EXCL);
>  	}
>  
>  	return error;
> diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
> index c98cb468c35780..0c9eb8fdeec082 100644
> --- a/fs/xfs/xfs_dquot.c
> +++ b/fs/xfs/xfs_dquot.c
> @@ -357,7 +357,6 @@ xfs_dquot_disk_alloc(
>  		goto err_cancel;
>  
>  	ASSERT(map.br_blockcount == XFS_DQUOT_CLUSTER_SIZE_FSB);
> -	ASSERT(nmaps == 1);
>  	ASSERT((map.br_startblock != DELAYSTARTBLOCK) &&
>  	       (map.br_startblock != HOLESTARTBLOCK));
>  
> diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
> index 4087af7f3c9f3f..42155cedefb77d 100644
> --- a/fs/xfs/xfs_iomap.c
> +++ b/fs/xfs/xfs_iomap.c
> @@ -321,14 +321,6 @@ xfs_iomap_write_direct(
>  	if (error)
>  		goto out_unlock;
>  
> -	/*
> -	 * Copy any maps to caller's array and return any error.
> -	 */
> -	if (nimaps == 0) {
> -		error = -ENOSPC;
> -		goto out_unlock;
> -	}
> -
>  	if (unlikely(!xfs_valid_startblock(ip, imap->br_startblock))) {
>  		xfs_bmap_mark_sick(ip, XFS_DATA_FORK);
>  		error = xfs_alert_fsblock_zero(ip, imap);
> diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
> index 7da0e8f961d351..5ecb52a234becc 100644
> --- a/fs/xfs/xfs_reflink.c
> +++ b/fs/xfs/xfs_reflink.c
> @@ -430,13 +430,6 @@ xfs_reflink_fill_cow_hole(
>  	if (error)
>  		return error;
>  
> -	/*
> -	 * Allocation succeeded but the requested range was not even partially
> -	 * satisfied?  Bail out!
> -	 */
> -	if (nimaps == 0)
> -		return -ENOSPC;
> -
>  convert:
>  	return xfs_reflink_convert_unwritten(ip, imap, cmap, convert_now);
>  
> @@ -499,13 +492,6 @@ xfs_reflink_fill_delalloc(
>  		error = xfs_trans_commit(tp);
>  		if (error)
>  			return error;
> -
> -		/*
> -		 * Allocation succeeded but the requested range was not even
> -		 * partially satisfied?  Bail out!
> -		 */
> -		if (nimaps == 0)
> -			return -ENOSPC;
>  	} while (cmap->br_startoff + cmap->br_blockcount <= imap->br_startoff);
>  
>  	return xfs_reflink_convert_unwritten(ip, imap, cmap, convert_now);
> diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
> index e66f9bd5de5cff..46ee8093f797a6 100644
> --- a/fs/xfs/xfs_rtalloc.c
> +++ b/fs/xfs/xfs_rtalloc.c
> @@ -709,8 +709,6 @@ xfs_growfs_rt_alloc(
>  		nmap = 1;
>  		error = xfs_bmapi_write(tp, ip, oblocks, nblocks - oblocks,
>  					XFS_BMAPI_METADATA, 0, &map, &nmap);
> -		if (!error && nmap < 1)
> -			error = -ENOSPC;
>  		if (error)
>  			goto out_trans_cancel;
>  		/*
> -- 
> 2.39.2
> 
> 
