Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:17651 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751548AbeCVXq7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 22 Mar 2018 19:46:59 -0400
Date: Fri, 23 Mar 2018 10:46:13 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH RFC] xfs, memcg: Call xfs_fs_nr_cached_objects() only in
 case of global reclaim
Message-ID: <20180322234613.GD18129@dastard>
References: <20180315230313.GM18129@dastard>
 <6628c551-f607-367b-1ee6-f458266c1d92@virtuozzo.com>
 <20180316213910.GF7000@dastard>
 <18a031f3-2136-4ef9-6ede-05f5b835661c@virtuozzo.com>
 <20180320001827.GB1150@dastard>
 <ec116ce6-c22b-66e1-0e01-55f895997c7d@virtuozzo.com>
 <20180320143452.GT18129@dastard>
 <5eb88165-c108-5989-3cb5-1f260cec5e53@virtuozzo.com>
 <20180322050152.GA18129@dastard>
 <3320c962-35c5-c5ed-2a9f-0acb2b875579@virtuozzo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3320c962-35c5-c5ed-2a9f-0acb2b875579@virtuozzo.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Kirill Tkhai <ktkhai@virtuozzo.com>
Cc: Michal Hocko <mhocko@kernel.org>, darrick.wong@oracle.com, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, akpm@linux-foundation.org

On Thu, Mar 22, 2018 at 07:52:37PM +0300, Kirill Tkhai wrote:
> Here is the problem I'm solving: https://lkml.org/lkml/2018/3/21/365.

Oh, finally you tell me what the problem is that you're trying to
solve. I *asked this several times* and got no response. Thank you
for wasting so much of my time.

> Current shrinker is not scalable. Then there are many memcg and mounts,
> the time of iteration shrink_slab() in case of global reclaim can
> take much time. There is times of shrink_slab() by the link. A node
> with 200 containers may waste 4 seconds on global reclaim just to
> iterate over all shrinkers for all cgroups, call shrinker::count_objects()
> and receive 0 zero objects.

So, your problem is the way the memcgs were tacked onto the side
of the list_lru infrastructure and are iterated, which has basically
nothing to do with the way the low level XFS inode shrinker behaves.

/me looks at the patches

/me shudders at the thought of external "cache has freeable items"
control for the shrinking of vfs caches.

Biggest problem I see with this is the scope for coherency bugs ini
the "memcg shrinker has freeable items" tracking. If that happens,
there's no way of getting that memcg to run it's shrinker ever
again. That seems very, very fragile and likely to be an endless
source of OOM bugs. The whole point of the shrinker polling
infrastructure is that it is not susceptible to this sort of bug.

Really, the problem is that there's no separate list of memcg aware
shrinkers, so every registered shrinker has to be iterated just to
find the one shrinker that is memcg aware.

So why not just do the simple thing which is create a separate
"memcg-aware" shrinker list (i.e. create shrinker_list_memcg
alongside shrinker_list) and only iterate the shrinker_list_memcg
when a memcg is passed to shrink_slab()?

That means we'll only run 2 shrinkers per memcg at most (sueprblock
and working set) per memcg reclaim call. That's a simple 10-20 line
change, not a whole mess of new code and issues...

> Can't we call shrink of shared objects only for top memcg? Something like
> this:

What's a "shared object", and how is it any different to a normal
slab cache object?

CHeers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
