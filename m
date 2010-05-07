Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o475dLhM148929 for <xfs@oss.sgi.com>; Fri, 7 May 2010 00:39:21 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1BA90963902
	for <xfs@oss.sgi.com>; Thu,  6 May 2010 22:41:29 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail16.adl2.internode.on.net
	[150.101.137.101]) by cuda.sgi.com with ESMTP id
	aGk7jjK98smAGyfJ for <xfs@oss.sgi.com>;
	Thu, 06 May 2010 22:41:29 -0700 (PDT)
Received: from dastard (unverified [121.45.169.108])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	23402973-1927428
	for <xfs@oss.sgi.com>; Fri, 07 May 2010 15:11:24 +0930 (CST)
Received: from disturbed ([192.168.1.9]) by dastard with esmtp (Exim 4.71)
	(envelope-from <dave@fromorbit.com>) id 1OAGJE-0006rX-Fl
	for xfs@oss.sgi.com; Fri, 07 May 2010 15:41:12 +1000
Received: from dave by disturbed with local (Exim 4.71)
	(envelope-from <dave@disturbed.disaster>) id 1OAGJC-00066W-WE
	for xfs@oss.sgi.com; Fri, 07 May 2010 15:41:11 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 07/12] xfs: Improve scalability of busy extent tracking
Date: Fri,  7 May 2010 15:40:55 +1000
Message-Id: <1273210860-23414-8-git-send-email-david@fromorbit.com>
In-Reply-To: <1273210860-23414-1-git-send-email-david@fromorbit.com>
References: <1273210860-23414-1-git-send-email-david@fromorbit.com>
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

When we free a metadata extent, we record it in the per-AG busy
extent array so that it is not re-used before the freeing
transaction hits the disk. This array is fixed size, so when it
overflows we make further allocation transactions synchronous
because we cannot track more freed extents until those transactions
hit the disk and are completed. Under heavy mixed allocation and
freeing workloads with large log buffers, we can overflow this array
quite easily.

Further, the array is sparsely populated, which means that inserts
need to search for a free slot, and array searches often have to
search many more slots that are actually used to check all the
busy extents. Quite inefficient, really.

To enable this aspect of extent freeing to scale better, we need
a structure that can grow dynamically. While in other areas of
XFS we have used radix trees, the extents being freed are at random
locations on disk so are better suited to being indexed by an rbtree.

So, use a per-AG rbtree indexed by block number to track busy
extents.  This incures a memory allocation when marking an extent
busy, but should not occur too often in low memory situations. This
should scale to an arbitrary number of extents so should not be a
limitation for features such as in-memory aggregation of
transactions.

However, there are still situations where we can't avoid allocating
busy extents (such as allocation from the AGFL). To minimise the
overhead of such occurences, we need to avoid doing a synchronous
log force while holding the AGF locked to ensure that the previous
transactions are safely on disk before we use the extent. We can do
this by marking the transaction doing the allocation as synchronous
rather issuing a log force.

Because of the locking involved and the ordering of transactions,
the synchronous transaction provides the same guarantees as a
synchronous log force because it ensures that all the prior
transactions are already on disk when the synchronous transaction
hits the disk. i.e. it preserves the free->allocate order of the
extent correctly in recovery.

By doing this, we avoid holding the AGF locked while log writes are
in progress, hence reducing the length of time the lock is held and
therefore we increase the rate at which we can allocate and free
from the allocation group, thereby increasing overall throughput.

The only problem with this approach is that when a metadata buffer is
marked stale (e.g. a directory block is removed), then buffer remains
pinned and locked until the log goes to disk. The issue here is that
if that stale buffer is reallocated in a subsequent transaction, the
attempt to lock that buffer in the transaction will hang waiting
the log to go to disk to unlock and unpin the buffer. Hence if
someone tries to lock a pinned, stale, locked buffer we need to
push on the log to get it unlocked ASAP. Effectively we are trading
off a guaranteed log force for a much less common trigger for log
force to occur.

Ideally we should not reallocate busy extents. That is a much more
complex fix to the problem as it involves direct intervention in the
allocation btree searches in many places. This is left to a future
set of modifications.

Finally, now that we track busy extents in allocated memory, we
don't need the descriptors in the transaction structure to point to
them. We can replace the complex busy chunk infrastructure with a
simple linked list of busy extents. This allows us to remove a large
chunk of code, making the overall change a net reduction in code
size.

Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 fs/xfs/linux-2.6/xfs_buf.c      |    9 +
 fs/xfs/linux-2.6/xfs_quotaops.c |    1 +
 fs/xfs/linux-2.6/xfs_trace.h    |   83 ++++++---
 fs/xfs/xfs_ag.h                 |   24 ++-
 fs/xfs/xfs_alloc.c              |  364 ++++++++++++++++++++++++++++-----------
 fs/xfs/xfs_alloc.h              |    7 +-
 fs/xfs/xfs_alloc_btree.c        |    2 +-
 fs/xfs/xfs_log.h                |    3 -
 fs/xfs/xfs_trans.c              |   41 ++----
 fs/xfs/xfs_trans.h              |   35 +----
 fs/xfs/xfs_trans_item.c         |  109 ------------
 fs/xfs/xfs_trans_priv.h         |    4 -
 fs/xfs/xfs_types.h              |    2 +
 13 files changed, 361 insertions(+), 323 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_buf.c b/fs/xfs/linux-2.6/xfs_buf.c
index 6873afc..82678bf 100644
--- a/fs/xfs/linux-2.6/xfs_buf.c
+++ b/fs/xfs/linux-2.6/xfs_buf.c
@@ -37,6 +37,7 @@
 
 #include "xfs_sb.h"
 #include "xfs_inum.h"
+#include "xfs_log.h"
 #include "xfs_ag.h"
 #include "xfs_dmapi.h"
 #include "xfs_mount.h"
