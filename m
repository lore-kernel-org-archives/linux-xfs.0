Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail02.adl2.internode.on.net ([150.101.137.139]:24571 "EHLO
        ipmail02.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751521AbeCTOe4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 20 Mar 2018 10:34:56 -0400
Date: Wed, 21 Mar 2018 01:34:52 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH RFC] xfs, memcg: Call xfs_fs_nr_cached_objects() only in
 case of global reclaim
Message-ID: <20180320143452.GT18129@dastard>
References: <152112607662.7371.16175767692798928059.stgit@localhost.localdomain>
 <20180315174903.GM23100@dhcp22.suse.cz>
 <c6a9bf24-50e6-8e60-94af-28e99c51f516@virtuozzo.com>
 <20180315230313.GM18129@dastard>
 <6628c551-f607-367b-1ee6-f458266c1d92@virtuozzo.com>
 <20180316213910.GF7000@dastard>
 <18a031f3-2136-4ef9-6ede-05f5b835661c@virtuozzo.com>
 <20180320001827.GB1150@dastard>
 <ec116ce6-c22b-66e1-0e01-55f895997c7d@virtuozzo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ec116ce6-c22b-66e1-0e01-55f895997c7d@virtuozzo.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Kirill Tkhai <ktkhai@virtuozzo.com>
Cc: Michal Hocko <mhocko@kernel.org>, darrick.wong@oracle.com, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, akpm@linux-foundation.org

On Tue, Mar 20, 2018 at 04:15:16PM +0300, Kirill Tkhai wrote:
> On 20.03.2018 03:18, Dave Chinner wrote:
> > On Mon, Mar 19, 2018 at 02:06:01PM +0300, Kirill Tkhai wrote:
> >> On 17.03.2018 00:39, Dave Chinner wrote:
> > Actually, it is fair, because:
> > 
> >         /* proportion the scan between the caches */
> >         dentries = mult_frac(sc->nr_to_scan, dentries, total_objects);
> >         inodes = mult_frac(sc->nr_to_scan, inodes, total_objects);
> >         fs_objects = mult_frac(sc->nr_to_scan, fs_objects, total_objects);
> > 
> > This means that if the number of objects in the memcg aware VFS
> > caches are tiny compared to the global XFS inode cache, then they
> > only get a tiny amount of the total scanning done by the shrinker.
> 
> This is just wrong. If you have two memcgs, the first is charged
> by xfs dentries and inodes, while the second is not charged by xfs
> dentries and inodes, the second will response for xfs shrink as well
> as the first.

That makes no sense to me. Shrinkers are per-sb, so they only
shrink per-filesystem dentries and inodes. If your memcgs are on
different filesystems, then they'll behave according to the size of
that filesystem's caches, not the cache of some other filesystem.

> When we call shrink xfs partition of the second memcg, total_objects
> in super_cache_count() will consist only of cached objects.
> 
> Then, we will call super_cache_scan() in the loop, and 
> 
> total_objects = dentries + inodes + fs_objects + 1 = fs_objects
> s_objects = mult_frac(sc->nr_to_scan, fs_objects, total_objects) ~ almost equal to sc->nr_to_scan.
> 
> So, if the first memcg is huge and it's charged 10GB to cached objects,
> the second memcg will shrink signify part of this objects (depending
> on do_shrink_slab() priority) in case of reclaim coming.

Do we really care which memcg does the global reclaim work as long
as it all gets done in a timely manner? The fact is that when there
is global memory pressure, shrinkers from every memcg will be doing
work all the time and so it really does not matter which shrinker
context does what work. In such cases, memory reclaim is all about
bulk throughput, and we trade of instantenous fairness for overall
fairness and higher bulk throughput.

And, well, the bulk of XFS inode reclaim is not done by the shrinker
contexts - memcg or otherwise - it's done by an asycnhronous,
non-blocking per-filesystem background work which is kicked by a
shrinker scan being run on that filesystem . The only reason we keep
the shrinkers doing direct work is to throttle direct reclaim to the
overall background inode reclaim rate. It's hardly fair for the
filesystem to automatically do the work the memcg should be doing
and doing it faster than the memcg reclaim can do it, is it?

FWIW, inodes are RCU objects, so they aren't freed until RCU grace
periods expire and that means memcg reclaim does not actually free
inodes immediately. They are always delayed to some time after the
memcg shrinker has run and reported it freed those objects.  IOWs,
it really doesn't matter which memcg context does the "freeing"
work, because the freeing of inode memory in any given memcg
actually occurs some time later from callbacks run in a global,
non-memcg aware context....

> > And because all of the memcg shrinkers walk the global inode cache,
> > the overall scanning is shared between all memcgs under memory
> > pressure evenly and so none are unfairly penalised by having to
> > scan the global inode cache to trigger final garbage collection.
> 
> So, if there is single memcg using xfs, the rest of system is
> responsible for its shrinking. Completely unfair.

If there is only one memcg that is generating internal memory
pressure, then only that memcg will be running the shrinker and
reclaiming dentries, inodes and XFS inodes from that memcg. Nothing
else will be running reclaim and hence only the memcg shrinker will
be doing reclaim work. I don't see where you get the "rest of the
system is responsible for it's shrinking" from - that just isn't the
way the shrinker infrastructure works, regardless of whether XFS is
involved or not.

> Isn't this easy to understand?

First rule of shrinkers: Shrinkers *aren't easy to understand.*
Second rule of shrinkers: See the first rule.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
