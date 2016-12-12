Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:32915 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751028AbcLLIK7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 12 Dec 2016 03:10:59 -0500
Received: by mail-wm0-f67.google.com with SMTP id u144so9507179wmu.0
        for <linux-xfs@vger.kernel.org>; Mon, 12 Dec 2016 00:10:59 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20161212074430.GX4326@dastard>
References: <CAOQ4uxi_x+7Kc3P_xMr4O3DUKK7uhkfoUoyQsp7PYnxJaeLzcw@mail.gmail.com>
 <20161212015959.GT4326@dastard> <CAOQ4uxhiOb9SBgDaqjY5gQ+Z99BRWCFtc=vyGiB4PmXyDYQQZA@mail.gmail.com>
 <20161212074430.GX4326@dastard>
From: Amir Goldstein <amir73il@gmail.com>
Date: Mon, 12 Dec 2016 10:10:57 +0200
Message-ID: <CAOQ4uxg=2X27tKod1EcwGCUYArMKPjOhW2toWnLM3w2ju79HTg@mail.gmail.com>
Subject: Re: [RFC] Preparing for XFS reflink D-day
Content-Type: text/plain; charset=UTF-8
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org

On Mon, Dec 12, 2016 at 9:44 AM, Dave Chinner <david@fromorbit.com> wrote:
> On Mon, Dec 12, 2016 at 07:06:37AM +0200, Amir Goldstein wrote:
...
>
> IOWs, the /earliest/ anything like this could be done is 4.11, but
> I'd be really hesitant to rush anything like this into 4.11 because
> of all the stuff we already have in the pipeline.  And given that
> we're currently looking at around the 4.12 release timeframe for
> moving to full support for reflink, what does all this extra
> "refcount-but-not-reflink" format shenanigans buy us? At best it's
> going to be useful for a 3-6 month window, with very very limited
> relevance or use to the rest of the XFS userbase?
>

If I truly believed that 4.12 is a realistic target, I wouldn't have bothered
at all. But to get there we need to have a sufficiently large beta group
of bleeding edge testers, don't you think?
In fact, I am hoping that overlayfs "clone up" is merged to 4.10, creating
a big incentive to CoreOS users to start experimenting with docker
with overlayfs over XFS reflink, so there may be hope for that beta group.

FYI, and unrelated, in coming up docker 1.13 release I implemented
support for container disk usage quota with overlayfs storage driver
over xfs using project quotas.
This is catching up with a feature that btrfs/zfs/lvm storage driver
already have.
So soon enough, docker users will have a new incentive to use xfs
an base fs.

> When I look at what you are proposing from this perspective, the
> cost-benefit analysis does not fall favourably on the side of making
> these changes.
>

There is only one single benefit to what I am proposing
and that is for admins that want to install systems near the day that
reflink is declared stable and wait for the D-day before activation.
How many such admins are there, I have no idea. This is why I am
posting this requirement on a public mailing list - to find out.

Following your feedback, I suppose I am going to go for the
option of carrying a patch for -onoreflink.
And yes, take the support of experimental reflink (refcount<=1)
on myself.

Cheers,
Amir.
