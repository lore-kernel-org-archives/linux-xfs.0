Return-Path: <SRS0=IY5l=AV=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A00C7C433DF
	for <linux-xfs@archiver.kernel.org>; Fri, 10 Jul 2020 09:23:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 75F7C20772
	for <linux-xfs@archiver.kernel.org>; Fri, 10 Jul 2020 09:23:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FJbRy8rb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726369AbgGJJXI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 10 Jul 2020 05:23:08 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:34889 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726288AbgGJJXI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 10 Jul 2020 05:23:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594372986;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=zzBMDRXIwS+6kC9xHStganqfBaBQ5fqz8gbN6SOVnKQ=;
        b=FJbRy8rbiFQkKy6jJ9NIP4GoIA3QbQV9AtJbNWTXrVpj9F/k9CpDL+XjRz5s3H7VOe/oCb
        W8oFOzo+uc0leQkpC5czXi2xqWdFdKBfuveBwHuQPWv1pw6hj8I0pbMmsw4IWEL8R9PNL4
        lpnjWSj7wrFsADiSp0TmEZnowvrQcfI=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-288-dr0xgZraPWq6RTkfpjmsSw-1; Fri, 10 Jul 2020 05:23:04 -0400
X-MC-Unique: dr0xgZraPWq6RTkfpjmsSw-1
Received: by mail-wm1-f69.google.com with SMTP id g187so6073965wme.0
        for <linux-xfs@vger.kernel.org>; Fri, 10 Jul 2020 02:23:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:subject:message-id:mail-followup-to
         :references:mime-version:content-disposition:in-reply-to;
        bh=zzBMDRXIwS+6kC9xHStganqfBaBQ5fqz8gbN6SOVnKQ=;
        b=HDI801v2gOl52zAZLZEQDxeEFrLwwO8mT/rsQU5FgNUX/jE1A6Q2/ln/20eVkQjjTA
         iJPnVxTCDXVmaMQn11uJrzgrorjCfTLz5DVvDG4Qftr6dR9FaT+/fFIDTlHah+EI0a/x
         iKYSjG1ZpOVS378EJKAF9eASj1ca5vcwrXGU0gkOzDlHTMv+Q5UTzfs4Xc0rgITowy68
         8EiCEwaOiw/QAVxuhDB/3TyA5CvlHy+sTBTB+xhFtL4lA48PUBBzriEfne2R2dDy07VZ
         IfdxZqzlN6bE10x12++FGGC8OqlumtuubTtsyNC5w6vZTb/luxoPuATNzLRao77sQRzV
         /nog==
X-Gm-Message-State: AOAM53245nsqMKXX68+RBlKNIX9LCM+z1i1O4s0hHrif9LlwDEoK9SWr
        5ynFcYb7k8T5llM7crf2o4KGbczAC6/pveeHBAzGljVfmzxUaJ2mBtH2aQYJroRHWoRat9zWXFx
        2Isa9FivuBVrjR4byLXKT
X-Received: by 2002:adf:ded2:: with SMTP id i18mr67564287wrn.109.1594372983480;
        Fri, 10 Jul 2020 02:23:03 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxnQtExeYH9Fgq0xwQGGguKQgrWgFoNAIzyymzXhQNg/r00PNxazEFEyI3Bv06qlep1DyBK0w==
X-Received: by 2002:adf:ded2:: with SMTP id i18mr67564269wrn.109.1594372983296;
        Fri, 10 Jul 2020 02:23:03 -0700 (PDT)
Received: from eorzea (ip-89-103-126-188.net.upcbroadband.cz. [89.103.126.188])
        by smtp.gmail.com with ESMTPSA id x185sm8957057wmg.41.2020.07.10.02.23.02
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jul 2020 02:23:02 -0700 (PDT)
Date:   Fri, 10 Jul 2020 11:23:00 +0200
From:   Carlos Maiolino <cmaiolino@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH V3 3/5] xfs: Modify xlog_ticket_alloc() to use kernel's
 MM API
