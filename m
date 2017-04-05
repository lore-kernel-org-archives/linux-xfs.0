Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:44971 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755354AbdDESC2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 5 Apr 2017 14:02:28 -0400
Date: Wed, 5 Apr 2017 11:01:33 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [ANNOUNCE] xfs-linux: for-next updated to 0cbf8c9
Message-ID: <20170405180133.GI4874@birch.djwong.org>
References: <20170330173724.GE4864@birch.djwong.org>
 <20170331160438.GA3255@infradead.org>
 <20170331170601.GH4874@birch.djwong.org>
 <20170402000214.GY23007@dastard>
 <20170403183915.GP4864@birch.djwong.org>
 <fac5c7f1-ddea-54de-60de-0f3d4032b263@redhat.com>
 <20170404112023.GA38324@bfoster.bfoster>
 <20170404181534.GS4864@birch.djwong.org>
 <20170405114848.GB2835@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170405114848.GB2835@localhost.localdomain>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: Eric Sandeen <sandeen@redhat.com>, Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@infradead.org>, xfs <linux-xfs@vger.kernel.org>

On Wed, Apr 05, 2017 at 07:48:48AM -0400, Brian Foster wrote:
> On Tue, Apr 04, 2017 at 11:15:34AM -0700, Darrick J. Wong wrote:
> > On Tue, Apr 04, 2017 at 07:20:23AM -0400, Brian Foster wrote:
> > > On Mon, Apr 03, 2017 at 01:56:37PM -0500, Eric Sandeen wrote:
> > > > On 4/3/17 1:39 PM, Darrick J. Wong wrote:
> > > > > On Sun, Apr 02, 2017 at 10:02:14AM +1000, Dave Chinner wrote:
> > > > >> On Fri, Mar 31, 2017 at 10:06:01AM -0700, Darrick J. Wong wrote:
> > > > >>> On Fri, Mar 31, 2017 at 09:04:38AM -0700, Christoph Hellwig wrote:
> > > > >>>> On Thu, Mar 30, 2017 at 10:37:24AM -0700, Darrick J. Wong wrote:
> > > > >>>>> has just been updated.  I intend to try to put in Eric Sandeen's patches
> > > > >>>>> to perform unlinked inode cleanup during ro mount and my own GETFSMAP
> > > > >>>>> patches for 4.12, so I put them in along with the other fixes and
> > > > >>>>> cleanups to get further testing.
> > > > >>>>
> > > > >>>> Any chance we could not use for-next for stuff that's just queued up
> > > > >>>> for testing?
> > > > >>>
> > > > >>> I've had a difficult time figuring out the timeline for Eric's patches.
> > > > >>>
> > > > >>> I've been testing them internally since they were posted and haven't
> > > > >>> seen any problems crop up.  There's already an xfstest to reproduce the
> > > > >>> problem and exercise the fix. 
> > > > >>
> > > > >> Sure, but that doesn't mean that we should use for-next for testing
> > > > >> whether a change we are unsure about will have an adverse impact on
> > > > >> users.  for-next is purely for integration testing of reviewed,
> > > > >> committed patches ready for upstream merge. It feeds directly to
> > > > >> linux-next users, so it is most definitely not the place to "try
> > > > >> out" patches we aren't sure about.
> > > > > 
> > > > > All right, I'll pull them from for-next.  Eric (who I think was on
> > > > > vacation last week) is ok with this, I think.
> > > > 
> > > > It's been broken forever.  A little while longer won't really hurt,
> > > > I guess.
> > > > 
> > > > >>> Dave is concerned about the repercussions
> > > > >>> of the fs suddenly reaping up to several years' worth of orphaned inodes
> > > > >>> during a ro mount, since XFS never used to do that.  It's hard to know
> > > > >>> just how many people across the entire userbase that have read-only
> > > > >>> filesystems with inodes that have been sitting orphaned for years.
> > > > >>
> > > > >> If we are unsure of the implications of a change, then it hasn't
> > > > >> passed review, right?
> > > > >>
> > > > >> That is one of the reasons I sometimes took a month or two before I
> > > > >> would move a patch from my local testing tree to for-next (i.e. after
> > > > >> hundreds of local xfstests cycles plus all the other ad-hoc testing
> > > > >> and stress I'd run in day-to-day dev work).  i.e.  sometimes it
> > > > >> takes that long to really understand all the implications on the
> > > > >> code and to run it through a gamet of testing to ensure nothing has
> > > > >> been missed.
> > > > >>
> > > > >> Sometimes we can't be 100% certain everything is OK. In this sort of
> > > > >> situation the situation whether to merge or not comes down to risk
> > > > >> categorisation and mitigation, I'd be doing things like thinking
> > > > >> back to the number of times I've run xfs_repair and had it clean up
> > > > >> the unlinked inode list. How often did that happen without zeroing
> > > > >> the log? How many times had I seen this in user bug reports? How
> > > > >> many broken filesystem images have I done forensic examination on
> > > > >> and found orphan indoes in them?
> > > > > 
> > > > > I barely have any data to go on -- so far I've not personally seen this
> > > > > happen... but nearly all the XFS setups I know about use XFS for data
> > > > > storage (i.e. not root fs) and are always mounted rw.
> > > > > 
> > > > > The initial complaint (I think) came from a RH bug about this situation,
> > > > > so I'm assuming that the RHers have a better view on this than I do...
> > > > > IOWs, since we're spreading out some of the responsibility for owning
> > > > > pieces of code to take pressure off the maintainer, it would help me to
> > > > > have code authors and reviewers discuss the timeline in which they think
> > > > > a given patchset should be upstreamed.  This doesn't have to be
> > > > > particularly precise or set in stone -- even a hint such as "fix this
> > > > > now", "next merge window", "code looks ok but let's soak this for a few
> > > > > months" would help immensely.
> > > > 
> > > 
> > > I think our recent impulse has been to merge everything that's been
> > > reviewed upstream asap (i.e., whatever the next -rc cycle is) and kind
> > > of filter off things that should be pushed out. IMO, the safer and more
> > > appropriate approach is probably the opposite: assume everything is
> > > destined for for-next unless it is obviously a release regression or
> > > otherwise "escalated" as an -rc fix.
> > > 
> > > IOW, for me personally, when I 'Reviewed-by' something I still generally
> > > expect to have that code available in for-next for a period of time for
> > > local testing and whatnot. Dave obviously has enough experience to
> > > filter things between for-next and -rc updates such that we haven't
> > > really had to discuss this much on the list. If there's confusion, I
> > > think it's reasonable that we explicitly point out patches that are
> > > expected to go in an -rc update (or to just ask when it's not clear or
> > > give notice that something is to be queued for -rc).
> > 
> > Yeah.  I originally put it in the -next branch on my testing tree, but
> > changed my mind to the -rc branch after chatting with Eric, then changed
> > it back after Dave's reply that you linked below.  There it sat in
> > -next, and then all this happened.  I wasn't expecting quite so much
> > churn. :/
> > 
> > > > Yes, we had one report.  Then we saw a guy with a /huge/ swath of space
> > > > missing on IRC, and it was the same problem.
> > > >  
> > > > > (Or to put it another way: I prefer that the upstreaming timeline be a
> > > > > part of the patch review from the start, rather than me trying to figure
> > > > > it out in a vacuum and walking things back when everyone is surprised.)
> > > > > 
> > > > >> This sort of categorisation gives a rough indication of how conerned
> > > > >> we should be that behavioural changes will result on something
> > > > >> different happening. The reason I raised this concern is that I've
> > > > >> seen such evidence of orphaned inodes in the past, hence it's
> > > > >> something we need to think carefully about. The next question to be
> > > > >> answered is "what is the risk of cleaning up these inodes?"
> > > > >>
> > > > >> testing will give us some insight, but we have to weigh off other
> > > > >> things such as inodes (and associated metadata) that have not been
> > > > >> touched for years. That brings into question things like storage
> > > > >> bitrot, and that's not something we can directly test for and is not
> > > > >> somethign we can be 100% certain about. We can make an educated
> > > > >> guess about how frequent such events are likely to be, however, and
> > > > >> hence get some idea of the risk we are exposing users to.
> > > > >>
> > > > >> A simple risk mitigation strategy in this case would be to say
> > > > >> "let's just enable it for v5 filesystems right now" because there
> > > > >> are much fewer of those out there, and they are much less likey to
> > > > >> have years of stale orphaned inodes on them or to be on storage old
> > > > >> enough to be bit-rotting. And even if it is bitrotted, we'll get
> > > > >> decent error reporting if there is a problem cleaning them up,
> > > > >> too.
> > > > 
> > > > Eh, we now have verifiers even w/o V5, right.
> > > > 
> > > > >> This will tell us if there is a mechanism problem in adding the
> > > > >> new behaviour, leaving the only unknown at that point the "untouched
> > > > >> metadata" risk. There's a chance we'll never see this, so once we
> > > > >> know the mechanism is fine on v5 filesystems (say 6 months after
> > > > >> kernel release) we can enable it on v4 filesystems. Then if problems
> > > > >> crop up, we have a fair idea of whether it is a mechanism or bitrot
> > > > >> problem that is causing recovery failures....
> > > > > 
> > > > > Ok.  See, this was what I was looking for, in terms of 'what is someone
> > > > > uncomfortable about and what would they like us to do about it'.  Eric?
> > > > 
> > > > Well, tbh this all seems a bit circular and hand-wavy.
> > > > 
> > > > We're doing half of recovery and not the other half in the case where
> > > > we have an RO mount.  And Dave has voiced some rather vague worries
> > > > about fixing it to do /all/ of recovery on an ro mount.
> > > > 
> > > > I've written a test explicitly to exercise this, so we do have a functional
> > > > regression test.  But we can't merge it because we're afraid it might
> > > > break something in the field, and we won't know if it will break anything
> > > > in the field until we merge it.
> > > > 
> > > > I mean, I guess we could enable for v5 and not v4, but I'm really not
> > > > understanding why there's so much fear around this particular change.
> > > > There seems to be an order of magnitude more worry than for most other
> > > > changes, and I don't know why that is.
> > > > 
> > > > Of course, as soon as I argue for earlier and universal inclusion, it'll
> > > > blow up in my face, because that's just how these things go.  ;)
> > > > 
> > > > >> This is why I keep saying "there should be no rush to commit and
> > > > >> push upstream". This stuff is complex, it takes time to test
> > > > >> sufficiently and history tells us that the worst thing we can do is
> > > > >> push stuff to users too quickly.  There is nothing wrong with saying
> > > > >> "I'm not sure of this yet, lets slip it to the next cycle" and
> > > > >> continue to test and evaluate it.
> > > > 
> > > > Well, if it's just a release timing issue, that's different.
> > > > 
> > > > If the proposal is to merge it early next cycle and (in theory) get more
> > > > widespread testing before that kernel is baked, that's fine by me.
> > > > 
> > > 
> > > The original objection[1] during the review of the last post was to the
> > > idea of these patches going in through an -rc update. That makes sense
> > > to me, as this is a behavior change and not necessarily an isolated bug
> > > fix or regression. I.e., my understanding is that the -rc cycles are
> > > basically a release stabilization process and not really for "new
> > > development" (I think this qualifies as the latter despite us calling it
> > > a "bug," and thus doesn't really serve the stabilization process).
> > > 
> > > Given that and the fact that the code has been reviewed, to me the right
> > > approach should be to merge it into for-next such that it's available
> > > for our local development/testing and ready to go in on the next merge
> > > window and full -rc cycle (which is precisely what Darrick has done).
> > > From there we have the opportunity to fix or deal with any regressions
> > > (with the worst case of having to revert the change, as is the case with
> > > any other patch).
> > > 
> > > So IMO this has ultimately been handled the right way. I don't think we
> > > should drop patches from for-next (I know the branch _can_ rebase and
> > > whatnot, but it's still annoying when it does) that have otherwise
> > > followed the appropriate process unless there is some new,
> > > tangible/critical concern that wasn't known at review time and we don't
> > > think we can resolve with follow on patches in the meantime. Just my
> > > .02.
> > 
> > OTOH, I think it's accurate to say that Eric and I aren't going to push
> > this series for 4.12, so it doesn't belong in for-next either.  I've
> > already removed them from for-next.
> > 
> 
> Ok, fair enough. It's ultimately your call either way. :)
> 
> FWIW, I think I now have broken upstream commit hash references due to
> the rebase, which is a bit annoying. I know that's always been a
> possibility, but generally occurs rarely.
> 
> As it is, is there anything else in for-next currently that is not
> imminent for 4.12 (i.e., blocked on pending reviews/testing or
> whatever) such that we might expect another rebase before the end of the
> release?

I don't anticipate pulling anything else out, at least not at this time.

> > I've thought that maybe I should just put them on a third (new) branch.
> > -fixes can be for the unreleased stable kernel (4.11); -merge can be for
> > the next kernel cycle (4.12); and -washme for things deferred even after
> > that (4.13+).  We all can peruse the three branches, argue about whether
> > or not patches should move between the branches, and then I can
> > periodically push -merge into for-next when the dust settles, which
> > should hopefully reduce the rebasing churn on for-next.
> >
> 
> IMO, branch strategy is not really relevant to the problem here. This
> patch is apparently blocked on somebody (presumably the author :)
> running a longer running test cycle (i.e., including it in one's regular
> testing for a release cycle or so, for example) to better establish
> confidence that it doesn't cause any problems.
> 
> Obviously you should do whatever works for you as far as branch
> management and whatnot, whether it be topic branches or the strategy
> outlined above. My point is more that the act of merging this patch in a
> topic branch, while useful in that it at least makes the patch
> available, doesn't progress it unless somebody is actually doing the
> testing.

<nod>

> Brian
> 
> > --D
> > 
> > > 
> > > Brian
> > > 
> > > [1] http://www.spinics.net/lists/linux-xfs/msg05046.html
> > > 
> > > > Dave, if you have any specific worries or things that you want a testcase
> > > > for, I'm all ears.  If it's vague fears, I'm not sure how to remedy that.
> > > > 
> > > > One thing I could do is fabricate a test that processes the unlinked list
> > > > on a filesystem that has a /clean/ log.  Or, if we're worried that there's
> > > > state built up around log replay that matters, I could changes so that this
> > > > processing only happens if we have run into a dirty log on this mount, and
> > > > have done the normal log replay that we normally see with unlinked inodes ...
> > > > 
> > > > -Eric
> > > > 
> > > > > In the meantime, what do people think of this for for-next tomorrow?
> > > > > https://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git/log/?h=xfs-4.12-merge
> > > > > 
> > > > > --D
> > > > > 
> > > > >> Cheers,
> > > > >>
> > > > >> Dave.
> > > > >> -- 
> > > > >> Dave Chinner
> > > > >> david@fromorbit.com
> > > > >> --
> > > > >> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > > > >> the body of a message to majordomo@vger.kernel.org
> > > > >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > > > 
> > > > --
> > > > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > > > the body of a message to majordomo@vger.kernel.org
> > > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > > --
> > > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > > the body of a message to majordomo@vger.kernel.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
