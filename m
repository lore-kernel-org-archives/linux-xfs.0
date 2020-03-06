Return-Path: <SRS0=P3J0=4X=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DCB49C10DCE
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Mar 2020 17:15:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AB51E2051A
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Mar 2020 17:15:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ajziEu2o"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725935AbgCFRPx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 6 Mar 2020 12:15:53 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:51703 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726162AbgCFRPx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 6 Mar 2020 12:15:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583514951;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=7gbaDWA0VP4hXDqje0J3ks+03vWOSfiPfaQfo1pUjw8=;
        b=ajziEu2oa2RrsMyZPMYfvQVPMscVm+GTtmPddf3c9GTPgpjVUS4cUK6IyW61r77ssoyklN
        SQJau4LSCk9EeUgvLgfo2+EzUXQYezfJ2zCrfJp6WB3o5vohiWwLX4I01RMWchIUNpca7w
        uwZ8vImIzMk5Wrr+VqG3z6SP7LFZ6eg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-331-XQ0xB1llPeqXxIGmxwbU5A-1; Fri, 06 Mar 2020 12:15:49 -0500
X-MC-Unique: XQ0xB1llPeqXxIGmxwbU5A-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4714513F5;
        Fri,  6 Mar 2020 17:15:48 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id B5D065D9CD;
        Fri,  6 Mar 2020 17:15:47 +0000 (UTC)
Date:   Fri, 6 Mar 2020 12:15:45 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org, Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 7/7] xfs: kill XLOG_STATE_IOERROR
Message-ID: <20200306171545.GJ2773@bfoster>
References: <20200306143137.236478-1-hch@lst.de>
 <20200306143137.236478-8-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200306143137.236478-8-hch@lst.de>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Mar 06, 2020 at 07:31:37AM -0700, Christoph Hellwig wrote:
> Just check the shutdown flag in struct xlog, instead of replicating the
> information into each iclog and checking it there.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---

Most of the code seems Ok to me, but as I work through this series I'm
starting to have a harder time seeing the value of removing the error
state in the current code. Of course there's obvious value of less code
and whatnot, but the state code that's being removed is mostly busted
code or very simple (i.e. the shutdown helper). In contrast, all of
these checks that remain sprinkled throughout the log code change
specific iclog checks into broader state checks where we now have to
consider what new racing might or might not occur, etc.

In the end the fs is busted and we're shutting down, but at the same
time shutdown has consistently been riddled with subtle
race/locking/state bugs that are low impact but quite annoying to track
down. I do see value in simplifying the log error handling overall as
the previous patches start to do, but ISTM that should be the primary
goal here. IOW, to simplify the bigger picture logic first to the point
where this patch should be much, much smaller than it is.

If we were to first significantly reduce the number of error state
checks required throughout this code (i.e. reduced to the minimum
critical points necessary that ensure we don't do more log I/O or other
"bad things"), _then_ I see the value of a patch to kill off the error
state. Until we get to that point, this kind of strikes me as
rejiggering complexity around. For example, things like how
xlog_state_do_callback() passes ioerror to
xlog_state_iodone_process_iclog(), which assigns it based on shutdown
state, only for the caller to also check the shutdown state again are
indication that more cleanup is in order before killing off the state.

Brian

