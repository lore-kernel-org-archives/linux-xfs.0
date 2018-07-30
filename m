Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:48240 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727019AbeG3VwT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 30 Jul 2018 17:52:19 -0400
Date: Mon, 30 Jul 2018 13:15:35 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 06/15] xfs: add missing defer ijoins for held inodes
Message-ID: <20180730201535.GG30972@magnolia>
References: <20180730164520.36882-1-bfoster@redhat.com>
 <20180730164520.36882-7-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180730164520.36882-7-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Mon, Jul 30, 2018 at 12:45:11PM -0400, Brian Foster wrote:
> Log items that require relogging during deferred operations
> processing are explicitly joined to the associated dfops via the
> xfs_defer_*join() helpers. These calls imply that the associated
> object is "held" by the transaction such that when rolled, the item
> can be immediately joined to a follow up transaction. For buffers,
> this means the buffer remains locked and held after each roll. For
> inodes, this means that the inode remains locked.
> 
> Failure to join a held item to the dfops structure means the
> associated object pins the tail of the log while dfops processing
> completes, because the item never relogs and is not unlocked or
> released until deferred processing completes.
> 
> Currently, all buffers that are held in transactions (XFS_BLI_HOLD)
> with deferred operations are explicitly joined to the dfops. This is
> not the case for inodes, however, as various contexts defer
> operations to transactions with held inodes without explicit joins
> to the associated dfops (and thus not relogging).
> 
> While this is not a catastrophic problem, it is not ideal. Given
> that we want to eventually relog such items automatically during
> dfops processing, start by explicitly adding these missing
> xfs_defer_ijoin() calls. A call is added everywhere an inode is
> joined to a transaction without transferring lock ownership and
> said transaction runs deferred operations.
> 
> All xfs_defer_ijoin() calls will eventually be replaced by automatic
> dfops inode relogging. This patch essentially implements the
> behavior change that would otherwise occur due to automatic inode
> dfops relogging.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>

Looks ok, though I admit I'm a little skeptical of adding the calls only
to replace them with automatic ijoining two patches later... :)

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/libxfs/xfs_bmap.c | 1 +
>  fs/xfs/xfs_bmap_util.c   | 1 +
>  fs/xfs/xfs_inode.c       | 1 +
>  fs/xfs/xfs_iomap.c       | 3 +++
>  fs/xfs/xfs_reflink.c     | 1 +
>  5 files changed, 7 insertions(+)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 8edf7522aaff..71687d805f79 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -1119,6 +1119,7 @@ xfs_bmap_add_attrfork(
>  			xfs_log_sb(tp);
>  	}
>  
> +	xfs_defer_ijoin(tp->t_dfops, ip);
>  	error = xfs_trans_commit(tp);
>  	xfs_iunlock(ip, XFS_ILOCK_EXCL);
>  	return error;
> diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> index 412dc58ae54d..0c58a66b39e5 100644
> --- a/fs/xfs/xfs_bmap_util.c
> +++ b/fs/xfs/xfs_bmap_util.c
> @@ -979,6 +979,7 @@ xfs_alloc_file_space(
>  		/*
>  		 * Complete the transaction
>  		 */
> +		xfs_defer_ijoin(tp->t_dfops, ip);
>  		error = xfs_trans_commit(tp);
>  		xfs_iunlock(ip, XFS_ILOCK_EXCL);
>  		if (error)
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 5fc1815c2b62..441c8593cfd7 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -1810,6 +1810,7 @@ xfs_inactive_ifree(
>  	 * Just ignore errors at this point.  There is nothing we can do except
>  	 * to try to keep going. Make sure it's not a silent error.
>  	 */
> +	xfs_defer_ijoin(tp->t_dfops, ip);
>  	error = xfs_trans_commit(tp);
>  	if (error)
>  		xfs_notice(mp, "%s: xfs_trans_commit returned error %d",
> diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
> index 8e8ca9f03f0e..464b4b3225bb 100644
> --- a/fs/xfs/xfs_iomap.c
> +++ b/fs/xfs/xfs_iomap.c
> @@ -261,6 +261,7 @@ xfs_iomap_write_direct(
>  	/*
>  	 * Complete the transaction
>  	 */
> +	xfs_defer_ijoin(tp->t_dfops, ip);
>  	error = xfs_trans_commit(tp);
>  	if (error)
>  		goto out_unlock;
> @@ -762,6 +763,7 @@ xfs_iomap_write_allocate(
>  			if (error)
>  				goto trans_cancel;
>  
> +			xfs_defer_ijoin(tp->t_dfops, ip);
>  			error = xfs_trans_commit(tp);
>  			if (error)
>  				goto error0;
> @@ -879,6 +881,7 @@ xfs_iomap_write_unwritten(
>  			xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
>  		}
>  
> +		xfs_defer_ijoin(tp->t_dfops, ip);
>  		error = xfs_trans_commit(tp);
>  		xfs_iunlock(ip, XFS_ILOCK_EXCL);
>  		if (error)
> diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
> index 9a0a56526266..e986fcf928e5 100644
> --- a/fs/xfs/xfs_reflink.c
> +++ b/fs/xfs/xfs_reflink.c
> @@ -435,6 +435,7 @@ xfs_reflink_allocate_cow(
>  	xfs_inode_set_cowblocks_tag(ip);
>  
>  	/* Finish up. */
> +	xfs_defer_ijoin(tp->t_dfops, ip);
>  	error = xfs_trans_commit(tp);
>  	if (error)
>  		return error;
> -- 
> 2.17.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
