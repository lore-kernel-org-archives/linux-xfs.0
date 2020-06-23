Return-Path: <SRS0=nlsN=AE=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35CCDC433DF
	for <linux-xfs@archiver.kernel.org>; Tue, 23 Jun 2020 02:38:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 07FE720720
	for <linux-xfs@archiver.kernel.org>; Tue, 23 Jun 2020 02:38:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="o1ShHYIq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731546AbgFWCiU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 22 Jun 2020 22:38:20 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:39890 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731434AbgFWCiU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 22 Jun 2020 22:38:20 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05N2bfmm119300;
        Tue, 23 Jun 2020 02:38:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=rhbCF/TQRfvpDVmTwznoBGMwsBruFuc0pK4E2qB0C7A=;
 b=o1ShHYIq0MbC4mRC8FSN8Gz4WHOttKHIoqfeWcHOECgVM7WSKQtUAldXufkLGqguta+P
 4FgqCqhEUhJ1Rfko5eoGpc81D0/js4mgr2Z7k18jNhi+F6NGoD+8dHKQMAQsmxA+bgvs
 T23mdlXs08VCxQ0R+5IYSr8GnQooF/5DY2L38eFckLTisOr9BHhI9spRpdSfJAzP1wpe
 Ie1oSo6I9Lu6SWEGrIn2eR7odbDuVHXlMyucvrz9SPaQyfSaQw/KFww745Uff4uOWxwJ
 o64cRUoqV4VuI9ukvr6wO3UV8Ljo+aY2zHaJf9LVvDtEZSyEAfDZt2jwikuFUCF0jBDv TQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 31sebbamy7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 23 Jun 2020 02:38:16 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05N2buBU102497;
        Tue, 23 Jun 2020 02:38:15 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 31svc2tyjv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 Jun 2020 02:38:15 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 05N2cEFD017499;
        Tue, 23 Jun 2020 02:38:14 GMT
Received: from localhost (/10.159.143.140)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 23 Jun 2020 02:38:14 +0000
Date:   Mon, 22 Jun 2020 19:38:13 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 13/30] xfs: handle buffer log item IO errors directly
Message-ID: <20200623023813.GC7606@magnolia>
References: <20200622081605.1818434-1-david@fromorbit.com>
 <20200622081605.1818434-14-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200622081605.1818434-14-david@fromorbit.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9660 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 bulkscore=0
 spamscore=0 suspectscore=1 mlxlogscore=999 malwarescore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006230018
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9660 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 cotscore=-2147483648
 lowpriorityscore=0 phishscore=0 bulkscore=0 clxscore=1015 impostorscore=0
 malwarescore=0 priorityscore=1501 spamscore=0 mlxscore=0 adultscore=0
 suspectscore=1 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006230018
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jun 22, 2020 at 06:15:48PM +1000, Dave Chinner wrote:
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
> Reviewed-by: Brian Foster <bfoster@redhat.com>

Ok, I can more or less follow along with what we're doing now.

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_buf_item.c | 214 ++++++++++++++++++++++++++++--------------
>  1 file changed, 144 insertions(+), 70 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
> index 09bfe9c52dbd..f80fc5bd3bff 100644
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
> -- 
> 2.26.2.761.g0e0b3e54be
> 
