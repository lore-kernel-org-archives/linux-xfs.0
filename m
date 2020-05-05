Return-Path: <SRS0=NnDK=6T=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0EB11C47247
	for <linux-xfs@archiver.kernel.org>; Tue,  5 May 2020 21:11:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D7C02206FA
	for <linux-xfs@archiver.kernel.org>; Tue,  5 May 2020 21:11:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="LUzJ1IEU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728356AbgEEVLx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 5 May 2020 17:11:53 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:51430 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726350AbgEEVLx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 5 May 2020 17:11:53 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 045L40jW166834;
        Tue, 5 May 2020 21:11:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=EP+LACIccZ8T7DmWVkZOozyS8Whn2cS5mPJzOKcBAkU=;
 b=LUzJ1IEUVd5HVi93GjgjQCbL7KOssEouhoBAf+ElXhPozm4tIDTi96cYE6l9GSWphiIz
 PDL1n6ePYqe+E2GWBSjhseAaQ1M+VT2xKjp9A1m1DCn2jvusZM7FQwGvzio8FmtNo5DH
 Ohvj8ZDdOjFwZfnYjcvsYXeS4K0s7p6oByCxy7DMZK1Q4md+jr0AOcuUTqQIoRGuqfGb
 r0UOynDQE4kRHF6UXoeu7Qc4DdzMv3cm3SAsD67MLLZP+/Op0RC+WhEnA9WXzUpPddME
 EwZ+QtkA2rY9xxiE9MH97AbEkf+Fm5CVEnHzdgPRVLXk7iEVb1/CP8u/TNYxBveDZWjh Vg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 30s09r75y6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 May 2020 21:11:49 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 045L6ufu106739;
        Tue, 5 May 2020 21:09:49 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 30sjdtupes-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 May 2020 21:09:49 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 045L9m8c029303;
        Tue, 5 May 2020 21:09:48 GMT
Received: from [192.168.1.223] (/67.1.142.158)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 05 May 2020 14:09:48 -0700
Subject: Re: [PATCH v4 06/17] xfs: refactor ratelimited buffer error messages
 into helper
To:     Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org
References: <20200504141154.55887-1-bfoster@redhat.com>
 <20200504141154.55887-7-bfoster@redhat.com>
From:   Allison Collins <allison.henderson@oracle.com>
Message-ID: <7ecb16ca-2d78-91ea-4914-932a3ab5c2cb@oracle.com>
Date:   Tue, 5 May 2020 14:09:47 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20200504141154.55887-7-bfoster@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9612 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=2 mlxscore=0
 bulkscore=0 adultscore=0 phishscore=0 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005050163
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9612 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0
 lowpriorityscore=0 spamscore=0 adultscore=0 clxscore=1015 suspectscore=2
 priorityscore=1501 malwarescore=0 mlxlogscore=999 phishscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005050163
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 5/4/20 7:11 AM, Brian Foster wrote:
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
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
Alrighty, make sense
Reviewed-by: Allison Collins <allison.henderson@oracle.com>

