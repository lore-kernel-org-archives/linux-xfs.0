Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 691F7C433FE
	for <linux-xfs@archiver.kernel.org>; Fri, 27 May 2022 13:10:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345710AbiE0NKc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 27 May 2022 09:10:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245012AbiE0NKb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 27 May 2022 09:10:31 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9776122B6A;
        Fri, 27 May 2022 06:10:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description;
        bh=5Az+ZM6zR+VBdw1NGFNlmoDJi0KU/Qp5ykVRjIaXV3c=; b=xULUh7vkKkdDjvdX7KAUya19Y7
        vQMaWYEzpACR78D67OFPFafIL+UN+ww8SNtUGcemJWFwt8hDJakwIfP9paaa/uYwLrG3p+UVLHn2D
        p2HZEbhrqqP8SGzP96vysB/KQ0bRCtHfqh27UGIFKRbAanMNcZutlDIVlpINHhQnOtYlOigZg22Hj
        OymJkAIfQy6rqCvGew/Gv6zYn6yep3GueUIIO3n03njAlnz50W745g5jXeMTLfrY931yYiBcB+1Gy
        86mR1jfBldHDXMOMLwoHfwv6ermMbUUBCMZYdYfGW5sNhh3bISreSJ1OuLEoJYufAmDXv/yyrBVqe
        IaRw7zUQ==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nuZjO-0006HE-5W; Fri, 27 May 2022 13:10:18 +0000
Date:   Fri, 27 May 2022 06:10:18 -0700
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     "Darrick J. Wong" <djwong@kernel.org>,
        Dave Chinner <david@fromorbit.com>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        Theodore Ts'o <tytso@mit.edu>,
        Adam Manzanares <a.manzanares@samsung.com>,
        Tyler Hicks <code@tyhicks.com>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        fstests <fstests@vger.kernel.org>,
        Leah Rumancik <lrumancik@google.com>, masahiroy@kernel.org,
        Klaus Jensen <its@irrelevant.dk>,
        Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
        "Paul E. McKenney" <paulmck@kernel.org>
Subject: Re: [PATH 5.10 0/4] xfs stable candidate patches for 5.10.y (part 1)
Message-ID: <YpDNuqr0cRsiVBjv@bombadil.infradead.org>
References: <20220525111715.2769700-1-amir73il@gmail.com>
 <Yo+4jW0e4+fYIxX2@magnolia>
 <Yo/KibX8TOj+rZkV@bombadil.infradead.org>
 <CAOQ4uxgSKFutWq03Yu2+AvucoZwJ5azz5G5KgDSztCczk_+OtA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAOQ4uxgSKFutWq03Yu2+AvucoZwJ5azz5G5KgDSztCczk_+OtA@mail.gmail.com>
