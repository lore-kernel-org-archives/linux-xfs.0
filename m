Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id ABE617FB7
	for <xfs@oss.sgi.com>; Wed, 21 Aug 2013 21:03:09 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 88FEF8F8035
	for <xfs@oss.sgi.com>; Wed, 21 Aug 2013 19:03:06 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	7bFALcddxXDaxpSL for <xfs@oss.sgi.com>;
	Wed, 21 Aug 2013 19:03:02 -0700 (PDT)
Date: Thu, 22 Aug 2013 12:02:26 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 51/50] xfs: add xfs sb v4 support for dirent filetype field
Message-ID: <20130822020226.GR6023@dastard>
References: <1376304611-22994-1-git-send-email-david@fromorbit.com>
	<20130819201940.516942026@sgi.com> <5212AA1D.3000809@sandeen.net>
	<52137D3D.8060205@sgi.com> <20130821000624.GO6023@dastard>
	<20130821170336.GJ5262@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130821170336.GJ5262@sgi.com>
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
To: Ben Myers <bpm@sgi.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, Mark Tinguely <tinguely@sgi.com>, xfs@oss.sgi.com

On Wed, Aug 21, 2013 at 12:03:36PM -0500, Ben Myers wrote:
> Hi Dave,
> 
> On Wed, Aug 21, 2013 at 10:06:24AM +1000, Dave Chinner wrote:
> > On Tue, Aug 20, 2013 at 09:29:17AM -0500, Mark Tinguely wrote:
> > > I repeat, if you have technical concerns for the feature's
> > > implementation and its impact on v4 filesystems because it uses
> > > common directory code, then it should be held back for more testing.
> > 
> > I missed this comment. Mark, I'm really concerned that SGI is taking
> > the stance that the dtype code is fully working unless otherwise
> > proven to have problems.  That is a dangerous approach to take for
> > new code and new on-disk formats - it should be considered with
> > suspicion and paranoia until enough testing has been done to negate
> > those concerns.
> > 
> > The reason I only proposed this for v5 superblocks is to enable
> > wider testing and get us to the point where we are not concerned
> > anymore about it before we say it is ready for production
> > deployment.
> > 
> > I have technical concerns that arise once the feature bit it
> > enabled, not when it is disabled. Those technical concerns center
> > around off-by-one and alignment issues as a result of increasing the
> > dirent size when the feature bit is enabled - they pack differently
> > into the directory structure and hence will exercise allocation,
> > freespace and logging differently.
> > 
> > See my previous comments about how hard the directory code is to
> > test and validate - that's why I want to enable in V5 first so we
> > can shake out problems over a wider (but still constrained) user
> > base that understand that EXPERIMENTAL means that they might still
> > be corruption bugs lurking.
> 
> I understand the sentiment that it would be nice to get this into v5 for some
> early initial testing.  However, we agreed to take in the crc work as
> experimental on the condition that it does not regress v4 superblocks, and with
> the knowledge that it might take awhile to be completed.  It's still unfinished
> and that's ok.  We knew that was coming.  But this was an agreement made for
> one feature only.

No, it was made for all the on-disk changes that were proposed for
the new v5 format. The dirent changes were part of that - that's
been the POR for the past couple of years, I was clear and up front
about this and mentioned it several times during the weekly con
calls. I even specifically said at one point that if I don't get it
done for the initial merge that I'd need use an incompat feature bit
for it. At no time during those discussions did SGI say *anything*
about needing it on v4.

No, that didn't happen until I posted the patches for review with
performance numbers attached. And here we are....

Further, I'm seriously concerned that the maintainer is claiming to
be unaware of the the public POR for this feature, especially as
this very feature has specifically talked about and mentioned in the
conctext of CRCs and features in discussions over the past few
months.

> We did not agree that the v5 superblock would become a
> dumping ground for unrelated and incomplete features to get early testing.

I am not using v5 superblocks as a "dumping ground". This feature
was *always* planned solely for v5 superblocks.

