Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o727Q2Ox177220 for <xfs@oss.sgi.com>; Mon, 2 Aug 2010 02:26:02 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0BC581E39AC4
	for <xfs@oss.sgi.com>; Mon,  2 Aug 2010 00:26:19 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail14.adl6.internode.on.net
	[150.101.137.99]) by cuda.sgi.com with ESMTP id
	DvXzmLwaNqdPNolA for <xfs@oss.sgi.com>;
	Mon, 02 Aug 2010 00:26:19 -0700 (PDT)
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 2/2] dio: scale unaligned IO tracking via multiple lists
Date: Mon,  2 Aug 2010 17:25:45 +1000
Message-Id: <1280733945-16231-3-git-send-email-david@fromorbit.com>
In-Reply-To: <1280733945-16231-1-git-send-email-david@fromorbit.com>
References: <1280733945-16231-1-git-send-email-david@fromorbit.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: linux-fsdevel@vger.kernel.org
Cc: sandeen@sandeen.net, xfs@oss.sgi.com

From: Dave Chinner <dchinner@redhat.com>

To avoid concerns that a single list and lock tracking the unaligned IOs
will not scale appropriately, create multiple lists and locks and chose them by
hashing the unaligned block being zeroed.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/direct-io.c |   53 ++++++++++++++++++++++++++++++++++++++++-------------
 1 files changed, 40 insertions(+), 13 deletions(-)

diff --git a/fs/direct-io.c b/fs/direct-io.c
index 611524e..95dcba4 100644
--- a/fs/direct-io.c
+++ b/fs/direct-io.c
@@ -152,8 +152,29 @@ struct dio_zero_block {
 	atomic_t	ref;		/* reference count */
 };
 
-DEFINE_SPINLOCK(dio_zero_block_lock);
-LIST_HEAD(dio_zero_block_list);
+#define DIO_ZERO_BLOCK_NR	37LL
+struct dio_zero_block_head {
+	struct list_head	list;
+	spinlock_t		lock;
+};
+
+struct dio_zero_block_head dio_zero_blocks[DIO_ZERO_BLOCK_NR];
+#define to_dio_zero_list(zb)	(&dio_zero_blocks[zb % DIO_ZERO_BLOCK_NR].list)
+#define to_dio_zero_lock(zb)	(&dio_zero_blocks[zb % DIO_ZERO_BLOCK_NR].lock)
+
+
+static int __init
+dio_init_zero_block(void)
+{
+	int i;
+
+	for (i = 0; i < DIO_ZERO_BLOCK_NR; i++) {
+		spin_lock_init(&dio_zero_blocks[i].lock);
+		INIT_LIST_HEAD(&dio_zero_blocks[i].list);
+	}
+	return 0;
+}
+subsys_initcall(dio_init_zero_block);
 
 /*
  * Add a filesystem block to the list of blocks we are tracking.
@@ -162,6 +183,8 @@ static void
 dio_start_zero_block(struct dio *dio, sector_t zero_block)
 {
 	struct dio_zero_block *zb;
+	struct list_head *list  = to_dio_zero_list(zero_block);
+	spinlock_t *lock = to_dio_zero_lock(zero_block);
 
 	zb = kmalloc(sizeof(*zb), GFP_NOIO);
 	if (!zb)
@@ -172,9 +195,9 @@ dio_start_zero_block(struct dio *dio, sector_t zero_block)
 	zb->dio = dio;
 	atomic_set(&zb->ref, 1);
 
-	spin_lock(&dio_zero_block_lock);
-	list_add(&zb->dio_list, &dio_zero_block_list);
-	spin_unlock(&dio_zero_block_lock);
+	spin_lock(lock);
+	list_add(&zb->dio_list, list);
+	spin_unlock(lock);
 }
 
 static void
@@ -194,20 +217,22 @@ static int
 dio_wait_zero_block(struct dio *dio, sector_t zero_block)
 {
 	struct dio_zero_block *zb;
+	struct list_head *list  = to_dio_zero_list(zero_block);
+	spinlock_t *lock = to_dio_zero_lock(zero_block);
 
-	spin_lock(&dio_zero_block_lock);
-	list_for_each_entry(zb, &dio_zero_block_list, dio_list) {
+	spin_lock(lock);
+	list_for_each_entry(zb, list, dio_list) {
 		if (zb->dio->inode != dio->inode)
 			continue;
 		if (zb->zero_block != zero_block)
 			continue;
 		atomic_inc(&zb->ref);
-		spin_unlock(&dio_zero_block_lock);
+		spin_unlock(lock);
 		wait_event(zb->wq, (list_empty(&zb->dio_list)));
 		dio_drop_zero_block(zb);
 		return 1;
 	}
-	spin_unlock(&dio_zero_block_lock);
+	spin_unlock(lock);
 	return 0;
 }
 
@@ -217,20 +242,22 @@ dio_wait_zero_block(struct dio *dio, sector_t zero_block)
 static void dio_end_zero_block(struct dio *dio, sector_t zero_block)
 {
 	struct dio_zero_block *zb;
+	struct list_head *list  = to_dio_zero_list(zero_block);
+	spinlock_t *lock = to_dio_zero_lock(zero_block);
 
-	spin_lock(&dio_zero_block_lock);
-	list_for_each_entry(zb, &dio_zero_block_list, dio_list) {
+	spin_lock(lock);
+	list_for_each_entry(zb, list, dio_list) {
 		if (zb->dio->inode != dio->inode)
 			continue;
 		if (zb->zero_block != zero_block)
 			continue;
 		list_del_init(&zb->dio_list);
-		spin_unlock(&dio_zero_block_lock);
+		spin_unlock(lock);
 		wake_up(&zb->wq);
 		dio_drop_zero_block(zb);
 		return;
 	}
-	spin_unlock(&dio_zero_block_lock);
+	spin_unlock(lock);
 }
 
 /*
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
