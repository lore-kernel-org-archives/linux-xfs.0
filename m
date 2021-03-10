Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C335CC433E0
	for <linux-xfs@archiver.kernel.org>; Wed, 10 Mar 2021 14:50:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7C63064EF9
	for <linux-xfs@archiver.kernel.org>; Wed, 10 Mar 2021 14:50:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231326AbhCJOuD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 10 Mar 2021 09:50:03 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:31706 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230341AbhCJOty (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 10 Mar 2021 09:49:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615387793;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=D47Dx/wPt4KcgcIyXHGO1ETHgaMyU9+Y6ChfFO3B4KM=;
        b=bYXaP0xJaC+Ra3ITS7k6vWzOJjPEK1/rAddCjExYWL2ii2MPhaKfNYF9ahKzSVndhFtbQl
        kv1/4D0MbpkNfJTY/lHY+/v6wdhaJhHC70FSKoBwivNK38ED3Ldpo6f+cNDsnR4GurOyG5
        4+6WZ70v88JOJUWxxNdKZ6lxrEQ+fb0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-292-2AfvyQaUNKqwuxh8jxUSTw-1; Wed, 10 Mar 2021 09:49:50 -0500
X-MC-Unique: 2AfvyQaUNKqwuxh8jxUSTw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CCA8726866;
        Wed, 10 Mar 2021 14:49:49 +0000 (UTC)
Received: from bfoster (ovpn-112-124.rdu2.redhat.com [10.10.112.124])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 31A4F5DEF9;
        Wed, 10 Mar 2021 14:49:49 +0000 (UTC)
Date:   Wed, 10 Mar 2021 09:49:47 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/3 v2] xfs: AIL needs asynchronous CIL forcing
Message-ID: <YEjcizn496sxt1GH@bfoster>
References: <20210224211058.GA4662@dread.disaster.area>
 <20210224232600.GH4662@dread.disaster.area>
 <YD6xrJHgkkHi+7a3@bfoster>
 <20210303005752.GM4662@dread.disaster.area>
 <YD/IN66S3aM1lEQh@bfoster>
 <20210304015933.GO4662@dread.disaster.area>
 <YEDc42Z1GjHBXi6S@bfoster>
 <20210304224848.GR4662@dread.disaster.area>
 <YEJHEt/vt6yuHbak@bfoster>
 <20210309004410.GC74031@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210309004410.GC74031@dread.disaster.area>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Mar 09, 2021 at 11:44:10AM +1100, Dave Chinner wrote:
> On Fri, Mar 05, 2021 at 09:58:26AM -0500, Brian Foster wrote:
> > On Fri, Mar 05, 2021 at 09:48:48AM +1100, Dave Chinner wrote:
> > > > > > So not only does this patch expose subsystem internals to
> > > > > > external layers and create more log forcing interfaces/behaviors to
> > > > > 
> > > > > Sorry, I don't follow. What "subsystem internals" are being exposed
> > > > > and what external layer are they being exposed to?
> > > > > 
> > > > > > > Cleaning up the mess that is the xfs_log_* and xlog_* interfaces and
> > > > > > > changing things like log force behaviour and implementation is for
> > > > > > > a future series.
> > > > > > > 
> > > > > > 
> > > > > > TBH I think this patch is kind of a mess on its own. I think the
> > > > > > mechanism it wants to provide is sane, but I've not even got to the
> > > > > > point of reviewing _that_ yet because of the seeming dismissal of higher
> > > > > > level feedback. I'd rather not go around in circles on this so I'll just
> > > > > > offer my summarized feedback to this patch...
> > > > > 
> > > > > I'm not dismissing review nor am I saying the API cannot or should
> > > > > not be improved. I'm simply telling you that I think the additional
> > > > > changes you are proposing are outside the scope of the problem I am
> > > > > addressing here. I already plan to rework the log force API (and
> > > > > others) but doing so it not something that this patchset needs to
> > > > > address, or indeed should address.
> > > > > 
> > > > 
> > > > I'm not proposing additional changes nor to rework the log force API.
> > > > I'm pointing out that I find this implementation to be extremely and
> > > > unnecessarily confusing.
> > > 
> > > And that's just fine - not everyone has to understand all of the
> > > code all of the time. That's why we have a team....
> > > 
> > > > To improve it, I'm suggesting to either coopt
> > > > the existing async log force API...
> > > 
> > > And I'm telling you that this is *future work*. As the person
> > > actually doing the work, that's my decision and you need to accept
> > > that. I understand your concerns and have a plan to address them -
> > > you just have to accept that the plan to address them isn't going to
> > > be exactly to your liking.
> > > 
> > 
> > As a reviewer, I am pointing out that I object to how this patch is
> > implemented and offered several fairly simple suggestions on how to
> > address my concerns. Those suggestions have been rejected pretty much
> > out of hand on the basis of the existence of some future plans.
> 
> We're allowed to disagree on the best approach. But to find a way
> forward means that both the summitter and the reviewer need to
> compromise. I've fixed up the obvious warts and bugs you've pointed
> out, and agreed that it needs cleaning up and have committed to
> cleaning it up in the near future.
> 
> > Future rework plans do not justify or change my view of this patch
> > and the mess it adds (for other developers, for historical context
> > and downstreams, etc.).  Therefore, if the only option you're
> > willing to consider is "make this mess now and clean it up later
> > in some broader rework," then I'd rather we just defer this patch
> > until after that rework is available and avoid the mess that way.
> 
> So you won't review it until I have 100 outstanding patches in this
> series and it's completely and utterly unreviewable? Then you'll ask
> me to split it up and re-order it into digestable chunks, and so
> we'll go back to having to merge this because any of the API rework
> that depends on the mechanism that this patch introduces.
> 

