Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6278FC48BD1
	for <linux-xfs@archiver.kernel.org>; Thu, 10 Jun 2021 00:28:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 45B6A613EF
	for <linux-xfs@archiver.kernel.org>; Thu, 10 Jun 2021 00:28:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229792AbhFJAaE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 9 Jun 2021 20:30:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:52314 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229507AbhFJAaC (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 9 Jun 2021 20:30:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5CC876136D;
        Thu, 10 Jun 2021 00:28:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623284887;
        bh=3K5m45O25/Rc7bZH6Ipmn6+iGJ+OBLPPq5S2W6ne0ag=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hzGFbErpnyRGvm8XcohAnq7SquZ73SFNe5Ql/HeYf79bqzX54LWDo6Wa4XJAFa7aw
         5dAW0cbeCanlYDTolUYxbTIk9zE8uuim7jskp8Pg56g7W6OrP9FVYDZ1Zxe/a3KU7v
         z/fYCYWnVQz4RbdV6LHqZtHo/jmOtvcNcHc7Ze/KLtDFyIuq6McAH1F0kVHfizftsJ
         /FI/L/HpFSR81nOzB7w+VwPm143QwvdFbWRY0MRd0nKlQN4a+9DJYpuYei+wer9vk+
         UUHVZFsBfxwU58zz0Zymna+md6N48WbM7dj48KWCMKhblTULqQIZooEsolSHY1VRs0
         XS6m13pdTCeZA==
Date:   Wed, 9 Jun 2021 17:28:06 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Allison Henderson <allison.henderson@oracle.com>,
        linux-xfs@vger.kernel.org
Subject: Re: [GIT PULL] xfs: Delay Ready Attributes
Message-ID: <20210610002806.GA2945738@locust>
References: <20210609194447.10600-1-allison.henderson@oracle.com>
 <20210609220339.GO664593@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210609220339.GO664593@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jun 10, 2021 at 08:03:39AM +1000, Dave Chinner wrote:
> On Wed, Jun 09, 2021 at 12:44:47PM -0700, Allison Henderson wrote:
> > Hi Darrick,
> > 
> > I've created a branch and tag for the delay ready attribute series.  I'ved
> > added the rvbs since the last review, but otherwise it is unchanged since
> > v20.
> > 
> > Please pull from the tag decsribed below.
> 
> Yay! At last! Good work, Allison. :)

Yes, indeed.  Pulled!

> Nothing to worry about here, but I thought I'd make an observation
> on the construction branches for pull requests seeing as pull
> request are becoming our way of saying "this code is ready to
> merge". 
> 
> > Thanks!
> > Allison
> > 
> > The following changes since commit 0fe0bbe00a6fb77adf75085b7d06b71a830dd6f2:
> > 
> >   xfs: bunmapi has unnecessary AG lock ordering issues (2021-05-27 08:11:24 -0700)
> 
> This looks like it has been built on top of a specific commit in the
> linux-xfs tree - perhaps a for-next branch before all the most
> recent development branches have been merged in.

Yes, it's the xfs-5.13-fixes-3 tag at the end of the 5.13 fixes branch.

> The problem with doing this is that the for-next tree can rebase,
> which can leave your tree with orphaned commits that are no longer
> in the main development branch or upstream. While these commits
> are upstream now, this isn't an issue for this particular branch
> and pull request.
> 
> i.e. if the recent rebase of the for-next branch rewrote the above
> commit, pulling this branch would cause all sorts of problems.
> 
> So to avoid this sort of issue with pull requests, and to allow the
> maintainer (darrick) to be able to easily reformulate the for-next
> tree just by merging branches, pull requests should all come from a
> known upstream base. In the case of pull requests for the xfs tree,
> that known base is the master branch of the XFS tree.

This is a good point.  Branches should be based off of something that's
stable, recent, and relatively close to the current development work.

Ideally that would be for-next, but I hadn't actually declared that
stable yet since I just started accepting pull requests and wanted a
couple of days to make sure nothing totally weird happened with Stephen
Rothwell's integration merge.

With for-next in flux, basing your branch off the end of the fixes
branch, or an upstream Linus release some time after that, are good
enough choices... since I hadn't updated xfs-linux.git#master in a
while.

For the past 4.5 years, the pattern has always been that the most recent
fixes branch (xfs-5.X-fixes) gets merged into upstream before I create
the xfs-5.(X+1)-merge branch.  This could get murky if I ever have
enough bandwidth to be building a fixes branch and a merge branch at the
same time, but TBH if xfs is so unstable that we /need/ fixes past -rc4
then we really should concentrate on that at the expense of merging new
code.

I guess that means I should be updating xfs-linux.git#master to point to
the most recent -rc with any Xfs changes in it.

> The only time that you wouldn't do this is when your work is
> dependent on some other set of fixes. Those fixes then need to be
> in a stable upstream branch somewhere, which you then merge into
> your own dev branch based on xfs/master and the put your own commits
> on top of. IOWs, you start your own branch with a merge commit...
> 
> If you do this, you should note in the pull request that there are
> other branches merged into this pull request and where they came
> from. THat way the maintainer can determine if the branch is
> actually stable and will end up being merged upstream unchanged from
> it's current state.
> 
> It is also nice to tell the maintainer that you've based the branch
> on a stable XFS commit ahead of the current master branch. This
> might be necessary because there's a dependency between multiple
> development branches that are being merged one at a time in seperate
> pull requests.

Agreed.

> 
> In terms of workflow, what this means is that development is done on
> a xfs/master based branch. i.e. dev branches are built like this:
> 
> $ git checkout -b dev-branch-1 xfs/master
> $ git merge remote/stable-dev-branch
> $ git merge local-dependent-dev-branch
> $ <apply all your changes>
> $ <build kernel and test>
> 
> And for testing against the latest -rc (say 5.13-rc5) and for-next
> kernels you do:
> 
> $ git checkout -b testing v5.13-rc5
> $ git merge xfs/for-next
> $ git merge dev-branch-1
> <resolve conflicts>
> $ git merge dev-branch-2
> <resolve conflicts>
> ....
> $ git merge dev-branch-N
> <resolve conflicts>
> $ <build kernel and test>

Whee, the modern era... :)

> This means that each dev branch has all the correct dependencies
> built into it, and they can be pulled by anyone without perturbing
> their local tree for testing and review because they are all working
> on the same xfs/master branch as your branches are.
> 
> This also means that the xfs/for-next tree can remain based on
> xfs/master and be reformulated against xfs/master in a repeatable
> manner. It just makes everything easier if all pull requests are
> sent from the same stable base commit...
> 
> Anyway, this isn't an issue for this pull-req because it is based on
> a stable XFS commit in a branch based on xfs/master, but I thought
> it's worth pointing out the pitfalls of using random stable commits
> as the base for pull requests so everyone knows what they should be
> doing as it's not really documented anywhere. :)

Agreed, though this isn't entirely a "random stable commit", it's the
end of the most recent stable branch.

--D

> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
