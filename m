Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 245D9C12002
	for <linux-xfs@archiver.kernel.org>; Wed, 14 Jul 2021 22:00:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0016B613BF
	for <linux-xfs@archiver.kernel.org>; Wed, 14 Jul 2021 22:00:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231154AbhGNWDc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 14 Jul 2021 18:03:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:42018 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229498AbhGNWDc (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 14 Jul 2021 18:03:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 24913613BF;
        Wed, 14 Jul 2021 22:00:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626300040;
        bh=eGBfR+jr54HQvhr5Of9xj/9cfy4uvEqoCkUWIkuREvs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=dNPNQ4EiYgOev+sMPnwLMR/VVf+Dalu1j+sTzpGufNzrRExkOHUasdmfjaJ3jTMzj
         7YZLSktDm5LApqR5o97004gecQl1jbmVfts4nEbMaMmZgodND5iZhP8f8Y8pTcCIdQ
         S4EEGRUGMr2mFVUPwxMfTuUG3MbunDKyDG04ENcZQkYfN/2+H0/qIG58C3lvwshA+5
         zAkWyqAbGDlSndv1kmt7rWlI41oEjbOEN3fTelPbX6NtS9EZFThv9KgIyJCF/m4nlQ
         yxUNVtL9ZW/jhQLQfBseCIO4bccQJWeyXqHnj83Y2GnhZpJcLyVXs0rj+xlP0XB6hn
         2PKTAEk+RJKTg==
Date:   Wed, 14 Jul 2021 15:00:39 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 7/9] xfs: separate out log shutdown callback processing
Message-ID: <20210714220039.GP22402@magnolia>
References: <20210714031958.2614411-1-david@fromorbit.com>
 <20210714031958.2614411-8-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210714031958.2614411-8-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jul 14, 2021 at 01:19:56PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> The iclog callback processing done during a forced log shutdown has
> different logic to normal runtime IO completion callback processing.
> Separate out eh shutdown callbacks into their own function and call

"..out the shutdown callbacks..."

> that from the shutdown code instead.
> 
> We don't need this shutdown specific logic in the normal runtime
> completion code - we'll always run the shutdown version on shutdown,
> and it will do what shutdown needs regardless of whether there are
> racing IO completion callbacks scheduled or in progress. Hence we
> can also simplify the normal IO completion callpath and only abort
> if shutdown occurred while we actively were processing callbacks.
> 
> Further, separating out the IO completion logic from the shutdown
> logic avoids callback race conditions from being triggered by log IO
> completion after a shutdown. IO completion will now only run
> callbacks on iclogs that are in the correct state for a callback to
> be run, avoiding the possibility of running callbacks on a
> referenced iclog that hasn't yet been submitted for IO.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

With the typo fixed, I like this cleanup. :)
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_log.c | 53 ++++++++++++++++++++++++++++++++++--------------
>  1 file changed, 38 insertions(+), 15 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index 302c1ce27974..4d72d9efed7c 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -487,6 +487,32 @@ xfs_log_reserve(
>  	return error;
>  }
>  
> +/*
> + * Run all the pending iclog callbacks and wake log force waiters and iclog
> + * space waiters so they can process the newly set shutdown state. We really
> + * don't care what order we process callbacks here because the log is shut down
> + * and so state cannot change on disk anymore.
> + */
> +static void
> +xlog_state_shutdown_callbacks(
> +	struct xlog		*log)
> +{
> +	struct xlog_in_core	*iclog;
> +	LIST_HEAD(cb_list);
> +
> +	spin_lock(&log->l_icloglock);
> +	iclog = log->l_iclog;
> +	do {
> +		list_splice_init(&iclog->ic_callbacks, &cb_list);
> +		wake_up_all(&iclog->ic_force_wait);
> +	} while ((iclog = iclog->ic_next) != log->l_iclog);
> +
> +	wake_up_all(&log->l_flush_wait);
> +	spin_unlock(&log->l_icloglock);
> +
> +	xlog_cil_process_committed(&cb_list);
> +}
> +
>  static bool
>  __xlog_state_release_iclog(
>  	struct xlog		*log,
> @@ -2762,7 +2788,10 @@ xlog_state_iodone_process_iclog(
>  
>  /*
>   * Loop over all the iclogs, running attached callbacks on them. Return true if
> - * we ran any callbacks, indicating that we dropped the icloglock.
> + * we ran any callbacks, indicating that we dropped the icloglock. We don't need
> + * to handle transient shutdown state here at all because
> + * xlog_state_shutdown_callbacks() will be run to do the necessary shutdown
> + * cleanup of the callbacks.
>   */
>  static bool
>  xlog_state_do_iclog_callbacks(
> @@ -2777,13 +2806,11 @@ xlog_state_do_iclog_callbacks(
>  	do {
>  		LIST_HEAD(cb_list);
>  
> -		if (!xlog_is_shutdown(log)) {
> -			if (xlog_state_iodone_process_iclog(log, iclog))
> -				break;
> -			if (iclog->ic_state != XLOG_STATE_CALLBACK) {
> -				iclog = iclog->ic_next;
> -				continue;
> -			}
> +		if (xlog_state_iodone_process_iclog(log, iclog))
> +			break;
> +		if (iclog->ic_state != XLOG_STATE_CALLBACK) {
> +			iclog = iclog->ic_next;
> +			continue;
>  		}
>  		list_splice_init(&iclog->ic_callbacks, &cb_list);
>  		spin_unlock(&log->l_icloglock);
> @@ -2794,10 +2821,7 @@ xlog_state_do_iclog_callbacks(
>  		ran_callback = true;
>  
>  		spin_lock(&log->l_icloglock);
> -		if (xlog_is_shutdown(log))
> -			wake_up_all(&iclog->ic_force_wait);
> -		else
> -			xlog_state_clean_iclog(log, iclog);
> +		xlog_state_clean_iclog(log, iclog);
>  		iclog = iclog->ic_next;
>  	} while (iclog != first_iclog);
>  
> @@ -2830,8 +2854,7 @@ xlog_state_do_callback(
>  		}
>  	}
>  
> -	if (log->l_iclog->ic_state == XLOG_STATE_ACTIVE ||
> -	    xlog_is_shutdown(log))
> +	if (log->l_iclog->ic_state == XLOG_STATE_ACTIVE)
>  		wake_up_all(&log->l_flush_wait);
>  
>  	spin_unlock(&log->l_icloglock);
> @@ -3764,7 +3787,7 @@ xlog_force_shutdown(
>  	spin_lock(&log->l_cilp->xc_push_lock);
>  	wake_up_all(&log->l_cilp->xc_commit_wait);
>  	spin_unlock(&log->l_cilp->xc_push_lock);
> -	xlog_state_do_callback(log);
> +	xlog_state_shutdown_callbacks(log);
>  
>  	return log_error;
>  }
> -- 
> 2.31.1
> 
