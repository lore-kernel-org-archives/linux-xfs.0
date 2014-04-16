Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 3B6857F3F
	for <xfs@oss.sgi.com>; Tue, 15 Apr 2014 19:07:23 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 1C18630407E
	for <xfs@oss.sgi.com>; Tue, 15 Apr 2014 17:07:22 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	sYWIE2a1TsSkiLEG for <xfs@oss.sgi.com>;
	Tue, 15 Apr 2014 17:07:18 -0700 (PDT)
Date: Wed, 16 Apr 2014 10:06:35 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] ext4: add fallocate mode blocking for debugging purposes
Message-ID: <20140416000634.GT15995@dastard>
References: <1397420518-29218-1-git-send-email-tytso@mit.edu>
	<20140413220016.GD8122@thunk.org>
	<alpine.LFD.2.00.1404151749490.2146@localhost.localdomain>
	<534D5B2D.70408@redhat.com> <20140415184442.GC4456@thunk.org>
	<534DB38B.7030805@redhat.com> <20140415233039.GR4456@thunk.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140415233039.GR4456@thunk.org>
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
To: Theodore Ts'o <tytso@mit.edu>
Cc: Eric Sandeen <sandeen@redhat.com>, Namjae Jeon <linkinjeon@gmail.com>, Ext4 Developers List <linux-ext4@vger.kernel.org>, xfs@oss.sgi.com, =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>

[added xfs@oss.sgi.com]

On Tue, Apr 15, 2014 at 07:30:39PM -0400, Theodore Ts'o wrote:
> On Tue, Apr 15, 2014 at 05:32:43PM -0500, Eric Sandeen wrote:
> > > I also had a sneaking suspicion that we might have a similar issue
> > > with the INSERT RANGE patches which are coming down the pike, and so
> > > having a general way of also being able INSERT RANGE if to be able to
> > > quickly determine whether a potential bug was caused by INSERT RANGE
> > > or some other pending changes might also be useful.
> > 
> > Also: I'd humbly suggest just not merging those until they pass stringent
> > tests like fsx & fsstress...
> > 
> > Adding a pre-emptive knob to turn them off post-merge when they turn
> > out to be broken sounds backwards to me...
> 
> Having learned from COLLAPSE RANGE, I agree.  The fact that we didn't
> have full testing during the whole development cycle was unfortunate.
> And we got lucky with the renameat patches, since I wasn't able to get
> tha testing done because the xfstests commits didn't get merged until
> *after* the they renameat commits got merged, and also because I
> didn't notice that the i386 system call wasn't wired up when I was
> doing my manual "just before I push to Linus" testing.

I asked for renameat2 tests long before inclusion occurred. The fact
is that we can't co-ordinate xfstests inclusion for a feature that
we don't even know is going to be included until someone sends Linus
a pull request....

> I plan on insisting that INSERT RANGE support being in the VFS, and be
> fully enabled, and that we have full INSERT RANGE testing into
> xfstests, during the development cycle.

There wasn't a problem with the timing of xfstests inclusion - the
problem was with the fact we didn't have sufficient QA coverage in
xfstests when the initial upstream kernel commits occurred.  This
time around, the difference will be that this time we'll have fsx
and fsstress coverage *before* kernel support is added, and I've
already asked for that:

http://oss.sgi.com/archives/xfs/2014-04/msg00121.html

> Some of the work that I've
> been doing with kvm-xfstests and why I created a github tytso/xfstests
> git tree is specifically to make sure things go much more smoothly
> this time around.

Ted, this looks and sounds like you're preparing to fork xfstests.
Why?  What's the problem with working upstream on test development
and refinement like everyone else does?

This thread is a demonstration of how avoiding upstream interaction
results in nasty hacks being proposed. If you asked the question on
the xfs mailing list of how to avoid various fsstress/fsx
operations, we woul dhave told you that using FSSTRESS_AVOID and
adding an equivalent FSX_AVOID to xfstests is all that is needed.
i.e. we already have partial infrastructure support for what you
need in xfstests and it would be about 30 minutes work to add
FSX_AVOID....

Is that fast enough for you?

Indeed, we could also use similar env vars to ensure various
_requires_* checks fail and to populate FSSTRESS_AVOID/FSX_AVOID
automatically and so tests that require this functionality are not
run.

IOWs, it's in your best interests to work with upstream to add the
functionality you require to xfstests. History tells us that forking
development into private repositories has never worked out well for
anyone, so I'd really, really like you to *at least try* to work
with upstream as your primary test development environment....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
