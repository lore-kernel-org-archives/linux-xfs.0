Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EB441FBA
	for <linux-xfs@vger.kernel.org>; Fri, 29 Mar 2024 16:29:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711729777; cv=none; b=Ed/tdTfZAGZRxZzvOg2ZXq5g6mSAqYuv5UL/A2eVbNzy8a1sZxfRvQzCtmrPwPM4O4tr+wfluy+f5eROhC/jej4RpAMF4OyM+zo9yb1cfFIn8H3QRsr9IrIo/EtDdkM3vJvkTtHfC2wtaH/bV1WhVPhwscglgpZkCtfSD0J0wX4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711729777; c=relaxed/simple;
	bh=/BY0iuSAfWgT2C2uvqxll9e4oizR0vBicYMjegk6mkc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CtXmep74N7MSImbTTssef31LtO4vufjHZXUuhX6GwGdqHfizUtuXXuyA7J6Uzo/xywHqxFHB7ew11LyYnUEg+psFZNXmdJWfrsCvh3HKLbyPJz/vZEw9Zop7k+JN7TJYya+V3posI8BPFEYF3kfmm0q8J38H6BOQRkIesXhK1nE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QrBWHjYI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QrBWHjYI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D515C433C7;
	Fri, 29 Mar 2024 16:29:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711729776;
	bh=/BY0iuSAfWgT2C2uvqxll9e4oizR0vBicYMjegk6mkc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=QrBWHjYIzMwFvCti3VJXJ5qzVG1eiupljB8EKcdFNFCuqbhn/zTNxNt1ff41spRJ4
	 jbrAT+HvzRV0DAMPMNDwFDiBSuiCFSVVryoh07Lg2/HSlr8DZJYAK3Fy6Jzbg/aIi9
	 XtS3u67kG1Z6XGRM/R8tjTDOtXaCOVjNCQj5Z6zwLTvUavYiYyq5W/oANZIRcO+n1a
	 Ka/W9osrQAI5IcNc85JNvEf5wN/bl79KAT4BXKiT3BHVEAg9WrqHhdcG5nFDUaPP9N
	 TMiYiRnNAYhGl0cTphhvH0wcZ41ODtKRt4R8ZFnfpPCUCoQ1K+tx8a6emK8wVPOFf2
	 1pJM0K039WPpg==
Date: Fri, 29 Mar 2024 09:29:36 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/6] xfs: optimize extent remapping in
 xfs_reflink_end_cow_extent
Message-ID: <20240329162936.GI6390@frogsfrogsfrogs>
References: <20240328070256.2918605-1-hch@lst.de>
 <20240328070256.2918605-6-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240328070256.2918605-6-hch@lst.de>

On Thu, Mar 28, 2024 at 08:02:55AM +0100, Christoph Hellwig wrote:
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
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_reflink.c | 98 +++++++++++++++++++++++++-------------------
>  1 file changed, 56 insertions(+), 42 deletions(-)
> 
> diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
> index 3c35cd3b2dec5d..a7ee868d79bf02 100644
> --- a/fs/xfs/xfs_reflink.c
> +++ b/fs/xfs/xfs_reflink.c
> @@ -701,6 +701,52 @@ xfs_reflink_cancel_cow_range(
>  	return error;
>  }
>  
> +/*
> + * Unmap any old data covering the COW target.
> + */
> +static void
> +xfs_reflink_unmap_old_data(
> +	struct xfs_trans	*tp,
> +	struct xfs_inode	*ip,
> +	xfs_fileoff_t		offset_fsb,
> +	xfs_fileoff_t		end_fsb)
> +{
> +	struct xfs_ifork	*ifp = &ip->i_df;
> +	struct xfs_bmbt_irec	got, del;
> +	struct xfs_iext_cursor	icur;
> +
> +	ASSERT(!xfs_need_iread_extents(ifp));
> +
> +	if (!xfs_iext_lookup_extent_before(ip, ifp, &end_fsb, &icur, &got))
> +		return;
> +
> +	while (got.br_startoff + got.br_blockcount > offset_fsb) {

How many bmap and refcount log intent items can we attach to a single
transaction?  It's roughly t_log_res / (32 + 32) though iirc in repair
I simply picked an upper limit of 128 extent mappings before I'd go back
for a fresh transaction.

--D

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
> +		xfs_bmap_unmap_extent(tp, ip, XFS_DATA_FORK, &del);
> +		xfs_refcount_decrease_extent(tp, &del);
> +		xfs_trans_mod_dquot_byino(tp, ip, XFS_TRANS_DQ_BCOUNT,
> +				-del.br_blockcount);
> +prev_extent:
> +		xfs_iext_prev(ifp, &icur);
> +refresh:
> +		if (!xfs_iext_get_extent(ifp, &icur, &got))
> +			break;
> +	}
> +}
> +
>  /*
>   * Remap part of the CoW fork into the data fork.
>   *
> @@ -718,12 +764,11 @@ xfs_reflink_end_cow_extent(
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
> @@ -765,9 +810,7 @@ xfs_reflink_end_cow_extent(
>  	/*
>  	 * Only remap real extents that contain data.  With AIO, speculative
>  	 * preallocations can leak into the range we are called upon, and we
> -	 * need to skip them.  Preserve @got for the eventual CoW fork
> -	 * deletion; from now on @del represents the mapping that we're
> -	 * actually remapping.
> +	 * need to skip them.
>  	 */
>  	while (!xfs_bmap_is_written_extent(&got)) {
>  		if (!xfs_iext_next_extent(ifp, &icur, &got) ||
> @@ -776,47 +819,18 @@ xfs_reflink_end_cow_extent(
>  			goto out_cancel;
>  		}
>  	}
> +
> +	/*
> +	 * Preserve @got for the eventual CoW fork deletion; from now on @del
> +	 * represents the mapping that we're actually remapping.
> +	 */
>  	del = got;
>  	xfs_trim_extent(&del, *offset_fsb, end_fsb - *offset_fsb);
> -
> -	/* Grab the corresponding mapping in the data fork. */
> -	nmaps = 1;
> -	error = xfs_bmapi_read(ip, del.br_startoff, del.br_blockcount, &data,
> -			&nmaps, 0);
> -	if (error)
> -		goto out_cancel;
> -
> -	/* We can only remap the smaller of the two extent sizes. */
> -	data.br_blockcount = min(data.br_blockcount, del.br_blockcount);
> -	del.br_blockcount = data.br_blockcount;
> -
>  	trace_xfs_reflink_cow_remap_from(ip, &del);
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
>  
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
> +	/* Unmap the old data. */
> +	xfs_reflink_unmap_old_data(tp, ip, del.br_startoff,
> +			del.br_startoff + del.br_blockcount);
>  
>  	/* Free the CoW orphan record. */
>  	xfs_refcount_free_cow_extent(tp, del.br_startblock, del.br_blockcount);
> -- 
> 2.39.2
> 
> 
