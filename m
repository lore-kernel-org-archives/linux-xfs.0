Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9032C64E7B
	for <linux-xfs@archiver.kernel.org>; Mon, 30 Nov 2020 21:52:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5D15B2084C
	for <linux-xfs@archiver.kernel.org>; Mon, 30 Nov 2020 21:52:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725995AbgK3VwB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 30 Nov 2020 16:52:01 -0500
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:40950 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725893AbgK3VwA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 30 Nov 2020 16:52:00 -0500
Received: from dread.disaster.area (pa49-179-6-140.pa.nsw.optusnet.com.au [49.179.6.140])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id B99933C3A84;
        Tue,  1 Dec 2020 08:51:15 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1kjr4k-00GjyN-P6; Tue, 01 Dec 2020 08:51:14 +1100
Date:   Tue, 1 Dec 2020 08:51:14 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Chandan Babu R <chandanrlinux@gmail.com>
Cc:     linux-xfs@vger.kernel.org, darrick.wong@oracle.com
Subject: Re: Maximum height of rmapbt when reflink feature is enabled
Message-ID: <20201130215114.GH2842436@dread.disaster.area>
References: <3275346.ciGmp8L3Sz@garuda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3275346.ciGmp8L3Sz@garuda>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=F8MpiZpN c=1 sm=1 tr=0 cx=a_idp_d
        a=uDU3YIYVKEaHT0eX+MXYOQ==:117 a=uDU3YIYVKEaHT0eX+MXYOQ==:17
        a=kj9zAlcOel0A:10 a=zTNgK-yGK50A:10 a=7-415B0cAAAA:8
        a=_cDiFbhlsSxLhcC8TFkA:9 a=somuxn7QlSIc6bZ6:21 a=v-vu3GntEptOoEz-:21
        a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Nov 30, 2020 at 02:35:21PM +0530, Chandan Babu R wrote:
> The comment in xfs_rmapbt_compute_maxlevels() mentions that with
> reflink enabled, XFS will run out of AG blocks before reaching maximum
> levels of XFS_BTREE_MAXLEVELS (i.e. 9).  This is easy to prove for 4k
> block size case:
> 
> Considering theoretical limits, maximum height of rmapbt can be,
> max btree height = Log_(min_recs)(total recs)
> max_rmapbt_height = Log_45(2^64) = 12.

I think the use of mirecs here is wrong. We can continue to fill
both leaves and nodes above minrecs once we get to maximal height.
When a leaf/node is full, it will attempt to shift records left and
right to sibling nodes before trying to split. Hence a split only
occurs when all three nodes are completely full.

Hence we'll end up with a much higher average population of leaves
and nodes than the minimum when we are at maximum height, especially
at the upper levels of the btree near the root.

i.e. we won't try to split the root ever until the root is at
maximum capacity, and we won't try to split the next level down
(before we get to a root split) until at least 3 adjacent nodes
are at max capacity, and so on. Hence at higher levels, the tree is
always going to tend towards max capacity nodes, not min capacity.
That changes these calculations quite a lot...

> Detailed calculation:
> nr-levels = 1; nr-leaf-blks = 2^64 / 84 = 2e17;
> nr-levels = 2; nr-blks = 2e17 / 45 = 5e15;
> nr-levels = 3; nr-blks = 5e15 / 45 = 1e14;
> nr-levels = 4; nr-blks = 1e14 / 45 = 2e12;
> nr-levels = 5; nr-blks = 2e12 / 45 = 5e10;
> nr-levels = 6; nr-blks = 5e10 / 45 = 1e9;
> nr-levels = 7; nr-blks = 1e9 / 45 = 3e7;
> nr-levels = 8; nr-blks = 3e7 / 45 = 6e5;
> nr-levels = 9; nr-blks = 6e5 / 45 = 1e4;
> nr-levels = 10; nr-blks = 1e4 / 45 = 3e2;
> nr-levels = 11; nr-blks = 3e2 / 45 = 6;
> nr-levels = 12; nr-blks = 1;
> 
> Total number of blocks = 2e17
>
> Here, 84 is the minimum number of leaf records and 45 is the minimum
> number of node records in the rmapbt when using 4k block size. 2^64 is
> the maximum possible rmapbt records
> (i.e. max_rmap_entries_per_disk_block (2^32) * max_nr_agblocks
> (2^32)).
>
> i.e. theoretically rmapbt height can go upto 12.