(Well, I'm not reviewing it now because I'm on PTO this week...)

> I'm not going to play that "now jump through this hoop" game.  We
> add flags for on-off behaviours in internal functions -all the
> time-. If this makes the interface so complex and confusing that you
> don't understand it, then the interface was already too complex and
> confusing. And fixing that is *not in the scope of this patchset*.
> 

I'm pretty sure creating a flag for the one-off behavior here was one of
my earlier suggestions. Based on the above, what's the problem with
that? I think Darrick's suggestion (re: my previous reply) around a
wrapper approach is quite reasonable as well.

> Demanding that code be made perfect before it can be merged is
> really not very helpful. Especially when there are already plans to
> rework the API but that rework is dependent on a bunch of other
> changes than need to be done first.
> 

"Jumping through hoops" on 100 patch series? Demanding perfection?
That's a little extreme for first pass feedback on v1 of a 3 patch
series, don't you think?

My position on this patch in its current form is that regardless of any
pending rework, it is unnecessarily gross. As stated numerous times, I
think there are various options for small tweaks that make it passable
for the time being. Let me know if you become willing to entertain the
notion that this patch might stand to improve independent from some
broader rework and I'm happy to revisit any of those options in further
detail.

In the meantime, I'm growing a little tired of the hyperbolic replies
around playing games, jumping through hoops, demanding perfection, or
whatever other nonsense. I've invested the better part of a week (and
now into PTO) in review of this patch alone because I feel strongly
about the result and am willing to contribute toward a solution, not
because I want to waste time or play games. I don't feel in kind about
the replies.

Brian

P.S.,

FWIW, I certainly don't expect all feedback to be incorporated during
review. On balance, I'd say a reasonable breakdown is that probably half
makes sense, another half might be bogus, and then some percentage of
that comes down to preference between reviewer and author where I'll try
to defer to the patch author when I feel there's at least been some good
faith discussion or justification for the current approach. "No, that's
obfuscation" or "no, I'll do it later" are not productive arguments if
you're looking for compromise. Those leave no room for discussion.
There's no counter suggestion to try and address the immediate concern
and work towards something mutually agreeable, or even any opportunity
to arrive at the conclusion that the original patch might be the ideal
outcome after all.

> iclogs are something that need to be moved behind the CIL, not sit
> in front of CIL. The CIL abstracts the journal and writing to the
> journal completely away from the transaction subsystem, yet the log
> force code punches straight through that abstraction and walks
> iclogs directly. The whole log force implementation needs to change,
> and I plan for the API that wraps the log forces to get reworked at
> that time.
> 
> For example, if we want to direct map storage for log writes, then
> iclog-based log force synchronisation needs to go away because we
> don't need iclogs for buffering journal writes. Hence the log foce
> code should interface only with the CIL, and only the CIL should
> manage whatever mechanism it is using to write to stable storage.
> The code is currently the way it is because the CIL, when first
> implemented, had to co-exist with the old way of writing to the log.
> We haven't used that old way for a decade now and we have very
> different storage performance characteristics these days, so it's
> about time we got rid of the mechanism designed to be optimal for
> spinning disks and actually integrated the CIL and the log
> efficiently.
> 
> There are a *lot* of steps to do this, and reworking the log force
> implementation and API is part of that. But reworking that API is
> premature because we haven't done all the necessary pre-work in
> place to make such a change yet. This patch is actually part of that
> pre-work to get the mechanisms that the log force rework will rely
> on.
> 
> I have very good reasons for pushing back against your suggestions,
> Brian. Your suggestions have merit but this patch is not the time to
> be making the changes you suggest. Code does not need to be perfect
> to be merged, nor does the entire larger change they will be part of
> need to be complete and 100% tested and reviewed before preparation
> and infrastructure patches can be merged. This is how we've done big
> changes in the past - they've been staged across multiple kernel
> cycles - and not everything needs to be done in the first
> patchset of a larger body of work....
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 

