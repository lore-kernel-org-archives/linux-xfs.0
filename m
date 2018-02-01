Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:4771 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751245AbeBAIN7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 1 Feb 2018 03:13:59 -0500
Date: Thu, 1 Feb 2018 19:14:52 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: byte range buffer dirty region tracking
Message-ID: <20180201081452.gaavuhnxafoafunm@destitution>
References: <20180201010514.30233-1-david@fromorbit.com>
 <20180201051128.GO4849@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180201051128.GO4849@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Wed, Jan 31, 2018 at 09:11:28PM -0800, Darrick J. Wong wrote:
> On Thu, Feb 01, 2018 at 12:05:14PM +1100, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > One of the biggest performance problems with large directory block
> > sizes is the CPU overhead in maintaining the buffer log item direty
> > region bitmap.  The bit manipulations and buffer region mapping
> > calls are right at the top of the profiles when running tests on 64k
> > directory buffers:
.....
> > ---
> >  fs/xfs/xfs_buf.c      |   2 +
> >  fs/xfs/xfs_buf_item.c | 431 +++++++++++++++++++++++++-------------------------
> >  fs/xfs/xfs_buf_item.h |  19 +++
> >  3 files changed, 238 insertions(+), 214 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> > index d1da2ee9e6db..7621fabeb505 100644
> > --- a/fs/xfs/xfs_buf.c
> > +++ b/fs/xfs/xfs_buf.c
> > @@ -1583,6 +1583,8 @@ xfs_buf_iomove(
> >  		page = bp->b_pages[page_index];
> >  		csize = min_t(size_t, PAGE_SIZE - page_offset,
> >  				      BBTOB(bp->b_io_length) - boff);
> > +		if (boff + csize > bend)
> > +			csize = bend - boff;
> 
> How often does csize exceed bend?

/me checks notes when the patch was written a couple of years ago

Rarely. I didn't record the exact cause because it was a memory
corruption bug that showed up long after the cause was gone.
Reading between the lines, I think was a case where bsize was a
single chunk (128 bytes), boff was 256 (third chunk in the buffer)
b_io_length was 512 bytes and a page offset of ~512 bytes.

That means csize was coming out at 256 bytes, but we only wanted 128
bytes to be copied. In most cases this didn't cause a problem
because there was more space in the log iovec buffer being copied
into, but occasionally it would be the last copy into the
logvec buffer and that would overrun the user buffer and corrupt
memory.

Essentially we are trying to copy from boff to bend, there's
nothing in the loop to clamp the copy size to bend, and that's
what this is doing. I can separate it out into another patch if you
want - I'd completely forgotten this was in the patch because I've
been running this patch in my tree for a long time now without
really looking at it...

[...]


> > @@ -136,7 +98,9 @@ xfs_buf_item_size(
> >  	int			*nbytes)
> >  {
> >  	struct xfs_buf_log_item	*bip = BUF_ITEM(lip);
> > -	int			i;
> > +	struct xfs_buf	*bp = bip->bli_buf;
> 
> Indentation before '*bp'...

Ah, missed that on conflict resolution from the buf_log_item
typedef removal...

> > -	 * written.
> > +	 * buffers we need to track which segment the dirty ranges correspond
> > +	 * to, and when we move from one segment to the next increment the
> > +	 * vector count for the extra buf log format structure that will need to
> > +	 * be written.
> >  	 */
> > -	for (i = 0; i < bip->bli_format_count; i++) {
> > -		xfs_buf_item_size_segment(bip, &bip->bli_formats[i],
> > -					  nvecs, nbytes);
> > +	ASSERT(bip->bli_range[0].last != 0);
> > +	if (bip->bli_range[0].last == 0) {
> > +		/* clean! */
> > +		ASSERT(bip->bli_range[0].first == 0);
> 
> Hm, so given that the firsts are initialized to UINT_MAX, this only
> happens if the first (only?) range we log is ... (0, 0) ?

Yeah, basically it catches code that should not be logging buffers
because there is no dirty range in the buffer.

> Mildly confused about what these asserts are going after, since the
> first one implies that this shouldn't happen anyway.

If first is after last, then we've really screwed up because we've
got a dirty buffer with an invalid range. I can't recall seeing
either of these asserts fire, but we still need the check for clean
buffer ranges/ screwups in production code. maybe there's a better
way to do this?

> >  STATIC void
> > diff --git a/fs/xfs/xfs_buf_item.h b/fs/xfs/xfs_buf_item.h
> > index 643f53dcfe51..9b278c3a2db9 100644
> > --- a/fs/xfs/xfs_buf_item.h
> > +++ b/fs/xfs/xfs_buf_item.h
> > @@ -57,6 +57,25 @@ struct xfs_buf_log_item {
> >  	unsigned int		bli_recur;	/* lock recursion count */
> >  	atomic_t		bli_refcount;	/* cnt of tp refs */
> >  	int			bli_format_count;	/* count of headers */
> > +
> > +	/*
> > +	 * logging ranges. Keep a small number of distinct ranges rather than a
> > +	 * bitmap which is expensive to maintain.
> > +	 * 4 separate ranges s probably optimal so that we
> 
> "...ranges is probably..." ?
> 
> Mostly looks ok, but whew. :)

Thanks!

-Dave.
-- 
Dave Chinner
david@fromorbit.com
