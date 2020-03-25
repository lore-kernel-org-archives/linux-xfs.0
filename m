Return-Path: <SRS0=vNgo=5K=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1DE74C54FCF
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Mar 2020 04:42:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DB4FF20719
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Mar 2020 04:42:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="lwYJROPy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725815AbgCYEmh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 25 Mar 2020 00:42:37 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:48338 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725263AbgCYEmh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 25 Mar 2020 00:42:37 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02P4e0DW186166;
        Wed, 25 Mar 2020 04:42:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=vdJYb9liWGZcxMj7I4T45nEysunmiZc1lumbPewhyFM=;
 b=lwYJROPygdCEKFsXSSmtVBAAgGo3HaRpwjUcJEarXFyHlYLsHBZP0qosUY8dF4BDg5R0
 XrTc4kz++OZjVfQWcs0RU7KaankmCBgDD9aRxNNIWSdDeYp/xvMglm3EB7kTe1coDGLH
 l92Bzr72fV7Z9QpFqQEwK7Vq48IplDfRWxuZ+E6co0j6f03VmNJG6J1xVaBLiO5Zq+In
 r6RCkNPNW+4uZCQRdQhKHleDMLr1UzorMcxvwSnm1pDuOAB6BKtNfKv8EMxRBl6imbCw
 4ueBomqsB24LntvoGnQvwDgAZs3iyj+w5btM1SKJ8ZL2MLcowfCOkSaEbwd861UwqrFb Aw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2ywabr7rx2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 Mar 2020 04:42:34 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02P4QXjM009006;
        Wed, 25 Mar 2020 04:42:33 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2yymbve8j5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 Mar 2020 04:42:33 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 02P4gWuq024126;
        Wed, 25 Mar 2020 04:42:32 GMT
Received: from [192.168.1.223] (/67.1.1.216)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 24 Mar 2020 21:42:31 -0700
Subject: Re: [PATCH 2/8] xfs: Throttle commits on delayed background CIL push
To:     Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
References: <20200325014205.11843-1-david@fromorbit.com>
 <20200325014205.11843-3-david@fromorbit.com>
From:   Allison Collins <allison.henderson@oracle.com>
Message-ID: <7b640fa5-8621-9cc2-d00d-fa949303f198@oracle.com>
Date:   Tue, 24 Mar 2020 21:42:30 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20200325014205.11843-3-david@fromorbit.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9570 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0
 adultscore=0 malwarescore=0 bulkscore=0 spamscore=0 mlxlogscore=999
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003250038
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9570 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0
 lowpriorityscore=0 malwarescore=0 phishscore=0 priorityscore=1501
 clxscore=1015 adultscore=0 mlxscore=0 mlxlogscore=999 bulkscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003250038
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 3/24/20 6:41 PM, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> In certain situations the background CIL push can be indefinitely
> delayed. While we have workarounds from the obvious cases now, it
> doesn't solve the underlying issue. This issue is that there is no
> upper limit on the CIL where we will either force or wait for
> a background push to start, hence allowing the CIL to grow without
> bound until it consumes all log space.
> 
> To fix this, add a new wait queue to the CIL which allows background
> pushes to wait for the CIL context to be switched out. This happens
> when the push starts, so it will allow us to block incoming
> transaction commit completion until the push has started. This will
> only affect processes that are running modifications, and only when
> the CIL threshold has been significantly overrun.
> 
> This has no apparent impact on performance, and doesn't even trigger
> until over 45 million inodes had been created in a 16-way fsmark
> test on a 2GB log. That was limiting at 64MB of log space used, so
> the active CIL size is only about 3% of the total log in that case.
> The concurrent removal of those files did not trigger the background
> sleep at all.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> Reviewed-by: Brian Foster <bfoster@redhat.com>
Ok, I don't see any obvious errors
Reviewed-by: Allison Collins <allison.henderson@oracle.com>

