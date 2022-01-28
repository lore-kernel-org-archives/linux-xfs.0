Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BD0BC433EF
	for <linux-xfs@archiver.kernel.org>; Fri, 28 Jan 2022 14:11:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346936AbiA1OLQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 28 Jan 2022 09:11:16 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:40418 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235208AbiA1OLO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 28 Jan 2022 09:11:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643379073;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=YomwWvemuiPREr7uDt/d+Gf1MNGWkmf5x3I7VNXSPjs=;
        b=b81cu1Rbd+LJ5CADOeEpONAu/CclQ816jOx//ALS0lrn48nHkJk4yq2c+jDf+NFSKBwsyz
        ggmVVV/ez15Dhn73fiOTyMktMiVrTHzPStSjSQ01CsXtc9DUfvObcs5mscN1XM158s4Uok
        3rqldi1YRbFFKpvq2bd08uiyUk4pyFk=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-553-3fp2cTvwPp2E97E1kqpR0A-1; Fri, 28 Jan 2022 09:11:12 -0500
X-MC-Unique: 3fp2cTvwPp2E97E1kqpR0A-1
Received: by mail-qt1-f199.google.com with SMTP id b7-20020ac85bc7000000b002b65aee118bso4571163qtb.13
        for <linux-xfs@vger.kernel.org>; Fri, 28 Jan 2022 06:11:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=YomwWvemuiPREr7uDt/d+Gf1MNGWkmf5x3I7VNXSPjs=;
        b=LG9VhUfnIkCA43WOcWUr5m08pYJZtoUH9k4Fod/zcDS9us4eGs2U+8tY5Q/333BoMI
         p5f6qoo1MNFgqRf9FgZzsQ4SA9GAt7dC+TzeucJL2NGMbJ2wNk0tNphjHZ1Z/xiQva/T
         YdsrDYmib8cO3sGM3NXhjtFIMP0JZZzQnNOo1HuEnxbRUzFq6MF5dukokjYXC8WFoyNw
         6T9Oyi9pXM85HexuI9Nvb4ibIQZ+MP6u+vL16EsZagvYaUvrkSsdI//VpS8goMmoVpzA
         +1w2cpBS8RqpQs1qdWPDRvCzgQ/p558p+dEN/j+g9SrHHMqhJknXDJcTYfGupCdEsjO+
         COjQ==
X-Gm-Message-State: AOAM532QQYF+nwekaJlAId4m1ASmgK38QFUbFfJXy1/LEagkRjIlUaAM
        TAVr7rgpz0tt80ILHSYjKjlMo1k5SjxmfcBpqxxexqg1Z1PQjIJA4mFui8N0j6xBk5UARImw25N
        o2qvmeTCtupCCdgbQIRNI
X-Received: by 2002:a05:620a:424e:: with SMTP id w14mr5843517qko.26.1643379070048;
        Fri, 28 Jan 2022 06:11:10 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyhOYBtgdut5A0hltokMXqYZvCduuab+hmjn8sSPBHpttpU5coHa0RJdF7+I3I34WuC9aShow==
X-Received: by 2002:a05:620a:424e:: with SMTP id w14mr5843472qko.26.1643379069418;
        Fri, 28 Jan 2022 06:11:09 -0800 (PST)
Received: from bfoster (c-24-61-119-116.hsd1.ma.comcast.net. [24.61.119.116])
        by smtp.gmail.com with ESMTPSA id i13sm3554655qko.91.2022.01.28.06.11.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Jan 2022 06:11:09 -0800 (PST)
Date:   Fri, 28 Jan 2022 09:11:07 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Al Viro <viro@zeniv.linux.org.uk>, linux-xfs@vger.kernel.org,
        Ian Kent <raven@themaw.net>, rcu@vger.kernel.org
Subject: Re: [PATCH] xfs: require an rcu grace period before inode recycle
Message-ID: <YfP5e6Y1bQ2V/NwN@bfoster>
References: <Ye6/g+XMSyp9vYvY@bfoster>
 <20220124220853.GN59729@dread.disaster.area>
 <Ye82TgBY0VmtTjMc@bfoster>
 <20220125003120.GO59729@dread.disaster.area>
 <YfBBzHascwVnefYY@bfoster>
 <20220125224551.GQ59729@dread.disaster.area>
 <YfIdVq6R6xEWxy0K@zeniv-ca.linux.org.uk>
 <20220127052609.GR59729@dread.disaster.area>
 <YfLsBdPBSsyPFgHJ@bfoster>
 <20220127221817.GS59729@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220127221817.GS59729@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jan 28, 2022 at 09:18:17AM +1100, Dave Chinner wrote:
