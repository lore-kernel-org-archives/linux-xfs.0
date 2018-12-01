Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-yb1-f193.google.com ([209.85.219.193]:43707 "EHLO
        mail-yb1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726209AbeLAUg6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 1 Dec 2018 15:36:58 -0500
MIME-Version: 1.0
References: <20181130051253.GB7100@sh-el5.eng.rdu2.redhat.com>
 <20181130121506.GI2299@dhcp-12-149.nay.redhat.com> <CAOQ4uxg9MdMbkM5+CuXK-VmmqxF8UmNkNqeKTHoxOtTnQ2=LnQ@mail.gmail.com>
 <20181130182322.GM8125@magnolia>
In-Reply-To: <20181130182322.GM8125@magnolia>
From: Amir Goldstein <amir73il@gmail.com>
Date: Sat, 1 Dec 2018 11:24:41 +0200
Message-ID: <CAOQ4uxjxTXZ14pcvy5wkJrwP012BdStx8gSNL=dkkOW1BXKT-g@mail.gmail.com>
Subject: Re: [4.20-rc4 regression] generic/095 Concurrent mixed I/O hang on
 xfs based overlayfs
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Dave Chinner <david@fromorbit.com>, jencce.kernel@gmail.com, linux-xfs <linux-xfs@vger.kernel.org>, overlayfs <linux-unionfs@vger.kernel.org>, Zorro Lang <zlang@redhat.com>, fstests <fstests@vger.kernel.org>

> > Darrick,
> >
> > This is my cue to insert a rant. You already know what I am going to rant about.
> >
> > I cannot force you to add a check -overlay xfstests run to your pull
> > request validation
> > routine. I can offer assistance in any questions you may have and I can offer
> > support for check -overlay infrastructure if it breaks or if it needs
> > improvements.
> >
> > I have checked on several recent point releases that check -overlay does not
> > regress any tests compared to xfs reflink configuration, and when I
> > found a regression
> > (mostly in overlayfs code, but also in xfs code sometimes) I reported
> > and/or fixed it.
> > But I do not have the resources to validate every xfs merge and
> > certainly not xfs-next.
> >
> > There is a large group of tests that is expected to notrun, which
> > makes running the
> > -overlay test a lot faster than any given xfs configuration and IMO
> > running just a single
> > xfs reflink config with -overlay would give a pretty good test coverage.
> >
> > So what do you say?...
>
> Frankly I'd rather push the kernelci/0day/lf/whoever folks to kick off
> fstests across all the major filesystems after the daily for-next merge
> so that we can all see if there are regressions over the previous day's
> test.  IOWs, rather than loading ourselves down with more testing
> burden, let's make it more public.
>
> I've received occasional reports from the 0day robot, but I'm not sure
> if it's testing consistently because it only ever seems to emit
> complaints, not "I love your branch and even better nothing regressed!".
>

That would indeed be great if we had some more knowledge about
what is being tested by 0day and friends.

Regardless, check -overlay had already found several bugs in XFS code
(I can look it up, but you know what I mean), so I argue that it would be
beneficial to you as XFS maintainer and not only to overlayfs users if
you run check -overlay on pull request branches.
Consider overlayfs as a unit test for some of the XFS VFS interfaces
that are harder (or impossible) to hit from userspace.
Besides, as I said, the cost of running check -overlay on a single reflink
config is relatively cheap, so please consider running it occasionally to be
a head of those type of bugs.

> That said, this *does* confirm Zorro's earlier point that I should give
> him a week to test xfs for-next before pushing to Linus.
>

It looks like between Zorro and yourself, overlayfs+xfs bugs should not
be slipping in to master anymore, so I'm happy with the way things are :-)

Thanks,
Amir.
