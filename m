Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:36086 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389372AbfHBX3a (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 2 Aug 2019 19:29:30 -0400
Date: Sat, 3 Aug 2019 09:28:14 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 09/24] xfs: don't allow log IO to be throttled
Message-ID: <20190802232814.GP7777@dread.disaster.area>
References: <20190801021752.4986-1-david@fromorbit.com>
 <20190801021752.4986-10-david@fromorbit.com>
 <F1E7CC65-D2CB-4078-9AA3-9D172ECDE17B@fb.com>
 <20190801235849.GO7777@dread.disaster.area>
 <7093F5C3-53D2-4C49-9C0D-64B20C565D18@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7093F5C3-53D2-4C49-9C0D-64B20C565D18@fb.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Chris Mason <clm@fb.com>
Cc: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>

On Fri, Aug 02, 2019 at 02:11:53PM +0000, Chris Mason wrote:
> On 1 Aug 2019, at 19:58, Dave Chinner wrote:
> I can't really see bio->b_ioprio working without the rest of the IO 
> controller logic creating a sensible system,

That's exactly the problem we need to solve. The current situation
is ... untenable. Regardless of whether the io.latency controller
works well, the fact is that the wbt subsystem is active on -all-
configurations and the way it "prioritises" is completely broken.

> framework to define weights etc.  My question is if it's worth trying 
> inside of the wbt code, or if we should just let the metadata go 
> through.

As I said, that doesn't  solve the problem. We /want/ critical
journal IO to have higher priority that background metadata
writeback. Just ignoring REQ_META doesn't help us there - it just
moves the priority inversion to blocking on request queue tags.

> Tejun reminded me that in a lot of ways, swap is user IO and it's 
> actually fine to have it prioritized at the same level as user IO.  We 

I think that's wrong. Swap *in* could have user priority but swap
*out* is global as there is no guarantee that the page being swapped
belongs to the user context that is reclaiming memory.

Lots of other user and kernel reclaim contexts may be waiting on
that swap to complete, so it's important that swap out is not
arbitrarily delayed or susceptible to priority inversions. i.e. swap
out must take priority over swap-in and other user IO because that
IO may require allocation to make progress via swapping to free
"user" file data cached in memory....

> don't want to let a low prio app thrash the drive swapping things in and 
> out all the time,

Low priority apps will be throttled on *swap in* IO - i.e. by their
incoming memory demand. High priority apps should be swapping out
low priority app memory if there are shortages - that's what priority
defines....

> other higher priority processes aren't waiting for the memory.  This 
> depends on the cgroup config, so wrt your current patches it probably 
> sounds crazy, but we have a lot of data around this from the fleet.

I'm not using cgroups.

Core infrastructure needs to work without cgroups being configured
to confine everything in userspace to "safe" bounds, and right now
just running things in the root cgroup doesn't appear to work very
well at all.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
