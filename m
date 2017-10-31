Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:33642 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933106AbdJaWnd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 31 Oct 2017 18:43:33 -0400
Date: Tue, 31 Oct 2017 15:43:20 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs_repair: clear extra file attributes on symlinks
Message-ID: <20171031224320.GB4911@magnolia>
References: <20171031215156.12544-1-mcgrof@kernel.org>
 <20171031221253.GV4911@magnolia>
 <CAB=NE6WusGvGYVBokMOup9snofncCm9gXopM7BaUukp9N3zbRQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAB=NE6WusGvGYVBokMOup9snofncCm9gXopM7BaUukp9N3zbRQ@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Luis R. Rodriguez" <mcgrof@kernel.org>
Cc: Eric Sandeen <sandeen@sandeen.net>, David Howells <dhowells@redhat.com>, xfs <linux-xfs@vger.kernel.org>, Tso Ted <tytso@mit.edu>, Nikolay Borisov <nborisov@suse.com>, Flex Liu <fliu@suse.com>, Jake Norris <jake.norris@suse.com>, Jan Kara <jack@suse.cz>

On Tue, Oct 31, 2017 at 03:19:00PM -0700, Luis R. Rodriguez wrote:
> On Tue, Oct 31, 2017 at 3:12 PM, Darrick J. Wong
> <darrick.wong@oracle.com> wrote:
> > On Tue, Oct 31, 2017 at 02:51:56PM -0700, Luis R. Rodriguez wrote:
> >> Linux filesystems cannot set extra file attributes (stx_attributes as per
> >> statx(2)) on a symbolic link as ioctl(2) with FS_IOC_SETFLAGS is used for
> >> this purpose, and *all* ioctl(2) calls on a symbolic link yield EBADF.
> >> This is because ioctl(2) tries to obtain struct fd from the symbolic link
> >> file descriptor passed using fdget(), fdget() in turn always returns no
> >> file set when a file descriptor is open with O_PATH. As per symlink(2)
> >> O_PATH and O_NOFOLLOW must *always* be used when you want to get the file
> >> descriptor of a symbolic link, and this holds true for Linux, as such extra
> >> file attributes cannot possibly be set on symbolic links on Linux.
> >>
> >> Given this Linux filesystems should treat extra file attributes set on
> >> symbolic links as corruption and fix them.
> >>
> >>    The TL;DR:
> >>
> >> How I discovered this was finding a corrupted filesystem with symbolic
> >> links with the extra file attribute append (STATX_ATTR_APPEND) set. Symbolic
> >> links with the attribute append set cannot be removed as they are treated as
> >> if a file was set with the immutable flag set. Standard tools however cannot
> >> remove *any* attribute flag:
> >>
> >>       # chattr -a symlink
> >>       chattr: Operation not supported while reading flags on b
> >>
> >> If you end up with these symbolic links userspace cannot remove them.
> >>
> >> Likewise one cannot use the same tool to *set* this extra file attribute on
> >> a symbolic link using chattr:
> >>       # rm -f y z
> >>       # ln -s y z
> >>       # chattr +a z
> >>       chattr: Operation not supported while reading flags on z
> >>
> >> What makes this puzzling was one cannot even list attributes on symlinks
> >> using lsattr either:
> >>
> >>       # rm -f a b
> >>       # ln -s a b
> >>       # lsattr b
> >>       lsattr: Operation not supported While reading flags on b
> >>
> >> The above was due to commit 023d111e92195 ("chattr.1.in: Document the
> >> compression attribute flags E, X, and ...") merged on e2fsprogs v1.28 since
> >> August 2002. That commit just refers to the fact that attributes were only
> >> allowed after that commit for directories and regular files due to Debian
> >> bug 152029 [0]. This bug was filed since lsattr lsattr would segfault when
> >> used against a special file of an old DRM buggy driver, the ioctl seem to
> >> have worked but crashed lsattr with its information. The bug report doesn't
> >> list any specific reasoning for not allowing attributes on symlinks though.
> >>
> >> Crafting your own tool to query the extra file attributes with the new
> >> shiny statx(2) works, and if a symbolic link has the extra attribute
> >> flag set statx(2) would inform userspace of this. statx(2) is only used
> >> for getting file information, not for setting them.
> >>
> >> This all meant that if you end up with the append extra file attribute
> >> set on a symlink you need special tools to try to remove it and currently
> >> that's only possible on XFS with xfs_db [1] [2].
> >>
> >> Fix XFS filesystems which have these extra file attributes set as the only
> >> way they could have been set was through corruption.
> >>
> >> [0] https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=152029
> >> [1] xfs_db -x -c 'inode inode-number' -c 'write core.append 1' /dev/device
> >> [2] xfs_db -x -c 'inode inode-number' -c 'write core.append 0' /dev/device
> >>
> >> Cc: Tso Ted <tytso@mit.edu>
> >> Cc: Nikolay Borisov <nborisov@suse.com>
> >> Cc: Flex Liu <fliu@suse.com>
> >> Cc: Jake Norris <jake.norris@suse.com>
> >> Cc: Jan Kara <jack@suse.cz>
> >> Signed-off-by: Luis R. Rodriguez <mcgrof@kernel.org>
> >> ---
> >>
> >> On this v2 I've provided a much better explanation as to why these
> >> extra file attributes don't make sense on Linux, and trimmed the flags
> >> we venture out to clear to *only* match what statx defines. It may be
> >> possible to clear more dino->di_flags and maybe even dino->di_flags2
> >> for symbolic links however that those be determined separately as the
> >> other flags' semantics are clarified for setting.
> >>
> >>  repair/dinode.c | 21 +++++++++++++++++++++
> >>  1 file changed, 21 insertions(+)
> >>
> >> diff --git a/repair/dinode.c b/repair/dinode.c
> >> index 15ba8cc22b39..6288e42de15e 100644
> >> --- a/repair/dinode.c
> >> +++ b/repair/dinode.c
> >> @@ -2482,6 +2482,27 @@ _("bad (negative) size %" PRId64 " on inode %" PRIu64 "\n"),
> >>                                               FS_XFLAG_EXTSIZE);
> >>                       }
> >>               }
> >> +             if (flags & (XFS_DIFLAG_IMMUTABLE | XFS_DIFLAG_APPEND |
> >> +                          XFS_DIFLAG_NODUMP)) {
> >> +                     /*
> >> +                      * ioctl(fd, *) and so ioctl(fd, FS_IOC_SETFLAGS)
> >> +                      * yields EBADF on symlinks as they have O_PATH set.
> >> +                      * "Extra file attributes", stx_attributes, as per
> >> +                      * statx(2) cannot be set on symlinks on Linux.
> >> +                      */
> >> +                     if (di_mode && S_ISLNK(di_mode) &&
> >> +                         !S_ISREG(di_mode) && !S_ISDIR(di_mode)) {
> >
> > I don't think we can be a link and a file at the same time, right?
> 
> True, the check should be much simpler with just S_ISLNK().
> 
> > Does this DIFLAG clearing applies to bdev/cdev/fifo/socket files too?
> 
> Not at the moment given the semantics I hunted down and tested for
> were for O_PATH only.  The validation I hunted down applies to any
> file descriptors which we open via O_PATH only.

iirc when you open one of those special files you end up with a fd that
points to an inode on a special bdevfs/pipefs/etc., not an inode linked
to the underlying filesystem containing the special file.  Therefore,
you shouldn't be able to set any DIFLAG/DIFLAG2 flags on special files.

# mknod block b 8 0 ; mknod char c 1 3 ; mknod fifo p
# lsattr block char fifo
lsattr: Operation not supported While reading flags on block
lsattr: Operation not supported While reading flags on char
lsattr: Operation not supported While reading flags on fifo

--D

>  Recall that the Debian bug that Ted had fixed in userspace was a work
> around for userspace querying the file extra attributes via ioctl onto
> a buggy DRM driver, so a special file. The *setting* via ioctl() can
> certainly be ruled out for O_PATH files, but for other types of files
> other types of evaluations would be needed.
> 
>  Luis
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
