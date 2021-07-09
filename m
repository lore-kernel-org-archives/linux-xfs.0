Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1948FC07E99
	for <linux-xfs@archiver.kernel.org>; Fri,  9 Jul 2021 04:42:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E877E61448
	for <linux-xfs@archiver.kernel.org>; Fri,  9 Jul 2021 04:42:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229610AbhGIEo6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 9 Jul 2021 00:44:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:37902 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229576AbhGIEo5 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 9 Jul 2021 00:44:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E50DE6144A;
        Fri,  9 Jul 2021 04:42:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625805735;
        bh=4KlIcFcSAui7CwyZT14n2Bn4MsZH/jgJkuSBYj5Z/2A=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Wv1A+G/oov97QHA+KxrmVShUAIucGaNYVsotOYF4e4Qekf1o4UabCKDrdpwrx+izQ
         2UmdBP4kSU8deqIZVVcHh5yxnrQzXhhdLXp4+yR81p7mcLwERYgn4hbwWSEJvMejzX
         dAr6QUrNThQXACmRAdYdyloW1RdHImrv45VB9eqWyK+lUS4H5BGflKKvZkfRJ2hqq9
         nr0/HSk1W2GBFnl9T58Muvge3S9nFEacDDGBIMvGdBHZscAf4reNyK5FRTGmfgRM5Y
         IY1A4whdz1NQNnlJptdbqdwZ1q2sV3S2FhpCPPD22hMxiwQvBA5tR7jpbX27kSEOGC
         VGkOSv/0Txwsg==
Date:   Thu, 8 Jul 2021 21:42:14 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 6/9] xfs: reowrk up xlog_state_do_callback
Message-ID: <20210709044214.GY11588@locust>
References: <20210630063813.1751007-1-david@fromorbit.com>
 <20210630063813.1751007-7-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210630063813.1751007-7-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jun 30, 2021 at 04:38:10PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Clean it up a bit by factoring and rearranging some of the code.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_log.c | 99 ++++++++++++++++++++++++++----------------------
>  1 file changed, 53 insertions(+), 46 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index 6c7cfc052135..bb44dcfcae89 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -2758,67 +2758,74 @@ xlog_state_iodone_process_iclog(
>  	}
>  }
>  
> +/*
> + * Loop over all the iclogs, running attached callbacks on them. Return true if
> + * we ran any callbacks, indicating that we dropped the icloglock.
> + */
> +static bool
> +xlog_state_do_iclog_callbacks(
> +	struct xlog		*log)
> +		__releases(&log->l_icloglock)
> +		__acquires(&log->l_icloglock)
> +{
> +	struct xlog_in_core	*iclog = log->l_iclog;
> +	struct xlog_in_core	*first_iclog = NULL;
> +	bool			ran_callback = false;
> +
> +	for (; iclog != first_iclog; iclog = iclog->ic_next) {
> +		LIST_HEAD(cb_list);
> +
> +		if (!first_iclog)
> +			first_iclog = iclog;
> +
> +		if (!xlog_is_shutdown(log)) {
> +			if (xlog_state_iodone_process_iclog(log, iclog))
> +				break;
> +			if (iclog->ic_state != XLOG_STATE_CALLBACK)
> +				continue;
> +		}
> +		list_splice_init(&iclog->ic_callbacks, &cb_list);
> +		spin_unlock(&log->l_icloglock);
> +
> +		trace_xlog_iclog_callbacks_start(iclog, _RET_IP_);
> +		xlog_cil_process_committed(&cb_list);
> +		trace_xlog_iclog_callbacks_done(iclog, _RET_IP_);
> +		ran_callback = true;
> +
> +		spin_lock(&log->l_icloglock);
> +		if (xlog_is_shutdown(log))
> +			wake_up_all(&iclog->ic_force_wait);
> +		else
> +			xlog_state_clean_iclog(log, iclog);
> +	};

Aside from the unnecessary semicolon here...

> +	return ran_callback;
> +}
> +
> +
> +/*
> + * Loop running iclog completion callbacks until there are no more iclogs in a
> + * state that can run callbacks.
> + */
>  STATIC void
>  xlog_state_do_callback(
>  	struct xlog		*log)
>  {
> -	struct xlog_in_core	*iclog;
> -	struct xlog_in_core	*first_iclog;
> -	bool			cycled_icloglock;
>  	int			flushcnt = 0;
>  	int			repeats = 0;
>  
>  	spin_lock(&log->l_icloglock);
> -	do {
> -		repeats++;
> +	while (xlog_state_do_iclog_callbacks(log)) {
> +		if (xlog_is_shutdown(log))
> +			break;
>  
> -		/*
> -		 * Scan all iclogs starting with the one pointed to by the
> -		 * log.  Reset this starting point each time the log is
> -		 * unlocked (during callbacks).
> -		 *
> -		 * Keep looping through iclogs until one full pass is made
> -		 * without running any callbacks.
> -		 */
> -		cycled_icloglock = false;
> -		first_iclog = NULL;
> -		for (iclog = log->l_iclog;
> -		     iclog != first_iclog;
> -		     iclog = iclog->ic_next) {
> -			LIST_HEAD(cb_list);
> -
> -			if (!first_iclog)
> -				first_iclog = iclog;
> -
> -			if (!xlog_is_shutdown(log)) {
> -				if (xlog_state_iodone_process_iclog(log, iclog))
> -					break;
> -				if (iclog->ic_state != XLOG_STATE_CALLBACK)
> -					continue;
> -			}
> -			list_splice_init(&iclog->ic_callbacks, &cb_list);
> -			spin_unlock(&log->l_icloglock);
> -
> -			trace_xlog_iclog_callbacks_start(iclog, _RET_IP_);
> -			xlog_cil_process_committed(&cb_list);
> -			trace_xlog_iclog_callbacks_done(iclog, _RET_IP_);
> -			cycled_icloglock = true;
> -
> -			spin_lock(&log->l_icloglock);
> -			if (xlog_is_shutdown(log))
> -				wake_up_all(&iclog->ic_force_wait);
> -			else
> -				xlog_state_clean_iclog(log, iclog);
> -		};
> -
> -		if (repeats > 5000) {
> +		if (repeats++ > 5000) {
>  			flushcnt += repeats;
>  			repeats = 0;
>  			xfs_warn(log->l_mp,
>  				"%s: possible infinite loop (%d iterations)",
>  				__func__, flushcnt);
>  		}
> -	} while (!xlog_is_shutdown(log) && cycled_icloglock);
> +	};

...and here, this looks like a simple hoist.

With that fixed,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

>  
>  	if (log->l_iclog->ic_state == XLOG_STATE_ACTIVE ||
>  	    xlog_is_shutdown(log))
> -- 
> 2.31.1
> 
