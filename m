Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:21395 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751948AbeCVFCa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 22 Mar 2018 01:02:30 -0400
Date: Thu, 22 Mar 2018 16:01:52 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH RFC] xfs, memcg: Call xfs_fs_nr_cached_objects() only in
 case of global reclaim
Message-ID: <20180322050152.GA18129@dastard>
References: <20180315174903.GM23100@dhcp22.suse.cz>
 <c6a9bf24-50e6-8e60-94af-28e99c51f516@virtuozzo.com>
 <20180315230313.GM18129@dastard>
 <6628c551-f607-367b-1ee6-f458266c1d92@virtuozzo.com>
 <20180316213910.GF7000@dastard>
 <18a031f3-2136-4ef9-6ede-05f5b835661c@virtuozzo.com>
 <20180320001827.GB1150@dastard>
 <ec116ce6-c22b-66e1-0e01-55f895997c7d@virtuozzo.com>
 <20180320143452.GT18129@dastard>
 <5eb88165-c108-5989-3cb5-1f260cec5e53@virtuozzo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5eb88165-c108-5989-3cb5-1f260cec5e53@virtuozzo.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Kirill Tkhai <ktkhai@virtuozzo.com>
Cc: Michal Hocko <mhocko@kernel.org>, darrick.wong@oracle.com, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, akpm@linux-foundation.org

On Wed, Mar 21, 2018 at 07:15:14PM +0300, Kirill Tkhai wrote:
> On 20.03.2018 17:34, Dave Chinner wrote:
> > On Tue, Mar 20, 2018 at 04:15:16PM +0300, Kirill Tkhai wrote:
> >> On 20.03.2018 03:18, Dave Chinner wrote:
> >>> On Mon, Mar 19, 2018 at 02:06:01PM +0300, Kirill Tkhai wrote:
> >>>> On 17.03.2018 00:39, Dave Chinner wrote:
> >>> Actually, it is fair, because:
> >>>
> >>>         /* proportion the scan between the caches */
> >>>         dentries = mult_frac(sc->nr_to_scan, dentries, total_objects);
> >>>         inodes = mult_frac(sc->nr_to_scan, inodes, total_objects);
> >>>         fs_objects = mult_frac(sc->nr_to_scan, fs_objects, total_objects);
> >>>
> >>> This means that if the number of objects in the memcg aware VFS
> >>> caches are tiny compared to the global XFS inode cache, then they
> >>> only get a tiny amount of the total scanning done by the shrinker.
> >>
> >> This is just wrong. If you have two memcgs, the first is charged
> >> by xfs dentries and inodes, while the second is not charged by xfs
> >> dentries and inodes, the second will response for xfs shrink as well
> >> as the first.
> > 
> > That makes no sense to me. Shrinkers are per-sb, so they only
> > shrink per-filesystem dentries and inodes. If your memcgs are on
> > different filesystems, then they'll behave according to the size of
> > that filesystem's caches, not the cache of some other filesystem.
> 
> But this break the isolation purpose of memcg. When someone places
> different services in different pairs of memcg and cpu cgroup, he
> wants do not do foreign work.

Too bad. Filesystems *break memcg isolation all the time*.

Think about it. The filesystem journal is owned by the filesystem,
not the memcg that is writing a transaction to it.  If one memcg
does lots of metadata modifications, it can use all the journal
space and starve iitself and all other memcgs of journal space while
the filesystem does writeback to clear it out.

Another example: if one memcg is manipulating free space in a
particular allocation group, other memcgs that need to manipulate
space in those allocation groups will block and be prevented from
operating until the other memcg finishes it's work.

Another example: inode IO in XFS are done in clusters of 32. read or
write any inode in the cluster, and we read/write all the other
inodes in that cluster, too. Hence if we need to read an inode and
the cluster is busy because the filesystem journal needed flushing
or another inode in the cluster is being unlinked (e.g. by a process
in a different memcg), then the read in the first memcg will block
until whatever is being done on the buffer is complete. IOWs, even
at the physical on-disk inode level we violate memcg resource 
isolation principles.

I can go on, but I think you get the picture: Filesystems are full
of global structures whose access arbitration mechanisms
fundamentally break the concept of operational memcg isolation.

With that in mind, we really don't care that the shrinker does
global work and violate memcg isolation principles because we
violately them everywhere. IOWs, if we try to enforce memcg
isolation in the shrinker, then we can't guarantee forwards progress
in memory reclaim because we end up with multi-dimensional memcg
dependencies at the physical layers of the filesystem structure....

I don't expect people who know nothing about XFS or filesystems to
understand the complexity of the interactions we are dealing with
here. Everything is a compromise when it comes to the memory reclaim
code as tehre are so many corner cases we have to handle. In this
situation, perfect is the enemy of good....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
