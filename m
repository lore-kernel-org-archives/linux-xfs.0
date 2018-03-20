Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:4567 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S934168AbeCTASb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 19 Mar 2018 20:18:31 -0400
Date: Tue, 20 Mar 2018 11:18:27 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH RFC] xfs, memcg: Call xfs_fs_nr_cached_objects() only in
 case of global reclaim
Message-ID: <20180320001827.GB1150@dastard>
References: <152112607662.7371.16175767692798928059.stgit@localhost.localdomain>
 <20180315174903.GM23100@dhcp22.suse.cz>
 <c6a9bf24-50e6-8e60-94af-28e99c51f516@virtuozzo.com>
 <20180315230313.GM18129@dastard>
 <6628c551-f607-367b-1ee6-f458266c1d92@virtuozzo.com>
 <20180316213910.GF7000@dastard>
 <18a031f3-2136-4ef9-6ede-05f5b835661c@virtuozzo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18a031f3-2136-4ef9-6ede-05f5b835661c@virtuozzo.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Kirill Tkhai <ktkhai@virtuozzo.com>
Cc: Michal Hocko <mhocko@kernel.org>, darrick.wong@oracle.com, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, akpm@linux-foundation.org

On Mon, Mar 19, 2018 at 02:06:01PM +0300, Kirill Tkhai wrote:
> On 17.03.2018 00:39, Dave Chinner wrote:
> > On Fri, Mar 16, 2018 at 11:55:30AM +0300, Kirill Tkhai wrote:
> >> On 16.03.2018 02:03, Dave Chinner wrote:
> >>> On Thu, Mar 15, 2018 at 10:28:43PM +0300, Kirill Tkhai wrote:
> >>>> On 15.03.2018 20:49, Michal Hocko wrote:
> >>>>> On Thu 15-03-18 18:01:34, Kirill Tkhai wrote:
> >>>>>> xfs_reclaim_inodes_count(XFS_M(sb)) does not care about memcg.
> >>>>>> So, it's called for memcg reclaim too, e.g. this list is shrinked
> >>>>>> disproportionality to another lists.
> >>>>>>
> >>>>>> This looks confusing, so I'm reporting about this.
> >>>>>> Consider this patch as RFC.
> >>>>>
> >>>>> Could you be more specific about the problem you are trying to solve?
> >>>>> Because we do skip shrinkers which are not memcg aware by
> >>>>> shrink_slab:
> >>>>> 		/*
> >>>>> 		 * If kernel memory accounting is disabled, we ignore
> >>>>> 		 * SHRINKER_MEMCG_AWARE flag and call all shrinkers
> >>>>> 		 * passing NULL for memcg.
> >>>>> 		 */
> >>>>> 		if (memcg_kmem_enabled() &&
> >>>>> 		    !!memcg != !!(shrinker->flags & SHRINKER_MEMCG_AWARE))
> >>>>> 			continue;
> >>>>>
> >>>>> Or am I missing something?
> >>>>
> >>>> sb->s_op->nr_cached_objects is a sub-method of generic super_cache_count().
> >>>> super_cache_count() is owned and only called by superblock's shrinker,
> >>>> which does have SHRINKER_MEMCG_AWARE flag.
> >>>
> >>> Xfs inodes are accounted to memcgs when they are allocated.  All the
> >>> memcg reclaim stuff is done at the VFS inode cache level - all the
> >>> XFS inode cache shrinker does is clean up inodes that are not
> >>> referenced by the VFS inode cache because the memcg aware reclaim
> >>> has already freed them.
> >>>
> >>> i.e. what the XFS inode cache is doing is perfectly reasonable -
> >>> memcg aware inode reclaim is occuring at the VFS level, but on XFS
> >>> that does not free the inodes as they are still referenced
> >>> internally by XFS. However, once the inode is removed from the VFS
> >>> LRU, all memcg information about the inode is destroyed, so there's
> >>> nothing in the XFS layers that cares about memcgs.
> >>
> >> So, after inode is removed from LRU, memory still remains accounted
> >> to memcg till the time they are actually freed. I personally don't
> >> care, just to mention.
> >>  
> >>> Hence when the XFS inode shrinker then called to run a
> >>> garbage collection pass on unreferenced inodes - the inodes that
> >>> are now unreferenced in the memcg due to the VFS inode shrinker pass
> >>> - it frees inodes regardless of the memcg context it was called from
> >>> because that information is no longer present in the inode cache.
> >>> Hence we just ignore memcgs at this level.
> >>
> >> But xfs_fs_free_cached_objects() returns number of these freed object
> >> as result to super_cache_scan(), so shrinker interprets them as related
> >> to a memcg, while they may be related to another memcg. This introduces
> >> a disproportion relatively to another shrinkers called to memcg.
> > 
> > In what way? All memcgs see tha same values from the backing cache
> > and so try to do the same amount of scanning work. The shrinker
> > accounting simply doesn't care where the objects are scanned from,
> > as long as it comes from the same place as the calculation of the
> > number of objects in the cache it's about to scan.
> 
> shrinker->count_objects() result is used to count number of objects,
> do_shrink_slab() should shrink during the call:
> 
>         freeable = shrinker->count_objects(shrinker, shrinkctl);
> 
> Then shrinker takes part of this value:
> 
>         delta = freeable >> priority;
>         delta *= 4;
>         do_div(delta, shrinker->seeks);
> 
> This is a number, the shrinker tries to shrink during the call.
> Let the priority is DEF_PRIORITY. Then, shrinker try to shrink
> freeable*4/(shrinker->seeks * 2^DEF_PRIORITY) enteties from every
> shrinker. Equal percent of every memcg shrinker.
> 
> When XFS shows global number of cached objects in count_objects(),
> shrinker also tryes to shrink the same percent of global objects,
> as for other memcg shrinkers. So, when you have small memcg
> with 128Mb memory allowed and small number of tasks related to it,
> you may meet 1Gb of cached objects, which were queued by another
> big cgroup. So, the small cgroup may shrink number of objects of
> size more, then its own. It's not fair. That's all I'm worry in
> this message.

