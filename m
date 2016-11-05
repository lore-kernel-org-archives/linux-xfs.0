Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:17545 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751411AbcKEATI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 4 Nov 2016 20:19:08 -0400
Subject: [PATCH v2 00/41] xfs: online scrub/repair support
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 04 Nov 2016 17:19:03 -0700
Message-ID: <147830514302.2155.3920703176812208304.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

Hi all,

This is the second revision of a patchset that adds to XFS kernel
support for online metadata scrubbing and repair.  There aren't any
on-disk format changes.

Online scrub/repair support consists of four major pieces -- first, an
ioctl that maps physical extents to their owners; second, various
in-kernel metadata scrubbing ioctls to examine metadata records and
cross-reference them with other filesystem metadata; third, an in-kernel
mechanism for rebuilding damaged metadata objects and btrees; and
fourth, a userspace component to initiate kernel scrubbing, walk all
inodes and the directory tree, scrub data extents, and ask the kernel to
repair anything that is broken.

This new utility, xfs_scrub, is separate from the existing offline
xfs_repair tool.  Scrub has three main modes of operation -- in its most
powerful mode, it iterates all XFS metadata and asks the kernel to check
the metadata and repair it if necessary.  The second most powerful mode
can use certain VFS methods and XFS ioctls (BULKSTAT, GETBMAP, and
GETFSMAP) to check as much metadata as it reasonably can from userspace.
It cannot repair anything.  The least powerful mode uses only VFS
functions to access as much of the directory/file/xattr graph as
possible.  It has no mechanism to check internal metadata and also
cannot repair anything.  This is good enough for scrubbing non-XFS
filesystems, but it is intended for the first mode to be used.

The first few patches in this series implements the GETFSMAP ioctl
that maps a device number and physical extent either to filesystem
metadata or to a range of file blocks.  The initial implementation
uses the reverse-mapping B+tree to supply the mapping information,
however a fallback implementation based on the free space btrees is
also provided.  The flexibility of having both implementations is
important when it comes to the userspace tool -- even without the
owner/offset data, we still have enough information to set up a read
verification.

The bulk of the patches implement in-kernel scrubbing.  This is
implemented as a new ioctl.  Pass in a metadata type and control data
such as an AG number or inode (when applicable); the kernel will examine
each record in that metadata structure looking for obvious logical
errors.  External corruption should be discoverable via the checksum
embedded in each (v5) filesystem metadata block.  When applicable, the
metadata record will be cross-referenced with the other metadata
structures to look for discrepancies.  Should any errors be found, an
error code is returned to userspace, which in the old days would require
the administrator to take the filesystem offline and repair it.

However, the new online *repair* functionality uses the redundancy
between the new reverse-mapping feature introduced in 4.8 and the
existing storage space records (bno, cnt, ino, fino, and bmap) to
reconstruct primary metadata from the secondary, or secondary metadata
from the primaries.  That's right, we can regrow (some) of the XFS
metadata even if parts of the filesystem go bad!  Should the kernel
succeed, it is not necessary to take the filesystem offline for repair.

The final patch in the series enables xfs_scrub to query the per-AG
block reservations so that the summary counters can be sanity-checked.

If you're going to start using this mess, you probably ought to just
pull from my github trees for kernel[1], xfsprogs[2], and xfstests[3].
The kernel patches in the git trees should apply to 4.9-rc3; xfsprogs
patches to for-next; and xfstest to master.

The patches have survived all auto group xfstests both with scrub-only
mode and also a special debugging mode to xfs_scrub that forces it to
rebuild the metadata structures even if they're not damaged.  Note that
I haven't thoroughly run the new tests in [3] that try to fuzz every
field in every data structure on disk.

This is an extraordinary way to eat your data.  Enjoy! 
Comments and questions are, as always, welcome.

--D

[1] https://github.com/djwong/linux/tree/djwong-devel
[2] https://github.com/djwong/xfsprogs/tree/djwong-devel
[3] https://github.com/djwong/xfstests/tree/djwong-devel