@@ -850,6 +851,12 @@ xfs_buf_lock_value(
  *	Note that this in no way locks the underlying pages, so it is only
  *	useful for synchronizing concurrent use of buffer objects, not for
  *	synchronizing independent access to the underlying pages.
+ *
+ *	If we come across a stale, pinned, locked buffer, we know that we
+ *	are being asked to lock a buffer that has been reallocated. Because
+ *	it is pinned, we know that the log has not been pushed to disk and
+ *	hence it will still be locked. Rather than sleeping until someone
+ *	else pushes the log, push it ourselves before trying to get the lock.
  */
 void
 xfs_buf_lock(
@@ -857,6 +864,8 @@ xfs_buf_lock(
 {
 	trace_xfs_buf_lock(bp, _RET_IP_);
 
+	if (atomic_read(&bp->b_pin_count) && (bp->b_flags & XBF_STALE))
+		xfs_log_force(bp->b_mount, 0);
 	if (atomic_read(&bp->b_io_remaining))
 		blk_run_address_space(bp->b_target->bt_mapping);
 	down(&bp->b_sema);
diff --git a/fs/xfs/linux-2.6/xfs_quotaops.c b/fs/xfs/linux-2.6/xfs_quotaops.c
index 1947514..2e73688 100644
--- a/fs/xfs/linux-2.6/xfs_quotaops.c
+++ b/fs/xfs/linux-2.6/xfs_quotaops.c
@@ -19,6 +19,7 @@
 #include "xfs_dmapi.h"
 #include "xfs_sb.h"
 #include "xfs_inum.h"
+#include "xfs_log.h"
 #include "xfs_ag.h"
 #include "xfs_mount.h"
 #include "xfs_quota.h"
diff --git a/fs/xfs/linux-2.6/xfs_trace.h b/fs/xfs/linux-2.6/xfs_trace.h
index 8a319cf..ff6bc79 100644
--- a/fs/xfs/linux-2.6/xfs_trace.h
+++ b/fs/xfs/linux-2.6/xfs_trace.h
@@ -1059,83 +1059,112 @@ TRACE_EVENT(xfs_bunmap,
 
 );
 
+#define XFS_BUSY_SYNC \
+	{ 0,	"async" }, \
+	{ 1,	"sync" }
+
 TRACE_EVENT(xfs_alloc_busy,
-	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno, xfs_agblock_t agbno,
-		 xfs_extlen_t len, int slot),
-	TP_ARGS(mp, agno, agbno, len, slot),
+	TP_PROTO(struct xfs_trans *trans, xfs_agnumber_t agno,
+		 xfs_agblock_t agbno, xfs_extlen_t len, int sync),
+	TP_ARGS(trans, agno, agbno, len, sync),
 	TP_STRUCT__entry(
 		__field(dev_t, dev)
+		__field(struct xfs_trans *, tp)
+		__field(int, tid)
 		__field(xfs_agnumber_t, agno)
 		__field(xfs_agblock_t, agbno)
 		__field(xfs_extlen_t, len)
-		__field(int, slot)
+		__field(int, sync)
 	),
 	TP_fast_assign(
-		__entry->dev = mp->m_super->s_dev;
+		__entry->dev = trans->t_mountp->m_super->s_dev;
+		__entry->tp = trans;
+		__entry->tid = trans->t_ticket->t_tid;
 		__entry->agno = agno;
 		__entry->agbno = agbno;
 		__entry->len = len;
-		__entry->slot = slot;
+		__entry->sync = sync;
 	),
-	TP_printk("dev %d:%d agno %u agbno %u len %u slot %d",
+	TP_printk("dev %d:%d trans 0x%p tid 0x%x agno %u agbno %u len %u %s",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->tp,
+		  __entry->tid,
 		  __entry->agno,
 		  __entry->agbno,
 		  __entry->len,
-		  __entry->slot)
+		  __print_symbolic(__entry->sync, XFS_BUSY_SYNC))
 
 );
 
-#define XFS_BUSY_STATES \
-	{ 0,	"found" }, \
-	{ 1,	"missing" }
-
 TRACE_EVENT(xfs_alloc_unbusy,
 	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno,
-		 int slot, int found),
-	TP_ARGS(mp, agno, slot, found),
+		 xfs_agblock_t agbno, xfs_extlen_t len),
+	TP_ARGS(mp, agno, agbno, len),
 	TP_STRUCT__entry(
 		__field(dev_t, dev)
 		__field(xfs_agnumber_t, agno)
-		__field(int, slot)
-		__field(int, found)
+		__field(xfs_agblock_t, agbno)
+		__field(xfs_extlen_t, len)
 	),
 	TP_fast_assign(
 		__entry->dev = mp->m_super->s_dev;
 		__entry->agno = agno;
-		__entry->slot = slot;
-		__entry->found = found;
+		__entry->agbno = agbno;
+		__entry->len = len;
 	),
-	TP_printk("dev %d:%d agno %u slot %d %s",
+	TP_printk("dev %d:%d agno %u agbno %u len %u",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->agno,
-		  __entry->slot,
-		  __print_symbolic(__entry->found, XFS_BUSY_STATES))
+		  __entry->agbno,
+		  __entry->len)
 );
 
+#define XFS_BUSY_STATES \
+	{ 0,	"missing" }, \
+	{ 1,	"found" }
+
 TRACE_EVENT(xfs_alloc_busysearch,
-	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno, xfs_agblock_t agbno,
-		 xfs_extlen_t len, xfs_lsn_t lsn),
-	TP_ARGS(mp, agno, agbno, len, lsn),
+	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno,
+		 xfs_agblock_t agbno, xfs_extlen_t len, int found),
+	TP_ARGS(mp, agno, agbno, len, found),
 	TP_STRUCT__entry(
 		__field(dev_t, dev)
 		__field(xfs_agnumber_t, agno)
 		__field(xfs_agblock_t, agbno)
 		__field(xfs_extlen_t, len)
-		__field(xfs_lsn_t, lsn)
+		__field(int, found)
 	),
 	TP_fast_assign(
 		__entry->dev = mp->m_super->s_dev;
 		__entry->agno = agno;
 		__entry->agbno = agbno;
 		__entry->len = len;
-		__entry->lsn = lsn;
+		__entry->found = found;
 	),
