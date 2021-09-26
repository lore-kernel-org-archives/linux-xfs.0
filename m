Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99FD2C433EF
	for <linux-xfs@archiver.kernel.org>; Sun, 26 Sep 2021 00:43:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 68201610A3
	for <linux-xfs@archiver.kernel.org>; Sun, 26 Sep 2021 00:43:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230213AbhIZApV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 25 Sep 2021 20:45:21 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:42839 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230211AbhIZApV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 25 Sep 2021 20:45:21 -0400
Received: from dread.disaster.area (pa49-195-238-16.pa.nsw.optusnet.com.au [49.195.238.16])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 457E78838BC;
        Sun, 26 Sep 2021 10:43:44 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1mUIGd-00GkQT-A2; Sun, 26 Sep 2021 10:43:43 +1000
Date:   Sun, 26 Sep 2021 10:43:43 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     chandan.babu@oracle.com, chandanrlinux@gmail.com,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/4] xfs: check absolute maximum nlevels for each btree
 type
Message-ID: <20210926004343.GC1756565@dread.disaster.area>
References: <163244685787.2701674.13029851795897591378.stgit@magnolia>
 <163244687436.2701674.5377184817013946444.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <163244687436.2701674.5377184817013946444.stgit@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=F8MpiZpN c=1 sm=1 tr=0
        a=DzKKRZjfViQTE5W6EVc0VA==:117 a=DzKKRZjfViQTE5W6EVc0VA==:17
        a=kj9zAlcOel0A:10 a=7QKq2e-ADPsA:10 a=VwQbUJbxAAAA:8 a=7-415B0cAAAA:8
        a=JAHgLN7nDS3Y1voxMgkA:9 a=CjuIK1q_8ugA:10 a=AjGcO6oz07-iQ99wixmX:22
        a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Sep 23, 2021 at 06:27:54PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Add code for all five btree types so that we can compute the absolute
> maximum possible btree height for each btree type, and then check that
> none of them exceed XFS_BTREE_CUR_ZONE_MAXLEVELS.  The code to do the
> actual checking is a little excessive, but it sets us up for per-type
> cursor zones in the next patch.

Ok, I think the cursor "zone" array is the wrong approach here.

First of all - can we stop using the term "zone" for new code?
That's the old irix terminolgy for slab caches, and we have been
moving away from that to the Linux "kmem_cache" terminology and
types for quite some time.

AFAICT, the only reason for having the zone array is so that
xfs_btree_alloc_cursor() can do a lookup via btnum into the array to
get the maxlevels and kmem cache pointer to allocate from.

Given that we've just called into xfs_btree_alloc_cursor() from the
specific btree type we are allocating the cursor for (that's where
we got btnum from!), we should just be passing these type specific
variables directly from the caller like we do for btnum. That gets
rid of the need for the zone array completely....

i.e. I don't see why the per-type cache information needs to be
global information. The individual max-level calculations could just
be individual kmem_cache_alloc() calls to set locally defined (i.e.
static global) cache pointers and max size variables.

> diff --git a/fs/xfs/libxfs/xfs_ialloc_btree.c b/fs/xfs/libxfs/xfs_ialloc_btree.c
> index c8fea6a464d5..ce428c98e7c4 100644
> --- a/fs/xfs/libxfs/xfs_ialloc_btree.c
> +++ b/fs/xfs/libxfs/xfs_ialloc_btree.c
> @@ -541,6 +541,17 @@ xfs_inobt_maxrecs(
>  	return blocklen / (sizeof(xfs_inobt_key_t) + sizeof(xfs_inobt_ptr_t));
>  }
>  
> +unsigned int
> +xfs_inobt_absolute_maxlevels(void)
> +{
> +	unsigned int		minrecs[2];
> +
> +	xfs_btree_absolute_minrecs(minrecs, 0, sizeof(xfs_inobt_rec_t),
> +			sizeof(xfs_inobt_key_t) + sizeof(xfs_inobt_ptr_t));
> +
> +	return xfs_btree_compute_maxlevels(minrecs, XFS_MAX_AG_INODES);
> +}

i.e. rather than returning the size here, we do:

static int xfs_inobt_maxlevels;
static struct kmem_cache xfs_inobt_cursor_cache;

int __init
xfs_inobt_create_cursor_cache(void)
{
	unsigned int		minrecs[2];

	xfs_btree_absolute_minrecs(minrecs, 0, sizeof(xfs_inobt_rec_t),
			sizeof(xfs_inobt_key_t) + sizeof(xfs_inobt_ptr_t));
	xfs_inobt_maxlevels = xfs_btree_compute_maxlevels(minrecs,
			XFS_MAX_AG_INODES);
	xfs_inobt_cursor_cache = kmem_cache_alloc("xfs_inobt_cur",
			xfs_btree_cur_sizeof(xfs_inobt_maxlevels),
			0, 0, NULL);
	if (!xfs_inobt_cursor_cache)
		return -ENOMEM;
	return 0;
}

void
xfs_inobt_destroy_cursor_cache(void)
{
	kmem_cache_destroy(xfs_inobt_cursor_cache);
}

and nothing outside fs/xfs/libxfs/xfs_ialloc_btree.c ever needs to
know about these variables as they only ever feed into
xfs_btree_alloc_cursor() from xfs_inobt_init_common().

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
