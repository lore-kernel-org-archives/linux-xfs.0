Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o09IJogJ182713 for <xfs@oss.sgi.com>; Sat, 9 Jan 2010 12:19:50 -0600
Content-class: urn:content-classes:message
MIME-Version: 1.0
Subject: [PATCH,
	updated]  xfs: Ensure we force all busy extents in range to disk
Date: Sat, 9 Jan 2010 12:10:02 -0600
Message-ID: <1AB9A794DBDDF54A8A81BE2296F7BDFE012A693C@cf--amer001e--3.americas.sgi.com>
In-Reply-To: <20100109000927.GE8654@discord.disaster>
From: "Alex Elder" <aelder@sgi.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

Port of this patch to the current XFS master top-of-tree,
which does not yet have the perag radix-tree changes.

    http://patchwork.xfs.org/patch/387/

					-Alex

When we search for and find a busy extent during allocation we
force the log out to ensure the extent free transaction is on
disk before the allocation transaction. The current implementation
has a subtle bug in it--it does not handle multiple overlapping
ranges.

That is, if we free lots of little extents into a single
contiguous extent, then allocate the contiguous extent, the busy
search code stops searching at the first extent it finds that
overlaps the allocated range. It then uses the commit LSN of the
transaction to force the log out to.

Unfortunately, the other busy ranges might have more recent
commit LSNs than the first busy extent that is found, and this
results in xfs_alloc_search_busy() returning before all the
extent free transactions are on disk for the range being
allocated. This can lead to potential metadata corruption or
stale data exposure after a crash because log replay won't replay
all the extent free transactions that cover the allocation range.

Signed-off-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Alex Elder <aelder@sgi.com>

---
 fs/xfs/linux-2.6/xfs_trace.h |    9 +++++---
 fs/xfs/xfs_alloc.c           |   46 ++++++++++++++++++++-----------------------
 2 files changed, 28 insertions(+), 27 deletions(-)

Index: b/fs/xfs/linux-2.6/xfs_trace.h
===================================================================
--- a/fs/xfs/linux-2.6/xfs_trace.h
+++ b/fs/xfs/linux-2.6/xfs_trace.h
@@ -1079,14 +1079,15 @@ TRACE_EVENT(xfs_alloc_unbusy,
 
 TRACE_EVENT(xfs_alloc_busysearch,
 	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno, xfs_agblock_t agbno,
-		 xfs_extlen_t len, int found),
-	TP_ARGS(mp, agno, agbno, len, found),
+		 xfs_extlen_t len, int found, xfs_lsn_t lsn),
+	TP_ARGS(mp, agno, agbno, len, found, lsn),
 	TP_STRUCT__entry(
 		__field(dev_t, dev)
 		__field(xfs_agnumber_t, agno)
 		__field(xfs_agblock_t, agbno)
 		__field(xfs_extlen_t, len)
 		__field(int, found)
+		__field(xfs_lsn_t, lsn)
 	),
 	TP_fast_assign(
 		__entry->dev = mp->m_super->s_dev;
@@ -1094,12 +1095,14 @@ TRACE_EVENT(xfs_alloc_busysearch,
 		__entry->agbno = agbno;
 		__entry->len = len;
 		__entry->found = found;
+		__entry->lsn = lsn;
 	),
-	TP_printk("dev %d:%d agno %u agbno %u len %u %s",
+	TP_printk("dev %d:%d agno %u agbno %u len %u force lsn 0x%llx %s",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->agno,
 		  __entry->agbno,
 		  __entry->len,
+		  __entry->lsn,
 		  __print_symbolic(__entry->found, XFS_BUSY_STATES))
 );
 
Index: b/fs/xfs/xfs_alloc.c
===================================================================
--- a/fs/xfs/xfs_alloc.c
+++ b/fs/xfs/xfs_alloc.c
@@ -2563,43 +2563,41 @@ xfs_alloc_search_busy(xfs_trans_t *tp,
 	xfs_mount_t		*mp;
 	xfs_perag_busy_t	*bsy;
 	xfs_agblock_t		uend, bend;
-	xfs_lsn_t		lsn;
+	xfs_lsn_t		lsn = 0;
 	int			cnt;
 
 	mp = tp->t_mountp;
 
 	spin_lock(&mp->m_perag[agno].pagb_lock);
-	cnt = mp->m_perag[agno].pagb_count;
 
 	uend = bno + len - 1;
 
-	/* search pagb_list for this slot, skipping open slots */
-	for (bsy = mp->m_perag[agno].pagb_list; cnt; bsy++) {
-
-		/*
-		 * (start1,length1) within (start2, length2)
-		 */
-		if (bsy->busy_tp != NULL) {
-			bend = bsy->busy_start + bsy->busy_length - 1;
-			if ((bno > bend) || (uend < bsy->busy_start)) {
-				cnt--;
-			} else {
-				break;
-			}
-		}
+	/*
+	 * search pagb_list for this slot, skipping open slots. We have to
+	 * search the entire array as there may be multiple overlaps and
+	 * we have to get the most recent LSN for the log force to push out
+	 * all the transactions that span the range.
+	 */
+	for (cnt = 0; cnt < mp->m_perag[agno].pagb_count; cnt++) {
+		bsy = &mp->m_perag[agno].pagb_list[cnt];
+		if (!bsy->busy_tp)
+			continue;
+
+		bend = bsy->busy_start + bsy->busy_length - 1;
+		if (bno > bend || uend < bsy->busy_start)
+			continue;
+
+		/* (start1,length1) within (start2, length2) */
+		if (XFS_LSN_CMP(bsy->busy_tp->t_commit_lsn, lsn) > 0)
+			lsn = bsy->busy_tp->t_commit_lsn;
 	}
-
-	trace_xfs_alloc_busysearch(mp, agno, bno, len, !!cnt);
+	spin_unlock(&mp->m_perag[agno].pagb_lock);
+	trace_xfs_alloc_busysearch(tp->t_mountp, agno, bno, len, !!cnt, lsn);
 
 	/*
 	 * If a block was found, force the log through the LSN of the
 	 * transaction that freed the block
 	 */
-	if (cnt) {
-		lsn = bsy->busy_tp->t_commit_lsn;
-		spin_unlock(&mp->m_perag[agno].pagb_lock);
+	if (lsn)
 		xfs_log_force(mp, lsn, XFS_LOG_FORCE|XFS_LOG_SYNC);
-	} else {
-		spin_unlock(&mp->m_perag[agno].pagb_lock);
-	}
 }

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
