Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53446 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730997AbfFMQYb (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 13 Jun 2019 12:24:31 -0400
Date: Thu, 13 Jun 2019 12:24:26 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 01/14] xfs: create iterator error codes
Message-ID: <20190613162423.GA21773@bfoster>
References: <156032205136.3774243.15725828509940520561.stgit@magnolia>
 <156032205794.3774243.2000474980369140298.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <156032205794.3774243.2000474980369140298.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Jun 11, 2019 at 11:47:37PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Currently, xfs doesn't have generic error codes defined for "stop
> iterating"; we just reuse the XFS_BTREE_QUERY_* return values.  This
> looks a little weird if we're not actually iterating a btree index.
> Before we start adding more iterators, we should create general
> XFS_ITER_{CONTINUE,ABORT} return values and define the XFS_BTREE_QUERY_*
> ones from that.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

Have you given any thought to just replacing
XFS_BTREE_QUERY_RANGE_[ABORT|CONTINUE] with the generic ITER variants
and using the latter wherever applicable?

This patch looks fine either way:

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/libxfs/xfs_alloc.c  |    2 +-
>  fs/xfs/libxfs/xfs_btree.h  |    4 ++--
>  fs/xfs/libxfs/xfs_shared.h |    6 ++++++
>  fs/xfs/scrub/agheader.c    |    4 ++--
>  fs/xfs/scrub/repair.c      |    4 ++--
>  fs/xfs/xfs_dquot.c         |    2 +-
>  6 files changed, 14 insertions(+), 8 deletions(-)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> index a9ff3cf82cce..b9eb3a8aeaf9 100644
> --- a/fs/xfs/libxfs/xfs_alloc.c
> +++ b/fs/xfs/libxfs/xfs_alloc.c
> @@ -3146,7 +3146,7 @@ xfs_alloc_has_record(
>  
>  /*
>   * Walk all the blocks in the AGFL.  The @walk_fn can return any negative
> - * error code or XFS_BTREE_QUERY_RANGE_ABORT.
> + * error code or XFS_ITER_*.
>   */
>  int
>  xfs_agfl_walk(
> diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
> index e3b3e9dce5da..94530766dd30 100644
> --- a/fs/xfs/libxfs/xfs_btree.h
> +++ b/fs/xfs/libxfs/xfs_btree.h
> @@ -469,8 +469,8 @@ uint xfs_btree_compute_maxlevels(uint *limits, unsigned long len);
>  unsigned long long xfs_btree_calc_size(uint *limits, unsigned long long len);
>  
>  /* return codes */
> -#define XFS_BTREE_QUERY_RANGE_CONTINUE	0	/* keep iterating */
> -#define XFS_BTREE_QUERY_RANGE_ABORT	1	/* stop iterating */
> +#define XFS_BTREE_QUERY_RANGE_CONTINUE	(XFS_ITER_CONTINUE) /* keep iterating */
> +#define XFS_BTREE_QUERY_RANGE_ABORT	(XFS_ITER_ABORT)    /* stop iterating */
>  typedef int (*xfs_btree_query_range_fn)(struct xfs_btree_cur *cur,
>  		union xfs_btree_rec *rec, void *priv);
>  
> diff --git a/fs/xfs/libxfs/xfs_shared.h b/fs/xfs/libxfs/xfs_shared.h
> index 4e909791aeac..fa788139dfe3 100644
> --- a/fs/xfs/libxfs/xfs_shared.h
> +++ b/fs/xfs/libxfs/xfs_shared.h
> @@ -136,4 +136,10 @@ void xfs_symlink_local_to_remote(struct xfs_trans *tp, struct xfs_buf *bp,
>  				 struct xfs_inode *ip, struct xfs_ifork *ifp);
>  xfs_failaddr_t xfs_symlink_shortform_verify(struct xfs_inode *ip);
>  
> +/* Keep iterating the data structure. */
> +#define XFS_ITER_CONTINUE	(0)
> +
> +/* Stop iterating the data structure. */
> +#define XFS_ITER_ABORT		(1)
> +
>  #endif /* __XFS_SHARED_H__ */
> diff --git a/fs/xfs/scrub/agheader.c b/fs/xfs/scrub/agheader.c
> index adaeabdefdd3..1d5361f9ebfc 100644
> --- a/fs/xfs/scrub/agheader.c
> +++ b/fs/xfs/scrub/agheader.c
> @@ -646,7 +646,7 @@ xchk_agfl_block(
>  	xchk_agfl_block_xref(sc, agbno);
>  
>  	if (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
> -		return XFS_BTREE_QUERY_RANGE_ABORT;
> +		return XFS_ITER_ABORT;
>  
>  	return 0;
>  }
> @@ -737,7 +737,7 @@ xchk_agfl(
>  	/* Check the blocks in the AGFL. */
>  	error = xfs_agfl_walk(sc->mp, XFS_BUF_TO_AGF(sc->sa.agf_bp),
>  			sc->sa.agfl_bp, xchk_agfl_block, &sai);
> -	if (error == XFS_BTREE_QUERY_RANGE_ABORT) {
> +	if (error == XFS_ITER_ABORT) {
>  		error = 0;
>  		goto out_free;
>  	}
> diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
> index eb358f0f5e0a..e2a352c1bad7 100644
> --- a/fs/xfs/scrub/repair.c
> +++ b/fs/xfs/scrub/repair.c
> @@ -672,7 +672,7 @@ xrep_findroot_agfl_walk(
>  {
>  	xfs_agblock_t		*agbno = priv;
>  
> -	return (*agbno == bno) ? XFS_BTREE_QUERY_RANGE_ABORT : 0;
> +	return (*agbno == bno) ? XFS_ITER_ABORT : 0;
>  }
>  
>  /* Does this block match the btree information passed in? */
> @@ -702,7 +702,7 @@ xrep_findroot_block(
>  	if (owner == XFS_RMAP_OWN_AG) {
>  		error = xfs_agfl_walk(mp, ri->agf, ri->agfl_bp,
>  				xrep_findroot_agfl_walk, &agbno);
> -		if (error == XFS_BTREE_QUERY_RANGE_ABORT)
> +		if (error == XFS_ITER_ABORT)
>  			return 0;
>  		if (error)
>  			return error;
> diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
> index a1af984e4913..8674551c5e98 100644
> --- a/fs/xfs/xfs_dquot.c
> +++ b/fs/xfs/xfs_dquot.c
> @@ -1243,7 +1243,7 @@ xfs_qm_exit(void)
>  /*
>   * Iterate every dquot of a particular type.  The caller must ensure that the
>   * particular quota type is active.  iter_fn can return negative error codes,
> - * or XFS_BTREE_QUERY_RANGE_ABORT to indicate that it wants to stop iterating.
> + * or XFS_ITER_ABORT to indicate that it wants to stop iterating.
>   */
>  int
>  xfs_qm_dqiterate(
> 
