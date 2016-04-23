Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id ACD247CA7
	for <xfs@oss.sgi.com>; Sat, 23 Apr 2016 14:14:00 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 80A518F8033
	for <xfs@oss.sgi.com>; Sat, 23 Apr 2016 12:14:00 -0700 (PDT)
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65]) by
	cuda.sgi.com with ESMTP id T5KoyQKbKln9USgH for
	<xfs@oss.sgi.com>; Sat, 23 Apr 2016 12:13:59 -0700 (PDT)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [PATCH v3 1/7] block, dax: pass blk_dax_ctl through to drivers
Date: Sat, 23 Apr 2016 13:13:36 -0600
Message-Id: <1461438822-3592-2-git-send-email-vishal.l.verma@intel.com>
In-Reply-To: <1461438822-3592-1-git-send-email-vishal.l.verma@intel.com>
References: <1461438822-3592-1-git-send-email-vishal.l.verma@intel.com>
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
Cc: Jens Axboe <axboe@fb.com>, Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, linux-block@vger.kernel.org, linux-mm@kvack.org, Jeff Moyer <jmoyer@redhat.com>, Matthew Wilcox <matthew.r.wilcox@intel.com>, linux-fsdevel@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>, linux-ext4@vger.kernel.org, Ross Zwisler <ross.zwisler@linux.intel.com>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Al Viro <viro@zeniv.linux.org.uk>

From: Dan Williams <dan.j.williams@intel.com>

This is in preparation for doing badblocks checking against the
requested sector range in the driver.  Currently we opportunistically
return as much data that can be "dax'd" starting at the given sector.
When errors are present we want to limit that range to the first
encountered error, or fail the dax request if the range encompasses an
error.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 arch/powerpc/sysdev/axonram.c | 10 +++++-----
 drivers/block/brd.c           |  9 +++++----
 drivers/nvdimm/pmem.c         |  9 +++++----
 drivers/s390/block/dcssblk.c  | 12 ++++++------
 fs/block_dev.c                |  2 +-
 include/linux/blkdev.h        |  3 +--
 6 files changed, 23 insertions(+), 22 deletions(-)

diff --git a/arch/powerpc/sysdev/axonram.c b/arch/powerpc/sysdev/axonram.c
index 0d112b9..d85673f 100644
--- a/arch/powerpc/sysdev/axonram.c
+++ b/arch/powerpc/sysdev/axonram.c
@@ -139,17 +139,17 @@ axon_ram_make_request(struct request_queue *queue, struct bio *bio)
 
 /**
  * axon_ram_direct_access - direct_access() method for block device
- * @device, @sector, @data: see block_device_operations method
+ * @dax: see block_device_operations method
  */
 static long
-axon_ram_direct_access(struct block_device *device, sector_t sector,
-		       void __pmem **kaddr, pfn_t *pfn)
+axon_ram_direct_access(struct block_device *device, struct blk_dax_ctl *dax)
 {
+	sector_t sector = get_start_sect(device) + dax->sector;
 	struct axon_ram_bank *bank = device->bd_disk->private_data;
 	loff_t offset = (loff_t)sector << AXON_RAM_SECTOR_SHIFT;
 
-	*kaddr = (void __pmem __force *) bank->io_addr + offset;
-	*pfn = phys_to_pfn_t(bank->ph_addr + offset, PFN_DEV);
+	dax->addr = (void __pmem __force *) bank->io_addr + offset;
+	dax->pfn = phys_to_pfn_t(bank->ph_addr + offset, PFN_DEV);
 	return bank->size - offset;
 }
 
diff --git a/drivers/block/brd.c b/drivers/block/brd.c
index 51a071e..71521c1 100644
--- a/drivers/block/brd.c
+++ b/drivers/block/brd.c
@@ -380,9 +380,10 @@ static int brd_rw_page(struct block_device *bdev, sector_t sector,
 }
 
 #ifdef CONFIG_BLK_DEV_RAM_DAX
