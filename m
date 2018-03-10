Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:41589 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750735AbeCJHDz (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 10 Mar 2018 02:03:55 -0500
Subject: [PATCH v5 00/11] dax: fix dma vs truncate/hole-punch
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 09 Mar 2018 22:54:49 -0800
Message-ID: <152066488891.40260.14605734226832760468.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-nvdimm@lists.01.org
Cc: Dave Hansen <dave.hansen@linux.intel.com>, Peter Zijlstra <peterz@infradead.org>, Jeff Moyer <jmoyer@redhat.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Andreas Dilger <adilger.kernel@dilger.ca>, Jan Kara <jack@suse.cz>, Jan Kara <jack@suse.com>, Michal Hocko <mhocko@suse.com>, Christoph Hellwig <hch@lst.de>, Ross Zwisler <ross.zwisler@linux.intel.com>, Matthew Wilcox <mawilcox@microsoft.com>, Ingo Molnar <mingo@redhat.com>, Dave Chinner <david@fromorbit.com>, =?utf-8?b?SsOpcsO0bWU=?= Glisse <jglisse@redhat.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-ext4@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>, Andrew Morton <akpm@linux-foundation.org>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.orgjack@suse.czross.zwisler@linux.intel.comhch@lst.de, linux-kernel@vger.kernel.org

Changes since v4 [1]:
* Kill the DEFINE_FSDAX_AOPS macro and just open code new
  address_space_operations instances for each fs (Matthew, Jan, Dave,
  Christoph)

* Rename routines that had a 'dma_' prefix with 'dax_layout_' and merge
  the dax-layout-break into xfs_break_layouts() (Dave, Christoph)

* Rework the implementation to have the fsdax core find the pages, but
  leave the responsibility of waiting on those pages to the filesystem
  (Dave).

* Drop the nfit_test infrastructure for testing this mechanism, I plan
  to investigate better mechanisms for injecting arbitrary put_page()
  delays for dax pages relative to an extent unmap operation. The
  dm_delay target does not do what I want since it operates at whole
  device level. A better test interface would be a mechanism to delay
  I/O completion based on whether a bio referenced a given LBA.

Not changed since v4:
* This implementation still relies on RCU for synchronizing
  get_user_pages() and get_user_pages_fast() against
  dax_layout_busy_page(). We could perform the operation with just
  barriers if we knew at get_user_pages() time that the pages were flagged
  for truncation.  However, dax_layout_busy_page() does not have the
  information to flag that a page is actually going to be truncated, only
  that it *might* be truncated.

[1]: https://lists.01.org/pipermail/linux-nvdimm/2017-December/013704.html

----

Background:

get_user_pages() in the filesystem pins file backed memory pages for
access by devices performing dma. However, it only pins the memory pages
not the page-to-file offset association. If a file is truncated the
pages are mapped out of the file and dma may continue indefinitely into
a page that is owned by a device driver. This breaks coherency of the
file vs dma, but the assumption is that if userspace wants the
file-space truncated it does not matter what data is inbound from the
device, it is not relevant anymore. The only expectation is that dma can
safely continue while the filesystem reallocates the block(s).

Problem:

This expectation that dma can safely continue while the filesystem
changes the block map is broken by dax. With dax the target dma page
*is* the filesystem block. The model of leaving the page pinned for dma,
but truncating the file block out of the file, means that the filesytem
is free to reallocate a block under active dma to another file and now
the expected data-incoherency situation has turned into active
data-corruption.

Solution:

Defer all filesystem operations (fallocate(), truncate()) on a dax mode
file while any page/block in the file is under active dma. This solution
assumes that dma is transient. Cases where dma operations are known to
not be transient, like RDMA, have been explicitly disabled via
commits like 5f1d43de5416 "IB/core: disable memory registration of
filesystem-dax vmas".

The dax_layout_busy_page() routine is called by filesystems with a lock
held against mm faults (i_mmap_lock) to find pinned / busy dax pages.
The process of looking up a busy page invalidates all mappings
to trigger any subsequent get_user_pages() to block on i_mmap_lock.
The filesystem continues to call dax_layout_busy_page() until it finally
returns no more active pages. This approach assumes that the page
pinning is transient, if that assumption is violated the system would
have likely hung from the uncompleted I/O.


---

Dan Williams (11):
      dax: store pfns in the radix
      xfs, dax: introduce xfs_dax_aops
      ext4, dax: introduce ext4_dax_aops
      ext2, dax: introduce ext2_dax_aops
      fs, dax: use page->mapping to warn if truncate collides with a busy page
      mm, dax: enable filesystems to trigger dev_pagemap ->page_free callbacks
      mm, dev_pagemap: introduce CONFIG_DEV_PAGEMAP_OPS
      wait_bit: introduce {wait_on,wake_up}_atomic_one
      mm, fs, dax: handle layout changes to pinned dax mappings
      xfs: prepare xfs_break_layouts() for another layout type
      xfs, dax: introduce xfs_break_dax_layouts()


 drivers/dax/super.c      |   96 +++++++++++++++--
 drivers/nvdimm/pmem.c    |    3 -
 fs/Kconfig               |    1 
 fs/dax.c                 |  259 +++++++++++++++++++++++++++++++++++++---------
 fs/ext2/ext2.h           |    1 
 fs/ext2/inode.c          |   28 ++++-
 fs/ext2/namei.c          |   18 ---
 fs/ext2/super.c          |    6 +
 fs/ext4/inode.c          |   11 ++
 fs/ext4/super.c          |    6 +
 fs/xfs/xfs_aops.c        |    7 +
 fs/xfs/xfs_aops.h        |    1 
 fs/xfs/xfs_file.c        |   94 ++++++++++++++++-
 fs/xfs/xfs_inode.h       |    9 ++
 fs/xfs/xfs_ioctl.c       |    9 +-
 fs/xfs/xfs_iops.c        |   17 ++-
 fs/xfs/xfs_pnfs.c        |    8 +
 fs/xfs/xfs_pnfs.h        |    4 -
 fs/xfs/xfs_super.c       |   20 ++--
 include/linux/dax.h      |   45 +++++++-
 include/linux/memremap.h |   28 ++---
 include/linux/mm.h       |   61 ++++++++---
 include/linux/wait_bit.h |   13 ++
 kernel/memremap.c        |   30 +++++
 kernel/sched/wait_bit.c  |   59 +++++++++-
 mm/Kconfig               |    5 +
 mm/gup.c                 |    5 +
 mm/hmm.c                 |   13 --
 mm/swap.c                |    3 -
 29 files changed, 663 insertions(+), 197 deletions(-)