>  fs/xfs/xfs_log.c      | 95 +++++++++++++++----------------------------
>  fs/xfs/xfs_log_cil.c  |  2 +-
>  fs/xfs/xfs_log_priv.h |  1 -
>  3 files changed, 34 insertions(+), 64 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index fae5107099b1..1bcd5c735d6b 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -583,7 +583,7 @@ xlog_state_release_iclog(
>  {
>  	lockdep_assert_held(&log->l_icloglock);
>  
> -	if (iclog->ic_state == XLOG_STATE_IOERROR)
> +	if (XLOG_FORCED_SHUTDOWN(log))
>  		return -EIO;
>  
>  	if (atomic_dec_and_test(&iclog->ic_refcnt) &&
> @@ -604,11 +604,11 @@ xfs_log_release_iclog(
>  	struct xlog		*log = mp->m_log;
>  	bool			sync;
>  
> -	if (iclog->ic_state == XLOG_STATE_IOERROR)
> +	if (XLOG_FORCED_SHUTDOWN(log))
>  		goto error;
>  
>  	if (atomic_dec_and_lock(&iclog->ic_refcnt, &log->l_icloglock)) {
> -		if (iclog->ic_state == XLOG_STATE_IOERROR) {
> +		if (XLOG_FORCED_SHUTDOWN(log)) {
>  			spin_unlock(&log->l_icloglock);
>  			goto error;
>  		}
> @@ -914,7 +914,7 @@ xfs_log_write_unmount_record(
>  	error = xlog_write(log, &vec, tic, &lsn, NULL, flags);
>  	/*
>  	 * At this point, we're umounting anyway, so there's no point in
> -	 * transitioning log state to IOERROR. Just continue...
> +	 * transitioning log state to IO_ERROR. Just continue...
>  	 */
>  out_err:
>  	if (error)
> @@ -1737,7 +1737,7 @@ xlog_write_iclog(
>  	 * across the log IO to archieve that.
>  	 */
>  	down(&iclog->ic_sema);
> -	if (unlikely(iclog->ic_state == XLOG_STATE_IOERROR)) {
> +	if (unlikely(XLOG_FORCED_SHUTDOWN(log))) {
>  		/*
>  		 * It would seem logical to return EIO here, but we rely on
>  		 * the log state machine to propagate I/O errors instead of
> @@ -2721,6 +2721,17 @@ xlog_state_iodone_process_iclog(
>  	xfs_lsn_t		lowest_lsn;
>  	xfs_lsn_t		header_lsn;
>  
> +	/*
> +	 * Between marking a filesystem SHUTDOWN and stopping the log, we do
> +	 * flush all iclogs to disk (if there wasn't a log I/O error).  So, we
> +	 * do want things to go smoothly in case of just a SHUTDOWN w/o a
> +	 * LOG_IO_ERROR.
> +	 */
> +	if (XLOG_FORCED_SHUTDOWN(log)) {
> +		*ioerror = true;
> +		return false;
> +	}
> +
>  	switch (iclog->ic_state) {
>  	case XLOG_STATE_ACTIVE:
>  	case XLOG_STATE_DIRTY:
> @@ -2728,15 +2739,6 @@ xlog_state_iodone_process_iclog(
>  		 * Skip all iclogs in the ACTIVE & DIRTY states:
>  		 */
>  		return false;
> -	case XLOG_STATE_IOERROR:
> -		/*
> -		 * Between marking a filesystem SHUTDOWN and stopping the log,
> -		 * we do flush all iclogs to disk (if there wasn't a log I/O
> -		 * error). So, we do want things to go smoothly in case of just
> -		 * a SHUTDOWN w/o a LOG_IO_ERROR.
> -		 */
> -		*ioerror = true;
> -		return false;
>  	case XLOG_STATE_DONE_SYNC:
>  		/*
>  		 * Now that we have an iclog that is in the DONE_SYNC state, do
> @@ -2830,7 +2832,7 @@ xlog_state_do_callback(
>  				break;
>  
>  			if (iclog->ic_state != XLOG_STATE_CALLBACK &&
> -			    iclog->ic_state != XLOG_STATE_IOERROR) {
> +			    !XLOG_FORCED_SHUTDOWN(log)) {
>  				iclog = iclog->ic_next;
>  				continue;
>  			}
> @@ -2856,7 +2858,7 @@ xlog_state_do_callback(
>  	} while (!ioerror && cycled_icloglock);
>  
>  	if (log->l_iclog->ic_state == XLOG_STATE_ACTIVE ||
> -	    log->l_iclog->ic_state == XLOG_STATE_IOERROR)
> +	    XLOG_FORCED_SHUTDOWN(log))
>  		wake_up_all(&log->l_flush_wait);
>  
>  	spin_unlock(&log->l_icloglock);
> @@ -3202,7 +3204,7 @@ xfs_log_force(
>  
>  	spin_lock(&log->l_icloglock);
>  	iclog = log->l_iclog;
> -	if (iclog->ic_state == XLOG_STATE_IOERROR)
> +	if (XLOG_FORCED_SHUTDOWN(log))
>  		goto out_error;
>  
>  	if (iclog->ic_state == XLOG_STATE_DIRTY ||
> @@ -3259,11 +3261,11 @@ xfs_log_force(
>  	if (!(flags & XFS_LOG_SYNC))
>  		goto out_unlock;
>  
> -	if (iclog->ic_state == XLOG_STATE_IOERROR)
> +	if (XLOG_FORCED_SHUTDOWN(log))
>  		goto out_error;
>  	XFS_STATS_INC(mp, xs_log_force_sleep);
>  	xlog_wait(&iclog->ic_force_wait, &log->l_icloglock);
> -	if (iclog->ic_state == XLOG_STATE_IOERROR)
> +	if (XLOG_FORCED_SHUTDOWN(log))
>  		return -EIO;
>  	return 0;
>  
> @@ -3288,7 +3290,7 @@ __xfs_log_force_lsn(
>  
>  	spin_lock(&log->l_icloglock);
>  	iclog = log->l_iclog;
> -	if (iclog->ic_state == XLOG_STATE_IOERROR)
> +	if (XLOG_FORCED_SHUTDOWN(log))
>  		goto out_error;
>  
>  	while (be64_to_cpu(iclog->ic_header.h_lsn) != lsn) {
> @@ -3338,12 +3340,12 @@ __xfs_log_force_lsn(
>  	     iclog->ic_state == XLOG_STATE_DIRTY))
>  		goto out_unlock;
>  
> -	if (iclog->ic_state == XLOG_STATE_IOERROR)
> +	if (XLOG_FORCED_SHUTDOWN(log))
>  		goto out_error;
>  
>  	XFS_STATS_INC(mp, xs_log_force_sleep);
>  	xlog_wait(&iclog->ic_force_wait, &log->l_icloglock);
> -	if (iclog->ic_state == XLOG_STATE_IOERROR)
> +	if (XLOG_FORCED_SHUTDOWN(log))
>  		return -EIO;
>  	return 0;
>  
> @@ -3407,7 +3409,7 @@ xlog_state_want_sync(
>  		xlog_state_switch_iclogs(log, iclog, 0);
>  	} else {
>  		ASSERT(iclog->ic_state == XLOG_STATE_WANT_SYNC ||
> -		       iclog->ic_state == XLOG_STATE_IOERROR);
> +		       XLOG_FORCED_SHUTDOWN(log));
>  	}
>  }
>  
> @@ -3774,34 +3776,6 @@ xlog_verify_iclog(
>  }	/* xlog_verify_iclog */
>  #endif
>  
> -/*
> - * Mark all iclogs IOERROR. l_icloglock is held by the caller.
> - */
> -STATIC int
> -xlog_state_ioerror(
> -	struct xlog	*log)
> -{
> -	xlog_in_core_t	*iclog, *ic;
> -
> -	iclog = log->l_iclog;
> -	if (iclog->ic_state != XLOG_STATE_IOERROR) {
> -		/*
> -		 * Mark all the incore logs IOERROR.
> -		 * From now on, no log flushes will result.
> -		 */
> -		ic = iclog;
> -		do {
> -			ic->ic_state = XLOG_STATE_IOERROR;
> -			ic = ic->ic_next;
> -		} while (ic != iclog);
> -		return 0;
> -	}
> -	/*
> -	 * Return non-zero, if state transition has already happened.
> -	 */
> -	return 1;
> -}
> -
>  /*
>   * This is called from xfs_force_shutdown, when we're forcibly
>   * shutting down the filesystem, typically because of an IO error.
> @@ -3823,10 +3797,8 @@ xfs_log_force_umount(
>  	struct xfs_mount	*mp,
>  	int			logerror)
>  {
> -	struct xlog	*log;
> -	int		retval;
> -
> -	log = mp->m_log;
> +	struct xlog		*log = mp->m_log;
> +	int			retval = 0;
>  
>  	/*
>  	 * If this happens during log recovery, don't worry about
> @@ -3844,10 +3816,8 @@ xfs_log_force_umount(
>  	 * Somebody could've already done the hard work for us.
>  	 * No need to get locks for this.
>  	 */
> -	if (logerror && log->l_iclog->ic_state == XLOG_STATE_IOERROR) {
> -		ASSERT(XLOG_FORCED_SHUTDOWN(log));
> +	if (logerror && XLOG_FORCED_SHUTDOWN(log))
>  		return 1;
> -	}
>  
>  	/*
>  	 * Flush all the completed transactions to disk before marking the log
> @@ -3869,11 +3839,13 @@ xfs_log_force_umount(
>  		mp->m_sb_bp->b_flags |= XBF_DONE;
>  
>  	/*
> -	 * Mark the log and the iclogs with IO error flags to prevent any
> -	 * further log IO from being issued or completed.
> +	 * Mark the log as shut down to prevent any further log IO from being
> +	 * issued or completed.  Return non-zero if log IO_ERROR transition had
> +	 * already happened so that the caller can skip further processing.
>  	 */
> +	if (XLOG_FORCED_SHUTDOWN(log))
> +		retval = 1;
>  	log->l_flags |= XLOG_IO_ERROR;
> -	retval = xlog_state_ioerror(log);
>  	spin_unlock(&log->l_icloglock);
>  
>  	/*
> @@ -3897,7 +3869,6 @@ xfs_log_force_umount(
>  	spin_unlock(&log->l_cilp->xc_push_lock);
>  	xlog_state_do_callback(log);
>  
> -	/* return non-zero if log IOERROR transition had already happened */
>  	return retval;
>  }
>  
> diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
> index b5c4a45c208c..41a45d75a2d0 100644
> --- a/fs/xfs/xfs_log_cil.c
> +++ b/fs/xfs/xfs_log_cil.c
> @@ -846,7 +846,7 @@ xlog_cil_push(
>  		goto out_abort;
>  
>  	spin_lock(&commit_iclog->ic_callback_lock);
> -	if (commit_iclog->ic_state == XLOG_STATE_IOERROR) {
> +	if (XLOG_FORCED_SHUTDOWN(log)) {
>  		spin_unlock(&commit_iclog->ic_callback_lock);
>  		goto out_abort;
>  	}
> diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
> index b192c5a9f9fd..fd4c913ee7e6 100644
> --- a/fs/xfs/xfs_log_priv.h
> +++ b/fs/xfs/xfs_log_priv.h
> @@ -47,7 +47,6 @@ enum xlog_iclog_state {
>  	XLOG_STATE_DONE_SYNC,	/* Done syncing to disk */
>  	XLOG_STATE_CALLBACK,	/* Callback functions now */
>  	XLOG_STATE_DIRTY,	/* Dirty IC log, not ready for ACTIVE status */
> -	XLOG_STATE_IOERROR,	/* IO error happened in sync'ing log */
>  };
>  
>  /*
> -- 
> 2.24.1
> 

