Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5199221B44A
	for <linux-xfs@vger.kernel.org>; Tue, 12 Nov 2024 23:58:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731455889; cv=none; b=pX8zMv/VLqWZkASscGqiLZDnLT6gC2l2/2pl5TTrHLnQJQAHMZLM9zTFsVZ7cILV2WtsHOYX0slZ7LY4clMBGFXB2xg/Zc5BW7bB1zQKM5sM4c9ocCm53hHKs4UUm0m2fAvMJOUTHvWCm9VXHlJNsuKhFavIlnSmNwlwWXoLILM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731455889; c=relaxed/simple;
	bh=zNhMSXygoM1kPUsw+PeD2yG3RSGL00Kl+ar0B/d338s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fc1vATVd/HsTfZX6mvliTP6gGhGj9/ex3U8nI56SCv4SviHx5al/u0lRZ37KgyiDzOhEPvYwf5Y1VdcLI7P8ueZLUJCMquSV7c8dc8sMIIDr8E7sTY/hfJZcLwHWkcvrgpKpIl5OHFl8p5y6KGyRWHprlKnHrO0OgDqe2hVlp28=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QJP5bAED; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QJP5bAED"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE7C8C4CED0;
	Tue, 12 Nov 2024 23:58:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1731455888;
	bh=zNhMSXygoM1kPUsw+PeD2yG3RSGL00Kl+ar0B/d338s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=QJP5bAEDpopWA2qg6DJMFz3z/4wj7CZppxTojZ3FzEzIBUbnPU3e/IOkKIyEx58C2
	 UJFVJwAUJ20HAkfjPxb3baSK5yqpaKwAc1QtzrC9JPC3UEJDbP53pfZc4nBAVeuE0+
	 OMl++mUM1nIH6lX1+qZ7f767SrWrfUEJZozZ3flKEBSVgwuLMkoAq2e4R3S+Okdp49
	 vJTf1n4fi+b/qStNglDDIxOvrfKwbyRYi7hduP6YVDtlOK4/5NBGzlf3BP2XVDvIH/
	 1yB4QVywCuWChqv78Fpz9n7vfiLp+r6+MeVsO7WuctROutSvFbfNx9lFbJk/c9iGdT
	 0PLswrU7pKvNA==
Date: Tue, 12 Nov 2024 15:58:08 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org, cem@kernel.org
Subject: Re: [PATCH 3/3] xfs: prevent mount and log shutdown race
Message-ID: <20241112235808.GI9438@frogsfrogsfrogs>
References: <20241112221920.1105007-1-david@fromorbit.com>
 <20241112221920.1105007-4-david@fromorbit.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241112221920.1105007-4-david@fromorbit.com>

