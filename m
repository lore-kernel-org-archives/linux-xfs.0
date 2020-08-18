Return-Path: <SRS0=PyEN=B4=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2DDA1C433E1
	for <linux-xfs@archiver.kernel.org>; Tue, 18 Aug 2020 22:40:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F241320709
	for <linux-xfs@archiver.kernel.org>; Tue, 18 Aug 2020 22:40:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="MoyGbiow"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727101AbgHRWkP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 18 Aug 2020 18:40:15 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:57830 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727097AbgHRWkI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 Aug 2020 18:40:08 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07IMGxTI111944;
        Tue, 18 Aug 2020 22:40:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=jCm/5fCOyIPwkdF4rrIVFB/R5/b+RgKOCqLT5yzBygY=;
 b=MoyGbiowp4435xQmRLke+8i7SsYi8wN9LrZwo9ueuKK4JKbAPtsN/R7UeSDe81ebch2t
 huxwYOBtVuhyUf0yVvoQo4qHDhTl5kCyWMT1n6SD5xiRInGd5VM1yMga2yttHcFP8KFF
 g4c40FWEHIb7vh7H+8gOIQyuqm0fjiHdmjbIKar+JcOMnwFDyCEm3wdG8gQGzrYH3q8L
 sYn8ksElMV0a1wLOCGLrRLd6WncTBpovGVAmM/Iuya01vpPAIPJFxyWW6Bo45Em4Cp6d
 kltc0wQLSoNumNylPa/01+9Qovzwj/3IkGMjmQinor8zwsOxu2PGUM6JGhyoAC4WjR4a mg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 32x8bn7hj9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 18 Aug 2020 22:40:00 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07IMHj39056226;
        Tue, 18 Aug 2020 22:40:00 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 330pvhm79c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 Aug 2020 22:39:59 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 07IMdwup026672;
        Tue, 18 Aug 2020 22:39:58 GMT
