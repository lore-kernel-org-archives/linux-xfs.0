Return-Path: <SRS0=TKSY=YI=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68DBEC10F14
	for <linux-xfs@archiver.kernel.org>; Tue, 15 Oct 2019 17:09:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3EDFF2084B
	for <linux-xfs@archiver.kernel.org>; Tue, 15 Oct 2019 17:09:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727739AbfJORJl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 15 Oct 2019 13:09:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33232 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726470AbfJORJl (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 15 Oct 2019 13:09:41 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 054A4308FBAC;
        Tue, 15 Oct 2019 17:09:41 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 9F93160D5C;
        Tue, 15 Oct 2019 17:09:40 +0000 (UTC)
Date:   Tue, 15 Oct 2019 13:09:38 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 8/8] xfs: remove the XLOG_STATE_DO_CALLBACK state
Message-ID: <20191015170938.GJ36108@bfoster>
References: <20191009142748.18005-1-hch@lst.de>
 <20191009142748.18005-9-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191009142748.18005-9-hch@lst.de>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.43]); Tue, 15 Oct 2019 17:09:41 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Oct 09, 2019 at 04:27:48PM +0200, Christoph Hellwig wrote:
> XLOG_STATE_DO_CALLBACK is only entered through XLOG_STATE_DONE_SYNC
> and just used in a single debug check.  Remove the flag and thus
> simplify the calling conventions for xlog_state_do_callback and
> xlog_state_iodone_process_iclog.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_log.c      | 76 +++++++------------------------------------
>  fs/xfs/xfs_log_priv.h |  1 -
>  2 files changed, 11 insertions(+), 66 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index 001a9586cb56..d158b6d56a26 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -2750,7 +2750,6 @@ static bool
>  xlog_state_iodone_process_iclog(
>  	struct xlog		*log,
>  	struct xlog_in_core	*iclog,
> -	struct xlog_in_core	*completed_iclog,
>  	bool			*ioerror)
>  {
>  	xfs_lsn_t		lowest_lsn;
> @@ -2768,17 +2767,16 @@ xlog_state_iodone_process_iclog(
>  		 * Between marking a filesystem SHUTDOWN and stopping the log,
>  		 * we do flush all iclogs to disk (if there wasn't a log I/O
>  		 * error). So, we do want things to go smoothly in case of just
> -		 * a SHUTDOWN  w/o a LOG_IO_ERROR.
> +		 * a SHUTDOWN w/o a LOG_IO_ERROR.
>  		 */
>  		*ioerror = true;
>  		return false;
>  	case XLOG_STATE_DONE_SYNC:
> -	case XLOG_STATE_DO_CALLBACK:
>  		/*
> -		 * Now that we have an iclog that is in either the DO_CALLBACK
> -		 * or DONE_SYNC states, do one more check here to see if we have
> -		 * chased our tail around.  If this is not the lowest lsn iclog,
> -		 * then we will leave it for another completion to process.
> +		 * Now that we have an iclog that is in the DONE_SYNC state, do
> +		 * one more check here to see if we have chased our tail around.
> +		 * If this is not the lowest lsn iclog, then we will leave it
> +		 * for another completion to process.
>  		 */
>  		header_lsn = be64_to_cpu(iclog->ic_header.h_lsn);
>  		lowest_lsn = xlog_get_lowest_lsn(log);
> @@ -2789,15 +2787,9 @@ xlog_state_iodone_process_iclog(
>  	default:
>  		/*
>  		 * Can only perform callbacks in order.  Since this iclog is not
> -		 * in the DONE_SYNC or DO_CALLBACK states, we skip the rest and
> -		 * just try to clean up.  If we set our iclog to DO_CALLBACK, we
> -		 * will not process it when we retry since a previous iclog is
> -		 * in the CALLBACK and the state cannot change since we are
> -		 * holding l_icloglock.
> +		 * in the DONE_SYNC state, we skip the rest and just try to
> +		 * clean up.
>  		 */
> -		if (completed_iclog &&
> -		    (completed_iclog->ic_state == XLOG_STATE_DONE_SYNC))
> -			completed_iclog->ic_state = XLOG_STATE_DO_CALLBACK;
>  		return true;
>  	}
>  }
> @@ -2838,54 +2830,13 @@ xlog_state_do_iclog_callbacks(
>  	spin_unlock(&iclog->ic_callback_lock);
>  }
>  
> -#ifdef DEBUG
> -/*
> - * Make one last gasp attempt to see if iclogs are being left in limbo.  If the
> - * above loop finds an iclog earlier than the current iclog and in one of the
> - * syncing states, the current iclog is put into DO_CALLBACK and the callbacks
> - * are deferred to the completion of the earlier iclog. Walk the iclogs in order
> - * and make sure that no iclog is in DO_CALLBACK unless an earlier iclog is in
> - * one of the syncing states.
> - */
> -static void
> -xlog_state_callback_check_state(
> -	struct xlog		*log)
> -{
> -	struct xlog_in_core	*first_iclog = log->l_iclog;
> -	struct xlog_in_core	*iclog = first_iclog;
> -
> -	do {
> -		ASSERT(iclog->ic_state != XLOG_STATE_DO_CALLBACK);
> -		/*
> -		 * Terminate the loop if iclogs are found in states
> -		 * which will cause other threads to clean up iclogs.
> -		 *
> -		 * SYNCING - i/o completion will go through logs
> -		 * DONE_SYNC - interrupt thread should be waiting for
> -		 *              l_icloglock
> -		 * IOERROR - give up hope all ye who enter here
> -		 */
> -		if (iclog->ic_state == XLOG_STATE_WANT_SYNC ||
> -		    iclog->ic_state == XLOG_STATE_SYNCING ||
> -		    iclog->ic_state == XLOG_STATE_DONE_SYNC ||
> -		    iclog->ic_state == XLOG_STATE_IOERROR )
> -			break;
> -		iclog = iclog->ic_next;
> -	} while (first_iclog != iclog);
> -}
> -#else
> -#define xlog_state_callback_check_state(l)	((void)0)
> -#endif
> -
>  STATIC void
>  xlog_state_do_callback(
>  	struct xlog		*log,
> -	bool			aborted,
> -	struct xlog_in_core	*ciclog)
> +	bool			aborted)
>  {
>  	struct xlog_in_core	*iclog;
>  	struct xlog_in_core	*first_iclog;
> -	bool			did_callbacks = false;
>  	bool			cycled_icloglock;
>  	bool			ioerror;
>  	int			flushcnt = 0;
> @@ -2909,7 +2860,7 @@ xlog_state_do_callback(
>  
>  		do {
>  			if (xlog_state_iodone_process_iclog(log, iclog,
> -							ciclog, &ioerror))
> +							&ioerror))
>  				break;
>  
>  			if (iclog->ic_state != XLOG_STATE_CALLBACK &&
> @@ -2929,8 +2880,6 @@ xlog_state_do_callback(
>  			iclog = iclog->ic_next;
>  		} while (first_iclog != iclog);
>  
> -		did_callbacks |= cycled_icloglock;
> -
>  		if (repeats > 5000) {
>  			flushcnt += repeats;
>  			repeats = 0;
> @@ -2940,9 +2889,6 @@ xlog_state_do_callback(
>  		}
>  	} while (!ioerror && cycled_icloglock);
>  
> -	if (did_callbacks)
> -		xlog_state_callback_check_state(log);
> -
>  	if (log->l_iclog->ic_state == XLOG_STATE_ACTIVE ||
>  	    log->l_iclog->ic_state == XLOG_STATE_IOERROR)
>  		wake_up_all(&log->l_flush_wait);
> @@ -2993,7 +2939,7 @@ xlog_state_done_syncing(
>  	 */
>  	wake_up_all(&iclog->ic_write_wait);
>  	spin_unlock(&log->l_icloglock);
> -	xlog_state_do_callback(log, aborted, iclog);	/* also cleans log */
> +	xlog_state_do_callback(log, aborted);	/* also cleans log */
>  }	/* xlog_state_done_syncing */
>  
>  
> @@ -3987,7 +3933,7 @@ xfs_log_force_umount(
>  	spin_lock(&log->l_cilp->xc_push_lock);
>  	wake_up_all(&log->l_cilp->xc_commit_wait);
>  	spin_unlock(&log->l_cilp->xc_push_lock);
> -	xlog_state_do_callback(log, true, NULL);
> +	xlog_state_do_callback(log, true);
>  
>  	/* return non-zero if log IOERROR transition had already happened */
>  	return retval;
> diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
> index bf076893f516..4f19375f6592 100644
> --- a/fs/xfs/xfs_log_priv.h
> +++ b/fs/xfs/xfs_log_priv.h
> @@ -45,7 +45,6 @@ enum xlog_iclog_state {
>  	XLOG_STATE_WANT_SYNC,	/* Want to sync this iclog; no more writes */
>  	XLOG_STATE_SYNCING,	/* This IC log is syncing */
>  	XLOG_STATE_DONE_SYNC,	/* Done syncing to disk */
> -	XLOG_STATE_DO_CALLBACK,	/* Process callback functions */
>  	XLOG_STATE_CALLBACK,	/* Callback functions now */
>  	XLOG_STATE_DIRTY,	/* Dirty IC log, not ready for ACTIVE status */
>  	XLOG_STATE_IOERROR,	/* IO error happened in sync'ing log */
> -- 
> 2.20.1
> 
