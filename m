Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80A0BC43334
	for <linux-xfs@archiver.kernel.org>; Wed,  8 Jun 2022 22:16:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229957AbiFHWQp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 8 Jun 2022 18:16:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229837AbiFHWQp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 8 Jun 2022 18:16:45 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3099230F51
        for <linux-xfs@vger.kernel.org>; Wed,  8 Jun 2022 15:16:44 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id e24so19897291pjt.0
        for <linux-xfs@vger.kernel.org>; Wed, 08 Jun 2022 15:16:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=3y3cjlvBWca9BOHphvXWKxpzNa3K8stb0hlmE/Mkg/w=;
        b=DSCiEk6xLxSwLSS92fAYjriHrUrODrZSfGqjHX/Whuw8qu6+4rp0c6X/w7kbkymLWC
         ugmghCtTYapeImECy3pOkGHa8perGJHL4FeqN5RjocLrKVjexXiXcjiEr0MxoBmktBi1
         DhT0I0SO/ABD4gPOQAbfXjgi4eemEbxYmPzZIR11c0S5cj0qDN/cUFcBEYQHSjLuuQ1r
         Lh2K8/XOjYxc8yG9hWSZOeg+5OIgFc27hp0NI0aHLQtPLB87OPmDMSFkKDTNmwRnBO2Q
         vN3M+FC6xDKYuR8Y9YBK0S9tFxBEct4bT9gw3oaReDLcHtb3qHRDUfYEyaVklPlQ3RU6
         PZmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=3y3cjlvBWca9BOHphvXWKxpzNa3K8stb0hlmE/Mkg/w=;
        b=BTFXAvTwAosTcTD0obJVDISGw8q3Dczp1Vxd120AB2lN7mGrt2IoeX+GfQG9n+Zb61
         KTqDknZP9+7VE5QaI1DlmKdSIm0wLITt6wfElWkBZmc5ABDOxkzT5WRn4JyWKpuXADgF
         vH9zuj+mtzxZG5hLn16YGsPgoDQHa442iOIzygviQmRVsFCZ8ndLZl2cPrmzVbXS1pub
         +lxpZkxhm8utC1307yrZxYSdFN2rFZDZJ7b3eephMxbpPyFrQvRmCp5SI062ocQ646A0
         M2/zx23cKuN3YwdRNYmx84gX2qXXoVA0uwlCmv218RobNpIV4lmgm5CY8zsqkFj6nqvN
         5xYw==
X-Gm-Message-State: AOAM532o0BkPOyenCQdTEltIHVvRA5fC0DMACHnrXh7XhrXtI4MvyEr9
        Nyk5S6T0a/9E2ZUC/i8TWxI=
X-Google-Smtp-Source: ABdhPJzRHQwvduu8u1IDaPm/lCg9sRWD+2fiNVfveTziNV4g91h4g3gT2887m2OeHbCFq1GwqUtKwQ==
X-Received: by 2002:a17:903:40c9:b0:167:5411:3536 with SMTP id t9-20020a17090340c900b0016754113536mr27036945pld.2.1654726603509;
        Wed, 08 Jun 2022 15:16:43 -0700 (PDT)
Received: from google.com ([2620:15c:2c1:200:7b7:e310:ec9d:18c6])
        by smtp.gmail.com with ESMTPSA id 202-20020a6302d3000000b003fd6034de24sm9755496pgc.40.2022.06.08.15.16.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jun 2022 15:16:43 -0700 (PDT)
Date:   Wed, 8 Jun 2022 15:16:41 -0700
From:   Leah Rumancik <leah.rumancik@gmail.com>
To:     Luis Chamberlain <mcgrof@kernel.org>
Cc:     Amir Goldstein <amir73il@gmail.com>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        "Darrick J. Wong" <djwong@kernel.org>, Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH 5.15 00/15] xfs stable candidate patches for 5.15.y
Message-ID: <YqEfyR0DBbQEFv9s@google.com>
References: <20220603184701.3117780-1-leah.rumancik@gmail.com>
 <CAOQ4uxjzq1BQeO3-BkzLVKi8=95ohVU-UHJhR_zWZze5O_G=gA@mail.gmail.com>
 <Yp4jbET5GqubQTlk@bombadil.infradead.org>
 <Yp5OBN8fj+lFQaW0@google.com>
 <Yp5V80/7KuM3sdiW@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yp5V80/7KuM3sdiW@bombadil.infradead.org>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jun 06, 2022 at 12:30:59PM -0700, Luis Chamberlain wrote:
> On Mon, Jun 06, 2022 at 11:57:08AM -0700, Leah Rumancik wrote:
> > On Mon, Jun 06, 2022 at 08:55:24AM -0700, Luis Chamberlain wrote:
> > > On Sat, Jun 04, 2022 at 11:38:35AM +0300, Amir Goldstein wrote:
> > > > On Sat, Jun 4, 2022 at 6:53 AM Leah Rumancik <leah.rumancik@gmail.com> wrote:
> > > > >
> > > > > From: Leah Rumancik <lrumancik@google.com>
> > > > >
> > > > > This first round of patches aims to take care of the easy cases - patches
> > > > > with the Fixes tag that apply cleanly. I have ~30 more patches identified
> > > > > which will be tested next, thanks everyone for the various suggestions
> > > > > for tracking down more bug fixes. No regressions were seen during
> > > > > testing when running fstests 3 times per config with the following configs:
> > > 
> > > Leah,
> > > 
> > > It is great to see this work move forward.
> > > 
> > > How many times was fstest run *without* the patches to establish the
> > > baseline? Do you have a baseline for known failures published somewhere?
> > 
> > Currently, the tests are being run 10x per config without the patches.
> > If a failure is seen with the patches, the tests are rerun on the
> > baseline several hundred times to see if the failure was a regression or
> > to determine the baseline failure rate.
> 
> This is certainly one way to go about it. This just means that you have
> to do this work then as a second step. Whereas if you first have a high
> confidence in a baseline you then are pretty certain you have a
> regression once a test fails after you start testing deltas on
> a stable release.
> 
> Average failure rates for non-deterministic tests tend to be about
> 1/2 - 1/30. Although things such as 1/60, anything beyond 1/100
> exist is *very* rare. So running fstests just 10 times seems to me
> rather low to have any sort of high confidence in a baseline.
> 

Unfortunately, I am seeing some failures pop up with a fail rate of
~0.5-2% :( I typically end up rerunning failing tests up to 1000 times to
be confident about the failure rate on both the baseline and the backports
branch. Running each test 1000 times from the start is a bit much, but I
upped the test runs on both the baseline and backports branches to 100
runs per test to hopefully filter out some of the tests that fail more
consistently.


> > > 
> > > As discussed at LSFMM is there a chance we can collaborate on a baseline
> > > together? One way I had suggested we could do this for different test
> > > runners is to have git subtree with the expunges which we can all share
> > > for different test runner.
> > > 
> > 
> > Could you elaborate on this a bit? Are you hoping to gain insight from
> > comparing 5.10.y baseline with 5.15.y baseline or are you hoping to
> > allow people working on the same stable branch to have a joint record of
> > test run output?
> 
> Not output, but to share failures known to exist per kernel release and
> per filesystem, and even Linux distribution. We can shared this as
> expressed in an expunge file which can be used as input to running
> fstests so that tests are skipped for the release.
> 
> Annotations can be made with comments, you can see an existin list here:
> 
> https://github.com/linux-kdevops/kdevops/tree/master/workflows/fstests/expunges/
> 
> I currently track *.bad and *.dmesg outputs into gists and refer to them
> with a URL. Likewise when possible I annotate the failure rate.
> 
> *If* it makes sense to collaborate on that front I can extract *just*
> the expunges directory and make its own git subtree which then kdevops
> uses. Other test runner can then use the same git tree as a git subtree.

Personally, I don't think I would have much use for a git subtree. I have
been using expunges very sparingly - only for tests which cause crashes -
as I like to run even the failing tests to keep tabs on the failure rates.

> 
>   Luis

Best,
Leah
