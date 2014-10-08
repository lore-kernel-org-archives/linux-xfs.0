Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id E77EE7F3F
	for <xfs@oss.sgi.com>; Wed,  8 Oct 2014 09:24:26 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 1616BAC006
	for <xfs@oss.sgi.com>; Wed,  8 Oct 2014 07:24:26 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id kLCqknR9fIFrH9xx (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 08 Oct 2014 07:24:24 -0700 (PDT)
Date: Wed, 8 Oct 2014 10:24:14 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH v2] xfs: rework zero range to prevent invalid i_size
	updates
Message-ID: <20141008142414.GA30800@bfoster.bfoster>
References: <1412707548-46011-1-git-send-email-bfoster@redhat.com>
	<20141007214023.GR2301@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20141007214023.GR2301@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Wed, Oct 08, 2014 at 08:40:23AM +1100, Dave Chinner wrote:
> On Tue, Oct 07, 2014 at 02:45:48PM -0400, Brian Foster wrote:
> > The zero range operation is analogous to fallocate with the exception of
> > converting the range to zeroes. E.g., it attempts to allocate zeroed
> > blocks over the range specified by the caller. The XFS implementation
> > kills all delalloc blocks currently over the aligned range, converts the
> > range to allocated zero blocks (unwritten extents) and handles the
> > partial pages at the ends of the range by sending writes through the
> > pagecache.
> > 
> > The current implementation suffers from several problems associated with
> > inode size. If the aligned range covers an extending I/O, said I/O is
> > discarded and an inode size update from a previous write never makes it
> > to disk. Further, if an unaligned zero range extends beyond eof, the
> > page write induced for the partial end page can itself increase the
> > inode size, even if the zero range request is not supposed to update
> > i_size (via KEEP_SIZE, similar to an fallocate beyond EOF).
> > 
> > The latter behavior not only incorrectly increases the inode size, but
> > can lead to stray delalloc blocks on the inode. Typically, post-eof
> > preallocation blocks are either truncated on release or inode eviction
> > or explicitly written to by xfs_zero_eof() on natural file size
> > extension. If the inode size increases due to zero range, however,
> > associated blocks leak into the address space having never been
> > converted or mapped to pagecache pages. A direct I/O to such an
> > uncovered range cannot convert the extent via writeback and will BUG().
> > For example:
> > 
> > $ xfs_io -fc "pwrite 0 128k" -c "fzero -k 1m 54321" <file>
> > ...
> > $ xfs_io -d -c "pread 128k 128k" <file>
> > <BUG>
> > 
> > If the entire delalloc extent happens to not have page coverage
> > whatsoever (e.g., delalloc conversion couldn't find a large enough free
> > space extent), even a full file writeback won't convert what's left of
> > the extent and we'll assert on inode eviction.
> > 
> > Rework xfs_zero_file_space() to avoid buffered I/O for partial pages.
> > Align to blocksize rather than page size and use uncached buffers to
> > zero partial blocks. Preallocate the outward block-aligned range to
> > provide fallocate allocation semantics and convert the inward range to
> > unwritten extents to zero the range.
> > 
> > Signed-off-by: Brian Foster <bfoster@redhat.com>
> 
> comments below...
> 
> > +/*
> > + * Preallocate and zero a range of a file. This mechanism has the allocation
> > + * semantics of fallocate and in addition converts data in the range to zeroes.
> > + * This is done using unwritten extent conversion for complete blocks within the
> > + * range. Partial start/end blocks cannot be converted to unwritten as they
> > + * contain valid data. Therefore, partial blocks are preallocated and explicitly
> > + * zeroed on-disk.
> 
> If we don't modify the patch and continue with the uncached zeroing
> mechanism, we need to add a big warning about why we avoid the page
> cache for partial block zeroing. (i.e. to prevent ioend completions
> from updating inode size incorrectly and causing data corruption).
> 

Ok, I'll add a note on that here.

> >  	trace_xfs_zero_file_space(ip);
> >  
> > -	granularity = max_t(uint, 1 << mp->m_sb.sb_blocklog, PAGE_CACHE_SIZE);
> > +	blksize = 1 << mp->m_sb.sb_blocklog;
> 
> If we are now doing sub-page block manipulation, we have the issue
> with racing page faults failing to refault after the extent map has
> changed underneath partial pages. That, however, appears to be
> mostly mitigated by the partial page writeback.
> 
> >  
> >  	/*
> > -	 * Round the range of extents we are going to convert inwards.  If the
> > -	 * offset is aligned, then it doesn't get changed so we zero from the
> > -	 * start of the block offset points to.
> > +	 * Align the range inward to blocksize. This represents the range that
> > +	 * can be converted to unwritten extents.
> >  	 */
> > -	start_boundary = round_up(offset, granularity);
> > -	end_boundary = round_down(offset + len, granularity);
> > +	start_boundary = round_up(offset, blksize);
> > +	end_boundary = round_down(offset + len, blksize);
> >  
> >  	ASSERT(start_boundary >= offset);
> >  	ASSERT(end_boundary <= offset + len);
> >  
> > -	if (start_boundary < end_boundary - 1) {
> > -		/*
> > -		 * Writeback the range to ensure any inode size updates due to
> > -		 * appending writes make it to disk (otherwise we could just
> > -		 * punch out the delalloc blocks).
> > -		 */
> > -		error = filemap_write_and_wait_range(VFS_I(ip)->i_mapping,
> > -				start_boundary, end_boundary - 1);
> > +	/*
> > +	 * We generally want to avoid writeback here but must take a few things
> > +	 * into consideration. If the eof page falls within the aligned range,
> > +	 * write it back so we don't lose i_size updates. Also writeback
> > +	 * unaligned start/end pages to avoid races with uncached I/O.
> > +	 */
> > +	eof = round_down(i_size_read(VFS_I(ip)) - 1, PAGE_CACHE_SIZE);
> > +	if (eof >= start_boundary && eof <= end_boundary)
> > +		filemap_write_and_wait_range(VFS_I(ip)->i_mapping, eof, -1);
> 
> That's only necessary if (VFS_I(ip)->i_size > ip->i_d.di_size),
> right?. i.e. it's only needed if there are extending writes still
> pending writeback that will update the on-disk inode size (see
> xfs_setattr_size() for details).
> 

Yes, that's true. I can update the logic there.

> > +	if (!PAGE_ALIGNED(offset) || !PAGE_ALIGNED(offset + len)) {
> > +		filemap_write_and_wait_range(VFS_I(ip)->i_mapping, offset,
> > +					     start_boundary);
> > +		filemap_write_and_wait_range(VFS_I(ip)->i_mapping, end_boundary,
> > +					     offset + len);
> > +	}
> 
> If the offset and/or (offset+len) are beyond EOF, we need to write
> them as ->writepage will see that they are beyond EOF and abort.
> Hence I'd split this into separate check+flush start, check+flush
> end branches that also check whether they are beyond EOF or in the
> EOF page we've already written.
> 

I assume you meant to say we don't need to write them, which makes
sense. That said, I'm not sure I see the benefit of adding code to
detect scenarios that are already correctly handled. E.g., the pages
don't need to be written back, so they won't be.

It's also just as possible that offset and offset+len fall into the same
page and we call writeback twice. I believe I originally had the
start/end checks as separate checks and combined them at some point just
to keep things simple (e.g., we have to do I/O anyways if one of the
start of end is unaligned). I can break it back up into independent
checks, but I'm hesitant to sprinkle more logic just to prevent things
like calling filemap_write_and_wait_range() one time too many to no
practical benefit.

> > +	/*
> > +	 * Punch out the pagecache and delalloc extents in the range.
> > +	 * truncate_pagecache_range() handles partial page zeroing for us.
> > +	 */
> > +	truncate_pagecache_range(VFS_I(ip), offset, offset + len - 1);
> > +	if (end_boundary > start_boundary) {
> > +		xfs_ilock(ip, XFS_ILOCK_EXCL);
> > +		error = xfs_bmap_punch_delalloc_range(ip,
> > +				XFS_B_TO_FSBT(mp, start_boundary),
> > +				XFS_B_TO_FSB(mp,
> > +					     end_boundary - start_boundary));
> > +		xfs_iunlock(ip, XFS_ILOCK_EXCL);
> > +	}
> 
> I see this if (end_boundary > start_boundary) check repeatedly - if
> this case is true, we are zeroing within a single block. If that
> block is within EOF, then all we need to do is call xfs_iozero() and
> we are done. Perhaps we should special case this right at the start
> of the function (similar to the special sub-single-block case in
> xfs_free_file_space()).
> 

The boundary variables are rounded "inward" to block alignment. The 'if
(end_boundary > start_boundary)' check means that the range covers one
or more full blocks.

We could add an optimization for the single/double block case as the
original implementation had, but I'd prefer to do that as a separate
patch considering the amount of testing I've done with this
implementation so far.

> > +
> > +	/*
> > +	 * Now handle start and end sub-block zeroing. We do this before
> > +	 * allocation because we want the blocks on disk consistent with
> > +	 * pagecache if we hit ENOSPC.
> > +	 */
> > +	if (offset < start_boundary) {
> > +		/* don't go past the end offset if it's within the block */
> > +		endoffset = min_t(xfs_off_t, start_boundary, offset + len);
> > +
> > +		error = xfs_zero_remaining_bytes(ip, offset, endoffset - 1);
> >  		if (error)
> >  			goto out;
> > -		truncate_pagecache_range(VFS_I(ip), start_boundary,
> > -					 end_boundary - 1);
> > +	}
> > +	if (end_boundary >= start_boundary && offset + len > end_boundary) {
> > +		error = xfs_zero_remaining_bytes(ip, end_boundary,
> > +						 offset + len - 1);
> > +		if (error)
> > +			goto out;
> > +	}
> 
> So this means we now write the partial start/end blocks twice - once
> to clean the page cache, then once to zero the blocks on disk.
> Again, this does not need to happen if the start/end is beyond EOF,
> as a truncate up will completely zero the underlying blocks if that
> are allocated and in the written state.
> 

Not exactly...

I'll echo my previous sentiment with regard to keeping this simple. I'm
not against follow-on optimizations to take better consideration of eof,
to add an xfs_iozero() short-circuit, etc., but this took enough
finagling and debugging to try and get right that I'd really prefer to
keep this first version as simple as possible.

> Hence I'm not sure that we actually need to do it this way. If we
> do this:
> 
> 	if (isize needs update)
> 		filemap_write_and_wait_range(eof_block)
> 	truncate_pagecache_range(start, end)
> 	if (partial_and_within_eof(start_page))
> 		filemap_write_and_wait_range(start_page)
> 	if (partial_and_within_eof(end_page))
> 		filemap_write_and_wait_range(end_page)
> 	xfs_bmap_punch_delalloc_range(start, end)
> 
> We should get the partial blocks correctly zeroed in the page cache,
> then the correctly zeroed pages written to disk, and then we punch
> out the delalloc blocks in the middle, thereby zeroing the in-memory
> extent tree to match the pagecache after the truncation we just did.
> 

This will probably reproduce an fsx data corruption failure.
truncate_pagecache_range() will not read the page on a miss nor mark it
dirty if it's currently clean AFAICT. If the pages happen to be cached
and clean, we'd read what we expect until they are evicted and have to
go back to disk. If they aren't cached, we'd still skip the on-disk
update and probably detect it sooner. If they are cached and dirty, then
perhaps that will work.

So this is the reason for the current order: partial writeback, fix up
pagecache, kill delalloc extents and update partial blocks on disk. I'm
trying to document as much as possible in comments. Perhaps I should
update the associated comment to make that bit more clear?

FWIW, tracking down these kind of fsx issues is also why I'm
particularly conservative about this patch at this point. I've played
with various combinations of cache management and sub-block zeroing and
had to track down numerous problems to try and get that part working.
I've not been able to reproduce any corruption issues and I haven't seen
a delalloc assert in ~450 some odd iterations of generic/269 on a setup
that typically reproduces within 10-30 iterations. I did finally hit a
getbmap delalloc assert, but I'm pretty sure I've seen that one for
normal post-eof preallocation, e.g., not indicative of stray delalloc
within eof.

> >  
> > -		/* convert the blocks */
> > +	/*
> > +	 * Finally, preallocate the unaligned range and convert the block
> > +	 * aligned range to unwritten. We attempt extent conversion even if
> > +	 * prealloc fails to convert as many existing extents as possible.
> > +	 */
> > +	error = xfs_alloc_file_space(ip, round_down(offset, blksize),
> > +				     round_up(offset + len, blksize) - 1,
> > +				     XFS_BMAPI_PREALLOC);
> > +	if (end_boundary > start_boundary)
> >  		error = xfs_alloc_file_space(ip, start_boundary,
> >  					end_boundary - start_boundary - 1,
> >  					XFS_BMAPI_PREALLOC | XFS_BMAPI_CONVERT);
> 
> That doesn't make a lot of sense - apart from the different
> start/end offsets - if the initial xfs_alloc_file_space() call fails
> with ENOSPC, the second call will too because it will try to pick up
> unwritten extent allocation where the first call failed with ENOSPC.
> i.e. it will fail with ENOSPC, too, at the same place. One call is
> all that is needed, and if we special case the (end_boundary >
> start_boundary) condition early on then there's only one range
> needed here.
> 

The different offsets are intentional because the first call does the
allocation and the second does unwritten conversion. We want to make
sure the partial/edge blocks are allocated but they cannot be converted
to unwritten, so both calls are necessary. If you take a look back at
v1, this basically reduces three alloc calls down to two in a manner
that still does allocation linearly.

Note that I did reproduce failures last night in generic/009 and
xfs/242 that point out the length parameter in the first call is wrong.
It passes the end offset rather than length.

I expect for the second call to hit ENOSPC if the first one has. The
reasoning here is that even though the allocation fails, we could still
run though and convert some of the range up until we hit the point of
allocation failure.

Put another way, what I'd really like here is an
xfs_bmap_convert_range() function that iterates similar to
xfs_bmap_punch_delalloc_range() but converts all existing normal extents
to unwritten without doing any block allocation. This means we could
convert the range to zero value and put off preallocation (and the
possibility of ENOSPC) to the absolute final step. That in turn means
that even on ENOSPC, we'll have always zero-valued the range.

That was also something I was considering looking into once this patch
is merged. If the current logic is too ugly or I'm misjudging behavior,
I could just wait until said helper exists and return immediately on
allocation failure for now. Thoughts?

Brian

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
