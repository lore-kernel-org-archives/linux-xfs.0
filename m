Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o737NCks230198 for <xfs@oss.sgi.com>; Tue, 3 Aug 2010 02:23:13 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2185048E473
	for <xfs@oss.sgi.com>; Tue,  3 Aug 2010 00:23:30 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail19.adl2.internode.on.net
	[150.101.137.104]) by cuda.sgi.com with ESMTP id
	wATLig4HIX6m103Z for <xfs@oss.sgi.com>;
	Tue, 03 Aug 2010 00:23:30 -0700 (PDT)
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 3/3] dio: add a mempool for the unaligned block structures
Date: Tue,  3 Aug 2010 17:23:24 +1000
Message-Id: <1280820204-1418-4-git-send-email-david@fromorbit.com>
In-Reply-To: <1280820204-1418-1-git-send-email-david@fromorbit.com>
References: <1280820204-1418-1-git-send-email-david@fromorbit.com>
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
Cc: xfs@oss.sgi.com

From: Dave Chinner <dchinner@redhat.com>

We need the zero block tracking structure allocation to succeed.
Silently failing and potentially allowing data corruption is not an
option. Add a mempool to ensure this allocation will always succeed.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/direct-io.c |   14 +++++++++++---
 1 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/fs/direct-io.c b/fs/direct-io.c
index 368abec..dfc5d9a 100644
--- a/fs/direct-io.c
+++ b/fs/direct-io.c
@@ -161,12 +161,22 @@ struct dio_zero_block_head {
 static struct dio_zero_block_head dio_zero_blocks[DIO_ZERO_BLOCK_NR];
 #define to_dio_zero_head(zb)	(&dio_zero_blocks[zb % DIO_ZERO_BLOCK_NR])
 
+/* a small mempool just to guarantee progress. */
+#define DIO_ZERO_BLOCK_ENTRIES	2
+static mempool_t *dio_zero_block_pool;
+
 
 static int __init
 dio_init_zero_block(void)
 {
 	int i;
 
+	dio_zero_block_pool = mempool_create_kmalloc_pool(
+					DIO_ZERO_BLOCK_ENTRIES,
+					sizeof(struct dio_zero_block));
+	if (!dio_zero_block_pool)
+		panic("dio: can't create zero block pool");
+
 	for (i = 0; i < DIO_ZERO_BLOCK_NR; i++) {
 		spin_lock_init(&dio_zero_blocks[i].lock);
 		INIT_LIST_HEAD(&dio_zero_blocks[i].list);
@@ -184,9 +194,7 @@ dio_start_zero_block(struct dio *dio, sector_t zero_block)
 	struct dio_zero_block_head *zbh = to_dio_zero_head(zero_block);
 	struct dio_zero_block *zb;
 
-	zb = kmalloc(sizeof(*zb), GFP_NOIO);
-	if (!zb)
-		return;
+	zb = mempool_alloc(dio_zero_block_pool, GFP_NOIO);
 	INIT_LIST_HEAD(&zb->dio_list);
 	init_waitqueue_head(&zb->wq);
 	zb->zero_block = zero_block;
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
