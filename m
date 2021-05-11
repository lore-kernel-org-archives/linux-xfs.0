Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 280E5C433ED
	for <linux-xfs@archiver.kernel.org>; Tue, 11 May 2021 12:34:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DF32D6190A
	for <linux-xfs@archiver.kernel.org>; Tue, 11 May 2021 12:34:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231577AbhEKMf6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 11 May 2021 08:35:58 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:38520 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231597AbhEKMfx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 11 May 2021 08:35:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620736487;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=5yT0Y6F9MxZYe1hBrlhXW772A8EuqUXj9eSILviTh2w=;
        b=Z8XC7w7AOs3zTp5NCvZil1IFSkVNoMsU6itCvobCbHBAo1il5PbAu0FFxNP7iw561AAGKk
        BzClmq3AL8dUy3hBcvEAAjWb4OG2tLbTAFFslHsOlldcCBt+WhtOzOr0YWGfT9H8HFo2Dz
        kDmBfHf81ITy2bgvAGA5DbDB/+UO6X0=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-497-MNtuTrJNNCqVrVz7nfeiBQ-1; Tue, 11 May 2021 08:34:43 -0400
X-MC-Unique: MNtuTrJNNCqVrVz7nfeiBQ-1
Received: by mail-qk1-f199.google.com with SMTP id s10-20020a05620a030ab02902e061a1661fso14285868qkm.12
        for <linux-xfs@vger.kernel.org>; Tue, 11 May 2021 05:34:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=5yT0Y6F9MxZYe1hBrlhXW772A8EuqUXj9eSILviTh2w=;
        b=UnbBCKouu9SFQ1V2J3IIFESEnC1FXpom3U2mofS3Xd4RAxOfHorfG+YSks3ykMDQsZ
         sG+z6ii31b4aO2KgdwYEb3BnpT5MgriEokEcwCvbwXKhbrTVJl+fy9074PSuCgxlWbqf
         e3MJNPO1VSHPxNCDdOk8dCfMlgByqYBn44NAz+IhPJ5kdNzXWuo5ezejpV2T001th3BX
         zApqs3Iyjg5T0+PZDaYdsbs6QiYm/vdi8ZWR97VkqG2ah03ACFLve07DaLi8vJkEia0y
         1dbngK6eVZfqh/EZHjiOQm3FZ41nZMlXC2zBoAAtxnEcy4eQnkfFyYTAxYxOwH7fDAbz
         H4qg==
X-Gm-Message-State: AOAM5314qCYw/SSw5Uff/3WBRMqolbE6m8gMF7KWwQLxhq7HOqAL71H/
        SHASejh6XcjMDFzLPjcVLxWTgQxXEp/SbKaZTneKpEYfWmZ4Ov3iEqbn3gdLafJsS+TLja5o0Kd
        qJhozlgFkXg/UndqrntmR
X-Received: by 2002:a37:de13:: with SMTP id h19mr11142732qkj.346.1620736482515;
        Tue, 11 May 2021 05:34:42 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxJqz59yZbBMgUBow4PGHfnRIC+s4ZuMJj27i7yGmwwt+E41v17kNaSuDhtVZUG8+4/ebcZUg==
X-Received: by 2002:a37:de13:: with SMTP id h19mr11142715qkj.346.1620736482321;
        Tue, 11 May 2021 05:34:42 -0700 (PDT)
Received: from bfoster ([98.216.211.229])
        by smtp.gmail.com with ESMTPSA id u27sm6222181qku.33.2021.05.11.05.34.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 May 2021 05:34:42 -0700 (PDT)
Date:   Tue, 11 May 2021 08:34:40 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 16/22] xfs: remove agno from btree cursor
Message-ID: <YJp54LyDZliZVR1H@bfoster>
References: <20210506072054.271157-1-david@fromorbit.com>
 <20210506072054.271157-17-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210506072054.271157-17-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, May 06, 2021 at 05:20:48PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Now that everything passes a perag, the agno is not needed anymore.
