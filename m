Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:58462 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729548AbeGMXHT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 13 Jul 2018 19:07:19 -0400
Date: Fri, 13 Jul 2018 15:50:33 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 5/6] xfs: maintain a sequence count for inode fork
 manipulations
Message-ID: <20180713225033.GO32415@magnolia>
References: <20180712134910.30298-1-hch@lst.de>
 <20180712134910.30298-6-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180712134910.30298-6-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Thu, Jul 12, 2018 at 03:49:09PM +0200, Christoph Hellwig wrote:
> Add a simple 32-bit unsigned integer as the sequence count for
> modifications to the extent list in the inode fork.  This will be
> used to optimize away extent list lookups in the writeback code.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/libxfs/xfs_iext_tree.c  | 4 ++++
>  fs/xfs/libxfs/xfs_inode_fork.h | 1 +
>  2 files changed, 5 insertions(+)
> 
> diff --git a/fs/xfs/libxfs/xfs_iext_tree.c b/fs/xfs/libxfs/xfs_iext_tree.c
> index b80c63faace2..cce7e8024f46 100644
> --- a/fs/xfs/libxfs/xfs_iext_tree.c
> +++ b/fs/xfs/libxfs/xfs_iext_tree.c
> @@ -650,6 +650,7 @@ xfs_iext_insert(
>  		cur->leaf->recs[i] = cur->leaf->recs[i - 1];
>  	xfs_iext_set(cur_rec(cur), irec);
>  	ifp->if_bytes += sizeof(struct xfs_iext_rec);
> +	ifp->if_seq++;
>  
>  	trace_xfs_iext_insert(ip, cur, state, _RET_IP_);
>  
> @@ -869,6 +870,7 @@ xfs_iext_remove(
>  		leaf->recs[i] = leaf->recs[i + 1];
>  	xfs_iext_rec_clear(&leaf->recs[nr_entries]);
>  	ifp->if_bytes -= sizeof(struct xfs_iext_rec);
> +	ifp->if_seq++;
>  
>  	if (cur->pos == 0 && nr_entries > 0) {
>  		xfs_iext_update_node(ifp, offset, xfs_iext_leaf_key(leaf, 0), 1,
> @@ -983,6 +985,8 @@ xfs_iext_update_extent(
>  	trace_xfs_bmap_pre_update(ip, cur, state, _RET_IP_);
>  	xfs_iext_set(cur_rec(cur), new);
>  	trace_xfs_bmap_post_update(ip, cur, state, _RET_IP_);
> +
> +	ifp->if_seq++;
>  }
>  
>  /*
> diff --git a/fs/xfs/libxfs/xfs_inode_fork.h b/fs/xfs/libxfs/xfs_inode_fork.h
> index 1492143371f3..f20b2468ca35 100644
> --- a/fs/xfs/libxfs/xfs_inode_fork.h
> +++ b/fs/xfs/libxfs/xfs_inode_fork.h
> @@ -14,6 +14,7 @@ struct xfs_dinode;
>   */
>  struct xfs_ifork {
>  	int			if_bytes;	/* bytes in if_u1 */
> +	unsigned int		if_seq;
>  	struct xfs_btree_block	*if_broot;	/* file's incore btree root */
>  	short			if_broot_bytes;	/* bytes allocated for root */
>  	unsigned char		if_flags;	/* per-fork flags */
> -- 
> 2.18.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
