Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-io1-f66.google.com ([209.85.166.66]:44806 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389303AbeKGCqx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 6 Nov 2018 21:46:53 -0500
Received: by mail-io1-f66.google.com with SMTP id c6-v6so9783191iob.11
        for <linux-xfs@vger.kernel.org>; Tue, 06 Nov 2018 09:20:41 -0800 (PST)
Date: Tue, 6 Nov 2018 09:20:37 -0800
From: Omar Sandoval <osandov@osandov.com>
Subject: Re: [PATCH] xfs: cache minimum realtime summary level
Message-ID: <20181106172037.GA26112@vader>
References: <74441433f31eeb7f0c9fb49a04173ac2417d349a.1541187228.git.osandov@fb.com>
 <20181105234948.GL19305@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181105234948.GL19305@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org, kernel-team@fb.com

On Tue, Nov 06, 2018 at 10:49:48AM +1100, Dave Chinner wrote:
> On Fri, Nov 02, 2018 at 12:38:00PM -0700, Omar Sandoval wrote:
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
> 
> Yup, the RT allocator is showing that it was never intended for
> general purpose data storage workloads... :P

Indeed. What they really want is the AG allocator with metadata on a
separate device, but that sounds like a much bigger project.

> So how much memory would it require to keep an in-memory copy of
> the summary information? i.e. do an in-memory copy search, then once
> the block is found, pull in the buffer that needs modifying and log
> it? That gets rid of the buffer management overhead, and potentially
> allows for more efficient search algorithms to be used.

Yeah, I considered that. We use 256kB realtime extents for the 8 TB
filesystem, so it's 100kB. If we were using 4kB realtime extents, it'd
be about 7MB. So, it's doable but not the best.

> > One solution would be to swap the dimensions of the summary array so
> > that different sizes on the same bitmap block are adjacent. However,
> > this would require a disk format change to a very old component of XFS,
> > and it would slow down xfs_rtallocate_extent_size().
> 
> Or maybe we should put a second summary on disk, ordered the other
> way similar to  how the btree allocator freespace indexes are
> organised.

That's another thing I considered, but I wanted to avoid a disk format
change if possible, and this small cache is pretty much just as good.

> > Instead, we can cache the minimum size which contains any extents. We do
> > so lazily; rather than guaranteeing that the cache contains the precise
> > minimum, it always contains a loose lower bound which we tighten when we
> > read or update a summary block. This only uses a few kilobytes of memory
> > and is already serialized via the realtime bitmap and summary inode
> > locks, so the cost is minimal. With this change, the same workload only
> > spends 0.2% of its CPU cycles in the realtime allocator.
> 
> Good win.
> 
> > @@ -1187,8 +1195,8 @@ xfs_rtmount_init(
> >  }
> >  
> >  /*
> > - * Get the bitmap and summary inodes into the mount structure
> > - * at mount time.
> > + * Get the bitmap and summary inodes and the summary cache into the mount
> > + * structure at mount time.
> >   */
> >  int					/* error */
> >  xfs_rtmount_inodes(
> > @@ -1211,6 +1219,16 @@ xfs_rtmount_inodes(
> >  		return error;
> >  	}
> >  	ASSERT(mp->m_rsumip != NULL);
> > +	/*
> > +	 * The rsum cache is initialized to all zeroes, which trivially
> > +	 * satisfies the invariant.
> 
> Satisfies what invariant? Please explain why this is OK and how it
> interacts with the allocation code so we're not left guessing what
> this means in the future.
> 
> Remember: comments are not for now - they are for 10 years time when
> no-one remembers what this code does or is actually used for.

The invariant I specified in the definition in xfs_mount_t, but I'll
clarify this.

> > +	 */
> > +	mp->m_rsum_cache = kvzalloc(sbp->sb_rbmblocks, GFP_KERNEL);
> 
> kmem_zalloc_large().

Will change.

> Which makes me ask, just how large is this allocation if you're
> using vmalloc() straight out of the box?

For our 256kB extent size, it's only ~1000 bytes. However, for the same
size filesystem with 4kB extents, it'd be ~60kB.

> > +	if (!mp->m_rsum_cache) {
> > +		xfs_irele(mp->m_rbmip);
> > +		xfs_irele(mp->m_rsumip);
> > +		return -ENOMEM;
> > +	}
> >  	return 0;
> >  }
> >  
> > @@ -1218,6 +1236,7 @@ void
> >  xfs_rtunmount_inodes(
> >  	struct xfs_mount	*mp)
> >  {
> > +	kvfree(mp->m_rsum_cache);
> 
> kmem_free().

Will change.

Thanks for the review!
