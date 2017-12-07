Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:60932 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752212AbdLGVeK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 Dec 2017 16:34:10 -0500
Date: Thu, 7 Dec 2017 13:34:04 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v2 1/7] xfs: print transaction log reservation on overrun
Message-ID: <20171207213404.GV19219@magnolia>
References: <20171130185836.18481-1-bfoster@redhat.com>
 <20171130185836.18481-2-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171130185836.18481-2-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Thu, Nov 30, 2017 at 01:58:30PM -0500, Brian Foster wrote:
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
> Reviewed-by: Dave Chinner <dchinner@redhat.com>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

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
>  
> -- 
> 2.13.6
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
