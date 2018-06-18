Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:46589 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754516AbeFRCxQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 17 Jun 2018 22:53:16 -0400
Date: Mon, 18 Jun 2018 12:53:12 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: symlinks can be zero length during log recovery
Message-ID: <20180618025312.GC19934@dastard>
References: <20180615014314.27574-1-david@fromorbit.com>
 <20180615113126.GA2857@bfoster>
 <20180616001034.GR10363@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180616001034.GR10363@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Sat, Jun 16, 2018 at 10:10:34AM +1000, Dave Chinner wrote:
> On Fri, Jun 15, 2018 at 07:31:26AM -0400, Brian Foster wrote:
> > On Fri, Jun 15, 2018 at 11:43:14AM +1000, Dave Chinner wrote:
> > > From: Dave Chinner <dchinner@redhat.com>
> > > 
> > > A log recovery failure has been reproduced where a symlink inode has
> > > a zero length in extent form. It was caused by a shutdown during a
> > > combined fstress+fsmark workload.
> > > 
> > > To fix it, we have to allow zero length symlink inodes through
> > > xfs_dinode_verify() during log recovery. We already specifically
> > > check and allow this case in the shortform symlink fork verifier,
> > > but in this case we don't get that far, and the inode is not in
> > > shortform format.
> > > 
> > > Update the dinode verifier to handle this case, and change the
> > > symlink fork verifier to only allow this case to exist during log
> > > recovery.
> > > 
> > > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > > ---
> > 
> > Seems Ok to me, but before we restrict some of the existing checks to
> > log recovery I am curious about one thing. xfs_inactive_symlink() has
> > this:
> > 
> >         /*
> >          * Zero length symlinks _can_ exist.
> >          */
> >         pathlen = (int)ip->i_d.di_size;
> >         if (!pathlen) {
> >                 xfs_iunlock(ip, XFS_ILOCK_EXCL);
> >                 return 0;
> >         }
> > 
> > I'm not quite sure what case that covers, but it seems slightly
> > inconsistent with the fork verifer change (simply because that path is
> > not exclusive to the read from disk case), at least. Any idea?
> 
> Yeah, that's what I'm trying to chase down right now. I had the
> verifier fire on inode writeback during generic/269. I don't know
> yet where these zero length symlinks are coming from, and none of
> the comments (there's a couple that say the above)
> actually give any hint to their source.

Ok, so there is this comment in fs/namei.c w.r.t. symlink handling
before getname_flags():

* POSIX.1 2.4: an empty pathname is invalid (ENOENT).

So the call chain is

sys_symlink(oldname ....)
  do_symlinkat(oldname ...)
    getname(oldname)
      getname_flags(oldname, 0, NULL)
        len = strncpy_from_user(... oldname ....)
	....
	if (!len) {
		if (!(flags & LOOKUP_EMPTY))
			return -ENOENT;
	}

So we should never see a zero length symlink from userspace as flags
is always zero. Hence if we are seeing zero length symlinks on disk,
then that's an XFS implementation issue, not a user API requirement.

There's two issues in the symlink code that can lead to zero length
symlinks firing the verifiers. They are symptoms of the same core
issue in xfs_inactive_symlink(): the inode is unlocked between the
symlink inactivation/truncation and the inode being freed. This
opens a window for the inode to be written to disk before it
xfs_ifree() removes it from the unlinked list, marks it free in the
inobt and zeros the mode.

The first, and simplest to solve issue is the shortform verifier.
This verifier doesn't actually verify on disk state - it verifies
*in memory inode fork state*. Specifically, it checks for a zero
length inode fork (ifp->if_bytes) and says specifically "this can
happen". The only place it can happen in in the window between
xfs_inactive_symlink() and xfs_ifree() because
xfs_inactive_symlink() tears down the data fork. It doesn't,
however, change the inode size, so if the inode is written back to
disk in this window, it's written with a non-zero size, leaving the
data fork in the inode untouched. i.e. the inode on disk is still a
valid symlink.

To fix this is easy. xfs_ifree() actually cleans up the in-memory
data and attr fork structures, and so there is absolutely no need to
do it in xfs_inactive_symlink(). With that change, the symlink
verifier error goes away.

Which leaves remote symlink inactivation. This runs a transaction
that truncates away the symlink extent and sets the inode size to
zero. IOWs, it creates an actual path for zero length symlinks on
disk. However, the symlink inode at this point is unreferenced by
userspace and is on the unlinked list, and hence userspace can never
see a zero length symlink inode. This does, however, create a
problem - we can get zero length symlinks on disk in log recovery
because the inode size is set to zero at the same time the EFI
intents are recorded. hence if log recovery then reads the inode off
disk to replay EFIs or other non-completed intents, it can see a
symlink inode with zero length.

So we have a choice here: either special case log recovery for
symlink inode verification, or prevent zero length extent for
symlink inodes from existing on disk. The former is essentially the
patch I posted, the latter requires discussion.

If we want to avoid zero length extent form symlinks on disk we
either need to make the inactivation and freeing atomic, or we can
make symlink inactivation change the type of inode to something that
allows zero length. The former is complex and a major undertaking
(new deferred op, a bunch of new intents, log recovery work, etc)
while the latter is one line of code. i.e. we simply change the
mode of the inode to a regular file at the same time we set the size
to zero.

If the transaction with the EFIs and zero size goes to disk, we
don't really care what the inode type is. it's on the unlinked list,
can't be seen from userspace, and we just need to run extent removal
and freeing on it in log recovery. Hence if we change it to be a
regular file inode, then we maintain the "no zero length symlinks
on disk" rule, and we get cleanup occurring without any new code or
concerns being created.

Thoughts?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
