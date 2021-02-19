Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08ED5C433DB
	for <linux-xfs@archiver.kernel.org>; Fri, 19 Feb 2021 14:11:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BAC8364E67
	for <linux-xfs@archiver.kernel.org>; Fri, 19 Feb 2021 14:11:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230428AbhBSOK6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 19 Feb 2021 09:10:58 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:55174 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230014AbhBSOKw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 19 Feb 2021 09:10:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613743765;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=fUNfAf1bTnwtPxUfvue8vgbIj4xMilhsf/kxZIJu6ho=;
        b=GKCFWtPuow+geHy5AJZ2PKwJIly5Gm3wFZbPw8VdT9x9skoHPy5fKZjfhEz+TmMBV3uQyS
        zuEn/jNUrFCZSuUm4zDAVfosV80sdtcymSWOhC8XBZfB+zNgrojLJjX726Djkfc8akT8e/
        3wnSMkbmpP86EpU5rTzLEdsw7qeYEns=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-87-Zszp0C5HOfqua6tSVufSfA-1; Fri, 19 Feb 2021 09:09:23 -0500
X-MC-Unique: Zszp0C5HOfqua6tSVufSfA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1BA796D4E3;
        Fri, 19 Feb 2021 14:09:22 +0000 (UTC)
Received: from bfoster (ovpn-119-92.rdu2.redhat.com [10.10.119.92])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 9C1E260918;
        Fri, 19 Feb 2021 14:09:21 +0000 (UTC)
Date:   Fri, 19 Feb 2021 09:09:19 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: set aside allocation btree blocks from block
 reservation
Message-ID: <20210219140919.GC757814@bfoster>
References: <20210217132339.651020-1-bfoster@redhat.com>
 <20210218003451.GC4662@dread.disaster.area>
 <20210218132520.GD685651@bfoster>
 <20210219022411.GD4662@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210219022411.GD4662@dread.disaster.area>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Feb 19, 2021 at 01:24:11PM +1100, Dave Chinner wrote:
> On Thu, Feb 18, 2021 at 08:25:20AM -0500, Brian Foster wrote:
> > On Thu, Feb 18, 2021 at 11:34:51AM +1100, Dave Chinner wrote:
> > > On Wed, Feb 17, 2021 at 08:23:39AM -0500, Brian Foster wrote:
...
> 
> > > > Note that the counter uses a small percpu batch size to allow the
> > > > allocation paths to keep the primary count accurate enough that the
> > > > reservation path doesn't ever need to lock and sum the counter.
> > > > Absolute accuracy is not required here, just that the counter
> > > > reflects the majority of unavailable blocks so the reservation path
> > > > fails first.
> > > 
> > > And this makes the per-cpu counter scale almost no better than an
> > > simple atomic counter, because a spinlock requires two atomic
> > > operations (lock and unlock). Hence a batch count of 4 only reduces
> > > the atomic op count by half but introduces at lot of extra
> > > complexity. It won't make a difference to the scalability of
> > > workloads that hammer the btree block count because contention on
> > > the internal counter spinlock will occur at close to the same
> > > concurrency rate as would occur on an atomic counter.
> > > 
> > 
> > Right, but percpu_counter_read_positive() allows a fast read in the
> > xfs_mod_fdblocks() path. I didn't use an atomic because I was concerned
> > about introducing overhead in that path. If we're Ok with whatever
> > overhead an atomic read might introduce (a spin lock in the worst case
> > for some arches), then I don't mind switching over to that. I also don't
> 
> The generic definition of atomic_read() is this:
> 
> /**
>  * atomic_read - read atomic variable
>  * @v: pointer of type atomic_t
>  *
>  * Atomically reads the value of @v.
>  */
> #ifndef atomic_read
> #define atomic_read(v)  READ_ONCE((v)->counter)
> #endif
> 
> And the only arch specific implementations (x86 and arm64) both have
> the same implementation.
> 

That's the 32-bit variant, FWIW. It looks like the x86-64 and arm64
atomic64 variants are essentially the same, but the generic 64-bit
implementation is:

s64 atomic64_read(const atomic64_t *v)
{
        unsigned long flags;
        raw_spinlock_t *lock = lock_addr(v);
        s64 val;

        raw_spin_lock_irqsave(lock, flags);
        val = v->counter;
        raw_spin_unlock_irqrestore(lock, flags);
        return val;
}

Arm, powerpc, and s390 appear to have custom implementations which I
assume are more efficient than this. x86 has an arch_atomic64_read()
that falls through a maze of directives with at least a couple
underlying implementations. One appears to be atomic64_read_cx8() which
uses the cache line lock prefix thing. It's not clear to me where the
other goes, or if this ever falls back to the generic implementation..

