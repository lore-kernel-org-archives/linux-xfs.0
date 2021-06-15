Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A10FC48BE5
	for <linux-xfs@archiver.kernel.org>; Tue, 15 Jun 2021 15:38:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3FE4E61494
	for <linux-xfs@archiver.kernel.org>; Tue, 15 Jun 2021 15:38:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231583AbhFOPk3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 15 Jun 2021 11:40:29 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:30483 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231609AbhFOPk0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 15 Jun 2021 11:40:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623771501;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=GQZqxqodLYuBb006+Cum+sMilH+MHHn6VAMHYk9AC2E=;
        b=F4nCzkTgfXEMud/hlHuuUzY96yVE4XokxTdqoTg38f3d8u2nWoJ5k3cVafimBMDpZ1Sr1U
        2VFnyWteM8DRFkjOyrJ95b4cfTHvjj+R5esHc/Eb0S5HY3yBJqUa0vXIO8Lfvhy0WkuqGN
        ch1NnmokXkmZOPLzRPuGyvucj6M94T4=
Received: from mail-oi1-f200.google.com (mail-oi1-f200.google.com
 [209.85.167.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-521-eh3rc0K9OEuOs7WBmWkA7w-1; Tue, 15 Jun 2021 11:38:17 -0400
X-MC-Unique: eh3rc0K9OEuOs7WBmWkA7w-1
Received: by mail-oi1-f200.google.com with SMTP id f16-20020acacf100000b02901eed1481b82so6443826oig.20
        for <linux-xfs@vger.kernel.org>; Tue, 15 Jun 2021 08:38:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=GQZqxqodLYuBb006+Cum+sMilH+MHHn6VAMHYk9AC2E=;
        b=ogSyhWiTEDszi57s8Tt9lskoXT/W+smOEhYS/Lmm4mj95+zJHMNRyi1WxZoloZr9Vj
         5FAITtl3WOFq2ay2myspaBQcNUzx6+lp+L72SOjINuYlnzUOhDXW5jY6oBmPubccL6kb
         Hf9e5okYO6Z0JCcHapz/EFiG8J3m4fc5nX4t4Ldc0g6oXpDq5JTKhCDpmGo68mq91TTJ
         Dqu/bQxEVG18zYmp93u/H84hpa9lsHRdmY96sV8Zpgle7qPdagejbTRtf2vRggiF3XAK
         4BTWDVeFDk6AFu9B8CJq7TWIYhTJwfJzUZOZ3GemB0L+RWO5kc9kXGTCS85ZE7Dgdw9F
         FRkg==
X-Gm-Message-State: AOAM533vOZAD4YZ1S48Ov0NXIKWC0exihJz0pxkj9Boyj+W/edfQfgZd
        0O6qakZ2tdOMQbi3+Rf1oMhxV5TcxkO86GnF0ux+co6xaftw8uNOW5MkKgmkpu20R3S7oQdv0n3
        IL40B288ywIoTaEA9drd1
X-Received: by 2002:a54:4385:: with SMTP id u5mr14789347oiv.30.1623771497109;
        Tue, 15 Jun 2021 08:38:17 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxaE6wRLj4ms9xKkO5gp/TzaTspE+rXCXj/ZQ7UIMmSs4HE5Tsvo0/dyDq2TUveZrRnGJYufg==
X-Received: by 2002:a54:4385:: with SMTP id u5mr14789336oiv.30.1623771496923;
        Tue, 15 Jun 2021 08:38:16 -0700 (PDT)
Received: from bfoster ([98.216.211.229])
        by smtp.gmail.com with ESMTPSA id f25sm4173698oto.26.2021.06.15.08.38.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Jun 2021 08:38:16 -0700 (PDT)
Date:   Tue, 15 Jun 2021 11:38:14 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: don't wait on future iclogs when pushing the CIL
Message-ID: <YMjJZigzh3AbpOPA@bfoster>
References: <20210615064658.854029-1-david@fromorbit.com>
 <20210615064658.854029-3-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210615064658.854029-3-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jun 15, 2021 at 04:46:58PM +1000, Dave Chinner wrote:
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
> Fix this by only waiting on the previous iclog when the commit_iclog
> is not the oldest iclog in the ring.
> 
> Fixes: 5fd9256ce156 ("xfs: separate CIL commit record IO")
> Reported-by: Brian Foster <bfoster@redhat.com>
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_log_cil.c | 18 ++++++++++++------
>  1 file changed, 12 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
> index 705619e9dab4..398f00cf9cbf 100644
> --- a/fs/xfs/xfs_log_cil.c
> +++ b/fs/xfs/xfs_log_cil.c
> @@ -1075,15 +1075,21 @@ xlog_cil_push_work(
>  	ticket = ctx->ticket;
>  
>  	/*
> -	 * If the checkpoint spans multiple iclogs, wait for all previous
> -	 * iclogs to complete before we submit the commit_iclog. In this case,
> -	 * the commit_iclog write needs to issue a pre-flush so that the
> -	 * ordering is correctly preserved down to stable storage.
> +	 * If the checkpoint spans multiple iclogs, wait for all previous iclogs
> +	 * to complete before we submit the commit_iclog. If the commit iclog is
> +	 * at the head of the iclog ring, then all other iclogs have completed
> +	 * and are waiting on this one and hence we don't need to wait.
> +	 *
> +	 * Regardless of whether we need to wait or not, the the commit_iclog
> +	 * write needs to issue a pre-flush so that the ordering for this
> +	 * checkpoint is correctly preserved down to stable storage.
>  	 */
>  	spin_lock(&log->l_icloglock);
>  	if (ctx->start_lsn != commit_lsn) {
> -		xlog_wait_on_iclog(commit_iclog->ic_prev);
> -		spin_lock(&log->l_icloglock);
> +		if (commit_iclog != log->l_iclog) {
> +			xlog_wait_on_iclog(commit_iclog->ic_prev);
> +			spin_lock(&log->l_icloglock);
> +		}

I'm confused at what this is attempting to accomplish. If we have a
single CIL force and that happens to span several iclogs, isn't the goal
to wait on the previous iclog to ensure the previously written content
of the current checkpoint is on-disk? If so, it looks to me that
commit_iclog will always match log->l_iclog in that scenario because in
the commit record path we don't (potentially) switch it out until toward
the end of this function. Hmm.. did you mean to check ->ic_prev against
->l_iclog perhaps, or am I just missing something else?

Brian

>  		commit_iclog->ic_flags |= XLOG_ICL_NEED_FLUSH;
>  	}
>  
> -- 
> 2.31.1
> 

