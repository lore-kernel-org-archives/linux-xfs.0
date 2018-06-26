Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mga07.intel.com ([134.134.136.100]:23715 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752199AbeFZR7f (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 26 Jun 2018 13:59:35 -0400
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [PATCH v3 0/3] Fix DM DAX handling
Date: Tue, 26 Jun 2018 11:59:29 -0600
Message-Id: <20180626175932.8899-1-ross.zwisler@linux.intel.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Toshi Kani <toshi.kani@hpe.com>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org, linux-xfs@vger.kernel.org

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

---

Changes since v2:
  * Only set QUEUE_FLAG_DAX for fsdax mode PMEM namespaces. (Mike)
  * Check for QUEUE_FLAG_DAX in __bdev_dax_supported(). (Mike)
  * Get rid of DM_TYPE_DAX_BIO_BASED reworks. (Mike)
  * Dropped the first 2 prep patches of v2 since they were merged for
    v4.18-rc1.  (Thanks, Darrick!)

---

Mike, can you take this series through your tree?

Personally I think this should be treated as a bug fix and merged in the
v4.18-rc* series.

Ross Zwisler (3):
  pmem: only set QUEUE_FLAG_DAX for fsdax mode
  dax: bdev_dax_supported() check for QUEUE_FLAG_DAX
  dm: prevent DAX mounts if not supported

 drivers/dax/super.c           | 8 ++++++++
 drivers/md/dm-ioctl.c         | 5 +++++
 drivers/md/dm-table.c         | 7 +++----
 drivers/md/dm.c               | 3 +--
 drivers/nvdimm/pmem.c         | 3 ++-
 include/linux/device-mapper.h | 5 +++++
 6 files changed, 24 insertions(+), 7 deletions(-)

-- 
2.14.4

