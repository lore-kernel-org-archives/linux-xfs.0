Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail02.adl2.internode.on.net ([150.101.137.139]:1440 "EHLO
        ipmail02.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727117AbfCSUZn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 19 Mar 2019 16:25:43 -0400
Date: Wed, 20 Mar 2019 07:25:37 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/4] xfs: force writes to delalloc regions to unwritten
Message-ID: <20190319202537.GR23020@dastard>
References: <155259894630.30230.10064390935593758177.stgit@magnolia>
 <20190314230841.GJ23020@dastard>
 <20190315031302.GF4929@magnolia>
 <20190315034038.GK23020@dastard>
 <20190315122939.GB5182@bfoster>
 <20190317224011.GO23020@dastard>
 <20190318124039.GA17956@bfoster>
 <20190318203506.GQ23020@dastard>
 <20190318215014.GA21231@bfoster>
 <20190319180249.GS4929@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190319180249.GS4929@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org

On Tue, Mar 19, 2019 at 11:02:49AM -0700, Darrick J. Wong wrote:
> On Mon, Mar 18, 2019 at 05:50:14PM -0400, Brian Foster wrote:
> > On Tue, Mar 19, 2019 at 07:35:06AM +1100, Dave Chinner wrote:
> > > On Mon, Mar 18, 2019 at 08:40:39AM -0400, Brian Foster wrote:
> > > > On Mon, Mar 18, 2019 at 09:40:11AM +1100, Dave Chinner wrote:
> > > > > On Fri, Mar 15, 2019 at 08:29:40AM -0400, Brian Foster wrote:
> > > > > > On Fri, Mar 15, 2019 at 02:40:38PM +1100, Dave Chinner wrote:
> > > > > > > > If the delalloc extent crosses EOF then I think it makes sense to map it
> > > > > > > > in as unwritten, issue the write, and convert the extent to real during
> > > > > > > > io completion, and not split it up just to avoid having unwritten
> > > > > > > > extents past EOF.
> > > > > > > 
> > > > > > > Yup, makes sense. For a sequential write, they should always be
> > > > > > > beyond EOF. For anything else, we use unwritten.
> > > > > > > 
> > > > > > 
> > > > > > I'm not quite sure I follow the suggested change in behavior here tbh so
> > > > > > maybe this is not an issue, but another thing to consider is whether
> > > > > > selective delalloc -> real conversion for post-eof extents translates to
> > > > > > conditional stale data exposure vectors in certain file extension
> > > > > > scenarios.
> > > > > 
> > > > > No, it doesn't because the transaction that moves EOF is done after
> > > > > the data write into the region it exposes is complete. hence the
> > > > > device cache flush that occurs before the log write containing the
> > > > > transaction that moves the EOF will always result in the data being
> > > > > on stable storage *before* the extending szie transaction hits the
> > > > > journal and exposes it.
> > > > > 
> > > > 
> > > > Ok, but this ordering alone doesn't guarantee the data we've just
> > > > written is on-disk before the transaction hits the log.
> > > 
> > > Which transaction are you talking about? This ordering guarantees
> > > that the data is on stable storage before the EOF size change
> > > transactions that exposes the region is on disk (that's the whole
> > > point of updates after data writes).
> > > 
> > > If you are talking about the allocation transaction taht we are
> > > going to write the data into, then you are right that it doesn't
> > > guarantee that the data is on disk before that commits, but when the
> > > allocation is beyond EOF it doesn't matter ebcause is won't be
> > > exposed until after the data is written and the EOF moving
> > > transaction is committed.
> > > 
> > 
> > The extending transaction that you referred to above and with respect to
> > the device cache flush. I'm simply saying that the transaction has to be
> > ordered with respect to full writeback completion as well, which is also
> > what you are saying further down. (We're in agreement... ;)).
> > 
> > > As I've previously proposed, what I suspect we should be doing is
> > > not commiting the allocation transaction until IO completion, which
> > > closes this stale data exposure hole completely and removes the need
> > > for allocating unwritten extentsi and then having to convert them.
> > > Direct IO could also do this, and so it could stop using unwritten
> > > extents, too....
> > > 
> > 
> > That sounds like an interesting (and potentially more efficient)
> > alternative to using unwritten extents across the board only to convert
> > them as I/Os complete. I guess we'd need to make sure that the
> > allocation transaction holds across potentially many ioends considering
> > the max extents size of 8GB or so. I suppose the locking and handling of
> > fragmented allocation cases could get a bit interesting there as well,
> > but it's probably worth a prototype attempt at least to survey the
> > concept... (I wonder if Darrick is still paying attention or found
> > something more interesting to do..? :D)
> 
> /me wandered off into fixing the io completion mess; if either of you
> want to work on a better prototype, I encourage you to go for it. :)
> 
> Though I wonder how bad would be the effects of holding the allocation
> transaction open across a (potentially very slow) writeout.  We'd still
> be holding onto the dirty inode's ilock as well as the AGF header and
> whatever bnobt/cntbt blocks are dirty.  Wouldn't that stall any other
> thread that was walking the AGs looking for free space?

Yeah, which is why I mentioned on IRC that it may be better to use
an intent/done transaction pair similar to an EFI/EFD. i.e. on IO
completion we only have to log the "write done" and it can contain
just hte range for the specific IO, hence we can do large
allocations and only mark the areas we write as containing data.
That would allow zeroing of the regions that aren't covered by a
done intent within EOF during recovery....

> > I also assume we'd still need to use unwritten extents for cases where
> > the allocation completes before all of the extent is within EOF (i.e.,
> > the extent zeroing idea you mentioned on irc..).
> 
> Yes, I think it would still be necessary.  My guess is that
> xfs_bmapi_convert_delalloc has to create unwritten extents for any
> extent starting before the on-disk EOF but can create real extents for
> anything past the on-disk isize (because we don't set the on-disk isize
> to match the in-core isize until writes complete).

Yes, that was my assumption too, but I suspect that with an
intent/done pair, even that is not necessary.

> I guess the "zero
> pages between old isize and new isize" code can simply reset any real
> extents it finds to be unwritten too, as we've been discussing.

*nod*

> > The broader point is that by controlling writeback ordering, we can
> > explicitly demonstrate stale data exposure. If fixed properly, we should
> > never expect stale data exposure even in the event of out of order
> > writeback completion, regardless of the cause.
> 
> Agree.  Even if s_f_r is a giant trash fire, if we're exposing stale
> disk contents it's game over anyway and we ought to fix it.

Well, that's exactly the problem with SFR, isn't it? The dirty data
is outside the range the user asks to sync and the implementation
doesn't go anywhere near the filesystem so we can't actually do the
right thing here. So we are left to either hack fixes around a
shitty, broken interface and everyone pays the penalty, or we ignore
it. We've simply ignored it for the past 10+ years because it really
can't be used safely for it's intended purposes (as everyone who
tries to use it finds out eventually)...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
