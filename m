Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6298EC433ED
	for <linux-xfs@archiver.kernel.org>; Mon, 10 May 2021 13:40:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2DCD261421
	for <linux-xfs@archiver.kernel.org>; Mon, 10 May 2021 13:40:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236102AbhEJNlf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 10 May 2021 09:41:35 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:47116 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1347922AbhEJMyl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 10 May 2021 08:54:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620651213;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=1u+kHe/RGNDXioH3lrufzWT0BKxU0h7bLYXSbObty2k=;
        b=NRAZRRCc5S42f0LMapQILLoVx5HjLgrKbBXQamctPDscbtsPSKI144W8xcYYat8LOhwogq
        ODweqiLeXcVLBrtQLfoF0Dw1a/DZHD50C4U5Wnv09YgXdR1e5C1U89lBbz5OIBJT+uhOKL
        lBb9O/XPx1v3SoLCUWdq3cwdc/6312g=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-167-e014x6NFPmunxtMa4crqPQ-1; Mon, 10 May 2021 08:53:31 -0400
X-MC-Unique: e014x6NFPmunxtMa4crqPQ-1
Received: by mail-qt1-f197.google.com with SMTP id h2-20020a05622a1702b02901b9123889b0so10310717qtk.10
        for <linux-xfs@vger.kernel.org>; Mon, 10 May 2021 05:53:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=1u+kHe/RGNDXioH3lrufzWT0BKxU0h7bLYXSbObty2k=;
        b=t8j97juTDoO+1AgczXc+VDFfABZ4ZLcw3NEWijULDpYm6jiZDInzv0hRBLO6wpSp8n
         3KouZuH2GiCek9n3aYJmaOoPjoeXg5hp+UQfFvs+09xMwIZCgefvI5Zv0qR7UMciLqC/
         zV9rIPigd1BYDoVwhkWVZVrKmiWoGUSsEzRnG5a6orLmy8uz3+ccDeyAnaTTUFg/0PxM
         t7EvtkomhLW10LXmYqJBzbYWJYvAkQ37Yt25Zhr2iv4+Knrw7A2C5g9nDJx538uIEpUk
         /Fl6DZj/BUn7LW+PGYWal0+ywyN23tUhTW+/Lkv5B1mL7t80rDM/aB0pCrhWrDdxVXth
         cz8g==
X-Gm-Message-State: AOAM531LzXZ1gBNpvzsOiyDRf6AQY/gwJsqi7LQt1Ehb9/KyqTJpJktM
        pH7VaIbViepBzAGssXxGGRW+7QhDWYi88GaVOS3x0bxTwgGhDkPJ59wSR7+NrV0wZNno3FN9dJt
        l9jVMKrWZVhD/E1aVZf7U
X-Received: by 2002:a37:41ce:: with SMTP id o197mr23093136qka.122.1620651210611;
        Mon, 10 May 2021 05:53:30 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyrhguHWvJpzXodDiKpks2k/2ubNf7R2KqqGagn5/J80cg8ZHdfPPhhpmpf7U6KDVXVDMdXfQ==
X-Received: by 2002:a37:41ce:: with SMTP id o197mr23093125qka.122.1620651210401;
        Mon, 10 May 2021 05:53:30 -0700 (PDT)
Received: from bfoster ([98.216.211.229])
        by smtp.gmail.com with ESMTPSA id m22sm10970476qkk.65.2021.05.10.05.53.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 May 2021 05:53:30 -0700 (PDT)
Date:   Mon, 10 May 2021 08:53:28 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 02/22] xfs: prepare for moving perag definitions and
 support to libxfs
Message-ID: <YJksyJDAfDmv326/@bfoster>
References: <20210506072054.271157-1-david@fromorbit.com>
 <20210506072054.271157-3-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210506072054.271157-3-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, May 06, 2021 at 05:20:34PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> The perag structures really need to be defined with the rest of the
