Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail03.adl2.internode.on.net ([150.101.137.141]:22504 "EHLO
        ipmail03.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932375AbdJZIdd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 26 Oct 2017 04:33:33 -0400
Received: from discord.disaster.area ([192.168.1.111])
        by dastard with esmtp (Exim 4.80)
        (envelope-from <david@fromorbit.com>)
        id 1e7dbS-0003CV-EK
        for linux-xfs@vger.kernel.org; Thu, 26 Oct 2017 19:33:26 +1100
Received: from dave by discord.disaster.area with local (Exim 4.89)
        (envelope-from <david@fromorbit.com>)
        id 1e7dbS-0005MA-B3
        for linux-xfs@vger.kernel.org; Thu, 26 Oct 2017 19:33:26 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [RFC PATCH 0/14] xfs: Towards thin provisioning aware filesystems
Date: Thu, 26 Oct 2017 19:33:08 +1100
Message-Id: <20171026083322.20428-1-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

This patchset is aimed at filesystems that are installed on sparse
block devices, a.k.a thin provisioned devices. The aim of the
patchset is to bring the space management aspect of the storage
stack up into the filesystem rather than keeping it below the
filesystem where users and the filesystem have no clue they are
about to run out of space.

The idea is that thin block devices will be massively
over-provisioned giving the filesystem a large block device address
space to manage, but the filesystem presents itself as a much
smaller filesystem. That is, the space the filesystem presents the
users is much lower than the what the address space teh block device
provides.

This somewhat turns traditional thin provisioning on it's head.
Admins are used to lying through their teeth to users about how much
space they have available, and then they hope to hell that users
never try to store as much data as they've been "provisioned" with.
As a result, the traditional failure case is the block device
running out of space all of a sudden and the filesystem and
users wondering WTF just went wrong with their system.

Moving the space management up into the filesystem by itself doesn't
solve this problem - the thin storage pools can still be
over-committed - but it does allow a new way of managing the space.
Essentially, growing or shrinking a thin filesystem is an
operation that only takes a couple of milliseconds to do because
it's just an accounting trick. It's far less complex than creating
a new file, or even reading data from a file.

Freeing unused space from the filesystem isn't done during a shrink
operation. It is done through discard operations, either dynamically
via the discard mount option or, preferrably, by an fstrim
invocation. This means freeing space in the thin pool is not in any
way related to the management of the filesystem size and space
enforcement even during a grow or shrink operation.

What it means is that the filesystem controls the amount of active
data the user can have in the thin pool. The thin pool usage may be
more or less, depending on snapshots, deduplication,
freed-but-not-discarded space, etc. And because of how low the
overhead of changing the accounting is, users don't need to be given
a filesystem with all the space they might need once in a blue moon.
It is trivial to expand when need, and shrink and release when the
data is removed.

Yes, the underlying thin device that the filesystem sits on gets
provisioned at the "once in a blue moon" size that is requested,
but until that space is needed the filesystem can run at low amounts
of reported free space and so prevent the likelyhood of sudden
thin device pool depletion.

Normally, running a filesysetm for low periods of time at low
amounts of free space is a bad thing. However, for a thin
filesystem, a low amount of usable free space doesn't mean the
filesystem is running near full. The filesystem still has the full
block device address to work with, so has oodles of contiguous free
space hidden from the user. hence it's not until the thin filesystem
grows to be near "non-thin" and is near full that the traditional
"running near ENOSPC" problems arise.

How to stop that from ever happening? e.g. Some one needs 100GB of
space now, but maybe much more than that in a year. So provision a
10TB thin block device and put a 100GB thin filesystem on it.
Problems won't arise until it's been grown to 100x it's original
size.

Yeah, it all requires thinking about the way storage is provisioned
and managed a little bit differently, but the key point to realise
is that grow and shrink effectively become free operations on
thin devices if the filesystem is aware that it's on a thin device.

The patchset has several parts to it. It is built on a 4.14-rc5
kernel with for-next and Darrick's scrub tree from a couple of days
ago merged into it.

The first part of teh series is a growfs refactoring. This can
probably stand alone, and the idea is to move the refactored
infrastructure into libxfs so it can be shared with mkfs. This also
cleans up a lot of the cruft in growfs and so makes it much easier
to add the changes later in the series.

The second part of the patchset moves the functionality of
sb_dblocks into the struct xfs_mount. This provides the separation
of address space checks and capacty related calculations that the
thinspace mods require. This also fixes the problem of freshly made,
empty filesystems reporting 2% of the space as used.

The XFS_IOC_FSGEOMETRY ioctl needed to be bumped to a new version
because the structure needed growing.

Finally, there's the patches that provide thinspace support and the
growfs mods needed to grow and shrink.

I've smoke tested the non-thinspace code paths (running auto tests
on a scrub enabled kernel+userspace right now) as I haven't updated
the userspace code to exercise the thinp code paths yet. I know the
concept works, but my userspace code has an older on-disk format
from the prototype so it will take me a couple of days to update and
work out how to get fstests to integrate it reliably. So this is
mainly a heads-up RFC patchset....

Comments, thoughts, flames all welcome....

Cheers,

Dave.
