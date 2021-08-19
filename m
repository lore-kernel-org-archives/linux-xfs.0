Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20685C4338F
	for <linux-xfs@archiver.kernel.org>; Thu, 19 Aug 2021 12:08:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 04C9A61153
	for <linux-xfs@archiver.kernel.org>; Thu, 19 Aug 2021 12:08:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238286AbhHSMIq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 19 Aug 2021 08:08:46 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:39448 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238105AbhHSMIp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 19 Aug 2021 08:08:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629374886;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=XR6PLP6of3KZi5v39GD0n1+utvnVvRAEguwHKLpJ1gI=;
        b=Qlyz5wDrTnehnkv4i39aurOlntkxr/DjT85VzklfjXot2Rb+tHQnXAdF94f+luoxptDua8
        PcUmvXf9Mvd9RlDXJYTRo8juZX8MHUGqHKKlWY+CPlYFIM5kqYwKnsD541uNO2L+XdRxWT
        kSYWGnF/YgpfvTjVTpE4Wn5AD0A+Wg4=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-561-5JgCSmVBNf-SUxrwUGMRDw-1; Thu, 19 Aug 2021 08:08:05 -0400
X-MC-Unique: 5JgCSmVBNf-SUxrwUGMRDw-1
Received: by mail-ed1-f70.google.com with SMTP id m16-20020a056402511000b003bead176527so2704694edd.10
        for <linux-xfs@vger.kernel.org>; Thu, 19 Aug 2021 05:08:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=XR6PLP6of3KZi5v39GD0n1+utvnVvRAEguwHKLpJ1gI=;
        b=CUd6O34Kau3qx1DvSRcTBITitZneGC/RkThzyoTnqnm6gVs6rG7D75P7UUXc7Bc7aX
         sYyfu0QHFiG10A9i5TV0oZGmAu41Vn+46c1c0dDUGhgJa+3YiWysrvYpGFldAyGUzZ5v
         6uXKTfH8A4CthlOrVzpiBQSnQiFhKdtdiWcCClEXY99/3Jo9t3q2hSSiW3CPXeJOoQ/8
         z9vCvX8dorYXHNXFmrZ2VuATltiwtnWdbfCn5CPmP3xa/1w3DtZMTKyPsCRjetZbeOeF
         5w5vl7a1j1vTTIuag35QJAycvFPItUUbv5qzISzJqVHpsbNcjX3gosrod1aVAJgkBrfr
         Cj8w==
X-Gm-Message-State: AOAM530nLJG/jTrVYjgI+7qERgCTeYJJt8BU4BypR9CQOCLURn+PuDRq
        XAYPG2VmcORX2lfmDiS4X7eUbQmFOtzZucGTnmtUmy97dYUcdR4vFwii2/oqq9FM2+pO2nCTRqI
        zIn/Lg095ONPeRcsoFovI
X-Received: by 2002:a05:6402:1648:: with SMTP id s8mr15678041edx.214.1629374884344;
        Thu, 19 Aug 2021 05:08:04 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxAsnW3BBzlNFNvgM66GuaVRA2K5BrF9RhhTEey3F+WEJwShQhpPr6BTWXR8xx2i49Opcsx1A==
X-Received: by 2002:a05:6402:1648:: with SMTP id s8mr15678013edx.214.1629374884134;
        Thu, 19 Aug 2021 05:08:04 -0700 (PDT)
Received: from omega.lan (ip4-46-39-172-19.cust.nbox.cz. [46.39.172.19])
        by smtp.gmail.com with ESMTPSA id g14sm1663429edr.47.2021.08.19.05.08.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Aug 2021 05:08:03 -0700 (PDT)
Date:   Thu, 19 Aug 2021 14:08:01 +0200
From:   Carlos Maiolino <cmaiolino@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     david@fromorbit.com, sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2 09/15] xfs: disambiguate units for ftrace fields
 tagged "len"
Message-ID: <20210819120801.tnvmfxt3xbkfjdte@omega.lan>
Mail-Followup-To: "Darrick J. Wong" <djwong@kernel.org>,
        david@fromorbit.com, sandeen@sandeen.net, linux-xfs@vger.kernel.org
