Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id CA4B27F37
	for <xfs@oss.sgi.com>; Thu, 25 Jul 2013 14:53:28 -0500 (CDT)
Date: Thu, 25 Jul 2013 14:53:25 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 15/48] xfs: add CRCs to attr leaf blocks
Message-ID: <20130725195325.GC3111@sgi.com>
References: <1370564771-4929-1-git-send-email-david@fromorbit.com>
	<1370564771-4929-16-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1370564771-4929-16-git-send-email-david@fromorbit.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Fri, Jun 07, 2013 at 10:25:38AM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

This one corresponds to commit 517c22207b04.

The xfs_db, metadump, and repair changes look good.

Note don't have xfs_attr_inactive, xfs_attr_leaf_list, xfs_attr_node_list,
xfs_attr_node_inactive, xfs_attr_leaf_inactive, xfs_attr_leaf_freextent,
xfs_attr_root_inactive, and xfs_attr_leaf_list_int in userspace.

> @@ -854,24 +854,24 @@ xfs_attr_leaf_removename(xfs_da_args_t *args)
>  	 */
>  	dp = args->dp;
>  	args->blkno = 0;
> -	error = xfs_attr_leaf_read(args->trans, args->dp, args->blkno, -1, &bp);
> +	error = xfs_attr3_leaf_read(args->trans, args->dp, args->blkno, -1, &bp);
>  	if (error)
>  		return error;
>  
> -	error = xfs_attr_leaf_lookup_int(bp, args);
> +	error = xfs_attr3_leaf_lookup_int(bp, args);
>  	if (error == ENOATTR) {
>  		xfs_trans_brelse(args->trans, bp);
>  		return(error);

In the kernel patch the parens are removed:

	return error;

Again, this is probably fixed in a subsequent patch.

>  STATIC int
> -xfs_attr_leaf_add_work(
> -	struct xfs_buf	*bp,
> -	xfs_da_args_t	*args,
> -	int		mapindex)
> +xfs_attr3_leaf_add_work(
> +	struct xfs_buf		*bp,
> +	struct xfs_attr3_icleaf_hdr *ichdr,
> +	struct xfs_da_args	*args,
> +	int			mapindex)
>  {
> -	xfs_attr_leafblock_t *leaf;
> -	xfs_attr_leaf_hdr_t *hdr;
> -	xfs_attr_leaf_entry_t *entry;
> -	xfs_attr_leaf_name_local_t *name_loc;
> -	xfs_attr_leaf_name_remote_t *name_rmt;
> -	xfs_attr_leaf_map_t *map;
> -	xfs_mount_t *mp;
> -	int tmp, i;
> +	struct xfs_attr_leafblock *leaf;
> +	struct xfs_attr_leaf_entry *entry;
> +	struct xfs_attr_leaf_name_local *name_loc;
> +	struct xfs_attr_leaf_name_remote *name_rmt;
> +	struct xfs_attr_leaf_map *map;

The kernel commit removed map.  Probably fixed in a subsequent patch.

Reviewed-by: Ben Myers <bpm@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
