Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id D0EFB7F3F
	for <xfs@oss.sgi.com>; Sun, 27 Oct 2013 21:23:42 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id AC395304039
	for <xfs@oss.sgi.com>; Sun, 27 Oct 2013 19:23:42 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	fBfAV9liVgyoZegI for <xfs@oss.sgi.com>;
	Sun, 27 Oct 2013 19:23:40 -0700 (PDT)
Date: Mon, 28 Oct 2013 13:23:34 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: linux-3.12 userspace
Message-ID: <20131028022334.GL4446@dastard>
References: <526A6FF9.8000506@sgi.com> <526A87F4.2020207@sandeen.net>
	<526AB077.6030800@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <526AB077.6030800@sgi.com>
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
To: Rich Johnston <rjohnston@sgi.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, xfs-oss <xfs@oss.sgi.com>

On Fri, Oct 25, 2013 at 12:55:03PM -0500, Rich Johnston wrote:
> On 10/25/2013 10:02 AM, Eric Sandeen wrote:
> >On 10/25/13 8:19 AM, Rich Johnston wrote:
> >>Hey Folks,
> >>
> >>Dave Chinner has a 32 part userspace patchset that needs to be
> >>reviewed and will be committed to coincide with the linux-3.12
> >>kernel release.
>
> I was referring to userspace ( hence the subject ;) ) matching
> kernel.

Kernel and userspace don't release on the same schedule.

> >We'd want to get kernelspace merged in the xfs git tree well
> >before the merge window,
>
> Yup Ben is working on it.

Everyone can review kernel patches, not just Ben. The more eyes
looking at the code the faster the process will go.

> >and I don't think the kernel merge window needs to affect
> >userspace merges.
>
> Umm yes I need to wait until the kernel supports the feature
> before adding it to userspace.  AFAIR the goal was to have
> userspace features match the kernelspace.

The issue is not todo with release schedules, but whether patches
are committed to the git trees or not.

That is, for code shared between kernel and userspace, the process
is effectively:

kernel side:			userspace side:

propose patch			propose equivalent patch
review cycle:			review cycle:
	address comments		address comments
	update with userspace changes	update with kernel side changes
	test				test
	repost				repost
reviewed-by given
commit to xfs-oss tree
				update match kernel commit
				repost
				commit to xfsprogs tree

However, for pure userspace patches (like the write support for
xfs_db patches), there is not co-ordination needed with the kernel
patches. Those patches can be reviewed immediately, even if they
have a dependency on the shared code patches. All that means is that
they have to be committed *after* the above process for shared
patches completes. 

> >Can you talk in more specifics (which series/patches, for what
> >codebase) you're proposing?
>
> Yes I was referring to "[PATCH 00/32] xfsprogs: V5 write support
> for xfs_db" http://oss.sgi.com/archives/xfs/2013-09/msg00805.html
> Which needs to be reviewed before I can pull it in.

what that userspace series looks like from a
process point of view is this:

First N patches:
	- shared code already committed to kernel
	- review and commit required only
Second M patches
	- shared code not yet committed to kernel
	- kernel and user review process as per above
Last O patches
	- userspace only patches
	- review and commit required only
	- commit dependent on previous shared patches being ready
	  for commit.

IOWs, N has no dependency, M are dependent on kernel commits, and O
are dependent only on N and M being committed to userspace. At no
stage does the fact that committing M first requires kernel commits
prevent review of N, M or O from occurring....

i.e. we can review userspace code without needing to immediately
commit it!

> I was asking for any other userspace patches that need to be
> pulled in for the next userspace release so it matches kernel
> 3.12.

We don't do userspace releases to match kernel releases. They are
independent and asynchronous. We try to have functional userspace changes
committed to the dev tree to match kernel releases (e.g. mkfs/repair
support for a new feature) but that doesn't mean that we need exact
code parity between the kernel and userspace at the same time.

> >In general I think we simply have a review bottleneck, but once
> >patchsets are reviewed, in general, they should just get merged,
> >especially in userspace, IMHO.
>
> No I was chastised for pulling in reviewed userspace patches too
> early.  Kernel code was not fully hashed out.

Sure, but that has nothing to do with release schedules for kernel
and userspace code. That's a process problem, and one that should
not happen because we've explained the reason for the process being
the way it is several times in the past. It was highlighted again
most recently with the build breakage that Mark caused by porting a
userspace patch back to the the kernel and then not compile testing
it before it was committed...

Ben, as the XFS Maintainer, it is your responsibility to ensure that
engineers doing work on your behalf understand what they are doing
and what processes they need to follow. Can you please get together
with Rich and provide him with the knowledge and oversight he needs
to understand how to manage multiple developers and large patch
series so he can avoid making further mistakes?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
