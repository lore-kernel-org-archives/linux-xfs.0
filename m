Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o7Q4DNQU008552 for <xfs@oss.sgi.com>; Wed, 25 Aug 2010 23:13:23 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id CBAF927498
	for <xfs@oss.sgi.com>; Wed, 25 Aug 2010 21:13:56 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail15.adl6.internode.on.net
	[150.101.137.100]) by cuda.sgi.com with ESMTP id
	nDk24ldk4aGlwEtw for <xfs@oss.sgi.com>;
	Wed, 25 Aug 2010 21:13:56 -0700 (PDT)
Date: Thu, 26 Aug 2010 14:13:52 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [GIT Review] xfs: 2.6.36 fixes
Message-ID: <20100826041352.GA705@dastard>
References: <20100824024445.GJ31488@dastard> <1282690498.1885.74.camel@doink>
	<20100825011028.GL31488@dastard> <20100825045032.GM31488@dastard>
	<1282789046.5543.2.camel@doink>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1282789046.5543.2.camel@doink>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Alex Elder <aelder@sgi.com>
Cc: xfs@oss.sgi.com

On Wed, Aug 25, 2010 at 09:17:26PM -0500, Alex Elder wrote:
> On Wed, 2010-08-25 at 14:50 +1000, Dave Chinner wrote:
> > On Wed, Aug 25, 2010 at 11:10:28AM +1000, Dave Chinner wrote:
> > > On Tue, Aug 24, 2010 at 05:54:58PM -0500, Alex Elder wrote:
> > > > On Tue, 2010-08-24 at 12:44 +1000, Dave Chinner wrote:
> > > > > Folks,
> > > > >
> > > > > Can you please cast an eye over the the tree below to check that
> all
> > > > > the bug fixes that need to go into 2.6.36 are there? If so, I'll
> > > > > send a pull request to Linus tomorrow.
> > > > >
> > > > > Note that these are just the outstanding bug fixes that have
> been
> > > > > reviewed (as Linus has again decreed for pull requests after
> -rc1),
> > > > > so it not the complete set of reviewd patches that exist.
> > > > >
> > > > > Cheers,
> > > > >
> > > > > Dave.
> > > >
> > > > All of these commits look good to me.  I will have these
> > > > and all the rest published on the oss.sgi.com tree later
> > > > this week.  I've been on vacation and have gotten behind.
> > >
> > > I'm going to send the pull to Linus, anyway, Alex.
> > >
> > > The problem is deeper than "been on vacation" - regardless of
> > > whether you are on vacation we can't rely on you to do anything
> > > immediately. It might be code review, triage community reported
> > > bugs, pulling patches into the OSS tree or sending stuff to Linus,
> > > but it's always a week or two later than it needs to be. This is
> > > not a new problem, either.
> >
> > So this doesn't get taken the wrong way, this is not a comment on
> > the quality of the work you do, Alex. My concern is the limited
> > amount of time you have available to do the required work and
> > avoiding the bottleneck it causes.
> 
> This has been an ongoing issue, and I concur that it's been a matter
> of giving XFS maintenance the time and attention it requires.
> 
> In July I raised this issue internally and got agreement to give
> this more priority versus other competing demands.  That helped
> some, but there still were some other things that needed my
> dedicated focus, and that disrupted the continuity of my attention
> to XFS maintenance.
> 
> My vacation last week, directly on the heels of my trip to Boston
> the week before (during which I had limited network access) resulted
> in an extended delay whose cause was actually pretty unusual (and
> unfortunately timed). 
> 
> I have now been directed to spend 100% of my time on XFS maintenance
> for the community.  This will not result in 10 minute turnaround but
> it will allow me to offer everything I've got to the cause, without
> interruption.

Wonderful news, Alex! I can't think of a better way to address my
concerns.

/me does a happy dance

> SGI continues to be committed to supporting XFS (for more than just
> its own customers), and in the coming month or so is going to be
> evaluating what more can be done to serve and benefit the community.
> In the mean time XFS maintenance has my full attention.

I'd suggest that one thing we really need to do first is work out a
semi-coherent development roadmap so that we all understand what the
big issues are that we need to solve. I've been noticing the lack of
a definite direction for XFS recently - we've been scratching itches
but not really having an idea of what the next itch is going to be.

I can see some interesting requirements starting to coalesce from
RedHat customers that are just starting to use XFS, and I'm sure
that SGI is in the same boat. I also know that there are many
different lurkers in the community that would like certain features
in XFS to differentiate their products, so perhaps it is time to
flush them all out and work out a future direction that we can work
towards together.....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
