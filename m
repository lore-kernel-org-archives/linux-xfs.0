Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:31541 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751017AbdHSBRt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 18 Aug 2017 21:17:49 -0400
Date: Fri, 18 Aug 2017 18:17:21 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [RFC 00/12] xfs: more and better verifiers
Message-ID: <20170819011721.GP4796@magnolia>
References: <150301268960.5851.2513223883233763065.stgit@magnolia>
 <20170818070516.GA15291@infradead.org>
 <20170818170607.GK4796@magnolia>
 <20170818184511.GL4796@magnolia>
 <20170819003300.GL10621@dastard>
 <20170819005816.GO4796@magnolia>
 <20170819011246.GN10621@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170819011246.GN10621@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org

On Sat, Aug 19, 2017 at 11:12:46AM +1000, Dave Chinner wrote:
> On Fri, Aug 18, 2017 at 05:58:16PM -0700, Darrick J. Wong wrote:
> > On Sat, Aug 19, 2017 at 10:33:00AM +1000, Dave Chinner wrote:
> > > On Fri, Aug 18, 2017 at 11:45:11AM -0700, Darrick J. Wong wrote:
> > > > On Fri, Aug 18, 2017 at 10:06:07AM -0700, Darrick J. Wong wrote:
> > > > > ...which is totally worthless, unless we want to compile all the verifier
> > > > > functions with __attribute__((optimize("O0"))), which is bogus.
> > > > > 
> > > > > <sigh> Back to the drawing board on that one.
> > > > 
> > > > Ok, there's /slightly/ less awful way to prevent gcc from optimizing the
> > > > verifier function to the point of imprecise pointer value, but it involves
> > > > writing to a volatile int:
> > > > 
> > > > /* stupidly prevent gcc from over-optimizing getting the instruction ptr */
> > > > extern volatile int xfs_lineno;
> > > > #define __this_address ({ __label__ __here; __here: xfs_lineno = __LINE__; &&__here; })
> > > > 
> > > > <grumble> Yucky, but it more or less works.
> > > 
> > > Can you declare the label as volatile, like you can an asm
> > > statement to prevent the compiler from optimising out asm
> > > statements?
> > > 
> > > Even so, given the yuckiness is very isolated and should only affect
> > > the slow path code, I can live with this.
> > 
> > Hmmm.  I can't declare the label as volatile, but I /can/ inject
> > asm volatile("") and that seems to prevent gcc from moving code hunks
> > around:
> > 
> > #define __this_address	({ __label__ __here; __here: asm volatile(""); &&__here; })
> 
> That seems cleaner to me, and I /think/ the gcc manual says it won't
> remove such statements, but it also says:
> 
> 	Under certain circumstances, GCC may duplicate (or remove duplicates
> 	of) your assembly code when optimizing.
> 
> So I have no real idea whether this is going to be robust or not.
> I'm not a gcc/asm expert at all (that stuff is mostly black magic
> to me).

Same here.  I figure if we start getting complaints about totally wacko
function pointers in the dmesg/xfsrepair output, we can put the
set-a-volatile-int cobwebs back in.

--D

> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