> ---
>   fs/xfs/xfs_log_cil.c  | 37 +++++++++++++++++++++++++++++++++----
>   fs/xfs/xfs_log_priv.h | 24 ++++++++++++++++++++++++
>   fs/xfs/xfs_trace.h    |  1 +
>   3 files changed, 58 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
> index 27de462d2ba40..ac43301ae2f43 100644
> --- a/fs/xfs/xfs_log_cil.c
> +++ b/fs/xfs/xfs_log_cil.c
> @@ -668,6 +668,11 @@ xlog_cil_push_work(
>   	push_seq = cil->xc_push_seq;
>   	ASSERT(push_seq <= ctx->sequence);
>   
> +	/*
> +	 * Wake up any background push waiters now this context is being pushed.
> +	 */
> +	wake_up_all(&ctx->push_wait);
> +
>   	/*
>   	 * Check if we've anything to push. If there is nothing, then we don't
>   	 * move on to a new sequence number and so we have to be able to push
> @@ -744,6 +749,7 @@ xlog_cil_push_work(
>   	 */
>   	INIT_LIST_HEAD(&new_ctx->committing);
>   	INIT_LIST_HEAD(&new_ctx->busy_extents);
> +	init_waitqueue_head(&new_ctx->push_wait);
>   	new_ctx->sequence = ctx->sequence + 1;
>   	new_ctx->cil = cil;
>   	cil->xc_ctx = new_ctx;
> @@ -891,7 +897,7 @@ xlog_cil_push_work(
>    */
>   static void
>   xlog_cil_push_background(
> -	struct xlog	*log)
> +	struct xlog	*log) __releases(cil->xc_ctx_lock)
>   {
>   	struct xfs_cil	*cil = log->l_cilp;
>   
> @@ -905,14 +911,36 @@ xlog_cil_push_background(
>   	 * don't do a background push if we haven't used up all the
>   	 * space available yet.
>   	 */
> -	if (cil->xc_ctx->space_used < XLOG_CIL_SPACE_LIMIT(log))
> +	if (cil->xc_ctx->space_used < XLOG_CIL_SPACE_LIMIT(log)) {
> +		up_read(&cil->xc_ctx_lock);
>   		return;
> +	}
>   
>   	spin_lock(&cil->xc_push_lock);
>   	if (cil->xc_push_seq < cil->xc_current_sequence) {
>   		cil->xc_push_seq = cil->xc_current_sequence;
>   		queue_work(log->l_mp->m_cil_workqueue, &cil->xc_push_work);
>   	}
> +
> +	/*
> +	 * Drop the context lock now, we can't hold that if we need to sleep
> +	 * because we are over the blocking threshold. The push_lock is still
> +	 * held, so blocking threshold sleep/wakeup is still correctly
> +	 * serialised here.
> +	 */
> +	up_read(&cil->xc_ctx_lock);
> +
> +	/*
> +	 * If we are well over the space limit, throttle the work that is being
> +	 * done until the push work on this context has begun.
> +	 */
> +	if (cil->xc_ctx->space_used >= XLOG_CIL_BLOCKING_SPACE_LIMIT(log)) {
> +		trace_xfs_log_cil_wait(log, cil->xc_ctx->ticket);
> +		ASSERT(cil->xc_ctx->space_used < log->l_logsize);
> +		xlog_wait(&cil->xc_ctx->push_wait, &cil->xc_push_lock);
> +		return;
> +	}
> +
>   	spin_unlock(&cil->xc_push_lock);
>   
>   }
> @@ -1032,9 +1060,9 @@ xfs_log_commit_cil(
>   		if (lip->li_ops->iop_committing)
>   			lip->li_ops->iop_committing(lip, xc_commit_lsn);
>   	}
> -	xlog_cil_push_background(log);
>   
> -	up_read(&cil->xc_ctx_lock);
> +	/* xlog_cil_push_background() releases cil->xc_ctx_lock */
> +	xlog_cil_push_background(log);
>   }
>   
>   /*
> @@ -1193,6 +1221,7 @@ xlog_cil_init(
>   
>   	INIT_LIST_HEAD(&ctx->committing);
>   	INIT_LIST_HEAD(&ctx->busy_extents);
> +	init_waitqueue_head(&ctx->push_wait);
>   	ctx->sequence = 1;
>   	ctx->cil = cil;
>   	cil->xc_ctx = ctx;
> diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
> index 8c4be91f62d0d..dacab1817a1b0 100644
> --- a/fs/xfs/xfs_log_priv.h
> +++ b/fs/xfs/xfs_log_priv.h
> @@ -240,6 +240,7 @@ struct xfs_cil_ctx {
>   	struct xfs_log_vec	*lv_chain;	/* logvecs being pushed */
>   	struct list_head	iclog_entry;
>   	struct list_head	committing;	/* ctx committing list */
> +	wait_queue_head_t	push_wait;	/* background push throttle */
>   	struct work_struct	discard_endio_work;
>   };
>   
> @@ -337,10 +338,33 @@ struct xfs_cil {
>    *   buffer window (32MB) as measurements have shown this to be roughly the
>    *   point of diminishing performance increases under highly concurrent
>    *   modification workloads.
> + *
> + * To prevent the CIL from overflowing upper commit size bounds, we introduce a
> + * new threshold at which we block committing transactions until the background
> + * CIL commit commences and switches to a new context. While this is not a hard
> + * limit, it forces the process committing a transaction to the CIL to block and
> + * yeild the CPU, giving the CIL push work a chance to be scheduled and start
> + * work. This prevents a process running lots of transactions from overfilling
> + * the CIL because it is not yielding the CPU. We set the blocking limit at
> + * twice the background push space threshold so we keep in line with the AIL
> + * push thresholds.
> + *
> + * Note: this is not a -hard- limit as blocking is applied after the transaction
> + * is inserted into the CIL and the push has been triggered. It is largely a
> + * throttling mechanism that allows the CIL push to be scheduled and run. A hard
> + * limit will be difficult to implement without introducing global serialisation
> + * in the CIL commit fast path, and it's not at all clear that we actually need
> + * such hard limits given the ~7 years we've run without a hard limit before
> + * finding the first situation where a checkpoint size overflow actually
> + * occurred. Hence the simple throttle, and an ASSERT check to tell us that
> + * we've overrun the max size.
>    */
>   #define XLOG_CIL_SPACE_LIMIT(log)	\
>   	min_t(int, (log)->l_logsize >> 3, BBTOB(XLOG_TOTAL_REC_SHIFT(log)) << 4)
>   
> +#define XLOG_CIL_BLOCKING_SPACE_LIMIT(log)	\
> +	(XLOG_CIL_SPACE_LIMIT(log) * 2)
> +
>   /*
>    * ticket grant locks, queues and accounting have their own cachlines
>    * as these are quite hot and can be operated on concurrently.
> diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> index fbfdd9cf160df..575ca74532f79 100644
> --- a/fs/xfs/xfs_trace.h
> +++ b/fs/xfs/xfs_trace.h
> @@ -1015,6 +1015,7 @@ DEFINE_LOGGRANT_EVENT(xfs_log_ticket_regrant_sub);
>   DEFINE_LOGGRANT_EVENT(xfs_log_ticket_done);
>   DEFINE_LOGGRANT_EVENT(xfs_log_ticket_done_sub);
>   DEFINE_LOGGRANT_EVENT(xfs_log_ticket_done_exit);
> +DEFINE_LOGGRANT_EVENT(xfs_log_cil_wait);
>   
>   DECLARE_EVENT_CLASS(xfs_log_item_class,
>   	TP_PROTO(struct xfs_log_item *lip),
> 
