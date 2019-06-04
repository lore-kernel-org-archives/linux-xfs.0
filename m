Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38146 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728166AbfFDQMn (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 4 Jun 2019 12:12:43 -0400
Date: Tue, 4 Jun 2019 12:12:40 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 06/20] xfs: don't use REQ_PREFLUSH for split log writes
Message-ID: <20190604161240.GA44563@bfoster>
References: <20190603172945.13819-1-hch@lst.de>
 <20190603172945.13819-7-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190603172945.13819-7-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org, Dave Chinner <dchinner@redhat.com>

On Mon, Jun 03, 2019 at 07:29:31PM +0200, Christoph Hellwig wrote:
> If we have to split a log write because it wraps the end of the log we
> can't just use REQ_PREFLUSH to flush before the first log write,
> as the writes might get reordered somewhere in the I/O stack.  Issue
> a manual flush in that case so that the ordering of the two log I/Os
> doesn't matter.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_log.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index 3b82ca8ac9c8..646a190e5730 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -1941,7 +1941,7 @@ xlog_sync(
>  	 * synchronously here; for an internal log we can simply use the block
>  	 * layer state machine for preflushes.
>  	 */
> -	if (log->l_mp->m_logdev_targp != log->l_mp->m_ddev_targp)
> +	if (log->l_mp->m_logdev_targp != log->l_mp->m_ddev_targp || split)
>  		xfs_blkdev_issue_flush(log->l_mp->m_ddev_targp);

I'm curious if this is really necessary. The log record isn't
recoverable until it's complete on disk (and thus the tail LSN stamped
in the record header not relevant). As long as the cache flushes before
the record is completely written, what difference does it make if it was
made up of two out of order I/Os?

Granted log wrapping is not a frequent operation, but the explicit flush
is a synchronous operation in the log force path whereas the flush flag
isn't.

Brian

>  	else
>  		bp->b_flags |= XBF_FLUSH;
> -- 
> 2.20.1
> 
