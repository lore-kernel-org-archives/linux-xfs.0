Return-Path: <SRS0=k6ZN=2G=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 544DAC43603
	for <linux-xfs@archiver.kernel.org>; Mon, 16 Dec 2019 16:45:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2E26A206E0
	for <linux-xfs@archiver.kernel.org>; Mon, 16 Dec 2019 16:45:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726133AbfLPQps (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 16 Dec 2019 11:45:48 -0500
Received: from mout.kundenserver.de ([212.227.126.134]:38451 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725805AbfLPQps (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 16 Dec 2019 11:45:48 -0500
Received: from mail-qt1-f170.google.com ([209.85.160.170]) by
 mrelayeu.kundenserver.de (mreue011 [212.227.15.129]) with ESMTPSA (Nemesis)
 id 1MJEIl-1iQkcq0MGJ-00KdpX; Mon, 16 Dec 2019 17:45:47 +0100
Received: by mail-qt1-f170.google.com with SMTP id l12so6254831qtq.12;
        Mon, 16 Dec 2019 08:45:46 -0800 (PST)
X-Gm-Message-State: APjAAAViuger6gBit60jJGOPq1C9Dt1QZOzuEnqiwvPdFUEL9iZCklPa
        JwFL4cEF330X4rgdS+obNQdO/mBrwv+olTwfKns=
X-Google-Smtp-Source: APXvYqyNtNGvtOrieWJOqiT35oBaAfdHoFb3XM4O0PnpnAuRGShXkJ2ZEqQrbTQaSu86bkHc1+ANDnvgpR3Qr2vKo2Q=
X-Received: by 2002:ac8:3a27:: with SMTP id w36mr138947qte.204.1576514745925;
 Mon, 16 Dec 2019 08:45:45 -0800 (PST)
MIME-Version: 1.0
References: <20191213204936.3643476-1-arnd@arndb.de> <20191213205417.3871055-11-arnd@arndb.de>
 <20191213210509.GK99875@magnolia>
In-Reply-To: <20191213210509.GK99875@magnolia>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Mon, 16 Dec 2019 17:45:29 +0100
X-Gmail-Original-Message-ID: <CAK8P3a10wQuHGV3c2JYSkLsKLFK8t9fOmpE=fwULe8Aj41Kshg@mail.gmail.com>
Message-ID: <CAK8P3a10wQuHGV3c2JYSkLsKLFK8t9fOmpE=fwULe8Aj41Kshg@mail.gmail.com>
Subject: Re: [PATCH v2 20/24] xfs: disallow broken ioctls without compat-32-bit-time
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     y2038 Mailman List <y2038@lists.linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        Brian Foster <bfoster@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        Allison Collins <allison.henderson@oracle.com>,
        Jan Kara <jack@suse.cz>, Eric Sandeen <sandeen@sandeen.net>
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:h57ekWNpB4JlW+DfbI3eJXOF67r6gl5MO1WY/HYDe04eZOrYnwD
 NEQvjjr8vLyKJ2Gc5MslUDSqWTDZ1afTgWWJOyDGm5NG4gyBDDdbKI9VOVzz3FB1mpMBGB7
 kCxJd9KzuXpNZXRP7fQeRedMGQrAMx5zJXOhTtlGbzo9HyHe45yDa84i8xYTgdf/hkw0Geh
 9/s0xZOy/OYMRgTFLaDWQ==
X-UI-Out-Filterresults: notjunk:1;V03:K0:f9AkRGpJ1EU=:7690EZ12hBnd3ASWvMC1QW
 h7PZGe5QIyJczVcgk+AEHU53ZsEHiQkTLIR+/z9xZOx2L5HZHr9iNN85SKMHwKxtZNxR/9XmI
 ZoGueCcgYrQI3cgBfFhwa0GEqqQrrckxlmiHnaZymUVswG6etP/Zx6AoADtVkN9z0UOmW9JiK
 y19TChTmST+UVTZjVYvA0HaRr97XiD6ynYS0nhKPRc0UqUsIE7ffMlbsma0IA7vo7dOfOTj5H
 MqDffXJYJRXSAYbokyPnlqIlEe/fbIFiT4Ob+xqix8GNp6MRmhkRINmPa7CVmXmnnlvpQ1zQ0
 BaAtcIikrWfV/WxMegk5R0JKFEi3H6aldoYOrIt/cgGNzHavg2O1lnzRINx4UtU7TbhAHc4tA
 c3tgPYTeVbpi0LVLTDe4vB8xr522u1/uRXXMno4ZGWQAfEH2004DiQw9wT8u/OUlq6IPYSsCK
 uI2RgfKQgO2X/UlrbeF+Chw1imTuREmcqK20sMUtbqpN1A/4xF7W/HlYJl1HbpWkaiwgjZ2yy
 24hblAxus58ini3I+IZZG3uXlMc2veN+OrKSIFUXOFSLeU3zwaWaQNYaRZdOzkTnhefxGYWRf
 JxCgOerab4RitWrg+GF7lsuIfVHVNL4/TGjmhQtIGOtobMI677L7uIJFq1aCmDno1UO4G5rQM
 fcm55kcFe9S5OKpdkFQwkhLR2kaviJNwvRgzrK+NMVEJb4UQV2ixDek1w/oPRjZ6PagPYVy/S
 yTtiUF6mjNb+rCmkMVAlqDkqX1WCBOGY0PKtIqeJPNaRCQhcMu/k0k8au3hws+mFqX4Qo+oC0
 9xWSeUGvUuNQhj2aOoLv4/mNu8EU5etfNnXbAHtDMXGFfTFTrLPRKkONZShQ0glqAhrMIeM2a
 bSpv55HgEeiSUMXcWNAg==
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Dec 13, 2019 at 10:05 PM Darrick J. Wong
<darrick.wong@oracle.com> wrote:
>
> On Fri, Dec 13, 2019 at 09:53:48PM +0100, Arnd Bergmann wrote:
> > When building a kernel that disables support for 32-bit time_t
> > system calls, it also makes sense to disable the old xfs_bstat
> > ioctls completely, as they truncate the timestamps to 32-bit
> > values.
>
> Note that current xfs doesn't support > 32-bit timestamps at all, so for
> now the old bulkstat/swapext ioctls will never overflow.

Right, this patch originally came after my version of the 40-bit
timestamps that I dropped from the series now.

I've added "... once the extended times are supported." above now.

> Granted, I melded everyone's suggestions into a more fully formed
> 'bigtime' feature patchset that I'll dump out soon as part of my usual
> end of year carpetbombing of the mailing list, so we likely still need
> most of this patch anyway...

What is the timeline for that work now? I'm mainly interested in
getting the removal of 'time_t/timeval/timespec' and 'get_seconds()'
from the kernel done for v5.6, but it would be good to also have
this patch and the extended timestamps in the same version
just so we can claim that "all known y2038 issues" are addressed
in that release (I'm sure we will run into bugs we don't know yet).

> > @@ -617,6 +618,23 @@ xfs_fsinumbers_fmt(
> >       return xfs_ibulk_advance(breq, sizeof(struct xfs_inogrp));
> >  }
> >
> > +/* disallow y2038-unsafe ioctls with CONFIG_COMPAT_32BIT_TIME=n */
> > +static bool xfs_have_compat_bstat_time32(unsigned int cmd)
>
> The v5 bulkstat ioctls follow an entirely separate path through
> xfs_ioctl.c, so I think you don't need the @cmd parameter.

The check is there to not forbid XFS_IOC_FSINUMBERS at
the moment, since that is not affected.

> > @@ -1815,6 +1836,11 @@ xfs_ioc_swapext(
> >       struct fd       f, tmp;
> >       int             error = 0;
> >
> > +     if (xfs_have_compat_bstat_time32(XFS_IOC_SWAPEXT)) {
>
> if (!xfs_have...()) ?

Right, fixed now.

       Arnd
