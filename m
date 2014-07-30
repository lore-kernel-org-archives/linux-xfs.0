Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id AA67B7F6F
	for <xfs@oss.sgi.com>; Tue, 29 Jul 2014 20:49:08 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 38AC1AC001
	for <xfs@oss.sgi.com>; Tue, 29 Jul 2014 18:49:08 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	c2NBqyebSejfLUlz for <xfs@oss.sgi.com>;
	Tue, 29 Jul 2014 18:49:06 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1XCJ0c-0001HA-PR
	for xfs@oss.sgi.com; Wed, 30 Jul 2014 11:48:50 +1000
Received: from dave by disappointment with local (Exim 4.82_1-5b7a7c0-XX)
	(envelope-from <dave@disappointment.disaster>) id 1XCJ0c-0002uQ-Oi
	for xfs@oss.sgi.com; Wed, 30 Jul 2014 11:48:50 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 1/4] xfs: catch buffers written without verifiers attached
Date: Wed, 30 Jul 2014 11:48:46 +1000
Message-Id: <1406684929-11133-2-git-send-email-david@fromorbit.com>
In-Reply-To: <1406684929-11133-1-git-send-email-david@fromorbit.com>
References: <1406684929-11133-1-git-send-email-david@fromorbit.com>
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

From: Dave Chinner <dchinner@redhat.com>

We recently had a bug where buffers were slipping through log
recovery without any verifier attached to them. This was resulting
in on-disk CRC mismatches for valid data. Add some warning code to
catch this occurrence so that we catch such bugs durin development
rather than not being aware they exist.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_buf.c | 6 ++++++
 fs/xfs/xfs_log.c | 7 ++++++-
 2 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index a6dc83e..95e5516 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -1330,6 +1330,12 @@ _xfs_buf_ioapply(
 						   SHUTDOWN_CORRUPT_INCORE);
 				return;
 			}
+		} else if (bp->b_bn != -1LL) {
+			xfs_warn(bp->b_target->bt_mount,
+				"%s: no ops on block 0x%llx/0x%llx",
+				__func__, bp->b_bn, bp->b_maps[0].bm_bn);
+			xfs_hex_dump(bp->b_addr, 64);
+			dump_stack();
 		}
 	} else if (bp->b_flags & XBF_READ_AHEAD) {
 		rw = READA;
diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 149a4a5..9dc92b3 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -1378,8 +1378,13 @@ xlog_alloc_log(
 
 	xlog_get_iclog_buffer_size(mp, log);
 
+	/*
+	 * Use a block number of -1 for the extra log buffer used during splits
+	 * so that it will trigger errors if we ever try to do IO on it without
+	 * first having set it up properly.
+	 */
 	error = -ENOMEM;
-	bp = xfs_buf_alloc(mp->m_logdev_targp, 0, BTOBB(log->l_iclog_size), 0);
+	bp = xfs_buf_alloc(mp->m_logdev_targp, -1LL, BTOBB(log->l_iclog_size), 0);
 	if (!bp)
 		goto out_free_log;
 
-- 
2.0.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
