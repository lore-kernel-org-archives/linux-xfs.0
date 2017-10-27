Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:49193 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751145AbdJ0QVT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 27 Oct 2017 12:21:19 -0400
Date: Fri, 27 Oct 2017 09:21:15 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs: fix unused variable warning in xfs_buf_set_ref()
Message-ID: <20171027162115.GK5483@magnolia>
References: <201710271527.DFIgRssJ%fengguang.wu@intel.com>
 <20171027102248.61771-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171027102248.61771-1-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Fri, Oct 27, 2017 at 06:22:48AM -0400, Brian Foster wrote:
> Fix an unused variable warning on non-DEBUG builds introduced by
> commit 7561d27e90 ("xfs: buffer lru reference count error injection
> tag").
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

> ---
> 
> Sigh, sorry for the noise..
> 
> Brian
> 
>  fs/xfs/xfs_buf.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index d481dd2..db786bc 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -2133,14 +2133,13 @@ xfs_buf_terminate(void)
>  
>  void xfs_buf_set_ref(struct xfs_buf *bp, int lru_ref)
>  {
> -	struct xfs_mount	*mp = bp->b_target->bt_mount;
> -
>  	/*
>  	 * Set the lru reference count to 0 based on the error injection tag.
>  	 * This allows userspace to disrupt buffer caching for debug/testing
>  	 * purposes.
>  	 */
> -	if (XFS_TEST_ERROR(false, mp, XFS_ERRTAG_BUF_LRU_REF))
> +	if (XFS_TEST_ERROR(false, bp->b_target->bt_mount,
> +			   XFS_ERRTAG_BUF_LRU_REF))
>  		lru_ref = 0;
>  
>  	atomic_set(&bp->b_lru_ref, lru_ref);
> -- 
> 2.9.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
