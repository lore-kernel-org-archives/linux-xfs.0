Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9AC0C43334
	for <linux-xfs@archiver.kernel.org>; Wed, 22 Jun 2022 21:44:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233787AbiFVVoy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 22 Jun 2022 17:44:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232842AbiFVVox (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 22 Jun 2022 17:44:53 -0400
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6738340D1;
        Wed, 22 Jun 2022 14:44:51 -0700 (PDT)
Received: from letrec.thunk.org (c-24-1-67-28.hsd1.il.comcast.net [24.1.67.28])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 25MLiUlS001655
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 22 Jun 2022 17:44:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
        t=1655934273; bh=XsRq7eTS7g0wh3Ppz8PQzaPbQZm88G1VXyRNwA4tT28=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To;
        b=R9vRvO3Cmy2n5REdRIyg9oURL2P9ATeCEEE0VHJOrWSOFrJwzUPzOhUJeqKKgthDm
         apGLCJuD65gV9MbGZMQ+HT7oX5oeDhh8AUX9xyGG6BypnWuXiVO9TvnSoIJulAF+kQ
         i/F21BdzLq8IjXbQM7vmUJ5ly5dx2D/6ZS5gz3Xoch7YW0VpsTr9PAmWWPd2NFf/J1
         eHY688VsnqRB3wN2Tx2SRo7mmeMvswbsNXpFTfrVylTWEb1GRTBn94RBYSgjFZt5MN
         //kR3G1nmeNVNn20odnsrNQzcLg7hl8U469VjUisLKg7PJ6d14idZiQav2u2N91Oar
         1xR7kLkafz+LA==
Received: by letrec.thunk.org (Postfix, from userid 15806)
        id 51DD78C3289; Wed, 22 Jun 2022 17:44:30 -0400 (EDT)
Date:   Wed, 22 Jun 2022 17:44:30 -0400
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     Luis Chamberlain <mcgrof@kernel.org>
Cc:     Leah Rumancik <leah.rumancik@gmail.com>,
        Amir Goldstein <amir73il@gmail.com>,
        Josef Bacik <josef@toxicpanda.com>,
        Chuck Lever <chuck.lever@oracle.com>, chandanrmail@gmail.com,
        Sweet Tea Dorminy <sweettea-kernel@dorminy.me>,
        Pankaj Raghav <pankydev8@gmail.com>, linux-xfs@vger.kernel.org,
        fstests <fstests@vger.kernel.org>
Subject: Re: [PATCH 5.15 CANDIDATE v2 0/8] xfs stable candidate patches for
 5.15.y (part 1)
Message-ID: <YrONPrBgopZQ2EUj@mit.edu>
References: <20220616182749.1200971-1-leah.rumancik@gmail.com>
 <YrJdLhHBsolF83Rq@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YrJdLhHBsolF83Rq@bombadil.infradead.org>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jun 21, 2022 at 05:07:10PM -0700, Luis Chamberlain wrote:
> On Thu, Jun 16, 2022 at 11:27:41AM -0700, Leah Rumancik wrote:
> > https://gist.github.com/lrumancik/5a9d85d2637f878220224578e173fc23. 
> 
> The coverage for XFS is using profiles which seem to come inspired
> by ext4's different mkfs configurations.

That's not correct, actually.  It's using the gce-xfstests test
framework which is part of the xfstests-bld[1][2] system that I
maintain, yes.  However, the actual config profiles were obtained via
discussions from Darrick and represent the actual configs which the
XFS maintainer uses to test the upstream XFS tree before deciding to
push to Linus.  We figure if it's good enough for the XFS Maintainer,
it's good enough for us.  :-)

[1] https://thunk.org/gce-xfstests
[2] https://github.com/tytso/xfstests-bld

If you think the XFS Maintainer should be running more configs, I
invite you to have that conversation with Darrick.

> GCE is supported as well, so is Azure and OpenStack, and even custom
> openstack solutions...

The way kdevops work is quite different from how gce-xfstests work,
since it is a VM native solution.  Which is to say, when we kick off a
test, VM's are launched, one per each config, whih provide for better
parallelization, and then once everything is completed, the VM's are
automatically shutdown and they go away; so it's far more efficient in
terms of using cloud resources.  The Lightweight Test Manager will ten
take the Junit XML files, plus all of the test artifacts, and these
get combined into a single test report.

The lightweight test manager runs in a small VM, and this is the only
VM which is consuming resources until we ask it to do some work.  For
example:

    gce-xfstests ltm -c xfs --repo stable.git --commit v5.18.6 -c xfs/all -g auto

That single command will result in the LTM launching a large builder
VM which quickly build the kernel.  (And it uses ccache, and a
persistent cache disk, but even if we've never built the kernel, it
can complete the build in a few minutes.)  Then we launch 12 VM's, one
for each config, and since they don't need to be optimized for fast
builds, we can run most of the VM's with a smaller amount of memory,
to better stress test the file system.  (But for the dax config, we'll
launch a VM with more memory, since we need to simulate the PMEM
device using raw memory.)  Once each VM completes each test run, it
uploads its test artifiacts and results XML file to Google Cloud
Storage.  When all of the VM's complete, the LTM VM will download all
of the results files from GCS, combines them together into a single
result file, and then sends e-mail with a summary of the results.

It's optimized for developers, and for our use cases.  I'm sure
kdevops is much more general, since it can work for hardware-based
test machines, as well as many other cloud stacks, and it's also
optimized for the QA department --- not surprising, since where
kdevops has come from.

> Also, I see on the above URL you posted there is a TODO in the gist which
> says, "find a better route for publishing these". If you were to use
> kdevops for this it would have the immediate gain in that kdevops users
> could reproduce your findings and help augment it.

Sure, but with our system, kvm-xfstests and gce-xfstests users can
*easily* reproduce our findings and can help augment it.  :-)

As far as sharing expunge files, as I've observed before, these files
tend to be very specific to the test configuration --- the number of
CPU's, and the amount of memory, the characteristics of the storage
device, etc.  So what works for one developer's test setup will not
necessarily work for others --- and I'm not convinced that trying to
get everyone standardized on the One True Test Setup is actually an
advantage.  Some people may be using large RAID Arrays; some might be
using fast flash; some might be using some kind of emulated log
structured block device; some might be using eMMC flash.  And that's a
*good* thing.

We also have a very different philosophy about how to use expunge
files.  In paticular, if there is test which is only failing 0.5% of
the time, I don't think it makes sense to put that test into an
expunge file.

In general, we are only placing tests into expunge files when
it causes the system under test to crash, or it takes *WAAAY* too
long, or it's a clear test bug that is too hard to fix for real, so we
just suppress the test for that config for now.  (Example: tests in
xfstests for quota don't understand clustered allocation.)

So we want to run the tests, even if we know it will fail, and have a
way of annotating that a test is known to fail for a particular kernel
version, or if it's a flaky test, what the expected flake percentage
is for that particular test.  For flaky tests, we'd like to be able
automatically retry running the test, and so we can flag when a flaky
test has become a hard failure, or a flaky test has radically changed
how often it fails.  We haven't implemented all of this yet, but this
is something that we're exploring the design space at the moment.

More generally, I think competition is a good thing, and for areas
where we are still exploring the best way to automate tests, not just
from a QA department's perspective, but from a file system developer's
perspective, having multiple systems where we can explore these ideas
can be a good thing.

Cheers,

						- Ted