> On Thu, Jan 27, 2022 at 02:01:25PM -0500, Brian Foster wrote:
> > On Thu, Jan 27, 2022 at 04:26:09PM +1100, Dave Chinner wrote:
> > > On Thu, Jan 27, 2022 at 04:19:34AM +0000, Al Viro wrote:
> > > > On Wed, Jan 26, 2022 at 09:45:51AM +1100, Dave Chinner wrote:
> > > > 
> > > > > Right, background inactivation does not improve performance - it's
> > > > > necessary to get the transactions out of the evict() path. All we
> > > > > wanted was to ensure that there were no performance degradations as
> > > > > a result of background inactivation, not that it was faster.
> > > > > 
> > > > > If you want to confirm that there is an increase in cold cache
> > > > > access when the batch size is increased, cpu profiles with 'perf
> > > > > top'/'perf record/report' and CPU cache performance metric reporting
> > > > > via 'perf stat -dddd' are your friend. See elsewhere in the thread
> > > > > where I mention those things to Paul.
> > > > 
> > > > Dave, do you see a plausible way to eventually drop Ian's bandaid?
> > > > I'm not asking for that to happen this cycle and for backports Ian's
> > > > patch is obviously fine.
> > > 
> > > Yes, but not in the near term.
> > > 
> > > > What I really want to avoid is the situation when we are stuck with
> > > > keeping that bandaid in fs/namei.c, since all ways to avoid seeing
> > > > reused inodes would hurt XFS too badly.  And the benchmarks in this
> > > > thread do look like that.
> > > 
> > > The simplest way I think is to have the XFS inode allocation track
> > > "busy inodes" in the same way we track "busy extents". A busy extent
> > > is an extent that has been freed by the user, but is not yet marked
> > > free in the journal/on disk. If we try to reallocate that busy
> > > extent, we either select a different free extent to allocate, or if
> > > we can't find any we force the journal to disk, wait for it to
> > > complete (hence unbusying the extents) and retry the allocation
> > > again.
> > > 
> > > We can do something similar for inode allocation - it's actually a
> > > lockless tag lookup on the radix tree entry for the candidate inode
> > > number. If we find the reclaimable radix tree tag set, the we select
> > > a different inode. If we can't allocate a new inode, then we kick
> > > synchronize_rcu() and retry the allocation, allowing inodes to be
> > > recycled this time.
> > > 
> > 
> > I'm starting to poke around this area since it's become clear that the
> > currently proposed scheme just involves too much latency (unless Paul
> > chimes in with his expedited grace period variant, at which point I will
> > revisit) in the fast allocation/recycle path. ISTM so far that a simple
> > "skip inodes in the radix tree, sync rcu if unsuccessful" algorithm will
> > have pretty much the same pattern of behavior as this patch: one
> > synchronize_rcu() per batch.
> 
> That's not really what I proposed - what I suggested was that if we
> can't allocate a usable inode from the finobt, and we can't allocate
> a new inode cluster from the AG (i.e. populate the finobt with more
> inodes), only then call synchronise_rcu() and recycle an inode.
> 

That's not how I read it... Regardless, that was my suggestion as well,
so we're on the same page on that front.

> We don't need to scan the inode cache or the finobt to determine if
> there are reclaimable inodes immediately available - do a gang tag
> lookup on the radix tree for newino.
> If it comes back with an inode number that is not
> equal to the node number we looked up, then we can allocate an
> newino immediately.
> 
> If it comes back with newino, then check the first inode in the
> finobt. If that comes back with an inode that is not the first inode
> in the finobt, we can immediately allocate the first inode in the
> finobt. If not, check the last inode. if that fails, assume all
> inodes in the finobt need recycling and allocate a new cluster,
> pointing newino at it.
> 

