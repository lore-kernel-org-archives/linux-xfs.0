Return-Path: <SRS0=pQq2=7P=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDE27C433DF
	for <linux-xfs@archiver.kernel.org>; Tue,  2 Jun 2020 20:39:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 84469206A2
	for <linux-xfs@archiver.kernel.org>; Tue,  2 Jun 2020 20:39:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="BhmAQMoG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726842AbgFBUj7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 2 Jun 2020 16:39:59 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:45680 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726580AbgFBUj6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 2 Jun 2020 16:39:58 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 052KcH5Q038081;
        Tue, 2 Jun 2020 20:39:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=2uc2r0559pSy7kT6L8ikxnOp1TaLkd5Q1kCDciTYmeA=;
 b=BhmAQMoG2xxFwi6/QHVYM13TdI+RLmwH1MVwMcbwudSXFZxA+WN4Nh0yK6MOCKKRR9c9
 liquVCtetfNCVuMf4al9zmxQk536fEePIkezhqS5jqjZGCwg7aoUAUkD++YuyPtLPDqj
 WbJAQI0zsgbdsEhPzbI/qh/5o9ofSAjSO+M29pzfVHH7tIWqmSYNKnT8JwiMHHmLQbsw
 N1rmILHSEvOCXzuwYGuYZ8BfrZ435psWzrOFqha5BeN+9MhdJQ7Fby3AkqEDWduMCF6V
 RBE2TMxSPkfGpzYSTgH7m7oYjnm/xGED4vdFWhXl8F3NPULUnaLfO4m2mvXrrlym5HBP qg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 31bewqx35p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 02 Jun 2020 20:39:55 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 052Kc00L042694;
        Tue, 2 Jun 2020 20:39:54 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 31dju23chc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 02 Jun 2020 20:39:54 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 052KdrXR025910;
        Tue, 2 Jun 2020 20:39:53 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 02 Jun 2020 13:39:52 -0700