Yes, but if the rmapbt contains 2^64 records, how many physical disk
blocks does it consume itself? Worst case that's 2^64 / 45, so
somewhere between 2^58 and 2^59 blocks of storage required for
indexing all those reocrds with a 4kB block size?

Yet we only have 2^28 4kB blocks in an AG, and the limit of a
rmapbt is actually what can physically fit in an AG, yes?

So, regardless of what the theoretical record capacity of a worse
case rmapbt record fill might be, it hits physical record storage
limits long before that. i.e. the limit on the btree height is
physical storage, not theoretical record indexing capability.

In which case, let us [incorrectly, see later] assume we have a
handful of maximally shared single data blocks and the rest of the
1TB AG is rmapbt. i.e.  the maximum depth of the rmapbt is
determined by how much physical space it can consume, which is very
close to 2^32 blocks for 1kB filesystems.

Let's work from max capacity, so 2^32 * 21 is the max record holding
capacity of the per-ag rmapbt.  Hence the worst case index height
requirement for the rmapbt is indexing ~2^37 records.

nr-levels = 1; nr-leaf-blks = 2^32 * 21 / 21 = 4e9
nr-levels = 2; nr-blks = 4e9 / 21 = 2e8;
nr-levels = 3; nr-blks = 2e8 / 21 = 9e6;
nr-levels = 4; nr-blks = 9e6/ 21 = 4e5;
nr-levels = 5; nr-blks = 4e5 / 21 = 2e4;
nr-levels = 6; nr-blks = 2e4 / 21 = 1e3;
nr-levels = 7; nr-blks = 1e3 / 21 = 50
nr-levels = 8; nr-blks = 50 / 21 = 3;
nr-levels = 9; nr-blks = 3 / 21 = 1;
nr-levels = 10; nr-blks = 1;

So we *just* tick over into a 10 level rmapbt here in this worse
case where the rmapbt takes *all* of the AG space.  In comparison,
min capacity lower nodes, max capacity higher nodes:

nr-levels = 1; nr-leaf-blks = 2^32 * 11 / 11 = 4e9
nr-levels = 2; nr-blks = 4e9 / 11 = 4e8;
nr-levels = 3; nr-blks = 4e8 / 11 = 4e7;
nr-levels = 4; nr-blks = 4e7/ 11 = 3e6;
nr-levels = 5; nr-blks = 3e6 / 21 = 2e5;
nr-levels = 6; nr-blks = 2e5 / 21 = 7e3;
nr-levels = 7; nr-blks = 7e3 / 21 = 348;
nr-levels = 8; nr-blks = 348 / 21 = 16;
nr-levels = 9; nr-blks = 16 / 21 = 1;
nr-levels = 10; nr-blks = 1;

Same, it's a 10 level tree.

> But as the comment in xfs_rmapbt_compute_maxlevels() suggests, we will
> run out of per-ag blocks trying to build an rmapbt of height
> XFS_BTREE_MAXLEVELS (i.e. 9).
> 
> Since number of nodes grows as a geometric series,
> nr_nodes (roughly) = (45^9 - 1) / (45 - 1) = 10e12
> 
> i.e. 10e12 blocks > max ag blocks (2^32 == 4e9)
> 
> However, with 1k block size we are not close to consuming all of 2^32
> AG blocks as shown by the below calculations,
> 
>  - rmapbt with maximum of 9 levels will have roughly (11^9 - 1) / (11 -
>    1) = 2e8 blocks.

2.35e8, which is a quarter of the max AG space, assuming minimum
capacity nodes. Assuming max capacity nodes, we're at
3.9e10 blocks, which is almost 40x the number of blocks in the AG...

>    - 11 is the minimum number of recs in a non-leaf node with 1k block size.
>    - Also, Total number of records (roughly) = (nr_leaves * 11) = 11^8 * 11
>      = 2e9 (this value will be used later).
>  
>  - refcountbt
>    - Maximum number of records theoretically = maximum number of blocks
>      in an AG = 2^32