Actually, it is fair, because:

        /* proportion the scan between the caches */
        dentries = mult_frac(sc->nr_to_scan, dentries, total_objects);
        inodes = mult_frac(sc->nr_to_scan, inodes, total_objects);
        fs_objects = mult_frac(sc->nr_to_scan, fs_objects, total_objects);

This means that if the number of objects in the memcg aware VFS
caches are tiny compared to the global XFS inode cache, then they
only get a tiny amount of the total scanning done by the shrinker.

And because all of the memcg shrinkers walk the global inode cache,
the overall scanning is shared between all memcgs under memory
pressure evenly and so none are unfairly penalised by having to
scan the global inode cache to trigger final garbage collection.

If you just look at a single memcg and shrinker in isolation, then
you are missing the forest for the trees...

> > You've described some theoretical issue, but not described any user
> > visible or performance impacting behaviour that users actually care
> > about. What reproducable, observable behaviour does it fix/change?
> 
> Strange question. Do you fix problems only when you meet a reproducable
> BUG()? This is the kernel, and many problem may be racy. But this
> does not mean, it's prohibited to discuss about them.

That's a bit extreme.

I expect people who are trying to fix bugs in complex subsystems
to be able to explain what the bug is they are fixing, what impact
it has and how they observed/measured the impact. Especially for
somethign as critical as shrinker infrastructure - if we screw up the
calculations we'll break systems everywhere and when we have to fix
those bugs we need to know why those changes were made. That means
the reasons for making the change (i.e. what problem was being
fixed) needs to be documented in the commit message.

> >>> So, is there a problem you are actually trying to fix, or is this
> >>> simply a "I don't understand how the superblock shrinkers work,
> >>> please explain" patch?
> >>
> >> I work on some shrinker changes, and just want to understand they don't
> >> touch anything. 
> > 
> > Oh, goody, another person about to learn the hard way that shrinkers
> > are far more varied and complex than page reclaim :P
> 
> It may be a surprise, but I have to say, that all memcg-aware shrinkers
> are based on list_lrus. XFS is exception. So, your words are not about
> shrinkers in general, just about XFS.

Speaking as the original author of the list_lru infrastructure for
shrinkers, you've got that all back to front. The list_lru was
developed specifically for XFS scalibilty and performance reasons
i.e. SHRINKER_NUMA_AWARE.

The memcg stuff was tacked onto the side of the list-lrus later on
as it was a convenient abstraction to hide the bogosities of memcg
accounting and reclaim from the rest of the mm subsystem.  IOWs, the
memcg infrastructure is the exception case here, not XFS....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
