Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61A0BC433FE
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Jan 2022 22:18:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239970AbiA0WSW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 27 Jan 2022 17:18:22 -0500
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:56615 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236410AbiA0WSW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Jan 2022 17:18:22 -0500
Received: from dread.disaster.area (pa49-179-45-11.pa.nsw.optusnet.com.au [49.179.45.11])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 3F7C862D0BF;
        Fri, 28 Jan 2022 09:18:18 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nDD5t-004zNk-DL; Fri, 28 Jan 2022 09:18:17 +1100
Date:   Fri, 28 Jan 2022 09:18:17 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     Al Viro <viro@zeniv.linux.org.uk>, linux-xfs@vger.kernel.org,
        Ian Kent <raven@themaw.net>, rcu@vger.kernel.org
Subject: Re: [PATCH] xfs: require an rcu grace period before inode recycle
Message-ID: <20220127221817.GS59729@dread.disaster.area>
References: <20220121142454.1994916-1-bfoster@redhat.com>
 <Ye6/g+XMSyp9vYvY@bfoster>
 <20220124220853.GN59729@dread.disaster.area>
 <Ye82TgBY0VmtTjMc@bfoster>
 <20220125003120.GO59729@dread.disaster.area>
 <YfBBzHascwVnefYY@bfoster>
 <20220125224551.GQ59729@dread.disaster.area>
 <YfIdVq6R6xEWxy0K@zeniv-ca.linux.org.uk>
 <20220127052609.GR59729@dread.disaster.area>
 <YfLsBdPBSsyPFgHJ@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YfLsBdPBSsyPFgHJ@bfoster>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=VuxAv86n c=1 sm=1 tr=0 ts=61f31a2c
        a=Eslsx4mF8WGvnV49LKizaA==:117 a=Eslsx4mF8WGvnV49LKizaA==:17
        a=kj9zAlcOel0A:10 a=DghFqjY3_ZEA:10 a=7-415B0cAAAA:8
        a=mrosdXFn7jjNGUWx4wEA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jan 27, 2022 at 02:01:25PM -0500, Brian Foster wrote:
> On Thu, Jan 27, 2022 at 04:26:09PM +1100, Dave Chinner wrote:
> > On Thu, Jan 27, 2022 at 04:19:34AM +0000, Al Viro wrote:
> > > On Wed, Jan 26, 2022 at 09:45:51AM +1100, Dave Chinner wrote:
> > > 
> > > > Right, background inactivation does not improve performance - it's
> > > > necessary to get the transactions out of the evict() path. All we
> > > > wanted was to ensure that there were no performance degradations as
> > > > a result of background inactivation, not that it was faster.
> > > > 
> > > > If you want to confirm that there is an increase in cold cache
> > > > access when the batch size is increased, cpu profiles with 'perf
> > > > top'/'perf record/report' and CPU cache performance metric reporting
> > > > via 'perf stat -dddd' are your friend. See elsewhere in the thread
> > > > where I mention those things to Paul.
> > > 
> > > Dave, do you see a plausible way to eventually drop Ian's bandaid?
> > > I'm not asking for that to happen this cycle and for backports Ian's
> > > patch is obviously fine.
> > 
> > Yes, but not in the near term.
> > 
> > > What I really want to avoid is the situation when we are stuck with
> > > keeping that bandaid in fs/namei.c, since all ways to avoid seeing
> > > reused inodes would hurt XFS too badly.  And the benchmarks in this
> > > thread do look like that.
> > 
> > The simplest way I think is to have the XFS inode allocation track
> > "busy inodes" in the same way we track "busy extents". A busy extent
> > is an extent that has been freed by the user, but is not yet marked
> > free in the journal/on disk. If we try to reallocate that busy
> > extent, we either select a different free extent to allocate, or if
> > we can't find any we force the journal to disk, wait for it to
> > complete (hence unbusying the extents) and retry the allocation
> > again.
> > 
> > We can do something similar for inode allocation - it's actually a
> > lockless tag lookup on the radix tree entry for the candidate inode
> > number. If we find the reclaimable radix tree tag set, the we select
> > a different inode. If we can't allocate a new inode, then we kick
> > synchronize_rcu() and retry the allocation, allowing inodes to be
> > recycled this time.
> > 
> 
> I'm starting to poke around this area since it's become clear that the
> currently proposed scheme just involves too much latency (unless Paul
> chimes in with his expedited grace period variant, at which point I will
> revisit) in the fast allocation/recycle path. ISTM so far that a simple
> "skip inodes in the radix tree, sync rcu if unsuccessful" algorithm will
> have pretty much the same pattern of behavior as this patch: one
> synchronize_rcu() per batch.

