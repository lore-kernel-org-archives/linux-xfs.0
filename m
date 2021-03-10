Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97135C433E0
	for <linux-xfs@archiver.kernel.org>; Wed, 10 Mar 2021 15:14:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4FEEE64F1B
	for <linux-xfs@archiver.kernel.org>; Wed, 10 Mar 2021 15:14:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230504AbhCJPNi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 10 Mar 2021 10:13:38 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:55202 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229689AbhCJPNb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 10 Mar 2021 10:13:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615389210;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=e5KSzFz0U5aG4SbwihghqgTnMRxQW1xzFqplcpr9dJI=;
        b=ZQgZCRa2bKzLDOMzg+gVJcJ4Abok/xKoL+/Mprq9qMhwZC5h7Wgsz87thS7zBPMpLEOIM8
        PRLKUA7hlDxTMe18MPAYQdYlLQJOJgaF19qyWKSL7lbUkVcPh4tjB8te2s7fjZrRJhDQ4f
        yL3UYyHoGWw1t3ClRvoleBNHD7PDma0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-367-ilW6u-pUN0eyBPumg2tfnA-1; Wed, 10 Mar 2021 10:13:26 -0500
X-MC-Unique: ilW6u-pUN0eyBPumg2tfnA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A322B1932480;
        Wed, 10 Mar 2021 15:13:25 +0000 (UTC)
Received: from bfoster (ovpn-112-124.rdu2.redhat.com [10.10.112.124])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 1BB3D5945E;
        Wed, 10 Mar 2021 15:13:25 +0000 (UTC)
Date:   Wed, 10 Mar 2021 10:13:23 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/3 v2] xfs: AIL needs asynchronous CIL forcing\
Message-ID: <YEjiE07YBLkhMSds@bfoster>
References: <20210224232600.GH4662@dread.disaster.area>
 <YD6xrJHgkkHi+7a3@bfoster>
 <20210303005752.GM4662@dread.disaster.area>
 <YD/IN66S3aM1lEQh@bfoster>
 <20210304015933.GO4662@dread.disaster.area>
 <YEDc42Z1GjHBXi6S@bfoster>
 <20210304224848.GR4662@dread.disaster.area>
 <YEJHEt/vt6yuHbak@bfoster>
 <20210309004410.GC74031@dread.disaster.area>
 <20210309043559.GT3419940@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210309043559.GT3419940@magnolia>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

(Replying separately to the logistical bits...)

On Mon, Mar 08, 2021 at 08:35:59PM -0800, Darrick J. Wong wrote:
> On Tue, Mar 09, 2021 at 11:44:10AM +1100, Dave Chinner wrote:
> > On Fri, Mar 05, 2021 at 09:58:26AM -0500, Brian Foster wrote:
> > > On Fri, Mar 05, 2021 at 09:48:48AM +1100, Dave Chinner wrote:
...
> > > 
> > > As a reviewer, I am pointing out that I object to how this patch is
> > > implemented and offered several fairly simple suggestions on how to
> > > address my concerns. Those suggestions have been rejected pretty much
> > > out of hand on the basis of the existence of some future plans.
> > 
> > We're allowed to disagree on the best approach. But to find a way
> > forward means that both the summitter and the reviewer need to
> > compromise. I've fixed up the obvious warts and bugs you've pointed
> > out, and agreed that it needs cleaning up and have committed to
> > cleaning it up in the near future.
> > 
> > > Future rework plans do not justify or change my view of this patch
> > > and the mess it adds (for other developers, for historical context
> > > and downstreams, etc.).  Therefore, if the only option you're
> > > willing to consider is "make this mess now and clean it up later
> > > in some broader rework," then I'd rather we just defer this patch
> > > until after that rework is available and avoid the mess that way.
> > 
> > So you won't review it until I have 100 outstanding patches in this
> > series and it's completely and utterly unreviewable?
> 
> Already unreviewable at 45, and I've only gotten through 2/3 of it.
> 
> > Then you'll ask me to split it up and re-order it into digestable
> > chunks, and so we'll go back to having to merge this because any of
> > the API rework that depends on the mechanism that this patch
> > introduces.
> 
> Here's something I haven't previously shared with all of you: Last cycle
> when we were going around and around on the ENOSPC/EDQUOT retry loop
> patches (which exploded from 13 to 41 patches) it was /very/ stressful
> to have to rework this and that part every day and a half for almost
> three weeks.
> 