On Wed, Nov 13, 2024 at 09:05:16AM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> I recently had an fstests hang where there were two internal tasks
> stuck like so:
> 
> [ 6559.010870] task:kworker/24:45   state:D stack:12152 pid:631308 tgid:631308 ppid:2      flags:0x00004000
> [ 6559.016984] Workqueue: xfs-buf/dm-2 xfs_buf_ioend_work
> [ 6559.020349] Call Trace:
> [ 6559.022002]  <TASK>
> [ 6559.023426]  __schedule+0x650/0xb10
> [ 6559.025734]  schedule+0x6d/0xf0
> [ 6559.027835]  schedule_timeout+0x31/0x180
> [ 6559.030582]  wait_for_common+0x10c/0x1e0
> [ 6559.033495]  wait_for_completion+0x1d/0x30
> [ 6559.036463]  __flush_workqueue+0xeb/0x490
> [ 6559.039479]  ? mempool_alloc_slab+0x15/0x20
> [ 6559.042537]  xlog_cil_force_seq+0xa1/0x2f0
> [ 6559.045498]  ? bio_alloc_bioset+0x1d8/0x510
> [ 6559.048578]  ? submit_bio_noacct+0x2f2/0x380
> [ 6559.051665]  ? xlog_force_shutdown+0x3b/0x170
> [ 6559.054819]  xfs_log_force+0x77/0x230
> [ 6559.057455]  xlog_force_shutdown+0x3b/0x170
> [ 6559.060507]  xfs_do_force_shutdown+0xd4/0x200
> [ 6559.063798]  ? xfs_buf_rele+0x1bd/0x580
> [ 6559.066541]  xfs_buf_ioend_handle_error+0x163/0x2e0
> [ 6559.070099]  xfs_buf_ioend+0x61/0x200
> [ 6559.072728]  xfs_buf_ioend_work+0x15/0x20
> [ 6559.075706]  process_scheduled_works+0x1d4/0x400
> [ 6559.078814]  worker_thread+0x234/0x2e0
> [ 6559.081300]  kthread+0x147/0x170
> [ 6559.083462]  ? __pfx_worker_thread+0x10/0x10
> [ 6559.086295]  ? __pfx_kthread+0x10/0x10
> [ 6559.088771]  ret_from_fork+0x3e/0x50
> [ 6559.091153]  ? __pfx_kthread+0x10/0x10
> [ 6559.093624]  ret_from_fork_asm+0x1a/0x30
> [ 6559.096227]  </TASK>
> 
> [ 6559.109304] Workqueue: xfs-cil/dm-2 xlog_cil_push_work
> [ 6559.112673] Call Trace:
> [ 6559.114333]  <TASK>
> [ 6559.115760]  __schedule+0x650/0xb10
> [ 6559.118084]  schedule+0x6d/0xf0
> [ 6559.120175]  schedule_timeout+0x31/0x180
> [ 6559.122776]  ? call_rcu+0xee/0x2f0
> [ 6559.125034]  __down_common+0xbe/0x1f0
> [ 6559.127470]  __down+0x1d/0x30
> [ 6559.129458]  down+0x48/0x50
> [ 6559.131343]  ? xfs_buf_item_unpin+0x8d/0x380
> [ 6559.134213]  xfs_buf_lock+0x3d/0xe0
> [ 6559.136544]  xfs_buf_item_unpin+0x8d/0x380
> [ 6559.139253]  xlog_cil_committed+0x287/0x520
> [ 6559.142019]  ? sched_clock+0x10/0x30
> [ 6559.144384]  ? sched_clock_cpu+0x10/0x190
> [ 6559.147039]  ? psi_group_change+0x48/0x310
> [ 6559.149735]  ? _raw_spin_unlock+0xe/0x30
> [ 6559.152340]  ? finish_task_switch+0xbc/0x310
> [ 6559.155163]  xlog_cil_process_committed+0x6d/0x90
> [ 6559.158265]  xlog_state_shutdown_callbacks+0x53/0x110
> [ 6559.161564]  ? xlog_cil_push_work+0xa70/0xaf0
> [ 6559.164441]  xlog_state_release_iclog+0xba/0x1b0
> [ 6559.167483]  xlog_cil_push_work+0xa70/0xaf0
> [ 6559.170260]  process_scheduled_works+0x1d4/0x400
> [ 6559.173286]  worker_thread+0x234/0x2e0
> [ 6559.175779]  kthread+0x147/0x170
> [ 6559.177933]  ? __pfx_worker_thread+0x10/0x10
> [ 6559.180748]  ? __pfx_kthread+0x10/0x10
> [ 6559.183231]  ret_from_fork+0x3e/0x50
> [ 6559.185601]  ? __pfx_kthread+0x10/0x10
> [ 6559.188092]  ret_from_fork_asm+0x1a/0x30
> [ 6559.190692]  </TASK>
> 
> This is an ABBA deadlock where buffer IO completion is triggering a
> forced shutdown with the buffer lock held. It is waiting for the CIL
> to flush as part of the log force. The CIL flush is blocked doing
> shutdown processing of all it's objects, trying to unpin a buffer
> item. That requires taking the buffer lock....
> 
> For the CIL to be doing shutdown processing, the log must be marked
> with XLOG_IO_ERROR, but that doesn't happen until after the log
> force is issued. Hence for xfs_do_force_shutdown() to be forcing
> the log on a shut down log, we must have had a racing
> xlog_force_shutdown and xfs_force_shutdown like so:
> 
> p0			p1			CIL push
> 
>    			<holds buffer lock>
> xlog_force_shutdown
>   xfs_log_force
>    test_and_set_bit(XLOG_IO_ERROR)
>    						xlog_state_release_iclog()
> 						  sees XLOG_IO_ERROR
> 						  xlog_state_shutdown_callbacks
> 						    ....
> 						    xfs_buf_item_unpin
> 						    xfs_buf_lock
> 						    <blocks on buffer p1 holds>
> 
>    			xfs_force_shutdown
> 			  xfs_set_shutdown(mp) wins
> 			    xlog_force_shutdown
> 			      xfs_log_force
> 			        <blocks on CIL push>
> 
>   xfs_set_shutdown(mp) fails
>   <shuts down rest of log>

Huh.  I wonder, what happens today if there are multiple threads all
trying to shut down the log?  Same thing?  I guess we've never really
gone Farmer Brown's Bad Day[1] on this part of the fs.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

[1] https://www.gocomics.com/calvinandhobbes/1993/04/11

> The deadlock can be mitigated by avoiding the log force on the
> second pass through xlog_force_shutdown. Do this by adding another
> atomic state bit (XLOG_OP_PENDING_SHUTDOWN) that is set on entry to
> xlog_force_shutdown() but doesn't mark the log as shutdown.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_log.c      | 11 +++++++++++
>  fs/xfs/xfs_log_priv.h |  1 +
>  2 files changed, 12 insertions(+)
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index 26b2f5887b88..05daad8a8d34 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -3455,6 +3455,16 @@ xlog_force_shutdown(
>  	if (!log)
>  		return false;
>  
> +	/*
> +	 * Ensure that there is only ever one log shutdown being processed.
> +	 * If we allow the log force below on a second pass after shutting
> +	 * down the log, we risk deadlocking the CIL push as it may require
> +	 * locks on objects the current shutdown context holds (e.g. taking
> +	 * buffer locks to abort buffers on last unpin of buf log items).
> +	 */
> +	if (test_and_set_bit(XLOG_SHUTDOWN_STARTED, &log->l_opstate))
> +		return false;
> +
>  	/*
>  	 * Flush all the completed transactions to disk before marking the log
>  	 * being shut down. We need to do this first as shutting down the log
> @@ -3487,6 +3497,7 @@ xlog_force_shutdown(
>  	spin_lock(&log->l_icloglock);
>  	if (test_and_set_bit(XLOG_IO_ERROR, &log->l_opstate)) {
>  		spin_unlock(&log->l_icloglock);
> +		ASSERT(0);
>  		return false;
>  	}
>  	spin_unlock(&log->l_icloglock);
> diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
> index b8778a4fd6b6..f3d78869e5e5 100644
> --- a/fs/xfs/xfs_log_priv.h
> +++ b/fs/xfs/xfs_log_priv.h
> @@ -458,6 +458,7 @@ struct xlog {
>  #define XLOG_IO_ERROR		2	/* log hit an I/O error, and being
>  				   shutdown */
>  #define XLOG_TAIL_WARN		3	/* log tail verify warning issued */
> +#define XLOG_SHUTDOWN_STARTED	4	/* xlog_force_shutdown() exclusion */
>  
>  static inline bool
>  xlog_recovery_needed(struct xlog *log)
> -- 
> 2.45.2
> 
> 