Sender: Luis Chamberlain <mcgrof@infradead.org>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, May 26, 2022 at 09:59:19PM +0300, Amir Goldstein wrote:
> On Thu, May 26, 2022 at 9:44 PM Luis Chamberlain <mcgrof@kernel.org> wrote:
> >
> > On Thu, May 26, 2022 at 10:27:41AM -0700, Darrick J. Wong wrote:
> > > /me looks and sees a large collection of expunge lists, along with
> > > comments about how often failures occur and/or reasons.  Neat!
> > >
> > > Leah mentioned on the ext4 call this morning that she would have found
> > > it helpful to know (before she started working on 5.15 backports) which
> > > tests were of the flaky variety so that she could better prioritize the
> > > time she had to look into fstests failures.  (IOWS: saw a test fail a
> > > small percentage of the time and then burned a lot of machine time only
> > > to figure out that 5.15.0 also failed a percentage of th time).
> >
> > See my proposal to try to make this easier to parse:
> >
> > https://lore.kernel.org/all/YoW0ZC+zM27Pi0Us@bombadil.infradead.org/
> >
> > > We talked about where it would be most useful for maintainers and QA
> > > people to store their historical pass/fail data, before settling on
> > > "somewhere public where everyone can review their colleagues' notes" and
> > > "somewhere minimizing commit friction".  At the time, we were thinking
> > > about having people contribute their notes directly to the fstests
> > > source code, but I guess Luis has been doing that in the kdevops repo
> > > for a few years now.
> > >
> > > So, maybe there?
> >
> > For now sure, I'm happy to add others the linux-kdevops org on github
> > and they get immediate write access to the repo. This is working well
> > so far. Long term we need to decide if we want to spin off the
> > expunge list as a separate effort and make it a git subtree (note
> > it is different than a git sub module). Another example of a use case
> > for a git subtree, to use it as an example, is the way I forked
> > kconfig from Linux into a standalone git tree so to allow any project
> > to bump kconfig code with just one command. So different projects
> > don't need to fork kconfig as they do today.
> >
> > The value in doing the git subtree for expunges is any runner can use
> > it. I did design kdevops though to run on *any* cloud, and support
> > local virtualization tech like libvirt and virtualbox.
> >
> > The linux-kdevops git org also has other projects which both fstest
> > and blktests depend on, so for example dbench which I had forked and
> > cleaned up a while ago. It may make sense to share keeping oddball
> > efforts like thse which are no longer maintained in this repo.
> >
> > There is other tech I'm evaluating for this sort of collaborative test
> > efforts such as ledgers, but that is in its infancy at this point in
> > time. I have a sense though it may be a good outlet for collection of
> > test artifacts in a decentralized way and also allow *any* entity to
> > participate in bringing confidence to stable kernel branches or dev
> > branches prior to release.
> >
> 
> There are few problems I noticed with the current workflow.
> 
> 1. It will not scale to maintain this in git as more and more testers
> start using kdepops and adding more and more fs and configs and distros.

You say that but do not explain why you think this is the case.
Quite the contrary, I don't think so and I'll expain why. Let's
just stic to the expunge list as that is what matters here in this
context.

The expunge list is already divided by target kernels if using upstream
kernels by directory. So this applies to any stable kernel, vanilla
kernels, or linux-next. Folks working on these kernels would very likely
be collaborating just as you and I have.

Distro kernels also have their own directory, and so they'd very likely
collaborate.

> How many more developers you want to give push access to linux-kdevops?

Only those really collaborating, the idea is not to give access to the
world here. The challenge I'm thinking about for the future though is
how to scale this beyond just those few in a meaningful way in such a
way that you don't limit your scope of evaluation only to what resources
these folks have.

That is a research question and beyond the scope of just using git in a
shared linux repo.

> I don't know how test labs report to KernelCI, but we need to look at their
> model and not invent the wheel.

I looked at and to say the least I was not in any way shape or form
drawn to it or what it was using. You are free to look at it too.

The distributed aspect is what I don't agree with, and it is why I am
evaluating alternative decentralized technologies for the future.

It relies on a LAVA, Linaro Automated Validation Architecture. The
project home page to LAVA [0], mentions "LAVA is an automated validation
architecture primarily aimed at testing deployments of systems based
around the Linux kernel on ARM devices, specifically ARMv7 and later".
The SOC [1] page however now lists x86, but it is not the main focus of
the project. You can add a new test lab and add new tests, these tests
are intended to be public. If running tests for private consumption
you’d have to set up your own backend and front end. All this and the
experience with the results page was enough for me to decide this
wasn't an immediate good fit for automation for fstests and blktests
when I started considering this for enterprise Linux.

[0] https://git.lavasoftware.org
[1] https://linux.kernelci.org/soc/

It does not mean one cannot use a centralized methodology to share an
expunge list / artifacts, etc for fstests or blktests. A shared expunge
set on linux-kdevops organization is a *simple* centralized way to do that
to start off with, and if you limit access to folks who collaborate on
one directory (as you kind of do in Linux development with maintainers)
you avoid merge conflicts. We're not at a point yet where we're going to
have 100 folks who want access to say the v5.10.y directory for expunges
for XFS for example.... it's just you and me right now. Likewise for
other filesystems it would be similar. But from a research perspective
it does invite one to consider how to scale this in a sensible way
beyond those. When I looked at kernelci, I didn't personally think that
was an optimal way to scale, but that is beyond the scope of the simple
ramp up we're still discussing.

> 2. kdevops is very focused on stabilizing the baseline fast, 

