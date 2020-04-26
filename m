Return-Path: <SRS0=Ew45=6K=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 592D2C54FCB
	for <linux-xfs@archiver.kernel.org>; Sun, 26 Apr 2020 22:08:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 34E162075B
	for <linux-xfs@archiver.kernel.org>; Sun, 26 Apr 2020 22:08:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726216AbgDZWIJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 26 Apr 2020 18:08:09 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:51355 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726215AbgDZWIJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 26 Apr 2020 18:08:09 -0400
Received: from dread.disaster.area (pa49-195-157-175.pa.nsw.optusnet.com.au [49.195.157.175])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 550E93A4FC2;
        Mon, 27 Apr 2020 08:08:06 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jSpRV-0008Km-71; Mon, 27 Apr 2020 08:08:05 +1000
Date:   Mon, 27 Apr 2020 08:08:05 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Chandan Rajendra <chandan@linux.ibm.com>
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        Chandan Rajendra <chandanrlinux@gmail.com>,
        linux-xfs@vger.kernel.org, bfoster@redhat.com
Subject: Re: [PATCH 2/2] xfs: Extend xattr extent counter to 32-bits
Message-ID: <20200426220805.GE2040@dread.disaster.area>
References: <20200404085203.1908-1-chandanrlinux@gmail.com>
 <2468041.fvziTNUSPq@localhost.localdomain>
 <20200422223041.GE27860@dread.disaster.area>
 <2457302.TnqmriUJk8@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2457302.TnqmriUJk8@localhost.localdomain>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=QIgWuTDL c=1 sm=1 tr=0
        a=ONQRW0k9raierNYdzxQi9Q==:117 a=ONQRW0k9raierNYdzxQi9Q==:17
        a=kj9zAlcOel0A:10 a=cl8xLZFz6L8A:10 a=7-415B0cAAAA:8
        a=sj2pnMTuyTJ17fFAoogA:9 a=lW7t2CFN_JvmrShR:21 a=6d80TkwGj26y1EX_:21
        a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Apr 25, 2020 at 05:37:39PM +0530, Chandan Rajendra wrote:
> On Thursday, April 23, 2020 4:00 AM Dave Chinner wrote: 
> > On Wed, Apr 22, 2020 at 03:08:00PM +0530, Chandan Rajendra wrote:
> > > Attr bmbt tree height (MINABTPTRS == 2)
> > > |-------+------------------------+-------------------------|
> > > | Level | Number of nodes/leaves |           Total Nr recs |
> > > |       |                        | (nr nodes/leaves * 125) |
> > > |-------+------------------------+-------------------------|
> > > |     0 |                      1 |                       2 |
> > > |     1 |                      2 |                     250 |
> > > |     2 |                    250 |                   31250 |
> > > |     3 |                  31250 |                 3906250 |
> > > |     4 |                3906250 |               488281250 |
> > > |     5 |              488281250 |             61035156250 |
> > > |-------+------------------------+-------------------------|
> > > 
> > > For xattr extents, (2 ** 32) - 1 = 4294967295 (~ 4 billion extents). So this
> > > will cause the corresponding bmbt's maximum height to go from 3 to 5.
> > > This probably won't cause any regression.
> > 
> > We already have the XFS_DA_NODE_MAXDEPTH set to 5, so changing the
> > attr fork extent count makes no difference to the attribute fork
> > bmbt reservations. i.e. the bmbt reservations are defined by the
> > dabtree structure limits, not the maximum extent count the fork can
> > hold.
> 
> I think the dabtree structure limits is because of the following ...
> 
> How many levels of dabtree would be needed to hold ~100 million xattrs?
> - name len = 16 bytes
>          struct xfs_parent_name_rec {
>                __be64  p_ino;
>                __be32  p_gen;
>                __be32  p_diroffset;
>        };
>   i.e. 64 + 32 + 32 = 128 bits = 16 bytes;
> - Value len = file name length = Assume ~40 bytes

That's quite long for a file name, but lets run with it...

> - Formula for number of node entries (used in column 3 in the table given
>   below) at any level of the dabtree,
>   nr_blocks * ((block size - sizeof(struct xfs_da3_node_hdr)) / sizeof(struct
>   xfs_da_node_entry))
>   i.e. nr_blocks * ((block size - 64) / 8)
> - Formula for number of leaf entries (used in column 4 in the table given
>   below),
>   (block size - sizeof(xfs_attr_leaf_hdr_t)) /
>   (sizeof(xfs_attr_leaf_entry_t) + valuelen + namelen + nameval)
>   i.e. nr_blocks * ((block size - 32) / (8 + 2 + 1 + 16 + 40))
> 
> Here I have assumed block size to be 4k.
> 
> |-------+------------------+--------------------------+--------------------------|
> | Level | Number of blocks | Number of entries (node) | Number of entries (leaf) |
> |-------+------------------+--------------------------+--------------------------|
> |     0 |              1.0 |                      5e2 |                    6.1e1 |
> |     1 |              5e2 |                    2.5e5 |                    3.0e4 |
> |     2 |            2.5e5 |                    1.3e8 |                    1.5e7 |
> |     3 |            1.3e8 |                   6.6e10 |                    7.9e9 |
> |-------+------------------+--------------------------+--------------------------|

I'm not sure what this table actually represents.

> 
> Hence we would need a tree of height 3.
> Total number of blocks = 1 + 5e2 + 2.5e5 + 1.3e8 = ~1.3e8

130 million blocks to hold 100 million xattrs? That doesn't pass the
smell test.

I think you are trying to do these calculations from the wrong
direction. Calculate the number of leaf blocks needed to hold the
xattr data first, then work out the height of the pointer tree from
that. e.g:

If we need 100m xattrs, we need this many 100% full 4k blocks to
hold them all:

blocks	= 100m / entries per leaf
	= 100m / 61
	= 1.64m

and if we assume 37% for the least populated (because magic
split/merge number), multiply by 3, so blocks ~= 5m for 100m xattrs
in 4k blocks.

That makes a lot more sense. Now the tree itself:

ptrs per node ^ N = 5m
ptrs per node ^ (N-1) = 5m / 500 = 10k
ptrs per node ^ (N-2) = 10k / 500 = 200
ptrs per node ^ (N-3) = 200 / 500 = 1

So, N-3 = level 0, so we've got a tree of height 4 for 100m xattrs,
and the pointer tree requires ~12000 blocks which is noise compared
to the number of leaf blocks...

As for the bmbt, we've got ~5m extents worst case, which is

ptrs per node ^ N = 5m
ptrs per node ^ (N-1) = 5m / 125 = 40k
ptrs per node ^ (N-2) = 40k / 125 = 320
ptrs per node ^ (N-3) = 320 / 125 = 3

As 3 bmbt records should fit in the inode fork, we'd only need a 4
level bmbt tree to hold this, too. It's at the lower limit of a 4
level tree, but 100m xattrs is the extreme case we are talking about
here...

FWIW, repeat this with a directory data segment size of 32GB w/ 40
byte names, and the numbers aren't much different to a worst case
xattr tree of this shape. You'll see the reason for the dabtree
height being limited to 5, and that neither the directory structure
nor the xattr structure is anywhere near the 2^32 bit extent count
limit...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
