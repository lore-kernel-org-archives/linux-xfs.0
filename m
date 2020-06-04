Return-Path: <SRS0=uikP=7R=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ACC83C433DF
	for <linux-xfs@archiver.kernel.org>; Thu,  4 Jun 2020 14:05:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 83DA120738
	for <linux-xfs@archiver.kernel.org>; Thu,  4 Jun 2020 14:05:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JtrBIcot"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728496AbgFDOF1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 4 Jun 2020 10:05:27 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:49738 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728675AbgFDOF1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 4 Jun 2020 10:05:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591279525;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=4KeJA2eCDvDDKmz6D8l20ilv/EuY5cE1jlwWeTfoYLE=;
        b=JtrBIcotnLcy4nh301Yy6b1+rJEC4dGKYu3cUCUXo6FcVPrWMQxT0JbbrPOhKPvXJqWjiF
        T3G7dzGRSM0FCftPr2Z0Vo2+V2eRVWbSL97EfnCUR9wLcU+AKlSL1lT/llPzUnl4kes44g
        XnhxbUbhrT+doTIODSgFjGbEnkL93dc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-92-4tatTbijNHKv4BtepePaCQ-1; Thu, 04 Jun 2020 10:05:23 -0400
X-MC-Unique: 4tatTbijNHKv4BtepePaCQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 33A1A80B726;
        Thu,  4 Jun 2020 14:05:22 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id D1B7678F08;
        Thu,  4 Jun 2020 14:05:21 +0000 (UTC)
Date:   Thu, 4 Jun 2020 10:05:20 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 13/30] xfs: handle buffer log item IO errors directly
Message-ID: <20200604140520.GD17815@bfoster>
References: <20200604074606.266213-1-david@fromorbit.com>
 <20200604074606.266213-14-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200604074606.266213-14-david@fromorbit.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jun 04, 2020 at 05:45:49PM +1000, Dave Chinner wrote:
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
>  fs/xfs/xfs_buf_item.c | 215 ++++++++++++++++++++++++++++--------------
>  1 file changed, 145 insertions(+), 70 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
> index 09bfe9c52dbdb..3560993847b7c 100644
> --- a/fs/xfs/xfs_buf_item.c
> +++ b/fs/xfs/xfs_buf_item.c
...
> @@ -1011,91 +1014,115 @@ xfs_buf_iodone_callback_error(
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
> +	if (bp->b_flags & (XBF_STALE | XBF_WRITE_FAIL))
> +		return false;
> +	if (bp->b_last_error == bp->b_error)
> +		return false;

This looks like a subtle logic change. The current code issues the
internal retry if the flag isn't set (i.e. first ioerror in the
sequence) or if the current error code differs from the previous. This
code only looks at ->b_last_error if the fail flag wasn't set.

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
...
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

I like the enum, but I have a hard time distinguishing what the
difference is between FINISH and DONE based on the naming. I think
RESUBMIT would be more clear than DONE and perhaps have the resubmit in
the caller, but then we'd have to duplicate that as well. Eh, perhaps it
makes sense to defer such potential cleanups to the end.

Brian

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
> @@ -1122,6 +1149,15 @@ xfs_buf_item_done(
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
> @@ -1129,9 +1165,22 @@ void
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
> @@ -1144,9 +1193,22 @@ void
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
> @@ -1163,9 +1225,22 @@ void
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
> -- 
> 2.26.2.761.g0e0b3e54be
> 

