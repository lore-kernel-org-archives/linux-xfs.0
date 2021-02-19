Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 280BFC433DB
	for <linux-xfs@archiver.kernel.org>; Fri, 19 Feb 2021 21:29:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DD907614A7
	for <linux-xfs@archiver.kernel.org>; Fri, 19 Feb 2021 21:29:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229649AbhBSV3x (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 19 Feb 2021 16:29:53 -0500
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:39456 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229553AbhBSV3w (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 19 Feb 2021 16:29:52 -0500
Received: from dread.disaster.area (pa49-179-130-210.pa.nsw.optusnet.com.au [49.179.130.210])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id A343A1040B99;
        Sat, 20 Feb 2021 08:29:00 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lDDKd-00Cawd-HG; Sat, 20 Feb 2021 08:28:59 +1100
Date:   Sat, 20 Feb 2021 08:28:59 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: set aside allocation btree blocks from block
 reservation
Message-ID: <20210219212859.GI4662@dread.disaster.area>
References: <20210217132339.651020-1-bfoster@redhat.com>
 <20210218003451.GC4662@dread.disaster.area>
 <20210218132520.GD685651@bfoster>
 <20210219022411.GD4662@dread.disaster.area>
 <20210219140919.GC757814@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210219140919.GC757814@bfoster>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=Tu+Yewfh c=1 sm=1 tr=0 cx=a_idp_d
        a=JD06eNgDs9tuHP7JIKoLzw==:117 a=JD06eNgDs9tuHP7JIKoLzw==:17
        a=kj9zAlcOel0A:10 a=qa6Q16uM49sA:10 a=7-415B0cAAAA:8
        a=GidzjyWy6BG75MDhbGsA:9 a=CjuIK1q_8ugA:10 a=igBNqPyMv6gA:10
        a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Feb 19, 2021 at 09:09:19AM -0500, Brian Foster wrote:
> On Fri, Feb 19, 2021 at 01:24:11PM +1100, Dave Chinner wrote:
> > On Thu, Feb 18, 2021 at 08:25:20AM -0500, Brian Foster wrote:
> > > On Thu, Feb 18, 2021 at 11:34:51AM +1100, Dave Chinner wrote:
> > > > On Wed, Feb 17, 2021 at 08:23:39AM -0500, Brian Foster wrote:
> ...
> > 
> > > > > Note that the counter uses a small percpu batch size to allow the
> > > > > allocation paths to keep the primary count accurate enough that the
> > > > > reservation path doesn't ever need to lock and sum the counter.
> > > > > Absolute accuracy is not required here, just that the counter
> > > > > reflects the majority of unavailable blocks so the reservation path
> > > > > fails first.
> > > > 
> > > > And this makes the per-cpu counter scale almost no better than an
> > > > simple atomic counter, because a spinlock requires two atomic
> > > > operations (lock and unlock). Hence a batch count of 4 only reduces
> > > > the atomic op count by half but introduces at lot of extra
> > > > complexity. It won't make a difference to the scalability of
> > > > workloads that hammer the btree block count because contention on
> > > > the internal counter spinlock will occur at close to the same
> > > > concurrency rate as would occur on an atomic counter.
> > > > 
> > > 
> > > Right, but percpu_counter_read_positive() allows a fast read in the
> > > xfs_mod_fdblocks() path. I didn't use an atomic because I was concerned
> > > about introducing overhead in that path. If we're Ok with whatever
> > > overhead an atomic read might introduce (a spin lock in the worst case
> > > for some arches), then I don't mind switching over to that. I also don't
> > 
> > The generic definition of atomic_read() is this:
> > 
> > /**
> >  * atomic_read - read atomic variable
> >  * @v: pointer of type atomic_t
> >  *
> >  * Atomically reads the value of @v.
> >  */
> > #ifndef atomic_read
> > #define atomic_read(v)  READ_ONCE((v)->counter)
> > #endif
> > 
> > And the only arch specific implementations (x86 and arm64) both have
> > the same implementation.
> > 
> 
> That's the 32-bit variant, FWIW. It looks like the x86-64 and arm64
> atomic64 variants are essentially the same, but the generic 64-bit
> implementation is:
> 
> s64 atomic64_read(const atomic64_t *v)
> {
>         unsigned long flags;
>         raw_spinlock_t *lock = lock_addr(v);
>         s64 val;
> 
>         raw_spin_lock_irqsave(lock, flags);
>         val = v->counter;
>         raw_spin_unlock_irqrestore(lock, flags);
>         return val;
> }

That's necessary for generic 32 bit platforms that may do two 32 bit
ops to store a 64 bit val. This is why xfs_trans_ail_copy_lsn()
exists - to be able to do atomic read and store of an lsn on a 32
bit platform so we don't get a bad LSN from a torn 32 bit loads.

But we *just don't care* about scalability on 32 bit platforms -
they just don't have the CPU count for this to matter one bit to
performancer. And if you worry about scaling down then the spin lock
goes away for all the single CPU 32 bit platforms, too.

> Arm, powerpc, and s390 appear to have custom implementations which I
> assume are more efficient than this.

Yes, they are much more efficient than spinlocks. All the 64bit CPU
platforms essentially boil down to a single load instruction on the
read side.  This is documented in Documentation/atomic_t.txt:

SEMANTICS
---------

Non-RMW ops:

The non-RMW ops are (typically) regular LOADs and STOREs and are canonically
implemented using READ_ONCE(), WRITE_ONCE(), smp_load_acquire() and
smp_store_release() respectively. Therefore, if you find yourself only using
the Non-RMW operations of atomic_t, you do not in fact need atomic_t at all
and are doing it wrong.
.....


> x86 has an arch_atomic64_read() that falls through a maze of
> directives with at least a couple underlying implementations.  One
> appears to be atomic64_read_cx8() which uses the cache line lock
> prefix thing. It's not clear to me where the other goes, or if
> this ever falls back to the generic implementation..

arch/x86/include/asm/atomic64_64.h version is the one that is used
on 64 bit CPUs and hence the only one we care about. It is
READ_ONCE(v->counter)...

The atomic64_32.h header is for 32 bit CPUs and only some of them
support the cmpxchg8 which is an atomic 8 byte cmpxchg. That's still
faster and more efficient than a spin lock. The oldest of the x86
cpus fall back to some else, but we *really* don't care about 25+
year old 32 bit CPUs...

> > Spinlocks really hurt scalability in fast paths. atomics are much,
> > much less hurty, and so the threshold for needing percpu counters is
> > *much higher* than the threshold for needing lockless algorithms to
> > avoid catastrophic lock contention.[*]
> > 
> 
> As shown above, this is why I wanted to avoid introducing a spinlock on
> the read side. ;) IOW, the functional behavior I was aiming for was:
> 
> update code:
> 	spin_lock();
> 	counter += delta;
> 	spin_unlock();
> 
> read code:
> 	READ_ONCE(counter);

Which is simply atomic64_add(cnt, delta); and atomic64_read(cnt);

> I was initially going to pass a batch size of 0 because performance of
> the update side is not important. The use of percpu was not for
> scalability reasons at all. It was a somewhat lazy reuse of code to
> avoid defining a new spinlock just for this.

This is what atomics are for.

> In any event, the atomic64 read side is essentially equivalent to this
> on x86-64 and arm64. If we're comfortable with the remaining custom
> atomic64 implementations for other common arches (ppc64, s390x, x86,
> etc.) and simply don't care enough about the additional overhead on the
> arches that might fall back to the generic implementation, then that is
> good enough reason to me to switch to an atomic...

We've been comfortable with these for well over a decade. That is,
we use atomic64 heavily in the lockless grant head and log tail
accounting algorithms, which are the the hottest accounting paths in
the transaction subsystem. They are the counters I pointed out were
only just starting to show scalability issues at 2.8 million updates
a second in my last email...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
