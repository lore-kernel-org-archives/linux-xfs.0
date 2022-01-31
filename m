Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1E8FC433EF
	for <linux-xfs@archiver.kernel.org>; Mon, 31 Jan 2022 13:28:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348723AbiAaN2w (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 31 Jan 2022 08:28:52 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:24776 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239492AbiAaN2w (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 31 Jan 2022 08:28:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643635731;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=I5jvSXKCYM42qEh2eIcWJh7m351ssMkMQLGkdnyWnBI=;
        b=TQg04d9MpGCIjr2lUCoiELOKbGdmfAGlYRDfOkQx/jkRPzAP2N1VmB+jCKDTLaSk9J83RW
        RHN0U+1BIeYf2QpdQd5twdw8T0wx9wZcXMmbm6YRckRBCPTOCANVoLwViA2l7Ui162/gCF
        5joc6fxayn+a8bPhrLYhOkE/0hlyST0=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-629-piMNtnYAPRSQrYgBZzP1LA-1; Mon, 31 Jan 2022 08:28:50 -0500
X-MC-Unique: piMNtnYAPRSQrYgBZzP1LA-1
Received: by mail-qk1-f197.google.com with SMTP id b16-20020a05620a119000b004e11e7b51c4so5394113qkk.17
        for <linux-xfs@vger.kernel.org>; Mon, 31 Jan 2022 05:28:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=I5jvSXKCYM42qEh2eIcWJh7m351ssMkMQLGkdnyWnBI=;
        b=qSOR+puc+x6eTPkiEswnsjxhKF3bk7q46sLAr+BsDh4EuVGK8oiIeFJwnqXa22Dd2M
         FWodLSRKxzAH3TSGWR5LXIsRPN/3KXjiGnpRrMB1CuXtAxTVo3kLhH9VGH64nuVWYbtg
         m97NSuQVs5xI+bs10+NuBJ/Z1f73AQq9nI4ShO48daGtl875MMeca3esYnKFn9/v7ure
         J9cwGLsSRgCUTIe6nI1ki60qtzwDcbCbj9KTNOxEnmeC0bPTUzSzBKSygNF/lx8yPjQT
         j0WJTX1Uc3YVa4FE6afVIz8rwkZHDhpddMMDOe8Boea4SSQiOMN6FVPVGUYv4Fef+oul
         EQmQ==
X-Gm-Message-State: AOAM5306P6JCUEX07o8ZT3ZxAf3IwNkn4Ym01TM8YVYes801z7agMXX9
        YxhqOv5K4IQ2FO3UKuai+/HJNZQDLDulLNc5OqKFfQ83pEwMGNJUOTzMhKAHpsBPKOl0k42O13Y
        SkV0dA0NDnmilXfGHdHlg
X-Received: by 2002:a05:622a:a:: with SMTP id x10mr14913821qtw.208.1643635729300;
        Mon, 31 Jan 2022 05:28:49 -0800 (PST)
X-Google-Smtp-Source: ABdhPJx1J8SC99VePLrUEOBUDrnjC4jEJJAxBfA7gRr1okdkAiuHe6SGPp/PFwvHo9cPqBlfALHCNg==
X-Received: by 2002:a05:622a:a:: with SMTP id x10mr14913790qtw.208.1643635728893;
        Mon, 31 Jan 2022 05:28:48 -0800 (PST)
Received: from bfoster (c-24-61-119-116.hsd1.ma.comcast.net. [24.61.119.116])
        by smtp.gmail.com with ESMTPSA id r1sm8374584qtt.92.2022.01.31.05.28.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Jan 2022 05:28:48 -0800 (PST)
Date:   Mon, 31 Jan 2022 08:28:46 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Al Viro <viro@zeniv.linux.org.uk>, linux-xfs@vger.kernel.org,
        Ian Kent <raven@themaw.net>, rcu@vger.kernel.org
Subject: Re: [PATCH] xfs: require an rcu grace period before inode recycle
Message-ID: <YffkDg4YTfwOayVx@bfoster>
References: <Ye82TgBY0VmtTjMc@bfoster>
 <20220125003120.GO59729@dread.disaster.area>
 <YfBBzHascwVnefYY@bfoster>
 <20220125224551.GQ59729@dread.disaster.area>
 <YfIdVq6R6xEWxy0K@zeniv-ca.linux.org.uk>
 <20220127052609.GR59729@dread.disaster.area>
 <YfLsBdPBSsyPFgHJ@bfoster>
 <20220127221817.GS59729@dread.disaster.area>
 <YfP5e6Y1bQ2V/NwN@bfoster>
 <20220128235313.GT59729@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220128235313.GT59729@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Jan 29, 2022 at 10:53:13AM +1100, Dave Chinner wrote:
> On Fri, Jan 28, 2022 at 09:11:07AM -0500, Brian Foster wrote:
> > On Fri, Jan 28, 2022 at 09:18:17AM +1100, Dave Chinner wrote:
> > > On Thu, Jan 27, 2022 at 02:01:25PM -0500, Brian Foster wrote:
> > > > On Thu, Jan 27, 2022 at 04:26:09PM +1100, Dave Chinner wrote:
> > > > > On Thu, Jan 27, 2022 at 04:19:34AM +0000, Al Viro wrote:
> > > > > > On Wed, Jan 26, 2022 at 09:45:51AM +1100, Dave Chinner wrote:
> > > > > > 
> > > > > > > Right, background inactivation does not improve performance - it's
> > > > > > > necessary to get the transactions out of the evict() path. All we
> > > > > > > wanted was to ensure that there were no performance degradations as
> > > > > > > a result of background inactivation, not that it was faster.
> > > > > > > 
> > > > > > > If you want to confirm that there is an increase in cold cache
> > > > > > > access when the batch size is increased, cpu profiles with 'perf
> > > > > > > top'/'perf record/report' and CPU cache performance metric reporting
> > > > > > > via 'perf stat -dddd' are your friend. See elsewhere in the thread
> > > > > > > where I mention those things to Paul.
> > > > > > 
> > > > > > Dave, do you see a plausible way to eventually drop Ian's bandaid?
> > > > > > I'm not asking for that to happen this cycle and for backports Ian's
> > > > > > patch is obviously fine.
> > > > > 
> > > > > Yes, but not in the near term.
> > > > > 
> > > > > > What I really want to avoid is the situation when we are stuck with
> > > > > > keeping that bandaid in fs/namei.c, since all ways to avoid seeing
> > > > > > reused inodes would hurt XFS too badly.  And the benchmarks in this
> > > > > > thread do look like that.
> > > > > 
> > > > > The simplest way I think is to have the XFS inode allocation track
> > > > > "busy inodes" in the same way we track "busy extents". A busy extent
> > > > > is an extent that has been freed by the user, but is not yet marked
> > > > > free in the journal/on disk. If we try to reallocate that busy
> > > > > extent, we either select a different free extent to allocate, or if
> > > > > we can't find any we force the journal to disk, wait for it to
> > > > > complete (hence unbusying the extents) and retry the allocation
> > > > > again.
> > > > > 
> > > > > We can do something similar for inode allocation - it's actually a
> > > > > lockless tag lookup on the radix tree entry for the candidate inode
> > > > > number. If we find the reclaimable radix tree tag set, the we select
> > > > > a different inode. If we can't allocate a new inode, then we kick
> > > > > synchronize_rcu() and retry the allocation, allowing inodes to be
> > > > > recycled this time.
> > > > > 
> > > > 
> > > > I'm starting to poke around this area since it's become clear that the
> > > > currently proposed scheme just involves too much latency (unless Paul
> > > > chimes in with his expedited grace period variant, at which point I will
> > > > revisit) in the fast allocation/recycle path. ISTM so far that a simple
> > > > "skip inodes in the radix tree, sync rcu if unsuccessful" algorithm will
> > > > have pretty much the same pattern of behavior as this patch: one
> > > > synchronize_rcu() per batch.
> > > 
> > > That's not really what I proposed - what I suggested was that if we
> > > can't allocate a usable inode from the finobt, and we can't allocate
> > > a new inode cluster from the AG (i.e. populate the finobt with more
> > > inodes), only then call synchronise_rcu() and recycle an inode.
> > > 
> > 
> > That's not how I read it... Regardless, that was my suggestion as well,
> > so we're on the same page on that front.
> > 
> > > We don't need to scan the inode cache or the finobt to determine if
> > > there are reclaimable inodes immediately available - do a gang tag
> > > lookup on the radix tree for newino.
> > > If it comes back with an inode number that is not
> > > equal to the node number we looked up, then we can allocate an
> > > newino immediately.
> > > 
> > > If it comes back with newino, then check the first inode in the
> > > finobt. If that comes back with an inode that is not the first inode
> > > in the finobt, we can immediately allocate the first inode in the
> > > finobt. If not, check the last inode. if that fails, assume all
> > > inodes in the finobt need recycling and allocate a new cluster,
> > > pointing newino at it.
> > > 
> > 
> > Hrm, I'll have to think about this some more. I don't mind something
> > like this as a possible scanning allocation algorithm, but I don't love
> > the idea of doing a few predictable btree/radix tree lookups and
> > inferring broader AG state from that, particularly when I think it's
> > possible to get more accurate information in a way that's easier and
> > probably more efficient.
> > 
> > For example, we already have counts of the number of reclaimable and
> > free inodes in the perag. We could fairly easily add a counter to track
> > the subset of reclaimable inodes that are unlinked. With something like
> > that, it's easier to make higher level decisions like when to just
> > allocate a new inode chunk (because the free inode pool consists mostly
> > of reclaimable inodes) or just scanning through the finobt for a good
> > candidate (because there are none or very few unlinked reclaimable
> > inodes relative to the number of free inodes in the btree).
> > 
> > So in general I think the two obvious ends of the spectrum (i.e. the
> > repeated alloc/free workload I'm testing above vs. the tar/cp use case
> > where there are many allocs and few unlinks) are probably the most
> > straightforward to handle and don't require major search algorithm
> > changes.  It's the middle ground (i.e. a large number of free inodes
> > with half or whatever more sitting in the radix tree) that I think
> > requires some more thought and I don't quite have an answer for atm. I
> > don't want to go off allocating new inode chunks too aggressively, but
> > also don't want to turn the finobt allocation algorithm into something
> > like the historical inobt search algorithm with poor worst case
> > behavior.
> > 
> > > Then we get another 64 inodes starting at the newino cursor we can
> > > allocate from while we wait for the current RCU grace period to
> > > expire for inodes already in the reclaimable state. An algorithm
> > > like this will allow the free inode pool to resize automatically
> > > based on the unlink frequency of the workload and RCU grace period
> > > latency...
> > > 
> > > > IOW, background reclaim only kicks in after 30s by default,
> > > 
> > > 5 seconds, by default, not 30s.
> > > 
> > 
> > xfs_reclaim_work_queue() keys off xfs_syncd_centisecs, which corresponds
> > to xfs_params.syncd_timer, which is initialized as:
> > 
> >         .syncd_timer    = {     1*100,          30*100,         7200*100},
> > 
> > Am I missing something?
> 
> static void
> xfs_reclaim_work_queue(
>         struct xfs_mount        *mp)
> {
> 
>         rcu_read_lock();
>         if (radix_tree_tagged(&mp->m_perag_tree, XFS_ICI_RECLAIM_TAG)) {
>                 queue_delayed_work(mp->m_reclaim_workqueue, &mp->m_reclaim_work,
>                         msecs_to_jiffies(xfs_syncd_centisecs / 6 * 10));
>         }
>         rcu_read_unlock();
> }
> 

Ah, thanks.

> ....
> 
> > > > > Really, though, we need the inactivation stuff to be done as part of
> > > > > the VFS inode lifecycle. I have some ideas on what to do here, but I
> > > > > suspect we'll need some changes to iput_final()/evict() to allow us
> > > > > to process final unlinks in the bakground and then call evict()
> > > > > ourselves when the unlink completes. That way ->destroy_inode() can
> > > > > just call xfs_reclaim_inode() to free it directly, which also helps
> > > > > us get rid of background inode freeing and hence inode recycling
> > > > > from XFS altogether. I think we _might_ be able to do this without
> > > > > needing to change any of the logging code in XFS, but I haven't
> > > > > looked any further than this into it as yet.
> > > > > 
> > > > 
> > > > ... of whatever this ends up looking like.
> > > > 
> > > > Can you elaborate on what you mean by processing unlinks in the
> > > > background? I can see the value of being able to eliminate the recycle
> > > > code in XFS, but wouldn't we still have to limit and throttle against
> > > > background work to maintain sustained removal performance?
> > > 
> > > Yes, but that's irrelevant because all we would be doing is slightly
> > > changing where that throttling occurs (i.e. in
> > > iput_final->drop_inode instead of iput_final->evict->destroy_inode).
> > > 
> > > However, moving the throttling up the stack is a good thing because
> > > it gets rid of the current problem with the inactivation throttling
> > > blocking the shrinker via shrinker->super_cache_scan->
> > > prune_icache_sb->dispose_list->evict-> destroy_inode->throttle on
> > > full inactivation queue because all the inodes need EOF block
> > > trimming to be done.
> > > 
> > 
> > What I'm trying to understand is whether inodes will have cycled through
> > the requisite grace period before ->destroy_inode() or not, and if so,
> 
> The whole point of moving stuff up in the VFS is that inodes
> don't get recycled by XFS at all so we don't even have to think
> about RCU grace periods anywhere inside XFS.
> 
> > how that is done to avoid the sustained removal performance problem
> > we've run into here (caused by the extra latency leading to increasing
> > cacheline misses)..?
> 
> The background work is done _before_ evict() is called by the VFS to
> get the inode freed via RCU callbacks. The perf constraints are
> unchanged, we just change the layer at which the background work is
> performance.
> 

