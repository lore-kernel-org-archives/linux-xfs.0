Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67540C433F5
	for <linux-xfs@archiver.kernel.org>; Mon, 27 Sep 2021 18:21:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4AA9460EE9
	for <linux-xfs@archiver.kernel.org>; Mon, 27 Sep 2021 18:21:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235986AbhI0SXB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 27 Sep 2021 14:23:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:51198 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235950AbhI0SXA (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 27 Sep 2021 14:23:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7C55460F11;
        Mon, 27 Sep 2021 18:21:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632766882;
        bh=SAJZTbRYrLU9pkvLqDD2tUAtpnaizkJH43kZl7K4nec=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=HgGwcwK68If0i287P2LUheHVF1y8HcpMuLhAF9qjH3mBs32OBUY5rNm1upZeeiz32
         uzeGRVazvYNOtUT2pmy+I6u05Tb5qOR+8za+b70pIYz24oHHb5L7dPLq5x6o7JwAuA
         8jDUtvxg07zwS/lJe+j9euj1XKf5/FAcbc3sNeo9bXmiLwbqzxBWB/jSDRWHrkfwoP
         uFh1vwUQBvr4cAoDFJSyJGtJ9uMbMbrKKLJBoOvBiVwJs4Ijkj4jbusghdv0oJs+RA
         ofzKSflThdjA7R3hv2ekqE6/s6jAX7Vw4E2ybmDzXz2lPWGfvMRKOCKEpLRJ6bMGTc
         BBXqkzd7lJicQ==
Date:   Mon, 27 Sep 2021 11:21:22 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     chandan.babu@oracle.com, chandanrlinux@gmail.com,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/4] xfs: use separate btree cursor slab for each btree
 type
Message-ID: <20210927182122.GT570615@magnolia>
References: <163244685787.2701674.13029851795897591378.stgit@magnolia>
 <163244687985.2701674.5510358661953545557.stgit@magnolia>
 <20210926004721.GD1756565@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210926004721.GD1756565@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Sep 26, 2021 at 10:47:21AM +1000, Dave Chinner wrote:
> On Thu, Sep 23, 2021 at 06:27:59PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Now that we have the infrastructure to track the max possible height of
> > each btree type, we can create a separate slab zone for cursors of each
> > type of btree.  For smaller indices like the free space btrees, this
> > means that we can pack more cursors into a slab page, improving slab
> > utilization.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> >  fs/xfs/libxfs/xfs_btree.c |   12 ++++++------
> >  fs/xfs/libxfs/xfs_btree.h |    9 +--------
> >  fs/xfs/xfs_super.c        |   33 ++++++++++++++++++++++++---------
> >  3 files changed, 31 insertions(+), 23 deletions(-)
> > 
> > 
> > diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
> > index 120280c998f8..3131de9ae631 100644
> > --- a/fs/xfs/libxfs/xfs_btree.c
> > +++ b/fs/xfs/libxfs/xfs_btree.c
> > @@ -26,7 +26,6 @@
> >  /*
> >   * Cursor allocation zone.
> >   */
> > -kmem_zone_t	*xfs_btree_cur_zone;
> >  struct xfs_btree_cur_zone xfs_btree_cur_zones[XFS_BTNUM_MAX] = {
> >  	[XFS_BTNUM_BNO]		= { .name = "xfs_alloc_btree_cur" },
> >  	[XFS_BTNUM_INO]		= { .name = "xfs_ialloc_btree_cur" },
> > @@ -364,6 +363,7 @@ xfs_btree_del_cursor(
> >  	struct xfs_btree_cur	*cur,		/* btree cursor */
> >  	int			error)		/* del because of error */
> >  {
> > +	struct xfs_btree_cur_zone *bczone = &xfs_btree_cur_zones[cur->bc_btnum];
> >  	int			i;		/* btree level */
> >  
> >  	/*
> > @@ -386,10 +386,10 @@ xfs_btree_del_cursor(
> >  		kmem_free(cur->bc_ops);
> >  	if (!(cur->bc_flags & XFS_BTREE_LONG_PTRS) && cur->bc_ag.pag)
> >  		xfs_perag_put(cur->bc_ag.pag);
> > -	if (cur->bc_maxlevels > XFS_BTREE_CUR_ZONE_MAXLEVELS)
> > +	if (cur->bc_maxlevels > bczone->maxlevels)
> >  		kmem_free(cur);
> >  	else
> > -		kmem_cache_free(xfs_btree_cur_zone, cur);
> > +		kmem_cache_free(bczone->zone, cur);
> >  }
> >  
> >  /*
> > @@ -5021,12 +5021,12 @@ xfs_btree_alloc_cursor(
> >  {
> >  	struct xfs_btree_cur	*cur;
> >  	unsigned int		maxlevels = xfs_btree_maxlevels(mp, btnum);
> > +	struct xfs_btree_cur_zone *bczone = &xfs_btree_cur_zones[btnum];
> >  
> > -	if (maxlevels > XFS_BTREE_CUR_ZONE_MAXLEVELS)
> > +	if (maxlevels > bczone->maxlevels)
> >  		cur = kmem_zalloc(xfs_btree_cur_sizeof(maxlevels), KM_NOFS);
> >  	else
> > -		cur = kmem_cache_zalloc(xfs_btree_cur_zone,
> > -				GFP_NOFS | __GFP_NOFAIL);
> > +		cur = kmem_cache_zalloc(bczone->zone, GFP_NOFS | __GFP_NOFAIL);
> 
> When will maxlevels ever be greater than bczone->maxlevels? Isn't
> the bczone->maxlevels case always supposed to be the tallest
> possible height for that btree?

It should never happen, provided that the maxlevels computation and
verification are all correct.  I thought it was important to leave the
heap allocation in here as a fallback, since the consequence for getting
the size calculations wrong is corrupt kernel memory.

--D

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
