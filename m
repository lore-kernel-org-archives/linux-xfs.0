Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-ed1-f45.google.com ([209.85.208.45]:41890 "EHLO
        mail-ed1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725932AbeJ3I5G (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 30 Oct 2018 04:57:06 -0400
Received: by mail-ed1-f45.google.com with SMTP id x31-v6so8923826edd.8
        for <linux-xfs@vger.kernel.org>; Mon, 29 Oct 2018 17:06:00 -0700 (PDT)
MIME-Version: 1.0
References: <CAMp4zn_YQy+Naggwfu5-aKigyx6rJJ27F7fdL=tRponn8Kug=A@mail.gmail.com>
 <20171001224904.GG3666@dastard> <CAOQ4uxgqjhnn8FOfkZAruigQcewNFewhGZ_jnj24RG4mNu5MZQ@mail.gmail.com>
 <20171007225449.GW3666@dastard> <CAJDdQW1pLDgPjBpx8RGmT-n4uq+2tP94zmABTN7oBKUEnd7A5A@mail.gmail.com>
In-Reply-To: <CAJDdQW1pLDgPjBpx8RGmT-n4uq+2tP94zmABTN7oBKUEnd7A5A@mail.gmail.com>
From: Sargun Dhillon <sargun@sargun.me>
Date: Mon, 29 Oct 2018 17:05:22 -0700
Message-ID: <CAMp4zn_+PbqyQhKMRbvtPi+M1dY0rL9g8FSWzkLECWySFba6fw@mail.gmail.com>
Subject: Re: XFS AIL lockup
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: zbl.lkml@gmail.com
Cc: david@fromorbit.com, Amir Goldstein <amir73il@gmail.com>, linux-xfs@vger.kernel.org

On Sun, Sep 23, 2018 at 2:54 AM =E5=BC=A0=E6=9C=AC=E9=BE=99 <zbl.lkml@gmail=
.com> wrote:
>
> Hi Dave,
>
> May I ask if the problem has been fixed? It's encountered on our
> 3.10.0-514.16.1.el7.x86_64 production environment too.
>
>
> Cannot find info other places so just wanna confirm.
>
> Thanks,
> Benlong
> Dave Chinner <david@fromorbit.com> =E4=BA=8E2017=E5=B9=B410=E6=9C=888=E6=
=97=A5=E5=91=A8=E6=97=A5 =E4=B8=8A=E5=8D=886:55=E5=86=99=E9=81=93
This behaviour is still preserved in 4.18.

> >
> > On Fri, Oct 06, 2017 at 03:29:01PM +0300, Amir Goldstein wrote:
> > > On Mon, Oct 2, 2017 at 1:49 AM, Dave Chinner <david@fromorbit.com> wr=
ote:
> > > > On Sun, Oct 01, 2017 at 03:10:03PM -0700, Sargun Dhillon wrote:
> > > >> I'm running into an issue where xfs aild is locking up. This is on
> > > >> kernel version 4.9.34. It's an SMP system with 32 cores, and ~250G=
 of
> > > >> RAM (AWS R4.8XL) and an XFS filesystem with 1 SSD with project ID
> > > >> quotas in use. It's the only XFS filesystem on the host. The root
> > > >> partition is running EXT4, and isn't involved in this.
> > > >>
> > > >> There are containers that use overlayfs atop this filesystem. It l=
ooks
> > > >> like one of the processes (10090, or 11504) has gotten into a stat=
e
> > > >> where it's holding a lock on a xfs_buf, and they're trying to lock
> > > >> xfs_buf's which are currently on the xfs ail list.
> > > >>
> > > ...
> > > > Ok, this is a RENAME_WHITEOUT case, and that points to the issue.
> > > > The whiteout inode is allocated as a temporary inode, which means
> > > > it remains on the unlinked list so that if we crash part way throug=
h
> > > > the update log recovery will free it again.
> > > >
> > > > Once all the dirent updates and other rename work is done, we remov=
e
> > > > the whiteout inode from the unlinked list, and that requires
> > > > grabbing the AGI lock. That's what we are stuck on here.
> > > >
> > > ...
> > > >
> > > > Because this is the deadlock - we're trying to lock the AGF with an
> > > > AGI already locked. That means the above RENAME_WHITEOUT has either
> > > > allocated or freed extents in manipulating the dirents during
> > > > rename, and so holds an AGF locked. It's a classic ABBA deadlock.
> > > >
> > > > That's the problem, not sure what the solution is yet - there's no
> > > > obvious or simple way around this RENAME_WHITEOUT behaviour (which
> > > > only affects overlay, fwiw). I'll have a think about it.
> > > >
> > >
> > > Dave,
> > >
> > > Could you explain why the RENAME_WHITEOUT case is different locking
> > > order wise from linking an O_TEMPFILE?
> >
> > RENAME_WHITEOUT creates an O_TMPFILE inode in the form or a whiteout
> > device node in an initial separate transaction, which is fine as
> > this uses the normal AGI->AGF lock order. This is so if we crash
> > while doing the rename, log recovery will free the (now unused)
> > whiteout device node.
> >
> > We then use the O_TMPFILE inode in the rename, which does all the
> > directory mods, which take the AGF lock to allocate directory
> > blocks. Then it removes the O_TMPFILE inode from the unlinked list
> > because it's now referenced by a directory which takes the AGI lock.
> >
> >
> > > Is it because xfs_iunlink_remove() is called before xfs_dir_createnam=
e()
> > > in xfs_link()?
> >
> > Yes, and gives the lock order AGI->AGF.
> >
> > > Also, in xfs_rename(), before removing whiteout inode from unlinked l=
ist,
> > > the comment says: "If we fail here after bumping the link
> > >          * count, we're shutting down the filesystem so we'll never s=
ee the
> > >          * intermediate state on disk.",
> > > but I am not actually seeing where that shutdown takes place, or mayb=
e
> > > I don't know what to look for.
> >
> > Say, for example, the journal commit fails. That'll shut down the
> > filesystem.
> >
> > The reason for doing the xfs_iunlink_remove() call last is that
> > if we get a failure to modify a directory entry (e.g. we're at
> > ENOSPC) before we've dirtied anything in the directories, we'll end
> > up cancelling a dirty transaction and that will shut down the
> > filesystem. On failures that should just return an error, we have
> > to put the inode back on the unlinked list so we can commit the
> > dirty transaction and return the error. It quickly becomes very
> > nasty trying to work out all the different error paths and exactly
> > which ones are fatal (i.e. trigger a shutdown) and those that need
> > to (and can) put the inode back on the unlinked list successfully
> > and commit the transaction so things can proceed.
> >
> > Ideally we need to make the unlinked list removal a deferred op
> > (i.e. log an intent and then do it after the RENAME_WHITEOUT
> > transaction has committed). That would leave the error handling
> > simple and get rid of the lock order problem because it would move
> > the unlinked list removal to it's own transaction....
> >
> > Cheers,
> >
> > Dave.
> > --
> > Dave Chinner
> > david@fromorbit.com
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
