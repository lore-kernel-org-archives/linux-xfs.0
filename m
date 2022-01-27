Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69476C433F5
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Jan 2022 19:01:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234802AbiA0TBc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 27 Jan 2022 14:01:32 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:33273 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238995AbiA0TBb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Jan 2022 14:01:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643310090;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=wc5pIo/fz7/YRuXsH6cyUCkDTCzS47nn+TPrVHljHds=;
        b=EBYB5yAox+q6d8/aGAlBYHPAC+XHdaNCobNgcZzQJlAxGg00YmkQ3Qen7vwa7+CYb7wAbu
        lduX438U3jj80tSkOnQpS6wuBK+vuVS2dojnExeDjtq8/S5cYzHdHYHAODu6zcvxtcB1H8
        0FbDQfL43haMb1CY1Q2Stltt3v7uE1k=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-367-vrurQO-yMwybrjffo5xRHg-1; Thu, 27 Jan 2022 14:01:29 -0500
X-MC-Unique: vrurQO-yMwybrjffo5xRHg-1
Received: by mail-qv1-f69.google.com with SMTP id g2-20020a0562141cc200b004123b0abe18so4115787qvd.2
        for <linux-xfs@vger.kernel.org>; Thu, 27 Jan 2022 11:01:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=wc5pIo/fz7/YRuXsH6cyUCkDTCzS47nn+TPrVHljHds=;
        b=gi9IwoUetCzQ/fZhRociSJzrV6CcbSEqGgXsTM3hSb4J7inBQmduWVEiBbcDzVPv9u
         FqQvS0A+Ngzebzo0isVjES/XEpbNrzduLXO9O57m0P1mdo9MNld3X/BMmaTsudLVzEm5
         vjUYsgri0KZtOu3JIwyC4MUHKppjOqP48lKY2gmiY+C+HkSV/PSt33Bn6vvgSKXqUmk4
         TI4zldNtu015K1LQK87A3XNgHXGUBfGhMdooSXlm5oVSgpgXP4ikasKK6gN4o2ExmPm7
         IE8iu0ZVyhqiIDozmw6McXsl+NQOcfOsSYqlVeDho3Tf2UD2aXB/sj+aYnNBoF5CbvFF
         X6tw==
X-Gm-Message-State: AOAM533RwWB1l0uBfCrgzpzYO8dLstQ35BAunjflMernupVagI8TVBgC
        8sKCqgYdJ+7J5UajJUB1emMVGa/sUh6ORGew6dGDhaqjBq17T1bqynwHN8YVgSzQegRz0tYXddX
        5R1j9jpZ2nyRRP50DvmiU
X-Received: by 2002:a05:6214:4111:: with SMTP id kc17mr4147366qvb.65.1643310088803;
        Thu, 27 Jan 2022 11:01:28 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzN5bRM062pGELFbjM8o2iJcXXwZ4JHYBP7C552CqKUWs7aOJPCR0ShDpyIti7UeTht7lpUuw==
X-Received: by 2002:a05:6214:4111:: with SMTP id kc17mr4147327qvb.65.1643310088439;
        Thu, 27 Jan 2022 11:01:28 -0800 (PST)
Received: from bfoster (c-24-61-119-116.hsd1.ma.comcast.net. [24.61.119.116])
        by smtp.gmail.com with ESMTPSA id n18sm1968823qkp.2.2022.01.27.11.01.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Jan 2022 11:01:28 -0800 (PST)
Date:   Thu, 27 Jan 2022 14:01:25 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Al Viro <viro@zeniv.linux.org.uk>, linux-xfs@vger.kernel.org,
        Ian Kent <raven@themaw.net>, rcu@vger.kernel.org
Subject: Re: [PATCH] xfs: require an rcu grace period before inode recycle
Message-ID: <YfLsBdPBSsyPFgHJ@bfoster>
References: <20220121142454.1994916-1-bfoster@redhat.com>
 <Ye6/g+XMSyp9vYvY@bfoster>
 <20220124220853.GN59729@dread.disaster.area>
 <Ye82TgBY0VmtTjMc@bfoster>
 <20220125003120.GO59729@dread.disaster.area>
 <YfBBzHascwVnefYY@bfoster>
 <20220125224551.GQ59729@dread.disaster.area>
 <YfIdVq6R6xEWxy0K@zeniv-ca.linux.org.uk>
 <20220127052609.GR59729@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220127052609.GR59729@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jan 27, 2022 at 04:26:09PM +1100, Dave Chinner wrote:
> On Thu, Jan 27, 2022 at 04:19:34AM +0000, Al Viro wrote:
> > On Wed, Jan 26, 2022 at 09:45:51AM +1100, Dave Chinner wrote:
> > 
> > > Right, background inactivation does not improve performance - it's
> > > necessary to get the transactions out of the evict() path. All we
> > > wanted was to ensure that there were no performance degradations as
> > > a result of background inactivation, not that it was faster.
> > > 
> > > If you want to confirm that there is an increase in cold cache
> > > access when the batch size is increased, cpu profiles with 'perf
> > > top'/'perf record/report' and CPU cache performance metric reporting
> > > via 'perf stat -dddd' are your friend. See elsewhere in the thread
> > > where I mention those things to Paul.
> > 
> > Dave, do you see a plausible way to eventually drop Ian's bandaid?
> > I'm not asking for that to happen this cycle and for backports Ian's
> > patch is obviously fine.
> 
> Yes, but not in the near term.
> 
> > What I really want to avoid is the situation when we are stuck with
> > keeping that bandaid in fs/namei.c, since all ways to avoid seeing
> > reused inodes would hurt XFS too badly.  And the benchmarks in this
> > thread do look like that.
> 
> The simplest way I think is to have the XFS inode allocation track
> "busy inodes" in the same way we track "busy extents". A busy extent
> is an extent that has been freed by the user, but is not yet marked
> free in the journal/on disk. If we try to reallocate that busy
> extent, we either select a different free extent to allocate, or if
> we can't find any we force the journal to disk, wait for it to
> complete (hence unbusying the extents) and retry the allocation
> again.
> 
> We can do something similar for inode allocation - it's actually a
> lockless tag lookup on the radix tree entry for the candidate inode
> number. If we find the reclaimable radix tree tag set, the we select
> a different inode. If we can't allocate a new inode, then we kick
> synchronize_rcu() and retry the allocation, allowing inodes to be
> recycled this time.
> 

I'm starting to poke around this area since it's become clear that the
currently proposed scheme just involves too much latency (unless Paul
chimes in with his expedited grace period variant, at which point I will
revisit) in the fast allocation/recycle path. ISTM so far that a simple
"skip inodes in the radix tree, sync rcu if unsuccessful" algorithm will
have pretty much the same pattern of behavior as this patch: one
synchronize_rcu() per batch.

IOW, background reclaim only kicks in after 30s by default, so the pool
of free inodes pretty much always consists of 100% reclaimable inodes.
On top of that, at smaller batch sizes, the pool tends to have a uniform
(!elapsed) grace period cookie, so a stall is required to be able to
allocate any of them. As the batch size increases, I do see the
population of free inodes start to contain a mix of expired and
non-expired grace period cookies. It's fairly easy to hack up an
internal icwalk scan to locate already expired inodes, but the problem
is that the recycle rate is so much faster than the grace period latency
that it doesn't really matter. We'll still have to stall by the time we
get to the non-expired inodes, and so we're back to one stall per batch
and the same general performance characteristic of this patch.

So given all of this, I'm wondering about something like the following
high level inode allocation algorithm:

1. If the AG has any reclaimable inodes, scan for one with an expired
grace period. If found, target that inode for physical allocation.

2. If the AG free inode count == the AG reclaimable count and we know
all reclaimable inodes are most likely pending a grace period (because
the previous step failed), allocate a new inode chunk (and target it in
this allocation).

3. If the AG free inode count > the reclaimable count, scan the finobt
for an inode that is not present in the radix tree (i.e. Dave's logic
above).

Each of those steps could involve some heuristics to maintain
predictable behavior and avoid large scans and such, but the general
idea is that the repeated alloc/free inode workload naturally populates
the AG with enough physical inodes to always be able to satisfy an
allocation without waiting on a grace period. IOW, this is effectively
similar behavior to if physical inode freeing was delayed to an rcu
callback, with the tradeoff of complicating the allocation path rather
than stalling in the inactivation pipeline. Thoughts?

This of course is more involved than this patch (or similarly simple
variants of RCU delaying preexisting bits of code) and requires some
more investigation, but certainly shouldn't be a multi-year thing. The
question is probably more of whether it's enough complexity to justify
in the meantime...

> > Are there any realistic prospects of having xfs_iget() deal with
> > reuse case by allocating new in-core inode and flipping whatever
> > references you've got in XFS journalling data structures to the
> > new copy?  If I understood what you said on IRC correctly, that is...
> 
> That's ... much harder.
> 
> One of the problems is that once an inode has a log item attached to
> it, it assumes that it can be accessed without specific locking,
> etc. see xfs_inode_clean(), for example. So there's some life-cycle
> stuff that needs to be taken care of in XFS first, and the inode <->
> log item relationship is tangled.
> 
> I've been working towards removing that tangle - but taht stuff is
> quite a distance down my logging rework patch queue. THat queue has
> been stuck now for a year trying to get the first handful of rework
> and scalability modifications reviewed and merged, so I'm not
> holding my breathe as to how long a more substantial rework of
> internal logging code will take to review and merge.
> 
> Really, though, we need the inactivation stuff to be done as part of
> the VFS inode lifecycle. I have some ideas on what to do here, but I
> suspect we'll need some changes to iput_final()/evict() to allow us
> to process final unlinks in the bakground and then call evict()
> ourselves when the unlink completes. That way ->destroy_inode() can
> just call xfs_reclaim_inode() to free it directly, which also helps
> us get rid of background inode freeing and hence inode recycling
> from XFS altogether. I think we _might_ be able to do this without
> needing to change any of the logging code in XFS, but I haven't
> looked any further than this into it as yet.
> 

... of whatever this ends up looking like.

Can you elaborate on what you mean by processing unlinks in the
background? I can see the value of being able to eliminate the recycle
code in XFS, but wouldn't we still have to limit and throttle against
background work to maintain sustained removal performance? IOW, what's
the general teardown behavior you're getting at here, aside from what
parts push into the vfs or not?

Brian

> > Again, I'm not asking if it can be done this cycle; having a
> > realistic path to doing that eventually would be fine by me.
> 
> We're talking a year at least, probably two, before we get there...
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 