-static long brd_direct_access(struct block_device *bdev, sector_t sector,
-			void __pmem **kaddr, pfn_t *pfn)
+static long brd_direct_access(struct block_device *bdev,
+		struct blk_dax_ctl *dax)
 {
+	sector_t sector = get_start_sect(bdev) + dax->sector;
 	struct brd_device *brd = bdev->bd_disk->private_data;
 	struct page *page;
 
@@ -391,8 +392,8 @@ static long brd_direct_access(struct block_device *bdev, sector_t sector,
 	page = brd_insert_page(brd, sector);
 	if (!page)
 		return -ENOSPC;
-	*kaddr = (void __pmem *)page_address(page);
-	*pfn = page_to_pfn_t(page);
+	dax->addr = (void __pmem *)page_address(page);
+	dax->pfn = page_to_pfn_t(page);
 
 	return PAGE_SIZE;
 }
diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
index f798899..f72733c 100644
--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -181,14 +181,15 @@ static int pmem_rw_page(struct block_device *bdev, sector_t sector,
 	return rc;
 }
 
-static long pmem_direct_access(struct block_device *bdev, sector_t sector,
-		      void __pmem **kaddr, pfn_t *pfn)
+static long pmem_direct_access(struct block_device *bdev,
+		struct blk_dax_ctl *dax)
 {
+	sector_t sector = get_start_sect(bdev) + dax->sector;
 	struct pmem_device *pmem = bdev->bd_disk->private_data;
 	resource_size_t offset = sector * 512 + pmem->data_offset;
 
-	*kaddr = pmem->virt_addr + offset;
-	*pfn = phys_to_pfn_t(pmem->phys_addr + offset, pmem->pfn_flags);
+	dax->addr = pmem->virt_addr + offset;
+	dax->pfn = phys_to_pfn_t(pmem->phys_addr + offset, pmem->pfn_flags);
 
 	return pmem->size - pmem->pfn_pad - offset;
 }
diff --git a/drivers/s390/block/dcssblk.c b/drivers/s390/block/dcssblk.c
index b839086..613f587 100644
--- a/drivers/s390/block/dcssblk.c
+++ b/drivers/s390/block/dcssblk.c
@@ -30,8 +30,8 @@ static int dcssblk_open(struct block_device *bdev, fmode_t mode);
 static void dcssblk_release(struct gendisk *disk, fmode_t mode);
 static blk_qc_t dcssblk_make_request(struct request_queue *q,
 						struct bio *bio);
-static long dcssblk_direct_access(struct block_device *bdev, sector_t secnum,
-			 void __pmem **kaddr, pfn_t *pfn);
+static long dcssblk_direct_access(struct block_device *bdev,
+		struct blk_dax_ctl *dax)
 
 static char dcssblk_segments[DCSSBLK_PARM_LEN] = "\0";
 
@@ -883,9 +883,9 @@ fail:
 }
 
 static long
-dcssblk_direct_access (struct block_device *bdev, sector_t secnum,
-			void __pmem **kaddr, pfn_t *pfn)
+dcssblk_direct_access(struct block_device *bdev, struct blk_dax_ctl *dax)
 {
+	sector_t secnum = get_start_sect(bdev) + dax->sector;
 	struct dcssblk_dev_info *dev_info;
 	unsigned long offset, dev_sz;
 
@@ -894,8 +894,8 @@ dcssblk_direct_access (struct block_device *bdev, sector_t secnum,
 		return -ENODEV;
 	dev_sz = dev_info->end - dev_info->start;
 	offset = secnum * 512;
-	*kaddr = (void __pmem *) (dev_info->start + offset);
-	*pfn = __pfn_to_pfn_t(PFN_DOWN(dev_info->start + offset), PFN_DEV);
+	dax->addr = (void __pmem *) (dev_info->start + offset);
+	dax->pfn = __pfn_to_pfn_t(PFN_DOWN(dev_info->start + offset), PFN_DEV);
 
 	return dev_sz - offset;
 }
diff --git a/fs/block_dev.c b/fs/block_dev.c
index b25bb23..79defba 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -488,7 +488,7 @@ long bdev_direct_access(struct block_device *bdev, struct blk_dax_ctl *dax)
 	sector += get_start_sect(bdev);
 	if (sector % (PAGE_SIZE / 512))
 		return -EINVAL;
-	avail = ops->direct_access(bdev, sector, &dax->addr, &dax->pfn);
+	avail = ops->direct_access(bdev, dax);
 	if (!avail)
 		return -ERANGE;
 	if (avail > 0 && avail & ~PAGE_MASK)
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 669e419..9d8c6d5 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1656,8 +1656,7 @@ struct block_device_operations {
 	int (*rw_page)(struct block_device *, sector_t, struct page *, int rw);
 	int (*ioctl) (struct block_device *, fmode_t, unsigned, unsigned long);
 	int (*compat_ioctl) (struct block_device *, fmode_t, unsigned, unsigned long);
-	long (*direct_access)(struct block_device *, sector_t, void __pmem **,
-			pfn_t *);
+	long (*direct_access)(struct block_device *, struct blk_dax_ctl *dax);
 	unsigned int (*check_events) (struct gendisk *disk,
 				      unsigned int clearing);
 	/* ->media_changed() is DEPRECATED, use ->check_events() instead */
-- 
2.5.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
