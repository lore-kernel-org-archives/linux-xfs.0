Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:47688 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727053AbfDEA3j (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 4 Apr 2019 20:29:39 -0400
Date: Thu, 4 Apr 2019 17:29:29 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 2/3] xfs: reset page mappings after setting immutable
Message-ID: <20190405002929.GD1177@magnolia>
References: <155379543409.24796.5783716624820175068.stgit@magnolia>
 <155379544747.24796.1807309281507099911.stgit@magnolia>
 <20190328212147.GK23020@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190328212147.GK23020@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-mm@kvack.org

On Fri, Mar 29, 2019 at 08:21:47AM +1100, Dave Chinner wrote:
> On Thu, Mar 28, 2019 at 10:50:47AM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > The chattr manpage has this to say about immutable files:
> > 
> > "A file with the 'i' attribute cannot be modified: it cannot be deleted
> > or renamed, no link can be created to this file, most of the file's
> > metadata can not be modified, and the file can not be opened in write
> > mode."
> > 
> > This means that we need to flush the page cache when setting the
> 
> nit: flush and invalidate the page cache.
> 
> > immutable flag so that programs cannot continue to write to writable
> > mappings.
> 
> Do we even need to invalidate the page cache for this? i.e. we've
> cleaned the pages so that any new write to them will fault,
> that will see the immutable flag via ->page_mkwrite and then the
> app should segv, right?

Yeah, we only need to flush the pages.  No need to invalidate.

> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  fs/xfs/xfs_ioctl.c |   63 +++++++++++++++++++++++++++++++++++-----------------
> >  1 file changed, 43 insertions(+), 20 deletions(-)
> > 
> > 
> > diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> > index 6ecdbb3af7de..2bd1c5ab5008 100644
> > --- a/fs/xfs/xfs_ioctl.c
> > +++ b/fs/xfs/xfs_ioctl.c
> > @@ -998,6 +998,37 @@ xfs_diflags_to_linux(
> >  #endif
> >  }
> >  
> > +static int
> > +xfs_ioctl_setattr_flush(
> > +	struct xfs_inode	*ip,
> > +	int			*join_flags)
> > +{
> > +	struct inode		*inode = VFS_I(ip);
> > +	int			error;
> > +
> > +	if (S_ISDIR(inode->i_mode))
> > +		return 0;
> > +	if ((*join_flags) & (XFS_IOLOCK_EXCL | XFS_MMAPLOCK_EXCL))
> > +		return 0;
> > +
> > +	/* lock, flush and invalidate mapping in preparation for flag change */
> > +	xfs_ilock(ip, XFS_MMAPLOCK_EXCL | XFS_IOLOCK_EXCL);
> > +	error = filemap_write_and_wait(inode->i_mapping);
> > +	if (error)
> > +		goto out_unlock;
> > +	error = invalidate_inode_pages2(inode->i_mapping);
> > +	if (error)
> > +		goto out_unlock;
> > +
> > +	*join_flags = XFS_MMAPLOCK_EXCL | XFS_IOLOCK_EXCL;
> > +	return 0;
> > +
> > +out_unlock:
> > +	xfs_iunlock(ip, XFS_MMAPLOCK_EXCL | XFS_IOLOCK_EXCL);
> > +	return error;
> > +
> > +}
> 
> Doesn't wait for direct IO to drain. Wouldn't it be better to do
> this?
> 
> 	lock()
> 	xfs_flush_unmap_range(ip, 0, XFS_SIZE(ip));
> 	unlock()

But if we only need to filemap_write_and_wait, then calling flush_unmap
(which also calls truncate_pagecache_range) is too much work.

--D

> 
> Otherwise looks ok.
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
