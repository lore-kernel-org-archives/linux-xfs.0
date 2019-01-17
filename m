Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:41570 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726981AbfAQXCu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Jan 2019 18:02:50 -0500
Date: Thu, 17 Jan 2019 15:02:40 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 06/22] xfs: refactor kernel-specific parts of xfs_ialloc
Message-ID: <20190117230240.GI4424@magnolia>
References: <154630914104.18437.15354380637179830566.stgit@magnolia>
 <154630917828.18437.11659667761358440410.stgit@magnolia>
 <20190117222614.GG6173@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190117222614.GG6173@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Fri, Jan 18, 2019 at 09:26:14AM +1100, Dave Chinner wrote:
> On Mon, Dec 31, 2018 at 06:19:38PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Move the kernel-specific parts of xfs_ialloc into a separate function in
> > preparation for hoisting xfs_ialloc to libxfs.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  fs/xfs/xfs_inode.c |   45 ++++++++++++++++++++++++++++++++++++---------
> >  1 file changed, 36 insertions(+), 9 deletions(-)
> > 
> > 
> > diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> > index 403eb8fa2f1f..b635d43caeed 100644
> > --- a/fs/xfs/xfs_inode.c
> > +++ b/fs/xfs/xfs_inode.c
> > @@ -621,6 +621,32 @@ xfs_lookup(
> >  	return error;
> >  }
> >  
> > +/* Return an exclusive ILOCK'd in-core inode. */
> > +static int
> > +xfs_ialloc_iget(
> > +	struct xfs_mount	*mp,
> > +	struct xfs_trans	*tp,
> > +	xfs_ino_t		ino,
> > +	struct xfs_inode	**ipp)
> > +{
> > +	return xfs_iget(mp, tp, ino, XFS_IGET_CREATE, XFS_ILOCK_EXCL, ipp);
> > +}
> > +
> > +/* Propagate platform-specific inode properties into the new child. */
> > +static void
> > +xfs_ialloc_platform_init(
> > +	struct xfs_trans		*tp,
> > +	const struct xfs_ialloc_args	*args,
> > +	struct xfs_inode		*ip)
> > +{
> > +	struct timespec64		tv;
> > +
> > +	tv = current_time(VFS_I(ip));
> > +	VFS_I(ip)->i_mtime = tv;
> > +	VFS_I(ip)->i_atime = tv;
> > +	VFS_I(ip)->i_ctime = tv;
> 
> Doesn't set ip->i_d.di_crtime, so ....
> 
> > @@ -755,10 +781,11 @@ xfs_ialloc(
> >  		inode_set_iversion(inode, 1);
> >  		ip->i_d.di_flags2 = 0;
> >  		ip->i_d.di_cowextsize = 0;
> > -		ip->i_d.di_crtime.t_sec = (int32_t)tv.tv_sec;
> > -		ip->i_d.di_crtime.t_nsec = (int32_t)tv.tv_nsec;
> > +		ip->i_d.di_crtime.t_sec = 0;
> > +		ip->i_d.di_crtime.t_nsec = 0;
> >  	}
> >  
> > +	xfs_ialloc_platform_init(tp, args, ip);
> 
> This breaks create time functionality.

Yikes!

> Don't we have a statx() test in fstests that checks that the
> create time of inodes is set correctly?

Clearly not... <frown>

--D

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
