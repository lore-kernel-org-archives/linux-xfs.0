Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 01DFE7F47
	for <xfs@oss.sgi.com>; Thu, 12 Jun 2014 18:29:07 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id CEE02304039
	for <xfs@oss.sgi.com>; Thu, 12 Jun 2014 16:29:03 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	oOSIKEsg0lcTHtLr for <xfs@oss.sgi.com>;
	Thu, 12 Jun 2014 16:29:01 -0700 (PDT)
Date: Fri, 13 Jun 2014 09:28:47 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [DISCUSS] Planning for new dev cycle (3.17)
Message-ID: <20140612232847.GS9508@dastard>
References: <20140609223320.GE9508@dastard>
	<20140610115857.GC46344@bfoster.bfoster>
	<20140610214850.GH9508@dastard> <20140611091020.GO4453@dastard>
	<20140612200139.GD3148@laptop.bfoster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140612200139.GD3148@laptop.bfoster>
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

On Thu, Jun 12, 2014 at 04:01:41PM -0400, Brian Foster wrote:
> On Wed, Jun 11, 2014 at 07:10:20PM +1000, Dave Chinner wrote:
> > On Wed, Jun 11, 2014 at 07:48:50AM +1000, Dave Chinner wrote:
> > > On Tue, Jun 10, 2014 at 07:58:57AM -0400, Brian Foster wrote:
> > > > On Tue, Jun 10, 2014 at 08:33:20AM +1000, Dave Chinner wrote:
> > > > > The issue is the negative error number patchset, and how to handle
> > > > > review and testing. The patchset is already 62 patches long and it
> > > > > converts roughly half the code base. It'll take me another couple of
> > > > > days to convert the rest of the code, and that will probably take
> > > > > another 60 patches.
> > > > > 
> > > > > I understand that reviewing 100+ patches is going to be a pain, but
> > > > > each patch currently averages about +/- 10 lines. The current
> > > > > diffstat is:
> > > > > 
> > > > > 	37 files changed, 723 insertions(+), 722 deletions(-)
> > > > > 
> > > > > And that will probably double, so it's still going to be a fair
> > > > > amount of change.
> > > > 
> > > > Is there any sort of more coarse logical breakdown of this series, or do
> > > > we want/need to convert the entire codebase all at once? The individual
> > > > patches sound relatively small... is there a particular method at play
> > > > there? E.g., a patch per function? file? call chain?
> > > 
> > > I'm doing it layer by layer, starting from the linux interface
> > > layers and working my way down. e.g. fs/xfs/xfs_file.c first,
> > > the fs/xfs/xfs_iops.c, and so on, and there are multiple patches per
> > > file for each (roughly) logical change. e.g. converting xfs_iops.c:
> > [...]
> > 
> > I've decided that there really is too much unnecessary code churn
> > from this approach. I end up converting all the call sites to negate
> > the error sign, and then end up converting them back to the original
> > code some time later, leaving only the source of the errors with a
> > changed sign.
> > 
> > So, I stopped doing that to see just what the brute force, change
> > source and conversions only, and I found with a few simple searches
> > I could identify all the locations that need changing. So, in a
> > couple of hours I churned out the patch that converted everything.
> > Still pretty large, even though it only changes error values and
> > conversion points.
> > 
> > 67 files changed, 879 insertions(+), 884 deletions(-)
> > 
> > Not sure how I could break this up - it really is an all-or-nothing
> > patch this Big Hammer approach....
> > 
> 
> Yeah, now that I look at it, it's kind of hard to review as any other
> way as well. I've done some grepping and made a pass through all of the
> changes. I noticed some very minor things like not all of the comments
> being converted and some multi-line parameter lists going out of
> alignment, but I didn't bother to even make notes of those.
> 
> I've gone through an xfstests run without any explosions as well.
> 
> A couple general observations:
> 
> - I assume the xfs_buf->b_error type change is intentional..?

yes - it was an unsigned short, which is incompaitble with negative
integer values, and there is a 2 byte hole in the xfs_buf structure
after it, anyway....

> - Same for the change in value for the ASSERT(error <=0 && error >=
>   -1000) assert in xfs_buf_ioerror (previously it used 64k).

Right - it was checking to see if it fit in an unsigned short, while
now it checks for the valid "negative errno" range the kernel uses.

> ... and I saw a few spots that looked like could still need conversion.

No surprises there...

> A diff is inlined below.

Yup, I missed a couple. I'll fold them in to the patch. Thanks!

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
