Return-Path: <SRS0=OPd9=7K=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 485D3C433DF
	for <linux-xfs@archiver.kernel.org>; Thu, 28 May 2020 00:04:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 271D7207D3
	for <linux-xfs@archiver.kernel.org>; Thu, 28 May 2020 00:04:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725681AbgE1AE1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 27 May 2020 20:04:27 -0400
Received: from mail106.syd.optusnet.com.au ([211.29.132.42]:33770 "EHLO
        mail106.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725294AbgE1AE1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 27 May 2020 20:04:27 -0400
Received: from dread.disaster.area (pa49-195-157-175.pa.nsw.optusnet.com.au [49.195.157.175])
        by mail106.syd.optusnet.com.au (Postfix) with ESMTPS id F40705AC86A;
        Thu, 28 May 2020 10:04:00 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1je61X-0001IB-A4; Thu, 28 May 2020 10:03:51 +1000
Date:   Thu, 28 May 2020 10:03:51 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: Re: [XFS SUMMIT] Ugh, Rebasing Sucks!
Message-ID: <20200528000351.GA2040@dread.disaster.area>
References: <20200527184858.GM8230@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200527184858.GM8230@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=X6os11be c=1 sm=1 tr=0
        a=ONQRW0k9raierNYdzxQi9Q==:117 a=ONQRW0k9raierNYdzxQi9Q==:17
        a=kj9zAlcOel0A:10 a=sTwFKg_x9MkA:10 a=7-415B0cAAAA:8
        a=DHIEruG9mEWbTF_yWHUA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, May 27, 2020 at 11:48:58AM -0700, Darrick J. Wong wrote:
> Hi everyone,
> 
> Many of you have complained (both publicly and privately) about the
> heavy cost of rebasing your development trees, particularly when you're
> getting close to sending a series out for review.  I get it, there have
> been a lot of large refactoring patchsets coming in the past few kernel
> cycles, and this has caused a lot of treewide churn.  I don't mind
> cleanups of things that have been weird and wonky about XFS for years,
> but, frankly, rebasing is soul-grinding.
> 
> To that end, I propose reducing the frequency of (my own) for-next
> pushes to reduce how often people feel compelled to rebase when they're
> trying to get a series ready for review.
> 
> Specifically, I would like to make an informal for-next push schedule as
> follows:
> 
>  1 Between -rc1 and -rc4, I'll collect critical bug fixes for the
>    merge window that just closed.  These should be small changes, so
>    I'll put them out incrementally with the goal of landing everything
>    in -rc4, and they shouldn't cause major disruptions for anyone else
>    working on a big patchset.  This is more or less what I've been doing
>    up till now -- if it's been on the list for > 24h and someone's
>    reviewed it, I'll put it in for-next for wider testing.
> 
>  2 A day or two after -rc4 drops.  This push is targeted for the next
>    merge window.  Coming three weeks after -rc1, I hope this will give
>    everyone enough time for a round of rebase, review, and debugging of
>    large changesets after -rc1.  IOWs, the majority of patchsets should
>    be ready to go in before we get halfway to the next merge window.
> 
>  3 Another push a day or two after -rc6 drops.  This will hopefully give
>    everyone a second chance to land patchsets that were nearly ready but
>    didn't quite make it for -rc4; or other cleanups that would have
>    interfered with the first round.  Once this is out, we're more or
>    less finished with the big patchsets.

This seems like a reasonable compromise - knowing when updates are
expected goes a long way to being able to plan development and
schedule dev tree updates to avoid repeated rebasing.

>  4 Perhaps another big push a day or two after -rc8 drops?  I'm not keen
>    on doing this.  It's not often that the kernel goes beyond -rc6 and I
>    find it really stressful when the -rc's drag on but people keep
>    sending large new patchsets.  Talk about stumbling around in the
>    dark...

IMO it's too late at -rc8 to be including big new changes for the
merge window. Bug fixes are fine, but not cleanups or features at
this point because there's too little test and soak time to catch
brown paper bag bugs before it's in the mainline tree and in much
more widespread use.

Same goes for merging new stuff during the merge window - last time
around we had updates right up to the merge window, then an update
during the merge window for a second pull request. There just wasn't
any time when the tree wasn't actively moving forward.

From my perspective, an update from for-next after the -rc6 update
gets me all the stuff that will be in the next release. That's the
major rebase for my work, and everything pulled in from for-next
starts getting test coverage a couple of weeks out from the merge
window.  Once the merge window closes, another local update to the
-rc1 kernel (which should be a no-op for all XFS work) then gets
test coverage for the next release. -rc1 to -rc4 is when
review/rework for whatever I want merged in -rc4/-rc6 would get
posted to the list....

This means there's a single rebase event a cycle at -rc6, and the
rest of the time the tree is pretty stable and the base tree I'm
testing is almost always the tree that we need to focus dev testing
on. That is, just before the merge window everyone should be testing
for-next on a -rc6/-rc7 base, and once -rc1 is out, everyone should
be testing that kernel through to ~-rc4 at which point it has
largely stabilised and the cycle starts again....

>  5 Obviously, I wouldn't hold back on critical bug fixes to things that
>    are broken in for-next, since the goal is to promote testing, not
>    hinder it.

*nod*

> Hopefully this will cut down on the "arrrgh I was almost ready to send
> this but then for-next jumped and nggghghghg" feelings. :/
> 
> Thoughts?  Flames?

Perhaps:

- each patch set that is posted should start with "this is aimed at
  a 5.x.y-rc4/-rc6 merge" or "still work in progress" so that
  everyone has some expectation of when changes are likely to land.

or:

- aim to land features and complex bug fixes in -rc4 and cleanups in
  -rc6, that way we naturally minimise the rebase work for the
  features/bug fixes that are being landed. This may mean that -rc4
  is a small merge if there are no features/bug fixes that meet the
  -rc4 merge criteria...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
