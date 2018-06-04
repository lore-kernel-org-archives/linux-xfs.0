Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail01.adl2.internode.on.net ([150.101.137.133]:20882 "EHLO
        ipmail01.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751232AbeFDAOJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 3 Jun 2018 20:14:09 -0400
Date: Mon, 4 Jun 2018 10:14:06 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 07/10] xfs: xfs_alloc_get_rec should return EFSCORRUPTED
 for obvious bnobt corruption
Message-ID: <20180604001406.GE10363@dastard>
References: <152806814253.18187.4009340462930782844.stgit@magnolia>
 <152806818878.18187.4844773238575124410.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <152806818878.18187.4844773238575124410.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Sun, Jun 03, 2018 at 04:23:08PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Return -EFSCORRUPTED when the bnobt/cntbt return obviously corrupt
> values, rather than letting them bounce around in the internal code.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_alloc.c |   12 ++++++++----
>  1 file changed, 8 insertions(+), 4 deletions(-)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> index dc9dd3805d97..0214a77808d0 100644
> --- a/fs/xfs/libxfs/xfs_alloc.c
> +++ b/fs/xfs/libxfs/xfs_alloc.c
> @@ -231,10 +231,14 @@ xfs_alloc_get_rec(
>  	int			error;
>  
>  	error = xfs_btree_get_rec(cur, &rec, stat);
> -	if (!error && *stat == 1) {
> -		*bno = be32_to_cpu(rec->alloc.ar_startblock);
> -		*len = be32_to_cpu(rec->alloc.ar_blockcount);
> -	}
> +	if (error || !(*stat))
> +		return error;
> +	if (rec->alloc.ar_blockcount == 0)
> +		return -EFSCORRUPTED;
> +
> +	*bno = be32_to_cpu(rec->alloc.ar_startblock);
> +	*len = be32_to_cpu(rec->alloc.ar_blockcount);

Looks good, but makes me wonder if we should verify that
ar_startblock is a valid agbno, and that the extent lies wholly
within the AG? That can be another patch, though.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com
