Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:63885 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727380AbeKPQan (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 16 Nov 2018 11:30:43 -0500
Date: Fri, 16 Nov 2018 17:19:36 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 14/16] xfs: align writepages to large block sizes
Message-ID: <20181116061936.GE19305@dastard>
References: <20181107063127.3902-1-david@fromorbit.com>
 <20181107063127.3902-15-david@fromorbit.com>
 <20181114141925.GA19257@bfoster>
 <20181114211818.GW19305@dastard>
 <20181115125544.GC22958@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181115125544.GC22958@bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

On Thu, Nov 15, 2018 at 07:55:44AM -0500, Brian Foster wrote:
> On Thu, Nov 15, 2018 at 08:18:18AM +1100, Dave Chinner wrote:
> > On Wed, Nov 14, 2018 at 09:19:26AM -0500, Brian Foster wrote:
> > > On Wed, Nov 07, 2018 at 05:31:25PM +1100, Dave Chinner wrote:
> > > > From: Dave Chinner <dchinner@redhat.com>
> > > > 
> > > > For data integrity purposes, we need to write back the entire
> > > > filesystem block when asked to sync a sub-block range of the file.
> > > > When the filesystem block size is larger than the page size, this
> > > > means we need to convert single page integrity writes into whole
> > > > block integrity writes. We do this by extending the writepage range
> > > > to filesystem block granularity and alignment.
> > > > 
> > > > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > > > ---
> > > >  fs/xfs/xfs_aops.c | 14 ++++++++++++++
> > > >  1 file changed, 14 insertions(+)
> > > > 
> > > > diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
> > > > index f6ef9e0a7312..5334f16be166 100644
> > > > --- a/fs/xfs/xfs_aops.c
> > > > +++ b/fs/xfs/xfs_aops.c
> > > > @@ -900,6 +900,7 @@ xfs_vm_writepages(
> > > >  		.io_type = XFS_IO_HOLE,
> > > >  	};
> > > >  	int			ret;
> > > > +	unsigned		bsize =	i_blocksize(mapping->host);
> > > >  
> > > >  	/*
> > > >  	 * Refuse to write pages out if we are called from reclaim context.
> > > > @@ -922,6 +923,19 @@ xfs_vm_writepages(
> > > >  	if (WARN_ON_ONCE(current->flags & PF_MEMALLOC_NOFS))
> > > >  		return 0;
> > > >  
> > > > +	/*
> > > > +	 * If the block size is larger than page size, extent the incoming write
> > > > +	 * request to fsb granularity and alignment. This is a requirement for
> > > > +	 * data integrity operations and it doesn't hurt for other write
> > > > +	 * operations, so do it unconditionally.
> > > > +	 */
> > > > +	if (wbc->range_start)
> > > > +		wbc->range_start = round_down(wbc->range_start, bsize);
> > > > +	if (wbc->range_end != LLONG_MAX)
> > > > +		wbc->range_end = round_up(wbc->range_end, bsize);
> > > > +	if (wbc->nr_to_write < wbc->range_end - wbc->range_start)
> > > > +		wbc->nr_to_write = round_up(wbc->nr_to_write, bsize);
> > > > +
> > > 
> > > This latter bit causes endless writeback loops in tests such as
> > > generic/475 (I think I reproduced it with xfs/141 as well). The
> > 
> > Yup, I've seen that, but haven't fixed it yet because I still
> > haven't climbed out of the dedupe/clone/copy file range data
> > corruption hole that fsx pulled the lid of.
> > 
> > Basically, I can't get back to working on bs > ps until I get the
> > stuff we actually support working correctly first...
> > 
> > > writeback infrastructure samples ->nr_to_write before and after
> > > ->writepages() calls to identify progress. Unconditionally bumping it to
> > > something larger than the original value can lead to an underflow in the
> > > writeback code that seems to throw things off. E.g., see the following
> > > wb tracepoints (w/ 4k block and page size):
> > > 
> > >    kworker/u8:13-189   [003] ...1   317.968147: writeback_single_inode_start: bdi 253:9: ino=8389005 state=I_DIRTY_PAGES|I_SYNC dirtied_when=4294773087 age=211 index=0 to_write=1024 wrote=0 cgroup_ino=4294967295
> > >    kworker/u8:13-189   [003] ...1   317.968150: writeback_single_inode: bdi 253:9: ino=8389005 state=I_DIRTY_PAGES|I_SYNC dirtied_when=4294773087 age=211 index=0 to_write=1024 wrote=18446744073709548544 cgroup_ino=4294967295
> > > 
> > > The wrote value goes from 0 to garbage and writeback_sb_inodes() uses
> > > the same basic calculation for 'wrote.'
> > 
> > Easy enough to fix, just stash the originals and restore them once
> > done.
> > 
> > > 
> > > BTW, I haven't gone through the broader set, but just looking at this
> > > bit what's the purpose of rounding ->nr_to_write (which is a page count)
> > > to a block size in the first place?
> > 
> > fsync on a single page range.
> > 
> > We write that page, allocate the block (which spans 16 pages), and
> > then return from writeback leaving 15/16 pages on that block still
> > dirty in memory.  Then we force the log, pushing the allocation and
> > metadata to disk.  Crash.
> > 
> > On recovery, we expose 15/16 pages of stale data because we only
> > wrote one of the pages over the block during fsync.
> > 
> 
> But why the block size and not something that represents pages per
> block? Note again that ->nr_to_write is a page count and you're
> comparing and aligning it with fields that are byte offsets.

Not sure I follow you - block size is directly related to the
number of pages per block. You can't calculate one without the
other...

/me goes back an looks at the code, finally it dawns on him that
the bug is he's rounding to block size, not (block size >>
PAGE_SHIFT). I'll fix that.

> IOW, an
> integrity write isn't limited by page count since it's critical to flush
> the specified range. Unless I'm misunderstanding how this field is used
> in the writeback code, ISTM that there shouldn't be any need to muck
> with nr_to_write here for the purposes of fsync.

Sorry, I thought you were asking about why were were rounding the
range in general, not nr_to_write specifically.

We don't need to modify nr_to_write for WB_SYNC_ALL,
write_cache_pages() will not terminate on a nr_to_write expiry. So,
unlike the range rounding, the nr_to_write rounding is really only
for WB_SYNC_NONE.

i.e. we round WB_SYNC_NONE to try to get whole blocks written so we
don't end up with partially written blocks on disk for extended
periods of time (e.g. between background writeback periods). It
doesn't matter for WB_SYNC_ALL, but it will reduce the potential for
stale data beign exposed when crashes occur and random pages in
blocks have't been written back. i.e. it's to help iprevent
re-exposing the problematic cases that we added the "NULL files
after crash" workarounds for.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