-	TP_printk("dev %d:%d agno %u agbno %u len %u force lsn 0x%llx",
+	TP_printk("dev %d:%d agno %u agbno %u len %u %s",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->agno,
 		  __entry->agbno,
 		  __entry->len,
+		  __print_symbolic(__entry->found, XFS_BUSY_STATES))
+);
+
+TRACE_EVENT(xfs_trans_commit_lsn,
+	TP_PROTO(struct xfs_trans *trans),
+	TP_ARGS(trans),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(struct xfs_trans *, tp)
+		__field(xfs_lsn_t, lsn)
+	),
+	TP_fast_assign(
+		__entry->dev = trans->t_mountp->m_super->s_dev;
+		__entry->tp = trans;
+		__entry->lsn = trans->t_commit_lsn;
+	),
+	TP_printk("dev %d:%d trans 0x%p commit_lsn 0x%llx",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->tp,
 		  __entry->lsn)
 );
 
diff --git a/fs/xfs/xfs_ag.h b/fs/xfs/xfs_ag.h
index abb8222..401f364 100644
--- a/fs/xfs/xfs_ag.h
+++ b/fs/xfs/xfs_ag.h
@@ -175,14 +175,20 @@ typedef struct xfs_agfl {
 } xfs_agfl_t;
 
 /*
- * Busy block/extent entry.  Used in perag to mark blocks that have been freed
- * but whose transactions aren't committed to disk yet.
+ * Busy block/extent entry.  Indexed by a rbtree in perag to mark blocks that
+ * have been freed but whose transactions aren't committed to disk yet.
+ *
+ * Note that we use the transaction ID to record the transaction, not the
+ * transaction structure itself. See xfs_alloc_busy_insert() for details.
  */
-typedef struct xfs_perag_busy {
-	xfs_agblock_t	busy_start;
-	xfs_extlen_t	busy_length;
-	struct xfs_trans *busy_tp;	/* transaction that did the free */
-} xfs_perag_busy_t;
+struct xfs_busy_extent {
+	struct rb_node	rb_node;	/* ag by-bno indexed search tree */
+	struct list_head list;		/* transaction busy extent list */
+	xfs_agnumber_t	agno;
+	xfs_agblock_t	bno;
+	xfs_extlen_t	length;
+	xlog_tid_t	tid;		/* transaction that created this */
+};
 
 /*
  * Per-ag incore structure, copies of information in agf and agi,
@@ -216,7 +222,8 @@ typedef struct xfs_perag {
 	xfs_agino_t	pagl_leftrec;
 	xfs_agino_t	pagl_rightrec;
 #ifdef __KERNEL__
-	spinlock_t	pagb_lock;	/* lock for pagb_list */
+	spinlock_t	pagb_lock;	/* lock for pagb_tree */
+	struct rb_root	pagb_tree;	/* ordered tree of busy extents */
 
 	atomic_t        pagf_fstrms;    /* # of filestreams active in this AG */
 
