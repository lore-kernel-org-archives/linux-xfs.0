Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o08NExgp082508 for <xfs@oss.sgi.com>; Fri, 8 Jan 2010 17:14:59 -0600
Content-class: urn:content-classes:message
MIME-Version: 1.0
Subject: [PATCH v2] xfs: Don't flush stale inodes
Date: Fri, 8 Jan 2010 17:14:25 -0600
Message-ID: <1AB9A794DBDDF54A8A81BE2296F7BDFE012A693A@cf--amer001e--3.americas.sgi.com>
In-Reply-To: <1262399980-19277-1-git-send-email-david@fromorbit.com>
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

Dave Chinner wrote:
> Because inodes remain in cache much longer than inode buffers do
> under memory pressure, we can get the situation where we have stale,
> dirty inodes being reclaimed but the backing storage has been freed.
> Hence we should never, ever flush XFS_ISTALE inodes to disk as
> there is no guarantee that the backing buffer is in cache and
> still marked stale when the flush occurs.
>
> Signed-off-by: Dave Chinner <david@fromorbit.com>

Dave, I'm putting this patch in before your perag radix tree
patch series, so I had to port it.  I am submitting here on
your behalf, but would like you to review it if possible.
It builds fine, and I've run it through a quick test.
I will retain all of your original commentary, etc.  I did
*not* implement Christoph's recommendation that you change
the "for" loop in xfs_alloc_search_busy() to a more typical
form.

For reference, the original patch is here:
    http://patchwork.xfs.org/patch/382/

Signed-off-by: Alex Elder <aelder@sgi.com>


---
 fs/xfs/linux-2.6/xfs_trace.h |    9 +++++---
 fs/xfs/xfs_alloc.c           |   44 ++++++++++++++++++++-----------------------
 2 files changed, 27 insertions(+), 26 deletions(-)

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
@@ -2563,7 +2563,7 @@ xfs_alloc_search_busy(xfs_trans_t *tp,
 	xfs_mount_t		*mp;
 	xfs_perag_busy_t	*bsy;
 	xfs_agblock_t		uend, bend;
-	xfs_lsn_t		lsn;
+	xfs_lsn_t		lsn = 0;
 	int			cnt;
 
 	mp = tp->t_mountp;
@@ -2573,33 +2573,31 @@ xfs_alloc_search_busy(xfs_trans_t *tp,
 
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
+	for (bsy = mp->m_perag[agno].pagb_list; cnt; bsy++, cnt--) {
+		if (!bsy->busy_tp)
+			continue;
+
+		bend = bsy->busy_start + bsy->busy_length - 1;
+		if ((bno > bend) || (uend < bsy->busy_start))
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