Received: from localhost (/10.159.129.94)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 18 Aug 2020 15:39:58 -0700
Date:   Tue, 18 Aug 2020 15:39:56 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 04/13] xfs: move the buffer retry logic to xfs_buf.c
Message-ID: <20200818223956.GE6096@magnolia>
References: <20200709150453.109230-1-hch@lst.de>
 <20200709150453.109230-5-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200709150453.109230-5-hch@lst.de>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9717 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 phishscore=0
 malwarescore=0 adultscore=0 bulkscore=0 suspectscore=5 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008180160
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9717 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 lowpriorityscore=0
 impostorscore=0 suspectscore=5 adultscore=0 spamscore=0 malwarescore=0
 mlxlogscore=999 priorityscore=1501 bulkscore=0 clxscore=1015 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008180160
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jul 09, 2020 at 08:04:44AM -0700, Christoph Hellwig wrote:
> Move the buffer retry state machine logic to xfs_buf.c and call it once
> from xfs_ioend instead of duplicating it three times for the three kinds
> of buffers.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks like a pretty straightforward refactoring -- most of the buffer
completion code gets moved to xfs_buf.c, and the inode/dquot specific
pieces retreat to their respective files...

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/libxfs/xfs_trans_inode.c |   6 +-
>  fs/xfs/xfs_buf.c                | 173 ++++++++++++++++++++-
>  fs/xfs/xfs_buf_item.c           | 260 +-------------------------------
>  fs/xfs/xfs_buf_item.h           |   3 +
>  fs/xfs/xfs_dquot.c              |  14 +-
>  fs/xfs/xfs_inode.c              |   6 +-
>  fs/xfs/xfs_inode_item.c         |  12 +-
>  fs/xfs/xfs_inode_item.h         |   1 -
>  fs/xfs/xfs_trace.h              |   2 +-
>  9 files changed, 206 insertions(+), 271 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_trans_inode.c b/fs/xfs/libxfs/xfs_trans_inode.c
> index e15129647e00c9..3071ab55c44518 100644
> --- a/fs/xfs/libxfs/xfs_trans_inode.c
> +++ b/fs/xfs/libxfs/xfs_trans_inode.c
> @@ -177,9 +177,9 @@ xfs_trans_log_inode(
>  
>  	/*
>  	 * Always OR in the bits from the ili_last_fields field.  This is to
> -	 * coordinate with the xfs_iflush() and xfs_iflush_done() routines in
> -	 * the eventual clearing of the ili_fields bits.  See the big comment in
> -	 * xfs_iflush() for an explanation of this coordination mechanism.
> +	 * coordinate with the xfs_iflush() and xfs_buf_inode_iodone() routines
> +	 * in the eventual clearing of the ili_fields bits.  See the big comment
> +	 * in xfs_iflush() for an explanation of this coordination mechanism.
>  	 */
>  	iip->ili_fields |= (flags | iip->ili_last_fields | iversion_flags);
>  	spin_unlock(&iip->ili_lock);
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index 7c22d63f43f754..443d11bdfcf502 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -1173,8 +1173,145 @@ xfs_buf_wait_unpin(
>  }
>  
>  /*
> - *	Buffer Utility Routines
> + * Decide if we're going to retry the write after a failure, and prepare
> + * the buffer for retrying the write.
>   */
> +static bool
> +xfs_buf_ioerror_fail_without_retry(
> +	struct xfs_buf		*bp)
> +{
> +	struct xfs_mount	*mp = bp->b_mount;
> +	static unsigned long	lasttime;
> +	static struct xfs_buftarg *lasttarg;
> +
> +	/*
> +	 * If we've already decided to shutdown the filesystem because of
> +	 * I/O errors, there's no point in giving this a retry.
> +	 */
> +	if (XFS_FORCED_SHUTDOWN(mp))
> +		return true;
> +
> +	if (bp->b_target != lasttarg ||
> +	    time_after(jiffies, (lasttime + 5*HZ))) {
> +		lasttime = jiffies;
> +		xfs_buf_ioerror_alert(bp, __this_address);
> +	}
> +	lasttarg = bp->b_target;
> +
> +	/* synchronous writes will have callers process the error */
> +	if (!(bp->b_flags & XBF_ASYNC))
> +		return true;
> +	return false;
> +}
> +
> +static bool
> +xfs_buf_ioerror_retry(
> +	struct xfs_buf		*bp,
> +	struct xfs_error_cfg	*cfg)
> +{
> +	if ((bp->b_flags & (XBF_STALE | XBF_WRITE_FAIL)) &&
> +	    bp->b_last_error == bp->b_error)
> +		return false;
> +
> +	bp->b_flags |= (XBF_WRITE | XBF_DONE | XBF_WRITE_FAIL);
> +	bp->b_last_error = bp->b_error;
> +	if (cfg->retry_timeout != XFS_ERR_RETRY_FOREVER &&
> +	    !bp->b_first_retry_time)
> +		bp->b_first_retry_time = jiffies;
> +	return true;
> +}
> +
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
> +
> +	if (cfg->max_retries != XFS_ERR_RETRY_FOREVER &&
> +	    ++bp->b_retries > cfg->max_retries)
> +		return true;
> +	if (cfg->retry_timeout != XFS_ERR_RETRY_FOREVER &&
> +	    time_after(jiffies, cfg->retry_timeout + bp->b_first_retry_time))
> +		return true;
> +
> +	/* At unmount we may treat errors differently */
> +	if ((mp->m_flags & XFS_MOUNT_UNMOUNTING) && mp->m_fail_unmount)
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
> + * XBF_IOEND_FINISH: run callback completions
> + * XBF_IOEND_DONE: resubmitted immediately, do not run any completions
> + * XBF_IOEND_FAIL: transient error, run failure callback completions and then
> + *    release the buffer
> + */
> +enum xfs_buf_ioend_disposition {
> +	XBF_IOEND_FINISH,
> +	XBF_IOEND_DONE,
> +	XBF_IOEND_FAIL,
> +};
> +
> +static enum xfs_buf_ioend_disposition
> +xfs_buf_ioend_disposition(
> +	struct xfs_buf		*bp)
> +{
> +	struct xfs_mount	*mp = bp->b_mount;
> +	struct xfs_error_cfg	*cfg;
> +
> +	if (likely(!bp->b_error))
> +		return XBF_IOEND_FINISH;
> +
> +	if (xfs_buf_ioerror_fail_without_retry(bp))
> +		goto out_stale;
> +
> +	trace_xfs_buf_iodone_async(bp, _RET_IP_);
> +
> +	cfg = xfs_error_get_cfg(mp, XFS_ERR_METADATA, bp->b_error);
> +	if (xfs_buf_ioerror_retry(bp, cfg)) {
> +		xfs_buf_ioerror(bp, 0);
> +		xfs_buf_submit(bp);
> +		return XBF_IOEND_DONE;
> +	}
> +
> +	/*
> +	 * Permanent error - we need to trigger a shutdown if we haven't already
> +	 * to indicate that inconsistency will result from this action.
> +	 */
> +	if (xfs_buf_ioerror_permanent(bp, cfg)) {
> +		xfs_force_shutdown(mp, SHUTDOWN_META_IO_ERROR);
> +		goto out_stale;
> +	}
> +
> +	/* Still considered a transient error. Caller will schedule retries. */
> +	return XBF_IOEND_FAIL;
> +
> +out_stale:
> +	xfs_buf_stale(bp);
> +	bp->b_flags |= XBF_DONE;
> +	trace_xfs_buf_error_relse(bp, _RET_IP_);
> +	return XBF_IOEND_FINISH;
> +}
>  
>  static void
>  xfs_buf_ioend(
> @@ -1212,12 +1349,42 @@ xfs_buf_ioend(
>  			bp->b_flags |= XBF_DONE;
>  		}
>  
> +		switch (xfs_buf_ioend_disposition(bp)) {
> +		case XBF_IOEND_DONE:
> +			return;
> +		case XBF_IOEND_FAIL:
> +			if (bp->b_flags & _XBF_INODES)
> +				xfs_buf_inode_io_fail(bp);
> +			else if (bp->b_flags & _XBF_DQUOTS)
> +				xfs_buf_dquot_io_fail(bp);
> +			else
> +				ASSERT(list_empty(&bp->b_li_list));
> +			xfs_buf_ioerror(bp, 0);
> +			xfs_buf_relse(bp);
> +			return;
> +		default:
> +			break;
> +		}
> +
> +		/* clear the retry state */
> +		bp->b_last_error = 0;
> +		bp->b_retries = 0;
> +		bp->b_first_retry_time = 0;
> +
> +		/*
> +		 * Note that for things like remote attribute buffers, there may
> +		 * not be a buffer log item here, so processing the buffer log
> +		 * item must remain optional.
> +		 */
> +		if (bp->b_log_item)
> +			xfs_buf_item_done(bp);
> +
>  		if (bp->b_flags & _XBF_INODES)
>  			xfs_buf_inode_iodone(bp);
>  		else if (bp->b_flags & _XBF_DQUOTS)
>  			xfs_buf_dquot_iodone(bp);
> -		else
> -			xfs_buf_iodone(bp);
> +
> +		xfs_buf_ioend_finish(bp);
>  	}
>  }
>  
> diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
> index 19896884189973..ccc9d69683fae4 100644
> --- a/fs/xfs/xfs_buf_item.c
> +++ b/fs/xfs/xfs_buf_item.c
> @@ -31,8 +31,6 @@ static inline struct xfs_buf_log_item *BUF_ITEM(struct xfs_log_item *lip)
>  	return container_of(lip, struct xfs_buf_log_item, bli_item);
>  }
>  
> -static void xfs_buf_item_done(struct xfs_buf *bp);
> -
>  /* Is this log iovec plausibly large enough to contain the buffer log format? */
>  bool
>  xfs_buf_log_check_iovec(
> @@ -464,7 +462,7 @@ xfs_buf_item_unpin(
>  		 */
>  		if (bip->bli_flags & XFS_BLI_STALE_INODE) {
>  			xfs_buf_item_done(bp);
> -			xfs_iflush_done(bp);
> +			xfs_buf_inode_iodone(bp);
>  			ASSERT(list_empty(&bp->b_li_list));
>  		} else {
>  			xfs_trans_ail_delete(lip, SHUTDOWN_LOG_IO_ERROR);
> @@ -957,156 +955,12 @@ xfs_buf_item_relse(
>  	xfs_buf_item_free(bip);
>  }
>  
> -/*
> - * Decide if we're going to retry the write after a failure, and prepare
> - * the buffer for retrying the write.
> - */
> -static bool
> -xfs_buf_ioerror_fail_without_retry(
> -	struct xfs_buf		*bp)
> -{
> -	struct xfs_mount	*mp = bp->b_mount;
> -	static ulong		lasttime;
> -	static xfs_buftarg_t	*lasttarg;
> -
> -	/*
> -	 * If we've already decided to shutdown the filesystem because of
> -	 * I/O errors, there's no point in giving this a retry.
> -	 */
> -	if (XFS_FORCED_SHUTDOWN(mp))
> -		return true;
> -
> -	if (bp->b_target != lasttarg ||
> -	    time_after(jiffies, (lasttime + 5*HZ))) {
> -		lasttime = jiffies;
> -		xfs_buf_ioerror_alert(bp, __this_address);
> -	}
> -	lasttarg = bp->b_target;
> -
> -	/* synchronous writes will have callers process the error */
> -	if (!(bp->b_flags & XBF_ASYNC))
> -		return true;
> -	return false;
> -}
> -
> -static bool
> -xfs_buf_ioerror_retry(
> -	struct xfs_buf		*bp,
> -	struct xfs_error_cfg	*cfg)
> -{
> -	if ((bp->b_flags & (XBF_STALE | XBF_WRITE_FAIL)) &&
> -	    bp->b_last_error == bp->b_error)
> -		return false;
> -
> -	bp->b_flags |= (XBF_WRITE | XBF_DONE | XBF_WRITE_FAIL);
> -	bp->b_last_error = bp->b_error;
> -	if (cfg->retry_timeout != XFS_ERR_RETRY_FOREVER &&
> -	    !bp->b_first_retry_time)
> -		bp->b_first_retry_time = jiffies;
> -	return true;
> -}
> -
> -/*
> - * Account for this latest trip around the retry handler, and decide if
> - * we've failed enough times to constitute a permanent failure.
> - */
> -static bool
> -xfs_buf_ioerror_permanent(
> -	struct xfs_buf		*bp,
> -	struct xfs_error_cfg	*cfg)
> -{
> -	struct xfs_mount	*mp = bp->b_mount;
> -
> -	if (cfg->max_retries != XFS_ERR_RETRY_FOREVER &&
> -	    ++bp->b_retries > cfg->max_retries)
> -		return true;
> -	if (cfg->retry_timeout != XFS_ERR_RETRY_FOREVER &&
> -	    time_after(jiffies, cfg->retry_timeout + bp->b_first_retry_time))
> -		return true;
> -
> -	/* At unmount we may treat errors differently */
> -	if ((mp->m_flags & XFS_MOUNT_UNMOUNTING) && mp->m_fail_unmount)
> -		return true;
> -
> -	return false;
> -}
> -
> -/*
> - * On a sync write or shutdown we just want to stale the buffer and let the
> - * caller handle the error in bp->b_error appropriately.
> - *
> - * If the write was asynchronous then no one will be looking for the error.  If
> - * this is the first failure of this type, clear the error state and write the
> - * buffer out again. This means we always retry an async write failure at least
> - * once, but we also need to set the buffer up to behave correctly now for
> - * repeated failures.
> - *
> - * If we get repeated async write failures, then we take action according to the
> - * error configuration we have been set up to use.
> - *
> - * Multi-state return value:
> - *
> - * XBF_IOEND_FINISH: run callback completions
> - * XBF_IOEND_DONE: resubmitted immediately, do not run any completions
> - * XBF_IOEND_FAIL: transient error, run failure callback completions and then
> - *    release the buffer
> - */
> -enum xfs_buf_ioend_disposition {
> -	XBF_IOEND_FINISH,
> -	XBF_IOEND_DONE,
> -	XBF_IOEND_FAIL,
> -};
> -
> -static enum xfs_buf_ioend_disposition
> -xfs_buf_ioend_disposition(
> -	struct xfs_buf		*bp)
> -{
> -	struct xfs_mount	*mp = bp->b_mount;
> -	struct xfs_error_cfg	*cfg;
> -
> -	if (likely(!bp->b_error))
> -		return XBF_IOEND_FINISH;
> -
> -	if (xfs_buf_ioerror_fail_without_retry(bp))
> -		goto out_stale;
> -
> -	trace_xfs_buf_item_iodone_async(bp, _RET_IP_);
> -
> -	cfg = xfs_error_get_cfg(mp, XFS_ERR_METADATA, bp->b_error);
> -	if (xfs_buf_ioerror_retry(bp, cfg)) {
> -		xfs_buf_ioerror(bp, 0);
> -		xfs_buf_submit(bp);
> -		return XBF_IOEND_DONE;
> -	}
> -
> -	/*
> -	 * Permanent error - we need to trigger a shutdown if we haven't already
> -	 * to indicate that inconsistency will result from this action.
> -	 */
> -	if (xfs_buf_ioerror_permanent(bp, cfg)) {
> -		xfs_force_shutdown(mp, SHUTDOWN_META_IO_ERROR);
> -		goto out_stale;
> -	}
> -
> -	/* Still considered a transient error. Caller will schedule retries. */
> -	return XBF_IOEND_FAIL;
> -
> -out_stale:
> -	xfs_buf_stale(bp);
> -	bp->b_flags |= XBF_DONE;
> -	trace_xfs_buf_error_relse(bp, _RET_IP_);
> -	return XBF_IOEND_FINISH;
> -}
> -
> -static void
> +void
>  xfs_buf_item_done(
>  	struct xfs_buf		*bp)
>  {
>  	struct xfs_buf_log_item	*bip = bp->b_log_item;
>  
> -	if (!bip)
> -		return;
> -
>  	/*
>  	 * If we are forcibly shutting down, this may well be off the AIL
>  	 * already. That's because we simulate the log-committed callbacks to
> @@ -1121,113 +975,3 @@ xfs_buf_item_done(
>  	xfs_buf_item_free(bip);
>  	xfs_buf_rele(bp);
>  }
> -
> -static inline void
> -xfs_buf_clear_ioerror_retry_state(
> -	struct xfs_buf		*bp)
> -{
> -	bp->b_last_error = 0;
> -	bp->b_retries = 0;
> -	bp->b_first_retry_time = 0;
> -}
> -
> -static void
> -xfs_buf_inode_io_fail(
> -	struct xfs_buf		*bp)
> -{
> -	struct xfs_log_item	*lip;
> -
> -	list_for_each_entry(lip, &bp->b_li_list, li_bio_list)
> -		set_bit(XFS_LI_FAILED, &lip->li_flags);
> -
> -	xfs_buf_ioerror(bp, 0);
> -	xfs_buf_relse(bp);
> -}
> -
> -/*
> - * Inode buffer iodone callback function.
> - */
> -void
> -xfs_buf_inode_iodone(
> -	struct xfs_buf		*bp)
> -{
> -	switch (xfs_buf_ioend_disposition(bp)) {
> -	case XBF_IOEND_DONE:
> -		return;
> -	case XBF_IOEND_FAIL:
> -		xfs_buf_inode_io_fail(bp);
> -		return;
> -	default:
> -		break;
> -	}
> -
> -	xfs_buf_clear_ioerror_retry_state(bp);
> -	xfs_buf_item_done(bp);
> -	xfs_iflush_done(bp);
> -	xfs_buf_ioend_finish(bp);
> -}
> -
> -static void
> -xfs_buf_dquot_io_fail(
> -	struct xfs_buf		*bp)
> -{
> -	struct xfs_log_item	*lip;
> -
> -	spin_lock(&bp->b_mount->m_ail->ail_lock);
> -	list_for_each_entry(lip, &bp->b_li_list, li_bio_list)
> -		xfs_set_li_failed(lip, bp);
> -	spin_unlock(&bp->b_mount->m_ail->ail_lock);
> -	xfs_buf_ioerror(bp, 0);
> -	xfs_buf_relse(bp);
> -}
> -
> -/*
> - * Dquot buffer iodone callback function.
> - */
> -void
> -xfs_buf_dquot_iodone(
> -	struct xfs_buf		*bp)
> -{
> -	switch (xfs_buf_ioend_disposition(bp)) {
> -	case XBF_IOEND_DONE:
> -		return;
> -	case XBF_IOEND_FAIL:
> -		xfs_buf_dquot_io_fail(bp);
> -		return;
> -	default:
> -		break;
> -	}
> -
> -	xfs_buf_clear_ioerror_retry_state(bp);
> -	/* a newly allocated dquot buffer might have a log item attached */
> -	xfs_buf_item_done(bp);
> -	xfs_dquot_done(bp);
> -	xfs_buf_ioend_finish(bp);
> -}
> -
> -/*
> - * Dirty buffer iodone callback function.
> - *
> - * Note that for things like remote attribute buffers, there may not be a buffer
> - * log item here, so processing the buffer log item must remain be optional.
> - */
> -void
> -xfs_buf_iodone(
> -	struct xfs_buf		*bp)
> -{
> -	switch (xfs_buf_ioend_disposition(bp)) {
> -	case XBF_IOEND_DONE:
> -		return;
> -	case XBF_IOEND_FAIL:
> -		ASSERT(list_empty(&bp->b_li_list));
> -		xfs_buf_ioerror(bp, 0);
> -		xfs_buf_relse(bp);
> -		return;
> -	default:
> -		break;
> -	}
> -
> -	xfs_buf_clear_ioerror_retry_state(bp);
> -	xfs_buf_item_done(bp);
> -	xfs_buf_ioend_finish(bp);
> -}
> diff --git a/fs/xfs/xfs_buf_item.h b/fs/xfs/xfs_buf_item.h
> index 23507cbb4c4132..55da71fb6e22fc 100644
> --- a/fs/xfs/xfs_buf_item.h
> +++ b/fs/xfs/xfs_buf_item.h
> @@ -50,12 +50,15 @@ struct xfs_buf_log_item {
>  };
>  
>  int	xfs_buf_item_init(struct xfs_buf *, struct xfs_mount *);
> +void	xfs_buf_item_done(struct xfs_buf *bp);
>  void	xfs_buf_item_relse(struct xfs_buf *);
>  bool	xfs_buf_item_put(struct xfs_buf_log_item *);
>  void	xfs_buf_item_log(struct xfs_buf_log_item *, uint, uint);
>  bool	xfs_buf_item_dirty_format(struct xfs_buf_log_item *);
>  void	xfs_buf_inode_iodone(struct xfs_buf *);
> +void	xfs_buf_inode_io_fail(struct xfs_buf *bp);
>  void	xfs_buf_dquot_iodone(struct xfs_buf *);
> +void	xfs_buf_dquot_io_fail(struct xfs_buf *bp);
>  void	xfs_buf_iodone(struct xfs_buf *);
>  bool	xfs_buf_log_check_iovec(struct xfs_log_iovec *iovec);
>  
> diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
> index 76353c9a723ee0..2f309767d8c03b 100644
> --- a/fs/xfs/xfs_dquot.c
> +++ b/fs/xfs/xfs_dquot.c
> @@ -1087,7 +1087,7 @@ xfs_qm_dqflush_done(
>  }
>  
>  void
> -xfs_dquot_done(
> +xfs_buf_dquot_iodone(
>  	struct xfs_buf		*bp)
>  {
>  	struct xfs_log_item	*lip, *n;
> @@ -1098,6 +1098,18 @@ xfs_dquot_done(
>  	}
>  }
>  
> +void
> +xfs_buf_dquot_io_fail(
> +	struct xfs_buf		*bp)
> +{
> +	struct xfs_log_item	*lip;
> +
> +	spin_lock(&bp->b_mount->m_ail->ail_lock);
> +	list_for_each_entry(lip, &bp->b_li_list, li_bio_list)
> +		xfs_set_li_failed(lip, bp);
> +	spin_unlock(&bp->b_mount->m_ail->ail_lock);
> +}
> +
>  /*
>   * Write a modified dquot to disk.
>   * The dquot must be locked and the flush lock too taken by caller.
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 5c07bf491d9f5f..98240126914fc8 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -3569,8 +3569,8 @@ xfs_iflush(
>  	 *
>  	 * What we do is move the bits to the ili_last_fields field.  When
>  	 * logging the inode, these bits are moved back to the ili_fields field.
> -	 * In the xfs_iflush_done() routine we clear ili_last_fields, since we
> -	 * know that the information those bits represent is permanently on
> +	 * In the xfs_buf_inode_iodone() routine we clear ili_last_fields, since
> +	 * we know that the information those bits represent is permanently on
>  	 * disk.  As long as the flush completes before the inode is logged
>  	 * again, then both ili_fields and ili_last_fields will be cleared.
>  	 */
> @@ -3584,7 +3584,7 @@ xfs_iflush(
>  
>  	/*
>  	 * Store the current LSN of the inode so that we can tell whether the
> -	 * item has moved in the AIL from xfs_iflush_done().
> +	 * item has moved in the AIL from xfs_buf_inode_iodone().
>  	 */
>  	xfs_trans_ail_copy_lsn(mp->m_ail, &iip->ili_flush_lsn,
>  				&iip->ili_item.li_lsn);
> diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
> index 3840117f8a5e2c..69c3a40a51db10 100644
> --- a/fs/xfs/xfs_inode_item.c
> +++ b/fs/xfs/xfs_inode_item.c
> @@ -714,7 +714,7 @@ xfs_iflush_finish(
>   * as completing the flush and unlocking the inode.
>   */
>  void
> -xfs_iflush_done(
> +xfs_buf_inode_iodone(
>  	struct xfs_buf		*bp)
>  {
>  	struct xfs_log_item	*lip, *n;
> @@ -753,6 +753,16 @@ xfs_iflush_done(
>  		list_splice_tail(&flushed_inodes, &bp->b_li_list);
>  }
>  
> +void
> +xfs_buf_inode_io_fail(
> +	struct xfs_buf		*bp)
> +{
> +	struct xfs_log_item	*lip;
> +
> +	list_for_each_entry(lip, &bp->b_li_list, li_bio_list)
> +		set_bit(XFS_LI_FAILED, &lip->li_flags);
> +}
> +
>  /*
>   * This is the inode flushing abort routine.  It is called from xfs_iflush when
>   * the filesystem is shutting down to clean up the inode state.  It is
> diff --git a/fs/xfs/xfs_inode_item.h b/fs/xfs/xfs_inode_item.h
> index 048b5e7dee901f..7154d92338a393 100644
> --- a/fs/xfs/xfs_inode_item.h
> +++ b/fs/xfs/xfs_inode_item.h
> @@ -43,7 +43,6 @@ static inline int xfs_inode_clean(struct xfs_inode *ip)
>  
>  extern void xfs_inode_item_init(struct xfs_inode *, struct xfs_mount *);
>  extern void xfs_inode_item_destroy(struct xfs_inode *);
> -extern void xfs_iflush_done(struct xfs_buf *);
>  extern void xfs_iflush_abort(struct xfs_inode *);
>  extern int xfs_inode_item_format_convert(xfs_log_iovec_t *,
>  					 struct xfs_inode_log_format *);
> diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> index 50c478374a31b4..90702c6e5bd7ec 100644
> --- a/fs/xfs/xfs_trace.h
> +++ b/fs/xfs/xfs_trace.h
> @@ -337,7 +337,7 @@ DEFINE_BUF_EVENT(xfs_buf_delwri_split);
>  DEFINE_BUF_EVENT(xfs_buf_delwri_pushbuf);
>  DEFINE_BUF_EVENT(xfs_buf_get_uncached);
>  DEFINE_BUF_EVENT(xfs_buf_item_relse);
> -DEFINE_BUF_EVENT(xfs_buf_item_iodone_async);
> +DEFINE_BUF_EVENT(xfs_buf_iodone_async);
>  DEFINE_BUF_EVENT(xfs_buf_error_relse);
>  DEFINE_BUF_EVENT(xfs_buf_wait_buftarg);
>  DEFINE_BUF_EVENT(xfs_trans_read_buf_shut);
> -- 
> 2.26.2
> 
