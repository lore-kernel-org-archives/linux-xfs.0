Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 813A7C433EF
	for <linux-xfs@archiver.kernel.org>; Mon,  6 Jun 2022 18:57:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229966AbiFFS5O (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 6 Jun 2022 14:57:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231339AbiFFS5N (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 6 Jun 2022 14:57:13 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDDA1A180
        for <linux-xfs@vger.kernel.org>; Mon,  6 Jun 2022 11:57:11 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id o17so12841250pla.6
        for <linux-xfs@vger.kernel.org>; Mon, 06 Jun 2022 11:57:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=nR6XneNPwSI/DHJtSoKsdjhE4t4Hd9rrjjMaxDHh2S8=;
        b=MCXttVNvHxfjKI1vPVKwi9X01n6oVxDg0xxbEi1+57UrNbjF0vkKMcdMYmVvoU3G6X
         OQNp2AqeBMmEBpEBl+l206gwn05p9Bow1EuK4yb1cc5/sSP5+ozQBADb93Qc4Fku3Jj1
         MWYJStbK7GU6w9FYhrU5QnpyhHNvSXcy6rqrs1jQ5taRg8ZeMhfxpRgIrPaLDAmQZM0V
         Jo3Zv3DEjC+P9a78ea0zaRZmrKYT/JHR3oU7UEpwg5lrQUf4S3XWRtwlxkicTvm5Lg0l
         GoaEAj2zfIxqK29DZGpYBsW8oYFNyN1Jbefoi0zR7U2cyyECSSPdORelnJGhIQERgsCk
         9UBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=nR6XneNPwSI/DHJtSoKsdjhE4t4Hd9rrjjMaxDHh2S8=;
        b=pMOdvdORdBy6Rxd3uDBPDQBWX9RwLB1OnLVoWGXQke9WA9N2qbryN4IBwUM6T3vA2P
         IlsgMZ9IUQd16wlE64v0FkcMfMCVGE7mIKkD8lxdCGm5xJQNNyXSRyDOumffXawibgsX
         6gSTxyXYIzwNX8UP75oBWlOUE6UpJwZTLK7YW7qZtyuSi07aVVlS9MTL+89z9pnixEVR
         vdIQKQofJj4JYZm7wPDWRVRpyrBh9EAXtK52EpPYVyVsQPCCuEfn+3w1qfacMt8nTrZc
         aWcYlQRNbfp+t+EFnMoJcynbGkWasUgK81Enzn6ngwXHRQ6RNPqmYiaCIbZZ5H0Meyf4
         d0UA==
X-Gm-Message-State: AOAM533UrhDrdTmIwdy8xRbZxT2/dCfruJ771JDiMm9Zj+CTqtdTY8/Z
        A0dOz1Cyd2C0PKFasN5WPxc=
X-Google-Smtp-Source: ABdhPJzOUc0FeUNorci9gtoJDIn2ck9Jk794zuxRG1lIhYAeA1kbEZM9KeUkut0kNpkjiNLYYhEuQA==
X-Received: by 2002:a17:90b:1d08:b0:1e3:2a4f:6935 with SMTP id on8-20020a17090b1d0800b001e32a4f6935mr40740462pjb.174.1654541831206;
        Mon, 06 Jun 2022 11:57:11 -0700 (PDT)
Received: from google.com ([2620:0:1001:7810:60d:5ebb:8c17:f634])
        by smtp.gmail.com with ESMTPSA id s6-20020a170902ea0600b0016232dbd01fsm10810006plg.292.2022.06.06.11.57.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jun 2022 11:57:10 -0700 (PDT)
Date:   Mon, 6 Jun 2022 11:57:08 -0700
From:   Leah Rumancik <leah.rumancik@gmail.com>
To:     Luis Chamberlain <mcgrof@kernel.org>
Cc:     Amir Goldstein <amir73il@gmail.com>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        "Darrick J. Wong" <djwong@kernel.org>, Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH 5.15 00/15] xfs stable candidate patches for 5.15.y
Message-ID: <Yp5OBN8fj+lFQaW0@google.com>
References: <20220603184701.3117780-1-leah.rumancik@gmail.com>
 <CAOQ4uxjzq1BQeO3-BkzLVKi8=95ohVU-UHJhR_zWZze5O_G=gA@mail.gmail.com>
 <Yp4jbET5GqubQTlk@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yp4jbET5GqubQTlk@bombadil.infradead.org>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jun 06, 2022 at 08:55:24AM -0700, Luis Chamberlain wrote:
> On Sat, Jun 04, 2022 at 11:38:35AM +0300, Amir Goldstein wrote:
> > On Sat, Jun 4, 2022 at 6:53 AM Leah Rumancik <leah.rumancik@gmail.com> wrote:
> > >
> > > From: Leah Rumancik <lrumancik@google.com>
> > >
> > > This first round of patches aims to take care of the easy cases - patches
> > > with the Fixes tag that apply cleanly. I have ~30 more patches identified
> > > which will be tested next, thanks everyone for the various suggestions
> > > for tracking down more bug fixes. No regressions were seen during
> > > testing when running fstests 3 times per config with the following configs:
> 
> Leah,
> 
> It is great to see this work move forward.
> 
> How many times was fstest run *without* the patches to establish the
> baseline? Do you have a baseline for known failures published somewhere?

Currently, the tests are being run 10x per config without the patches.
If a failure is seen with the patches, the tests are rerun on the
baseline several hundred times to see if the failure was a regression or
to determine the baseline failure rate.

> 
> For v5.10.y effort we aimed for 100 times so to ensure we have a high
> confidence in the baseline. That baseline is here:
> 
> https://github.com/linux-kdevops/kdevops/tree/master/workflows/fstests/expunges/5.10.105/xfs/unassigned
> 
> For XFS the latest baseline we are tracking on kdevops is v5.17 and you can
> see the current results here:
> 
> https://github.com/linux-kdevops/kdevops/tree/master/workflows/fstests/expunges/5.17.0-rc7/xfs/unassigned
> 
> This passed 100 loops of fstests already. The target "test steady state"
> of 100 is set in kdevops using CONFIG_KERNEL_CI_STEADY_STATE_GOAL=100.
> 
> As discussed at LSFMM is there a chance we can collaborate on a baseline
> together? One way I had suggested we could do this for different test
> runners is to have git subtree with the expunges which we can all share
> for different test runner.
> 

Could you elaborate on this a bit? Are you hoping to gain insight from
comparing 5.10.y baseline with 5.15.y baseline or are you hoping to
allow people working on the same stable branch to have a joint record of
test run output?

> The configuration used is dynamically generated for the target
> test dev and pool, but the rest is pretty standard:
> 
> https://github.com/linux-kdevops/kdevops/blob/master/playbooks/roles/fstests/templates/xfs/xfs.config
> 
> Hearing that only 3 loops of running fstests is run gives me a bit of
> concern for introducing a regression with a low failure rate. I realize
> that we may be limited in resources to test running fstests in a loop
> but just 3 tests should take a bit over a day. I think we can do better.
> At the very last you can give me your baseline and I can try to confirm
> if matches what I see. 

I can go ahead and bump up the amount of test runs. It would be nice to
agree on the number of test runs and the specific configs to test. For a
fixed amount of resources there is a tradeoff between broader coverage
through more configs vs more solid results with fewer configs. I am not
sure where everyone's priorities lie.

After the new runs, I'll go ahead and post the baseline and send out a
link so we can compare.

> Then, 30 patches seems like a lot, so I think it
> would be best to add patches to stable 10 at a time max.

I am planning on batching into smaller groups, 10 at a time works for
me.

Best,
Leah
