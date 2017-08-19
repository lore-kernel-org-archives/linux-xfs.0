Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:21425 "EHLO
        ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752021AbdHSXUO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 19 Aug 2017 19:20:14 -0400
Date: Sun, 20 Aug 2017 09:20:10 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [RFC 00/12] xfs: more and better verifiers
Message-ID: <20170819232010.GO10621@dastard>
References: <150301268960.5851.2513223883233763065.stgit@magnolia>
 <20170818070516.GA15291@infradead.org>
 <20170818170607.GK4796@magnolia>
 <20170818184511.GL4796@magnolia>
 <20170819003300.GL10621@dastard>
 <20170819005816.GO4796@magnolia>
 <20170819011246.GN10621@dastard>
 <20170819011721.GP4796@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170819011721.GP4796@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org

On Fri, Aug 18, 2017 at 06:17:21PM -0700, Darrick J. Wong wrote:
> On Sat, Aug 19, 2017 at 11:12:46AM +1000, Dave Chinner wrote:
> > On Fri, Aug 18, 2017 at 05:58:16PM -0700, Darrick J. Wong wrote:
> > > On Sat, Aug 19, 2017 at 10:33:00AM +1000, Dave Chinner wrote:
> > > > On Fri, Aug 18, 2017 at 11:45:11AM -0700, Darrick J. Wong wrote:
> > > > > On Fri, Aug 18, 2017 at 10:06:07AM -0700, Darrick J. Wong wrote:
> > > > > > ...which is totally worthless, unless we want to compile all the verifier
> > > > > > functions with __attribute__((optimize("O0"))), which is bogus.
> > > > > > 
> > > > > > <sigh> Back to the drawing board on that one.
> > > > > 
> > > > > Ok, there's /slightly/ less awful way to prevent gcc from optimizing the
> > > > > verifier function to the point of imprecise pointer value, but it involves
> > > > > writing to a volatile int:
> > > > > 
> > > > > /* stupidly prevent gcc from over-optimizing getting the instruction ptr */
> > > > > extern volatile int xfs_lineno;
> > > > > #define __this_address ({ __label__ __here; __here: xfs_lineno = __LINE__; &&__here; })
> > > > > 
> > > > > <grumble> Yucky, but it more or less works.
> > > > 
> > > > Can you declare the label as volatile, like you can an asm
> > > > statement to prevent the compiler from optimising out asm
> > > > statements?
> > > > 
> > > > Even so, given the yuckiness is very isolated and should only affect
> > > > the slow path code, I can live with this.
> > > 
> > > Hmmm.  I can't declare the label as volatile, but I /can/ inject
> > > asm volatile("") and that seems to prevent gcc from moving code hunks
> > > around:
> > > 
> > > #define __this_address	({ __label__ __here; __here: asm volatile(""); &&__here; })
> > 
> > That seems cleaner to me, and I /think/ the gcc manual says it won't
> > remove such statements, but it also says:
> > 
> > 	Under certain circumstances, GCC may duplicate (or remove duplicates
> > 	of) your assembly code when optimizing.
> > 
> > So I have no real idea whether this is going to be robust or not.
> > I'm not a gcc/asm expert at all (that stuff is mostly black magic
> > to me).
> 
> Same here.  I figure if we start getting complaints about totally wacko
> function pointers in the dmesg/xfsrepair output, we can put the
> set-a-volatile-int cobwebs back in.

Doh, it's taking me longer to remember things I forgot 10+ years ago
these days...

>From include/linux/gcc-compiler.h:

/* Optimization barrier */

/* The "volatile" is due to gcc bugs */
#define barrier() __asm__ __volatile__("": : :"memory")

So I think we can just dump a barrier() call in the macro and it
should work without us having to care about it. Still need a comment
to explain why the barrier is there, though...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
