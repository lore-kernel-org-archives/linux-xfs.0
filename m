Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 14A247F51
	for <xfs@oss.sgi.com>; Sun,  3 Jan 2016 06:09:44 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 9A826AC001
	for <xfs@oss.sgi.com>; Sun,  3 Jan 2016 04:09:43 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id eyFl5Gq20cYFZpMR (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Sun, 03 Jan 2016 04:09:42 -0800 (PST)
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 2/3] xfs: only end a COW operation in xfs_zero_remaining_bytes
	if we started one
Date: Sun,  3 Jan 2016 13:07:52 +0100
Message-Id: <1451822873-12969-3-git-send-email-hch@lst.de>
In-Reply-To: <1451822873-12969-1-git-send-email-hch@lst.de>
References: <1451822873-12969-1-git-send-email-hch@lst.de>
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
To: darrick.wong@oracle.com
Cc: xfs@oss.sgi.com

Without these we can see NULL pointer dereferences due to a non-existing
COW fork during xfstests runs.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_bmap_util.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 7bee3c7..e777095 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -1226,13 +1226,15 @@ xfs_zero_remaining_bytes(
 
 		error = xfs_bwrite(bp);
 		xfs_buf_relse(bp);
-		if (error) {
-			err2 = xfs_reflink_end_cow_failed(ip, offset,
+		if (should_fork) {
+			if (error) {
+				err2 = xfs_reflink_end_cow_failed(ip, offset,
+						lastoffset - offset + 1);
+				return error;
+			}
+			error = xfs_reflink_end_cow(ip, offset,
 					lastoffset - offset + 1);
-			return error;
 		}
-		error = xfs_reflink_end_cow(ip, offset,
-				lastoffset - offset + 1);
 		if (error)
 			return error;
 	}
-- 
1.9.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
