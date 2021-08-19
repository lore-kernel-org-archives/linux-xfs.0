Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80DCAC4338F
	for <linux-xfs@archiver.kernel.org>; Thu, 19 Aug 2021 09:06:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6865061100
	for <linux-xfs@archiver.kernel.org>; Thu, 19 Aug 2021 09:06:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234211AbhHSJHX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 19 Aug 2021 05:07:23 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:20385 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230146AbhHSJHN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 19 Aug 2021 05:07:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629363997;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/A03lA3uD79HCZkMdHq0pdGDA6GXRacnkydgdEbVUE4=;
        b=VGG5F3rzJYhqmhFeWck5p2MvWMzhnpkp7rDl1iHHBCOeANQx2htfgqpUj11zWQEZyE5S3Z
        qtORFcg1c212Rn+vlebSmmDwWVLbFaWhROf5aqvtSioTSvI0XoigXgOsjII5+FShra8IAu
        MrfpJ583U1wYKjhZaiNLxKOJ5qLLD5U=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-147-egSjG4TVMp-jc--CRU6dvg-1; Thu, 19 Aug 2021 05:06:35 -0400
X-MC-Unique: egSjG4TVMp-jc--CRU6dvg-1
Received: by mail-ed1-f69.google.com with SMTP id v20-20020aa7d9d40000b02903be68450bf3so2492512eds.23
        for <linux-xfs@vger.kernel.org>; Thu, 19 Aug 2021 02:06:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=/A03lA3uD79HCZkMdHq0pdGDA6GXRacnkydgdEbVUE4=;
        b=PtyX0oJkJe+F3L+4iuYBwg0AnH/Fb0ZVxb+kcJfruGT1E9jgukWCn0LigSYPrcQaIK
         I9QtOwb9NvF60qNOlh4dGA0LjIiF4GjaHdi0dDBdk+lGOL7/PNgu/g8tNZolJ9lvWyVt
         QMC6uyYFfnitrzh+wStQ/uBE5C7lR38p8XJJD6Pw+WVILEZlmVtwPIUI2mEjBF0HCP2C
         LVEZpLbKHEQFoiOG7KpgvDBgXBhD+0xDUDNKrI4l+y12F/Ifh/BtY/9Q8I3zO8aczULB
         6ykh1u4IZUyHVVFyHWmAtqfw/sfuivR/S+Ihwvrurqg6qdkGiChXQ7IApPT+DLgT3AyB
         xooA==
X-Gm-Message-State: AOAM533H74T25giQYcAlMg/VClmtSe8E4aMsW04qZ3bc/KtsjjWZiKfa
        ygseiHkt//CDjoGj3YyeeHprQjXws40tAgEtm2pQk9ROBmyDAreIICekCtVRKAhI/0f48dzOk2N
        fSiandBSAjZ3XZz2d8A6L
X-Received: by 2002:a05:6402:10cc:: with SMTP id p12mr15339959edu.328.1629363994764;
        Thu, 19 Aug 2021 02:06:34 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxeplKwj6+tX7P8W9ju94hh1yS86tgzbkaTHoXUZwJa8xXJo1zruLr1o4lO/DC78J0zlFXdOA==
X-Received: by 2002:a05:6402:10cc:: with SMTP id p12mr15339947edu.328.1629363994586;
        Thu, 19 Aug 2021 02:06:34 -0700 (PDT)
Received: from omega.lan (ip4-46-39-172-19.cust.nbox.cz. [46.39.172.19])
        by smtp.gmail.com with ESMTPSA id kv4sm1006548ejc.35.2021.08.19.02.06.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Aug 2021 02:06:33 -0700 (PDT)
Date:   Thu, 19 Aug 2021 11:06:32 +0200
From:   Carlos Maiolino <cmaiolino@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     david@fromorbit.com, sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 04/15] xfs: standardize AG block number formatting in
 ftrace output
Message-ID: <20210819090632.r2sbnerdppy76csp@omega.lan>
Mail-Followup-To: "Darrick J. Wong" <djwong@kernel.org>,
        david@fromorbit.com, sandeen@sandeen.net, linux-xfs@vger.kernel.org
