Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F245C433F5
	for <linux-xfs@archiver.kernel.org>; Thu, 21 Oct 2021 01:56:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E28C561186
	for <linux-xfs@archiver.kernel.org>; Thu, 21 Oct 2021 01:56:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230103AbhJUB6m (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 20 Oct 2021 21:58:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:34468 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229771AbhJUB6l (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 20 Oct 2021 21:58:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 97BAE610A2;
        Thu, 21 Oct 2021 01:56:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634781386;
        bh=gmfFdUKUsgEvTd8jXQ7boxd7MXuugem0DsRAlarE7uI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OzmaiexQh2Z+GPYAujqZwahSh/2JIQaDKOMs5sppMACxXhvFqcmdHxMz4/QVkODa8
         +XouJV+e7msdhgUcJnbPfxdubR471jSUw+7T7efRwjRMTQiVKbNtkUl0nmTlIrj/Iw
         TH2kIUjiMPo7vreJmN61amBs0t/z0lZ849XOgjCPm0nLB4fooXU+vov2iy7+1lUHEo
         z2te+p1+LojNXawerERhGQGWjCKLoUMjhA259XebsH6lhUQgmvLY8A5f70KTvoWhGa
         VzRmhEQH8fa1xkuQbCnit1/XogiUpjlxY57Q9R2K48uCg837PNAseeB8/lI76biJge
         0cSqeI+1oDFxw==
Date:   Wed, 20 Oct 2021 18:56:26 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Chandan Babu R <chandan.babu@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/5] xfs: create slab caches for frequently-used deferred
 items
Message-ID: <20211021015626.GU24307@magnolia>
References: <163466952709.2235671.6966476326124447013.stgit@magnolia>
 <163466953819.2235671.899746816552861515.stgit@magnolia>
 <874k9cht4h.fsf@debian-BULLSEYE-live-builder-AMD64>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <874k9cht4h.fsf@debian-BULLSEYE-live-builder-AMD64>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Oct 20, 2021 at 04:15:34PM +0530, Chandan Babu R wrote:
> On 20 Oct 2021 at 00:22, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> >
> > Create slab caches for the high-level structures that coordinate
> > deferred intent items, since they're used fairly heavily.
> >
> 
> Apart from the nits pointed later in this mail, the remaining changes looks
> good to me.
> 
> Reviewed-by: Chandan Babu R <chandan.babu@oracle.com>
> 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> >  fs/xfs/libxfs/xfs_bmap.c     |   21 +++++++++++++-
> >  fs/xfs/libxfs/xfs_bmap.h     |    5 +++
> >  fs/xfs/libxfs/xfs_defer.c    |   62 +++++++++++++++++++++++++++++++++++++++---
> >  fs/xfs/libxfs/xfs_defer.h    |    3 ++
> >  fs/xfs/libxfs/xfs_refcount.c |   23 ++++++++++++++--
> >  fs/xfs/libxfs/xfs_refcount.h |    5 +++
> >  fs/xfs/libxfs/xfs_rmap.c     |   21 ++++++++++++++
> >  fs/xfs/libxfs/xfs_rmap.h     |    5 +++
> >  fs/xfs/xfs_bmap_item.c       |    4 +--
> >  fs/xfs/xfs_refcount_item.c   |    4 +--
> >  fs/xfs/xfs_rmap_item.c       |    4 +--
> >  fs/xfs/xfs_super.c           |   10 ++++++-
> >  12 files changed, 151 insertions(+), 16 deletions(-)
> >
> >
> > diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> > index 8a993ef6b7f4..ef2ac0ecaed9 100644
> > --- a/fs/xfs/libxfs/xfs_bmap.c
> > +++ b/fs/xfs/libxfs/xfs_bmap.c
> > @@ -37,7 +37,7 @@
> >  #include "xfs_icache.h"
> >  #include "xfs_iomap.h"
> >  
> > -
> > +struct kmem_cache		*xfs_bmap_intent_cache;
> >  struct kmem_cache		*xfs_bmap_free_item_cache;
> >  
> >  /*
> > @@ -6190,7 +6190,7 @@ __xfs_bmap_add(
> >  			bmap->br_blockcount,
> >  			bmap->br_state);
> >  
> > -	bi = kmem_alloc(sizeof(struct xfs_bmap_intent), KM_NOFS);
> > +	bi = kmem_cache_alloc(xfs_bmap_intent_cache, GFP_NOFS | __GFP_NOFAIL);
> >  	INIT_LIST_HEAD(&bi->bi_list);
> >  	bi->bi_type = type;
> >  	bi->bi_owner = ip;
> > @@ -6301,3 +6301,20 @@ xfs_bmap_validate_extent(
> >  		return __this_address;
> >  	return NULL;
> >  }
> > +
> > +int __init
> > +xfs_bmap_intent_init_cache(void)
> > +{
> > +	xfs_bmap_intent_cache = kmem_cache_create("xfs_bmap_intent",
> > +			sizeof(struct xfs_bmap_intent),
> > +			0, 0, NULL);
> > +
> > +	return xfs_bmap_intent_cache != NULL ? 0 : -ENOMEM;
> > +}
> > +
> > +void
> > +xfs_bmap_intent_destroy_cache(void)
> > +{
> > +	kmem_cache_destroy(xfs_bmap_intent_cache);
> > +	xfs_bmap_intent_cache = NULL;
> > +}
> > diff --git a/fs/xfs/libxfs/xfs_bmap.h b/fs/xfs/libxfs/xfs_bmap.h
> > index db01fe83bb8a..fa73a56827b1 100644
> > --- a/fs/xfs/libxfs/xfs_bmap.h
> > +++ b/fs/xfs/libxfs/xfs_bmap.h
> > @@ -290,4 +290,9 @@ int	xfs_bmapi_remap(struct xfs_trans *tp, struct xfs_inode *ip,
> >  		xfs_fileoff_t bno, xfs_filblks_t len, xfs_fsblock_t startblock,
> >  		int flags);
> >  
> > +extern struct kmem_cache	*xfs_bmap_intent_cache;
> > +
> > +int __init xfs_bmap_intent_init_cache(void);
> > +void xfs_bmap_intent_destroy_cache(void);
> > +
> >  #endif	/* __XFS_BMAP_H__ */
> > diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
> > index 136a367d7b16..641a5dee4ffc 100644
> > --- a/fs/xfs/libxfs/xfs_defer.c
> > +++ b/fs/xfs/libxfs/xfs_defer.c
> > @@ -18,6 +18,11 @@
> >  #include "xfs_trace.h"
> >  #include "xfs_icache.h"
> >  #include "xfs_log.h"
> > +#include "xfs_rmap.h"
> > +#include "xfs_refcount.h"
> > +#include "xfs_bmap.h"
> > +
> > +static struct kmem_cache	*xfs_defer_pending_cache;
> >  
> >  /*
> >   * Deferred Operations in XFS
> > @@ -365,7 +370,7 @@ xfs_defer_cancel_list(
> >  			ops->cancel_item(pwi);
> >  		}
> >  		ASSERT(dfp->dfp_count == 0);
> > -		kmem_free(dfp);
> > +		kmem_cache_free(xfs_defer_pending_cache, dfp);
> >  	}
> >  }
> >  
> > @@ -462,7 +467,7 @@ xfs_defer_finish_one(
> >  
> >  	/* Done with the dfp, free it. */
> >  	list_del(&dfp->dfp_list);
> > -	kmem_free(dfp);
> > +	kmem_cache_free(xfs_defer_pending_cache, dfp);
> >  out:
> >  	if (ops->finish_cleanup)
> >  		ops->finish_cleanup(tp, state, error);
> > @@ -596,8 +601,8 @@ xfs_defer_add(
> >  			dfp = NULL;
> >  	}
> >  	if (!dfp) {
> > -		dfp = kmem_alloc(sizeof(struct xfs_defer_pending),
> > -				KM_NOFS);
> > +		dfp = kmem_cache_zalloc(xfs_defer_pending_cache,
> > +				GFP_NOFS | __GFP_NOFAIL);
> >  		dfp->dfp_type = type;
> >  		dfp->dfp_intent = NULL;
> >  		dfp->dfp_done = NULL;
> > @@ -809,3 +814,52 @@ xfs_defer_resources_rele(
> >  	dres->dr_bufs = 0;
> >  	dres->dr_ordered = 0;
> >  }
> > +
> > +static inline int __init
> > +xfs_defer_init_cache(void)
> > +{
> > +	xfs_defer_pending_cache = kmem_cache_create("xfs_defer_pending",
> > +			sizeof(struct xfs_defer_pending),
> > +			0, 0, NULL);
> > +
> > +	return xfs_defer_pending_cache != NULL ? 0 : -ENOMEM;
> > +}
> > +
> > +static inline void
> > +xfs_defer_destroy_cache(void)
> > +{
> > +	kmem_cache_destroy(xfs_defer_pending_cache);
> > +	xfs_defer_pending_cache = NULL;
> > +}
> > +
> > +/* Set up caches for deferred work items. */
> > +int __init
> > +xfs_defer_init_item_caches(void)
> > +{
> > +	int				error;
> > +
> > +	error = xfs_defer_init_cache();
> > +	if (error)
> > +		return error;
> > +	error = xfs_rmap_intent_init_cache();
> > +	if (error)
> > +		return error;
> > +	error = xfs_refcount_intent_init_cache();
> > +	if (error)
> > +		return error;
> > +	error = xfs_bmap_intent_init_cache();
> > +	if (error)
> > +		return error;
> > +
> 
> If the call to xfs_rmap_intent_init_cache() fails, then we don't free up
> xfs_defer_pending_cache. Same logic applies to the rest of initialization
> functions called above.

Ooh, good catch.  I'll go fix that.

> > +	return 0;
> > +}
> > +
> > +/* Destroy all the deferred work item caches, if they've been allocated. */
> > +void
> > +xfs_defer_destroy_item_caches(void)
> > +{
> > +	xfs_bmap_intent_destroy_cache();
> > +	xfs_refcount_intent_destroy_cache();
> > +	xfs_rmap_intent_destroy_cache();
> > +	xfs_defer_destroy_cache();
> > +}
> > diff --git a/fs/xfs/libxfs/xfs_defer.h b/fs/xfs/libxfs/xfs_defer.h
> > index 7952695c7c41..7bb8a31ad65b 100644
> > --- a/fs/xfs/libxfs/xfs_defer.h
> > +++ b/fs/xfs/libxfs/xfs_defer.h
> > @@ -122,4 +122,7 @@ void xfs_defer_ops_capture_free(struct xfs_mount *mp,
> >  		struct xfs_defer_capture *d);
> >  void xfs_defer_resources_rele(struct xfs_defer_resources *dres);
> >  
> > +int __init xfs_defer_init_item_caches(void);
> > +void xfs_defer_destroy_item_caches(void);
> > +
> >  #endif /* __XFS_DEFER_H__ */
> > diff --git a/fs/xfs/libxfs/xfs_refcount.c b/fs/xfs/libxfs/xfs_refcount.c
> > index e5d767a7fc5d..2c03df715d4f 100644
> > --- a/fs/xfs/libxfs/xfs_refcount.c
> > +++ b/fs/xfs/libxfs/xfs_refcount.c
> > @@ -24,6 +24,8 @@
> >  #include "xfs_rmap.h"
> >  #include "xfs_ag.h"
> >  
> > +struct kmem_cache	*xfs_refcount_intent_cache;
> > +
> >  /* Allowable refcount adjustment amounts. */
> >  enum xfs_refc_adjust_op {
> >  	XFS_REFCOUNT_ADJUST_INCREASE	= 1,
> > @@ -1235,8 +1237,8 @@ __xfs_refcount_add(
> >  			type, XFS_FSB_TO_AGBNO(tp->t_mountp, startblock),
> >  			blockcount);
> >  
> > -	ri = kmem_alloc(sizeof(struct xfs_refcount_intent),
> > -			KM_NOFS);
> > +	ri = kmem_cache_alloc(xfs_refcount_intent_cache,
> > +			GFP_NOFS | __GFP_NOFAIL);
> >  	INIT_LIST_HEAD(&ri->ri_list);
> >  	ri->ri_type = type;
> >  	ri->ri_startblock = startblock;
> > @@ -1782,3 +1784,20 @@ xfs_refcount_has_record(
> >  
> >  	return xfs_btree_has_record(cur, &low, &high, exists);
> >  }
> > +
> > +int __init
> > +xfs_refcount_intent_init_cache(void)
> > +{
> > +	xfs_refcount_intent_cache = kmem_cache_create("xfs_refc_intent",
> > +			sizeof(struct xfs_refcount_intent),
> > +			0, 0, NULL);
> > +
> > +	return xfs_refcount_intent_cache != NULL ? 0 : -ENOMEM;
> > +}
> > +
> > +void
> > +xfs_refcount_intent_destroy_cache(void)
> > +{
> > +	kmem_cache_destroy(xfs_refcount_intent_cache);
> > +	xfs_refcount_intent_cache = NULL;
> > +}
> > diff --git a/fs/xfs/libxfs/xfs_refcount.h b/fs/xfs/libxfs/xfs_refcount.h
> > index 894045968bc6..9eb01edbd89d 100644
> > --- a/fs/xfs/libxfs/xfs_refcount.h
> > +++ b/fs/xfs/libxfs/xfs_refcount.h
> > @@ -83,4 +83,9 @@ extern void xfs_refcount_btrec_to_irec(const union xfs_btree_rec *rec,
> >  extern int xfs_refcount_insert(struct xfs_btree_cur *cur,
> >  		struct xfs_refcount_irec *irec, int *stat);
> >  
> > +extern struct kmem_cache	*xfs_refcount_intent_cache;
> > +
> > +int __init xfs_refcount_intent_init_cache(void);
> > +void xfs_refcount_intent_destroy_cache(void);
> > +
> >  #endif	/* __XFS_REFCOUNT_H__ */
> > diff --git a/fs/xfs/libxfs/xfs_rmap.c b/fs/xfs/libxfs/xfs_rmap.c
> > index f45929b1b94a..cd322174dbff 100644
> > --- a/fs/xfs/libxfs/xfs_rmap.c
> > +++ b/fs/xfs/libxfs/xfs_rmap.c
> > @@ -24,6 +24,8 @@
> >  #include "xfs_inode.h"
> >  #include "xfs_ag.h"
> >  
> > +struct kmem_cache	*xfs_rmap_intent_cache;
> > +
> >  /*
> >   * Lookup the first record less than or equal to [bno, len, owner, offset]
> >   * in the btree given by cur.
> > @@ -2485,7 +2487,7 @@ __xfs_rmap_add(
> >  			bmap->br_blockcount,
> >  			bmap->br_state);
> >  
> > -	ri = kmem_alloc(sizeof(struct xfs_rmap_intent), KM_NOFS);
> > +	ri = kmem_cache_alloc(xfs_rmap_intent_cache, GFP_NOFS | __GFP_NOFAIL);
> >  	INIT_LIST_HEAD(&ri->ri_list);
> >  	ri->ri_type = type;
> >  	ri->ri_owner = owner;
> > @@ -2779,3 +2781,20 @@ const struct xfs_owner_info XFS_RMAP_OINFO_REFC = {
> >  const struct xfs_owner_info XFS_RMAP_OINFO_COW = {
> >  	.oi_owner = XFS_RMAP_OWN_COW,
> >  };
> > +
> > +int __init
> > +xfs_rmap_intent_init_cache(void)
> > +{
> > +	xfs_rmap_intent_cache = kmem_cache_create("xfs_rmap_intent",
> > +			sizeof(struct xfs_rmap_intent),
> > +			0, 0, NULL);
> > +
> > +	return xfs_rmap_intent_cache != NULL ? 0 : -ENOMEM;
> > +}
> > +
> > +void
> > +xfs_rmap_intent_destroy_cache(void)
> > +{
> > +	kmem_cache_destroy(xfs_rmap_intent_cache);
> > +	xfs_rmap_intent_cache = NULL;
> > +}
> > diff --git a/fs/xfs/libxfs/xfs_rmap.h b/fs/xfs/libxfs/xfs_rmap.h
> > index 85dd98ac3f12..b718ebeda372 100644
> > --- a/fs/xfs/libxfs/xfs_rmap.h
> > +++ b/fs/xfs/libxfs/xfs_rmap.h
> > @@ -215,4 +215,9 @@ extern const struct xfs_owner_info XFS_RMAP_OINFO_INODES;
> >  extern const struct xfs_owner_info XFS_RMAP_OINFO_REFC;
> >  extern const struct xfs_owner_info XFS_RMAP_OINFO_COW;
> >  
> > +extern struct kmem_cache	*xfs_rmap_intent_cache;
> > +
> > +int __init xfs_rmap_intent_init_cache(void);
> > +void xfs_rmap_intent_destroy_cache(void);
> > +
> >  #endif	/* __XFS_RMAP_H__ */
> > diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
> > index 6049f0722181..e1f4d7d5a011 100644
> > --- a/fs/xfs/xfs_bmap_item.c
> > +++ b/fs/xfs/xfs_bmap_item.c
> > @@ -384,7 +384,7 @@ xfs_bmap_update_finish_item(
> >  		bmap->bi_bmap.br_blockcount = count;
> >  		return -EAGAIN;
> >  	}
> > -	kmem_free(bmap);
> > +	kmem_cache_free(xfs_bmap_intent_cache, bmap);
> >  	return error;
> >  }
> >  
> > @@ -404,7 +404,7 @@ xfs_bmap_update_cancel_item(
> >  	struct xfs_bmap_intent		*bmap;
> >  
> >  	bmap = container_of(item, struct xfs_bmap_intent, bi_list);
> > -	kmem_free(bmap);
> > +	kmem_cache_free(xfs_bmap_intent_cache, bmap);
> >  }
> >  
> >  const struct xfs_defer_op_type xfs_bmap_update_defer_type = {
> > diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
> > index f23e86e06bfb..d3da67772d57 100644
> > --- a/fs/xfs/xfs_refcount_item.c
> > +++ b/fs/xfs/xfs_refcount_item.c
> > @@ -384,7 +384,7 @@ xfs_refcount_update_finish_item(
> >  		refc->ri_blockcount = new_aglen;
> >  		return -EAGAIN;
> >  	}
> > -	kmem_free(refc);
> > +	kmem_cache_free(xfs_refcount_intent_cache, refc);
> >  	return error;
> >  }
> >  
> > @@ -404,7 +404,7 @@ xfs_refcount_update_cancel_item(
> >  	struct xfs_refcount_intent	*refc;
> >  
> >  	refc = container_of(item, struct xfs_refcount_intent, ri_list);
> > -	kmem_free(refc);
> > +	kmem_cache_free(xfs_refcount_intent_cache, refc);
> >  }
> >  
> >  const struct xfs_defer_op_type xfs_refcount_update_defer_type = {
> > diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
> > index b5cdeb10927e..c3966b4c58ef 100644
> > --- a/fs/xfs/xfs_rmap_item.c
> > +++ b/fs/xfs/xfs_rmap_item.c
> > @@ -427,7 +427,7 @@ xfs_rmap_update_finish_item(
> >  			rmap->ri_bmap.br_startoff, rmap->ri_bmap.br_startblock,
> >  			rmap->ri_bmap.br_blockcount, rmap->ri_bmap.br_state,
> >  			state);
> > -	kmem_free(rmap);
> > +	kmem_cache_free(xfs_rmap_intent_cache, rmap);
> >  	return error;
> >  }
> >  
> > @@ -447,7 +447,7 @@ xfs_rmap_update_cancel_item(
> >  	struct xfs_rmap_intent		*rmap;
> >  
> >  	rmap = container_of(item, struct xfs_rmap_intent, ri_list);
> > -	kmem_free(rmap);
> > +	kmem_cache_free(xfs_rmap_intent_cache, rmap);
> >  }
> >  
> >  const struct xfs_defer_op_type xfs_rmap_update_defer_type = {
> > diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> > index 0afa47378211..8909e08cbf77 100644
> > --- a/fs/xfs/xfs_super.c
> > +++ b/fs/xfs/xfs_super.c
> > @@ -38,6 +38,7 @@
> >  #include "xfs_pwork.h"
> >  #include "xfs_ag.h"
> >  #include "xfs_btree.h"
> > +#include "xfs_defer.h"
> >  
> >  #include <linux/magic.h>
> >  #include <linux/fs_context.h>
> > @@ -1972,11 +1973,15 @@ xfs_init_caches(void)
> >  	if (error)
> >  		goto out_destroy_bmap_free_item_cache;
> >  
> > +	error = xfs_defer_init_item_caches();
> > +	if (error)
> > +		goto out_destroy_btree_cur_cache;
> > +
> >  	xfs_da_state_cache = kmem_cache_create("xfs_da_state",
> >  					      sizeof(struct xfs_da_state),
> >  					      0, 0, NULL);
> >  	if (!xfs_da_state_cache)
> > -		goto out_destroy_btree_cur_cache;
> > +		goto out_destroy_defer_item_cache;
> >  
> >  	xfs_ifork_cache = kmem_cache_create("xfs_ifork",
> >  					   sizeof(struct xfs_ifork),
> > @@ -2106,6 +2111,8 @@ xfs_init_caches(void)
> >  	kmem_cache_destroy(xfs_ifork_cache);
> >   out_destroy_da_state_cache:
> >  	kmem_cache_destroy(xfs_da_state_cache);
> > + out_destroy_defer_item_cache:
> > +	xfs_defer_destroy_item_caches();
> >   out_destroy_btree_cur_cache:
> >  	xfs_btree_destroy_cur_caches();
> >   out_destroy_bmap_free_item_cache:
> > @@ -2140,6 +2147,7 @@ xfs_destroy_caches(void)
> >  	kmem_cache_destroy(xfs_ifork_cache);
> >  	kmem_cache_destroy(xfs_da_state_cache);
> >  	xfs_btree_destroy_cur_caches();
> > +	xfs_defer_destroy_item_caches();
> 
> Since caches are being freed in the reverse order of their creation,
> xfs_defer_destroy_item_caches() should be invoked before
> xfs_btree_destroy_cur_caches().

Fixed.  Thanks for the review!

--D

> >  	kmem_cache_destroy(xfs_bmap_free_item_cache);
> >  	kmem_cache_destroy(xfs_log_ticket_cache);
> >  }
> 
> 
> -- 
> chandan
