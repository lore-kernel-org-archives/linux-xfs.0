Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-yb1-f194.google.com ([209.85.219.194]:45571 "EHLO
        mail-yb1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726084AbeLAAkY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Nov 2018 19:40:24 -0500
MIME-Version: 1.0
References: <20181130051253.GB7100@sh-el5.eng.rdu2.redhat.com> <20181130121506.GI2299@dhcp-12-149.nay.redhat.com>
In-Reply-To: <20181130121506.GI2299@dhcp-12-149.nay.redhat.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Fri, 30 Nov 2018 15:30:54 +0200
Message-ID: <CAOQ4uxg9MdMbkM5+CuXK-VmmqxF8UmNkNqeKTHoxOtTnQ2=LnQ@mail.gmail.com>
Subject: Re: [4.20-rc4 regression] generic/095 Concurrent mixed I/O hang on
 xfs based overlayfs
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: jencce.kernel@gmail.com, linux-xfs <linux-xfs@vger.kernel.org>, overlayfs <linux-unionfs@vger.kernel.org>, Zorro Lang <zlang@redhat.com>, fstests <fstests@vger.kernel.org>

On Fri, Nov 30, 2018 at 2:13 PM Zorro Lang <zlang@redhat.com> wrote:
>
> On Fri, Nov 30, 2018 at 12:12:53AM -0500, Murphy Zhou wrote:
> > Hi,
> >
> > Hit a xfs regression issue by generic/095 on overlayfs.
> >
> > It's easy to reproduce. Tests processes hang there and never return.
> > There are some warning in the dmesg.
> >
> > SIGINT (Ctrl+C) can't kill the tests, neither does SIGTERM (kill).
> > However, SIGKILL (kill -9) can clean them up.
> >
> > This happens when testing on v4 or v5 or reflink, with the same behaviour.
> > -m crc=0
> > -m crc=1,finobt=1,rmapbt=0,reflink=0 -i sparse=1
> > -m crc=1,finobt=1,rmapbt=1,reflink=1 -i sparse=1
> >
> > This does not happen if ext4 as base fs for overlayfs.
> >
> > Bisecting points to this commit:
> >       4721a601 iomap: dio data corruption and spurious errors when pipes fill
> >
> > Test pass soon after this commit reverted.
> >
> > # ps axjf
> >  1839  1862   S+    0:00  |  \_ /bin/bash ./bin/single -o -t generic/095
> >  1862  2005   S+    0:00  |      \_ /bin/bash ./check -T -overlay generic/095
> >  2005  2292   S+    0:00  |          \_ /bin/bash ./tests/generic/095
> >  2292  2516   Sl+   0:01  |              \_ /usr/bin/fio /tmp/2292.fio
> >  2516  2565   Rs    6:02  |                  \_ /usr/bin/fio /tmp/2292.fio
> >  2516  2566   Rs    6:02  |                  \_ /usr/bin/fio /tmp/2292.fio
> >  2516  2567   Rs    6:02  |                  \_ /usr/bin/fio /tmp/2292.fio
> >  2516  2568   Rs    6:02  |                  \_ /usr/bin/fio /tmp/2292.fio
> >  2516  2569   Rs    6:02  |                  \_ /usr/bin/fio /tmp/2292.fio
>
> Nice catch! I didn't tried overlayfs on XFS regression test this time. I never hit
> issue on XFS singly, even on glusterfs(XFS underlying).
>
> I just gave it a try. This bug is reproducible on xfs-linux git tree
> xfs-4.20-fixes-2 HEAD. And by strace all fio processes, they all
> keep outputing [1]. More details as [2]. Only overlayfs on XFS can
> reproduce this bug, overlayfs on Ext4 can't.
>

Darrick,

This is my cue to insert a rant. You already know what I am going to rant about.

I cannot force you to add a check -overlay xfstests run to your pull
request validation
routine. I can offer assistance in any questions you may have and I can offer
support for check -overlay infrastructure if it breaks or if it needs
improvements.

I have checked on several recent point releases that check -overlay does not
regress any tests compared to xfs reflink configuration, and when I
found a regression
(mostly in overlayfs code, but also in xfs code sometimes) I reported
and/or fixed it.
But I do not have the resources to validate every xfs merge and
certainly not xfs-next.

There is a large group of tests that is expected to notrun, which
makes running the
-overlay test a lot faster than any given xfs configuration and IMO
running just a single
xfs reflink config with -overlay would give a pretty good test coverage.

So what do you say?...

Thanks,
Amir.
