Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id B058A7CE7
	for <xfs@oss.sgi.com>; Thu, 28 Apr 2016 16:17:24 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 31C05AC002
	for <xfs@oss.sgi.com>; Thu, 28 Apr 2016 14:17:24 -0700 (PDT)
Received: from mga14.intel.com ([192.55.52.115]) by cuda.sgi.com with ESMTP id
	iqqwqQmV9y8tPb8E for <xfs@oss.sgi.com>;
	Thu, 28 Apr 2016 14:17:23 -0700 (PDT)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [PATCH v4 3/7] dax: enable dax in the presence of known media errors
	(badblocks)
Date: Thu, 28 Apr 2016 15:16:54 -0600
Message-Id: <1461878218-3844-4-git-send-email-vishal.l.verma@intel.com>
In-Reply-To: <1461878218-3844-1-git-send-email-vishal.l.verma@intel.com>
References: <1461878218-3844-1-git-send-email-vishal.l.verma@intel.com>
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
Cc: Jens Axboe <axboe@fb.com>, Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, Matthew Wilcox <matthew@wil.cx>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, linux-block@vger.kernel.org, linux-mm@kvack.org, Jeff Moyer <jmoyer@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>, linux-ext4@vger.kernel.org, Ross Zwisler <ross.zwisler@linux.intel.com>

From: Dan Williams <dan.j.williams@intel.com>

1/ If a mapping overlaps a bad sector fail the request.

2/ Do not opportunistically report more dax-capable capacity than is
   requested when errors present.

[vishal: fix a conflict with system RAM collision patches]
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 block/ioctl.c         | 9 ---------
 drivers/nvdimm/pmem.c | 8 ++++++++
 2 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/block/ioctl.c b/block/ioctl.c
index 4ff1f92..bf80bfd 100644
--- a/block/ioctl.c
+++ b/block/ioctl.c
@@ -423,15 +423,6 @@ bool blkdev_dax_capable(struct block_device *bdev)
 			|| (bdev->bd_part->nr_sects % (PAGE_SIZE / 512)))
 		return false;
 
-	/*
-	 * If the device has known bad blocks, force all I/O through the
-	 * driver / page cache.
-	 *
-	 * TODO: support finer grained dax error handling
-	 */
-	if (disk->bb && disk->bb->count)
-		return false;
-
 	return true;
 }
 #endif
diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
index f72733c..4567d9a 100644
--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -188,9 +188,17 @@ static long pmem_direct_access(struct block_device *bdev,
 	struct pmem_device *pmem = bdev->bd_disk->private_data;
 	resource_size_t offset = sector * 512 + pmem->data_offset;
 
+	if (unlikely(is_bad_pmem(&pmem->bb, sector, dax->size)))
+		return -EIO;
 	dax->addr = pmem->virt_addr + offset;
 	dax->pfn = phys_to_pfn_t(pmem->phys_addr + offset, pmem->pfn_flags);
 
+	/*
+	 * If badblocks are present, limit known good range to the
+	 * requested range.
+	 */
+	if (unlikely(pmem->bb.count))
+		return dax->size;
 	return pmem->size - pmem->pfn_pad - offset;
 }
 
-- 
2.5.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
