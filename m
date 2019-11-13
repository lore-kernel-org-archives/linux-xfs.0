Return-Path: <SRS0=J5MO=ZF=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CEAD5C43331
	for <linux-xfs@archiver.kernel.org>; Wed, 13 Nov 2019 13:21:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AAEF4222CD
	for <linux-xfs@archiver.kernel.org>; Wed, 13 Nov 2019 13:21:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726410AbfKMNVF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 13 Nov 2019 08:21:05 -0500
Received: from mout.kundenserver.de ([212.227.126.135]:35401 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726190AbfKMNVF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 13 Nov 2019 08:21:05 -0500
Received: from mail-qt1-f179.google.com ([209.85.160.179]) by
 mrelayeu.kundenserver.de (mreue010 [212.227.15.129]) with ESMTPSA (Nemesis)
 id 1MFsIZ-1iffGb1cJL-00HOuH for <linux-xfs@vger.kernel.org>; Wed, 13 Nov 2019
 14:21:02 +0100
Received: by mail-qt1-f179.google.com with SMTP id o11so2483089qtr.11
        for <linux-xfs@vger.kernel.org>; Wed, 13 Nov 2019 05:21:02 -0800 (PST)
X-Gm-Message-State: APjAAAUicUSbFMsSAg0yr2aoDV6Wn1EZODU3l1DVUQgzOZ8QWUbIBpH+
        V2xhOlT+D5ePnpX4HtHyyzge9c391QLxRDab6zg=
X-Google-Smtp-Source: APXvYqxEKlww0R6Ri4Y/Br4gvwUIX2r6HuEgGLwHEeOKrB/Kayumup48ooNKqWt5AARWcdeYf7oGEmkchxsuFdfl/HM=
X-Received: by 2002:ac8:2e57:: with SMTP id s23mr2514337qta.204.1573651261282;
 Wed, 13 Nov 2019 05:21:01 -0800 (PST)
MIME-Version: 1.0
References: <20191111213630.14680-1-amir73il@gmail.com> <20191111223508.GS6219@magnolia>
 <CAOQ4uxgC8Gz+uyCaV_Prw=uUVNtwv0j7US8sbkfoTphC4Z6b6A@mail.gmail.com>
 <20191112211153.GO4614@dread.disaster.area> <20191113035611.GE6219@magnolia>
 <CAOQ4uxi9vzR4c3T0B4N=bM6DxCwj_TbqiOxyOQLrurknnyw+oA@mail.gmail.com> <20191113045840.GR6219@magnolia>
In-Reply-To: <20191113045840.GR6219@magnolia>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Wed, 13 Nov 2019 14:20:44 +0100
X-Gmail-Original-Message-ID: <CAK8P3a2+AhLj+eAJVmKZ_V82Xgdb87vv8o01CzYQ=MCNA5bU-A@mail.gmail.com>
Message-ID: <CAK8P3a2+AhLj+eAJVmKZ_V82Xgdb87vv8o01CzYQ=MCNA5bU-A@mail.gmail.com>
Subject: Re: [RFC][PATCH] xfs: extended timestamp range
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Amir Goldstein <amir73il@gmail.com>,
        Dave Chinner <david@fromorbit.com>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        Deepa Dinamani <deepa.kernel@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:bPXxwu7J7lv+dT8DSBuyZxesDUO+CvShZ6cxCC7hpYOW2CeA/Gx
 vP5yMNDz4pa3T9vinEhWWs15onseptZm6AoG2Bop98EC4OtarXSLuMFnTWlpRCEAR5MZOhd
 O78h+U9ugdZluv0ygzW93ZB9O6zVcGzzclk7/eWxEwWShmqM5E0blKHi1glCTd/ETGyNp7b
 R50hkEaUkRbVl0uzrEHPw==
X-UI-Out-Filterresults: notjunk:1;V03:K0:URpbtdpYFqA=:ZKh3zCa3iZgEApOeCVEAVH
 mL6nNwz1Y3XWmTEQ+zth6awjDto2uxHynWQLf9Z8/Np6cnvTlUJV8u8NkL7aGXJH3RJt55jFe
 L8Q4TDTM4vVrMrYZTAKelvlygUes7VMbqvtWXRKrnkJjCCTlhIgvGqRNIk4slVf4Aeu1rZ5lO
 oeY63bgUMKp0FxP9aUr24S30g71srQBCr2s0ctKa5fa+ThdwRBDuryPfIpG2/vEZzwnk/9RCy
 k0l3/6VjRqGGw5cHKHOVpofJk2ejXGiGxiSfqOMj8X1JZpzFzanSI1hUM6eWwV41G69UKSnDP
 OvxP4z9zjLLNgAeENtE57nWY7HaCMbgBqIde+HMJhqZiExN49VGd/CIzapixXaJWWGsYk+vFi
 YKhqqtLnF9tMlkFwmQ+U1MdYT7f/tbjaP7dDjIfEfbUGKZMbVDwA4cdPPAulDqIjp3pSCSWuS
 UFWtG/eqTVjPU1HQeMy2ij8kow7Wpt0BrpHzQdjWbJIatHEHQP0xYKKLVgbE8566/g9HU2ld2
 Gs3BkbpYnoBzBLoGwDXdoqxLwNKzIQV06OBn/kxHPRt1l7EC8Ust6XjEhYaAs1/jYOJw6Yy5Q
 nPDEWoM4TV5Xbs8BwXBA9JtbhFdMkYG+RGS59L/onnNG6rsan+UTwhfAmx6szLZl0jF3xARGx
 Cn/W34p91VdrkPjgQ5EjJp7nroYGwayhasz8229+LjOEu4YaiF2a9nLmK+1aPPLysyWj2ugH/
 4Ldk5m2nMTe/RfJxVYeAd1VY5vrdiedY6w7YgA9ciUqG8uQF6EkPGpSzOAq1WCzGEVoruGRys
 OkW2U4IcRhdx7kKLqMn2VmNh41fYL5b5TGliuxe0FiGg1u+H6W+LiWrlYr6gVsw54baytAebJ
 xh/6J1MoZVzwpTmMFkNg==
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Nov 13, 2019 at 5:59 AM Darrick J. Wong <darrick.wong@oracle.com> wrote:
> On Wed, Nov 13, 2019 at 06:42:09AM +0200, Amir Goldstein wrote:
> > [CC:Arnd,Deepa]
> > On Wed, Nov 13, 2019 at 5:56 AM Darrick J. Wong <darrick.wong@oracle.com> wrote:
> > >
> > > On Wed, Nov 13, 2019 at 08:11:53AM +1100, Dave Chinner wrote:
> > > > On Tue, Nov 12, 2019 at 06:00:19AM +0200, Amir Goldstein wrote:
> > > > > On Tue, Nov 12, 2019 at 12:35 AM Darrick J. Wong
> > > > > <darrick.wong@oracle.com> wrote:
> > >
> >
> > I didn't get why you dropped the di_pad idea (Arnd's and Dave's patches).
> > Is it to save the pad for another rainy day?
>
> Something like that.  Someone /else/ can worry about the y2486 problem.
>
> <duck>
>
> Practically speaking I'd almost rather drop the precision in order to
> extend the seconds range, since timestamp updates are only precise to
> HZ anyway.

I think there would be noticeable overhead from anything that requires
a 64-bit division to update a timestamp, or to read it into an in-memory
inode, especially on 32-bit architectures.

I think the reason why separate seconds/nanoseconds are easy is that
this is what both the in-kernel and user space interface are based around.
We clearly don't use the precision, but anything else is more expensive
at runtime.

> > > > IOWs, we pretty much decided on a new 64 bit encoding format using a
> > > > epoch of 1900 and a unsigned 64bit nanosecond counter to get us a
> > > > range of almost 600 years from year 1900-2500. It's simple, easy to
> > > > encode/decode, and very easy to validate. It's also trivially easy
> > > > to do in-place upgrades with an inode flag....
> > > >
> >
> > All right, so how do we proceed?
> > Arnd, do you want to re-work your series according to this scheme?
>
> Lemme read them over again. :)
>
> > Is there any core xfs developer that was going to tackle this?
> >
> > I'm here, so if you need my help moving things forward let me know.
>
> I wrote a trivial garbage version this afternoon, will have something
> more polished tomorrow.  None of this is 5.6 material, we have time.

I think from a user perspective, it would be the nicest to just add the
extra high bits (however many, I don't care) and treat it as an ro-compatible
extension, possibly even as completely compatible both ways.

Note that for any released kernel (5.4 changes this), this matches
the existing behavior: setting a timestamp after 2038 using utimensat()
silently wraps the seconds back to the regular epoch. With the
extension patch, you get the correct results as long as the inode was
both written and read on a new enough kernel, while all pre-5.4
kernels produce the same incorrect data that they always have.

       Arnd
