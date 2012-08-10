Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7AI21HU114399 for <xfs@oss.sgi.com>; Fri, 10 Aug 2012 13:02:01 -0500
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 6sOkVUR7QLDTpS5f for
	<xfs@oss.sgi.com>; Fri, 10 Aug 2012 11:02:00 -0700 (PDT)
Received: from int-mx12.intmail.prod.int.phx2.redhat.com
	(int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q7AI1x1B004988
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Fri, 10 Aug 2012 14:02:00 -0400
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: [PATCH] xfs: fix race while discarding buffers [V4]
Date: Fri, 10 Aug 2012 15:01:51 -0300
Message-Id: <1344621711-8049-1-git-send-email-cmaiolino@redhat.com>
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
locking and the test condition in xfs_buf_stale() checks for the buffer being in
*any* list:

if (!list_empty(&bp->b_lru)

If the buffer happens to be on dispose list, this causes the buffer counter of
lru list (btp->bt_lru_nr) to be decremented twice (once in xfs_buftarg_shrink()
and another in xfs_buf_stale()) causing a wrong account usage of the lru list.

This may cause xfs_buftarg_shrink() to return a wrong value to the memory
shrinker shrink_slab(), and such account error may also cause an underflowed
value to be returned; since the counter is lower than the current number of
items in the lru list, a decrement may happen when the counter is 0, causing
an underflow on the counter.

The fix uses a new flag field (and a new buffer flag) to serialize buffer
handling during the shrink process. The new flag field has been designed to use
btp->bt_lru_lock/unlock instead of xfs_buf_lock/unlock mechanism.

dchinner, sandeen, aquini and aris also deserve credits for this.

Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
---
 fs/xfs/xfs_buf.c |  5 ++++-
 fs/xfs/xfs_buf.h | 41 ++++++++++++++++++++++++-----------------
 2 files changed, 28 insertions(+), 18 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index d7a9dd7..933b793 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -96,6 +96,7 @@ xfs_buf_lru_add(
 		atomic_inc(&bp->b_hold);
 		list_add_tail(&bp->b_lru, &btp->bt_lru);
 		btp->bt_lru_nr++;
+		bp->b_lru_flags &= ~_XBF_LRU_DISPOSE;
 	}
 	spin_unlock(&btp->bt_lru_lock);
 }
@@ -154,7 +155,8 @@ xfs_buf_stale(
 		struct xfs_buftarg *btp = bp->b_target;
 
 		spin_lock(&btp->bt_lru_lock);
-		if (!list_empty(&bp->b_lru)) {
+		if (!list_empty(&bp->b_lru) &&
+		    !(bp->b_lru_flags & _XBF_LRU_DISPOSE)) {
 			list_del_init(&bp->b_lru);
 			btp->bt_lru_nr--;
 			atomic_dec(&bp->b_hold);
@@ -1501,6 +1503,7 @@ xfs_buftarg_shrink(
 		 */
 		list_move(&bp->b_lru, &dispose);
 		btp->bt_lru_nr--;
+		bp->b_lru_flags |= _XBF_LRU_DISPOSE;
 	}
 	spin_unlock(&btp->bt_lru_lock);
 
diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
index d03b73b..7c0b6a0 100644
--- a/fs/xfs/xfs_buf.h
+++ b/fs/xfs/xfs_buf.h
@@ -38,27 +38,28 @@ typedef enum {
 	XBRW_ZERO = 3,			/* Zero target memory */
 } xfs_buf_rw_t;
 
-#define XBF_READ	(1 << 0) /* buffer intended for reading from device */
-#define XBF_WRITE	(1 << 1) /* buffer intended for writing to device */
-#define XBF_READ_AHEAD	(1 << 2) /* asynchronous read-ahead */
-#define XBF_ASYNC	(1 << 4) /* initiator will not wait for completion */
-#define XBF_DONE	(1 << 5) /* all pages in the buffer uptodate */
-#define XBF_STALE	(1 << 6) /* buffer has been staled, do not find it */
+#define XBF_READ	 (1 << 0) /* buffer intended for reading from device */
+#define XBF_WRITE	 (1 << 1) /* buffer intended for writing to device */
+#define XBF_READ_AHEAD	 (1 << 2) /* asynchronous read-ahead */
+#define XBF_ASYNC	 (1 << 4) /* initiator will not wait for completion */
+#define XBF_DONE	 (1 << 5) /* all pages in the buffer uptodate */
+#define XBF_STALE	 (1 << 6) /* buffer has been staled, do not find it */
 
 /* I/O hints for the BIO layer */
-#define XBF_SYNCIO	(1 << 10)/* treat this buffer as synchronous I/O */
-#define XBF_FUA		(1 << 11)/* force cache write through mode */
-#define XBF_FLUSH	(1 << 12)/* flush the disk cache before a write */
+#define XBF_SYNCIO	 (1 << 10)/* treat this buffer as synchronous I/O */
+#define XBF_FUA		 (1 << 11)/* force cache write through mode */
+#define XBF_FLUSH	 (1 << 12)/* flush the disk cache before a write */
 
 /* flags used only as arguments to access routines */
-#define XBF_TRYLOCK	(1 << 16)/* lock requested, but do not wait */
-#define XBF_UNMAPPED	(1 << 17)/* do not map the buffer */
+#define XBF_TRYLOCK	 (1 << 16)/* lock requested, but do not wait */
+#define XBF_UNMAPPED	 (1 << 17)/* do not map the buffer */
 
 /* flags used only internally */
-#define _XBF_PAGES	(1 << 20)/* backed by refcounted pages */
-#define _XBF_KMEM	(1 << 21)/* backed by heap memory */
-#define _XBF_DELWRI_Q	(1 << 22)/* buffer on a delwri queue */
-#define _XBF_COMPOUND	(1 << 23)/* compound buffer */
+#define _XBF_PAGES	 (1 << 20)/* backed by refcounted pages */
+#define _XBF_KMEM	 (1 << 21)/* backed by heap memory */
+#define _XBF_DELWRI_Q	 (1 << 22)/* buffer on a delwri queue */
+#define _XBF_COMPOUND	 (1 << 23)/* compound buffer */
+#define _XBF_LRU_DISPOSE (1 << 24)/* buffer being discarded */
 
 typedef unsigned int xfs_buf_flags_t;
 
@@ -72,12 +73,13 @@ typedef unsigned int xfs_buf_flags_t;
 	{ XBF_SYNCIO,		"SYNCIO" }, \
 	{ XBF_FUA,		"FUA" }, \
 	{ XBF_FLUSH,		"FLUSH" }, \
-	{ XBF_TRYLOCK,		"TRYLOCK" }, 	/* should never be set */\
+	{ XBF_TRYLOCK,		"TRYLOCK" },	/* should never be set */\
 	{ XBF_UNMAPPED,		"UNMAPPED" },	/* ditto */\
 	{ _XBF_PAGES,		"PAGES" }, \
 	{ _XBF_KMEM,		"KMEM" }, \
 	{ _XBF_DELWRI_Q,	"DELWRI_Q" }, \
-	{ _XBF_COMPOUND,	"COMPOUND" }
+	{ _XBF_COMPOUND,	"COMPOUND" }, \
+	{ _XBF_LRU_DISPOSE,	"LRU_DISPOSE" }
 
 typedef struct xfs_buftarg {
 	dev_t			bt_dev;
@@ -124,7 +126,12 @@ typedef struct xfs_buf {
 	xfs_buf_flags_t		b_flags;	/* status flags */
 	struct semaphore	b_sema;		/* semaphore for lockables */
 
+	/*
+	 * concurrent access to b_lru and b_lru_flags are protected by
+	 * bt_lru_lock and not by b_sema
+	 */
 	struct list_head	b_lru;		/* lru list */
+	xfs_buf_flags_t		b_lru_flags;	/* internal lru status flags */
 	wait_queue_head_t	b_waiters;	/* unpin waiters */
 	struct list_head	b_list;
 	struct xfs_perag	*b_pag;		/* contains rbtree root */
-- 
1.7.11.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
