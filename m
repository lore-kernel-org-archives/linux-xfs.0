Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:43343 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752166AbeCWNHE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 23 Mar 2018 09:07:04 -0400
Received: by mail-wr0-f193.google.com with SMTP id p53so4549376wrc.10
        for <linux-xfs@vger.kernel.org>; Fri, 23 Mar 2018 06:07:03 -0700 (PDT)
Date: Fri, 23 Mar 2018 14:07:00 +0100
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH 1/2] xfs: catch inode allocation state mismatch corruption
Message-ID: <20180323130700.spalddpstux7r4sh@odin.usersys.redhat.com>
References: <20180321075248.7677-1-david@fromorbit.com>
 <20180321075248.7677-2-david@fromorbit.com>
 <20180321170640.GC4818@magnolia>
 <20180321211022.GV18129@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180321211022.GV18129@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org

On Thu, Mar 22, 2018 at 08:10:22AM +1100, Dave Chinner wrote:
> On Wed, Mar 21, 2018 at 10:06:40AM -0700, Darrick J. Wong wrote:
> > On Wed, Mar 21, 2018 at 06:52:47PM +1100, Dave Chinner wrote:
> > > From: Dave Chinner <dchinner@redhat.com>
> > > 
> > > We recently came across a V4 filesystem causing memory corruption
> > > due to a newly allocated inode being setup twice and being added to
> > > the superblock inode list twice. From code inspection, the only way
> > > this could happen is if a newly allocated inode was not marked as
> > > free on disk (i.e. di_mode wasn't zero).
> .....
> > > Note that this crash is only possible on v4 filesystemsi or v5
> > > filesystems mounted with the ikeep mount option. For all other V5
> > > filesystems, this problem cannot occur because we don't read inodes
> > > we are allocating from disk - we simply overwrite them with the new
> > > inode information.
> > 
> > Got a test case for this scenario? :)
> 
> No, because I haven't had time to build an xfs_db script to corrupt
> an inode and allocate it reliably yet.  I've only been using the
> supplied metadump image to reproduce it so far. i.e.  I posted the
> patch the moment I confirmed that it fixes the problem....
> 

Oh, just read this, I was considering something like:

- mkfs.xfs the device with a fixed geometry.
- create a dir into the fs
- create a single file under this dir (using dd just to have a block allocated)
- using xfs_io to overwrite the inobt block into specified offset holding the
  inobt_record (there should be a single chunk only anyway).

The trickiest part would be to calculate the offsets, but I think this can be
done based on the geometry of the FS created. Well, at least for some reason we
change the Btree header/records size.

Does it look reasonable?


> > > diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> > > index 1dc37b72b6ea..98b7a4ae15e4 100644
> > > --- a/fs/xfs/xfs_icache.c
> > > +++ b/fs/xfs/xfs_icache.c
> > > @@ -484,7 +484,28 @@ xfs_iget_cache_miss(
> > >  
> > >  	trace_xfs_iget_miss(ip);
> > >  
> > > -	if ((VFS_I(ip)->i_mode == 0) && !(flags & XFS_IGET_CREATE)) {
> > > +
> > > +	/*
> > > +	 * If we are allocating a new inode, then check what was returned is
> > > +	 * actually a free, empty inode. If we are not allocating an inode,
> > > +	 * the check we didn't find a free inode.
> > > +	 */
> > > +	if (flags & XFS_IGET_CREATE) {
> > > +		if (VFS_I(ip)->i_mode != 0) {
> > > +			xfs_warn(mp,
> > > +"Corruption detected! Free inode 0x%llx not marked free on disk",
> > > +				ino);
> > > +			error = -EFSCORRUPTED;
> > > +			goto out_destroy;
> > > +		}
> > > +		if (ip->i_d.di_nblocks != 0) {
> > > +			xfs_warn(mp,
> > > +"Corruption detected! Free inode 0x%llx has blocks allocated!",
> > > +				ino);
> > > +			error = -EFSCORRUPTED;
> > > +			goto out_destroy;
> > 
> > I've a patch out for review that adds a xfs_inode_verifier_error
> > function that spits out a standardized corruption warning, a hex dump of
> > the bad dinode, and tells the user to run repair.  This seems like a
> > good candidate for that.
> 
> Sure, but that can be done as a separate commit - this fix is almost
> certainly going to be backported to a distro kernel or two, so
> keeping the initial commit as just the fix makes that whole process
> much easier...
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Carlos
