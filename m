Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F187C433EF
	for <linux-xfs@archiver.kernel.org>; Mon,  6 Jun 2022 15:55:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241073AbiFFPz3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 6 Jun 2022 11:55:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240974AbiFFPz2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 6 Jun 2022 11:55:28 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9DE3235B07
        for <linux-xfs@vger.kernel.org>; Mon,  6 Jun 2022 08:55:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=l+/xeOQkhMZjOIguuuJMrmMY1dTbjHGIix2I+/MIi7o=; b=veLeiWbFTQlpHOzIMCQCyqzM87
        Xu5KpbtualHRwSVb0Za9mSLPlWK3SMej2wBRRmihKlp7Sf8qr3kmnyNh/676Vp5K4t52kIRYUw0Qw
        Nee1UHEGNfunrQuVVYF2XprHazl51J5CZF3x5YPIHSwtnOzXtb1h5JPzd9mMMVfl5huX7xTqNR2p7
        qajMxg2sJmBpkXkojlsxf6csJuswEvnNNSwhubMS+qqD+7NwhIKJ4TVvtKzZJAhYDphqyqGoo5Y76
        Q4BzYcDukdJ+dil5FeweSxwhfDxbvkPxsrAkcaLNDCz5aHp5WlnSvb1q3Zs6bLdoWNdwpMLmcLyFE
        gTHoUqAA==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nyF4e-001vQc-2s; Mon, 06 Jun 2022 15:55:24 +0000
Date:   Mon, 6 Jun 2022 08:55:24 -0700
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Leah Rumancik <leah.rumancik@gmail.com>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Leah Rumancik <lrumancik@google.com>,
        Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH 5.15 00/15] xfs stable candidate patches for 5.15.y
Message-ID: <Yp4jbET5GqubQTlk@bombadil.infradead.org>
References: <20220603184701.3117780-1-leah.rumancik@gmail.com>
 <CAOQ4uxjzq1BQeO3-BkzLVKi8=95ohVU-UHJhR_zWZze5O_G=gA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxjzq1BQeO3-BkzLVKi8=95ohVU-UHJhR_zWZze5O_G=gA@mail.gmail.com>
Sender: Luis Chamberlain <mcgrof@infradead.org>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Jun 04, 2022 at 11:38:35AM +0300, Amir Goldstein wrote:
> On Sat, Jun 4, 2022 at 6:53 AM Leah Rumancik <leah.rumancik@gmail.com> wrote:
> >
> > From: Leah Rumancik <lrumancik@google.com>
> >
> > This first round of patches aims to take care of the easy cases - patches
> > with the Fixes tag that apply cleanly. I have ~30 more patches identified
> > which will be tested next, thanks everyone for the various suggestions
> > for tracking down more bug fixes. No regressions were seen during
> > testing when running fstests 3 times per config with the following configs:

Leah,

It is great to see this work move forward.

How many times was fstest run *without* the patches to establish the
baseline? Do you have a baseline for known failures published somewhere?

For v5.10.y effort we aimed for 100 times so to ensure we have a high
confidence in the baseline. That baseline is here:

https://github.com/linux-kdevops/kdevops/tree/master/workflows/fstests/expunges/5.10.105/xfs/unassigned

For XFS the latest baseline we are tracking on kdevops is v5.17 and you can
see the current results here:

https://github.com/linux-kdevops/kdevops/tree/master/workflows/fstests/expunges/5.17.0-rc7/xfs/unassigned

This passed 100 loops of fstests already. The target "test steady state"
of 100 is set in kdevops using CONFIG_KERNEL_CI_STEADY_STATE_GOAL=100.

As discussed at LSFMM is there a chance we can collaborate on a baseline
together? One way I had suggested we could do this for different test
runners is to have git subtree with the expunges which we can all share
for different test runner.

The configuration used is dynamically generated for the target
test dev and pool, but the rest is pretty standard:

https://github.com/linux-kdevops/kdevops/blob/master/playbooks/roles/fstests/templates/xfs/xfs.config

Hearing that only 3 loops of running fstests is run gives me a bit of
concern for introducing a regression with a low failure rate. I realize
that we may be limited in resources to test running fstests in a loop
but just 3 tests should take a bit over a day. I think we can do better.
At the very last you can give me your baseline and I can try to confirm
if matches what I see. Then, 30 patches seems like a lot, so I think it
would be best to add patches to stable 10 at a time max.

  Luis
