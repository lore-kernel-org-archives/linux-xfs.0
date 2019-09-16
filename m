Return-Path: <SRS0=IYS1=XL=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3FD0C49ED7
	for <linux-xfs@archiver.kernel.org>; Mon, 16 Sep 2019 16:43:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7CE1921852
	for <linux-xfs@archiver.kernel.org>; Mon, 16 Sep 2019 16:43:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="M5A/5P5b"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390098AbfIPQnC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 16 Sep 2019 12:43:02 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:46256 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727981AbfIPQnC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 16 Sep 2019 12:43:02 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8GGEPGu153094;
        Mon, 16 Sep 2019 16:42:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=WRy229U4EhbdkBD9mP4h0IKWqz95ElPrP/6sbAM1T6w=;
 b=M5A/5P5bBKHJ89EDMd34xBOY2abQwrgEXsyXG5Ti/wxK61xnOgZBQQji2mOonyHqlSF+
 k5iEEDeVrEB+GB8xx9No636SCWRc+D+0ylSI9uGVMkw4vp212ERrbb8GwZYZOcUmDaid
 7tF3eiRPMUCIQ14Lze6s/ywP5ihbcfktUABEiocLKkDxf7hgkyJ4l0ASkTtyNtaUqZfQ
 0xP6SPdS00KX7rWT9I1haHOWDSsIArtj6alvbmqEgUKpSGpT+onyLERGoJS/hWZUQNGe
 KbhIroTiiaZA5XKyizKHFEyKEUl5YBpjflcJ6W/1aqAjmTBpxag2i/qHhjhm5buEo7ZS MA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2v0ruqgqxr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 16 Sep 2019 16:42:59 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8GGDYGj109696;
        Mon, 16 Sep 2019 16:42:58 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 2v0p8uvbqm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 16 Sep 2019 16:42:58 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x8GGgvme026356;
        Mon, 16 Sep 2019 16:42:57 GMT
Received: from localhost (/10.159.225.108)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 16 Sep 2019 09:42:56 -0700
Date:   Mon, 16 Sep 2019 09:42:55 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: hard limit the background CIL push
Message-ID: <20190916164255.GA2229799@magnolia>
References: <20190909015159.19662-1-david@fromorbit.com>
 <20190909015159.19662-3-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190909015159.19662-3-david@fromorbit.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9382 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1909160167
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9382 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1909160167
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Sep 09, 2019 at 11:51:59AM +1000, Dave Chinner wrote:
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
> ---
>  fs/xfs/xfs_log_cil.c  | 30 +++++++++++++++++++++++++-----
>  fs/xfs/xfs_log_priv.h |  1 +
>  2 files changed, 26 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
> index ef652abd112c..eec9b32f5e08 100644
> --- a/fs/xfs/xfs_log_cil.c
> +++ b/fs/xfs/xfs_log_cil.c
> @@ -670,6 +670,11 @@ xlog_cil_push(
>  	push_seq = cil->xc_push_seq;
>  	ASSERT(push_seq <= ctx->sequence);
>  
> +	/*
> +	 * Wake up any background push waiters now this context is being pushed.
> +	 */
> +	wake_up_all(&ctx->push_wait);
> +
>  	/*
>  	 * Check if we've anything to push. If there is nothing, then we don't
>  	 * move on to a new sequence number and so we have to be able to push
> @@ -746,6 +751,7 @@ xlog_cil_push(
>  	 */
>  	INIT_LIST_HEAD(&new_ctx->committing);
>  	INIT_LIST_HEAD(&new_ctx->busy_extents);
> +	init_waitqueue_head(&new_ctx->push_wait);
>  	new_ctx->sequence = ctx->sequence + 1;
>  	new_ctx->cil = cil;
>  	cil->xc_ctx = new_ctx;
> @@ -898,7 +904,7 @@ xlog_cil_push_work(
>   * checkpoint), but commit latency and memory usage limit this to a smaller
>   * size.
>   */
> -static void
> +static bool
>  xlog_cil_push_background(
>  	struct xlog	*log)
>  {
> @@ -915,14 +921,28 @@ xlog_cil_push_background(
>  	 * space available yet.
>  	 */
>  	if (cil->xc_ctx->space_used < XLOG_CIL_SPACE_LIMIT(log))
> -		return;
> +		return false;
>  
>  	spin_lock(&cil->xc_push_lock);
>  	if (cil->xc_push_seq < cil->xc_current_sequence) {
>  		cil->xc_push_seq = cil->xc_current_sequence;
>  		queue_work(log->l_mp->m_cil_workqueue, &cil->xc_push_work);
>  	}
> +
> +	/*
> +	 * If we are well over the space limit, throttle the work that is being
> +	 * done until the push work on this context has begun. This will prevent
> +	 * the CIL from violating maximum transaction size limits if the CIL
> +	 * push is delayed for some reason.
> +	 */
> +	if (cil->xc_ctx->space_used > XLOG_CIL_SPACE_LIMIT(log) * 2) {
> +		up_read(&cil->xc_ctx_lock);
> +		trace_printk("CIL space used %d", cil->xc_ctx->space_used);

Needs a real tracepoint before this drops RFC status.

> +		xlog_wait(&cil->xc_ctx->push_wait, &cil->xc_push_lock);
> +		return true;
> +	}
>  	spin_unlock(&cil->xc_push_lock);
> +	return false;
>  
>  }
>  
> @@ -1038,9 +1058,8 @@ xfs_log_commit_cil(
>  		if (lip->li_ops->iop_committing)
>  			lip->li_ops->iop_committing(lip, xc_commit_lsn);
>  	}
> -	xlog_cil_push_background(log);
> -
> -	up_read(&cil->xc_ctx_lock);
> +	if (!xlog_cil_push_background(log))
> +		up_read(&cil->xc_ctx_lock);

Hmmmm... the return value here tell us if ctx_lock has been dropped.
/me wonders if this would be cleaner if xlog_cil_push_background
returned having called up_read...?

--D

>  }
>  
>  /*
> @@ -1199,6 +1218,7 @@ xlog_cil_init(
>  
>  	INIT_LIST_HEAD(&ctx->committing);
>  	INIT_LIST_HEAD(&ctx->busy_extents);
> +	init_waitqueue_head(&ctx->push_wait);
>  	ctx->sequence = 1;
>  	ctx->cil = cil;
>  	cil->xc_ctx = ctx;
> diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
> index 187a43ffeaf7..466259fd1e4a 100644
> --- a/fs/xfs/xfs_log_priv.h
> +++ b/fs/xfs/xfs_log_priv.h
> @@ -247,6 +247,7 @@ struct xfs_cil_ctx {
>  	struct xfs_log_vec	*lv_chain;	/* logvecs being pushed */
>  	struct list_head	iclog_entry;
>  	struct list_head	committing;	/* ctx committing list */
> +	wait_queue_head_t	push_wait;	/* background push throttle */
>  	struct work_struct	discard_endio_work;
>  };
>  
> -- 
> 2.23.0.rc1
> 
