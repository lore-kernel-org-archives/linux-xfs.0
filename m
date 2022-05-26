Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B07F7C433F5
	for <linux-xfs@archiver.kernel.org>; Thu, 26 May 2022 18:59:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345624AbiEZS7d (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 26 May 2022 14:59:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231196AbiEZS7d (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 26 May 2022 14:59:33 -0400
Received: from mail-qk1-x72e.google.com (mail-qk1-x72e.google.com [IPv6:2607:f8b0:4864:20::72e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DBFBCFE24;
        Thu, 26 May 2022 11:59:32 -0700 (PDT)
Received: by mail-qk1-x72e.google.com with SMTP id p63so2332766qkf.0;
        Thu, 26 May 2022 11:59:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=weY+EYNxcvGxOH+7TMih1ZKr+3Mghx/ygRt8J31EFDg=;
        b=jaOwVcSyGLWyzzupmSslnUwVqqXsvKpJoOt3hwJ7ID4FpZTavxuN3o3NReLNn+60/7
         H1u2J29DTJqUmoN9PrHfyJPxldheH52ygNAc+9TpWGaVQRFEghGC+s92Tz/mcFg0wZ/y
         tDrFYsY0JtCumrtpGPzfR7TRTtDWHxm6VecNITthyELlMtP9S/FcVGFerf4qfvnM+QOg
         DbZBHfWi7I4mqYEtVCpipvmKexY4ThvlNtcX+De+7DsmumE6tBVAzDD9ZTu6X5YdI9uf
         FA+tPZ8h/XranTb0G7jD7ICpblcDk7Bm1qr5pnvJnnqxthJxDbPW0UuMyiXJ7lOGvrPe
         jVZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=weY+EYNxcvGxOH+7TMih1ZKr+3Mghx/ygRt8J31EFDg=;
        b=MzL4qcSBtOV9lkHYST6cVUkSARph7/qY83lXED3MisHGSxXt7DFUdAGFb8OanbgMjZ
         BbyEU9Ez4LJj6y5kOv1F3lZW32THB4CHCwlOxSy8lTV69uSVDZvwgJbzQu/PTIecqJAh
         WLJJPbUjaqGaz0W+UY+cKm/wemgmJxhS/RhnyLwgH50dXtU5DX5Ux8kJc2MgoF9ZHyrj
         qBcvc7XRc8GxbOipsCGwuVac6OCSRQKLZUh8rK1c6avMUwK+qI4vTw0czeA2g31saMNu
         n+yLdkT/rM8cv4d+OH0nDXUueVXxSuT8u5HefGAQKRpLIC6vmib5g4cW4AFkq84RPB1B
         dDng==
X-Gm-Message-State: AOAM533hgtFEcXDc7PI2Zwp44FgGngB1JpvBzyFWMgQzdy57HTLcNpDF
        WKN08SETrmSpkGJTkjf5tfVsHR3ZF62qctNsF9c=
X-Google-Smtp-Source: ABdhPJxPSa7EMRKRnQQ3oHpXzm9Mks25PmqzGTYGvvst7KXcoT5x4g33fu+XPJ4ubb86FOC761RDyYp4B5IdeCH8/Ys=
X-Received: by 2002:a37:6310:0:b0:6a5:71bf:17e6 with SMTP id
 x16-20020a376310000000b006a571bf17e6mr11011009qkb.258.1653591571204; Thu, 26
 May 2022 11:59:31 -0700 (PDT)
MIME-Version: 1.0
References: <20220525111715.2769700-1-amir73il@gmail.com> <Yo+4jW0e4+fYIxX2@magnolia>
 <Yo/KibX8TOj+rZkV@bombadil.infradead.org>
In-Reply-To: <Yo/KibX8TOj+rZkV@bombadil.infradead.org>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Thu, 26 May 2022 21:59:19 +0300
Message-ID: <CAOQ4uxgSKFutWq03Yu2+AvucoZwJ5azz5G5KgDSztCczk_+OtA@mail.gmail.com>
Subject: Re: [PATH 5.10 0/4] xfs stable candidate patches for 5.10.y (part 1)
To:     Luis Chamberlain <mcgrof@kernel.org>
Cc:     "Darrick J. Wong" <djwong@kernel.org>,
        Dave Chinner <david@fromorbit.com>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        "Theodore Ts'o" <tytso@mit.edu>,
        Adam Manzanares <a.manzanares@samsung.com>,
        Tyler Hicks <code@tyhicks.com>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        fstests <fstests@vger.kernel.org>,
        Leah Rumancik <lrumancik@google.com>, masahiroy@kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, May 26, 2022 at 9:44 PM Luis Chamberlain <mcgrof@kernel.org> wrote:
>
> On Thu, May 26, 2022 at 10:27:41AM -0700, Darrick J. Wong wrote:
> > /me looks and sees a large collection of expunge lists, along with
> > comments about how often failures occur and/or reasons.  Neat!
> >
> > Leah mentioned on the ext4 call this morning that she would have found
> > it helpful to know (before she started working on 5.15 backports) which
> > tests were of the flaky variety so that she could better prioritize the
> > time she had to look into fstests failures.  (IOWS: saw a test fail a
> > small percentage of the time and then burned a lot of machine time only
> > to figure out that 5.15.0 also failed a percentage of th time).
>
> See my proposal to try to make this easier to parse:
>
> https://lore.kernel.org/all/YoW0ZC+zM27Pi0Us@bombadil.infradead.org/
>
> > We talked about where it would be most useful for maintainers and QA
> > people to store their historical pass/fail data, before settling on
> > "somewhere public where everyone can review their colleagues' notes" and
> > "somewhere minimizing commit friction".  At the time, we were thinking
> > about having people contribute their notes directly to the fstests
> > source code, but I guess Luis has been doing that in the kdevops repo
> > for a few years now.
> >
> > So, maybe there?
>
> For now sure, I'm happy to add others the linux-kdevops org on github
> and they get immediate write access to the repo. This is working well
> so far. Long term we need to decide if we want to spin off the
> expunge list as a separate effort and make it a git subtree (note
> it is different than a git sub module). Another example of a use case
> for a git subtree, to use it as an example, is the way I forked
> kconfig from Linux into a standalone git tree so to allow any project
> to bump kconfig code with just one command. So different projects
> don't need to fork kconfig as they do today.
>
> The value in doing the git subtree for expunges is any runner can use
> it. I did design kdevops though to run on *any* cloud, and support
> local virtualization tech like libvirt and virtualbox.
>
> The linux-kdevops git org also has other projects which both fstest
> and blktests depend on, so for example dbench which I had forked and
> cleaned up a while ago. It may make sense to share keeping oddball
> efforts like thse which are no longer maintained in this repo.
>
> There is other tech I'm evaluating for this sort of collaborative test
> efforts such as ledgers, but that is in its infancy at this point in
> time. I have a sense though it may be a good outlet for collection of
> test artifacts in a decentralized way and also allow *any* entity to
> participate in bringing confidence to stable kernel branches or dev
> branches prior to release.
>

There are few problems I noticed with the current workflow.

1. It will not scale to maintain this in git as more and more testers
start using kdepops and adding more and more fs and configs and distros.
How many more developers you want to give push access to linux-kdevops?
I don't know how test labs report to KernelCI, but we need to look at their
model and not invent the wheel.

2. kdevops is very focused on stabilizing the baseline fast, which is
very good, but there is no good process of getting a test out of expunge list.
We have a very strong suspicion that some of the tests that we put in
expunge lists failed due to some setup issue in the host OS that caused
NVME IO errors in the guests. I tried to put that into comments when
I noticed that, but I am afraid there may have been other tests that are
falsely accused of failing. All developers make those mistakes in their
own expunge lists, but if we start propagating those mistakes to the world,
it becomes an issue.

For those two reasons I think that the model to aspire to should be
composed of a database where absolutely everyone can post data
point to in the form of facts (i.e. the test failed after N runs on this kernel
and this hardware...) and another process, partly AI, partly human to
digest all those facts into a knowledge base that is valuable and
maintained by experts. Much easier said than done...

Thanks,
Amir.
