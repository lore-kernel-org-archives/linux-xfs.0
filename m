Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D33B15F861
	for <linux-xfs@vger.kernel.org>; Mon, 29 Apr 2024 15:43:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714405424; cv=none; b=W+crDfACNOmGWajOKcgjUD38zEyXIkkAareIkWF3TGPhi+ddtCMePJL74sqFL1ZMH6fmrJyB4F1s7/7VzutvnIRbAZ0fYXTuHeLL2cFf/TNAjaNMLuSk3KFmlSAe1CWGsLwvGvyUJ64Bl6INQdgtJi24Q9ay4H2thSUrH3EdusA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714405424; c=relaxed/simple;
	bh=mOk4WEkKAaE+TMcxiQo6vaEk81BYKcFxRRQsLjEWGsc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rBKVFgmtw5Bp3MXbv127Lk2dPBc4ftOMGO3jSFUUVx5MScrtjTuLiiWdomzOHPb8IsWN3oOmVcpxAi0PJg0beGW9Rs7jpdGuVlZVEikiY3x+nMrrbhidwiySppgzwPwwJ6N1d1XFP0ska9UFH2ZEIE9YscAsCfi6YjlqxCghMcE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=R41MJys7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="R41MJys7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABAD0C113CD;
	Mon, 29 Apr 2024 15:43:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1714405424;
	bh=mOk4WEkKAaE+TMcxiQo6vaEk81BYKcFxRRQsLjEWGsc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=R41MJys7R90sGEtBQ8D/rDgPNt/+HVPACJ4ay7OqUv23YvLKW0PC3AK+fDbAJQPlG
	 cUWH2Yg2EqSQAcKQdO1UfTRhXYXe0mQ7J8X07AriqnoWPTC1FW4ewPvn4vb6urI/1G
	 ivPu7TnWIpE8ypiiGyu6FDm61GqaoxXjiESfQYv9H6I4ZNr/didORJX4m23bbbBx85
	 6eWmA/Mso2FGezBK9jcjw9cgDoPDQd3srtxzsgMqxUpEa1pIcgkK8AujA9gaYkEt50
	 aBeQOzbqy1fGPjVw0Y+aPk9i61TS1fu+k/zuSeYMAH0gbGwYgyNUV/reX7YbfkUSzD
	 sRD2oVzOwro2A==
Date: Mon, 29 Apr 2024 08:43:44 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 7/8] xfs: optimize extent remapping in
 xfs_reflink_end_cow_extent
Message-ID: <20240429154344.GA360919@frogsfrogsfrogs>
References: <20240429044917.1504566-1-hch@lst.de>
 <20240429044917.1504566-8-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240429044917.1504566-8-hch@lst.de>