Although it does help with this, I still think there is small efforts to
help automate this further in the future. A runner should be able to
spin this off without intervention if possible. Today upon failures it
requires manual verification, adding a new failure to an expunge list,
etc.  We can do better, and the goal is to slowly automate each of those
menial tasks which today we do manually. Building a completely new
baseline without manual intervention I think is possible and we should
strive towards it slowly and carefully.

> which is
> very good, but there is no good process of getting a test out of expunge list.

Yes, *part* of this involves a nice atomic task which can be dedicated to a
runner. So this goal alone needs to broken up in to parts:

a) Is this task still failing? --> easily automated today
b) How can we avoid this to fail --> not easily autmated today

As for a), a simple dedicated guest could for example evaluate a target kernel
on a fileystem configuration and run through each expunge and *verify* it
is indeed still failing. If it is not, and there is high confidence that
this is the case (say it verified that it is not failing many times), then
clearly the issue may have been fixed (say a stable kernel update) and
the task can inform us of that.

Thas task b) requires years, and years of work.

> We have a very strong suspicion that some of the tests that we put in
> expunge lists failed due to some setup issue in the host OS that caused
> NVME IO errors in the guests.

We already know that qemu with qcow2 nvme files does incur some delays
when doing full swing drive discards and this can cause some of these
nvme IO errors (timeouts). We now also are aware that the odds of this
timeout happening twice is also low but *is* possible. We *also* now
know that when two consecutive nvme timeoutes happen due to this it can
also *somehow* trigger an RCU false positive for blktests in some corner
cases when testing ZNS [0] but this was *what* made us realize that this
issue was a qemu issue and the qemu nvme maintainer has noted that
this needs to be fixed in qemu.

[0] https://lkml.kernel.org/r/YliZ9M6QWISXvhAJ@bombadil.infradead.org

But these sorts of qemu bugs should should not cause filesystem
issues. We also already know that this is a qemu bug and that this will
be fixed in the long term. Upon review with the qemu nvme maintainer
the way kdevops uses nvme is not incorrect.

Yes we can switch to raw format to skip the suboptimal way to do
discards, but we *want* to find more bugs, not less. We could
simply just make a new Kconfig entry on kdevops to enable users to use
raw files for the nvme drives for those that want to opt-out of these
timeouts for now.

> I tried to put that into comments when
> I noticed that, but I am afraid there may have been other tests that are
> falsely accused of failing.

There are two things we should consider in light of this:

c) We do need semantics for common exceptions to failures
d) We need an appreciation for why some of these exceptions may be
   real odd issues and it may take time to either fix them or
   to acknoledge they are non-issue somehow.

As for c) I had proposed a way to annotate failure rate, perhaps
we need a way to annotate these odd issues as well.

In my talk at LSFMM I mentioned how 25% of time *alone* on the test
automation effort consists of dealing with low hanging fruit. Since
companies are now trying to dedicate some resources towards stable
filesystem efforts it maybe worthy for them to consider this so that
they are aware that some of these oddball issues may end up with them
lurking in odd corners. I gave one example which took 8 months to root
cause on the blktests front alone at LSFMM.

> All developers make those mistakes in their
> own expunge lists, but if we start propagating those mistakes to the world,
> it becomes an issue.

Agreed, but note that the conversation is shifting from not sharing
expunges to possibly sharing some notion of expunges *somehow*. That is
a small step forward. I agree we need to address these semantics issues
and they are important, but without the will to share expunges there
would have been no point to address some of these common pain points.

> For those two reasons I think that the model to aspire to should be
> composed of a database where absolutely everyone can post data
> point to in the form of facts (i.e. the test failed after N runs on this kernel
> and this hardware...) and another process, partly AI, partly human to
> digest all those facts into a knowledge base that is valuable and
> maintained by experts. Much easier said than done...

Anything is possible, sure. A centralized database is one way to go
about some of these things. I'm however suspicious that perhaps there
is a better way, and am still evaluating a ledger as a way to scale
test results. Both paths can be taken, in fact. One does not negate
the other.

*For now*... I do think a simple repo with those who *are* collaborating
on expunges can share a simple repo as we have been doing for a few
months.

The need for scaling has to be addressed but for the long term of growth
of the endeavour.

  Luis
