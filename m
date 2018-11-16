Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52380 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727727AbeKPXlu (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 16 Nov 2018 18:41:50 -0500
Date: Fri, 16 Nov 2018 08:29:23 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 14/16] xfs: align writepages to large block sizes
Message-ID: <20181116132922.GA31603@bfoster>
References: <20181107063127.3902-1-david@fromorbit.com>
 <20181107063127.3902-15-david@fromorbit.com>
 <20181114141925.GA19257@bfoster>
 <20181114211818.GW19305@dastard>
 <20181115125544.GC22958@bfoster>
 <20181116061936.GE19305@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181116061936.GE19305@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

On Fri, Nov 16, 2018 at 05:19:36PM +1100, Dave Chinner wrote:
> On Thu, Nov 15, 2018 at 07:55:44AM -0500, Brian Foster wrote:
> > On Thu, Nov 15, 2018 at 08:18:18AM +1100, Dave Chinner wrote:
> > > On Wed, Nov 14, 2018 at 09:19:26AM -0500, Brian Foster wrote:
> > > > On Wed, Nov 07, 2018 at 05:31:25PM +1100, Dave Chinner wrote:
> > > > > From: Dave Chinner <dchinner@redhat.com>
> > > > > 
> > > > > For data integrity purposes, we need to write back the entire
> > > > > filesystem block when asked to sync a sub-block range of the file.
> > > > > When the filesystem block size is larger than the page size, this
> > > > > means we need to convert single page integrity writes into whole
> > > > > block integrity writes. We do this by extending the writepage range
> > > > > to filesystem block granularity and alignment.
> > > > > 
> > > > > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > > > > ---
> > > > >  fs/xfs/xfs_aops.c | 14 ++++++++++++++
> > > > >  1 file changed, 14 insertions(+)
> > > > > 
> > > > > diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
> > > > > index f6ef9e0a7312..5334f16be166 100644
> > > > > --- a/fs/xfs/xfs_aops.c
> > > > > +++ b/fs/xfs/xfs_aops.c
> > > > > @@ -900,6 +900,7 @@ xfs_vm_writepages(
> > > > >  		.io_type = XFS_IO_HOLE,
> > > > >  	};
> > > > >  	int			ret;
> > > > > +	unsigned		bsize =	i_blocksize(mapping->host);
> > > > >  
> > > > >  	/*
> > > > >  	 * Refuse to write pages out if we are called from reclaim context.
> > > > > @@ -922,6 +923,19 @@ xfs_vm_writepages(
> > > > >  	if (WARN_ON_ONCE(current->flags & PF_MEMALLOC_NOFS))
> > > > >  		return 0;
> > > > >  
> > > > > +	/*
> > > > > +	 * If the block size is larger than page size, extent the incoming write
> > > > > +	 * request to fsb granularity and alignment. This is a requirement for
> > > > > +	 * data integrity operations and it doesn't hurt for other write
> > > > > +	 * operations, so do it unconditionally.
> > > > > +	 */
> > > > > +	if (wbc->range_start)
> > > > > +		wbc->range_start = round_down(wbc->range_start, bsize);
> > > > > +	if (wbc->range_end != LLONG_MAX)
> > > > > +		wbc->range_end = round_up(wbc->range_end, bsize);
> > > > > +	if (wbc->nr_to_write < wbc->range_end - wbc->range_start)
> > > > > +		wbc->nr_to_write = round_up(wbc->nr_to_write, bsize);
> > > > > +
> > > > 
> > > > This latter bit causes endless writeback loops in tests such as
> > > > generic/475 (I think I reproduced it with xfs/141 as well). The
> > > 
> > > Yup, I've seen that, but haven't fixed it yet because I still
> > > haven't climbed out of the dedupe/clone/copy file range data
> > > corruption hole that fsx pulled the lid of.
> > > 
> > > Basically, I can't get back to working on bs > ps until I get the
> > > stuff we actually support working correctly first...
> > > 
> > > > writeback infrastructure samples ->nr_to_write before and after
> > > > ->writepages() calls to identify progress. Unconditionally bumping it to
> > > > something larger than the original value can lead to an underflow in the
> > > > writeback code that seems to throw things off. E.g., see the following
> > > > wb tracepoints (w/ 4k block and page size):
> > > > 
> > > >    kworker/u8:13-189   [003] ...1   317.968147: writeback_single_inode_start: bdi 253:9: ino=8389005 state=I_DIRTY_PAGES|I_SYNC dirtied_when=4294773087 age=211 index=0 to_write=1024 wrote=0 cgroup_ino=4294967295
> > > >    kworker/u8:13-189   [003] ...1   317.968150: writeback_single_inode: bdi 253:9: ino=8389005 state=I_DIRTY_PAGES|I_SYNC dirtied_when=4294773087 age=211 index=0 to_write=1024 wrote=18446744073709548544 cgroup_ino=4294967295
> > > > 
> > > > The wrote value goes from 0 to garbage and writeback_sb_inodes() uses
> > > > the same basic calculation for 'wrote.'
> > > 
> > > Easy enough to fix, just stash the originals and restore them once
> > > done.
> > > 
> > > > 
> > > > BTW, I haven't gone through the broader set, but just looking at this
> > > > bit what's the purpose of rounding ->nr_to_write (which is a page count)
> > > > to a block size in the first place?
> > > 
> > > fsync on a single page range.
> > > 
> > > We write that page, allocate the block (which spans 16 pages), and
> > > then return from writeback leaving 15/16 pages on that block still
> > > dirty in memory.  Then we force the log, pushing the allocation and
> > > metadata to disk.  Crash.
> > > 
> > > On recovery, we expose 15/16 pages of stale data because we only
> > > wrote one of the pages over the block during fsync.
> > > 
> > 
> > But why the block size and not something that represents pages per
> > block? Note again that ->nr_to_write is a page count and you're
> > comparing and aligning it with fields that are byte offsets.
> 
> Not sure I follow you - block size is directly related to the
> number of pages per block. You can't calculate one without the
> other...
> 
> /me goes back an looks at the code, finally it dawns on him that
> the bug is he's rounding to block size, not (block size >>
> PAGE_SHIFT). I'll fix that.
> 

