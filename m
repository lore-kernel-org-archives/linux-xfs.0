Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 22 Jan 2008 23:11:30 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m0N7BMFI018754
	for <xfs@oss.sgi.com>; Tue, 22 Jan 2008 23:11:24 -0800
Message-ID: <4796E8C8.3030702@sgi.com>
Date: Wed, 23 Jan 2008 18:12:08 +1100
From: Timothy Shimmin <tes@sgi.com>
MIME-Version: 1.0
Subject: Re: [patch] Prevent AIL lock contention during transaction completion
References: <20080121052330.GG155259@sgi.com>
In-Reply-To: <20080121052330.GG155259@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

Hi Dave,

So all cosmetic except for moving of xlog_assign_tail_lsn().

Looking at the code the l_tail_lsn is used by more than just
when we are writing out the iclog.
Certainly, that is where we set the h_tail_lsn in the iclog
header, so we can find the tail later on during mount/recovery.

However, we also use l_tail_lsn when trying to work out
how much space is left in the log
i.e.
- xlog_space_left(), xlog_grant_push_tail(),
   xlog_grant_log_space(), xlog_regrant_write_log_space()

I guess this could mean that we may fail to update the l_tail_lsn
now if we don't sync the iclog (not in want-sync state etc..)
and so there could be more space
in the log than we realise until a bit later.
Maybe not a big deal.
Not sure if this really happens though or not.

Looking who assigns to l_tail_lsn (apart from initialisation
and recovery) we have xlog_assign_tail_lsn and xfs_log_move_tail.
And (apart from recovery) xlog_assign_tail_lsn is called by our
xlog_state_release_iclog.
So I presume the other place where we update the l_tail_lsn in
general is in calls to xfs_log_move_tail.
And xfs_log_move_tail is called by:
* xfs_trans_update_ail, xfs_trans_delete_ail,
   (xfs_trans_unlocked_item and xlog_ungrant_log_space who call
    xfs_log_move_tail call it with param 1 which doesn't modify
    l_tail_lsn)
I would have thought update_ail and delete_ail would cover the
changes to the ail and hence what the new min item in the ail list
is and hence the change in the tail.
In the case of an empty AIL, I guess it needs to use l_last_sync_lsn
which is what xlog_assign_tail_lsn gives you that xfs_log_move_tail
doesn't.

--Tim

David Chinner wrote:
> When hundreds of processors attempt to commit
> transactions at the same time, they can contend on the AIL
> lock when updating the tail LSN held in the in-core log
> structure.
> 
> At the moment, the tail LSN is only needed when actually writing
> out an iclog, so it really does not need to be updated on every
> single transaction completion - only those that result in switching
> iclogs and flushing them to disk.
> 
> The result is that we reduce the number oftimes we need to grab the
> AIL lock and the log grant lock by up to two orders of magnitude
> on large processor count machines. The problem has previously been
> hidden by AIL lock contention walking the AIL list, which has
> recently been solved.
> 
> Signed-off-by: Dave Chinner <dgc@sgi.com>
> ---
>  fs/xfs/xfs_log.c |   15 ++++++---------
>  1 file changed, 6 insertions(+), 9 deletions(-)
> 
> Index: 2.6.x-xfs-new/fs/xfs/xfs_log.c
> ===================================================================
> --- 2.6.x-xfs-new.orig/fs/xfs/xfs_log.c	2008-01-21 16:06:27.187549816 +1100
> +++ 2.6.x-xfs-new/fs/xfs/xfs_log.c	2008-01-21 16:16:51.804146394 +1100
> @@ -2815,15 +2815,13 @@ xlog_state_put_ticket(xlog_t	    *log,
>   *
>   */
>  STATIC int
> -xlog_state_release_iclog(xlog_t		*log,
> -			 xlog_in_core_t	*iclog)
> +xlog_state_release_iclog(
> +	xlog_t		*log,
> +	xlog_in_core_t	*iclog)
>  {
>  	int		sync = 0;	/* do we sync? */
>  
> -	xlog_assign_tail_lsn(log->l_mp);
> -
>  	spin_lock(&log->l_icloglock);
> -
>  	if (iclog->ic_state & XLOG_STATE_IOERROR) {
>  		spin_unlock(&log->l_icloglock);
>  		return XFS_ERROR(EIO);
> @@ -2835,13 +2833,14 @@ xlog_state_release_iclog(xlog_t		*log,
>  
>  	if (--iclog->ic_refcnt == 0 &&
>  	    iclog->ic_state == XLOG_STATE_WANT_SYNC) {
> +		/* update tail before writing to iclog */
> +		xlog_assign_tail_lsn(log->l_mp);
>  		sync++;
>  		iclog->ic_state = XLOG_STATE_SYNCING;
>  		iclog->ic_header.h_tail_lsn = cpu_to_be64(log->l_tail_lsn);
>  		xlog_verify_tail_lsn(log, iclog, log->l_tail_lsn);
>  		/* cycle incremented when incrementing curr_block */
>  	}
> -
>  	spin_unlock(&log->l_icloglock);
>  
>  	/*
> @@ -2851,11 +2850,9 @@ xlog_state_release_iclog(xlog_t		*log,
>  	 * this iclog has consistent data, so we ignore IOERROR
>  	 * flags after this point.
>  	 */
> -	if (sync) {
> +	if (sync)
>  		return xlog_sync(log, iclog);
> -	}
>  	return 0;
> -
>  }	/* xlog_state_release_iclog */
>  
>  