> ---
>   fs/xfs/xfs_buf.c      | 15 +++++++++++----
>   fs/xfs/xfs_buf.h      |  1 +
>   fs/xfs/xfs_buf_item.c | 17 ++++-------------
>   fs/xfs/xfs_message.c  | 22 ++++++++++++++++++++++
>   fs/xfs/xfs_message.h  |  3 +++
>   5 files changed, 41 insertions(+), 17 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index fd76a84cefdd..594d5e1df6f8 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -1244,10 +1244,10 @@ xfs_buf_ioerror_alert(
>   	struct xfs_buf		*bp,
>   	xfs_failaddr_t		func)
>   {
> -	xfs_alert_ratelimited(bp->b_mount,
> -"metadata I/O error in \"%pS\" at daddr 0x%llx len %d error %d",
> -			func, (uint64_t)XFS_BUF_ADDR(bp), bp->b_length,
> -			-bp->b_error);
> +	xfs_buf_alert_ratelimited(bp, "XFS: metadata IO error",
> +		"metadata I/O error in \"%pS\" at daddr 0x%llx len %d error %d",
> +				  func, (uint64_t)XFS_BUF_ADDR(bp),
> +				  bp->b_length, -bp->b_error);
>   }
>   
>   /*
> @@ -1828,6 +1828,13 @@ xfs_alloc_buftarg(
>   	btp->bt_bdev = bdev;
>   	btp->bt_daxdev = dax_dev;
>   
> +	/*
> +	 * Buffer IO error rate limiting. Limit it to no more than 10 messages
> +	 * per 30 seconds so as to not spam logs too much on repeated errors.
> +	 */
> +	ratelimit_state_init(&btp->bt_ioerror_rl, 30 * HZ,
> +			     DEFAULT_RATELIMIT_BURST);
> +
>   	if (xfs_setsize_buftarg_early(btp, bdev))
>   		goto error_free;
>   
> diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
> index 06ea3eef866e..050c53b739e2 100644
> --- a/fs/xfs/xfs_buf.h
> +++ b/fs/xfs/xfs_buf.h
> @@ -91,6 +91,7 @@ typedef struct xfs_buftarg {
>   	struct list_lru		bt_lru;
>   
>   	struct percpu_counter	bt_io_count;
> +	struct ratelimit_state	bt_ioerror_rl;
>   } xfs_buftarg_t;
>   
>   struct xfs_buf;
> diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
> index b452a399a441..1f7acffc99ba 100644
> --- a/fs/xfs/xfs_buf_item.c
> +++ b/fs/xfs/xfs_buf_item.c
> @@ -481,14 +481,6 @@ xfs_buf_item_unpin(
>   	}
>   }
>   
> -/*
> - * Buffer IO error rate limiting. Limit it to no more than 10 messages per 30
> - * seconds so as to not spam logs too much on repeated detection of the same
> - * buffer being bad..
> - */
> -
> -static DEFINE_RATELIMIT_STATE(xfs_buf_write_fail_rl_state, 30 * HZ, 10);
> -
>   STATIC uint
>   xfs_buf_item_push(
>   	struct xfs_log_item	*lip,
> @@ -518,11 +510,10 @@ xfs_buf_item_push(
>   	trace_xfs_buf_item_push(bip);
>   
>   	/* has a previous flush failed due to IO errors? */
> -	if ((bp->b_flags & XBF_WRITE_FAIL) &&
> -	    ___ratelimit(&xfs_buf_write_fail_rl_state, "XFS: Failing async write")) {
> -		xfs_warn(bp->b_mount,
> -"Failing async write on buffer block 0x%llx. Retrying async write.",
> -			 (long long)bp->b_bn);
> +	if (bp->b_flags & XBF_WRITE_FAIL) {
> +		xfs_buf_alert_ratelimited(bp, "XFS: Failing async write",
> +	    "Failing async write on buffer block 0x%llx. Retrying async write.",
> +					  (long long)bp->b_bn);
>   	}
>   
>   	if (!xfs_buf_delwri_queue(bp, buffer_list))
> diff --git a/fs/xfs/xfs_message.c b/fs/xfs/xfs_message.c
> index e0f9d3b6abe9..bc66d95c8d4c 100644
> --- a/fs/xfs/xfs_message.c
> +++ b/fs/xfs/xfs_message.c
> @@ -117,3 +117,25 @@ xfs_hex_dump(const void *p, int length)
>   {
>   	print_hex_dump(KERN_ALERT, "", DUMP_PREFIX_OFFSET, 16, 1, p, length, 1);
>   }
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
>   extern void xfs_hex_dump(const void *p, int length);
>   
> +void xfs_buf_alert_ratelimited(struct xfs_buf *bp, const char *rlmsg,
> +			       const char *fmt, ...);
> +
>   #endif	/* __XFS_MESSAGE_H */
> 