References: <162924373176.761813.10896002154570305865.stgit@magnolia>
 <162924375404.761813.16085072027749593088.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <162924375404.761813.16085072027749593088.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Aug 17, 2021 at 04:42:34PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Always print allocation group block numbers in hexadecimal and preceded
> with the unit "agbno".
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

> ---
>  fs/xfs/scrub/trace.h |   24 ++++++++++++------------
>  fs/xfs/xfs_trace.h   |   46 +++++++++++++++++++++++-----------------------
>  2 files changed, 35 insertions(+), 35 deletions(-)
> 
> 
> diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
> index 3676b1736bab..49822589a4ae 100644
> --- a/fs/xfs/scrub/trace.h
> +++ b/fs/xfs/scrub/trace.h
> @@ -145,7 +145,7 @@ TRACE_EVENT(xchk_op_error,
>  		__entry->error = error;
>  		__entry->ret_ip = ret_ip;
>  	),
> -	TP_printk("dev %d:%d type %s agno 0x%x agbno %u error %d ret_ip %pS",
> +	TP_printk("dev %d:%d type %s agno 0x%x agbno 0x%x error %d ret_ip %pS",
>  		  MAJOR(__entry->dev), MINOR(__entry->dev),
>  		  __print_symbolic(__entry->type, XFS_SCRUB_TYPE_STRINGS),
>  		  __entry->agno,
> @@ -203,7 +203,7 @@ DECLARE_EVENT_CLASS(xchk_block_error_class,
>  		__entry->agbno = xfs_daddr_to_agbno(sc->mp, daddr);
>  		__entry->ret_ip = ret_ip;
>  	),
> -	TP_printk("dev %d:%d type %s agno 0x%x agbno %u ret_ip %pS",
> +	TP_printk("dev %d:%d type %s agno 0x%x agbno 0x%x ret_ip %pS",
>  		  MAJOR(__entry->dev), MINOR(__entry->dev),
>  		  __print_symbolic(__entry->type, XFS_SCRUB_TYPE_STRINGS),
>  		  __entry->agno,
> @@ -338,7 +338,7 @@ TRACE_EVENT(xchk_btree_op_error,
>  		__entry->error = error;
>  		__entry->ret_ip = ret_ip;
>  	),
> -	TP_printk("dev %d:%d type %s btree %s level %d ptr %d agno 0x%x agbno %u error %d ret_ip %pS",
> +	TP_printk("dev %d:%d type %s btree %s level %d ptr %d agno 0x%x agbno 0x%x error %d ret_ip %pS",
>  		  MAJOR(__entry->dev), MINOR(__entry->dev),
>  		  __print_symbolic(__entry->type, XFS_SCRUB_TYPE_STRINGS),
>  		  __print_symbolic(__entry->btnum, XFS_BTNUM_STRINGS),
> @@ -381,7 +381,7 @@ TRACE_EVENT(xchk_ifork_btree_op_error,
>  		__entry->error = error;
>  		__entry->ret_ip = ret_ip;
>  	),
> -	TP_printk("dev %d:%d ino 0x%llx fork %d type %s btree %s level %d ptr %d agno 0x%x agbno %u error %d ret_ip %pS",
> +	TP_printk("dev %d:%d ino 0x%llx fork %d type %s btree %s level %d ptr %d agno 0x%x agbno 0x%x error %d ret_ip %pS",
>  		  MAJOR(__entry->dev), MINOR(__entry->dev),
>  		  __entry->ino,
>  		  __entry->whichfork,
> @@ -420,7 +420,7 @@ TRACE_EVENT(xchk_btree_error,
>  		__entry->ptr = cur->bc_ptrs[level];
>  		__entry->ret_ip = ret_ip;
>  	),
> -	TP_printk("dev %d:%d type %s btree %s level %d ptr %d agno 0x%x agbno %u ret_ip %pS",
> +	TP_printk("dev %d:%d type %s btree %s level %d ptr %d agno 0x%x agbno 0x%x ret_ip %pS",
>  		  MAJOR(__entry->dev), MINOR(__entry->dev),
>  		  __print_symbolic(__entry->type, XFS_SCRUB_TYPE_STRINGS),
>  		  __print_symbolic(__entry->btnum, XFS_BTNUM_STRINGS),
> @@ -460,7 +460,7 @@ TRACE_EVENT(xchk_ifork_btree_error,
>  		__entry->ptr = cur->bc_ptrs[level];
>  		__entry->ret_ip = ret_ip;
>  	),
> -	TP_printk("dev %d:%d ino 0x%llx fork %d type %s btree %s level %d ptr %d agno 0x%x agbno %u ret_ip %pS",
> +	TP_printk("dev %d:%d ino 0x%llx fork %d type %s btree %s level %d ptr %d agno 0x%x agbno 0x%x ret_ip %pS",
>  		  MAJOR(__entry->dev), MINOR(__entry->dev),
>  		  __entry->ino,
>  		  __entry->whichfork,
> @@ -499,7 +499,7 @@ DECLARE_EVENT_CLASS(xchk_sbtree_class,
>  		__entry->nlevels = cur->bc_nlevels;
>  		__entry->ptr = cur->bc_ptrs[level];
>  	),
> -	TP_printk("dev %d:%d type %s btree %s agno 0x%x agbno %u level %d nlevels %d ptr %d",
> +	TP_printk("dev %d:%d type %s btree %s agno 0x%x agbno 0x%x level %d nlevels %d ptr %d",
>  		  MAJOR(__entry->dev), MINOR(__entry->dev),
>  		  __print_symbolic(__entry->type, XFS_SCRUB_TYPE_STRINGS),
>  		  __print_symbolic(__entry->btnum, XFS_BTNUM_STRINGS),
> @@ -662,7 +662,7 @@ DECLARE_EVENT_CLASS(xrep_extent_class,
>  		__entry->agbno = agbno;
>  		__entry->len = len;
>  	),
> -	TP_printk("dev %d:%d agno 0x%x agbno %u len %u",
> +	TP_printk("dev %d:%d agno 0x%x agbno 0x%x len %u",
>  		  MAJOR(__entry->dev), MINOR(__entry->dev),
>  		  __entry->agno,
>  		  __entry->agbno,
> @@ -699,7 +699,7 @@ DECLARE_EVENT_CLASS(xrep_rmap_class,
>  		__entry->offset = offset;
>  		__entry->flags = flags;
>  	),
> -	TP_printk("dev %d:%d agno 0x%x agbno %u len %u owner %lld offset %llu flags 0x%x",
> +	TP_printk("dev %d:%d agno 0x%x agbno 0x%x len %u owner %lld offset %llu flags 0x%x",
>  		  MAJOR(__entry->dev), MINOR(__entry->dev),
>  		  __entry->agno,
>  		  __entry->agbno,
> @@ -737,7 +737,7 @@ TRACE_EVENT(xrep_refcount_extent_fn,
>  		__entry->blockcount = irec->rc_blockcount;
>  		__entry->refcount = irec->rc_refcount;
>  	),
> -	TP_printk("dev %d:%d agno 0x%x agbno %u len %u refcount %u",
> +	TP_printk("dev %d:%d agno 0x%x agbno 0x%x len %u refcount %u",
>  		  MAJOR(__entry->dev), MINOR(__entry->dev),
>  		  __entry->agno,
>  		  __entry->startblock,
> @@ -761,7 +761,7 @@ TRACE_EVENT(xrep_init_btblock,
>  		__entry->agbno = agbno;
>  		__entry->btnum = btnum;
>  	),
> -	TP_printk("dev %d:%d agno 0x%x agbno %u btree %s",
> +	TP_printk("dev %d:%d agno 0x%x agbno 0x%x btree %s",
>  		  MAJOR(__entry->dev), MINOR(__entry->dev),
>  		  __entry->agno,
>  		  __entry->agbno,
> @@ -785,7 +785,7 @@ TRACE_EVENT(xrep_findroot_block,
>  		__entry->magic = magic;
>  		__entry->level = level;
>  	),
> -	TP_printk("dev %d:%d agno 0x%x agbno %u magic 0x%x level %u",
> +	TP_printk("dev %d:%d agno 0x%x agbno 0x%x magic 0x%x level %u",
>  		  MAJOR(__entry->dev), MINOR(__entry->dev),
>  		  __entry->agno,
>  		  __entry->agbno,
> diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> index 9ddc710c1be9..a780b1752ede 100644
> --- a/fs/xfs/xfs_trace.h
> +++ b/fs/xfs/xfs_trace.h
> @@ -1601,7 +1601,7 @@ DECLARE_EVENT_CLASS(xfs_extent_busy_class,
>  		__entry->agbno = agbno;
>  		__entry->len = len;
>  	),
> -	TP_printk("dev %d:%d agno 0x%x agbno %u len %u",
> +	TP_printk("dev %d:%d agno 0x%x agbno 0x%x len %u",
>  		  MAJOR(__entry->dev), MINOR(__entry->dev),
>  		  __entry->agno,
>  		  __entry->agbno,
> @@ -1639,7 +1639,7 @@ TRACE_EVENT(xfs_extent_busy_trim,
>  		__entry->tbno = tbno;
>  		__entry->tlen = tlen;
>  	),
> -	TP_printk("dev %d:%d agno 0x%x agbno %u len %u tbno %u tlen %u",
> +	TP_printk("dev %d:%d agno 0x%x agbno 0x%x len %u found_agbno 0x%x tlen %u",
>  		  MAJOR(__entry->dev), MINOR(__entry->dev),
>  		  __entry->agno,
>  		  __entry->agbno,
> @@ -1735,7 +1735,7 @@ TRACE_EVENT(xfs_free_extent,
>  		__entry->haveleft = haveleft;
>  		__entry->haveright = haveright;
>  	),
> -	TP_printk("dev %d:%d agno 0x%x agbno %u len %u resv %d %s",
> +	TP_printk("dev %d:%d agno 0x%x agbno 0x%x len %u resv %d %s",
>  		  MAJOR(__entry->dev), MINOR(__entry->dev),
>  		  __entry->agno,
>  		  __entry->agbno,
> @@ -1792,7 +1792,7 @@ DECLARE_EVENT_CLASS(xfs_alloc_class,
>  		__entry->datatype = args->datatype;
>  		__entry->firstblock = args->tp->t_firstblock;
>  	),
> -	TP_printk("dev %d:%d agno 0x%x agbno %u minlen %u maxlen %u mod %u "
> +	TP_printk("dev %d:%d agno 0x%x agbno 0x%x minlen %u maxlen %u mod %u "
>  		  "prod %u minleft %u total %u alignment %u minalignslop %u "
>  		  "len %u type %s otype %s wasdel %d wasfromfl %d resv %d "
>  		  "datatype 0x%x firstblock 0x%llx",
> @@ -1870,7 +1870,7 @@ TRACE_EVENT(xfs_alloc_cur_check,
>  		__entry->diff = diff;
>  		__entry->new = new;
>  	),
> -	TP_printk("dev %d:%d btree %s bno 0x%x len 0x%x diff 0x%x new %d",
> +	TP_printk("dev %d:%d btree %s agbno 0x%x len 0x%x diff 0x%x new %d",
>  		  MAJOR(__entry->dev), MINOR(__entry->dev),
>  		  __print_symbolic(__entry->btnum, XFS_BTNUM_STRINGS),
>  		  __entry->bno, __entry->len, __entry->diff, __entry->new)
> @@ -2363,7 +2363,7 @@ DECLARE_EVENT_CLASS(xfs_log_recover_icreate_item_class,
>  		__entry->length = be32_to_cpu(in_f->icl_length);
>  		__entry->gen = be32_to_cpu(in_f->icl_gen);
>  	),
> -	TP_printk("dev %d:%d agno 0x%x agbno %u count %u isize %u length %u "
> +	TP_printk("dev %d:%d agno 0x%x agbno 0x%x count %u isize %u length %u "
>  		  "gen %u", MAJOR(__entry->dev), MINOR(__entry->dev),
>  		  __entry->agno, __entry->agbno, __entry->count, __entry->isize,
>  		  __entry->length, __entry->gen)
> @@ -2392,7 +2392,7 @@ DECLARE_EVENT_CLASS(xfs_discard_class,
>  		__entry->agbno = agbno;
>  		__entry->len = len;
>  	),
> -	TP_printk("dev %d:%d agno 0x%x agbno %u len %u",
> +	TP_printk("dev %d:%d agno 0x%x agbno 0x%x len %u",
>  		  MAJOR(__entry->dev), MINOR(__entry->dev),
>  		  __entry->agno,
>  		  __entry->agbno,
> @@ -2551,7 +2551,7 @@ DECLARE_EVENT_CLASS(xfs_phys_extent_deferred_class,
>  		__entry->agbno = agbno;
>  		__entry->len = len;
>  	),
> -	TP_printk("dev %d:%d op %d agno 0x%x agbno %u len %u",
> +	TP_printk("dev %d:%d op %d agno 0x%x agbno 0x%x len %u",
>  		  MAJOR(__entry->dev), MINOR(__entry->dev),
>  		  __entry->type,
>  		  __entry->agno,
> @@ -2598,7 +2598,7 @@ DECLARE_EVENT_CLASS(xfs_map_extent_deferred_class,
>  		__entry->l_state = state;
>  		__entry->op = op;
>  	),
> -	TP_printk("dev %d:%d op %d agno 0x%x agbno %u owner %lld %s offset %llu len %llu state %d",
> +	TP_printk("dev %d:%d op %d agno 0x%x agbno 0x%x owner %lld %s offset %llu len %llu state %d",
>  		  MAJOR(__entry->dev), MINOR(__entry->dev),
>  		  __entry->op,
>  		  __entry->agno,
> @@ -2668,7 +2668,7 @@ DECLARE_EVENT_CLASS(xfs_rmap_class,
>  		if (unwritten)
>  			__entry->flags |= XFS_RMAP_UNWRITTEN;
>  	),
> -	TP_printk("dev %d:%d agno 0x%x agbno %u len %u owner %lld offset %llu flags 0x%lx",
> +	TP_printk("dev %d:%d agno 0x%x agbno 0x%x len %u owner %lld offset %llu flags 0x%lx",
>  		  MAJOR(__entry->dev), MINOR(__entry->dev),
>  		  __entry->agno,
>  		  __entry->agbno,
> @@ -2748,7 +2748,7 @@ DECLARE_EVENT_CLASS(xfs_rmapbt_class,
>  		__entry->offset = offset;
>  		__entry->flags = flags;
>  	),
> -	TP_printk("dev %d:%d agno 0x%x agbno %u len %u owner %lld offset %llu flags 0x%x",
> +	TP_printk("dev %d:%d agno 0x%x agbno 0x%x len %u owner %lld offset %llu flags 0x%x",
>  		  MAJOR(__entry->dev), MINOR(__entry->dev),
>  		  __entry->agno,
>  		  __entry->agbno,
> @@ -2870,7 +2870,7 @@ DECLARE_EVENT_CLASS(xfs_ag_btree_lookup_class,
>  		__entry->agbno = agbno;
>  		__entry->dir = dir;
>  	),
> -	TP_printk("dev %d:%d agno 0x%x agbno %u cmp %s(%d)",
> +	TP_printk("dev %d:%d agno 0x%x agbno 0x%x cmp %s(%d)",
>  		  MAJOR(__entry->dev), MINOR(__entry->dev),
>  		  __entry->agno,
>  		  __entry->agbno,
> @@ -2903,7 +2903,7 @@ DECLARE_EVENT_CLASS(xfs_refcount_extent_class,
>  		__entry->blockcount = irec->rc_blockcount;
>  		__entry->refcount = irec->rc_refcount;
>  	),
> -	TP_printk("dev %d:%d agno 0x%x agbno %u len %u refcount %u",
> +	TP_printk("dev %d:%d agno 0x%x agbno 0x%x len %u refcount %u",
>  		  MAJOR(__entry->dev), MINOR(__entry->dev),
>  		  __entry->agno,
>  		  __entry->startblock,
> @@ -2938,7 +2938,7 @@ DECLARE_EVENT_CLASS(xfs_refcount_extent_at_class,
>  		__entry->refcount = irec->rc_refcount;
>  		__entry->agbno = agbno;
>  	),
> -	TP_printk("dev %d:%d agno 0x%x agbno %u len %u refcount %u @ agbno %u",
> +	TP_printk("dev %d:%d agno 0x%x agbno 0x%x len %u refcount %u @ agbno 0x%x",
>  		  MAJOR(__entry->dev), MINOR(__entry->dev),
>  		  __entry->agno,
>  		  __entry->startblock,
> @@ -2978,8 +2978,8 @@ DECLARE_EVENT_CLASS(xfs_refcount_double_extent_class,
>  		__entry->i2_blockcount = i2->rc_blockcount;
>  		__entry->i2_refcount = i2->rc_refcount;
>  	),
> -	TP_printk("dev %d:%d agno 0x%x agbno %u len %u refcount %u -- "
> -		  "agbno %u len %u refcount %u",
> +	TP_printk("dev %d:%d agno 0x%x agbno 0x%x len %u refcount %u -- "
> +		  "agbno 0x%x len %u refcount %u",
>  		  MAJOR(__entry->dev), MINOR(__entry->dev),
>  		  __entry->agno,
>  		  __entry->i1_startblock,
> @@ -3024,8 +3024,8 @@ DECLARE_EVENT_CLASS(xfs_refcount_double_extent_at_class,
>  		__entry->i2_refcount = i2->rc_refcount;
>  		__entry->agbno = agbno;
>  	),
> -	TP_printk("dev %d:%d agno 0x%x agbno %u len %u refcount %u -- "
> -		  "agbno %u len %u refcount %u @ agbno %u",
> +	TP_printk("dev %d:%d agno 0x%x agbno 0x%x len %u refcount %u -- "
> +		  "agbno 0x%x len %u refcount %u @ agbno 0x%x",
>  		  MAJOR(__entry->dev), MINOR(__entry->dev),
>  		  __entry->agno,
>  		  __entry->i1_startblock,
> @@ -3076,9 +3076,9 @@ DECLARE_EVENT_CLASS(xfs_refcount_triple_extent_class,
>  		__entry->i3_blockcount = i3->rc_blockcount;
>  		__entry->i3_refcount = i3->rc_refcount;
>  	),
> -	TP_printk("dev %d:%d agno 0x%x agbno %u len %u refcount %u -- "
> -		  "agbno %u len %u refcount %u -- "
> -		  "agbno %u len %u refcount %u",
> +	TP_printk("dev %d:%d agno 0x%x agbno 0x%x len %u refcount %u -- "
> +		  "agbno 0x%x len %u refcount %u -- "
> +		  "agbno 0x%x len %u refcount %u",
>  		  MAJOR(__entry->dev), MINOR(__entry->dev),
>  		  __entry->agno,
>  		  __entry->i1_startblock,
> @@ -3165,7 +3165,7 @@ TRACE_EVENT(xfs_refcount_finish_one_leftover,
>  		__entry->new_agbno = new_agbno;
>  		__entry->new_len = new_len;
>  	),
> -	TP_printk("dev %d:%d type %d agno 0x%x agbno %u len %u new_agbno %u new_len %u",
> +	TP_printk("dev %d:%d type %d agno 0x%x agbno 0x%x len %u new_agbno 0x%x new_len %u",
>  		  MAJOR(__entry->dev), MINOR(__entry->dev),
>  		  __entry->type,
>  		  __entry->agno,
> @@ -3930,7 +3930,7 @@ TRACE_EVENT(xfs_btree_bload_block,
>  		}
>  		__entry->nr_records = nr_records;
>  	),
> -	TP_printk("dev %d:%d btree %s level %u block %llu/%llu agno 0x%x agbno %u recs %u",
> +	TP_printk("dev %d:%d btree %s level %u block %llu/%llu agno 0x%x agbno 0x%x recs %u",
>  		  MAJOR(__entry->dev), MINOR(__entry->dev),
>  		  __print_symbolic(__entry->btnum, XFS_BTNUM_STRINGS),
>  		  __entry->level,
> 

-- 
Carlos

