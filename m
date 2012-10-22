Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9MMLQpL157215 for <xfs@oss.sgi.com>; Mon, 22 Oct 2012 17:21:26 -0500
Date: Mon, 22 Oct 2012 17:23:06 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: master branch fast-forwarded to v3.7-rc1, and corp-speak mumble
Message-ID: <20121022222306.GN1377@sgi.com>
References: <20121016155640.GA1377@sgi.com> <507F132B.30000@sandeen.net>
	<20121018222838.GI1377@sgi.com> <20121019050850.GW2739@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20121019050850.GW2739@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com

Hi Dave,

On Fri, Oct 19, 2012 at 04:08:50PM +1100, Dave Chinner wrote:
> On Thu, Oct 18, 2012 at 05:28:38PM -0500, Ben Myers wrote:
> > On Wed, Oct 17, 2012 at 03:20:59PM -0500, Eric Sandeen wrote:
> > > Dave had concerns that a regression, which, although quickly fixed, was
> > > cited as the reason for missing a merge window.
> > >
> > > This concerns me too, because it's not just SGI's timetables that matter
> > > here; others are also depending on this work getting upstream within certain
> > > deadlines as well.
> > >
> > > Reading back through the list, I'm alarmed that SGI wants some unspecified
> > > "soak time," but not upstream, for new work.  There's no better place than an
> > > -rc1 to get soak & exposure for tested patches.  Bugs get found and fixed.
> > 
> > I think you are referring to my comment in this message:
> > http://oss.sgi.com/archives/xfs/2012-10/msg00122.html
> > 
> > My soak time comment was with regard to a specific patch set that had a history
> > of problems.  My comment was not meant to indicate that SGI plans to soak every
> > patch before we pull it in.  We do run the regression test suite on new patches
> > before pulling them in though.
> 
> I think the misunderstanding stems from the approach taken to
> resolve this particular case combined it with abstract references to
> stabilty and avoiding all regressions in the dev tree.  We need to
> keep communication clear and direct...
> 
> > > I don't think the XFS developer community needs a lecture on patch submission
> > > processes and quality expectations.
> > 
> > Sorry it came off that way.  Maybe not everyone else sees it, but we have had a
> > few situations recently where a patch was posted which clearly hadn't been
> > adequately tested by the developer.  E.g. something crashes right away, hits an
> > assert, or whatever.
> 
> This is something that the review process is supposed to cover. If
> you don't think a patch set is adequately tested, then that should
> be part of your review feedback.
> 
> i.e. timely communication is very helpful here, so we all should be
> trying to review code within a couple of days of it being posted and
> not leaving it for a week or two to rot before looking at it....
> 
> > It's not a huge deal, but that's why we wanted to remind
> > everyone to test before posting.  I hope that most everyone is not running into
> > those kinds of problems because they are usually caught before commit time.
> 
> Developers do test their code - they test them to the best of their
> ability and available hardware. That doesn't mean the code is
> perfect or bug free - we know from years of experience that a change
> that passes xfstests on several developers machines might cause a
> repeated ASSERT failure on one specific machine with a specific
> configuration somewhere else.
> 
> Such a problem is not the devloper's fault, though, and keeping the
> code out of the dev tree because of such a problem is a harsh
> penalty. And it's apenalty that just places more burden on
> developers and reviewers.
> 
> i.e. Instead of having to just review/track a single patch for the
> regression, the entire patch set has to be kept under management and
> reposted and updated over and over again while the regression is
> triaged and fixes are tested.  Reviewers have to look at the whole
> patch series to see what they need to re-review, it needs to be
> retested, etc. It's messy and time consuming and reduces developer
> productivity because of the additional overhead it imposes on them.
> Dealing with such problems post-integration is much more efficient
> for everyone.
> 
> > > If maintainers get too conservative all it's going to do is slow development,
> > > and slow the discovery & fixes for bugs which will inevitably occur in the
> > > course of active development.
> > 
> > Yep, I understand.  I don't want to slow development either.  I do want to try
> > to get the relevent content in before -rc7 and play by the rules with the
> > upstream tree.  And, I understand that bugs slip through.
> 
> Then, please, say exactly that.  Tell us what your merge cycle plan
> is so we can organise our work flows around that.  It'll make
> everyone's life easier if we know what targets we need to work
> towards.  I know I sound like a broken record, but it's that
> communication thing again...  :/
> 
> > > The master branch is a shared *development* resource.  If SGI is treating it
> > > as something which must never be broken under any circumstances, then I
> > > humbly submit that you're doing it wrong.  It may date me, but I'll point out
> > > that it's meant to be a bazaar, not a cathedral, and that release early,
> > > release often is not a new idea.
> > 
> > I think we're treating the master branch correctly.  If a patch is 1)
> > adequately reviewed and 2) doesn't regress something, we're good to go.  I'll
> > grant you the statement "We simply cannot pull in work with known regressions"
> > was a bit strong.  There are probably some good reasons to pull in known broken
> > code, e.g. the new breakage is preferable to the old, but usually it should be
> > fixed first.
> 
> Sure. But the crux of the concern is that "2) doesn't regress
> something" is new merge criteria because "something" has been
> redefined to have a much wider scope.
> 
> What it comes down to is that minor or isolated regressions in the
> dev tree are an acceptible trade-off for getting code into the dev
> tree quickly and efficiently. Getting the code into the tree fast
> has much wider benefits to the dev community than ensuring that
> merged code does not have any regressions at all.
> 
> > > If you need something solid and slow-moving, that's what forks and branches
> > > and -stable trees are for.
> > 
> > I take your point but I think we also have to be careful not to break stuff
> > that will affect a lot of people.  When we break the master branch it affects
> > maybe tens of people.
> 
> Development trees are for developers. Development trees, by
> definition, are unstable. Developers understand this, and so expect
> to find regressions and breakages in the developement tree.
> 
> > I really don't know how many people use the -rc releases
> > upstream.
> 
> Tens of thousands. Maybe even hundreds of thousands of developer and
> test machines are running -rc kernels. Machines that expect -rc
> kernels to have problems and are running -rc kernels to find those
> problems and get them fixed.  Again, regressions in -rc1 are not the
> end of the world.
> 
> > So here's Ben at v3.6, considering pulling in a broken patchset with
> > a challenging history, along with a one-day-old fix, without much testing, for
> > something that is already fixed in 3.6, in the middle of the merge window,
> > shortly after being told not to do that, when a mistake will affect a lot of
> > people.
> 
> I'm not going get into a he-said, she-said argument over this,
> because....
> 
> > Does that make things any clearer?  Make it worse?
> 
> ... the problem was very clear: a lack of communication.
> 
> (<smash> Oh, look, another broken record. :)
> 
> In the above case, an early "I don't think this is ready for merge"
> statement would have resulted in discussing the issue immediately
> and deciding the way to progress. No surprises, and everyone ends up
> happy with the outcome because they know exactly what is going on.
> 
> The maintainer role is not just being a code monkey - that's the
> easy part. You also have to be a release manager, a front line
> support engineer, a QA manager and - last but not least - a very
> good developer.  All of these tasks require close communication with
> affected parties, so the maintainer must also be able to communicate
> quickly and effectively.
> 
> Put simply, the #1 job of the maintainer is communication and
> co-ordination. If the maintainer is not communicating and/or
> co-ordinating well then everything else breaks down.

Thanks for the talk, coach.  ;)

Well everyone seems to agree that communication is the #1 problem.  So for my
part, that is what I'll be working on.  I'll ask the rest of the SGI XFS geeks
to do so as well.  Other contributors need to do the same, and to remember that
it cuts both ways:  I have a limited amount of time that I can spend running my
yap on this list while still getting some (marginally) useful technical work
done.  I am determined to spend it as best I can.

Gotta go.  Maybe I can pull in some code tonight! 8P

Thanks Dave,
-Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
