Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmailnode02.adl6.internode.on.net ([150.101.137.148]:48088
        "EHLO ipmailnode02.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S936942AbeFRWnD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 18 Jun 2018 18:43:03 -0400
Date: Tue, 19 Jun 2018 08:42:59 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/2] xfs: zero length symlinks are not valid
Message-ID: <20180618224259.GF19934@dastard>
References: <20180618055711.23391-1-david@fromorbit.com>
 <20180618055711.23391-2-david@fromorbit.com>
 <20180618132411.GB28320@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180618132411.GB28320@bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Mon, Jun 18, 2018 at 09:24:11AM -0400, Brian Foster wrote:
> On Mon, Jun 18, 2018 at 03:57:10PM +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > A log recovery failure has been reproduced where a symlink inode has
> > a zero length in extent form. It was caused by a shutdown during a
> > combined fstress+fsmark workload.
> > 
> > The underlying problem is the issue in xfs_inactive_symlink(): the
> > inode is unlocked between the symlink inactivation/truncation and
> > the inode being freed. This opens a window for the inode to be
> > written to disk before it xfs_ifree() removes it from the unlinked
> > list, marks it free in the inobt and zeros the mode.
> > 
> > For shortform inodes, the fix is simple. xfs_ifree() clears the data
> > fork state, so there's no need to do it in xfs_inactive_symlink().
> > This means the shortform fork verifier will not see a zero length
> > data fork as it mirrors the inode size through to xfs_ifree()), and
> > hence if the inode gets written back and the fork verifiers are run
> > they will still see a fork that matches the on-disk inode size.
> > 
> > For extent form (remote) symlinks, it is a little more tricky. Here
> > we explicitly set the inode size to zero, so the above race can lead
> > to zero length symlinks on disk. Because the inode is unlinked at
> > this point (i.e. on the unlinked list) and unreferenced, it can
> > never be seen again by a user. Hence when we set the inode size to
> 
> Perhaps we don't care, but what about bulkstat? The inode free is
> imminent, so it probably doesn't matter that much.

Bulkstat users have to deal with all sorts of TOCTOU races because
we do the inode lookup after unlocking the AGI. Hence the inodes
returned are not guaranteed to be allocated or even accessible,
especially if they return nlink == 0...

So, yeah, I don't think it matters for bulkstat.

> > @@ -523,17 +531,10 @@ xfs_inactive_symlink(
> >  		return -EIO;
> >  
> >  	xfs_ilock(ip, XFS_ILOCK_EXCL);
> > -
> > -	/*
> > -	 * Zero length symlinks _can_ exist.
> > -	 */
> >  	pathlen = (int)ip->i_d.di_size;
> > -	if (!pathlen) {
> > -		xfs_iunlock(ip, XFS_ILOCK_EXCL);
> > -		return 0;
> > -	}
> > +	ASSERT(pathlen);
> 
> Ok, but I still feel like I'm missing something here. The commit log
> explains how symlink inode inactivation creates this transient zero-size
> symlink state. That's fine, but why do we have code to check for such
> symlinks _in_ the symlink activation path?

Ah, I put that in the cover letter - the VFS is supposed to ensure
we don't get zero length symlinks passed to us, and the verifiers
are supposed to catch it coming off disk. This is mostly just a
bounds check to document that we don't expect zero length symlinks
at any time, especially in the unlink path. I put the same assert
check in the xfs_symlink() create path, too, to ensure we don't get
passed a zero length from the VFS...

> Is the assumption that this is just an overzealous/unnecessary check, or
> am I missing something? If the former, an extra sentence in the last
> paragraph or so of the commit log to explain why we remove this would be
> nice.

It's a "should never occur" situation but, well, paranoia seeing as
we've got this wrong for so long...

> > -	if (pathlen < 0 || pathlen > XFS_SYMLINK_MAXLEN) {
> > +	if (pathlen <= 0 || pathlen > XFS_SYMLINK_MAXLEN) {
> >  		xfs_alert(mp, "%s: inode (0x%llx) bad symlink length (%d)",
> >  			 __func__, (unsigned long long)ip->i_ino, pathlen);
> >  		xfs_iunlock(ip, XFS_ILOCK_EXCL);
> > @@ -541,12 +542,12 @@ xfs_inactive_symlink(
> >  		return -EFSCORRUPTED;
> >  	}
> >  
> > +	/*
> > +	 * Inline fork state gets removed by xfs_difree() so we have nothing to
> > +	 * do here in that case.
> > +	 */
> 
> It looks like that actually happens in xfs_ifree() (not xfs_difree()).

Yup, will fix.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