Hrm, I'll have to think about this some more. I don't mind something
like this as a possible scanning allocation algorithm, but I don't love
the idea of doing a few predictable btree/radix tree lookups and
inferring broader AG state from that, particularly when I think it's
possible to get more accurate information in a way that's easier and
probably more efficient.

For example, we already have counts of the number of reclaimable and
free inodes in the perag. We could fairly easily add a counter to track
the subset of reclaimable inodes that are unlinked. With something like
that, it's easier to make higher level decisions like when to just
allocate a new inode chunk (because the free inode pool consists mostly
of reclaimable inodes) or just scanning through the finobt for a good
candidate (because there are none or very few unlinked reclaimable
inodes relative to the number of free inodes in the btree).

So in general I think the two obvious ends of the spectrum (i.e. the
repeated alloc/free workload I'm testing above vs. the tar/cp use case
where there are many allocs and few unlinks) are probably the most
straightforward to handle and don't require major search algorithm
changes.  It's the middle ground (i.e. a large number of free inodes
with half or whatever more sitting in the radix tree) that I think
requires some more thought and I don't quite have an answer for atm. I
don't want to go off allocating new inode chunks too aggressively, but
also don't want to turn the finobt allocation algorithm into something
like the historical inobt search algorithm with poor worst case
behavior.

> Then we get another 64 inodes starting at the newino cursor we can
> allocate from while we wait for the current RCU grace period to
> expire for inodes already in the reclaimable state. An algorithm
> like this will allow the free inode pool to resize automatically
> based on the unlink frequency of the workload and RCU grace period
> latency...
> 
> > IOW, background reclaim only kicks in after 30s by default,
> 
> 5 seconds, by default, not 30s.
> 

xfs_reclaim_work_queue() keys off xfs_syncd_centisecs, which corresponds
to xfs_params.syncd_timer, which is initialized as:

        .syncd_timer    = {     1*100,          30*100,         7200*100},

Am I missing something? Not that it really matters much for this
discussion anyways. Whether it's 30s or 5s, either way the reallocation
workload is going to pretty much always recycle these inodes long before
background reclaim gets to them.

> > so the pool
> > of free inodes pretty much always consists of 100% reclaimable inodes.
> > On top of that, at smaller batch sizes, the pool tends to have a uniform
> > (!elapsed) grace period cookie, so a stall is required to be able to
> > allocate any of them. As the batch size increases, I do see the
> > population of free inodes start to contain a mix of expired and
> > non-expired grace period cookies. It's fairly easy to hack up an
> > internal icwalk scan to locate already expired inodes,
> 
> We don't want or need to do exhaustive, exactly correct scans here.
> We want *fast and loose* because this is a critical performance fast
> path. We don't care if we skip the occasional recyclable inode, what
> we need to to is minimise the CPU overhead and search latency for
> the case where recycling will never occur.
> 

Agreed. That's what I meant by my comment about having heuristics to
avoid large/long scans.

> > but the problem
> > is that the recycle rate is so much faster than the grace period latency
> > that it doesn't really matter. We'll still have to stall by the time we
> > get to the non-expired inodes, and so we're back to one stall per batch
> > and the same general performance characteristic of this patch.
> 
> Yes, but that's why I suggested that we allocate a new inode cluster
> rather than calling synchronise_rcu() when we don't have a
> recyclable inode candidate.
> 

Ok.

> > So given all of this, I'm wondering about something like the following
> > high level inode allocation algorithm:
> > 
> > 1. If the AG has any reclaimable inodes, scan for one with an expired
> > grace period. If found, target that inode for physical allocation.
> 
> How do you efficiently discriminate between "reclaimable w/ nlink >
> 0" and "reclaimable w/ nlink == 0" so we don't get hung up searching
> millions of reclaimable inodes for the one that has been unlinked
> and has an expired grace period?
> 

A counter or some other form of hinting structure..

> Also, this will need to be done on every inode allocation when we
> have inodes in reclaimable state (which is almost always on a busy
> system).  Workloads with sequential allocation (as per untar, rsync,
> git checkout, cp -r, etc) will do this scan unnecessarily as they
> will almost never hit this inode recycle path as there aren't a lot
> of unlinks occurring while they are working.
> 

