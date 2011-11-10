Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pAAMJiIh136573 for <xfs@oss.sgi.com>; Thu, 10 Nov 2011 16:19:44 -0600
Received: from ipmail06.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0AB99104FE31
	for <xfs@oss.sgi.com>; Thu, 10 Nov 2011 14:19:41 -0800 (PST)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	9BolbT6sdQjqCUzx for <xfs@oss.sgi.com>;
	Thu, 10 Nov 2011 14:19:41 -0800 (PST)
Date: Fri, 11 Nov 2011 09:19:37 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Debug of xfstest 234 hang
Message-ID: <20111110221937.GA2386@dastard>
References: <1320959794.2201.15.camel@chandra-lucid.austin.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1320959794.2201.15.camel@chandra-lucid.austin.ibm.com>
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
To: Chandra Seetharaman <sekharan@us.ibm.com>
Cc: XFS Mailing List <xfs@oss.sgi.com>, Alex Elder <aelder@sgi.com>

On Thu, Nov 10, 2011 at 03:16:33PM -0600, Chandra Seetharaman wrote:
> Hi Dave, Alex,
> 
> Debugging using trace, crash and systemtap, I found that the hang
> happens when xfs_sync_worker() (thru kworker) gets stuck in xlog_wait()
> while reserving a transaction log buffer for the dummy log.

Yes, that much I already knew from stack traces posted.

> I also found that even though xfsaild_push() keeps getting invoked, it
> doesn't do anything to push the log to the disk, since the
> ailp->xa_target has not been changed since it has been called from the
> process stack a while back.

Which is normal behaviour - if the log head/tail have't moved, then the
calculated push target (25 % of log space free) will not change
during the transaction reservation.

> So, I thought, resetting the target to the max value would help nudge
> the flow of ail to the disk. So, I added the following code. 
> ------------------
> diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
> index ed9252b..f59fd9f 100644
> --- a/fs/xfs/xfs_trans_ail.c
> +++ b/fs/xfs/xfs_trans_ail.c
> @@ -534,6 +534,10 @@ out_done:
>  		ailp->xa_last_pushed_lsn = 0;
>  	}
>  
> +	lsn = xfs_ail_max_lsn(ailp);
> +	smp_wmb();
> +	xfs_trans_ail_copy_lsn(ailp, &ailp->xa_target, &lsn);
> +	smp_wmb();
>  	return tout;
>  }
> --------------------
> 
> and it seem to do the magic.

which means anyone who pushes on the AIL *always empties it*. That's
extremely bad from a performance persepctive because it means we no
longer have any concept of delaying metadata writeback until it is
really necessary.

Basically all this does is prevent the log space usage from hanging
around the threshold point that causes the hang. i.e. instead of
keeping the log roughly 25% free, this change means we get to 75%
full then try to empty it completely. The hang is occurring due to
some as yet unknown flaw in the threshold logic, so all your change
does is make it harder to hit because the filesysetm spends less
time at the threshold.

A better way to acheive this woulxp dbe to push the AIL in
xfs_sync_worker() before trying to cover the log. i.e. change the
code to do this:

 
 	if (!(mp->m_flags & XFS_MOUNT_RDONLY)) {
+		/* start pushing all the metadata that is currently dirty */
+		xfs_ail_push_all(mp->m_ail);
+
 		/* dgc: errors ignored here */
 		if (mp->m_super->s_frozen == SB_UNFROZEN &&
 		    xfs_log_need_covered(mp))
 			error = xfs_fs_log_dummy(mp);
 		else
 			xfs_log_force(mp, 0);
 		error = xfs_qm_sync(mp, SYNC_TRYLOCK);
-
-		/* start pushing all the metadata that is currently dirty */
-		xfs_ail_push_all(mp->m_ail);
 	}
 
 	/* queue us up again */

This will guarantee the push target is moved before the sync worker
tries to do a transaction reservation and potentially hangs waiting
for space.

However, this is still just a workaround for whatever threshold
value problem we have that is the root cause of the problem. Hence
what I'd really like to know is where the grant head/log tail values
are at this point when the hang occurs (the log event tracing has
all the necessary values) so we can get an idea of the condition
that we are stuck in. Being able to view the progression of log
reservations and releases leading up to the hang (once again from
the event trace) might point out exactly what condition we are
getting stuck in, and that's what we nee dto understand first before
trying to fix the problem.

