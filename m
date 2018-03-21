Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43194 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751778AbeCUNzV (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 21 Mar 2018 09:55:21 -0400
Date: Wed, 21 Mar 2018 09:55:20 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 2/9] xfs: refactor bmap record valiation
Message-ID: <20180321135519.GC11127@bfoster.bfoster>
References: <152107377037.19571.8618901963505842632.stgit@magnolia>
 <152107378261.19571.1457221354115584570.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <152107378261.19571.1457221354115584570.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Wed, Mar 14, 2018 at 05:29:42PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Refactor the bmap validator into a more complete helper that looks for
> extents that run off the end of the device, overflow into the next AG,
> or have invalid flag states, leaving a raw helper so that the inode
> repair can check things even if iget fails.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_bmap.c       |   55 ++++++++++++++++++++++++++++++++++++++--
>  fs/xfs/libxfs/xfs_bmap.h       |    5 ++++
>  fs/xfs/libxfs/xfs_bmap_btree.h |   14 ----------
>  fs/xfs/libxfs/xfs_inode_fork.c |   12 ++++++---
>  4 files changed, 65 insertions(+), 21 deletions(-)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index daae00e..5850e76 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -1261,11 +1261,15 @@ xfs_iread_extents(
>  		 */
>  		frp = XFS_BMBT_REC_ADDR(mp, block, 1);
>  		for (j = 0; j < num_recs; j++, frp++, i++) {
> +			xfs_failaddr_t	fa;
> +
>  			xfs_bmbt_disk_get_all(frp, &new);
> -			if (!xfs_bmbt_validate_extent(mp, whichfork, &new)) {
> -				XFS_ERROR_REPORT("xfs_bmap_read_extents(2)",
> -						 XFS_ERRLEVEL_LOW, mp);
> +			fa = xfs_bmap_validate_extent(ip, whichfork, &new);
> +			if (fa) {
>  				error = -EFSCORRUPTED;
> +				xfs_inode_verifier_error(ip, error,
> +						"xfs_bmap_read_extents(2)",

Might as well fix up the stale function name string.

> +						frp, sizeof(*frp), fa);
>  				goto out_brelse;
>  			}
>  			xfs_iext_insert(ip, &icur, &new, state);
> @@ -6154,3 +6158,48 @@ xfs_bmap_finish_one(
>  
>  	return error;
>  }
> +
> +/* Check that an extent does not have invalid flags or bad ranges. */
> +xfs_failaddr_t
> +xfs_bmbt_validate_extent(
> +	struct xfs_mount	*mp,
> +	bool			isrt,
> +	int			whichfork,
> +	struct xfs_bmbt_irec	*irec)
> +{
> +	xfs_fsblock_t		endfsb;
> +
> +	endfsb = irec->br_startblock + irec->br_blockcount - 1;
> +	if (isrt) {
> +		if (!xfs_verify_rtbno(mp, irec->br_startblock))
> +			return __this_address;
> +		if (!xfs_verify_rtbno(mp, endfsb))
> +			return __this_address;
> +	} else {
> +		if (!xfs_verify_fsbno(mp, irec->br_startblock))
> +			return __this_address;
> +		if (!xfs_verify_fsbno(mp, endfsb))
> +			return __this_address;
> +		if (XFS_FSB_TO_AGNO(mp, irec->br_startblock) !=
> +		    XFS_FSB_TO_AGNO(mp, endfsb))
> +			return __this_address;
> +	}
> +	if (irec->br_state != XFS_EXT_NORM) {
> +		if (whichfork != XFS_DATA_FORK)
> +			return __this_address;
> +		if (!xfs_sb_version_hasextflgbit(&mp->m_sb))
> +			return __this_address;
> +	}
> +	return NULL;
> +}
> +
> +/* Check that an inode's extent does not have invalid flags or bad ranges. */
> +xfs_failaddr_t
> +xfs_bmap_validate_extent(
> +	struct xfs_inode	*ip,
> +	int			whichfork,
> +	struct xfs_bmbt_irec	*irec)
> +{
> +	return xfs_bmbt_validate_extent(ip->i_mount, XFS_IS_REALTIME_INODE(ip),
> +			whichfork, irec);
> +}

Do we really need this wrapper just for an rt check? Why not just pass
ip down to xfs_bmbt_validate_extent() and pull isrt from there (if
present)?

The commit log implies the helper could be left around for future repair
code. If that's the case, I think it's more appropriate to refactor it
as such in whatever patch the helper is first used. Otherwise looks
fine.

Brian

> diff --git a/fs/xfs/libxfs/xfs_bmap.h b/fs/xfs/libxfs/xfs_bmap.h
> index e36d757..e0fef89 100644
> --- a/fs/xfs/libxfs/xfs_bmap.h
> +++ b/fs/xfs/libxfs/xfs_bmap.h
> @@ -274,4 +274,9 @@ static inline int xfs_bmap_fork_to_state(int whichfork)
>  	}
>  }
>  
> +xfs_failaddr_t xfs_bmbt_validate_extent(struct xfs_mount *mp, bool isrt,
> +		int whichfork, struct xfs_bmbt_irec *irec);
> +xfs_failaddr_t xfs_bmap_validate_extent(struct xfs_inode *ip, int whichfork,
> +		struct xfs_bmbt_irec *irec);
> +
>  #endif	/* __XFS_BMAP_H__ */
> diff --git a/fs/xfs/libxfs/xfs_bmap_btree.h b/fs/xfs/libxfs/xfs_bmap_btree.h
> index 135b8c5..e450574 100644
> --- a/fs/xfs/libxfs/xfs_bmap_btree.h
> +++ b/fs/xfs/libxfs/xfs_bmap_btree.h
> @@ -118,18 +118,4 @@ extern int xfs_bmbt_change_owner(struct xfs_trans *tp, struct xfs_inode *ip,
>  extern struct xfs_btree_cur *xfs_bmbt_init_cursor(struct xfs_mount *,
>  		struct xfs_trans *, struct xfs_inode *, int);
>  
> -/*
> - * Check that the extent does not contain an invalid unwritten extent flag.
> - */
> -static inline bool xfs_bmbt_validate_extent(struct xfs_mount *mp, int whichfork,
> -		struct xfs_bmbt_irec *irec)
> -{
> -	if (irec->br_state == XFS_EXT_NORM)
> -		return true;
> -	if (whichfork == XFS_DATA_FORK &&
> -	    xfs_sb_version_hasextflgbit(&mp->m_sb))
> -		return true;
> -	return false;
> -}
> -
>  #endif	/* __XFS_BMAP_BTREE_H__ */
> diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
> index 866d2861..613fba2 100644
> --- a/fs/xfs/libxfs/xfs_inode_fork.c
> +++ b/fs/xfs/libxfs/xfs_inode_fork.c
> @@ -245,10 +245,14 @@ xfs_iformat_extents(
>  
>  		xfs_iext_first(ifp, &icur);
>  		for (i = 0; i < nex; i++, dp++) {
> +			xfs_failaddr_t	fa;
> +
>  			xfs_bmbt_disk_get_all(dp, &new);
> -			if (!xfs_bmbt_validate_extent(mp, whichfork, &new)) {
> -				XFS_ERROR_REPORT("xfs_iformat_extents(2)",
> -						 XFS_ERRLEVEL_LOW, mp);
> +			fa = xfs_bmap_validate_extent(ip, whichfork, &new);
> +			if (fa) {
> +				xfs_inode_verifier_error(ip, -EFSCORRUPTED,
> +						"xfs_iformat_extents(2)",
> +						dp, sizeof(*dp), fa);
>  				return -EFSCORRUPTED;
>  			}
>  
> @@ -595,7 +599,7 @@ xfs_iextents_copy(
>  	for_each_xfs_iext(ifp, &icur, &rec) {
>  		if (isnullstartblock(rec.br_startblock))
>  			continue;
> -		ASSERT(xfs_bmbt_validate_extent(ip->i_mount, whichfork, &rec));
> +		ASSERT(xfs_bmap_validate_extent(ip, whichfork, &rec) == NULL);
>  		xfs_bmbt_disk_set_all(dp, &rec);
>  		trace_xfs_write_extent(ip, &icur, state, _RET_IP_);
>  		copied += sizeof(struct xfs_bmbt_rec);
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
