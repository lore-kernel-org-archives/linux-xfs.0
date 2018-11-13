Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pl1-f195.google.com ([209.85.214.195]:45817 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730995AbeKNEAk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 13 Nov 2018 23:00:40 -0500
Received: by mail-pl1-f195.google.com with SMTP id a14so1781537plm.12
        for <linux-xfs@vger.kernel.org>; Tue, 13 Nov 2018 10:01:29 -0800 (PST)
Date: Tue, 13 Nov 2018 10:01:26 -0800
From: Omar Sandoval <osandov@osandov.com>
Subject: Re: [PATCH v2] xfs: cache minimum realtime summary level
Message-ID: <20181113180126.GA3253@vader>
References: <49a31389f88ab40b11f07afa5c728a1368e39a45.1541908447.git.osandov@fb.com>
 <20181113174234.GI4235@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181113174234.GI4235@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org, kernel-team@fb.com

On Tue, Nov 13, 2018 at 09:42:34AM -0800, Darrick J. Wong wrote:
> On Sat, Nov 10, 2018 at 07:59:58PM -0800, Omar Sandoval wrote:
> > From: Omar Sandoval <osandov@fb.com>
> > 
> > The realtime summary is a two-dimensional array on disk, effectively:
> > 
> > u32 rsum[log2(number of realtime extents) + 1][number of blocks in the bitmap]
> > 
> > rsum[log][bbno] is the number of extents of size 2**log which start in
> > bitmap block bbno.
> > 
> > xfs_rtallocate_extent_near() uses xfs_rtany_summary() to check whether
> > rsum[log][bbno] != 0 for any log level. However, the summary array is
> > stored in row-major order (i.e., like an array in C), so all of these
> > entries are not adjacent, but rather spread across the entire summary
> > file. In the worst case (a full bitmap block), xfs_rtany_summary() has
> > to check every level.
> > 
> > This means that on a moderately-used realtime device, an allocation will
> > waste a lot of time finding, reading, and releasing buffers for the
> > realtime summary. In particular, one of our storage services (which runs
> > on servers with 8 very slow CPUs and 15 8 TB XFS realtime filesystems)
> > spends almost 5% of its CPU cycles in xfs_rtbuf_get() and
> > xfs_trans_brelse() called from xfs_rtany_summary().
> > 
> > One solution would be to also store the summary with the dimensions
> > swapped. However, this would require a disk format change to a very old
> > component of XFS.
> > 
> > Instead, we can cache the minimum size which contains any extents. We do
> > so lazily; rather than guaranteeing that the cache contains the precise
> > minimum, it always contains a loose lower bound which we tighten when we
> > read or update a summary block. This only uses a few kilobytes of memory
> > and is already serialized via the realtime bitmap and summary inode
> > locks, so the cost is minimal. With this change, the same workload only
> > spends 0.2% of its CPU cycles in the realtime allocator.
> > 
> > Signed-off-by: Omar Sandoval <osandov@fb.com>
> > ---

[snip]

> Hmmm, how much memory does this require?
> 
> Let's say I had a 64TB realtime volume on a 4k block filesystem and 1
> block per rt extent.
> 
> That's ... 2^(46 - 12) = 2^34 rt blocks.
> 
> Each rtbitmap block tracks 2^(12+3) = 2^15 blocks, which means that
> there are 2^(34-15) = 2^19 rtbitmap blocks.
> 
> The cache requires 1 byte per rtbitmap block (2^19) which means it
> requires ~512k of memory?  And if I had 1EB that would be 8MB of RAM?
> 
> (Granted you said you use 256K rt extents, which cuts down the memory
> requirements by 64x, but I don't want to assume everyone will do this.)

Yup, that math looks right.

> > +	if (!mp->m_rsum_cache) {
> > +		xfs_irele(mp->m_rbmip);
> > +		xfs_irele(mp->m_rsumip);
> > +		return -ENOMEM;
> > +	}
> 
> That's a pretty high order memory allocation and it seem unfortunate to
> fail the mount because we couldn't cobble together enough [kv]memory to
> set up a rtsummary cache.
> 
> One option would be to fall back to reading the rtsummary file if
> m_rsum_cache == NULL (i.e. we couldn't get enough memory to set up the
> cache).

Good idea, I'll make this continue without the cache if it can't be
allocated.

Thanks for the review.

> Another option could be to use the xfs big memory array that
> I've been developing for the xfs online repair patchset which uses a
> memfd to create a byte-addressable array whose pages can be swapped out.
> The downside of xfbma is that array accesses are pretty heavyweight.
> 
> --D
