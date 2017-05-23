Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:64376 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1762551AbdEWLod (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 23 May 2017 07:44:33 -0400
Date: Tue, 23 May 2017 21:44:19 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 3/3] xfs: freeze rw filesystems just prior to reboot
Message-ID: <20170523114419.GY17542@dastard>
References: <20170518012618.GT4519@birch.djwong.org>
 <20170518013242.GW4519@birch.djwong.org>
 <20170518083405.GQ17542@dastard>
 <20170518223053.GD4519@birch.djwong.org>
 <CAJCQCtTj-7BovZbXyZu9=Dhh4ROR-AJ6Dpsw1GKbM-a2fr+uVw@mail.gmail.com>
 <20170519210040.GL4519@birch.djwong.org>
 <20170522020112.GV17542@dastard>
 <CAJCQCtTj4it6o-Fop6vm3s_HFbRemF5o_H9w-tvS6wmFfVwKBA@mail.gmail.com>
 <CAJCQCtT5riGri5d3cin9BipUso9mfQ-PBqoPzMZEEYm8RezJdA@mail.gmail.com>
 <4167af4e-edf2-9d08-94fa-5ec3fb38f32d@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4167af4e-edf2-9d08-94fa-5ec3fb38f32d@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>
Cc: Chris Murphy <lists@colorremedies.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, xfs <linux-xfs@vger.kernel.org>

On Mon, May 22, 2017 at 11:04:54PM -0500, Eric Sandeen wrote:
> On 5/22/17 10:56 PM, Chris Murphy wrote:
> > On Mon, May 22, 2017 at 2:46 PM, Chris Murphy <lists@colorremedies.com> wrote:
> > 
> >> Second, I have only been able to reproduce this problem with grubby +
> >> XFS.
> > 
> > OK so this is just on Fedora/RH systems, which is the example case I
> > have. The kernel RPM is running a script called new-kernel-pkg which
> > is part of grubby. It's found here:
> > 
> > https://github.com/rhinstaller/grubby/blob/master/new-kernel-pkg
> > 
> > # make sure changes make it to the disk.
> > # if /boot is a mountpoint, force the meta data on disk
> > # to by-pass writeback delay.
> > # PPC64LE-only to deal with Petitboot issues
> > if [ "$ARCH" = "ppc64le" ]; then
> >     sync && mountpoint -q /boot && fsfreeze -f /boot && fsfreeze -u /boot
> > fi
> > 
> > 
> > So why only Petitboot on ppc64 is considered to need this?

> because petitboot essentially a full kernel & userspace, and it is
> (may be?) a different endianness than the os and the filesystem it's booting...
> so normally it actually /could/ replay the log, but it can't due to the
> different endianness.  So, freeze / unfreeze to quiesce, and then
> petitboot does mount -o norecovery to ignore the unmount record we leave
> lying around on a frozen fs.

Actually, IIUC what Stewart told me at LCA earlier this year, what
petitboot does now is far more convoluted and whacky than mount -o
norecovery. It overlays a write-capturing ram disk on top of the
block device, mounts the filesystem and performs log recovery.  All
writes from log recovery go into the ram disk so it never modifies
the underlying block device. It then traverses the recovered
filesystem to find the kernel images, and once they are found it
boots from them, throwing away the ramdisk that contained the
recovered changes from the log.

> Hacks upon hacks.

It's hacks all the way down....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
