Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:51828 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389828AbeHGUOg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 7 Aug 2018 16:14:36 -0400
Date: Tue, 7 Aug 2018 10:59:02 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs: use WRITE_ONCE to update if_seq
Message-ID: <20180807175902.GF30972@magnolia>
References: <20180807120937.26597-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180807120937.26597-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Tue, Aug 07, 2018 at 02:09:37PM +0200, Christoph Hellwig wrote:
> This adds ordering of the updates and makes sure we always see the if_seq
> update before the extent tree is modified.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks reasonable enough...
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/libxfs/xfs_iext_tree.c | 20 +++++++++++++++++---
>  fs/xfs/xfs_aops.c             |  4 ++--
>  fs/xfs/xfs_iomap.c            |  3 ++-
>  3 files changed, 21 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_iext_tree.c b/fs/xfs/libxfs/xfs_iext_tree.c
> index 8a7aea041ee1..771dd072015d 100644
> --- a/fs/xfs/libxfs/xfs_iext_tree.c
> +++ b/fs/xfs/libxfs/xfs_iext_tree.c
> @@ -14,6 +14,7 @@
>  #include "xfs_inode_fork.h"
>  #include "xfs_trans_resv.h"
>  #include "xfs_mount.h"
> +#include "xfs_bmap.h"
>  #include "xfs_trace.h"
>  
>  /*
> @@ -612,6 +613,19 @@ xfs_iext_realloc_root(
>  	cur->leaf = new;
>  }
>  
> +/*
> + * Increment the sequence counter if we are on a COW fork.  This allows
> + * the writeback code to skip looking for a COW extent if the COW fork
> + * hasn't changed.  We use WRITE_ONCE here to ensure the update to the
> + * sequence counter is seen before the modifications to the extent
> + * tree itself take effect.
> + */
> +static inline void xfs_iext_inc_seq(struct xfs_ifork *ifp, int state)
> +{
> +	if (state & BMAP_COWFORK)
> +		WRITE_ONCE(ifp->if_seq, READ_ONCE(ifp->if_seq) + 1);
> +}
> +
>  void
>  xfs_iext_insert(
>  	struct xfs_inode	*ip,
> @@ -624,7 +638,7 @@ xfs_iext_insert(
>  	struct xfs_iext_leaf	*new = NULL;
>  	int			nr_entries, i;
>  
> -	ifp->if_seq++;
> +	xfs_iext_inc_seq(ifp, state);
>  
>  	if (ifp->if_height == 0)
>  		xfs_iext_alloc_root(ifp, cur);
> @@ -866,7 +880,7 @@ xfs_iext_remove(
>  	ASSERT(ifp->if_u1.if_root != NULL);
>  	ASSERT(xfs_iext_valid(ifp, cur));
>  
> -	ifp->if_seq++;
> +	xfs_iext_inc_seq(ifp, state);
>  
>  	nr_entries = xfs_iext_leaf_nr_entries(ifp, leaf, cur->pos) - 1;
>  	for (i = cur->pos; i < nr_entries; i++)
> @@ -974,7 +988,7 @@ xfs_iext_update_extent(
>  {
>  	struct xfs_ifork	*ifp = xfs_iext_state_to_fork(ip, state);
>  
> -	ifp->if_seq++;
> +	xfs_iext_inc_seq(ifp, state);
>  
>  	if (cur->pos == 0) {
>  		struct xfs_bmbt_irec	old;
> diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
> index 235b4ddcd324..49f5f5896a43 100644
> --- a/fs/xfs/xfs_aops.c
> +++ b/fs/xfs/xfs_aops.c
> @@ -351,7 +351,7 @@ xfs_map_blocks(
>  	if (imap_valid &&
>  	    (!xfs_inode_has_cow_data(ip) ||
>  	     wpc->io_type == XFS_IO_COW ||
> -	     wpc->cow_seq == ip->i_cowfp->if_seq))
> +	     wpc->cow_seq == READ_ONCE(ip->i_cowfp->if_seq)))
>  		return 0;
>  
>  	if (XFS_FORCED_SHUTDOWN(mp))
> @@ -380,7 +380,7 @@ xfs_map_blocks(
>  	    xfs_iext_lookup_extent(ip, ip->i_cowfp, offset_fsb, &icur, &imap))
>  		cow_fsb = imap.br_startoff;
>  	if (cow_fsb != NULLFILEOFF && cow_fsb <= offset_fsb) {
> -		wpc->cow_seq = ip->i_cowfp->if_seq;
> +		wpc->cow_seq = READ_ONCE(ip->i_cowfp->if_seq);
>  		xfs_iunlock(ip, XFS_ILOCK_SHARED);
>  		/*
>  		 * Truncate can race with writeback since writeback doesn't
> diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
> index 3282575e2df4..6320aca39f39 100644
> --- a/fs/xfs/xfs_iomap.c
> +++ b/fs/xfs/xfs_iomap.c
> @@ -655,6 +655,7 @@ xfs_iomap_write_allocate(
>  	unsigned int	*cow_seq)
>  {
>  	xfs_mount_t	*mp = ip->i_mount;
> +	struct xfs_ifork *ifp = XFS_IFORK_PTR(ip, whichfork);
>  	xfs_fileoff_t	offset_fsb, last_block;
>  	xfs_fileoff_t	end_fsb, map_start_fsb;
>  	xfs_filblks_t	count_fsb;
> @@ -768,7 +769,7 @@ xfs_iomap_write_allocate(
>  				goto error0;
>  
>  			if (whichfork == XFS_COW_FORK)
> -				*cow_seq = XFS_IFORK_PTR(ip, whichfork)->if_seq;
> +				*cow_seq = READ_ONCE(ifp->if_seq);
>  			xfs_iunlock(ip, XFS_ILOCK_EXCL);
>  		}
>  
> -- 
> 2.18.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