> And percpu_counter_read_positive() is:
> 
> /*
>  * It is possible for the percpu_counter_read() to return a small negative
>  * number for some counter which should never be negative.
>  *
>  */
> static inline s64 percpu_counter_read_positive(struct percpu_counter *fbc)
> {
>         /* Prevent reloads of fbc->count */
>         s64 ret = READ_ONCE(fbc->count);
> 
>         if (ret >= 0)
>                 return ret;
>         return 0;
> }
> 
> IOWs, atomic_read() has lower read side overhead than the percpu
> counter. atomic reads do not require spinlocks or even locked memory
> accesses - they are only needed on the write side. Hence the only
> reason for using a pcp counter over an atomic is that the atomic is
> update rate bound....
> 
> FWIW, generic atomics don't use spin locks anymore - they use
> cmpxchg() which is generally much more efficient than a spin lock,
> even when emulated on platforms that don't have native support for
> cmpxchg(). And, really, we don't care one bit about performance or
> scalability on those niche platforms; all the high CPU count
> platforms where scalability matters have native atomic cmpxchg
> operations.
> 
> > mind defining a new spin lock and explicitly implementing the lockless
> > read in xfs_mod_fdblocks(), I just thought it was extra code for little
> > benefit over the percpu counter. Preference?
> 
> Spinlocks really hurt scalability in fast paths. atomics are much,
> much less hurty, and so the threshold for needing percpu counters is
> *much higher* than the threshold for needing lockless algorithms to
> avoid catastrophic lock contention.[*]
> 

As shown above, this is why I wanted to avoid introducing a spinlock on
the read side. ;) IOW, the functional behavior I was aiming for was:

update code:
	spin_lock();
	counter += delta;
	spin_unlock();

read code:
	READ_ONCE(counter);

I was initially going to pass a batch size of 0 because performance of
the update side is not important. The use of percpu was not for
scalability reasons at all. It was a somewhat lazy reuse of code to
avoid defining a new spinlock just for this.

In any event, the atomic64 read side is essentially equivalent to this
on x86-64 and arm64. If we're comfortable with the remaining custom
atomic64 implementations for other common arches (ppc64, s390x, x86,
etc.) and simply don't care enough about the additional overhead on the
arches that might fall back to the generic implementation, then that is
good enough reason to me to switch to an atomic...

Brian

> Cheers,
> 
> Dave.
> 
> [*] For example, I just added an atomic counter into
> xlog_cil_insert_items() that is incremented on every transaction
> commit (provides global ordering of items in the CIL checkpoint
> placed on per-cpu lists). With the spinlocks from the CIL commit
> path, we increase performance from 700k commits/s to 1.4 million
> commits/s on a 32p machine and only increase CPU time in
> xlog_cil_insert_items() from 1.8% to 3.3%.
> 
> IOWs, the atomic counter has almost zero overhead compared to a set
> of critical sections protected by multiple spinlocks that were
> consuming crazy amounts of CPU time.
> 
> Before, at 700,000 commits/sec:
> 
>  -   75.35%     1.83%  [kernel]            [k] xfs_log_commit_cil
>     - 46.35% xfs_log_commit_cil
>        - 41.54% _raw_spin_lock
>           - 67.30% do_raw_spin_lock
>                66.96% __pv_queued_spin_lock_slowpath
> 
> 
> After, at 1.4 million commits/sec:
> 
> -   21.78%     3.32%  [kernel]            [k] xlog_cil_commit
>    - 17.32% xlog_cil_commit
>       - 9.04% xfs_log_ticket_ungrant
>            2.22% xfs_log_space_wake
>         2.13% memcpy_erms
>       - 1.42% xfs_buf_item_committing
>          - 1.44% xfs_buf_item_release
>             - 0.63% xfs_buf_unlock
>                  0.63% up
>               0.55% xfs_buf_rele
>         1.06% xfs_inode_item_format
>         1.00% down_read
>         0.77% up_read
>         0.60% xfs_buf_item_format
> 
> You can see the atomic cmpxchg loops to update the grant heads in
> xfs_log_ticket_ungrant() is now looking like the highest contended
> cachelines in the fast path, and the CIL ctx rwsem is showing up on
> the profile, too. But there's no spin lock contention, and the
> atomics I added to the xlog_cil_commit() fast path aren't having any
> adverse impact on CPU usage at this point.
> 
> FWIW, the grant head accounting is definitely getting hot here,
> as the xfs_trans_reserve side is showing:
> 
>      7.35%     7.29%  [kernel]            [k] xlog_grant_add_space 
> 
> Which indicates at least 15% of the CPU time on this workload is now
> being spend in the grant head accounting loops. Those atomic
> counters are where I'd be considering per-cpu counters now as they
> are showing signs of contention at ~2.8 million updates/s each.
> 
> However, the reason I didn't use per-cpu counters way back when I
> made this stuff lockless was that we need an accurate sum of the
> grant head space frequently. Hence the summing cost of a per-cpu
> counter is just too great for a hot limit accounting path like this,
> so I used cmpxchg loops. PCP counters are still too expensive to sum
> accurately regularly, so if we want to support a higher transaction
> throughput rate we're going to have to get creative here.
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 

