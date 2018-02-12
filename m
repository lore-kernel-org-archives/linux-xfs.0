Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57420 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754190AbeBLO0V (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 12 Feb 2018 09:26:21 -0500
Date: Mon, 12 Feb 2018 09:26:19 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH v2] xfs: byte range buffer dirty region tracking
Message-ID: <20180212142619.GA33694@bfoster.bfoster>
References: <20180201010514.30233-1-david@fromorbit.com>
 <20180205003415.dn6elcqb4kae3xle@destitution>
 <20180206162141.GA3862@bfoster.bfoster>
 <20180212024138.GB6778@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180212024138.GB6778@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Mon, Feb 12, 2018 at 01:41:38PM +1100, Dave Chinner wrote:
> On Tue, Feb 06, 2018 at 11:21:41AM -0500, Brian Foster wrote:
> > On Mon, Feb 05, 2018 at 11:34:15AM +1100, Dave Chinner wrote:
> > > 
> > > From: Dave Chinner <dchinner@redhat.com>
> > > 
> > > One of the biggest performance problems with large directory block
> > > sizes is the CPU overhead in maintaining the buffer log item direty
> > > region bitmap.  The bit manipulations and buffer region mapping
> > > calls are right at the top of the profiles when running tests on 64k
> > > directory buffers:
> > > 
> > ...
> > > 
> > >  fs/xfs/xfs_buf.c      |  23 ++-
> > >  fs/xfs/xfs_buf_item.c | 437 ++++++++++++++++++++++++++------------------------
> > >  fs/xfs/xfs_buf_item.h |  19 +++
> > >  3 files changed, 261 insertions(+), 218 deletions(-)
> > > 
> > ...
> > > diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
> > > index 270ddb4d2313..bc6514a08760 100644
> > > --- a/fs/xfs/xfs_buf_item.c
> > > +++ b/fs/xfs/xfs_buf_item.c
...
> > > @@ -167,19 +132,53 @@ xfs_buf_item_size(
> > >  		return;
> > >  	}
> > >  
> > > +
> > > +	/*
> > > +	 * If the last byte of teh first range is zero, then we've been fed a
> > > +	 * clean buffer with a XFS_BLI_DIRTY flag set. This should never happen,
> > > +	 * but be paranoid and catch it. If it does happen, then first should be
> > > +	 * zero, too.
> > > +	 */
> > > +	if (bip->bli_range[0].last == 0) {
> > > +		ASSERT(0);
> > > +		ASSERT(bip->bli_range[0].first == 0);
> > > +		return;
> > > +	}
> > 
> > Isn't first == last == 0 a valid, inclusive range?
> 
> It indicates someone logged a clean buffer, and we shouldn't ever
> get to this point if that has happened. Someone made a programming
> mistake, so better we catch it here than silently log an empty range
> and hope that log recovery does the right thing...
> 

The assert seems reasonable here... but I'm not sure a caller
programming mistake should reflect here unless we went to byte-aligned
ranges (rather than 128byte or whatever it is currently). I'm also not
convinced skipping out here is the right thing to do, but more on this
in xfs_buf_item_log()...

> > > @@ -234,16 +236,6 @@ xfs_buf_item_format_segment(
> > >  	 * memory structure.
> > >  	 */
> > >  	base_size = xfs_buf_log_format_size(blfp);
> > > -
> > > -	first_bit = xfs_next_bit(blfp->blf_data_map, blfp->blf_map_size, 0);
> > > -	if (!(bip->bli_flags & XFS_BLI_STALE) && first_bit == -1) {
> > > -		/*
> > > -		 * If the map is not be dirty in the transaction, mark
> > > -		 * the size as zero and do not advance the vector pointer.
> > > -		 */
> > > -		return;
> > > -	}
> > > -
> > >  	blfp = xlog_copy_iovec(lv, vecp, XLOG_REG_TYPE_BFORMAT, blfp, base_size);
> > >  	blfp->blf_size = 1;
> > 
> > Perhaps we should set the datamap bits before we format out the blf? ;)
> 
> No. This code is slightly tricksy, clearly, but that's not something
> this patch has changed.
> 
> That is: the blfp we pass in is the source data from the incore buf
> log format structure attached to the buf log item. xlog_copy_iovec()
> returns a pointer to the log iovec data buffer we copied the source
> into. IOWS, after the call to xlog_copy_iovec() blfp points to the
> structure that will be written to the log, not the in-memory
> structure, and we modify that repeatedly as we add new iovecs
> containing the buffer data being logged.
> 