On Mon, Apr 29, 2024 at 06:49:16AM +0200, Christoph Hellwig wrote:
> xfs_reflink_end_cow_extent currently caps the range it works on to
> fit both the existing extent (or hole) in the data fork and the
> new COW range.  For overwrites of fragmented regions that is highly
> inefficient, as we need to split the new region at every boundary,
> just for it to be merge back in the next pass.
> 
> Switch to unmapping the old data using a chain of deferred bmap
> and extent free ops ops first, and then handle remapping the new
> data in one single transaction instead.
> 
> Note that this also switches from a write to an itruncate transaction
> reservation as the xfs_reflink_end_cow_extent doesn't touch any of
> the allocator data structures in the AGF or the RT inodes.  Instead
> the lead transaction just unmaps blocks, and later they get freed,
> COW records get freed and the new blocks get mapped into the inode.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_reflink.c | 111 ++++++++++++++++++++++++++++---------------
>  1 file changed, 72 insertions(+), 39 deletions(-)
> 
> diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
> index af388f2caef304..e20db39d1cc46f 100644
> --- a/fs/xfs/xfs_reflink.c
> +++ b/fs/xfs/xfs_reflink.c
> @@ -701,6 +701,72 @@ xfs_reflink_cancel_cow_range(
>  	return error;
>  }
>  
> +/*
> + * Unmap any old data covering the COW target.
> + */
> +static int
> +xfs_reflink_unmap_old_data(
> +	struct xfs_trans	**tpp,
> +	struct xfs_inode	*ip,
> +	xfs_fileoff_t		offset_fsb,
> +	xfs_fileoff_t		end_fsb)
> +{
> +	struct xfs_ifork	*ifp = &ip->i_df;
> +	struct xfs_bmbt_irec	got, del;
> +	struct xfs_iext_cursor	icur;
> +	unsigned int		freed;
> +	int			error;
> +
> +	ASSERT(!xfs_need_iread_extents(ifp));
> +
> +restart:
> +	freed = 0;
> +	if (!xfs_iext_lookup_extent_before(ip, ifp, &end_fsb, &icur, &got))
> +		return 0;
> +
> +	while (got.br_startoff + got.br_blockcount > offset_fsb) {
> +		del = got;
> +		xfs_trim_extent(&del, offset_fsb, end_fsb - offset_fsb);
> +
> +		/* Extent delete may have bumped us forward */
> +		if (!del.br_blockcount)
> +			goto prev_extent;
> +
> +		trace_xfs_reflink_cow_remap_to(ip, &del);
> +		if (isnullstartblock(del.br_startblock)) {
> +			xfs_bmap_del_extent_delay(ip, XFS_DATA_FORK, &icur,
> +					&got, &del);
> +			goto refresh;
> +		}
> +
> +		xfs_bmap_unmap_extent(*tpp, ip, XFS_DATA_FORK, &del);
> +		xfs_refcount_decrease_extent(*tpp, &del);
> +		xfs_trans_mod_dquot_byino(*tpp, ip, XFS_TRANS_DQ_BCOUNT,
> +				-del.br_blockcount);
> +
> +		/*
> +		 * We can't add an unlimited number of EFIs and thus deferred
> +		 * unmapped items to a transaction.  Once we've filled our
> +		 * quota roll the transaction, which requires us to restart
> +		 * the lookup as the deferred item processing will change the
> +		 * iext tree.

Nit: This loop actually queues multiple intent items -- one BUI to
handle the unmap, one RUI if the rmapbt needs updating, one CUI to
decrement the old data fork extent's refcount, and one EFI if that was
the last ref to that space.  So I guess 128 of these is small enough not
to overflow a tr_itruncate transaction...

> +		 */
> +		if (++freed == XFS_MAX_ITRUNCATE_EFIS) {
> +			error = xfs_defer_finish(tpp);

...but the bigger problem here is that defer_finish rolls the
transaction having not added the log intent items for the cow ->
data fork remap operation.  If we commit the old *tpp and crash before
the new *tpp commits, then log recovery will zap the data fork extent
without replacing it with anything, and the file contents turn to
zeroes.

To fix this, you'd need to do this stuff (copy-pasted from
xfs_reflink_end_cow_extent):

	/* Free the CoW orphan record. */
	xfs_refcount_free_cow_extent(tp, remap.br_startblock, remap.br_blockcount);

	/* Map the new blocks into the data fork. */
	xfs_bmap_map_extent(tp, ip, XFS_DATA_FORK, &remap);

	/* Charge this new data fork mapping to the on-disk quota. */
	xfs_trans_mod_dquot_byino(tp, ip, XFS_TRANS_DQ_DELBCOUNT,
			(long)remap.br_blockcount);

	/* Remove the mapping from the CoW fork. */
	xfs_bmap_del_extent_cow(ip, &icur, &got, &remap);

before the xfs_defer_finish call, and with the same file block range as
was unmapped in this transaction.

--D

> +			if (error)
> +				return error;
> +			goto restart;
> +		}
> +prev_extent:
> +		xfs_iext_prev(ifp, &icur);
> +refresh:
> +		if (!xfs_iext_get_extent(ifp, &icur, &got))
> +			break;
> +	}
> +
> +	return 0;
> +}
> +
>  /*
>   * Remap part of the CoW fork into the data fork.
>   *
> @@ -718,16 +784,15 @@ xfs_reflink_end_cow_extent(
>  	xfs_fileoff_t		end_fsb)
>  {
>  	struct xfs_iext_cursor	icur;
> -	struct xfs_bmbt_irec	got, del, data;
> +	struct xfs_bmbt_irec	got, del;
>  	struct xfs_mount	*mp = ip->i_mount;
>  	struct xfs_trans	*tp;
>  	struct xfs_ifork	*ifp = xfs_ifork_ptr(ip, XFS_COW_FORK);
>  	unsigned int		resblks;
> -	int			nmaps;
>  	int			error;
>  
>  	resblks = XFS_EXTENTADD_SPACE_RES(mp, XFS_DATA_FORK);
> -	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_write, resblks, 0,
> +	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_itruncate, resblks, 0,
>  			XFS_TRANS_RESERVE, &tp);
>  	if (error)
>  		return error;
> @@ -767,51 +832,19 @@ xfs_reflink_end_cow_extent(
>  	}
>  	del = got;
>  	xfs_trim_extent(&del, *offset_fsb, end_fsb - *offset_fsb);
> +	trace_xfs_reflink_cow_remap_from(ip, &del);
>  
>  	error = xfs_iext_count_ensure(tp, ip, XFS_DATA_FORK,
>  			XFS_IEXT_REFLINK_END_COW_CNT);
>  	if (error)
>  		goto out_cancel;
>  
> -	/* Grab the corresponding mapping in the data fork. */
> -	nmaps = 1;
> -	error = xfs_bmapi_read(ip, del.br_startoff, del.br_blockcount, &data,
> -			&nmaps, 0);
> +	/* Unmap the old data. */
> +	error = xfs_reflink_unmap_old_data(&tp, ip, del.br_startoff,
> +			del.br_startoff + del.br_blockcount);
>  	if (error)
>  		goto out_cancel;
>  
> -	/* We can only remap the smaller of the two extent sizes. */
> -	data.br_blockcount = min(data.br_blockcount, del.br_blockcount);
> -	del.br_blockcount = data.br_blockcount;
> -
> -	trace_xfs_reflink_cow_remap_from(ip, &del);
> -	trace_xfs_reflink_cow_remap_to(ip, &data);
> -
> -	if (xfs_bmap_is_real_extent(&data)) {
> -		/*
> -		 * If the extent we're remapping is backed by storage (written
> -		 * or not), unmap the extent and drop its refcount.
> -		 */
> -		xfs_bmap_unmap_extent(tp, ip, XFS_DATA_FORK, &data);
> -		xfs_refcount_decrease_extent(tp, &data);
> -		xfs_trans_mod_dquot_byino(tp, ip, XFS_TRANS_DQ_BCOUNT,
> -				-data.br_blockcount);
> -	} else if (data.br_startblock == DELAYSTARTBLOCK) {
> -		int		done;
> -
> -		/*
> -		 * If the extent we're remapping is a delalloc reservation,
> -		 * we can use the regular bunmapi function to release the
> -		 * incore state.  Dropping the delalloc reservation takes care
> -		 * of the quota reservation for us.
> -		 */
> -		error = xfs_bunmapi(NULL, ip, data.br_startoff,
> -				data.br_blockcount, 0, 1, &done);
> -		if (error)
> -			goto out_cancel;
> -		ASSERT(done);
> -	}
> -
>  	/* Free the CoW orphan record. */
>  	xfs_refcount_free_cow_extent(tp, del.br_startblock, del.br_blockcount);
>  
> -- 
> 2.39.2
> 
> 
