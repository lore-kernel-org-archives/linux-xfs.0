Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6728AC47082
	for <linux-xfs@archiver.kernel.org>; Wed, 26 May 2021 12:33:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 44D39613EC
	for <linux-xfs@archiver.kernel.org>; Wed, 26 May 2021 12:33:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233232AbhEZMfV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 26 May 2021 08:35:21 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:44547 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232808AbhEZMfP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 May 2021 08:35:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622032423;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=4a9P20xp5oQGQKAv0E8BU+gamLRIgT5lSKjAdnaWVAs=;
        b=gwzw4qnNr3CUOY7RDt/lUA6LWSIVazfDPSeKiXtHv425gdiUXdiTfAm+xcb9PCdg1ik5Gs
        TX3xE9OucJvyZ+zz5eM9ADN5MoNR8MuYngibEJU+BN4vpJC36lUXaAseKWu4pwG5h/4cqj
        cCCDOAwH4ewQe97iVxKUPDPlnWYCH/E=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-460-Xd3T2VbQMyO04Ob1DWuN3A-1; Wed, 26 May 2021 08:33:41 -0400
X-MC-Unique: Xd3T2VbQMyO04Ob1DWuN3A-1
Received: by mail-qk1-f198.google.com with SMTP id z12-20020a05620a08ccb02902ea1e4a963dso619040qkz.13
        for <linux-xfs@vger.kernel.org>; Wed, 26 May 2021 05:33:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=4a9P20xp5oQGQKAv0E8BU+gamLRIgT5lSKjAdnaWVAs=;
        b=jzFhTBaXUfAGvQC96lEryo8AzJDCadeGg312flxbR+y34IMUqVBP91ZauYK89YhSB4
         DoRZCTSXZi3tdp8533SQcK4XB/DJSAPAdmwYcJ5ecOQGdBqm4nBuMAibtXrO/UsdsNHk
         BXszpmI+/M4WU1uvTum7T6cH34itO8eLkVMT6Ayrm/mGRrazBOalAOJPuvLv1Yl2Akgi
         GTtO0bc4/B8EVlvX6V7NC2XLDuyWArq1ywLSnRiXTzvkk4Dd19FS2C0CvD0dR0Ek31J3
         NxGPglut/JlF4aJCAh9IjSZE2jyNP+Ijfq3eZQCc+roEFV+okOw3wZ/e2iV/NzQh23IA
         Bnbw==
X-Gm-Message-State: AOAM532t1Uisd2I3BJ+BpXyp3Y8x40NRZ3sfNj41uaqF75vsqxJFeepL
        DD1kkezM/yphrG83cXT4+hb3wnHCBATO/uj+r/erCImxVm4pAU/LmFNflbxM68zVuKH45+jPWOP
        vA5qYEGQCJeNwQ3R7ArnQ
X-Received: by 2002:a37:b107:: with SMTP id a7mr40316219qkf.366.1622032420846;
        Wed, 26 May 2021 05:33:40 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzFiu0gkaZTQnc+JZZg9IVAR03AEvSnPqMmACdyrseOln7fV10K2Hdz3iRDbmW4uszlIKwRiw==
X-Received: by 2002:a37:b107:: with SMTP id a7mr40316195qkf.366.1622032420561;
        Wed, 26 May 2021 05:33:40 -0700 (PDT)
Received: from bfoster ([98.216.211.229])
        by smtp.gmail.com with ESMTPSA id d28sm1411344qkl.105.2021.05.26.05.33.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 May 2021 05:33:40 -0700 (PDT)
Date:   Wed, 26 May 2021 08:33:38 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 02/23] xfs: prepare for moving perag definitions and
 support to libxfs
