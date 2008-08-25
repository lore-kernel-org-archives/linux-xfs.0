Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 24 Aug 2008 18:58:19 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m7P1wCYK017030
	for <xfs@oss.sgi.com>; Sun, 24 Aug 2008 18:58:13 -0700
Received: from ipmail01.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8F7923C88DB
	for <xfs@oss.sgi.com>; Sun, 24 Aug 2008 18:59:33 -0700 (PDT)
Received: from ipmail01.adl6.internode.on.net (ipmail01.adl6.internode.on.net [203.16.214.146]) by cuda.sgi.com with ESMTP id 4wkOXg62WmJqG5oE for <xfs@oss.sgi.com>; Sun, 24 Aug 2008 18:59:33 -0700 (PDT)
Date: Mon, 25 Aug 2008 11:59:22 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS vs Elevators (was Re: [PATCH RFC] nilfs2: continuous
	snapshotting file system)
Message-ID: <20080825015922.GP5706@disturbed>
References: <20080821051508.GB5706@disturbed> <200808211933.34565.nickpiggin@yahoo.com.au> <20080821170854.GJ5706@disturbed> <200808221229.11069.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200808221229.11069.nickpiggin@yahoo.com.au>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: gus3 <musicman529@yahoo.com>, Szabolcs Szakacsits <szaka@ntfs-3g.org>, Andrew Morton <akpm@linux-foundation.org>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Fri, Aug 22, 2008 at 12:29:10PM +1000, Nick Piggin wrote:
> On Friday 22 August 2008 03:08, Dave Chinner wrote:
> > On Thu, Aug 21, 2008 at 07:33:34PM +1000, Nick Piggin wrote:
> 
> > > I don't really see it as too complex. If you know how you want the
> > > request to be handled, then it should be possible to implement.
> >
> > That is the problem in a nutshell. Nobody can keep up with all
> > the shiny new stuff that is being implemented,let alone the
> > subtle behavioural differences that accumulate through such
> > change...
> 
> I'm not sure exactly what you mean.. I certainly have not been keeping
> up with all the changes here as I'm spending most of my time on other
> things lately...
> 
> But from what I see, you've got a fairly good handle on analysing the
> elevator behaviour (if only the end result).

Only from having to do this analysis over and over again trying to
understand what has changed in the elevator that has negated the
effect of some previous optimisation....

> So if you were to tell
> Jens that "these blocks" need more priority, or not to contribute to
> a process's usage quota, etc. then I'm sure improvements could be
> made.

It's exactly this sort of complexity that is the problem. When the
behaviour of such things change, filesystems that are optimised for
the previous behaviour are not updated - we're not even aware that
the elevator has been changed in some subtle manner that breaks
the optimisations that have been done.

To keep on top of this, we keep adding new variations and types and
expect the filesystems to make best use of them (without
documentation) to optimise for certain situations. Example - the
new(ish) BIO_META tag that only CFQ understands. I can change the
way XFS issues bios to use this tag to make CFQ behave the same way
it used to w.r.t. metadata I/O from XFS, but then the deadline and
AS will probably regress because they don't understand that tag and
still need the old optimisations that just got removed. Ditto for
prioritised bio dispatch - CFQ supports it but none of the others
do.

IOWs, I am left with a choice - optimise for a specific elevator
(CFQ) to the detriment of all others (noop, as, deadline), or make
the filesystem work best with the simple elevator (noop) and
consider the smarter schedulers deficient if they are slower than
the noop elevator....

> Or am I completely misunderstanding you? :)

You're suggesting that I add complexity to solve the too much complexity
problem.... ;)

> > > > With the way the elevators have been regressing,
> > > > improving and changing behaviour,
> > >
> > > AFAIK deadline, AS, and noop haven't significantly changed for years.
> >
> > Yet they've regularly shown performance regressions because other
> > stuff has been changing around them, right?
> 
> Is this rhetorical? Because I don't see how *they* could be showing
> regular performance regressions.

I get private email fairly often asking questions as to why XFS is
slower going from, say, 2.6.23 to 2.6.24 and then speeds back up in
2.6.25. I seen a number of cases where the answer to this was that
elevator 'x' with XFS in 2.6.x because for some reason it is much,
much slower than the others on that workload on that hardware.

As seen earlier in this thread, this can be caused by a problem with
the hardware, firmware, configuration, driver bugs, etc - there are
so many combinations of variables that can cause performance issues
that often the only 'macro' level change that you can make to avoid
them is to switch schedulers. IOWs, while a specific scheduler has
not changed, the code around it has changed sufficiently for a
specific elevator to show a regression compared to the otherr
elevators.....

Basically, the complexity of the interactions between the
filesystems, elevators and the storage devices is such that there
are transient second order effects occurring that are not reported
widely because they are easily worked around by switching elevators.

> Deadline literally had its last
> behaviour change nearly a year ago, and before that was before
> recorded (git) history.
> 
> AS hasn't changed much more frequently, although I will grant that it
> and CFS add a lot more complexity. So I would always compare results
> with deadline or noop.

Which can still change by things like changing merging behaviour.
Granted, it is less complex, but still we can have subtle changes
having major impact in less commonly run workloads...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
