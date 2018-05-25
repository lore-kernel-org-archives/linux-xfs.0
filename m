Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mga18.intel.com ([134.134.136.126]:17942 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1030329AbeEYWBA (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 25 May 2018 18:01:00 -0400
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [PATCH resend 0/7] Fix DM DAX handling
Date: Fri, 25 May 2018 16:00:48 -0600
Message-Id: <20180525220055.18920-1-ross.zwisler@linux.intel.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Toshi Kani <toshi.kani@hpe.com>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org, linux-xfs@vger.kernel.org

No code changes from v1.  Just CCing the xfs mailing list & adding one
Reviewed-by from Darrick.

---

This series fixes a few issues that I found with DM's handling of DAX
devices.  Here are some of the issues I found:

 * We can create a dm-stripe or dm-linear device which is made up of an
   fsdax PMEM namespace and a raw PMEM namespace but which can hold a
   filesystem mounted with the -o dax mount option.  DAX operations to
   the raw PMEM namespace part lack struct page and can fail in
   interesting/unexpected ways when doing things like fork(), examining
   memory with gdb, etc.

 * We can create a dm-stripe or dm-linear device which is made up of an
   fsdax PMEM namespace and a BRD ramdisk which can hold a filesystem
   mounted with the -o dax mount option.  All I/O to this filesystem
   will fail.

 * In DM you can't transition a dm target which could possibly support
   DAX (mode DM_TYPE_DAX_BIO_BASED) to one which can't support DAX
   (mode DM_TYPE_BIO_BASED), even if you never use DAX.

The first 2 patches in this series are prep work from Darrick and Dave
which improve bdev_dax_supported().  The last 5 problems fix the above
mentioned problems in DM.  I feel that this series simplifies the
handling of DAX devices in DM, and the last 5 DM-related patches have a
net code reduction of 50 lines.

Darrick J. Wong (1):
  fs: allow per-device dax status checking for filesystems

Dave Jiang (1):
  dax: change bdev_dax_supported() to support boolean returns

Ross Zwisler (5):
  dm: fix test for DAX device support
  dm: prevent DAX mounts if not supported
  dm: remove DM_TYPE_DAX_BIO_BASED dm_queue_mode
  dm-snap: remove unnecessary direct_access() stub
  dm-error: remove unnecessary direct_access() stub

 drivers/dax/super.c           | 44 +++++++++++++++++++++----------------------
 drivers/md/dm-ioctl.c         | 16 ++++++----------
 drivers/md/dm-snap.c          |  8 --------
 drivers/md/dm-table.c         | 29 +++++++++++-----------------
 drivers/md/dm-target.c        |  7 -------
 drivers/md/dm.c               |  7 ++-----
 fs/ext2/super.c               |  3 +--
 fs/ext4/super.c               |  3 +--
 fs/xfs/xfs_ioctl.c            |  3 ++-
 fs/xfs/xfs_iops.c             | 30 ++++++++++++++++++++++++-----
 fs/xfs/xfs_super.c            | 10 ++++++++--
 include/linux/dax.h           | 12 ++++--------
 include/linux/device-mapper.h |  8 ++++++--
 13 files changed, 88 insertions(+), 92 deletions(-)

-- 
2.14.3

