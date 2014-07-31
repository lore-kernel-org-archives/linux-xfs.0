Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 08C0A7F99
	for <xfs@oss.sgi.com>; Wed, 30 Jul 2014 20:02:01 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 7DC11AC003
	for <xfs@oss.sgi.com>; Wed, 30 Jul 2014 18:01:57 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	f80RHxOEuS73s8OO for <xfs@oss.sgi.com>;
	Wed, 30 Jul 2014 18:01:55 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1XCeki-0004nG-8l
	for xfs@oss.sgi.com; Thu, 31 Jul 2014 11:01:52 +1000
Received: from dave by disappointment with local (Exim 4.82_1-5b7a7c0-XX)
	(envelope-from <dave@disappointment.disaster>) id 1XCeki-0000A8-7s
	for xfs@oss.sgi.com; Thu, 31 Jul 2014 11:01:52 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 1/4] xfs: catch buffers written without verifiers attached
Date: Thu, 31 Jul 2014 11:01:46 +1000
Message-Id: <1406768509-32556-2-git-send-email-david@fromorbit.com>
In-Reply-To: <1406768509-32556-1-git-send-email-david@fromorbit.com>
References: <1406768509-32556-1-git-send-email-david@fromorbit.com>
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
catch this occurrence so that we catch such bugs during development
rather than not being aware they exist.

Note that we cannot do this verification unconditionally as non-CRC
filesystems don't always attach verifiers to the buffers being
written. e.g. during log recovery we cannot identify all the
different types of buffers correctly on non-CRC filesystems, so we
can't attach the correct verifiers in all cases and so we don't
attach any. Hence we don't want on non-CRC filesystems to avoid
spamming the logs with false indications.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_buf.c | 14 ++++++++++++++
 fs/xfs/xfs_log.c |  8 +++++++-
 2 files changed, 21 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index a6dc83e..cd7b8ca 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -1330,6 +1330,20 @@ _xfs_buf_ioapply(
 						   SHUTDOWN_CORRUPT_INCORE);
 				return;
 			}
+		} else if (bp->b_bn != XFS_BUF_DADDR_NULL) {
+			struct xfs_mount *mp = bp->b_target->bt_mount;
+
+			/*
+			 * non-crc filesystems don't attach verifiers during
+			 * log recovery, so don't warn for such filesystems.
+			 */
+			if (xfs_sb_version_hascrc(&mp->m_sb)) {
+				xfs_warn(mp,
+					"%s: no ops on block 0x%llx/0x%x",
+					__func__, bp->b_bn, bp->b_length);
+				xfs_hex_dump(bp->b_addr, 64);
+				dump_stack();
+			}
 		}
 	} else if (bp->b_flags & XBF_READ_AHEAD) {
 		rw = READA;
diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 149a4a5..ca4fd5b 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -1378,8 +1378,14 @@ xlog_alloc_log(
 
 	xlog_get_iclog_buffer_size(mp, log);
 
+	/*
+	 * Use a NULL block for the extra log buffer used during splits so that
+	 * it will trigger errors if we ever try to do IO on it without first
+	 * having set it up properly.
+	 */
 	error = -ENOMEM;
-	bp = xfs_buf_alloc(mp->m_logdev_targp, 0, BTOBB(log->l_iclog_size), 0);
+	bp = xfs_buf_alloc(mp->m_logdev_targp, XFS_BUF_DADDR_NULL,
+			   BTOBB(log->l_iclog_size), 0);
 	if (!bp)
 		goto out_free_log;
 
-- 
2.0.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
