Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C21D6C4338F
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Jul 2021 17:58:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9768360F6E
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Jul 2021 17:58:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229851AbhGZRR4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 26 Jul 2021 13:17:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:38672 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229680AbhGZRR4 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 26 Jul 2021 13:17:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 86D7360F6D;
        Mon, 26 Jul 2021 17:58:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627322304;
        bh=5b93QJ7c4EzO65CUmABrCiP6KAwfALYY9H2iqM3g01A=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=YZzl88Wn6KDY9kbmhadRwXLiGjHCOc02wBvv9hPlsAY33zDOyRHfdvTSpOmDZdFhu
         l04hE8q8qGFSjg56T04cNLUODc8C7mwCS0ZGnHSzS2LwxgMJfX60ohhK0FWroc2/oa
         b++/FPgRX1LRVjdjc9PWRBS8243oY10vdG9G1xibrRy5b2mYmK0fX3NzCryF4ymTb0
         Xy3OOOU3tfLF3M+2IPvm6l9OELLHwaR1+4WKrNSa7xQDJmg+lAjmPUuAEIGaMI0DAq
         ctXEdopSAvM/lsvIvygi1ZbR4pe3yi+Lmuua88u6JF8ZZSwzqo722dfzLDt2K4+Xnu
         SFqKqnfjzMaJg==
Date:   Mon, 26 Jul 2021 10:58:24 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 06/10] xfs: log forces imply data device cache flushes
Message-ID: <20210726175824.GA559212@magnolia>
References: <20210726060716.3295008-1-david@fromorbit.com>
 <20210726060716.3295008-7-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210726060716.3295008-7-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jul 26, 2021 at 04:07:12PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> After fixing the tail_lsn vs cache flush race, generic/482 continued
> to fail in a similar way where cache flushes were missing before
> iclog FUA writes. Tracing of iclog state changes during the fsstress
> workload portion of the test (via xlog_iclog* events) indicated that
> iclog writes were coming from two sources - CIL pushes and log
> forces (due to fsync/O_SYNC operations). All of the cases where a
> recovery problem was triggered indicated that the log force was the
> source of the iclog write that was not preceeded by a cache flush.
> 
> This was an oversight in the modifications made in commit
> eef983ffeae7 ("xfs: journal IO cache flush reductions"). Log forces
> for fsync imply a data device cache flush has been issued if an
> iclog was flushed to disk and is indicated to the caller via the
> log_flushed parameter so they can elide the device cache flush if
> the journal issued one.
> 
> The change in eef983ffeae7 results in iclogs only issuing a cache
> flush if XLOG_ICL_NEED_FLUSH is set on the iclog, but this was not
> added to the iclogs that the log force code flushes to disk. Hence
> log forces are no longer guaranteeing that a cache flush is issued,
> hence opening up a potential on-disk ordering failure.
> 
> Log forces should also set XLOG_ICL_NEED_FUA as well to ensure that
> the actual iclogs it forces to the journal are also on stable
> storage before it returns to the caller.
> 
> This patch introduces the xlog_force_iclog() helper function to
> encapsulate the process of taking a reference to an iclog, switching
> it's state if WANT_SYNC and flushing it to stable storage correctly.

s/it's/its/

