Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:17029 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728501AbeKOHXP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 15 Nov 2018 02:23:15 -0500
Date: Thu, 15 Nov 2018 08:18:18 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 14/16] xfs: align writepages to large block sizes
Message-ID: <20181114211818.GW19305@dastard>
References: <20181107063127.3902-1-david@fromorbit.com>
 <20181107063127.3902-15-david@fromorbit.com>
 <20181114141925.GA19257@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181114141925.GA19257@bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

On Wed, Nov 14, 2018 at 09:19:26AM -0500, Brian Foster wrote:
> On Wed, Nov 07, 2018 at 05:31:25PM +1100, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > For data integrity purposes, we need to write back the entire
> > filesystem block when asked to sync a sub-block range of the file.
> > When the filesystem block size is larger than the page size, this
> > means we need to convert single page integrity writes into whole
> > block integrity writes. We do this by extending the writepage range
> > to filesystem block granularity and alignment.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > ---
> >  fs/xfs/xfs_aops.c | 14 ++++++++++++++
> >  1 file changed, 14 insertions(+)
> > 
> > diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
> > index f6ef9e0a7312..5334f16be166 100644
> > --- a/fs/xfs/xfs_aops.c
> > +++ b/fs/xfs/xfs_aops.c
> > @@ -900,6 +900,7 @@ xfs_vm_writepages(
> >  		.io_type = XFS_IO_HOLE,
> >  	};
> >  	int			ret;
> > +	unsigned		bsize =	i_blocksize(mapping->host);
> >  
> >  	/*
> >  	 * Refuse to write pages out if we are called from reclaim context.
> > @@ -922,6 +923,19 @@ xfs_vm_writepages(
> >  	if (WARN_ON_ONCE(current->flags & PF_MEMALLOC_NOFS))
> >  		return 0;
> >  
> > +	/*
> > +	 * If the block size is larger than page size, extent the incoming write
> > +	 * request to fsb granularity and alignment. This is a requirement for
> > +	 * data integrity operations and it doesn't hurt for other write
> > +	 * operations, so do it unconditionally.
> > +	 */
> > +	if (wbc->range_start)
> > +		wbc->range_start = round_down(wbc->range_start, bsize);
> > +	if (wbc->range_end != LLONG_MAX)
> > +		wbc->range_end = round_up(wbc->range_end, bsize);
> > +	if (wbc->nr_to_write < wbc->range_end - wbc->range_start)
> > +		wbc->nr_to_write = round_up(wbc->nr_to_write, bsize);
> > +
> 
> This latter bit causes endless writeback loops in tests such as
> generic/475 (I think I reproduced it with xfs/141 as well). The

Yup, I've seen that, but haven't fixed it yet because I still
haven't climbed out of the dedupe/clone/copy file range data
corruption hole that fsx pulled the lid of.

Basically, I can't get back to working on bs > ps until I get the
stuff we actually support working correctly first...

> writeback infrastructure samples ->nr_to_write before and after
> ->writepages() calls to identify progress. Unconditionally bumping it to
> something larger than the original value can lead to an underflow in the
> writeback code that seems to throw things off. E.g., see the following
> wb tracepoints (w/ 4k block and page size):
> 
>    kworker/u8:13-189   [003] ...1   317.968147: writeback_single_inode_start: bdi 253:9: ino=8389005 state=I_DIRTY_PAGES|I_SYNC dirtied_when=4294773087 age=211 index=0 to_write=1024 wrote=0 cgroup_ino=4294967295
>    kworker/u8:13-189   [003] ...1   317.968150: writeback_single_inode: bdi 253:9: ino=8389005 state=I_DIRTY_PAGES|I_SYNC dirtied_when=4294773087 age=211 index=0 to_write=1024 wrote=18446744073709548544 cgroup_ino=4294967295
> 
> The wrote value goes from 0 to garbage and writeback_sb_inodes() uses
> the same basic calculation for 'wrote.'

Easy enough to fix, just stash the originals and restore them once
done.

> 
> BTW, I haven't gone through the broader set, but just looking at this
> bit what's the purpose of rounding ->nr_to_write (which is a page count)
> to a block size in the first place?

fsync on a single page range.

We write that page, allocate the block (which spans 16 pages), and
then return from writeback leaving 15/16 pages on that block still
dirty in memory.  Then we force the log, pushing the allocation and
metadata to disk.  Crash.

On recovery, we expose 15/16 pages of stale data because we only
wrote one of the pages over the block during fsync.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
