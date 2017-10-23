Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mga05.intel.com ([192.55.52.43]:47607 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751442AbdJWK3z (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 23 Oct 2017 06:29:55 -0400
From: "Reshetova, Elena" <elena.reshetova@intel.com>
Subject: RE: [PATCH 0/5] xfs refcount conversions
Date: Mon, 23 Oct 2017 10:29:51 +0000
Message-ID: <2236FBA76BA1254E88B949DDB74E612B802B436F@IRSMSX102.ger.corp.intel.com>
References: <1508497678-10508-1-git-send-email-elena.reshetova@intel.com>
 <20171020232111.GT3666@dastard>
In-Reply-To: <20171020232111.GT3666@dastard>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: "darrick.wong@oracle.com" <darrick.wong@oracle.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>, "peterz@infradead.org" <peterz@infradead.org>, "keescook@chromium.org" <keescook@chromium.org>

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
> 
> Given these counters in XFS directly define the life cycle states
> rather than being just an object refcount, I'm pretty sure they
> rely on the implied smp_mb() that the atomic operations provide to
> work correctly.
> 
> Let me put it this way: Documentation/memory-barriers.txt breaks my
> brain.
> 
> We know atomics provide the barriers we need for the code to work
> correctly, but using anything else requires understanding the
> ordering of the new code and what Documentation/memory-barriers.txt
> says that means.
> 
> IMO, that makes it way too hard to review sanely for code that:
> 
> 	a) we already know works correctly
> 	b) has guards against reference count problems; and
> 	c) isn't performance critical, so doesn't need the
> 	   complexity of tricky memory ordering and/or barriers.
> 
> So, really, it comes down to the fact that we know refcount_t is not
> a straight drop in replacement for atomics, and that actually
> verifying the change is correct requires an in depth understanding
> of Documentation/memory-barriers.txt. IMO, that's way too much of a
> long term maintenance and knowledge burden to add to what is a
> simple set of reference counters...

Fair point. Let's see if we can change refcount_t to provide the same memory ordering
guarantees as atomics. Then you don't have to worry about things like this. 

I think this initial idea behind refcount_t was a straight replacement for atomic_t
reference counter use case plus a number of clear and understandable security guarantees
(like overflow protection).
It was indeed not supposed to make a difference in any *other* ways (and I think in most of cases
it doesn't even in the current form). But it is indeed easier to just make it provide same guarantees 
on ordering vs. trying to check every case (and make sure future users understand this too).

Let me be back that we have a joint conclusion on what to do with memory ordering. 

Best Regards,
Elena.

> 
> Cheers,
> 
> Dave.
> --
> Dave Chinner
> david@fromorbit.com
