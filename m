Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q8OHaAxu188078 for <xfs@oss.sgi.com>; Mon, 24 Sep 2012 12:36:10 -0500
Date: Mon, 24 Sep 2012 12:37:23 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 1/3] xfs: restrict allocate worker to x86_64
Message-ID: <20120924173723.GH1140@sgi.com>
References: <20120919163133.097340199@sgi.com>
	<20120919163145.367256258@sgi.com> <20120919215405.GE31501@dastard>
	<505B546A.6070105@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <505B546A.6070105@sgi.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Mark Tinguely <tinguely@sgi.com>
Cc: xfs@oss.sgi.com

Hey,

On Thu, Sep 20, 2012 at 12:37:46PM -0500, Mark Tinguely wrote:
> On 09/19/12 16:54, Dave Chinner wrote:
> >On Wed, Sep 19, 2012 at 11:31:34AM -0500, tinguely@sgi.com wrote:
> >>Restrict the allocation worker to X86_64 machines. This will improve
> >>performance on non-X86-64 machines and avoid the AGF buffer hang.
> >>
> >>Signed-off-by: Mark Tinguely<tinguely@sgi.com>
> >
> >NACK.
> >
> >The stack overflow problems that this works around are not limited
> >to x86-64. In the past we've seen overflows on i686 (even with 8k
> >stacks), s390 and other platforms, so it's not an isolated issue.
> >
> >It either works or it doesn't - let's not start down the rathole of
> >having different code paths and behaviours for different platforms.
> >
> >Cheers,
> >
> >Dave.
> 
> Well, I was expecting a 4 letter word from Dave on this patch and
> "NACK" was surprisingly mild.
> 
> When the allocation worker was placed into XFS, even Christoph
> wanted a kernel configure switch to be able turn it off.
> 
> Dave has already placed a switch in the code that turns it off for
> over half of the direct callers xfs_alloc_vextent() because a
> performance issue.
> 
> We are just finding places where it causes serious issues.
> 
> This is worker is an "necessary evil" (I think those were
> Christoph's review comment). We should limit the evil to where it is
> necessary.

I tend to agree that it is undesireble to have platform specific behaviors in
XFS.  Dave has a good point.  Mark and Christoph also have valid points.

This is a platform specific problem so it's reasonable that the solution can be
platform specific too.  If the list of platforms which are broken by having so
little stack available in the kernel is larger than we'd like... well that's
unfortunate.  But it's not something we're the cause of, and it speaks to how
important it is to fix the more general problem.

We shouldn't penalize those who are using platforms which are not affected by
this problem for the limitations of the other platforms.  OTOH, if we have
multiple behaviors our testing becomes more difficult.  Nobody wins.

I think it is desireable to be able to turn this off so that users can choose
how they prefer to lose, and so that this hack continues to be easily removable
if the time ever comes when we can do so.

-Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
