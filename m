Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5BC98C4338F
	for <linux-xfs@archiver.kernel.org>; Thu, 19 Aug 2021 12:57:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3395461152
	for <linux-xfs@archiver.kernel.org>; Thu, 19 Aug 2021 12:57:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229670AbhHSM6P (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 19 Aug 2021 08:58:15 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:34892 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229601AbhHSM6P (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 19 Aug 2021 08:58:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629377858;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=XhRrjzTaG5+y0yW/q84PXZ4yQDL0fewxHdgaKzUhubs=;
        b=Lhppy0G5BDeJHQRPfqYavctKbtN8VjP+FWFBqI76tQ2nIRAuiNoZkrarff3gvz0EWbcKGm
        cV71LA3va5n7UKOAXUy30lxJaAHdfuw8qH8aIK57e6ioU1mncN6qCTddwjla5En4F2uASK
        YeSXjsYJuyGX4AHCXNs/ST7YK418SVg=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-162-TvjTQLRRMDa07CjIGj0-Ng-1; Thu, 19 Aug 2021 08:57:37 -0400
X-MC-Unique: TvjTQLRRMDa07CjIGj0-Ng-1
Received: by mail-ed1-f70.google.com with SMTP id dd25-20020a056402313900b003bed8169691so2791918edb.7
        for <linux-xfs@vger.kernel.org>; Thu, 19 Aug 2021 05:57:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=XhRrjzTaG5+y0yW/q84PXZ4yQDL0fewxHdgaKzUhubs=;
        b=Jk9V1rJm35l5IGKZGdyzj3oRJEHGzi8IJkyU/Fxj4SMnk02ufCe8/Mmd2NhrlcxGKz
         OJ0UyOrpC1V09wZKnklXGeroyx1wmbikZlodMn1Q97+YswEYZuH/n2JvFXZ8E5+WY1Q+
         m93UY3MEZ4R74jp4/UTIvXWbfBUQld2pBc5WvfxhF5rrji6IIqg3og+wWaQZGSGeGLl3
         6Wld541kRvuxdmD9+OWSwzaMtzAP3zfqq/lmmYgJaHWGtB0xK8ZHt/3knq+rTrr+LXa+
         h/wWNY8Lyu9D/DBIBoaQNnlPBgTRs8LTPHkZzgiesqhKRqjSwis4gL/9RCfEnqTZ76Vd
         +uhw==
X-Gm-Message-State: AOAM533BMJG1WnOHGB1EklDPyfKmZ/0AHiggLakgeYdBAr7azkIWPgdV
        gPZYzoWwj++d8rdB2ixXEppVnPY1opo1wHnbgYbcMIC6NuAKSX/lJUqGei4xz2qhiTKfOraRd8I
        Ze9idbLK87gSNLgKMnNQG
X-Received: by 2002:a17:906:720e:: with SMTP id m14mr15421220ejk.500.1629377856379;
        Thu, 19 Aug 2021 05:57:36 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxQALoHd+vJ9dcqSikwYFkltoRIVHTFTb0XCrzMhfs74qdEzn6BxLIzGS0JOZu91QhD1+bk/A==
X-Received: by 2002:a17:906:720e:: with SMTP id m14mr15421205ejk.500.1629377856177;
        Thu, 19 Aug 2021 05:57:36 -0700 (PDT)
Received: from omega.lan (ip4-46-39-172-19.cust.nbox.cz. [46.39.172.19])
        by smtp.gmail.com with ESMTPSA id v21sm1225671ejw.85.2021.08.19.05.57.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Aug 2021 05:57:35 -0700 (PDT)
Date:   Thu, 19 Aug 2021 14:57:33 +0200
From:   Carlos Maiolino <cmaiolino@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     david@fromorbit.com, sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 14/15] xfs: standardize inode generation formatting in
 ftrace output
Message-ID: <20210819125733.wm43xdxiffjbo4qf@omega.lan>
Mail-Followup-To: "Darrick J. Wong" <djwong@kernel.org>,
        david@fromorbit.com, sandeen@sandeen.net, linux-xfs@vger.kernel.org
References: <162924373176.761813.10896002154570305865.stgit@magnolia>
 <162924380913.761813.13285817199891223797.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <162924380913.761813.13285817199891223797.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Aug 17, 2021 at 04:43:29PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Always print inode generation in hexadecimal and preceded with the unit
> "gen".
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

>  fs/xfs/scrub/trace.h |    2 +-
>  fs/xfs/xfs_trace.h   |    2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> 
> diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
> index 36f86b1497f4..2777d882819d 100644
> --- a/fs/xfs/scrub/trace.h
> +++ b/fs/xfs/scrub/trace.h
> @@ -103,7 +103,7 @@ DECLARE_EVENT_CLASS(xchk_class,
>  		__entry->flags = sm->sm_flags;
>  		__entry->error = error;
>  	),
> -	TP_printk("dev %d:%d ino 0x%llx type %s agno 0x%x inum 0x%llx gen %u flags 0x%x error %d",
> +	TP_printk("dev %d:%d ino 0x%llx type %s agno 0x%x inum 0x%llx gen 0x%x flags 0x%x error %d",
>  		  MAJOR(__entry->dev), MINOR(__entry->dev),
>  		  __entry->ino,
>  		  __print_symbolic(__entry->type, XFS_SCRUB_TYPE_STRINGS),
> diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> index 3b53fd681ce7..984a23775340 100644
> --- a/fs/xfs/xfs_trace.h
> +++ b/fs/xfs/xfs_trace.h
> @@ -2364,7 +2364,7 @@ DECLARE_EVENT_CLASS(xfs_log_recover_icreate_item_class,
>  		__entry->gen = be32_to_cpu(in_f->icl_gen);
>  	),
>  	TP_printk("dev %d:%d agno 0x%x agbno 0x%x count %u isize %u blockcount 0x%x "
> -		  "gen %u", MAJOR(__entry->dev), MINOR(__entry->dev),
> +		  "gen 0x%x", MAJOR(__entry->dev), MINOR(__entry->dev),
>  		  __entry->agno, __entry->agbno, __entry->count, __entry->isize,
>  		  __entry->length, __entry->gen)
>  )
> 

-- 
Carlos

