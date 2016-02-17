Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 0CEE27CA2
	for <xfs@oss.sgi.com>; Tue, 16 Feb 2016 21:34:37 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 6E27DAC006
	for <xfs@oss.sgi.com>; Tue, 16 Feb 2016 19:34:36 -0800 (PST)
Received: from mga04.intel.com ([192.55.52.120]) by cuda.sgi.com with ESMTP id
	yT51USGpM34UioaV for <xfs@oss.sgi.com>;
	Tue, 16 Feb 2016 19:34:35 -0800 (PST)
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [PATCH v3 0/6] DAX fixes, move flushing calls to FS
Date: Tue, 16 Feb 2016 20:34:13 -0700
Message-Id: <1455680059-20126-1-git-send-email-ross.zwisler@linux.intel.com>
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
Cc: Jens Axboe <axboe@kernel.dk>, Jeff Layton <jlayton@poochiereds.net>, Theodore Ts'o <tytso@mit.edu>, linux-nvdimm@lists.01.org, linux-block@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>, xfs@oss.sgi.com, "J. Bruce Fields" <bfields@fieldses.org>, linux-mm@kvack.org, Andreas Dilger <adilger.kernel@dilger.ca>, Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.com>, linux-fsdevel@vger.kernel.org, Matthew Wilcox <willy@linux.intel.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, linux-ext4@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>

This patch series fixes several issues with the current DAX code:

1) DAX is used by default on raw block devices that are capable of
supporting it.  This creates an issue because there are still uses of the
block device that use the page cache, and having one block device user
doing DAX I/O and another doing page cache I/O can lead to data corruption.

2) When S_DAX is set on an inode we assume that if there are pages attached
to the mapping (mapping->nrpages != 0), those pages are clean zero pages
that were used to service reads from holes.  This wasn't true in all cases.

3) ext4 online defrag combined with DAX I/O could lead to data corruption.

4) The DAX block/sector zeroing code needs a valid struct block_device,
which it wasn't always getting.

5) The DAX writeback code needs a valid struct block_device, which it
wasn't always getting.

6) The DAX writeback code needs to be called for sync(2) and syncfs(2).

The last patch in this series reenables the DAX I/O path for raw block
devices when they would otherwise be doing direct I/O.  It can be dropped
if it is too controversial.

Thank you to Dan Williams and Jan Kara for their code contributions to this
set.

A working tree can be found here:
https://git.kernel.org/cgit/linux/kernel/git/zwisler/linux.git/log/?h=fsync_bdev_v3

Dan Williams (2):
  block: disable block device DAX by default
  block: use dax_do_io() if blkdev_dax_capable()

Ross Zwisler (4):
  ext2, ext4: only set S_DAX for regular inodes
  ext4: Online defrag not supported with DAX
  dax: give DAX clearing code correct bdev
  dax: move writeback calls into the filesystems

 block/Kconfig          | 13 +++++++++++++
 block/ioctl.c          |  1 +
 fs/block_dev.c         | 22 +++++++++++++++++++---
 fs/dax.c               | 21 +++++++++++----------
 fs/ext2/inode.c        | 16 +++++++++++++---
 fs/ext4/inode.c        |  6 +++++-
 fs/ext4/ioctl.c        |  5 +++++
 fs/xfs/xfs_aops.c      |  6 +++++-
 fs/xfs/xfs_aops.h      |  1 +
 fs/xfs/xfs_bmap_util.c |  3 ++-
 include/linux/dax.h    |  8 +++++---
 include/linux/fs.h     | 31 +++++++++++++++++++++----------
 mm/filemap.c           | 12 ++++--------
 13 files changed, 105 insertions(+), 40 deletions(-)

-- 
2.5.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
