Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9FA02C04A68
	for <linux-xfs@archiver.kernel.org>; Fri, 29 Jul 2022 16:15:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230163AbiG2QPw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 29 Jul 2022 12:15:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231976AbiG2QPv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 29 Jul 2022 12:15:51 -0400
Received: from mail-vs1-xe30.google.com (mail-vs1-xe30.google.com [IPv6:2607:f8b0:4864:20::e30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B01F4FD29;
        Fri, 29 Jul 2022 09:15:50 -0700 (PDT)
Received: by mail-vs1-xe30.google.com with SMTP id 129so5022815vsq.8;
        Fri, 29 Jul 2022 09:15:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=mzoPDf5bDlXx1BaYbqPpOiGhYYUfpkfcEpH1gSsIq0g=;
        b=LG2i5/BHu/Y7osIg+JH3KAl+aG/uU6dDUbVb2Xmv2eYIJ+vK8KsqWRZAEaQ6xrQyEF
         oe/zzVQP0C7pOvYlLIXHWNPN0s4rND02vN5iDWaUglwIMgaMqPPxH8Cvq7aisQl2WZBc
         NsgW7ZsxavHW+03qzeSg7HCYgdqaZKPIqVktUzoD3NgbjCwgB1x0razFHGdnDEtF1Eb5
         xRwEvn/5gInKBrg6pQueOx7Buzc8ifoiuvEriPWPDKC5pgTspwY0hOo9HVDl7qfZVTXT
         blEE16rrH2ecy1v9Whs5N5yi6C+VxXQytIPKUKoWYmd5KoPFcQq5+m/Qk4gKlki5RQhe
         w6/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=mzoPDf5bDlXx1BaYbqPpOiGhYYUfpkfcEpH1gSsIq0g=;
        b=hjFbN54k7yX6Qu4kS0LUCRXbyk/vt3O0BBJidhDuuJ7gf1z95qfxNcl6/9y3XTcU/z
         1GQCWunWqjJoddbUIWAygnaRpQoOeVz3Y0CTMGIcVMCPfT4Cf6eFTisDlnOWCsQKyuoO
         61k9W0XefamDisndmNjpXM2iWmNtQ7IbfF8rIkZ2b+1s4wHFyjk4Q+oj01h9W16PdjyW
         JWBECXfW2LH87kN1jKvyqUMlozo8b5CN1WzzZmfGmiFfVYgQ1o60ZNCDfb5iEZA9adEB
         uJZPVXUZWDtigbUo5fYRx8g4zvXA3K+qHoWowScxPnqTpI2QWko3h4DVigmcSLOYCfW9
         Mz+A==
X-Gm-Message-State: AJIora++8S34+pwa5b+BTKnu4824aeBUWNSZPdx3qj1Ez8S6Oa774UHa
        +6jcaAgle19Syca57kYoSftMWkNpnV+9eOCbcEdQd4iBKEA=
X-Google-Smtp-Source: AGRyM1sznv/9jLAu/P6nK9T1fjifa+VwUMkIaEixgKPPQDU/XYabfVkUmLROWvfRrwM3Ue/9Kvx3idUrZbTYnWzJI4s=
X-Received: by 2002:a67:eb98:0:b0:358:6274:71b3 with SMTP id
 e24-20020a67eb98000000b00358627471b3mr1607451vso.72.1659111349554; Fri, 29
 Jul 2022 09:15:49 -0700 (PDT)
MIME-Version: 1.0
References: <20220726092125.3899077-1-amir73il@gmail.com> <CAOQ4uxi=VYa+86A7G3wqCX84n2Aezx2mYqfYrFTAVtSpYmeq_Q@mail.gmail.com>
 <YuHt65YWtkqLxlpv@magnolia> <YuHve9LEkM7nmbUJ@magnolia> <CAOQ4uxiSKNYAT_oUXAwGADt4KQvVH8s12nFSrRUoKYi8DOzQig@mail.gmail.com>
In-Reply-To: <CAOQ4uxiSKNYAT_oUXAwGADt4KQvVH8s12nFSrRUoKYi8DOzQig@mail.gmail.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Fri, 29 Jul 2022 18:15:38 +0200
Message-ID: <CAOQ4uxgbWOEZTCX_S43DCT-0KihU6By3TtwvYjZA6DS=y20FHQ@mail.gmail.com>
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

On Thu, Jul 28, 2022 at 11:39 AM Amir Goldstein <amir73il@gmail.com> wrote:
>
> On Thu, Jul 28, 2022 at 4:07 AM Darrick J. Wong <djwong@kernel.org> wrote:
> >
> > On Wed, Jul 27, 2022 at 07:01:15PM -0700, Darrick J. Wong wrote:
> > > On Wed, Jul 27, 2022 at 09:17:47PM +0200, Amir Goldstein wrote:
> > > > On Tue, Jul 26, 2022 at 11:21 AM Amir Goldstein <amir73il@gmail.com> wrote:
> > > > >
> > > > > Darrick,
> > > > >
> > > > > This backport series contains mostly fixes from v5.14 release along
> > > > > with three deferred patches from the joint 5.10/5.15 series [1].
> > > > >
> > > > > I ran the auto group 10 times on baseline (v5.10.131) and this series
> > > > > with no observed regressions.
> > > > >
> > > > > I ran the recoveryloop group 100 times with no observed regressions.
> > > > > The soak group run is in progress (10+) with no observed regressions
> > > > > so far.
> > > > >
> > > > > I am somewhat disappointed from not seeing any improvement in the
> > > > > results of the recoveryloop tests comapred to baseline.
> > > > >
> > > > > This is the summary of the recoveryloop test results on both baseline
> > > > > and backport branch:
> > > > >
> > > > > generic,455, generic/457, generic/646: pass
> > > > > generic/019, generic/475, generic/648: failing often in all config
> > >
> > > <nod> I posted a couple of patchsets to fstests@ yesterday that might
> > > help with these recoveryloop tests failing.
> > >
> > > https://lore.kernel.org/fstests/165886493457.1585218.32410114728132213.stgit@magnolia/T/#t
> > > https://lore.kernel.org/fstests/165886492580.1585149.760428651537119015.stgit@magnolia/T/#t
> > > https://lore.kernel.org/fstests/165886491119.1585061.14285332087646848837.stgit@magnolia/T/#t
> > >
> > > > > generic/388: failing often with reflink_1024
> > > > > generic/388: failing at ~1/50 rate for any config
> > > > > generic/482: failing often on V4 configs
> > > > > generic/482: failing at ~1/100 rate for V5 configs
> > > > > xfs/057: failing at ~1/200 rate for any config
> > > > >
> > > > > I observed no failures in soak group so far neither on baseline nor
> > > > > on backport branch. I will update when I have more results.
> > > > >
> > > >
> > > > Some more results after 1.5 days of spinning:
> > > > 1. soak group reached 100 runs (x5 configs) with no failures
> > > > 2. Ran all the tests also on debian/testing with xfsprogs 5.18 and
> > > >     observed a very similar fail/pass pattern as with xfsprogs 5.10
> > > > 3. Started to run the 3 passing recoveryloop tests 1000 times and
> > > >     an interesting pattern emerged -
> > > >
> > > > generic/455 failed 3 times on baseline (out of 250 runs x 5 configs),
> > > > but if has not failed on backport branch yet (700 runs x 5 configs).
> > > >
> > > > And it's not just failures, it's proper data corruptions, e.g.
> > > > "testfile2.mark1 md5sum mismatched" (and not always on mark1)
> > >
> > > Oh good!
> > >
> > >
> > > >
> > > > I will keep this loop spinning, but I am cautiously optimistic about
> > > > this being an actual proof of bug fix.
>
> That was wishful thinking - after 1500 x 5 runs there are 2 failures also
> on the backport branch.
>
> It is still better than 4 failures out of 800 x 5 runs on baseline, but I can
> not call that a proof for bug fix - only no regression.
>
> > > >
> > > > If these results don't change, I would be happy to get an ACK for the
> > > > series so I can post it after the long soaking.
> > >
> > > Patches 4-9 are an easy
> > > Acked-by: Darrick J. Wong <djwong@kernel.org>
> >
> > I hit send too fast.
> >
> > I think patches 1-3 look correct.  I still think it's sort of risky,
> > but your testing shows that things at least get better and don't
> > immediately explode or anything. :)
> >
> > By my recollection of the log changes between 5.10 and 5.17 I think the
> > lsn/cil split didn't change all that much, so if you get to the end of
> > the week with no further problems then I say Acked-by for them too.
> >
>
> Great. I'll keep it spinning.
>

Well, it's the end of my week now and loop has passed over 4,000
runs x 5 configs on the backport branch with only 4 failures, so it's
going to stable.

Thanks,
Amir.
