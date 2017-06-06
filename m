Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36674 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751345AbdFFNco (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 6 Jun 2017 09:32:44 -0400
Date: Tue, 6 Jun 2017 09:32:42 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 01/13] xfs: optimize _btree_query_all
Message-ID: <20170606133239.GA51630@bfoster.bfoster>
References: <149643863965.23065.10505493683913299340.stgit@birch.djwong.org>
 <149643864610.23065.12274956619066749994.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <149643864610.23065.12274956619066749994.stgit@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Fri, Jun 02, 2017 at 02:24:06PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Don't bother wandering our way through the leaf nodes when the caller
> issues a query_all; just zoom down the left side of the tree and walk
> rightwards along level zero.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_btree.c |   44 +++++++++++++++++++++++++++++++++++++++-----
>  1 file changed, 39 insertions(+), 5 deletions(-)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
> index 3a673ba..07d75bc 100644
> --- a/fs/xfs/libxfs/xfs_btree.c
> +++ b/fs/xfs/libxfs/xfs_btree.c
> @@ -4849,12 +4849,46 @@ xfs_btree_query_all(
>  	xfs_btree_query_range_fn	fn,
>  	void				*priv)
>  {
> -	union xfs_btree_irec		low_rec;
> -	union xfs_btree_irec		high_rec;
> +	union xfs_btree_rec		*recp;
> +	int				stat;
> +	int				error;
> +
> +	/*
> +	 * Find the leftmost record.  The btree cursor must be set
> +	 * to the low record used to generate low_key.
> +	 */
> +	memset(&cur->bc_rec, 0, sizeof(cur->bc_rec));
> +	stat = 0;
> +	error = xfs_btree_lookup(cur, XFS_LOOKUP_LE, &stat);
> +	if (error)
> +		goto out;
> +
> +	/* Nothing?  See if there's anything to the right. */
> +	if (!stat) {
> +		error = xfs_btree_increment(cur, 0, &stat);
> +		if (error)
> +			goto out;
> +	}
>  
> -	memset(&low_rec, 0, sizeof(low_rec));
> -	memset(&high_rec, 0xFF, sizeof(high_rec));
> -	return xfs_btree_query_range(cur, &low_rec, &high_rec, fn, priv);
> +	while (stat) {
> +		/* Find the record. */
> +		error = xfs_btree_get_rec(cur, &recp, &stat);
> +		if (error || !stat)
> +			break;
> +
> +		/* Callback */
> +		error = fn(cur, recp, priv);
> +		if (error < 0 || error == XFS_BTREE_QUERY_RANGE_ABORT)
> +			break;
> +
> +		/* Move on to the next record. */
> +		error = xfs_btree_increment(cur, 0, &stat);
> +		if (error)
> +			break;
> +	}
> +
> +out:
> +	return error;

This all looks quite similar to xfs_btree_simple_query_range(), minus
the associated key checks. I doubt the latter measurably affects the
performance of a btree walk. Could we call that function directly here?

Brian

>  }
>  
>  /*
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
