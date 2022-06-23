Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43B9BC43334
	for <linux-xfs@archiver.kernel.org>; Thu, 23 Jun 2022 21:31:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229502AbiFWVbX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 23 Jun 2022 17:31:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbiFWVbW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 23 Jun 2022 17:31:22 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFB6E52E45;
        Thu, 23 Jun 2022 14:31:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=RSVgJsEM9lYJmB/CpO9oqVYjD7khqWo4A76+LjSym9c=; b=zf0fDCao7KmvZPpSxglRrBG8AW
        ov5MBhrmJk4DsgSNUH826yCs4DpAFEZO0SBf/r9gOs0r5EYvURrO+8b2QgOK0eVxi6QU4WQP2OQVf
        8gDBuHXmLlg9VouvQcUrN+GrHk3+nFU8Sig9WP0eGa8A8P+CNW/GSDlU/GbvPegPYUJ08InAmcw6r
        O38zEdgKeG29sPIo8JRho40V4wiPCv7TWeCFTYz3WvV2z6TnIYuhVI8g8pRbryFfF6Ytf7dwHF7qx
        CLOwrhWanqB5IjhFFr/xttIJOoTyUKwIm+YD9lIt8OSXwZ1q4Arvz9btn9Pjj/+El16gnw0xroOrt
        04GYAwpg==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1o4UPx-00GrdZ-0g; Thu, 23 Jun 2022 21:31:13 +0000
Date:   Thu, 23 Jun 2022 14:31:12 -0700
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     Theodore Ts'o <tytso@mit.edu>,
        "Darrick J. Wong" <djwong@kernel.org>
Cc:     Leah Rumancik <leah.rumancik@gmail.com>,
        Amir Goldstein <amir73il@gmail.com>,
        Josef Bacik <josef@toxicpanda.com>,
        Chuck Lever <chuck.lever@oracle.com>, chandanrmail@gmail.com,
        Sweet Tea Dorminy <sweettea-kernel@dorminy.me>,
        Pankaj Raghav <pankydev8@gmail.com>, linux-xfs@vger.kernel.org,
        fstests <fstests@vger.kernel.org>
Subject: Re: [PATCH 5.15 CANDIDATE v2 0/8] xfs stable candidate patches for
 5.15.y (part 1)
Message-ID: <YrTboFa4usTuCqUb@bombadil.infradead.org>
References: <20220616182749.1200971-1-leah.rumancik@gmail.com>
 <YrJdLhHBsolF83Rq@bombadil.infradead.org>
 <YrONPrBgopZQ2EUj@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YrONPrBgopZQ2EUj@mit.edu>
Sender: Luis Chamberlain <mcgrof@infradead.org>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jun 22, 2022 at 05:44:30PM -0400, Theodore Ts'o wrote:
> On Tue, Jun 21, 2022 at 05:07:10PM -0700, Luis Chamberlain wrote:
> > On Thu, Jun 16, 2022 at 11:27:41AM -0700, Leah Rumancik wrote:
> > > https://gist.github.com/lrumancik/5a9d85d2637f878220224578e173fc23. 
> > 
> > The coverage for XFS is using profiles which seem to come inspired
> > by ext4's different mkfs configurations.
> 
> That's not correct, actually.  It's using the gce-xfstests test
> framework which is part of the xfstests-bld[1][2] system that I
> maintain, yes.  However, the actual config profiles were obtained via
> discussions from Darrick and represent the actual configs which the
> XFS maintainer uses to test the upstream XFS tree before deciding to
> push to Linus.  We figure if it's good enough for the XFS Maintainer,
> it's good enough for us.  :-)
> 
> [1] https://thunk.org/gce-xfstests
> [2] https://github.com/tytso/xfstests-bld
> 
> If you think the XFS Maintainer should be running more configs, I
> invite you to have that conversation with Darrick.

Sorry, I did not realize that the test configurations for XFS were already
agreed upon with Darrick for stable for the v5.15 effort.

Darrick, long ago when I started to test xfs for stable I had published
what I had suggested and it seemed to cover the grounds back then in
2019:

https://lore.kernel.org/all/20190208194829.GJ11489@garbanzo.do-not-panic.com/T/#m14e299ce476de104f9ee2038b8d002001e579515

If there is something missing from what we use on kdevops for stable
consideation I'd like to augment it. Note that kdevops supports many
sections and some of them are optional for the distribution, each
distribution can opt-in, but likewise we can make sensible defaults for
stable kernels, and per release too. The list of configurations
supported are:

https://github.com/linux-kdevops/kdevops/blob/master/playbooks/roles/fstests/templates/xfs/xfs.config

For stable today we use all sections except xfs_bigblock and xfs_realtimedev.

Do you have any advice on what to stick to for both v5.10 and v5.15 for
stable for both kdevops and gce-xfstests ? It would seem just odd if we
are not testing the same set of profiles as a minimum requirement.

