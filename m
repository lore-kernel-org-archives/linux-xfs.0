Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:52222 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726246AbfBVSUQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 22 Feb 2019 13:20:16 -0500
Date: Fri, 22 Feb 2019 10:20:08 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [RFC PATCH] pmem: advertise page alignment for pmem devices
 supporting fsdax
Message-ID: <20190222182008.GT6503@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: dan.j.williams@intel.com
Cc: linux-nvdimm@lists.01.org, zwisler@kernel.org, vishal.l.verma@intel.com, xfs <linux-xfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>

Hi all!

Uh, we have an internal customer <cough> who's been trying out MAP_SYNC
on pmem, and they've observed that one has to do a fair amount of
legwork (in the form of mkfs.xfs parameters) to get the kernel to set up
2M PMD mappings.  They (of course) want to mmap hundreds of GB of pmem,
so the PMD mappings are much more efficient.

I started poking around w.r.t. what mkfs.xfs was doing and realized that
if the fsdax pmem device advertised iomin/ioopt of 2MB, then mkfs will
set up all the parameters automatically.  Below is my ham-handed attempt
to teach the kernel to do this.

Comments, flames, "WTF is this guy smoking?" are all welcome. :)

--D

---
Configure pmem devices to advertise the default page alignment when said
block device supports fsdax.  Certain filesystems use these iomin/ioopt
hints to try to create aligned file extents, which makes it much easier
for mmaps to take advantage of huge page table entries.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 drivers/nvdimm/pmem.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
index bc2f700feef8..3eeb9dd117d5 100644
--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -441,8 +441,11 @@ static int pmem_attach_disk(struct device *dev,
 	blk_queue_logical_block_size(q, pmem_sector_size(ndns));
 	blk_queue_max_hw_sectors(q, UINT_MAX);
 	blk_queue_flag_set(QUEUE_FLAG_NONROT, q);
-	if (pmem->pfn_flags & PFN_MAP)
+	if (pmem->pfn_flags & PFN_MAP) {
 		blk_queue_flag_set(QUEUE_FLAG_DAX, q);
+		blk_queue_io_min(q, PFN_DEFAULT_ALIGNMENT);
+		blk_queue_io_opt(q, PFN_DEFAULT_ALIGNMENT);
+	}
 	q->queuedata = pmem;
 
 	disk = alloc_disk_node(0, nid);
