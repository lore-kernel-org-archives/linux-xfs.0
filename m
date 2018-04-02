Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:45328 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753189AbeDBT4Q (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 2 Apr 2018 15:56:16 -0400
Subject: [PATCH v14.1 00/21] xfs: online repair support
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Mon, 02 Apr 2018 12:56:12 -0700
Message-ID: <152269897182.16346.1710955088267364781.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, david@fromorbit.com

Hi all,

This is an update to the fourteenth revision of a patchset that adds to XFS
kernel support for online metadata scrubbing and repair.  There aren't any
on-disk format changes.

New since v14 of these patches are some minor reworks and splits of the
series posted last week.

New since v13 of these patches is the addition of a new output flag
(XFS_SCRUB_OFLAG_UNTOUCHED) that is set when userspace has requested a
repair or a preen, but the kernel did not find that the metadata needed
fixing or optimization.  The flag was added because a misreporting
problem was discovered in xfs_scrub.  If metadata objects A and B can be
cross-referenced, a corruption in B results in xfs_scrub thinking that
it has to repair B (OFLAG_CORRUPT) and ought to ask the kernel if A also
needs repairs (OFLAG_XCORRUPT).  If we repair B and then try to repair
A, the re-examination of A has no way to communicate to xfs_scrub that A
was actually fine, and xfs_scrub mistakenly reports that it fixed A.
This series also fixes a bug wherein if userspace asked the kernel to
repair a metadata object D and the kernel did not support repairing D,
the kernel would return a runtime error even if D was not in need of a
repair.  This caused further reporting errors when xfs_scrub tried to
have OFLAG_XCORRUPT objects re-examined.

The first six patches add or expose various libxfs helpers that the
online repair code will use to reconstruct broken metadata.  Most
notably we add a NORMAP flag to the bmapi functions so that we can
use rmap data to rebuild block maps.

Patch seven allows us to disable inode reclamation temporarily for the few
things that requires full filesystem scans; at the moment that is
limited to the rmap rebuilder.

Patches 8-21 introduce the online repair functionality for space
metadata.  Our general strategy for rebuilding damaged primary metadata
is to rebuild the structure completely from secondary metadata and free
the old structure after the fact; we do not try to salvage anything.
Consequently, online repair requires rmapbt.  Rebuilding the secondary
metadata (rmap) is much harder -- due to our locking rules (primary and
then secondary) we have to shut down the filesystem temporarily while we
scan all the primary metadata for data to put in the new secondary
structure.

Reconstructing inodes is difficult -- the ability to rebuild files
depends on the filesystem being able to load an inode (xfs_iget), which
means repair has to know how to zap any part of an inode record that
might trigger corruption errors from iget.  To that end, we can now
reset most of an inode record or an inode fork so that we can rebuild
the file.

The refcount rebuilder is more or less the same algorithm that
xfs_repair uses, but modified to reflect the constraints of running in
kernel space.

For rmap rebuilds, we cannot have anything on the filesystem taking
exclusive locks and we cannot have any allocation activity at all.
Therefore, we start by freezing the filesystem to allow other
transactions to finish.  Then, we disable periodic inode reclaim and
roll the freeze back just enough so that we can create our own
transactions but other writes will block.  Next, we scan all other AG
metadata structures, every inode, and every block map to reconstruct the
rmap data.  Then, we reinitialize the rmap btree root and reload the
rmap btree.  Finally, we release all the resource we grabbed and the
filesystem returns to normal.

Looking forward, the parent pointer feature that Allison Henderson is
working on will enable us to reconstruct directories, at which point
we'll be able to reconstruct most of a lightly damaged filesystem.  But
that's future talk.

If you're going to start using this mess, you probably ought to just
pull from my git trees.  The kernel patches[1] should apply against
4.16.  xfsprogs[2] and xfstests[3] can be found in their usual
places.  The git trees contain all four series' worth of changes.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

[1] https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=djwong-devel
[2] https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=djwong-devel
[3] https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=djwong-devel
