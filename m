Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 04E817CA1
	for <xfs@oss.sgi.com>; Wed,  3 Aug 2016 12:33:15 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 6A6E1AC003
	for <xfs@oss.sgi.com>; Wed,  3 Aug 2016 10:33:14 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id fAvPcfTrmnLBVjyh (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 03 Aug 2016 10:33:10 -0700 (PDT)
Received: from [83.175.99.196] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.85_2 #1 (Red Hat Linux))
	id 1bV02X-00063c-Eh
	for xfs@oss.sgi.com; Wed, 03 Aug 2016 17:33:09 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] xfs: fix bogus space reservation in xfs_iomap_write_allocate
Date: Wed,  3 Aug 2016 19:33:06 +0200
Message-Id: <1470245586-14068-1-git-send-email-hch@lst.de>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

The space reservations was without an explaination back in commit

    "Add error reporting calls in error paths that return EFSCORRUPTED"

back in 2003.  There is no reason to reserve disk blocks in the
transaction when allocating blocks for delalloc space as we already
reserved the space when creating the delalloc extent.

With this fix we stop running out of the reserved pool in generic/229,
which has happened for long time with small blocksize file systems,
and has increased in severity with the new buffered write path.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_iomap.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 2114d53..279353c 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -691,7 +691,6 @@ xfs_iomap_write_allocate(
 	xfs_trans_t	*tp;
 	int		nimaps;
 	int		error = 0;
-	int		nres;
 
 	/*
 	 * Make sure that the dquots are there.
@@ -715,12 +714,15 @@ xfs_iomap_write_allocate(
 		 * is in the delayed allocation extent on which we sit
 		 * but before our buffer starts.
 		 */
-
 		nimaps = 0;
 		while (nimaps == 0) {
-			nres = XFS_EXTENTADD_SPACE_RES(mp, XFS_DATA_FORK);
-
-			error = xfs_trans_alloc(mp, &M_RES(mp)->tr_write, nres,
+			/*
+			 * We have already reserved space for the extent and any
+			 * indirect blocks when creating the delalloc extent,
+			 * there is no need to reserve space in this transaction
+			 * again.
+			 */
+			error = xfs_trans_alloc(mp, &M_RES(mp)->tr_write, 0,
 					0, XFS_TRANS_RESERVE, &tp);
 			if (error)
 				return error;
@@ -783,7 +785,7 @@ xfs_iomap_write_allocate(
 			 */
 			error = xfs_bmapi_write(tp, ip, map_start_fsb,
 						count_fsb, 0, &first_block,
-						nres, imap, &nimaps,
+						0, imap, &nimaps,
 						&dfops);
 			if (error)
 				goto trans_cancel;
-- 
2.1.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
