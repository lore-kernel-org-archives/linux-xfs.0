Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 62B7E7F53
	for <xfs@oss.sgi.com>; Fri, 30 Oct 2015 07:37:00 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 5183F30405F
	for <xfs@oss.sgi.com>; Fri, 30 Oct 2015 05:37:00 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id fb8ROxQ7nw7AIdYT (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 30 Oct 2015 05:36:59 -0700 (PDT)
Date: Fri, 30 Oct 2015 08:36:57 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 3/6] xfs: Don't use unwritten extents for DAX
Message-ID: <20151030123657.GC54905@bfoster.bfoster>
References: <1445225238-30413-1-git-send-email-david@fromorbit.com>
	<1445225238-30413-4-git-send-email-david@fromorbit.com>
	<20151029142950.GE11663@bfoster.bfoster>
	<20151029233756.GS19199@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20151029233756.GS19199@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: ross.zwisler@linux.intel.com, jack@suse.cz, xfs@oss.sgi.com

On Fri, Oct 30, 2015 at 10:37:56AM +1100, Dave Chinner wrote:
> On Thu, Oct 29, 2015 at 10:29:50AM -0400, Brian Foster wrote:
> > On Mon, Oct 19, 2015 at 02:27:15PM +1100, Dave Chinner wrote:
> > > From: Dave Chinner <dchinner@redhat.com>
> > > 
...
> > > +	/*
> > > +	 * For DAX, we do not allocate unwritten extents, but instead we zero
> > > +	 * the block before we commit the transaction.  Ideally we'd like to do
> > > +	 * this outside the transaction context, but if we commit and then crash
> > > +	 * we may not have zeroed the blocks and this will be exposed on
> > > +	 * recovery of the allocation. Hence we must zero before commit.
> > > +	 * Further, if we are mapping unwritten extents here, we need to zero
> > > +	 * and convert them to written so that we don't need an unwritten extent
> > > +	 * callback for DAX. This also means that we need to be able to dip into
> > > +	 * the reserve block pool if there is no space left but we need to do
> > > +	 * unwritten extent conversion.
> > > +	 */
> > > +	if (IS_DAX(VFS_I(ip))) {
> > > +		bmapi_flags = XFS_BMAPI_CONVERT | XFS_BMAPI_ZERO;
> > > +		tp->t_flags |= XFS_TRANS_RESERVE;
> > > +	}
> > 
> > Am I following the commit log description correctly in that block
> > zeroing is only required for DAX faults? Do we zero blocks for DAX DIO
> > as well to be consistent, or is that also required (because it looks
> > like we still have end_io completion for dio writes anyways)?
> 
> DAX DIO will do the zeroing rather than using unwritten extents,
> too. But we still have DIO IO completion as that needs to do file
> size updates.
> 

Right, my question is: is the DAX DIO zeroing required to avoid the
races described as the purpose for this patch, or is this just here as a
simplification? In other words, why not do block zeroing only for DAX
faults and not DAX/DIO?

I ask because my understanding is the purpose of this patch is a special
atomic zeroed allocation requirement just for mmap. Unless there is some
special mixed dio/mmap case I'm missing, doing so for DAX/DIO basically
causes a clear_pmem() over every page sized chunk of the target I/O
range for which we already have the data. Perhaps that is fine (for now)
from a performance perspective, but seems unnecessary. Further, we still
have write completion in place which means we can still handle unwritten
conversion just as easily for DAX/DIO as normal DIO.

Thoughts?

Brian

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
