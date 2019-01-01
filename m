Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail03.adl2.internode.on.net ([150.101.137.141]:55219 "EHLO
        ipmail03.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725941AbfAAXsY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 1 Jan 2019 18:48:24 -0500
Date: Wed, 2 Jan 2019 10:48:18 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Non-blocking socket stuck for multiple seconds on
 xfs_reclaim_inodes_ag()
Message-ID: <20190101234818.GJ4205@dastard>
References: <20181129021800.GQ6311@dastard>
 <CABWYdi0Bd6sMAaTPkfHKupMGpw1QPSf_VohPF_Wg7Mm=W=j2bA@mail.gmail.com>
 <20181130021840.GV6311@dastard>
 <CABWYdi0nSJAV-RPdUSwGbRwqeoKo-83_X=ptuQwwH1CnPXCYmQ@mail.gmail.com>
 <20181130064908.GX6311@dastard>
 <20181130074547.GY6311@dastard>
 <CABWYdi28ifToh-yWRAv4MSdJ9g6t-Rxyz2GAFXGFraCwf9BBDg@mail.gmail.com>
 <CAJouXQn2mSyyacnf_CnrhX-JQ1x2QOUoB3=bzsSfbHFfAdRc9Q@mail.gmail.com>
 <20181225234732.GH4205@dastard>
 <CAJouXQndAaybOzbSLRq+Uw7a35YLkUnL5NmRC0qLbV+8QP+vaA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJouXQndAaybOzbSLRq+Uw7a35YLkUnL5NmRC0qLbV+8QP+vaA@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Kenton Varda <kenton@cloudflare.com>
Cc: Ivan Babrou <ivan@cloudflare.com>, linux-xfs@vger.kernel.org, Shawn Bohrer <sbohrer@cloudflare.com>

On Tue, Dec 25, 2018 at 07:16:25PM -0800, Kenton Varda wrote:
> On Tue, Dec 25, 2018 at 3:47 PM Dave Chinner <david@fromorbit.com> wrote:
> > But taking out your frustrations on the people who are trying to fix
> > the problems you are seeing isn't productive. We are only a small
> > team and we can't fix every problem that everyone reports
> > immediately. Some things take time to fix.
> 
> I agree. My hope is that explaining our use case helps you make XFS
> better, but you don't owe us anything. It's our problem to solve and
> any help you give us is a favor.
> 
> > IOWs, there are relatively few applications that have such a
> > significant dependency on memory reclaim having extremely low
> > latency,
> 
> Hmm, I'm confused by this. Isn't low-latency memory allocation is a
> common requirement for any kind of interactive workload?

"interactive" tends to mean "human does not see noticable
delays" which means acceptible latency for an operation is measured
in hundreds of milliseconds, not microseconds.

And it's relatively rare for interactive users to have heavily
overloaded IO subsystems such that a single IO takes more than a
couple of hundred milliseconds, let alone have enough memory demand
and concurrent memory reclaim IO that direct reclaim backs up for
seconds on it.

> I don't see
> what's unique about our use case in this respect. Any desktop and most
> web servers I would think have similar requirements.

Interactive latency deficiencies are almost always caused by "need
to get something off disk", not memory reclaim.  And even when it is
caused by "memory reclaim needs to write something", that tends to
mean the "get something from disk" latency is even higher and more
noticable....

> I'm sure there's something about our use case that's unusual, but it
> doesn't seem to me that requiring low-latency memory allocation is
> unique.
>
> Maybe the real thing that's odd about us is that we constantly create
> and delete files at a high rate, and that means we have an excessive
> number of dirty inodes to flush?

Most likely. It is unusual to combine a huge amount of clean page
cache with an inode cache that has really only has dirty reclaimable
inodes in it. It basically implies the common way inodes age out of
the in-memory cache is by being unlinked, not by having their page
cache fully reclaimed by memory pressure...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