Ok.

> > > > IOW, what's
> > > > the general teardown behavior you're getting at here, aside from what
> > > > parts push into the vfs or not?
> > > 
> > > ->drop_inode() triggers background inactivation for both blockgc and
> > > inode unlink. For unlink, we set I_WILL_FREE so the VFS will not
> > > attempt to re-use it, add the inode # to the internal AG "busy
> > > inode" tree and return drop = true and the VFS then stops processing
> > > that inode. For blockgc, we queue the work and return drop = false
> > > and the VFS puts it onto the LRU. Now we have asynchronous
> > > inactivation while the inode is still present and visible at the VFS
> > > level.
> > > 
> > > For background blockgc - that now happens while the inode is idle on
> > > the LRU before it gets reclaimed by the shrinker. i.e. we trigger
> > > block gc when the last reference to the inode goes away instead of
> > > when it gets removed from memory by the shrinker.
> > > 
> > > For unlink, that now runs in the bacgrkoud until the inode unlink
> > > has been journalled and the cleared inode written to the backing
> > > inode cluster buffer. The inode is then no longer visisble to the
> > > journal and it can't be reallocated because it is still busy. We
> > > then change the inode state from I_WILL_FREE to I_FREEING and call
> > > evict(). The inode then gets torn down, and in ->destroy_inode we
> > > remove the inode from the radix tree, clear the per-ag busy record
> > > and free the inode via RCU as expected by the VFS.
> > > 
> > 
> > Ok, so this sort of sounds like these are separate things. I'm all for
> > creating more flexibility with the VFS to allow XFS to remove or
> > simplify codepaths, but this still depends on some form of grace period
> > tracking to avoid allocation of inodes that are free in the btrees but
> > still might have in-core struct inode's laying around, yes?
> 
> > The reason I'm asking about this is because as this patch to avoid
> > recycling non-expired inodes becomes more complex in order to satisfy
> > performance requirements, longer term usefulness becomes more relevant.
> 
> You say this like I haven't already thought about this....
> 
> > I don't want us to come up with some complex scheme to avoid RCU stalls
> > when there's already a plan to rip it out and replace it in a year or
> > so. OTOH if the resulting logic is part of that longer term strategy,
> > then this is less of a concern.
> 
> .... and so maybe you haven't realised why I keep suggesting
> something along the lines of a busy inode mechanism similar to busy
> extent tracking?
> 
> Essentially, we can't reallocate the inode until the previous use
> has been retired. Which means we'd create the busy inode record in
> xfs_inactive() before we free the inode and xfs_reclaim_inode()
> would remove the inode from the busy tree when it reclaims the inode
> and removes it from the radix tree after marking it dead for RCU
> lookup purposes. That would prevent reallocation of the inode until
> we can allocate a new in-core inode structure for the inode.
> 
> In the lifted VFS case I describe, ->drop_inode() would result in
> background inactivation inserting the inode into the busy tree. Once
> that is all done and we call evict() on the inode, ->destroy_inode
> calls xfs-reclaim_inode() directly. IOWs, the busy inode mechanism
> works for both existing and future inactivation mechanisms.
> 

