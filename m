Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5F11C433F5
	for <linux-xfs@archiver.kernel.org>; Thu,  4 Nov 2021 19:08:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8379861220
	for <linux-xfs@archiver.kernel.org>; Thu,  4 Nov 2021 19:08:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234125AbhKDTLZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 4 Nov 2021 15:11:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:47574 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234130AbhKDTLY (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 4 Nov 2021 15:11:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 35BA76121F;
        Thu,  4 Nov 2021 19:08:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636052926;
        bh=mbSg7F04MhQteeVctpXPXeHojMe5WcJKOuNXsHjs6vA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=eGiGEuarIdhqvaBAcgHnnO+lXp6/+E5W1zJB/DNix8K+Q2ee8Zu68W+a3d72SEW+x
         aJkbufG5fr8yYhxaVCiYGPQRvYK6UVWSc9m8afkPgjqdDOC5yr134F6rBHw+cHijAp
         rlxSdriEPkLxkk7pQlVEW6NICiHqOMK0FyJ+G5+ZNj7HyeW8Ectb2Uv4GizeNoAz0X
         QwjHhwwkWv1Z+8vyxROf6W08BhVpT+YkGVGmLa8MzHuEzRH0MmasYZl/RtNOqdrJH4
         kpbz3gyefGNRrW75hbxj81NuSVx/XVBrcVN16PSywsKsDtuLHct2eHd9E0SXoX1Q6O
         +FYYkhnwQrteA==
Date:   Thu, 4 Nov 2021 12:08:45 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@redhat.com
Cc:     xfs <linux-xfs@vger.kernel.org>, Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH V3 RFC] xfsprogs: remove stubbed-out kernel functions out
 from xfs_shared.h
Message-ID: <20211104190845.GT24307@magnolia>
References: <389722a5-4b02-c76d-a5ac-d92d1e642b21@redhat.com>
 <fa2fe2c5-645b-6263-3493-b59b4d096488@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fa2fe2c5-645b-6263-3493-b59b4d096488@redhat.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Nov 04, 2021 at 12:15:04PM -0500, Eric Sandeen wrote:
> Remove these kernel stubs by #ifdeffing code instead.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> Dave preferred #ifdefs over stubs, and this is what I came up with.
>
> Honestly, I think this is worse, and will lead to more libxfs-sync pain
> unless we're willing to scatter #ifdefs around the kernel code as well,
> but I figured I'd put this out there for discussion.

Yuck.  Now I wish I'd pushed back harder on the patch author (Dave) to
provide the xfsprogs version of this, or whatever fixes are needed to
libxfs-diff to deuglify whatever the result was, rather than let this
fall to the maintainer (Eric). :/

--D

