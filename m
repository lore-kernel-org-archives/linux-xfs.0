Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:34495 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752009AbdCVFQM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 22 Mar 2017 01:16:12 -0400
Date: Wed, 22 Mar 2017 01:16:02 -0400
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: boot failure after kernel update, imap claims in-use inode
 661690 is free, would correct imap
Message-ID: <20170322051602.GD5722@birch.djwong.org>
References: <CAJCQCtQ8aZn5y7WjCC=PamChxSw9Fd=0D7o2+S_GEbifV1h+ig@mail.gmail.com>
 <20170315072349.GZ5280@birch.djwong.org>
 <CAJCQCtR8RLOBxK7S9Ck0ATT_5vVY6T9rmLtKrYGLPJTrsDRdNQ@mail.gmail.com>
 <20170315191355.GF5280@birch.djwong.org>
 <20170315193040.GG5280@birch.djwong.org>
 <CAJCQCtRt7_WpEp0npF=k1JJHFLE2sfc9ktB4YakuCZ5CNfZTTg@mail.gmail.com>
 <CAJCQCtRVuKiOMdtGLb3QbR8uCTXbhFMnNQgPzzZWG7y6URawHQ@mail.gmail.com>
 <20170322043438.GD17542@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170322043438.GD17542@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Chris Murphy <lists@colorremedies.com>, xfs list <linux-xfs@vger.kernel.org>

On Wed, Mar 22, 2017 at 03:34:38PM +1100, Dave Chinner wrote:
> On Tue, Mar 21, 2017 at 01:47:12PM -0600, Chris Murphy wrote:
> > On Thu, Mar 16, 2017 at 10:07 PM, Chris Murphy <lists@colorremedies.com> wrote:
> > 
> > > Yuck. I'll ask on systemd list if there's a way to get more verbose
> > > information about this without that. It really ought to be in
> > > systemd.log_level=debug anyway.
> > 
> > I've gotten one response so far, which did not answer the question how
> > to get more verbose debug information.
> > https://lists.freedesktop.org/archives/systemd-devel/2017-March/038502.html
> > 
> > The assertion there is that it's virtually certainly an EBUSY exit code.
> > 
> > Additionally:
> > a. Systemd only ever does a remount to read-only with root fs. It
> > never umounts it.
> > https://github.com/systemd/systemd/blob/master/src/core/umount.c line 413
> > 
> > b. The three messages suggests that it's retrying to remount ro.
> > 
> > c. The failure to remount ro is predicted by the plymouth message "It
> > is running from the root file system, and thus likely to block
> > re-mounting of the root file system to read-only."
> > 
> > d. All of this happens on ext4, XFS, and Btrfs. But only XFS manifests
> > by being unbootable.
> 
> Because, in this case, both ext4 and XFS require a successful
> remount-ro to guarantee that the metadata grub is relying on is
> written to disk. In the case of ext4, you've just been lucky,
> probably because it has a faster background journal flush cycle.
> 
> ....
> 
> > https://github.com/systemd/systemd/blob/master/src/core/shutdown.c
> > line 213 suggests a sync happens. This sync is after pk offline update
> > has finished, so why is this sync not syncing with XFS and ext4? Why
> > does the kernel permit a reboot before root fs has been cleanly
> > umounted?
> 
> sync is /not sufficient/ to force metadata to disk. All that is
> required during sync for a journalling filesystem is to ensure that
> data is flushed and the journal is committed to disk. If the system
> crashes, then log recovery is run and no metadata or data is lost.
> 
> Hence, if grub is trying to find the new kernel that was written to
> disk then sync()d but not unmounted/remounted before rebooting, the
> metadata that grub needs to find the new kernel image is in the
> journal, not resting on disk as grub is assuming it will be.

Yep, that's exactly what I was getting at in my last mail.

> Hence, boot fails because grub/systemd did not correctly
> sync/unmount/remount the filesystem before boot. And, no, having
> grub replay the log is not the answer - that's a recipe for endless
> filesystem corruption problems that filesystem developers will
> disown with "grub screwed up your filesystem, go shout at them".

The prospect of replaying the log in 640K of memory is comical to me!

:P

> FYI, I've ranted previously over many years about how broken grub's
> kernel update and retreival process is fundamentally broken, but
> it's never been fixed(*). As a result, I don't use grub on any of my
> systems, nor do I recommend that anyone else use it.
> 
> (*) The simple fix for grub to freeze/unfreeze the filesystem rather
> than/after calling sync() - this does the same thing as remount-ro,
> but unlike remount-ro it does not fail if there are writable file
> descriptors open.

You mean systemd here, right?  AFAIK the grub scripts (at least on
Debian) don't actually retrieve or update kernels; apt/dpkg still do
that, and they don't use this weird systemd update mode.  So it's really
systemd that ought to be freezing the rootfs as the last thing it does
before triggering the kernel reboot.

(Then again I have separate /boot so it probably gets umounted
successfully bootsplash or otherwise. :P)

--D

> > Meanwhile, retesting on Btrfs, offline check reports no error after
> > the pk offline update reboot; nor when mounting the fs.
> 
> of course - it's the nature of btrfs structure that the superblock
> is updated to only point at a valid tree. If the superblock is not
> updated, then none of the update in progress is even known to
> exist...
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
