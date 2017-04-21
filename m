Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:20816 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1423254AbdDUV2N (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Apr 2017 17:28:13 -0400
Date: Fri, 21 Apr 2017 14:28:00 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v3 1/2] xfs: fix up quotacheck buffer list error handling
Message-ID: <20170421212800.GM23371@birch.djwong.org>
References: <1492777333-60156-1-git-send-email-bfoster@redhat.com>
 <1492777333-60156-2-git-send-email-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1492777333-60156-2-git-send-email-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Fri, Apr 21, 2017 at 08:22:12AM -0400, Brian Foster wrote:
> The quotacheck error handling of the delwri buffer list assumes the
> resident buffers are locked and doesn't clear the _XBF_DELWRI_Q flag
> on the buffers that are dequeued. This can lead to assert failures
> on buffer release and possibly other locking problems.
> 
> Move this code to a delwri queue cancel helper function to
> encapsulate the logic required to properly release buffers from a
> delwri queue. Update the helper to clear the delwri queue flag and
> call it from quotacheck.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>

I /think/ this one is ok -- it's useful to assert that the buffer is
actually locked before we try to unlock it, and the other parts refactor
existing code.

If we want to be super-pedantic, then yes, delwri_submit consumes the
entire list and we don't need to touch buffer_list if we hit the final
"goto error_return;" in quotacheck.  OTOH I feel like there's not much
harm in the extra list_empty check and should we ever decide that
delwri_submit shouldn't consume the whole list, then we're already
covered.

Regardless, if anyone /does/ want that change, it can be a separate
patch.

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_buf.c | 24 ++++++++++++++++++++++++
>  fs/xfs/xfs_buf.h |  1 +
>  fs/xfs/xfs_qm.c  |  7 +------
>  3 files changed, 26 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index b620872..ba036c1 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -1079,6 +1079,8 @@ void
>  xfs_buf_unlock(
>  	struct xfs_buf		*bp)
>  {
> +	ASSERT(xfs_buf_islocked(bp));
> +
>  	XB_CLEAR_OWNER(bp);
>  	up(&bp->b_sema);
>  
> @@ -1815,6 +1817,28 @@ xfs_alloc_buftarg(
>  }
>  
>  /*
> + * Cancel a delayed write list.
> + *
> + * Remove each buffer from the list, clear the delwri queue flag and drop the
> + * associated buffer reference.
> + */
> +void
> +xfs_buf_delwri_cancel(
> +	struct list_head	*list)
> +{
> +	struct xfs_buf		*bp;
> +
> +	while (!list_empty(list)) {
> +		bp = list_first_entry(list, struct xfs_buf, b_list);
> +
> +		xfs_buf_lock(bp);
> +		bp->b_flags &= ~_XBF_DELWRI_Q;
> +		list_del_init(&bp->b_list);
> +		xfs_buf_relse(bp);
> +	}
> +}
> +
> +/*
>   * Add a buffer to the delayed write list.
>   *
>   * This queues a buffer for writeout if it hasn't already been.  Note that
> diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
> index e1bc1af..8d1d44f 100644
> --- a/fs/xfs/xfs_buf.h
> +++ b/fs/xfs/xfs_buf.h
> @@ -329,6 +329,7 @@ extern void *xfs_buf_offset(struct xfs_buf *, size_t);
>  extern void xfs_buf_stale(struct xfs_buf *bp);
>  
>  /* Delayed Write Buffer Routines */
> +extern void xfs_buf_delwri_cancel(struct list_head *);
>  extern bool xfs_buf_delwri_queue(struct xfs_buf *, struct list_head *);
>  extern int xfs_buf_delwri_submit(struct list_head *);
>  extern int xfs_buf_delwri_submit_nowait(struct list_head *);
> diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
> index b669b12..8b9a9f1 100644
> --- a/fs/xfs/xfs_qm.c
> +++ b/fs/xfs/xfs_qm.c
> @@ -1384,12 +1384,7 @@ xfs_qm_quotacheck(
>  	mp->m_qflags |= flags;
>  
>   error_return:
> -	while (!list_empty(&buffer_list)) {
> -		struct xfs_buf *bp =
> -			list_first_entry(&buffer_list, struct xfs_buf, b_list);
> -		list_del_init(&bp->b_list);
> -		xfs_buf_relse(bp);
> -	}
> +	xfs_buf_delwri_cancel(&buffer_list);
>  
>  	if (error) {
>  		xfs_warn(mp,
> -- 
> 2.7.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
