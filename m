Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:58008 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751168AbdJLXWY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 12 Oct 2017 19:22:24 -0400
Date: Fri, 13 Oct 2017 10:22:21 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] [RFC] xfs: make xfs_writepage_map extent map centric
Message-ID: <20171012232221.GV15067@dastard>
References: <20171011081131.8029-1-david@fromorbit.com>
 <20171012161433.GA40005@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171012161433.GA40005@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Thu, Oct 12, 2017 at 12:14:37PM -0400, Brian Foster wrote:
> On Wed, Oct 11, 2017 at 07:11:31PM +1100, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > xfs_writepage_map() iterates over the bufferheads on a page to decide
> > what sort of IO to do and what actions to take. However, when it comes
> > to reflink and deciding when it needs to execute a COW operation, we no
> > longer look at the bufferhead state but instead we ignore than and look up
> > internal state held in teh COW fork extent list.

[....]
> > 
> > This patch has smoke tested ok on 1k and 4k block filesystems with and without
> > reflink enabled, so it seems solid enough for initial comments to be made. Next
> > step is to get some kind of generation count or seqlock based cached map
> > invalidation into this code now that it's all unified.
> > 
> > Signed-Off-By: Dave Chinner <dchinner@redhat.com>
> > ---
> 
> This seems sane to me on a first look. You may be planning this anyways
> since this is an RFC, but could we split up the patches into separate
> logical changes? For example, folding xfs_map_cow() into
> xfs_map_blocks() seems like it could be a separate patch.

Yeah, I intend to split it up for review and submission. I generally
just write a big single patch first to get the code into the right
shape and working first, then worry about how to split it sanely for
review. That way I don't waste time generating patches that have
to be completely reworked after an initial RFC...

> > +	xfs_ilock(ip, XFS_ILOCK_SHARED);
> > +	ASSERT(ip->i_d.di_format != XFS_DINODE_FMT_BTREE ||
> > +	       (ip->i_df.if_flags & XFS_IFEXTENTS));
> > +	ASSERT(offset <= mp->m_super->s_maxbytes);
> > +
> > +	if (xfs_is_reflink_inode(XFS_I(inode)))
> > +		is_cow = xfs_reflink_find_cow_mapping(ip, offset, imap);
> > +
> 
> Maybe do something like the following here:
> 
> 		if (is_cow) {
> 			*type = XFS_IO_COW;
> 			goto do_alloc;
> 		}
> 
> ... so we can reduce the indentation of the large !cow hunk below?

Yup, this whole function could do with a bit of factoring :P