That's not really what I proposed - what I suggested was that if we
can't allocate a usable inode from the finobt, and we can't allocate
a new inode cluster from the AG (i.e. populate the finobt with more
inodes), only then call synchronise_rcu() and recycle an inode.

We don't need to scan the inode cache or the finobt to determine if
there are reclaimable inodes immediately available - do a gang tag
lookup on the radix tree for newino.
If it comes back with an inode number that is not
equal to the node number we looked up, then we can allocate an
newino immediately.

If it comes back with newino, then check the first inode in the
finobt. If that comes back with an inode that is not the first inode
in the finobt, we can immediately allocate the first inode in the
finobt. If not, check the last inode. if that fails, assume all
inodes in the finobt need recycling and allocate a new cluster,
pointing newino at it.

Then we get another 64 inodes starting at the newino cursor we can
allocate from while we wait for the current RCU grace period to
expire for inodes already in the reclaimable state. An algorithm
like this will allow the free inode pool to resize automatically
based on the unlink frequency of the workload and RCU grace period
latency...

> IOW, background reclaim only kicks in after 30s by default,

5 seconds, by default, not 30s.

> so the pool
> of free inodes pretty much always consists of 100% reclaimable inodes.
> On top of that, at smaller batch sizes, the pool tends to have a uniform
> (!elapsed) grace period cookie, so a stall is required to be able to
> allocate any of them. As the batch size increases, I do see the
> population of free inodes start to contain a mix of expired and
> non-expired grace period cookies. It's fairly easy to hack up an
> internal icwalk scan to locate already expired inodes,

We don't want or need to do exhaustive, exactly correct scans here.
We want *fast and loose* because this is a critical performance fast
path. We don't care if we skip the occasional recyclable inode, what
we need to to is minimise the CPU overhead and search latency for
the case where recycling will never occur.

> but the problem
> is that the recycle rate is so much faster than the grace period latency
> that it doesn't really matter. We'll still have to stall by the time we
> get to the non-expired inodes, and so we're back to one stall per batch
> and the same general performance characteristic of this patch.

Yes, but that's why I suggested that we allocate a new inode cluster
rather than calling synchronise_rcu() when we don't have a
recyclable inode candidate.

> So given all of this, I'm wondering about something like the following
> high level inode allocation algorithm:
> 
> 1. If the AG has any reclaimable inodes, scan for one with an expired
> grace period. If found, target that inode for physical allocation.

How do you efficiently discriminate between "reclaimable w/ nlink >
0" and "reclaimable w/ nlink == 0" so we don't get hung up searching
millions of reclaimable inodes for the one that has been unlinked
and has an expired grace period?

Also, this will need to be done on every inode allocation when we
have inodes in reclaimable state (which is almost always on a busy
system).  Workloads with sequential allocation (as per untar, rsync,
git checkout, cp -r, etc) will do this scan unnecessarily as they
will almost never hit this inode recycle path as there aren't a lot
of unlinks occurring while they are working.

> 2. If the AG free inode count == the AG reclaimable count and we know
> all reclaimable inodes are most likely pending a grace period (because
> the previous step failed), allocate a new inode chunk (and target it in
> this allocation).

That's good for the allocation that allocates the chunk, but...

> 3. If the AG free inode count > the reclaimable count, scan the finobt
> for an inode that is not present in the radix tree (i.e. Dave's logic
> above).

... now we are repeating the radix tree walk that we've already done
in #1 to find the newly allocated inodes we allocated in #2.

We don't need to walk the inodes in the inode radix tree to look at
individual inode state - we can use the reclaimable radix tree tag
to shortcut those walks and minimise the number of actual lookups we
need to do. By definition, and inode in the finobt and
XFS_IRECLAIMABLE state is an inode that needs recycling, so we can
just use the finobt and the inode radix tree tags to avoid inodes
that need recycling altogether.  i.e. If we fail a tag lookup, we
have no reclaimable inodes in the range we asked the lookup to
search so we can immediately allocate - we don't need to actually
need to look at the inode in the fast path no-recycling case at all. 

Keep in mind that the fast path we really care about is not the
unlink/allocate looping case, it's the allocation case where no
recycling will ever occur and so that's the one we really have to
try hard to minimise the overhead for. The moment we get into
reclaimable inodes within the finobt range  we're hitting the "lots
of temp files" use case, so we can detect that and keep the overhead
of that algorithm as separate as we possibly can.

