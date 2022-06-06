Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0E73C433EF
	for <linux-xfs@archiver.kernel.org>; Mon,  6 Jun 2022 19:31:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232443AbiFFTbL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 6 Jun 2022 15:31:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232481AbiFFTbH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 6 Jun 2022 15:31:07 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F5E01D316
        for <linux-xfs@vger.kernel.org>; Mon,  6 Jun 2022 12:31:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=jDwVCtsL7aF1W251xPV5rvaDtgRp2C7zItfZArGAbAw=; b=iGGSD1ZZrWvI2pYGWZVB0tCtDK
        RHOgwMhikkflQ+pBwOtMLPxe2DHVLIixSGz9ay/MliATEE0WcxPmhkR9mYYO4cKfiSlkuDtPae4kq
        0P5fEYhUL9Y+Nrl0dOgGWofs5MhHuVVZj7pnHnAx/LvA5FCnWq4ANakb2eL5OwkBpbAfiryCEwthL
        6M1Ga7MRQrEHQ1edAQsz51gDjJzCsJ1+bBGtVTryHwDuV3lbv1Z+DuFzoDFKvKln7jjzF8TCntt90
        KP1kUSL8sxiG+lJ+zkZoKDWfGFK6YFgdaK2gb2qwTjtRTcVWP1ykRxJU22e4X2HYPTL9tCUlxl9fl
        8GAFC3Bw==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nyIRH-002T5u-SM; Mon, 06 Jun 2022 19:30:59 +0000
Date:   Mon, 6 Jun 2022 12:30:59 -0700
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     Leah Rumancik <leah.rumancik@gmail.com>
Cc:     Amir Goldstein <amir73il@gmail.com>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        "Darrick J. Wong" <djwong@kernel.org>, Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH 5.15 00/15] xfs stable candidate patches for 5.15.y
Message-ID: <Yp5V80/7KuM3sdiW@bombadil.infradead.org>
References: <20220603184701.3117780-1-leah.rumancik@gmail.com>
 <CAOQ4uxjzq1BQeO3-BkzLVKi8=95ohVU-UHJhR_zWZze5O_G=gA@mail.gmail.com>
 <Yp4jbET5GqubQTlk@bombadil.infradead.org>
 <Yp5OBN8fj+lFQaW0@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yp5OBN8fj+lFQaW0@google.com>
Sender: Luis Chamberlain <mcgrof@infradead.org>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jun 06, 2022 at 11:57:08AM -0700, Leah Rumancik wrote:
> On Mon, Jun 06, 2022 at 08:55:24AM -0700, Luis Chamberlain wrote:
> > On Sat, Jun 04, 2022 at 11:38:35AM +0300, Amir Goldstein wrote:
> > > On Sat, Jun 4, 2022 at 6:53 AM Leah Rumancik <leah.rumancik@gmail.com> wrote:
> > > >
> > > > From: Leah Rumancik <lrumancik@google.com>
> > > >
> > > > This first round of patches aims to take care of the easy cases - patches
> > > > with the Fixes tag that apply cleanly. I have ~30 more patches identified
> > > > which will be tested next, thanks everyone for the various suggestions
> > > > for tracking down more bug fixes. No regressions were seen during
> > > > testing when running fstests 3 times per config with the following configs:
> > 
> > Leah,
> > 
> > It is great to see this work move forward.
> > 
> > How many times was fstest run *without* the patches to establish the
> > baseline? Do you have a baseline for known failures published somewhere?
> 
> Currently, the tests are being run 10x per config without the patches.
> If a failure is seen with the patches, the tests are rerun on the
> baseline several hundred times to see if the failure was a regression or
> to determine the baseline failure rate.

This is certainly one way to go about it. This just means that you have
to do this work then as a second step. Whereas if you first have a high
confidence in a baseline you then are pretty certain you have a
regression once a test fails after you start testing deltas on
a stable release.

Average failure rates for non-deterministic tests tend to be about
1/2 - 1/30. Although things such as 1/60, anything beyond 1/100
exist is *very* rare. So running fstests just 10 times seems to me
rather low to have any sort of high confidence in a baseline.

> > For v5.10.y effort we aimed for 100 times so to ensure we have a high
> > confidence in the baseline. That baseline is here:
> > 
> > https://github.com/linux-kdevops/kdevops/tree/master/workflows/fstests/expunges/5.10.105/xfs/unassigned
> > 
> > For XFS the latest baseline we are tracking on kdevops is v5.17 and you can
> > see the current results here:
> > 
> > https://github.com/linux-kdevops/kdevops/tree/master/workflows/fstests/expunges/5.17.0-rc7/xfs/unassigned
> > 
> > This passed 100 loops of fstests already. The target "test steady state"
> > of 100 is set in kdevops using CONFIG_KERNEL_CI_STEADY_STATE_GOAL=100.
> > 
> > As discussed at LSFMM is there a chance we can collaborate on a baseline
> > together? One way I had suggested we could do this for different test
> > runners is to have git subtree with the expunges which we can all share
> > for different test runner.
> > 
> 
> Could you elaborate on this a bit? Are you hoping to gain insight from
> comparing 5.10.y baseline with 5.15.y baseline or are you hoping to
> allow people working on the same stable branch to have a joint record of
> test run output?

Not output, but to share failures known to exist per kernel release and
per filesystem, and even Linux distribution. We can shared this as
expressed in an expunge file which can be used as input to running
fstests so that tests are skipped for the release.

Annotations can be made with comments, you can see an existin list here:

https://github.com/linux-kdevops/kdevops/tree/master/workflows/fstests/expunges/

I currently track *.bad and *.dmesg outputs into gists and refer to them
with a URL. Likewise when possible I annotate the failure rate.

*If* it makes sense to collaborate on that front I can extract *just*
the expunges directory and make its own git subtree which then kdevops
uses. Other test runner can then use the same git tree as a git subtree.

> > The configuration used is dynamically generated for the target
> > test dev and pool, but the rest is pretty standard:
> > 
> > https://github.com/linux-kdevops/kdevops/blob/master/playbooks/roles/fstests/templates/xfs/xfs.config
> > 
> > Hearing that only 3 loops of running fstests is run gives me a bit of
> > concern for introducing a regression with a low failure rate. I realize
> > that we may be limited in resources to test running fstests in a loop
> > but just 3 tests should take a bit over a day. I think we can do better.
> > At the very last you can give me your baseline and I can try to confirm
> > if matches what I see. 
> 
> I can go ahead and bump up the amount of test runs. It would be nice to
> agree on the number of test runs and the specific configs to test. For a
> fixed amount of resources there is a tradeoff between broader coverage
> through more configs vs more solid results with fewer configs. I am not
> sure where everyone's priorities lie.

Sure, it is all a tradeoff. But given we want to strive to collaborate,
I'd hope we can strive for a reasoanably well tested baseline. Given
average failure rates for non deterministic tests linger aroun 1/2 -
1/30, and given it can take about 1 week to run fstests in a loop
100 times *for any filesystem*, I think it is reasonable to use 100 as
good baseline target for a "test steady state".

> After the new runs, I'll go ahead and post the baseline and send out a
> link so we can compare.

Groovy!

> > Then, 30 patches seems like a lot, so I think it
> > would be best to add patches to stable 10 at a time max.
> 
> I am planning on batching into smaller groups, 10 at a time works for
> me.

Great!

  Luis
