Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65D78C4338F
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Jul 2021 17:49:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3EA7260F6B
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Jul 2021 17:49:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231557AbhGZRIc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 26 Jul 2021 13:08:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:36702 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231248AbhGZRI3 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 26 Jul 2021 13:08:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 311CC604AC;
        Mon, 26 Jul 2021 17:48:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627321738;
        bh=6KY8g/djq/Ixos9JId7+NqMUTxmvMS+B8NvOyV+xNp8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OEsVoD0dE4nrKz/sA5be9I2ZJqyep6SBMBbDvKscA6po5noIy3l/xcUGf8cn3++6w
         UfcHcMIWhLfuqrgoM5Un1ehTSRmNKbDdkWTrU/zbEv+GKVLqCwGvgnkegc/IQx1xHl
         Nn49KoSE3jf3KhMQ0LA+vgj5IIbv3l9ujtWC292LkdCM06DZg72I8lYJb3c718FYS2
         R8M7EdGQdYYwkU18QNhh8+VOpcRBWLijG0+IN/8Wm6WX/sjMh6jxv1AuzD0tze/L1V
         YzkI1tQClw9iN6mKzNFAUqZtWQs/0iPmeG/QGk6ktqVd4hP45fcGSTWV4zZyvL1uVE
         Iyw781XTNvvdQ==
Date:   Mon, 26 Jul 2021 10:48:57 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 05/10] xfs: factor out forced iclog flushes
Message-ID: <20210726174857.GX559212@magnolia>
References: <20210726060716.3295008-1-david@fromorbit.com>
 <20210726060716.3295008-6-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210726060716.3295008-6-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jul 26, 2021 at 04:07:11PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> We force iclogs in several places - we need them all to have the
> same cache flush semantics, so start by factoring out the iclog
> force into a common helper.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Looks like a pretty simple hoist.

I also wonder about the removal of the assertion in xlog_unmount_write,
but I /think/ that's ok because at that point we've turned off
everything else that could write the log and forced it, which means that
the log is clean, and therefore all iclogs ought to be in ACTIVE state?

If I got that right,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_log.c | 42 ++++++++++++++++++------------------------
>  1 file changed, 18 insertions(+), 24 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index 1f8c00e40c53..7107cf542eda 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -781,6 +781,20 @@ xfs_log_mount_cancel(
>  	xfs_log_unmount(mp);
>  }
>  
> +/*
> + * Flush out the iclog to disk ensuring that device caches are flushed and
> + * the iclog hits stable storage before any completion waiters are woken.
> + */
> +static inline int
> +xlog_force_iclog(
> +	struct xlog_in_core	*iclog)
> +{
> +	atomic_inc(&iclog->ic_refcnt);
> +	if (iclog->ic_state == XLOG_STATE_ACTIVE)
> +		xlog_state_switch_iclogs(iclog->ic_log, iclog, 0);
> +	return xlog_state_release_iclog(iclog->ic_log, iclog, 0);
> +}
> +
>  /*
>   * Wait for the iclog and all prior iclogs to be written disk as required by the
>   * log force state machine. Waiting on ic_force_wait ensures iclog completions
> @@ -866,18 +880,8 @@ xlog_unmount_write(
>  
>  	spin_lock(&log->l_icloglock);
>  	iclog = log->l_iclog;
> -	atomic_inc(&iclog->ic_refcnt);
> -	if (iclog->ic_state == XLOG_STATE_ACTIVE)
> -		xlog_state_switch_iclogs(log, iclog, 0);
> -	else
> -		ASSERT(iclog->ic_state == XLOG_STATE_WANT_SYNC ||
> -		       iclog->ic_state == XLOG_STATE_IOERROR);
> -	/*
> -	 * Ensure the journal is fully flushed and on stable storage once the
> -	 * iclog containing the unmount record is written.
> -	 */
>  	iclog->ic_flags |= (XLOG_ICL_NEED_FLUSH | XLOG_ICL_NEED_FUA);
> -	error = xlog_state_release_iclog(log, iclog, 0);
> +	error = xlog_force_iclog(iclog);
>  	xlog_wait_on_iclog(iclog);
>  
>  	if (tic) {
> @@ -3204,17 +3208,9 @@ xfs_log_force(
>  		iclog = iclog->ic_prev;
>  	} else if (iclog->ic_state == XLOG_STATE_ACTIVE) {
>  		if (atomic_read(&iclog->ic_refcnt) == 0) {
> -			/*
> -			 * We are the only one with access to this iclog.
> -			 *
> -			 * Flush it out now.  There should be a roundoff of zero
> -			 * to show that someone has already taken care of the
> -			 * roundoff from the previous sync.
> -			 */
> -			atomic_inc(&iclog->ic_refcnt);
> +			/* We have exclusive access to this iclog. */
>  			lsn = be64_to_cpu(iclog->ic_header.h_lsn);
> -			xlog_state_switch_iclogs(log, iclog, 0);
> -			if (xlog_state_release_iclog(log, iclog, 0))
> +			if (xlog_force_iclog(iclog))
>  				goto out_error;
>  
>  			if (be64_to_cpu(iclog->ic_header.h_lsn) != lsn)
> @@ -3292,9 +3288,7 @@ xlog_force_lsn(
>  					&log->l_icloglock);
>  			return -EAGAIN;
>  		}
> -		atomic_inc(&iclog->ic_refcnt);
> -		xlog_state_switch_iclogs(log, iclog, 0);
> -		if (xlog_state_release_iclog(log, iclog, 0))
> +		if (xlog_force_iclog(iclog))
>  			goto out_error;
>  		if (log_flushed)
>  			*log_flushed = 1;
> -- 
> 2.31.1
> 
