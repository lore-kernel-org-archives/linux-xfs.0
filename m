Return-Path: <SRS0=6H2z=7S=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD329C433E0
	for <linux-xfs@archiver.kernel.org>; Fri,  5 Jun 2020 16:25:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7D7782074B
	for <linux-xfs@archiver.kernel.org>; Fri,  5 Jun 2020 16:25:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Z0yIXMLs"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726068AbgFEQZD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 5 Jun 2020 12:25:03 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:38265 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726039AbgFEQZC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 5 Jun 2020 12:25:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591374300;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=lCmkxymm6xnKjnDSaGxLPoG8GrGLgWHvHPmz6UGUhIw=;
        b=Z0yIXMLs27JPxE4pQC8yL27rAcg/lBPhhGNz+83ofE2C5N/jGXKg5Grp0dqEO/e49+9Llp
        2a6LmBxbJ0D3p0uCf4PNB5+upLvJeVTqRxgjzWdVRMpaFbY17SDlosWd3drWRhu636TXpY
        2WPtIbBe45i0n8lL4ZgO0gRLE070Nak=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-201-n-1Zt2PXMmSdUeBxjcQ5nQ-1; Fri, 05 Jun 2020 12:24:55 -0400
X-MC-Unique: n-1Zt2PXMmSdUeBxjcQ5nQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DEBCD835B4A;
        Fri,  5 Jun 2020 16:24:54 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 7022D891C2;
        Fri,  5 Jun 2020 16:24:54 +0000 (UTC)
Date:   Fri, 5 Jun 2020 12:24:52 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 13/30 V2] xfs: handle buffer log item IO errors directly
Message-ID: <20200605162452.GA23747@bfoster>
References: <20200604074606.266213-1-david@fromorbit.com>
 <20200604074606.266213-14-david@fromorbit.com>
 <20200605013238.GA2040@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200605013238.GA2040@dread.disaster.area>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jun 05, 2020 at 11:32:38AM +1000, Dave Chinner wrote:
> 
> From: Dave Chinner <dchinner@redhat.com>
> 
> Currently when a buffer with attached log items has an IO error
> it called ->iop_error for each attched log item. These all call
> xfs_set_li_failed() to handle the error, but we are about to change
> the way log items manage buffers. hence we first need to remove the
> per-item dependency on buffer handling done by xfs_set_li_failed().
> 
> We already have specific buffer type IO completion routines, so move
> the log item error handling out of the generic error handling and
> into the log item specific functions so we can implement per-type
> error handling easily.
> 
> This requires a more complex return value from the error handling
> code so that we can take the correct action the failure handling
> requires.  This results in some repeated boilerplate in the
> functions, but that can be cleaned up later once all the changes
> cascade through this code.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
> V2: fix buffer retry selection logic braino.
> 

