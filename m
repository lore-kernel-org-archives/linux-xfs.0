Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 319E8C433F5
	for <linux-xfs@archiver.kernel.org>; Sun, 20 Feb 2022 18:48:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244553AbiBTSsl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 20 Feb 2022 13:48:41 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:33170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243159AbiBTSsl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 20 Feb 2022 13:48:41 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A9F5049FBB
        for <linux-xfs@vger.kernel.org>; Sun, 20 Feb 2022 10:48:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645382895;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=hQOF9o9Ir9lLeGi1kIXbP3UrCSAhDCjR53Cx+Cl0DQA=;
        b=A86gt9WhyA8Gbwlh18sFXoA0uYgasqCbr8DZNMQu0A8pE/oExvynaxpcK03UH1b/j16PGz
        +ggvfj3lJy1cBI2Zot3qjcptV3VXTj+Ur5fJpI9b0A8E0OOvA8G6sEAC46FMMvOB7fLB8A
        W/Uc+/CqIpgBrtXOAlctt9dM/iCJLqc=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-314-444wvNQENNuseY_LQaMQ2A-1; Sun, 20 Feb 2022 13:48:14 -0500
X-MC-Unique: 444wvNQENNuseY_LQaMQ2A-1
Received: by mail-qv1-f72.google.com with SMTP id i20-20020a056214031400b0043185095fe2so2496486qvu.10
        for <linux-xfs@vger.kernel.org>; Sun, 20 Feb 2022 10:48:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=hQOF9o9Ir9lLeGi1kIXbP3UrCSAhDCjR53Cx+Cl0DQA=;
        b=pdG/Sx9OV0Wmh5/Z1auwkIyHJlDcz3zZKPqVgTvgt2pu9noRATN1JCAS6L0PE9lW58
         quezhJjW2DJiAx9UleoZEG9PSS0OSvb9zt77B8qZ/VHclSF9GjFO9xK9alK/7fGXGopt
         WK/IDNjEvPDjLQa8Bk9MPQrppKVCvU6XUZGf+d73C6uA7JzmYll/YbDzxGzY84hH/t1Y
         aUzXkmhUkEWHZx5zNYJN2neW/ZxHWZh4MsHzOkvbPVmNe3XNVPZaTQd3RMnBILgb0pk4
         u4OGGYJyz+FSrequCojVe9SEgXYCQCanCkoK4BEgqfn9dBlH94kQYT/cEHpBM9RqfOCA
         UQKA==
X-Gm-Message-State: AOAM530oLzrpHOfJveWuKmijKB4aKckhgS4/nUuGNfjwF9qQjzocypNp
        OrziapdlSKfy2pA655ltnMCC8fG0P7lxiH1TRmTfQJieFLnm3xFT4NBfpl7PPWgTs4NgBtkZ6Q8
        K079xp3HV495oFUQF3Tns
X-Received: by 2002:ad4:4e61:0:b0:42d:1b44:44c4 with SMTP id ec1-20020ad44e61000000b0042d1b4444c4mr12730940qvb.44.1645382893627;
        Sun, 20 Feb 2022 10:48:13 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzLUrBKZG+/332fT1mFQ7rUFfj7G/p24faXdH5LOdt7VaDikAltUJBir10ilt0WNBoEN4qHng==
X-Received: by 2002:ad4:4e61:0:b0:42d:1b44:44c4 with SMTP id ec1-20020ad44e61000000b0042d1b4444c4mr12730924qvb.44.1645382893237;
        Sun, 20 Feb 2022 10:48:13 -0800 (PST)
Received: from bfoster (c-24-61-119-116.hsd1.ma.comcast.net. [24.61.119.116])
        by smtp.gmail.com with ESMTPSA id w10sm30143375qtj.73.2022.02.20.10.48.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Feb 2022 10:48:12 -0800 (PST)
Date:   Sun, 20 Feb 2022 13:48:10 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH RFC 3/4] xfs: crude chunk allocation retry mechanism
Message-ID: <YhKM6u3yuF1Ek4/w@bfoster>
References: <20220217172518.3842951-1-bfoster@redhat.com>
 <20220217172518.3842951-4-bfoster@redhat.com>
 <20220217232033.GD59715@dread.disaster.area>
 <Yg+rdFRpvra8U25D@bfoster>
 <20220218225440.GE59715@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220218225440.GE59715@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Feb 19, 2022 at 09:54:40AM +1100, Dave Chinner wrote:
