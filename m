Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:60155 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751884AbcKOQwH (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 15 Nov 2016 11:52:07 -0500
Date: Tue, 15 Nov 2016 17:52:04 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 2/5] xfs: remove i_iolock and use i_rwsem in the VFS
        inode instead
Message-ID: <20161115165204.GA1490@lst.de>
References: <1479064054-10474-1-git-send-email-hch@lst.de> <1479064054-10474-3-git-send-email-hch@lst.de> <20161115153408.GA65218@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161115153408.GA65218@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

On Tue, Nov 15, 2016 at 10:34:10AM -0500, Brian Foster wrote:
> > @@ -1592,12 +1591,10 @@ xfs_vm_bmap(
> >  	 * that on reflinks inodes, so we have to skip out here.  And yes,
> >  	 * 0 is the magic code for a bmap error..
> >  	 */
> > -	if (xfs_is_reflink_inode(ip)) {
> > -		xfs_iunlock(ip, XFS_IOLOCK_SHARED);
> > +	if (xfs_is_reflink_inode(ip))
> >  		return 0;
> > -	}
> > +
> >  	filemap_write_and_wait(mapping);
> > -	xfs_iunlock(ip, XFS_IOLOCK_SHARED);
> 
> The commit log makes no mention of dropping lock usage, unless I missed
> where the inode lock is taken elsewhere..?

For swapon, the only case where the lock matter is is taken by the
calller now.  For the ioctl it simply doesn't matter as the result
will be stale by the time we return.

> >  
> >  	if (lock_flags & (XFS_IOLOCK_EXCL|XFS_IOLOCK_SHARED)) {
> >  		if (!(lock_flags & XFS_IOLOCK_SHARED))
> > -			return !!ip->i_iolock.mr_writer;
> > -		return rwsem_is_locked(&ip->i_iolock.mr_lock);
> > +			return !debug_locks ||
> > +				lockdep_is_held_type(&VFS_I(ip)->i_rwsem, 0);
> > +		return rwsem_is_locked(&VFS_I(ip)->i_rwsem);
> 
> So if I read this correctly, we can no longer safely assert that an
> inode is not exclusively locked because the debug_locks == 0 case would
> always tell us it is. It doesn't look like we do that today, but it
> warrants a comment IMO.

Ok, I can add a comment.
