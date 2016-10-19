Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:28189 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S941451AbcJSTes (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 19 Oct 2016 15:34:48 -0400
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [PATCH v8 00/16] re-enable DAX PMD support
Date: Wed, 19 Oct 2016 13:34:19 -0600
Message-Id: <1476905675-32581-1-git-send-email-ross.zwisler@linux.intel.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-kernel@vger.kernel.org
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>, Theodore Ts'o <tytso@mit.edu>, Alexander Viro <viro@zeniv.linux.org.uk>, Andreas Dilger <adilger.kernel@dilger.ca>, Andrew Morton <akpm@linux-foundation.org>, Christoph Hellwig <hch@lst.de>, Dan Williams <dan.j.williams@intel.com>, Dave Chinner <david@fromorbit.com>, Jan Kara <jack@suse.cz>, Matthew Wilcox <mawilcox@microsoft.com>, linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-nvdimm@lists.01.org, linux-xfs@vger.kernel.org

DAX PMDs have been disabled since Jan Kara introduced DAX radix tree based
locking.  This series allows DAX PMDs to participate in the DAX radix tree
based locking scheme so that they can be re-enabled.

Changes since v7:
 - Rebased on v4.9-rc1, dropping one ext4 patch that had already been merged.
 - Added Reviewed-by tags from Jan Kara.

Here is a tree containing my changes:
https://git.kernel.org/cgit/linux/kernel/git/zwisler/linux.git/log/?h=dax_pmd_v8

Ross Zwisler (16):
  ext4: tell DAX the size of allocation holes
  dax: remove buffer_size_valid()
  ext2: remove support for DAX PMD faults
  dax: make 'wait_table' global variable static
  dax: remove the last BUG_ON() from fs/dax.c
  dax: consistent variable naming for DAX entries
  dax: coordinate locking for offsets in PMD range
  dax: remove dax_pmd_fault()
  dax: correct dax iomap code namespace
  dax: add dax_iomap_sector() helper function
  dax: dax_iomap_fault() needs to call iomap_end()
  dax: move RADIX_DAX_* defines to dax.h
  dax: move put_(un)locked_mapping_entry() in dax.c
  dax: add struct iomap based DAX PMD support
  xfs: use struct iomap based DAX PMD fault path
  dax: remove "depends on BROKEN" from FS_DAX_PMD

 fs/Kconfig          |   1 -
 fs/dax.c            | 826 +++++++++++++++++++++++++++++-----------------------
 fs/ext2/file.c      |  35 +--
 fs/ext4/inode.c     |   3 +
 fs/xfs/xfs_aops.c   |  26 +-
 fs/xfs/xfs_aops.h   |   3 -
 fs/xfs/xfs_file.c   |  10 +-
 include/linux/dax.h |  58 +++-
 mm/filemap.c        |   5 +-
 9 files changed, 537 insertions(+), 430 deletions(-)

-- 
2.7.4

