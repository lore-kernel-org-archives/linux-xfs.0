Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 801DB7CB0
	for <xfs@oss.sgi.com>; Wed, 10 Feb 2016 14:49:17 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 7443D8F8033
	for <xfs@oss.sgi.com>; Wed, 10 Feb 2016 12:49:17 -0800 (PST)
Received: from mga11.intel.com ([192.55.52.93]) by cuda.sgi.com with ESMTP id
	TXPVbDPvxGEv49Wk for <xfs@oss.sgi.com>;
	Wed, 10 Feb 2016 12:49:16 -0800 (PST)
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [PATCH v2 0/2] DAX bdev fixes - move flushing calls to FS
Date: Wed, 10 Feb 2016 13:48:54 -0700
Message-Id: <1455137336-28720-1-git-send-email-ross.zwisler@linux.intel.com>
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
To: linux-kernel@vger.kernel.org
Cc: Theodore Ts'o <tytso@mit.edu>, Andrew Morton <akpm@linux-foundation.org>, linux-nvdimm@lists.01.org, xfs@oss.sgi.com, linux-mm@kvack.org, Andreas Dilger <adilger.kernel@dilger.ca>, Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.com>, linux-fsdevel@vger.kernel.org, Matthew Wilcox <willy@linux.intel.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, linux-ext4@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>

During testing of raw block devices + DAX I noticed that the struct
block_device that we were using for DAX operations was incorrect.  For the
fault handlers, etc. we can just get the correct bdev via get_block(),
which is passed in as a function pointer, but for the *sync code and for
sector zeroing we don't have access to get_block().  This is also an issue
for XFS real-time devices, whenever we get those working.

Patch one of this series fixes the DAX sector zeroing code by explicitly
passing in a valid struct block_device.

Patch two of this series fixes DAX *sync support by moving calls to
dax_writeback_mapping_range() out of filemap_write_and_wait_range() and
into the filesystem/block device ->writepages function so that it can
supply us with a valid block device. This also fixes DAX code to properly
flush caches in response to sync(2).

Thanks to Jan Kara for his initial draft of patch 2:
https://lkml.org/lkml/2016/2/9/485

Here are the changes that I've made to that patch:

1) For DAX mappings, only return after calling
dax_writeback_mapping_range() if we encountered an error.  In the non-error
case we still need to write back normal pages, else we lose metadata
updates. 

2) In dax_writeback_mapping_range(), move the new check for 
        if (!mapping->nrexceptional || wbc->sync_mode != WB_SYNC_ALL)
above the i_blkbits check.  In my testing I found cases where
dax_writeback_mapping_range() was called for inodes with i_blkbits !=
PAGE_SHIFT - I'm assuming these are internal metadata inodes?  They have no
exceptional DAX entries to flush, so we have no work to do, but if we
return error from the i_blkbits check we will fail the overall writeback
operation.  Please let me know if it seems wrong for us to be seeing inodes
set to use DAX but with i_blkbits != PAGE_SHIFT and I'll get more info.

3) In filemap_write_and_wait() and filemap_write_and_wait_range(), continue
the writeback in the case that DAX is enabled but we only have a nonzero
mapping->nrpages.  As with 1) and 2), I believe this is necessary to
properly writeback metadata changes.  If this sounds wrong, please let me
know and I'll get more info.

A working tree can be found here:
https://git.kernel.org/cgit/linux/kernel/git/zwisler/linux.git/log/?h=fsync_bdev_v2

Ross Zwisler (2):
  dax: supply DAX clearing code with correct bdev
  dax: move writeback calls into the filesystems

 fs/block_dev.c         | 16 +++++++++++++++-
 fs/dax.c               | 22 ++++++++++++----------
 fs/ext2/inode.c        | 17 +++++++++++++++--
 fs/ext4/inode.c        |  7 +++++++
 fs/xfs/xfs_aops.c      | 11 ++++++++++-
 fs/xfs/xfs_aops.h      |  1 +
 fs/xfs/xfs_bmap_util.c |  3 ++-
 include/linux/dax.h    |  8 +++++---
 mm/filemap.c           | 12 ++++--------
 9 files changed, 71 insertions(+), 26 deletions(-)

-- 
2.5.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
