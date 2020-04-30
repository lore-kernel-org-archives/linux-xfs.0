Return-Path: <SRS0=AYd8=6O=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7AAAAC4724C
	for <linux-xfs@archiver.kernel.org>; Thu, 30 Apr 2020 18:42:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3EFB12495B
	for <linux-xfs@archiver.kernel.org>; Thu, 30 Apr 2020 18:42:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="keY0MtRR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726309AbgD3Smd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 30 Apr 2020 14:42:33 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:42922 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726272AbgD3Smd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 30 Apr 2020 14:42:33 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03UIfbjs073141;
        Thu, 30 Apr 2020 18:42:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=XnJbO7DU/jB5Yhv1fQEh5wQr57oJTzqR9QQyuQ1whbc=;
 b=keY0MtRRSMT33pz9sq9hIxAGQjw6U8qrHBTVsJf6dbvyvYJdHYd/lz+hcvnHvLn/duUO
 BMLfWEF2nFfQNDXEXHfey08zOWg5OQhHxUeFBNh/e37yjjwgXmR+niWAC8P3Cv6u2Pdt
 X2tn1JUcZcgokWMtFyg7lIe378TRWO6pJAQp1oZPKC3rCeuQ84CTSgPtugVkz1mH47QJ
 rqX0x4wCuiXYu5qGR9M1xa8r5CqZz/RNZ7uEBweBVoL5xXcegFkxeMlR7uG7TKRK0VWh
 5RRDVkH/gx1KxYGE9V4oktRRmwFVRNOCQIbMv3qendmOb823T+LxH5tyeJoEo5J0EC8b YQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 30p01p3rnk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 30 Apr 2020 18:42:29 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03UIaK1Z078222;
        Thu, 30 Apr 2020 18:42:29 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 30qtg1mgfw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 30 Apr 2020 18:42:29 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 03UIgSjn020880;
        Thu, 30 Apr 2020 18:42:28 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 30 Apr 2020 18:42:28 +0000
Date:   Thu, 30 Apr 2020 11:42:27 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v3 06/17] xfs: refactor ratelimited buffer error messages
 into helper
Message-ID: <20200430184227.GG6742@magnolia>
References: <20200429172153.41680-1-bfoster@redhat.com>
 <20200429172153.41680-7-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200429172153.41680-7-bfoster@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9607 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 adultscore=0
 mlxlogscore=999 phishscore=0 malwarescore=0 spamscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004300144
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9607 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 clxscore=1015
 phishscore=0 mlxlogscore=999 adultscore=0 priorityscore=1501 mlxscore=0
 suspectscore=2 malwarescore=0 lowpriorityscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004300144
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Apr 29, 2020 at 01:21:42PM -0400, Brian Foster wrote:
> XFS has some inconsistent log message rate limiting with respect to
> buffer alerts. The metadata I/O error notification uses the generic
> ratelimited alert, the buffer push code uses a custom rate limit and
> the similar quiesce time failure checks are not rate limited at all
> (when they should be).
> 
> The custom rate limit defined in the buf item code is specifically
> crafted for buffer alerts. It is more aggressive than generic rate
> limiting code because it must accommodate a high frequency of I/O
> error events in a relative short timeframe.
> 
> Factor out the custom rate limit state from the buf item code into a
> per-buftarg rate limit so various alerts are limited based on the
> target. Define a buffer alert helper function and use it for the
> buffer alerts that are already ratelimited.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>

