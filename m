Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:8763 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752109AbeDCBxv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 2 Apr 2018 21:53:51 -0400
Date: Tue, 3 Apr 2018 11:53:48 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/2] xfs: hoist xfs_scrub_agfl_walk to libxfs as
 xfs_agfl_walk
Message-ID: <20180403015348.GJ1150@dastard>
References: <152269892987.16253.3900560313483881560.stgit@magnolia>
 <152269894202.16253.2257249480679291752.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <152269894202.16253.2257249480679291752.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Mon, Apr 02, 2018 at 12:55:42PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> This function is basically a generic AGFL block iterator, so promote it
> to libxfs ahead of online repair wanting to use it.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_alloc.c |   37 +++++++++++++++++++++
>  fs/xfs/libxfs/xfs_alloc.h |    5 +++
>  fs/xfs/scrub/agheader.c   |   78 ++++++++-------------------------------------
>  fs/xfs/scrub/common.h     |    4 --
>  4 files changed, 55 insertions(+), 69 deletions(-)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> index 4c03ec2..d860116 100644
> --- a/fs/xfs/libxfs/xfs_alloc.c
> +++ b/fs/xfs/libxfs/xfs_alloc.c
> @@ -3128,3 +3128,40 @@ xfs_alloc_has_record(
>  
>  	return xfs_btree_has_record(cur, &low, &high, exists);
>  }
> +
> +/*
> + * Walk all the blocks in the AGFL.  The fn function can return any negative
> + * error code or XFS_BTREE_QUERY_RANGE_ABORT.
> + */
> +int
> +xfs_agfl_walk(
> +	struct xfs_mount	*mp,
> +	struct xfs_agf		*agf,
> +	struct xfs_buf		*agflbp,
> +	xfs_agfl_walk_fn	fn,

	xfs_agfl_walk_fn	walk_fn,

I don't really like "fn" as a variable - it's hard to pick out what
it does and where it's called in the code.

Also, the comment would make more sense as "The @walk_fn can return
any negative....

Otherwise looks OK.

-Dave.

-- 
Dave Chinner
david@fromorbit.com
