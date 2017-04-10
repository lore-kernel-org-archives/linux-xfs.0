Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:38820 "EHLO
        ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751588AbdDJETO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 10 Apr 2017 00:19:14 -0400
Date: Mon, 10 Apr 2017 14:18:41 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/3] xfs: fix up quotacheck buffer list error handling
Message-ID: <20170410041841.GH23007@dastard>
References: <1487966001-63263-1-git-send-email-bfoster@redhat.com>
 <1487966001-63263-2-git-send-email-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1487966001-63263-2-git-send-email-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org, Martin Svec <martin.svec@zoner.cz>

On Fri, Feb 24, 2017 at 02:53:19PM -0500, Brian Foster wrote:
> The quotacheck error handling of the delwri buffer list assumes the
> resident buffers are locked and doesn't clear the _XBF_DELWRI_Q flag
> on the buffers that are dequeued. This can lead to assert failures
> on buffer release and possibly other locking problems.
> 
> Update the error handling code to lock each buffer as it is removed
> from the buffer list and clear the delwri queue flag.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> ---
>  fs/xfs/xfs_buf.c | 2 ++
>  fs/xfs/xfs_qm.c  | 2 ++
>  2 files changed, 4 insertions(+)
> 
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index ac3b4db..e566510 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -1078,6 +1078,8 @@ void
>  xfs_buf_unlock(
>  	struct xfs_buf		*bp)
>  {
> +	ASSERT(xfs_buf_islocked(bp));
> +
>  	XB_CLEAR_OWNER(bp);
>  	up(&bp->b_sema);
>  
> diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
> index b669b12..4ff993c 100644
> --- a/fs/xfs/xfs_qm.c
> +++ b/fs/xfs/xfs_qm.c
> @@ -1387,6 +1387,8 @@ xfs_qm_quotacheck(
>  	while (!list_empty(&buffer_list)) {
>  		struct xfs_buf *bp =
>  			list_first_entry(&buffer_list, struct xfs_buf, b_list);
> +		xfs_buf_lock(bp);
> +		bp->b_flags &= ~_XBF_DELWRI_Q;
>  		list_del_init(&bp->b_list);
>  		xfs_buf_relse(bp);
>  	}

I think that should be put in a xfs_buf_delwri_cancel() function,
because the delwri state of a buffer is entirely internal to the
buffer cache - they are on the buffer list as a result of a call to
xfs_buf_delwri_queue() which hides all this internal buffer state
from the callers. Hence the details of cancelling - as the callers
have no idea what xfs_buf_delwri_queue() actually did - should be
internal to the buffer cache code, too.

And, FWIW, it looks highly suspect running this list cancelling
code in response to an error being returned from
xfs_buf_delwri_submit(). xfs_buf_delwri_submit consumes the buffer
list regardless of error state returned, so having the same error
handling for errors before submission as we do afterwards just seems
wrong to me....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
