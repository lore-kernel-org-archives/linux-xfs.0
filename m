Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:34374 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725801AbfC2ECa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 29 Mar 2019 00:02:30 -0400
Date: Thu, 28 Mar 2019 21:02:22 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 3/3] xfs: don't allow most setxattr to immutable files
Message-ID: <20190329040222.GC18833@magnolia>
References: <155379543409.24796.5783716624820175068.stgit@magnolia>
 <155379545404.24796.5019142212767521955.stgit@magnolia>
 <20190328212948.GL23020@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190328212948.GL23020@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-mm@kvack.org

On Fri, Mar 29, 2019 at 08:29:48AM +1100, Dave Chinner wrote:
> On Thu, Mar 28, 2019 at 10:50:54AM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > The chattr manpage has this to say about immutable files:
> > 
> > "A file with the 'i' attribute cannot be modified: it cannot be deleted
> > or renamed, no link can be created to this file, most of the file's
> > metadata can not be modified, and the file can not be opened in write
> > mode."
> > 
> > However, we don't actually check the immutable flag in the setattr code,
> > which means that we can update project ids and extent size hints on
> > supposedly immutable files.  Therefore, reject a setattr call on an
> > immutable file except for the case where we're trying to unset
> > IMMUTABLE.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  fs/xfs/xfs_ioctl.c |    8 ++++++++
> >  1 file changed, 8 insertions(+)
> > 
> > 
> > diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> > index 2bd1c5ab5008..9cf0bc0ae2bd 100644
> > --- a/fs/xfs/xfs_ioctl.c
> > +++ b/fs/xfs/xfs_ioctl.c
> > @@ -1067,6 +1067,14 @@ xfs_ioctl_setattr_xflags(
> >  	    !capable(CAP_LINUX_IMMUTABLE))
> >  		return -EPERM;
> >  
> > +	/*
> > +	 * If immutable is set and we are not clearing it, we're not allowed
> > +	 * to change anything else in the inode.
> > +	 */
> > +	if ((ip->i_d.di_flags & XFS_DIFLAG_IMMUTABLE) &&
> > +	    (fa->fsx_xflags & FS_XFLAG_IMMUTABLE))
> > +		return -EPERM;
> > +
> >  	/* diflags2 only valid for v3 inodes. */
> >  	di_flags2 = xfs_flags2diflags2(ip, fa->fsx_xflags);
> >  	if (di_flags2 && ip->i_d.di_version < 3)
> 
> Looks fine - catches both FS_IOC_SETFLAGS and FS_IOC_FSSETXATTR
> for XFS.
> 
> Do the other filesystems that implement FS_IOC_FSSETXATTR have
> the same bug?

Yes.  I'm not even 100% sure I've finished playing xfs whackamole yet.

--D

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
