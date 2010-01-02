Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o022fghb051706 for <xfs@oss.sgi.com>; Fri, 1 Jan 2010 20:41:42 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5C5B0136B25
	for <xfs@oss.sgi.com>; Fri,  1 Jan 2010 18:42:29 -0800 (PST)
Received: from mail.internode.on.net (bld-mail18.adl2.internode.on.net
	[150.101.137.103]) by cuda.sgi.com with ESMTP id
	7giutCLkXQb8oGjK for <xfs@oss.sgi.com>;
	Fri, 01 Jan 2010 18:42:29 -0800 (PST)
Received: from discord (unverified [121.44.238.220])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	10928435-1927428
	for <xfs@oss.sgi.com>; Sat, 02 Jan 2010 13:12:28 +1030 (CDT)
Received: from [192.168.1.6] (helo=disturbed) by discord with esmtp (Exim 4.69)
	(envelope-from <dave@fromorbit.com>) id 1NQtwg-0007wk-V9
	for xfs@oss.sgi.com; Sat, 02 Jan 2010 13:42:26 +1100
Received: from dave by disturbed with local (Exim 4.71)
	(envelope-from <dave@disturbed.disaster>) id 1NQttI-000508-5M
	for xfs@oss.sgi.com; Sat, 02 Jan 2010 13:38:56 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH] XFS: Ensure we force all busy extents in range to disk
Date: Sat,  2 Jan 2010 13:38:56 +1100
Message-Id: <1262399936-19195-1-git-send-email-david@fromorbit.com>
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

When we search for and find a busy extent during allocation we force
the log out to ensure the extent free transaction is on disk before
the allocation transaction. The curret implementation has a subtle
bug in it - it does not handle multiple overlapping ranges.

That is, if we free lots of little extents into a single contiguous
extent, then allocate the contiguous extent, the busy search code
stops searching at the first extent it finds that overlaps the
allocated range. It then uses the commit LSN of the transaction to
force the log out to.

Unfortunately, the other busy ranges might have more recent commit
LSNs than the first busy extent that is found, and this results in
xfs_alloc_search_busy() returning before all the extent free
transactions are on disk for the range being allocated. This can
lead to potential metadata corruption or stale data exposure after
a crash because log replay won't replay all the extent free
transactions that cover the allocation range.

Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 fs/xfs/linux-2.6/xfs_trace.h |    9 +++++--
 fs/xfs/xfs_alloc.c           |   44 ++++++++++++++++++++---------------------
 2 files changed, 27 insertions(+), 26 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_trace.h b/fs/xfs/linux-2.6/xfs_trace.h
index 5ec1475..2b0819a 100644
--- a/fs/xfs/linux-2.6/xfs_trace.h
+++ b/fs/xfs/linux-2.6/xfs_trace.h
@@ -1064,14 +1064,15 @@ TRACE_EVENT(xfs_alloc_unbusy,
 
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
@@ -1079,12 +1080,14 @@ TRACE_EVENT(xfs_alloc_busysearch,
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
 
diff --git a/fs/xfs/xfs_alloc.c b/fs/xfs/xfs_alloc.c
index d58ca99..407a671 100644
--- a/fs/xfs/xfs_alloc.c
+++ b/fs/xfs/xfs_alloc.c
@@ -2565,7 +2565,7 @@ xfs_alloc_search_busy(xfs_trans_t *tp,
 	struct xfs_perag	*pag;
 	xfs_perag_busy_t	*bsy;
 	xfs_agblock_t		uend, bend;
-	xfs_lsn_t		lsn;
+	xfs_lsn_t		lsn = 0;
 	int			cnt;
 
 	pag = xfs_perag_get(tp->t_mountp, agno);
@@ -2574,34 +2574,32 @@ xfs_alloc_search_busy(xfs_trans_t *tp,
 
 	uend = bno + len - 1;
 
-	/* search pagb_list for this slot, skipping open slots */
-	for (bsy = pag->pagb_list; cnt; bsy++) {
+	/*
+	 * search pagb_list for this slot, skipping open slots. We have to
+	 * search the entire array as there may be multiple overlaps and
+	 * we have to get the most recent LSN for the log force to push out
+	 * all the transactions that span the range.
+	 */
+	for (bsy = pag->pagb_list; cnt; bsy++, cnt--) {
+		if (!bsy->busy_tp)
+			continue;
 
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
-	}
+		bend = bsy->busy_start + bsy->busy_length - 1;
+		if ((bno > bend) || (uend < bsy->busy_start))
+			continue;
 
-	trace_xfs_alloc_busysearch(tp->t_mountp, agno, bno, len, !!cnt);
+		/* (start1,length1) within (start2, length2) */
+		if (XFS_LSN_CMP(bsy->busy_tp->t_commit_lsn, lsn) > 0)
+			lsn = bsy->busy_tp->t_commit_lsn;
+	}
+	spin_unlock(&pag->pagb_lock);
+	xfs_perag_put(pag);
+	trace_xfs_alloc_busysearch(tp->t_mountp, agno, bno, len, !!cnt, lsn);
 
 	/*
 	 * If a block was found, force the log through the LSN of the
 	 * transaction that freed the block
 	 */
-	if (cnt) {
-		lsn = bsy->busy_tp->t_commit_lsn;
-		spin_unlock(&pag->pagb_lock);
+	if (lsn)
 		xfs_log_force(tp->t_mountp, lsn, XFS_LOG_FORCE|XFS_LOG_SYNC);
-	} else {
-		spin_unlock(&pag->pagb_lock);
-	}
-	xfs_perag_put(pag);
 }
-- 
1.6.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