> 
> > -	/*
> > -	 * Else we need to check if there is a COW mapping at this offset.
> > -	 */
> > -	xfs_ilock(ip, XFS_ILOCK_SHARED);
> > -	is_cow = xfs_reflink_find_cow_mapping(ip, offset, &imap);
> > +	trace_printk("ino 0x%llx: type %d, null %d, startoff 0x%llx\n",
> > +			(long long)inode->i_ino, *type,
> > +			isnullstartblock(imap->br_startblock),
> > +			imap->br_startoff);
> >  	xfs_iunlock(ip, XFS_ILOCK_SHARED);
> > +	if (error)
> > +		return error;
> >  
> > -	if (!is_cow)
> > -		return 0;
> > +	if (isnullstartblock(imap->br_startblock)) {
> > +		int	whichfork = 0;
> >  
> > -	/*
> > -	 * And if the COW mapping has a delayed extent here we need to
> > -	 * allocate real space for it now.
> > -	 */
> > -	if (isnullstartblock(imap.br_startblock)) {
> > -		error = xfs_iomap_write_allocate(ip, XFS_COW_FORK, offset,
> > -				&imap);
> > -		if (error)
> > -			return error;
> > +		switch (*type) {
> > +		case XFS_IO_DELALLOC:
> > +			whichfork = XFS_DATA_FORK;
> > +			break;
> > +		case XFS_IO_COW:
> > +			whichfork = XFS_COW_FORK;
> > +			break;
> 
> The logic seems a little verbose here. Could we set whichfork =
> XFS_COW_FORK in the same hunk I suggested adding above? Initialize
> whichfork to XFS_DATA_FORK at the top of the function and that covers
> the above two cases.

*nod*

> 
> > +		case XFS_IO_HOLE:
> > +			/* nothing to do! */
> > +			trace_xfs_map_blocks_found(ip, offset, count, *type, imap);
> > +			return 0;
> 
> I'm a little confused about this case. How can this happen, and why do
> we use the _blocks_found() tracepoint?

isnullstartblock() evaluates as true for HOLESTARTBLOCK, which we
mapped above in the !COW case. I just reused the tracepoint as a
quick and dirty method of tracing that holes were being mapped
properly via the type field.

> > +		default:
> > +			ASSERT(0);
> > +			return -EFSCORRUPTED;
> > +		}
> 
> Previous question aside, it looks like doing something like:

This caught quite a few bugs as I developed the patch :P

> 
> 	if (isnullstartblock(..) &&
> 	    (*type == XFS_IO_DELALLOC || *type == XFS_IO_COW)) {
> 		...
> 	}
> 
> ... and doing some of the corruption checks separately could then
> eliminate this switch statement entirely.

Yeah, it can definitely be cleaned up - handling the non-allocation
case first would also help a lot....


> > @@ -883,89 +900,93 @@ xfs_writepage_map(
> >  	struct writeback_control *wbc,
> >  	struct inode		*inode,
> >  	struct page		*page,
> > -	loff_t			offset,
> >  	uint64_t              end_offset)
> >  {
> >  	LIST_HEAD(submit_list);
> >  	struct xfs_ioend	*ioend, *next;
> > -	struct buffer_head	*bh, *head;
> > +	struct buffer_head	*bh;
> >  	ssize_t			len = i_blocksize(inode);
> >  	int			error = 0;
> >  	int			count = 0;
> > -	int			uptodate = 1;
> > -	unsigned int		new_type;
> > +	bool			uptodate = true;
> > +	loff_t			file_offset;	/* file offset of page */
> > +	int			poffset;	/* offset into page */
> >  
> > -	bh = head = page_buffers(page);
> > -	offset = page_offset(page);
> > -	do {
> > -		if (offset >= end_offset)
> > +	/*
> > +	 * walk the blocks on the page, and we we run off then end of the
> > +	 * current map or find the current map invalid, grab a new one.
> > +	 * We only use bufferheads here to check per-block state - they no
> > +	 * longer control the iteration through the page. This allows us to
> > +	 * replace the bufferhead with some other state tracking mechanism in
> > +	 * future.
> > +	 */
> > +	file_offset = page_offset(page);
> > +	bh = page_buffers(page);
> > +	for (poffset = 0;
> > +	     poffset < PAGE_SIZE;
> > +	     poffset += len, file_offset += len, bh = bh->b_this_page) {
> > +
> > +		/* past the range we are writing, so nothing more to write. */
> > +		if (file_offset >= end_offset)
> >  			break;
> ...
> > +
> > +		if (!wpc->imap_valid || wpc->io_type == XFS_IO_HOLE) {
> > +			/*
> > +			 * set_page_dirty dirties all buffers in a page, independent
> > +			 * of their state.  The dirty state however is entirely
> > +			 * meaningless for holes (!mapped && uptodate), so check we did
> > +			 * have a buffer covering a hole here and continue.
> > +			 */
> > +			ASSERT(!buffer_mapped(bh));
> > +			continue;
> >  		}
> 
> IIRC, the old (broken) write over hole situation would allocate a block,
> potentially yell about a block reservation overrun and ultimately write
> the page.

Which was [always] the wrong thing to do.

However, we were forced to do this historically because it covered
bugs and deficiencies in the front end mapping code, such as before
we had ->page_mkwrite notification. In those ancient times, mmap()
could not do delayed allocation or discover unwritten extents
correctly.  So back in those days we had to do unreserved
allocations in writeback and risk transaction overruns and ENOSPC in
writeback because mmap writes were unable to do the right thing.

Nowdays, we've closed off all those issues and the only situation we
can get unreserved allocation into a hole is when we've got a
mismatch between bufferhead and extent state. This should never
happen anymore, and silently allocating blocks for ranges that may
or may not have valid data in them and writing it to disk is
exactly the wrong thing to be doing now.

> Now it looks like we silently (aside from the assert on dev
> kernels) skip the writeback and clean the page.

Which, IMO, is correct behaviour - the old code danced around this
because we couldn't easily answer the question of "what to do when
we have a bufferhead state vs extent map mismatch?".

All we care about now is "does the block have valid data" and "does
the extent map say we can write it". By the time we get here, we've
already skipped blocks that don't have valid data, and the checks
above say "we can't write this data because it's a hole". The reason
it has valid data is that has been previously read - which is pretty
common and most definitely exercised by fstests - so we silently
skip it.

One of the benefits of this change is that we remove these
ambiguities from the writeback code. If we get fed crap in the
writeback code, then we've got a bug in the front end iomap code...

> Unless I've missed that
> being handled somewhere, that seems like a slightly more severe error
> from the user perspective. Perhaps we should have a noiser warning here
> or even consider that a writeback error?

No, because it's a valid state to have cached data over a hole if
it's been read. Hence the assert to ensure what we got was from a
previous read into a hole - if a mod we make to the higher level
code screws up, we'll catch it pretty quickly during testing...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
