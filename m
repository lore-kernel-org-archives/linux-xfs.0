Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C794FC2B9F4
	for <linux-xfs@archiver.kernel.org>; Tue, 22 Jun 2021 12:40:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A62B160FF2
	for <linux-xfs@archiver.kernel.org>; Tue, 22 Jun 2021 12:40:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231644AbhFVMm5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 22 Jun 2021 08:42:57 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:52413 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229999AbhFVMl2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 22 Jun 2021 08:41:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624365552;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ya5yyWfTX8+CsAsj4fkti9KQ8++ZtmpTifiRu8lZnfE=;
        b=NKrgjaVTzWr61i7afM3UTZiElTyd4qRxJEXvMqQVhQTOkC6cXre9buZxa/hm58MPCGzMH1
        kcpywcjGQQyyO06OsNutP8ERD/OwtHD7qVg51nocsyojAWkCl0DexSZEQ8ge5l9cU6B6cw
        JizDISD1Vb0gdij9jNjLgPlAt1zhmmQ=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-115-RiMWcvy6MP-wRRYXXaPnDQ-1; Tue, 22 Jun 2021 08:39:10 -0400
X-MC-Unique: RiMWcvy6MP-wRRYXXaPnDQ-1
Received: by mail-qk1-f197.google.com with SMTP id t131-20020a37aa890000b02903a9f6c1e8bfso17812973qke.10
        for <linux-xfs@vger.kernel.org>; Tue, 22 Jun 2021 05:39:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ya5yyWfTX8+CsAsj4fkti9KQ8++ZtmpTifiRu8lZnfE=;
        b=EyC7gPaWbmjUKqTtuebT237+qZiEOLmW0bUP14lhSBn/Zxbn80JJZ/OXF4UgvCXIOV
         KIDrzLocgWkDtIgCCB8AbQ9boR5AA160zo6UMN2gZ5Db/VZCm1qhCnbWTTrg6aKiXj/x
         T4yZApK+vLUGz9F7qy4MlUmEDzxIj8tj1LE67N+h/FfVxCwqRf9UWajGlbDkIVJCTFS1
         1UUHjy8V6EyTKhMl3vZk6ZMWkh9miY7/QI77mSHNT62LNa5DijCGKaVs5G8CK2zyIxxl
         0wOWS8x0FWSuOy2/Adkr6WvfDNlocwdQuBAADud9/WpS73rz/EPHU1EjTHivTNrmFlL3
         iobw==
X-Gm-Message-State: AOAM533NBDavmGCA6QeDQFSntV+Bialuigqiel96K4+5nnRLPvZZqjxq
        ZQ6op5w7FcJGsVLjy4oLgWjr2OKZGNqgKJYc9Oa3xasWR4NxmpO9IvNgVaop/992oqeqlK6oq+o
        1wISuIRcr14cjNsfOb9sR
X-Received: by 2002:ac8:43cc:: with SMTP id w12mr3228317qtn.137.1624365549882;
        Tue, 22 Jun 2021 05:39:09 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzbfEJNz+1oPlQuu/rRkZ3CB9fowsJdmNZrqGeKU87mHAh2skfneeyNrC3ESv+A50O1p8ov8g==
X-Received: by 2002:ac8:43cc:: with SMTP id w12mr3228298qtn.137.1624365549696;
        Tue, 22 Jun 2021 05:39:09 -0700 (PDT)
Received: from bfoster ([98.216.211.229])
        by smtp.gmail.com with ESMTPSA id m11sm1543418qtn.81.2021.06.22.05.39.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Jun 2021 05:39:09 -0700 (PDT)
Date:   Tue, 22 Jun 2021 08:39:07 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/4] xfs: remove callback dequeue loop from
 xlog_state_do_iclog_callbacks
Message-ID: <YNHZ67ucUUEPJNbh@bfoster>
References: <20210622040604.1290539-1-david@fromorbit.com>
 <20210622040604.1290539-3-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210622040604.1290539-3-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jun 22, 2021 at 02:06:02PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> If we are processing callbacks on an iclog, nothing can be
> concurrently adding callbacks to the loop. We only add callbacks to
> the iclog when they are in ACTIVE or WANT_SYNC state, and we
> explicitly do not add callbacks if the iclog is already in IOERROR
> state.
> 
> The only way to have a dequeue racing with an enqueue is to be
> processing a shutdown without a direct reference to an iclog in
> ACTIVE or WANT_SYNC state. As the enqueue avoids this race
> condition, we only ever need a single dequeue operation in
> xlog_state_do_iclog_callbacks(). Hence we can remove the loop.
> 

This sort of relates to my question on the previous patch..

> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_log.c | 16 ++++++----------
>  1 file changed, 6 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index bb4390942275..05b00fa4d661 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -2774,19 +2774,15 @@ xlog_state_do_iclog_callbacks(
>  	struct xlog		*log,
>  	struct xlog_in_core	*iclog)
>  {
> -	trace_xlog_iclog_callbacks_start(iclog, _RET_IP_);
> -	spin_lock(&iclog->ic_callback_lock);
> -	while (!list_empty(&iclog->ic_callbacks)) {
> -		LIST_HEAD(tmp);
> +	LIST_HEAD(tmp);
>  
> -		list_splice_init(&iclog->ic_callbacks, &tmp);
> -
> -		spin_unlock(&iclog->ic_callback_lock);
> -		xlog_cil_process_committed(&tmp);
> -		spin_lock(&iclog->ic_callback_lock);
> -	}
> +	trace_xlog_iclog_callbacks_start(iclog, _RET_IP_);
>  
> +	spin_lock(&iclog->ic_callback_lock);
> +	list_splice_init(&iclog->ic_callbacks, &tmp);
>  	spin_unlock(&iclog->ic_callback_lock);
> +
> +	xlog_cil_process_committed(&tmp);
>  	trace_xlog_iclog_callbacks_done(iclog, _RET_IP_);
>  }
>  
> -- 
> 2.31.1
> 

