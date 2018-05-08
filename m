Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:44104 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753615AbeEHAb3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 7 May 2018 20:31:29 -0400
Date: Mon, 7 May 2018 17:30:55 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [RFC] vfs: skip extra attributes check on removal for symlinks
Message-ID: <20180508003055.GC11261@magnolia>
References: <20180426234639.12480-1-mcgrof@kernel.org>
 <20180501172319.GK4127@magnolia>
 <20180501174512.GA27853@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180501174512.GA27853@wotan.suse.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Luis R. Rodriguez" <mcgrof@kernel.org>
Cc: viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, sandeen@sandeen.net, dhowells@redhat.com, tytso@mit.edu, fliu@suse.com, jack@suse.cz, jeffm@suse.com, nborisov@suse.com, jake.norris@suse.com, mtk.manpages@gmail.com, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org

On Tue, May 01, 2018 at 05:45:12PM +0000, Luis R. Rodriguez wrote:
> On Tue, May 01, 2018 at 10:23:19AM -0700, Darrick J. Wong wrote:
> > On Thu, Apr 26, 2018 at 04:46:39PM -0700, Luis R. Rodriguez wrote:
> > > Linux filesystems cannot set extra file attributes (stx_attributes as per
> > > statx(2)) on a symbolic link. To set extra file attributes you issue
> > > ioctl(2) with FS_IOC_SETFLAGS, *all* ioctl(2) calls on a symbolic link
> > > yield EBADF.
> > > 
> > > This is because ioctl(2) tries to obtain struct fd from the symbolic link
> > > file descriptor passed using fdget(), fdget() in turn always returns no
> > > file set when a file descriptor is open with O_PATH. As per symlink(2)
> > > O_PATH and O_NOFOLLOW must *always* be used when you want to get the file
> > > descriptor of a symbolic link, and this holds true for Linux, as such extra
> > > file attributes cannot possibly be set on symbolic links on Linux.
> > > 
> > > Filesystems repair utilities should be updated to detect this as
> > > corruption and correct this, however, the VFS *does* respect these
> > > extra attributes on symlinks for removal.
> > > 
> > > Since we cannot set these attributes we should special-case the
> > > immutable/append on delete for symlinks, this would be consistent with
> > > what we *do* allow on Linux for all filesystems.
> > 
> > Ah, ok, so the problem here is that you can't rm an "immutable" symlink
> > nor can you clear the immutable flag on such a beast, so therefore
> > ignore the immutable (and append) flags if we're trying to delete a
> > symlink?
> 
> Yup.
> 
> > I think we ought to teach the xfs inode verifier to check for
> > immutable/append symlinks and return error so that we don't end up with
> > such things in core in the first place,
> 
> Agreed. But note that one way to end up with these things is through
> corruption. Once a user finds this the first signs they'll run into
> (unless they have the awesome new online scrubber) is they cannot delete
> some odd file and not know why. And then they'll see they cannot change
> or remove either the immutable or append flag. The immutable attribute
> is known to not let you delete the file, but its less known that the
> append attribute implies the same. Folks would scratch their heads.
> 
> Since one cannot *set* these attributes on symlinks on Linux, other than
> ignoring such attributes perhaps we should warn about it? As the only
> way you could end up with that is if your filesystem got corrupted.
> 
> But without filesystems having a fix for that merged users can't do anything.
> 
> > and fix xfs_repair to zap such things.
> 
> This is what my patch for xfs_repair does, which is pending review.
> 
> But note that special files are handled differently, I explain the logic on the
> RFC commit log, which is why I suggested splitting up adding a fix for special
> files as a separate patch.
> 
> > That said, for the filesystems that aren't going to check their inodes,
> > I guess this is a (hackish) way to avoid presenting undeletable gunk in
> > the fs to the user...
> 
> That's why its RFC. What is the right thing to do here?

Ideally, none of the filesystems should ever feed garbage to the vfs,
but it's not all that obvious exactly what things the vfs will trip over.
And knowing that a lot of the filesystems do minimal checking if any, I
guess I'll just say that...

...XFS (and probably ext4) should catch immutable symlinks in the inode
verifiers so that xfs_iget returns -EFSCORRUPTED.  For the rest of the
filesystems, it's probably fine to let them delete the symlink since the
user wants to kill it anyway.

> My own logic here was since we cannot possibly allow extended attributes on
> symlinks is to not use them then as well, in this case for delete.
> 
> > (Were it up to me I'd make a common vfs_check_inode() to reject
> > struct inode containing garbage that the vfs won't deal with,
> 
> There certainly are cases that we could come up with for the VFS where
> if such things are found, regardless of the filesystem, we're very sure
> its a corruption. This is just one example, as you note.
> 
> So it is correct that there are two things here:
> 
> 1) Do we respect the attribute for symlink on delete
> 2) Do we warn to users of the fact that the inode is very likely corrupted
>    regardless of the filesystem?

But I suppose we could WARN_ON_ONCE to state that we're allowing
deletion of an immutable symlink that we couldn't possibly have set.
Anyway, couple this patch with a second one to fix the xfs verifier and
I'll be happy.

--D

> This patch only addresses 1) and makes it match the VFS expectation, and
> I think this is safe if we're not doing 2). This is why I'm also looking
> for feedback from linux-api folks.
> 
> This is one of those odd corner cases we run into, and very likely not
> well documented anywhere.
> 
> > and teach the filesystems to use it;
> 
> Or the VFS uses it.
> 
>   Luis
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