This is what I was trying to understand. The discussion to this point
around eventually moving lifecycle bits into the VFS gave the impression
that the grace period sequence would essentially be hidden from XFS, so
that's why I've been asking how we expect to accomplish that. ISTM
that's not necessarily the case... the notion of a free (on disk) inode
that cannot be used due to a pending grace period still exists, it's
just abstracted as a "busy inode" and used to implement a rule that such
inodes cannot be reallocated until the VFS indicates so. At that point
we reclaim the struct inode so this presumably eliminates the need for
the recycling logic and perhaps various other lifecycle related bits
(that I've not thought through) in XFS, providing further simplification
opportunities, etc.

If I'm following the general idea correctly, this makes more sense to
me. Thanks.

Brian

> Now, lets take a step further back from this, and consider the
> current inode cache implementation.  The fast and dirty method for
> tracking busy inodes is to use the fact that a busy inode is defined
> as being in the finobt whilst the in-core inode is in an
> IRECLAIMABLE state.
> 
> Hence, at least initially, we don't need a separate tree to
> determine if an inode is "busy" efficiently. The allocation policy
> that selects the inode to allocate doesn't care what mechanism we
> use to determine if an inode is busy - it's just concerned with
> finding a non-busy inode efficiently. Hence we can use a simple
> "best, first, last" hueristic to determine if the finobt is likely
> to be largely made up of busy inodes and decide to allocate new
> inode chunks instead of searching the finobt for an unbusy inode.
> 
> IOWs, the "busy extent tracking" implementation will need to change
> to be something more explicit as we move inactivation up in the VFS
> because the IRCELAIMABLE state goes away, but that doesn't change
> the allocation algorithm or heuristics that are based on detecting
> busy inodes at allocation time.
> 
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 

