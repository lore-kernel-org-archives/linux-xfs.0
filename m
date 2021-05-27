Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A6CDC4707F
	for <linux-xfs@archiver.kernel.org>; Thu, 27 May 2021 22:02:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E6D63613EB
	for <linux-xfs@archiver.kernel.org>; Thu, 27 May 2021 22:02:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234684AbhE0WDy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 27 May 2021 18:03:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:57234 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234404AbhE0WDy (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 27 May 2021 18:03:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7E2C56113B;
        Thu, 27 May 2021 22:02:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622152940;
        bh=4T5g8Z3gfAwUAZTay4sjwlxIg9xOsYsdZ9dHCXOhfb8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PE1wKNcvTkarROMXCUCUbDlE4U/LAAEL/fGYmrSw5KA1ILYFMqyi/pcJKmvd7DKGV
         tJxBKz8uEwr3zJ6yOaklElZovmzBw4faKTghfWRjGXSFdDXfkaHcSjOEPotohCSdgg
         xWHkB9b9j3dD7EPSYrDiVKwRjyT5kiSw2hyNi+4MQ/AVJQ5epXIsjFfIFu/TbqHYD2
         eMNV/DrgJDFURgJPTBpKAWrw8haiPKPhNytUDsVQXpS0oL6yAoeUNOSOd+prfg+dM1
         Dzk1Kwe6Co4GPtJEXE/YlUWEQf6u04FeAK1sgymgKeKWngGc6w49CiX9oCu6GUx8No
         weSSCf1Bsv9lg==
Date:   Thu, 27 May 2021 15:02:20 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 02/23] xfs: prepare for moving perag definitions and
 support to libxfs
Message-ID: <20210527220220.GQ2402049@locust>
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

Looks good this time around,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
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
