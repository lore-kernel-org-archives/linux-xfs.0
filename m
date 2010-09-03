Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8301M5M224684 for <xfs@oss.sgi.com>; Thu, 2 Sep 2010 19:01:22 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C526E12D2AF1
	for <xfs@oss.sgi.com>; Thu,  2 Sep 2010 17:12:42 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail13.adl6.internode.on.net
	[150.101.137.98]) by cuda.sgi.com with ESMTP id
	e1jKmLzvEucs2qqC for <xfs@oss.sgi.com>;
	Thu, 02 Sep 2010 17:12:42 -0700 (PDT)
Date: Fri, 3 Sep 2010 10:01:46 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: prevent 32bit overflow in space reservation
Message-ID: <20100903000146.GA705@dastard>
References: <1283404663-28105-1-git-send-email-david@fromorbit.com>
	<1283442679.5727.35.camel@doink>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1283442679.5727.35.camel@doink>
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
To: Alex Elder <aelder@sgi.com>
Cc: xfs@oss.sgi.com

On Thu, Sep 02, 2010 at 10:51:19AM -0500, Alex Elder wrote:
> On Thu, 2010-09-02 at 15:17 +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > If we attempt to preallocate more than 2^32 blocks of space in a
> > single syscall, the transaction block reservation will overflow
> > leading to a hangs in the superblock block accounting code. This
> > is trivially reproduced with xfs_io. Fix the problem by capping the
> > allocation reservation to the maximum number of blocks a single
> > xfs_bmapi() call can allocate (2^21 blocks).
> 
> This looks OK, but I have two comments, below.
> 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > ---
> >  fs/xfs/xfs_vnodeops.c |   12 +++++++++---
> >  1 files changed, 9 insertions(+), 3 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_vnodeops.c b/fs/xfs/xfs_vnodeops.c
> > index 66d585c..91dd9c8 100644
> > --- a/fs/xfs/xfs_vnodeops.c
> > +++ b/fs/xfs/xfs_vnodeops.c
> > @@ -2299,15 +2299,21 @@ xfs_alloc_file_space(
> >  			e = allocatesize_fsb;
> >  		}
> >  
> > +		/*
> > +		 * we can't allocate more than @nimaps extents at a time,
> > +		 * so prevent a 32bit overflow on the transaction reserve
> > +		 * by trying to reserve > 16TB worth of blocks for the
> > +		 * preallocation.
> > +
> 
> This comment could use rewording.  How about something like:
> 
> 	A 32-bit block count limits the amount of space that can
> 	be reserved in a transaction, so we need to limit the
> 	number of blocks reserved to avoid overflow.  We can't
> 	allocate more than @nimaps extents (whose size won't
> 	exceed 32 bits) at a time anyway, so use that to enforce
> 	the limit.

Ok, make sense - I'll reword it.

> > 		 */
> > +		resblks = min_t(xfs_fileoff_t, (e - s), (MAXEXTLEN * nimaps));
> 
> I guess it's clear that MAXEXTLEN fits in 32 bits because of
> sizeof (xfs_extlen_t).

True, but if sizeof(xfs_extlen_t) was the limiting factor,
then the mulitply could still cause 32bit overflows.

The real reason is that MAXEXTLEN defines the maximum extent length
supported by the on disk bmap btree record format. The record format
defines the extent length in FSBs to be:

#define MAXEXTLEN       ((xfs_extlen_t)0x001fffff)      /* 21 bits */

and as such fits easily into the 32 bit limit.

> And inspection shows that nimaps is
> just 1, so this does the 32-bit limiting.  But that just
> seems indirect.

nimaps can be up to:

#define XFS_BMAP_MAX_NMAP 4

So if we change the loop to do more allocations per loop, then
the code will already handle it correctly. :)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
