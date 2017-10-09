Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:61773 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752185AbdJIAmn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 8 Oct 2017 20:42:43 -0400
Date: Mon, 9 Oct 2017 11:42:40 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [GIT PULL] xfsprogs: mkfs refactor
Message-ID: <20171009004240.GZ3666@dastard>
References: <20171003080607.GM15067@dastard>
 <eca367b2-03de-517d-9ef5-5400e8a4739e@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <eca367b2-03de-517d-9ef5-5400e8a4739e@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: linux-xfs@vger.kernel.org

On Fri, Oct 06, 2017 at 01:01:39PM -0500, Eric Sandeen wrote:
> On 10/3/17 3:06 AM, Dave Chinner wrote:
> > Hi Eric,
> > 
> > I've put the latest mkfs refactor code that I have up in place
> > you can pull it from. I've rebased it against the current for-next
> > tree (4.13.1 release) and fixed all the problems that xfstests
> > exposes. The only thing I haven't fixed is xfs/191 that does mkfs
> > command line behaviour verification because the refactored version
> > fixes several problems that the old mkfs didn't handle correctly
> > (e.g. being able to specify certain things like agsize in blocks or
> > sectors).
> > 
> > There's a small filter patch needed for xfstests that I'll post in
> > a reply to this pull request that will filter out the new "defaults
> > sourced from ..." output and so prevent spurious xfstests failures.
> > 
> > If you want I can tag the branch with a signed tag for you to pull
> > from (same process as Linus prefers) rather than just a branch in a
> > tree. If you'd prefer that I post this as patches instead, then let
> > me know and I'll bomb the list instead.
> 
> Thanks Dave.  Trying to un-swamp from other things.
> 
> Only advantage to patchbombing is having a permanent record of discussions,
> but maybe it can happen in reference to patches as follows.... mostly
> minor nits.

Yup, but when it's been posted before, multiple ppl have said
"tested ok" but nobody is looking like they are going to review it,
I'm going to send a pull request rather than another patchbomb. :/

> 
> > mkfs: can't specify sector size of internal log
> 
> commit log is a bit vague/misleading; I think you mean that
> it should be /disallowed/ because it must match the filesystem's
> /sector/ size when it's internal?  It's not actually clear to me why
> an external log can have a "mismatched" sector size but internal can't.

I thought that was obvious.  If we have a 512 byte data device (e.g.
HDD) but a 4k sector external log device (e.g. pmem) then we'll have
the situation where the log device requires a different sector size
to the data device.  And we allow this, because the on disk log
format is only dependent on the underlying sector size, not the
configuration of the filesystem.

However, if the log is on the data device (i.e. internal) then it
should match the sector size the data device is using, otherwise
one or the other doesn't have atomic sector writes. Not to mention
that it's simply wrong to have two different sector sizes for the
same device.

If you need to change the write size (i.e. padding) characteristics
of the log for an internal/external, then use the log stripe unit
because that's exactly what it does...

> > mkfs: introduce a structure to hold CLI options
> 
> "between th einput"  (the input)
> 
> Comment mentions initialization to -1 or 0 but I don't see that this
> gets done, at least not in this patch? (Am I missing it?)  I took
> this to mean that before anything happens this would be initialized
> so we know what was and was not specified after everything was parsed...

Stale comment, updated. We initialise it all to zero, if we need
flags to see if the option was set we look at the option table
"seen" value.

> > mkfs: introduce a structure to hold CLI options
> 
> +/* quick way of checking is a parameter was set on the CLI */
>                          "if"
> 
> > mkfs: factor naming subopts parser
> 
> no "nvflag" in "temp don't break" code?  Oh, nice - write-only var.  Ok.
> do we still test it for respec, or care?  Will check later.

I was only making the code build with the temp code. Stuff like
crappy write-only vars got dropped at the first point they were
found to be crap.

And, FYI, with code that does this:

	nvflag = nlflag = foo = bar = 0;

gcc does not report set-but-unused or other such warnings because
it seems to stop checking the moment there's a multiple assignment
statement like the above. Hence shit code like in mkfs basically
prevented gcc from warning about how the shit code was dead code....


> > mkfs: Introduce mkfs configuration structure
> 
> would be nice to proofread commit log a bit ;)

Seriously, after several hours of tedious, boring patch splitting
I only cared that the code was correct. Commit logs were write once,
read never. :/

Fixed.

> > mkfs: Introduce mkfs configuration structure
> 
> s/teh/the/
> 
> <ok stopping here for now, will send more later>

Thanks!

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