I'm not necessarily suggesting a full radix tree scan per inode
allocation. I was more thinking about an occasionally updated hinting
structure to efficiently locate the least recently freed inode numbers,
or something similar. This would serve no purpose in scenarios where it
just makes more sense to allocate new chunks, but otherwise could just
serve as an allocation target, a metric to determine likelihood of
reclaimable inodes w/ expired grace periods being present, or just a
starting point for a finobt search algorithm like what you describe
above, etc.

> > 2. If the AG free inode count == the AG reclaimable count and we know
> > all reclaimable inodes are most likely pending a grace period (because
> > the previous step failed), allocate a new inode chunk (and target it in
> > this allocation).
> 
> That's good for the allocation that allocates the chunk, but...
> 
> > 3. If the AG free inode count > the reclaimable count, scan the finobt
> > for an inode that is not present in the radix tree (i.e. Dave's logic
> > above).
> 
> ... now we are repeating the radix tree walk that we've already done
> in #1 to find the newly allocated inodes we allocated in #2.
> 
> We don't need to walk the inodes in the inode radix tree to look at
> individual inode state - we can use the reclaimable radix tree tag
> to shortcut those walks and minimise the number of actual lookups we
> need to do. By definition, and inode in the finobt and
> XFS_IRECLAIMABLE state is an inode that needs recycling, so we can
> just use the finobt and the inode radix tree tags to avoid inodes
> that need recycling altogether.  i.e. If we fail a tag lookup, we
> have no reclaimable inodes in the range we asked the lookup to
> search so we can immediately allocate - we don't need to actually
> need to look at the inode in the fast path no-recycling case at all. 
> 

This is starting to make some odd (to me) assumptions about thus far
undefined implementation details. For example, the very little amount of
code I have already for experimentation purposes only scans tagged
reclaimable inodes, so that you suggest doing exactly that instead of
full radix tree scans suggests to me that there are some details here
that are clearly not getting across in email. ;)

That's fine, I'm not trying to cover details. Details are easier to work
through with code, and TBH I don't have enough concrete ideas to hash
through details in email just yet anyways. The primary concepts in my
previous description were that we should prioritize allocation of new
chunks over taking RCU stalls whenever possible, and that there might be
ways to use existing radix tree state to maintain predictable worst case
performance for finobt searches (TBD). With regard to the general
principles you mention of avoiding repeated large scans, maintaing
common workload and fast path performance, etc., I think we're pretty
much on the same page.

> Keep in mind that the fast path we really care about is not the
> unlink/allocate looping case, it's the allocation case where no
> recycling will ever occur and so that's the one we really have to
> try hard to minimise the overhead for. The moment we get into
> reclaimable inodes within the finobt range  we're hitting the "lots
> of temp files" use case, so we can detect that and keep the overhead
> of that algorithm as separate as we possibly can.
> 
> Hence we need the initial "can we allocate this inode number"
> decision to be as fast and as low overhead as possible so we can
> determine which algorithm we need to run. A lockless radix tree gang
> tag lookup will give us that and if the lookup finds a reclaimable
> inode only then do we move into the "recycle RCU avoidance"
> algorithm path....
> 
> > > > Are there any realistic prospects of having xfs_iget() deal with
> > > > reuse case by allocating new in-core inode and flipping whatever
> > > > references you've got in XFS journalling data structures to the
> > > > new copy?  If I understood what you said on IRC correctly, that is...
> > > 
> > > That's ... much harder.
> > > 
> > > One of the problems is that once an inode has a log item attached to
> > > it, it assumes that it can be accessed without specific locking,
> > > etc. see xfs_inode_clean(), for example. So there's some life-cycle
> > > stuff that needs to be taken care of in XFS first, and the inode <->
> > > log item relationship is tangled.
> > > 
> > > I've been working towards removing that tangle - but taht stuff is
> > > quite a distance down my logging rework patch queue. THat queue has
> > > been stuck now for a year trying to get the first handful of rework
> > > and scalability modifications reviewed and merged, so I'm not
> > > holding my breathe as to how long a more substantial rework of
> > > internal logging code will take to review and merge.
> > > 
> > > Really, though, we need the inactivation stuff to be done as part of
> > > the VFS inode lifecycle. I have some ideas on what to do here, but I
> > > suspect we'll need some changes to iput_final()/evict() to allow us
> > > to process final unlinks in the bakground and then call evict()
> > > ourselves when the unlink completes. That way ->destroy_inode() can
> > > just call xfs_reclaim_inode() to free it directly, which also helps
> > > us get rid of background inode freeing and hence inode recycling
> > > from XFS altogether. I think we _might_ be able to do this without
> > > needing to change any of the logging code in XFS, but I haven't
> > > looked any further than this into it as yet.
> > > 
> > 
> > ... of whatever this ends up looking like.
> > 
> > Can you elaborate on what you mean by processing unlinks in the
> > background? I can see the value of being able to eliminate the recycle
> > code in XFS, but wouldn't we still have to limit and throttle against
> > background work to maintain sustained removal performance?
> 
> Yes, but that's irrelevant because all we would be doing is slightly
> changing where that throttling occurs (i.e. in
> iput_final->drop_inode instead of iput_final->evict->destroy_inode).
> 
> However, moving the throttling up the stack is a good thing because
> it gets rid of the current problem with the inactivation throttling
> blocking the shrinker via shrinker->super_cache_scan->
> prune_icache_sb->dispose_list->evict-> destroy_inode->throttle on
> full inactivation queue because all the inodes need EOF block
> trimming to be done.
> 

