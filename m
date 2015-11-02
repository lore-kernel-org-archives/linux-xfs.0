Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id DE51B7F59
	for <xfs@oss.sgi.com>; Sun,  1 Nov 2015 19:21:51 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id CEB2A304032
	for <xfs@oss.sgi.com>; Sun,  1 Nov 2015 17:21:48 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	K7jBJMRLuMs5Awhz for <xfs@oss.sgi.com>;
	Sun, 01 Nov 2015 17:21:46 -0800 (PST)
Date: Mon, 2 Nov 2015 12:21:32 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/6] xfs: introduce BMAPI_ZERO for allocating zeroed
	extents
Message-ID: <20151102012132.GX19199@dastard>
References: <1445225238-30413-1-git-send-email-david@fromorbit.com>
	<1445225238-30413-3-git-send-email-david@fromorbit.com>
	<20151029142757.GD11663@bfoster.bfoster>
	<20151029233548.GR19199@dastard>
	<20151030123608.GB54905@bfoster.bfoster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20151030123608.GB54905@bfoster.bfoster>
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
Cc: ross.zwisler@linux.intel.com, jack@suse.cz, xfs@oss.sgi.com

On Fri, Oct 30, 2015 at 08:36:08AM -0400, Brian Foster wrote:
> On Fri, Oct 30, 2015 at 10:35:48AM +1100, Dave Chinner wrote:
> > On Thu, Oct 29, 2015 at 10:27:58AM -0400, Brian Foster wrote:
> > > On Mon, Oct 19, 2015 at 02:27:14PM +1100, Dave Chinner wrote:
> > > > From: Dave Chinner <dchinner@redhat.com>
> > > > 
> ...
> > 
> > > I suspect there's no use case to pass XFS_BMAPI_ZERO for new unwritten
> > > allocations, but if the flag is passed, doesn't this cause duplicate
> > > block zeroing?
> > 
> > It probably would, but....
> > 
> > > Perhaps we should drop the zero flag from 'flags' after
> > > allocation in xfs_bmapi_write() just to ensure this executes in one
> > > place or the other..?
> > 
> > I think that if we hit this, we're doing something else wrong - why
> > would we allocate unwritten extents and still need to initialise
> > them to zero?
> > 
> 
> No idea, really (as noted above). ;) It just looked like it could be
> invoked twice per bmapi call, nothing else I saw prevented it, and it
> looks easily avoidable. Maybe somebody down the road decides to turn on
> block zeroing unconditionally in the block allocator due to hardware
> support or some such. Or maybe we'll never hit the problem. The point is
> that this code will inevitably be modified/enhanced down the road and
> nobody is going to remember that the zeroing is invoked twice in a
> particular prealloc codepath.
> 
> If we don't want to mess with the flags, how about an assert somewhere
> so it's explicit the bmapi implementation doesn't expect this
> combination of flags?

Easy enough. I'll add this to the initial asserts in xfs_bmapi_write():

+	/*
+	 * we can allocate unwritten extents or pre-zero allocated blocks,
+	 * but it makes no sense to do both at once. This would result in
+	 * zeroing the unwritten extent twice, but it still being an
+	 * unwritten extent....
+	 */
+	ASSERT((flags & (XFS_BMAPI_PREALLOC|XFS_BMAPI_ZERO)) !=
+			(XFS_BMAPI_PREALLOC|XFS_BMAPI_ZERO));

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
