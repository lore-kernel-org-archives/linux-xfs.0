Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 4C8557F67
	for <xfs@oss.sgi.com>; Thu,  7 Jan 2016 18:44:06 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 39483304067
	for <xfs@oss.sgi.com>; Thu,  7 Jan 2016 16:44:06 -0800 (PST)
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24]) by
	cuda.sgi.com with ESMTP id LjG0Vdlf7FxxCWsw for
	<xfs@oss.sgi.com>; Thu, 07 Jan 2016 16:43:56 -0800 (PST)
Subject: [PATCH v3 1/5] block: prepare for del_gendisk_queue()
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 07 Jan 2016 16:43:00 -0800
Message-ID: <20160108004259.36061.83529.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <20160108004254.36061.32864.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <20160108004254.36061.32864.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org

Refactor del_gendisk() into del_gendisk_start() and del_gendisk_end().
These are common helpers that will be shared bewtween del_gendisk() and
the to-be-introduced del_gendisk_queue().

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 block/genhd.c |   41 +++++++++++++++++++++++++++--------------
 1 file changed, 27 insertions(+), 14 deletions(-)

diff --git a/block/genhd.c b/block/genhd.c
index e5cafa51567c..b1d1df42ba13 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -634,24 +634,14 @@ void add_disk(struct gendisk *disk)
 }
 EXPORT_SYMBOL(add_disk);
 
-void del_gendisk(struct gendisk *disk)
+static void del_gendisk_start(struct gendisk *disk)
 {
-	struct disk_part_iter piter;
-	struct hd_struct *part;
-
 	blk_integrity_del(disk);
 	disk_del_events(disk);
+}
 
-	/* invalidate stuff */
-	disk_part_iter_init(&piter, disk,
-			     DISK_PITER_INCL_EMPTY | DISK_PITER_REVERSE);
-	while ((part = disk_part_iter_next(&piter))) {
-		invalidate_partition(disk, part->partno);
-		delete_partition(disk, part->partno);
-	}
-	disk_part_iter_exit(&piter);
-
-	invalidate_partition(disk, 0);
+static void del_gendisk_end(struct gendisk *disk)
+{
 	set_capacity(disk, 0);
 	disk->flags &= ~GENHD_FL_UP;
 
@@ -670,6 +660,29 @@ void del_gendisk(struct gendisk *disk)
 	pm_runtime_set_memalloc_noio(disk_to_dev(disk), false);
 	device_del(disk_to_dev(disk));
 }
+
+#define for_each_part(part, piter) \
+	for (part = disk_part_iter_next(piter); part; \
+			part = disk_part_iter_next(piter))
+void del_gendisk(struct gendisk *disk)
+{
+	struct disk_part_iter piter;
+	struct hd_struct *part;
+
+	del_gendisk_start(disk);
+
+	/* invalidate stuff */
+	disk_part_iter_init(&piter, disk,
+			     DISK_PITER_INCL_EMPTY | DISK_PITER_REVERSE);
+	for_each_part(part, &piter) {
+		invalidate_partition(disk, part->partno);
+		delete_partition(disk, part->partno);
+	}
+	disk_part_iter_exit(&piter);
+	invalidate_partition(disk, 0);
+
+	del_gendisk_end(disk);
+}
 EXPORT_SYMBOL(del_gendisk);
 
 /**

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
