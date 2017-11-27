Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:49917 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752051AbdK0WOe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 27 Nov 2017 17:14:34 -0500
Date: Tue, 28 Nov 2017 09:14:32 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/4] xfs: print transaction log reservation on overrun
Message-ID: <20171127221431.GZ5858@dastard>
References: <20171127202434.43125-1-bfoster@redhat.com>
 <20171127202434.43125-2-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171127202434.43125-2-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Mon, Nov 27, 2017 at 03:24:31PM -0500, Brian Foster wrote:
> The transaction dump code displays the content and reservation
> consumption of a particular transaction in the event of an overrun.
> It currently displays the reservation associated with the
> transaction ticket, but not the original reservation attached to the
> transaction.
> 
> The latter value reflects the original transaction reservation
> calculation before additional reservation overhead is assigned, such
> as for the CIL context header and potential split region headers.
> 
> Update xlog_print_trans() to also print the original transaction
> reservation in the event of overrun. This provides a reference point
> to identify how much reservation overhead was added to a particular
> ticket by xfs_log_calc_unit_res().
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> ---
>  fs/xfs/xfs_log.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index 38d4227895ae..3a37fa1ed25e 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -2117,7 +2117,9 @@ xlog_print_trans(
>  
>  	/* dump core transaction and ticket info */
>  	xfs_warn(mp, "transaction summary:");
> -	xfs_warn(mp, "  flags	= 0x%x", tp->t_flags);
> +	xfs_warn(mp, "  log res   = %d", tp->t_log_res);
> +	xfs_warn(mp, "  log count = %d", tp->t_log_count);
> +	xfs_warn(mp, "  flags     = 0x%x", tp->t_flags);
>  
>  	xlog_print_tic_res(mp, tp->t_ticket);


Looks fine.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
