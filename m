Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42330 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752004AbdJPMR4 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 16 Oct 2017 08:17:56 -0400
Date: Mon, 16 Oct 2017 08:17:54 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] [RFC] xfs: make xfs_writepage_map extent map centric
Message-ID: <20171016121754.GD58994@bfoster.bfoster>
References: <20171011081131.8029-1-david@fromorbit.com>
 <20171012161433.GA40005@bfoster.bfoster>
 <20171012232221.GV15067@dastard>
 <20171013131347.GB44461@bfoster.bfoster>
 <20171014222532.GB15067@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171014222532.GB15067@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Sun, Oct 15, 2017 at 09:25:32AM +1100, Dave Chinner wrote:
> On Fri, Oct 13, 2017 at 09:13:48AM -0400, Brian Foster wrote:
> > On Fri, Oct 13, 2017 at 10:22:21AM +1100, Dave Chinner wrote:
> > > On Thu, Oct 12, 2017 at 12:14:37PM -0400, Brian Foster wrote:
> > > > On Wed, Oct 11, 2017 at 07:11:31PM +1100, Dave Chinner wrote:
> > > > > From: Dave Chinner <dchinner@redhat.com>
> > > > > 
> > > > > xfs_writepage_map() iterates over the bufferheads on a page to decide
> > > > > what sort of IO to do and what actions to take. However, when it comes
> > > > > to reflink and deciding when it needs to execute a COW operation, we no
> > > > > longer look at the bufferhead state but instead we ignore than and look up
> > > > > internal state held in teh COW fork extent list.
> > > 
> > > [....]
> > > 
> > > > > +
> > > > > +		if (!wpc->imap_valid || wpc->io_type == XFS_IO_HOLE) {
> > > > > +			/*
> > > > > +			 * set_page_dirty dirties all buffers in a page, independent
> > > > > +			 * of their state.  The dirty state however is entirely
> > > > > +			 * meaningless for holes (!mapped && uptodate), so check we did
> > > > > +			 * have a buffer covering a hole here and continue.
> > > > > +			 */
> > > > > +			ASSERT(!buffer_mapped(bh));
> > > > > +			continue;
> > > > >  		}
> > > > 
> > > > IIRC, the old (broken) write over hole situation would allocate a block,
> > > > potentially yell about a block reservation overrun and ultimately write
> > > > the page.
> > > 
> > > Which was [always] the wrong thing to do.
> > > 
> > > However, we were forced to do this historically because it covered
> > > bugs and deficiencies in the front end mapping code, such as before
> > > we had ->page_mkwrite notification. In those ancient times, mmap()
> > > could not do delayed allocation or discover unwritten extents
> > > correctly.  So back in those days we had to do unreserved
> > > allocations in writeback and risk transaction overruns and ENOSPC in
> > > writeback because mmap writes were unable to do the right thing.
> > > 
> > > Nowdays, we've closed off all those issues and the only situation we
> > > can get unreserved allocation into a hole is when we've got a
> > > mismatch between bufferhead and extent state. This should never
> > > happen anymore, and silently allocating blocks for ranges that may
> > > or may not have valid data in them and writing it to disk is
> > > exactly the wrong thing to be doing now.
> > > 
> > 
> > "This should never happen ..."
> > 
> > Famous last words? ;) 
> > 
> > Yeah, I understand it's a broken case, but I'm slightly concerned over
> > the fact that it has happened in the past due to filesystem bugs. I
> > think due to more than one problem as well, but my memory is hazy.
> > 
> > Note that I'm not suggesting we go ahead and write the page like we used
> > to do, but rather that we at least have a defensive check for a
> > discrepancy between pagecache state that suggests a buffer is dirty and
> > extent state says there is no place to write.
> 
> This code does not checking against "buffer_dirty" because we've
> never done that in the writeback path - we've always written clean,
> uptodate, mapped sub-page buffers if the page is dirty.
> 
> So the only case left to defend against here is mapped buffers over
> a hole or an invalid extent. The writeback path currently checks
> that doesn't happen with an ASSERT(), and the code above retains
> that ASSERT(). It will go away completely when we move away from
> bufferheads....
> 
> > If so, throw a warning
> > (either xfs_alert() or WARN_ON()) to indicate something went wrong
> > because we tossed a dirty page without writing it anywhere. In other
> > words, all I'm really saying here is that I don't think an assert is
> > good enough.
> 
> It's the same as what we've always had to defend against this "we
> fucked up the higher layer mapping" type of bug. I'm not creating
> any new situation here, so I don't think it warrants a new warning
> that will simply go away with bufferheads...
> 

Ok, then it may not be ideal to rely on the buffer_head to detect the
error.

> > > > Unless I've missed that
> > > > being handled somewhere, that seems like a slightly more severe error
> > > > from the user perspective. Perhaps we should have a noiser warning here
> > > > or even consider that a writeback error?
> > > 
> > > No, because it's a valid state to have cached data over a hole if
> > > it's been read. Hence the assert to ensure what we got was from a
> > > previous read into a hole - if a mod we make to the higher level
> > > code screws up, we'll catch it pretty quickly during testing...
> > 
> > We should be able to distinguish between page/buffer state that
> > indicates we have valid data over a hole vs. valid+dirty data over a
> > hole in order to flag the latter as a problem.
> 
> Except that, as above, we treat clean/dirty data exactly the same in
> writepage - we write it if it's mapped over a valid extent. The code
> catches the only case left that is invalid and it doesn't matter if
> the buffer is clean or dirty - in both cases it is invalid....
> 

This is simply not the case as it pertains to how the current code deals
with holes. Initially I was thinking we still quietly wrote the page,
but that is incorrect too. Christoph added the XFS_BMAPI_DELALLOC flag
in commit d2b3964a ("xfs: fix COW writeback race") that alters this
behavior.

The current behavior of the broken dirty page over a hole case is that
we no longer silenty attempt a hole -> real allocation. Instead,
writeback fails with -EIO. With this patch, that exact same broken case
fails the assert, but otherwise skips the dirty page without any error
or notification to userspace. IOW, by skipping the
iomap_write_allocate() code unconditionally we've effectively removed an
error check and made the pre-existing assert logic responsible for it.

So regardless of what specific buffer state checks pre-existed or not,
this patch subtly changes an existing error condition to an assertion
without any explicit intent/justification. I can understand not wanting
to add new logic related to buffer heads, but I don't think "buffer
heads suck" is a good enough reason alone to just drop the error. The
safer approach is to retain the error so that it's clear we need to find
a better way to detect it before we eliminate buffer_heads.

It would be nice if we could just rely on the page state to detect the
error. For example, is there any real non-erroneous case for having a
dirty page completely over a hole within EOF of a file? Unfortunately
that doesn't help us in the sub-page blocksize case where some of the
page might be valid, but perhaps that is a reasonable compromise. If so,
I think that should be part of a patch that actually eliminates
buffer_heads rather than reworking writepage because it at least gives
us more time to think about the problem.

Brian

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