I wonder if there's more that needs to be hooked to the buftarg
ratelimiter, but this seems reasonable enough on its own,

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_buf.c      | 15 +++++++++++----
>  fs/xfs/xfs_buf.h      |  1 +
>  fs/xfs/xfs_buf_item.c | 17 ++++-------------
>  fs/xfs/xfs_message.c  | 22 ++++++++++++++++++++++
>  fs/xfs/xfs_message.h  |  3 +++
>  5 files changed, 41 insertions(+), 17 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index fd76a84cefdd..594d5e1df6f8 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -1244,10 +1244,10 @@ xfs_buf_ioerror_alert(
>  	struct xfs_buf		*bp,
>  	xfs_failaddr_t		func)
>  {
> -	xfs_alert_ratelimited(bp->b_mount,
> -"metadata I/O error in \"%pS\" at daddr 0x%llx len %d error %d",
> -			func, (uint64_t)XFS_BUF_ADDR(bp), bp->b_length,
> -			-bp->b_error);
> +	xfs_buf_alert_ratelimited(bp, "XFS: metadata IO error",
> +		"metadata I/O error in \"%pS\" at daddr 0x%llx len %d error %d",
> +				  func, (uint64_t)XFS_BUF_ADDR(bp),
> +				  bp->b_length, -bp->b_error);
>  }
>  
>  /*
> @@ -1828,6 +1828,13 @@ xfs_alloc_buftarg(
>  	btp->bt_bdev = bdev;
>  	btp->bt_daxdev = dax_dev;
>  
> +	/*
> +	 * Buffer IO error rate limiting. Limit it to no more than 10 messages
> +	 * per 30 seconds so as to not spam logs too much on repeated errors.
> +	 */
> +	ratelimit_state_init(&btp->bt_ioerror_rl, 30 * HZ,
> +			     DEFAULT_RATELIMIT_BURST);
> +
>  	if (xfs_setsize_buftarg_early(btp, bdev))
>  		goto error_free;
>  
> diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
> index 06ea3eef866e..050c53b739e2 100644
> --- a/fs/xfs/xfs_buf.h
> +++ b/fs/xfs/xfs_buf.h
> @@ -91,6 +91,7 @@ typedef struct xfs_buftarg {
>  	struct list_lru		bt_lru;
>  
>  	struct percpu_counter	bt_io_count;
> +	struct ratelimit_state	bt_ioerror_rl;
>  } xfs_buftarg_t;
>  
>  struct xfs_buf;
> diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
> index b452a399a441..1f7acffc99ba 100644
> --- a/fs/xfs/xfs_buf_item.c
> +++ b/fs/xfs/xfs_buf_item.c
> @@ -481,14 +481,6 @@ xfs_buf_item_unpin(
>  	}
>  }
>  
> -/*
> - * Buffer IO error rate limiting. Limit it to no more than 10 messages per 30
> - * seconds so as to not spam logs too much on repeated detection of the same
> - * buffer being bad..
> - */
> -
> -static DEFINE_RATELIMIT_STATE(xfs_buf_write_fail_rl_state, 30 * HZ, 10);
> -
>  STATIC uint
>  xfs_buf_item_push(
>  	struct xfs_log_item	*lip,
> @@ -518,11 +510,10 @@ xfs_buf_item_push(
>  	trace_xfs_buf_item_push(bip);
>  
>  	/* has a previous flush failed due to IO errors? */
> -	if ((bp->b_flags & XBF_WRITE_FAIL) &&
> -	    ___ratelimit(&xfs_buf_write_fail_rl_state, "XFS: Failing async write")) {
> -		xfs_warn(bp->b_mount,
> -"Failing async write on buffer block 0x%llx. Retrying async write.",
> -			 (long long)bp->b_bn);
> +	if (bp->b_flags & XBF_WRITE_FAIL) {
> +		xfs_buf_alert_ratelimited(bp, "XFS: Failing async write",
> +	    "Failing async write on buffer block 0x%llx. Retrying async write.",
> +					  (long long)bp->b_bn);
>  	}
>  
>  	if (!xfs_buf_delwri_queue(bp, buffer_list))
> diff --git a/fs/xfs/xfs_message.c b/fs/xfs/xfs_message.c
> index e0f9d3b6abe9..bc66d95c8d4c 100644
> --- a/fs/xfs/xfs_message.c
> +++ b/fs/xfs/xfs_message.c
> @@ -117,3 +117,25 @@ xfs_hex_dump(const void *p, int length)
>  {
>  	print_hex_dump(KERN_ALERT, "", DUMP_PREFIX_OFFSET, 16, 1, p, length, 1);
>  }
> +
> +void
> +xfs_buf_alert_ratelimited(
> +	struct xfs_buf		*bp,
> +	const char		*rlmsg,
> +	const char		*fmt,
> +	...)
> +{
> +	struct xfs_mount	*mp = bp->b_mount;
> +	struct va_format	vaf;
> +	va_list			args;
> +
> +	/* use the more aggressive per-target rate limit for buffers */
> +	if (!___ratelimit(&bp->b_target->bt_ioerror_rl, rlmsg))
> +		return;
> +
> +	va_start(args, fmt);
> +	vaf.fmt = fmt;
> +	vaf.va = &args;
> +	__xfs_printk(KERN_ALERT, mp, &vaf);
> +	va_end(args);
> +}
> diff --git a/fs/xfs/xfs_message.h b/fs/xfs/xfs_message.h
> index 0b05e10995a0..6be2ebe3a7b9 100644
> --- a/fs/xfs/xfs_message.h
> +++ b/fs/xfs/xfs_message.h
> @@ -62,4 +62,7 @@ void asswarn(struct xfs_mount *mp, char *expr, char *f, int l);
>  
>  extern void xfs_hex_dump(const void *p, int length);
>  
> +void xfs_buf_alert_ratelimited(struct xfs_buf *bp, const char *rlmsg,
> +			       const char *fmt, ...);
> +
>  #endif	/* __XFS_MESSAGE_H */
> -- 
> 2.21.1
> 
