Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:19225 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730909AbeKGG0D (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 7 Nov 2018 01:26:03 -0500
Date: Wed, 7 Nov 2018 07:58:51 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: cache minimum realtime summary level
Message-ID: <20181106205851.GM19305@dastard>
References: <74441433f31eeb7f0c9fb49a04173ac2417d349a.1541187228.git.osandov@fb.com>
 <20181105234948.GL19305@dastard>
 <20181106172037.GA26112@vader>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181106172037.GA26112@vader>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Omar Sandoval <osandov@osandov.com>
Cc: linux-xfs@vger.kernel.org, kernel-team@fb.com

On Tue, Nov 06, 2018 at 09:20:37AM -0800, Omar Sandoval wrote:
> On Tue, Nov 06, 2018 at 10:49:48AM +1100, Dave Chinner wrote:
> > On Fri, Nov 02, 2018 at 12:38:00PM -0700, Omar Sandoval wrote:
> > > From: Omar Sandoval <osandov@fb.com>
> > > 
> > > The realtime summary is a two-dimensional array on disk, effectively:
> > > 
> > > u32 rsum[log2(number of realtime extents) + 1][number of blocks in the bitmap]
> > > 
> > > rsum[log][bbno] is the number of extents of size 2**log which start in
> > > bitmap block bbno.
> > > 
> > > xfs_rtallocate_extent_near() uses xfs_rtany_summary() to check whether
> > > rsum[log][bbno] != 0 for any log level. However, the summary array is
> > > stored in row-major order (i.e., like an array in C), so all of these
> > > entries are not adjacent, but rather spread across the entire summary
> > > file. In the worst case (a full bitmap block), xfs_rtany_summary() has
> > > to check every level.
> > > 
> > > This means that on a moderately-used realtime device, an allocation will
> > > waste a lot of time finding, reading, and releasing buffers for the
> > > realtime summary. In particular, one of our storage services (which runs
> > > on servers with 8 very slow CPUs and 15 8 TB XFS realtime filesystems)
> > > spends almost 5% of its CPU cycles in xfs_rtbuf_get() and
> > > xfs_trans_brelse() called from xfs_rtany_summary().
> > 
> > Yup, the RT allocator is showing that it was never intended for
> > general purpose data storage workloads... :P
> 
> Indeed. What they really want is the AG allocator with metadata on a
> separate device, but that sounds like a much bigger project.
> 
> > So how much memory would it require to keep an in-memory copy of
> > the summary information? i.e. do an in-memory copy search, then once
> > the block is found, pull in the buffer that needs modifying and log
> > it? That gets rid of the buffer management overhead, and potentially
> > allows for more efficient search algorithms to be used.
> 
> Yeah, I considered that. We use 256kB realtime extents for the 8 TB
> filesystem, so it's 100kB. If we were using 4kB realtime extents, it'd
> be about 7MB. So, it's doable but not the best.

Quite frankly, that's a small amount compared to the amount of
metadata we typically cache on an active filesystem. If we are
really talking about 1MB of RAM per TB of disk space at the worst
case, then that's and acceptible amount to spend on speeding up the
allocator. This patch is a good stepping stone - would you be able
to look into implementing a full in-memory summary cache?

[ Consider that we're reserving something like 16GB of disk space per
TB for rmap btrees - the disk space and memory overhead there is
substantial once the rmap tree grows - and that's why I think 1MB
per TB is almost inconsequential. ]

> > > One solution would be to swap the dimensions of the summary array so
> > > that different sizes on the same bitmap block are adjacent. However,
> > > this would require a disk format change to a very old component of XFS,
> > > and it would slow down xfs_rtallocate_extent_size().
> > 
> > Or maybe we should put a second summary on disk, ordered the other
> > way similar to  how the btree allocator freespace indexes are
> > organised.
> 
> That's another thing I considered, but I wanted to avoid a disk format
> change if possible, and this small cache is pretty much just as good.

*nod*

> > > +	mp->m_rsum_cache = kvzalloc(sbp->sb_rbmblocks, GFP_KERNEL);
> > 
> > kmem_zalloc_large().
> 
> Will change.
> 
> > Which makes me ask, just how large is this allocation if you're
> > using vmalloc() straight out of the box?
> 
> For our 256kB extent size, it's only ~1000 bytes. However, for the same
> size filesystem with 4kB extents, it'd be ~60kB.

Yup, I had a rough thought of around 64k for 8TB, but I wasn't sure
I got it all right in my head. Thanks for confirming.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
