Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:36757 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753198AbdBASgW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 1 Feb 2017 13:36:22 -0500
Date: Wed, 1 Feb 2017 10:36:21 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2 7/7] xfs: mark speculative prealloc CoW fork extents
 unwritten
Message-ID: <20170201183621.GA2118@infradead.org>
References: <148582218411.12293.806854574193653038.stgit@birch.djwong.org>
 <148582223303.12293.11053073799262731296.stgit@birch.djwong.org>
 <20170201023617.GM9134@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170201023617.GM9134@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

Looks fine (and tests fine):

Reviewed-by: Christoph Hellwig <hch@lst.de>

But a few style nitpicks below:


> +	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, XFS_COW_FORK);
> +	xfs_fileoff_t		offset_fsb;
> +	xfs_fileoff_t		end_fsb;
> +	xfs_extnum_t		idx;
> +	bool			found;
> +	int			error;
> +
> +	offset_fsb = XFS_B_TO_FSBT(mp, offset);
> +	end_fsb = XFS_B_TO_FSB(mp, offset + count);

Move these into the lines with the variable declarations, please.

> +	xfs_ilock(ip, XFS_ILOCK_EXCL);
> +
> +	/* Convert all the extents to real from unwritten. */
> +	for (found = xfs_iext_lookup_extent(ip, ifp, offset_fsb, &idx, &got);
> +	     found && got.br_startoff < end_fsb;
> +	     found = xfs_iext_get_extent(ifp, ++idx, &got)) {
> +		if (got.br_state == XFS_EXT_NORM)
> +			continue;
> +		error = __xfs_reflink_convert_cow(ip, &got, offset_fsb,
> +				end_fsb - offset_fsb, &dfops);

Move the state check into __xfs_reflink_convert_cow and rename that
to xfs_reflink_convert_cow_extent?

> @@ -389,10 +479,13 @@ xfs_reflink_allocate_cow_range(
>  		if (error) {
>  			trace_xfs_reflink_allocate_cow_range_error(ip, error,
>  					_RET_IP_);
> -			break;
> +			goto out;
>  		}
>  	}
>  
> +	/* Convert the CoW extents to regular. */
> +	error = xfs_reflink_convert_cow(ip, offset, count);
> +out:
>  	return error;

No need for the goto here really, justt return the error directly.
