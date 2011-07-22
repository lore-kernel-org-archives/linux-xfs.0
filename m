Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6M0XnV6051526 for <xfs@oss.sgi.com>; Thu, 21 Jul 2011 19:33:49 -0500
Received: from e7.ny.us.ibm.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id AE5CF8C73F
	for <xfs@oss.sgi.com>; Thu, 21 Jul 2011 17:33:48 -0700 (PDT)
Received: from e7.ny.us.ibm.com (e7.ny.us.ibm.com [32.97.182.137]) by
	cuda.sgi.com with ESMTP id fBxF41K2YGMoTfjg for
	<xfs@oss.sgi.com>; Thu, 21 Jul 2011 17:33:48 -0700 (PDT)
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e7.ny.us.ibm.com (8.14.4/8.13.1) with ESMTP id p6M08Kst030559
	for <xfs@oss.sgi.com>; Thu, 21 Jul 2011 20:08:20 -0400
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	p6M0Xl23133764 for <xfs@oss.sgi.com>; Thu, 21 Jul 2011 20:33:47 -0400
Received: from d03av01.boulder.ibm.com (loopback [127.0.0.1])
	by d03av01.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP
	id p6M0XlpG018007
	for <xfs@oss.sgi.com>; Thu, 21 Jul 2011 18:33:47 -0600
From: Chandra Seetharaman <sekharan@us.ibm.com>
Date: Thu, 21 Jul 2011 17:33:43 -0700
Message-Id: <20110722003343.21069.95122.sendpatchset@chandra-lucid.beaverton.ibm.com>
In-Reply-To: <20110722003226.21069.58401.sendpatchset@chandra-lucid.beaverton.ibm.com>
References: <20110722003226.21069.58401.sendpatchset@chandra-lucid.beaverton.ibm.com>
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

Replace the macro XFS_BUF_ISPINNED with an inline helper function
xfs_buf_ispinned, and change all its usages.

Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/linux-2.6/xfs_buf.c  |    2 +-
 fs/xfs/linux-2.6/xfs_buf.h  |    5 ++++-
 fs/xfs/linux-2.6/xfs_sync.c |    2 +-
 fs/xfs/quota/xfs_dquot.c    |    4 ++--
 fs/xfs/xfs_buf_item.c       |    2 +-
 fs/xfs/xfs_inode.c          |    2 +-
 6 files changed, 10 insertions(+), 7 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_buf.c b/fs/xfs/linux-2.6/xfs_buf.c
index 6a42f71..5e929f0 100644
--- a/fs/xfs/linux-2.6/xfs_buf.c
+++ b/fs/xfs/linux-2.6/xfs_buf.c
@@ -1677,7 +1677,7 @@ xfs_buf_delwri_split(
 	list_for_each_entry_safe(bp, n, dwq, b_list) {
 		ASSERT(bp->b_flags & XBF_DELWRI);
 
-		if (!XFS_BUF_ISPINNED(bp) && xfs_buf_trylock(bp)) {
+		if (!xfs_buf_ispinned(bp) && xfs_buf_trylock(bp)) {
 			if (!force &&
 			    time_before(jiffies, bp->b_queuetime + age)) {
 				xfs_buf_unlock(bp);
diff --git a/fs/xfs/linux-2.6/xfs_buf.h b/fs/xfs/linux-2.6/xfs_buf.h
index 7b1f484..71e1d6f 100644
--- a/fs/xfs/linux-2.6/xfs_buf.h
+++ b/fs/xfs/linux-2.6/xfs_buf.h
@@ -280,7 +280,10 @@ xfs_buf_set_ref(
 #define XFS_BUF_SET_VTYPE_REF(bp, type, ref)	xfs_buf_set_ref(bp, ref)
 #define XFS_BUF_SET_VTYPE(bp, type)		do { } while (0)
 
-#define XFS_BUF_ISPINNED(bp)	atomic_read(&((bp)->b_pin_count))
+static inline int xfs_buf_ispinned(struct xfs_buf *bp)
+{
+	return atomic_read(&(bp->b_pin_count));
+}
 
 #define XFS_BUF_FINISH_IOWAIT(bp)	complete(&bp->b_iowait);
 
diff --git a/fs/xfs/linux-2.6/xfs_sync.c b/fs/xfs/linux-2.6/xfs_sync.c
index 5cc158e..a8500e9 100644
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
index fccde4a..4bebb29 100644
--- a/fs/xfs/quota/xfs_dquot.c
+++ b/fs/xfs/quota/xfs_dquot.c
@@ -1237,7 +1237,7 @@ xfs_qm_dqflush(
 	 * If the buffer is pinned then push on the log so we won't
 	 * get stuck waiting in the write for too long.
 	 */
-	if (XFS_BUF_ISPINNED(bp)) {
+	if (xfs_buf_ispinned(bp)) {
 		trace_xfs_dqflush_force(dqp);
 		xfs_log_force(mp, 0);
 	}
@@ -1444,7 +1444,7 @@ xfs_qm_dqflock_pushbuf_wait(
 		goto out_lock;
 
 	if (XFS_BUF_ISDELAYWRITE(bp)) {
-		if (XFS_BUF_ISPINNED(bp))
+		if (xfs_buf_ispinned(bp))
 			xfs_log_force(mp, 0);
 		xfs_buf_delwri_promote(bp);
 		wake_up_process(bp->b_target->bt_task);
diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index a16c24c..a3d2bbc 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -478,7 +478,7 @@ xfs_buf_item_trylock(
 	struct xfs_buf_log_item	*bip = BUF_ITEM(lip);
 	struct xfs_buf		*bp = bip->bli_buf;
 
-	if (XFS_BUF_ISPINNED(bp))
+	if (xfs_buf_ispinned(bp))
 		return XFS_ITEM_PINNED;
 	if (!xfs_buf_trylock(bp))
 		return XFS_ITEM_LOCKED;
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index bdb47b2..76ee2c5 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2585,7 +2585,7 @@ xfs_iflush(
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
