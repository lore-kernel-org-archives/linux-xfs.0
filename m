Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id A19F37C8C
	for <xfs@oss.sgi.com>; Mon, 22 Feb 2016 12:59:47 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 697FB304098
	for <xfs@oss.sgi.com>; Mon, 22 Feb 2016 10:59:41 -0800 (PST)
Received: from mga11.intel.com ([192.55.52.93]) by cuda.sgi.com with ESMTP id
	Vo6pvDYbqY4icoW6 for <xfs@oss.sgi.com>;
	Mon, 22 Feb 2016 10:59:40 -0800 (PST)
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [PATCH v4 1/5] block: disable block device DAX by default
Date: Mon, 22 Feb 2016 11:59:18 -0700
Message-Id: <1456167562-28576-2-git-send-email-ross.zwisler@linux.intel.com>
In-Reply-To: <1456167562-28576-1-git-send-email-ross.zwisler@linux.intel.com>
References: <1456167562-28576-1-git-send-email-ross.zwisler@linux.intel.com>
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
Cc: Jens Axboe <axboe@kernel.dk>, Jens Axboe <axboe@fb.com>, Theodore Ts'o <tytso@mit.edu>, linux-nvdimm@lists.01.org, Jan Kara <jack@suse.cz>, Al Viro <viro@ftp.linux.org.uk>, xfs@oss.sgi.com, linux-block@vger.kernel.org, linux-mm@kvack.org, Andreas Dilger <adilger.kernel@dilger.ca>, Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.com>, linux-fsdevel@vger.kernel.org, Matthew Wilcox <willy@linux.intel.com>, Dan Williams <dan.j.williams@intel.com>, linux-ext4@vger.kernel.org, Ross Zwisler <ross.zwisler@linux.intel.com>, Andrew Morton <akpm@linux-foundation.org>, Matthew Wilcox <matthew.r.wilcox@intel.com>

From: Dan Williams <dan.j.williams@intel.com>

The recent *sync enabling discovered that we are inserting into the
block_device pagecache counter to the expectations of the dirty data
tracking for dax mappings.  This can lead to data corruption.

We want to support DAX for block devices eventually, but it requires
wider changes to properly manage the pagecache.

  [<ffffffff81576d93>] dump_stack+0x85/0xc2
  [<ffffffff812b9ee0>] dax_writeback_mapping_range+0x60/0xe0
  [<ffffffff812a1d4f>] blkdev_writepages+0x3f/0x50
  [<ffffffff811db011>] do_writepages+0x21/0x30
  [<ffffffff811cb6a6>] __filemap_fdatawrite_range+0xc6/0x100
  [<ffffffff811cb75a>] filemap_write_and_wait+0x4a/0xa0
  [<ffffffff812a15e0>] set_blocksize+0x70/0xd0
  [<ffffffff812a273d>] sb_set_blocksize+0x1d/0x50
  [<ffffffff8132ac9b>] ext4_fill_super+0x75b/0x3360
  [<ffffffff81583381>] ? vsnprintf+0x201/0x4c0
  [<ffffffff815836d9>] ? snprintf+0x49/0x60
  [<ffffffff81263010>] mount_bdev+0x180/0x1b0
  [<ffffffff8132a540>] ? ext4_calculate_overhead+0x370/0x370
  [<ffffffff8131ad95>] ext4_mount+0x15/0x20
  [<ffffffff81263908>] mount_fs+0x38/0x170

Mark the support broken so its disabled by default, but otherwise still
available for testing.

Cc: Jan Kara <jack@suse.cz>
Cc: Jens Axboe <axboe@fb.com>
Cc: Matthew Wilcox <matthew.r.wilcox@intel.com>
Cc: Al Viro <viro@ftp.linux.org.uk>
Reported-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Suggested-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Reviewed-by: Jan Kara <jack@suse.cz>
---
 block/Kconfig  | 13 +++++++++++++
 fs/block_dev.c |  6 +++++-
 2 files changed, 18 insertions(+), 1 deletion(-)

diff --git a/block/Kconfig b/block/Kconfig
index 161491d..0363cd7 100644
--- a/block/Kconfig
+++ b/block/Kconfig
@@ -88,6 +88,19 @@ config BLK_DEV_INTEGRITY
 	T10/SCSI Data Integrity Field or the T13/ATA External Path
 	Protection.  If in doubt, say N.
 
+config BLK_DEV_DAX
+	bool "Block device DAX support"
+	depends on FS_DAX
+	depends on BROKEN
+	help
+	  When DAX support is available (CONFIG_FS_DAX) raw block
+	  devices can also support direct userspace access to the
+	  storage capacity via MMAP(2) similar to a file on a
+	  DAX-enabled filesystem.  However, the DAX I/O-path disables
+	  some standard I/O-statistics, and the MMAP(2) path has some
+	  operational differences due to bypassing the page
+	  cache.  If in doubt, say N.
+
 config BLK_DEV_THROTTLING
 	bool "Block layer bio throttling support"
 	depends on BLK_CGROUP=y
diff --git a/fs/block_dev.c b/fs/block_dev.c
index 39b3a17..31c6d10 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -1201,7 +1201,11 @@ static int __blkdev_get(struct block_device *bdev, fmode_t mode, int for_part)
 		bdev->bd_disk = disk;
 		bdev->bd_queue = disk->queue;
 		bdev->bd_contains = bdev;
-		bdev->bd_inode->i_flags = disk->fops->direct_access ? S_DAX : 0;
+		if (IS_ENABLED(CONFIG_BLK_DEV_DAX) && disk->fops->direct_access)
+			bdev->bd_inode->i_flags = S_DAX;
+		else
+			bdev->bd_inode->i_flags = 0;
+
 		if (!partno) {
 			ret = -ENXIO;
 			bdev->bd_part = disk_get_part(disk, partno);
-- 
2.5.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
