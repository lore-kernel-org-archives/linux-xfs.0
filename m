Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 10 Jul 2008 22:24:46 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m6B5OfZB026693
	for <xfs@oss.sgi.com>; Thu, 10 Jul 2008 22:24:43 -0700
Message-ID: <4876EED7.8060004@sgi.com>
Date: Fri, 11 Jul 2008 15:25:43 +1000
From: Timothy Shimmin <tes@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] Fix reference counting race on log buffers
References: <1215752481-6862-1-git-send-email-david@fromorbit.com>
In-Reply-To: <1215752481-6862-1-git-send-email-david@fromorbit.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

Dave,

Yeah, looks good. Thanks.
(My personal preference is for reversing if/else than using !
 as it is easier to read but whatever :)

But will need Eric's result before checking it in.

--Tim


Dave Chinner wrote:
> When we release the iclog, we do an atomic_dec_and_lock to determine
> if we are the last reference to enable update of log headers and
> writeout. however, in xlog_state_get_iclog_space() we need to check
> if we have the last reference count there.  if we do, we release the
> log buffer, otherwise we decrement the reference count.
> 
> The issue is that the compare and decrement in
> xlog_state_get_iclog_space() is not atomic, so both places can see a
> reference count of 2 and neither will release the iclog. That leads
> to a filesystem hang.
> 
> Close the hole replacing the compare and decrement with
> atomic_add_unless() to ensure that they are executed atomically.
> 
> Signed-off-by: Dave Chinner <david@fromorbit.com>
> ---
>  fs/xfs/xfs_log.c |   15 +++++++++++----
>  1 files changed, 11 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index 760d543..0816c5d 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -2425,13 +2425,20 @@ restart:
>  	if (iclog->ic_size - iclog->ic_offset < 2*sizeof(xlog_op_header_t)) {
>  		xlog_state_switch_iclogs(log, iclog, iclog->ic_size);
>  
> -		/* If I'm the only one writing to this iclog, sync it to disk */
> -		if (atomic_read(&iclog->ic_refcnt) == 1) {
> +		/*
> +		 * If I'm the only one writing to this iclog, sync it to disk.
> +		 * We need to do an atomic compare and decrement here to avoid
> +		 * racing with concurrent atomic_dec_and_lock() calls in
> +		 * xlog_state_release_iclog() when there is more than one
> +		 * reference to the iclog.
> +		 */
> +		if (!atomic_add_unless(&iclog->ic_refcnt, -1, 1)) {
> +			/* we are the only one */
>  			spin_unlock(&log->l_icloglock);
> -			if ((error = xlog_state_release_iclog(log, iclog)))
> +			error = xlog_state_release_iclog(log, iclog);
> +			if (error)
>  				return error;
>  		} else {
> -			atomic_dec(&iclog->ic_refcnt);
>  			spin_unlock(&log->l_icloglock);
>  		}
>  		goto restart;
