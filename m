Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 648C57CA2
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 20:04:24 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 22F4530404E
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:04:24 -0700 (PDT)
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20]) by
	cuda.sgi.com with ESMTP id MdIuCFcwj52biRbR for
	<xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:04:22 -0700 (PDT)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [RFC PATCH 1/2] block, badblocks: add a notifier for badblocks
Date: Thu, 16 Jun 2016 19:03:38 -0600
Message-Id: <1466125419-17736-2-git-send-email-vishal.l.verma@intel.com>
In-Reply-To: <1466125419-17736-1-git-send-email-vishal.l.verma@intel.com>
References: <1466125419-17736-1-git-send-email-vishal.l.verma@intel.com>
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
To: linux-nvdimm@lists.01.org, xfs@oss.sgi.com
Cc: Jan Kara <jack@suse.cz>, Vishal Verma <vishal.l.verma@intel.com>, "Darrick J. Wong" <darrick.wong@oracle.com>

Filesystems with reverse mapping data may wish to do their own badblock
checking if they can be more efficient. This lays the groundwork for
that by providing a notifier in badblocks that such filesystems may
subscribe to. The notification includes information for whether one or
more badblocks were added or removed, the start sector of the operation,
and the number of sectors affected.

Cc: Darrick J. Wong <darrick.wong@oracle.com>
Cc: Dave Chinner <david@fromorbit.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 block/badblocks.c         | 79 +++++++++++++++++++++++++++++++++++++++++++++--
 include/linux/badblocks.h | 19 ++++++++++++
 2 files changed, 95 insertions(+), 3 deletions(-)

diff --git a/block/badblocks.c b/block/badblocks.c
index 7be53cb..f7cfece 100644
--- a/block/badblocks.c
+++ b/block/badblocks.c
@@ -16,6 +16,7 @@
  */
 
 #include <linux/badblocks.h>
+#include <linux/notifier.h>
 #include <linux/seqlock.h>
 #include <linux/device.h>
 #include <linux/kernel.h>
@@ -25,6 +26,67 @@
 #include <linux/slab.h>
 
 /**
+ * badblocks_notify - call badblocks notifier chain
+ * @bb: struct badblocks that is changing
+ * @op: badblocks operation
+ * @sector: old clk rate
+ *
+ * Triggers a notifier call chain on the badblocks change notification
+ * for 'bb'.  Passes a pointer to the struct badblocks and the operation,
+ * and affected sector. Intended to be called by internal badblocks code
+ * only. Returns whatever atomic_notifier_call_chain returns.
+ */
+static int badblocks_notify(struct badblocks *bb, unsigned long op, sector_t sector,
+		int count)
+{
+	struct bb_notifier_data bbn_data;
+
+	bbn_data.sector = sector;
+	bbn_data.count = count;
+
+	return atomic_notifier_call_chain(&bb->notifier, op, &bbn_data);
+}
+
+/**
+ * bb_notifier_register - add a badblocks change notifier
+ * @bb: struct badblocks * to watch
+ * @nb: struct notifier_block * with callback info
+ *
+ * Request notification when badblocks are added or cleared.
+ * This uses a notifier of the 'atomic' type.
+ *
+ * Returns -EINVAL if called with null arguments otherwise, passes along
+ * the return value of atomic_notifier_chain_register().
+ */
+int bb_notifier_register(struct badblocks *bb, struct notifier_block *nb)
+{
+	if (!bb || !nb)
+		return -EINVAL;
+
+	return atomic_notifier_chain_register(&bb->notifier, nb);
+}
+EXPORT_SYMBOL_GPL(bb_notifier_register);
+
+/**
+ * bb_notifier_unregister - remove a badblocks change notifier
+ * @bb: struct badblocks *
+ * @nb: struct notifier_block * with callback info
+ *
+ * Request no further notification for changes to the badblocks list.
+ *
+ * Returns -EINVAL if called with null arguments; otherwise, passes
+ * along the return value of atomic_notifier_chain_unregister().
+ */
+int bb_notifier_unregister(struct badblocks *bb, struct notifier_block *nb)
+{
+	if (!bb || !nb)
+		return -EINVAL;
+
+	return atomic_notifier_chain_unregister(&bb->notifier, nb);
+}
+EXPORT_SYMBOL_GPL(bb_notifier_unregister);
+
+/**
  * badblocks_check() - check a given range for bad sectors
  * @bb:		the badblocks structure that holds all badblock information
  * @s:		sector (start) at which to check for badblocks
@@ -152,9 +214,10 @@ int badblocks_set(struct badblocks *bb, sector_t s, int sectors,
 			int acknowledged)
 {
 	u64 *p;
-	int lo, hi;
-	int rv = 0;
+	int rv = 0, ret;
 	unsigned long flags;
+	sector_t saved_s = s;
+	int lo, hi, saved_count = sectors;
 
 	if (bb->shift < 0)
 		/* badblocks are disabled */
