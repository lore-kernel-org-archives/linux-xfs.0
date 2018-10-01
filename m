Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34502 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729182AbeJAVFP (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 1 Oct 2018 17:05:15 -0400
Date: Mon, 1 Oct 2018 10:27:08 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 7/7] xfs: print dangling delalloc extents
Message-ID: <20181001142708.GI53694@bfoster>
References: <20181001123741.32005-1-hch@lst.de>
 <20181001123741.32005-8-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181001123741.32005-8-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Mon, Oct 01, 2018 at 05:37:41AM -0700, Christoph Hellwig wrote:
> Instead of just asserting that we have no delalloc space dangling
> in an inode that gets freed print the actual offenders for debug
> mode.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

Thanks for the tweak:

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_super.c | 33 ++++++++++++++++++++++++++++++++-
>  1 file changed, 32 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index 207ee302b1bb..99250bcb65a7 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -933,6 +933,32 @@ xfs_fs_alloc_inode(
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
> +	"ino %llx %s fork has delalloc extent at [0x%llx:0x%llx]",
> +				ip->i_ino,
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
> @@ -951,7 +977,12 @@ xfs_fs_destroy_inode(
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
> 2.19.0
> 
