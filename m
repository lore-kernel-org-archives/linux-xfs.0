Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:50488 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752855AbeCOXE4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 15 Mar 2018 19:04:56 -0400
Date: Fri, 16 Mar 2018 10:03:13 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH RFC] xfs, memcg: Call xfs_fs_nr_cached_objects() only in
 case of global reclaim
Message-ID: <20180315230313.GM18129@dastard>
References: <152112607662.7371.16175767692798928059.stgit@localhost.localdomain>
 <20180315174903.GM23100@dhcp22.suse.cz>
 <c6a9bf24-50e6-8e60-94af-28e99c51f516@virtuozzo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c6a9bf24-50e6-8e60-94af-28e99c51f516@virtuozzo.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Kirill Tkhai <ktkhai@virtuozzo.com>
Cc: Michal Hocko <mhocko@kernel.org>, darrick.wong@oracle.com, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, akpm@linux-foundation.org

On Thu, Mar 15, 2018 at 10:28:43PM +0300, Kirill Tkhai wrote:
> On 15.03.2018 20:49, Michal Hocko wrote:
> > On Thu 15-03-18 18:01:34, Kirill Tkhai wrote:
> >> xfs_reclaim_inodes_count(XFS_M(sb)) does not care about memcg.
> >> So, it's called for memcg reclaim too, e.g. this list is shrinked
> >> disproportionality to another lists.
> >>
> >> This looks confusing, so I'm reporting about this.
> >> Consider this patch as RFC.
> > 
> > Could you be more specific about the problem you are trying to solve?
> > Because we do skip shrinkers which are not memcg aware by
> > shrink_slab:
> > 		/*
> > 		 * If kernel memory accounting is disabled, we ignore
> > 		 * SHRINKER_MEMCG_AWARE flag and call all shrinkers
> > 		 * passing NULL for memcg.
> > 		 */
> > 		if (memcg_kmem_enabled() &&
> > 		    !!memcg != !!(shrinker->flags & SHRINKER_MEMCG_AWARE))
> > 			continue;
> > 
> > Or am I missing something?
> 
> sb->s_op->nr_cached_objects is a sub-method of generic super_cache_count().
> super_cache_count() is owned and only called by superblock's shrinker,
> which does have SHRINKER_MEMCG_AWARE flag.

Xfs inodes are accounted to memcgs when they are allocated.  All the
memcg reclaim stuff is done at the VFS inode cache level - all the
XFS inode cache shrinker does is clean up inodes that are not
referenced by the VFS inode cache because the memcg aware reclaim
has already freed them.

i.e. what the XFS inode cache is doing is perfectly reasonable -
memcg aware inode reclaim is occuring at the VFS level, but on XFS
that does not free the inodes as they are still referenced
internally by XFS. However, once the inode is removed from the VFS
LRU, all memcg information about the inode is destroyed, so there's
nothing in the XFS layers that cares about memcgs.

Hence when the XFS inode shrinker then called to run a
garbage collection pass on unreferenced inodes - the inodes that
are now unreferenced in the memcg due to the VFS inode shrinker pass
- it frees inodes regardless of the memcg context it was called from
because that information is no longer present in the inode cache.
Hence we just ignore memcgs at this level.

So, is there a problem you are actually trying to fix, or is this
simply a "I don't understand how the superblock shrinkers work,
please explain" patch?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