The log reserve tracepoints give output like this:

           <...>-8903  [002] 241733.544531: xfs_log_reserve:      dev 253:16 type QM_SETQLIM t_ocnt 1 t_cnt 1 t_curr_res 2332 t_unit_res 2332 t_flags XLOG_TIC_INITED reserveq empty writeq empty grant_reserve_cycle 1 grant_reserve_bytes 105116 grant_write_cycle 1 grant_write_bytes 105116 curr_cycle 1 curr_block 23 tail_cycle 1 tail_block 2
           <...>-8903  [002] 241733.544531: xfs_log_grant_enter:  dev 253:16 type QM_SETQLIM t_ocnt 1 t_cnt 1 t_curr_res 2332 t_unit_res 2332 t_flags XLOG_TIC_INITED reserveq empty writeq empty grant_reserve_cycle 1 grant_reserve_bytes 105116 grant_write_cycle 1 grant_write_bytes 105116 curr_cycle 1 curr_block 23 tail_cycle 1 tail_block 2
           <...>-8903  [002] 241733.544531: xfs_log_grant_exit:   dev 253:16 type QM_SETQLIM t_ocnt 1 t_cnt 1 t_curr_res 2332 t_unit_res 2332 t_flags XLOG_TIC_INITED reserveq empty writeq empty grant_reserve_cycle 1 grant_reserve_bytes 107448 grant_write_cycle 1 grant_write_bytes 107448 curr_cycle 1 curr_block 23 tail_cycle 1 tail_block 2

which show all the information about the grant/write head locations,
the current tail location, the transaction type and reservation,
etc. When the transaction is committed we then see:


           <...>-8894  [002] 241733.544536: xfs_log_done_nonperm: dev 253:16 type QM_SETQLIM t_ocnt 1 t_cnt 1 t_curr_res 2180 t_unit_res 2332 t_flags XLOG_TIC_INITED reserveq empty writeq empty grant_reserve_cycle 1 grant_reserve_bytes 107448 grant_write_cycle 1 grant_write_bytes 107448 curr_cycle 1 curr_block 23 tail_cycle 1 tail_block 2
           <...>-8894  [002] 241733.544536: xfs_log_ungrant_enter: dev 253:16 type QM_SETQLIM t_ocnt 1 t_cnt 0 t_curr_res 2180 t_unit_res 2332 t_flags XLOG_TIC_INITED reserveq empty writeq empty grant_reserve_cycle 1 grant_reserve_bytes 107448 grant_write_cycle 1 grant_write_bytes 107448 curr_cycle 1 curr_block 23 tail_cycle 1 tail_block 2
           <...>-8894  [002] 241733.544536: xfs_log_ungrant_sub:  dev 253:16 type QM_SETQLIM t_ocnt 1 t_cnt 0 t_curr_res 2180 t_unit_res 2332 t_flags XLOG_TIC_INITED reserveq empty writeq empty grant_reserve_cycle 1 grant_reserve_bytes 107448 grant_write_cycle 1 grant_write_bytes 107448 curr_cycle 1 curr_block 23 tail_cycle 1 tail_block 2
           <...>-8894  [002] 241733.544537: xfs_log_ungrant_exit: dev 253:16 type QM_SETQLIM t_ocnt 1 t_cnt 0 t_curr_res 2180 t_unit_res 2332 t_flags XLOG_TIC_INITED reserveq empty writeq empty grant_reserve_cycle 1 grant_reserve_bytes 105268 grant_write_cycle 1 grant_write_bytes 105268 curr_cycle 1 curr_block 23 tail_cycle 1 tail_block 2

Where the remaining reservation is returned to the log.

>From these traces, we can see how much space is being used by each
transaction (t_unit_res - t_curr_res), whether the grant head/write
head change apprpropriately, whether there are queued waiters, where
the tail is, where the last iclog was written to, etc. By looking at
the various values, the threshold problem might become obvious.  I
tend to write quick throw-away awk scripts to extract the necessary
fields into a plottable formats and run those through something like
gnuplot or kst to see if there is any visible artifacts that might
be the cause of the problem...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
