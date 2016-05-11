Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 0206F7CA1
	for <xfs@oss.sgi.com>; Wed, 11 May 2016 16:09:21 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id C5F7B304032
	for <xfs@oss.sgi.com>; Wed, 11 May 2016 14:09:20 -0700 (PDT)
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20]) by
	cuda.sgi.com with ESMTP id zkBT4n9dbo6A0EYF for
	<xfs@oss.sgi.com>; Wed, 11 May 2016 14:09:16 -0700 (PDT)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [PATCH v7 0/6] dax: handling media errors (clear-on-zero only)
Date: Wed, 11 May 2016 15:08:46 -0600
Message-Id: <1463000932-31680-1-git-send-email-vishal.l.verma@intel.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: linux-nvdimm@lists.01.org
Cc: Jens Axboe <axboe@fb.com>, Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, Christoph Hellwig <hch@infradead.org>, Vishal Verma <vishal.l.verma@intel.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, linux-block@vger.kernel.org, linux-mm@kvack.org, Jeff Moyer <jmoyer@redhat.com>, Boaz Harrosh <boaz@plexistor.com>, linux-fsdevel@vger.kernel.org, Ross Zwisler <ross.zwisler@linux.intel.com>, linux-ext4@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>

Until now, dax has been disabled if media errors were found on
any device. This series attempts to address that.

The first two patches from Dan re-enable dax even when media
errors are present.

The third patch from Matthew removes the zeroout path from dax
entirely, making zeroout operations always go through the driver
(The motivation is that if a backing device has media errors,
and we create a sparse file on it, we don't want the initial
zeroing to happen via dax, we want to give the block driver a
chance to clear the errors).

Patch 4 from Christoph exports a low level dax helper for zeroing

Patch 5 reduces our calls to clear_pmem from dax in the
truncate/hole-punch cases. We check if the range being truncated
is sector aligned/sized, and if so, send blkdev_issue_zeroout
instead of clear_pmem so that errors can be handled better by
the driver.

Patch 6 fixes a redundant comment in DAX and is mostly unrelated
to the rest of this series.

This series also depends on/is based on Jan Kara's Ext4 and DAX
fixups series:
http://marc.info/?l=linux-ext4&m=146295959100848&w=2
http://marc.info/?l=linux-ext4&m=146296078001307&w=2

v7:
 - Fix the dax alignment check to only check 'offset' and 'length'
   for alignment as that's all that is needed. (Jan)
 - Fix the blockdev_issue_zeroout call to zero the correct sector
 - Rebase to v4.6-rc7 + the two patch-series from Jan linked above
 - Add a patch from Christoph's iomap series:
   http://www.spinics.net/lists/xfs/msg39656.html

v6:
 - Use IS_ALIGNED in dax_range_is_aligned instead of open coding
   an alignment check (Jan)
 - Collect all Reveiwed-by tags so far.

v5:
 - Drop the patch that attempts to clear-errors-on-write till we
   reach consensus on how to handle that.
 - Don't pass blk_dax_ctl to direct_access, instead pass in all the
   required arguments individually (Christoph, Dan)

v4:
 - Remove the dax->direct_IO fallbacks entirely. Instead, go through
   the usual direct_IO path when we're in O_DIRECT, and use dax_IO
   for other, non O_DIRECT IO. (Dan, Christoph)

v3:
 - Wrapper-ize the direct_IO fallback again and make an exception
   for -EIOCBQUEUED (Jeff, Dan)
 - Reduce clear_pmem usage in DAX to the minimum



Christoph Hellwig (1):
  dax: export a low-level __dax_zero_page_range helper

Dan Williams (2):
  dax: fallback from pmd to pte on error
  dax: enable dax in the presence of known media errors (badblocks)

Matthew Wilcox (1):
  dax: use sb_issue_zerout instead of calling dax_clear_sectors

Vishal Verma (2):
  dax: for truncate/hole-punch, do zeroing through the driver if
    possible
  dax: fix a comment in dax_zero_page_range and dax_truncate_page

 Documentation/filesystems/dax.txt |  32 ++++++++++++
 arch/powerpc/sysdev/axonram.c     |   2 +-
 block/ioctl.c                     |   9 ----
 drivers/block/brd.c               |   2 +-
 drivers/nvdimm/pmem.c             |  10 +++-
 drivers/s390/block/dcssblk.c      |   2 +-
 fs/block_dev.c                    |   2 +-
 fs/dax.c                          | 104 ++++++++++++++++----------------------
 fs/ext2/inode.c                   |   7 ++-
 fs/xfs/xfs_bmap_util.c            |  15 ++----
 include/linux/blkdev.h            |   2 +-
 include/linux/dax.h               |   8 ++-
 12 files changed, 103 insertions(+), 92 deletions(-)

-- 
2.5.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