> AG support infrastructure. The struct xfs_perag and init/teardown
> has been placed in xfs_mount.[ch] because there are differences in
> the structure between kernel and userspace. Mainly that userspace
> doesn't have a lot of the internal stuff that the kernel has for
> caches and discard and other such structures.
> 
> However, it makes more sense to move this to libxfs than to keep
> this separation because we are now moving to use struct perags
> everywhere in the code instead of passing raw agnumber_t values
> about. Hence we shoudl really move the support infrastructure to
> libxfs/xfs_ag.[ch].
> 
> To do this without breaking userspace, first we need to rearrange
> the structures and code so that all the kernel specific code is
> located together. This makes it simple for userspace to ifdef out
> the all the parts it does not need, minimising the code differences
> between kernel and userspace. The next commit will do the move...
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_mount.c | 50 ++++++++++++++++++++++++++--------------------
>  fs/xfs/xfs_mount.h | 19 +++++++++---------
>  2 files changed, 38 insertions(+), 31 deletions(-)
> 
> diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> index 21c630dde476..2e6d42014346 100644
> --- a/fs/xfs/xfs_mount.c
> +++ b/fs/xfs/xfs_mount.c
...
> @@ -229,13 +220,27 @@ xfs_initialize_perag(
>  		}
>  		spin_unlock(&mp->m_perag_lock);
>  		radix_tree_preload_end();
> -		/* first new pag is fully initialized */
> -		if (first_initialised == NULLAGNUMBER)
> -			first_initialised = index;
> +
> +		spin_lock_init(&pag->pag_ici_lock);
> +		spin_lock_init(&pag->pagb_lock);
> +		spin_lock_init(&pag->pag_state_lock);
> +		INIT_DELAYED_WORK(&pag->pag_blockgc_work, xfs_blockgc_worker);
> +		INIT_RADIX_TREE(&pag->pag_ici_root, GFP_ATOMIC);
> +		init_waitqueue_head(&pag->pagb_wait);
> +		pag->pagb_count = 0;
> +		pag->pagb_tree = RB_ROOT;
> +
> +		error = xfs_buf_hash_init(pag);
> +		if (error)
> +			goto out_free_pag;
> +

There's error handling code earlier up in this function that still lands
in out_hash_destroy, which is now before we get to the _hash_init()
call.

>  		error = xfs_iunlink_init(pag);
>  		if (error)
>  			goto out_hash_destroy;
> -		spin_lock_init(&pag->pag_state_lock);
> +
> +		/* first new pag is fully initialized */
> +		if (first_initialised == NULLAGNUMBER)
> +			first_initialised = index;
>  	}
>  
>  	index = xfs_set_inode_alloc(mp, agcount);
> @@ -249,6 +254,7 @@ xfs_initialize_perag(
>  out_hash_destroy:
>  	xfs_buf_hash_destroy(pag);
>  out_free_pag:
> +	pag = radix_tree_delete(&mp->m_perag_tree, index);

Now if we get here with an allocated pag that hasn't been inserted to
the tree, I suspect this call would assign pag = NULL..

Brian

>  	kmem_free(pag);
>  out_unwind_new_pags:
>  	/* unwind any prior newly initialized pags */
> diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
> index bb67274ee23f..6e534be5eea8 100644
> --- a/fs/xfs/xfs_mount.h
> +++ b/fs/xfs/xfs_mount.h
> @@ -338,6 +338,16 @@ typedef struct xfs_perag {
>  	xfs_agino_t	pagl_leftrec;
>  	xfs_agino_t	pagl_rightrec;
>  
> +	int		pagb_count;	/* pagb slots in use */
> +	uint8_t		pagf_refcount_level; /* recount btree height */
> +
> +	/* Blocks reserved for all kinds of metadata. */
> +	struct xfs_ag_resv	pag_meta_resv;
> +	/* Blocks reserved for the reverse mapping btree. */
> +	struct xfs_ag_resv	pag_rmapbt_resv;
> +
> +	/* -- kernel only structures below this line -- */
> +
>  	/*
>  	 * Bitsets of per-ag metadata that have been checked and/or are sick.
>  	 * Callers should hold pag_state_lock before accessing this field.
> @@ -364,19 +374,10 @@ typedef struct xfs_perag {
>  
>  	/* for rcu-safe freeing */
>  	struct rcu_head	rcu_head;
> -	int		pagb_count;	/* pagb slots in use */
> -
> -	/* Blocks reserved for all kinds of metadata. */
> -	struct xfs_ag_resv	pag_meta_resv;
> -	/* Blocks reserved for the reverse mapping btree. */
> -	struct xfs_ag_resv	pag_rmapbt_resv;
>  
>  	/* background prealloc block trimming */
>  	struct delayed_work	pag_blockgc_work;
>  
> -	/* reference count */
> -	uint8_t			pagf_refcount_level;
> -
>  	/*
>  	 * Unlinked inode information.  This incore information reflects
>  	 * data stored in the AGI, so callers must hold the AGI buffer lock
> -- 
> 2.31.1
> 

