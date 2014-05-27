Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 2A4D129DFA
	for <xfs@oss.sgi.com>; Tue, 27 May 2014 11:01:18 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id EE5D3304059
	for <xfs@oss.sgi.com>; Tue, 27 May 2014 09:01:17 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id XTHUbGUXBVeOcvGA for
	<xfs@oss.sgi.com>; Tue, 27 May 2014 09:01:17 -0700 (PDT)
Date: Tue, 27 May 2014 12:01:13 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 15/16] xfs: pass xfs_da_args to xfs_attr_leaf_newentsize
Message-ID: <20140527160113.GG11265@laptop.bfoster>
References: <1400803432-20048-1-git-send-email-david@fromorbit.com>
	<1400803432-20048-16-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1400803432-20048-16-git-send-email-david@fromorbit.com>
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

On Fri, May 23, 2014 at 10:03:51AM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> As it's only ever called from contexts where the xfs_da_args is
> present and contains all the information needed inside the args
> structure.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_attr.c      |  4 +---
>  fs/xfs/xfs_attr_leaf.c | 47 +++++++++++++++++------------------------------
>  fs/xfs/xfs_attr_leaf.h |  3 +--
>  3 files changed, 19 insertions(+), 35 deletions(-)
> 
> diff --git a/fs/xfs/xfs_attr.c b/fs/xfs/xfs_attr.c
> index ccfc2c9..3d8c03e 100644
> --- a/fs/xfs/xfs_attr.c
> +++ b/fs/xfs/xfs_attr.c
> @@ -174,9 +174,7 @@ xfs_attr_calc_size(
>  	 * Determine space new attribute will use, and if it would be
>  	 * "local" or "remote" (note: local != inline).
>  	 */
> -	size = xfs_attr_leaf_newentsize(args->namelen, args->valuelen,
> -					args->geo->blksize, local);
> -
> +	size = xfs_attr_leaf_newentsize(args, local);
>  	nblks = XFS_DAENTER_SPACE_RES(mp, XFS_ATTR_FORK);
>  	if (*local) {
>  		if (size > (args->geo->blksize / 2)) {
> diff --git a/fs/xfs/xfs_attr_leaf.c b/fs/xfs/xfs_attr_leaf.c
> index 88cd84a..7761103 100644
> --- a/fs/xfs/xfs_attr_leaf.c
> +++ b/fs/xfs/xfs_attr_leaf.c
> @@ -1076,8 +1076,7 @@ xfs_attr3_leaf_add(
>  	leaf = bp->b_addr;
>  	xfs_attr3_leaf_hdr_from_disk(&ichdr, leaf);
>  	ASSERT(args->index >= 0 && args->index <= ichdr.count);
> -	entsize = xfs_attr_leaf_newentsize(args->namelen, args->valuelen,
> -			   args->geo->blksize, NULL);
> +	entsize = xfs_attr_leaf_newentsize(args, NULL);
>  
>  	/*
>  	 * Search through freemap for first-fit on new name length.
> @@ -1179,14 +1178,11 @@ xfs_attr3_leaf_add_work(
>  	ASSERT(ichdr->freemap[mapindex].base < XFS_LBSIZE(mp));
>  	ASSERT((ichdr->freemap[mapindex].base & 0x3) == 0);
>  	ASSERT(ichdr->freemap[mapindex].size >=
> -		xfs_attr_leaf_newentsize(args->namelen, args->valuelen,
> -					 args->geo->blksize, NULL));
> +		xfs_attr_leaf_newentsize(args, NULL));
>  	ASSERT(ichdr->freemap[mapindex].size < XFS_LBSIZE(mp));
>  	ASSERT((ichdr->freemap[mapindex].size & 0x3) == 0);
>  
> -	ichdr->freemap[mapindex].size -=
> -			xfs_attr_leaf_newentsize(args->namelen, args->valuelen,
> -						 args->geo->blksize, &tmp);
> +	ichdr->freemap[mapindex].size -= xfs_attr_leaf_newentsize(args, &tmp);
>  
>  	entry->nameidx = cpu_to_be16(ichdr->freemap[mapindex].base +
>  				     ichdr->freemap[mapindex].size);
> @@ -1594,9 +1590,7 @@ xfs_attr3_leaf_figure_balance(
>  	max = ichdr1->count + ichdr2->count;
>  	half = (max + 1) * sizeof(*entry);
>  	half += ichdr1->usedbytes + ichdr2->usedbytes +
> -			xfs_attr_leaf_newentsize(state->args->namelen,
> -						 state->args->valuelen,
> -						 state->blocksize, NULL);
> +			xfs_attr_leaf_newentsize(state->args, NULL);
>  	half /= 2;
>  	lastdelta = state->blocksize;
>  	entry = xfs_attr3_leaf_entryp(leaf1);
> @@ -1608,10 +1602,7 @@ xfs_attr3_leaf_figure_balance(
>  		 */
>  		if (count == blk1->index) {
>  			tmp = totallen + sizeof(*entry) +
> -				xfs_attr_leaf_newentsize(
> -						state->args->namelen,
> -						state->args->valuelen,
> -						state->blocksize, NULL);
> +				xfs_attr_leaf_newentsize(state->args, NULL);
>  			if (XFS_ATTR_ABS(half - tmp) > lastdelta)
>  				break;
>  			lastdelta = XFS_ATTR_ABS(half - tmp);
> @@ -1647,10 +1638,7 @@ xfs_attr3_leaf_figure_balance(
>  	totallen -= count * sizeof(*entry);
>  	if (foundit) {
>  		totallen -= sizeof(*entry) +
> -				xfs_attr_leaf_newentsize(
> -						state->args->namelen,
> -						state->args->valuelen,
> -						state->blocksize, NULL);
> +				xfs_attr_leaf_newentsize(state->args, NULL);
>  	}
>  
>  	*countarg = count;
> @@ -2441,22 +2429,21 @@ xfs_attr_leaf_entsize(xfs_attr_leafblock_t *leaf, int index)
>   * a "local" or a "remote" attribute.
>   */
>  int
> -xfs_attr_leaf_newentsize(int namelen, int valuelen, int blocksize, int *local)
> +xfs_attr_leaf_newentsize(
> +	struct xfs_da_args	*args,
> +	int			*local)
>  {
> -	int size;
> +	int			size;
>  
> -	size = xfs_attr_leaf_entsize_local(namelen, valuelen);
> -	if (size < xfs_attr_leaf_entsize_local_max(blocksize)) {
> -		if (local) {
> +	size = xfs_attr_leaf_entsize_local(args->namelen, args->valuelen);
> +	if (size < xfs_attr_leaf_entsize_local_max(args->geo->blksize)) {
> +		if (local)
>  			*local = 1;
> -		}
> -	} else {
> -		size = xfs_attr_leaf_entsize_remote(namelen);
> -		if (local) {
> -			*local = 0;
> -		}
> +		return size;
>  	}
> -	return size;
> +	if (local)
> +		*local = 0;
> +	return xfs_attr_leaf_entsize_remote(args->namelen);
>  }
>  
>  
> diff --git a/fs/xfs/xfs_attr_leaf.h b/fs/xfs/xfs_attr_leaf.h
> index 3ec5ec0..e2929da 100644
> --- a/fs/xfs/xfs_attr_leaf.h
> +++ b/fs/xfs/xfs_attr_leaf.h
> @@ -96,8 +96,7 @@ int	xfs_attr3_root_inactive(struct xfs_trans **trans, struct xfs_inode *dp);
>  xfs_dahash_t	xfs_attr_leaf_lasthash(struct xfs_buf *bp, int *count);
>  int	xfs_attr_leaf_order(struct xfs_buf *leaf1_bp,
>  				   struct xfs_buf *leaf2_bp);
> -int	xfs_attr_leaf_newentsize(int namelen, int valuelen, int blocksize,
> -					int *local);
> +int	xfs_attr_leaf_newentsize(struct xfs_da_args *args, int *local);
>  int	xfs_attr3_leaf_read(struct xfs_trans *tp, struct xfs_inode *dp,
>  			xfs_dablk_t bno, xfs_daddr_t mappedbno,
>  			struct xfs_buf **bpp);
> -- 
> 1.9.0
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
