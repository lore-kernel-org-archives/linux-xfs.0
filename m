Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail02.adl2.internode.on.net ([150.101.137.139]:7720 "EHLO
        ipmail02.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726729AbeKCIf2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 3 Nov 2018 04:35:28 -0400
Date: Sat, 3 Nov 2018 10:26:13 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 3/7] cache: prevent expansion races
Message-ID: <20181102232613.GG19305@dastard>
References: <20181030112043.6034-1-david@fromorbit.com>
 <20181030112043.6034-4-david@fromorbit.com>
 <20181031171302.GA16769@bfoster>
 <20181101012739.GY19305@dastard>
 <20181101131732.GB21654@bfoster>
 <20181101212344.GZ19305@dastard>
 <20181102113138.GA6794@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181102113138.GA6794@bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Fri, Nov 02, 2018 at 07:31:38AM -0400, Brian Foster wrote:
> Fair enough, but I'm still curious if doing something like changing the
> hash trylock in the shaker to a blocking lock would improve shaker
> effectiveness enough to avoid the need for the time-based hackery. It's
> possible it has no effect or just replaces one problem with a set of
> others, but it's an even more trivial change than this patch is.
> 
> Another approach may be to lift the cache shaker from a per-lookup-miss
> execution context to something more central (like its own thread(s))
> such that lookups can block on (bounded) shakes without introducing too
> much concurrency therein. That is certainly more involved than bolting a
> throttle onto cache expansion and may not be worth the effort if the
> long term plan is to replace the whole cache mechanism.

I'm more inclined to kill the entire libxfs buffer cache
implementation and MRUs and port the kernel code across with it's
reference based LRU and shrinker. And with that, use AIO so that we
don't need huge numbers of prefetch threads to keep IO in flight.

Getting rid of the repair prefetcher threads removes the major
concurrency component that is placed on the cache. Using the kernel
infrastrucutre also moves from a global cache to a per-ag cache
which matches how xfs_repair operates and hence further reduces lock
contention. i.e. it allows threads working within an AG to work
without interfence from other AGs.

Basically, we are hitting on the scalability limits of the libxfs
architecture right now, and we have an architecure in the kernel
that scales way beyond what we have in userspace. And it fits right
in with the way userspace algorithms operate.

Add to that the need for AIO and delwri lists to scale mkfs to
really large filesystems, and it really comes down to "we need to
port the kernel code and move to AIO" rather than tinker around the
edges with an architecture that we can't easily scale further that
it current does...

Cheers,

Dave
-- 
Dave Chinner
david@fromorbit.com
