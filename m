Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1115C4338F
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Jul 2021 17:57:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 858D860F6D
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Jul 2021 17:57:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231925AbhGZRRC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 26 Jul 2021 13:17:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:38560 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229851AbhGZRRC (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 26 Jul 2021 13:17:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4994860F6C;
        Mon, 26 Jul 2021 17:57:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627322250;
        bh=wV1mBLzOggprrpOCnKCNgS4lY4N8q/TdSm5vFTN20B4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gm6bZ9ZSkjIhsVYsgJgWZz8L+CeorjDLwcDWXUQciqzCPoZXpiL5qLEakRolD47mM
         ry5iu0XANR7+mnROEPmXyA7YIwdQi9G8fxv7EWoxKZKQkayXcynU1Ofl2PQUprpYYh
         mMjcCgmBIGNoU8vphZPbsusZQq1q753tO0EFZ/5teKeLyU0JRXuEPD0fYAUzGv/tX7
         nSNJdZPVcmXrDFd6O+DRC6FmpwN2UnNIMcJMAJY+iJ2fRYPVfDW43ykWOMWJ699+Q3
         eslIMw5xadQRhiEwJYMzcfu2VEqqkj7i+9t3iYRk6oCslEb+gn0NyprTOHcspsPn3r
         2Q/bdYeXqNegw==
Date:   Mon, 26 Jul 2021 10:57:30 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 10/10] xfs: need to see iclog flags in tracing
Message-ID: <20210726175730.GZ559212@magnolia>
References: <20210726060716.3295008-1-david@fromorbit.com>
 <20210726060716.3295008-11-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210726060716.3295008-11-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jul 26, 2021 at 04:07:16PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Because I cannot tell if the NEED_FLUSH flag is being set correctly
> by the log force and CIL push machinery without it.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Looks good,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_log_priv.h | 13 ++++++++++---
>  fs/xfs/xfs_trace.h    |  5 ++++-
>  2 files changed, 14 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
> index 7cbde0b4f990..f3e79a45d60a 100644
> --- a/fs/xfs/xfs_log_priv.h
> +++ b/fs/xfs/xfs_log_priv.h
> @@ -59,6 +59,16 @@ enum xlog_iclog_state {
>  	{ XLOG_STATE_DIRTY,	"XLOG_STATE_DIRTY" }, \
>  	{ XLOG_STATE_IOERROR,	"XLOG_STATE_IOERROR" }
>  
> +/*
> + * In core log flags
> + */
> +#define XLOG_ICL_NEED_FLUSH	(1 << 0)	/* iclog needs REQ_PREFLUSH */
> +#define XLOG_ICL_NEED_FUA	(1 << 1)	/* iclog needs REQ_FUA */
> +
> +#define XLOG_ICL_STRINGS \
> +	{ XLOG_ICL_NEED_FLUSH,	"XLOG_ICL_NEED_FLUSH" }, \
> +	{ XLOG_ICL_NEED_FUA,	"XLOG_ICL_NEED_FUA" }
> +
>  
>  /*
>   * Log ticket flags
> @@ -143,9 +153,6 @@ enum xlog_iclog_state {
>  
>  #define XLOG_COVER_OPS		5
>  
> -#define XLOG_ICL_NEED_FLUSH	(1 << 0)	/* iclog needs REQ_PREFLUSH */
> -#define XLOG_ICL_NEED_FUA	(1 << 1)	/* iclog needs REQ_FUA */
> -
>  /* Ticket reservation region accounting */ 
>  #define XLOG_TIC_LEN_MAX	15
>  
> diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> index f9d8d605f9b1..19260291ff8b 100644
> --- a/fs/xfs/xfs_trace.h
> +++ b/fs/xfs/xfs_trace.h
> @@ -3944,6 +3944,7 @@ DECLARE_EVENT_CLASS(xlog_iclog_class,
>  		__field(uint32_t, state)
>  		__field(int32_t, refcount)
>  		__field(uint32_t, offset)
> +		__field(uint32_t, flags)
>  		__field(unsigned long long, lsn)
>  		__field(unsigned long, caller_ip)
>  	),
> @@ -3952,15 +3953,17 @@ DECLARE_EVENT_CLASS(xlog_iclog_class,
>  		__entry->state = iclog->ic_state;
>  		__entry->refcount = atomic_read(&iclog->ic_refcnt);
>  		__entry->offset = iclog->ic_offset;
> +		__entry->flags = iclog->ic_flags;
>  		__entry->lsn = be64_to_cpu(iclog->ic_header.h_lsn);
>  		__entry->caller_ip = caller_ip;
>  	),
> -	TP_printk("dev %d:%d state %s refcnt %d offset %u lsn 0x%llx caller %pS",
> +	TP_printk("dev %d:%d state %s refcnt %d offset %u lsn 0x%llx flags %s caller %pS",
>  		  MAJOR(__entry->dev), MINOR(__entry->dev),
>  		  __print_symbolic(__entry->state, XLOG_STATE_STRINGS),
>  		  __entry->refcount,
>  		  __entry->offset,
>  		  __entry->lsn,
> +		  __print_flags(__entry->flags, "|", XLOG_ICL_STRINGS),
>  		  (char *)__entry->caller_ip)
>  
>  );
> -- 
> 2.31.1
> 
