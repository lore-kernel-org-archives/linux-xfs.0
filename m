Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:64354 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752075AbdERIeI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 18 May 2017 04:34:08 -0400
Date: Thu, 18 May 2017 18:34:05 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 3/3] xfs: freeze rw filesystems just prior to reboot
Message-ID: <20170518083405.GQ17542@dastard>
References: <20170518012618.GT4519@birch.djwong.org>
 <20170518013242.GW4519@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170518013242.GW4519@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: xfs <linux-xfs@vger.kernel.org>, Eric Sandeen <sandeen@redhat.com>

On Wed, May 17, 2017 at 06:32:42PM -0700, Darrick J. Wong wrote:
> Apparently there are certain system software configurations that do odd
> things like update the kernel and reboot without umounting the /boot fs
> or remounting it readonly, either of which would push all the AIL items
> out to disk.  As a result, a subsequent invocation of something like
> grub (which has a frightening willingness to read a fs with a dirty log)
> can read stale disk contents and/or miss files the metadata for which
> have been written to the log but not checkpointed into the filesystem.

> Granted, most of the time /boot is a separate partition and
> systemd/sysvinit/whatever actually /do/ unmount /boot before rebooting.
> This "fix" is only needed for people who have one giant filesystem.

Let me guess the series of events: grub calls "sync" and says "I'm
done", then user runs an immediate reboot/shutdown and something
still running after init has killed everything but PID 1 has an open
writeable file descriptor causing the remount-ro of / to return
EBUSY and so it just shuts down/restarts with an unflushed log?

> Therefore, add a reboot hook to freeze the rw filesystems (which
> checkpoints the log) just prior to reboot.  This is an unfortunate and
> insufficient workaround for multiple layers of inadequate external
> software, but at least it will reduce boot time surprises for the "OS
> updater failed to disengage the filesystem before rebooting" case.
> 
> Seeing as grub is unlikely ever to learn to replay the XFS log (and we
> probably don't want it doing that),

If anything other than XFS code modifies the filesystem (log,
metadata or data) then we have a tainted, unsuportable filesystem
image.....

> *LILO has been discontinued for at least 18 months,

Yet Lilo still works just fine.

> and we're not quite to the point of putting kernel
> files directly on the EFI System Partition,

Really? How have we not got there yet - we were doing this almost
15 years ago with ia64 and elilo via mounting the EFI partition on
/boot....

> this seems like the least
> crappy solution to this problem.
> 
> Yes, you're still screwed in grub if the system crashes. :)

This really sounds like the perennial "grub doesn't ensure the
information it requires to boot is safely on stable storage before
reboot" problem combined with some sub-optimal init behaviour to
expose the grub issue....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
