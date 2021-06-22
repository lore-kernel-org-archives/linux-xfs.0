Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 185B0C49EA2
	for <linux-xfs@archiver.kernel.org>; Tue, 22 Jun 2021 12:42:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0421060FF2
	for <linux-xfs@archiver.kernel.org>; Tue, 22 Jun 2021 12:42:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231446AbhFVMoP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 22 Jun 2021 08:44:15 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:45982 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231293AbhFVMoA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 22 Jun 2021 08:44:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624365704;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=OwlEtufjM+4iMlqpevxFMZ49J/laHz0egsRZ4NF3YP8=;
        b=eaeX9yPWQSP3T3FoQT9f1BXQiGDA3wqzyB+MljCx/yoAzC/IRaZkxcZND3LzQ78C4KQgNq
        YTA9vF1Wuy/VgegqPaSEdl2y6sg0DtA9VDSuqSfPV6UScuuS0GdNgaHTFJA6N4Kt2x/HaN
        +awJPJSH4sDU6GI4i2fHIR7J3wHXrto=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-446-gqBAtBh0N9a_LPwQbPyD6w-1; Tue, 22 Jun 2021 08:41:39 -0400
X-MC-Unique: gqBAtBh0N9a_LPwQbPyD6w-1
Received: by mail-qk1-f200.google.com with SMTP id r190-20020a375dc70000b02903acea04c19fso17859972qkb.8
        for <linux-xfs@vger.kernel.org>; Tue, 22 Jun 2021 05:41:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=OwlEtufjM+4iMlqpevxFMZ49J/laHz0egsRZ4NF3YP8=;
        b=lVetHfCpSU0wr2P6ccBJsBXCmLyyCtxLwY7HOWwlEVcPDG0xZ6ELGmoEjgvfMUG8fx
         wUMiuJW+xjOGLWe0ajcuXGUaKjXuS5dH1D1sbFNe3NUpP0g9CI4TIYTQdPLiy6+ZyFZv
         ZcmrhZKJf6d3PGSt/6Wbh8mXrEVXfhtBGmOLS2XHuFrllHFBX1AEKlS2Uw6I2vt+TmQ3
         Mfg3H0eERpDGxWdwo8JC4vzJQYa1E4EIGNdFArJC7MlaZTVMwYIvE/Bfq+wMR8nG0s+Q
         81xWXvnQ5XBmFVPVeSj+c7cUz440zALr4uLvoGnBTWcSkOss72RBucgDTIdG7SsEFi7Q
         g31g==
X-Gm-Message-State: AOAM532ebRynI9HX/wmhjUVX0+Ep/XXXmdY3DaL4knU7zqmzV7EN14lm
        BBS2VjRJ0+Teror4Tx//tmen2ROt6YxtrGU3Fb9kIXFwjARJtGDoRvorur+OPKdlFjQQntnJxgq
        qJleMjD+6G+0HQJ8AxKG4
X-Received: by 2002:a05:620a:d45:: with SMTP id o5mr3967039qkl.319.1624365699121;
        Tue, 22 Jun 2021 05:41:39 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJycRjEabNQotD3kWChsG0cUR58LmG4lex7wiHkqBa9NUHxeVpvMm2khn/fpC09Hp4STZycogw==
X-Received: by 2002:a05:620a:d45:: with SMTP id o5mr3967017qkl.319.1624365698933;
        Tue, 22 Jun 2021 05:41:38 -0700 (PDT)
Received: from bfoster ([98.216.211.229])
        by smtp.gmail.com with ESMTPSA id k124sm12458172qkc.132.2021.06.22.05.41.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Jun 2021 05:41:38 -0700 (PDT)
Date:   Tue, 22 Jun 2021 08:41:37 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/4] xfs: Fix a CIL UAF by getting get rid of the iclog
 callback lock
