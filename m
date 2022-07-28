Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D45BC19F29
	for <linux-xfs@archiver.kernel.org>; Thu, 28 Jul 2022 09:40:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235620AbiG1JkA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 28 Jul 2022 05:40:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235622AbiG1Jj7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 28 Jul 2022 05:39:59 -0400
Received: from mail-ua1-x92a.google.com (mail-ua1-x92a.google.com [IPv6:2607:f8b0:4864:20::92a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A04DE65D4E;
        Thu, 28 Jul 2022 02:39:58 -0700 (PDT)
Received: by mail-ua1-x92a.google.com with SMTP id r12so506847uaf.7;
        Thu, 28 Jul 2022 02:39:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=b9SON6vaCEaLKno9h+DjBnlljTFJJlT0r8VmKEyEixE=;
        b=CIFOarSlYANbf8kXk7Ysw/FAfH/igfU4G1V0qX2GL4YP+jEb1KfbPga6Y0YNo4XtMk
         VKpU0e0VbdMRV0RLiT867LtLfmqpkioLCKpgH2SuGKICtTpDLMxEqtsUZb3R/Qz56K8S
         Cx7RXc9++ASnKZ2Uyc2TtWgGcfC9tZTSqAEFt2Q6KvxKSHmdmgnzUzkJN2BSzhpX1omR
         SX2G0YRjUI0F08TX9FGw4uY4AtsFZ+Xh4eo3IP1oxUZpgcndTJW8HnmdfxeImdg2IhJI
         kInQIdJxW2XGI+xVXdBpIw05e3+RxieflX3gD/RcYXnRBkfCLmo6CAntgsncYU7+ZCjJ
         wBEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=b9SON6vaCEaLKno9h+DjBnlljTFJJlT0r8VmKEyEixE=;
        b=U9PrSmJUT26wnwEgo2mFww5rQFKehvsfVZjAM1avwo8RwvzwZy1EnSJy/v3RU2rRTx
         OP2RnB3Kmu6YPOFXUZuOOvUezw18fU7EKmDGTLloPalABeqA9/Ntr1dBkesgdrpMg/E6
         D8F+8UI2SNPuCCf6A+aafuqRGfDRHAf+j+k8dVECHuIBCjGBC2zf24bF3BXRH99xiEqQ
         6lfgwWKy4mfzbVQ9XHS3P4+RzllwXLSveLjc1sal5uRLTE7FCSjtoNeNOBQOB2TcWsLv
         BWGKVzs81jYywdOFOGGnP8g9uvVjR6lUxIf2h0wuUS5Z7sj+hr44TabtOy31gCkpjpAH
         NTUw==
X-Gm-Message-State: AJIora8iq16PvF9zlyTMDKJ1g/COHJ7mq/LOVCRn/MeQuJSh6mT4H/vV
        iS+fpNW9I6S64BotiyvIPYBIp6WlKu2tXLOQ77LL2Ocosv2ki+rK
X-Google-Smtp-Source: AGRyM1uWnWT/r+VXiWZmO4F2HccjaPd93NXi60AY5DdF8F8pNOxVMtWMb6l0/PPLC6Fn4EryGlOlhkLO1+TIZAQPoCs=
X-Received: by 2002:ab0:1c56:0:b0:384:cbd7:4329 with SMTP id
 o22-20020ab01c56000000b00384cbd74329mr4212017uaj.9.1659001197691; Thu, 28 Jul
 2022 02:39:57 -0700 (PDT)
MIME-Version: 1.0
References: <20220726092125.3899077-1-amir73il@gmail.com> <CAOQ4uxi=VYa+86A7G3wqCX84n2Aezx2mYqfYrFTAVtSpYmeq_Q@mail.gmail.com>
 <YuHt65YWtkqLxlpv@magnolia> <YuHve9LEkM7nmbUJ@magnolia>
In-Reply-To: <YuHve9LEkM7nmbUJ@magnolia>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Thu, 28 Jul 2022 11:39:45 +0200
Message-ID: <CAOQ4uxiSKNYAT_oUXAwGADt4KQvVH8s12nFSrRUoKYi8DOzQig@mail.gmail.com>
Subject: Re: [PATCH 5.10 CANDIDATE 0/9] xfs stable candidate patches for
 5.10.y (from v5.13+)
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Leah Rumancik <leah.rumancik@gmail.com>,
        Chandan Babu R <chandan.babu@oracle.com>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        fstests <fstests@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jul 28, 2022 at 4:07 AM Darrick J. Wong <djwong@kernel.org> wrote:
>
> On Wed, Jul 27, 2022 at 07:01:15PM -0700, Darrick J. Wong wrote:
> > On Wed, Jul 27, 2022 at 09:17:47PM +0200, Amir Goldstein wrote:
> > > On Tue, Jul 26, 2022 at 11:21 AM Amir Goldstein <amir73il@gmail.com> wrote:
> > > >
> > > > Darrick,
> > > >
> > > > This backport series contains mostly fixes from v5.14 release along
> > > > with three deferred patches from the joint 5.10/5.15 series [1].
> > > >
> > > > I ran the auto group 10 times on baseline (v5.10.131) and this series
> > > > with no observed regressions.
> > > >
> > > > I ran the recoveryloop group 100 times with no observed regressions.
> > > > The soak group run is in progress (10+) with no observed regressions
> > > > so far.
> > > >
> > > > I am somewhat disappointed from not seeing any improvement in the
> > > > results of the recoveryloop tests comapred to baseline.
> > > >
> > > > This is the summary of the recoveryloop test results on both baseline
> > > > and backport branch:
> > > >
> > > > generic,455, generic/457, generic/646: pass
> > > > generic/019, generic/475, generic/648: failing often in all config
> >
> > <nod> I posted a couple of patchsets to fstests@ yesterday that might
> > help with these recoveryloop tests failing.
> >
> > https://lore.kernel.org/fstests/165886493457.1585218.32410114728132213.stgit@magnolia/T/#t
> > https://lore.kernel.org/fstests/165886492580.1585149.760428651537119015.stgit@magnolia/T/#t
> > https://lore.kernel.org/fstests/165886491119.1585061.14285332087646848837.stgit@magnolia/T/#t
> >
> > > > generic/388: failing often with reflink_1024
> > > > generic/388: failing at ~1/50 rate for any config
> > > > generic/482: failing often on V4 configs
> > > > generic/482: failing at ~1/100 rate for V5 configs
> > > > xfs/057: failing at ~1/200 rate for any config
> > > >
> > > > I observed no failures in soak group so far neither on baseline nor
> > > > on backport branch. I will update when I have more results.
> > > >
> > >
> > > Some more results after 1.5 days of spinning:
> > > 1. soak group reached 100 runs (x5 configs) with no failures
> > > 2. Ran all the tests also on debian/testing with xfsprogs 5.18 and
> > >     observed a very similar fail/pass pattern as with xfsprogs 5.10
> > > 3. Started to run the 3 passing recoveryloop tests 1000 times and
> > >     an interesting pattern emerged -
> > >
> > > generic/455 failed 3 times on baseline (out of 250 runs x 5 configs),
> > > but if has not failed on backport branch yet (700 runs x 5 configs).
> > >
> > > And it's not just failures, it's proper data corruptions, e.g.
> > > "testfile2.mark1 md5sum mismatched" (and not always on mark1)
> >
> > Oh good!
> >
> >
> > >
> > > I will keep this loop spinning, but I am cautiously optimistic about
> > > this being an actual proof of bug fix.

That was wishful thinking - after 1500 x 5 runs there are 2 failures also
on the backport branch.

It is still better than 4 failures out of 800 x 5 runs on baseline, but I can
not call that a proof for bug fix - only no regression.

> > >
> > > If these results don't change, I would be happy to get an ACK for the
> > > series so I can post it after the long soaking.
> >
> > Patches 4-9 are an easy
> > Acked-by: Darrick J. Wong <djwong@kernel.org>
>
> I hit send too fast.
>
> I think patches 1-3 look correct.  I still think it's sort of risky,
> but your testing shows that things at least get better and don't
> immediately explode or anything. :)
>
> By my recollection of the log changes between 5.10 and 5.17 I think the
> lsn/cil split didn't change all that much, so if you get to the end of
> the week with no further problems then I say Acked-by for them too.
>

Great. I'll keep it spinning.

Thanks,
Amir.