Right.. and comparing it to range_end - range_start without conversion
as well.

> > IOW, an
> > integrity write isn't limited by page count since it's critical to flush
> > the specified range. Unless I'm misunderstanding how this field is used
> > in the writeback code, ISTM that there shouldn't be any need to muck
> > with nr_to_write here for the purposes of fsync.
> 
> Sorry, I thought you were asking about why were were rounding the
> range in general, not nr_to_write specifically.
> 

No worries.

> We don't need to modify nr_to_write for WB_SYNC_ALL,
> write_cache_pages() will not terminate on a nr_to_write expiry. So,
> unlike the range rounding, the nr_to_write rounding is really only
> for WB_SYNC_NONE.
> 

Ok, I was responding to the "fsync() on a single page range" use case,
but I see it wasn't clear I was asking specifically about ->nr_to_write
and not necessarily the broader change.

Then again, the commit log seems to focus on fsync exclusively, so some
more content could be included there at minimum.

> i.e. we round WB_SYNC_NONE to try to get whole blocks written so we
> don't end up with partially written blocks on disk for extended
> periods of time (e.g. between background writeback periods). It
> doesn't matter for WB_SYNC_ALL, but it will reduce the potential for
> stale data beign exposed when crashes occur and random pages in
> blocks have't been written back. i.e. it's to help iprevent
> re-exposing the problematic cases that we added the "NULL files
> after crash" workarounds for.
> 

Ok. I see that there are earlier patches to do zero-around on sub-block
writes, so the idea makes a bit more sense with that in mind. That said,
I still don't grok how messing with nr_to_write is effective.

For background writeback (WB_SYNC_NONE), the range fields are clamped
out (0-LONG_MAX) since the location of pages to write is not really a
concern. In that case, ->nr_to_write is set based on some bandwidth
heuristic and the only change we make here is to round it. If we
consider the fact that any mapping itself may consist of some
combination of zeroed-around delalloc blocks (covered by an aligned
number of dirty pages) and already allocated/overwrite blocks (covered
by any number of dirty pages), how does a rounded ->nr_to_write actually
help us at all? Can't the magic ->nr_to_write value that prevents
stopping at a partially written sub-block page be unaligned to the block
size?

For integrity writeback (WB_SYNC_ALL), the range rounding makes sense to
me. In that case, the appropriate range_start/end values are set and
->nr_to_write is LONG_MAX because we don't want to limit on a page
count. So we round out the range to help ensure we don't do any
sub-block writes and as already discussed, ->nr_to_write is irrelevant
here.

Given the above, I don't see how tweaking ->nr_to_write really helps at
all even as an optimization. Unless I'm missing something else in the
earlier patches that facilitate this, ISTM that something more explicit
is required if you want to increase the odds that zeroed-around blocks
are written together. For example, perhaps try to detect this further
down in the writepage callout if we're about to stop in a bad spot, use
something like the old xfs_convert_page() mechanism to handle N pages
per-callout, or (as Christoph suggested), try to incorporate this kind
of block alignment consideration into write_cache_pages() itself. For
the latter, perhaps we could add a mod/align field or some such to the
wbc that the fs can use to instruct writeback to consider bs > ps
alignment explicitly.

Brian

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