> > Again, as I've said all along - enabling the feature on v4
> > filesystems is not a technical problem - it's a process and
> > support problem. If I thought that this code was ready for
> > widespread production deployment then I would have no hesitation
> > to add v4 support, but it's simply not at that stage yet. We
> > need wider test and deployment coverage to get the new feature
> > to that stage.
> >
> > Which leads to the "then it should be held back for more
> > testing" comment. We've discussed this before - almost a year
> > ago now - when SGI stated that they wouldn't accept any new code
> > in the xfsdev tree unless it was proven to be regression free.
> > That was unacceptable then and to apply it to the v5 dirent code
> > is no different.
> > 
> > We need wider testing of these changes before it is production
> > ready, and so holding it back until it's proven to be OK for
> > production deployment in v4 filesystems is placing us in a
> > catch-22 and as such is a similarly an unacceptable outcome.
> 
> If this needs more testing I'm all for it.  We should make it a
> Kconfig option marked as experimental in it's own right,

I don't follow you - what feature do you want to make a compile time
conditional?

> finish the userspace work, and then
> set about pulling it in.  Marking the feature bit as experimental
> in mkfs with a warning also seems like an good idea to me...

What does that acheive that we don't already have?

And, indeed, ext4 proved this a bad idea with their ext4dev flag
and all problems that produced in userspace...

> And
> if you're that concerned about it then I'd really like to see them
> both.  But marking it experimental doesn't magically mean that
> we'll pull in another incomplete feature.

dtype support for v5 is a complete feature from the kernel code
perspective. There's no more kernel code that needs to be written
for it.

> My impression is we're likely to go to -rc7, so I think chances
> are good this work can be finished in time for 3.12.

v4 support is not going to be ready for 3.12. We don't rush new
on-disk format changes, and the v4 code support is nowhere near
complete yet. Ignoring the code that still needs to be written,
there's a lot more verification needed before it gets merged....

The compromise I have suggested of review and merge v5 now and work
to get v4 support for v3.13 is not at all unreasonable.  It's a
simple plan, we end up in the same place, we don't delay merging of
code, it gives the dirent code wider exposure immediately to early
adopters and testers, it gives us time to ensure that the v4 code is
robust and complete before a merge occurs and we split the release
validation test matrix for the feature over 2 releases rather than
having to validate them both in the one -rc series. It's a clear win
for everyone if we take that route.

The thing that I don't understand is why SGI is in such a *rush* to
get this feature on v4 superblocks? What's driving SGIs requirement
that v4 and v5 support be merged *at the same time*? Nobody from SGI
has actually explained why this is needed and AFICT there is no
technical reason why it is necessary.

Ben, given that you have decided to try to merge them both for 3.12,
then someone must have made a convincing argument to you that it is
absolutely necessary that they must be supported at the same time,
in the same release, and that it needs to be rushed into 3.12.
You're not normally this reckless - you have tended to err on the
conservative side, so I can only conclude that you know something
that SGI has not told anyone outside of SGI about.

If there is no reason for v4 support in 3.12 other than "it's in
v5", then why the rush regardless of the obvious risks that this
entails? Further, if there is no rush, then why is SGI so stridently
opposed to the plan I've been stating above?

>From my perspective (as the author of the dtype code and that of the
XFS developer most intimately familiar with the complexity of the
directory code), if the only way the v5 dtype support is going to be
merged is when the v4 code is ready to go, then the only decision
that can be made is to slip dtype support to 3.13 so as to give us
time to properly review and validate the dtype code on v4
filesystems befor merging it.

I'm not happy at be forced to compromise further and have this code
miss 3.12, but SGI is really holding my new code hostage and asking
for a ransom to be paid before the code can be merged. I can't force
you to merge it, but if you don't, or you do something exceedingly
risky instead, then *I want to know why* the maintainer has made
those decisions.

I'm very, very, very unhappy about how this situation is unfolding.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
