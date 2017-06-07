Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:19824 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750810AbdFGOWh (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 7 Jun 2017 10:22:37 -0400
Date: Wed, 7 Jun 2017 10:22:35 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH v2 01/13] xfs: optimize _btree_query_all
Message-ID: <20170607142235.GB64146@bfoster.bfoster>
References: <149643863965.23065.10505493683913299340.stgit@birch.djwong.org>
 <149643864610.23065.12274956619066749994.stgit@birch.djwong.org>
 <20170607011853.GA4530@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170607011853.GA4530@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Jun 06, 2017 at 06:18:53PM -0700, Darrick J. Wong wrote:
> Don't bother wandering our way through the leaf nodes when the caller
> issues a query_all; just zoom down the left side of the tree and walk
> rightwards along level zero.  In other words, use the simple query
> range implementation.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/libxfs/xfs_btree.c |   12 +++++++-----
>  1 file changed, 7 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
> index 3a673ba..d505179 100644
> --- a/fs/xfs/libxfs/xfs_btree.c
> +++ b/fs/xfs/libxfs/xfs_btree.c
> @@ -4849,12 +4849,14 @@ xfs_btree_query_all(
>  	xfs_btree_query_range_fn	fn,
>  	void				*priv)
>  {
> -	union xfs_btree_irec		low_rec;
> -	union xfs_btree_irec		high_rec;
> +	union xfs_btree_key		low_key;
> +	union xfs_btree_key		high_key;
> +
> +	memset(&cur->bc_rec, 0, sizeof(cur->bc_rec));
> +	memset(&low_key, 0, sizeof(low_key));
> +	memset(&high_key, 0xFF, sizeof(high_key));
>  
> -	memset(&low_rec, 0, sizeof(low_rec));
> -	memset(&high_rec, 0xFF, sizeof(high_rec));
> -	return xfs_btree_query_range(cur, &low_rec, &high_rec, fn, priv);
> +	return xfs_btree_simple_query_range(cur, &low_key, &high_key, fn, priv);
>  }
>  
>  /*
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
