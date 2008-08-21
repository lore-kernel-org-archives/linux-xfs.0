Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 20 Aug 2008 23:13:30 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m7L6DQHb008499
	for <xfs@oss.sgi.com>; Wed, 20 Aug 2008 23:13:27 -0700
Received: from ipmail01.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 000C81A1DB7F
	for <xfs@oss.sgi.com>; Wed, 20 Aug 2008 23:14:47 -0700 (PDT)
Received: from ipmail01.adl6.internode.on.net (ipmail01.adl6.internode.on.net [203.16.214.146]) by cuda.sgi.com with ESMTP id vrp7HndiCpaQbKr6 for <xfs@oss.sgi.com>; Wed, 20 Aug 2008 23:14:47 -0700 (PDT)
Date: Thu, 21 Aug 2008 16:14:43 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS vs Elevators (was Re: [PATCH RFC] nilfs2: continuous
	snapshotting file system)
Message-ID: <20080821061443.GD5706@disturbed>
References: <20080821051508.GB5706@disturbed> <684252.68814.qm@web34508.mail.mud.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <684252.68814.qm@web34508.mail.mud.yahoo.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: gus3 <musicman529@yahoo.com>
Cc: Szabolcs Szakacsits <szaka@ntfs-3g.org>, Andrew Morton <akpm@linux-foundation.org>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Wed, Aug 20, 2008 at 11:00:07PM -0700, gus3 wrote:
> --- On Wed, 8/20/08, Dave Chinner <david@fromorbit.com> wrote:
> 
> > Ok, I thought it might be the tiny log, but it didn't improve
> > anything here when increased the log size, or the log buffer
> > size.
> > 
> > Looking at the block trace, I think elevator merging is somewhat
> > busted. I'm seeing adjacent I/Os being dispatched without having
> > been merged.  e.g:
> 
> [snip]
> 
> > Also, CFQ appears to not be merging WRITE_SYNC bios or issuing
> > them with any urgency.  The result of this is that it stalls the
> > XFS transaction subsystem by capturing all the log buffers in
> > the elevator and not issuing them. e.g.:
> 
> [snip]
> 
> > The I/Os are merged, but there's still that 700ms delay before
> > dispatch.  i was looking at this a while back but didn't get to
> > finishing it off.  i.e.:
> > 
> > http://oss.sgi.com/archives/xfs/2008-01/msg00151.html
> > http://oss.sgi.com/archives/xfs/2008-01/msg00152.html
> > 
> > I'll have a bit more of a look at this w.r.t to compilebench
> > performance, because it seems like a similar set of problems
> > that I was seeing back then...
> 
> I concur your observation, esp. w.r.t. XFS and CFQ clashing:
> 
> http://gus3.typepad.com/i_am_therefore_i_think/2008/07/finding-the-fas.html
> 
> CFQ is the default on most Linux systems AFAIK; for decent XFS
> performance one needs to switch to "noop" or "deadline". I wasn't
> sure if it was broken code, or simply base assumptions in conflict
> (XFS vs. CFQ). Your log output sheds light on the matter for me,
> thanks.

I'm wondering if these elevators are just getting too smart for
their own good. w.r.t to the above test, deadline was about twice
as slow as CFQ - it does immediate dispatch on SYNC_WRITE bios and
so caused more seeks that CFQ and hence went slower. noop had
similar dispatch latency problems to CFQ, so it wasn't any
faster either.

I think that we need to issue explicit unplugs to get the log I/O
dispatched the way we want on all elevators and stop trying to
give elevators implicit hints by abusing the bio types and hoping
they do the right thing....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
