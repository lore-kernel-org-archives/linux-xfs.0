Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q76FQfdT162017 for <xfs@oss.sgi.com>; Mon, 6 Aug 2012 10:26:42 -0500
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id v1AWx7bIlvw5gt1q for
	<xfs@oss.sgi.com>; Mon, 06 Aug 2012 08:26:41 -0700 (PDT)
Received: from int-mx01.intmail.prod.int.phx2.redhat.com
	(int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q76FQemM022101
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Mon, 6 Aug 2012 11:26:40 -0400
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: [PATCH] xfs: fix race while discarding buffers
Date: Mon,  6 Aug 2012 12:26:37 -0300
Message-Id: <1344266797-7749-1-git-send-email-cmaiolino@redhat.com>
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
Cc: Carlos Maiolino <cmaiolino@redhat.com>

While xfs_buftarg_shrink() is freeing buffers from the dispose list (filled with
buffers from lru list), there is a possibility to have xfs_buf_stale() racing
with it, and removing buffers from dispose list before xfs_buftarg_shrink() does
it.

This happens because xfs_buftarg_shrink() handle the dispose list without
locking and since the test condition in xfs_buf_stale()
-- if (!list_empty(&bp->b_lru)) -- checks for the buffer being in *any* list, if
the buffer happens to be on dispose list, this causes the buffer counter of the
lru list (btp->bt_lru_nr) to be decremented twice (once in xfs_buftarg_shrink()
and another in xfs_buf_stale()) causing a wrong account usage of the lru list,
which may cause xfs_buftarg_shrink() to return a wrong value to the memory
shrinker function (shrink_slab()), such account error may also cause a
underflowed value to be returned; since the counter is lower than the current
number of items in the lru list, a decrement may happen when the counter is 0,
causing an underflow since the counter is an unsigned value.

The fix uses a new flag field (and a new buffer flag) to serialize buffer
handling during the shrink process. The new flag fied has been designed to use
btp->bt_lru_lock/unlock instead of xfs_buf_lock/unlock mechanism.

Thanks to dchinner, sandeen and aris for the help and hints on this

Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
---
 fs/xfs/xfs_buf.c | 7 ++++++-
 fs/xfs/xfs_buf.h | 7 ++++++-
 2 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index d7a9dd7..52b27c4 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -96,6 +96,8 @@ xfs_buf_lru_add(
 		atomic_inc(&bp->b_hold);
 		list_add_tail(&bp->b_lru, &btp->bt_lru);
 		btp->bt_lru_nr++;
+		if (bp->b_lru_flags & XBF_LRU_DISPOSE)
+			bp->b_lru_flags &= ~XBF_LRU_DISPOSE;
 	}
 	spin_unlock(&btp->bt_lru_lock);
 }
@@ -154,7 +156,8 @@ xfs_buf_stale(
 		struct xfs_buftarg *btp = bp->b_target;
 
 		spin_lock(&btp->bt_lru_lock);
-		if (!list_empty(&bp->b_lru)) {
+		if (!list_empty(&bp->b_lru) &&
+		   !(bp->b_lru_flags & XBF_LRU_DISPOSE)) {
 			list_del_init(&bp->b_lru);
 			btp->bt_lru_nr--;
 			atomic_dec(&bp->b_hold);
@@ -228,6 +231,7 @@ _xfs_buf_alloc(
 	XB_SET_OWNER(bp);
 	bp->b_target = target;
 	bp->b_flags = flags;
+	bp->b_lru_flags = 0;
 
 	/*
 	 * Set length and io_length to the same value initially.
@@ -1500,6 +1504,7 @@ xfs_buftarg_shrink(
 		 * lock round trip inside xfs_buf_rele().
 		 */
 		list_move(&bp->b_lru, &dispose);
+		bp->b_lru_flags |= XBF_LRU_DISPOSE;
 		btp->bt_lru_nr--;
 	}
 	spin_unlock(&btp->bt_lru_lock);
diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
index d03b73b..ec0a17e 100644
--- a/fs/xfs/xfs_buf.h
+++ b/fs/xfs/xfs_buf.h
@@ -60,6 +60,9 @@ typedef enum {
 #define _XBF_DELWRI_Q	(1 << 22)/* buffer on a delwri queue */
 #define _XBF_COMPOUND	(1 << 23)/* compound buffer */
 
+/* flags used to handle lru items */
+#define XBF_LRU_DISPOSE (1 << 24) /* buffer being discarded */
+
 typedef unsigned int xfs_buf_flags_t;
 
 #define XFS_BUF_FLAGS \
@@ -77,7 +80,8 @@ typedef unsigned int xfs_buf_flags_t;
 	{ _XBF_PAGES,		"PAGES" }, \
 	{ _XBF_KMEM,		"KMEM" }, \
 	{ _XBF_DELWRI_Q,	"DELWRI_Q" }, \
-	{ _XBF_COMPOUND,	"COMPOUND" }
+	{ _XBF_COMPOUND,	"COMPOUND" }, \
+	{ XBF_LRU_DISPOSE,	"LRU_DISPOSE" }
 
 typedef struct xfs_buftarg {
 	dev_t			bt_dev;
@@ -122,6 +126,7 @@ typedef struct xfs_buf {
 	atomic_t		b_hold;		/* reference count */
 	atomic_t		b_lru_ref;	/* lru reclaim ref count */
 	xfs_buf_flags_t		b_flags;	/* status flags */
+	xfs_buf_flags_t		b_lru_flags;	/* internal lru status flags */
 	struct semaphore	b_sema;		/* semaphore for lockables */
 
 	struct list_head	b_lru;		/* lru list */
-- 
1.7.11.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
