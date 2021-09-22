Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5ED4DC433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 22 Sep 2021 17:38:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4B9E66120F
	for <linux-xfs@archiver.kernel.org>; Wed, 22 Sep 2021 17:38:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236717AbhIVRjx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 22 Sep 2021 13:39:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:55406 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236886AbhIVRjx (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 22 Sep 2021 13:39:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5E00F6120E;
        Wed, 22 Sep 2021 17:38:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632332302;
        bh=jsICq0tTyX5AKH1J523s5lyCEGaZXR1Gb+DquoBBmd4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=bCNOV+oF8x1s8jLD+hDKsjAvwfGNP1cEvywnVyhsotTLmSrZqMki+uS5FfHkcNrtk
         XPJbmMCwdAV5E9H5a8sDjYjZK6dcgHJE19mwrb5shDz2jk1YnuPWbVXmvuu/MLdjTW
         jAz/8eBtNCaincHKQrlM6ifWd+pIR5FhbZprKV3pjBMav4wEoNQKQiJReV3zB9MG4W
         LGEEByyBRonjBCaiYCHpiM2rfiPYjblFQD61YWf2QuLgHUGo+QOKKtlHdDI76B27Mo
         9UX+K1iUeUhzQJyZh2u1w7vnwkKHRboVHbLc90fHqOFdotlFmemo3mN0mLqCm6s87h
         ja3GeHsghMH0g==
Date:   Wed, 22 Sep 2021 10:38:21 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     chandan.babu@oracle.com, chandanrlinux@gmail.com,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH 11/14] xfs: dynamically allocate cursors based on
 maxlevels
Message-ID: <20210922173821.GH570615@magnolia>
References: <163192854958.416199.3396890438240296942.stgit@magnolia>
 <163192861018.416199.11733078081556457241.stgit@magnolia>
 <20210920230635.GM1756565@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210920230635.GM1756565@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Sep 21, 2021 at 09:06:35AM +1000, Dave Chinner wrote:
> On Fri, Sep 17, 2021 at 06:30:10PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Replace the statically-sized btree cursor zone with dynamically sized
> > allocations so that we can reduce the memory overhead for per-AG bt
> > cursors while handling very tall btrees for rt metadata.
> 
> Hmmmmm. We do a *lot* of btree cursor allocation and freeing under
> load. Keeping that in a single slab rather than using heap memory is
> a good idea for stuff like this for many reasons...
> 
> I mean, if we are creating a million inodes a second, a rouch
> back-of-the-envelope calculation says we are doing 3-4 million btree
> cursor instantiations a second. That's a lot of short term churn on
> the heap that we don't really need to subject it to. And even a few
> extra instructions in a path called millions of times a second adds
> up to a lot of extra runtime overhead.
> 
> So....
> 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> >  fs/xfs/libxfs/xfs_btree.c |   40 ++++++++++++++++++++++++++++++++--------
> >  fs/xfs/libxfs/xfs_btree.h |    2 --
> >  fs/xfs/xfs_super.c        |   11 +----------
> >  3 files changed, 33 insertions(+), 20 deletions(-)
> > 
> > 
> > diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
> > index 2486ba22c01d..f9516828a847 100644
> > --- a/fs/xfs/libxfs/xfs_btree.c
> > +++ b/fs/xfs/libxfs/xfs_btree.c
> > @@ -23,11 +23,6 @@
> >  #include "xfs_btree_staging.h"
> >  #include "xfs_ag.h"
> >  
> > -/*
> > - * Cursor allocation zone.
> > - */
> > -kmem_zone_t	*xfs_btree_cur_zone;
> > -
> >  /*
> >   * Btree magic numbers.
> >   */
> > @@ -379,7 +374,7 @@ xfs_btree_del_cursor(
> >  		kmem_free(cur->bc_ops);
> >  	if (!(cur->bc_flags & XFS_BTREE_LONG_PTRS) && cur->bc_ag.pag)
> >  		xfs_perag_put(cur->bc_ag.pag);
> > -	kmem_cache_free(xfs_btree_cur_zone, cur);
> > +	kmem_free(cur);
> >  }
> >  
> >  /*
> > @@ -4927,6 +4922,32 @@ xfs_btree_has_more_records(
> >  		return block->bb_u.s.bb_rightsib != cpu_to_be32(NULLAGBLOCK);
> >  }
> >  
> > +/* Compute the maximum allowed height for a given btree type. */
> > +static unsigned int
> > +xfs_btree_maxlevels(
> > +	struct xfs_mount	*mp,
> > +	xfs_btnum_t		btnum)
> > +{
> > +	switch (btnum) {
> > +	case XFS_BTNUM_BNO:
> > +	case XFS_BTNUM_CNT:
> > +		return mp->m_ag_maxlevels;
> > +	case XFS_BTNUM_BMAP:
> > +		return max(mp->m_bm_maxlevels[XFS_DATA_FORK],
> > +			   mp->m_bm_maxlevels[XFS_ATTR_FORK]);
> > +	case XFS_BTNUM_INO:
> > +	case XFS_BTNUM_FINO:
> > +		return M_IGEO(mp)->inobt_maxlevels;
> > +	case XFS_BTNUM_RMAP:
> > +		return mp->m_rmap_maxlevels;
> > +	case XFS_BTNUM_REFC:
> > +		return mp->m_refc_maxlevels;
> > +	default:
> > +		ASSERT(0);
> > +		return XFS_BTREE_MAXLEVELS;
> > +	}
> > +}
> > +
> >  /* Allocate a new btree cursor of the appropriate size. */
> >  struct xfs_btree_cur *
> >  xfs_btree_alloc_cursor(
> > @@ -4935,13 +4956,16 @@ xfs_btree_alloc_cursor(
> >  	xfs_btnum_t		btnum)
> >  {
> >  	struct xfs_btree_cur	*cur;
> > +	unsigned int		maxlevels = xfs_btree_maxlevels(mp, btnum);
> >  
> > -	cur = kmem_cache_zalloc(xfs_btree_cur_zone, GFP_NOFS | __GFP_NOFAIL);
> > +	ASSERT(maxlevels <= XFS_BTREE_MAXLEVELS);
> > +
> > +	cur = kmem_zalloc(xfs_btree_cur_sizeof(maxlevels), KM_NOFS);
> 
> Instead of multiple dynamic runtime calculations to determine the
> size to allocate from the heap, which then has to select a slab
> based on size, why don't we just pre-calculate the max size of
> the cursor at XFS module init and use that for the btree cursor slab
> size?

As part of developing the realtime rmapbt and reflink btrees, I computed
the maximum theoretical btree height for a maximally sized realtime
volume.  For a realtime volume with 2^52 blocks and a 1k block size, I
estimate that you'd need a 11-level rtrefcount btree cursor.  The rtrmap
btree cursor would have to be 28 levels high.  Using 4k blocks instead
of 1k blocks, it's not so bad -- 8 for rtrefcount and 17 for rtrmap.

I don't recall exactly what Chandan said the maximum bmbt height would
need to be to support really large data fork mapping structures, but
based on my worst case estimate of 2^54 single-block mappings and a 1k
blocksize, you'd need a 12-level bmbt cursor.  For 4k blocks, you'd need
only 8 levels.

The current XFS_BTREE_MAXLEVELS is 9, which just so happens to fit in
248 bytes.  I will rework this patch to make xfs_btree_cur_zone supply
256-byte cursors, and the btree code will continue using the zone if 256
bytes is enough space for the cursor.

If we decide later on that we need a zone for larger cursors, I think
the next logical size up (512 bytes) will fit 25 levels, but let's wait
to get there first.

--D

> The memory overhead of the cursor isn't an issue because we've been
> maximally sizing it since forever, and the whole point of a slab
> cache is to minimise allocation overhead of frequently allocated
> objects. It seems to me that we really want to retain these
> properties of the cursor allocator, not give them up just as we're
> in the process of making other modifications that will hit the path
> more frequently than it's ever been hit before...
> 
> I like all the dynamic sized guards that this series places in the
> cursor, but I don't think we want to change the way we allocate the
> cursors just to support that.
> 
> FWIW, an example of avoidable runtime calculation overhead of
> constants is xlog_calc_unit_res(). These values are actually
> constant for a given transaction reservation, but at 1.6 million
> transactions a second it shows up at #20 on the flat profile of
> functions using the most CPU:
> 
> 0.71%  [kernel]  [k] xlog_calc_unit_res
> 
> 0.71% of 32 CPUs for 1.6 million calculations a second of the same
> constants is a non-trivial amount of CPU time to spend doing
> unnecessary repeated calculations.
> 
> Even though the btree cursor constant calculations are simpler than
> the log res calculations, they are more frequent. Hence on general
> principles of efficiency, I don't think we want to be replacing high
> frequency, low overhead slab/zone based allocations with heap
> allocations that require repeated constant calculations and
> size->slab redirection....
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