Message-ID: <YNHagR8Z6F4K38ul@bfoster>
References: <20210622040604.1290539-1-david@fromorbit.com>
 <20210622040604.1290539-4-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210622040604.1290539-4-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jun 22, 2021 at 02:06:03PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> The iclog callback chain has it's own lock. That was added way back
> in 2008 by myself to alleviate severe lock contention on the
> icloglock in commit 114d23aae512 ("[XFS] Per iclog callback chain
> lock"). This was long before delayed logging took the icloglock out
> of the hot transaction commit path and removed all contention on it.
> Hence the separate ic_callback_lock doesn't serve any scalability
> purpose anymore, and hasn't for close on a decade.
> 
> Further, we only attach callbacks to iclogs in one place where we
> are already taking the icloglock soon after attaching the callbacks.
> We also have to drop the icloglock to run callbacks and grab it
> immediately afterwards again. So given that the icloglock is no
> longer hot, making it cover callbacks again doesn't really change
> the locking patterns very much at all.
> 
> We also need to extend the icloglock to cover callback addition to
> fix a zero-day UAF in the CIL push code. This occurs when shutdown
> races with xlog_cil_push_work() and the shutdown runs the callbacks
> before the push releases the iclog. This results in the CIL context
> structure attached to the iclog being freed by the callback before
> the CIL push has finished referencing it, leading to UAF bugs.
> 
> Hence, to avoid this UAF, we need the callback attachment to be
> atomic with post processing of the commit iclog and references to
> the structures being attached to the iclog. This requires holding
> the icloglock as that's the only way to serialise iclog state
> against a shutdown in progress.
> 
> The result is we need to be using the icloglock to protect the
> callback list addition and removal and serialise them with shutdown.
> That makes the ic_callback_lock redundant and so it can be removed.
> 
> Fixes: 71e330b59390 ("xfs: Introduce delayed logging core code")
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_log.c      | 34 ++++++----------------------------
>  fs/xfs/xfs_log_cil.c  | 16 ++++++++++++----
>  fs/xfs/xfs_log_priv.h |  3 ---
>  3 files changed, 18 insertions(+), 35 deletions(-)
> 
...
> diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
> index 3c2b1205944d..27bed1d9cf29 100644
> --- a/fs/xfs/xfs_log_cil.c
> +++ b/fs/xfs/xfs_log_cil.c
...
> @@ -898,8 +904,10 @@ xlog_cil_push_work(
>  	 * iclogs to complete before we submit the commit_iclog. In this case,
>  	 * the commit_iclog write needs to issue a pre-flush so that the
>  	 * ordering is correctly preserved down to stable storage.
> +	 *
> +	 * NOTE: It is not safe reference the ctx after this check as we drop

			   safe to reference

> +	 * the icloglock if we have to wait for completion of other iclogs.
>  	 */

Also, it's probably more clear to just say it's not safe to access the
ctx once we drop the lock since the conditional lock cycle is obvious
from the code. Otherwise:

Reviewed-by: Brian Foster <bfoster@redhat.com>

> -	spin_lock(&log->l_icloglock);
>  	if (ctx->start_lsn != commit_lsn) {
>  		xlog_wait_on_iclog(commit_iclog->ic_prev);
>  		spin_lock(&log->l_icloglock);
> diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
> index 293d82b1fc0d..4c41bbfa33b0 100644
> --- a/fs/xfs/xfs_log_priv.h
> +++ b/fs/xfs/xfs_log_priv.h
> @@ -216,9 +216,6 @@ typedef struct xlog_in_core {
>  	enum xlog_iclog_state	ic_state;
>  	unsigned int		ic_flags;
>  	char			*ic_datap;	/* pointer to iclog data */
> -
> -	/* Callback structures need their own cacheline */
> -	spinlock_t		ic_callback_lock ____cacheline_aligned_in_smp;
>  	struct list_head	ic_callbacks;
>  
>  	/* reference counts need their own cacheline */
> -- 
> 2.31.1
> 