> Convert all the users to use pag->pag_agno instead and remove the
> agno from the cursor. This was largely done as an automated search
> and replace.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/libxfs/xfs_alloc.c          |   2 +-
>  fs/xfs/libxfs/xfs_alloc_btree.c    |   1 -
>  fs/xfs/libxfs/xfs_btree.c          |  12 ++--
>  fs/xfs/libxfs/xfs_btree.h          |   1 -
>  fs/xfs/libxfs/xfs_ialloc.c         |   2 +-
>  fs/xfs/libxfs/xfs_ialloc_btree.c   |   7 +-
>  fs/xfs/libxfs/xfs_refcount.c       |  82 +++++++++++-----------
>  fs/xfs/libxfs/xfs_refcount_btree.c |  11 ++-
>  fs/xfs/libxfs/xfs_rmap.c           | 108 ++++++++++++++---------------
>  fs/xfs/libxfs/xfs_rmap_btree.c     |   1 -
>  fs/xfs/scrub/agheader_repair.c     |   2 +-
>  fs/xfs/scrub/alloc.c               |   3 +-
>  fs/xfs/scrub/bmap.c                |   2 +-
>  fs/xfs/scrub/ialloc.c              |   9 +--
>  fs/xfs/scrub/refcount.c            |   3 +-
>  fs/xfs/scrub/rmap.c                |   3 +-
>  fs/xfs/scrub/trace.c               |   3 +-
>  fs/xfs/xfs_fsmap.c                 |   4 +-
>  fs/xfs/xfs_trace.h                 |   4 +-
>  19 files changed, 130 insertions(+), 130 deletions(-)
> 
...
> diff --git a/fs/xfs/libxfs/xfs_rmap.c b/fs/xfs/libxfs/xfs_rmap.c
> index b23f949ee15c..d1dfad0204e3 100644
> --- a/fs/xfs/libxfs/xfs_rmap.c
> +++ b/fs/xfs/libxfs/xfs_rmap.c
...
> @@ -2389,7 +2389,7 @@ xfs_rmap_finish_one(
>  	 * the startblock, get one now.
>  	 */
>  	rcur = *pcur;
> -	if (rcur != NULL && rcur->bc_ag.agno != pag->pag_agno) {
> +	if (rcur != NULL && rcur->bc_ag.pag != pag) {

I wonder a bit about this sort of logic if the goal is to ultimately
allow for dynamic instantiation of perag structures, though it's
probably not an issue here.

>  		xfs_rmap_finish_one_cleanup(tp, rcur, 0);
>  		rcur = NULL;
>  		*pcur = NULL;
...
> diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> index 808ae337b222..5ba9c6396dcb 100644
> --- a/fs/xfs/xfs_trace.h
> +++ b/fs/xfs/xfs_trace.h
> @@ -3730,7 +3730,7 @@ TRACE_EVENT(xfs_btree_commit_afakeroot,
>  	TP_fast_assign(
>  		__entry->dev = cur->bc_mp->m_super->s_dev;
>  		__entry->btnum = cur->bc_btnum;
> -		__entry->agno = cur->bc_ag.agno;
> +		__entry->agno = cur->bc_ag.pag->pag_agno;

It would be nice if we did this with some of the other tracepoints
rather than pulling ->pag_agno out at every callsite, but that's
probably something for another patch. All in all this looks fine to me:

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  		__entry->agbno = cur->bc_ag.afake->af_root;
>  		__entry->levels = cur->bc_ag.afake->af_levels;
>  		__entry->blocks = cur->bc_ag.afake->af_blocks;
> @@ -3845,7 +3845,7 @@ TRACE_EVENT(xfs_btree_bload_block,
>  			__entry->agno = XFS_FSB_TO_AGNO(cur->bc_mp, fsb);
>  			__entry->agbno = XFS_FSB_TO_AGBNO(cur->bc_mp, fsb);
>  		} else {
> -			__entry->agno = cur->bc_ag.agno;
> +			__entry->agno = cur->bc_ag.pag->pag_agno;
>  			__entry->agbno = be32_to_cpu(ptr->s);
>  		}
>  		__entry->nr_records = nr_records;
> -- 
> 2.31.1
> 