> 
> diff --git a/libxfs/xfs_ag.c b/libxfs/xfs_ag.c
> index 9eda6eba..c01986f7 100644
> --- a/libxfs/xfs_ag.c
> +++ b/libxfs/xfs_ag.c
> @@ -170,7 +170,9 @@ __xfs_free_perag(
>  {
>  	struct xfs_perag *pag = container_of(head, struct xfs_perag, rcu_head);
> +#ifdef __KERNEL__
>  	ASSERT(!delayed_work_pending(&pag->pag_blockgc_work));
> +#endif	/* __KERNEL__ */
>  	ASSERT(atomic_read(&pag->pag_ref) == 0);
>  	kmem_free(pag);
>  }
> @@ -192,9 +194,11 @@ xfs_free_perag(
>  		ASSERT(pag);
>  		ASSERT(atomic_read(&pag->pag_ref) == 0);
> +#ifdef __KERNEL__
>  		cancel_delayed_work_sync(&pag->pag_blockgc_work);
>  		xfs_iunlink_destroy(pag);
>  		xfs_buf_hash_destroy(pag);
> +#endif	/* __KERNEL__ */
>  		call_rcu(&pag->rcu_head, __xfs_free_perag);
>  	}
> @@ -246,6 +250,7 @@ xfs_initialize_perag(
>  		spin_unlock(&mp->m_perag_lock);
>  		radix_tree_preload_end();
> +#ifdef __KERNEL__
>  		/* Place kernel structure only init below this point. */
>  		spin_lock_init(&pag->pag_ici_lock);
>  		spin_lock_init(&pag->pagb_lock);
> @@ -267,6 +272,7 @@ xfs_initialize_perag(
>  		/* first new pag is fully initialized */
>  		if (first_initialised == NULLAGNUMBER)
>  			first_initialised = index;
> +#endif	/* __KERNEL__ */
>  	}
>  	index = xfs_set_inode_alloc(mp, agcount);
> @@ -277,10 +283,12 @@ xfs_initialize_perag(
>  	mp->m_ag_prealloc_blocks = xfs_prealloc_blocks(mp);
>  	return 0;
> +#ifdef __KERNEL__
>  out_hash_destroy:
>  	xfs_buf_hash_destroy(pag);
>  out_remove_pag:
>  	radix_tree_delete(&mp->m_perag_tree, index);
> +#endif	/* __KERNEL__ */
>  out_free_pag:
>  	kmem_free(pag);
>  out_unwind_new_pags:
> diff --git a/libxfs/xfs_ag.h b/libxfs/xfs_ag.h
> index 4c6f9045..dda1303e 100644
> --- a/libxfs/xfs_ag.h
> +++ b/libxfs/xfs_ag.h
> @@ -64,6 +64,9 @@ struct xfs_perag {
>  	/* Blocks reserved for the reverse mapping btree. */
>  	struct xfs_ag_resv	pag_rmapbt_resv;
> +	/* for rcu-safe freeing */
> +	struct rcu_head	rcu_head;
> +
>  	/* -- kernel only structures below this line -- */
>  	/*
> @@ -75,6 +78,7 @@ struct xfs_perag {
>  	spinlock_t	pag_state_lock;
>  	spinlock_t	pagb_lock;	/* lock for pagb_tree */
> +#ifdef __KERNEL__
>  	struct rb_root	pagb_tree;	/* ordered tree of busy extents */
>  	unsigned int	pagb_gen;	/* generation count for pagb_tree */
>  	wait_queue_head_t pagb_wait;	/* woken when pagb_gen changes */
> @@ -90,9 +94,6 @@ struct xfs_perag {
>  	spinlock_t	pag_buf_lock;	/* lock for pag_buf_hash */
>  	struct rhashtable pag_buf_hash;
> -	/* for rcu-safe freeing */
> -	struct rcu_head	rcu_head;
> -
>  	/* background prealloc block trimming */
>  	struct delayed_work	pag_blockgc_work;
> @@ -102,6 +103,7 @@ struct xfs_perag {
>  	 * or have some other means to control concurrency.
>  	 */
>  	struct rhashtable	pagi_unlinked_hash;
> +#endif	/* __KERNEL__ */
>  };
>  int xfs_initialize_perag(struct xfs_mount *mp, xfs_agnumber_t agcount,
> diff --git a/libxfs/xfs_shared.h b/libxfs/xfs_shared.h
> index bafee48c..25c4cab5 100644
> --- a/libxfs/xfs_shared.h
> +++ b/libxfs/xfs_shared.h
> @@ -180,24 +180,4 @@ struct xfs_ino_geometry {
>  };
> -/* Faked up kernel bits */
> -struct rb_root {
> -};
> -
> -#define RB_ROOT 		(struct rb_root) { }
> -
> -typedef struct wait_queue_head {
> -} wait_queue_head_t;
> -
> -#define init_waitqueue_head(wqh)	do { } while(0)
> -
> -struct rhashtable {
> -};
> -
> -struct delayed_work {
> -};
> -
> -#define INIT_DELAYED_WORK(work, func)	do { } while(0)
> -#define cancel_delayed_work_sync(work)	do { } while(0)
> -
>  #endif /* __XFS_SHARED_H__ */
> 
