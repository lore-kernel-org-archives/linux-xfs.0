Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail03.adl6.internode.on.net ([150.101.137.143]:21617 "EHLO
        ipmail03.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753210AbeCUVKd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 21 Mar 2018 17:10:33 -0400
Date: Thu, 22 Mar 2018 08:10:22 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/2] xfs: catch inode allocation state mismatch corruption
Message-ID: <20180321211022.GV18129@dastard>
References: <20180321075248.7677-1-david@fromorbit.com>
 <20180321075248.7677-2-david@fromorbit.com>
 <20180321170640.GC4818@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180321170640.GC4818@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Wed, Mar 21, 2018 at 10:06:40AM -0700, Darrick J. Wong wrote:
> On Wed, Mar 21, 2018 at 06:52:47PM +1100, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > We recently came across a V4 filesystem causing memory corruption
> > due to a newly allocated inode being setup twice and being added to
> > the superblock inode list twice. From code inspection, the only way
> > this could happen is if a newly allocated inode was not marked as
> > free on disk (i.e. di_mode wasn't zero).
.....
> > Note that this crash is only possible on v4 filesystemsi or v5
> > filesystems mounted with the ikeep mount option. For all other V5
> > filesystems, this problem cannot occur because we don't read inodes
> > we are allocating from disk - we simply overwrite them with the new
> > inode information.
> 
> Got a test case for this scenario? :)

No, because I haven't had time to build an xfs_db script to corrupt
an inode and allocate it reliably yet.  I've only been using the
supplied metadump image to reproduce it so far. i.e.  I posted the
patch the moment I confirmed that it fixes the problem....

> > diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> > index 1dc37b72b6ea..98b7a4ae15e4 100644
> > --- a/fs/xfs/xfs_icache.c
> > +++ b/fs/xfs/xfs_icache.c
> > @@ -484,7 +484,28 @@ xfs_iget_cache_miss(
> >  
> >  	trace_xfs_iget_miss(ip);
> >  
> > -	if ((VFS_I(ip)->i_mode == 0) && !(flags & XFS_IGET_CREATE)) {
> > +
> > +	/*
> > +	 * If we are allocating a new inode, then check what was returned is
> > +	 * actually a free, empty inode. If we are not allocating an inode,
> > +	 * the check we didn't find a free inode.
> > +	 */
> > +	if (flags & XFS_IGET_CREATE) {
> > +		if (VFS_I(ip)->i_mode != 0) {
> > +			xfs_warn(mp,
> > +"Corruption detected! Free inode 0x%llx not marked free on disk",
> > +				ino);
> > +			error = -EFSCORRUPTED;
> > +			goto out_destroy;
> > +		}
> > +		if (ip->i_d.di_nblocks != 0) {
> > +			xfs_warn(mp,
> > +"Corruption detected! Free inode 0x%llx has blocks allocated!",
> > +				ino);
> > +			error = -EFSCORRUPTED;
> > +			goto out_destroy;
> 
> I've a patch out for review that adds a xfs_inode_verifier_error
> function that spits out a standardized corruption warning, a hex dump of
> the bad dinode, and tells the user to run repair.  This seems like a
> good candidate for that.

Sure, but that can be done as a separate commit - this fix is almost
certainly going to be backported to a distro kernel or two, so
keeping the initial commit as just the fix makes that whole process
much easier...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
