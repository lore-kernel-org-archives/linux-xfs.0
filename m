Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60896 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751190AbdFGPL3 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 7 Jun 2017 11:11:29 -0400
Date: Wed, 7 Jun 2017 11:11:27 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH v2 9.9/13] xfs: make _bmap_count_blocks consistent wrt
 delalloc extent behavior
Message-ID: <20170607151126.GE64146@bfoster.bfoster>
References: <149643863965.23065.10505493683913299340.stgit@birch.djwong.org>
 <149643870157.23065.16428953914864164786.stgit@birch.djwong.org>
 <20170607012910.GD4530@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170607012910.GD4530@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Jun 06, 2017 at 06:29:10PM -0700, Darrick J. Wong wrote:
> There is an inconsistency in the way that _bmap_count_blocks deals with
> delalloc reservations -- if the specified fork is in extents format,
> *count is set to the total number of blocks referenced by the in-core
> fork, including delalloc extents.  However, if the fork is in btree
> format, *count is set to the number of blocks referenced by the on-disk
> fork, which does /not/ include delalloc extents.
> 
> For the lone existing caller of _bmap_count_blocks this hasn't been an
> issue because the function is only used to count xattr fork blocks
> (where there aren't any delalloc reservations).  However, when scrub
> comes along it will use this same function to check di_nblocks against
> both on-disk extent maps, so we need this behavior to be consistent.
> 
> Therefore, fix _bmap_count_leaves not to include delalloc extents and
> remove unnecessary parameters.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/xfs_bmap_util.c |   17 +++++++++--------
>  1 file changed, 9 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> index fe83bbc..a34c3ce 100644
> --- a/fs/xfs/xfs_bmap_util.c
> +++ b/fs/xfs/xfs_bmap_util.c
> @@ -223,16 +223,17 @@ xfs_bmap_eof(
>   */

A quick update to the function comment would be nice just to point out
that we skip delalloc blocks to be consistent with the bmbt case.
Otherwise looks good to me:

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  STATIC void
>  xfs_bmap_count_leaves(
> -	xfs_ifork_t		*ifp,
> -	xfs_extnum_t		idx,
> -	int			numrecs,
> +	struct xfs_ifork	*ifp,
>  	int			*count)
>  {
> -	int		b;
> +	xfs_extnum_t		i;
> +	xfs_extnum_t		nr_exts = xfs_iext_count(ifp);
>  
> -	for (b = 0; b < numrecs; b++) {
> -		xfs_bmbt_rec_host_t *frp = xfs_iext_get_ext(ifp, idx + b);
> -		*count += xfs_bmbt_get_blockcount(frp);
> +	for (i = 0; i < nr_exts; i++) {
> +		xfs_bmbt_rec_host_t *frp = xfs_iext_get_ext(ifp, i);
> +		if (!isnullstartblock(xfs_bmbt_get_startblock(frp))) {
> +			*count += xfs_bmbt_get_blockcount(frp);
> +		}
>  	}
>  }
>  
> @@ -354,7 +355,7 @@ xfs_bmap_count_blocks(
>  	mp = ip->i_mount;
>  	ifp = XFS_IFORK_PTR(ip, whichfork);
>  	if ( XFS_IFORK_FORMAT(ip, whichfork) == XFS_DINODE_FMT_EXTENTS ) {
> -		xfs_bmap_count_leaves(ifp, 0, xfs_iext_count(ifp), count);
> +		xfs_bmap_count_leaves(ifp, count);
>  		return 0;
>  	}
>  
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
