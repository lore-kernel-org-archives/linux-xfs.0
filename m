Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id F34317F6A
	for <xfs@oss.sgi.com>; Sun, 30 Mar 2014 21:51:58 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id E46FE8F8033
	for <xfs@oss.sgi.com>; Sun, 30 Mar 2014 19:51:55 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	meFrZ3q02wfFBJzH for <xfs@oss.sgi.com>;
	Sun, 30 Mar 2014 19:51:53 -0700 (PDT)
Date: Mon, 31 Mar 2014 13:51:48 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [Lsf] [PATCH] xfstests-bld: Simplify determination of number of
	CPUs in build-all
Message-ID: <20140331025148.GF16336@dastard>
References: <1395997399-3000-1-git-send-email-sedat.dilek@gmail.com>
	<20140328161806.GA31772@thunk.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140328161806.GA31772@thunk.org>
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
To: tytso@mit.edu
Cc: Sedat Dilek <sedat.dilek@gmail.com>, lsf@lists.linux-foundation.org, linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com

[cc'ing the xfstests list: xfs@oss.sgi.com]

On Fri, Mar 28, 2014 at 12:18:06PM -0400, tytso@mit.edu wrote:
> If we start getting a huge number of patches to xfstests-bld, and
> people start getting confused/annoyed about how xfstests-bld issues
> get discussed on linux-ext4@vger.kernel.org, while xfstests patches
> and discussion happen on xfs@oss.sgi.com, we could consider creating a
> new mailing list ---

/me puts on his xfstests Maintainer Hat

That's a problem of your own making, Ted: please don't speak on
behalf of what the upstream xfstests developers might or might not
do just because of what you do with it as a user. The existance of
many different environments people have built up around it is one of
the strengths of xfstests. Hence the very act of considering
enforcing One True Way of running xfstests is, IMO, harmful
to the wider filesystem and xfstests community.

You're also being rather presumptive that the existence of
xfstests-bld requires us to change anything about the way xfstests
is run.  Your xfstests environment - while interesting and
potentially useful to others - is not unique and is not the only way
of doing in-place testing.

> especially given that based on a challenge which
> Greg K-H gave us at the kernel pannel at Collab Summit,
               ^^^^

Hmmmm. Not the way I remember it. Perhaps I should go look at the
video and check that Greg was addressing me directly as the xfstests
maintainer with those comments. After all, those lights on stage can
be blinding.....

> we'll at least
> be looking at cleaning up and then trying to get into the linux kernel
> mainline sources some combination of xfstests plus some infrastructure
> automation (perhaps strongly based on what I've been working here in
> the xfstests-bld tree) to run xfstests.

Now you're pre-empting the discussions we need to have about
xfstests and what best serves it's user community. xfstests is
consumed by many end-users that are not kernel developers (e.g.
distro QA departments, storage product vendors, etc), so anything we
decide needs to work not only for kernel developers but also benefit
the wider community of xfstests users.

There are many advantages even to filesystem developers to
staying outside the kernel tree. Think about this for a moment: to
update xfstests to pick up a new regression test to test a
regression, you need to update the kernel tree. That will also pull
in the fix for the regression. To revert the kernel tree to before
the fix came in so that you can run before/after fix comfirmation,
it also removes the new regression test from xfstests harness and so
you can't run the regression test in place.

IOWs, bisects based on regression tests become rather difficult
because of this - bisects require the test not to change from
bisection point to bisection point, and running xfstests directly out
of the kernel tree that you are building kernels from during the
bisect is going to have this exact problem.

Therefore, *if* we move xfstests to the kernel tree we will still
need to maintain that flexibility and configurability of the current
code so that developers and external users can continue to package
the tests up into their own QA environment. That implies we need to
work out packaging and distribution issues that we don't currently
care about, as well as some method of in-place test execution for
people like Greg doing -stable kernel testing.

So, rather than going off half-cocked about some random build
environment for xfstests defining the future of filesystem testing,
we need to step back and think about what Greg actually wants. That
is, "make tests" in the kernel tests/ tree to be able to run
xfstests. That's the problem Greg wanted solved, and that does not
necessarily mean wholesale changes to xfstests or it's development
model. And one possible solution to this is simply making the kernel
tests/ directory just another downstream consumer of the upstream
xfstests project....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