Likewise, the same quiestion applies to linus' tree and linux-next as
in the future my hope is we get to the point kdevops *will* send out
notices for new regressions detected.

> > GCE is supported as well, so is Azure and OpenStack, and even custom
> > openstack solutions...
> 
> The way kdevops work is quite different from how gce-xfstests work,
> since it is a VM native solution.

To be clear, you seem to suggest gce-xfstests is a VM native solution.
I'd also like to clarify that kdevops supports native VMs, cloud and
baremetal. With kdevops you pick your bringup method.

> Which is to 

<-- a description of how gce-xfstests works -->

Today all artifacts are gathered by kdevops locally, they are not
uploaded anywhere. Consumption of this is yet to be determined,
but typically I put the output into a gist manually and then refer
to the URL of the gist on the expunge entry.

Uploading them can be an option / should, but it is not clear yet
where to upload them to. A team will soon be looking into doing some
more parsing of the results into a pretty flexible form / introspection.

> It's optimized for developers, and for our use cases.  I'm sure
> kdevops is much more general, since it can work for hardware-based
> test machines, as well as many other cloud stacks, and it's also
> optimized for the QA department --- not surprising, since where
> kdevops has come from.

kdevops started as an effort for kernel development and filesystems
testing. It is why the initial guest configuration was to use 8 GiB
of RAM and 4 vcpus, that suffices to do local builds / development.
I always did kernel development on guests back in the day still do
to this day.

It also has support for email reports and you get the xunit summary
output *and* a git diff output of the expunges should a new regression
be found.

A QA team was never involved other than later learning existed and that
the kernel team was using it to proactively find issues. Later kdevops was
used to report bugs proactively as it was finding a lot more issues than
typical fstests QA setups find.

> > Also, I see on the above URL you posted there is a TODO in the gist which
> > says, "find a better route for publishing these". If you were to use
> > kdevops for this it would have the immediate gain in that kdevops users
> > could reproduce your findings and help augment it.
> 
> Sure, but with our system, kvm-xfstests and gce-xfstests users can
> *easily* reproduce our findings and can help augment it.  :-)

Sure, the TODO item on the URL seemed to indicate there was a desire to
find a better place to put failures.

> As far as sharing expunge files, as I've observed before, these files
> tend to be very specific to the test configuration --- the number of
> CPU's, and the amount of memory, the characteristics of the storage
> device, etc.

And as I noted also at LSFMM it is not an imposibility to address this
either if we want to. We can simply use a namespace for test runner and
a generic test configuration.

A parent directory simply would represent the test runner. We have two
main ones for stable:

  * gce-xfstests
  * kdevops

So they can just be the parent directory.

Then I think we can probably agree upon 4 GiB RAM / 4 vpus per guest on
x86_64 for a typical standard requirement. So something like
x86_64_mem4g_cpus4. Then there is the drive setup. kdevops defaults
to loopback drives on nvme drives as the default for both cloud and
native KVM guests. So that can be nvme_loopback. It is not clear
what gce-xfstests but this can probably be described just as well.

> So what works for one developer's test setup will not
> necessarily work for others 

True but it does not mean we cannot automate setup of an agreed upon setup.
Specially if you wan to enable folks to reproduce. We can.

> --- and I'm not convinced that trying to
> get everyone standardized on the One True Test Setup is actually an
> advantage.

That is not a goal, the goal is allow variability! And share results
in the most efficient way.

It just turns an extremely simple setup we *can* *enable* *many* folks
to setup easily with local vms to reproduce *more* issues today is
with nvme drives + loopback drives. You are probably correct that
this methodology was perhaps not as tested today as it was before and
this is probably *why* we find more issues today. But so far it is
true that:

 * all issues found are real and sometimes hard to reproduce with direct
   drives
 * this methodology is easy to bring up
 * it is finding more issues

This is why this is just today's default for kdevops. It does not
mean you can't *grow* to add support for other drive setup. In fact
this is needed for testing ZNS drives.

> Some people may be using large RAID Arrays; some might be
> using fast flash; some might be using some kind of emulated log
> structured block device; some might be using eMMC flash.  And that's a
> *good* thing.

Absolutely!

> We also have a very different philosophy about how to use expunge
> files.

Yes it does not mean we can't share them.

And the variability which exists today *can* also be expressed.

> In paticular, if there is test which is only failing 0.5% of
> the time, I don't think it makes sense to put that test into an
> expunge file.

This preference can be expressed through kconfig and supported
and support added for it.

> More generally, I think competition is a good thing, and for areas
> where we are still exploring the best way to automate tests, not just
> from a QA department's perspective, but from a file system developer's
> perspective, having multiple systems where we can explore these ideas
> can be a good thing.

Sure, sure, but again, but it does not mean we can't or shouldn't
consider to share some things. Differences in strategy on how to process
expunge files can be discussed so that later I can add support for it.

I still think we can share at the very least configurations and
expunges with known failure rates (even if they are runner/config
specific).

  Luis
