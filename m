Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-yw1-f67.google.com ([209.85.161.67]:34570 "EHLO
        mail-yw1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726184AbeHYOYl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 25 Aug 2018 10:24:41 -0400
MIME-Version: 1.0
References: <1535101371-26461-1-git-send-email-amir73il@gmail.com> <20180824233901.GA2234@dastard>
In-Reply-To: <20180824233901.GA2234@dastard>
From: Amir Goldstein <amir73il@gmail.com>
Date: Sat, 25 Aug 2018 13:47:52 +0300
Message-ID: <CAOQ4uxj=3N28eSX1papQU4n3bt-J7S=_NhtTFq0xV1k0WgH-Ug@mail.gmail.com>
Subject: Re: [PATCH] xfs: fix GPF in swapfile_activate of file from overlayfs
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, Miklos Szeredi <miklos@szeredi.hu>, linux-xfs <linux-xfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, overlayfs <linux-unionfs@vger.kernel.org>, Al Viro <viro@zeniv.linux.org.uk>

[+cc: Al,linux-unionfs]

On Sat, Aug 25, 2018 at 2:39 AM Dave Chinner <david@fromorbit.com> wrote:
>
> On Fri, Aug 24, 2018 at 12:02:51PM +0300, Amir Goldstein wrote:
> > Since overlayfs implements stacked file operations, f_inode
> > is no longer euqivalent to f_mapping->host and xfs should use
> > the latter, same as generic_swapfile_activate().
>
> Since when has file_inode() not pointed to the inode backing the
> struct file?
>
> > Using f_inode results in an attempt to dereference an xfs_inode
> > struct from an ovl_inode pointer:
> >
> >  CPU: 0 PID: 2462 Comm: swapon Not tainted
> >  4.18.0-xfstests-12721-g33e17876ea4e #3402
> >  RIP: 0010:xfs_find_bdev_for_inode+0x23/0x2f
> >  Call Trace:
> >   xfs_iomap_swapfile_activate+0x1f/0x43
> >   __se_sys_swapon+0xb1a/0xee9
> >
> > Fixes: d1d04ef8572b ("ovl: stack file ops")
>
> Oh, since about 3 days ago.
>
> So now we've got to deal with a vfs interface change that isn't
> documented, hasn't been clearly communicated prior to merging, and
> it subtly breaks a subset of callers.
>

Well, when you put it this way... ;-)

First of all - self NACK.
My fix is papering over a bigger issue, that is leaking of overlay
file/inode into xfs f_aops.
I believe the correct fix right now would be to add an overlayfs hack
in swapon(), as well as some other hacks in mm/* syscalls
(e.g. readahead()).

The virtue of merging stacked file operations was getting rid of many
VFS hacks, but the last chapter has not been written yet, or to put it
in Al's words [1]:

"Uses of ->vm_file (and rules for those) are too convoluted to untangle
at the moment.  I still would love to get that straightened out, but
it's not this cycle fodder, more's the pity..."

So I expect this cycle will require adding a few temporary mm
syscall hacks, in the hope they will be more short lived than the
departing VFS hacks.

> So, please enlighten me with a documentation patch before changing
> any XFS code: What is the new behaviour and the rules we must follow
> for calling file_inode()?
>

Actually, I believe the intention was that fs developers don't need to worry
about using file_inode() at all, because before the change we had:

- file passed in to xfs f_op's and a_ops is either overlay file OR xfs file
- file_inode() of either overlay/xfs file in xfs context is always xfs inode
- file->f_path in xfs context, BTW, was overlay path and therefore,
  XFS_IOC_OPEN_BY_HANDLE was slightly broken in overlayfs over xfs,
  as were several other fs specific ioctls

After stacked file operations change we should have the rules:

1. file passed in to xfs f_op's is always xfs file (*)
2. file passed in to xfs a_ops is always xfs file (**)
3. file_inode() of overlay file is an overlay inode

(*) as explicit file argument or on iocb->ki_filp
(**) as explicit file argument or on ->vm_file

I believe that swapfile leaking an overlay file into xfs was an oversight,
that is breaking rule #2.

> I'm also interested in understanding whether anyone auditted all the
> callers to see if they follow those rules.  There are another
> 20-odd file_inode() calls in XFS, and ~750 across fs/. How many
> other places have been checked for correctness under the new rules?
>

It is my understanding that code was reviewed by Al with the
assumptions made above about users of file_inode() not being affected
by this change. If those assumptions hold, then filesystem specific code
should not be affected.

So looking for users of file_inode() is looking for the wrong thing.
We need to be looking for entry points that can pass an overlay file
to fs f_aops. I found two and I'll keep looking.

> i.e.  I can't review this patch without also confirming that all the
> other file_inode() callers in XFS are still correct, and I can't do
> that until I understand what the new behaviour of file_inode() is
> and when it is not safe to use.
>

I audited the XFS uses of file_inode() and they seem to be correct
because they are all inside implementations of file or address_space
operations and operate on file argument passed in directly as one of
the operation arguments or indirectly via ->vm_file or iocb->ki_filp.

All calls to file_inode() in  xfs_file.c are in static helpers that are not
called by any non static (or non fs operation) function.
In xfs_ioctl*.c, some calls to file_inode() are not in static helpers,
but those are only called from both ioctl operation variants.

The one exception I found is file_inode(tmp.file) call in
xfs_ioc_swapext() which is operating on a file passed in by
user via ioctl arg, but that case is well covered by a validation
check (tmp.file->f_op != &xfs_file_operations).

Cheers,
Amir.

[1] https://marc.info/?l=linux-fsdevel&m=152882788408566&w=2
