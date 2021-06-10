Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59567C48BCD
	for <linux-xfs@archiver.kernel.org>; Thu, 10 Jun 2021 01:49:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3717361407
	for <linux-xfs@archiver.kernel.org>; Thu, 10 Jun 2021 01:49:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229809AbhFJBvw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 9 Jun 2021 21:51:52 -0400
Received: from mail108.syd.optusnet.com.au ([211.29.132.59]:57118 "EHLO
        mail108.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229507AbhFJBvw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 9 Jun 2021 21:51:52 -0400
Received: from dread.disaster.area (pa49-179-138-183.pa.nsw.optusnet.com.au [49.179.138.183])
        by mail108.syd.optusnet.com.au (Postfix) with ESMTPS id BF1BD1B1035;
        Thu, 10 Jun 2021 11:49:54 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lr9pR-00Ayj5-Cy; Thu, 10 Jun 2021 11:49:53 +1000
Date:   Thu, 10 Jun 2021 11:49:53 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Allison Henderson <allison.henderson@oracle.com>,
        linux-xfs@vger.kernel.org
Subject: Re: [GIT PULL] xfs: Delay Ready Attributes
Message-ID: <20210610014953.GP664593@dread.disaster.area>
References: <20210609194447.10600-1-allison.henderson@oracle.com>
 <20210609220339.GO664593@dread.disaster.area>
 <20210610002806.GA2945738@locust>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210610002806.GA2945738@locust>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=F8MpiZpN c=1 sm=1 tr=0
        a=MnllW2CieawZLw/OcHE/Ng==:117 a=MnllW2CieawZLw/OcHE/Ng==:17
        a=kj9zAlcOel0A:10 a=r6YtysWOX24A:10 a=7-415B0cAAAA:8
        a=hfrnT7B_I2l7Y8N1_nsA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jun 09, 2021 at 05:28:06PM -0700, Darrick J. Wong wrote:
> On Thu, Jun 10, 2021 at 08:03:39AM +1000, Dave Chinner wrote:
> > On Wed, Jun 09, 2021 at 12:44:47PM -0700, Allison Henderson wrote:
> > > Hi Darrick,
> > > 
> > > I've created a branch and tag for the delay ready attribute series.  I'ved
> > > added the rvbs since the last review, but otherwise it is unchanged since
> > > v20.
> > > 
> > > Please pull from the tag decsribed below.
> > 
> > Yay! At last! Good work, Allison. :)
> 
> Yes, indeed.  Pulled!
> 
> > Nothing to worry about here, but I thought I'd make an observation
> > on the construction branches for pull requests seeing as pull
> > request are becoming our way of saying "this code is ready to
> > merge". 
> > 
> > > Thanks!
> > > Allison
> > > 
> > > The following changes since commit 0fe0bbe00a6fb77adf75085b7d06b71a830dd6f2:
> > > 
> > >   xfs: bunmapi has unnecessary AG lock ordering issues (2021-05-27 08:11:24 -0700)
> > 
> > This looks like it has been built on top of a specific commit in the
> > linux-xfs tree - perhaps a for-next branch before all the most
> > recent development branches have been merged in.
> 
> Yes, it's the xfs-5.13-fixes-3 tag at the end of the 5.13 fixes branch.
> 
> > The problem with doing this is that the for-next tree can rebase,
> > which can leave your tree with orphaned commits that are no longer
> > in the main development branch or upstream. While these commits
> > are upstream now, this isn't an issue for this particular branch
> > and pull request.
> > 
> > i.e. if the recent rebase of the for-next branch rewrote the above
> > commit, pulling this branch would cause all sorts of problems.
> > 
> > So to avoid this sort of issue with pull requests, and to allow the
> > maintainer (darrick) to be able to easily reformulate the for-next
> > tree just by merging branches, pull requests should all come from a
> > known upstream base. In the case of pull requests for the xfs tree,
> > that known base is the master branch of the XFS tree.
> 
> This is a good point.  Branches should be based off of something that's
> stable, recent, and relatively close to the current development work.
> 
> Ideally that would be for-next, but I hadn't actually declared that
> stable yet since I just started accepting pull requests and wanted a
> couple of days to make sure nothing totally weird happened with Stephen
> Rothwell's integration merge.

I don't think you should ever declare for-next as a "stable" branch
to base new work on, for the same reason that linux-next isn't
stable. i.e. for-next is a "work in progress" branch that, eventually,
becomes the branch that is merged upstream. It's not actually
something developers can rely on being "stable" until it is tagged
for upstream merge and a pull-request issued.

Really, for-next is the intergration branch - it's first place where
we get wider coverage of the development code via linux-next. There
is -always- a chance that someone using linux-next is going to find
a problem that requires a rebase of the for-next branch to fix, and
so the for-next branch really isn't "stable".