Date:   Tue, 2 Jun 2020 13:39:51 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 13/30] xfs: handle buffer log item IO errors directly
Message-ID: <20200602203951.GJ8230@magnolia>
References: <20200601214251.4167140-1-david@fromorbit.com>
 <20200601214251.4167140-14-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200601214251.4167140-14-david@fromorbit.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9640 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 phishscore=0 malwarescore=0 mlxscore=0 adultscore=0 bulkscore=0
 suspectscore=1 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006020150
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9640 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 bulkscore=0
 phishscore=0 suspectscore=1 impostorscore=0 cotscore=-2147483648
 lowpriorityscore=0 mlxscore=0 adultscore=0 spamscore=0 mlxlogscore=999
 malwarescore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2006020150
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jun 02, 2020 at 07:42:34AM +1000, Dave Chinner wrote:
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
>  fs/xfs/xfs_buf_item.c | 167 ++++++++++++++++++++++++++++--------------
>  1 file changed, 112 insertions(+), 55 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
> index 09bfe9c52dbdb..b6995719e877b 100644
> --- a/fs/xfs/xfs_buf_item.c
> +++ b/fs/xfs/xfs_buf_item.c
> @@ -987,20 +987,18 @@ xfs_buf_do_callbacks_fail(
>  }
>  
>  static bool
> -xfs_buf_iodone_callback_error(
> +xfs_buf_ioerror_sync(
>  	struct xfs_buf		*bp)
>  {
>  	struct xfs_mount	*mp = bp->b_mount;
>  	static ulong		lasttime;
>  	static xfs_buftarg_t	*lasttarg;
> -	struct xfs_error_cfg	*cfg;
> -
>  	/*

This should preserve the blank line between the declarations and the
start of the code.

>  	 * If we've already decided to shutdown the filesystem because of
>  	 * I/O errors, there's no point in giving this a retry.
>  	 */
>  	if (XFS_FORCED_SHUTDOWN(mp))
> -		goto out_stale;
> +		return true;
>  
>  	if (bp->b_target != lasttarg ||
>  	    time_after(jiffies, (lasttime + 5*HZ))) {
> @@ -1011,19 +1009,15 @@ xfs_buf_iodone_callback_error(
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

What does the return value mean here?  true means "let the caller deal
with the error", false means "attempt a retry, if desired?  So this
function decides if we're going to fail immediately or not?

	if (xfs_buf_ioerr_fail_immediately(bp))
		goto out_stale;

That's a lengthy name though.  On second inspection, I guess this
function decides if the buffer is going to be sent through the io retry
mechanism, and the next two functions advance it through the retry
states until either the write succeeds or we declare permanent failure?

> +}
>  
> -	/*
> -	 * If the write was asynchronous then no one will be looking for the
> -	 * error.  If this is the first failure of this type, clear the error
> -	 * state and write the buffer out again. This means we always retry an
> -	 * async write failure at least once, but we also need to set the buffer
> -	 * up to behave correctly now for repeated failures.
> -	 */
> +static bool
> +xfs_buf_ioerror_retry(

Might be nice to preserve some of this comment, since I initially
missed that this function both decides whether or not to do the retry
and sets up the buffer to do that.

/*
 * Decide if we're going to retry the write after a failure, and prepare
 * the buffer for retrying the write.
 */

Or, adding some newlines in the outer if body to make the two lines
that modify the bp state stand out would also help.

(TBH I'm struggling right now to make sense of what these new functions
do, though I'm fairly convinced that they at least aren't changing much
of the functionality...)

> +	struct xfs_buf		*bp,
> +	struct xfs_error_cfg	*cfg)
> +{
>  	if (!(bp->b_flags & (XBF_STALE | XBF_WRITE_FAIL)) ||
>  	     bp->b_last_error != bp->b_error) {
>  		bp->b_flags |= (XBF_WRITE | XBF_DONE | XBF_WRITE_FAIL);
> @@ -1031,36 +1025,80 @@ xfs_buf_iodone_callback_error(
>  		if (cfg->retry_timeout != XFS_ERR_RETRY_FOREVER &&
>  		    !bp->b_first_retry_time)
>  			bp->b_first_retry_time = jiffies;
> -
> -		xfs_buf_ioerror(bp, 0);
> -		xfs_buf_submit(bp);
>  		return true;
>  	}
> +	return false;
> +}
>  
> -	/*
> -	 * Repeated failure on an async write. Take action according to the
> -	 * error configuration we have been set up to use.
> -	 */
> +static bool
> +xfs_buf_ioerror_permanent(

/*
 * Account for this latest trip around the retry handler, and decide if
 * we've failed enough times to constitute a permanent failure.
 */

> +	struct xfs_buf		*bp,
> +	struct xfs_error_cfg	*cfg)
> +{
> +	struct xfs_mount	*mp = bp->b_mount;
>  
>  	if (cfg->max_retries != XFS_ERR_RETRY_FOREVER &&
>  	    ++bp->b_retries > cfg->max_retries)
> -			goto permanent_error;
> +			return true;

Might as well fix the indentation while you're at it.


>  	if (cfg->retry_timeout != XFS_ERR_RETRY_FOREVER &&
>  	    time_after(jiffies, cfg->retry_timeout + bp->b_first_retry_time))
> -			goto permanent_error;
> +			return true;
>  
>  	/* At unmount we may treat errors differently */
>  	if ((mp->m_flags & XFS_MOUNT_UNMOUNTING) && mp->m_fail_unmount)
> +		return true;
> +
> +	return false;
> +}
> +
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
> + * 0: clear IO error retry state and run callback completions
> + * 1: resubmitted immediately, do not run any completions
> + * 2: transient error, run failure callback completions and then
> + *    release the buffer

Feels odd not to use an enum here, but as this is a static function
maybe it's not a high risk for screwing up in the callers.

--D

> + */
> +static int
> +xfs_buf_iodone_error(
> +	struct xfs_buf		*bp)
> +{
> +	struct xfs_mount	*mp = bp->b_mount;
> +	struct xfs_error_cfg	*cfg;
> +
> +	if (xfs_buf_ioerror_sync(bp))
> +		goto out_stale;
> +
> +	trace_xfs_buf_item_iodone_async(bp, _RET_IP_);
> +
> +	cfg = xfs_error_get_cfg(mp, XFS_ERR_METADATA, bp->b_error);
> +	if (xfs_buf_ioerror_retry(bp, cfg)) {
> +		xfs_buf_ioerror(bp, 0);
> +		xfs_buf_submit(bp);
> +		return 1;
> +	}
> +
> +	if (xfs_buf_ioerror_permanent(bp, cfg))
>  		goto permanent_error;
>  
>  	/*
>  	 * Still a transient error, run IO completion failure callbacks and let
>  	 * the higher layers retry the buffer.
>  	 */
> -	xfs_buf_do_callbacks_fail(bp);
>  	xfs_buf_ioerror(bp, 0);
> -	xfs_buf_relse(bp);
> -	return true;
> +	return 2;
>  
>  	/*
>  	 * Permanent error - we need to trigger a shutdown if we haven't already
> @@ -1072,30 +1110,7 @@ xfs_buf_iodone_callback_error(
>  	xfs_buf_stale(bp);
>  	bp->b_flags |= XBF_DONE;
>  	trace_xfs_buf_error_relse(bp, _RET_IP_);
> -	return false;
> -}
> -
> -static inline bool
> -xfs_buf_had_callback_errors(
> -	struct xfs_buf		*bp)
> -{
> -
> -	/*
> -	 * If there is an error, process it. Some errors require us to run
> -	 * callbacks after failure processing is done so we detect that and take
> -	 * appropriate action.
> -	 */
> -	if (bp->b_error && xfs_buf_iodone_callback_error(bp))
> -		return true;
> -
> -	/*
> -	 * Successful IO or permanent error. Either way, we can clear the
> -	 * retry state here in preparation for the next error that may occur.
> -	 */
> -	bp->b_last_error = 0;
> -	bp->b_retries = 0;
> -	bp->b_first_retry_time = 0;
> -	return false;
> +	return 0;
>  }
>  
>  static void
> @@ -1122,6 +1137,15 @@ xfs_buf_item_done(
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
> @@ -1129,9 +1153,20 @@ void
>  xfs_buf_inode_iodone(
>  	struct xfs_buf		*bp)
>  {
> -	if (xfs_buf_had_callback_errors(bp))
> +	if (bp->b_error) {
> +		int ret = xfs_buf_iodone_error(bp);
> +		if (!ret)
> +			goto finish_iodone;
> +		if (ret == 1)
> +			return;
> +		ASSERT(ret == 2);
> +		xfs_buf_do_callbacks_fail(bp);
> +		xfs_buf_relse(bp);
>  		return;
> +	}
>  
> +finish_iodone:
> +	xfs_buf_clear_ioerror_retry_state(bp);
>  	xfs_buf_item_done(bp);
>  	xfs_iflush_done(bp);
>  	xfs_buf_ioend_finish(bp);
> @@ -1144,9 +1179,20 @@ void
>  xfs_buf_dquot_iodone(
>  	struct xfs_buf		*bp)
>  {
> -	if (xfs_buf_had_callback_errors(bp))
> +	if (bp->b_error) {
> +		int ret = xfs_buf_iodone_error(bp);
> +		if (!ret)
> +			goto finish_iodone;
> +		if (ret == 1)
> +			return;
> +		ASSERT(ret == 2);
> +		xfs_buf_do_callbacks_fail(bp);
> +		xfs_buf_relse(bp);
>  		return;
> +	}
>  
> +finish_iodone:
> +	xfs_buf_clear_ioerror_retry_state(bp);
>  	/* a newly allocated dquot buffer might have a log item attached */
>  	xfs_buf_item_done(bp);
>  	xfs_dquot_done(bp);
> @@ -1163,9 +1209,20 @@ void
>  xfs_buf_iodone(
>  	struct xfs_buf		*bp)
>  {
> -	if (xfs_buf_had_callback_errors(bp))
> +	if (bp->b_error) {
> +		int ret = xfs_buf_iodone_error(bp);
> +		if (!ret)
> +			goto finish_iodone;
> +		if (ret == 1)
> +			return;
> +		ASSERT(ret == 2);
> +		xfs_buf_do_callbacks_fail(bp);
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