Hence we need the initial "can we allocate this inode number"
decision to be as fast and as low overhead as possible so we can
determine which algorithm we need to run. A lockless radix tree gang
tag lookup will give us that and if the lookup finds a reclaimable
inode only then do we move into the "recycle RCU avoidance"
algorithm path....

> > > Are there any realistic prospects of having xfs_iget() deal with
> > > reuse case by allocating new in-core inode and flipping whatever
> > > references you've got in XFS journalling data structures to the
> > > new copy?  If I understood what you said on IRC correctly, that is...
> > 
> > That's ... much harder.
> > 
> > One of the problems is that once an inode has a log item attached to
> > it, it assumes that it can be accessed without specific locking,
> > etc. see xfs_inode_clean(), for example. So there's some life-cycle
> > stuff that needs to be taken care of in XFS first, and the inode <->
> > log item relationship is tangled.
> > 
> > I've been working towards removing that tangle - but taht stuff is
> > quite a distance down my logging rework patch queue. THat queue has
> > been stuck now for a year trying to get the first handful of rework
> > and scalability modifications reviewed and merged, so I'm not
> > holding my breathe as to how long a more substantial rework of
> > internal logging code will take to review and merge.
> > 
> > Really, though, we need the inactivation stuff to be done as part of
> > the VFS inode lifecycle. I have some ideas on what to do here, but I
> > suspect we'll need some changes to iput_final()/evict() to allow us
> > to process final unlinks in the bakground and then call evict()
> > ourselves when the unlink completes. That way ->destroy_inode() can
> > just call xfs_reclaim_inode() to free it directly, which also helps
> > us get rid of background inode freeing and hence inode recycling
> > from XFS altogether. I think we _might_ be able to do this without
> > needing to change any of the logging code in XFS, but I haven't
> > looked any further than this into it as yet.
> > 
> 
> ... of whatever this ends up looking like.
> 
> Can you elaborate on what you mean by processing unlinks in the
> background? I can see the value of being able to eliminate the recycle
> code in XFS, but wouldn't we still have to limit and throttle against
> background work to maintain sustained removal performance?

Yes, but that's irrelevant because all we would be doing is slightly
changing where that throttling occurs (i.e. in
iput_final->drop_inode instead of iput_final->evict->destroy_inode).

However, moving the throttling up the stack is a good thing because
it gets rid of the current problem with the inactivation throttling
blocking the shrinker via shrinker->super_cache_scan->
prune_icache_sb->dispose_list->evict-> destroy_inode->throttle on
full inactivation queue because all the inodes need EOF block
trimming to be done.

> IOW, what's
> the general teardown behavior you're getting at here, aside from what
> parts push into the vfs or not?

->drop_inode() triggers background inactivation for both blockgc and
inode unlink. For unlink, we set I_WILL_FREE so the VFS will not
attempt to re-use it, add the inode # to the internal AG "busy
inode" tree and return drop = true and the VFS then stops processing
that inode. For blockgc, we queue the work and return drop = false
and the VFS puts it onto the LRU. Now we have asynchronous
inactivation while the inode is still present and visible at the VFS
level.

For background blockgc - that now happens while the inode is idle on
the LRU before it gets reclaimed by the shrinker. i.e. we trigger
block gc when the last reference to the inode goes away instead of
when it gets removed from memory by the shrinker.

For unlink, that now runs in the bacgrkoud until the inode unlink
has been journalled and the cleared inode written to the backing
inode cluster buffer. The inode is then no longer visisble to the
journal and it can't be reallocated because it is still busy. We
then change the inode state from I_WILL_FREE to I_FREEING and call
evict(). The inode then gets torn down, and in ->destroy_inode we
remove the inode from the radix tree, clear the per-ag busy record
and free the inode via RCU as expected by the VFS.

Another possible mechanism instead of exporting evict() is that
background inactivation takes a new reference to the inode from
->drop_inode so that even if we put it on the LRU the inode cache
shrinker will skip it while we are doing background inactivation.
That would mean that when background inactivation is done, we call
iput_final() again. The inode will either then be left on the LRU or
go through the normal evict() path.

This also it gets the memory demand and overhead of EOF block
trimming out of the memory reclaim path, and it also gets rid of
the need for the special superblock shrinker hooks that XFS has for
reclaiming it's internal inode cache.

Overall, lifting this stuff up to the VFS is full of "less
complexity in XFS" wins if we can make it work...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