If we need public stable branches for cross-dev development, they
need to be published in their own branch as an explicitly stable
branch. That stable branch can then be merged into dev trees and
for-next like any other stable branch and when those dev branches
are merged into the one tree from multiple sources git will
recognise this and merge them cleanly.

IOWs, for-next is for shaking out problems found during integration
and wider testing, not for commit stability....

> With for-next in flux, basing your branch off the end of the fixes
> branch, or an upstream Linus release some time after that, are good
> enough choices...

The base of topic branch should be a Linus release at or before
(older) the base commit the xfs fixes branch is based off.
Otherwise when the topic branch is merged into the for-next tree, it
will also pull all the commits from the upstream branch that the
for-next tree doesn't have.

IOWs, if the XFS fixes branch is based on 5.13-rc2, then all pull
requests need to be based on either the fixes branch or at or
something earlier than xfs/master. If you base the pull req on
5.13-rc3, then merging the topic branch into for-next will also move
for-next forward to 5.13-rc3. This makes a mess of the tree history,
and Linus will complain about the mess when he sees it...

> since I hadn't updated xfs-linux.git#master in a
> while.

In case I haven't already made it clear, I think the master branch
should only get updated once per release cycle, some time shortly
after the merge window closes.  Ideally this happens around -rc2
so the base is somewhat stable.

/me does a double take

When did xfs/master move forward to 5.13-rc4?

> For the past 4.5 years, the pattern has always been that the most recent
> fixes branch (xfs-5.X-fixes) gets merged into upstream before I create
> the xfs-5.(X+1)-merge branch.  This could get murky if I ever have
> enough bandwidth to be building a fixes branch and a merge branch at the
> same time, but TBH if xfs is so unstable that we /need/ fixes past -rc4
> then we really should concentrate on that at the expense of merging new
> code.
> 
> I guess that means I should be updating xfs-linux.git#master to point to
> the most recent -rc with any Xfs changes in it.

IMO, it should not change at all during a cycle. Having to update
the -fixes branch late in the cycle does not need rebasing the
master branch or the fixes branch. It just means it needs to be
merged into the for-next branch again after the new fix is appended
to it.

Moving the master branch forwards to pick up all the fixes just
leads to downstream problems when people are managing multiple
branches locally. i.e. master branch stability isn't about what is
convenient for building for-next, but about providing a stable base
for all developers that are using the tree to build pull requests.

IOWs, I do not want to be using -rc2 for one set of topic branches,
and then another branch I set up for merge a week later to be based
on -rc4 even though I've used xfs/master as the base for all of
them.  That results in lots of local merge noise and difficultly in
getting diffs between branches. This also causes problems with
explicitly stable branches if they end up being based off different
commits to the rest of the trees.

So unless there's a compelling reason, I don't think the master
branch should move more than once per dev cycle. Everyone should be
using the same base for their pull requests so they can pull each
other's work without getting base kernel revision noise in the
merges...

> > In terms of workflow, what this means is that development is done on
> > a xfs/master based branch. i.e. dev branches are built like this:
> > 
> > $ git checkout -b dev-branch-1 xfs/master
> > $ git merge remote/stable-dev-branch
> > $ git merge local-dependent-dev-branch
> > $ <apply all your changes>
> > $ <build kernel and test>
> > 
> > And for testing against the latest -rc (say 5.13-rc5) and for-next
> > kernels you do:
> > 
> > $ git checkout -b testing v5.13-rc5
> > $ git merge xfs/for-next
> > $ git merge dev-branch-1
> > <resolve conflicts>
> > $ git merge dev-branch-2
> > <resolve conflicts>
> > ....
> > $ git merge dev-branch-N
> > <resolve conflicts>
> > $ <build kernel and test>
> 
> Whee, the modern era... :)

Hardly - that's how I've worked for over a decade :P

(Get Off My Lawn!)

> > Anyway, this isn't an issue for this pull-req because it is based on
> > a stable XFS commit in a branch based on xfs/master, but I thought
> > it's worth pointing out the pitfalls of using random stable commits
> > as the base for pull requests so everyone knows what they should be
> > doing as it's not really documented anywhere. :)
> 
> Agreed, though this isn't entirely a "random stable commit", it's the
> end of the most recent stable branch.

Right, but my point is that where that commit comes from isn't
obvious just by looking at the pull request. I mean, can you tell me
what branch/base kernel is the pull request based on just from the
commit ID and name?

If you look at the pull-reqs I sent you, they say:

The following changes since commit d07f6ca923ea0927a1024dfccafc5b53b61cfecc:

  Linux 5.13-rc2 (2021-05-16 15:27:44 -0700)

are available in the Git repository at:
....

And that is immediately obvious what the pull-req is based on.
That's what xfs/master /was/ based on when I built the topic
branches. Using a common, known base for building branches makes
things easier for everyone....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