> On Fri, Feb 18, 2022 at 09:21:40AM -0500, Brian Foster wrote:
> > On Fri, Feb 18, 2022 at 10:20:33AM +1100, Dave Chinner wrote:
> > > On Thu, Feb 17, 2022 at 12:25:17PM -0500, Brian Foster wrote:
> > > > The free inode btree currently tracks all inode chunk records with
> > > > at least one free inode. This simplifies the chunk and allocation
> > > > selection algorithms as free inode availability can be guaranteed
> > > > after a few simple checks. This is no longer the case with busy
> > > > inode avoidance, however, because busy inode state is tracked in the
> > > > radix tree independent from physical allocation status.
> > > > 
> > > > A busy inode avoidance algorithm relies on the ability to fall back
> > > > to an inode chunk allocation one way or another in the event that
> > > > all current free inodes are busy. Hack in a crude allocation
> > > > fallback mechanism for experimental purposes. If the inode selection
> > > > algorithm is unable to locate a usable inode, allow it to return
> > > > -EAGAIN to perform another physical chunk allocation in the AG and
> > > > retry the inode allocation.
> > > > 
> > > > The current prototype can perform this allocation and retry sequence
> > > > repeatedly because a newly allocated chunk may still be covered by
> > > > busy in-core inodes in the radix tree (if it were recently freed,
> > > > for example). This is inefficient and temporary. It will be properly
> > > > mitigated by background chunk removal. This defers freeing of inode
> > > > chunk blocks from the free of the last used inode in the chunk to a
> > > > background task that only frees chunks once completely idle, thereby
> > > > providing a guarantee that a new chunk allocation always adds
> > > > non-busy inodes to the AG.
> > > 
> > > I think you can get rid of this simply by checking the radix tree
> > > tags for busy inodes at the location of the new inode chunk before
> > > we do the cluster allocation. If there are busy inodes in the range
> > > of the chunk (pure gang tag lookup, don't need to dereference any of
> > > the inodes), just skip to the next chunk offset and try that. Hence
> > > we only ever end up allocating a chunk that we know there are no
> > > busy inodes in and this retry mechanism is unnecessary.
> > > 
> > 
> > The retry mechanism exists in this series due to the factoring of the
> > inode allocation code moreso than whether the fallback is guaranteed to
> > provide a fully non-busy chunk or not. As the prototype is written, the
> > inode scan still needs to fall back at least once even with such a
> > guarantee (see my reply on the previous patch around cleaning up that
> > particular wart).
> > 
> > With regard to checking busy inode state, that is pretty much what I was
> > referring to by filtering or hinting the block allocation when we
> > discussed this on IRC. I'm explicitly trying to avoid that because for
> > one it unnecessarily spreads concern about busy inodes across layers. On
> > top of that, it assumes that there will always be some usable physical
> > block range available without busy inodes, which is not the case. That
> > means we now need to consider the fact that chunk allocation might fail
> > for reasons other than -ENOSPC and factor that into the inode allocation
> > algorithm. IOW, ISTM this just unnecessarily complicates things for
> > minimal benefit.
> 
> For the moment, if inode allocation fails because we have busy
> inodes after chunk allocation has already been done, then we are
> hitting a corner case that isn't typical fast path operation. I
> think that we should not complicate things by trying to optimise
> this case unnecessarily.
> 

Not really, it's one of the first problems I ran into with the chunk
allocation fallback in place.

> I'd just expedite reclaim using synchronize_rcu() and re-run the
> finobt scan as it will always succeed the second time because we
> haven't dropped the AGI log and all freed inodes have now passed
> through a grace period. Indeed, we need this expedited reclaim path
> anyway because if we fail to allocate a new chunk and there are busy
> inodes, we need to wait for busy inodes to become unbusy to avoid
> premature ENOSPC while there are still avaialbe free inodes.
> 

