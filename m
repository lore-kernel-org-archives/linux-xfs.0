Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33416C48BD1
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Jun 2021 22:04:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 16D1D613F4
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Jun 2021 22:04:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230190AbhFIWGJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 9 Jun 2021 18:06:09 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:58594 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229947AbhFIWGF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 9 Jun 2021 18:06:05 -0400
Received: from dread.disaster.area (pa49-179-138-183.pa.nsw.optusnet.com.au [49.179.138.183])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 4D9608666C7;
        Thu, 10 Jun 2021 08:03:51 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lr6IV-00Av6o-PE; Thu, 10 Jun 2021 08:03:39 +1000
Date:   Thu, 10 Jun 2021 08:03:39 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Allison Henderson <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [GIT PULL] xfs: Delay Ready Attributes
Message-ID: <20210609220339.GO664593@dread.disaster.area>
References: <20210609194447.10600-1-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210609194447.10600-1-allison.henderson@oracle.com>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=F8MpiZpN c=1 sm=1 tr=0
        a=MnllW2CieawZLw/OcHE/Ng==:117 a=MnllW2CieawZLw/OcHE/Ng==:17
        a=kj9zAlcOel0A:10 a=r6YtysWOX24A:10 a=7-415B0cAAAA:8
        a=cmtwn1_pvDLKzlOutJsA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jun 09, 2021 at 12:44:47PM -0700, Allison Henderson wrote:
> Hi Darrick,
> 
> I've created a branch and tag for the delay ready attribute series.  I'ved
> added the rvbs since the last review, but otherwise it is unchanged since
> v20.
> 
> Please pull from the tag decsribed below.

Yay! At last! Good work, Allison. :)

Nothing to worry about here, but I thought I'd make an observation
on the construction branches for pull requests seeing as pull
request are becoming our way of saying "this code is ready to
merge". 

> Thanks!
> Allison
> 
> The following changes since commit 0fe0bbe00a6fb77adf75085b7d06b71a830dd6f2:
> 
>   xfs: bunmapi has unnecessary AG lock ordering issues (2021-05-27 08:11:24 -0700)

This looks like it has been built on top of a specific commit in the
linux-xfs tree - perhaps a for-next branch before all the most
recent development branches have been merged in.

The problem with doing this is that the for-next tree can rebase,
which can leave your tree with orphaned commits that are no longer
in the main development branch or upstream. While these commits
are upstream now, this isn't an issue for this particular branch
and pull request.

i.e. if the recent rebase of the for-next branch rewrote the above
commit, pulling this branch would cause all sorts of problems.

So to avoid this sort of issue with pull requests, and to allow the
maintainer (darrick) to be able to easily reformulate the for-next
tree just by merging branches, pull requests should all come from a
known upstream base. In the case of pull requests for the xfs tree,
that known base is the master branch of the XFS tree.

The only time that you wouldn't do this is when your work is
dependent on some other set of fixes. Those fixes then need to be
in a stable upstream branch somewhere, which you then merge into
your own dev branch based on xfs/master and the put your own commits
on top of. IOWs, you start your own branch with a merge commit...

If you do this, you should note in the pull request that there are
other branches merged into this pull request and where they came
from. THat way the maintainer can determine if the branch is
actually stable and will end up being merged upstream unchanged from
it's current state.

It is also nice to tell the maintainer that you've based the branch
on a stable XFS commit ahead of the current master branch. This
might be necessary because there's a dependency between multiple
development branches that are being merged one at a time in seperate
pull requests.

In terms of workflow, what this means is that development is done on
a xfs/master based branch. i.e. dev branches are built like this:

$ git checkout -b dev-branch-1 xfs/master
$ git merge remote/stable-dev-branch
$ git merge local-dependent-dev-branch
$ <apply all your changes>
$ <build kernel and test>

And for testing against the latest -rc (say 5.13-rc5) and for-next
kernels you do:

$ git checkout -b testing v5.13-rc5
$ git merge xfs/for-next
$ git merge dev-branch-1
<resolve conflicts>
$ git merge dev-branch-2
<resolve conflicts>
....
$ git merge dev-branch-N
<resolve conflicts>
$ <build kernel and test>

This means that each dev branch has all the correct dependencies
built into it, and they can be pulled by anyone without perturbing
their local tree for testing and review because they are all working
on the same xfs/master branch as your branches are.

This also means that the xfs/for-next tree can remain based on
xfs/master and be reformulated against xfs/master in a repeatable
manner. It just makes everything easier if all pull requests are
sent from the same stable base commit...

Anyway, this isn't an issue for this pull-req because it is based on
a stable XFS commit in a branch based on xfs/master, but I thought
it's worth pointing out the pitfalls of using random stable commits
as the base for pull requests so everyone knows what they should be
doing as it's not really documented anywhere. :)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
