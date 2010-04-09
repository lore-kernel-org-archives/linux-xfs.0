Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o39MTlGI146505 for <xfs@oss.sgi.com>; Fri, 9 Apr 2010 17:29:47 -0500
Received: from cf--amer001e--3.americas.sgi.com
	(cf--amer001e--3.americas.sgi.com [137.38.100.5])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 3EEBA8F80C5
	for <xfs@oss.sgi.com>; Fri,  9 Apr 2010 15:31:40 -0700 (PDT)
Subject: [PATCHv2 8/10] xfs: avoid repeated pointer dereferences
From: Alex Elder <aelder@sgi.com>
Date: Fri, 09 Apr 2010 17:30:42 -0500
Message-ID: <1270852242.7840.158.camel@doink>
Mime-Version: 1.0
Reply-To: aelder@sgi.com
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
To: xfs@oss.sgi.com

In xlog_find_cycle_start() use a local variable for some repeated
operations rather than constantly updating the memory location
whose address is passed in.

Signed-off-by: Alex Elder <aelder@sgi.com>

---
fs/xfs/xfs_log_recover.c |   83 ++++++++++++++++++++++++-----------------------
 fs/xfs/xfs_log_recover.c |   26 ++++++++++++++------------
 1 file changed, 14 insertions(+), 12 deletions(-)

Index: b/fs/xfs/xfs_log_recover.c
===================================================================
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -354,26 +354,28 @@ xlog_find_cycle_start(
 {
 	xfs_caddr_t	offset;
 	xfs_daddr_t	mid_blk;
+	xfs_daddr_t	end_blk;
 	uint		mid_cycle;
 	int		error;
 
-	mid_blk = BLK_AVG(first_blk, *last_blk);
-	while (mid_blk != first_blk && mid_blk != *last_blk) {
+	ASSERT(last_blk != NULL);
+	end_blk = *last_blk;
+	mid_blk = BLK_AVG(first_blk, end_blk);
+	while (mid_blk != first_blk && mid_blk != end_blk) {
 		error = xlog_bread(log, mid_blk, 1, bp, &offset);
 		if (error)
 			return error;
 		mid_cycle = xlog_get_cycle(offset);
-		if (mid_cycle == cycle) {
-			*last_blk = mid_blk;
-			/* last_half_cycle == mid_cycle */
-		} else {
-			first_blk = mid_blk;
-			/* first_half_cycle == mid_cycle */
-		}
-		mid_blk = BLK_AVG(first_blk, *last_blk);
+		if (mid_cycle == cycle)
+			end_blk = mid_blk;   /* last_half_cycle == mid_cycle */
+		else
+			first_blk = mid_blk; /* first_half_cycle == mid_cycle */
+		mid_blk = BLK_AVG(first_blk, end_blk);
 	}
-	ASSERT((mid_blk == first_blk && mid_blk+1 == *last_blk) ||
-	       (mid_blk == *last_blk && mid_blk-1 == first_blk));
+	ASSERT((mid_blk == first_blk && mid_blk+1 == end_blk) ||
+	       (mid_blk == end_blk && mid_blk-1 == first_blk));
+
+	*last_blk = end_blk;
 
 	return 0;
 }


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
