Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:27734 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751991AbdJWXu2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 23 Oct 2017 19:50:28 -0400
Date: Mon, 23 Oct 2017 16:50:22 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 2/4] xfs: fix log block underflow during recovery cycle
 verification
Message-ID: <20171023235022.GJ5483@magnolia>
References: <20171023144646.50107-1-bfoster@redhat.com>
 <20171023144646.50107-3-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171023144646.50107-3-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Mon, Oct 23, 2017 at 10:46:44AM -0400, Brian Foster wrote:
> Unfortunately it is possible for mkfs to format very small
> filesystems with too small of an internal log with respect to the
> various minimum size and block count requirements. If this occurs
> when the log happens to be smaller than the scan window used for
> cycle verification and the scan wraps the end of the log, the
> start_blk calculation in xlog_find_head() underflows and leads to an
> attempt to scan an invalid range of log blocks. This results in log
> recovery failure and a failed mount.
> 
> Since there may be filesystems out in the wild with this kind of
> geometry, we cannot simply refuse to mount. Instead, cap the scan
> window for cycle verification to the size of the physical log. This
> ensures that the cycle verification proceeds as expected when the
> scan wraps the end of the log.
> 
> Reported-by: Zorro Lang <zlang@redhat.com>
> Signed-off-by: Brian Foster <bfoster@redhat.com>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

> ---
>  fs/xfs/xfs_log_recover.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index 80b37a2..019de58 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -760,7 +760,7 @@ xlog_find_head(
>  	 * in the in-core log.  The following number can be made tighter if
>  	 * we actually look at the block size of the filesystem.
>  	 */
> -	num_scan_bblks = XLOG_TOTAL_REC_SHIFT(log);
> +	num_scan_bblks = min_t(int, log_bbnum, XLOG_TOTAL_REC_SHIFT(log));
>  	if (head_blk >= num_scan_bblks) {
>  		/*
>  		 * We are guaranteed that the entire check can be performed
> -- 
> 2.9.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
