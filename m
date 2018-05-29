Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mga06.intel.com ([134.134.136.31]:7359 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S966529AbeE2TvM (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 29 May 2018 15:51:12 -0400
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [PATCH v2 0/7] Fix DM DAX handling
Date: Tue, 29 May 2018 13:50:59 -0600
Message-Id: <20180529195106.14268-1-ross.zwisler@linux.intel.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Toshi Kani <toshi.kani@hpe.com>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org, linux-xfs@vger.kernel.org

Changes from v1:
 * Reworked patches 1 and 2 so that the __bdev_dax_supported() function
   stays hidden behind the bdev_dax_supported() wrapper.  This is needed
   to prevent compilation errors in configs where CONFIG_FS_DAX isn't
   defined. (0-day)

 * Added Eric's Reviewed-by to patch 1.  I did this in spite of the
   bdev_dax_supported() changes because they were minor and I think
   Eric's review was focused on the XFS parts.

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

 drivers/dax/super.c           | 40 ++++++++++++++++++++--------------------
 drivers/md/dm-ioctl.c         | 16 ++++++----------
 drivers/md/dm-snap.c          |  8 --------
 drivers/md/dm-table.c         | 29 +++++++++++------------------
 drivers/md/dm-target.c        |  7 -------
 drivers/md/dm.c               |  7 ++-----
 fs/ext2/super.c               |  3 +--
 fs/ext4/super.c               |  3 +--
 fs/xfs/xfs_ioctl.c            |  3 ++-
 fs/xfs/xfs_iops.c             | 30 +++++++++++++++++++++++++-----
 fs/xfs/xfs_super.c            | 10 ++++++++--
 include/linux/dax.h           | 11 ++++++-----
 include/linux/device-mapper.h |  8 ++++++--
 13 files changed, 88 insertions(+), 87 deletions(-)

-- 
2.14.3