I sympathize. There was at least a week in there that I spent pretty
much on nothing but review. :/

> When I get a patchset ready for submission, I export the patches from my
> development branch into a topic branch based off the latest -rc.  Every
> time anyone makes a suggestion, I update the topic branch and send that
> to the fstests "cloud" to see if it broke anything.  If it succeeds, I
> push it to k.org and resubmit.
> 
> The part that's less obvious is the fact that rebasing is /not/ that
> simple.  Next I integrate the changes into my development tree and
> rebase everything that comes after /that/ to make sure it doesn't
> interfere with my longer term development goals.  Sometimes this is
> easy, sometimes this takes an entire day to work out the warts.
> Then I send that to the fstests "cloud".  This rebase is particularly
> painful because every change that everyone makes to inode
> initialization collides with a rework of inode initialization that I've
> been working on in preparation for metadata directory trees.
> 
> The part that's even /less/ obvious than that is that once the
> development tree tests ok, then I do the same to my xfsprogs dev tree to
> make sure that nothing broke.  Frequently there are ABI or cognitive
> mismatches between kernel and userspace such that the build breaks, and
> then I have to patch the two kernel trees and re-run everything.
> 
> So, that's really stressful for me because a minor tweak to an interface
> can result in an enormous amount of work.  And I reject the argument
> that I could just rebase less frequently -- Dave does that, which means
> that any time he hears that one of his topic branches is being asked
> about, he has to spend weeks rebasing the whole mess to the latest
> upstream.  Maybe that works for him, but for me, I would hate that even
> more than doing a daily rebase.
> 
> Add to that the fact that vger has been a total delivery sh*tshow all
> year.  Now in addition to feeling disconnected from my family and
> friends, I also feel disconnected from work people too.  This really did
> nearly push me over the edge three weeks ago.
> 

