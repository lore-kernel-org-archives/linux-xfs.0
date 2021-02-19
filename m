Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 709BDC433DB
	for <linux-xfs@archiver.kernel.org>; Fri, 19 Feb 2021 02:25:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0EB8764ECE
	for <linux-xfs@archiver.kernel.org>; Fri, 19 Feb 2021 02:25:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229471AbhBSCY5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 18 Feb 2021 21:24:57 -0500
Received: from mail106.syd.optusnet.com.au ([211.29.132.42]:55793 "EHLO
        mail106.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229468AbhBSCY4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 18 Feb 2021 21:24:56 -0500
Received: from dread.disaster.area (pa49-179-130-210.pa.nsw.optusnet.com.au [49.179.130.210])
        by mail106.syd.optusnet.com.au (Postfix) with ESMTPS id 81E934EC75C;
        Fri, 19 Feb 2021 13:24:12 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lCvSl-00BMUX-2y; Fri, 19 Feb 2021 13:24:11 +1100
Date:   Fri, 19 Feb 2021 13:24:11 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: set aside allocation btree blocks from block
 reservation
Message-ID: <20210219022411.GD4662@dread.disaster.area>
References: <20210217132339.651020-1-bfoster@redhat.com>
 <20210218003451.GC4662@dread.disaster.area>
 <20210218132520.GD685651@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210218132520.GD685651@bfoster>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=F8MpiZpN c=1 sm=1 tr=0 cx=a_idp_d
        a=JD06eNgDs9tuHP7JIKoLzw==:117 a=JD06eNgDs9tuHP7JIKoLzw==:17
        a=kj9zAlcOel0A:10 a=qa6Q16uM49sA:10 a=7-415B0cAAAA:8
        a=NAWtXMCIp-F5qUBBsCMA:9 a=7jz1wD0oDIKR1GSH:21 a=2uMXh6LdSuaZHuh-:21
        a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Feb 18, 2021 at 08:25:20AM -0500, Brian Foster wrote:
> On Thu, Feb 18, 2021 at 11:34:51AM +1100, Dave Chinner wrote:
> > On Wed, Feb 17, 2021 at 08:23:39AM -0500, Brian Foster wrote:
> > > The blocks used for allocation btrees (bnobt and countbt) are
> > > technically considered free space. This is because as free space is
> > > used, allocbt blocks are removed and naturally become available for
> > > traditional allocation. However, this means that a significant
> > > portion of free space may consist of in-use btree blocks if free
> > > space is severely fragmented.
> > > 
> > > On large filesystems with large perag reservations, this can lead to
> > > a rare but nasty condition where a significant amount of physical
> > > free space is available, but the majority of actual usable blocks
> > > consist of in-use allocbt blocks. We have a record of a (~12TB, 32
> > > AG) filesystem with multiple AGs in a state with ~2.5GB or so free
> > > blocks tracked across ~300 total allocbt blocks, but effectively at
> > > 100% full because the the free space is entirely consumed by
> > > refcountbt perag reservation.
> > > 
> > > Such a large perag reservation is by design on large filesystems.
> > > The problem is that because the free space is so fragmented, this AG
> > > contributes the 300 or so allocbt blocks to the global counters as
> > > free space. If this pattern repeats across enough AGs, the
> > > filesystem lands in a state where global block reservation can
> > > outrun physical block availability. For example, a streaming
> > > buffered write on the affected filesystem continues to allow delayed
> > > allocation beyond the point where writeback starts to fail due to
> > > physical block allocation failures. The expected behavior is for the
> > > delalloc block reservation to fail gracefully with -ENOSPC before
> > > physical block allocation failure is a possibility.
> > 
> > *nod*
> > 
> > > To address this problem, introduce a percpu counter to track the sum
> > > of the allocbt block counters already tracked in the AGF. Use the
> > > new counter to set these blocks aside at reservation time and thus
> > > ensure they cannot be allocated until truly available. Since this is
> > > only necessary when large reflink perag reservations are in place
> > > and the counter requires a read of each AGF to fully populate, only
> > > enforce on reflink enabled filesystems. This allows initialization
> > > of the counter at ->pagf_init time because the refcountbt perag
> > > reservation init code reads each AGF at mount time.
> > 
> > Ok, so the mechanism sounds ok, but a per-cpu counter seems like
> > premature optimisation. How often are we really updating btree block
> > counts? An atomic counter is good for at least a million updates a
> > second across a 2 socket 32p machine, and I highly doubt we're
> > incrementing/decrementing btree block counts that often on such a
> > machine. 
> > 
> > While per-cpu counters have a fast write side, they come with
> > additional algorithmic complexity. Hence if the update rate of the
> > counter is not fast enough to need per-cpu counters, we should avoid
> > them. just because other free space counters use per-cpu counters,
> > it doesn't mean everything in that path needs to use them...
> > 
> 
> The use of the percpu counter was more for the read side than the write
> side. I think of it more of an abstraction to avoid having to open code
> and define a new spin lock just for this. I actually waffled a bit on
> just setting a batch count of 0 to get roughly equivalent behavior, but
> didn't think it would make much difference.

That doesn't make much sense to me. percpu counters are not for
avoiding spinlocks for stand alone counters - that's what atomic
counters are for. percpu counters are for replacing atomic counters
when they run out of scalability, not spin locks.

> > > Note that the counter uses a small percpu batch size to allow the
> > > allocation paths to keep the primary count accurate enough that the
> > > reservation path doesn't ever need to lock and sum the counter.
> > > Absolute accuracy is not required here, just that the counter
> > > reflects the majority of unavailable blocks so the reservation path
> > > fails first.
> > 
> > And this makes the per-cpu counter scale almost no better than an
> > simple atomic counter, because a spinlock requires two atomic
> > operations (lock and unlock). Hence a batch count of 4 only reduces
> > the atomic op count by half but introduces at lot of extra
> > complexity. It won't make a difference to the scalability of
> > workloads that hammer the btree block count because contention on
> > the internal counter spinlock will occur at close to the same
> > concurrency rate as would occur on an atomic counter.
> > 
> 
> Right, but percpu_counter_read_positive() allows a fast read in the
> xfs_mod_fdblocks() path. I didn't use an atomic because I was concerned
> about introducing overhead in that path. If we're Ok with whatever
> overhead an atomic read might introduce (a spin lock in the worst case
> for some arches), then I don't mind switching over to that. I also don't

The generic definition of atomic_read() is this:

/**
 * atomic_read - read atomic variable
 * @v: pointer of type atomic_t
 *
 * Atomically reads the value of @v.
 */
#ifndef atomic_read
#define atomic_read(v)  READ_ONCE((v)->counter)
#endif

And the only arch specific implementations (x86 and arm64) both have
the same implementation.

And percpu_counter_read_positive() is:

/*
 * It is possible for the percpu_counter_read() to return a small negative
 * number for some counter which should never be negative.
 *
 */
static inline s64 percpu_counter_read_positive(struct percpu_counter *fbc)
{
        /* Prevent reloads of fbc->count */
        s64 ret = READ_ONCE(fbc->count);

        if (ret >= 0)
                return ret;
        return 0;
}

IOWs, atomic_read() has lower read side overhead than the percpu
counter. atomic reads do not require spinlocks or even locked memory
accesses - they are only needed on the write side. Hence the only
reason for using a pcp counter over an atomic is that the atomic is
update rate bound....

FWIW, generic atomics don't use spin locks anymore - they use
cmpxchg() which is generally much more efficient than a spin lock,
even when emulated on platforms that don't have native support for
cmpxchg(). And, really, we don't care one bit about performance or
scalability on those niche platforms; all the high CPU count
platforms where scalability matters have native atomic cmpxchg
operations.

> mind defining a new spin lock and explicitly implementing the lockless
> read in xfs_mod_fdblocks(), I just thought it was extra code for little
> benefit over the percpu counter. Preference?

Spinlocks really hurt scalability in fast paths. atomics are much,
much less hurty, and so the threshold for needing percpu counters is
*much higher* than the threshold for needing lockless algorithms to
avoid catastrophic lock contention.[*]

Cheers,

Dave.

[*] For example, I just added an atomic counter into
xlog_cil_insert_items() that is incremented on every transaction
commit (provides global ordering of items in the CIL checkpoint
placed on per-cpu lists). With the spinlocks from the CIL commit
path, we increase performance from 700k commits/s to 1.4 million
commits/s on a 32p machine and only increase CPU time in
xlog_cil_insert_items() from 1.8% to 3.3%.

IOWs, the atomic counter has almost zero overhead compared to a set
of critical sections protected by multiple spinlocks that were
consuming crazy amounts of CPU time.

Before, at 700,000 commits/sec:

 -   75.35%     1.83%  [kernel]            [k] xfs_log_commit_cil
    - 46.35% xfs_log_commit_cil
       - 41.54% _raw_spin_lock
          - 67.30% do_raw_spin_lock
               66.96% __pv_queued_spin_lock_slowpath


After, at 1.4 million commits/sec:

-   21.78%     3.32%  [kernel]            [k] xlog_cil_commit
   - 17.32% xlog_cil_commit
      - 9.04% xfs_log_ticket_ungrant
           2.22% xfs_log_space_wake
        2.13% memcpy_erms
      - 1.42% xfs_buf_item_committing
         - 1.44% xfs_buf_item_release
            - 0.63% xfs_buf_unlock
                 0.63% up
              0.55% xfs_buf_rele
        1.06% xfs_inode_item_format
        1.00% down_read
        0.77% up_read
        0.60% xfs_buf_item_format

You can see the atomic cmpxchg loops to update the grant heads in
xfs_log_ticket_ungrant() is now looking like the highest contended
cachelines in the fast path, and the CIL ctx rwsem is showing up on
the profile, too. But there's no spin lock contention, and the
atomics I added to the xlog_cil_commit() fast path aren't having any
adverse impact on CPU usage at this point.

FWIW, the grant head accounting is definitely getting hot here,
as the xfs_trans_reserve side is showing:

     7.35%     7.29%  [kernel]            [k] xlog_grant_add_space 

Which indicates at least 15% of the CPU time on this workload is now
being spend in the grant head accounting loops. Those atomic
counters are where I'd be considering per-cpu counters now as they
are showing signs of contention at ~2.8 million updates/s each.

However, the reason I didn't use per-cpu counters way back when I
made this stuff lockless was that we need an accurate sum of the
grant head space frequently. Hence the summing cost of a per-cpu
counter is just too great for a hot limit accounting path like this,
so I used cmpxchg loops. PCP counters are still too expensive to sum
accurately regularly, so if we want to support a higher transaction
throughput rate we're going to have to get creative here.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
