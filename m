Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:44150 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732562AbeGKQ3p (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 11 Jul 2018 12:29:45 -0400
Date: Wed, 11 Jul 2018 09:24:34 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 4/6] xfs: introduce a new xfs_inode_has_cow_data helper
Message-ID: <20180711162434.GD32415@magnolia>
References: <20180710060528.4071-1-hch@lst.de>
 <20180710060528.4071-5-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180710060528.4071-5-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Tue, Jul 10, 2018 at 08:05:26AM +0200, Christoph Hellwig wrote:
> We have a few places that already check if an inode has actual data in
> the COW fork to avoid work on reflink inodes that do not actually have
> outstanding COW blocks.  There are a few more places that can avoid
> working if doing the same check, so add a documented helper for this
> condition and use it in all places where it makes sense.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks ok, I think.
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_aops.c      |  4 ++--
>  fs/xfs/xfs_bmap_util.c |  2 +-
>  fs/xfs/xfs_icache.c    | 10 ++++------
>  fs/xfs/xfs_inode.c     |  3 +--
>  fs/xfs/xfs_inode.h     |  9 +++++++++
>  fs/xfs/xfs_reflink.c   |  2 +-
>  6 files changed, 18 insertions(+), 12 deletions(-)
> 
> diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
> index f4d3252236c1..814100d27343 100644
> --- a/fs/xfs/xfs_aops.c
> +++ b/fs/xfs/xfs_aops.c
> @@ -338,7 +338,7 @@ xfs_map_blocks(
>  	imap_valid = offset_fsb >= wpc->imap.br_startoff &&
>  		     offset_fsb < wpc->imap.br_startoff + wpc->imap.br_blockcount;
>  	if (imap_valid &&
> -	    (!xfs_is_reflink_inode(ip) || wpc->io_type == XFS_IO_COW))
> +	    (!xfs_inode_has_cow_data(ip) || wpc->io_type == XFS_IO_COW))
>  		return 0;
>  
>  	if (XFS_FORCED_SHUTDOWN(mp))
> @@ -363,7 +363,7 @@ xfs_map_blocks(
>  	 * Check if this is offset is covered by a COW extents, and if yes use
>  	 * it directly instead of looking up anything in the data fork.
>  	 */
> -	if (xfs_is_reflink_inode(ip) &&
> +	if (xfs_inode_has_cow_data(ip) &&
>  	    xfs_iext_lookup_extent(ip, ip->i_cowfp, offset_fsb, &icur, &imap) &&
>  	    imap.br_startoff <= offset_fsb) {
>  		xfs_iunlock(ip, XFS_ILOCK_SHARED);
> diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> index da561882c349..d78f8300607f 100644
> --- a/fs/xfs/xfs_bmap_util.c
> +++ b/fs/xfs/xfs_bmap_util.c
> @@ -1280,7 +1280,7 @@ xfs_prepare_shift(
>  	 * we've flushed all the dirty data out to disk to avoid having
>  	 * CoW extents at the wrong offsets.
>  	 */
> -	if (xfs_is_reflink_inode(ip)) {
> +	if (xfs_inode_has_cow_data(ip)) {
>  		error = xfs_reflink_cancel_cow_range(ip, offset, NULLFILEOFF,
>  				true);
>  		if (error)
> diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> index 79f344fa8b14..fdae4c2d461e 100644
> --- a/fs/xfs/xfs_icache.c
> +++ b/fs/xfs/xfs_icache.c
> @@ -1697,14 +1697,13 @@ xfs_inode_clear_eofblocks_tag(
>   */
>  static bool
>  xfs_prep_free_cowblocks(
> -	struct xfs_inode	*ip,
> -	struct xfs_ifork	*ifp)
> +	struct xfs_inode	*ip)
>  {
>  	/*
>  	 * Just clear the tag if we have an empty cow fork or none at all. It's
>  	 * possible the inode was fully unshared since it was originally tagged.
>  	 */
> -	if (!xfs_is_reflink_inode(ip) || !ifp->if_bytes) {
> +	if (!xfs_inode_has_cow_data(ip)) {
>  		trace_xfs_inode_free_cowblocks_invalid(ip);
>  		xfs_inode_clear_cowblocks_tag(ip);
>  		return false;
> @@ -1742,11 +1741,10 @@ xfs_inode_free_cowblocks(
>  	void			*args)
>  {
>  	struct xfs_eofblocks	*eofb = args;
> -	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, XFS_COW_FORK);
>  	int			match;
>  	int			ret = 0;
>  
> -	if (!xfs_prep_free_cowblocks(ip, ifp))
> +	if (!xfs_prep_free_cowblocks(ip))
>  		return 0;
>  
>  	if (eofb) {
> @@ -1771,7 +1769,7 @@ xfs_inode_free_cowblocks(
>  	 * Check again, nobody else should be able to dirty blocks or change
>  	 * the reflink iflag now that we have the first two locks held.
>  	 */
> -	if (xfs_prep_free_cowblocks(ip, ifp))
> +	if (xfs_prep_free_cowblocks(ip))
>  		ret = xfs_reflink_cancel_cow_range(ip, 0, NULLFILEOFF, false);
>  
>  	xfs_iunlock(ip, XFS_MMAPLOCK_EXCL);
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index b6da446ae946..2036e49f7e15 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -1868,7 +1868,6 @@ xfs_inactive(
>  	xfs_inode_t	*ip)
>  {
>  	struct xfs_mount	*mp;
> -	struct xfs_ifork	*cow_ifp = XFS_IFORK_PTR(ip, XFS_COW_FORK);
>  	int			error;
>  	int			truncate = 0;
>  
> @@ -1889,7 +1888,7 @@ xfs_inactive(
>  		return;
>  
>  	/* Try to clean out the cow blocks if there are any. */
> -	if (xfs_is_reflink_inode(ip) && cow_ifp->if_bytes > 0)
> +	if (xfs_inode_has_cow_data(ip))
>  		xfs_reflink_cancel_cow_range(ip, 0, NULLFILEOFF, true);
>  
>  	if (VFS_I(ip)->i_nlink != 0) {
> diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
> index 1f910d2ae73a..82d27a295336 100644
> --- a/fs/xfs/xfs_inode.h
> +++ b/fs/xfs/xfs_inode.h
> @@ -198,6 +198,15 @@ static inline bool xfs_is_reflink_inode(struct xfs_inode *ip)
>  	return ip->i_d.di_flags2 & XFS_DIFLAG2_REFLINK;
>  }
>  
> +/*
> + * Check if an inode has any data in the COW fork.  This might be often false
> + * even for inodes with the reflink flag when there is no pending COW operation.
> + */
> +static inline bool xfs_inode_has_cow_data(struct xfs_inode *ip)
> +{
> +	return ip->i_cowfp && ip->i_cowfp->if_bytes;
> +}
> +
>  /*
>   * In-core inode flags.
>   */
> diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
> index 49e4913fa779..789310c547e6 100644
> --- a/fs/xfs/xfs_reflink.c
> +++ b/fs/xfs/xfs_reflink.c
> @@ -494,7 +494,7 @@ xfs_reflink_cancel_cow_blocks(
>  	struct xfs_defer_ops		dfops;
>  	int				error = 0;
>  
> -	if (!xfs_is_reflink_inode(ip))
> +	if (!xfs_inode_has_cow_data(ip))
>  		return 0;
>  	if (!xfs_iext_lookup_extent_before(ip, ifp, &end_fsb, &icur, &got))
>  		return 0;
> -- 
> 2.18.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
