Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail01.adl2.internode.on.net ([150.101.137.133]:54329 "EHLO
        ipmail01.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751603AbeFDAKX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 3 Jun 2018 20:10:23 -0400
Date: Mon, 4 Jun 2018 10:10:19 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 04/10] xfs: check directory bestfree information in the
 verifier
Message-ID: <20180604001019.GC10363@dastard>
References: <152806814253.18187.4009340462930782844.stgit@magnolia>
 <152806816970.18187.13658571880127164744.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <152806816970.18187.13658571880127164744.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Sun, Jun 03, 2018 at 04:22:49PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Create a variant of xfs_dir2_data_freefind that is suitable for use in a
> verifier.  Because _freefind is called by the verifier, we simply
> duplicate the _freefind function, convert the ASSERTs to return
> __this_address, and modify the verifier to call our new function.  Once
> we've made it impossible for directory blocks with bad bestfree data to
> make it into the filesystem we can remove the DEBUG code from the
> regular _freefind function.
> 
> Underlying argument: corruption of on-disk metadata should return
> -EFSCORRUPTED instead of blowing ASSERTs.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_dir2_data.c |  121 +++++++++++++++++++++++++++++------------
>  1 file changed, 86 insertions(+), 35 deletions(-)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_dir2_data.c b/fs/xfs/libxfs/xfs_dir2_data.c
> index cb67ec730b9b..bc5c0ba46ec6 100644
> --- a/fs/xfs/libxfs/xfs_dir2_data.c
> +++ b/fs/xfs/libxfs/xfs_dir2_data.c
> @@ -33,6 +33,11 @@
>  #include "xfs_cksum.h"
>  #include "xfs_log.h"
>  
> +static xfs_failaddr_t xfs_dir2_data_freefind_verify(
> +		struct xfs_dir2_data_hdr *hdr, struct xfs_dir2_data_free *bf,
> +		struct xfs_dir2_data_unused *dup,
> +		struct xfs_dir2_data_free **bf_ent);
> +
>  /*
>   * Check the consistency of the data block.
>   * The input can also be a block-format directory.
> @@ -52,6 +57,7 @@ __xfs_dir3_data_check(
>  	xfs_dir2_data_free_t	*dfp;		/* bestfree entry */
>  	xfs_dir2_data_unused_t	*dup;		/* unused entry */
>  	char			*endp;		/* end of useful data */
> +	xfs_failaddr_t		fa;
>  	int			freeseen;	/* mask of bestfrees seen */
>  	xfs_dahash_t		hash;		/* hash of current name */
>  	int			i;		/* leaf index */

This could be placed inside the loop scope, right?

> -	ASSERT(hdr->magic == cpu_to_be32(XFS_DIR2_DATA_MAGIC) ||
> -	       hdr->magic == cpu_to_be32(XFS_DIR3_DATA_MAGIC) ||
> -	       hdr->magic == cpu_to_be32(XFS_DIR2_BLOCK_MAGIC) ||
> -	       hdr->magic == cpu_to_be32(XFS_DIR3_BLOCK_MAGIC));
> -	for (dfp = &bf[0], seenzero = matched = 0;
> -	     dfp < &bf[XFS_DIR2_DATA_FD_COUNT];
> -	     dfp++) {
> +	for (dfp = &bf[0]; dfp < &bf[XFS_DIR2_DATA_FD_COUNT]; dfp++) {
>  		if (!dfp->offset) {
> -			ASSERT(!dfp->length);
> -			seenzero = 1;
> +			if (dfp->length)
> +				return __this_address;
> +			seenzero = true;
>  			continue;
>  		}
> -		ASSERT(seenzero == 0);
> +		if (seenzero)
> +			return __this_address;
>  		if (be16_to_cpu(dfp->offset) == off) {
> -			matched = 1;
> -			ASSERT(dfp->length == dup->length);
> -		} else if (off < be16_to_cpu(dfp->offset))
> -			ASSERT(off + be16_to_cpu(dup->length) <= be16_to_cpu(dfp->offset));
> -		else
> -			ASSERT(be16_to_cpu(dfp->offset) + be16_to_cpu(dfp->length) <= off);
> -		ASSERT(matched || be16_to_cpu(dfp->length) >= be16_to_cpu(dup->length));
> -		if (dfp > &bf[0])
> -			ASSERT(be16_to_cpu(dfp[-1].length) >= be16_to_cpu(dfp[0].length));
> +			matched = true;
> +			if (dfp->length != dup->length)
> +				return __this_address;
> +		} else if (be16_to_cpu(dfp->offset) > off) {
> +			if (off + be16_to_cpu(dup->length) >
> +			    be16_to_cpu(dfp->offset))

can you indent the second line further to indicate it is a
continuation of the logic statement on the previous line rather than
a new logic condition? i.e.

			if (off + be16_to_cpu(dup->length) >
					be16_to_cpu(dfp->offset))
> +				return __this_address;
> +		} else {
> +			if (be16_to_cpu(dfp->offset) +
> +			    be16_to_cpu(dfp->length) > off)
> +				return __this_address;

Same here?

> +		}
> +		if (!matched &&
> +		    be16_to_cpu(dfp->length) < be16_to_cpu(dup->length))
> +			return __this_address;
> +		if (dfp > &bf[0] &&
> +		    be16_to_cpu(dfp[-1].length) < be16_to_cpu(dfp[0].length))
> +			return __this_address;
>  	}
> -#endif
> +
> +	/*
> +	 * If this is smaller than the smallest bestfree entry,
> +	 * it can't be there since they're sorted.
> +	 */
> +	if (be16_to_cpu(dup->length) <
> +	    be16_to_cpu(bf[XFS_DIR2_DATA_FD_COUNT - 1].length))
> +		return NULL;
> +	/*
> +	 * Look at the three bestfree entries for our guy.
> +	 */
> +	for (dfp = &bf[0]; dfp < &bf[XFS_DIR2_DATA_FD_COUNT]; dfp++) {
> +		if (!dfp->offset)
> +			return NULL;
> +		if (be16_to_cpu(dfp->offset) == off) {
> +			*bf_ent = dfp;
> +			return NULL;
> +		}
> +	}
> +	/*
> +	 * Didn't find it.  This only happens if there are duplicate lengths.
> +	 */
> +	return NULL;

And this tail is basically a duplicate of what now remains in
xfs_dir2_data_freefind(). Can you call that function rather than
duplicating the search code?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
