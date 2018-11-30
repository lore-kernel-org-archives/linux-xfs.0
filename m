Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:38538 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725847AbeLAHqF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 1 Dec 2018 02:46:05 -0500
Date: Fri, 30 Nov 2018 12:35:27 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH AUTOSEL 4.14 25/35] iomap: sub-block dio needs to zeroout
 beyond EOF
Message-ID: <20181130203527.GP8125@magnolia>
References: <20181129060110.159878-1-sashal@kernel.org>
 <20181129060110.159878-25-sashal@kernel.org>
 <20181129121458.GK19305@dastard>
 <20181129124756.GA25945@kroah.com>
 <20181129224019.GM19305@dastard>
 <20181130082203.GA26830@kroah.com>
 <20181130101441.GA213156@sasha-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181130101441.GA213156@sasha-vm>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Sasha Levin <sashal@kernel.org>
Cc: Greg KH <gregkh@linuxfoundation.org>, Dave Chinner <david@fromorbit.com>, stable@vger.kernel.org, linux-kernel@vger.kernel.org, Dave Chinner <dchinner@redhat.com>, linux-fsdevel@vger.kernel.org, xfs <linux-xfs@vger.kernel.org>

On Fri, Nov 30, 2018 at 05:14:41AM -0500, Sasha Levin wrote:
> On Fri, Nov 30, 2018 at 09:22:03AM +0100, Greg KH wrote:
> > On Fri, Nov 30, 2018 at 09:40:19AM +1100, Dave Chinner wrote:
> > > I stopped my tests at 5 billion ops yesterday (i.e. 20 billion ops
> > > aggregate) to focus on testing the copy_file_range() changes, but
> > > Darrick's tests are still ongoing and have passed 40 billion ops in
> > > aggregate over the past few days.
> > > 
> > > The reason we are running these so long is that we've seen fsx data
> > > corruption failures after 12+ hours of runtime and hundreds of
> > > millions of ops. Hence the testing for backported fixes will need to
> > > replicate these test runs across multiple configurations for
> > > multiple days before we have any confidence that we've actually
> > > fixed the data corruptions and not introduced any new ones.
> > > 
> > > If you pull only a small subset of the fixes, the fsx will still
> > > fail and we have no real way of actually verifying that there have
> > > been no regression introduced by the backport.  IOWs, there's a
> > > /massive/ amount of QA needed for ensuring that these backports work
> > > correctly.
> > > 
> > > Right now the XFS developers don't have the time or resources
> > > available to validate stable backports are correct and regression
> > > fre because we are focussed on ensuring the upstream fixes we've
> > > already made (and are still writing) are solid and reliable.

I feel the need to contribute my own interpretation of what's been going
on the last four months:

What you're seeing is not the usual level of reluctance to backport
fixes to LTS kernels, it's our own frustrations at the kernel
community's systemic inability to QA new fs features properly.

Four months ago (prior to 4.19) Zorro started digging into periodic test
failures with shared/010, which resulted in some fixes to the btrfs
dedupe and clone range ioctl implementations.  He then saw the same
failures on XFS.

Dave and I stared at the btrfs patches for a while, then started looking
at the xfs counterparts, and realized that nobody had ever added those
commands to the fstests stressor programs, nor had anyone ever encoded
into a test the side effects of a file remap (mtime update, removal of
suid).  Nor were there any tests to ensure that these ioctls couldn't be
abused to violate system security and stability constraints.

That's why I refactored a whole ton of vfs file remap code for 4.20, and
(with the help of Dave and Brian and others) worked on fixing all the
problems where fsx and fsstress demonstrate file corruption problems.

Then we started asking the same questions of the copy_file_range system
call, and discovered that yes, we have all of the same problems.  We
also discovered several failure cases that aren't mentioned in any
documentation, which has complicated the generation of automatable
tests.  Worse yet, the stressor programs fell over even sooner with the
fallback splice implementation.

TLDR: New features show up in the vfs without a lot of design
documentation, incomplete userspace interface manuals, and not much
beyond trivial testing.

So the problem I'm facing here is that the XFS team are singlehandedly
trying to pay off years of accumulated technical debt in the vfs.  We
definitely had a role in adding to that debt, so we're fixing it.

Dave is now refactoring the copy_file_range backend to implement all the
necessary security and stability checks, and I'm still QAing all the
stuff we've added to 4.20.

We're not finished, where "finished" means that we can get /one/ kernel
tree to go ~100 billion fsxops without burping up failures, and we've
written fstests to check that said kernel can handle correctly all the
weird side cases.

Until all those fstests go upstream, I don't want to spread out into
backporting and testing LTS kernels, even with test automation.  By the
time we're done with all our upstream work you ought to be able to
autosel backport the whole mess into the LTS kernels /and/ fstests will
be able to tell you if the autosel has succeeded without causing any
obvious regressions.

> > Ok, that's fine, so users of XFS should wait until the 4.20 release
> > before relying on it?  :)

At the rate we're going, we're not going to finish until 4.21, but yes,
let's wait until 4.20 is closer to release to start in on porting all of
its fixes to 4.14/4.19.

> It's getting to the point that with the amount of known issues with XFS
> on LTS kernels it makes sense to mark it as CONFIG_BROKEN.

These aren't all issues specific to XFS; some plague every fs in subtle
weird ways that only show up with extreme testing.  We need the extreme
testing to flush out as many bugs as we can before enabling the feature
by default.  XFS reflink is not enabled by default and due to all this
is not likely to get it any time soon.

(That copy_file_range syscall should have been rigorously tested before
it was turned on in the kernel...)

> > I understand your reluctance to want to backport anything, but it really
> > feels like you are not even allowing for fixes that are "obviously
> > right" to be backported either, even after they pass testing.  Which
> > isn't ok for your users.
> 
> Do the XFS maintainers expect users to always use the latest upstream
> kernel?

For features that are EXPERIMENTAL or aren't enabled by default, yes,
they should be.

--D

> 
> --
> Thanks,
> Sasha