The logic here is flawed - you're assuming exclusive use of the AG
to hold *both* rmapbt records and shared data extents. Every block
used for an rmap record cannot have a refcount record pointing at
it because per-ag metadata cannot be shared.

>    - Total (leaves and non-leaf nodes) blocks required to hold 2^32 records
>      Leaf min recs = 20;  Node min recs = 60 (with 1k as the block size).
>      - Detailed calculation:
>  	    nr-levels = 1; nr-leaf-blks = 2^32 / 20 = 2e8;
>  	    nr-levels = 2; nr-blks = 2e8 / 60 = 4e6
>  	    nr-levels = 3; nr-blks = 4e6 / 60 = 6e4
>  	    nr-levels = 4; nr-blks = 6e4 / 60 = 1.0e3
>  	    nr-levels = 5; nr-blks = 1.0e3 / 60 = 2e1
>  	    nr-levels = 6; nr-blks = 1
>  
>      - Total block count = 2e8

So, if we assume that 20% of the AG space is refcount btree records
like this, then the rmapbt only consumes 80% of the AG, then the
rmap btree is much closer to the 9 level limit, especially if
we consider we'll tend towards max capacity nodes as we fill the
tree, not min capacity nodes.

But the reality is that we could have a single refcount record with
2^32 references, and that requires 2^32 rmapbt records. So if we are
talking about really high extent refcount situations, the worst case
is a handful of single blocks with billions of references. IOWs, the
refcountbt is a single block with ~2^5 entries in it, each which
track 2^32 references. Now we require 2^37 rmapbt records, and we've
overflowed the maximum physical storage capacity of the AG for
rmapbt blocks.

>  - Bmbt (assuming all the rmapbt records have the same inode as owner)
>    - Total (leaves and non-leaf nodes) blocks required to hold 2e9 records
>      Leaf min recs = 29;  Node min recs = 29 (with 1k as the block size).
>      (2e9 is the maximum rmapbt records with rmapbt height 9 and 1k block size).
>        nr-levels = 1; nr-leaf-blks = 2e9 / 29 = 7e7
>        nr-levels = 2; nr-blks = 7e7 / 29 = 2e6
>        nr-levels = 3; nr-blks = 2e6 / 29 = 8e4
>        nr-levels = 4; nr-blks = 8e4 / 29 = 3e3
>        nr-levels = 5; nr-blks = 3e3 / 29 = 1e2
>        nr-levels = 6; nr-blks = 1e2 / 29 = 3
>        nr-levels = 7; nr-blks = 1
>  
>    - Total block count = 7e7
>  
>  Total blocks used across rmapbt, refcountbt and bmbt = 2e8 + 2e8 + 7e7 = 5e8.

BMBT blocks are not bound to an AG the way refcount and rmapbt
records are. They can be anywhere in the filesystem, so they play no
part in calculations like these.

> Since 5e8 < 4e9(i.e. 2^32), we have not run out of blocks trying
> to build a rmapbt with XFS_BTREE_MAXLEVELS (i.e 9) levels.
> 
> Please let me know if my understanding is incorrect.

The worst case theory is largely sound, but theory != reality.

The actual reality of someone with billions of refcount entries to a
a handful of single extents in a single AG is using a 1kB block size
is likely to be so rare that we shouldn't consider it a critical
design point.

That is, if the values cover the default 4kB block size just fine,
then we should not penalise every common configuration just to
handle an extreme case in an extremely rare corner case for a
non-default configuration.

> I have come across a "log reservation" calculation issue when
> increasing XFS_BTREE_MAXLEVELS to 10 which is in turn required for
> extending data fork extent count to 48 bits.

What is that issue?

The BMBT modifications should not care about XFS_BTREE_MAXLEVELS as
a limit, we use the calculated mp->m_bm_maxlevels[] variables for
BMBT height. These are bound by the maximum number of extents the
tree can index, not the depth of btrees allowed within an AG.
Changing the size of the BMBT tree should not affect the per-ag
btrees in any way, nor the log reservations required to manipulate
the per-ag btrees...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