Message-ID: <20200710092300.2rppswd6b6a7hclx@eorzea>
Mail-Followup-To: linux-xfs@vger.kernel.org
References: <20200710091536.95828-1-cmaiolino@redhat.com>
 <20200710091536.95828-4-cmaiolino@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200710091536.95828-4-cmaiolino@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org


This is supposed to be V2, I mistyped the subject's tag, my apologies.

On Fri, Jul 10, 2020 at 11:15:34AM +0200, Carlos Maiolino wrote:
> xlog_ticket_alloc() is always called under NOFS context, except from
> unmount path, which eitherway is holding many FS locks, so, there is no
> need for its callers to keep passing allocation flags into it.
> 
> change xlog_ticket_alloc() to use default kmem_cache_zalloc(), remove
> its alloc_flags argument, and always use GFP_NOFS | __GFP_NOFAIL flags.
> 
> Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> ---
> 
> Changelog:
> 	V2:
> 		- Remove alloc_flags argument from xlog_ticket_alloc()
> 		  and update patch description accordingly.
> 
>  fs/xfs/xfs_log.c      | 9 +++------
>  fs/xfs/xfs_log_cil.c  | 3 +--
>  fs/xfs/xfs_log_priv.h | 4 +---
>  3 files changed, 5 insertions(+), 11 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index 00fda2e8e7380..ad0c69ee89475 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -433,7 +433,7 @@ xfs_log_reserve(
>  	XFS_STATS_INC(mp, xs_try_logspace);
>  
>  	ASSERT(*ticp == NULL);
> -	tic = xlog_ticket_alloc(log, unit_bytes, cnt, client, permanent, 0);
> +	tic = xlog_ticket_alloc(log, unit_bytes, cnt, client, permanent);
>  	*ticp = tic;
>  
>  	xlog_grant_push_ail(log, tic->t_cnt ? tic->t_unit_res * tic->t_cnt
> @@ -3408,15 +3408,12 @@ xlog_ticket_alloc(
>  	int			unit_bytes,
>  	int			cnt,
>  	char			client,
> -	bool			permanent,
> -	xfs_km_flags_t		alloc_flags)
> +	bool			permanent)
>  {
>  	struct xlog_ticket	*tic;
>  	int			unit_res;
>  
> -	tic = kmem_zone_zalloc(xfs_log_ticket_zone, alloc_flags);
> -	if (!tic)
> -		return NULL;
> +	tic = kmem_cache_zalloc(xfs_log_ticket_zone, GFP_NOFS | __GFP_NOFAIL);
>  
>  	unit_res = xfs_log_calc_unit_res(log->l_mp, unit_bytes);
>  
> diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
> index 9ed90368ab311..56c32eecffead 100644
> --- a/fs/xfs/xfs_log_cil.c
> +++ b/fs/xfs/xfs_log_cil.c
> @@ -37,8 +37,7 @@ xlog_cil_ticket_alloc(
>  {
>  	struct xlog_ticket *tic;
>  
> -	tic = xlog_ticket_alloc(log, 0, 1, XFS_TRANSACTION, 0,
> -				KM_NOFS);
> +	tic = xlog_ticket_alloc(log, 0, 1, XFS_TRANSACTION, 0);
>  
>  	/*
>  	 * set the current reservation to zero so we know to steal the basic
> diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
> index 75a62870b63af..1c6fdbf3d5066 100644
> --- a/fs/xfs/xfs_log_priv.h
> +++ b/fs/xfs/xfs_log_priv.h
> @@ -464,9 +464,7 @@ xlog_ticket_alloc(
>  	int		unit_bytes,
>  	int		count,
>  	char		client,
> -	bool		permanent,
> -	xfs_km_flags_t	alloc_flags);
> -
> +	bool		permanent);
>  
>  static inline void
>  xlog_write_adv_cnt(void **ptr, int *len, int *off, size_t bytes)
> -- 
> 2.26.2
> 

-- 
Carlos

