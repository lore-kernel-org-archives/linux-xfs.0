Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:7555 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753520AbdJGWyx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 7 Oct 2017 18:54:53 -0400
Date: Sun, 8 Oct 2017 09:54:49 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS AIL lockup
Message-ID: <20171007225449.GW3666@dastard>
References: <CAMp4zn_YQy+Naggwfu5-aKigyx6rJJ27F7fdL=tRponn8Kug=A@mail.gmail.com>
 <20171001224904.GG3666@dastard>
 <CAOQ4uxgqjhnn8FOfkZAruigQcewNFewhGZ_jnj24RG4mNu5MZQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxgqjhnn8FOfkZAruigQcewNFewhGZ_jnj24RG4mNu5MZQ@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Amir Goldstein <amir73il@gmail.com>
Cc: Sargun Dhillon <sargun@sargun.me>, linux-xfs <linux-xfs@vger.kernel.org>

On Fri, Oct 06, 2017 at 03:29:01PM +0300, Amir Goldstein wrote:
> On Mon, Oct 2, 2017 at 1:49 AM, Dave Chinner <david@fromorbit.com> wrote:
> > On Sun, Oct 01, 2017 at 03:10:03PM -0700, Sargun Dhillon wrote:
> >> I'm running into an issue where xfs aild is locking up. This is on
> >> kernel version 4.9.34. It's an SMP system with 32 cores, and ~250G of
> >> RAM (AWS R4.8XL) and an XFS filesystem with 1 SSD with project ID
> >> quotas in use. It's the only XFS filesystem on the host. The root
> >> partition is running EXT4, and isn't involved in this.
> >>
> >> There are containers that use overlayfs atop this filesystem. It looks
> >> like one of the processes (10090, or 11504) has gotten into a state
> >> where it's holding a lock on a xfs_buf, and they're trying to lock
> >> xfs_buf's which are currently on the xfs ail list.
> >>
> ...
> > Ok, this is a RENAME_WHITEOUT case, and that points to the issue.
> > The whiteout inode is allocated as a temporary inode, which means
> > it remains on the unlinked list so that if we crash part way through
> > the update log recovery will free it again.
> >
> > Once all the dirent updates and other rename work is done, we remove
> > the whiteout inode from the unlinked list, and that requires
> > grabbing the AGI lock. That's what we are stuck on here.
> >
> ...
> >
> > Because this is the deadlock - we're trying to lock the AGF with an
> > AGI already locked. That means the above RENAME_WHITEOUT has either
> > allocated or freed extents in manipulating the dirents during
> > rename, and so holds an AGF locked. It's a classic ABBA deadlock.
> >
> > That's the problem, not sure what the solution is yet - there's no
> > obvious or simple way around this RENAME_WHITEOUT behaviour (which
> > only affects overlay, fwiw). I'll have a think about it.
> >
> 
> Dave,
> 
> Could you explain why the RENAME_WHITEOUT case is different locking
> order wise from linking an O_TEMPFILE?

RENAME_WHITEOUT creates an O_TMPFILE inode in the form or a whiteout
device node in an initial separate transaction, which is fine as
this uses the normal AGI->AGF lock order. This is so if we crash
while doing the rename, log recovery will free the (now unused)
whiteout device node.

We then use the O_TMPFILE inode in the rename, which does all the
directory mods, which take the AGF lock to allocate directory
blocks. Then it removes the O_TMPFILE inode from the unlinked list
because it's now referenced by a directory which takes the AGI lock.


> Is it because xfs_iunlink_remove() is called before xfs_dir_createname()
> in xfs_link()?

Yes, and gives the lock order AGI->AGF.

> Also, in xfs_rename(), before removing whiteout inode from unlinked list,
> the comment says: "If we fail here after bumping the link
>          * count, we're shutting down the filesystem so we'll never see the
>          * intermediate state on disk.",
> but I am not actually seeing where that shutdown takes place, or maybe
> I don't know what to look for.

Say, for example, the journal commit fails. That'll shut down the
filesystem.

The reason for doing the xfs_iunlink_remove() call last is that
if we get a failure to modify a directory entry (e.g. we're at
ENOSPC) before we've dirtied anything in the directories, we'll end
up cancelling a dirty transaction and that will shut down the
filesystem. On failures that should just return an error, we have
to put the inode back on the unlinked list so we can commit the
dirty transaction and return the error. It quickly becomes very
nasty trying to work out all the different error paths and exactly
which ones are fatal (i.e. trigger a shutdown) and those that need
to (and can) put the inode back on the unlinked list successfully
and commit the transaction so things can proceed.

Ideally we need to make the unlinked list removal a deferred op
(i.e. log an intent and then do it after the RENAME_WHITEOUT
transaction has committed). That would leave the error handling
simple and get rid of the lock order problem because it would move
the unlinked list removal to it's own transaction....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
