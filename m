Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail01.adl2.internode.on.net ([150.101.137.133]:48244 "EHLO
        ipmail01.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752376AbdHVX2e (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 22 Aug 2017 19:28:34 -0400
Date: Wed, 23 Aug 2017 09:28:31 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS Bug Report
Message-ID: <20170822232831.GY21024@dastard>
References: <CAFzqJcahyU7F5CJcYKTPabWBVCnufwSMS4QcJijHVVux-Ndv+Q@mail.gmail.com>
 <ad807068-5de9-3200-68ef-de9e42401a5a@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ad807068-5de9-3200-68ef-de9e42401a5a@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Ruoxin Jiang <rj2394@columbia.edu>, linux-xfs@vger.kernel.org, Suman Jana <sumanj@gmail.com>

On Tue, Aug 22, 2017 at 05:33:24PM -0500, Eric Sandeen wrote:
> On 8/22/17 4:10 PM, Ruoxin Jiang wrote:
> > Hello,
> > 
> > We are researchers from Columbia University, New York. As part of our
> > current research we have run into some issues using xfs filesystem.
> > For example, we encountered a case where the setuid bit of a modified
> > executable was not removed as desired.
> 
> Thanks for the reports.
> 
> For case 1:
> 
> > * In xfs, function `xfs_file_aio_write_checks` calls `file_remove_privs` which
> > removes special file priviledges when the executable is written to or truncated.
> > 
> > * If an DIO write is not aligned to device logical sector size, the syscall
> > fails with  EINVAL` before `xfs_file_aio_write_checks` is called. Thus the setuid
> > bit will not be removed from the modified executable.
> 
> If the write did not happen, why should the setuid bit be removed?
> The write failed and the file's contents were not modified.  It seems
> like xfs's behavior makes sense; is there a posix specification that
> indicates the behavior should be different?
> 
> Case 2 does look problematic (failed mmap write extending the file EOF)

mmap should not be able to extend the file at all. It should segv
if an attempt to write past EOF occurs.

> Case 3 seems to show xfs violating this rule, I guess?
> 
>        When  the  owner or group of an executable file are changed by a
>        non-superuser, the S_ISUID and S_ISGID mode  bits  are  cleared.
>        POSIX does not specify whether this also should happen when root
>        does the chown(); the Linux behavior depends on the kernel  ver-
>        sion.   In  case  of  a non-group-executable file (i.e., one for
>        which the S_IXGRP bit is not  set)  the  S_ISGID  bit  indicates
>        mandatory locking, and is not cleared by a chown().
> 
> I thought this was all handled at the vfs, though, odd.

xfs_setattr_nonsize() does:

                /*
                 * CAP_FSETID overrides the following restrictions:
                 *
                 * The set-user-ID and set-group-ID bits of a file will be
                 * cleared upon successful return from chown()
                 */
                if ((inode->i_mode & (S_ISUID|S_ISGID)) &&
                    !capable(CAP_FSETID))
                        inode->i_mode &= ~(S_ISUID|S_ISGID);

Whereas the VFS has this check in should_remove_suid():

        /*
         * sgid without any exec bits is just a mandatory locking mark; leave
         * it alone.  If some exec bits are set, it's a real sgid; kill it.
         */
        if (unlikely((mode & S_ISGID) && (mode & S_IXGRP)))
                kill |= ATTR_KILL_SGID;

	if (unlikely(kill && !capable(CAP_FSETID) && S_ISREG(mode)))
                return kill;

So the VFS is doing the right thing but the XFS code does it's own
thing for reasons I don't remember. Given the VFS handles this, maybe
we should finally remove it from the XFS code?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
