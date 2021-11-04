Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED393C433F5
	for <linux-xfs@archiver.kernel.org>; Thu,  4 Nov 2021 22:38:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C754C61139
	for <linux-xfs@archiver.kernel.org>; Thu,  4 Nov 2021 22:38:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232346AbhKDWlF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 4 Nov 2021 18:41:05 -0400
Received: from mail107.syd.optusnet.com.au ([211.29.132.53]:50569 "EHLO
        mail107.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229587AbhKDWlF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 4 Nov 2021 18:41:05 -0400
Received: from dread.disaster.area (pa49-180-20-157.pa.nsw.optusnet.com.au [49.180.20.157])
        by mail107.syd.optusnet.com.au (Postfix) with ESMTPS id BE74AF2B8A1;
        Fri,  5 Nov 2021 09:38:24 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1milNH-004whN-UO; Fri, 05 Nov 2021 09:38:23 +1100
Date:   Fri, 5 Nov 2021 09:38:23 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     sandeen@redhat.com
Cc:     xfs <linux-xfs@vger.kernel.org>,
        "Darrick J. Wong" <djwong@kernel.org>
Subject: Re: [PATCH V3 RFC] xfsprogs: remove stubbed-out kernel functions out
 from xfs_shared.h
Message-ID: <20211104223823.GF449541@dread.disaster.area>
References: <389722a5-4b02-c76d-a5ac-d92d1e642b21@redhat.com>
 <fa2fe2c5-645b-6263-3493-b59b4d096488@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fa2fe2c5-645b-6263-3493-b59b4d096488@redhat.com>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=618460e1
        a=t5ERiztT/VoIE8AqcczM6g==:117 a=t5ERiztT/VoIE8AqcczM6g==:17
        a=kj9zAlcOel0A:10 a=vIxV3rELxO4A:10 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8
        a=xwu987gVM0DWHsuQlQgA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
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

These can be stubbed in libxfs_priv.h as we do with all other kernel
functions we don't use:

#define delayed_work_pending(a)		((void)0)
#define cancel_delayed_work_sync(a)	((void)0)
#define xfs_iunlink_destroy(a)		((void)0)
#define xfs_buf_hash_destroy(a)		((void)0)

That is the normal way we avoid needing these ifdef KERNEL clauses
in the libxfs C code. 

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

endif is in the wrong place - it needs to be before the
first_initialised checks because that is necessary for error
unwinding.

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

Again, stubbing out the functions like so:

#define xfs_buf_hash_init(a)		((void)0)
#define xfs_unlink_init(a)		((void)0)

means that the conditional init code doesn't need to be ifdef'd out
and so the error unwinding doesn't need to be ifdef'd out, either.
And, FWIW, you missed the xfs_buf_hash_destroy/xfs_iunlink_destroy
calls in the unwinding code....

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

Moving the rcu_head needs to be done in a separate patch, as that
needs to be done on the kernel side, too. When this change went into
the kernel, we didn't have userspace RCU so it was considered a
kernel only structure....

With those changes, we end up with some new stubs in libxfs_priv.h
and two places where we need #ifdef __KERNEL__ in xfs_ag.[ch]. Most
of the mess in this patch goes away....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
