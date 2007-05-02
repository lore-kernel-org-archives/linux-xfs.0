Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 02 May 2007 05:19:37 -0700 (PDT)
Received: from pentafluge.infradead.org (pentafluge.infradead.org [213.146.154.40])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l42CJWfB016412
	for <xfs@oss.sgi.com>; Wed, 2 May 2007 05:19:33 -0700
Date: Wed, 2 May 2007 12:51:05 +0100
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: TAKE 963965 - Add lockdep support for XFS
Message-ID: <20070502115105.GA21031@infradead.org>
References: <20070427085045.D7C6E5910FF9@chook.melbourne.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070427085045.D7C6E5910FF9@chook.melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Lachlan McIlroy <lachlan@sgi.com>
Cc: xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk

On Fri, Apr 27, 2007 at 06:50:45PM +1000, Lachlan McIlroy wrote:
> Add lockdep support for XFS

I don't think this is entirely correct, and it misses some of the
most interesting cases.

I've Cc'ed -fsdevel and Al to get some comments on the more tricky
issues in the rename section at the end of the mail.


> Modid:  xfs-linux-melb:xfs-kern:28485a
> fs/xfs/xfs_vnodeops.c - 1.695 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/> xfs_vnodeops.c.diff?r1=text&tr1=1.695&r2=text&tr2=1.694&f=h
> http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_vnodeops.c.diff?r1=text&tr1=1.695&r2=text&tr2=1.694&f=h

The XFS_ILOCK_PARENT uses in xfs_create, xfs_mkdir and xfs_symlink look good.

xfs_lock_dir_and_entry should go away and just become and opencoded

	xfs_ilock(dp, XFS_ILOCK_EXCL | XFS_ILOCK_PARENT);
	xfs_ilock(ip, XFS_ILOCK_EXCL);

in the two callers, once we made sure to have a sufficient locking
protocol where we always lock the parent before the child.

xfs_lock_dir_and_entry can be totally removed and replaced with just
the two ilock calls if we sort out the locking as proposed in this
mail.



>
> fs/xfs/xfs_vfsops.c - 1.518 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/> xfs_vfsops.c.diff?r1=text&tr1=1.518&r2=text&tr2=1.517&f=h
> http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_vfsops.c.diff?r1=text&tr1=1.518&r2=text&tr2=1.517&f=h

This looks a bit odd to me - the rt inodes are not connected to the
filesystem namespace so the root inode can't really be it's parent.

Why are we locking the root inode so early.  Is there a good reason we
don't delay the locking until we're done with the rt inodes?

If not the parent annotation is probably safe beause we never lock
the rt inode at the same time as any other inode, but it at least needs
a big comment describing what's going on. 



Now what seems to be completely lacking is any kind of annotation in
xfs_rename.c, which is the most difficult thing to get right for
inode locking because we may have to lock up to four inodes.  I suggest
to implement the same locking protocol the the VFS uses for locking
i_mutex, as document in Documentation/filesystems/directory-locking:

Also xfs_lock_inodes lacks any kind of annotation.

Let's start with the xfs_lock_inodes that don't fall into rename or
xfs_lock_dir_and_entry handled above:


 - xfs_swap_extents locks two inodes of the same type, but these
   could be directories, so there is a chance we can get into
   conflicts with the parent->child type locking
 - xfs_link locks the source inode and the target directory
   inode.  vfs locking rule is lock parent, lock source and
   we should follow this as it's in line with the directory
   before child rule except that the source doesn't always
   have to be a child, in which case we don't have a problem
   anyway

And now rename gets ugly, we should follow the VFS rules with
the following required adjustments:

 - XFS needs both source and target inode (if existing) locked.
   Because both must be non-directories sorting by inode number
   should be okay
 - Doing a lock_rename equivalent for locking the parent directories
   requires dentries, but only inodes are passed down from the VFS.
   On the other hand they are obviously guranteed to be directories
   so i_dentry has exactly one dentry on which we can do the upwards
   walk.
   s_vfs_rename_mutex is already held by the vfs so we don't need
   to do that again.

I'd suggest having a copy of the directory-locking file with the
XFS adjustments somewhere so all this is actually well documented.

 - case for source directory == parent directory is trivial.
   lock parent 
