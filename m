Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o4JJERUV149013 for <xfs@oss.sgi.com>; Wed, 19 May 2010 14:14:28 -0500
Subject: Re: [PATCH 05/12] xfs: clean up log ticket overrun debug output
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <1274138668-1662-6-git-send-email-david@fromorbit.com>
References: <1274138668-1662-1-git-send-email-david@fromorbit.com>
	<1274138668-1662-6-git-send-email-david@fromorbit.com>
Date: Wed, 19 May 2010 14:16:44 -0500
Message-ID: <1274296604.2140.55.camel@doink>
Mime-Version: 1.0
Reply-To: aelder@sgi.com
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Tue, 2010-05-18 at 09:24 +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Push the error message output when a ticket overrun is detected
> into the ticket printing functions. Also remove the debug version
> of the code as the production version will still panic just as
> effectively on a debug kernel via the panic mask being set.

Another not-really-actionable bit of commentary
below, but this looks good.

> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_error.c |    2 +-
>  fs/xfs/xfs_log.c   |   19 +++++--------------
>  2 files changed, 6 insertions(+), 15 deletions(-)
> 
> diff --git a/fs/xfs/xfs_error.c b/fs/xfs/xfs_error.c
> index ef96175..047b8a8 100644
> --- a/fs/xfs/xfs_error.c
> +++ b/fs/xfs/xfs_error.c
> @@ -170,7 +170,7 @@ xfs_cmn_err(int panic_tag, int level, xfs_mount_t *mp, char *fmt, ...)
>  	va_list ap;
>  
>  #ifdef DEBUG
> -	xfs_panic_mask |= XFS_PTAG_SHUTDOWN_CORRUPT;
> +	xfs_panic_mask |= (XFS_PTAG_SHUTDOWN_CORRUPT | XFS_PTAG_LOGRES);
>  #endif
>  
>  	if (xfs_panic_mask && (xfs_panic_mask & panic_tag)
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index 83be6a6..1efb303 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -1645,6 +1645,10 @@ xlog_print_tic_res(xfs_mount_t *mp, xlog_ticket_t *ticket)
>  			    "bad-rtype" : res_type_str[r_type-1]),
>  			    ticket->t_res_arr[i].r_len);
>  	}
> +
> +	xfs_cmn_err(XFS_PTAG_LOGRES, CE_ALERT, mp,
> +		"xfs_log_write: reservation ran out. Need to up reservation");
> +	xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
>  }
>  
>  /*
> @@ -1897,21 +1901,8 @@ xlog_write(
>  	*start_lsn = 0;
>  
>  	len = xlog_write_calc_vec_length(ticket, log_vector);
> -	if (ticket->t_curr_res < len) {
> +	if (ticket->t_curr_res < len)
>  		xlog_print_tic_res(log->l_mp, ticket);

Somehow "xlog_print_tic_res" doesn't suggest to me
that we're going to panic at this point, and I think
therefore that bit of information is lost with this
change.  I prefer what you've done, but I think I
would have liked some brief comment or something that
tells me this is a fatal condition.

> -#ifdef DEBUG
> -		xlog_panic(
> -	"xfs_log_write: reservation ran out. Need to up reservation");
> -#else
> -		/* Customer configurable panic */
> -		xfs_cmn_err(XFS_PTAG_LOGRES, CE_ALERT, log->l_mp,
> -	"xfs_log_write: reservation ran out. Need to up reservation");
> -
> -		/* If we did not panic, shutdown the filesystem */
> -		xfs_force_shutdown(log->l_mp, SHUTDOWN_CORRUPT_INCORE);
> -#endif
> -	}
> -
>  	ticket->t_curr_res -= len;
>  
>  	index = 0;



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
