Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10FE2C4338F
	for <linux-xfs@archiver.kernel.org>; Thu, 19 Aug 2021 09:57:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E29016112E
	for <linux-xfs@archiver.kernel.org>; Thu, 19 Aug 2021 09:57:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237662AbhHSJ6N (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 19 Aug 2021 05:58:13 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:35340 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237547AbhHSJ6M (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 19 Aug 2021 05:58:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629367056;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=x3EniS7kl2Jp9Q2Eke6ucdAo+7CenNCdbOIwLio/oAQ=;
        b=fVcARwpqc/r/nKLnuyVwuZn92xnc4PL1rufXXXoN4z47NB30ZEvuBoPmCDF3a5rZ5hZBsW
        SXtI73xVaTeftUGpGc/LXilgLHIjd+EMaWsDs+C0Z1QF7a5cNMr4QbuGO2+XDmmmrPpYIe
        dbgPhGxTPzekrn5fg1dhZ527csfLORg=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-246-VghYVRDQPfWeJStfr9rDRg-1; Thu, 19 Aug 2021 05:57:35 -0400
X-MC-Unique: VghYVRDQPfWeJStfr9rDRg-1
Received: by mail-ej1-f70.google.com with SMTP id ja25-20020a1709079899b02905b2a2bf1a62so2043735ejc.4
        for <linux-xfs@vger.kernel.org>; Thu, 19 Aug 2021 02:57:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=x3EniS7kl2Jp9Q2Eke6ucdAo+7CenNCdbOIwLio/oAQ=;
        b=E9uxIY7xGmM/7t5t1U7B2tMLsBD825weS833lpfMJoiWuc3lhXxp4n31EyXd76sxUX
         w0yhkFo7jE76KvMHUh4KIOx4tqLk6UEtfkTB28BfMNaULCclVAkTtaBP6qCSzGTWLcVb
         JpIakLIYzHOA7csd10WKYPKODcKix+u0ZBlzAKaWaKw+WecElg/L8tiqdml2d4oMuodC
         X0hTcwEjEmZLKTegOqXfZd9lj9zAtVxH4v0uZcfwQKozCFlOtERyAuUHrXWNNLi5pOYE
         S6tfNUfPj7D9CP6SmHNRwYiETzIFfr7ZwVM/PZE6sKAaGN3MBXgo+UFXe0kuS9wlBrtp
         r84Q==
X-Gm-Message-State: AOAM533lwp71wHJInJmr63cbygl/f2Ic+DSD4YTH6iS1XpNTNmEHDlpk
        1bXcdXQ+9CGFaSvz175+zPGN9DvGzsL1N+FNVv6RhXgvRbmhMJ/pQsuX3fnOAOlNk9iQVuaTMec
        41CpG/CxQO0qJU7HBUKww
X-Received: by 2002:a17:906:184e:: with SMTP id w14mr14867388eje.526.1629367054008;
        Thu, 19 Aug 2021 02:57:34 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxVi0cDRuYBi+XGB6D8Ddw4hxPgUHTndlGVOm+Rt1ReOsM+r0qZVGGP2vQwyq7RQhNBkDOUcA==
X-Received: by 2002:a17:906:184e:: with SMTP id w14mr14867374eje.526.1629367053785;
        Thu, 19 Aug 2021 02:57:33 -0700 (PDT)
Received: from omega.lan (ip4-46-39-172-19.cust.nbox.cz. [46.39.172.19])
        by smtp.gmail.com with ESMTPSA id da1sm1476993edb.26.2021.08.19.02.57.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Aug 2021 02:57:33 -0700 (PDT)
Date:   Thu, 19 Aug 2021 11:57:31 +0200
From:   Carlos Maiolino <cmaiolino@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     david@fromorbit.com, sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 05/15] xfs: standardize rmap owner number formatting in
 ftrace output
Message-ID: <20210819095731.e52fo4bmpby2fxde@omega.lan>
Mail-Followup-To: "Darrick J. Wong" <djwong@kernel.org>,
        david@fromorbit.com, sandeen@sandeen.net, linux-xfs@vger.kernel.org
References: <162924373176.761813.10896002154570305865.stgit@magnolia>
 <162924375953.761813.2443716298245181301.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <162924375953.761813.2443716298245181301.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Aug 17, 2021 at 04:42:39PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Always print rmap owner number in hexadecimal and preceded with the unit
> "owner".
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

> ---
>  fs/xfs/scrub/trace.h |    2 +-
>  fs/xfs/xfs_trace.h   |   10 +++++-----
>  2 files changed, 6 insertions(+), 6 deletions(-)
> 
> 
> diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
> index 49822589a4ae..486e6f3c0ea2 100644
> --- a/fs/xfs/scrub/trace.h
> +++ b/fs/xfs/scrub/trace.h
> @@ -699,7 +699,7 @@ DECLARE_EVENT_CLASS(xrep_rmap_class,
>  		__entry->offset = offset;
>  		__entry->flags = flags;
>  	),
> -	TP_printk("dev %d:%d agno 0x%x agbno 0x%x len %u owner %lld offset %llu flags 0x%x",
> +	TP_printk("dev %d:%d agno 0x%x agbno 0x%x len %u owner 0x%llx offset %llu flags 0x%x",
>  		  MAJOR(__entry->dev), MINOR(__entry->dev),
>  		  __entry->agno,
>  		  __entry->agbno,
> diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> index a780b1752ede..d6365a0ee0ff 100644
> --- a/fs/xfs/xfs_trace.h
> +++ b/fs/xfs/xfs_trace.h
> @@ -2598,7 +2598,7 @@ DECLARE_EVENT_CLASS(xfs_map_extent_deferred_class,
>  		__entry->l_state = state;
>  		__entry->op = op;
>  	),
> -	TP_printk("dev %d:%d op %d agno 0x%x agbno 0x%x owner %lld %s offset %llu len %llu state %d",
> +	TP_printk("dev %d:%d op %d agno 0x%x agbno 0x%x owner 0x%llx %s offset %llu len %llu state %d",
>  		  MAJOR(__entry->dev), MINOR(__entry->dev),
>  		  __entry->op,
>  		  __entry->agno,
> @@ -2668,7 +2668,7 @@ DECLARE_EVENT_CLASS(xfs_rmap_class,
>  		if (unwritten)
>  			__entry->flags |= XFS_RMAP_UNWRITTEN;
>  	),
> -	TP_printk("dev %d:%d agno 0x%x agbno 0x%x len %u owner %lld offset %llu flags 0x%lx",
> +	TP_printk("dev %d:%d agno 0x%x agbno 0x%x len %u owner 0x%llx offset %llu flags 0x%lx",
>  		  MAJOR(__entry->dev), MINOR(__entry->dev),
>  		  __entry->agno,
>  		  __entry->agbno,
> @@ -2748,7 +2748,7 @@ DECLARE_EVENT_CLASS(xfs_rmapbt_class,
>  		__entry->offset = offset;
>  		__entry->flags = flags;
>  	),
> -	TP_printk("dev %d:%d agno 0x%x agbno 0x%x len %u owner %lld offset %llu flags 0x%x",
> +	TP_printk("dev %d:%d agno 0x%x agbno 0x%x len %u owner 0x%llx offset %llu flags 0x%x",
>  		  MAJOR(__entry->dev), MINOR(__entry->dev),
>  		  __entry->agno,
>  		  __entry->agbno,
> @@ -3417,7 +3417,7 @@ DECLARE_EVENT_CLASS(xfs_fsmap_class,
>  		__entry->offset = rmap->rm_offset;
>  		__entry->flags = rmap->rm_flags;
>  	),
> -	TP_printk("dev %d:%d keydev %d:%d agno 0x%x bno %llu len %llu owner %lld offset %llu flags 0x%x",
> +	TP_printk("dev %d:%d keydev %d:%d agno 0x%x bno %llu len %llu owner 0x%llx offset %llu flags 0x%x",
>  		  MAJOR(__entry->dev), MINOR(__entry->dev),
>  		  MAJOR(__entry->keydev), MINOR(__entry->keydev),
>  		  __entry->agno,
> @@ -3457,7 +3457,7 @@ DECLARE_EVENT_CLASS(xfs_getfsmap_class,
>  		__entry->offset = fsmap->fmr_offset;
>  		__entry->flags = fsmap->fmr_flags;
>  	),
> -	TP_printk("dev %d:%d keydev %d:%d block %llu len %llu owner %lld offset %llu flags 0x%llx",
> +	TP_printk("dev %d:%d keydev %d:%d block %llu len %llu owner 0x%llx offset %llu flags 0x%llx",
>  		  MAJOR(__entry->dev), MINOR(__entry->dev),
>  		  MAJOR(__entry->keydev), MINOR(__entry->keydev),
>  		  __entry->block,
> 

-- 
Carlos

