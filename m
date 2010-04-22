Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o3MJPcgg227450 for <xfs@oss.sgi.com>; Thu, 22 Apr 2010 14:25:39 -0500
Received: from coco.kroah.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 825141057B6B
	for <xfs@oss.sgi.com>; Thu, 22 Apr 2010 12:27:39 -0700 (PDT)
Received: from coco.kroah.org (kroah.org [198.145.64.141]) by cuda.sgi.com
	with ESMTP id cHLKjVBy4gkjB74H for <xfs@oss.sgi.com>;
	Thu, 22 Apr 2010 12:27:39 -0700 (PDT)
Message-Id: <20100422190908.936014751@kvm.kroah.org>
Date: Thu, 22 Apr 2010 12:07:48 -0700
From: Greg KH <gregkh@suse.de>
Subject: [017/197] xfs: Ensure we force all busy extents in range to disk
In-Reply-To: <20100422191857.GA13268@kroah.com>
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
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: xfs@oss.sgi.com, Alex Elder <aelder@sgi.com>, akpm@linux-foundation.org, torvalds@linux-foundation.org, stable-review@kernel.org, alan@lxorguk.ukuu.org.uk

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Dave Chinner <david@fromorbit.com>

commit fd45e4784164d1017521086524e3442318c67370 upstream

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
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/xfs/xfs_alloc.c |   52 +++++++++++++++++++++-------------------------------
 1 file changed, 21 insertions(+), 31 deletions(-)

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


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
