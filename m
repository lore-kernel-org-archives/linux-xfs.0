Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:22739 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726604AbeKGHlF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 7 Nov 2018 02:41:05 -0500
Date: Wed, 7 Nov 2018 09:13:38 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 7/8] xfs: rename xchk_iallocbt_check_freemask
Message-ID: <20181106221338.GU19305@dastard>
References: <154147728649.32496.4515247239602322709.stgit@magnolia>
 <154147733302.32496.14353755611959314260.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <154147733302.32496.14353755611959314260.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Mon, Nov 05, 2018 at 08:08:53PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Change the name of xchk_iallocbt_check_freemask so that it represents
> what the function actually does.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/scrub/ialloc.c |   17 ++++++++++++++---
>  1 file changed, 14 insertions(+), 3 deletions(-)
> 
> 
> diff --git a/fs/xfs/scrub/ialloc.c b/fs/xfs/scrub/ialloc.c
> index 645b248faa80..10c3aaefc2a3 100644
> --- a/fs/xfs/scrub/ialloc.c
> +++ b/fs/xfs/scrub/ialloc.c
> @@ -305,9 +305,13 @@ xchk_iallocbt_check_cluster(
>  	return error;
>  }
>  
> -/* Make sure the free mask is consistent with what the inodes think. */
> +/*
> + * For all the inode clusters that could map to this inobt record, make sure
> + * that the holemask makes sense and that the allocation status of each inode
> + * matches the freemask.
> + */
>  STATIC int
> -xchk_iallocbt_check_freemask(
> +xchk_iallocbt_check_clusters(
>  	struct xchk_btree		*bs,
>  	struct xchk_iallocbt		*iabt,
>  	struct xfs_inobt_rec_incore	*irec)
> @@ -315,6 +319,13 @@ xchk_iallocbt_check_freemask(
>  	unsigned int			chunk_ioff;
>  	int				error = 0;
>  
> +	/*
> +	 * For the common case where this inobt record maps to multiple inode
> +	 * clusters this will call _check_cluster for each cluster.
> +	 *
> +	 * For the case that multiple inobt records map to a single cluster,
> +	 * this will call _check_cluster once.
> +	 */
>  	for (chunk_ioff = 0;
>  	     chunk_ioff < XFS_INODES_PER_CHUNK;
>  	     chunk_ioff += iabt->inodes_per_cluster) {

This comment really belongs in the previous patch. And, with that, I
think this can be merged totally into the previous patch.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
