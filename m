Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:51400 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727605AbeHGUMy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 7 Aug 2018 16:12:54 -0400
Date: Tue, 7 Aug 2018 10:57:16 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs: remove dead error handling code in
 xfs_dquot_disk_alloc()
Message-ID: <20180807175716.GE30972@magnolia>
References: <20180807164018.4865-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180807164018.4865-1-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org, Colin Ian King <colin.king@canonical.com>

On Tue, Aug 07, 2018 at 12:40:18PM -0400, Brian Foster wrote:
> Colin Ian King reports that commit 82ff27bc52 ("xfs: automatic dfops
> buffer relogging") leaves around some dead error handling code in
> xfs_dquot_disk_alloc(). This was discovered via Coverity scan.
> 
> Since the associated commit eliminates the act of joining a buffer
> to a dfops, this intermediate error state is no longer possible and
> the error handling code can be removed. Since the caller cancels the
> transaction on error, which cancels the dfops, eliminate the
> unnecessary xfs_defer_cancel() call and error handling labels.
> 
> Fixes: 82ff27bc52 ("xfs: automatic dfops buffer relogging")
> Reported-by: Colin Ian King <colin.king@canonical.com>
> Signed-off-by: Brian Foster <bfoster@redhat.com>

Looks ok, will test...
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_dquot.c | 26 ++++++--------------------
>  1 file changed, 6 insertions(+), 20 deletions(-)
> 
> diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
> index 70a76ac41f01..87e6dd5326d5 100644
> --- a/fs/xfs/xfs_dquot.c
> +++ b/fs/xfs/xfs_dquot.c
> @@ -311,7 +311,7 @@ xfs_dquot_disk_alloc(
>  			XFS_DQUOT_CLUSTER_SIZE_FSB, XFS_BMAPI_METADATA,
>  			XFS_QM_DQALLOC_SPACE_RES(mp), &map, &nmaps);
>  	if (error)
> -		goto error0;
> +		return error;
>  	ASSERT(map.br_blockcount == XFS_DQUOT_CLUSTER_SIZE_FSB);
>  	ASSERT(nmaps == 1);
>  	ASSERT((map.br_startblock != DELAYSTARTBLOCK) &&
> @@ -325,10 +325,8 @@ xfs_dquot_disk_alloc(
>  	/* now we can just get the buffer (there's nothing to read yet) */
>  	bp = xfs_trans_get_buf(tp, mp->m_ddev_targp, dqp->q_blkno,
>  			mp->m_quotainfo->qi_dqchunklen, 0);
> -	if (!bp) {
> -		error = -ENOMEM;
> -		goto error1;
> -	}
> +	if (!bp)
> +		return -ENOMEM;
>  	bp->b_ops = &xfs_dquot_buf_ops;
>  
>  	/*
> @@ -349,10 +347,8 @@ xfs_dquot_disk_alloc(
>  	 * the buffer locked across the _defer_finish call.  We can now do
>  	 * this correctly with xfs_defer_bjoin.
>  	 *
> -	 * Above, we allocated a disk block for the dquot information and
> -	 * used get_buf to initialize the dquot.  If the _defer_bjoin fails,
> -	 * the buffer is still locked to *tpp, so we must _bhold_release and
> -	 * then _trans_brelse the buffer.  If the _defer_finish fails, the old
> +	 * Above, we allocated a disk block for the dquot information and used
> +	 * get_buf to initialize the dquot. If the _defer_finish fails, the old
>  	 * transaction is gone but the new buffer is not joined or held to any
>  	 * transaction, so we must _buf_relse it.
>  	 *
> @@ -362,24 +358,14 @@ xfs_dquot_disk_alloc(
>  	 * manually or by committing the transaction.
>  	 */
>  	xfs_trans_bhold(tp, bp);
> -	if (error) {
> -		xfs_trans_bhold_release(tp, bp);
> -		xfs_trans_brelse(tp, bp);
> -		goto error1;
> -	}
>  	error = xfs_defer_finish(tpp);
>  	tp = *tpp;
>  	if (error) {
>  		xfs_buf_relse(bp);
> -		goto error0;
> +		return error;
>  	}
>  	*bpp = bp;
>  	return 0;
> -
> -error1:
> -	xfs_defer_cancel(tp);
> -error0:
> -	return error;
>  }
>  
>  /*
> -- 
> 2.17.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