References: <162924373176.761813.10896002154570305865.stgit@magnolia>
 <162924378154.761813.12918362378497157448.stgit@magnolia>
 <20210819034452.GP12640@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210819034452.GP12640@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Aug 18, 2021 at 08:44:52PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Some of our tracepoints have a field known as "len".  That name doesn't
> describe any units, which makes the fields not very useful.  Rename the
> fields to capture units and ensure the format is hexadecimal.
> 
> "fsbcount" are in units of fs blocks
> "bbcount" are in units of 512b blocks
> "ireccount" are in units of inodes
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
> v2: change the prefixes of the unit counts
> ---

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

>  fs/xfs/scrub/trace.h |    8 +++---
>  fs/xfs/xfs_trace.h   |   66 +++++++++++++++++++++++++++-----------------------
>  2 files changed, 39 insertions(+), 35 deletions(-)
> 
> diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
> index 5a57fea014f9..eb29f56dc9f1 100644
> --- a/fs/xfs/scrub/trace.h
> +++ b/fs/xfs/scrub/trace.h
> @@ -572,7 +572,7 @@ TRACE_EVENT(xchk_iallocbt_check_cluster,
>  		__entry->holemask = holemask;
>  		__entry->cluster_ino = cluster_ino;
>  	),
> -	TP_printk("dev %d:%d agno 0x%x startino 0x%x daddr 0x%llx len %d chunkino 0x%x nr_inodes %u cluster_mask 0x%x holemask 0x%x cluster_ino 0x%x",
> +	TP_printk("dev %d:%d agno 0x%x startino 0x%x daddr 0x%llx bbcount 0x%x chunkino 0x%x nr_inodes %u cluster_mask 0x%x holemask 0x%x cluster_ino 0x%x",
>  		  MAJOR(__entry->dev), MINOR(__entry->dev),
>  		  __entry->agno,
>  		  __entry->startino,
> @@ -662,7 +662,7 @@ DECLARE_EVENT_CLASS(xrep_extent_class,
>  		__entry->agbno = agbno;
>  		__entry->len = len;
>  	),
> -	TP_printk("dev %d:%d agno 0x%x agbno 0x%x len %u",
> +	TP_printk("dev %d:%d agno 0x%x agbno 0x%x fsbcount 0x%x",
>  		  MAJOR(__entry->dev), MINOR(__entry->dev),
>  		  __entry->agno,
>  		  __entry->agbno,
> @@ -699,7 +699,7 @@ DECLARE_EVENT_CLASS(xrep_rmap_class,
>  		__entry->offset = offset;
>  		__entry->flags = flags;
>  	),
> -	TP_printk("dev %d:%d agno 0x%x agbno 0x%x len %u owner 0x%llx fileoff 0x%llx flags 0x%x",
> +	TP_printk("dev %d:%d agno 0x%x agbno 0x%x fsbcount 0x%x owner 0x%llx fileoff 0x%llx flags 0x%x",
>  		  MAJOR(__entry->dev), MINOR(__entry->dev),
>  		  __entry->agno,
>  		  __entry->agbno,
> @@ -737,7 +737,7 @@ TRACE_EVENT(xrep_refcount_extent_fn,
>  		__entry->blockcount = irec->rc_blockcount;
>  		__entry->refcount = irec->rc_refcount;
>  	),
> -	TP_printk("dev %d:%d agno 0x%x agbno 0x%x len %u refcount %u",
> +	TP_printk("dev %d:%d agno 0x%x agbno 0x%x fsbcount 0x%x refcount %u",
>  		  MAJOR(__entry->dev), MINOR(__entry->dev),
>  		  __entry->agno,
>  		  __entry->startblock,
> diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> index 60837ff297bc..4169dc6cb5b9 100644
> --- a/fs/xfs/xfs_trace.h
> +++ b/fs/xfs/xfs_trace.h
> @@ -1440,7 +1440,7 @@ DECLARE_EVENT_CLASS(xfs_imap_class,
>  		__entry->blockcount = irec ? irec->br_blockcount : 0;
>  	),
>  	TP_printk("dev %d:%d ino 0x%llx size 0x%llx pos 0x%llx count %zd "
> -		  "fork %s startoff 0x%llx startblock 0x%llx blockcount 0x%llx",
> +		  "fork %s startoff 0x%llx startblock 0x%llx fsbcount 0x%llx",
>  		  MAJOR(__entry->dev), MINOR(__entry->dev),
>  		  __entry->ino,
>  		  __entry->size,
> @@ -1579,7 +1579,7 @@ TRACE_EVENT(xfs_bunmap,
>  		__entry->caller_ip = caller_ip;
>  		__entry->flags = flags;
>  	),
> -	TP_printk("dev %d:%d ino 0x%llx size 0x%llx fileoff 0x%llx len 0x%llx"
> +	TP_printk("dev %d:%d ino 0x%llx size 0x%llx fileoff 0x%llx fsbcount 0x%llx"
>  		  "flags %s caller %pS",
>  		  MAJOR(__entry->dev), MINOR(__entry->dev),
>  		  __entry->ino,
> @@ -1607,7 +1607,7 @@ DECLARE_EVENT_CLASS(xfs_extent_busy_class,
>  		__entry->agbno = agbno;
>  		__entry->len = len;
>  	),
> -	TP_printk("dev %d:%d agno 0x%x agbno 0x%x len %u",
> +	TP_printk("dev %d:%d agno 0x%x agbno 0x%x fsbcount 0x%x",
>  		  MAJOR(__entry->dev), MINOR(__entry->dev),
>  		  __entry->agno,
>  		  __entry->agbno,
> @@ -1645,7 +1645,7 @@ TRACE_EVENT(xfs_extent_busy_trim,
>  		__entry->tbno = tbno;
>  		__entry->tlen = tlen;
>  	),
> -	TP_printk("dev %d:%d agno 0x%x agbno 0x%x len %u found_agbno 0x%x tlen %u",
> +	TP_printk("dev %d:%d agno 0x%x agbno 0x%x fsbcount 0x%x found_agbno 0x%x found_fsbcount 0x%x",
>  		  MAJOR(__entry->dev), MINOR(__entry->dev),
>  		  __entry->agno,
>  		  __entry->agbno,
> @@ -1741,7 +1741,7 @@ TRACE_EVENT(xfs_free_extent,
>  		__entry->haveleft = haveleft;
>  		__entry->haveright = haveright;
>  	),
> -	TP_printk("dev %d:%d agno 0x%x agbno 0x%x len %u resv %d %s",
> +	TP_printk("dev %d:%d agno 0x%x agbno 0x%x fsbcount 0x%x resv %d %s",
>  		  MAJOR(__entry->dev), MINOR(__entry->dev),
>  		  __entry->agno,
>  		  __entry->agbno,
> @@ -1876,7 +1876,7 @@ TRACE_EVENT(xfs_alloc_cur_check,
>  		__entry->diff = diff;
>  		__entry->new = new;
>  	),
> -	TP_printk("dev %d:%d btree %s agbno 0x%x len 0x%x diff 0x%x new %d",
> +	TP_printk("dev %d:%d btree %s agbno 0x%x fsbcount 0x%x diff 0x%x new %d",
>  		  MAJOR(__entry->dev), MINOR(__entry->dev),
>  		  __print_symbolic(__entry->btnum, XFS_BTNUM_STRINGS),
>  		  __entry->bno, __entry->len, __entry->diff, __entry->new)
> @@ -2277,7 +2277,7 @@ DECLARE_EVENT_CLASS(xfs_log_recover_buf_item_class,
>  		__entry->size = buf_f->blf_size;
>  		__entry->map_size = buf_f->blf_map_size;
>  	),
> -	TP_printk("dev %d:%d daddr 0x%llx, len %u, flags 0x%x, size %d, "
> +	TP_printk("dev %d:%d daddr 0x%llx, bbcount 0x%x, flags 0x%x, size %d, "
>  			"map_size %d",
>  		  MAJOR(__entry->dev), MINOR(__entry->dev),
>  		  __entry->blkno,
> @@ -2328,7 +2328,7 @@ DECLARE_EVENT_CLASS(xfs_log_recover_ino_item_class,
>  		__entry->boffset = in_f->ilf_boffset;
>  	),
>  	TP_printk("dev %d:%d ino 0x%llx, size %u, fields 0x%x, asize %d, "
> -			"dsize %d, daddr 0x%llx, len %d, boffset %d",
> +			"dsize %d, daddr 0x%llx, bbcount 0x%x, boffset %d",
>  		  MAJOR(__entry->dev), MINOR(__entry->dev),
>  		  __entry->ino,
>  		  __entry->size,
> @@ -2369,10 +2369,14 @@ DECLARE_EVENT_CLASS(xfs_log_recover_icreate_item_class,
>  		__entry->length = be32_to_cpu(in_f->icl_length);
>  		__entry->gen = be32_to_cpu(in_f->icl_gen);
>  	),
> -	TP_printk("dev %d:%d agno 0x%x agbno 0x%x count %u isize %u length %u "
> -		  "gen %u", MAJOR(__entry->dev), MINOR(__entry->dev),
> -		  __entry->agno, __entry->agbno, __entry->count, __entry->isize,
> -		  __entry->length, __entry->gen)
> +	TP_printk("dev %d:%d agno 0x%x agbno 0x%x fsbcount 0x%x ireccount 0x%x isize %u gen %u",
> +		  MAJOR(__entry->dev), MINOR(__entry->dev),
> +		  __entry->agno,
> +		  __entry->agbno,
> +		  __entry->length,
> +		  __entry->count,
> +		  __entry->isize,
> +		  __entry->gen)
>  )
>  #define DEFINE_LOG_RECOVER_ICREATE_ITEM(name) \
>  DEFINE_EVENT(xfs_log_recover_icreate_item_class, name, \
> @@ -2398,7 +2402,7 @@ DECLARE_EVENT_CLASS(xfs_discard_class,
>  		__entry->agbno = agbno;
>  		__entry->len = len;
>  	),
> -	TP_printk("dev %d:%d agno 0x%x agbno 0x%x len %u",
> +	TP_printk("dev %d:%d agno 0x%x agbno 0x%x fsbcount 0x%x",
>  		  MAJOR(__entry->dev), MINOR(__entry->dev),
>  		  __entry->agno,
>  		  __entry->agbno,
> @@ -2557,7 +2561,7 @@ DECLARE_EVENT_CLASS(xfs_phys_extent_deferred_class,
>  		__entry->agbno = agbno;
>  		__entry->len = len;
>  	),
> -	TP_printk("dev %d:%d op %d agno 0x%x agbno 0x%x len %u",
> +	TP_printk("dev %d:%d op %d agno 0x%x agbno 0x%x fsbcount 0x%x",
>  		  MAJOR(__entry->dev), MINOR(__entry->dev),
>  		  __entry->type,
>  		  __entry->agno,
> @@ -2604,7 +2608,7 @@ DECLARE_EVENT_CLASS(xfs_map_extent_deferred_class,
>  		__entry->l_state = state;
>  		__entry->op = op;
>  	),
> -	TP_printk("dev %d:%d op %d agno 0x%x agbno 0x%x owner 0x%llx %s fileoff 0x%llx len %llu state %d",
> +	TP_printk("dev %d:%d op %d agno 0x%x agbno 0x%x owner 0x%llx %s fileoff 0x%llx fsbcount 0x%llx state %d",
>  		  MAJOR(__entry->dev), MINOR(__entry->dev),
>  		  __entry->op,
>  		  __entry->agno,
> @@ -2674,7 +2678,7 @@ DECLARE_EVENT_CLASS(xfs_rmap_class,
>  		if (unwritten)
>  			__entry->flags |= XFS_RMAP_UNWRITTEN;
>  	),
> -	TP_printk("dev %d:%d agno 0x%x agbno 0x%x len %u owner 0x%llx fileoff 0x%llx flags 0x%lx",
> +	TP_printk("dev %d:%d agno 0x%x agbno 0x%x fsbcount 0x%x owner 0x%llx fileoff 0x%llx flags 0x%lx",
>  		  MAJOR(__entry->dev), MINOR(__entry->dev),
>  		  __entry->agno,
>  		  __entry->agbno,
> @@ -2754,7 +2758,7 @@ DECLARE_EVENT_CLASS(xfs_rmapbt_class,
>  		__entry->offset = offset;
>  		__entry->flags = flags;
>  	),
> -	TP_printk("dev %d:%d agno 0x%x agbno 0x%x len %u owner 0x%llx fileoff 0x%llx flags 0x%x",
> +	TP_printk("dev %d:%d agno 0x%x agbno 0x%x fsbcount 0x%x owner 0x%llx fileoff 0x%llx flags 0x%x",
>  		  MAJOR(__entry->dev), MINOR(__entry->dev),
>  		  __entry->agno,
>  		  __entry->agbno,
> @@ -2909,7 +2913,7 @@ DECLARE_EVENT_CLASS(xfs_refcount_extent_class,
>  		__entry->blockcount = irec->rc_blockcount;
>  		__entry->refcount = irec->rc_refcount;
>  	),
> -	TP_printk("dev %d:%d agno 0x%x agbno 0x%x len %u refcount %u",
> +	TP_printk("dev %d:%d agno 0x%x agbno 0x%x fsbcount 0x%x refcount %u",
>  		  MAJOR(__entry->dev), MINOR(__entry->dev),
>  		  __entry->agno,
>  		  __entry->startblock,
> @@ -2944,7 +2948,7 @@ DECLARE_EVENT_CLASS(xfs_refcount_extent_at_class,
>  		__entry->refcount = irec->rc_refcount;
>  		__entry->agbno = agbno;
>  	),
> -	TP_printk("dev %d:%d agno 0x%x agbno 0x%x len %u refcount %u @ agbno 0x%x",
> +	TP_printk("dev %d:%d agno 0x%x agbno 0x%x fsbcount 0x%x refcount %u @ agbno 0x%x",
>  		  MAJOR(__entry->dev), MINOR(__entry->dev),
>  		  __entry->agno,
>  		  __entry->startblock,
> @@ -2984,8 +2988,8 @@ DECLARE_EVENT_CLASS(xfs_refcount_double_extent_class,
>  		__entry->i2_blockcount = i2->rc_blockcount;
>  		__entry->i2_refcount = i2->rc_refcount;
>  	),
> -	TP_printk("dev %d:%d agno 0x%x agbno 0x%x len %u refcount %u -- "
> -		  "agbno 0x%x len %u refcount %u",
> +	TP_printk("dev %d:%d agno 0x%x agbno 0x%x fsbcount 0x%x refcount %u -- "
> +		  "agbno 0x%x fsbcount 0x%x refcount %u",
>  		  MAJOR(__entry->dev), MINOR(__entry->dev),
>  		  __entry->agno,
>  		  __entry->i1_startblock,
> @@ -3030,8 +3034,8 @@ DECLARE_EVENT_CLASS(xfs_refcount_double_extent_at_class,
>  		__entry->i2_refcount = i2->rc_refcount;
>  		__entry->agbno = agbno;
>  	),
> -	TP_printk("dev %d:%d agno 0x%x agbno 0x%x len %u refcount %u -- "
> -		  "agbno 0x%x len %u refcount %u @ agbno 0x%x",
> +	TP_printk("dev %d:%d agno 0x%x agbno 0x%x fsbcount 0x%x refcount %u -- "
> +		  "agbno 0x%x fsbcount 0x%x refcount %u @ agbno 0x%x",
>  		  MAJOR(__entry->dev), MINOR(__entry->dev),
>  		  __entry->agno,
>  		  __entry->i1_startblock,
> @@ -3082,9 +3086,9 @@ DECLARE_EVENT_CLASS(xfs_refcount_triple_extent_class,
>  		__entry->i3_blockcount = i3->rc_blockcount;
>  		__entry->i3_refcount = i3->rc_refcount;
>  	),
> -	TP_printk("dev %d:%d agno 0x%x agbno 0x%x len %u refcount %u -- "
> -		  "agbno 0x%x len %u refcount %u -- "
> -		  "agbno 0x%x len %u refcount %u",
> +	TP_printk("dev %d:%d agno 0x%x agbno 0x%x fsbcount 0x%x refcount %u -- "
> +		  "agbno 0x%x fsbcount 0x%x refcount %u -- "
> +		  "agbno 0x%x fsbcount 0x%x refcount %u",
>  		  MAJOR(__entry->dev), MINOR(__entry->dev),
>  		  __entry->agno,
>  		  __entry->i1_startblock,
> @@ -3171,7 +3175,7 @@ TRACE_EVENT(xfs_refcount_finish_one_leftover,
>  		__entry->new_agbno = new_agbno;
>  		__entry->new_len = new_len;
>  	),
> -	TP_printk("dev %d:%d type %d agno 0x%x agbno 0x%x len %u new_agbno 0x%x new_len %u",
> +	TP_printk("dev %d:%d type %d agno 0x%x agbno 0x%x fsbcount 0x%x new_agbno 0x%x new_fsbcount 0x%x",
>  		  MAJOR(__entry->dev), MINOR(__entry->dev),
>  		  __entry->type,
>  		  __entry->agno,
> @@ -3282,7 +3286,7 @@ DECLARE_EVENT_CLASS(xfs_inode_irec_class,
>  		__entry->pblk = irec->br_startblock;
>  		__entry->state = irec->br_state;
>  	),
> -	TP_printk("dev %d:%d ino 0x%llx fileoff 0x%llx len 0x%x startblock 0x%llx st %d",
> +	TP_printk("dev %d:%d ino 0x%llx fileoff 0x%llx fsbcount 0x%x startblock 0x%llx st %d",
>  		  MAJOR(__entry->dev), MINOR(__entry->dev),
>  		  __entry->ino,
>  		  __entry->lblk,
> @@ -3322,7 +3326,7 @@ TRACE_EVENT(xfs_reflink_remap_blocks,
>  		__entry->dest_ino = dest->i_ino;
>  		__entry->dest_lblk = doffset;
>  	),
> -	TP_printk("dev %d:%d len 0x%llx "
> +	TP_printk("dev %d:%d fsbcount 0x%llx "
>  		  "ino 0x%llx fileoff 0x%llx -> ino 0x%llx fileoff 0x%llx",
>  		  MAJOR(__entry->dev), MINOR(__entry->dev),
>  		  __entry->len,
> @@ -3422,7 +3426,7 @@ DECLARE_EVENT_CLASS(xfs_fsmap_class,
>  		__entry->offset = rmap->rm_offset;
>  		__entry->flags = rmap->rm_flags;
>  	),
> -	TP_printk("dev %d:%d keydev %d:%d agno 0x%x startblock 0x%llx len %llu owner 0x%llx fileoff 0x%llx flags 0x%x",
> +	TP_printk("dev %d:%d keydev %d:%d agno 0x%x startblock 0x%llx fsbcount 0x%llx owner 0x%llx fileoff 0x%llx flags 0x%x",
>  		  MAJOR(__entry->dev), MINOR(__entry->dev),
>  		  MAJOR(__entry->keydev), MINOR(__entry->keydev),
>  		  __entry->agno,
> @@ -3462,7 +3466,7 @@ DECLARE_EVENT_CLASS(xfs_getfsmap_class,
>  		__entry->offset = fsmap->fmr_offset;
>  		__entry->flags = fsmap->fmr_flags;
>  	),
> -	TP_printk("dev %d:%d keydev %d:%d daddr 0x%llx len %llu owner 0x%llx fileoff_daddr 0x%llx flags 0x%llx",
> +	TP_printk("dev %d:%d keydev %d:%d daddr 0x%llx bbcount 0x%llx owner 0x%llx fileoff_daddr 0x%llx flags 0x%llx",
>  		  MAJOR(__entry->dev), MINOR(__entry->dev),
>  		  MAJOR(__entry->keydev), MINOR(__entry->keydev),
>  		  __entry->block,
> 

-- 
Carlos