Looks good:

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_buf_item.c | 214 +++++++++++++++++++++++++++++++++-----------------
>  1 file changed, 144 insertions(+), 70 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
> index 09bfe9c52dbdb..f80fc5bd3bffa 100644
> --- a/fs/xfs/xfs_buf_item.c
> +++ b/fs/xfs/xfs_buf_item.c
> @@ -986,21 +986,24 @@ xfs_buf_do_callbacks_fail(
>  	spin_unlock(&ailp->ail_lock);
>  }
>  
> +/*
> + * Decide if we're going to retry the write after a failure, and prepare
> + * the buffer for retrying the write.
> + */
>  static bool
> -xfs_buf_iodone_callback_error(
> +xfs_buf_ioerror_fail_without_retry(
>  	struct xfs_buf		*bp)
>  {
>  	struct xfs_mount	*mp = bp->b_mount;
>  	static ulong		lasttime;
>  	static xfs_buftarg_t	*lasttarg;
> -	struct xfs_error_cfg	*cfg;
>  
>  	/*
>  	 * If we've already decided to shutdown the filesystem because of
>  	 * I/O errors, there's no point in giving this a retry.
>  	 */
>  	if (XFS_FORCED_SHUTDOWN(mp))
> -		goto out_stale;
> +		return true;
>  
>  	if (bp->b_target != lasttarg ||
>  	    time_after(jiffies, (lasttime + 5*HZ))) {
> @@ -1011,91 +1014,114 @@ xfs_buf_iodone_callback_error(
>  
>  	/* synchronous writes will have callers process the error */
>  	if (!(bp->b_flags & XBF_ASYNC))
> -		goto out_stale;
> -
> -	trace_xfs_buf_item_iodone_async(bp, _RET_IP_);
> -
> -	cfg = xfs_error_get_cfg(mp, XFS_ERR_METADATA, bp->b_error);
> +		return true;
> +	return false;
> +}
>  
> -	/*
> -	 * If the write was asynchronous then no one will be looking for the
> -	 * error.  If this is the first failure of this type, clear the error
> -	 * state and write the buffer out again. This means we always retry an
> -	 * async write failure at least once, but we also need to set the buffer
> -	 * up to behave correctly now for repeated failures.
> -	 */
> -	if (!(bp->b_flags & (XBF_STALE | XBF_WRITE_FAIL)) ||
> -	     bp->b_last_error != bp->b_error) {
> -		bp->b_flags |= (XBF_WRITE | XBF_DONE | XBF_WRITE_FAIL);
> -		bp->b_last_error = bp->b_error;
> -		if (cfg->retry_timeout != XFS_ERR_RETRY_FOREVER &&
> -		    !bp->b_first_retry_time)
> -			bp->b_first_retry_time = jiffies;
> +static bool
> +xfs_buf_ioerror_retry(
> +	struct xfs_buf		*bp,
> +	struct xfs_error_cfg	*cfg)
> +{
> +	if ((bp->b_flags & (XBF_STALE | XBF_WRITE_FAIL)) &&
> +	    bp->b_last_error == bp->b_error)
> +		return false;
>  
> -		xfs_buf_ioerror(bp, 0);
> -		xfs_buf_submit(bp);
> -		return true;
> -	}
> +	bp->b_flags |= (XBF_WRITE | XBF_DONE | XBF_WRITE_FAIL);
> +	bp->b_last_error = bp->b_error;
> +	if (cfg->retry_timeout != XFS_ERR_RETRY_FOREVER &&
> +	    !bp->b_first_retry_time)
> +		bp->b_first_retry_time = jiffies;
> +	return true;
> +}
>  
> -	/*
> -	 * Repeated failure on an async write. Take action according to the
> -	 * error configuration we have been set up to use.
> -	 */
> +/*
> + * Account for this latest trip around the retry handler, and decide if
> + * we've failed enough times to constitute a permanent failure.
> + */
> +static bool
> +xfs_buf_ioerror_permanent(
> +	struct xfs_buf		*bp,
> +	struct xfs_error_cfg	*cfg)
> +{
> +	struct xfs_mount	*mp = bp->b_mount;
>  
>  	if (cfg->max_retries != XFS_ERR_RETRY_FOREVER &&
>  	    ++bp->b_retries > cfg->max_retries)
> -			goto permanent_error;
> +		return true;
>  	if (cfg->retry_timeout != XFS_ERR_RETRY_FOREVER &&
>  	    time_after(jiffies, cfg->retry_timeout + bp->b_first_retry_time))
> -			goto permanent_error;
> +		return true;
>  
>  	/* At unmount we may treat errors differently */
>  	if ((mp->m_flags & XFS_MOUNT_UNMOUNTING) && mp->m_fail_unmount)
> -		goto permanent_error;
> -
> -	/*
> -	 * Still a transient error, run IO completion failure callbacks and let
> -	 * the higher layers retry the buffer.
> -	 */
> -	xfs_buf_do_callbacks_fail(bp);
> -	xfs_buf_ioerror(bp, 0);
> -	xfs_buf_relse(bp);
> -	return true;
> +		return true;
>  
> -	/*
> -	 * Permanent error - we need to trigger a shutdown if we haven't already
> -	 * to indicate that inconsistency will result from this action.
> -	 */
> -permanent_error:
> -	xfs_force_shutdown(mp, SHUTDOWN_META_IO_ERROR);
> -out_stale:
> -	xfs_buf_stale(bp);
> -	bp->b_flags |= XBF_DONE;
> -	trace_xfs_buf_error_relse(bp, _RET_IP_);
>  	return false;
>  }
>  
> -static inline bool
> -xfs_buf_had_callback_errors(
> +/*
> + * On a sync write or shutdown we just want to stale the buffer and let the
> + * caller handle the error in bp->b_error appropriately.
> + *
> + * If the write was asynchronous then no one will be looking for the error.  If
> + * this is the first failure of this type, clear the error state and write the
> + * buffer out again. This means we always retry an async write failure at least
> + * once, but we also need to set the buffer up to behave correctly now for
> + * repeated failures.
> + *
> + * If we get repeated async write failures, then we take action according to the
> + * error configuration we have been set up to use.
> + *
> + * Multi-state return value:
> + *
> + * XBF_IOERROR_FINISH: clear IO error retry state and run callback completions
> + * XBF_IOERROR_DONE: resubmitted immediately, do not run any completions
> + * XBF_IOERROR_FAIL: transient error, run failure callback completions and then
> + *    release the buffer
> + */
> +enum {
> +	XBF_IOERROR_FINISH,
> +	XBF_IOERROR_DONE,
> +	XBF_IOERROR_FAIL,
> +};
> +
> +static int
> +xfs_buf_iodone_error(
>  	struct xfs_buf		*bp)
>  {
> +	struct xfs_mount	*mp = bp->b_mount;
> +	struct xfs_error_cfg	*cfg;
>  
> -	/*
> -	 * If there is an error, process it. Some errors require us to run
> -	 * callbacks after failure processing is done so we detect that and take
> -	 * appropriate action.
> -	 */
> -	if (bp->b_error && xfs_buf_iodone_callback_error(bp))
> -		return true;
> +	if (xfs_buf_ioerror_fail_without_retry(bp))
> +		goto out_stale;
> +
> +	trace_xfs_buf_item_iodone_async(bp, _RET_IP_);
> +
> +	cfg = xfs_error_get_cfg(mp, XFS_ERR_METADATA, bp->b_error);
> +	if (xfs_buf_ioerror_retry(bp, cfg)) {
> +		xfs_buf_ioerror(bp, 0);
> +		xfs_buf_submit(bp);
> +		return XBF_IOERROR_DONE;
> +	}
>  
>  	/*
> -	 * Successful IO or permanent error. Either way, we can clear the
> -	 * retry state here in preparation for the next error that may occur.
> +	 * Permanent error - we need to trigger a shutdown if we haven't already
> +	 * to indicate that inconsistency will result from this action.
>  	 */
> -	bp->b_last_error = 0;
> -	bp->b_retries = 0;
> -	bp->b_first_retry_time = 0;
> -	return false;
> +	if (xfs_buf_ioerror_permanent(bp, cfg)) {
> +		xfs_force_shutdown(mp, SHUTDOWN_META_IO_ERROR);
> +		goto out_stale;
> +	}
> +
> +	/* Still considered a transient error. Caller will schedule retries. */
> +	return XBF_IOERROR_FAIL;
> +
> +out_stale:
> +	xfs_buf_stale(bp);
> +	bp->b_flags |= XBF_DONE;
> +	trace_xfs_buf_error_relse(bp, _RET_IP_);
> +	return XBF_IOERROR_FINISH;
>  }
>  
>  static void
> @@ -1122,6 +1148,15 @@ xfs_buf_item_done(
>  	xfs_buf_rele(bp);
>  }
>  
> +static inline void
> +xfs_buf_clear_ioerror_retry_state(
> +	struct xfs_buf		*bp)
> +{
> +	bp->b_last_error = 0;
> +	bp->b_retries = 0;
> +	bp->b_first_retry_time = 0;
> +}
> +
>  /*
>   * Inode buffer iodone callback function.
>   */
> @@ -1129,9 +1164,22 @@ void
>  xfs_buf_inode_iodone(
>  	struct xfs_buf		*bp)
>  {
> -	if (xfs_buf_had_callback_errors(bp))
> +	if (bp->b_error) {
> +		int ret = xfs_buf_iodone_error(bp);
> +
> +		if (ret == XBF_IOERROR_FINISH)
> +			goto finish_iodone;
> +		if (ret == XBF_IOERROR_DONE)
> +			return;
> +		ASSERT(ret == XBF_IOERROR_FAIL);
> +		xfs_buf_do_callbacks_fail(bp);
> +		xfs_buf_ioerror(bp, 0);
> +		xfs_buf_relse(bp);
>  		return;
> +	}
>  
> +finish_iodone:
> +	xfs_buf_clear_ioerror_retry_state(bp);
>  	xfs_buf_item_done(bp);
>  	xfs_iflush_done(bp);
>  	xfs_buf_ioend_finish(bp);
> @@ -1144,9 +1192,22 @@ void
>  xfs_buf_dquot_iodone(
>  	struct xfs_buf		*bp)
>  {
> -	if (xfs_buf_had_callback_errors(bp))
> +	if (bp->b_error) {
> +		int ret = xfs_buf_iodone_error(bp);
> +
> +		if (ret == XBF_IOERROR_FINISH)
> +			goto finish_iodone;
> +		if (ret == XBF_IOERROR_DONE)
> +			return;
> +		ASSERT(ret == XBF_IOERROR_FAIL);
> +		xfs_buf_do_callbacks_fail(bp);
> +		xfs_buf_ioerror(bp, 0);
> +		xfs_buf_relse(bp);
>  		return;
> +	}
>  
> +finish_iodone:
> +	xfs_buf_clear_ioerror_retry_state(bp);
>  	/* a newly allocated dquot buffer might have a log item attached */
>  	xfs_buf_item_done(bp);
>  	xfs_dquot_done(bp);
> @@ -1163,9 +1224,22 @@ void
>  xfs_buf_iodone(
>  	struct xfs_buf		*bp)
>  {
> -	if (xfs_buf_had_callback_errors(bp))
> +	if (bp->b_error) {
> +		int ret = xfs_buf_iodone_error(bp);
> +
> +		if (ret == XBF_IOERROR_FINISH)
> +			goto finish_iodone;
> +		if (ret == XBF_IOERROR_DONE)
> +			return;
> +		ASSERT(ret == XBF_IOERROR_FAIL);
> +		xfs_buf_do_callbacks_fail(bp);
> +		xfs_buf_ioerror(bp, 0);
> +		xfs_buf_relse(bp);
>  		return;
> +	}
>  
> +finish_iodone:
> +	xfs_buf_clear_ioerror_retry_state(bp);
>  	xfs_buf_item_done(bp);
>  	xfs_buf_ioend_finish(bp);
>  }
> 

