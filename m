Return-Path: <SRS0=TKSY=YI=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CAAC3ECE588
	for <linux-xfs@archiver.kernel.org>; Tue, 15 Oct 2019 17:09:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9B4962084B
	for <linux-xfs@archiver.kernel.org>; Tue, 15 Oct 2019 17:09:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727073AbfJORJd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 15 Oct 2019 13:09:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44472 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726470AbfJORJd (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 15 Oct 2019 13:09:33 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 5A86381F13;
        Tue, 15 Oct 2019 17:09:32 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id E3C9660CCD;
        Tue, 15 Oct 2019 17:09:31 +0000 (UTC)
Date:   Tue, 15 Oct 2019 13:09:30 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 7/8] xfs: turn ic_state into an enum
Message-ID: <20191015170930.GI36108@bfoster>
References: <20191009142748.18005-1-hch@lst.de>
 <20191009142748.18005-8-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191009142748.18005-8-hch@lst.de>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.25]); Tue, 15 Oct 2019 17:09:32 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Oct 09, 2019 at 04:27:47PM +0200, Christoph Hellwig wrote:
> ic_state really is a set of different states, even if the values are
> encoded as non-conflicting bits and we sometimes use logical and
> operations to check for them.  Switch all comparisms to check for
> exact values (and use switch statements in a few places to make it
> more clear) and turn the values into an implicitly enumerated enum
> type.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_log.c      | 159 ++++++++++++++++++++----------------------
>  fs/xfs/xfs_log_cil.c  |   2 +-
>  fs/xfs/xfs_log_priv.h |  21 +++---
>  3 files changed, 88 insertions(+), 94 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index 7a429e5dc27c..001a9586cb56 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -584,7 +584,7 @@ xlog_state_release_iclog(
>  {
>  	lockdep_assert_held(&log->l_icloglock);
>  
> -	if (iclog->ic_state & XLOG_STATE_IOERROR)
> +	if (iclog->ic_state == XLOG_STATE_IOERROR)
>  		return -EIO;
>  
>  	if (atomic_dec_and_test(&iclog->ic_refcnt) &&
> @@ -605,7 +605,7 @@ xfs_log_release_iclog(
>  	struct xlog		*log = mp->m_log;
>  	bool			sync;
>  
> -	if (iclog->ic_state & XLOG_STATE_IOERROR) {
> +	if (iclog->ic_state == XLOG_STATE_IOERROR) {
>  		xfs_force_shutdown(mp, SHUTDOWN_LOG_IO_ERROR);
>  		return -EIO;
>  	}
> @@ -975,8 +975,8 @@ xfs_log_unmount_write(xfs_mount_t *mp)
>  #ifdef DEBUG
>  	first_iclog = iclog = log->l_iclog;
>  	do {
> -		if (!(iclog->ic_state & XLOG_STATE_IOERROR)) {
> -			ASSERT(iclog->ic_state & XLOG_STATE_ACTIVE);
> +		if (iclog->ic_state != XLOG_STATE_IOERROR) {
> +			ASSERT(iclog->ic_state == XLOG_STATE_ACTIVE);
>  			ASSERT(iclog->ic_offset == 0);
>  		}
>  		iclog = iclog->ic_next;
> @@ -1003,15 +1003,15 @@ xfs_log_unmount_write(xfs_mount_t *mp)
>  		atomic_inc(&iclog->ic_refcnt);
>  		xlog_state_want_sync(log, iclog);
>  		error =  xlog_state_release_iclog(log, iclog);
> -
> -		if ( ! (   iclog->ic_state == XLOG_STATE_ACTIVE
> -			|| iclog->ic_state == XLOG_STATE_DIRTY
> -			|| iclog->ic_state == XLOG_STATE_IOERROR) ) {
> -
> -				xlog_wait(&iclog->ic_force_wait,
> -							&log->l_icloglock);
> -		} else {
> +		switch (iclog->ic_state) {
> +		case XLOG_STATE_ACTIVE:
> +		case XLOG_STATE_DIRTY:
> +		case XLOG_STATE_IOERROR:
>  			spin_unlock(&log->l_icloglock);
> +			break;
> +		default:
> +			xlog_wait(&iclog->ic_force_wait, &log->l_icloglock);
> +			break;
>  		}
>  	}
>  
> @@ -1301,7 +1301,7 @@ xlog_ioend_work(
>  		 * didn't succeed.
>  		 */
>  		aborted = true;
> -	} else if (iclog->ic_state & XLOG_STATE_IOERROR) {
> +	} else if (iclog->ic_state == XLOG_STATE_IOERROR) {
>  		aborted = true;
>  	}
>  
> @@ -1774,7 +1774,7 @@ xlog_write_iclog(
>  	 * across the log IO to archieve that.
>  	 */
>  	down(&iclog->ic_sema);
> -	if (unlikely(iclog->ic_state & XLOG_STATE_IOERROR)) {
> +	if (unlikely(iclog->ic_state == XLOG_STATE_IOERROR)) {
>  		/*
>  		 * It would seem logical to return EIO here, but we rely on
>  		 * the log state machine to propagate I/O errors instead of
> @@ -2598,7 +2598,7 @@ xlog_state_clean_iclog(
>  	int			changed = 0;
>  
>  	/* Prepare the completed iclog. */
> -	if (!(dirty_iclog->ic_state & XLOG_STATE_IOERROR))
> +	if (dirty_iclog->ic_state != XLOG_STATE_IOERROR)
>  		dirty_iclog->ic_state = XLOG_STATE_DIRTY;
>  
>  	/* Walk all the iclogs to update the ordered active state. */
> @@ -2689,7 +2689,8 @@ xlog_get_lowest_lsn(
>  	xfs_lsn_t		lowest_lsn = 0, lsn;
>  
>  	do {
> -		if (iclog->ic_state & (XLOG_STATE_ACTIVE | XLOG_STATE_DIRTY))
> +		if (iclog->ic_state == XLOG_STATE_ACTIVE ||
> +		    iclog->ic_state == XLOG_STATE_DIRTY)
>  			continue;
>  
>  		lsn = be64_to_cpu(iclog->ic_header.h_lsn);
> @@ -2755,55 +2756,50 @@ xlog_state_iodone_process_iclog(
>  	xfs_lsn_t		lowest_lsn;
>  	xfs_lsn_t		header_lsn;
>  
> -	/* Skip all iclogs in the ACTIVE & DIRTY states */
> -	if (iclog->ic_state & (XLOG_STATE_ACTIVE | XLOG_STATE_DIRTY))
> +	switch (iclog->ic_state) {
> +	case XLOG_STATE_ACTIVE:
> +	case XLOG_STATE_DIRTY:
> +		/*
> +		 * Skip all iclogs in the ACTIVE & DIRTY states:
> +		 */
>  		return false;
> -
> -	/*
> -	 * Between marking a filesystem SHUTDOWN and stopping the log, we do
> -	 * flush all iclogs to disk (if there wasn't a log I/O error). So, we do
> -	 * want things to go smoothly in case of just a SHUTDOWN  w/o a
> -	 * LOG_IO_ERROR.
> -	 */
> -	if (iclog->ic_state & XLOG_STATE_IOERROR) {
> +	case XLOG_STATE_IOERROR:
> +		/*
> +		 * Between marking a filesystem SHUTDOWN and stopping the log,
> +		 * we do flush all iclogs to disk (if there wasn't a log I/O
> +		 * error). So, we do want things to go smoothly in case of just
> +		 * a SHUTDOWN  w/o a LOG_IO_ERROR.
> +		 */
>  		*ioerror = true;
>  		return false;
> -	}
> -
> -	/*
> -	 * Can only perform callbacks in order.  Since this iclog is not in the
> -	 * DONE_SYNC/ DO_CALLBACK state, we skip the rest and just try to clean
> -	 * up.  If we set our iclog to DO_CALLBACK, we will not process it when
> -	 * we retry since a previous iclog is in the CALLBACK and the state
> -	 * cannot change since we are holding the l_icloglock.
> -	 */
> -	if (!(iclog->ic_state &
> -			(XLOG_STATE_DONE_SYNC | XLOG_STATE_DO_CALLBACK))) {
> +	case XLOG_STATE_DONE_SYNC:
> +	case XLOG_STATE_DO_CALLBACK:
> +		/*
> +		 * Now that we have an iclog that is in either the DO_CALLBACK
> +		 * or DONE_SYNC states, do one more check here to see if we have
> +		 * chased our tail around.  If this is not the lowest lsn iclog,
> +		 * then we will leave it for another completion to process.
> +		 */
> +		header_lsn = be64_to_cpu(iclog->ic_header.h_lsn);
> +		lowest_lsn = xlog_get_lowest_lsn(log);
> +		if (lowest_lsn && XFS_LSN_CMP(lowest_lsn, header_lsn) < 0)
> +			return false;
> +		xlog_state_set_callback(log, iclog, header_lsn);
> +		return false;
> +	default:
> +		/*
> +		 * Can only perform callbacks in order.  Since this iclog is not
> +		 * in the DONE_SYNC or DO_CALLBACK states, we skip the rest and
> +		 * just try to clean up.  If we set our iclog to DO_CALLBACK, we
> +		 * will not process it when we retry since a previous iclog is
> +		 * in the CALLBACK and the state cannot change since we are
> +		 * holding l_icloglock.
> +		 */
>  		if (completed_iclog &&
> -		    (completed_iclog->ic_state == XLOG_STATE_DONE_SYNC)) {
> +		    (completed_iclog->ic_state == XLOG_STATE_DONE_SYNC))
>  			completed_iclog->ic_state = XLOG_STATE_DO_CALLBACK;
> -		}
>  		return true;
>  	}
> -
> -	/*
> -	 * We now have an iclog that is in either the DO_CALLBACK or DONE_SYNC
> -	 * states. The other states (WANT_SYNC, SYNCING, or CALLBACK were caught
> -	 * by the above if and are going to clean (i.e. we aren't doing their
> -	 * callbacks) see the above if.
> -	 *
> -	 * We will do one more check here to see if we have chased our tail
> -	 * around. If this is not the lowest lsn iclog, then we will leave it
> -	 * for another completion to process.
> -	 */
> -	header_lsn = be64_to_cpu(iclog->ic_header.h_lsn);
> -	lowest_lsn = xlog_get_lowest_lsn(log);
> -	if (lowest_lsn && XFS_LSN_CMP(lowest_lsn, header_lsn) < 0)
> -		return false;
> -
> -	xlog_state_set_callback(log, iclog, header_lsn);
> -	return false;
> -
>  }
>  
>  /*
> @@ -2850,9 +2846,6 @@ xlog_state_do_iclog_callbacks(
>   * are deferred to the completion of the earlier iclog. Walk the iclogs in order
>   * and make sure that no iclog is in DO_CALLBACK unless an earlier iclog is in
>   * one of the syncing states.
> - *
> - * Note that SYNCING|IOERROR is a valid state so we cannot just check for
> - * ic_state == SYNCING.
>   */
>  static void
>  xlog_state_callback_check_state(
> @@ -2873,7 +2866,7 @@ xlog_state_callback_check_state(
>  		 * IOERROR - give up hope all ye who enter here
>  		 */
>  		if (iclog->ic_state == XLOG_STATE_WANT_SYNC ||
> -		    iclog->ic_state & XLOG_STATE_SYNCING ||
> +		    iclog->ic_state == XLOG_STATE_SYNCING ||
>  		    iclog->ic_state == XLOG_STATE_DONE_SYNC ||
>  		    iclog->ic_state == XLOG_STATE_IOERROR )
>  			break;
> @@ -2919,8 +2912,8 @@ xlog_state_do_callback(
>  							ciclog, &ioerror))
>  				break;
>  
> -			if (!(iclog->ic_state &
> -			      (XLOG_STATE_CALLBACK | XLOG_STATE_IOERROR))) {
> +			if (iclog->ic_state != XLOG_STATE_CALLBACK &&
> +			    iclog->ic_state != XLOG_STATE_IOERROR) {
>  				iclog = iclog->ic_next;
>  				continue;
>  			}
> @@ -2950,7 +2943,8 @@ xlog_state_do_callback(
>  	if (did_callbacks)
>  		xlog_state_callback_check_state(log);
>  
> -	if (log->l_iclog->ic_state & (XLOG_STATE_ACTIVE|XLOG_STATE_IOERROR))
> +	if (log->l_iclog->ic_state == XLOG_STATE_ACTIVE ||
> +	    log->l_iclog->ic_state == XLOG_STATE_IOERROR)
>  		wake_up_all(&log->l_flush_wait);
>  
>  	spin_unlock(&log->l_icloglock);
> @@ -2979,8 +2973,6 @@ xlog_state_done_syncing(
>  
>  	spin_lock(&log->l_icloglock);
>  
> -	ASSERT(iclog->ic_state == XLOG_STATE_SYNCING ||
> -	       iclog->ic_state == XLOG_STATE_IOERROR);
>  	ASSERT(atomic_read(&iclog->ic_refcnt) == 0);
>  
>  	/*
> @@ -2989,8 +2981,10 @@ xlog_state_done_syncing(
>  	 * and none should ever be attempted to be written to disk
>  	 * again.
>  	 */
> -	if (iclog->ic_state != XLOG_STATE_IOERROR)
> +	if (iclog->ic_state == XLOG_STATE_SYNCING)
>  		iclog->ic_state = XLOG_STATE_DONE_SYNC;
> +	else
> +		ASSERT(iclog->ic_state == XLOG_STATE_IOERROR);
>  
>  	/*
>  	 * Someone could be sleeping prior to writing out the next
> @@ -3300,7 +3294,7 @@ xfs_log_force(
>  
>  	spin_lock(&log->l_icloglock);
>  	iclog = log->l_iclog;
> -	if (iclog->ic_state & XLOG_STATE_IOERROR)
> +	if (iclog->ic_state == XLOG_STATE_IOERROR)
>  		goto out_error;
>  
>  	if (iclog->ic_state == XLOG_STATE_DIRTY ||
> @@ -3357,11 +3351,11 @@ xfs_log_force(
>  	if (!(flags & XFS_LOG_SYNC))
>  		goto out_unlock;
>  
> -	if (iclog->ic_state & XLOG_STATE_IOERROR)
> +	if (iclog->ic_state == XLOG_STATE_IOERROR)
>  		goto out_error;
>  	XFS_STATS_INC(mp, xs_log_force_sleep);
>  	xlog_wait(&iclog->ic_force_wait, &log->l_icloglock);
> -	if (iclog->ic_state & XLOG_STATE_IOERROR)
> +	if (iclog->ic_state == XLOG_STATE_IOERROR)
>  		return -EIO;
>  	return 0;
>  
> @@ -3386,7 +3380,7 @@ __xfs_log_force_lsn(
>  
>  	spin_lock(&log->l_icloglock);
>  	iclog = log->l_iclog;
> -	if (iclog->ic_state & XLOG_STATE_IOERROR)
> +	if (iclog->ic_state == XLOG_STATE_IOERROR)
>  		goto out_error;
>  
>  	while (be64_to_cpu(iclog->ic_header.h_lsn) != lsn) {
> @@ -3415,10 +3409,8 @@ __xfs_log_force_lsn(
>  		 * will go out then.
>  		 */
>  		if (!already_slept &&
> -		    (iclog->ic_prev->ic_state &
> -		     (XLOG_STATE_WANT_SYNC | XLOG_STATE_SYNCING))) {
> -			ASSERT(!(iclog->ic_state & XLOG_STATE_IOERROR));
> -
> +		    (iclog->ic_prev->ic_state == XLOG_STATE_WANT_SYNC ||
> +		     iclog->ic_prev->ic_state == XLOG_STATE_SYNCING)) {
>  			XFS_STATS_INC(mp, xs_log_force_sleep);
>  
>  			xlog_wait(&iclog->ic_prev->ic_write_wait,
> @@ -3434,15 +3426,16 @@ __xfs_log_force_lsn(
>  	}
>  
>  	if (!(flags & XFS_LOG_SYNC) ||
> -	    (iclog->ic_state & (XLOG_STATE_ACTIVE | XLOG_STATE_DIRTY)))
> +	    (iclog->ic_state == XLOG_STATE_ACTIVE ||
> +	     iclog->ic_state == XLOG_STATE_DIRTY))
>  		goto out_unlock;
>  
> -	if (iclog->ic_state & XLOG_STATE_IOERROR)
> +	if (iclog->ic_state == XLOG_STATE_IOERROR)
>  		goto out_error;
>  
>  	XFS_STATS_INC(mp, xs_log_force_sleep);
>  	xlog_wait(&iclog->ic_force_wait, &log->l_icloglock);
> -	if (iclog->ic_state & XLOG_STATE_IOERROR)
> +	if (iclog->ic_state == XLOG_STATE_IOERROR)
>  		return -EIO;
>  	return 0;
>  
> @@ -3505,8 +3498,8 @@ xlog_state_want_sync(
>  	if (iclog->ic_state == XLOG_STATE_ACTIVE) {
>  		xlog_state_switch_iclogs(log, iclog, 0);
>  	} else {
> -		ASSERT(iclog->ic_state &
> -			(XLOG_STATE_WANT_SYNC|XLOG_STATE_IOERROR));
> +		ASSERT(iclog->ic_state == XLOG_STATE_WANT_SYNC ||
> +		       iclog->ic_state == XLOG_STATE_IOERROR);
>  	}
>  }
>  
> @@ -3883,7 +3876,7 @@ xlog_state_ioerror(
>  	xlog_in_core_t	*iclog, *ic;
>  
>  	iclog = log->l_iclog;
> -	if (! (iclog->ic_state & XLOG_STATE_IOERROR)) {
> +	if (iclog->ic_state != XLOG_STATE_IOERROR) {
>  		/*
>  		 * Mark all the incore logs IOERROR.
>  		 * From now on, no log flushes will result.
> @@ -3943,7 +3936,7 @@ xfs_log_force_umount(
>  	 * Somebody could've already done the hard work for us.
>  	 * No need to get locks for this.
>  	 */
> -	if (logerror && log->l_iclog->ic_state & XLOG_STATE_IOERROR) {
> +	if (logerror && log->l_iclog->ic_state == XLOG_STATE_IOERROR) {
>  		ASSERT(XLOG_FORCED_SHUTDOWN(log));
>  		return 1;
>  	}
> diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
> index ef652abd112c..a1204424a938 100644
> --- a/fs/xfs/xfs_log_cil.c
> +++ b/fs/xfs/xfs_log_cil.c
> @@ -847,7 +847,7 @@ xlog_cil_push(
>  		goto out_abort;
>  
>  	spin_lock(&commit_iclog->ic_callback_lock);
> -	if (commit_iclog->ic_state & XLOG_STATE_IOERROR) {
> +	if (commit_iclog->ic_state == XLOG_STATE_IOERROR) {
>  		spin_unlock(&commit_iclog->ic_callback_lock);
>  		goto out_abort;
>  	}
> diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
> index 66bd370ae60a..bf076893f516 100644
> --- a/fs/xfs/xfs_log_priv.h
> +++ b/fs/xfs/xfs_log_priv.h
> @@ -40,15 +40,16 @@ static inline uint xlog_get_client_id(__be32 i)
>  /*
>   * In core log state
>   */
> -#define XLOG_STATE_ACTIVE    0x0001 /* Current IC log being written to */
> -#define XLOG_STATE_WANT_SYNC 0x0002 /* Want to sync this iclog; no more writes */
> -#define XLOG_STATE_SYNCING   0x0004 /* This IC log is syncing */
> -#define XLOG_STATE_DONE_SYNC 0x0008 /* Done syncing to disk */
> -#define XLOG_STATE_DO_CALLBACK \
> -			     0x0010 /* Process callback functions */
> -#define XLOG_STATE_CALLBACK  0x0020 /* Callback functions now */
> -#define XLOG_STATE_DIRTY     0x0040 /* Dirty IC log, not ready for ACTIVE status*/
> -#define XLOG_STATE_IOERROR   0x0080 /* IO error happened in sync'ing log */
> +enum xlog_iclog_state {
> +	XLOG_STATE_ACTIVE,	/* Current IC log being written to */
> +	XLOG_STATE_WANT_SYNC,	/* Want to sync this iclog; no more writes */
> +	XLOG_STATE_SYNCING,	/* This IC log is syncing */
> +	XLOG_STATE_DONE_SYNC,	/* Done syncing to disk */
> +	XLOG_STATE_DO_CALLBACK,	/* Process callback functions */
> +	XLOG_STATE_CALLBACK,	/* Callback functions now */
> +	XLOG_STATE_DIRTY,	/* Dirty IC log, not ready for ACTIVE status */
> +	XLOG_STATE_IOERROR,	/* IO error happened in sync'ing log */
> +};
>  
>  /*
>   * Flags to log ticket
> @@ -202,7 +203,7 @@ typedef struct xlog_in_core {
>  	struct xlog		*ic_log;
>  	u32			ic_size;
>  	u32			ic_offset;
> -	unsigned short		ic_state;
> +	enum xlog_iclog_state	ic_state;
>  	char			*ic_datap;	/* pointer to iclog data */
>  
>  	/* Callback structures need their own cacheline */
> -- 
> 2.20.1
> 
