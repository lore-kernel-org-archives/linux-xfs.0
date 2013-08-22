Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id B597A7FA8
	for <xfs@oss.sgi.com>; Thu, 22 Aug 2013 11:14:59 -0500 (CDT)
Date: Thu, 22 Aug 2013 11:14:56 -0500
From: Geoffrey Wehrman <gwehrman@sgi.com>
Subject: Re: [PATCH 51/50] xfs: add xfs sb v4 support for dirent filetype field
Message-ID: <20130822161456.GB23510@sgi.com>
References: <1376304611-22994-1-git-send-email-david@fromorbit.com>
	<20130819201940.516942026@sgi.com>
	<5212AA1D.3000809@sandeen.net> <52137D3D.8060205@sgi.com>
	<20130821000624.GO6023@dastard> <20130821170336.GJ5262@sgi.com>
	<20130822020226.GR6023@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130822020226.GR6023@dastard>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: Ben Myers <bpm@sgi.com>, Eric Sandeen <sandeen@sandeen.net>, Mark Tinguely <tinguely@sgi.com>, xfs@oss.sgi.com

On Thu, Aug 22, 2013 at 12:02:26PM +1000, Dave Chinner wrote:
| On Wed, Aug 21, 2013 at 12:03:36PM -0500, Ben Myers wrote:
| > Hi Dave,
| > 
| > On Wed, Aug 21, 2013 at 10:06:24AM +1000, Dave Chinner wrote:
| > > On Tue, Aug 20, 2013 at 09:29:17AM -0500, Mark Tinguely wrote:
| > > > I repeat, if you have technical concerns for the feature's
| > > > implementation and its impact on v4 filesystems because it uses
| > > > common directory code, then it should be held back for more testing.
| > > 
| > > I missed this comment. Mark, I'm really concerned that SGI is taking
| > > the stance that the dtype code is fully working unless otherwise
| > > proven to have problems.  That is a dangerous approach to take for
| > > new code and new on-disk formats - it should be considered with
| > > suspicion and paranoia until enough testing has been done to negate
| > > those concerns.
| > > 
| > > The reason I only proposed this for v5 superblocks is to enable
| > > wider testing and get us to the point where we are not concerned
| > > anymore about it before we say it is ready for production
| > > deployment.
| > > 
| > > I have technical concerns that arise once the feature bit it
| > > enabled, not when it is disabled. Those technical concerns center
| > > around off-by-one and alignment issues as a result of increasing the
| > > dirent size when the feature bit is enabled - they pack differently
| > > into the directory structure and hence will exercise allocation,
| > > freespace and logging differently.
| > > 
| > > See my previous comments about how hard the directory code is to
| > > test and validate - that's why I want to enable in V5 first so we
| > > can shake out problems over a wider (but still constrained) user
| > > base that understand that EXPERIMENTAL means that they might still
| > > be corruption bugs lurking.
| > 
| > I understand the sentiment that it would be nice to get this into v5 for some
| > early initial testing.  However, we agreed to take in the crc work as
| > experimental on the condition that it does not regress v4 superblocks, and with
| > the knowledge that it might take awhile to be completed.  It's still unfinished
| > and that's ok.  We knew that was coming.  But this was an agreement made for
| > one feature only.
| 
| No, it was made for all the on-disk changes that were proposed for
| the new v5 format. The dirent changes were part of that - that's
| been the POR for the past couple of years, I was clear and up front
| about this and mentioned it several times during the weekly con
| calls. I even specifically said at one point that if I don't get it
| done for the initial merge that I'd need use an incompat feature bit
| for it. At no time during those discussions did SGI say *anything*
| about needing it on v4.
| 
| No, that didn't happen until I posted the patches for review with
| performance numbers attached. And here we are....
| 
| Further, I'm seriously concerned that the maintainer is claiming to
| be unaware of the the public POR for this feature, especially as
| this very feature has specifically talked about and mentioned in the
| context of CRCs and features in discussions over the past few
| months.

