Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:24077 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752328AbdDFWj3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 6 Apr 2017 18:39:29 -0400
Date: Thu, 6 Apr 2017 15:39:21 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 1/3] xfs: fix up quotacheck buffer list error handling
Message-ID: <20170406223921.GB4864@birch.djwong.org>
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
Cc: linux-xfs@vger.kernel.org, Dave Chinner <david@fromorbit.com>, Martin Svec <martin.svec@zoner.cz>

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

Hmm, was this the only place we ever _buf_unlock'd an unlocked buffer?

--D

>  	}
> -- 
> 2.7.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
