Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 02 May 2007 23:45:20 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l436jDfB003835
	for <xfs@oss.sgi.com>; Wed, 2 May 2007 23:45:15 -0700
Date: Thu, 3 May 2007 16:44:59 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: TAKE 963965 - Add lockdep support for XFS
Message-ID: <20070503064459.GJ77450368@melbourne.sgi.com>
References: <20070427085045.D7C6E5910FF9@chook.melbourne.sgi.com> <20070502115105.GA21031@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070502115105.GA21031@infradead.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: Lachlan McIlroy <lachlan@sgi.com>, xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk

On Wed, May 02, 2007 at 12:51:05PM +0100, Christoph Hellwig wrote:
> On Fri, Apr 27, 2007 at 06:50:45PM +1000, Lachlan McIlroy wrote:
> > Add lockdep support for XFS
> 
> I don't think this is entirely correct, and it misses some of the
> most interesting cases.

Yeah, we decided it was better to get something out there
that fixes the obvious and frequently reported false positives
than hold it up on the hard stuff....

> I've Cc'ed -fsdevel and Al to get some comments on the more tricky
> issues in the rename section at the end of the mail.

There's several other tricky cases that we're not sure to handle
as well - they are mainly due to *valid* lock inversions. i.e.
we do "lock A, lock B" in most places, but in others we do "lock
B, *trylock* A" to avoid deadlocks. I think the MOUNT_ILOCK/inode ilock
is one of these pairs.

> 
> 
> > Modid:  xfs-linux-melb:xfs-kern:28485a
> > fs/xfs/xfs_vnodeops.c - 1.695 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/> > xfs_vnodeops.c.diff?r1=text&tr1=1.695&r2=text&tr2=1.694&f=h
> > http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_vnodeops.c.diff?r1=text&tr1=1.695&r2=text&tr2=1.694&f=h
> 
> The XFS_ILOCK_PARENT uses in xfs_create, xfs_mkdir and xfs_symlink look good.
> 
> xfs_lock_dir_and_entry should go away and just become and opencoded
> 
> 	xfs_ilock(dp, XFS_ILOCK_EXCL | XFS_ILOCK_PARENT);
> 	xfs_ilock(ip, XFS_ILOCK_EXCL);
> 
> in the two callers, once we made sure to have a sufficient locking
> protocol where we always lock the parent before the child.
> 
> xfs_lock_dir_and_entry can be totally removed and replaced with just
> the two ilock calls if we sort out the locking as proposed in this
> mail.

I'm not sure it is that simple - we currently always group locking of
multiple inodes in increasing inode number order. i don't know what
deadlock that is protecting against.

There's also the case that we can't sleep on the ilock if the inode
in the AIL while we hold the directory lock. Once again I'm not sure
what the deadlock is, but given we are now in a transaction it's
probably a tail-pushing deadlock that it is avoiding.

Without knowing for certain what these are avoiding, I don't think
we should be removing the code blindly....

> > fs/xfs/xfs_vfsops.c - 1.518 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/> > xfs_vfsops.c.diff?r1=text&tr1=1.518&r2=text&tr2=1.517&f=h
> > http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_vfsops.c.diff?r1=text&tr1=1.518&r2=text&tr2=1.517&f=h
> 
> This looks a bit odd to me - the rt inodes are not connected to the
> filesystem namespace so the root inode can't really be it's parent.
> 
> Why are we locking the root inode so early.  Is there a good reason we
> don't delay the locking until we're done with the rt inodes?

No idea - it's like that on irix too, and I don't have time
right now to discover why....

> If not the parent annotation is probably safe beause we never lock
> the rt inode at the same time as any other inode, but it at least needs
> a big comment describing what's going on. 
> 
> 
> 
> Now what seems to be completely lacking is any kind of annotation in
> xfs_rename.c, which is the most difficult thing to get right for
> inode locking because we may have to lock up to four inodes.  I suggest
> to implement the same locking protocol the the VFS uses for locking
> i_mutex, as document in Documentation/filesystems/directory-locking:
> 
> Also xfs_lock_inodes lacks any kind of annotation.

It calls xfs_lock_inumorder() to set up the annotation. The inode number in
the set of inodes to be locked drives the lock subclass for nesting.

Also xfs_rename locking ends up calling xfs_lock_inodes() and so it
does get annotated.

> Let's start with the xfs_lock_inodes that don't fall into rename or
> xfs_lock_dir_and_entry handled above:
> 
> 
>  - xfs_swap_extents locks two inodes of the same type, but these
>    could be directories, so there is a chance we can get into
>    conflicts with the parent->child type locking

Uses xfs_lock_inodes() so subclass nesting is used instead of
parent/child.

>  - xfs_link locks the source inode and the target directory
>    inode.  vfs locking rule is lock parent, lock source and
>    we should follow this as it's in line with the directory
>    before child rule except that the source doesn't always
>    have to be a child, in which case we don't have a problem
>    anyway

It locks in inode number order as per xfs_lock_dir_and_entry()
and uses xfs_lock_inodes() for annotation.

> And now rename gets ugly, we should follow the VFS rules with
> the following required adjustments:
> 
>  - XFS needs both source and target inode (if existing) locked.
>    Because both must be non-directories sorting by inode number
>    should be okay
>  - Doing a lock_rename equivalent for locking the parent directories
>    requires dentries, but only inodes are passed down from the VFS.
>    On the other hand they are obviously guranteed to be directories
>    so i_dentry has exactly one dentry on which we can do the upwards
>    walk.

This is a lot of churn that I don't really see as necessary - why should
we risk deadlocks and difficult to diagnose problems when the current
code works and is now annotated?

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
