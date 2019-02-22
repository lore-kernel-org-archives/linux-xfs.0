Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35704 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725892AbfBVPUS (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 22 Feb 2019 10:20:18 -0500
Date: Fri, 22 Feb 2019 10:20:16 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 5/8] xfs: merge COW handling into
 xfs_file_iomap_begin_delay
Message-ID: <20190222152015.GA56290@bfoster>
References: <20190218091827.12619-1-hch@lst.de>
 <20190218091827.12619-6-hch@lst.de>
 <20190221175903.GB51494@bfoster>
 <20190222142058.GB2484@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190222142058.GB2484@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Fri, Feb 22, 2019 at 03:20:58PM +0100, Christoph Hellwig wrote:
> On Thu, Feb 21, 2019 at 12:59:03PM -0500, Brian Foster wrote:
> > On Mon, Feb 18, 2019 at 10:18:24AM +0100, Christoph Hellwig wrote:
> > > Besides simplifying the code a bit this allows to actually implement
> > > the behavior of using COW preallocation for non-COW data mentioned
> > > in the current comments.
> > > 
> > > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > > ---
> > 
> > Heh, I'm somewhat amused by the fact that I sent a variant of this patch
> > two years ago (for a different purpose) and you explicitly complained
> > about the factoring. I'm glad you've finally come around. ;)
> > 
> > https://marc.info/?l=linux-xfs&m=149498124730442&w=2
> 
> 
> 
> > 
> > >  fs/xfs/xfs_iomap.c   | 133 ++++++++++++++++++++++++++++++-------------
> > >  fs/xfs/xfs_reflink.c |  67 ----------------------
> > >  fs/xfs/xfs_reflink.h |   2 -
> > >  fs/xfs/xfs_trace.h   |   3 -
> > >  4 files changed, 94 insertions(+), 111 deletions(-)
> > > 
> > > diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
> > > index 19a3331b4a56..c9fd1e4a1f99 100644
> > > --- a/fs/xfs/xfs_iomap.c
> > > +++ b/fs/xfs/xfs_iomap.c
> > ...
> > > @@ -568,51 +569,92 @@ xfs_file_iomap_begin_delay(
> > >  
> > >  	end_fsb = min(XFS_B_TO_FSB(mp, offset + count), maxbytes_fsb);
> > >  
> > > -	eof = !xfs_iext_lookup_extent(ip, ifp, offset_fsb, &icur, &got);
> > > +	/*
> > > +	 * Search the data fork fork first to look up our source mapping.  We
> > > +	 * always need the data fork map, as we have to return it to the
> > > +	 * iomap code so that the higher level write code can read data in to
> > > +	 * perform read-modify-write cycles for unaligned writes.
> > > +	 */
> > > +	eof = !xfs_iext_lookup_extent(ip, &ip->i_df, offset_fsb, &icur, &imap);
> > >  	if (eof)
> > > -		got.br_startoff = end_fsb; /* fake hole until the end */
> > > +		imap.br_startoff = end_fsb; /* fake hole until the end */
> > > +
> > > +	/* We never need to allocate blocks for zeroing a hole. */
> > > +	if ((flags & IOMAP_ZERO) && imap.br_startoff > offset_fsb) {
> > > +		xfs_hole_to_iomap(ip, iomap, offset_fsb, imap.br_startoff);
> > > +		goto out_unlock;
> > > +	}
> > > +
> > 
> > So does this need to account for the case of an overlapping cow block
> > over a hole in the data fork (with cached data, if that is possible)?
> > IIUC we introduce that possibility just below.
> 
> Yes, it probably should, although I need to find a reproducer for that
> first. 
> 

See my other reply. I don't think it's currently reproducible, but it
does technically break the iomap_zero_range() mechanism.

> > > +		 * We cap the maximum length we map here to MAX_WRITEBACK_PAGES
> > > +		 * pages to keep the chunks of work done where somewhat
> > > +		 * symmetric with the work writeback does.  This is a completely
> > > +		 * arbitrary number pulled out of thin air.
> > > +		 *
> > > +		 * Note that the values needs to be less than 32-bits wide until
> > > +		 * the lower level functions are updated.
> > > +		 */
> > > +		count = min_t(loff_t, count, 1024 * PAGE_SIZE);
> > > +		end_fsb = min(XFS_B_TO_FSB(mp, offset + count), maxbytes_fsb);
> > 
> > The existing code doesn't currently do this but ISTM this should apply
> > to either allocation case, not just data fork delalloc. That could be
> > something for a separate patch though.
> 
> I wonder if we need to keep this cap at all, we apply it very
> inconsistently through the writeback path.
> 

Perhaps we can just kill it off then.

> > > @@ -659,9 +703,20 @@ xfs_file_iomap_begin_delay(
> > >  	 * them out if the write happens to fail.
> > >  	 */
> > >  	iomap->flags |= IOMAP_F_NEW;
> > 
> > This looks like it flags the mapping new if we reserve cow blocks, which
> > I don't think is quite right.
> 
> To some extent marking it as new makes a lot of sense, especially if
> allocating to a hole.  But we probably only want it for that latter
> case.
> 

The allocation over a hole case makes more sense to me, but there's also
the case of cow fork delalloc over data fork delalloc. I think we need
some explicit definition of expected behavior here, not to just set the
flag based on what the current error handler happens to do. Perhaps that
might involve fixing up the error handling context to deal with the cow
fork as well.

> > 
> > > -	trace_xfs_iomap_alloc(ip, offset, count, XFS_DATA_FORK, &got);
> > > +	trace_xfs_iomap_alloc(ip, offset, count, whichfork,
> > > +			whichfork == XFS_DATA_FORK ? &imap : &cmap);
> > >  done:
> > > -	error = xfs_bmbt_to_iomap(ip, iomap, &got, false);
> > > +	if (whichfork == XFS_COW_FORK) {
> > > +		if (imap.br_startoff > offset_fsb) {
> > > +			xfs_trim_extent(&cmap, offset_fsb,
> > > +					imap.br_startoff - offset_fsb);
> > > +			error = xfs_bmbt_to_iomap(ip, iomap, &cmap, false);
> > > +			goto out_unlock;
> > > +		}
> > 
> > Hmm, so this looks like it is in fact handling a COW blocks over a hole
> > case, pushing the COW mapping into the iomap. We never accounted for
> > that case before where we'd always just allocate to the data fork. The
> > change in behavior probably makes sense, but this really should be
> > separate from the refactoring bits to reuse the data fork delalloc code.
> > Beyond making this a bit easier to follow, it warrants its own commit
> > log description and this one makes no mention of it at all.
> 
> Look at the last sentence of the commit log..

Ok. I didn't follow that the first time I read it because I thought it
referred to handling COW overlap in writeback, which we already do. It
wasn't until seeing the code (and the in-line comment) and
distinguishing that from the refactoring bits that I realized this
allows for use of existing cow blocks over data fork holes.

So it's not fair to say the commit log doesn't mention it at all, but I
still think that this should have been separate from code reuse
refactoring and warrants more explanation and description than a single
sentence. At minimum, the commit log should describe the current
behavior, the change in behavior and the reason for changing it.

Of course, I guess this is merged now so it doesn't really matter..

Brian