Message-ID: <YK5AIiit6U3vW5yM@bfoster>
References: <20210519012102.450926-1-david@fromorbit.com>
 <20210519012102.450926-3-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210519012102.450926-3-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, May 19, 2021 at 11:20:41AM +1000, Dave Chinner wrote:
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

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_mount.c | 56 ++++++++++++++++++++++++++--------------------
>  fs/xfs/xfs_mount.h | 19 ++++++++--------
>  2 files changed, 42 insertions(+), 33 deletions(-)
> 
> diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> index 21c630dde476..6966d7b12a13 100644
> --- a/fs/xfs/xfs_mount.c
> +++ b/fs/xfs/xfs_mount.c
> @@ -148,9 +148,11 @@ xfs_free_perag(
>  		spin_unlock(&mp->m_perag_lock);
>  		ASSERT(pag);
>  		ASSERT(atomic_read(&pag->pag_ref) == 0);
> +
>  		cancel_delayed_work_sync(&pag->pag_blockgc_work);
>  		xfs_iunlink_destroy(pag);
>  		xfs_buf_hash_destroy(pag);
> +
>  		call_rcu(&pag->rcu_head, __xfs_free_perag);
>  	}
>  }
> @@ -175,14 +177,14 @@ xfs_sb_validate_fsb_count(
>  
>  int
>  xfs_initialize_perag(
> -	xfs_mount_t	*mp,
> -	xfs_agnumber_t	agcount,
> -	xfs_agnumber_t	*maxagi)
> +	struct xfs_mount	*mp,
> +	xfs_agnumber_t		agcount,
> +	xfs_agnumber_t		*maxagi)
>  {
> -	xfs_agnumber_t	index;
> -	xfs_agnumber_t	first_initialised = NULLAGNUMBER;
> -	xfs_perag_t	*pag;
> -	int		error = -ENOMEM;
> +	struct xfs_perag	*pag;
> +	xfs_agnumber_t		index;
> +	xfs_agnumber_t		first_initialised = NULLAGNUMBER;
> +	int			error;
>  
>  	/*
>  	 * Walk the current per-ag tree so we don't try to initialise AGs
> @@ -203,21 +205,10 @@ xfs_initialize_perag(
>  		}
>  		pag->pag_agno = index;
>  		pag->pag_mount = mp;
> -		spin_lock_init(&pag->pag_ici_lock);
> -		INIT_DELAYED_WORK(&pag->pag_blockgc_work, xfs_blockgc_worker);
> -		INIT_RADIX_TREE(&pag->pag_ici_root, GFP_ATOMIC);
> -
> -		error = xfs_buf_hash_init(pag);
> -		if (error)
> -			goto out_free_pag;
> -		init_waitqueue_head(&pag->pagb_wait);
> -		spin_lock_init(&pag->pagb_lock);
> -		pag->pagb_count = 0;
> -		pag->pagb_tree = RB_ROOT;
>  
>  		error = radix_tree_preload(GFP_NOFS);
>  		if (error)
> -			goto out_hash_destroy;
> +			goto out_free_pag;
>  
>  		spin_lock(&mp->m_perag_lock);
>  		if (radix_tree_insert(&mp->m_perag_tree, index, pag)) {
> @@ -225,17 +216,32 @@ xfs_initialize_perag(
>  			spin_unlock(&mp->m_perag_lock);
>  			radix_tree_preload_end();
>  			error = -EEXIST;
> -			goto out_hash_destroy;
> +			goto out_free_pag;
>  		}
>  		spin_unlock(&mp->m_perag_lock);
>  		radix_tree_preload_end();
> -		/* first new pag is fully initialized */
> -		if (first_initialised == NULLAGNUMBER)
> -			first_initialised = index;
> +
> +		/* Place kernel structure only init below this point. */
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
> +			goto out_remove_pag;
> +
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
> @@ -248,6 +254,8 @@ xfs_initialize_perag(
>  
>  out_hash_destroy:
>  	xfs_buf_hash_destroy(pag);
> +out_remove_pag:
> +	radix_tree_delete(&mp->m_perag_tree, index);
>  out_free_pag:
>  	kmem_free(pag);
>  out_unwind_new_pags:
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

