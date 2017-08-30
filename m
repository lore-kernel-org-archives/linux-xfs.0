Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:24288 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750941AbdH3TuM (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 30 Aug 2017 15:50:12 -0400
Subject: [PATCH v3 0/4] fs, dax: lookup dax_device at mount time
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 30 Aug 2017 12:43:47 -0700
Message-ID: <150412222686.10177.8031279869867070772.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org, linux-ext4@vger.kernel.org
Cc: Jan Kara <jack@suse.cz>, linux-nvdimm@lists.01.org, "Darrick J. Wong" <darrick.wong@oracle.com>, Andreas Dilger <adilger.kernel@dilger.ca>, Theodore Ts'o <tytso@mit.edu>, Christoph Hellwig <hch@lst.de>

Changes since v2 [1]:
* Split fs_dax_get_by_bdev() to its own patch (Christoph)

* Push dax_device reference management into <fs>_{fill,put}_super()
  rather than the generic vfs. (Christoph)

[1]: https://lists.01.org/pipermail/linux-nvdimm/2017-August/012133.html

---

Christoph notes:

    I just noticed that we now do a fs_dax_get_by_host in every
    iomap_begin call for DAX. This function iterates a list, does a
    string compared and igrab. I really think we need to cache this in
    the superblock (possible even the fs superblock) similar to what we
    do for the block device.

This passes the libnvdimm unit tests.

---

Dan Williams (4):
      dax: introduce a fs_dax_get_by_bdev() helper
      xfs: perform dax_device lookup at mount
      ext2: perform dax_device lookup at mount
      ext4: perform dax_device lookup at mount


 drivers/dax/super.c |   10 ++++++++++
 fs/ext2/ext2.h      |    1 +
 fs/ext2/inode.c     |   11 +++--------
 fs/ext2/super.c     |    5 +++++
 fs/ext4/ext4.h      |    1 +
 fs/ext4/inode.c     |   11 +++--------
 fs/ext4/super.c     |    5 +++++
 fs/xfs/xfs_aops.c   |   13 +++++++++++++
 fs/xfs/xfs_aops.h   |    1 +
 fs/xfs/xfs_buf.c    |    4 +++-
 fs/xfs/xfs_buf.h    |    3 ++-
 fs/xfs/xfs_iomap.c  |   10 +---------
 fs/xfs/xfs_super.c  |   25 +++++++++++++++++++++----
 include/linux/dax.h |    6 ++++++
 14 files changed, 75 insertions(+), 31 deletions(-)
