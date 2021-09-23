Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 820B0C433F5
	for <linux-xfs@archiver.kernel.org>; Thu, 23 Sep 2021 01:58:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 65B0361050
	for <linux-xfs@archiver.kernel.org>; Thu, 23 Sep 2021 01:58:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238876AbhIWCAU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 22 Sep 2021 22:00:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:52394 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238177AbhIWCAT (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 22 Sep 2021 22:00:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E3E5660462;
        Thu, 23 Sep 2021 01:58:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632362329;
        bh=sQmGaoymMfuFPEYThyM/YxJYpI1bM1QBVB6XdHyewFs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=t/IcntYR27bx/h+frQmQoRZs4ZGD0VHBYQdBe760czYK3bUEIBpzwVt2RsG/ZYv4W
         QeulMoxpttegaSfcRp26XphUMYSiYqMhhk/mBLuihZwzxqacZ5MI7JctL4jWp+oPwa
         BxHmJbq6z915ychZiDoIHLK3kinLsypBjVExQlESt7HV3V984YP2N4FSucVqbEtSwf
         M+ExRn5PpuyJKcH8QyTqsfU6d0g22tUWBUAwXITpYVB3ht/UMpF3nPFTdPY2agJCG/
         ECtRMKW9esTrtuoyTuWHkhB3Zo+FeZMWkbXpFhpmOP7/SKNp+LI+XYli0CdtbqzfNJ
         7oXDYsIDviRLg==
Date:   Wed, 22 Sep 2021 18:58:48 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     chandan.babu@oracle.com, chandanrlinux@gmail.com,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH 11/14] xfs: dynamically allocate cursors based on
 maxlevels
Message-ID: <20210923015848.GR570615@magnolia>
References: <163192854958.416199.3396890438240296942.stgit@magnolia>
 <163192861018.416199.11733078081556457241.stgit@magnolia>
 <20210920230635.GM1756565@dread.disaster.area>
 <20210922173821.GH570615@magnolia>
 <20210922231015.GU1756565@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210922231015.GU1756565@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Sep 23, 2021 at 09:10:15AM +1000, Dave Chinner wrote:
> On Wed, Sep 22, 2021 at 10:38:21AM -0700, Darrick J. Wong wrote:
> > On Tue, Sep 21, 2021 at 09:06:35AM +1000, Dave Chinner wrote:
> > > On Fri, Sep 17, 2021 at 06:30:10PM -0700, Darrick J. Wong wrote:
> > > >  /* Allocate a new btree cursor of the appropriate size. */
> > > >  struct xfs_btree_cur *
> > > >  xfs_btree_alloc_cursor(
> > > > @@ -4935,13 +4956,16 @@ xfs_btree_alloc_cursor(
> > > >  	xfs_btnum_t		btnum)
> > > >  {
> > > >  	struct xfs_btree_cur	*cur;
> > > > +	unsigned int		maxlevels = xfs_btree_maxlevels(mp, btnum);
> > > >  
> > > > -	cur = kmem_cache_zalloc(xfs_btree_cur_zone, GFP_NOFS | __GFP_NOFAIL);
> > > > +	ASSERT(maxlevels <= XFS_BTREE_MAXLEVELS);
> > > > +
> > > > +	cur = kmem_zalloc(xfs_btree_cur_sizeof(maxlevels), KM_NOFS);
> > > 
> > > Instead of multiple dynamic runtime calculations to determine the
> > > size to allocate from the heap, which then has to select a slab
> > > based on size, why don't we just pre-calculate the max size of
> > > the cursor at XFS module init and use that for the btree cursor slab
> > > size?
> > 
> > As part of developing the realtime rmapbt and reflink btrees, I computed
> > the maximum theoretical btree height for a maximally sized realtime
> > volume.  For a realtime volume with 2^52 blocks and a 1k block size, I
> > estimate that you'd need a 11-level rtrefcount btree cursor.  The rtrmap
> > btree cursor would have to be 28 levels high.  Using 4k blocks instead
> > of 1k blocks, it's not so bad -- 8 for rtrefcount and 17 for rtrmap.
> 
> I'm going to state straight out that 1k block sizes for the rt
> device are insane. That's not what that device was intended to
> support, ever. It was intended for workloads with -large-,
> consistent extent sizes in large contiguous runs, not tiny, small
> random allocations of individual blocks.
> 
> So if we are going to be talking about the overhead RT block
> management for new functionality, we need to start by putting
> reasonable limits on the block sizes that the RT device will support
> such features for. Because while a btree might scale to 2^52 x 1kB
> blocks, the RT allocation bitmap sure as hell doesn't. It probably
> doesn't even scale at all well above a few million blocks for
> general usage.
> 
> Hence I don't think it's worth optimising for these cases when we
> think about maximum btree sizes for the cursors - those btrees can
> provide their own cursor slab to allocate from if it comes to it.
> 
> Really, if we want to scale RT devices to insane sizes, we need to
> move to an AG based structure for it which breaks up the bitmaps and
> summary files into regions to keep the overhead and max sizes under
> control.

Heh.  That just sounds like more work that I get to do...

> > I don't recall exactly what Chandan said the maximum bmbt height would
> > need to be to support really large data fork mapping structures, but
> > based on my worst case estimate of 2^54 single-block mappings and a 1k
> > blocksize, you'd need a 12-level bmbt cursor.  For 4k blocks, you'd need
> > only 8 levels.
> 
> Yup, it's not significantly different to what we have now.
> 
> > The current XFS_BTREE_MAXLEVELS is 9, which just so happens to fit in
> > 248 bytes.  I will rework this patch to make xfs_btree_cur_zone supply
> > 256-byte cursors, and the btree code will continue using the zone if 256
> > bytes is enough space for the cursor.
> >
> > If we decide later on that we need a zone for larger cursors, I think
> > the next logical size up (512 bytes) will fit 25 levels, but let's wait
> > to get there first.
> 
> I suspect you may misunderstand how SLUB caches work. SLUB packs
> non-power of two sized slabs tightly to natural alignment (8 bytes).
> e.g.:
> 
> $ sudo grep xfs_btree_cur /proc/slabinfo
> xfs_btree_cur       1152   1152    224   36    2 : tunables    0 0    0 : slabdata     32     32      0
> 
> SLUB is using an order-1 base page (2 pages), with 36 cursor objects
> in it. 36 * 224 = 8064 bytes, which means it is packed as tightly as
> possible. It is not using 256 byte objects for these btree cursors.

Ahah, I didn't realize that.  Yes, taking that into mind, the 256-byte
thing is unnecessary.

> If we allocate these 224 byte objects _from the heap_, however, then
> the 256 byte heap slab will be selected, which means the object is
> then padded to 256 bytes -by the heap-. The SLUB allocator does not
> pad the objects, it's the heap granularity that adds padding to the
> objects.
> 
> This implicit padding of heap objects is another reason we don't
> want to use the heap for anything we frequently allocate or allocate
> in large amounts. It can result in substantial amounts of wasted
> memory.
> 
> IOWs, we don't actually care about object size granularity for slab
> cache allocated objects.
> 
> However, if we really want to look at memory usage of struct
> xfs_btree_cur, pahole tells me:
> 
> 	/* size: 224, cachelines: 4, members: 13 */
> 
> Where are the extra 24 bytes coming from on your kernel?

Not sure.  Can you post your pahole output?

> It also tells me that a bunch of space that can be taken out of it:
> 
> - 4 byte hole that bc_btnum can be moved into.
> - bc_blocklog is set but not used, so it can go, too.
> - bc_ag.refc.nr_ops doesn't need to be an unsigned long

I'll look into those tomorrow.

> - optimising bc_ra state. That just tracks if
>   the current cursor has already done sibling readahead - it's two
>   bits per level , held in a int8_t per level. Could be a pair of
>   int16_t bitmasks if maxlevel is 12, that would save another 8
>   bytes. If maxlevel == 28 as per the rt case above, then a pair of
>   int32_t bitmasks saves 4 bytes for 12 levels and 20 bytes bytes
>   for 28 levels...

I don't think that optimizing bc_ra buys us much.  struct
xfs_btree_level will be 16 bytes anyway due to alignment of the xfs_buf
pointer, so we might as well use the extra bytes.

> Hence if we're concerned about space usage of the btree cursor,
> these seem like low hanging fruit.
> 
> Maybe the best thing here, as Christoph mentioned, is to have a set
> of btree cursor zones for the different size limits. All the per-ag
> btrees have the same (small) size limits, while the BMBT is bigger.
> And the RT btrees when they arrive will be bigger again. Given that
> we already allocate the cursors based on the type of btree they are
> going to walk, this seems like it would be pretty easy to do,
> something like the patch below, perhaps?

Um... the bmbt cache looks like it has the same size as the rest?

It's not so hard to make there be separate zones though.

--D

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 
> xfs: per-btree cursor slab caches
> ---
>  fs/xfs/libxfs/xfs_alloc_btree.c    |  3 ++-
>  fs/xfs/libxfs/xfs_bmap_btree.c     |  4 +++-
>  fs/xfs/libxfs/xfs_btree.c          | 28 +++++++++++++++++++++++-----
>  fs/xfs/libxfs/xfs_btree.h          |  6 +++++-
>  fs/xfs/libxfs/xfs_ialloc_btree.c   |  4 +++-
>  fs/xfs/libxfs/xfs_refcount_btree.c |  4 +++-
>  fs/xfs/libxfs/xfs_rmap_btree.c     |  4 +++-
>  fs/xfs/xfs_super.c                 | 30 ++++++++++++++++++++++++++----
>  8 files changed, 68 insertions(+), 15 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_alloc_btree.c b/fs/xfs/libxfs/xfs_alloc_btree.c
> index 6746fd735550..53ead7b98238 100644
> --- a/fs/xfs/libxfs/xfs_alloc_btree.c
> +++ b/fs/xfs/libxfs/xfs_alloc_btree.c
> @@ -20,6 +20,7 @@
>  #include "xfs_trans.h"
>  #include "xfs_ag.h"
>  
> +struct kmem_cache	*xfs_allocbt_cur_zone;
>  
>  STATIC struct xfs_btree_cur *
>  xfs_allocbt_dup_cursor(
> @@ -477,7 +478,7 @@ xfs_allocbt_init_common(
>  
>  	ASSERT(btnum == XFS_BTNUM_BNO || btnum == XFS_BTNUM_CNT);
>  
> -	cur = kmem_cache_zalloc(xfs_btree_cur_zone, GFP_NOFS | __GFP_NOFAIL);
> +	cur = kmem_cache_zalloc(xfs_allocbt_cur_zone, GFP_NOFS | __GFP_NOFAIL);
>  
>  	cur->bc_tp = tp;
>  	cur->bc_mp = mp;
> diff --git a/fs/xfs/libxfs/xfs_bmap_btree.c b/fs/xfs/libxfs/xfs_bmap_btree.c
> index 72444b8b38a6..e3f7107ce2e2 100644
> --- a/fs/xfs/libxfs/xfs_bmap_btree.c
> +++ b/fs/xfs/libxfs/xfs_bmap_btree.c
> @@ -22,6 +22,8 @@
>  #include "xfs_trace.h"
>  #include "xfs_rmap.h"
>  
> +struct kmem_cache	*xfs_bmbt_cur_zone;
> +
>  /*
>   * Convert on-disk form of btree root to in-memory form.
>   */
> @@ -552,7 +554,7 @@ xfs_bmbt_init_cursor(
>  	struct xfs_btree_cur	*cur;
>  	ASSERT(whichfork != XFS_COW_FORK);
>  
> -	cur = kmem_cache_zalloc(xfs_btree_cur_zone, GFP_NOFS | __GFP_NOFAIL);
> +	cur = kmem_cache_zalloc(xfs_bmbt_cur_zone, GFP_NOFS | __GFP_NOFAIL);
>  
>  	cur->bc_tp = tp;
>  	cur->bc_mp = mp;
> diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
> index 298395481713..7ef19f365e33 100644
> --- a/fs/xfs/libxfs/xfs_btree.c
> +++ b/fs/xfs/libxfs/xfs_btree.c
> @@ -23,10 +23,6 @@
>  #include "xfs_btree_staging.h"
>  #include "xfs_ag.h"
>  
> -/*
> - * Cursor allocation zone.
> - */
> -kmem_zone_t	*xfs_btree_cur_zone;
>  
>  /*
>   * Btree magic numbers.
> @@ -379,7 +375,29 @@ xfs_btree_del_cursor(
>  		kmem_free(cur->bc_ops);
>  	if (!(cur->bc_flags & XFS_BTREE_LONG_PTRS) && cur->bc_ag.pag)
>  		xfs_perag_put(cur->bc_ag.pag);
> -	kmem_cache_free(xfs_btree_cur_zone, cur);
> +
> +	switch (cur->bc_btnum) {
> +	case XFS_BTNUM_BMAP:
> +		kmem_cache_free(xfs_bmbt_cur_zone, cur);
> +		break;
> +	case XFS_BTNUM_BNO:
> +	case XFS_BTNUM_CNT:
> +		kmem_cache_free(xfs_allocbt_cur_zone, cur);
> +		break;
> +	case XFS_BTNUM_INOBT:
> +	case XFS_BTNUM_FINOBT:
> +		kmem_cache_free(xfs_inobt_cur_zone, cur);
> +		break;
> +	case XFS_BTNUM_RMAP:
> +		kmem_cache_free(xfs_rmapbt_cur_zone, cur);
> +		break;
> +	case XFS_BTNUM_REFCNT:
> +		kmem_cache_free(xfs_refcntbt_cur_zone, cur);
> +		break;
> +	default:
> +		ASSERT(0);
> +		break;
> +	}
>  }
>  
>  /*
> diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
> index 4eaf8517f850..acdf087c853a 100644
> --- a/fs/xfs/libxfs/xfs_btree.h
> +++ b/fs/xfs/libxfs/xfs_btree.h
> @@ -13,7 +13,11 @@ struct xfs_trans;
>  struct xfs_ifork;
>  struct xfs_perag;
>  
> -extern kmem_zone_t	*xfs_btree_cur_zone;
> +extern struct kmem_cache	*xfs_allocbt_cur_zone;
> +extern struct kmem_cache	*xfs_inobt_cur_zone;
> +extern struct kmem_cache	*xfs_bmbt_cur_zone;
> +extern struct kmem_cache	*xfs_rmapbt_cur_zone;
> +extern struct kmem_cache	*xfs_refcntbt_cur_zone;
>  
>  /*
>   * Generic key, ptr and record wrapper structures.
> diff --git a/fs/xfs/libxfs/xfs_ialloc_btree.c b/fs/xfs/libxfs/xfs_ialloc_btree.c
> index 27190840c5d8..5258696f153e 100644
> --- a/fs/xfs/libxfs/xfs_ialloc_btree.c
> +++ b/fs/xfs/libxfs/xfs_ialloc_btree.c
> @@ -22,6 +22,8 @@
>  #include "xfs_rmap.h"
>  #include "xfs_ag.h"
>  
> +struct kmem_cache	*xfs_inobt_cur_zone;
> +
>  STATIC int
>  xfs_inobt_get_minrecs(
>  	struct xfs_btree_cur	*cur,
> @@ -432,7 +434,7 @@ xfs_inobt_init_common(
>  {
>  	struct xfs_btree_cur	*cur;
>  
> -	cur = kmem_cache_zalloc(xfs_btree_cur_zone, GFP_NOFS | __GFP_NOFAIL);
> +	cur = kmem_cache_zalloc(xfs_inobt_cur_zone, GFP_NOFS | __GFP_NOFAIL);
>  	cur->bc_tp = tp;
>  	cur->bc_mp = mp;
>  	cur->bc_btnum = btnum;
> diff --git a/fs/xfs/libxfs/xfs_refcount_btree.c b/fs/xfs/libxfs/xfs_refcount_btree.c
> index 1ef9b99962ab..20667f173040 100644
> --- a/fs/xfs/libxfs/xfs_refcount_btree.c
> +++ b/fs/xfs/libxfs/xfs_refcount_btree.c
> @@ -21,6 +21,8 @@
>  #include "xfs_rmap.h"
>  #include "xfs_ag.h"
>  
> +struct kmem_cache	*xfs_refcntbt_cur_zone;
> +
>  static struct xfs_btree_cur *
>  xfs_refcountbt_dup_cursor(
>  	struct xfs_btree_cur	*cur)
> @@ -322,7 +324,7 @@ xfs_refcountbt_init_common(
>  
>  	ASSERT(pag->pag_agno < mp->m_sb.sb_agcount);
>  
> -	cur = kmem_cache_zalloc(xfs_btree_cur_zone, GFP_NOFS | __GFP_NOFAIL);
> +	cur = kmem_cache_zalloc(xfs_refcntbt_cur_zone, GFP_NOFS | __GFP_NOFAIL);
>  	cur->bc_tp = tp;
>  	cur->bc_mp = mp;
>  	cur->bc_btnum = XFS_BTNUM_REFC;
> diff --git a/fs/xfs/libxfs/xfs_rmap_btree.c b/fs/xfs/libxfs/xfs_rmap_btree.c
> index b7dbbfb3aeed..cb6e64f6d8f9 100644
> --- a/fs/xfs/libxfs/xfs_rmap_btree.c
> +++ b/fs/xfs/libxfs/xfs_rmap_btree.c
> @@ -22,6 +22,8 @@
>  #include "xfs_ag.h"
>  #include "xfs_ag_resv.h"
>  
> +struct kmem_cache	*xfs_rmapbt_cur_zone;
> +
>  /*
>   * Reverse map btree.
>   *
> @@ -451,7 +453,7 @@ xfs_rmapbt_init_common(
>  {
>  	struct xfs_btree_cur	*cur;
>  
> -	cur = kmem_cache_zalloc(xfs_btree_cur_zone, GFP_NOFS | __GFP_NOFAIL);
> +	cur = kmem_cache_zalloc(xfs_rmapbt_cur_zone, GFP_NOFS | __GFP_NOFAIL);
>  	cur->bc_tp = tp;
>  	cur->bc_mp = mp;
>  	/* Overlapping btree; 2 keys per pointer. */
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index 90716b9d6e5f..3f97dc1b41e0 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -1965,10 +1965,24 @@ xfs_init_zones(void)
>  	if (!xfs_bmap_free_item_zone)
>  		goto out_destroy_log_ticket_zone;
>  
> -	xfs_btree_cur_zone = kmem_cache_create("xfs_btree_cur",
> +	xfs_allocbt_cur_zone = kmem_cache_create("xfs_allocbt_cur",
>  					       sizeof(struct xfs_btree_cur),
>  					       0, 0, NULL);
> -	if (!xfs_btree_cur_zone)
> +	xfs_inobt_cur_zone = kmem_cache_create("xfs_inobt_cur",
> +					       sizeof(struct xfs_btree_cur),
> +					       0, 0, NULL);
> +	xfs_bmbt_cur_zone = kmem_cache_create("xfs_bmbt_cur",
> +					       sizeof(struct xfs_btree_cur),
> +					       0, 0, NULL);
> +	xfs_rmapbt_cur_zone = kmem_cache_create("xfs_rmapbt_cur",
> +					       sizeof(struct xfs_btree_cur),
> +					       0, 0, NULL);
> +	xfs_refcntbt_cur_zone = kmem_cache_create("xfs_refcnt_cur",
> +					       sizeof(struct xfs_btree_cur),
> +					       0, 0, NULL);
> +	if (!xfs_allocbt_cur_zone || !xfs_inobt_cur_zone ||
> +	    !xfs_bmbt_cur_zone || !xfs_rmapbt_cur_zone ||
> +	    !xfs_refcntbt_cur_zone)
>  		goto out_destroy_bmap_free_item_zone;
>  
>  	xfs_da_state_zone = kmem_cache_create("xfs_da_state",
> @@ -2106,7 +2120,11 @@ xfs_init_zones(void)
>   out_destroy_da_state_zone:
>  	kmem_cache_destroy(xfs_da_state_zone);
>   out_destroy_btree_cur_zone:
> -	kmem_cache_destroy(xfs_btree_cur_zone);
> +	kmem_cache_destroy(xfs_allocbt_cur_zone);
> +	kmem_cache_destroy(xfs_inobt_cur_zone);
> +	kmem_cache_destroy(xfs_bmbt_cur_zone);
> +	kmem_cache_destroy(xfs_rmapbt_cur_zone);
> +	kmem_cache_destroy(xfs_refcntbt_cur_zone);
>   out_destroy_bmap_free_item_zone:
>  	kmem_cache_destroy(xfs_bmap_free_item_zone);
>   out_destroy_log_ticket_zone:
> @@ -2138,7 +2156,11 @@ xfs_destroy_zones(void)
>  	kmem_cache_destroy(xfs_trans_zone);
>  	kmem_cache_destroy(xfs_ifork_zone);
>  	kmem_cache_destroy(xfs_da_state_zone);
> -	kmem_cache_destroy(xfs_btree_cur_zone);
> +	kmem_cache_destroy(xfs_allocbt_cur_zone);
> +	kmem_cache_destroy(xfs_inobt_cur_zone);
> +	kmem_cache_destroy(xfs_bmbt_cur_zone);
> +	kmem_cache_destroy(xfs_rmapbt_cur_zone);
> +	kmem_cache_destroy(xfs_refcntbt_cur_zone);
>  	kmem_cache_destroy(xfs_bmap_free_item_zone);
>  	kmem_cache_destroy(xfs_log_ticket_zone);
>  }
