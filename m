Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:64301 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725979AbeKSLw4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 19 Nov 2018 06:52:56 -0500
Date: Mon, 19 Nov 2018 12:14:55 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 14/16] xfs: align writepages to large block sizes
Message-ID: <20181119011455.GI19305@dastard>
References: <20181107063127.3902-1-david@fromorbit.com>
 <20181107063127.3902-15-david@fromorbit.com>
 <20181114141925.GA19257@bfoster>
 <20181114211818.GW19305@dastard>
 <20181115125544.GC22958@bfoster>
 <20181116061936.GE19305@dastard>
 <20181116132922.GA31603@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181116132922.GA31603@bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

On Fri, Nov 16, 2018 at 08:29:23AM -0500, Brian Foster wrote:
> On Fri, Nov 16, 2018 at 05:19:36PM +1100, Dave Chinner wrote:
> > i.e. we round WB_SYNC_NONE to try to get whole blocks written so we
> > don't end up with partially written blocks on disk for extended
> > periods of time (e.g. between background writeback periods). It
> > doesn't matter for WB_SYNC_ALL, but it will reduce the potential for
> > stale data beign exposed when crashes occur and random pages in
> > blocks have't been written back. i.e. it's to help iprevent
> > re-exposing the problematic cases that we added the "NULL files
> > after crash" workarounds for.
> > 
> 
> Ok. I see that there are earlier patches to do zero-around on sub-block
> writes, so the idea makes a bit more sense with that in mind. That said,
> I still don't grok how messing with nr_to_write is effective.

Because background writeback is range_cyclic = 1, and that means we
always start at offset zero, and then if nr_to_write expires we
stash the page index we are up to in:

	mapping->writeback_index = done_index

And the next background writeback will start again from there.

Hence if nr_to_write is always rounding to the number of pages per
block, background writeback will /tend/ towards writing full blocks
because the writeback_index will always end up a multiple of pages
per block. Hence cyclic writeback will tend towards writing aligned,
full blocks when nr_to_write is rounded.

That's the fundamental concept here - write-in does "zero-around" to
initialise full blocks, writeback does "write-around" to push full
blocks to disk. WB_SYNC_ALL needs ranges to be rounded to do full
block writeback, WB_SYNC_NONE background writeback needs it's range
cyclic behaviour to round to writing full blocks (and that's what
rounding nr_to_write is doing in this patch).

> For background writeback (WB_SYNC_NONE), the range fields are clamped
> out (0-LONG_MAX) since the location of pages to write is not really a
> concern. In that case, ->nr_to_write is set based on some bandwidth
> heuristic and the only change we make here is to round it. If we
> consider the fact that any mapping itself may consist of some
> combination of zeroed-around delalloc blocks (covered by an aligned
> number of dirty pages) and already allocated/overwrite blocks (covered
> by any number of dirty pages), how does a rounded ->nr_to_write actually
> help us at all? Can't the magic ->nr_to_write value that prevents
> stopping at a partially written sub-block page be unaligned to the block
> size?

Yup, I never intended for this RFC prototype to deal with all these
problems. That doesn't mean I'm not aware of them, nor that I don't
have a plan to deal with them.

> Given the above, I don't see how tweaking ->nr_to_write really helps at
> all even as an optimization. Unless I'm missing something else in the
> earlier patches that facilitate this, ISTM that something more explicit
> is required if you want to increase the odds that zeroed-around blocks
> are written together.

Which I've always intended as future work. I've spent about 14 hours
on this patch set so far - it's a functional prototype, not a
finished, completed piece of work.

I'm fully aware that this going to need a lot more work before it is
ready for merging This is an early prototype I'm putting out there
for architectural/design review. i.e. don't bother nitpicking
unimplemented details or bugs, look for big picture things I've got
wrong. Look for showstoppers and fundamental problems, not things
that just require a little bit of time and coding to implement....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
