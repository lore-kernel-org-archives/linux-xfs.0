Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-qk1-f195.google.com ([209.85.222.195]:33914 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725267AbeLSWPp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Dec 2018 17:15:45 -0500
Received: by mail-qk1-f195.google.com with SMTP id q8so10461145qke.1
        for <linux-xfs@vger.kernel.org>; Wed, 19 Dec 2018 14:15:45 -0800 (PST)
MIME-Version: 1.0
References: <CABWYdi1YZp+baxpON2R6mP09pjkUz5D-OE7Z2KmwVGycYTN-AA@mail.gmail.com>
 <20181129021800.GQ6311@dastard> <CABWYdi0Bd6sMAaTPkfHKupMGpw1QPSf_VohPF_Wg7Mm=W=j2bA@mail.gmail.com>
 <20181130021840.GV6311@dastard> <CABWYdi0nSJAV-RPdUSwGbRwqeoKo-83_X=ptuQwwH1CnPXCYmQ@mail.gmail.com>
 <20181130064908.GX6311@dastard> <20181130074547.GY6311@dastard>
In-Reply-To: <20181130074547.GY6311@dastard>
From: Ivan Babrou <ivan@cloudflare.com>
Date: Wed, 19 Dec 2018 14:15:33 -0800
Message-ID: <CABWYdi28ifToh-yWRAv4MSdJ9g6t-Rxyz2GAFXGFraCwf9BBDg@mail.gmail.com>
Subject: Re: Non-blocking socket stuck for multiple seconds on xfs_reclaim_inodes_ag()
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org, Shawn Bohrer <sbohrer@cloudflare.com>

We're sticking with the following patch that allows runtime switching
between XFS memory reclaim strategies:

* https://github.com/bobrik/linux/pull/2

There are some tests and graphs describing the issue and how it can be solved.

Let me know if you think this can be incorporated upstream, I'm fine if not.

On Thu, Nov 29, 2018 at 11:45 PM Dave Chinner <david@fromorbit.com> wrote:
>
> On Fri, Nov 30, 2018 at 05:49:08PM +1100, Dave Chinner wrote:
> > Seriously: describe your workload in detail for me so I can write a
> > reproducer for it. Without that I cannot help you any further and I
> > am just wasting my time asking you to describe the workload over
> > and over again.
>
> FWIW, here's the discussion that about the FB issue. Go read it,
> the first few emails are pretty much the same as this thread so far.
>
> https://www.spinics.net/lists/linux-xfs/msg01541.html
>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com
