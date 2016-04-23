Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 55F487CC9
	for <xfs@oss.sgi.com>; Sat, 23 Apr 2016 14:14:08 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 29572304032
	for <xfs@oss.sgi.com>; Sat, 23 Apr 2016 12:14:08 -0700 (PDT)
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65]) by
	cuda.sgi.com with ESMTP id tTQrm353x1RFdQbX for
	<xfs@oss.sgi.com>; Sat, 23 Apr 2016 12:14:07 -0700 (PDT)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [PATCH v3 6/7] dax: for truncate/hole-punch,
	do zeroing through the driver if possible
Date: Sat, 23 Apr 2016 13:13:41 -0600
Message-Id: <1461438822-3592-7-git-send-email-vishal.l.verma@intel.com>
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
Cc: Jens Axboe <axboe@fb.com>, Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, Christoph Hellwig <hch@infradead.org>, Vishal Verma <vishal.l.verma@intel.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, linux-block@vger.kernel.org, linux-mm@kvack.org, Jeff Moyer <jmoyer@redhat.com>, Matthew Wilcox <matthew.r.wilcox@intel.com>, linux-fsdevel@vger.kernel.org, Ross Zwisler <ross.zwisler@linux.intel.com>, linux-ext4@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Al Viro <viro@zeniv.linux.org.uk>

In the truncate or hole-punch path in dax, we clear out sub-page ranges.
If these sub-page ranges are sector aligned and sized, we can do the
zeroing through the driver instead so that error-clearing is handled
automatically.

For sub-sector ranges, we still have to rely on clear_pmem and have the
possibility of tripping over errors.

Cc: Matthew Wilcox <matthew.r.wilcox@intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Jeff Moyer <jmoyer@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Jan Kara <jack@suse.cz>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 fs/dax.c | 30 +++++++++++++++++++++++++-----
 1 file changed, 25 insertions(+), 5 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index 5948d9b..d8c974e 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -1196,6 +1196,20 @@ out:
 }
 EXPORT_SYMBOL_GPL(dax_pfn_mkwrite);
 
+static bool dax_range_is_aligned(struct block_device *bdev,
+				 struct blk_dax_ctl *dax, unsigned int offset,
+				 unsigned int length)
+{
+	unsigned short sector_size = bdev_logical_block_size(bdev);
+
+	if (((u64)dax->addr + offset) % sector_size)
+		return false;
+	if (length % sector_size)
+		return false;
+
+	return true;
+}
+
 /**
  * dax_zero_page_range - zero a range within a page of a DAX file
  * @inode: The file being truncated
@@ -1240,11 +1254,17 @@ int dax_zero_page_range(struct inode *inode, loff_t from, unsigned length,
 			.size = PAGE_SIZE,
 		};
 
-		if (dax_map_atomic(bdev, &dax) < 0)
-			return PTR_ERR(dax.addr);
-		clear_pmem(dax.addr + offset, length);
-		wmb_pmem();
-		dax_unmap_atomic(bdev, &dax);
+		if (dax_range_is_aligned(bdev, &dax, offset, length))
+			return blkdev_issue_zeroout(bdev, dax.sector,
+					length / bdev_logical_block_size(bdev),
+					GFP_NOFS, true);
+		else {
+			if (dax_map_atomic(bdev, &dax) < 0)
+				return PTR_ERR(dax.addr);
+			clear_pmem(dax.addr + offset, length);
+			wmb_pmem();
+			dax_unmap_atomic(bdev, &dax);
+		}
 	}
 
 	return 0;
-- 
2.5.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
