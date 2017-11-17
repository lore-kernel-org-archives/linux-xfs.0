Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:56448 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754068AbdKQU2f (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 17 Nov 2017 15:28:35 -0500
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [fstests PATCH v4 0/4] add test for DAX MAP_SYNC support
Date: Fri, 17 Nov 2017 13:28:24 -0700
Message-Id: <20171117202828.25472-1-ross.zwisler@linux.intel.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: fstests <fstests@vger.kernel.org>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>, linux-xfs <linux-xfs@vger.kernel.org>, linux-nvdimm <linux-nvdimm@lists.01.org>, Jan Kara <jack@suse.cz>, Dave Chinner <david@fromorbit.com>, Dan Williams <dan.j.williams@intel.com>, Amir Goldstein <amir73il@gmail.com>

The purpose of this series is to exercise the new MAP_SYNC mmap()
functionality [1].  It adds a test which uses dm-log-writes to try and
replay filesystem metadata operations for a file that is being written via
mmap().

If MAP_SYNC is active the dm-log-writes replay will recreate the file's
block allocations and you'll end up with a test file which is a known
size.

If MAP_SYNC is not active the metadata writes will most likely be lost and
the replay will either fail to create the test file at all or it will may
be smaller.  In all of my testing the file simply doesn't exist on the
replay if MAP_SYNC is ommited.

This test relies on a kernel with both the MAP_SYNC mmap() functionality
and the DAX enabling in dm-log-writes.  These will both appear in kernel
v4.15-rc1.  For ease of testing I've posted a kernel that is v4.14 plus
just those two patch series [2].

This test also relies on xfsprogs having support for MAP_SYNC and for
dm-log-writes.  I've posed a tree adding that support [3].  This xfsprogs
series is still under review so if the xfs_io interfaces change this
test will of course need to be updated as well.

Lastly, I've also posted a working version of this series [4].

Changes since v3:
 - Enhanced xfs_io with MAP_SYNC and dm-log-writes functionality instead of
   creating a one-off test program.  (Dave Chinner)

 - Improved dm target version checking. (Amir)

 - Fixed dm-log-writes replay issue, some general cleanup, broke changes
   out into a series.

[1]: https://lists.01.org/pipermail/linux-nvdimm/2017-November/013164.html
[2]: https://git.kernel.org/pub/scm/linux/kernel/git/zwisler/linux.git/log/?h=map_sync_dm_log_writes
[3]: https://git.kernel.org/pub/scm/linux/kernel/git/zwisler/xfsprogs-dev.git/log/?h=map_sync
[4]: https://git.kernel.org/pub/scm/linux/kernel/git/zwisler/xfstests-dev.git/log/?h=map_sync_test_v4

Ross Zwisler (4):
  common/rc: add _scratch_has_mount_option()
  dm-log-writes: only replay log to marks that exist
  dm-log-writes: allow DAX to be used when possible
  generic: add test for DAX MAP_SYNC support

 common/dmlogwrites           |  9 +++--
 common/rc                    | 33 ++++++++++++++++--
 doc/requirement-checking.txt |  5 +--
 tests/generic/468            | 83 ++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/468.out        |  3 ++
 tests/generic/group          |  1 +
 6 files changed, 128 insertions(+), 6 deletions(-)
 create mode 100755 tests/generic/468
 create mode 100644 tests/generic/468.out

-- 
2.9.5

