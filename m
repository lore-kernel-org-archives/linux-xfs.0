Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2FE3C433EF
	for <linux-xfs@archiver.kernel.org>; Tue, 29 Mar 2022 00:14:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231290AbiC2AQE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 28 Mar 2022 20:16:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231222AbiC2AQD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 28 Mar 2022 20:16:03 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4D9E20197
        for <linux-xfs@vger.kernel.org>; Mon, 28 Mar 2022 17:14:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5BF66B8159B
        for <linux-xfs@vger.kernel.org>; Tue, 29 Mar 2022 00:14:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8BB8C340EC;
        Tue, 29 Mar 2022 00:14:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648512859;
        bh=Hm4Yps3UtS5QmnzjE6SxWn8fhAsNQ1W/enI1m6tyTHw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=r2xRWqaldDNHFtJdu9w7bPb874Lf3mTJOABlwgMIO6DgHq8LWz/nXnC7wedEfYX/f
         b3WFBo7K4EgpijyXqmRvcz3N5BIyO6twdlRGFEOa+uAOpT00hz7fo2OOFHVUg3XLaV
         sA8jKvVseOyjgitACIWoTwP0J5JDZV5z2V5ea9fOQaIInNWSvyC/vZGnklQWK3WPWf
         29UpbHO7eVZ0DcPMkjW6ZB58NVRvKP2WT7xMrQZakd5I0AU0lv62s4w/j3egHMJhG4
         IQ6xhUxrD0QT41aE0bDmuFIadziOmB/4mL/az1pYEzy49X/vsm+qnZu5RUAu6saatJ
         5+7hlNQACUH8A==
Date:   Mon, 28 Mar 2022 17:14:18 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/6] xfs: log shutdown triggers should only shut down the
 log
Message-ID: <20220329001418.GC27713@magnolia>
References: <20220324002103.710477-1-david@fromorbit.com>
 <20220324002103.710477-5-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220324002103.710477-5-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Mar 24, 2022 at 11:21:01AM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> We've got a mess on our hands.
