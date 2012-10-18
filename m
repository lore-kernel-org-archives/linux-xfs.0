Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9IMR2Nt217146 for <xfs@oss.sgi.com>; Thu, 18 Oct 2012 17:27:02 -0500
Date: Thu, 18 Oct 2012 17:28:38 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: master branch fast-forwarded to v3.7-rc1, and corp-speak mumble
Message-ID: <20121018222838.GI1377@sgi.com>
References: <20121016155640.GA1377@sgi.com>
 <507F132B.30000@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <507F132B.30000@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

Hey Eric,

On Wed, Oct 17, 2012 at 03:20:59PM -0500, Eric Sandeen wrote:
> On 10/16/12 10:56 AM, Ben Myers wrote:
> > Hi XFS Folks,
> > 
> > Linux v3.7-rc1 is out.  The XFS master branch
> > (git://oss.sgi.com/xfs/xfs.git) has been fast-forwarded to v3.7-rc1.
> > 
> > We'd like to take a moment and let you all know that we at SGI are going
> > to make an effort to communicate more from our end.  Your contribution
> > is appreciated whether it be features, testing, reviews, docs,
> > refactoring, cheerleading, or otherwise.  We want you here, and we want
> > your help!  We'll continue to try to be as responsive as possible.
> > 
> > Please bear in mind that the master branch is a shared resource.  We XFS
> > developers need a stable and bug free environment to work in and test
> > our changes.  We simply cannot pull in work with known regressions
> > because that can stop _all_ development until the problems are resolved.
> > 
> > Much more importantly, our end users have every reason to expect release
> > quality software when they choose to run tagged releases from
> > git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git.
> > People entrust XFS with their data, so the stakes are high.  Developers
> > and testers who run upstream kernels between releases also have every
> > reason to expect quality.  XFS must not bottleneck their development
> > efforts through regression.  We must all be committed to a consistently
> > high level of quality, and this comes before our own convenience as
> > developers.
> > 
> > When submitting work to the xfs@oss.sgi.com mailing list, please
> > remember to follow the rules described in your kernel sources under
> > Documentation/SubmittingPatches, and those in the intro of the
> > MAINTAINERS file.  In the MAINTAINERS file there is specific emphasis in
> > #1 on testing patches.  Please take this to heart.  SGI is committed to
> > testing patches before pulling them in.  And as developers, we each need
> > to thoroughly test our patches before posting.  Also, please don't get
> > discouraged if colleagues find bugs in your code by inspection or
> > through testing.  It happens sometimes.  We shouldn't rake each other
> > over the coals for it.
> 
> It sounds like SGI perceives a problem in the development cycle, based
> on all the nice, vague words about testing and collaboration and quality.
> 
> Can we lose the management-speak and state clearly what's perceived as
> the problem to be solved here?  I'm reading between the lines as best
> I can.

Ew.  Management-speak.  What were we thinking?  ;)

> Dave had concerns that a regression, which, although quickly fixed, was
> cited as the reason for missing a merge window.
>
> This concerns me too, because it's not just SGI's timetables that matter
> here; others are also depending on this work getting upstream within certain
> deadlines as well.
>
> Reading back through the list, I'm alarmed that SGI wants some unspecified
> "soak time," but not upstream, for new work.  There's no better place than an
> -rc1 to get soak & exposure for tested patches.  Bugs get found and fixed.

I think you are referring to my comment in this message:
http://oss.sgi.com/archives/xfs/2012-10/msg00122.html

My soak time comment was with regard to a specific patch set that had a history
of problems.  My comment was not meant to indicate that SGI plans to soak every
patch before we pull it in.  We do run the regression test suite on new patches
before pulling them in though.

> I don't think the XFS developer community needs a lecture on patch submission
> processes and quality expectations.

Sorry it came off that way.  Maybe not everyone else sees it, but we have had a
few situations recently where a patch was posted which clearly hadn't been
adequately tested by the developer.  E.g. something crashes right away, hits an
assert, or whatever.  It's not a huge deal, but that's why we wanted to remind
everyone to test before posting.  I hope that most everyone is not running into
those kinds of problems because they are usually caught before commit time.

> If maintainers get too conservative all it's going to do is slow development,
> and slow the discovery & fixes for bugs which will inevitably occur in the
> course of active development.

Yep, I understand.  I don't want to slow development either.  I do want to try
to get the relevent content in before -rc7 and play by the rules with the
upstream tree.  And, I understand that bugs slip through.
 
> The master branch is a shared *development* resource.  If SGI is treating it
> as something which must never be broken under any circumstances, then I
> humbly submit that you're doing it wrong.  It may date me, but I'll point out
> that it's meant to be a bazaar, not a cathedral, and that release early,
> release often is not a new idea.

I think we're treating the master branch correctly.  If a patch is 1)
adequately reviewed and 2) doesn't regress something, we're good to go.  I'll
grant you the statement "We simply cannot pull in work with known regressions"
was a bit strong.  There are probably some good reasons to pull in known broken
code, e.g. the new breakage is preferable to the old, but usually it should be
fixed first.

> If you need something solid and slow-moving, that's what forks and branches
> and -stable trees are for.

I take your point but I think we also have to be careful not to break stuff
that will affect a lot of people.  When we break the master branch it affects
maybe tens of people.  I really don't know how many people use the -rc releases
upstream.  So here's Ben at v3.6, considering pulling in a broken patchset with
a challenging history, along with a one-day-old fix, without much testing, for
something that is already fixed in 3.6, in the middle of the merge window,
shortly after being told not to do that, when a mistake will affect a lot of
people.  So I made the call.  But it's only for a specific patch set.  It does
not represent a problem or a change in the development cycle, except to say
that we'd like to try and get stuff in by -rc7 next time so we can play by the
rules, to remind devs to test before posting, and to explain why we have to
push back sometimes.

Does that make things any clearer?  Make it worse?

Regards,
Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
