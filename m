Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 0E1B57CB1
	for <xfs@oss.sgi.com>; Tue, 29 Mar 2016 21:00:28 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id C40C4304032
	for <xfs@oss.sgi.com>; Tue, 29 Mar 2016 19:00:24 -0700 (PDT)
Received: from mga14.intel.com ([192.55.52.115]) by cuda.sgi.com with ESMTP id
	QIlyBOfUm7osiFiT for <xfs@oss.sgi.com>;
	Tue, 29 Mar 2016 19:00:23 -0700 (PDT)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [PATCH v2 3/5] dax: enable dax in the presence of known media errors
	(badblocks)
Date: Tue, 29 Mar 2016 19:59:48 -0600
Message-Id: <1459303190-20072-4-git-send-email-vishal.l.verma@intel.com>
In-Reply-To: <1459303190-20072-1-git-send-email-vishal.l.verma@intel.com>
References: <1459303190-20072-1-git-send-email-vishal.l.verma@intel.com>
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
Cc: Jens Axboe <axboe@fb.com>, Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, linux-block@vger.kernel.org, linux-mm@kvack.org, Matthew Wilcox <matthew.r.wilcox@intel.com>, linux-fsdevel@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>, linux-ext4@vger.kernel.org, Ross Zwisler <ross.zwisler@linux.intel.com>, Al Viro <viro@zeniv.linux.org.uk>

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
index d8996bb..cd7f392 100644
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
index da10554..eac5f93 100644
--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -174,9 +174,17 @@ static long pmem_direct_access(struct block_device *bdev,
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
