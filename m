Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FD12C433E0
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Mar 2021 00:44:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C328B652A4
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Mar 2021 00:44:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229611AbhCIAoY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 8 Mar 2021 19:44:24 -0500
Received: from mail106.syd.optusnet.com.au ([211.29.132.42]:52422 "EHLO
        mail106.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229749AbhCIAoT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 8 Mar 2021 19:44:19 -0500
Received: from dread.disaster.area (pa49-181-239-12.pa.nsw.optusnet.com.au [49.181.239.12])
        by mail106.syd.optusnet.com.au (Postfix) with ESMTPS id 07F2778A85F;
        Tue,  9 Mar 2021 11:44:10 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lJQTq-000Kfn-4Q; Tue, 09 Mar 2021 11:44:10 +1100
Date:   Tue, 9 Mar 2021 11:44:10 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/3 v2] xfs: AIL needs asynchronous CIL forcing
Message-ID: <20210309004410.GC74031@dread.disaster.area>
References: <20210223053212.3287398-3-david@fromorbit.com>
 <20210224211058.GA4662@dread.disaster.area>
 <20210224232600.GH4662@dread.disaster.area>
 <YD6xrJHgkkHi+7a3@bfoster>
 <20210303005752.GM4662@dread.disaster.area>
 <YD/IN66S3aM1lEQh@bfoster>
 <20210304015933.GO4662@dread.disaster.area>
 <YEDc42Z1GjHBXi6S@bfoster>
 <20210304224848.GR4662@dread.disaster.area>
 <YEJHEt/vt6yuHbak@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YEJHEt/vt6yuHbak@bfoster>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=F8MpiZpN c=1 sm=1 tr=0 cx=a_idp_d
        a=gO82wUwQTSpaJfP49aMSow==:117 a=gO82wUwQTSpaJfP49aMSow==:17
        a=kj9zAlcOel0A:10 a=dESyimp9J3IA:10 a=7-415B0cAAAA:8
        a=wv6fbLyrdsbbpLF9zbIA:9 a=UxIdY4KfFaj0D5R4:21 a=eTjuvqhptYncLwUU:21
        a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Mar 05, 2021 at 09:58:26AM -0500, Brian Foster wrote:
> On Fri, Mar 05, 2021 at 09:48:48AM +1100, Dave Chinner wrote:
> > > > > So not only does this patch expose subsystem internals to
> > > > > external layers and create more log forcing interfaces/behaviors to
> > > > 
> > > > Sorry, I don't follow. What "subsystem internals" are being exposed
> > > > and what external layer are they being exposed to?
> > > > 
> > > > > > Cleaning up the mess that is the xfs_log_* and xlog_* interfaces and
> > > > > > changing things like log force behaviour and implementation is for
> > > > > > a future series.
> > > > > > 
> > > > > 
> > > > > TBH I think this patch is kind of a mess on its own. I think the
> > > > > mechanism it wants to provide is sane, but I've not even got to the
> > > > > point of reviewing _that_ yet because of the seeming dismissal of higher
> > > > > level feedback. I'd rather not go around in circles on this so I'll just
> > > > > offer my summarized feedback to this patch...
> > > > 
> > > > I'm not dismissing review nor am I saying the API cannot or should
> > > > not be improved. I'm simply telling you that I think the additional
> > > > changes you are proposing are outside the scope of the problem I am
> > > > addressing here. I already plan to rework the log force API (and
> > > > others) but doing so it not something that this patchset needs to
> > > > address, or indeed should address.
> > > > 
> > > 
> > > I'm not proposing additional changes nor to rework the log force API.
> > > I'm pointing out that I find this implementation to be extremely and
> > > unnecessarily confusing.
> > 
> > And that's just fine - not everyone has to understand all of the
> > code all of the time. That's why we have a team....
> > 
> > > To improve it, I'm suggesting to either coopt
> > > the existing async log force API...
> > 
> > And I'm telling you that this is *future work*. As the person
> > actually doing the work, that's my decision and you need to accept
> > that. I understand your concerns and have a plan to address them -
> > you just have to accept that the plan to address them isn't going to
> > be exactly to your liking.
> > 
> 
> As a reviewer, I am pointing out that I object to how this patch is
> implemented and offered several fairly simple suggestions on how to
> address my concerns. Those suggestions have been rejected pretty much
> out of hand on the basis of the existence of some future plans.

We're allowed to disagree on the best approach. But to find a way
forward means that both the summitter and the reviewer need to
compromise. I've fixed up the obvious warts and bugs you've pointed
out, and agreed that it needs cleaning up and have committed to
cleaning it up in the near future.

> Future rework plans do not justify or change my view of this patch
> and the mess it adds (for other developers, for historical context
> and downstreams, etc.).  Therefore, if the only option you're
> willing to consider is "make this mess now and clean it up later
> in some broader rework," then I'd rather we just defer this patch
> until after that rework is available and avoid the mess that way.

So you won't review it until I have 100 outstanding patches in this
series and it's completely and utterly unreviewable? Then you'll ask
me to split it up and re-order it into digestable chunks, and so
we'll go back to having to merge this because any of the API rework
that depends on the mechanism that this patch introduces.

I'm not going to play that "now jump through this hoop" game.  We
add flags for on-off behaviours in internal functions -all the
time-. If this makes the interface so complex and confusing that you
don't understand it, then the interface was already too complex and
confusing. And fixing that is *not in the scope of this patchset*.

Demanding that code be made perfect before it can be merged is
really not very helpful. Especially when there are already plans to
rework the API but that rework is dependent on a bunch of other
changes than need to be done first.

iclogs are something that need to be moved behind the CIL, not sit
in front of CIL. The CIL abstracts the journal and writing to the
journal completely away from the transaction subsystem, yet the log
force code punches straight through that abstraction and walks
iclogs directly. The whole log force implementation needs to change,
and I plan for the API that wraps the log forces to get reworked at
that time.

For example, if we want to direct map storage for log writes, then
iclog-based log force synchronisation needs to go away because we
don't need iclogs for buffering journal writes. Hence the log foce
code should interface only with the CIL, and only the CIL should
manage whatever mechanism it is using to write to stable storage.
The code is currently the way it is because the CIL, when first
implemented, had to co-exist with the old way of writing to the log.
We haven't used that old way for a decade now and we have very
different storage performance characteristics these days, so it's
about time we got rid of the mechanism designed to be optimal for
spinning disks and actually integrated the CIL and the log
efficiently.

There are a *lot* of steps to do this, and reworking the log force
implementation and API is part of that. But reworking that API is
premature because we haven't done all the necessary pre-work in
place to make such a change yet. This patch is actually part of that
pre-work to get the mechanisms that the log force rework will rely
on.

I have very good reasons for pushing back against your suggestions,
Brian. Your suggestions have merit but this patch is not the time to
be making the changes you suggest. Code does not need to be perfect
to be merged, nor does the entire larger change they will be part of
need to be complete and 100% tested and reviewed before preparation
and infrastructure patches can be merged. This is how we've done big
changes in the past - they've been staged across multiple kernel
cycles - and not everything needs to be done in the first
patchset of a larger body of work....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