I am claiming to be unaware of the POR for this feature.
I have finally found a reference on February 25 of this year.
[http://oss.sgi.com/archives/xfs/2013-02/msg00451.html] As this feature
was lumped in with the CRC work, I never noticed it.  It is my fault
that I don't read the list more carefully.  However, what was posted
did not provide any design information, or code.  Even if I had noticed
your references to the feature, I would have had no clue as to how the
feature would be implemented.  It wasn't until you posted the patch on
July 19 that there was any type of indication as to how the feature is
implemented.  [http://oss.sgi.com/archives/xfs/2013-07/msg00422.html]
Had I been aware of the design and implementation details earlier,
I would have had an opportunity to raise my concerns earlier.

When I did finally notice this feature, it is clear that this feature
really does not belong with the CRC work.  It is completely unrelated
other than the fact there is an on-disk format change.  The only
dependency I can find is that your implementation is using code introduced
by the dir3 code, but that is the case whether or not the dirent filetype
feature is enabled.

| > We did not agree that the v5 superblock would become a
| > dumping ground for unrelated and incomplete features to get early testing.
| 
| I am not using v5 superblocks as a "dumping ground". This feature
| was *always* planned solely for v5 superblocks.

Why?  This feature has no dependency on v5 superblocks.  It has no
dependency on CRCs.  It has no dependency on self-describing metadata.
It could be implemented without the dir3 code.  What is your
justification for planning this feature solely for v5 superblocks.  That
is what I do not understand.

| > > Again, as I've said all along - enabling the feature on v4
| > > filesystems is not a technical problem - it's a process and
| > > support problem. If I thought that this code was ready for
| > > widespread production deployment then I would have no hesitation
| > > to add v4 support, but it's simply not at that stage yet. We
| > > need wider test and deployment coverage to get the new feature
| > > to that stage.

Process and support?  Mark and I have stepped up to provide the support
for this feature in v4 superblocks.  I will take responsibility for
ensuring that the feature is thoroughly tested.  Mark is already testing
the feature on v4 superblock filesystems.  If the feature is introduced
in the 3.12 merge window, there will be additional time to test the
feature before 3.12 is released.  What other process is there for adding
a feature?

| > > Which leads to the "then it should be held back for more
| > > testing" comment. We've discussed this before - almost a year
| > > ago now - when SGI stated that they wouldn't accept any new code
| > > in the xfsdev tree unless it was proven to be regression free.
| > > That was unacceptable then and to apply it to the v5 dirent code
| > > is no different.
| > > 
| > > We need wider testing of these changes before it is production
| > > ready, and so holding it back until it's proven to be OK for
| > > production deployment in v4 filesystems is placing us in a
| > > catch-22 and as such is a similarly an unacceptable outcome.

The common code path changes in your code will be active even if the
feature is not ported to v4 filesystems.  So no difference there.
Testing on the v4 changes is already underway, and no issues have been
found.  Please quantify the level of testing you expect.  Do you want to
see actual test results published?  I have never seen such a requirement
in the past.

| > If this needs more testing I'm all for it.  We should make it a
| > Kconfig option marked as experimental in it's own right,
| 
| I don't follow you - what feature do you want to make a compile time
| conditional?

I think Ben is suggesting making the dirent filetype feature a compile
time conditional.  I do not agree.

| > finish the userspace work, and then
| > set about pulling it in.  Marking the feature bit as experimental
| > in mkfs with a warning also seems like an good idea to me...
| 
| What does that achieve that we don't already have?
| 
| And, indeed, ext4 proved this a bad idea with their ext4dev flag
| and all problems that produced in userspace...
| 
| > And
| > if you're that concerned about it then I'd really like to see them
| > both.  But marking it experimental doesn't magically mean that
| > we'll pull in another incomplete feature.
| 
| dtype support for v5 is a complete feature from the kernel code
| perspective. There's no more kernel code that needs to be written
| for it.

Same for v4.  Mark has posted the code.

| > My impression is we're likely to go to -rc7, so I think chances
| > are good this work can be finished in time for 3.12.
| 
| v4 support is not going to be ready for 3.12. We don't rush new
| on-disk format changes, and the v4 code support is nowhere near
| complete yet. Ignoring the code that still needs to be written,
| there's a lot more verification needed before it gets merged....

Please explain what is missing?  If you are referring to the user space
code, you are correct in that there has not been any code posted for
review.  The kernel code can still go in though as without the user
space code, the feature cannot be enabled.  A modified mkfs is required
to enable the feature bit for v4, or the superblock must be hacked.

| The compromise I have suggested of review and merge v5 now and work
| to get v4 support for v3.13 is not at all unreasonable.  It's a
| simple plan, we end up in the same place, we don't delay merging of
| code, it gives the dirent code wider exposure immediately to early
| adopters and testers, it gives us time to ensure that the v4 code is
| robust and complete before a merge occurs and we split the release
| validation test matrix for the feature over 2 releases rather than
| having to validate them both in the one -rc series. It's a clear win
| for everyone if we take that route.
| 
| The thing that I don't understand is why SGI is in such a *rush* to
| get this feature on v4 superblocks? What's driving SGIs requirement
| that v4 and v5 support be merged *at the same time*? Nobody from SGI
| has actually explained why this is needed and AFICT there is no
| technical reason why it is necessary.

I still don't understand why you are trying to block this feature for
v4 superblocks.  I've attempted to explain the technical reasons why
the feature should go in to 3.12 for v4 superblocks.  The common code
is shared by both v4 and v5 superblocks.  The feature is not enabled by
default on v4 superblocks.  It can only be enabled by a modified mkfs
or by hacking the superblock.  Adding the v4 feature kernel code in
3.12 will allow developers and early adopters to start testing the new
feature in 3.12 kernels when the mkfs patch is available.  There is no
plan or requirement to rush the user space support into the next release.

There is no technical reason at this time to exclude the feature from v4
superblocks.  The only reason given has been vague "process and testing"
requirements, which as far as I can tell are invalid given the fact that
the feature cannot be enabled with the mkfs binaries currently available.
Adding the feature to v4 superblocks adds no additional risk over adding
the feature to v5 superblocks.

| Ben, given that you have decided to try to merge them both for 3.12,
| then someone must have made a convincing argument to you that it is
| absolutely necessary that they must be supported at the same time,
| in the same release, and that it needs to be rushed into 3.12.
| You're not normally this reckless - you have tended to err on the
| conservative side, so I can only conclude that you know something
| that SGI has not told anyone outside of SGI about.
| 
| If there is no reason for v4 support in 3.12 other than "it's in
| v5", then why the rush regardless of the obvious risks that this
| entails? Further, if there is no rush, then why is SGI so stridently
| opposed to the plan I've been stating above?

The v4 and v5 code share common code.  The v4 code has a feature bit to
enable the feature.  The v4 code cannot be enabled with the currently
available userspace binaries.  If that isn't convincing, I don't think I
can convince you that the sky is blue.

| >From my perspective (as the author of the dtype code and that of the
| XFS developer most intimately familiar with the complexity of the
| directory code), if the only way the v5 dtype support is going to be
| merged is when the v4 code is ready to go, then the only decision
| that can be made is to slip dtype support to 3.13 so as to give us
| time to properly review and validate the dtype code on v4
| filesystems before merging it.
| 
| I'm not happy at be forced to compromise further and have this code
| miss 3.12, but SGI is really holding my new code hostage and asking
| for a ransom to be paid before the code can be merged. I can't force
| you to merge it, but if you don't, or you do something exceedingly
| risky instead, then *I want to know why* the maintainer has made
| those decisions.
| 
| I'm very, very, very unhappy about how this situation is unfolding.

As am I.


-- 
Geoffrey Wehrman
gwehrman@sgi.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
