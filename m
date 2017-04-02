Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:25000 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751974AbdDBACS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 1 Apr 2017 20:02:18 -0400
Date: Sun, 2 Apr 2017 10:02:14 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [ANNOUNCE] xfs-linux: for-next updated to 0cbf8c9
Message-ID: <20170402000214.GY23007@dastard>
References: <20170330173724.GE4864@birch.djwong.org>
 <20170331160438.GA3255@infradead.org>
 <20170331170601.GH4874@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170331170601.GH4874@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs <linux-xfs@vger.kernel.org>

On Fri, Mar 31, 2017 at 10:06:01AM -0700, Darrick J. Wong wrote:
> On Fri, Mar 31, 2017 at 09:04:38AM -0700, Christoph Hellwig wrote:
> > On Thu, Mar 30, 2017 at 10:37:24AM -0700, Darrick J. Wong wrote:
> > > has just been updated.  I intend to try to put in Eric Sandeen's patches
> > > to perform unlinked inode cleanup during ro mount and my own GETFSMAP
> > > patches for 4.12, so I put them in along with the other fixes and
> > > cleanups to get further testing.
> > 
> > Any chance we could not use for-next for stuff that's just queued up
> > for testing?
> 
> I've had a difficult time figuring out the timeline for Eric's patches.
> 
> I've been testing them internally since they were posted and haven't
> seen any problems crop up.  There's already an xfstest to reproduce the
> problem and exercise the fix. 

Sure, but that doesn't mean that we should use for-next for testing
whether a change we are unsure about will have an adverse impact on
users.  for-next is purely for integration testing of reviewed,
committed patches ready for upstream merge. It feeds directly to
linux-next users, so it is most definitely not the place to "try
out" patches we aren't sure about.

> Dave is concerned about the repercussions
> of the fs suddenly reaping up to several years' worth of orphaned inodes
> during a ro mount, since XFS never used to do that.  It's hard to know
> just how many people across the entire userbase that have read-only
> filesystems with inodes that have been sitting orphaned for years.

If we are unsure of the implications of a change, then it hasn't
passed review, right?

That is one of the reasons I sometimes took a month or two before I
would move a patch from my local testing tree to for-next (i.e. after
hundreds of local xfstests cycles plus all the other ad-hoc testing
and stress I'd run in day-to-day dev work).  i.e.  sometimes it
takes that long to really understand all the implications on the
code and to run it through a gamet of testing to ensure nothing has
been missed.

Sometimes we can't be 100% certain everything is OK. In this sort of
situation the situation whether to merge or not comes down to risk
categorisation and mitigation, I'd be doing things like thinking
back to the number of times I've run xfs_repair and had it clean up
the unlinked inode list. How often did that happen without zeroing
the log? How many times had I seen this in user bug reports? How
many broken filesystem images have I done forensic examination on
and found orphan indoes in them?

This sort of categorisation gives a rough indication of how conerned
we should be that behavioural changes will result on something
different happening. The reason I raised this concern is that I've
seen such evidence of orphaned inodes in the past, hence it's
something we need to think carefully about. The next question to be
answered is "what is the risk of cleaning up these inodes?"

testing will give us some insight, but we have to weigh off other
things such as inodes (and associated metadata) that have not been
touched for years. That brings into question things like storage
bitrot, and that's not something we can directly test for and is not
somethign we can be 100% certain about. We can make an educated
guess about how frequent such events are likely to be, however, and
hence get some idea of the risk we are exposing users to.

A simple risk mitigation strategy in this case would be to say
"let's just enable it for v5 filesystems right now" because there
are much fewer of those out there, and they are much less likey to
have years of stale orphaned inodes on them or to be on storage old
enough to be bit-rotting. And even if it is bitrotted, we'll get
decent error reporting if there is a problem cleaning them up,
too.

This will tell us if there is a mechanism problem in adding the
new behaviour, leaving the only unknown at that point the "untouched
metadata" risk. There's a chance we'll never see this, so once we
know the mechanism is fine on v5 filesystems (say 6 months after
kernel release) we can enable it on v4 filesystems. Then if problems
crop up, we have a fair idea of whether it is a mechanism or bitrot
problem that is causing recovery failures....

This is why I keep saying "there should be no rush to commit and
push upstream". This stuff is complex, it takes time to test
sufficiently and history tells us that the worst thing we can do is
push stuff to users too quickly.  There is nothing wrong with saying
"I'm not sure of this yet, lets slip it to the next cycle" and
continue to test and evaluate it.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
