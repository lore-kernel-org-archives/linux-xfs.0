Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:54932 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752292AbeGCU2I (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 3 Jul 2018 16:28:08 -0400
Date: Tue, 3 Jul 2018 13:27:53 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 07/24] xfs: remove dfops param in attr fork add path
Message-ID: <20180703202753.GD32415@magnolia>
References: <20180628163636.52564-1-bfoster@redhat.com>
 <20180628163636.52564-8-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180628163636.52564-8-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Thu, Jun 28, 2018 at 12:36:19PM -0400, Brian Foster wrote:
> Now that the attribute fork add tx carries dfops along with the
> transaction, it is unnecessary to pass it down the stack. Remove the
> dfops parameter and access ->t_dfops directly where necessary. This
> patch does not change behavior.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/libxfs/xfs_bmap.c | 19 ++++++++-----------
>  1 file changed, 8 insertions(+), 11 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 16bbc8114d62..c4b81fee2dee 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -918,7 +918,6 @@ xfs_bmap_add_attrfork_btree(
>  	xfs_trans_t		*tp,		/* transaction pointer */
>  	xfs_inode_t		*ip,		/* incore inode pointer */
>  	xfs_fsblock_t		*firstblock,	/* first block allocated */
> -	struct xfs_defer_ops	*dfops,		/* blocks to free at commit */
>  	int			*flags)		/* inode logging flags */
>  {
>  	xfs_btree_cur_t		*cur;		/* btree cursor */
> @@ -931,7 +930,7 @@ xfs_bmap_add_attrfork_btree(
>  		*flags |= XFS_ILOG_DBROOT;
>  	else {
>  		cur = xfs_bmbt_init_cursor(mp, tp, ip, XFS_DATA_FORK);
> -		cur->bc_private.b.dfops = dfops;
> +		cur->bc_private.b.dfops = tp->t_dfops;
>  		cur->bc_private.b.firstblock = *firstblock;
>  		error = xfs_bmbt_lookup_first(cur, &stat);
>  		if (error)
> @@ -962,7 +961,6 @@ xfs_bmap_add_attrfork_extents(
>  	xfs_trans_t		*tp,		/* transaction pointer */
>  	xfs_inode_t		*ip,		/* incore inode pointer */
>  	xfs_fsblock_t		*firstblock,	/* first block allocated */
> -	struct xfs_defer_ops	*dfops,		/* blocks to free at commit */
>  	int			*flags)		/* inode logging flags */
>  {
>  	xfs_btree_cur_t		*cur;		/* bmap btree cursor */
> @@ -971,7 +969,7 @@ xfs_bmap_add_attrfork_extents(
>  	if (ip->i_d.di_nextents * sizeof(xfs_bmbt_rec_t) <= XFS_IFORK_DSIZE(ip))
>  		return 0;
>  	cur = NULL;
> -	error = xfs_bmap_extents_to_btree(tp, ip, firstblock, dfops, &cur, 0,
> +	error = xfs_bmap_extents_to_btree(tp, ip, firstblock, tp->t_dfops, &cur, 0,
>  		flags, XFS_DATA_FORK);
>  	if (cur) {
>  		cur->bc_private.b.allocated = 0;
> @@ -997,7 +995,6 @@ xfs_bmap_add_attrfork_local(
>  	xfs_trans_t		*tp,		/* transaction pointer */
>  	xfs_inode_t		*ip,		/* incore inode pointer */
>  	xfs_fsblock_t		*firstblock,	/* first block allocated */
> -	struct xfs_defer_ops	*dfops,		/* blocks to free at commit */
>  	int			*flags)		/* inode logging flags */
>  {
>  	xfs_da_args_t		dargs;		/* args for dir/attr code */
> @@ -1010,7 +1007,7 @@ xfs_bmap_add_attrfork_local(
>  		dargs.geo = ip->i_mount->m_dir_geo;
>  		dargs.dp = ip;
>  		dargs.firstblock = firstblock;
> -		dargs.dfops = dfops;
> +		dargs.dfops = tp->t_dfops;
>  		dargs.total = dargs.geo->fsbcount;
>  		dargs.whichfork = XFS_DATA_FORK;
>  		dargs.trans = tp;
> @@ -1108,16 +1105,16 @@ xfs_bmap_add_attrfork(
>  	logflags = 0;
>  	switch (ip->i_d.di_format) {
>  	case XFS_DINODE_FMT_LOCAL:
> -		error = xfs_bmap_add_attrfork_local(tp, ip, &firstblock, &dfops,
> -			&logflags);
> +		error = xfs_bmap_add_attrfork_local(tp, ip, &firstblock,
> +						    &logflags);
>  		break;
>  	case XFS_DINODE_FMT_EXTENTS:
>  		error = xfs_bmap_add_attrfork_extents(tp, ip, &firstblock,
> -			&dfops, &logflags);
> +						      &logflags);
>  		break;
>  	case XFS_DINODE_FMT_BTREE:
> -		error = xfs_bmap_add_attrfork_btree(tp, ip, &firstblock, &dfops,
> -			&logflags);
> +		error = xfs_bmap_add_attrfork_btree(tp, ip, &firstblock,
> +						    &logflags);
>  		break;
>  	default:
>  		error = 0;
> -- 
> 2.17.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
