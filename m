Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:58955 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751368AbcJJKWN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 10 Oct 2016 06:22:13 -0400
Date: Mon, 10 Oct 2016 03:21:13 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2 1/7] xfs: rework refcount cow recovery error handling
Message-ID: <20161010102113.GC18359@infradead.org>
References: <147588163396.12127.8356851783027062457.stgit@birch.djwong.org>
 <147588164562.12127.10503063159516084342.stgit@birch.djwong.org>
 <20161010061122.GC5619@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161010061122.GC5619@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: david@fromorbit.com, linux-xfs@vger.kernel.org, Brian Foster <bfoster@redhat.com>

On Sun, Oct 09, 2016 at 11:11:22PM -0700, Darrick J. Wong wrote:
> The error handling in xfs_refcount_recover_cow_leftovers is confused
> and can potentially leak memory, so rework it to release resources
> correctly on error.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> Reported-by: Brian Foster <bfoster@redhat.com>
> ---
>  fs/xfs/libxfs/xfs_refcount.c |   16 ++++++----------
>  1 file changed, 6 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_refcount.c b/fs/xfs/libxfs/xfs_refcount.c
> index 56bfef1..955b1d9 100644
> --- a/fs/xfs/libxfs/xfs_refcount.c
> +++ b/fs/xfs/libxfs/xfs_refcount.c
> @@ -1643,7 +1643,7 @@ xfs_refcount_recover_cow_leftovers(
>  	error = xfs_btree_query_range(cur, &low, &high,
>  			xfs_refcount_recover_extent, &debris);
>  	if (error)
> -		goto out_error;
> +		goto out_cursor;
>  	xfs_btree_del_cursor(cur, XFS_BTREE_NOERROR);
>  	xfs_buf_relse(agbp);
>  
> @@ -1675,26 +1675,22 @@ xfs_refcount_recover_cow_leftovers(
>  
>  		error = xfs_trans_commit(tp);
>  		if (error)
> +			goto out_free;
>  	}
>  	goto out_free;

don't we need to also delete the cursor after a successful exit?

