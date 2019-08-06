Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44534 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728582AbfHFSWP (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 6 Aug 2019 14:22:15 -0400
Date: Tue, 6 Aug 2019 14:22:13 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 18/24] xfs: reduce kswapd blocking on inode locking.
Message-ID: <20190806182213.GF2979@bfoster>
References: <20190801021752.4986-1-david@fromorbit.com>
 <20190801021752.4986-19-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190801021752.4986-19-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org

On Thu, Aug 01, 2019 at 12:17:46PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> When doing async node reclaiming, we grab a batch of inodes that we
> are likely able to reclaim and ignore those that are already
> flushing. However, when we actually go to reclaim them, the first
> thing we do is lock the inode. If we are racing with something
> else reclaiming the inode or flushing it because it is dirty,
> we block on the inode lock. Hence we can still block kswapd here.
> 
> Further, if we flush an inode, we also cluster all the other dirty
> inodes in that cluster into the same IO, flush locking them all.
> However, if the workload is operating on sequential inodes (e.g.
> created by a tarball extraction) most of these inodes will be
> sequntial in the cache and so in the same batch
> we've already grabbed for reclaim scanning.
> 
> As a result, it is common for all the inodes in the batch to be
> dirty and it is common for the first inode flushed to also flush all
> the inodes in the reclaim batch. In which case, they are now all
> going to be flush locked and we do not want to block on them.
> 

Hmm... I think I'm missing something with this description. For dirty
inodes that are flushed in a cluster via reclaim as described, aren't we
already blocking on all of the flush locks by virtue of the synchronous
I/O associated with the flush of the first dirty inode in that
particular cluster?

Brian

> Hence, for async reclaim (SYNC_TRYLOCK) make sure we always use
> trylock semantics and abort reclaim of an inode as quickly as we can
> without blocking kswapd.
> 
> Found via tracing and finding big batches of repeated lock/unlock
> runs on inodes that we just flushed by write clustering during
> reclaim.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_icache.c | 23 ++++++++++++++++++-----
>  1 file changed, 18 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> index 2fa2f8dcf86b..e6b9030875b9 100644
> --- a/fs/xfs/xfs_icache.c
> +++ b/fs/xfs/xfs_icache.c
> @@ -1104,11 +1104,23 @@ xfs_reclaim_inode(
>  
>  restart:
>  	error = 0;
> -	xfs_ilock(ip, XFS_ILOCK_EXCL);
> -	if (!xfs_iflock_nowait(ip)) {
> -		if (!(sync_mode & SYNC_WAIT))
> +	/*
> +	 * Don't try to flush the inode if another inode in this cluster has
> +	 * already flushed it after we did the initial checks in
> +	 * xfs_reclaim_inode_grab().
> +	 */
> +	if (sync_mode & SYNC_TRYLOCK) {
> +		if (!xfs_ilock_nowait(ip, XFS_ILOCK_EXCL))
>  			goto out;
> -		xfs_iflock(ip);
> +		if (!xfs_iflock_nowait(ip))
> +			goto out_unlock;
> +	} else {
> +		xfs_ilock(ip, XFS_ILOCK_EXCL);
> +		if (!xfs_iflock_nowait(ip)) {
> +			if (!(sync_mode & SYNC_WAIT))
> +				goto out_unlock;
> +			xfs_iflock(ip);
> +		}
>  	}
>  
>  	if (XFS_FORCED_SHUTDOWN(ip->i_mount)) {
> @@ -1215,9 +1227,10 @@ xfs_reclaim_inode(
>  
>  out_ifunlock:
>  	xfs_ifunlock(ip);
> +out_unlock:
> +	xfs_iunlock(ip, XFS_ILOCK_EXCL);
>  out:
>  	xfs_iflags_clear(ip, XFS_IRECLAIM);
> -	xfs_iunlock(ip, XFS_ILOCK_EXCL);
>  	/*
>  	 * We could return -EAGAIN here to make reclaim rescan the inode tree in
>  	 * a short while. However, this just burns CPU time scanning the tree
> -- 
> 2.22.0
> 
