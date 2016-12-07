Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:23490 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751233AbcLGASR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 6 Dec 2016 19:18:17 -0500
Subject: [PATCH v3 00/11] xfstests: online scrub/repair support
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 06 Dec 2016 16:18:11 -0800
Message-ID: <148106989109.19334.6839386416313318071.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: david@fromorbit.com, eguan@redhat.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

Hi all,

This is the third revision of a patchset that adds to XFS userland
tools support for online metadata scrubbing and repair.

The first patch tests ocfs2's ability to handle reflink when there are
inline-data files.

The second patch maliciously corrupts ext4 and xfs filesystems to
exploit nonexistent checking of i_size in order to coerce Linux into
loading a file with negative size.  It then exploits integer overflows
in the VFS writeback code to hard lock the kernel.

** DO NOT RUN THESE TESTS UNLESS YOU HAVE APPLIED THIS PATCH: **
"vfs: reject inodes with negative size to prevent kernel hang"

---------------

The new patches in this series do three things: first, they expand the
filesystem populate commands inside xfstests to be able to create all
types of XFS metadata.  Second, they create a bunch of xfs_db wrapper
functions to iterate all fields present in a given metadata object and
fuzz them in various ways.  Finally, for each metadata object type there
is a separate test that iteratively fuzzes all fields of that object
and runs it through the mount/scrub/repair loop to see what happens.

If you're going to start using this mess, you probably ought to just
pull from my github trees for kernel[1], xfsprogs[2], and xfstests[3].
The kernel patches in the git trees should apply to 4.9-rc8; xfsprogs
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
