Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41312 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932114AbdKAXuJ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 1 Nov 2017 19:50:09 -0400
Date: Thu, 2 Nov 2017 00:50:07 +0100
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: Re: [PATCH] xfs_repair: clear extra file attributes on symlinks
Message-ID: <20171101235007.GF22894@wotan.suse.de>
References: <20171031215156.12544-1-mcgrof@kernel.org>
 <20171031221253.GV4911@magnolia>
 <CAB=NE6WusGvGYVBokMOup9snofncCm9gXopM7BaUukp9N3zbRQ@mail.gmail.com>
 <20171031224320.GB4911@magnolia>
 <20171031231022.GD22894@wotan.suse.de>
 <659d0936-f2a0-5604-b72c-6b3ded3da4f7@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <659d0936-f2a0-5604-b72c-6b3ded3da4f7@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: "Luis R. Rodriguez" <mcgrof@kernel.org>, "Darrick J. Wong" <darrick.wong@oracle.com>, David Howells <dhowells@redhat.com>, xfs <linux-xfs@vger.kernel.org>, Tso Ted <tytso@mit.edu>, Nikolay Borisov <nborisov@suse.com>, Flex Liu <fliu@suse.com>, Jake Norris <jake.norris@suse.com>, Jan Kara <jack@suse.cz>

On Tue, Oct 31, 2017 at 06:12:30PM -0500, Eric Sandeen wrote:
> 
> 
> On 10/31/17 6:10 PM, Luis R. Rodriguez wrote:
> > On Tue, Oct 31, 2017 at 03:43:20PM -0700, Darrick J. Wong wrote:
> >> On Tue, Oct 31, 2017 at 03:19:00PM -0700, Luis R. Rodriguez wrote:
> >>> On Tue, Oct 31, 2017 at 3:12 PM, Darrick J. Wong
> >>> <darrick.wong@oracle.com> wrote:
> >>>> On Tue, Oct 31, 2017 at 02:51:56PM -0700, Luis R. Rodriguez wrote:
> >>>>> diff --git a/repair/dinode.c b/repair/dinode.c
> >>>>> index 15ba8cc22b39..6288e42de15e 100644
> >>>>> --- a/repair/dinode.c
> >>>>> +++ b/repair/dinode.c
> >>>>> @@ -2482,6 +2482,27 @@ _("bad (negative) size %" PRId64 " on inode %" PRIu64 "\n"),
> >>>>>                                               FS_XFLAG_EXTSIZE);
> >>>>>                       }
> >>>>>               }
> >>>>> +             if (flags & (XFS_DIFLAG_IMMUTABLE | XFS_DIFLAG_APPEND |
> >>>>> +                          XFS_DIFLAG_NODUMP)) {
> >>>>> +                     /*
> >>>>> +                      * ioctl(fd, *) and so ioctl(fd, FS_IOC_SETFLAGS)
> >>>>> +                      * yields EBADF on symlinks as they have O_PATH set.
> >>>>> +                      * "Extra file attributes", stx_attributes, as per
> >>>>> +                      * statx(2) cannot be set on symlinks on Linux.
> >>>>> +                      */
> >>>>> +                     if (di_mode && S_ISLNK(di_mode) &&
> >>>>> +                         !S_ISREG(di_mode) && !S_ISDIR(di_mode)) {
> >>>>
> >>>> Does this DIFLAG clearing applies to bdev/cdev/fifo/socket files too?
> >>>
> >>> Not at the moment given the semantics I hunted down and tested for
> >>> were for O_PATH only.  The validation I hunted down applies to any
> >>> file descriptors which we open via O_PATH only.
> >>
> >> iirc when you open one of those special files you end up with a fd that
> >> points to an inode on a special bdevfs/pipefs/etc., not an inode linked
> >> to the underlying filesystem containing the special file.
> > 
> > That seems to fit the O_PATH intent, however its unclear if O_PATH was needed,
> > as per my testing on /dev/loop0 I don't need O_PATH set for it.
> > 
> >> Therefore you shouldn't be able to set any DIFLAG/DIFLAG2 flags on special files.
> > 
> > That would be great if we can verify.
> > 
> >> # mknod block b 8 0 ; mknod char c 1 3 ; mknod fifo p
> >> # lsattr block char fifo
> >> lsattr: Operation not supported While reading flags on block
> >> lsattr: Operation not supported While reading flags on char
> >> lsattr: Operation not supported While reading flags on fifo
> > 
> > I'm afraid e2fsprogs has a special check for these, ie, userspace is barred
> > from actually toying with special files purposely because of the Debian bug I
> > named.
> > 
> > strace should reveal the respective ioctl() was not actually issued.
> 
> That's very easy to short-circuit in e2fsprogs if you'd like to test what
> the kernel does today.

I meant that *I know* that the ioctl() is not issued, as it is a guard implemented
on e2fsprogs to avoid potentially interfacing with buggy kernel drivers.

One however can write a program which does the raw ioctl() call to really test.

For all the above: block char fifo, ioctl() with FS_IOC_FSGETXATTR and
FS_IOC_FSSETXATTR fails with: -1 an errno is set to ENOTTY (Inappropriate ioctl
for device). Reason is that vfs_ioctl() is used, and on XFS we'll hit the goto
out here as no f_op callbacks are set for these special  devices:

long vfs_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
{
        int error = -ENOTTY;                                                    
                                                                                
        if (!filp->f_op->unlocked_ioctl)                                        
                goto out;                                                       
                                                                                
        error = filp->f_op->unlocked_ioctl(filp, cmd, arg);                     
        if (error == -ENOIOCTLCMD)                                              
                error = -ENOTTY;                                                
 out:                                                                           
        return error;                                                           
}

My point also was that the above logic is different than for symlink. I'd  much
prefer to address these as a secondary patch given the logic is different.

PF_LOCAL named sockets are also represented on the filesystem, and same situation
with them, so I can bunch up a check for them as well. Are you OK with these
going in as separate patches or do you want me to mesh this all together along
with the new explanation for these?

  Luis
