Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:12345 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750866AbeEDLcE (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 4 May 2018 07:32:04 -0400
Date: Fri, 4 May 2018 07:32:02 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 0.2/13] xfs: don't spray logs when dquot flush/purge fail
Message-ID: <20180504113201.GB26217@bfoster.bfoster>
References: <152506698177.21553.13500862866416804148.stgit@magnolia>
 <20180503175409.GG4127@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180503175409.GG4127@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org, hch@lst.de

On Thu, May 03, 2018 at 10:54:09AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> When dquot flush or purge fail there's no need to spam the logs, we've
> already logged the IO error or fs shutdown that caused the flush
> failures.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_dquot_item.c |    5 +----
>  fs/xfs/xfs_qm.c         |   10 ++--------
>  2 files changed, 3 insertions(+), 12 deletions(-)
> 
> diff --git a/fs/xfs/xfs_dquot_item.c b/fs/xfs/xfs_dquot_item.c
> index 4b331e354da7..d632ba403527 100644
> --- a/fs/xfs/xfs_dquot_item.c
> +++ b/fs/xfs/xfs_dquot_item.c
> @@ -209,10 +209,7 @@ xfs_qm_dquot_logitem_push(
>  	spin_unlock(&lip->li_ailp->ail_lock);
>  
>  	error = xfs_qm_dqflush(dqp, &bp);
> -	if (error) {
> -		xfs_warn(dqp->q_mount, "%s: push error %d on dqp "PTR_FMT,
> -			__func__, error, dqp);
> -	} else {
> +	if (!error) {
>  		if (!xfs_buf_delwri_queue(bp, buffer_list))
>  			rval = XFS_ITEM_FLUSHING;
>  		xfs_buf_relse(bp);
> diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
> index ec39ae274c78..579de656bc25 100644
> --- a/fs/xfs/xfs_qm.c
> +++ b/fs/xfs/xfs_qm.c
> @@ -161,10 +161,7 @@ xfs_qm_dqpurge(
>  		 * to purge this dquot anyway, so we go ahead regardless.
>  		 */
>  		error = xfs_qm_dqflush(dqp, &bp);
> -		if (error) {
> -			xfs_warn(mp, "%s: dquot "PTR_FMT" flush failed",
> -				__func__, dqp);
> -		} else {
> +		if (!error) {
>  			error = xfs_bwrite(bp);
>  			xfs_buf_relse(bp);
>  		}
> @@ -479,11 +476,8 @@ xfs_qm_dquot_isolate(
>  		spin_unlock(lru_lock);
>  
>  		error = xfs_qm_dqflush(dqp, &bp);
> -		if (error) {
> -			xfs_warn(dqp->q_mount, "%s: dquot "PTR_FMT" flush failed",
> -				 __func__, dqp);
> +		if (error)
>  			goto out_unlock_dirty;
> -		}
>  
>  		xfs_buf_delwri_queue(bp, &isol->buffers);
>  		xfs_buf_relse(bp);
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
