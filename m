Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39351C433EF
	for <linux-xfs@archiver.kernel.org>; Mon, 20 Sep 2021 23:08:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1C1E06044F
	for <linux-xfs@archiver.kernel.org>; Mon, 20 Sep 2021 23:08:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232844AbhITXKG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 20 Sep 2021 19:10:06 -0400
Received: from mail110.syd.optusnet.com.au ([211.29.132.97]:56750 "EHLO
        mail110.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229490AbhITXIG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 20 Sep 2021 19:08:06 -0400
Received: from dread.disaster.area (pa49-195-238-16.pa.nsw.optusnet.com.au [49.195.238.16])
        by mail110.syd.optusnet.com.au (Postfix) with ESMTPS id 37AF5108883;
        Tue, 21 Sep 2021 09:06:36 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1mSSMt-00EpCl-Mo; Tue, 21 Sep 2021 09:06:35 +1000
Date:   Tue, 21 Sep 2021 09:06:35 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     chandan.babu@oracle.com, chandanrlinux@gmail.com,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH 11/14] xfs: dynamically allocate cursors based on
 maxlevels
Message-ID: <20210920230635.GM1756565@dread.disaster.area>
References: <163192854958.416199.3396890438240296942.stgit@magnolia>
 <163192861018.416199.11733078081556457241.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <163192861018.416199.11733078081556457241.stgit@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=YKPhNiOx c=1 sm=1 tr=0
        a=DzKKRZjfViQTE5W6EVc0VA==:117 a=DzKKRZjfViQTE5W6EVc0VA==:17
        a=kj9zAlcOel0A:10 a=7QKq2e-ADPsA:10 a=VwQbUJbxAAAA:8 a=7-415B0cAAAA:8
        a=ey4o2al8hPZ2qFo5ZQIA:9 a=CjuIK1q_8ugA:10 a=AjGcO6oz07-iQ99wixmX:22
        a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Sep 17, 2021 at 06:30:10PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Replace the statically-sized btree cursor zone with dynamically sized
> allocations so that we can reduce the memory overhead for per-AG bt
> cursors while handling very tall btrees for rt metadata.

Hmmmmm. We do a *lot* of btree cursor allocation and freeing under
load. Keeping that in a single slab rather than using heap memory is
a good idea for stuff like this for many reasons...

I mean, if we are creating a million inodes a second, a rouch
back-of-the-envelope calculation says we are doing 3-4 million btree
cursor instantiations a second. That's a lot of short term churn on
the heap that we don't really need to subject it to. And even a few
extra instructions in a path called millions of times a second adds
up to a lot of extra runtime overhead.

So....

> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/libxfs/xfs_btree.c |   40 ++++++++++++++++++++++++++++++++--------
>  fs/xfs/libxfs/xfs_btree.h |    2 --
>  fs/xfs/xfs_super.c        |   11 +----------
>  3 files changed, 33 insertions(+), 20 deletions(-)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
> index 2486ba22c01d..f9516828a847 100644
> --- a/fs/xfs/libxfs/xfs_btree.c
> +++ b/fs/xfs/libxfs/xfs_btree.c
> @@ -23,11 +23,6 @@
>  #include "xfs_btree_staging.h"
>  #include "xfs_ag.h"
>  
> -/*
> - * Cursor allocation zone.
> - */
> -kmem_zone_t	*xfs_btree_cur_zone;
> -
>  /*
>   * Btree magic numbers.
>   */
> @@ -379,7 +374,7 @@ xfs_btree_del_cursor(
>  		kmem_free(cur->bc_ops);
>  	if (!(cur->bc_flags & XFS_BTREE_LONG_PTRS) && cur->bc_ag.pag)
>  		xfs_perag_put(cur->bc_ag.pag);
> -	kmem_cache_free(xfs_btree_cur_zone, cur);
> +	kmem_free(cur);
>  }
>  
>  /*
> @@ -4927,6 +4922,32 @@ xfs_btree_has_more_records(
>  		return block->bb_u.s.bb_rightsib != cpu_to_be32(NULLAGBLOCK);
>  }
>  
> +/* Compute the maximum allowed height for a given btree type. */
> +static unsigned int
> +xfs_btree_maxlevels(
> +	struct xfs_mount	*mp,
> +	xfs_btnum_t		btnum)
> +{
> +	switch (btnum) {
> +	case XFS_BTNUM_BNO:
> +	case XFS_BTNUM_CNT:
> +		return mp->m_ag_maxlevels;
> +	case XFS_BTNUM_BMAP:
> +		return max(mp->m_bm_maxlevels[XFS_DATA_FORK],
> +			   mp->m_bm_maxlevels[XFS_ATTR_FORK]);
> +	case XFS_BTNUM_INO:
> +	case XFS_BTNUM_FINO:
> +		return M_IGEO(mp)->inobt_maxlevels;
> +	case XFS_BTNUM_RMAP:
> +		return mp->m_rmap_maxlevels;
> +	case XFS_BTNUM_REFC:
> +		return mp->m_refc_maxlevels;
> +	default:
> +		ASSERT(0);
> +		return XFS_BTREE_MAXLEVELS;
> +	}
> +}
> +
>  /* Allocate a new btree cursor of the appropriate size. */
>  struct xfs_btree_cur *
>  xfs_btree_alloc_cursor(
> @@ -4935,13 +4956,16 @@ xfs_btree_alloc_cursor(
>  	xfs_btnum_t		btnum)
>  {
>  	struct xfs_btree_cur	*cur;
> +	unsigned int		maxlevels = xfs_btree_maxlevels(mp, btnum);
>  
> -	cur = kmem_cache_zalloc(xfs_btree_cur_zone, GFP_NOFS | __GFP_NOFAIL);
> +	ASSERT(maxlevels <= XFS_BTREE_MAXLEVELS);
> +
> +	cur = kmem_zalloc(xfs_btree_cur_sizeof(maxlevels), KM_NOFS);

Instead of multiple dynamic runtime calculations to determine the
size to allocate from the heap, which then has to select a slab
based on size, why don't we just pre-calculate the max size of
the cursor at XFS module init and use that for the btree cursor slab
size?

The memory overhead of the cursor isn't an issue because we've been
maximally sizing it since forever, and the whole point of a slab
cache is to minimise allocation overhead of frequently allocated
objects. It seems to me that we really want to retain these
properties of the cursor allocator, not give them up just as we're
in the process of making other modifications that will hit the path
more frequently than it's ever been hit before...

I like all the dynamic sized guards that this series places in the
cursor, but I don't think we want to change the way we allocate the
cursors just to support that.

FWIW, an example of avoidable runtime calculation overhead of
constants is xlog_calc_unit_res(). These values are actually
constant for a given transaction reservation, but at 1.6 million
transactions a second it shows up at #20 on the flat profile of
functions using the most CPU:

0.71%  [kernel]  [k] xlog_calc_unit_res

0.71% of 32 CPUs for 1.6 million calculations a second of the same
constants is a non-trivial amount of CPU time to spend doing
unnecessary repeated calculations.

Even though the btree cursor constant calculations are simpler than
the log res calculations, they are more frequent. Hence on general
principles of efficiency, I don't think we want to be replacing high
frequency, low overhead slab/zone based allocations with heap
allocations that require repeated constant calculations and
size->slab redirection....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