My experiments to this point suggest that would be extremely slow, to
the point where there's not much value to anything beyond patch 1. The
finobt is going to be relatively small with any sort of mixed alloc/free
workload as records cycle in and out, so a "sync per batch" is
effectively the behavior I already see with patch 1 alone and it's a
performance killer (with non-expedited grace periods, at least). We do
need the rcu sync -ENOSPC fallback as you say, but IMO it should be a
last resort.

> In the case of the updated inode lifecycle stuff I'm working on, a
> log force will replace the synchronise_rcu() call because the inodes
> will be XFS_ISTALE and journal IO completion of the cluster buffers
> will trigger the inodes to be reclaimed immediately as writeback is
> elided for XFS_ISTALE inodes. We may need an AIL push in other
> cases, but I'll cross that river when I get to it.
> 

Ok.

> > The point of background freeing inode chunks was that it makes this
> > problem go away because then we ensure that inode chunks aren't freed
> > until all associated busy inodes are cleared, and so we preserve the
> > historical behavior that an inode chunk allocation guarantees immediate
> > ability to allocate an inode. I thought we agreed in the previous
> > discussion that this was the right approach since it seemed to be in the
> > long term direction for XFS anyways.. hm?
> 
> Long term, yes, but we need something that works effectively and
> efficiently now, with minimal additional overhead, because we're
> going to have to live with this code in the allocation fast path for
> some time yet.
> 

Right, but I thought this is why we were only going to do the background
freeing part of the whole "background inode management" thing?

Short of that, I'm not aware of a really great option atm. IMO, pushing
explicit busy inode state/checking down into the block allocator is kind
of a gross layering violation. The approach this series currently uses
is simple and effective, but it's an unbound retry mechanism that just
continues to allocate chunks until we get one we can use, which is too
crude for production.

Perhaps a simple enough short term option is to use the existing block
alloc min/max range mechanisms (as mentioned on IRC). For example:

- Use the existing min/max_agbno allocation arg input values to attempt
  one or two chunk allocs outside of the known range of busy inodes for
  the AG (i.e., allocate blocks higher than the max busy agino or lower
  than the min busy agino).
- If success, then we know we've got a chunk w/o busy inodes.
- If failure, fall back to the existing chunk alloc calls, take whatever
  we get and retry the finobt scan (perhaps more aggressively checking
  each record) hoping we got a usable new record.
- If that still fails, then fall back to synchronize_rcu() as a last
  resort and grab one of the previously busy inodes.

I couldn't say for sure if that would be effective enough without
playing with it a bit, but that would sort of emulate an algorithm that
filtered chunk block allocations with at least one busy inode without
having to modify block allocation code. If it avoids an RCU sync in the
majority of cases it might be effective enough as a stopgap until
background freeing exists. Thoughts?

> Really, I want foreground inode allocation to know nothing about
> inode chunk allocation. If there are no inodes available for
> allocation, it kicks background inode chunk management and sleeps
> waiting for to be given an allocated inode it can use. It shouldn't
> even have to know about busy inodes - just work from an in-memory
> per-ag free list of inode numbers that can be immediately allocated.
> 
> In this situation, inodes that have been recently unlinked don't
> show up on that list until they can be reallocated safely. This
> is all managed asynchronously in the background by the inodegc state
> machine (what I'm currently working on) and when the inode is
> finally reclaimed it is moved into the free list and allowed to be
> reallocated.
> 

I think that makes a lot of sense. That's quite similar to another
experiment I was playing with that essentially populated a capped size
pool of background inactivated inodes that the allocation side could
pull directly from (i.e., so allocation actually becomes a radix tree
lookup instead of a filtered btree scan), but so far I was kind of
fighting with the existing mechanisms, trying not to peturb sustained
remove performance, etc., and hadn't been able to produce a performance
benefit yet. Perhaps this will work out better with the bigger picture
changes to inode lifecycle and background inode management in place..

Brian

> IOWs, the long term direction is to make sure that the
> foreground inode allocator doesn't even know about the existence of
> busy inodes and it gets faster and simpler as we push all the mess
> into the background that runs all the slow path allocation and
> freeing algorithms.
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 