Sorry. :(

> Please remember, one of the big advantages of our open development
> processes is that we /do/ accept code with warty (but functional)
> interfaces now, and we can clean them up later.  This is (IMHO) a good
> stress-reduction tactic, because each of us (ideally) should concentrate
> on getting the core algorithms right, and not focusing on rebasing code
> and smoothing over the same d*** merge conflicts over and over.
> 

I agree that we can and do accept code as such in certain cases, but not
always or by default. Usually, only when it makes sense due to
complexity, cross subsystem issues, etc. If the situation is the
submitter has sent a large patch series at a point where it's already so
unwieldy to change because of non-upstream reasons that some restricted
form of review is required, then I think that's a bit unfair to the
upstream community.

Using the whole block reclaim/retry loop thing as an example (just
because it was the most recent example of this kind of thing causing you
grief), perhaps those foundational changes should have been sent to the
list earlier before they became "too unwieldy to change?" I think it's
perfectly reasonable to send lightly tested or compile tested only
patches for initial thoughts, factoring feedback, etc., particularly if
a change proposes to add retry loops to various transaction allocation
callers. That's a fairly significant change in some core areas.

ISTM that on one hand review is fairly open ended and it's not really up
to the submitter to declare the scope of reviewer feedback (the
submitter is then certainly free to change certain things or not, but
the goal should be to cooperate toward some common ground). OTOH I
suppose the open development model allows for a community to determine a
standard for if/how they prefer to review patches.

That said, I personally don't like the "accept ugly code now, fix it
later over time" model by default because for one, I think it leads to a
lower quality mainline. I also think there's an implied assumption in
there that a reviewer wants to review endless series of cleanup patches
after providing such feedback on early versions of functionality. I know
if I take the time to review a 30+ patch series and had some
non-negligible amount of aesthetic feedback, I'm not really looking to
review another 20+ patches some time later just to clean up a mess that
the first series might have (unnecessarily) created, particularly when
the feedback has already been provided and so iterative review is more
time efficient (I find review much more time consuming than
development).

I dunno. That's just my .02 I guess. I do agree with Dave's previous
statements that not everything has to be 100% mutually agreeable. I
generally try to accommodate that by incorporating suggestions into my
own patches that I might not necessarily agree with, but don't feel
strongly enough about, to save time and keep things moving. Conversely
on the review side, I generally try to defer to other reviewers to see
whether my particular position might be in the majority or minority, and
go with that (That doesn't always mean I'm going to put reviewed-by tags
on patches I really don't like. In some cases, I think reviewing for
function/bugs and not nacking a patch is a form of compromise. ;).

> Yes, it's true that people think that a maintainer's only real power is
> to say 'no' in the hopes of forcing developers to fix everything now
> because they can't trust that a dev will ever come back with the
> promised updates, but I reject that 110%.  I'm not going anywhere, and I
> /do/ trust that when the rest of you say that you'll be back with wart
> remover, you will.
> 

I don't distrust that any XFS developers would make promised fixes as
such. I don't really see that as a problem at all. I think the whole
subsystem rework thing is pretty much a distraction from the original
feedback. E.g., I think your wrapper idea (explored in my previous
reply) is yet another reasonable solution that doesn't involve or
require any sort of broader rework.

Brian

> > I'm not going to play that "now jump through this hoop" game.  We
> > add flags for on-off behaviours in internal functions -all the
> > time-. If this makes the interface so complex and confusing that you
> > don't understand it, then the interface was already too complex and
> > confusing. And fixing that is *not in the scope of this patchset*.
> > 
> > Demanding that code be made perfect before it can be merged is
> > really not very helpful. Especially when there are already plans to
> > rework the API but that rework is dependent on a bunch of other
> > changes than need to be done first.
> > 
> > iclogs are something that need to be moved behind the CIL, not sit
> > in front of CIL. The CIL abstracts the journal and writing to the
> > journal completely away from the transaction subsystem, yet the log
> > force code punches straight through that abstraction and walks
> > iclogs directly. The whole log force implementation needs to change,
> > and I plan for the API that wraps the log forces to get reworked at
> > that time.
> 
> So here's what I want to know: Do Dave's changes to the log force APIs
> introduce broken behavior?  If the interfaces are so confusing that
> /none/ of us understand it, can we introduce the appropriate wrappers
> and documentation so that the rest of us plugging away at the rest of
> the system can only call it the supported ways to achieve any of the
> supported outcomes?
> 
> I'm willing to accept a bunch of documentation and "trivial" wrappers
> for the rest of us as a shoofly to enable the rest of the xfs developers
> to keep moving around a messy slow-moving log restructuring without
> falling into a work pit.
> 
> However, it's been difficult for me to check that without being able to
> reference a branch to see that at least the end result looks sane.  That
> was immensely helpful for reviewing Allison's deferred xattrs series.
> 
> (TLDR: git branch plz)
> 
> The other way to ease my fears, of course, would be to submit a ton of
> fstests to examine the log behavior for correctness, but that's
> difficult to pull off when the control surface is the userspace ABI.
> 
> > For example, if we want to direct map storage for log writes, then
> > iclog-based log force synchronisation needs to go away because we
> > don't need iclogs for buffering journal writes. Hence the log foce
> > code should interface only with the CIL, and only the CIL should
> > manage whatever mechanism it is using to write to stable storage.
> > The code is currently the way it is because the CIL, when first
> > implemented, had to co-exist with the old way of writing to the log.
> > We haven't used that old way for a decade now and we have very
> > different storage performance characteristics these days, so it's
> > about time we got rid of the mechanism designed to be optimal for
> > spinning disks and actually integrated the CIL and the log
> > efficiently.
> > 
> > There are a *lot* of steps to do this, and reworking the log force
> > implementation and API is part of that. But reworking that API is
> > premature because we haven't done all the necessary pre-work in
> > place to make such a change yet. This patch is actually part of that
> > pre-work to get the mechanisms that the log force rework will rely
> > on.
> > 
> > I have very good reasons for pushing back against your suggestions,
> > Brian. Your suggestions have merit but this patch is not the time to
> > be making the changes you suggest. Code does not need to be perfect
> > to be merged, nor does the entire larger change they will be part of
> > need to be complete and 100% tested and reviewed before preparation
> > and infrastructure patches can be merged. This is how we've done big
> > changes in the past - they've been staged across multiple kernel
> > cycles - and not everything needs to be done in the first
> > patchset of a larger body of work....
> 
> You mean there's even more beyond the 45 already on the list? /groan/
> 
> --D
> 
> > Cheers,
> > 
> > Dave.
> > -- 
> > Dave Chinner
> > david@fromorbit.com
> 

