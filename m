Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:10061 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752653AbdJTXVO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 20 Oct 2017 19:21:14 -0400
Date: Sat, 21 Oct 2017 10:21:11 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 0/5] xfs refcount conversions
Message-ID: <20171020232111.GT3666@dastard>
References: <1508497678-10508-1-git-send-email-elena.reshetova@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1508497678-10508-1-git-send-email-elena.reshetova@intel.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Elena Reshetova <elena.reshetova@intel.com>
Cc: darrick.wong@oracle.com, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, peterz@infradead.org, keescook@chromium.org

On Fri, Oct 20, 2017 at 02:07:53PM +0300, Elena Reshetova wrote:
> Note: our previous thread didn't finish in any conclusion, so
> I am resending this now (rebased at latest linux-next) to revive
> the discussion. refcount_t is slowly becoming a standard for
> refcounters and we would really like to make all conversions
> done where it is applicable.

In a separate "replace atomics with refcounts" discussion, the
ordering guarantees of refcounts was raised:

https://lkml.org/lkml/2017/9/4/206

i.e. refcounts use weak ordering whilst atomics imply a smp_mb()
operation was performed.

Given these counters in XFS directly define the life cycle states
rather than being just an object refcount, I'm pretty sure they
rely on the implied smp_mb() that the atomic operations provide to
work correctly.

Let me put it this way: Documentation/memory-barriers.txt breaks my
brain.

We know atomics provide the barriers we need for the code to work
correctly, but using anything else requires understanding the
ordering of the new code and what Documentation/memory-barriers.txt
says that means.

IMO, that makes it way too hard to review sanely for code that:

	a) we already know works correctly
	b) has guards against reference count problems; and
	c) isn't performance critical, so doesn't need the
	   complexity of tricky memory ordering and/or barriers.

So, really, it comes down to the fact that we know refcount_t is not
a straight drop in replacement for atomics, and that actually
verifying the change is correct requires an in depth understanding
of Documentation/memory-barriers.txt. IMO, that's way too much of a
long term maintenance and knowledge burden to add to what is a
simple set of reference counters...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
