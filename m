Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:34826 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932093AbdJWNl5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 23 Oct 2017 09:41:57 -0400
Date: Mon, 23 Oct 2017 15:41:49 +0200
From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 0/5] xfs refcount conversions
Message-ID: <20171023134149.GD3165@worktop.lehotels.local>
References: <1508497678-10508-1-git-send-email-elena.reshetova@intel.com>
 <20171020232111.GT3666@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171020232111.GT3666@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Elena Reshetova <elena.reshetova@intel.com>, darrick.wong@oracle.com, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, keescook@chromium.org

On Sat, Oct 21, 2017 at 10:21:11AM +1100, Dave Chinner wrote:
> On Fri, Oct 20, 2017 at 02:07:53PM +0300, Elena Reshetova wrote:
> > Note: our previous thread didn't finish in any conclusion, so
> > I am resending this now (rebased at latest linux-next) to revive
> > the discussion. refcount_t is slowly becoming a standard for
> > refcounters and we would really like to make all conversions
> > done where it is applicable.
> 
> In a separate "replace atomics with refcounts" discussion, the
> ordering guarantees of refcounts was raised:
> 
> https://lkml.org/lkml/2017/9/4/206
> 
> i.e. refcounts use weak ordering whilst atomics imply a smp_mb()
> operation was performed.

_some_ atomics. atomic_inc() does not for example.

> Given these counters in XFS directly define the life cycle states
> rather than being just an object refcount, I'm pretty sure they
> rely on the implied smp_mb() that the atomic operations provide to
> work correctly.

If you rely on more ordering than implied by refocunting, it would be
very good to document that in any case.

> Let me put it this way: Documentation/memory-barriers.txt breaks my
> brain.

It does that.. however,

> IMO, that makes it way too hard to review sanely for code that:
> 
> 	a) we already know works correctly

But how do you know if you have unknown ordering requirements?

> So, really, it comes down to the fact that we know refcount_t is not
> a straight drop in replacement for atomics, and that actually
> verifying the change is correct requires an in depth understanding
> of Documentation/memory-barriers.txt. IMO, that's way too much of a
> long term maintenance and knowledge burden to add to what is a
> simple set of reference counters...

So I feel that any object should imply the minimal amount of barriers
required for its correct functioning and no more. We're not adding
random barriers to spin_lock() either, just because it might 'fix'
something unrelated.

refcount_t has sufficient barriers for the concept of refcounting, that
is, refcount_dec_and_test() is a RELEASE, this means that all our object
accesses happen-before we drop the reference to our object (common
sense, touching an object after you drop its reference is UAF).

If you rely on anything else; you want that documented.

Note that you can upgrade your refcount_dec_and_test() with
smp_mb__{before,after}_atomic() where needed.


