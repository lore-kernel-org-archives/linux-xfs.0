Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11909C2B9F4
	for <linux-xfs@archiver.kernel.org>; Tue, 22 Jun 2021 12:42:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EB67B6135D
	for <linux-xfs@archiver.kernel.org>; Tue, 22 Jun 2021 12:42:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231592AbhFVMoQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 22 Jun 2021 08:44:16 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:42403 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231668AbhFVMoG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 22 Jun 2021 08:44:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624365710;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=1h4NBoGHlJbIItqN0IZMuSkHlJcoxWJndC5p75W4h0E=;
        b=H7V5CObDLFiuxjcyNKH/eLqbjU8U1M2xtA9ChQNkNfLEGbFi+Ut19w18Nt7FGymGcvwPB2
        6bta6FpnIr0ByYu+qsF7eUa0afpAwzjo7bqeadIolz7aspV7wQX+m6/wZXLRfQCYOnirUm
        UpmTymQjGGfCxAf6Y8ze0rhJQ9JU0pc=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-332-44REOWGEMMuqJs44JUYwMw-1; Tue, 22 Jun 2021 08:41:48 -0400
X-MC-Unique: 44REOWGEMMuqJs44JUYwMw-1
Received: by mail-qt1-f199.google.com with SMTP id 5-20020ac859450000b029024ba4a903ccso7640577qtz.6
        for <linux-xfs@vger.kernel.org>; Tue, 22 Jun 2021 05:41:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=1h4NBoGHlJbIItqN0IZMuSkHlJcoxWJndC5p75W4h0E=;
        b=lPij/H+YiJ7t3aOkXNK3qg2QzDI7V/AcbUt4iKPXkzdLd5c2/ZszitmxY/4FzkORM1
         h6he7R02CADJphSXu9zO1D6Ywnt6Etowj40sF0joLQA2KdtXFER2NAn2G8GKhnWq+uSY
         R0f9M80JI9nhWMYqb2ZcXQn2AASQbytoT8bFSYe36At3DmKTA5YoEAWPLCijKJtYYdoC
         uhSE/6pJyxpUfqFsrZiX6Mzqg+AvR0mcEC58m/XYAT+yMsjluT5SZon4nMD5I4Un/d4l
         NgMbOrfd6heTrY8xgCHeIMjCSEkvLiCcR9ChQzQ356wuCDRX78xGGLQMJ56j2J9ecjc1
         bgXg==
X-Gm-Message-State: AOAM530YFMc8inOj4uYipMCEO1+6b/VKk6hH5XD3W57kH3Gx8ebN4muR
        RXWBksDgn199QMQK9o2x0LRjwWoHfcj0XZ1hsjQlz7TZumY98Bhyvy15kqigAXRcQaUhrF7hcFP
        7H1WtWpJ7yp4GJ0Olz0/y
X-Received: by 2002:ae9:e90d:: with SMTP id x13mr4077132qkf.62.1624365708234;
        Tue, 22 Jun 2021 05:41:48 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwcALlUIAvnTEM190IxgnXJ4pFzKDpy+WDw2/faRl0gfRDw7GgTjduHj7xZ5Gq0cwnjg6rzcg==
X-Received: by 2002:ae9:e90d:: with SMTP id x13mr4077120qkf.62.1624365708065;
        Tue, 22 Jun 2021 05:41:48 -0700 (PDT)
Received: from bfoster ([98.216.211.229])
        by smtp.gmail.com with ESMTPSA id x11sm7860747qki.23.2021.06.22.05.41.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Jun 2021 05:41:47 -0700 (PDT)
Date:   Tue, 22 Jun 2021 08:41:46 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/4] xfs: don't wait on future iclogs when pushing the CIL
Message-ID: <YNHaimWBYvHGNrqe@bfoster>
References: <20210622040604.1290539-1-david@fromorbit.com>
 <20210622040604.1290539-5-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210622040604.1290539-5-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jun 22, 2021 at 02:06:04PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> The iclogbuf ring attached to the struct xlog is circular, hence the
