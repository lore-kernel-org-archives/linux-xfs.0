Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60352 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726119AbfAQRxg (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 17 Jan 2019 12:53:36 -0500
Date: Thu, 17 Jan 2019 12:53:33 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 3/4] xfs: validate writeback mapping using data fork seq
 counter
Message-ID: <20190117175333.GE37591@bfoster>
References: <20190111123032.31538-1-bfoster@redhat.com>
 <20190111123032.31538-4-bfoster@redhat.com>
 <20190113214905.GB4205@dastard>
 <20190114153422.GA3148@bfoster>
 <20190117144728.GA28225@infradead.org>
 <20190117163516.GD37591@bfoster>
 <20190117164148.GA15959@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190117164148.GA15959@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org

On Thu, Jan 17, 2019 at 08:41:48AM -0800, Christoph Hellwig wrote:
> On Thu, Jan 17, 2019 at 11:35:17AM -0500, Brian Foster wrote:
> > Hmm, it would be nice if these fixes were separate from the whole
> > always_cow thing. Some initial thoughts on a quick look through the
> > first few patches on the v3 post:
> 
> We can always skip the last patch.  It just helps to really nicely
> show a lot of the problems that are otherwise hard to reproduce, but
> already exist.
> 
> FYI, I just resent it like a minute before reading your mail.
> 
> > 1. It's probably best to drop your xfs_trim_extent_eof() changes as I
> > have a stable patch to add a couple more calls and then I subsequently
> > remove the whole thing going forward. Refactoring it is just churn at
> > this point.
> 
> Sure.
> 
> > 2. The whole explicit race with truncate detection looks rather involved
> > to me at first glance. I'm trying to avoid relying on i_size at all for
> > this because it doesn't seem like a reliable approach. E.g., Dave
> > described a hole punch vector for the same fundamental problem this
> > series is trying to address:
> > 
> >   https://marc.info/?l=linux-xfs&m=154692641021480&w=2
> > 
> > I don't think looking at i_size really helps us with that, but I could
> > be missing other changes in the cow series.
> 
> The i_size detection isn't new in this series, just slightly moved
> around.  And it really is just intended as an optimization to not
> even bother if we are beyond i_size.
> 

Ok, then I probably need to take a closer look. The purpose of these
patches are to remove it and replace it with something that
fundamentally addresses the underlying problem (i.e., the fork change
detection).

> > 
> > In general I'm looking at putting something like this in
> > xfs_iomap_write_allocate() once the data fork sequence number tracking
> > is enabled:
> > 
> >                         /*
> >                          * Now that we have ILOCK we must account for the fact
> >                          * that the fork (and thus our mapping) could have
> >                          * changed while the inode was unlocked. If the fork
> >                          * has changed, trim the caller's mapping to the
> >                          * current extent in the fork.
> 
> We don't even look at the callers mapping except for the range to
> cover.  And that is how e.g. direct I/O also works and a good thing
> as far as I can tell.  To make use of the previous mapping we'd have
> to rewrite xfs_bmapi_write.
> 

Yes, that's really just semantics. The purpose of the lookup in this
context is to trim down the range to map. We can only guarantee the
range specified by the current page once we cycle ilock, so we have to
consider that any part of the range external to that has become invalid.
This change to xfs_iomap_write_allocate() doesn't introduce any new way
of using the caller's imap that isn't already done by the existing code.
We just access the inode fork to validate the range rather than the
inode size because the caller already gives us information to confirm
whether the range has been invalidated (the *seq param) whereas the
i_size could have been truncated down and up since the last time we
checked it.

> If we want to be able to reuse existing mapings I think the sequences
> are helping us a bit, but a lot more work is needed, and it should
> be done in a generic way and not just in this path.

I'm assuming that a correct solution will lend itself to cleaning up
much of this code to do things like reduce the need for validations,
provide commonality with other paths, clean up layering, etc., but I'm
not worrying about that until we're confident that this is a correct and
viable approach.

Brian
