Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A619C61DA4
	for <linux-xfs@archiver.kernel.org>; Thu,  9 Feb 2023 08:08:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229508AbjBIIIt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 9 Feb 2023 03:08:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229606AbjBIIIr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 9 Feb 2023 03:08:47 -0500
Received: from mail-vs1-xe35.google.com (mail-vs1-xe35.google.com [IPv6:2607:f8b0:4864:20::e35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB057367D3
        for <linux-xfs@vger.kernel.org>; Thu,  9 Feb 2023 00:08:46 -0800 (PST)
Received: by mail-vs1-xe35.google.com with SMTP id g8so1298688vso.3
        for <linux-xfs@vger.kernel.org>; Thu, 09 Feb 2023 00:08:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=ZvL2n30ySJLnc8Kp2HLwV2t15TMMiuonS4EFOHrak3g=;
        b=fOICeDyIfGpTUyJ8cYPewTPA+ES3j1uRmFpXlWkgiT3glUApgtJqx3evOGXq2B9Ukp
         OQDRBgLMogFS7hPv1oPwnjK0G5Q9wCtnDqDIF6wPW2VcxSdys9cJmEWI0r80Y1/JxdFs
         wg845t/Wy4PxfQiydbmM1uVnvnKifvgRwFG0G2dGwp0Vyh8T9U5T+pFlSw/4rqcCBzeJ
         /3EFeFygZuEJhVqYBIJmCo3os9yg4iJQs8ygHwMM2JgWonYTnZTdmVCn4HpFmuymoPk2
         JtcNdnhoY8d7zACuBIfsPtXz2Ra0/PKRfbN+Wn8uN+3b7JS9fuBXUvNLbcsU84F1kydw
         CQIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZvL2n30ySJLnc8Kp2HLwV2t15TMMiuonS4EFOHrak3g=;
        b=nmMWLupNYWhvIPpV8pNsSpVXuX0A8oEAr6HDnH+aFHx+EEvDqk1JgSiClnlhVXtaRO
         SzRM4LeUemoDLQBjEFqULI9wjzoPlgNbsVyozYtGWG7tkfcaTKp1n5+jtVojIhLpoKM6
         qzHX7u+HQRcpnpTd2j8cxf3EdsLgg0iIXGtG+zt/IR4i3ZA8k8wBmm5J8DHJDO4lrcN5
         Z1rJdJF9Mx+ij/CZzZhzLNh9B/EGl2N66/vBnxQ4ESHQV0Kif03JlDXW3rkvqcPiSC4f
         EBFr78PDcypx5eTA3KjKaLxK16d13dQLJ5Oxgl4RM+Pc/oHJdzF0aNlblzHZdkkV1C6m
         GFkA==
X-Gm-Message-State: AO0yUKXr6Se05wVpFwcBJIzKaW5E0R1A3IjfyeA7IxeAS2jsrCn9lVxC
        J/elNaG/F96uh/XYBd/WImWQd1ko9i4Zdwy7gw2mfUjG2Xg=
X-Google-Smtp-Source: AK7set9hGlAEjIBwUDGYS0k9Z1oOu7F5+8d5uli6/9CMfYtMd1pCO/0Tuk5SZiqTT8Dmpeo1QjRlpCUYL2Cro8ZcG4o=
X-Received: by 2002:a05:6102:27c5:b0:3ea:a853:97c4 with SMTP id
 t5-20020a05610227c500b003eaa85397c4mr2054465vsu.36.1675930125783; Thu, 09 Feb
 2023 00:08:45 -0800 (PST)
MIME-Version: 1.0
References: <20230208175228.2226263-1-leah.rumancik@gmail.com>
 <CAOQ4uxgmHzWcxBDrzRb19ByCnNoayhha_MZ_eYN0YMC=RGTeMw@mail.gmail.com>
 <Y+P6y81Wmf4L66LC@magnolia> <20230208222104.GD360264@dread.disaster.area>
In-Reply-To: <20230208222104.GD360264@dread.disaster.area>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Thu, 9 Feb 2023 10:08:34 +0200
Message-ID: <CAOQ4uxizYHfrbsim6jpfND1L9g=4wjQzODz7448xC=vhCN1-uQ@mail.gmail.com>
Subject: Re: [PATCH 5.15 CANDIDATE 00/10] more xfs fixes for 5.15
To:     Dave Chinner <david@fromorbit.com>
Cc:     "Darrick J. Wong" <djwong@kernel.org>,
        Leah Rumancik <leah.rumancik@gmail.com>,
        linux-xfs@vger.kernel.org, chandan.babu@oracle.com,
        Christian Brauner <brauner@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Feb 9, 2023 at 12:21 AM Dave Chinner <david@fromorbit.com> wrote:
>
> On Wed, Feb 08, 2023 at 11:40:59AM -0800, Darrick J. Wong wrote:
> > On Wed, Feb 08, 2023 at 09:02:58PM +0200, Amir Goldstein wrote:
> > > On Wed, Feb 8, 2023 at 7:52 PM Leah Rumancik <leah.rumancik@gmail.com> wrote:
> > > >
> > > > Hello again,
> > > >
> > > > Here is the next batch of backports for 5.15.y. Testing included
> > > > 25 runs of auto group on 12 xfs configs. No regressions were seen.
> > > > I checked xfs/538 was run without issue as this test was mentioned
> > > > in 56486f307100. Also, from 86d40f1e49e9, I ran ran xfs/117 with
> > > > XFS compiled as a module and TEST_FS_MODULE_REOLOAD set, but I was
> > > > unable to reproduce the issue.
> > >
> > > Did you find any tests that started to pass or whose failure rate reduced?
> >
> > I wish Leah had, but there basically aren't any tests for the problems
> > fixed in this set for her to find. :(
> .....
> > > There are very few Fixes: annotations in these commits so it is hard for
> > > me to assess if any of them are relevant/important/worth the effort/risk
> > > to backport to 5.10.
> >
> > <nod> Dave's fixpatches rarely have Fixes tags attached.  It's difficult
> > to get him to do that because he has so much bad history with AUTOSEL.
> > I've tried to get him to add them in the past, but if I'm already
> > stressed out and Dave doesn't reply then I tend to merge the fix and
> > move on.
>
> In my defense, all the "fixes" from me in this series (except for
> the one with a fixes tag on it) date back so long ago it was
> difficult to identify what commit actually introduced the issue.
> Once we're talking about "it's been there for at least a decade" -
> espcially for fuzzer issues - identifying the exact commit is time
> consuming and often not possible, nor really useful for anything.
>

I wouldn't want anyone to spend more time on fuzzer issues and
I myself have given those very little attention.
My expectation is to always have a Fixes tag when a developer
knows they are fixing a regression and best effort when it is easy
for the developer to determine when the buggy code was merged.

It doesn't even have to be in the form of a Fixes tag.
If the cover letter says "fixes to the $FEATURE from v5.18"
that is good enough for me.

As a stable maintainer, if a commit has no Fixes tag and no hint
in the cover letter about relevant kernel versions, I will assume
it is relevant to the LTS kernel and spend time on the manual triage.
If a developer adds a Fixes tag where relevant, that can save my
time by eliminating commits irrelevant for e.g. 5.10.y.
This wasn't the case in this series I guess.

> I'm also not going to tag a patch with "fixes commit xyz" when
> commit xyz isn't actually the cause of the problem just so that
> someone can blindly use that as a "it's got a fixes tag on it, we
> should back port it" trigger.
>
> That's the whole problem with AUTOSEL - blindly applying anything
> with a fixes tag on it that merges cleanly into an older kernel -
> and the whole point of having a human actually manage the stable
> kernel backports.
>
> The stable XFS kernel maintainer is supposed to be actively looking
> at the commits that go into the upstream kernel to determine if they
> are relevant or not to the given stable kernel, regardless of
> whether they address fstests failures, have fixes/stable tags on
> them, etc. If all we needed stable maintainers to do is turn a crank
> handle, then we'd be perfectly OK with AUTOSEL and the upstream
> stable kernel process....
>

Yes. The reason I did not pick any of the commits in this series for 5.10
is not because lack of Fixes/tests, but because I read the cover letters
(thanks for the links Leah!) and commit messages and conclude that
the risk/effort does not make the cut.

But this conclusion was based very much on my own intuition and my
own interpretation of the cover letters. This is why I asked Chandan to
take another look.

I encourage any developer who writes a cover letter to share their
own opinion about the relevancy and risks associated with backporting
their patch set to LTS kernels - make it as vague statement as you
wish, anything that can help a human LTS maintainer do their job better.

Thanks,
Amir.