What I'm trying to understand is whether inodes will have cycled through
the requisite grace period before ->destroy_inode() or not, and if so,
how that is done to avoid the sustained removal performance problem
we've run into here (caused by the extra latency leading to increasing
cacheline misses)..?

> > IOW, what's
> > the general teardown behavior you're getting at here, aside from what
> > parts push into the vfs or not?
> 
> ->drop_inode() triggers background inactivation for both blockgc and
> inode unlink. For unlink, we set I_WILL_FREE so the VFS will not
> attempt to re-use it, add the inode # to the internal AG "busy
> inode" tree and return drop = true and the VFS then stops processing
> that inode. For blockgc, we queue the work and return drop = false
> and the VFS puts it onto the LRU. Now we have asynchronous
> inactivation while the inode is still present and visible at the VFS
> level.
> 
> For background blockgc - that now happens while the inode is idle on
> the LRU before it gets reclaimed by the shrinker. i.e. we trigger
> block gc when the last reference to the inode goes away instead of
> when it gets removed from memory by the shrinker.
> 
> For unlink, that now runs in the bacgrkoud until the inode unlink
> has been journalled and the cleared inode written to the backing
> inode cluster buffer. The inode is then no longer visisble to the
> journal and it can't be reallocated because it is still busy. We
> then change the inode state from I_WILL_FREE to I_FREEING and call
> evict(). The inode then gets torn down, and in ->destroy_inode we
> remove the inode from the radix tree, clear the per-ag busy record
> and free the inode via RCU as expected by the VFS.
> 

Ok, so this sort of sounds like these are separate things. I'm all for
creating more flexibility with the VFS to allow XFS to remove or
simplify codepaths, but this still depends on some form of grace period
tracking to avoid allocation of inodes that are free in the btrees but
still might have in-core struct inode's laying around, yes?

The reason I'm asking about this is because as this patch to avoid
recycling non-expired inodes becomes more complex in order to satisfy
performance requirements, longer term usefulness becomes more relevant.
I don't want us to come up with some complex scheme to avoid RCU stalls
when there's already a plan to rip it out and replace it in a year or
so. OTOH if the resulting logic is part of that longer term strategy,
then this is less of a concern.

Brian

> Another possible mechanism instead of exporting evict() is that
> background inactivation takes a new reference to the inode from
> ->drop_inode so that even if we put it on the LRU the inode cache
> shrinker will skip it while we are doing background inactivation.
> That would mean that when background inactivation is done, we call
> iput_final() again. The inode will either then be left on the LRU or
> go through the normal evict() path.
> 
> This also it gets the memory demand and overhead of EOF block
> trimming out of the memory reclaim path, and it also gets rid of
> the need for the special superblock shrinker hooks that XFS has for
> reclaiming it's internal inode cache.
> 
> Overall, lifting this stuff up to the VFS is full of "less
> complexity in XFS" wins if we can make it work...
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 

