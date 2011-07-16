Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6G1M1Mb228094 for <xfs@oss.sgi.com>; Fri, 15 Jul 2011 20:22:01 -0500
Received: from e7.ny.us.ibm.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3DE2A75A45
	for <xfs@oss.sgi.com>; Fri, 15 Jul 2011 18:22:00 -0700 (PDT)
Received: from e7.ny.us.ibm.com (e7.ny.us.ibm.com [32.97.182.137]) by
	cuda.sgi.com with ESMTP id gqUL889hGBLdvRox for
	<xfs@oss.sgi.com>; Fri, 15 Jul 2011 18:22:00 -0700 (PDT)
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e7.ny.us.ibm.com (8.14.4/8.13.1) with ESMTP id p6G0ujdJ023459
	for <xfs@oss.sgi.com>; Fri, 15 Jul 2011 20:56:45 -0400
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	p6G1M0uD157964 for <xfs@oss.sgi.com>; Fri, 15 Jul 2011 21:22:00 -0400
Received: from d03av01.boulder.ibm.com (loopback [127.0.0.1])
	by d03av01.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP
	id p6G1LxwZ008661
	for <xfs@oss.sgi.com>; Fri, 15 Jul 2011 19:21:59 -0600
From: Chandra Seetharaman <sekharan@us.ibm.com>
Date: Fri, 15 Jul 2011 18:21:58 -0700
Message-Id: <20110716012158.6629.88989.sendpatchset@chandra-lucid.beaverton.ibm.com>
In-Reply-To: <20110716012105.6629.24407.sendpatchset@chandra-lucid.beaverton.ibm.com>
References: <20110716012105.6629.24407.sendpatchset@chandra-lucid.beaverton.ibm.com>
Subject: [PATCH 09/12] Replace the macro XFS_BUF_ISPINNED with helper
	xfs_buf_ispinned
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
To: xfs@oss.sgi.com
Cc: Chandra Seetharaman <sekharan@us.ibm.com>

Replace the macro with an inline helper function, and change all
its usages.

Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
---
 fs/xfs/linux-2.6/xfs_buf.c  |    2 +-
 fs/xfs/linux-2.6/xfs_buf.h  |    5 ++++-
 fs/xfs/linux-2.6/xfs_sync.c |    2 +-
 fs/xfs/quota/xfs_dquot.c    |    4 ++--
 fs/xfs/xfs_buf_item.c       |    2 +-
 fs/xfs/xfs_inode.c          |    2 +-
 6 files changed, 10 insertions(+), 7 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_buf.c b/fs/xfs/linux-2.6/xfs_buf.c
index b3265dd..57b36e2 100644
--- a/fs/xfs/linux-2.6/xfs_buf.c
+++ b/fs/xfs/linux-2.6/xfs_buf.c
@@ -1694,7 +1694,7 @@ xfs_buf_delwri_split(
 	list_for_each_entry_safe(bp, n, dwq, b_list) {
 		ASSERT(XFS_BUF_ISDELAYWRITE(bp));
 
-		if (!XFS_BUF_ISPINNED(bp) && !xfs_buf_cond_lock(bp)) {
+		if (!xfs_buf_ispinned(bp) && !xfs_buf_cond_lock(bp)) {
 			if (!force &&
 			    time_before(jiffies, bp->b_queuetime + age)) {
 				xfs_buf_unlock(bp);
diff --git a/fs/xfs/linux-2.6/xfs_buf.h b/fs/xfs/linux-2.6/xfs_buf.h
index 7149c07..177c6f1 100644
--- a/fs/xfs/linux-2.6/xfs_buf.h
+++ b/fs/xfs/linux-2.6/xfs_buf.h
@@ -294,7 +294,10 @@ xfs_buf_set_ref(
 #define XFS_BUF_SET_VTYPE_REF(bp, type, ref)	xfs_buf_set_ref(bp, ref)
 #define XFS_BUF_SET_VTYPE(bp, type)		do { } while (0)
 
-#define XFS_BUF_ISPINNED(bp)	atomic_read(&((bp)->b_pin_count))
+static inline int xfs_buf_ispinned(struct xfs_buf *bp)
+{
+	return atomic_read(&(bp->b_pin_count));
+}
 
 #define XFS_BUF_VALUSEMA(bp)	xfs_buf_lock_value(bp)
 #define XFS_BUF_CPSEMA(bp)	(xfs_buf_cond_lock(bp) == 0)
diff --git a/fs/xfs/linux-2.6/xfs_sync.c b/fs/xfs/linux-2.6/xfs_sync.c
index b32c09e..4331463 100644
--- a/fs/xfs/linux-2.6/xfs_sync.c
+++ b/fs/xfs/linux-2.6/xfs_sync.c
@@ -330,7 +330,7 @@ xfs_sync_fsdata(
 	 * between there and here.
 	 */
 	bp = xfs_getsb(mp, 0);
-	if (XFS_BUF_ISPINNED(bp))
+	if (xfs_buf_ispinned(bp))
 		xfs_log_force(mp, 0);
 
 	return xfs_bwrite(mp, bp);
diff --git a/fs/xfs/quota/xfs_dquot.c b/fs/xfs/quota/xfs_dquot.c
index 7a3beba..c94e350 100644
--- a/fs/xfs/quota/xfs_dquot.c
+++ b/fs/xfs/quota/xfs_dquot.c
@@ -1235,7 +1235,7 @@ xfs_qm_dqflush(
 	 * If the buffer is pinned then push on the log so we won't
 	 * get stuck waiting in the write for too long.
 	 */
-	if (XFS_BUF_ISPINNED(bp)) {
+	if (xfs_buf_ispinned(bp)) {
 		trace_xfs_dqflush_force(dqp);
 		xfs_log_force(mp, 0);
 	}
@@ -1481,7 +1481,7 @@ xfs_qm_dqflock_pushbuf_wait(
 		goto out_lock;
 
 	if (XFS_BUF_ISDELAYWRITE(bp)) {
-		if (XFS_BUF_ISPINNED(bp))
+		if (xfs_buf_ispinned(bp))
 			xfs_log_force(mp, 0);
 		xfs_buf_delwri_promote(bp);
 		wake_up_process(bp->b_target->bt_task);
diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index c4f01e0..2f4169a 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -480,7 +480,7 @@ xfs_buf_item_trylock(
 	struct xfs_buf_log_item	*bip = BUF_ITEM(lip);
 	struct xfs_buf		*bp = bip->bli_buf;
 
-	if (XFS_BUF_ISPINNED(bp))
+	if (xfs_buf_ispinned(bp))
 		return XFS_ITEM_PINNED;
 	if (!XFS_BUF_CPSEMA(bp))
 		return XFS_ITEM_LOCKED;
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index ff8d8ea..c6f870d 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2848,7 +2848,7 @@ xfs_iflush(
 	 * If the buffer is pinned then push on the log now so we won't
 	 * get stuck waiting in the write for too long.
 	 */
-	if (XFS_BUF_ISPINNED(bp))
+	if (xfs_buf_ispinned(bp))
 		xfs_log_force(mp, 0);
 
 	/*
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
