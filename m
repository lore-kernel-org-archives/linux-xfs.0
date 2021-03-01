Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99662C433E0
	for <linux-xfs@archiver.kernel.org>; Mon,  1 Mar 2021 19:38:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4BBF164DF1
	for <linux-xfs@archiver.kernel.org>; Mon,  1 Mar 2021 19:38:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237560AbhCAThG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 1 Mar 2021 14:37:06 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:57993 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236713AbhCATba (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 1 Mar 2021 14:31:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614627003;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=5DAPBVRA+RIK0TNoYxkm7Oi0k2NNpbqcNOMywIhZADQ=;
        b=i48DeYXRWcV8u2ChkqkPpR+8Zhqq7H5DenjtykEHRjXHmtPxZXYzXmmyGpKkm4qFs6mW9n
        1+xkwQf/UnpJTDhtzlz8lFM0D7xD37JtkqxOKYSmkFWNF69LcuD8YlC3REi3iqSO3IEEI0
        zMg7UjX8LI69+YiLIAwq66FTJ8p3MtU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-520-lyezZ_l4NLCSJFA6REvWEQ-1; Mon, 01 Mar 2021 14:30:02 -0500
X-MC-Unique: lyezZ_l4NLCSJFA6REvWEQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 17D4BC294;
        Mon,  1 Mar 2021 19:30:01 +0000 (UTC)
Received: from bfoster (ovpn-113-120.rdu2.redhat.com [10.10.113.120])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id AF1EC60BFA;
        Mon,  1 Mar 2021 19:30:00 +0000 (UTC)
Date:   Mon, 1 Mar 2021 14:29:58 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 7/8 v2] xfs: journal IO cache flush reductions
Message-ID: <YD1AtpkuMHjz/YuC@bfoster>
References: <20210223033442.3267258-1-david@fromorbit.com>
 <20210223033442.3267258-8-david@fromorbit.com>
 <20210223080503.GW4662@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210223080503.GW4662@dread.disaster.area>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Feb 23, 2021 at 07:05:03PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
...
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
> Version 2:
> - repost manually without git/guilt mangling the patch author
> - fix bug in XLOG_ICL_NEED_FUA definition that didn't manifest as an
>   ordering bug in generic/45[57] until testing the CIL pipelining
>   changes much later in the series.
> 
>  fs/xfs/xfs_log.c      | 33 +++++++++++++++++++++++----------
>  fs/xfs/xfs_log_cil.c  |  7 ++++++-
>  fs/xfs/xfs_log_priv.h |  4 ++++
>  3 files changed, 33 insertions(+), 11 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index 6c3fb6dcb505..08d68a6161ae 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
...
> @@ -1951,7 +1952,7 @@ xlog_sync(
>  	unsigned int		roundoff;       /* roundoff to BB or stripe */
>  	uint64_t		bno;
>  	unsigned int		size;
> -	bool			need_flush = true, split = false;
> +	bool			split = false;

I find the mash of the logic change (i.e. when to flush) and rework of
the bool to ->ic_flags changes in this patch unnecessarily convoluted.
IMO, this should be two patches.

>  
>  	ASSERT(atomic_read(&iclog->ic_refcnt) == 0);
>  
> @@ -2009,13 +2010,14 @@ xlog_sync(
>  	 * synchronously here; for an internal log we can simply use the block
>  	 * layer state machine for preflushes.
>  	 */
> -	if (log->l_targ != log->l_mp->m_ddev_targp || split) {
> +	if (log->l_targ != log->l_mp->m_ddev_targp ||
> +	    (split && (iclog->ic_flags & XLOG_ICL_NEED_FLUSH))) {
>  		xfs_flush_bdev(log->l_mp->m_ddev_targp->bt_bdev);
> -		need_flush = false;
> +		iclog->ic_flags &= ~XLOG_ICL_NEED_FLUSH;
>  	}
>  
>  	xlog_verify_iclog(log, iclog, count);
> -	xlog_write_iclog(log, iclog, bno, count, need_flush);
> +	xlog_write_iclog(log, iclog, bno, count);
>  }
>  
>  /*
> @@ -2469,10 +2471,21 @@ xlog_write(
>  		ASSERT(log_offset <= iclog->ic_size - 1);
>  		ptr = iclog->ic_datap + log_offset;
>  
> -		/* start_lsn is the first lsn written to. That's all we need. */
> +		/* Start_lsn is the first lsn written to. */
>  		if (start_lsn && !*start_lsn)
>  			*start_lsn = be64_to_cpu(iclog->ic_header.h_lsn);
>  
> +		/*
> +		 * iclogs containing commit records or unmount records need
> +		 * to issue ordering cache flushes and commit immediately
> +		 * to stable storage to guarantee journal vs metadata ordering
> +		 * is correctly maintained in the storage media.
> +		 */
> +		if (optype & (XLOG_COMMIT_TRANS | XLOG_UNMOUNT_TRANS)) {
> +			iclog->ic_flags |= (XLOG_ICL_NEED_FLUSH |
> +						XLOG_ICL_NEED_FUA);
> +		}
> +
>  		/*
>  		 * This loop writes out as many regions as can fit in the amount
>  		 * of space which was allocated by xlog_state_get_iclog_space().
> diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
> index 4093d2d0db7c..370da7c2bfc8 100644
> --- a/fs/xfs/xfs_log_cil.c
> +++ b/fs/xfs/xfs_log_cil.c
> @@ -894,10 +894,15 @@ xlog_cil_push_work(
>  
>  	/*
>  	 * If the checkpoint spans multiple iclogs, wait for all previous
> -	 * iclogs to complete before we submit the commit_iclog.
> +	 * iclogs to complete before we submit the commit_iclog. If it is in the
> +	 * same iclog as the start of the checkpoint, then we can skip the iclog
> +	 * cache flush because there are no other iclogs we need to order
> +	 * against.
>  	 */
>  	if (ctx->start_lsn != commit_lsn)
>  		xlog_wait_on_iclog_lsn(commit_iclog, ctx->start_lsn);
> +	else
> +		commit_iclog->ic_flags &= ~XLOG_ICL_NEED_FLUSH;

Is there a reason we're making these iclog changes (here and in
xlog_write(), at least) outside of ->l_icloglock? I suspect this is safe
atm due to the fact that the CIL push is single threaded via the
workqueue, but the rest of the iclog management code is written with
proper internal exclusion in mind. This seems like a bit of a landmine
if the execution context is the only thing protecting us here... hm?

Brian

>  
>  	/* release the hounds! */
>  	xfs_log_release_iclog(commit_iclog);
> diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
> index 10a41b1dd895..a77e00b7789a 100644
> --- a/fs/xfs/xfs_log_priv.h
> +++ b/fs/xfs/xfs_log_priv.h
> @@ -133,6 +133,9 @@ enum xlog_iclog_state {
>  
>  #define XLOG_COVER_OPS		5
>  
> +#define XLOG_ICL_NEED_FLUSH	(1 << 0)	/* iclog needs REQ_PREFLUSH */
> +#define XLOG_ICL_NEED_FUA	(1 << 1)	/* iclog needs REQ_FUA */
> +
>  /* Ticket reservation region accounting */ 
>  #define XLOG_TIC_LEN_MAX	15
>  
> @@ -201,6 +204,7 @@ typedef struct xlog_in_core {
>  	u32			ic_size;
>  	u32			ic_offset;
>  	enum xlog_iclog_state	ic_state;
> +	unsigned int		ic_flags;
>  	char			*ic_datap;	/* pointer to iclog data */
>  
>  	/* Callback structures need their own cacheline */
> 

