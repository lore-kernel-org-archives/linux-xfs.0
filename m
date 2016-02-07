Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 752457CA3
	for <xfs@oss.sgi.com>; Sun,  7 Feb 2016 01:19:36 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 6739F8F8039
	for <xfs@oss.sgi.com>; Sat,  6 Feb 2016 23:19:33 -0800 (PST)
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65]) by
	cuda.sgi.com with ESMTP id 9s400sPCSjgcOWvg for
	<xfs@oss.sgi.com>; Sat, 06 Feb 2016 23:19:31 -0800 (PST)
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [PATCH 0/2] DAX bdev fixes - move flushing calls to FS
Date: Sun,  7 Feb 2016 00:19:11 -0700
Message-Id: <1454829553-29499-1-git-send-email-ross.zwisler@linux.intel.com>
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

The first patch in the series just adds a bdev argument to
dax_clear_blocks(), and should be relatively straightforward.

The second patch is slightly more controversial.  During testing of raw block
devices + DAX I noticed that the struct block_device that we were using for DAX
operations was incorrect.  For the fault handlers, etc. we can just get the
correct bdev via get_block(), which is passed in as a function pointer, but for
the flushing code we don't have access to get_block().  This is also an issue
for XFS real-time devices, whenever we get those working.

In short, somehow we need to get dax_writeback_mapping_range() a valid bdev.
Right now it is called via filemap_write_and_wait_range(), which can't provide
either the bdev nor a get_block() function pointer.  So, our options seem to
be:

  a) Move the calls to dax_writeback_mapping_range() into the filesystems.
  This is implemented by patch 2 in this series.

  b) Keep the calls to dax_writeback_mapping_range() in the mm code, and
  provide a generic way to ask a filesystem for an inode's bdev.  I did a
  version of this using a superblock operation here:

  https://lkml.org/lkml/2016/2/2/941

It has been noted that we may need to expand the coverage of our DAX
flushing code to include support for the sync() and syncfs() userspace
calls.  This is still under discussion, but if we do end up needing to add
support for sync(), I don't think that it is v4.5 material for the reasons
stated here:

https://lkml.org/lkml/2016/2/4/962

I think that for v4.5 we either need patch 2 of this series, or the
get_bdev() patch listed in for solution b) above.

Ross Zwisler (2):
  dax: pass bdev argument to dax_clear_blocks()
  dax: move writeback calls into the filesystems

 fs/block_dev.c         |  7 +++++++
 fs/dax.c               |  9 ++++-----
 fs/ext2/file.c         | 10 ++++++++++
 fs/ext2/inode.c        |  5 +++--
 fs/ext4/fsync.c        | 10 +++++++++-
 fs/xfs/xfs_aops.c      |  2 +-
 fs/xfs/xfs_aops.h      |  1 +
 fs/xfs/xfs_bmap_util.c |  4 +++-
 fs/xfs/xfs_file.c      | 12 ++++++++++--
 include/linux/dax.h    |  7 ++++---
 mm/filemap.c           |  6 ------
 11 files changed, 52 insertions(+), 21 deletions(-)

-- 
2.5.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
