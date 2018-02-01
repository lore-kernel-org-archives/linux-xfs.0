Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:34244 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751674AbeBAXXC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 1 Feb 2018 18:23:02 -0500
Date: Thu, 1 Feb 2018 15:22:58 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs: byte range buffer dirty region tracking
Message-ID: <20180201232258.GW4849@magnolia>
References: <20180201010514.30233-1-david@fromorbit.com>
 <20180201051128.GO4849@magnolia>
 <20180201081452.gaavuhnxafoafunm@destitution>
 <20180201203526.GR4849@magnolia>
 <20180201231647.qsiq6vnmllqc32le@destitution>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180201231647.qsiq6vnmllqc32le@destitution>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Fri, Feb 02, 2018 at 10:16:47AM +1100, Dave Chinner wrote:
> On Thu, Feb 01, 2018 at 12:35:26PM -0800, Darrick J. Wong wrote:
> > On Thu, Feb 01, 2018 at 07:14:52PM +1100, Dave Chinner wrote:
> > > On Wed, Jan 31, 2018 at 09:11:28PM -0800, Darrick J. Wong wrote:
> > > > On Thu, Feb 01, 2018 at 12:05:14PM +1100, Dave Chinner wrote:
> > > > > From: Dave Chinner <dchinner@redhat.com>
> > > > > 
> > > > > One of the biggest performance problems with large directory block
> > > > > sizes is the CPU overhead in maintaining the buffer log item direty
> > > > > region bitmap.  The bit manipulations and buffer region mapping
> > > > > calls are right at the top of the profiles when running tests on 64k
> > > > > directory buffers:
> > > .....
> > > > > ---
> > > > >  fs/xfs/xfs_buf.c      |   2 +
> > > > >  fs/xfs/xfs_buf_item.c | 431 +++++++++++++++++++++++++-------------------------
> > > > >  fs/xfs/xfs_buf_item.h |  19 +++
> > > > >  3 files changed, 238 insertions(+), 214 deletions(-)
> > > > > 
> > > > > diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> > > > > index d1da2ee9e6db..7621fabeb505 100644
> > > > > --- a/fs/xfs/xfs_buf.c
> > > > > +++ b/fs/xfs/xfs_buf.c
> > > > > @@ -1583,6 +1583,8 @@ xfs_buf_iomove(
> > > > >  		page = bp->b_pages[page_index];
> > > > >  		csize = min_t(size_t, PAGE_SIZE - page_offset,
> > > > >  				      BBTOB(bp->b_io_length) - boff);
> > > > > +		if (boff + csize > bend)
> > > > > +			csize = bend - boff;
> > > > 
> > > > How often does csize exceed bend?
> > > 
> > > /me checks notes when the patch was written a couple of years ago
> > > 
> > > Rarely. I didn't record the exact cause because it was a memory
> > > corruption bug that showed up long after the cause was gone.
> > > Reading between the lines, I think was a case where bsize was a
> > > single chunk (128 bytes), boff was 256 (third chunk in the buffer)
> > > b_io_length was 512 bytes and a page offset of ~512 bytes.
> > > 
> > > That means csize was coming out at 256 bytes, but we only wanted 128
> > > bytes to be copied. In most cases this didn't cause a problem
> > > because there was more space in the log iovec buffer being copied
> > > into, but occasionally it would be the last copy into the
> > > logvec buffer and that would overrun the user buffer and corrupt
> > > memory.
> > > 
> > > Essentially we are trying to copy from boff to bend, there's
> > > nothing in the loop to clamp the copy size to bend, and that's
> > > what this is doing. I can separate it out into another patch if you
> > > want - I'd completely forgotten this was in the patch because I've
> > > been running this patch in my tree for a long time now without
> > > really looking at it...
> > 
> > I don't know if this needs to be a separate patch, but it seems like the
> > upper levels shouldn't be sending us overlong lengths?  So either we
> > need to go find the ones that do and fix them to dtrt, possibly leaving
> > an assert here for "hey someone screwed up but we're fixing it"
> > analysis.
> 
> It was probably caused by a bug in the original range->bitmap
> conversion code I'd written, not by any of the external code. I'll
> add an assert into the code, but also leave the clamping so that
> production systems don't go bad if there's some other bug in the
> code that triggers it.
> 
> > > > > +	ASSERT(bip->bli_range[0].last != 0);
> > > > > +	if (bip->bli_range[0].last == 0) {
> > > > > +		/* clean! */
> > > > > +		ASSERT(bip->bli_range[0].first == 0);
> > > > 
> > > > Hm, so given that the firsts are initialized to UINT_MAX, this only
> > > > happens if the first (only?) range we log is ... (0, 0) ?
> > > 
> > > Yeah, basically it catches code that should not be logging buffers
> > > because there is no dirty range in the buffer.
> > > 
> > > > Mildly confused about what these asserts are going after, since the
> > > > first one implies that this shouldn't happen anyway.
> > > 
> > > If first is after last, then we've really screwed up because we've
> > > got a dirty buffer with an invalid range. I can't recall seeing
> > > either of these asserts fire, but we still need the check for clean
> > > buffer ranges/ screwups in production code. maybe there's a better
> > > way to do this?
> > 
> > I only came up with:
> > 
> > /*
> >  * If the first bli_range has a last of 0, we've been fed a clean
> >  * buffer.  This shouldn't happen but we'll be paranoid and check
> >  * anyway.
> >  */
> > if (bip->bli_range[0].last == 0) {
> > 	ASSERT(0);
> > 	ASSERT(bip->bli_range[0].first == 0);
> > 	return;
> > }
> 
> Yup, that's a bit cleaner, I'll change it over.
> 
> > FWIW I also ran straight into this when I applied it for giggles and ran
> > xfstests -g quick (generic/001 blew up):
> 
> I must have screwed up the forward port worse than usual - the
> conflicts with the xfs_buf_log_item typedef removal were pretty
> extensive.

Ah, sorry about that.  I'd thought it was just the xfs_buf rename. :/

> > [   31.909228] ================================================================================
> > [   31.911258] BUG: unable to handle kernel NULL pointer dereference at 00000000000000a0
> > [   31.912375] IP: xfs_buf_item_init+0x33/0x350 [xfs]
> 
> Hmmmm - I'm seeing that on my subvol smoke test script but not
> elsewhere. I've been looking through the subvol code to try to find
> this, maybe it's not the subvol code.  What mkfs parameters where
> you using?

mkfs.xfs -m rmapbt=1,reflink=1 -i sparse=1 /dev/pmem0

--D

> 
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
