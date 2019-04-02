Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:4198 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725912AbfDBVcn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 2 Apr 2019 17:32:43 -0400
Date: Wed, 3 Apr 2019 08:31:19 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: return correct XFS_IOC_DIOINFO for DAX inode
Message-ID: <20190402213119.GU26298@dastard>
References: <b3af182f-a547-9d04-3b29-232857e83fc4@redhat.com>
 <20190402175632.GD5147@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190402175632.GD5147@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Eric Sandeen <sandeen@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>, Jeff Moyer <jmoyer@redhat.com>

On Tue, Apr 02, 2019 at 10:56:32AM -0700, Darrick J. Wong wrote:
> On Tue, Apr 02, 2019 at 10:44:38AM -0500, Eric Sandeen wrote:
> > pmem is byte addressable, and indeed byte-aligned DIO works on
> > a DAX file.  So, teach XFS_IOC_DIOINFO to return the correct
> > alignment information if IS_DAX(inode).
> 
> If it's a DAX filesystem, do we want to try to steer people towards
> things like 2MB pages since (in theory) we can get away with fewer page
> table mappings?  And (seeing as that's mmap that cares, not directio)
> would advertising preferential page mapping sizes be more appropriate
> advertised in a different ioctl?
> 
> --D
> 
> > Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> > ---
> > 
> > diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> > index 6ecdbb3..35eae7d 100644
> > --- a/fs/xfs/xfs_ioctl.c
> > +++ b/fs/xfs/xfs_ioctl.c
> > @@ -1919,12 +1919,21 @@ xfs_file_ioctl(
> >  	}
> >  	case XFS_IOC_DIOINFO: {
> >  		struct dioattr	da;
> > -		xfs_buftarg_t	*target =
> > -			XFS_IS_REALTIME_INODE(ip) ?
> > -			mp->m_rtdev_targp : mp->m_ddev_targp;
> >  
> > -		da.d_mem =  da.d_miniosz = target->bt_logical_sectorsize;
> > -		da.d_maxiosz = INT_MAX & ~(da.d_miniosz - 1);
> > +		if (IS_DAX(inode)) {
> > +			/* pmem is byte addressable */
> > +			da.d_mem = 1;
> > +			da.d_miniosz = 1;
> > +			da.d_maxiosz = INT_MAX;

I don't think we want to open that can of worms.

Have you run fsx on dax mixing mmap/dio with byte range granularity?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