@@ -294,6 +357,11 @@ int badblocks_set(struct badblocks *bb, sector_t s, int sectors,
 	bb->changed = 1;
 	if (!acknowledged)
 		bb->unacked_exist = 1;
+
+	ret = badblocks_notify(bb, BB_ADD, saved_s, saved_count);
+	if (ret)
+		WARN(1, "Failure in badblocks notifier chain: %d\n", ret);
+
 	write_sequnlock_irqrestore(&bb->lock, flags);
 
 	return rv;
@@ -318,8 +386,9 @@ int badblocks_clear(struct badblocks *bb, sector_t s, int sectors)
 {
 	u64 *p;
 	int lo, hi;
+	sector_t saved_s = s;
 	sector_t target = s + sectors;
-	int rv = 0;
+	int rv = 0, ret, saved_count = sectors;
 
 	if (bb->shift > 0) {
 		/* When clearing we round the start up and the end down.
@@ -400,6 +469,9 @@ int badblocks_clear(struct badblocks *bb, sector_t s, int sectors)
 	}
 
 	bb->changed = 1;
+	ret = badblocks_notify(bb, BB_CLEAR, saved_s, saved_count);
+	if (ret)
+		WARN(1, "Failure in badblocks notifier chain: %d\n", ret);
 out:
 	write_sequnlock_irq(&bb->lock);
 	return rv;
@@ -541,6 +613,7 @@ static int __badblocks_init(struct device *dev, struct badblocks *bb,
 		return -ENOMEM;
 	}
 	seqlock_init(&bb->lock);
+	ATOMIC_INIT_NOTIFIER_HEAD(&bb->notifier);
 
 	return 0;
 }
diff --git a/include/linux/badblocks.h b/include/linux/badblocks.h
index c3bdf8c..67539f0 100644
--- a/include/linux/badblocks.h
+++ b/include/linux/badblocks.h
@@ -1,6 +1,7 @@
 #ifndef _LINUX_BADBLOCKS_H
 #define _LINUX_BADBLOCKS_H
 
+#include <linux/notifier.h>
 #include <linux/seqlock.h>
 #include <linux/device.h>
 #include <linux/kernel.h>
@@ -38,8 +39,26 @@ struct badblocks {
 	seqlock_t lock;
 	sector_t sector;
 	sector_t size;		/* in sectors */
+	struct atomic_notifier_head notifier; /* notifier for filesystems */
 };
 
+#define BB_ADD		0
+#define BB_CLEAR	1
+
+/**
+ * struct bb_notifier_data - data to pass to the notifier callback
+ * @bb: struct badblocks * being changed
+ * @sector: the 512B sector being added/removed
+ * @count: number of sectors after @sector being added/removed
+ */
+struct bb_notifier_data {
+	struct badblocks *bb;
+	sector_t sector;
+	int count;
+};
+
+int bb_notifier_register(struct badblocks *bb, struct notifier_block *nb);
+int bb_notifier_unregister(struct badblocks *bb, struct notifier_block *nb);
 int badblocks_check(struct badblocks *bb, sector_t s, int sectors,
 		   sector_t *first_bad, int *bad_sectors);
 int badblocks_set(struct badblocks *bb, sector_t s, int sectors,
-- 
2.5.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
