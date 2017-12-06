Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:6496 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753125AbdLFAhw (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 5 Dec 2017 19:37:52 -0500
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [fstests PATCH v5 0/2] add test for DAX MAP_SYNC support
Date: Tue,  5 Dec 2017 17:37:42 -0700
Message-Id: <20171206003744.28587-1-ross.zwisler@linux.intel.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: fstests <fstests@vger.kernel.org>, Eryu Guan <eguan@redhat.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>, linux-xfs <linux-xfs@vger.kernel.org>, linux-nvdimm <linux-nvdimm@lists.01.org>, Jan Kara <jack@suse.cz>, Dave Chinner <david@fromorbit.com>, Dan Williams <dan.j.williams@intel.com>, Amir Goldstein <amir73il@gmail.com>

This is the fifth revision of my xfstest adding a test for the new
mmap() MAP_SYNC flag.  The previous version can be found here:

https://lists.01.org/pipermail/linux-nvdimm/2017-November/013329.html

Changes since v4:
 - Test for dm-log-writes + DAX support in the spirit of
   _require_scratch_dax() instead of relying on specific module version
   number. (Eryu)

 - Print out the missing mark name in the error output of
   _log_writes_replay_log().  (Eryu)

 - Go back to using the output from "du -sh" to test our file block
   allocations.  The "stat -c %s" I was using in v4 was broken if the
   file existed and only had partial block allocations, and the number
   of blocks reported by "stat -c %b" can vary based on the block size.

 - Move the test number to 999 to avoid rebasing collisions.  Feel free
   to renumber as necessary when merging.

I've updated the links at the bottom of this mail to point to the most
recent version of my xfsprogs changes and to the current version of this
series.

---

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
and the DAX enabling in dm-log-writes.  These both appear in kernel
v4.15-rc*.  For ease of testing I've posted a kernel that is v4.14 plus
just those two patch series [2].

This test also relies on xfsprogs having support for MAP_SYNC and for
dm-log-writes.  I've posed a tree adding that support [3].  This xfsprogs
series is still under review so if the xfs_io interfaces change this
test will of course need to be updated as well.

Lastly, I've also posted a working version of this series [4].

[1]: https://lists.01.org/pipermail/linux-nvdimm/2017-November/013164.html
[2]: https://git.kernel.org/pub/scm/linux/kernel/git/zwisler/linux.git/log/?h=map_sync_dm_log_writes
[3]: https://git.kernel.org/pub/scm/linux/kernel/git/zwisler/xfsprogs-dev.git/log/?h=map_sync_v2
[4]: https://git.kernel.org/pub/scm/linux/kernel/git/zwisler/xfstests-dev.git/log/?h=map_sync_test_v5

Ross Zwisler (2):
  dm-log-writes: only replay log to marks that exist
  generic: add test for DAX MAP_SYNC support

 common/dmlogwrites    | 24 +++++++++++++++
 tests/generic/999     | 82 +++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/999.out |  3 ++
 tests/generic/group   |  1 +
 4 files changed, 110 insertions(+)
 create mode 100755 tests/generic/999
 create mode 100644 tests/generic/999.out

-- 
2.14.3

