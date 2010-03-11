Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o2BMf5Cq194424 for <xfs@oss.sgi.com>; Thu, 11 Mar 2010 16:41:06 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 99705141F781
	for <xfs@oss.sgi.com>; Thu, 11 Mar 2010 14:42:37 -0800 (PST)
Received: from mail.internode.on.net (bld-mail13.adl6.internode.on.net
	[150.101.137.98]) by cuda.sgi.com with ESMTP id
	FDPBHvJgOvrWPkla for <xfs@oss.sgi.com>;
	Thu, 11 Mar 2010 14:42:37 -0800 (PST)
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 09/19] xfs: Ensure we force all busy extents in range to disk
Date: Fri, 12 Mar 2010 09:42:07 +1100
Message-Id: <1268347337-7160-10-git-send-email-david@fromorbit.com>
In-Reply-To: <1268347337-7160-1-git-send-email-david@fromorbit.com>
References: <1268347337-7160-1-git-send-email-david@fromorbit.com>
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
To: stable@kernel.org
Cc: xfs@oss.sgi.com

>From fd45e4784164d1017521086524e3442318c67370
Date: Sat, 2 Jan 2010 02:38:56 +0000
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

Modified-by: Alex Elder <aelder@sgi.com>

(Dropped the "found" argument from the xfs_alloc_busysearch trace
event.)

Signed-off-by: Dave Chinner <david@fromorbit.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Alex Elder <aelder@sgi.com>
---
 fs/xfs/xfs_alloc.c |   52 +++++++++++++++++++++-------------------------------
 1 files changed, 21 insertions(+), 31 deletions(-)

diff --git a/fs/xfs/xfs_alloc.c b/fs/xfs/xfs_alloc.c
index 2cf944e..4cd1c23 100644
--- a/fs/xfs/xfs_alloc.c
+++ b/fs/xfs/xfs_alloc.c
@@ -2703,45 +2703,35 @@ xfs_alloc_search_busy(xfs_trans_t *tp,
 	xfs_mount_t		*mp;
 	xfs_perag_busy_t	*bsy;
 	xfs_agblock_t		uend, bend;
-	xfs_lsn_t		lsn;
+	xfs_lsn_t		lsn = 0;
 	int			cnt;
 
 	mp = tp->t_mountp;
 
 	spin_lock(&mp->m_perag[agno].pagb_lock);
-	cnt = mp->m_perag[agno].pagb_count;
-
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
-				TRACE_BUSYSEARCH("xfs_alloc_search_busy",
-					 "found1", agno, bno, len, tp);
-				break;
-			}
-		}
-	}
-
 	/*
-	 * If a block was found, force the log through the LSN of the
-	 * transaction that freed the block
+	 * search pagb_list for this slot, skipping open slots. We have to
+	 * search the entire array as there may be multiple overlaps and
+	 * we have to get the most recent LSN for the log force to push out
+	 * all the transactions that span the range.
 	 */
-	if (cnt) {
-		TRACE_BUSYSEARCH("xfs_alloc_search_busy", "found", agno, bno, len, tp);
-		lsn = bsy->busy_tp->t_commit_lsn;
-		spin_unlock(&mp->m_perag[agno].pagb_lock);
-		xfs_log_force(mp, lsn, XFS_LOG_FORCE|XFS_LOG_SYNC);
-	} else {
-		TRACE_BUSYSEARCH("xfs_alloc_search_busy", "not-found", agno, bno, len, tp);
-		spin_unlock(&mp->m_perag[agno].pagb_lock);
+	for (cnt = 0; cnt < mp->m_perag[agno].pagb_count; cnt++) {
+		bsy = &mp->m_perag[agno].pagb_list[cnt];
+		if (!bsy->busy_tp)
+			continue;
+		bend = bsy->busy_start + bsy->busy_length - 1;
+		if (bno > bend || uend < bsy->busy_start)
+			continue;
+
+		/* (start1,length1) within (start2, length2) */
+		if (XFS_LSN_CMP(bsy->busy_tp->t_commit_lsn, lsn) > 0)
+			lsn = bsy->busy_tp->t_commit_lsn;
 	}
+	spin_unlock(&mp->m_perag[agno].pagb_lock);
+	TRACE_BUSYSEARCH("xfs_alloc_search_busy", lsn ? "found" : "not-found",
+						agno, bno, len, tp);
+	if (lsn)
+		xfs_log_force(mp, lsn, XFS_LOG_FORCE|XFS_LOG_SYNC);
 }
-- 
1.6.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
