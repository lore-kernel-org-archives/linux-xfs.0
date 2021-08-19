Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7C3BC4338F
	for <linux-xfs@archiver.kernel.org>; Thu, 19 Aug 2021 12:43:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9C0106023D
	for <linux-xfs@archiver.kernel.org>; Thu, 19 Aug 2021 12:43:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230505AbhHSMno (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 19 Aug 2021 08:43:44 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:56377 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230292AbhHSMno (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 19 Aug 2021 08:43:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629376987;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=rG7f8VvV1A3zcELQKsHG6MY/UvwL4DFm5DxuSX+vunw=;
        b=eUAQPE0BwqBcQuc3IJchxgTJAmnNvaTVxTAgKMdMy3+XSICGvMtX4SzQ1AWruQM2PGHd+9
        7J14idsxE/kwU3/q43zjGXYS+UT6REMJ8Jed4KukR4MRVgw442avK/LbIQ/JpLJMNNQGK+
        4cZhH6T4mOhUpYeS62xrfIiDdGwMMK4=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-484-VhEdt6vpNZ2c-1f40dmmBA-1; Thu, 19 Aug 2021 08:43:06 -0400
X-MC-Unique: VhEdt6vpNZ2c-1f40dmmBA-1
Received: by mail-ej1-f69.google.com with SMTP id ne21-20020a1709077b95b029057eb61c6fdfso2181657ejc.22
        for <linux-xfs@vger.kernel.org>; Thu, 19 Aug 2021 05:43:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=rG7f8VvV1A3zcELQKsHG6MY/UvwL4DFm5DxuSX+vunw=;
        b=Yp3OCS9/GjA3XcO2GEP2glVyV9qPjVU8sfRTzS6+8MewrLUdw5Wdc6MBKYmI/foMKH
         giU2Qz5J+b09pqHvClsSxeC9DmRWPC2MRsFY4FLpA4c9rcYrpFGft0BM3wkeO3xyaD02
         l+0l9LwRQfPMixjxwKS2tqT+4eIxsc0UfkGDV12UmtubfZoK1K9i62vEz7cwzxy8XkK1
         LBQjjGEg3Pj3dtrujn8s/85HxCz6oh8MffLiF/Fb6zhmBG/tNf9odhzcd1xtHATRrBgv
         FClcgIHj2E/O3wuqgytlqZpIJZp91ITExHci4rr15cptSMCkkcq+hRx0oiAsH/vcSs0H
         9HAg==
X-Gm-Message-State: AOAM531UloW0E0nIe1N8KMqK4kZdaTx72NUHEN+loIJEbOXG0YLJGxIc
        GKNAYod/+a6H+ht/+PNtaQQdsuZ7iIK29Lohy1snKvgje5xLj46TbYjWX6IRy2qLvqasp3kFNCH
        oa1fe7OO8MBciNpTrD7rb
X-Received: by 2002:a05:6402:1912:: with SMTP id e18mr16059517edz.135.1629376984962;
        Thu, 19 Aug 2021 05:43:04 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzqD0TsJZnUNZYhhm4hhgkw0Y3o5IYk/AmYWl8/cZJ3/EKHOlgSJv8K0mTeyRZQH9uj/tYE4w==
X-Received: by 2002:a05:6402:1912:: with SMTP id e18mr16059504edz.135.1629376984790;
        Thu, 19 Aug 2021 05:43:04 -0700 (PDT)
Received: from omega.lan (ip4-46-39-172-19.cust.nbox.cz. [46.39.172.19])
        by smtp.gmail.com with ESMTPSA id kv4sm1268252ejc.35.2021.08.19.05.43.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Aug 2021 05:43:04 -0700 (PDT)
Date:   Thu, 19 Aug 2021 14:43:02 +0200
From:   Carlos Maiolino <cmaiolino@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     david@fromorbit.com, sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 12/15] xfs: resolve fork names in trace output
Message-ID: <20210819124302.qc2uwyaocb2wunyv@omega.lan>
Mail-Followup-To: "Darrick J. Wong" <djwong@kernel.org>,
        david@fromorbit.com, sandeen@sandeen.net, linux-xfs@vger.kernel.org
References: <162924373176.761813.10896002154570305865.stgit@magnolia>
 <162924379815.761813.4507794744090240998.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <162924379815.761813.4507794744090240998.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Aug 17, 2021 at 04:43:18PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Emit whichfork values as text strings in the ftrace output.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

>  fs/xfs/libxfs/xfs_types.h |    5 +++++
>  fs/xfs/scrub/trace.h      |   16 ++++++++--------
>  fs/xfs/xfs_trace.h        |    6 +++---
>  3 files changed, 16 insertions(+), 11 deletions(-)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_types.h b/fs/xfs/libxfs/xfs_types.h
> index 0870ef6f933d..b6da06b40989 100644
> --- a/fs/xfs/libxfs/xfs_types.h
> +++ b/fs/xfs/libxfs/xfs_types.h
> @@ -87,6 +87,11 @@ typedef void *		xfs_failaddr_t;
>  #define	XFS_ATTR_FORK	1
>  #define	XFS_COW_FORK	2
>  
> +#define XFS_WHICHFORK_STRINGS \
> +	{ XFS_DATA_FORK, 	"data" }, \
> +	{ XFS_ATTR_FORK,	"attr" }, \
> +	{ XFS_COW_FORK,		"cow" }
> +
>  /*
>   * Min numbers of data/attr fork btree root pointers.
>   */
> diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
> index cb5a74028b63..36f86b1497f4 100644
> --- a/fs/xfs/scrub/trace.h
> +++ b/fs/xfs/scrub/trace.h
> @@ -176,10 +176,10 @@ TRACE_EVENT(xchk_file_op_error,
>  		__entry->error = error;
>  		__entry->ret_ip = ret_ip;
>  	),
> -	TP_printk("dev %d:%d ino 0x%llx fork %d type %s fileoff 0x%llx error %d ret_ip %pS",
> +	TP_printk("dev %d:%d ino 0x%llx fork %s type %s fileoff 0x%llx error %d ret_ip %pS",
>  		  MAJOR(__entry->dev), MINOR(__entry->dev),
>  		  __entry->ino,
> -		  __entry->whichfork,
> +		  __print_symbolic(__entry->whichfork, XFS_WHICHFORK_STRINGS),
>  		  __print_symbolic(__entry->type, XFS_SCRUB_TYPE_STRINGS),
>  		  __entry->offset,
>  		  __entry->error,
> @@ -273,10 +273,10 @@ DECLARE_EVENT_CLASS(xchk_fblock_error_class,
>  		__entry->offset = offset;
>  		__entry->ret_ip = ret_ip;
>  	),
> -	TP_printk("dev %d:%d ino 0x%llx fork %d type %s fileoff 0x%llx ret_ip %pS",
> +	TP_printk("dev %d:%d ino 0x%llx fork %s type %s fileoff 0x%llx ret_ip %pS",
>  		  MAJOR(__entry->dev), MINOR(__entry->dev),
>  		  __entry->ino,
> -		  __entry->whichfork,
> +		  __print_symbolic(__entry->whichfork, XFS_WHICHFORK_STRINGS),
>  		  __print_symbolic(__entry->type, XFS_SCRUB_TYPE_STRINGS),
>  		  __entry->offset,
>  		  __entry->ret_ip)
> @@ -381,10 +381,10 @@ TRACE_EVENT(xchk_ifork_btree_op_error,
>  		__entry->error = error;
>  		__entry->ret_ip = ret_ip;
>  	),
> -	TP_printk("dev %d:%d ino 0x%llx fork %d type %s btree %s level %d ptr %d agno 0x%x agbno 0x%x error %d ret_ip %pS",
> +	TP_printk("dev %d:%d ino 0x%llx fork %s type %s btree %s level %d ptr %d agno 0x%x agbno 0x%x error %d ret_ip %pS",
>  		  MAJOR(__entry->dev), MINOR(__entry->dev),
>  		  __entry->ino,
> -		  __entry->whichfork,
> +		  __print_symbolic(__entry->whichfork, XFS_WHICHFORK_STRINGS),
>  		  __print_symbolic(__entry->type, XFS_SCRUB_TYPE_STRINGS),
>  		  __print_symbolic(__entry->btnum, XFS_BTNUM_STRINGS),
>  		  __entry->level,
> @@ -460,10 +460,10 @@ TRACE_EVENT(xchk_ifork_btree_error,
>  		__entry->ptr = cur->bc_ptrs[level];
>  		__entry->ret_ip = ret_ip;
>  	),
> -	TP_printk("dev %d:%d ino 0x%llx fork %d type %s btree %s level %d ptr %d agno 0x%x agbno 0x%x ret_ip %pS",
> +	TP_printk("dev %d:%d ino 0x%llx fork %s type %s btree %s level %d ptr %d agno 0x%x agbno 0x%x ret_ip %pS",
>  		  MAJOR(__entry->dev), MINOR(__entry->dev),
>  		  __entry->ino,
> -		  __entry->whichfork,
> +		  __print_symbolic(__entry->whichfork, XFS_WHICHFORK_STRINGS),
>  		  __print_symbolic(__entry->type, XFS_SCRUB_TYPE_STRINGS),
>  		  __print_symbolic(__entry->btnum, XFS_BTNUM_STRINGS),
>  		  __entry->level,
> diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> index 29bf5fbfa71b..474fdaffdccf 100644
> --- a/fs/xfs/xfs_trace.h
> +++ b/fs/xfs/xfs_trace.h
> @@ -1440,7 +1440,7 @@ DECLARE_EVENT_CLASS(xfs_imap_class,
>  		  __entry->size,
>  		  __entry->offset,
>  		  __entry->count,
> -		  __entry->whichfork == XFS_COW_FORK ? "cow" : "data",
> +		  __print_symbolic(__entry->whichfork, XFS_WHICHFORK_STRINGS),
>  		  __entry->startoff,
>  		  (int64_t)__entry->startblock,
>  		  __entry->blockcount)
> @@ -2604,7 +2604,7 @@ DECLARE_EVENT_CLASS(xfs_map_extent_deferred_class,
>  		  __entry->agno,
>  		  __entry->agbno,
>  		  __entry->ino,
> -		  __entry->whichfork == XFS_ATTR_FORK ? "attr" : "data",
> +		  __print_symbolic(__entry->whichfork, XFS_WHICHFORK_STRINGS),
>  		  __entry->l_loff,
>  		  __entry->l_len,
>  		  __entry->l_state)
> @@ -3851,7 +3851,7 @@ TRACE_EVENT(xfs_btree_commit_ifakeroot,
>  		  __print_symbolic(__entry->btnum, XFS_BTNUM_STRINGS),
>  		  __entry->agno,
>  		  __entry->agino,
> -		  __entry->whichfork == XFS_ATTR_FORK ? "attr" : "data",
> +		  __print_symbolic(__entry->whichfork, XFS_WHICHFORK_STRINGS),
>  		  __entry->levels,
>  		  __entry->blocks)
>  )
> 

-- 
Carlos

