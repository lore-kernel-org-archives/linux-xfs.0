Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:35417 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754009AbeBLVS1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 12 Feb 2018 16:18:27 -0500
Date: Tue, 13 Feb 2018 08:18:24 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2] xfs: byte range buffer dirty region tracking
Message-ID: <20180212211824.GC6778@dastard>
References: <20180201010514.30233-1-david@fromorbit.com>
 <20180205003415.dn6elcqb4kae3xle@destitution>
 <20180206162141.GA3862@bfoster.bfoster>
 <20180212024138.GB6778@dastard>
 <20180212142619.GA33694@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180212142619.GA33694@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Mon, Feb 12, 2018 at 09:26:19AM -0500, Brian Foster wrote:
> On Mon, Feb 12, 2018 at 01:41:38PM +1100, Dave Chinner wrote:
> > On Tue, Feb 06, 2018 at 11:21:41AM -0500, Brian Foster wrote:
> > > On Mon, Feb 05, 2018 at 11:34:15AM +1100, Dave Chinner wrote:
> > > > -static void
> > > > -xfs_buf_item_log_segment(
> > > > +void
> > > > +xfs_buf_item_log(
> > > > +	struct xfs_buf_log_item	*bip,
> > > >  	uint			first,
> > > > -	uint			last,
> > > > -	uint			*map)
> > > > +	uint			last)
> > > >  {
> > > > -	uint		first_bit;
> > > > -	uint		last_bit;
> > > > -	uint		bits_to_set;
> > > > -	uint		bits_set;
> > > > -	uint		word_num;
> > > > -	uint		*wordp;
> > > > -	uint		bit;
> > > > -	uint		end_bit;
> > > > -	uint		mask;
> > > > +	struct xfs_bli_range	*rp = NULL;
> > > > +	int			i;
> > > > +	ASSERT(last != 0);
> > > 
> > > The current code looks like it implicitly handles this case.
> > 
> > Yes, it may, but logging a zero size dirty region is simply wrong.
> > 
> 
> That's not the case I'm referring to. If the range is inclusive, how
> would you propose to log the first byte of a buffer?

We don't. No structure on disk has a single byte that needs to be
logged individually as it's first member. Hence we don't ever do
this.

If we ever happen to screw up an on-disk structure such that it
doesn't have a 4 byte magic number and a chunk of self describing
metadata as it's first 20-30 bytes in a buffer and we try to log
just the first byte, then these asserts will fire to tell us that
we've screwed up a new on-disk structure....

> I know we probably
> don't have this situation and may never, but afaict the current code
> handles it as you'd expect (which is to say it should behave as if we
> logged any other single byte in the first chunk of the buffer).

Just because the code handles the case, it doesn't mean it's a valid
thing to be asking the code to do....

> > > Asserts
> > > aside, it looks like this code could essentially add the range, fail to
> > > size it correctly (due to the earlier check in the _size() path), but
> > > then continue to log it based on the existing xfs_buf_item_log_segment()
> > > code that has been shifted over to xfs_buf_item_format_segment().
> > > 
> > > The interface requests an inclusive range, so perhaps we should just
> > > check for last == 0 (assuming first == 0) and bump last so the roundup
> > > and all subsequent code continues to behave exactly as it does today.
> > 
> > No code today passes last == 0 into this function. I want to make
> > sure it stays taht way, because it's indicative of a bug in the code
> > that is calling xfs_buf_item_log().
> > 
> 
> How is that a bug? Looking at the current code, the case of first ==
> last == 0 sets the first bit in the bitmap to log the first 128 byte
> region, as expected. Strange as it may be, this results in correctly
> sizing/formatting the first chunk of the buffer.

Yes, but that doesn't mean the caller is correct.

> With this patch, we'd throw an assert and potentially add a first ==
> last == 0 range to the bli. This leads to the subsequent assert
> referenced earlier in xfs_buf_item_size(), which also now returns
> without including the size of the range along with skipping the
> remaining ranges in the bli. Because we've shifted the old bitmap
> logging code over to the format side, it looks like the format code
> would still copy everything as it does today (modulo the -1 being
> removed from the end calculation, perhaps), however.

Yes, and that's required by the relogging algorithm - we have to
copy all the older tracked dirty regions when we write an active log
item into the log multiple times. That's required so we can move
objects forward in the AIL.

> :/ So it seems to
> me this breaks a technically valid case in weird/subtle ways. For
> example, why assert about last == 0, but then go on to add the range
> anyways, explicitly not size it correctly, but then format it as if
> nothing is wrong? If it were really wrong/invalid (which I don't think
> it is), why not put the check in the log side and skip adding the range
> rather than add it, skip sizing it, and then format it.

So what you're really concerned about is that I put asserts into the
code to catch broken development code, but then allow production
systems through without caring whether it works correctly because
that boundary condition will never occur during runtime on
production systems?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
