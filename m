Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:60282 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1758095AbeAHWmW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 8 Jan 2018 17:42:22 -0500
Date: Mon, 8 Jan 2018 14:38:45 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH v3] xfs: clarify units in the failed metadata io message
Message-ID: <20180108223845.GZ5602@magnolia>
References: <20180108194015.GT5602@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180108194015.GT5602@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: xfs <linux-xfs@vger.kernel.org>
Cc: Eric Sandeen <sandeen@redhat.com>, Dave Chinner <david@fromorbit.com>

From: Darrick J. Wong <darrick.wong@oracle.com>

If a metadata IO error happens, we report the location of the failed IO
request in units of daddrs.  However, the printk message misleads people
into thinking that the units are fs blocks, so fix the reported units.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
v3: fix only the units reporting, don't print the caller
v2: fix more messages
---
 fs/xfs/xfs_buf.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 1981ef7..0820c1c 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -585,7 +585,7 @@ _xfs_buf_find(
 		 * returning a specific error on buffer lookup failures.
 		 */
 		xfs_alert(btp->bt_mount,
-			  "%s: Block out of range: block 0x%llx, EOFS 0x%llx ",
+			  "%s: daddr 0x%llx out of range, EOFS 0x%llx",
 			  __func__, cmap.bm_bn, eofs);
 		WARN_ON(1);
 		return NULL;
@@ -1196,8 +1196,9 @@ xfs_buf_ioerror_alert(
 	const char		*func)
 {
 	xfs_alert(bp->b_target->bt_mount,
-"metadata I/O error: block 0x%llx (\"%s\") error %d numblks %d",
-		(uint64_t)XFS_BUF_ADDR(bp), func, -bp->b_error, bp->b_length);
+"metadata I/O error in \"%s\" at daddr 0x%llx len %d error %d",
+			func, (uint64_t)XFS_BUF_ADDR(bp), bp->b_length,
+			-bp->b_error);
 }
 
 int
@@ -1379,7 +1380,7 @@ _xfs_buf_ioapply(
 			 */
 			if (xfs_sb_version_hascrc(&mp->m_sb)) {
 				xfs_warn(mp,
-					"%s: no ops on block 0x%llx/0x%x",
+					"%s: no buf ops on daddr 0x%llx len %d",
 					__func__, bp->b_bn, bp->b_length);
 				xfs_hex_dump(bp->b_addr,
 						XFS_CORRUPTION_DUMP_LEN);
@@ -1673,7 +1674,7 @@ xfs_wait_buftarg(
 			list_del_init(&bp->b_lru);
 			if (bp->b_flags & XBF_WRITE_FAIL) {
 				xfs_alert(btp->bt_mount,
-"Corruption Alert: Buffer at block 0x%llx had permanent write failures!",
+"Corruption Alert: Buffer at daddr 0x%llx had permanent write failures!",
 					(long long)bp->b_bn);
 				xfs_alert(btp->bt_mount,
 "Please run xfs_repair to determine the extent of the problem.");