> first and last iclogs in the ring can only be determined by
> comparing them against the log->l_iclog pointer.
> 
> In xfs_cil_push_work(), we want to wait on previous iclogs that were
> issued so that we can flush them to stable storage with the commit
> record write, and it simply waits on the previous iclog in the ring.
> This, however, leads to CIL push hangs in generic/019 like so:
> 
> task:kworker/u33:0   state:D stack:12680 pid:    7 ppid:     2 flags:0x00004000
> Workqueue: xfs-cil/pmem1 xlog_cil_push_work
> Call Trace:
>  __schedule+0x30b/0x9f0
>  schedule+0x68/0xe0
>  xlog_wait_on_iclog+0x121/0x190
>  ? wake_up_q+0xa0/0xa0
>  xlog_cil_push_work+0x994/0xa10
>  ? _raw_spin_lock+0x15/0x20
>  ? xfs_swap_extents+0x920/0x920
>  process_one_work+0x1ab/0x390
>  worker_thread+0x56/0x3d0
>  ? rescuer_thread+0x3c0/0x3c0
>  kthread+0x14d/0x170
>  ? __kthread_bind_mask+0x70/0x70
>  ret_from_fork+0x1f/0x30
> 
> With other threads blocking in either xlog_state_get_iclog_space()
> waiting for iclog space or xlog_grant_head_wait() waiting for log
> reservation space.
> 
> The problem here is that the previous iclog on the ring might
> actually be a future iclog. That is, if log->l_iclog points at
> commit_iclog, commit_iclog is the first (oldest) iclog in the ring
> and there are no previous iclogs pending as they have all completed
> their IO and been activated again. IOWs, commit_iclog->ic_prev
> points to an iclog that will be written in the future, not one that
> has been written in the past.
> 
> Hence, in this case, waiting on the ->ic_prev iclog is incorrect
> behaviour, and depending on the state of the future iclog, we can
> end up with a circular ABA wait cycle and we hang.
> 
> The fix is made more complex by the fact that many iclogs states
> cannot be used to determine if the iclog is a past or future iclog.
> Hence we have to determine past iclogs by checking the LSN of the
> iclog rather than their state. A past ACTIVE iclog will have a LSN
> of zero, while a future ACTIVE iclog will have a LSN greater than
> the current iclog. We don't wait on either of these cases.
> 
> Similarly, a future iclog that hasn't completed IO will have an LSN
> greater than the current iclog and so we don't wait on them. A past
> iclog that is still undergoing IO completion will have a LSN less
> than the current iclog and those are the only iclogs that we need to
> wait on.
> 
> Hence we can use the iclog LSN to determine what iclogs we need to
> wait on here.
> 
> Fixes: 5fd9256ce156 ("xfs: separate CIL commit record IO")
> Reported-by: Brian Foster <bfoster@redhat.com>
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_log_cil.c | 35 ++++++++++++++++++++++++++++-------
>  1 file changed, 28 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
> index 27bed1d9cf29..83a932878177 100644
> --- a/fs/xfs/xfs_log_cil.c
> +++ b/fs/xfs/xfs_log_cil.c
> @@ -877,7 +877,7 @@ xlog_cil_push_work(
>  	 * Once we attach the ctx to the iclog, a shutdown can process the
>  	 * iclog, run the callbacks and free the ctx. The only thing preventing
>  	 * this potential UAF situation here is that we are holding the
> -	 * icloglock. Hence we cannot access the ctx after we have attached the
> +	 * icloglock. Hence we cannot access the ctx once we have attached the
>  	 * callbacks and dropped the icloglock.
>  	 */
>  	spin_lock(&log->l_icloglock);
> @@ -900,17 +900,38 @@ xlog_cil_push_work(
>  	spin_unlock(&cil->xc_push_lock);
>  
>  	/*
> -	 * If the checkpoint spans multiple iclogs, wait for all previous
> -	 * iclogs to complete before we submit the commit_iclog. In this case,
> -	 * the commit_iclog write needs to issue a pre-flush so that the
> -	 * ordering is correctly preserved down to stable storage.
> +	 * If the checkpoint spans multiple iclogs, wait for all previous iclogs
> +	 * to complete before we submit the commit_iclog. We can't use state
> +	 * checks for this - ACTIVE can be either a past completed iclog or a
> +	 * future iclog being filled, while WANT_SYNC through SYNC_DONE can be a
> +	 * past or future iclog awaiting IO or ordered IO completion to be run.
> +	 * In the latter case, if it's a future iclog and we wait on it, the we
> +	 * will hang because it won't get processed through to ic_force_wait
> +	 * wakeup until this commit_iclog is written to disk.  Hence we use the
> +	 * iclog header lsn and compare it to the commit lsn to determine if we
> +	 * need to wait on iclogs or not.
>  	 *
>  	 * NOTE: It is not safe reference the ctx after this check as we drop
>  	 * the icloglock if we have to wait for completion of other iclogs.
>  	 */
>  	if (ctx->start_lsn != commit_lsn) {
> -		xlog_wait_on_iclog(commit_iclog->ic_prev);
> -		spin_lock(&log->l_icloglock);
> +		xfs_lsn_t	plsn;
> +
> +		plsn = be64_to_cpu(commit_iclog->ic_prev->ic_header.h_lsn);
> +		if (plsn && XFS_LSN_CMP(plsn, commit_lsn) < 0) {
> +			/*
> +			 * Waiting on ic_force_wait orders the completion of
> +			 * iclogs older than ic_prev. Hence we only need to wait
> +			 * on the most recent older iclog here.
> +			 */
> +			xlog_wait_on_iclog(commit_iclog->ic_prev);
> +			spin_lock(&log->l_icloglock);
> +		}
> +
> +		/*
> +		 * We need to issue a pre-flush so that the ordering for this
> +		 * checkpoint is correctly preserved down to stable storage.
> +		 */
>  		commit_iclog->ic_flags |= XLOG_ICL_NEED_FLUSH;
>  	}
>  
> -- 
> 2.31.1
> 

