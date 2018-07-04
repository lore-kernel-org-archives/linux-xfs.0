Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:46928 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753085AbeGDAvQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 3 Jul 2018 20:51:16 -0400
Date: Tue, 3 Jul 2018 17:51:01 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 12/25] xfs: remove xfs_bunmapi() firstblock param
Message-ID: <20180704005101.GL32415@magnolia>
References: <20180703172319.24509-1-bfoster@redhat.com>
 <20180703172319.24509-13-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180703172319.24509-13-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Jul 03, 2018 at 01:23:06PM -0400, Brian Foster wrote:
> All callers pass ->t_firstblock from the current transaction.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/libxfs/xfs_attr_remote.c |  3 +--
>  fs/xfs/libxfs/xfs_bmap.c        | 25 ++++++++++++-------------
>  fs/xfs/libxfs/xfs_bmap.h        |  5 ++---
>  fs/xfs/libxfs/xfs_da_btree.c    |  3 +--
>  fs/xfs/libxfs/xfs_dir2.c        |  3 +--
>  fs/xfs/xfs_bmap_util.c          |  3 +--
>  fs/xfs/xfs_inode.c              |  3 +--
>  fs/xfs/xfs_reflink.c            |  6 ++----
>  fs/xfs/xfs_symlink.c            |  3 +--
>  9 files changed, 22 insertions(+), 32 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_remote.c
> index 2db9ef186e05..f02c705965ff 100644
> --- a/fs/xfs/libxfs/xfs_attr_remote.c
> +++ b/fs/xfs/libxfs/xfs_attr_remote.c
> @@ -631,8 +631,7 @@ xfs_attr_rmtval_remove(
>  		xfs_defer_init(args->trans, args->trans->t_dfops,
>  			       &args->trans->t_firstblock);
>  		error = xfs_bunmapi(args->trans, args->dp, lblkno, blkcnt,
> -				    XFS_BMAPI_ATTRFORK, 1,
> -				    &args->trans->t_firstblock, &done);
> +				    XFS_BMAPI_ATTRFORK, 1, &done);
>  		if (error)
>  			goto out_defer_cancel;
>  		xfs_defer_ijoin(args->trans->t_dfops, args->dp);
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index fd4125e3b097..967d12f9e415 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -5124,9 +5124,7 @@ __xfs_bunmapi(
>  	xfs_fileoff_t		start,		/* first file offset deleted */
>  	xfs_filblks_t		*rlen,		/* i/o: amount remaining */
>  	int			flags,		/* misc flags */
> -	xfs_extnum_t		nexts,		/* number of extents max */
> -	xfs_fsblock_t		*firstblock)	/* first allocated block
> -						   controls a.g. for allocs */
> +	xfs_extnum_t		nexts)		/* number of extents max */
>  {
>  	struct xfs_btree_cur	*cur;		/* bmap btree cursor */
>  	struct xfs_bmbt_irec	del;		/* extent being deleted */
> @@ -5200,7 +5198,7 @@ __xfs_bunmapi(
>  	if (ifp->if_flags & XFS_IFBROOT) {
>  		ASSERT(XFS_IFORK_FORMAT(ip, whichfork) == XFS_DINODE_FMT_BTREE);
>  		cur = xfs_bmbt_init_cursor(mp, tp, ip, whichfork);
> -		cur->bc_private.b.firstblock = *firstblock;
> +		cur->bc_private.b.firstblock = tp->t_firstblock;
>  		cur->bc_private.b.flags = 0;
>  	} else
>  		cur = NULL;
> @@ -5316,7 +5314,7 @@ __xfs_bunmapi(
>  			del.br_state = XFS_EXT_UNWRITTEN;
>  			error = xfs_bmap_add_extent_unwritten_real(tp, ip,
>  					whichfork, &icur, &cur, &del,
> -					firstblock, &logflags);
> +					&tp->t_firstblock, &logflags);
>  			if (error)
>  				goto error0;
>  			goto nodelete;
> @@ -5373,7 +5371,8 @@ __xfs_bunmapi(
>  				prev.br_state = XFS_EXT_UNWRITTEN;
>  				error = xfs_bmap_add_extent_unwritten_real(tp,
>  						ip, whichfork, &icur, &cur,
> -						&prev, firstblock, &logflags);
> +						&prev, &tp->t_firstblock,
> +						&logflags);
>  				if (error)
>  					goto error0;
>  				goto nodelete;
> @@ -5382,7 +5381,8 @@ __xfs_bunmapi(
>  				del.br_state = XFS_EXT_UNWRITTEN;
>  				error = xfs_bmap_add_extent_unwritten_real(tp,
>  						ip, whichfork, &icur, &cur,
> -						&del, firstblock, &logflags);
> +						&del, &tp->t_firstblock,
> +						&logflags);
>  				if (error)
>  					goto error0;
>  				goto nodelete;
> @@ -5429,8 +5429,8 @@ __xfs_bunmapi(
>  	 */
>  	if (xfs_bmap_needs_btree(ip, whichfork)) {
>  		ASSERT(cur == NULL);
> -		error = xfs_bmap_extents_to_btree(tp, ip, firstblock, &cur, 0,
> -				&tmp_logflags, whichfork);
> +		error = xfs_bmap_extents_to_btree(tp, ip, &tp->t_firstblock,
> +				&cur, 0, &tmp_logflags, whichfork);
>  		logflags |= tmp_logflags;
>  		if (error)
>  			goto error0;
> @@ -5469,7 +5469,7 @@ __xfs_bunmapi(
>  		xfs_trans_log_inode(tp, ip, logflags);
>  	if (cur) {
>  		if (!error) {
> -			*firstblock = cur->bc_private.b.firstblock;
> +			tp->t_firstblock = cur->bc_private.b.firstblock;
>  			cur->bc_private.b.allocated = 0;
>  		}
>  		xfs_btree_del_cursor(cur,
> @@ -5487,12 +5487,11 @@ xfs_bunmapi(
>  	xfs_filblks_t		len,
>  	int			flags,
>  	xfs_extnum_t		nexts,
> -	xfs_fsblock_t		*firstblock,
>  	int			*done)
>  {
>  	int			error;
>  
> -	error = __xfs_bunmapi(tp, ip, bno, &len, flags, nexts, firstblock);
> +	error = __xfs_bunmapi(tp, ip, bno, &len, flags, nexts);
>  	*done = (len == 0);
>  	return error;
>  }
> @@ -6150,7 +6149,7 @@ xfs_bmap_finish_one(
>  		break;
>  	case XFS_BMAP_UNMAP:
>  		error = __xfs_bunmapi(tp, ip, startoff, blockcount,
> -				XFS_BMAPI_REMAP, 1, &tp->t_firstblock);
> +				XFS_BMAPI_REMAP, 1);
>  		break;
>  	default:
>  		ASSERT(0);
> diff --git a/fs/xfs/libxfs/xfs_bmap.h b/fs/xfs/libxfs/xfs_bmap.h
> index 1f9e29f32f20..14e21dcc3044 100644
> --- a/fs/xfs/libxfs/xfs_bmap.h
> +++ b/fs/xfs/libxfs/xfs_bmap.h
> @@ -207,11 +207,10 @@ int	xfs_bmapi_write(struct xfs_trans *tp, struct xfs_inode *ip,
>  		xfs_extlen_t total, struct xfs_bmbt_irec *mval, int *nmap);
>  int	__xfs_bunmapi(struct xfs_trans *tp, struct xfs_inode *ip,
>  		xfs_fileoff_t bno, xfs_filblks_t *rlen, int flags,
> -		xfs_extnum_t nexts, xfs_fsblock_t *firstblock);
> +		xfs_extnum_t nexts);
>  int	xfs_bunmapi(struct xfs_trans *tp, struct xfs_inode *ip,
>  		xfs_fileoff_t bno, xfs_filblks_t len, int flags,
> -		xfs_extnum_t nexts, xfs_fsblock_t *firstblock,
> -		int *done);
> +		xfs_extnum_t nexts, int *done);
>  int	xfs_bmap_del_extent_delay(struct xfs_inode *ip, int whichfork,
>  		struct xfs_iext_cursor *cur, struct xfs_bmbt_irec *got,
>  		struct xfs_bmbt_irec *del);
> diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
> index fe4a192696ae..9efbd2038ffb 100644
> --- a/fs/xfs/libxfs/xfs_da_btree.c
> +++ b/fs/xfs/libxfs/xfs_da_btree.c
> @@ -2392,8 +2392,7 @@ xfs_da_shrink_inode(
>  		 * the last block to the place we want to kill.
>  		 */
>  		error = xfs_bunmapi(tp, dp, dead_blkno, count,
> -				    xfs_bmapi_aflag(w), 0, &tp->t_firstblock,
> -				    &done);
> +				    xfs_bmapi_aflag(w), 0, &done);
>  		if (error == -ENOSPC) {
>  			if (w != XFS_DATA_FORK)
>  				break;
> diff --git a/fs/xfs/libxfs/xfs_dir2.c b/fs/xfs/libxfs/xfs_dir2.c
> index 53e46fda8df4..eadfb3bc0c95 100644
> --- a/fs/xfs/libxfs/xfs_dir2.c
> +++ b/fs/xfs/libxfs/xfs_dir2.c
> @@ -655,8 +655,7 @@ xfs_dir2_shrink_inode(
>  	da = xfs_dir2_db_to_da(args->geo, db);
>  
>  	/* Unmap the fsblock(s). */
> -	error = xfs_bunmapi(tp, dp, da, args->geo->fsbcount, 0, 0,
> -			    &tp->t_firstblock, &done);
> +	error = xfs_bunmapi(tp, dp, da, args->geo->fsbcount, 0, 0, &done);
>  	if (error) {
>  		/*
>  		 * ENOSPC actually can happen if we're in a removename with no
> diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> index 0c433dbc6eb2..3675babb5202 100644
> --- a/fs/xfs/xfs_bmap_util.c
> +++ b/fs/xfs/xfs_bmap_util.c
> @@ -1040,8 +1040,7 @@ xfs_unmap_extent(
>  	xfs_trans_ijoin(tp, ip, 0);
>  
>  	xfs_defer_init(tp, &dfops, &tp->t_firstblock);
> -	error = xfs_bunmapi(tp, ip, startoffset_fsb, len_fsb, 0, 2,
> -			    &tp->t_firstblock, done);
> +	error = xfs_bunmapi(tp, ip, startoffset_fsb, len_fsb, 0, 2, done);
>  	if (error)
>  		goto out_bmap_cancel;
>  
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 3cdfd795a50c..5e1eaa26435c 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -1581,8 +1581,7 @@ xfs_itruncate_extents_flags(
>  	while (!done) {
>  		xfs_defer_init(tp, &dfops, &tp->t_firstblock);
>  		error = xfs_bunmapi(tp, ip, first_unmap_block, unmap_len, flags,
> -				    XFS_ITRUNC_MAX_EXTENTS, &tp->t_firstblock,
> -				    &done);
> +				    XFS_ITRUNC_MAX_EXTENTS, &done);
>  		if (error)
>  			goto out_bmap_cancel;
>  
> diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
> index 258183f28141..cf6080d42273 100644
> --- a/fs/xfs/xfs_reflink.c
> +++ b/fs/xfs/xfs_reflink.c
> @@ -759,8 +759,7 @@ xfs_reflink_end_cow(
>  		/* Unmap the old blocks in the data fork. */
>  		xfs_defer_init(tp, &dfops, &tp->t_firstblock);
>  		rlen = del.br_blockcount;
> -		error = __xfs_bunmapi(tp, ip, del.br_startoff, &rlen, 0, 1,
> -				&tp->t_firstblock);
> +		error = __xfs_bunmapi(tp, ip, del.br_startoff, &rlen, 0, 1);
>  		if (error)
>  			goto out_defer;
>  
> @@ -1107,8 +1106,7 @@ xfs_reflink_remap_extent(
>  	rlen = unmap_len;
>  	while (rlen) {
>  		xfs_defer_init(tp, &dfops, &tp->t_firstblock);
> -		error = __xfs_bunmapi(tp, ip, destoff, &rlen, 0, 1,
> -				      &tp->t_firstblock);
> +		error = __xfs_bunmapi(tp, ip, destoff, &rlen, 0, 1);
>  		if (error)
>  			goto out_defer;
>  
> diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
> index 94301b63525f..a3dc552a5b97 100644
> --- a/fs/xfs/xfs_symlink.c
> +++ b/fs/xfs/xfs_symlink.c
> @@ -460,8 +460,7 @@ xfs_inactive_symlink_rmt(
>  	/*
>  	 * Unmap the dead block(s) to the dfops.
>  	 */
> -	error = xfs_bunmapi(tp, ip, 0, size, 0, nmaps, &tp->t_firstblock,
> -			    &done);
> +	error = xfs_bunmapi(tp, ip, 0, size, 0, nmaps, &done);
>  	if (error)
>  		goto error_bmap_cancel;
>  	ASSERT(done);
> -- 
> 2.17.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