@@ -226,7 +233,6 @@ typedef struct xfs_perag {
 	int		pag_ici_reclaimable;	/* reclaimable inodes */
 #endif
 	int		pagb_count;	/* pagb slots in use */
-	xfs_perag_busy_t pagb_list[XFS_PAGB_NUM_SLOTS];	/* unstable blocks */
 } xfs_perag_t;
 
 /*
diff --git a/fs/xfs/xfs_alloc.c b/fs/xfs/xfs_alloc.c
index 94cddbf..f8d592b 100644
--- a/fs/xfs/xfs_alloc.c
+++ b/fs/xfs/xfs_alloc.c
@@ -46,11 +46,9 @@
 #define	XFSA_FIXUP_BNO_OK	1
 #define	XFSA_FIXUP_CNT_OK	2
 
-STATIC void
-xfs_alloc_search_busy(xfs_trans_t *tp,
-		    xfs_agnumber_t agno,
-		    xfs_agblock_t bno,
-		    xfs_extlen_t len);
+static int
+xfs_alloc_busy_search(struct xfs_mount *mp, xfs_agnumber_t agno,
+		    xfs_agblock_t bno, xfs_extlen_t len);
 
 /*
  * Prototypes for per-ag allocation routines
@@ -540,9 +538,16 @@ xfs_alloc_ag_vextent(
 				be32_to_cpu(agf->agf_length));
 			xfs_alloc_log_agf(args->tp, args->agbp,
 						XFS_AGF_FREEBLKS);
-			/* search the busylist for these blocks */
-			xfs_alloc_search_busy(args->tp, args->agno,
-					args->agbno, args->len);
+			/*
+			 * Search the busylist for these blocks and mark the
+			 * transaction as synchronous if blocks are found. This
+			 * avoids the need to block in due to a synchronous log
+			 * force to ensure correct ordering as the synchronous
+			 * transaction will guarantee that for us.
+			 */
+			if (xfs_alloc_busy_search(args->mp, args->agno,
+						args->agbno, args->len))
+				xfs_trans_set_sync(args->tp);
 		}
 		if (!args->isfl)
 			xfs_trans_mod_sb(args->tp,
@@ -1693,7 +1698,7 @@ xfs_free_ag_extent(
 	 * when the iclog commits to disk.  If a busy block is allocated,
 	 * the iclog is pushed up to the LSN that freed the block.
 	 */
-	xfs_alloc_mark_busy(tp, agno, bno, len);
+	xfs_alloc_busy_insert(tp, agno, bno, len);
 	return 0;
 
  error0:
@@ -1993,10 +1998,17 @@ xfs_alloc_get_freelist(
 	 * and remain there until the freeing transaction is committed to
 	 * disk.  Now that we have allocated blocks, this list must be
 	 * searched to see if a block is being reused.  If one is, then
-	 * the freeing transaction must be pushed to disk NOW by forcing
-	 * to disk all iclogs up that transaction's LSN.
-	 */
-	xfs_alloc_search_busy(tp, be32_to_cpu(agf->agf_seqno), bno, 1);
+	 * the freeing transaction must be pushed to disk before this
+	 * transaction.
+	 *
+	 * We do this by setting the current transaction
+	 * to a sync transaction which guarantees that the freeing transaction
+	 * is on disk before this transaction. This is done instead of a
+	 * synchronous log force here so that we don't sit and wait with
+	 * the AGF locked in the transaction during the log force.
+	 */
+	if (xfs_alloc_busy_search(mp, be32_to_cpu(agf->agf_seqno), bno, 1))
+		xfs_trans_set_sync(tp);
 	return 0;
 }
 
@@ -2201,7 +2213,7 @@ xfs_alloc_read_agf(
 			be32_to_cpu(agf->agf_levels[XFS_BTNUM_CNTi]);
 		spin_lock_init(&pag->pagb_lock);
 		pag->pagb_count = 0;
-		memset(pag->pagb_list, 0, sizeof(pag->pagb_list));
+		pag->pagb_tree = RB_ROOT;
 		pag->pagf_init = 1;
 	}
 #ifdef DEBUG
@@ -2479,127 +2491,273 @@ error0:
  * list is reused, the transaction that freed it must be forced to disk
  * before continuing to use the block.
  *
- * xfs_alloc_mark_busy - add to the per-ag busy list
- * xfs_alloc_clear_busy - remove an item from the per-ag busy list
+ * xfs_alloc_busy_insert - add to the per-ag busy list
+ * xfs_alloc_busy_clear - remove an item from the per-ag busy list
+ * xfs_alloc_busy_search - search for a busy extent
+ */
+
+/*
+ * Insert a new extent into the busy tree.
+ *
+ * This is straight forward, except that we can get overlaps with existing busy
+ * extents, and even duplicate busy extents. There are two main cases we have
+ * to handle here.
+ *
+ * The first case is a transaction that triggers a "free - allocate - free"
+ * cycle. This can occur during btree manipulations as a btree block is freed
+ * to the freelist, then allocated from the free list, then freed again. In
+ * this case, the second extnet free is what triggers the duplicate and as such
+ * the transaction IDs should match. Because the extent was allocated in this
+ * transaction, the transaction must be marked as synchronous. This is true for
+ * all cases where the free/alloc/free occurs in the one transaction, hence the
+ * addition of the ASSERT(tp->t_flags & XFS_TRANS_SYNC) to this case. This
+ * serves to catch violations of the second case quite effectively.
+ *
+ * The second case is where the free/alloc/free occur in different
+ * transactions. In this case, we can't mark the extent busy immediately
+ * because it is already tracked in a transaction that may be committing.  When
+ * the log commit completes, the busy extent will be removed from the tree. If
+ * we allow this busy insert to continue using that busy extent structure, it
+ * can be freed before this transaction is safely in the log.  Hence our only
+ * option in this case is to force the log to remove the existing busy extent
+ * from the list before we insert the new one with the current transaction ID.
+ *
+ * The problem we are trying to avoid in the free-alloc-free in separate
+ * transactions is most easily described with a timeline:
+ *
+ *      Thread 1	Thread 2	Thread 3	xfslogd
+ *	xact alloc
+ *	free X
+ *	mark busy
+ *	commit xact
+ *	free xact
+ *			xact alloc
+ *			alloc X
+ *			busy search
+ *			mark xact sync
+ *			commit xact
+ *			free xact
+ *			force log
+ *			checkpoint starts
+ *			....
+ *					xact alloc
+ *					free X
+ *					mark busy
+ *					finds match
+ *					*** KABOOM! ***
+ *					....
+ *							log IO completes
+ *							unbusy 1:91909
+ *			checkpoint completes
+ *
+ * By issuing a log force in thread 3 @ "KABOOM", the thread will block until
+ * the checkpoint completes, and the busy extent it matched will have been
+ * removed from the tree when it is woken. Hence it can then continue safely.
+ *
+ * However, to ensure this matching process is robust, we need to use the
+ * transaction ID for identifying transaction, as delayed logging results in
+ * the busy extent and transaction lifecycles being different. i.e. the busy
+ * extent is active for a lot longer than the transaction.  Hence the
+ * transaction structure can be freed and reallocated, then mark the same
+ * extent busy again in the new transaction. In this case the new transaction
+ * will have a different tid but can have the same address, and hence we need
+ * to check against the tid.
+ *
+ * Future: for delayed logging, we could avoid the log force is the extent was
+ * first freed in the current checkpoint sequence. This, however, requires the
+ * ability to pin the current checkpoint in memory until this transaction
+ * commits to ensure that both the original free and the current one combine
+ * logically into the one checkpoint. If the checkpoint sequences are
+ * different, however, we still need to wait on a log force.
  */
 void
-xfs_alloc_mark_busy(xfs_trans_t *tp,
-		    xfs_agnumber_t agno,
-		    xfs_agblock_t bno,
-		    xfs_extlen_t len)
+xfs_alloc_busy_insert(
+	struct xfs_trans	*tp,
+	xfs_agnumber_t		agno,
+	xfs_agblock_t		bno,
+	xfs_extlen_t		len)
 {
-	xfs_perag_busy_t	*bsy;
+	struct xfs_busy_extent	*new;
+	struct xfs_busy_extent	*busyp;
 	struct xfs_perag	*pag;
-	int			n;
+	struct rb_node		**rbp;
+	struct rb_node		*parent;
+	xfs_agblock_t		uend, bend;
+	int			match;
 
-	pag = xfs_perag_get(tp->t_mountp, agno);
-	spin_lock(&pag->pagb_lock);
 
-	/* search pagb_list for an open slot */
-	for (bsy = pag->pagb_list, n = 0;
-	     n < XFS_PAGB_NUM_SLOTS;
-	     bsy++, n++) {
-		if (bsy->busy_tp == NULL) {
-			break;
-		}
+	new = kmem_zalloc(sizeof(struct xfs_busy_extent), KM_MAYFAIL);
+	if (!new) {
+		/*
+		 * No Memory!  Since it is now not possible to track the free
+		 * block, make this a synchronous transaction to insure that
+		 * the block is not reused before this transaction commits.
+		 */
+		trace_xfs_alloc_busy(tp, agno, bno, len, 1);
+		xfs_trans_set_sync(tp);
+		return;
 	}
 
-	trace_xfs_alloc_busy(tp->t_mountp, agno, bno, len, n);
+	new->agno = agno;
+	new->bno = bno;
+	new->length = len;
+	new->tid = xfs_log_get_trans_ident(tp);
 
-	if (n < XFS_PAGB_NUM_SLOTS) {
-		bsy = &pag->pagb_list[n];
-		pag->pagb_count++;
-		bsy->busy_start = bno;
-		bsy->busy_length = len;
-		bsy->busy_tp = tp;
-		xfs_trans_add_busy(tp, agno, n);
-	} else {
+	INIT_LIST_HEAD(&new->list);
+
+	/* trace before insert to be able to see failed inserts */
+	trace_xfs_alloc_busy(tp, agno, bno, len, 0);
+
+	pag = xfs_perag_get(tp->t_mountp, new->agno);
+	uend = bno + len - 1;
+restart:
+	spin_lock(&pag->pagb_lock);
+	rbp = &pag->pagb_tree.rb_node;
+	parent = NULL;
+	busyp = NULL;
+	match = 0;
+	while (*rbp) {
+		parent = *rbp;
+		busyp = rb_entry(parent, struct xfs_busy_extent, rb_node);
+		bend = busyp->bno + busyp->length - 1;
+
+		if (new->bno < busyp->bno) {
+			/* may overlap, but exact start block is lower */
+			rbp = &(*rbp)->rb_left;
+			if (uend >= busyp->bno) {
+				if (busyp->tid != new->tid)
+					match = -1;
+				else if (match >= 0)
+					match = 1;
+			}
+		} else if (new->bno > busyp->bno) {
+			/* may overlap, but exact start block is higher */
+			rbp = &(*rbp)->rb_right;
+			if (bno <= bend) {
+				if (busyp->tid != new->tid)
+					match = -1;
+				else if (match >= 0)
+					match = 1;
+			}
+		} else {
+			if (busyp->tid != new->tid)
+				match = -1;
+			else if (match >= 0)
+				match = 1;
+			break;
+		}
+		busyp = NULL;
+	}
+	if (match < 0) {
+		/* overlap marked busy in different transaction */
+		spin_unlock(&pag->pagb_lock);
+		xfs_log_force(tp->t_mountp, XFS_LOG_SYNC);
+		goto restart;
+	}
+	if (match > 0) {
 		/*
-		 * The busy list is full!  Since it is now not possible to
-		 * track the free block, make this a synchronous transaction
-		 * to insure that the block is not reused before this
-		 * transaction commits.
+		 * overlap marked busy in same transaction. Update if exact
+		 * start block match, otherwise combine the busy extents into
+		 * a single range.
 		 */
-		xfs_trans_set_sync(tp);
+		if (busyp->bno == new->bno) {
+			busyp->length = max(busyp->length, new->length);
+			spin_unlock(&pag->pagb_lock);
+			ASSERT(tp->t_flags & XFS_TRANS_SYNC);
+			xfs_perag_put(pag);
+			kmem_free(new);
+			return;
+		}
+		rb_erase(&busyp->rb_node, &pag->pagb_tree);
+		new->length = max(busyp->bno + busyp->length,
+					new->bno + new->length) -
+				min(busyp->bno, new->bno);
+		new->bno = min(busyp->bno, new->bno);
 	}
 
+	rb_link_node(&new->rb_node, parent, rbp);
+	rb_insert_color(&new->rb_node, &pag->pagb_tree);
+
+	list_add(&new->list, &tp->t_busy);
 	spin_unlock(&pag->pagb_lock);
 	xfs_perag_put(pag);
+	kmem_free(busyp);
 }
 
-void
-xfs_alloc_clear_busy(xfs_trans_t *tp,
-		     xfs_agnumber_t agno,
-		     int idx)
+/*
+ * Search for a busy extent within the range of the extent we are about to
+ * allocate.  You need to be holding the busy extent tree lock when calling
+ * xfs_alloc_busy_search(). This function returns 0 for no overlapping busy
+ * extent, -1 for an overlapping but not exact busy extent, and 1 for an exact
+ * match. This is done so that a non-zero return indicates an overlap that
+ * will require a synchronous transaction, but it can still be
+ * used to distinguish between a partial or exact match.
+ */
+static int
+xfs_alloc_busy_search(
+	struct xfs_mount	*mp,
+	xfs_agnumber_t		agno,
+	xfs_agblock_t		bno,
+	xfs_extlen_t		len)
 {
 	struct xfs_perag	*pag;
-	xfs_perag_busy_t	*list;
+	struct rb_node		*rbp;
+	xfs_agblock_t		uend, bend;
+	struct xfs_busy_extent	*busyp;
+	int			match = 0;
 
-	ASSERT(idx < XFS_PAGB_NUM_SLOTS);
-	pag = xfs_perag_get(tp->t_mountp, agno);
+	pag = xfs_perag_get(mp, agno);
 	spin_lock(&pag->pagb_lock);
-	list = pag->pagb_list;
 
-	trace_xfs_alloc_unbusy(tp->t_mountp, agno, idx, list[idx].busy_tp == tp);
-
-	if (list[idx].busy_tp == tp) {
-		list[idx].busy_tp = NULL;
-		pag->pagb_count--;
+	uend = bno + len - 1;
+	rbp = pag->pagb_tree.rb_node;
+
+	/* find closest start bno overlap */
+	while (rbp) {
+		busyp = rb_entry(rbp, struct xfs_busy_extent, rb_node);
+		bend = busyp->bno + busyp->length - 1;
+		if (bno < busyp->bno) {
+			/* may overlap, but exact start block is lower */
+			if (uend >= busyp->bno)
+				match = -1;
+			rbp = rbp->rb_left;
+		} else if (bno > busyp->bno) {
+			/* may overlap, but exact start block is higher */
+			if (bno <= bend)
+				match = -1;
+			rbp = rbp->rb_right;
+		} else {
+			/* bno matches busyp, length determines exact match */
+			match = (busyp->length == len) ? 1 : -1;
+			break;
+		}
 	}
-
 	spin_unlock(&pag->pagb_lock);
+	trace_xfs_alloc_busysearch(mp, agno, bno, len, !!match);
 	xfs_perag_put(pag);
+	return match;
 }
 
-
-/*
- * If we find the extent in the busy list, force the log out to get the
- * extent out of the busy list so the caller can use it straight away.
- */
-STATIC void
-xfs_alloc_search_busy(xfs_trans_t *tp,
-		    xfs_agnumber_t agno,
-		    xfs_agblock_t bno,
-		    xfs_extlen_t len)
+void
+xfs_alloc_busy_clear(
+	struct xfs_mount	*mp,
+	struct xfs_busy_extent	*busyp)
 {
 	struct xfs_perag	*pag;
-	xfs_perag_busy_t	*bsy;
-	xfs_agblock_t		uend, bend;
-	xfs_lsn_t		lsn = 0;
-	int			cnt;
 
-	pag = xfs_perag_get(tp->t_mountp, agno);
-	spin_lock(&pag->pagb_lock);
-	cnt = pag->pagb_count;
+	trace_xfs_alloc_unbusy(mp, busyp->agno, busyp->bno,
+						busyp->length);
 
-	/*
-	 * search pagb_list for this slot, skipping open slots. We have to
-	 * search the entire array as there may be multiple overlaps and
-	 * we have to get the most recent LSN for the log force to push out
-	 * all the transactions that span the range.
-	 */
-	uend = bno + len - 1;
-	for (cnt = 0; cnt < pag->pagb_count; cnt++) {
-		bsy = &pag->pagb_list[cnt];
-		if (!bsy->busy_tp)
-			continue;
-
-		bend = bsy->busy_start + bsy->busy_length - 1;
-		if (bno > bend || uend < bsy->busy_start)
-			continue;
-
-		/* (start1,length1) within (start2, length2) */
-		if (XFS_LSN_CMP(bsy->busy_tp->t_commit_lsn, lsn) > 0)
-			lsn = bsy->busy_tp->t_commit_lsn;
-	}
+	ASSERT(xfs_alloc_busy_search(mp, busyp->agno, busyp->bno,
+						busyp->length) == 1);
+
+	list_del_init(&busyp->list);
+
+	pag = xfs_perag_get(mp, busyp->agno);
+	spin_lock(&pag->pagb_lock);
+	rb_erase(&busyp->rb_node, &pag->pagb_tree);
 	spin_unlock(&pag->pagb_lock);
 	xfs_perag_put(pag);
-	trace_xfs_alloc_busysearch(tp->t_mountp, agno, bno, len, lsn);
 
-	/*
-	 * If a block was found, force the log through the LSN of the
-	 * transaction that freed the block
-	 */
-	if (lsn)
-		xfs_log_force_lsn(tp->t_mountp, lsn, XFS_LOG_SYNC);
+	kmem_free(busyp);
 }
diff --git a/fs/xfs/xfs_alloc.h b/fs/xfs/xfs_alloc.h
index 599bffa..6d05199 100644
--- a/fs/xfs/xfs_alloc.h
+++ b/fs/xfs/xfs_alloc.h
@@ -22,6 +22,7 @@ struct xfs_buf;
 struct xfs_mount;
 struct xfs_perag;
 struct xfs_trans;
+struct xfs_busy_extent;
 
 /*
  * Freespace allocation types.  Argument to xfs_alloc_[v]extent.
@@ -119,15 +120,13 @@ xfs_alloc_longest_free_extent(struct xfs_mount *mp,
 #ifdef __KERNEL__
 
 void
-xfs_alloc_mark_busy(xfs_trans_t *tp,
+xfs_alloc_busy_insert(xfs_trans_t *tp,
 		xfs_agnumber_t agno,
 		xfs_agblock_t bno,
 		xfs_extlen_t len);
 
 void
-xfs_alloc_clear_busy(xfs_trans_t *tp,
-		xfs_agnumber_t ag,
-		int idx);
+xfs_alloc_busy_clear(struct xfs_mount *mp, struct xfs_busy_extent *busyp);
 
 #endif	/* __KERNEL__ */
 
diff --git a/fs/xfs/xfs_alloc_btree.c b/fs/xfs/xfs_alloc_btree.c
index b726e10..83f4942 100644
--- a/fs/xfs/xfs_alloc_btree.c
+++ b/fs/xfs/xfs_alloc_btree.c
@@ -134,7 +134,7 @@ xfs_allocbt_free_block(
 	 * disk. If a busy block is allocated, the iclog is pushed up to the
 	 * LSN that freed the block.
 	 */
-	xfs_alloc_mark_busy(cur->bc_tp, be32_to_cpu(agf->agf_seqno), bno, 1);
+	xfs_alloc_busy_insert(cur->bc_tp, be32_to_cpu(agf->agf_seqno), bno, 1);
 	xfs_trans_agbtree_delta(cur->bc_tp, -1);
 	return 0;
 }
diff --git a/fs/xfs/xfs_log.h b/fs/xfs/xfs_log.h
index 38af110..05f205a 100644
--- a/fs/xfs/xfs_log.h
+++ b/fs/xfs/xfs_log.h
@@ -18,9 +18,6 @@
 #ifndef	__XFS_LOG_H__
 #define __XFS_LOG_H__
 
-/* transaction ID type */
-typedef __uint32_t xlog_tid_t;
-
 /* get lsn fields */
 #define CYCLE_LSN(lsn) ((uint)((lsn)>>32))
 #define BLOCK_LSN(lsn) ((uint)(lsn))
diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index be578ec..40d9595 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -44,6 +44,7 @@
 #include "xfs_trans_priv.h"
 #include "xfs_trans_space.h"
 #include "xfs_inode_item.h"
+#include "xfs_trace.h"
 
 kmem_zone_t	*xfs_trans_zone;
 
@@ -243,9 +244,8 @@ _xfs_trans_alloc(
 	tp->t_type = type;
 	tp->t_mountp = mp;
 	tp->t_items_free = XFS_LIC_NUM_SLOTS;
-	tp->t_busy_free = XFS_LBC_NUM_SLOTS;
 	xfs_lic_init(&(tp->t_items));
-	XFS_LBC_INIT(&(tp->t_busy));
+	INIT_LIST_HEAD(&tp->t_busy);
 	return tp;
 }
 
@@ -255,8 +255,13 @@ _xfs_trans_alloc(
  */
 STATIC void
 xfs_trans_free(
-	xfs_trans_t	*tp)
+	struct xfs_trans	*tp)
 {
+	struct xfs_busy_extent	*busyp, *n;
+
+	list_for_each_entry_safe(busyp, n, &tp->t_busy, list)
+		xfs_alloc_busy_clear(tp->t_mountp, busyp);
+
 	atomic_dec(&tp->t_mountp->m_active_trans);
 	xfs_trans_free_dqinfo(tp);
 	kmem_zone_free(xfs_trans_zone, tp);
@@ -285,9 +290,8 @@ xfs_trans_dup(
 	ntp->t_type = tp->t_type;
 	ntp->t_mountp = tp->t_mountp;
 	ntp->t_items_free = XFS_LIC_NUM_SLOTS;
-	ntp->t_busy_free = XFS_LBC_NUM_SLOTS;
 	xfs_lic_init(&(ntp->t_items));
-	XFS_LBC_INIT(&(ntp->t_busy));
+	INIT_LIST_HEAD(&ntp->t_busy);
 
 	ASSERT(tp->t_flags & XFS_TRANS_PERM_LOG_RES);
 	ASSERT(tp->t_ticket != NULL);
@@ -423,7 +427,6 @@ undo_blocks:
 	return error;
 }
 
-
 /*
  * Record the indicated change to the given field for application
  * to the file system's superblock when the transaction commits.
@@ -930,26 +933,6 @@ xfs_trans_item_committed(
 	IOP_UNPIN(lip);
 }
 
-/* Clear all the per-AG busy list items listed in this transaction */
-static void
-xfs_trans_clear_busy_extents(
-	struct xfs_trans	*tp)
-{
-	xfs_log_busy_chunk_t	*lbcp;
-	xfs_log_busy_slot_t	*lbsp;
-	int			i;
-
-	for (lbcp = &tp->t_busy; lbcp != NULL; lbcp = lbcp->lbc_next) {
-		i = 0;
-		for (lbsp = lbcp->lbc_busy; i < lbcp->lbc_unused; i++, lbsp++) {
-			if (XFS_LBC_ISFREE(lbcp, i))
-				continue;
-			xfs_alloc_clear_busy(tp, lbsp->lbc_ag, lbsp->lbc_idx);
-		}
-	}
-	xfs_trans_free_busy(tp);
-}
-
 /*
  * This is typically called by the LM when a transaction has been fully
  * committed to disk.  It needs to unpin the items which have
@@ -984,7 +967,6 @@ xfs_trans_committed(
 		kmem_free(licp);
 	}
 
-	xfs_trans_clear_busy_extents(tp);
 	xfs_trans_free(tp);
 }
 
@@ -1013,7 +995,6 @@ xfs_trans_uncommit(
 	xfs_trans_unreserve_and_mod_dquots(tp);
 
 	xfs_trans_free_items(tp, flags);
-	xfs_trans_free_busy(tp);
 	xfs_trans_free(tp);
 }
 
@@ -1075,6 +1056,8 @@ xfs_trans_commit_iclog(
 	*commit_lsn = xfs_log_done(mp, tp->t_ticket, &commit_iclog, log_flags);
 
 	tp->t_commit_lsn = *commit_lsn;
+	trace_xfs_trans_commit_lsn(tp);
+
 	if (nvec > XFS_TRANS_LOGVEC_COUNT)
 		kmem_free(log_vector);
 
@@ -1260,7 +1243,6 @@ out_unreserve:
 	}
 	current_restore_flags_nested(&tp->t_pflags, PF_FSTRANS);
 	xfs_trans_free_items(tp, error ? XFS_TRANS_ABORT : 0);
-	xfs_trans_free_busy(tp);
 	xfs_trans_free(tp);
 
 	XFS_STATS_INC(xs_trans_empty);
@@ -1339,7 +1321,6 @@ xfs_trans_cancel(
 	current_restore_flags_nested(&tp->t_pflags, PF_FSTRANS);
 
 	xfs_trans_free_items(tp, flags);
-	xfs_trans_free_busy(tp);
 	xfs_trans_free(tp);
 }
 
diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
index c62beee..ff7e9e6 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -813,6 +813,7 @@ struct xfs_log_item_desc;
 struct xfs_mount;
 struct xfs_trans;
 struct xfs_dquot_acct;
+struct xfs_busy_extent;
 
 typedef struct xfs_log_item {
 	struct list_head		li_ail;		/* AIL pointers */
@@ -872,34 +873,6 @@ typedef struct xfs_item_ops {
 #define XFS_ITEM_PUSHBUF	3
 
 /*
- * This structure is used to maintain a list of block ranges that have been
- * freed in the transaction.  The ranges are listed in the perag[] busy list
- * between when they're freed and the transaction is committed to disk.
- */
-
-typedef struct xfs_log_busy_slot {
-	xfs_agnumber_t		lbc_ag;
-	ushort			lbc_idx;	/* index in perag.busy[] */
-} xfs_log_busy_slot_t;
-
-#define XFS_LBC_NUM_SLOTS	31
-typedef struct xfs_log_busy_chunk {
-	struct xfs_log_busy_chunk	*lbc_next;
-	uint				lbc_free;	/* free slots bitmask */
-	ushort				lbc_unused;	/* first unused */
-	xfs_log_busy_slot_t		lbc_busy[XFS_LBC_NUM_SLOTS];
-} xfs_log_busy_chunk_t;
-
-#define	XFS_LBC_MAX_SLOT	(XFS_LBC_NUM_SLOTS - 1)
-#define	XFS_LBC_FREEMASK	((1U << XFS_LBC_NUM_SLOTS) - 1)
-
-#define	XFS_LBC_INIT(cp)	((cp)->lbc_free = XFS_LBC_FREEMASK)
-#define	XFS_LBC_CLAIM(cp, slot)	((cp)->lbc_free &= ~(1 << (slot)))
-#define	XFS_LBC_SLOT(cp, slot)	(&((cp)->lbc_busy[(slot)]))
-#define	XFS_LBC_VACANCY(cp)	(((cp)->lbc_free) & XFS_LBC_FREEMASK)
-#define	XFS_LBC_ISFREE(cp, slot) ((cp)->lbc_free & (1 << (slot)))
-
-/*
  * This is the type of function which can be given to xfs_trans_callback()
  * to be called upon the transaction's commit to disk.
  */
@@ -950,8 +923,7 @@ typedef struct xfs_trans {
 	unsigned int		t_items_free;	/* log item descs free */
 	xfs_log_item_chunk_t	t_items;	/* first log item desc chunk */
 	xfs_trans_header_t	t_header;	/* header for in-log trans */
-	unsigned int		t_busy_free;	/* busy descs free */
-	xfs_log_busy_chunk_t	t_busy;		/* busy/async free blocks */
+	struct list_head	t_busy;		/* list of busy extents */
 	unsigned long		t_pflags;	/* saved process flags state */
 } xfs_trans_t;
 
@@ -1025,9 +997,6 @@ int		_xfs_trans_commit(xfs_trans_t *,
 void		xfs_trans_cancel(xfs_trans_t *, int);
 int		xfs_trans_ail_init(struct xfs_mount *);
 void		xfs_trans_ail_destroy(struct xfs_mount *);
-xfs_log_busy_slot_t *xfs_trans_add_busy(xfs_trans_t *tp,
-					xfs_agnumber_t ag,
-					xfs_extlen_t idx);
 
 extern kmem_zone_t	*xfs_trans_zone;
 
diff --git a/fs/xfs/xfs_trans_item.c b/fs/xfs/xfs_trans_item.c
index eb3fc57..2937a1e 100644
--- a/fs/xfs/xfs_trans_item.c
+++ b/fs/xfs/xfs_trans_item.c
@@ -438,112 +438,3 @@ xfs_trans_unlock_chunk(
 
 	return freed;
 }
-
-
-/*
- * This is called to add the given busy item to the transaction's
- * list of busy items.  It must find a free busy item descriptor
- * or allocate a new one and add the item to that descriptor.
- * The function returns a pointer to busy descriptor used to point
- * to the new busy entry.  The log busy entry will now point to its new
- * descriptor with its ???? field.
- */
-xfs_log_busy_slot_t *
-xfs_trans_add_busy(xfs_trans_t *tp, xfs_agnumber_t ag, xfs_extlen_t idx)
-{
-	xfs_log_busy_chunk_t	*lbcp;
-	xfs_log_busy_slot_t	*lbsp;
-	int			i=0;
-
-	/*
-	 * If there are no free descriptors, allocate a new chunk
-	 * of them and put it at the front of the chunk list.
-	 */
-	if (tp->t_busy_free == 0) {
-		lbcp = (xfs_log_busy_chunk_t*)
-		       kmem_alloc(sizeof(xfs_log_busy_chunk_t), KM_SLEEP);
-		ASSERT(lbcp != NULL);
-		/*
-		 * Initialize the chunk, and then
-		 * claim the first slot in the newly allocated chunk.
-		 */
-		XFS_LBC_INIT(lbcp);
-		XFS_LBC_CLAIM(lbcp, 0);
-		lbcp->lbc_unused = 1;
-		lbsp = XFS_LBC_SLOT(lbcp, 0);
-
-		/*
-		 * Link in the new chunk and update the free count.
-		 */
-		lbcp->lbc_next = tp->t_busy.lbc_next;
-		tp->t_busy.lbc_next = lbcp;
-		tp->t_busy_free = XFS_LIC_NUM_SLOTS - 1;
-
-		/*
-		 * Initialize the descriptor and the generic portion
-		 * of the log item.
-		 *
-		 * Point the new slot at this item and return it.
-		 * Also point the log item at its currently active
-		 * descriptor and set the item's mount pointer.
-		 */
-		lbsp->lbc_ag = ag;
-		lbsp->lbc_idx = idx;
-		return lbsp;
-	}
-
-	/*
-	 * Find the free descriptor. It is somewhere in the chunklist
-	 * of descriptors.
-	 */
-	lbcp = &tp->t_busy;
-	while (lbcp != NULL) {
-		if (XFS_LBC_VACANCY(lbcp)) {
-			if (lbcp->lbc_unused <= XFS_LBC_MAX_SLOT) {
-				i = lbcp->lbc_unused;
-				break;
-			} else {
-				/* out-of-order vacancy */
-				cmn_err(CE_DEBUG, "OOO vacancy lbcp 0x%p\n", lbcp);
-				ASSERT(0);
-			}
-		}
-		lbcp = lbcp->lbc_next;
-	}
-	ASSERT(lbcp != NULL);
-	/*
-	 * If we find a free descriptor, claim it,
-	 * initialize it, and return it.
-	 */
-	XFS_LBC_CLAIM(lbcp, i);
-	if (lbcp->lbc_unused <= i) {
-		lbcp->lbc_unused = i + 1;
-	}
-	lbsp = XFS_LBC_SLOT(lbcp, i);
-	tp->t_busy_free--;
-	lbsp->lbc_ag = ag;
-	lbsp->lbc_idx = idx;
-	return lbsp;
-}
-
-
-/*
- * xfs_trans_free_busy
- * Free all of the busy lists from a transaction
- */
-void
-xfs_trans_free_busy(xfs_trans_t *tp)
-{
-	xfs_log_busy_chunk_t	*lbcp;
-	xfs_log_busy_chunk_t	*lbcq;
-
-	lbcp = tp->t_busy.lbc_next;
-	while (lbcp != NULL) {
-		lbcq = lbcp->lbc_next;
-		kmem_free(lbcp);
-		lbcp = lbcq;
-	}
-
-	XFS_LBC_INIT(&tp->t_busy);
-	tp->t_busy.lbc_unused = 0;
-}
diff --git a/fs/xfs/xfs_trans_priv.h b/fs/xfs/xfs_trans_priv.h
index 73e2ad3..901dc0f 100644
--- a/fs/xfs/xfs_trans_priv.h
+++ b/fs/xfs/xfs_trans_priv.h
@@ -38,10 +38,6 @@ struct xfs_log_item_desc	*xfs_trans_next_item(struct xfs_trans *,
 void				xfs_trans_free_items(struct xfs_trans *, int);
 void				xfs_trans_unlock_items(struct xfs_trans *,
 							xfs_lsn_t);
-void				xfs_trans_free_busy(xfs_trans_t *tp);
-xfs_log_busy_slot_t		*xfs_trans_add_busy(xfs_trans_t *tp,
-						    xfs_agnumber_t ag,
-						    xfs_extlen_t idx);
 
 /*
  * AIL traversal cursor.
diff --git a/fs/xfs/xfs_types.h b/fs/xfs/xfs_types.h
index b099045..3207752 100644
--- a/fs/xfs/xfs_types.h
+++ b/fs/xfs/xfs_types.h
@@ -75,6 +75,8 @@ typedef	__uint32_t	xfs_dahash_t;	/* dir/attr hash value */
 
 typedef __uint16_t	xfs_prid_t;	/* prid_t truncated to 16bits in XFS */
 
+typedef __uint32_t	xlog_tid_t;	/* transaction ID type */
+
 /*
  * These types are 64 bits on disk but are either 32 or 64 bits in memory.
  * Disk based types:
-- 
1.5.6.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