Ah, I see. I guess I missed the reassignment of blfp.

> I'll clean it up to name the incoming blfp to "src_blfp" so it's
> clear we are operating on different structures here.
> 

Yep, thanks.

> > 
> > >  
...
> > > @@ -349,10 +334,36 @@ xfs_buf_item_format(
> > >  		bip->bli_flags &= ~XFS_BLI_INODE_BUF;
> > >  	}
> > >  
> > > -	for (i = 0; i < bip->bli_format_count; i++) {
> > > -		xfs_buf_item_format_segment(bip, lv, &vecp, offset,
> > > -					    &bip->bli_formats[i]);
> > > -		offset += BBTOB(bp->b_maps[i].bm_len);
> > > +	for (i = 0, offset = 0;
> > > +	     i < bip->bli_format_count;
> > > +	     i++, offset += BBTOB(bp->b_maps[i].bm_len)) {
> > > +
> > > +		/* stale regions cover the entire segment */
> > 
> > Something like "stale regions are fixed size" seems more accurate, since
> > we aren't actually logging any range(s).. Hm?
> 
> They aren't fixed size, either :P
> 
> 	/*
> 	 * Stale buffers do not have any data logged with them, so
> 	 * shortcut the dirty range checks and just emit a segment
> 	 * header.
> 	 */
> 

Sounds fine.

> 
> > > -static void
> > > -xfs_buf_item_log_segment(
> > > +void
> > > +xfs_buf_item_log(
> > > +	struct xfs_buf_log_item	*bip,
> > >  	uint			first,
> > > -	uint			last,
> > > -	uint			*map)
> > > +	uint			last)
> > >  {
> > > -	uint		first_bit;
> > > -	uint		last_bit;
> > > -	uint		bits_to_set;
> > > -	uint		bits_set;
> > > -	uint		word_num;
> > > -	uint		*wordp;
> > > -	uint		bit;
> > > -	uint		end_bit;
> > > -	uint		mask;
> > > +	struct xfs_bli_range	*rp = NULL;
> > > +	int			i;
> > > +	ASSERT(last != 0);
> > 
> > The current code looks like it implicitly handles this case.
> 
> Yes, it may, but logging a zero size dirty region is simply wrong.
> 

That's not the case I'm referring to. If the range is inclusive, how
would you propose to log the first byte of a buffer? I know we probably
don't have this situation and may never, but afaict the current code
handles it as you'd expect (which is to say it should behave as if we
logged any other single byte in the first chunk of the buffer).

> > Asserts
> > aside, it looks like this code could essentially add the range, fail to
> > size it correctly (due to the earlier check in the _size() path), but
> > then continue to log it based on the existing xfs_buf_item_log_segment()
> > code that has been shifted over to xfs_buf_item_format_segment().
> > 
> > The interface requests an inclusive range, so perhaps we should just
> > check for last == 0 (assuming first == 0) and bump last so the roundup
> > and all subsequent code continues to behave exactly as it does today.
> 
> No code today passes last == 0 into this function. I want to make
> sure it stays taht way, because it's indicative of a bug in the code
> that is calling xfs_buf_item_log().
> 

How is that a bug? Looking at the current code, the case of first ==
last == 0 sets the first bit in the bitmap to log the first 128 byte
region, as expected. Strange as it may be, this results in correctly
sizing/formatting the first chunk of the buffer.

With this patch, we'd throw an assert and potentially add a first ==
last == 0 range to the bli. This leads to the subsequent assert
referenced earlier in xfs_buf_item_size(), which also now returns
without including the size of the range along with skipping the
remaining ranges in the bli. Because we've shifted the old bitmap
logging code over to the format side, it looks like the format code
would still copy everything as it does today (modulo the -1 being
removed from the end calculation, perhaps), however. :/ So it seems to
me this breaks a technically valid case in weird/subtle ways. For
example, why assert about last == 0, but then go on to add the range
anyways, explicitly not size it correctly, but then format it as if
nothing is wrong? If it were really wrong/invalid (which I don't think
it is), why not put the check in the log side and skip adding the range
rather than add it, skip sizing it, and then format it.

Despite seeing no major need for it, I'm not going to haggle over the
asserts (if we wanted to leave a last == 0 assert in the logging side to
catch unexpected callers, for example). But I see no reason why the rest
of the code shouldn't essentially function as it does today: round up
the last byte to properly cover the first chunk of the buffer and log it
appropriately.

I agree that the last == 0 case is bogus by the time we hit
xfs_buf_item_size(), but AFAICT that is a bug conceptually created by
this patch and all the early return does there is facilitate potential
buffer overrun at format time. It's fine to assert, but IMO something
needs to change there to at least be consistent between the sizing and
formatting of the bli (and if we do end up skipping formatting a buffer
that might have other valid ranges, I'm thinking something louder than
an assert might be appropriate).

Brian

> > >  	/*
> > >  	 * Finally, set any bits left to be set in one last partial word.
> > > +	 * Case 3a: Extend last slot.
> > > +	 *
> > > +	 * If the range is beyond the last slot, extend the last slot to
> > > +	 * cover it. This treated the same as if an overlap existed with
> > > +	 * the last range.
> > >  	 */
> > > -	end_bit = bits_to_set - bits_set;
> > > -	if (end_bit) {
> > > -		mask = (1U << end_bit) - 1;
> > > -		*wordp |= mask;
> > > +	if (i == XFS_BLI_RANGES) {
> > > +		ASSERT(bip->bli_ranges == XFS_BLI_RANGES);
> > > +		rp = &bip->bli_range[XFS_BLI_RANGES - 1];
> > > +
> > > +		if (first < rp->first)
> > > +			rp->first = rounddown(first, XFS_BLF_CHUNK);
> > > +		if (last > rp->last)
> > > +			rp->last = roundup(last, XFS_BLF_CHUNK) - 1;
> > > +		goto merge;
> > >  	}
> > 
> > If I read this right, a 5th range arbitrarily extends the last range,
> > regardless of where that range sits in the buffer. For example, if we've
> > logged 4 small (128 byte), non-overlapping ranges within [4k-64k], then
> > say we log 0-128, we end up logging the entire 64k buffer.
> 
> Yup, I just did that for simplicity and convenience.
> 
> > It would be nice to be a little smarter here. A couple options could be
> > to merge with the first buffer that starts after the new range rather
> > than just using the last, or perhaps implementing a mechanism to
> > condense non-overlapping ranges to free a slot for a new range if doing
> > so would reduce the overall footprint.
> > 
> > Note that the latter sounded like overkill when I first thought of it,
> > but I think it may be possible to enhance the existing merge algorithm
> > you've already included into something that could merge non-adjacent
> > ranges based on an optional "weight" parameter that describes the
> > minimum distance between the new range and the closest existing range.
> > With something of that nature factored into a separate helper, it may
> > not be that difficult to make a decision on whether to condense, merge
> > or pick an existing range to extend. Worth a thought, at least...
> 
> Pretty simple to do that, now that I look at it. We don't even need
> a weight calculation because the ranges are ordered and we can
> easily detect when the incoming range falls between two entries.
> 
> I'll post an updated version once I've tested it.
> 
> Thanks for looking at this, Brian!
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