> 
> 1. xfs_trans_commit() cannot cancel transactions because the mount is
> shut down - that causes dirty, aborted, unlogged log items to sit
> unpinned in memory and potentially get written to disk before the
> log is shut down. Hence xfs_trans_commit() can only abort
> transactions when xlog_is_shutdown() is true.
> 
> 2. xfs_force_shutdown() is used in places to cause the current
> modification to be aborted via xfs_trans_commit() because it may be
> impractical or impossible to cancel the transaction directly, and
> hence xfs_trans_commit() must cancel transactions when
> xfs_is_shutdown() is true in this situation. But we can't do that
> because of #1.
> 
> 3. Log IO errors cause log shutdowns by calling xfs_force_shutdown()
> to shut down the mount and then the log from log IO completion.
> 
> 4. xfs_force_shutdown() can result in a log force being issued,
> which has to wait for log IO completion before it will mark the log
> as shut down. If #3 races with some other shutdown trigger that runs
> a log force, we rely on xfs_force_shutdown() silently ignoring #3
> and avoiding shutting down the log until the failed log force
> completes.
> 
> 5. To ensure #2 always works, we have to ensure that
> xfs_force_shutdown() does not return until the the log is shut down.
> But in the case of #4, this will result in a deadlock because the
> log Io completion will block waiting for a log force to complete
> which is blocked waiting for log IO to complete....
> 
> So the very first thing we have to do here to untangle this mess is
> dissociate log shutdown triggers from mount shutdowns. We already
> have xlog_forced_shutdown, which will atomically transistion to the
> log a shutdown state. Due to internal asserts it cannot be called
> multiple times, but was done simply because the only place that
> could call it was xfs_do_force_shutdown() (i.e. the mount shutdown!)
> and that could only call it once and once only.  So the first thing
> we do is remove the asserts.
> 
> We then convert all the internal log shutdown triggers to call
> xlog_force_shutdown() directly instead of xfs_force_shutdown(). This
> allows the log shutdown triggers to shut down the log without
> needing to care about mount based shutdown constraints. This means
> we shut down the log independently of the mount and the mount may
> not notice this until it's next attempt to read or modify metadata.
> At that point (e.g. xfs_trans_commit()) it will see that the log is
> shutdown, error out and shutdown the mount.
> 
> To ensure that all the unmount behaviours and asserts track
> correctly as a result of a log shutdown, propagate the shutdown up
> to the mount if it is not already set. This keeps the mount and log
> state in sync, and saves a huge amount of hassle where code fails
> because of a log shutdown but only checks for mount shutdowns and
> hence ends up doing the wrong thing. Cleaning up that mess is
> an exercise for another day.
> 
> This enables us to address the other problems noted above in
> followup patches.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_log.c         | 32 +++++++++++++++++++++++---------
>  fs/xfs/xfs_log_cil.c     |  4 ++--
>  fs/xfs/xfs_log_recover.c |  6 +++---
>  fs/xfs/xfs_mount.c       |  1 +
>  fs/xfs/xfs_trans_ail.c   |  8 ++++----
>  5 files changed, 33 insertions(+), 18 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index 388d53df7620..6879d6d19d68 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -1360,7 +1360,7 @@ xlog_ioend_work(
>  	 */
>  	if (XFS_TEST_ERROR(error, log->l_mp, XFS_ERRTAG_IODONE_IOERR)) {
>  		xfs_alert(log->l_mp, "log I/O error %d", error);
> -		xfs_force_shutdown(log->l_mp, SHUTDOWN_LOG_IO_ERROR);
> +		xlog_force_shutdown(log, SHUTDOWN_LOG_IO_ERROR);
>  	}
>  
>  	xlog_state_done_syncing(iclog);
> @@ -1899,7 +1899,7 @@ xlog_write_iclog(
>  	iclog->ic_flags &= ~(XLOG_ICL_NEED_FLUSH | XLOG_ICL_NEED_FUA);
>  
>  	if (xlog_map_iclog_data(&iclog->ic_bio, iclog->ic_data, count)) {
> -		xfs_force_shutdown(log->l_mp, SHUTDOWN_LOG_IO_ERROR);
> +		xlog_force_shutdown(log, SHUTDOWN_LOG_IO_ERROR);
>  		return;
>  	}
>  	if (is_vmalloc_addr(iclog->ic_data))
> @@ -2474,7 +2474,7 @@ xlog_write(
>  		xfs_alert_tag(log->l_mp, XFS_PTAG_LOGRES,
>  		     "ctx ticket reservation ran out. Need to up reservation");
>  		xlog_print_tic_res(log->l_mp, ticket);
> -		xfs_force_shutdown(log->l_mp, SHUTDOWN_LOG_IO_ERROR);
> +		xlog_force_shutdown(log, SHUTDOWN_LOG_IO_ERROR);
>  	}
>  
>  	len = xlog_write_calc_vec_length(ticket, log_vector, optype);
> @@ -3808,9 +3808,10 @@ xlog_verify_iclog(
>  #endif
>  
>  /*
> - * Perform a forced shutdown on the log. This should be called once and once
> - * only by the high level filesystem shutdown code to shut the log subsystem
> - * down cleanly.
> + * Perform a forced shutdown on the log.
> + *
> + * This can be called from low level log code to trigger a shutdown, or from the
> + * high level mount shutdown code when the mount shuts down.
>   *
>   * Our main objectives here are to make sure that:
>   *	a. if the shutdown was not due to a log IO error, flush the logs to
> @@ -3819,6 +3820,8 @@ xlog_verify_iclog(
>   *	   parties to find out. Nothing new gets queued after this is done.
>   *	c. Tasks sleeping on log reservations, pinned objects and
>   *	   other resources get woken up.
> + *	d. The mount is also marked as shut down so that log triggered shutdowns
> + *	   still behave the same as if they called xfs_forced_shutdown().
>   *
>   * Return true if the shutdown cause was a log IO error and we actually shut the
>   * log down.
> @@ -3837,8 +3840,6 @@ xlog_force_shutdown(
>  	if (!log || xlog_in_recovery(log))
>  		return false;
>  
> -	ASSERT(!xlog_is_shutdown(log));
> -
>  	/*
>  	 * Flush all the completed transactions to disk before marking the log
>  	 * being shut down. We need to do this first as shutting down the log
> @@ -3865,11 +3866,24 @@ xlog_force_shutdown(
>  	spin_lock(&log->l_icloglock);
>  	if (test_and_set_bit(XLOG_IO_ERROR, &log->l_opstate)) {
>  		spin_unlock(&log->l_icloglock);
> -		ASSERT(0);
>  		return false;
>  	}
>  	spin_unlock(&log->l_icloglock);
>  
> +	/*
> +	 * If this log shutdown also sets the mount shutdown state, issue a
> +	 * shutdown warning message.
> +	 */
> +	if (!test_and_set_bit(XFS_OPSTATE_SHUTDOWN, &log->l_mp->m_opstate)) {
> +		xfs_alert_tag(log->l_mp, XFS_PTAG_SHUTDOWN_LOGERROR,
> +		"Filesystem has been shut down due to log error (0x%x).",
> +				shutdown_flags);
> +		xfs_alert(log->l_mp,
> +		"Please unmount the filesystem and rectify the problem(s)");

Style nit: Can we make these strings have a different level of indent
than the enclosing function call?

Other than that, I think it makes a lot of sense that xfs_log* functions
should call the xlog shutdown procedure, not the one in the fs.

With the style nit fixed,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> +		if (xfs_error_level >= XFS_ERRLEVEL_HIGH)
> +			xfs_stack_trace();
> +	}
> +
>  	/*
>  	 * We don't want anybody waiting for log reservations after this. That
>  	 * means we have to wake up everybody queued up on reserveq as well as
> diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
> index 43006f6f5ab8..ba57323bfdce 100644
> --- a/fs/xfs/xfs_log_cil.c
> +++ b/fs/xfs/xfs_log_cil.c
> @@ -540,7 +540,7 @@ xlog_cil_insert_items(
>  	spin_unlock(&cil->xc_cil_lock);
>  
>  	if (tp->t_ticket->t_curr_res < 0)
> -		xfs_force_shutdown(log->l_mp, SHUTDOWN_LOG_IO_ERROR);
> +		xlog_force_shutdown(log, SHUTDOWN_LOG_IO_ERROR);
>  }
>  
>  static void
> @@ -864,7 +864,7 @@ xlog_cil_write_commit_record(
>  
>  	error = xlog_write(log, ctx, &vec, ctx->ticket, XLOG_COMMIT_TRANS);
>  	if (error)
> -		xfs_force_shutdown(log->l_mp, SHUTDOWN_LOG_IO_ERROR);
> +		xlog_force_shutdown(log, SHUTDOWN_LOG_IO_ERROR);
>  	return error;
>  }
>  
> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index 7758a6706b8c..c4ad4296c540 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -2485,7 +2485,7 @@ xlog_finish_defer_ops(
>  		error = xfs_trans_alloc(mp, &resv, dfc->dfc_blkres,
>  				dfc->dfc_rtxres, XFS_TRANS_RESERVE, &tp);
>  		if (error) {
> -			xfs_force_shutdown(mp, SHUTDOWN_LOG_IO_ERROR);
> +			xlog_force_shutdown(mp->m_log, SHUTDOWN_LOG_IO_ERROR);
>  			return error;
>  		}
>  
> @@ -3454,7 +3454,7 @@ xlog_recover_finish(
>  		 */
>  		xlog_recover_cancel_intents(log);
>  		xfs_alert(log->l_mp, "Failed to recover intents");
> -		xfs_force_shutdown(log->l_mp, SHUTDOWN_LOG_IO_ERROR);
> +		xlog_force_shutdown(log, SHUTDOWN_LOG_IO_ERROR);
>  		return error;
>  	}
>  
> @@ -3501,7 +3501,7 @@ xlog_recover_finish(
>  		 * end of intents processing can be pushed through the CIL
>  		 * and AIL.
>  		 */
> -		xfs_force_shutdown(log->l_mp, SHUTDOWN_LOG_IO_ERROR);
> +		xlog_force_shutdown(log, SHUTDOWN_LOG_IO_ERROR);
>  	}
>  
>  	return 0;
> diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> index bed73e8002a5..4e1aa4240b61 100644
> --- a/fs/xfs/xfs_mount.c
> +++ b/fs/xfs/xfs_mount.c
> @@ -21,6 +21,7 @@
>  #include "xfs_trans.h"
>  #include "xfs_trans_priv.h"
>  #include "xfs_log.h"
> +#include "xfs_log_priv.h"
>  #include "xfs_error.h"
>  #include "xfs_quota.h"
>  #include "xfs_fsops.h"
> diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
> index c2ccb98c7bcd..d3a97a028560 100644
> --- a/fs/xfs/xfs_trans_ail.c
> +++ b/fs/xfs/xfs_trans_ail.c
> @@ -873,17 +873,17 @@ xfs_trans_ail_delete(
>  	int			shutdown_type)
>  {
>  	struct xfs_ail		*ailp = lip->li_ailp;
> -	struct xfs_mount	*mp = ailp->ail_log->l_mp;
> +	struct xlog		*log = ailp->ail_log;
>  	xfs_lsn_t		tail_lsn;
>  
>  	spin_lock(&ailp->ail_lock);
>  	if (!test_bit(XFS_LI_IN_AIL, &lip->li_flags)) {
>  		spin_unlock(&ailp->ail_lock);
> -		if (shutdown_type && !xlog_is_shutdown(ailp->ail_log)) {
> -			xfs_alert_tag(mp, XFS_PTAG_AILDELETE,
> +		if (shutdown_type && !xlog_is_shutdown(log)) {
> +			xfs_alert_tag(log->l_mp, XFS_PTAG_AILDELETE,
>  	"%s: attempting to delete a log item that is not in the AIL",
>  					__func__);
> -			xfs_force_shutdown(mp, shutdown_type);
> +			xlog_force_shutdown(log, shutdown_type);
>  		}
>  		return;
>  	}
> -- 
> 2.35.1
> 
