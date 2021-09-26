Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27554C433F5
	for <linux-xfs@archiver.kernel.org>; Sun, 26 Sep 2021 00:47:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EAFFB6109D
	for <linux-xfs@archiver.kernel.org>; Sun, 26 Sep 2021 00:47:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230214AbhIZAs7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 25 Sep 2021 20:48:59 -0400
Received: from mail108.syd.optusnet.com.au ([211.29.132.59]:59293 "EHLO
        mail108.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230211AbhIZAs7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 25 Sep 2021 20:48:59 -0400
Received: from dread.disaster.area (pa49-195-238-16.pa.nsw.optusnet.com.au [49.195.238.16])
        by mail108.syd.optusnet.com.au (Postfix) with ESMTPS id 5626D1BCF20;
        Sun, 26 Sep 2021 10:47:22 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1mUIK9-00GkTI-Oo; Sun, 26 Sep 2021 10:47:21 +1000
Date:   Sun, 26 Sep 2021 10:47:21 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     chandan.babu@oracle.com, chandanrlinux@gmail.com,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/4] xfs: use separate btree cursor slab for each btree
 type
Message-ID: <20210926004721.GD1756565@dread.disaster.area>
References: <163244685787.2701674.13029851795897591378.stgit@magnolia>
 <163244687985.2701674.5510358661953545557.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <163244687985.2701674.5510358661953545557.stgit@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=F8MpiZpN c=1 sm=1 tr=0
        a=DzKKRZjfViQTE5W6EVc0VA==:117 a=DzKKRZjfViQTE5W6EVc0VA==:17
        a=kj9zAlcOel0A:10 a=7QKq2e-ADPsA:10 a=VwQbUJbxAAAA:8 a=7-415B0cAAAA:8
        a=7o786gbDF7qkn78YGUkA:9 a=CjuIK1q_8ugA:10 a=AjGcO6oz07-iQ99wixmX:22
        a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Sep 23, 2021 at 06:27:59PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Now that we have the infrastructure to track the max possible height of
> each btree type, we can create a separate slab zone for cursors of each
> type of btree.  For smaller indices like the free space btrees, this
> means that we can pack more cursors into a slab page, improving slab
> utilization.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/libxfs/xfs_btree.c |   12 ++++++------
>  fs/xfs/libxfs/xfs_btree.h |    9 +--------
>  fs/xfs/xfs_super.c        |   33 ++++++++++++++++++++++++---------
>  3 files changed, 31 insertions(+), 23 deletions(-)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
> index 120280c998f8..3131de9ae631 100644
> --- a/fs/xfs/libxfs/xfs_btree.c
> +++ b/fs/xfs/libxfs/xfs_btree.c
> @@ -26,7 +26,6 @@
>  /*
>   * Cursor allocation zone.
>   */
> -kmem_zone_t	*xfs_btree_cur_zone;
>  struct xfs_btree_cur_zone xfs_btree_cur_zones[XFS_BTNUM_MAX] = {
>  	[XFS_BTNUM_BNO]		= { .name = "xfs_alloc_btree_cur" },
>  	[XFS_BTNUM_INO]		= { .name = "xfs_ialloc_btree_cur" },
> @@ -364,6 +363,7 @@ xfs_btree_del_cursor(
>  	struct xfs_btree_cur	*cur,		/* btree cursor */
>  	int			error)		/* del because of error */
>  {
> +	struct xfs_btree_cur_zone *bczone = &xfs_btree_cur_zones[cur->bc_btnum];
>  	int			i;		/* btree level */
>  
>  	/*
> @@ -386,10 +386,10 @@ xfs_btree_del_cursor(
>  		kmem_free(cur->bc_ops);
>  	if (!(cur->bc_flags & XFS_BTREE_LONG_PTRS) && cur->bc_ag.pag)
>  		xfs_perag_put(cur->bc_ag.pag);
> -	if (cur->bc_maxlevels > XFS_BTREE_CUR_ZONE_MAXLEVELS)
> +	if (cur->bc_maxlevels > bczone->maxlevels)
>  		kmem_free(cur);
>  	else
> -		kmem_cache_free(xfs_btree_cur_zone, cur);
> +		kmem_cache_free(bczone->zone, cur);
>  }
>  
>  /*
> @@ -5021,12 +5021,12 @@ xfs_btree_alloc_cursor(
>  {
>  	struct xfs_btree_cur	*cur;
>  	unsigned int		maxlevels = xfs_btree_maxlevels(mp, btnum);
> +	struct xfs_btree_cur_zone *bczone = &xfs_btree_cur_zones[btnum];
>  
> -	if (maxlevels > XFS_BTREE_CUR_ZONE_MAXLEVELS)
> +	if (maxlevels > bczone->maxlevels)
>  		cur = kmem_zalloc(xfs_btree_cur_sizeof(maxlevels), KM_NOFS);
>  	else
> -		cur = kmem_cache_zalloc(xfs_btree_cur_zone,
> -				GFP_NOFS | __GFP_NOFAIL);
> +		cur = kmem_cache_zalloc(bczone->zone, GFP_NOFS | __GFP_NOFAIL);

When will maxlevels ever be greater than bczone->maxlevels? Isn't
the bczone->maxlevels case always supposed to be the tallest
possible height for that btree?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
