Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:50328 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754402AbeDJPSj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 10 Apr 2018 11:18:39 -0400
Date: Tue, 10 Apr 2018 08:18:34 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] Force log to disk before reading the AGF during a fstrim
Message-ID: <20180410151834.GT7500@magnolia>
References: <20180410150814.22610-1-cmaiolino@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180410150814.22610-1-cmaiolino@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Carlos Maiolino <cmaiolino@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Apr 10, 2018 at 05:08:14PM +0200, Carlos Maiolino wrote:
> Forcing the log to disk after reading the agf is wrong, we might be
> calling xfs_log_force with XFS_LOG_SYNC with a metadata lock held.
> 
> This can cause a deadlock when racing a fstrim with a filesystem
> shutdown.
> 
> The deadlock has been identified due a miscalculation bug in device-mapper
> dm-thin, which returns lack of space to its users earlier than the device itself
> really runs out of space, changing the device-mapper volume into an error state.
> 
> The problem happened while filling the filesystem with a single file,
> triggering the bug in device-mapper, consequently causing an IO error
> and shutting down the filesystem.
> 
> If such file is removed, and fstrim executed before the XFS finishes the
> shut down process, the fstrim process will end up holding the buffer
> lock, and going to sleep on the cil wait queue.
> 
> At this point, the shut down process will try to wake up all the threads
> waiting on the cil wait queue, but for this, it will try to hold the
> same buffer log already held my the fstrim, locking up the filesystem.
> 
> Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> ---
> Kudos to Dave who spotted it just after me telling him the process was
> deadlocked on a buffer lock

Uh... got an xfstest to reproduce this? :)

Code looks reasonable,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D


>  fs/xfs/xfs_discard.c | 14 +++++++-------
>  1 file changed, 7 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/xfs/xfs_discard.c b/fs/xfs/xfs_discard.c
> index b2cde5426182..7b68e6c9a474 100644
> --- a/fs/xfs/xfs_discard.c
> +++ b/fs/xfs/xfs_discard.c
> @@ -50,19 +50,19 @@ xfs_trim_extents(
>  
>  	pag = xfs_perag_get(mp, agno);
>  
> -	error = xfs_alloc_read_agf(mp, NULL, agno, 0, &agbp);
> -	if (error || !agbp)
> -		goto out_put_perag;
> -
> -	cur = xfs_allocbt_init_cursor(mp, NULL, agbp, agno, XFS_BTNUM_CNT);
> -
>  	/*
>  	 * Force out the log.  This means any transactions that might have freed
> -	 * space before we took the AGF buffer lock are now on disk, and the
> +	 * space before we take the AGF buffer lock are now on disk, and the
>  	 * volatile disk cache is flushed.
>  	 */
>  	xfs_log_force(mp, XFS_LOG_SYNC);
>  
> +	error = xfs_alloc_read_agf(mp, NULL, agno, 0, &agbp);
> +	if (error || !agbp)
> +		goto out_put_perag;
> +
> +	cur = xfs_allocbt_init_cursor(mp, NULL, agbp, agno, XFS_BTNUM_CNT);
> +
>  	/*
>  	 * Look up the longest btree in the AGF and start with it.
>  	 */
> -- 
> 2.14.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
