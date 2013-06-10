Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id C9DD07F37
	for <xfs@oss.sgi.com>; Mon, 10 Jun 2013 18:42:21 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 40CFDAC003
	for <xfs@oss.sgi.com>; Mon, 10 Jun 2013 16:42:21 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	SDGw0q77BFdZXkjP for <xfs@oss.sgi.com>;
	Mon, 10 Jun 2013 16:42:19 -0700 (PDT)
Date: Tue, 11 Jun 2013 09:42:07 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: fsx failure on 3.10.0-rc1+ (xfstests 263) -- Mapped Read:
	non-zero data past EOF
Message-ID: <20130610234207.GG29376@dastard>
References: <51B5D1EB.9080200@redhat.com> <20130610213100.GC29376@dastard>
	<51B65E82.5030305@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <51B65E82.5030305@redhat.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

On Mon, Jun 10, 2013 at 07:17:22PM -0400, Brian Foster wrote:
> On 06/10/2013 05:31 PM, Dave Chinner wrote:
> > On Mon, Jun 10, 2013 at 09:17:31AM -0400, Brian Foster wrote:
> >> Hi guys,
> >>
> >> I wanted to get this onto the list... I suspect this could be
> >> similar/related to the issue reported here:
> >>
> >> http://oss.sgi.com/archives/xfs/2013-06/msg00066.html
> > 
> > Unlikely - generic/263 tests mmap IO vs direct IO, and Sage's
> > problem has neither...
> > 
> 
> Oh, Ok. I didn't look at that one closely enough then.
> 
> >> While running xfstests, the only apparent regression I hit from 3.9.0
> >> was generic/263. This test fails due to the following command (and
> >> resulting output):
> > 
> > Not a regression - 263 has been failing ever since it was introduced
> > in 2011 by:
> > 
> > commit 0d69e10ed15b01397e8c6fd7833fa3c2970ec024
> ...
> > 
> > It is testing mmap() writes vs direct IO, something that is known to
> > be fundamentally broken (i.e. racy) as mmap() page fault path does
> > not hold the XFS_IOLOCK or i_mutex in any way.  The direct IO path
> > tries to wark around this by flushing and invalidating cached pages
> > before IO submission, but the lack of locking in the page fault path
> > means we can't avoid the race entirely.
> > 
> 
> Thanks for the explanation.
> 
> >> P.S., I also came across the following thread which, if related,
> >> suggests this might be known/understood to a degree:
> >>
> >> http://oss.sgi.com/archives/xfs/2012-04/msg00703.html
> > 
> > Yup, that's potentially one aspect of it. However, have you run the
> > test code on ext3/4? it works just fine - it's only XFS that has
> > problems with this case, so it's not clear that this is a DIO
> > problem. It was never able to work out where ext3/ext4 were zeroing
> > the part of the page beyond EOF, and I couldn't ever make the DIO
> > code reliably do the right thing. It's one of the reasons that lead
> > to this discussion as LSFMM:
> > 
> > http://lwn.net/Articles/548351/
> > 
> 
> Interesting, thanks again. I did happen to run the script and the fsx
> test on the ext4 rootfs of my VM and observed expected behavior.
> 
> Note that I mentioned this was harder to reproduce with fixed alloc
> sizes less than 128k or so. I don't believe ext4 does any kind of
> speculative preallocation in the manner that XFS does. Perhaps that is a
> factor..?

Oh, it most likely is, but XFS has done speculative prealloc since,
well, forever, so this isn't a regression as such.  FWIW, the old
default for speculative prealloc was XFS_WRITEIO_LOG_LARGE (16
filesystem blocks), so this test would have failed before any of the
dynamic speculative alloc changes were made....

Indeed, if you mount with -o allocsize=4k, you'll find the test case
no longer fails - it requires allocsize=32k (or larger) to fail
here. That's not surprising, given that the test is writing across a
16k-beyond-eof boundary when it triggers the problem, and so needs a
prealloc size of >16k to trigger...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
