Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 000C97CB4
	for <xfs@oss.sgi.com>; Wed, 11 May 2016 16:09:24 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 833BD304043
	for <xfs@oss.sgi.com>; Wed, 11 May 2016 14:09:24 -0700 (PDT)
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20]) by
	cuda.sgi.com with ESMTP id 6L4N7aWE96D5QTlc for
	<xfs@oss.sgi.com>; Wed, 11 May 2016 14:09:22 -0700 (PDT)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [PATCH v7 5/6] dax: for truncate/hole-punch,
	do zeroing through the driver if possible
Date: Wed, 11 May 2016 15:08:51 -0600
Message-Id: <1463000932-31680-6-git-send-email-vishal.l.verma@intel.com>
In-Reply-To: <1463000932-31680-1-git-send-email-vishal.l.verma@intel.com>
References: <1463000932-31680-1-git-send-email-vishal.l.verma@intel.com>
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

In the truncate or hole-punch path in dax, we clear out sub-page ranges.
If these sub-page ranges are sector aligned and sized, we can do the
zeroing through the driver instead so that error-clearing is handled
automatically.

For sub-sector ranges, we still have to rely on clear_pmem and have the
possibility of tripping over errors.

Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Jeff Moyer <jmoyer@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Jan Kara <jack@suse.cz>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 Documentation/filesystems/dax.txt | 32 ++++++++++++++++++++++++++++++++
 fs/dax.c                          | 30 +++++++++++++++++++++++++-----
 2 files changed, 57 insertions(+), 5 deletions(-)

diff --git a/Documentation/filesystems/dax.txt b/Documentation/filesystems/dax.txt
index 7bde640..ce4587d 100644
--- a/Documentation/filesystems/dax.txt
+++ b/Documentation/filesystems/dax.txt
@@ -79,6 +79,38 @@ These filesystems may be used for inspiration:
 - ext4: the fourth extended filesystem, see Documentation/filesystems/ext4.txt
 
 
+Handling Media Errors
+---------------------
+
+The libnvdimm subsystem stores a record of known media error locations for
+each pmem block device (in gendisk->badblocks). If we fault at such location,
+or one with a latent error not yet discovered, the application can expect
+to receive a SIGBUS. Libnvdimm also allows clearing of these errors by simply
+writing the affected sectors (through the pmem driver, and if the underlying
+NVDIMM supports the clear_poison DSM defined by ACPI).
+
+Since DAX IO normally doesn't go through the driver/bio path, applications or
+sysadmins have an option to restore the lost data from a prior backup/inbuilt
+redundancy in the following ways:
+
+1. Delete the affected file, and restore from a backup (sysadmin route):
+   This will free the file system blocks that were being used by the file,
+   and the next time they're allocated, they will be zeroed first, which
+   happens through the driver, and will clear bad sectors.
+
+2. Truncate or hole-punch the part of the file that has a bad-block (at least
+   an entire aligned sector has to be hole-punched, but not necessarily an
+   entire filesystem block).
+
+These are the two basic paths that allow DAX filesystems to continue operating
+in the presence of media errors. More robust error recovery mechanisms can be
+built on top of this in the future, for example, involving redundancy/mirroring
+provided at the block layer through DM, or additionally, at the filesystem
+level. These would have to rely on the above two tenets, that error clearing
+can happen either by sending an IO through the driver, or zeroing (also through
+the driver).
+
+
 Shortcomings
 ------------
 
diff --git a/fs/dax.c b/fs/dax.c
index 651d4b1..0b9a169 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -947,6 +947,19 @@ int dax_pfn_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
 }
 EXPORT_SYMBOL_GPL(dax_pfn_mkwrite);
 
+static bool dax_range_is_aligned(struct block_device *bdev,
+				 unsigned int offset, unsigned int length)
+{
+	unsigned short sector_size = bdev_logical_block_size(bdev);
+
+	if (!IS_ALIGNED(offset, sector_size))
+		return false;
+	if (!IS_ALIGNED(length, sector_size))
+		return false;
+
+	return true;
+}
+
 int __dax_zero_page_range(struct block_device *bdev, sector_t sector,
 		unsigned int offset, unsigned int length)
 {
@@ -955,11 +968,18 @@ int __dax_zero_page_range(struct block_device *bdev, sector_t sector,
 		.size		= PAGE_SIZE,
 	};
 
-	if (dax_map_atomic(bdev, &dax) < 0)
-		return PTR_ERR(dax.addr);
-	clear_pmem(dax.addr + offset, length);
-	wmb_pmem();
-	dax_unmap_atomic(bdev, &dax);
+	if (dax_range_is_aligned(bdev, offset, length)) {
+		sector_t start_sector = dax.sector + (offset >> 9);
+
+		return blkdev_issue_zeroout(bdev, start_sector,
+				length >> 9, GFP_NOFS, true);
+	} else {
+		if (dax_map_atomic(bdev, &dax) < 0)
+			return PTR_ERR(dax.addr);
+		clear_pmem(dax.addr + offset, length);
+		wmb_pmem();
+		dax_unmap_atomic(bdev, &dax);
+	}
 	return 0;
 }
 EXPORT_SYMBOL_GPL(__dax_zero_page_range);
-- 
2.5.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
