Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:39452 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387985AbeIUBvY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 20 Sep 2018 21:51:24 -0400
Date: Thu, 20 Sep 2018 13:06:10 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 4/5] xfs: print dangling delalloc extents
Message-ID: <20180920200610.GM20086@magnolia>
References: <20180920144220.2181-1-hch@lst.de>
 <20180920144220.2181-5-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180920144220.2181-5-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Thu, Sep 20, 2018 at 04:42:19PM +0200, Christoph Hellwig wrote:
> Instead of just asserting that we have no delalloc space dangling
> in an inode that gets freed print the actual offenders for debug
> mode.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_super.c | 32 +++++++++++++++++++++++++++++++-
>  1 file changed, 31 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index 207ee302b1bb..62850b420dc7 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -933,6 +933,31 @@ xfs_fs_alloc_inode(
>  	return NULL;
>  }
>  
> +#ifdef DEBUG
> +static void
> +xfs_check_delalloc(
> +	struct xfs_inode	*ip,
> +	int			whichfork)
> +{
> +	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, whichfork);
> +	struct xfs_bmbt_irec	got;
> +	struct xfs_iext_cursor	icur;
> +
> +	if (!ifp || !xfs_iext_lookup_extent(ip, ifp, 0, &icur, &got))
> +		return;
> +	do {
> +		if (isnullstartblock(got.br_startblock)) {
> +			xfs_warn(ip->i_mount,
> +				"%s fork has delalloc extent at [0x%llx:0x%llx]",
> +				whichfork == XFS_DATA_FORK ? "data" : "cow",
> +				got.br_startoff, got.br_blockcount);
> +		}
> +	} while (xfs_iext_next_extent(ifp, &icur, &got));
> +}
> +#else
> +#define xfs_check_delalloc(ip, whichfork)	do { } while (0)
> +#endif
> +
>  /*
>   * Now that the generic code is guaranteed not to be accessing
>   * the linux inode, we can inactivate and reclaim the inode.
> @@ -951,7 +976,12 @@ xfs_fs_destroy_inode(
>  
>  	xfs_inactive(ip);
>  
> -	ASSERT(XFS_FORCED_SHUTDOWN(ip->i_mount) || ip->i_delayed_blks == 0);
> +	if (!XFS_FORCED_SHUTDOWN(ip->i_mount) && ip->i_delayed_blks) {
> +		xfs_check_delalloc(ip, XFS_DATA_FORK);
> +		xfs_check_delalloc(ip, XFS_COW_FORK);
> +		ASSERT(0);
> +	}
> +
>  	XFS_STATS_INC(ip->i_mount, vn_reclaim);
>  
>  	/*
> -- 
> 2.18.0
> 