With that fixed,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> 
> Both xfs_log_force() and xfs_log_force_lsn() are converted to use
> it, as is xlog_unmount_write() which has an elaborate method of
> doing exactly the same "write this iclog to stable storage"
> operation.
> 
> Further, if the log force code needs to wait on a iclog in the
> WANT_SYNC state, it needs to ensure that iclog also results in a
> cache flush being issued. This covers the case where the iclog
> contains the commit record of the CIL flush that the log force
> triggered, but it hasn't been written yet because there is still an
> active reference to the iclog.
> 
> Note: this whole cache flush whack-a-mole patch is a result of log
> forces still being iclog state centric rather than being CIL
> sequence centric. Most of this nasty code will go away in future
> when log forces are converted to wait on CIL sequence push
> completion rather than iclog completion. With the CIL push algorithm
> guaranteeing that the CIL checkpoint is fully on stable storage when
> it completes, we no longer need to iterate iclogs and push them to
> ensure a CIL sequence push has completed and so all this nasty iclog
> iteration and flushing code will go away.
> 
> Fixes: eef983ffeae7 ("xfs: journal IO cache flush reductions")
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_log.c | 47 ++++++++++++++++++++++++++++++++++-------------
>  1 file changed, 34 insertions(+), 13 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index 7107cf542eda..a1243dfd66ee 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -790,6 +790,7 @@ xlog_force_iclog(
>  	struct xlog_in_core	*iclog)
>  {
>  	atomic_inc(&iclog->ic_refcnt);
> +	iclog->ic_flags |= XLOG_ICL_NEED_FLUSH | XLOG_ICL_NEED_FUA;
>  	if (iclog->ic_state == XLOG_STATE_ACTIVE)
>  		xlog_state_switch_iclogs(iclog->ic_log, iclog, 0);
>  	return xlog_state_release_iclog(iclog->ic_log, iclog, 0);
> @@ -880,7 +881,6 @@ xlog_unmount_write(
>  
>  	spin_lock(&log->l_icloglock);
>  	iclog = log->l_iclog;
> -	iclog->ic_flags |= (XLOG_ICL_NEED_FLUSH | XLOG_ICL_NEED_FUA);
>  	error = xlog_force_iclog(iclog);
>  	xlog_wait_on_iclog(iclog);
>  
> @@ -3217,22 +3217,23 @@ xfs_log_force(
>  				goto out_unlock;
>  		} else {
>  			/*
> -			 * Someone else is writing to this iclog.
> -			 *
> -			 * Use its call to flush out the data.  However, the
> -			 * other thread may not force out this LR, so we mark
> -			 * it WANT_SYNC.
> +			 * Someone else is still writing to this iclog, so we
> +			 * need to ensure that when they release the iclog it
> +			 * gets synced immediately as we may be waiting on it.
>  			 */
>  			xlog_state_switch_iclogs(log, iclog, 0);
>  		}
> -	} else {
> -		/*
> -		 * If the head iclog is not active nor dirty, we just attach
> -		 * ourselves to the head and go to sleep if necessary.
> -		 */
> -		;
>  	}
>  
> +	/*
> +	 * The iclog we are about to wait on may contain the checkpoint pushed
> +	 * by the above xlog_cil_force() call, but it may not have been pushed
> +	 * to disk yet. Like the ACTIVE case above, we need to make sure caches
> +	 * are flushed when this iclog is written.
> +	 */
> +	if (iclog->ic_state == XLOG_STATE_WANT_SYNC)
> +		iclog->ic_flags |= XLOG_ICL_NEED_FLUSH | XLOG_ICL_NEED_FUA;
> +
>  	if (flags & XFS_LOG_SYNC)
>  		return xlog_wait_on_iclog(iclog);
>  out_unlock:
> @@ -3265,7 +3266,8 @@ xlog_force_lsn(
>  			goto out_unlock;
>  	}
>  
> -	if (iclog->ic_state == XLOG_STATE_ACTIVE) {
> +	switch (iclog->ic_state) {
> +	case XLOG_STATE_ACTIVE:
>  		/*
>  		 * We sleep here if we haven't already slept (e.g. this is the
>  		 * first time we've looked at the correct iclog buf) and the
> @@ -3292,6 +3294,25 @@ xlog_force_lsn(
>  			goto out_error;
>  		if (log_flushed)
>  			*log_flushed = 1;
> +		break;
> +	case XLOG_STATE_WANT_SYNC:
> +		/*
> +		 * This iclog may contain the checkpoint pushed by the
> +		 * xlog_cil_force_seq() call, but there are other writers still
> +		 * accessing it so it hasn't been pushed to disk yet. Like the
> +		 * ACTIVE case above, we need to make sure caches are flushed
> +		 * when this iclog is written.
> +		 */
> +		iclog->ic_flags |= XLOG_ICL_NEED_FLUSH | XLOG_ICL_NEED_FUA;
> +		break;
> +	default:
> +		/*
> +		 * The entire checkpoint was written by the CIL force and is on
> +		 * its way to disk already. It will be stable when it
> +		 * completes, so we don't need to manipulate caches here at all.
> +		 * We just need to wait for completion if necessary.
> +		 */
> +		break;
>  	}
>  
>  	if (flags & XFS_LOG_SYNC)
> -- 
> 2.31.1
> 
