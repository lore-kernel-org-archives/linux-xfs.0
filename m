Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:41876 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388476AbeGXWDV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 24 Jul 2018 18:03:21 -0400
Date: Tue, 24 Jul 2018 13:54:53 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v2 13/15] xfs: remove unnecessary dfops init calls in
 xattr code
Message-ID: <20180724205453.GL4813@magnolia>
References: <20180723130414.47980-1-bfoster@redhat.com>
 <20180723130414.47980-14-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180723130414.47980-14-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Mon, Jul 23, 2018 at 09:04:12AM -0400, Brian Foster wrote:
> Each xfs_defer_init() call in the xattr code uses the internal dfops
> reference. In addition, a successful xfs_defer_finish() always
> returns with a reset xfs_defer_ops structure.
> 
> Given that along with the fact that every xfs_defer_init() call in
> the xattr code is followed up by an xfs_defer_finish(), the former
> calls are no longer necessary and can be removed.
> 
> Note that the xfs_defer_init() call in the remote value copy loop of
> xfs_attr_rmtval_set() is not followed by a finish, but the dfops is
> unused in this instance.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/libxfs/xfs_attr.c        | 8 --------
>  fs/xfs/libxfs/xfs_attr_remote.c | 3 ---
>  2 files changed, 11 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index 66a22c80a0db..3e98f0af389c 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -587,7 +587,6 @@ xfs_attr_leaf_addname(
>  		 * Commit that transaction so that the node_addname() call
>  		 * can manage its own transactions.
>  		 */
> -		xfs_defer_init(args->trans, args->trans->t_dfops);
>  		error = xfs_attr3_leaf_to_node(args);
>  		if (error)
>  			goto out_defer_cancel;
> @@ -676,7 +675,6 @@ xfs_attr_leaf_addname(
>  		 * If the result is small enough, shrink it all into the inode.
>  		 */
>  		if ((forkoff = xfs_attr_shortform_allfit(bp, dp))) {
> -			xfs_defer_init(args->trans, args->trans->t_dfops);
>  			error = xfs_attr3_leaf_to_shortform(bp, args, forkoff);
>  			/* bp is gone due to xfs_da_shrink_inode */
>  			if (error)
> @@ -741,7 +739,6 @@ xfs_attr_leaf_removename(
>  	 * If the result is small enough, shrink it all into the inode.
>  	 */
>  	if ((forkoff = xfs_attr_shortform_allfit(bp, dp))) {
> -		xfs_defer_init(args->trans, args->trans->t_dfops);
>  		error = xfs_attr3_leaf_to_shortform(bp, args, forkoff);
>  		/* bp is gone due to xfs_da_shrink_inode */
>  		if (error)
> @@ -870,7 +867,6 @@ xfs_attr_node_addname(
>  			 */
>  			xfs_da_state_free(state);
>  			state = NULL;
> -			xfs_defer_init(args->trans, args->trans->t_dfops);
>  			error = xfs_attr3_leaf_to_node(args);
>  			if (error)
>  				goto out_defer_cancel;
> @@ -897,7 +893,6 @@ xfs_attr_node_addname(
>  		 * in the index/blkno/rmtblkno/rmtblkcnt fields and
>  		 * in the index2/blkno2/rmtblkno2/rmtblkcnt2 fields.
>  		 */
> -		xfs_defer_init(args->trans, args->trans->t_dfops);
>  		error = xfs_da3_split(state);
>  		if (error)
>  			goto out_defer_cancel;
> @@ -995,7 +990,6 @@ xfs_attr_node_addname(
>  		 * Check to see if the tree needs to be collapsed.
>  		 */
>  		if (retval && (state->path.active > 1)) {
> -			xfs_defer_init(args->trans, args->trans->t_dfops);
>  			error = xfs_da3_join(state);
>  			if (error)
>  				goto out_defer_cancel;
> @@ -1120,7 +1114,6 @@ xfs_attr_node_removename(
>  	 * Check to see if the tree needs to be collapsed.
>  	 */
>  	if (retval && (state->path.active > 1)) {
> -		xfs_defer_init(args->trans, args->trans->t_dfops);
>  		error = xfs_da3_join(state);
>  		if (error)
>  			goto out_defer_cancel;
> @@ -1152,7 +1145,6 @@ xfs_attr_node_removename(
>  			goto out;
>  
>  		if ((forkoff = xfs_attr_shortform_allfit(bp, dp))) {
> -			xfs_defer_init(args->trans, args->trans->t_dfops);
>  			error = xfs_attr3_leaf_to_shortform(bp, args, forkoff);
>  			/* bp is gone due to xfs_da_shrink_inode */
>  			if (error)
> diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_remote.c
> index 829ab20f0cd7..0fbfb740949e 100644
> --- a/fs/xfs/libxfs/xfs_attr_remote.c
> +++ b/fs/xfs/libxfs/xfs_attr_remote.c
> @@ -480,7 +480,6 @@ xfs_attr_rmtval_set(
>  		 * extent and then crash then the block may not contain the
>  		 * correct metadata after log recovery occurs.
>  		 */
> -		xfs_defer_init(args->trans, args->trans->t_dfops);
>  		nmap = 1;
>  		error = xfs_bmapi_write(args->trans, dp, (xfs_fileoff_t)lblkno,
>  				  blkcnt, XFS_BMAPI_ATTRFORK, args->total, &map,
> @@ -522,7 +521,6 @@ xfs_attr_rmtval_set(
>  
>  		ASSERT(blkcnt > 0);
>  
> -		xfs_defer_init(args->trans, args->trans->t_dfops);
>  		nmap = 1;
>  		error = xfs_bmapi_read(dp, (xfs_fileoff_t)lblkno,
>  				       blkcnt, &map, &nmap,
> @@ -625,7 +623,6 @@ xfs_attr_rmtval_remove(
>  	blkcnt = args->rmtblkcnt;
>  	done = 0;
>  	while (!done) {
> -		xfs_defer_init(args->trans, args->trans->t_dfops);
>  		error = xfs_bunmapi(args->trans, args->dp, lblkno, blkcnt,
>  				    XFS_BMAPI_ATTRFORK, 1, &done);
>  		if (error)
> -- 
> 2.17.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
