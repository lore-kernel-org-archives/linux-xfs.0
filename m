Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mga05.intel.com ([192.55.52.43]:10923 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751768AbdH1DzA (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sun, 27 Aug 2017 23:55:00 -0400
Subject: [PATCH v2 0/2] fs, dax: lookup dax_device at mount time
From: Dan Williams <dan.j.williams@intel.com>
Date: Sun, 27 Aug 2017 20:48:35 -0700
Message-ID: <150389211501.25151.6477753201827914462.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-fsdevel@vger.kernel.org
Cc: jack@suse.cz, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-nvdimm@lists.01.org, linux-xfs@vger.kernel.org, Andreas Dilger <adilger.kernel@dilger.ca>, Jan Kara <jack@suse.com>, Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org, hch@lst.de

Changes since v1:
* Move the lookup to mount time. (Christoph)

---

Christoph notes:

    I just noticed that we now do a fs_dax_get_by_host in every
    iomap_begin call for DAX. This function iterates a list, does a
    string compared and igrab. I really think we need to cache this in
    the superblock (possible even the fs superblock) similar to what we
    do for the block device.

This passes the libnvdimm unit tests.

---

Dan Williams (2):
      fs, xfs: perform dax_device lookup at mount
      ext2, ext4: use the super_block dax_device


 drivers/dax/super.c |   10 ++++++++++
 fs/ext2/inode.c     |   10 ++--------
 fs/ext4/inode.c     |   10 ++--------
 fs/super.c          |   26 +++++++++++++++++++++++---
 fs/xfs/xfs_aops.c   |   13 +++++++++++++
 fs/xfs/xfs_aops.h   |    1 +
 fs/xfs/xfs_buf.c    |    4 +++-
 fs/xfs/xfs_buf.h    |    3 ++-
 fs/xfs/xfs_iomap.c  |   10 +---------
 fs/xfs/xfs_super.c  |   21 +++++++++++++++++----
 include/linux/dax.h |    6 ++++++
 include/linux/fs.h  |    1 +
 12 files changed, 81 insertions(+), 34 deletions(-)
