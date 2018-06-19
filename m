Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:51240 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S966578AbeFSQ2m (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 19 Jun 2018 12:28:42 -0400
Date: Tue, 19 Jun 2018 12:28:40 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 1/2] xfs: zero length symlinks are not valid
Message-ID: <20180619162839.GC2806@bfoster>
References: <20180618055711.23391-1-david@fromorbit.com>
 <20180618055711.23391-2-david@fromorbit.com>
 <20180618132411.GB28320@bfoster>
 <20180618224259.GF19934@dastard>
 <20180619115434.GB2806@bfoster>
 <20180619154810.GC21698@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180619154810.GC21698@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org

On Tue, Jun 19, 2018 at 08:48:10AM -0700, Darrick J. Wong wrote:
> On Tue, Jun 19, 2018 at 07:54:34AM -0400, Brian Foster wrote:
> > On Tue, Jun 19, 2018 at 08:42:59AM +1000, Dave Chinner wrote:
> > > On Mon, Jun 18, 2018 at 09:24:11AM -0400, Brian Foster wrote:
> > > > On Mon, Jun 18, 2018 at 03:57:10PM +1000, Dave Chinner wrote:
> > > > > From: Dave Chinner <dchinner@redhat.com>
> > > > > 
> > > > > A log recovery failure has been reproduced where a symlink inode has
> > > > > a zero length in extent form. It was caused by a shutdown during a
> > > > > combined fstress+fsmark workload.
> > > > > 
> > > > > The underlying problem is the issue in xfs_inactive_symlink(): the
> > > > > inode is unlocked between the symlink inactivation/truncation and
> > > > > the inode being freed. This opens a window for the inode to be
> > > > > written to disk before it xfs_ifree() removes it from the unlinked
> > > > > list, marks it free in the inobt and zeros the mode.
> > > > > 
> > > > > For shortform inodes, the fix is simple. xfs_ifree() clears the data
> > > > > fork state, so there's no need to do it in xfs_inactive_symlink().
> > > > > This means the shortform fork verifier will not see a zero length
> > > > > data fork as it mirrors the inode size through to xfs_ifree()), and
> > > > > hence if the inode gets written back and the fork verifiers are run
> > > > > they will still see a fork that matches the on-disk inode size.
> > > > > 
> > > > > For extent form (remote) symlinks, it is a little more tricky. Here
> > > > > we explicitly set the inode size to zero, so the above race can lead
> > > > > to zero length symlinks on disk. Because the inode is unlinked at
> > > > > this point (i.e. on the unlinked list) and unreferenced, it can
> > > > > never be seen again by a user. Hence when we set the inode size to
> > > > 
> > > > Perhaps we don't care, but what about bulkstat? The inode free is
> > > > imminent, so it probably doesn't matter that much.
> > > 
> > > Bulkstat users have to deal with all sorts of TOCTOU races because
> > > we do the inode lookup after unlocking the AGI. Hence the inodes
> > > returned are not guaranteed to be allocated or even accessible,
> > > especially if they return nlink == 0...
> > > 
> > > So, yeah, I don't think it matters for bulkstat.
> > > 
> > 
> > Ack.
> > 
> > > > > @@ -523,17 +531,10 @@ xfs_inactive_symlink(
> > > > >  		return -EIO;
> > > > >  
> > > > >  	xfs_ilock(ip, XFS_ILOCK_EXCL);
> > > > > -
> > > > > -	/*
> > > > > -	 * Zero length symlinks _can_ exist.
> > > > > -	 */
> > > > >  	pathlen = (int)ip->i_d.di_size;
> > > > > -	if (!pathlen) {
> > > > > -		xfs_iunlock(ip, XFS_ILOCK_EXCL);
> > > > > -		return 0;
> > > > > -	}
> > > > > +	ASSERT(pathlen);
> > > > 
> > > > Ok, but I still feel like I'm missing something here. The commit log
> > > > explains how symlink inode inactivation creates this transient zero-size
> > > > symlink state. That's fine, but why do we have code to check for such
> > > > symlinks _in_ the symlink activation path?
> > > 
> > > Ah, I put that in the cover letter - the VFS is supposed to ensure
> > > we don't get zero length symlinks passed to us, and the verifiers
> > > are supposed to catch it coming off disk. This is mostly just a
> > > bounds check to document that we don't expect zero length symlinks
> > > at any time, especially in the unlink path. I put the same assert
> > > check in the xfs_symlink() create path, too, to ensure we don't get
> > > passed a zero length from the VFS...
> > > 
> > 
> > Oh, I'm not referring to the ASSERT() here. That all seems fine...
> > 
> > > > Is the assumption that this is just an overzealous/unnecessary check, or
> > > > am I missing something? If the former, an extra sentence in the last
> > > > paragraph or so of the commit log to explain why we remove this would be
> > > > nice.
> > > 
> > > It's a "should never occur" situation but, well, paranoia seeing as
> > > we've got this wrong for so long...
> > > 
> > 
> > Rather, I'm asking about the pre-existing code that we remove. The hunk
> > just above from xfs_inactive_symlink():
> > 
> > -	/*
> > -	 * Zero length symlinks _can_ exist.
> > -	 */
> > -	if (!pathlen) {
> > -		xfs_iunlock(ip, XFS_ILOCK_EXCL);
> > -		return 0;
> > -	}
> > 
> > ... obviously suggests that there could have been a situation where we'd
> > see a zero-length symlink on entry to xfs_inactive_symlink(). This
> > patch, however, focuses on fixing the transient zero-length symlink
> > caused by xfs_inactive_symlink_rmt() (which comes after the above
> > check).
> > 
> > The latter implies we'd never enter the symlink inactivate path with a
> > zero-length symlink, since this is the path that causes it (until the
> > inode is ultimately freed). So my question essentially is do we have any
> > idea why this code exists in the first place? Is it just bogus given
> > there's no other clear vector to a zero-length symlink before the inode
> > is inactivated?
> 
> I think that vector is log recovery.  Say we have a filesystem running
> on an old kernel, and the fs goes down immediately after the transaction
> commit in xfs_inactive_symlink_rmt.  At that exact moment we have a
> zero-size extents format symlink on the unlinked list, and if we boot up
> with a new kernel and go through log recovery we'll try to free this
> inode in xlog_recover_process_one_iunlink.
> 

Ah, Ok. So log recovery will look up the inode and run it through
the inactive sequence again. We presumably remove this code because with
this patch that should no longer happen. Keeping it around doesn't help
us because presumably the verifier would fail before we get to this
point anyways. Makes sense, thanks Darrick.

> The new code that switches i_mode prevents us from dropping more of
> these onto the disk, but we still have old filesystems to deal with.
> FWIW every now and then generic/475 complains in xfs_repair -n about
> such a symlink (dfork format 2 and size 0).
> 

So it sounds like the caveat with this approach then is that we haven't
necessarily provided a recovery path for somebody stuck in this
particular failed recovery state, outside of 'xfs_repair -L'. :/ Unless
I'm misunderstanding the error, that does seem a bit unfortunate given
that otherwise recovery should complete.

Brian

> --D
> 
> > Brian
> > 
> > > > > -	if (pathlen < 0 || pathlen > XFS_SYMLINK_MAXLEN) {
> > > > > +	if (pathlen <= 0 || pathlen > XFS_SYMLINK_MAXLEN) {
> > > > >  		xfs_alert(mp, "%s: inode (0x%llx) bad symlink length (%d)",
> > > > >  			 __func__, (unsigned long long)ip->i_ino, pathlen);
> > > > >  		xfs_iunlock(ip, XFS_ILOCK_EXCL);
> > > > > @@ -541,12 +542,12 @@ xfs_inactive_symlink(
> > > > >  		return -EFSCORRUPTED;
> > > > >  	}
> > > > >  
> > > > > +	/*
> > > > > +	 * Inline fork state gets removed by xfs_difree() so we have nothing to
> > > > > +	 * do here in that case.
> > > > > +	 */
> > > > 
> > > > It looks like that actually happens in xfs_ifree() (not xfs_difree()).
> > > 
> > > Yup, will fix.
> > > 
> > > Cheers,
> > > 
> > > Dave.
> > > -- 
> > > Dave Chinner
> > > david@fromorbit.com
> > > --
> > > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > > the body of a message to majordomo@vger.kernel.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
