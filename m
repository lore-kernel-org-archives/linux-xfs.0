Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q8P0Crro233935 for <xfs@oss.sgi.com>; Mon, 24 Sep 2012 19:12:53 -0500
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	ntHdDCFTvLBjyIGr for <xfs@oss.sgi.com>;
	Mon, 24 Sep 2012 17:14:08 -0700 (PDT)
Date: Tue, 25 Sep 2012 10:14:05 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/3] xfs: restrict allocate worker to x86_64
Message-ID: <20120925001405.GA23520@dastard>
References: <20120919163133.097340199@sgi.com>
	<20120919163145.367256258@sgi.com> <20120919215405.GE31501@dastard>
	<505B546A.6070105@sgi.com> <20120924173723.GH1140@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120924173723.GH1140@sgi.com>
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
To: Ben Myers <bpm@sgi.com>
Cc: Mark Tinguely <tinguely@sgi.com>, xfs@oss.sgi.com

On Mon, Sep 24, 2012 at 12:37:23PM -0500, Ben Myers wrote:
> Hey,
> 
> On Thu, Sep 20, 2012 at 12:37:46PM -0500, Mark Tinguely wrote:
> > On 09/19/12 16:54, Dave Chinner wrote:
> > >On Wed, Sep 19, 2012 at 11:31:34AM -0500, tinguely@sgi.com wrote:
> > >>Restrict the allocation worker to X86_64 machines. This will improve
> > >>performance on non-X86-64 machines and avoid the AGF buffer hang.
> > >>
> > >>Signed-off-by: Mark Tinguely<tinguely@sgi.com>
> > >
> > >NACK.
> > >
> > >The stack overflow problems that this works around are not limited
> > >to x86-64. In the past we've seen overflows on i686 (even with 8k
> > >stacks), s390 and other platforms, so it's not an isolated issue.
> > >
> > >It either works or it doesn't - let's not start down the rathole of
> > >having different code paths and behaviours for different platforms.
> > >
> > >Cheers,
> > >
> > >Dave.
> > 
> > Well, I was expecting a 4 letter word from Dave on this patch and
> > "NACK" was surprisingly mild.
> > 
> > When the allocation worker was placed into XFS, even Christoph
> > wanted a kernel configure switch to be able turn it off.
> > 
> > Dave has already placed a switch in the code that turns it off for
> > over half of the direct callers xfs_alloc_vextent() because a
> > performance issue.
> > 
> > We are just finding places where it causes serious issues.
> > 
> > This is worker is an "necessary evil" (I think those were
> > Christoph's review comment). We should limit the evil to where it is
> > necessary.
> 
> I tend to agree that it is undesireble to have platform specific behaviors in
> XFS.  Dave has a good point.  Mark and Christoph also have valid points.
> 
> This is a platform specific problem so it's reasonable that the solution can be
> platform specific too.

It's not really platform specific. it's just harder to hit on some
platforms than others. The stack usage of XFS on 32 bt platforms is
only about 25% less than on 64 bit platforms through the problematic
allocation path as most of the on stack structures are the same size
on 32 bit and 64 bit - only the size of pointers and registers
change, and they are the miniority of stack usage. Stuff like
xfs_bmalloc_args, xfs_alloc_args and so on only shrink by a few
bytes.

I've seen the x86-64 stack overrung by 3.5k - that's almost a 50%
overrun. That means even if the stack usage is reduces by 25% on
Seeing as we are smashing the 8k x86-64 stack by over 25%, that same
path will smash an 8k stack. We just haven't had anyone report it
because ia32 users are in the minority.

Hence for all the 32 bit platforms with 8k stacks (i.e. all ARM,
MIPS, SH, etc) there is a still a significant risk of stack
overruns. Given the prevalence of XFS on these architectures for NAS
and DVR functionality, there's every chance that stack overflows
occur quite regularly that nobody ever reports or can report....

And even on other 64 bit platforms we know that s390 stack usage is
an issue  because each function call on the stack has a
base register frame of 128 bytes, plus whatever stack is used by the
function. Hence when we are looking at a function call chain of
70-80 functions deep, they really only have half of their available
stack space available for the code usage. i.e. about 8k. Sparc has
the same issue.

Power and ia64 are probably the only arches that don'thave problems
because of their default 64k page size.

IOWs, there are quite a few architectures where XFS is commonly used
that are at risk of stack overflows through the worst case XFS
writeback/allocation path (i.e. when you have a non-trivial
allocation like a double bmbt/abt split, bmbt split with readahead
in the abt, etc). Just because we don't have reports of them
occurring doesn't mean the problem doesn't exist. We simply get
reports from x86-64 users because they make up the vast majority of
XFS deployments and so rare problems are seen (correspondingly) more
frequently....

> If the list of platforms which are broken by having so
> little stack available in the kernel is larger than we'd like... well that's
> unfortunate.  But it's not something we're the cause of, and it speaks to how
> important it is to fix the more general problem.

I've been trying to raise awareness of the problem - the wider
storage community understand that there is a problem, but we're
getting no traction at all with core kernel folk. As far as they are
conerned, it's our problem, not a general problem.

> We shouldn't penalize those who are using platforms which are not affected by
> this problem for the limitations of the other platforms.  OTOH, if we have
> multiple behaviors our testing becomes more difficult.  Nobody wins.

You're forgetting that the performance problems were platform
specific! It only showed up on certain CPUs (i.e. AMD, not intel)
and only on low CPU count (1-4p) machines. So by your argument that
we should only enable this for platforms that don't see performance
issues, we should only do this stack switch for intel x86-64.

See where categorising issues by hardware platform leads? it's a
rat-hole.

> I think it is desireable to be able to turn this off so that users
> can choose how they prefer to lose, and so that this hack
> continues to be easily removable if the time ever comes when we
> can do so.

This is not an option that should be left to users - it is our
responsibility to provide a fit-for-purpose filesystem that doesn't
randomly crash, and one of those responsibilities is to take changes
that you don't like but are necessary for stability across the wider
user base.

I'm not going to change my opinion - if you do make this allocation
workqueue code platform specific, the first thing I'll be doing on
any kernel I'm responsible for is reverting the commit so I know
users are not going to have random outages caused by allocation
related stack overflows.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
