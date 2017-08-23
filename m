Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:31713 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754129AbdHWQf5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 23 Aug 2017 12:35:57 -0400
Date: Wed, 23 Aug 2017 09:35:43 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: XFS Bug Report
Message-ID: <20170823163543.GX4796@magnolia>
References: <CAFzqJcahyU7F5CJcYKTPabWBVCnufwSMS4QcJijHVVux-Ndv+Q@mail.gmail.com>
 <ad807068-5de9-3200-68ef-de9e42401a5a@sandeen.net>
 <20170822232831.GY21024@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170822232831.GY21024@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, Ruoxin Jiang <rj2394@columbia.edu>, linux-xfs@vger.kernel.org, Suman Jana <sumanj@gmail.com>

On Wed, Aug 23, 2017 at 09:28:31AM +1000, Dave Chinner wrote:
> On Tue, Aug 22, 2017 at 05:33:24PM -0500, Eric Sandeen wrote:
> > On 8/22/17 4:10 PM, Ruoxin Jiang wrote:
> > > Hello,
> > > 
> > > We are researchers from Columbia University, New York. As part of our
> > > current research we have run into some issues using xfs filesystem.
> > > For example, we encountered a case where the setuid bit of a modified
> > > executable was not removed as desired.
> > 
> > Thanks for the reports.
> > 
> > For case 1:
> > 
> > > * In xfs, function `xfs_file_aio_write_checks` calls `file_remove_privs` which
> > > removes special file priviledges when the executable is written to or truncated.
> > > 
> > > * If an DIO write is not aligned to device logical sector size, the syscall
> > > fails with  EINVAL` before `xfs_file_aio_write_checks` is called. Thus the setuid
> > > bit will not be removed from the modified executable.
> > 
> > If the write did not happen, why should the setuid bit be removed?
> > The write failed and the file's contents were not modified.  It seems
> > like xfs's behavior makes sense; is there a posix specification that
> > indicates the behavior should be different?
> > 
> > Case 2 does look problematic (failed mmap write extending the file EOF)
> 
> mmap should not be able to extend the file at all. It should segv
> if an attempt to write past EOF occurs.

  const char *filename = "file0";

  r[0] = creat(filename, 00666);
  r[1] = write(r[0], "1234567890", 10);
  printf("write()=%ld, errno=%d\n", r[1], errno);

Ok, so we create "file0" as r[0] and write 10 bytes...

  r[2] = creat(filename, 00444);

...then open again as r[2] and truncate it...

  r[3] = write(r[2], "A", 1);

...and write a single byte to the truncated file.  i_size is now 1, and
we have two file descriptions r0 and r2 both pointing to it.  r0's
position is 10 and r2's position is 1.

  printf("write()=%ld, errno=%d\n", r[3], errno);

  r[4] = syscall(__NR_mmap, 0x20000000ul, 0xc000ul, 0x0ul, 0x32ul,
                         0xfffffffffffffffful, 0x0ul, 0, 0, 0);

Create a 48k mapping at 0x20000000 to some anonymous memory... with
PROT_NONE.

  r[5] = syscall(__NR_write, r[0], 0x2000b000ul, 0x1ul, 0, 0, 0, 0, 0, 0);
  printf("write()=%ld, errno=%d\n", r[5], errno);

Then try to write 1 byte to r0 (whose pos is 10) from this anonymous
region, which bails out with EFAULT because the region is PROT_NONE.
This is effectively pwrite(r[0], <unreadable>, 1, 10);

Therefore, it's not an mmap write that extends the file length, it's the
write call that moves out EOF in preparation for the write, only to have
the buffered write fail because the process doesn't have read access to
the memory buffer.

Not sure what to do about this corner case, though -- I guess you could
check that at least the first byte of the write will succeed, and only
then call xfs_zero_eof.  Could still be a TOCTOU race though.

Thoughts?

--D

> 
> > Case 3 seems to show xfs violating this rule, I guess?
> > 
> >        When  the  owner or group of an executable file are changed by a
> >        non-superuser, the S_ISUID and S_ISGID mode  bits  are  cleared.
> >        POSIX does not specify whether this also should happen when root
> >        does the chown(); the Linux behavior depends on the kernel  ver-
> >        sion.   In  case  of  a non-group-executable file (i.e., one for
> >        which the S_IXGRP bit is not  set)  the  S_ISGID  bit  indicates
> >        mandatory locking, and is not cleared by a chown().
> > 
> > I thought this was all handled at the vfs, though, odd.
> 
> xfs_setattr_nonsize() does:
> 
>                 /*
>                  * CAP_FSETID overrides the following restrictions:
>                  *
>                  * The set-user-ID and set-group-ID bits of a file will be
>                  * cleared upon successful return from chown()
>                  */
>                 if ((inode->i_mode & (S_ISUID|S_ISGID)) &&
>                     !capable(CAP_FSETID))
>                         inode->i_mode &= ~(S_ISUID|S_ISGID);
> 
> Whereas the VFS has this check in should_remove_suid():
> 
>         /*
>          * sgid without any exec bits is just a mandatory locking mark; leave
>          * it alone.  If some exec bits are set, it's a real sgid; kill it.
>          */
>         if (unlikely((mode & S_ISGID) && (mode & S_IXGRP)))
>                 kill |= ATTR_KILL_SGID;
> 
> 	if (unlikely(kill && !capable(CAP_FSETID) && S_ISREG(mode)))
>                 return kill;
> 
> So the VFS is doing the right thing but the XFS code does it's own
> thing for reasons I don't remember. Given the VFS handles this, maybe
> we should finally remove it from the XFS code?
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
