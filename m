Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:40519 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S964977AbdAGAfr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 6 Jan 2017 19:35:47 -0500
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v070ZkUa022584
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sat, 7 Jan 2017 00:35:46 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id v070Zjal018385
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sat, 7 Jan 2017 00:35:46 GMT
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id v070ZjCT003280
        for <linux-xfs@vger.kernel.org>; Sat, 7 Jan 2017 00:35:45 GMT
Subject: [PATCH v4 00/47] xfs: online scrub/repair support
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 06 Jan 2017 16:35:44 -0800
Message-ID: <148374934333.30431.11042523766304087227.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

Hi all,

This is the fourth revision of a patchset that adds to XFS kernel
support for online metadata scrubbing and repair.  There aren't any
on-disk format changes.  Changes since v3 include numerous bug fixes and
reorganizing the code into smaller files in the fs/xfs/repair/
directory.  I have also begun using it to check all my development
workstations, which has been useful for flushing out more bugs.

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
filesystems, but the primary goal is first-class XFS support.

The first few patches in this series implements the GETFSMAP ioctl
that maps a device number and physical extent either to filesystem
metadata or to a range of file blocks.  The initial implementation
uses the reverse-mapping B+tree to supply the mapping information,
however a fallback implementation based on the free space btrees is
also provided.  The flexibility of having both implementations is
important when it comes to the userspace tool -- even without the
owner/offset data, we still have enough information to set up a read
verification.

The next half of the patches implement in-kernel scrubbing.  This is
implemented as a new ioctl.  Pass in a metadata type and control data
such as an AG number or inode (when applicable); the kernel will examine
each record in that metadata structure looking for obvious logical
errors.  External corruption should be discoverable via the checksum
embedded in each (v5) filesystem metadata block.  When applicable, the
metadata record will be cross-referenced with the other metadata
structures to look for discrepancies.  Should any errors be found, an
error code is returned to userspace, which in the old days would require
the administrator to take the filesystem offline and repair it.  I've
hidden the new online scrubber behind CONFIG_XFS_DEBUG to keep it
disabled by default.

Last comes the online *repair* functionality, which largely uses the
redundancy between the new reverse-mapping feature introduced in 4.8 and
the existing storage space records (bno, cnt, ino, fino, and bmap) to
reconstruct primary metadata from the secondary, or secondary metadata
from the primaries.  That's right, we can regrow (some) of the XFS
metadata even if parts of the filesystem go bad!  Should the kernel
succeed, it is not necessary to take the filesystem offline for repair.

The last two patches in the series enable xfs_scrub to query the per-AG
block reservations so that the summary counters can be sanity-checked,
and uses one of the new scrub features to prevent mount-time deadlocks
if the refcountbt is corrupt, respectively.

If you're going to start using this mess, you probably ought to just
pull from my github trees.  The kernel patches[1] should apply against
4.10-rc2.  xfsprogs[2] and xfstests[3] can be found in their usual
places.

The patches have survived all auto group xfstests both with scrub-only
mode and also a special debugging mode to xfs_scrub that forces it to
rebuild the metadata structures even if they're not damaged.  Since the
last patch release, I have now had time to run the new tests in [3] that
try to fuzz every field in every data structure on disk.

This is an extraordinary way to eat your data.  Enjoy! 
Comments and questions are, as always, welcome.

--D

[1] https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=djwong-devel
[2] https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=djwong-devel
[3] https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=djwong-devel
