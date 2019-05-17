Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45890 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728456AbfEQOEu (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 17 May 2019 10:04:50 -0400
Date: Fri, 17 May 2019 10:04:48 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 02/20] xfs: stop using XFS_LI_ABORTED as a parameter flag
Message-ID: <20190517140447.GB7888@bfoster>
References: <20190517073119.30178-1-hch@lst.de>
 <20190517073119.30178-3-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190517073119.30178-3-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Fri, May 17, 2019 at 09:31:01AM +0200, Christoph Hellwig wrote:
> Just pass a straight bool aborted instead of abusing XFS_LI_ABORTED as a
> flag in function parameters.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_log.c     | 25 +++++++++++--------------
>  fs/xfs/xfs_log.h     |  2 +-
>  fs/xfs/xfs_log_cil.c |  4 ++--
>  3 files changed, 14 insertions(+), 17 deletions(-)
> 
...
> diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
> index 5e595948bc5a..1b54002d3874 100644
> --- a/fs/xfs/xfs_log_cil.c
> +++ b/fs/xfs/xfs_log_cil.c
> @@ -577,7 +577,7 @@ xlog_discard_busy_extents(
>  static void
>  xlog_cil_committed(
>  	void	*args,
> -	int	abort)
> +	bool	abort)
>  {

Just FYI.. this function passes abort to xfs_trans_committed_bulk(),
which also looks like it could be changed from int to bool. That aside:

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  	struct xfs_cil_ctx	*ctx = args;
>  	struct xfs_mount	*mp = ctx->cil->xc_log->l_mp;
> @@ -864,7 +864,7 @@ xlog_cil_push(
>  out_abort_free_ticket:
>  	xfs_log_ticket_put(tic);
>  out_abort:
> -	xlog_cil_committed(ctx, XFS_LI_ABORTED);
> +	xlog_cil_committed(ctx, true);
>  	return -EIO;
>  }
>  
> -- 
> 2.20.1
> 
