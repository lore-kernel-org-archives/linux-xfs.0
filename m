Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q77624rI008264 for <xfs@oss.sgi.com>; Tue, 7 Aug 2012 01:02:04 -0500
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	fBEktUAAiGgiFT4k (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Mon, 06 Aug 2012 23:02:03 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1Sycri-00013i-Ma
	for xfs@oss.sgi.com; Tue, 07 Aug 2012 06:02:02 +0000
Date: Tue, 7 Aug 2012 02:02:02 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH] xfs: unlock the AGI buffer when looping in xfs_dialloc
Message-ID: <20120807060202.GA4005@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
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

Also update some commens in the area to make the code easier to read.

Signed-off-by: Christoph Hellwig <hch@lst.de>

---
 fs/xfs/xfs_ialloc.c |   17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

Index: xfs/fs/xfs/xfs_ialloc.c
===================================================================
--- xfs.orig/fs/xfs/xfs_ialloc.c	2012-08-07 07:33:49.750001911 +0200
+++ xfs/fs/xfs/xfs_ialloc.c	2012-08-07 07:34:14.393335258 +0200
@@ -962,23 +962,22 @@ xfs_dialloc(
 		if (!pag->pagi_freecount && !okalloc)
 			goto nextag;
 
+		/*
+		 * Then read in the AGI buffer and recheck with the AGI buffer
+		 * lock held.
+		 */
 		error = xfs_ialloc_read_agi(mp, tp, agno, &agbp);
 		if (error)
 			goto out_error;
 
-		/*
-		 * Once the AGI has been read in we have to recheck
-		 * pagi_freecount with the AGI buffer lock held.
-		 */
 		if (pag->pagi_freecount) {
 			xfs_perag_put(pag);
 			goto out_alloc;
 		}
 
-		if (!okalloc) {
-			xfs_trans_brelse(tp, agbp);
-			goto nextag;
-		}
+		if (!okalloc)
+			goto nextag_relse_buffer;
+
 
 		error = xfs_ialloc_ag_alloc(tp, agbp, &ialloced);
 		if (error) {
@@ -1007,6 +1006,8 @@ xfs_dialloc(
 			return 0;
 		}
 
+nextag_relse_buffer:
+		xfs_trans_brelse(tp, agbp);
 nextag:
 		xfs_perag_put(pag);
 		if (++agno == mp->m_sb.sb_agcount)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
