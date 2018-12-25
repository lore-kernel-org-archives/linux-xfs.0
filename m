Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:23727 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729585AbeLYXrh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Dec 2018 18:47:37 -0500
Date: Wed, 26 Dec 2018 10:47:32 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Non-blocking socket stuck for multiple seconds on
 xfs_reclaim_inodes_ag()
Message-ID: <20181225234732.GH4205@dastard>
References: <CABWYdi1YZp+baxpON2R6mP09pjkUz5D-OE7Z2KmwVGycYTN-AA@mail.gmail.com>
 <20181129021800.GQ6311@dastard>
 <CABWYdi0Bd6sMAaTPkfHKupMGpw1QPSf_VohPF_Wg7Mm=W=j2bA@mail.gmail.com>
 <20181130021840.GV6311@dastard>
 <CABWYdi0nSJAV-RPdUSwGbRwqeoKo-83_X=ptuQwwH1CnPXCYmQ@mail.gmail.com>
 <20181130064908.GX6311@dastard>
 <20181130074547.GY6311@dastard>
 <CABWYdi28ifToh-yWRAv4MSdJ9g6t-Rxyz2GAFXGFraCwf9BBDg@mail.gmail.com>
 <CAJouXQn2mSyyacnf_CnrhX-JQ1x2QOUoB3=bzsSfbHFfAdRc9Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJouXQn2mSyyacnf_CnrhX-JQ1x2QOUoB3=bzsSfbHFfAdRc9Q@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Kenton Varda <kenton@cloudflare.com>
Cc: Ivan Babrou <ivan@cloudflare.com>, linux-xfs@vger.kernel.org, Shawn Bohrer <sbohrer@cloudflare.com>

Hi Kenton,

On Thu, Dec 20, 2018 at 08:00:21PM -0800, Kenton Varda wrote:
> When XFS blocks direct reclaim, our service pretty much grinds to a
> halt on that machine, because everything is trying to allocate memory
> all the time. For example, as alluded by the subject of this thread,
> writing to a socket allocates memory, and thus will block waiting for
> XFS to write back inodes. What we find really frustrating is that we
> almost always have over 100GB of clean page cache that could be
> reclaimed immediately, without blocking, yet we end up waiting for the
> much-smaller inode cache to be written back to disk.

Sure, it's frustrating. It frsutrates me that I've been trying for
years to get memory reclaim behaviour changed so that we don't have
to do this, but we are still stuck with it.

But taking out your frustrations on the people who are trying to fix
the problems you are seeing isn't productive. We are only a small
team and we can't fix every problem that everyone reports
immediately. Some things take time to fix.

> We really can't accept random multi-second pauses.

And that's the problem here. For the vast majority of XFS users, the
alternative (i.e. not blocking reclaim) leads to substantially lower
performance and the high risk of premature OOM kills. It basically
moves the reclaim blocking problem to a different context (i.e. to
journal space allocation) and that has even worse latency and has
global filesystem scope rather than just the process doing reclaim.

IOWs, there are relatively few applications that have such a
significant dependency on memory reclaim having extremely low
latency, but there are a lot that are dependent on memory reclaim
being throttled harshly to keep the filesystem out of even worse
breakdown conditions.....

> Our current plan is
> to roll out the patch Ivan linked to.

Which is perfectly fine by me. I read the link, and it looks like it
works just fine in your environment. In contrast, I ran the same
patch on my performance bencmarks and saw between 15-30%
degradation in performance on my inode cache heavy and mixed
inode/page cache heavy memory pressure benchmarks. IOWs, that change
still doesn't work for XFS in general.

This is the beauty of open source software - you can make tweaks to
it to refine it for your specific workloads easily when such changes
aren't really suitable for the wider user base.  I encourage people
to make tweaks like this to optimise your systems for your workload.

However, I also encourage people then to discuss the problems that
lead to needing such tweaks with upstream so we are aware of the
issues and can work towards either incorporating them or modifying
infrastructure to avoid them altogether. Further, there's no need to
be combative or get upset when upstream determines that the tweak
isn't generally applicable or is hiding something deeper that needs
fixing.

All it means is that the upstream developers know there is a deeper
underlying problem and want to fix the underlying problem rather
than try to hide the problem for a specific workload.  The fact we
know there's a problem (and it's not just one workload situation
that it affects) helps us prioritise what we need to fix.

> But, if you have any other
> suggestions, we'd love to hear them. It would be great if we could
> agree on an upstream solution, and maybe solve Facebook's problem too.

I've already mentioned the things we are working on to Shaun to keep
the ball rolling on this. e.g. Darrick's pipelined background inode
inactivation work:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git/commit/?h=djwong-wtf&id=85baea68d8e87803e6831bda7b5a3773cf0d8820

i.e. as I indicated above, inode reclaim can block on lots more
things that just inode writeback. We can do transactions in inode
reclaim, so we can block on log space and that might require
*thousands* of IO to be completed before it can make progress. The
async kswapd mod doesn't address this problem at all because
inactivation occurs in the prune_icache() VFS shrinker context (i.e.
->destroy_inode()) rather than the XFS inode cache context that the
FB and CF patches address.

Also, the upcoming inode cache xarray conversion will provide us
with many more per-inode state tags in the xarray that will allow us
to track and execute multiple different post-VFS reclaim inode
states directly.  This will allow us to efficiently separate inodes
that need transactions and/or IO to be reclaimed from inodes that
can be reclaimed immediately, and it will allow efficient concurrent
async processing of inodes that need IO to be reclaimed.

IOWs, we're trying to solve *all* the blocking problems that we know
that can occur in inode reclaim so that it all just works for
everyone without tweaks being necessary. Yes, this takes longer than
just addressing the specific symptom that is causing you problems,
but the reality is while fixing things properly takes time to get
right, everyone will benefit from it being fixed and not just one or
two very specific, latency sensitive workloads.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
