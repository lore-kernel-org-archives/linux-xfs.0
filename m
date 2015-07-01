Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 3E4387FAA
	for <xfs@oss.sgi.com>; Wed,  1 Jul 2015 17:59:51 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 2A5408F8035
	for <xfs@oss.sgi.com>; Wed,  1 Jul 2015 15:59:51 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id jld5izU1JKTt7Wzo (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 01 Jul 2015 15:59:49 -0700 (PDT)
Date: Wed, 1 Jul 2015 15:59:44 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 10/14] xfs: minimize impact to non-reflink files via
	reflink per-inode flag
Message-ID: <20150701225944.GB10043@birch.djwong.org>
References: <20150625233909.4992.68314.stgit@birch.djwong.org>
	<20150625234016.4992.52406.stgit@birch.djwong.org>
	<20150701015843.GS22807@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150701015843.GS22807@dastard>
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
Cc: xfs@oss.sgi.com

On Wed, Jul 01, 2015 at 11:58:43AM +1000, Dave Chinner wrote:
> On Thu, Jun 25, 2015 at 04:40:16PM -0700, Darrick J. Wong wrote:
> > Gate all the reflink functions (which generally involve an expensive
> > trip to the reflink btree) on an inode flag which is applied to both
> > inodes at reflink time.  This minimizes reflink's impact on non-CoW
> > files.
> 
> Ah, I see you do this reflink inode flag here. This should be one of
> the first patches, not the last.  i.e. the patch series should
> build up all the supporting infrastructure in individual patches
> before adding any of the actual reflink implementation....

Pardon all the dust, I figured that it'd be better to get all the patches
out for earlier review than to make everyone wait until I could get a
reasonable refactoring done once.

> Also, the flag needs to go into the di_flags2 field, as the last
> flag in the di_flags field is reserved for a "more flags" flag if we
> ever need to add more flags to a v2 inode in a v4 filesystem...

Ok.

> > +/*
> > + * xfs_is_reflink_inode() -- Decide if an inode needs to be checked for CoW.
> > + *
> > + * @ip: XFS inode
> > + */
> > +bool
> > +xfs_is_reflink_inode(
> > +	struct xfs_inode	*ip)		/* XFS inode */
> > +{
> > +	struct xfs_mount	*mp = ip->i_mount;
> > +
> > +	if (!xfs_sb_version_hasreflink(&mp->m_sb))
> > +		return false;
> > +	if (!(ip->i_d.di_flags & XFS_DIFLAG_REFLINK))
> > +		return false;
> > +
> > +	ASSERT(!XFS_IS_REALTIME_INODE(ip));
> > +	return true;
> 
> I would have thought you only need to check the inode flag here
> because the only time it will be set is on a reflink enabled
> filesystem. i.e. that flag being set implies we've already done
> all the "reflink is supported in this filesystem and it's not a
> realtime file" checks when setting the flag.

Sure.  The reason for so many ASSERTs everywhere is to help me check my
own sanity while cobbling together the first version.  I imagine I could
eliminate a lot of them, but since they all compile out on !XFS_DEBUG &&
!XFS_WARN, I didn't think it was a serious problem. :)

--D

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
