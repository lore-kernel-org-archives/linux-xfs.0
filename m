Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:57525 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750904AbdAXVlE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 24 Jan 2017 16:41:04 -0500
Date: Wed, 25 Jan 2017 08:40:42 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v5 00/55] xfs: online scrub/repair support
Message-ID: <20170124214042.GA32761@dastard>
References: <148498561504.15323.8531512066874274553.stgit@birch.djwong.org>
 <20170124170811.GG60234@bfoster.bfoster>
 <20170124193719.GK4780@birch.djwong.org>
 <20170124205023.GI60234@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170124205023.GI60234@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org

On Tue, Jan 24, 2017 at 03:50:23PM -0500, Brian Foster wrote:
> On Tue, Jan 24, 2017 at 11:37:19AM -0800, Darrick J. Wong wrote:
> > On Tue, Jan 24, 2017 at 12:08:12PM -0500, Brian Foster wrote:
> > > Trimmed CC to XFS.
> > > 
> > > On Sat, Jan 21, 2017 at 12:00:15AM -0800, Darrick J. Wong wrote:
> > > > Hi all,
> > > > 
> > > > This is the fifth revision of a patchset that adds to XFS kernel support
> > > > for online metadata scrubbing and repair.  There aren't any on-disk
> > > > format changes.  Changes since v4 include numerous bug fixes, somewhat
> > > > more aggressive log flushing so that on-disk metadata, and the ability
> > > > to distinguish between metadata that's obviously corrupt and metadata
> > > > that merely fails cross-referencing checks in the status that is sent
> > > > back to userspace.  I have also begun using it to check all my
> > > > development workstations, which has been useful for flushing out more
> > > > bugs.
> > > > 
> > > 
> > > Hi Darrick,
> > > 
> > > Sorry I haven't got to looking into this yet.. I have kind of a
> > > logistical suggestion if I may...
> > > 
> > > Can we reduce and repost this in the smallest possible "mergeable
> > > units?" I ask because, at least for me, this kind of huge patchset tends
> > > to continuously get pushed down my todo list because the size of it
> > > suggests I'm going to need to set aside a decent amount of time to grok
> > > the whole thing, test it, etc.
> > > 
> > > We obviously lose quite a bit of (already limited) review throughput
> > > (and expertise) without Dave around. I think this would be easier for us
> > 
> > Yeah.  I've been reviewing my own patches, but when I encounter things
> > I simply stuff them into the patches directly.  I'm also fairly sure
> > that R-v-b'ing my own patches doesn't carry much weight. ;)
> > 
> 
> Heh. :P That's better than nothing I suppose, but yeah, a self r-b is
> probably to be avoided. At least I don't recall a point where we had to
> resort to that in the recent past (a better question for Dave). On the
> flip side, I think it has been naturally taking longer to get things
> reviewed and merged irrespective of Dave's vacation.

When it comes to review, the maintainer does not get a free pass. In
fact, it's even more important that the maintainer's code is
reviewed by someone else as it makes it clear that the
maintainer is not "all-powerful" and does not have privileges that
other developers don't have. i.e. there must be extremely compelling
reasons for a maintainer to commit their own code to the kernel tree
without peer review.

> > > to digest from a review perspective if we could do so in smaller chunks.
> > > For example, and just going by some of the patch titles:
> > > 
> > > - Some of the patches look like they are standalone bugfixes. If so, a
> > >   collection of those could be put into a single series, reviewed and
> > >   merged probably fairly quickly.
> > > - getfsmap looks like a standalone ioctl()..? That seems like something
> > >   that could also be reviewed and merged incrementally.
> > 
> > Originally the only consumer of getfsmap was the scrub tool itself,
> > though spaceman is now the second (real) user of it.
> > 
> > (The GET_AG_RESBLKS ioctl retrieves the per-ag reservation counters so
> > that scrub can compare what the fs reports for block/inode counts
> > against what it scrubbed, for the purpose of evaluating just how much of
> > the fs it found.)
> > 
> > > - Getting into the scrub stuff, could we separate scrubbing and online
> > >   repair into incremental series?
> > 
> > Yes, I could split these into (approximately) these kernel series:
> > 
> > 1) The usual random fixes (5 patches)
> > 2) GETFSMAP and GET_AG_RESBLKS (8)
> > 3) Basic scrub (19)
> > 4) Scrub cross-references (9)
> > 5) Repair (13)
> > 
> 
> That looks much more approachable. :)

This is generally how I've approached review of Darrick's patchbombs
- review and merge smaller, self-contained chunks one at a time. I
guess over the years I've gotten used to handling big patch sets
like this, so I have never found it a problem to break them into
manageable chunks myself... :P

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
