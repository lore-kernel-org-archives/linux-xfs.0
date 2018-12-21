Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-it1-f195.google.com ([209.85.166.195]:35867 "EHLO
        mail-it1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732492AbeLUEA7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 20 Dec 2018 23:00:59 -0500
Received: by mail-it1-f195.google.com with SMTP id c9so4867490itj.1
        for <linux-xfs@vger.kernel.org>; Thu, 20 Dec 2018 20:00:58 -0800 (PST)
MIME-Version: 1.0
References: <CABWYdi1YZp+baxpON2R6mP09pjkUz5D-OE7Z2KmwVGycYTN-AA@mail.gmail.com>
 <20181129021800.GQ6311@dastard> <CABWYdi0Bd6sMAaTPkfHKupMGpw1QPSf_VohPF_Wg7Mm=W=j2bA@mail.gmail.com>
 <20181130021840.GV6311@dastard> <CABWYdi0nSJAV-RPdUSwGbRwqeoKo-83_X=ptuQwwH1CnPXCYmQ@mail.gmail.com>
 <20181130064908.GX6311@dastard> <20181130074547.GY6311@dastard> <CABWYdi28ifToh-yWRAv4MSdJ9g6t-Rxyz2GAFXGFraCwf9BBDg@mail.gmail.com>
In-Reply-To: <CABWYdi28ifToh-yWRAv4MSdJ9g6t-Rxyz2GAFXGFraCwf9BBDg@mail.gmail.com>
From: Kenton Varda <kenton@cloudflare.com>
Date: Thu, 20 Dec 2018 20:00:21 -0800
Message-ID: <CAJouXQn2mSyyacnf_CnrhX-JQ1x2QOUoB3=bzsSfbHFfAdRc9Q@mail.gmail.com>
Subject: Re: Non-blocking socket stuck for multiple seconds on xfs_reclaim_inodes_ag()
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Ivan Babrou <ivan@cloudflare.com>
Cc: Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org, Shawn Bohrer <sbohrer@cloudflare.com>

Hi all,

I'm a coworker of Ivan's and wanted to add some background here -- in
particular to answer Dave's question about our workload.

For the purpose of this discussion, we can describe our workload as a
giant, glorified HTTP caching proxy. (We receive HTTP requests in. We
check if we have a cached response. If so, we return it to the client,
otherwise we forward the request on to its "origin" server. When the
origin responds, if the response is cacheable, we save it, and either
way we return it to the client.)

Roughly speaking, each HTTP cache entry is stored as a file on disk.
Hence, we have a very large number of files with files being added and
removed frequently. We also rely heavily on page cache for
performance, rather than some more complicated database scheme.

The HTTP requests we serve almost always come from live end users
interacting with a web site. So, any kind of delay means someone is
sitting and waiting. When delays get up over 15 seconds, we start
hitting timeouts, meaning someone's web site doesn't load at all or
loads "broken". Also note that any particular machine may serve
thousands of requests per second, so blocking one machine may affect
thousands of users.

When XFS blocks direct reclaim, our service pretty much grinds to a
halt on that machine, because everything is trying to allocate memory
all the time. For example, as alluded by the subject of this thread,
writing to a socket allocates memory, and thus will block waiting for
XFS to write back inodes. What we find really frustrating is that we
almost always have over 100GB of clean page cache that could be
reclaimed immediately, without blocking, yet we end up waiting for the
much-smaller inode cache to be written back to disk.

We really can't accept random multi-second pauses. Our current plan is
to roll out the patch Ivan linked to. But, if you have any other
suggestions, we'd love to hear them. It would be great if we could
agree on an upstream solution, and maybe solve Facebook's problem too.

Hope that helps elucidate things.

Thanks,
-Kenton


On Wed, Dec 19, 2018 at 2:15 PM Ivan Babrou <ivan@cloudflare.com> wrote:
>
> We're sticking with the following patch that allows runtime switching
> between XFS memory reclaim strategies:
>
> * https://github.com/bobrik/linux/pull/2
>
> There are some tests and graphs describing the issue and how it can be solved.
>
> Let me know if you think this can be incorporated upstream, I'm fine if not.
>
> On Thu, Nov 29, 2018 at 11:45 PM Dave Chinner <david@fromorbit.com> wrote:
> >
> > On Fri, Nov 30, 2018 at 05:49:08PM +1100, Dave Chinner wrote:
> > > Seriously: describe your workload in detail for me so I can write a
> > > reproducer for it. Without that I cannot help you any further and I
> > > am just wasting my time asking you to describe the workload over
> > > and over again.
> >
> > FWIW, here's the discussion that about the FB issue. Go read it,
> > the first few emails are pretty much the same as this thread so far.
> >
> > https://www.spinics.net/lists/linux-xfs/msg01541.html
> >
> > Cheers,
> >
> > Dave.
> > --
> > Dave Chinner
> > david@fromorbit.com
