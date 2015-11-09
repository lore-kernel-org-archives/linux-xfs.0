Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 2FDE97F5F
	for <xfs@oss.sgi.com>; Mon,  9 Nov 2015 14:21:22 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 21743304043
	for <xfs@oss.sgi.com>; Mon,  9 Nov 2015 12:21:22 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id XZl7GIp9EwAldLmA (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 09 Nov 2015 12:21:18 -0800 (PST)
Received: from int-mx11.intmail.prod.int.phx2.redhat.com
	(int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (Postfix) with ESMTPS id B1DB3C0B6112
	for <xfs@oss.sgi.com>; Mon,  9 Nov 2015 20:21:17 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-67.bos.redhat.com [10.18.41.67])
	by int-mx11.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id tA9KLH9T023703
	for <xfs@oss.sgi.com>; Mon, 9 Nov 2015 15:21:17 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 3/8] xfs: refactor and open code log record crc check
Date: Mon,  9 Nov 2015 15:21:10 -0500
Message-Id: <1447100475-33465-4-git-send-email-bfoster@redhat.com>
In-Reply-To: <1447100475-33465-1-git-send-email-bfoster@redhat.com>
References: <1447100475-33465-1-git-send-email-bfoster@redhat.com>
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

Log record CRC verification currently occurs during active log recovery,
immediately before a log record is unpacked. Therefore, the CRC
calculation code is buried within the data unpack function. CRC
verification pass support only needs to go so far as check the CRC, but
this is not easily allowed as the code is currently organized.

Since we now have a new log record processing helper, pull the record
CRC verification code out from the unpack helper and open-code it at the
top of the new process helper. This facilitates the ability to modify
how records are processed based on the type of the current pass. This
patch contains no functional changes.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_log_recover.c | 72 +++++++++++++++++-------------------------------
 1 file changed, 26 insertions(+), 46 deletions(-)

diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index a15a506..c2bf307 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -4118,46 +4118,6 @@ xlog_recover_process_iunlinks(
 	mp->m_dmevmask = mp_dmevmask;
 }
 
-/*
- * Upack the log buffer data and crc check it. If the check fails, issue a
- * warning if and only if the CRC in the header is non-zero. This makes the
- * check an advisory warning, and the zero CRC check will prevent failure
- * warnings from being emitted when upgrading the kernel from one that does not
- * add CRCs by default.
- *
- * When filesystems are CRC enabled, this CRC mismatch becomes a fatal log
- * corruption failure
- */
-STATIC int
-xlog_unpack_data_crc(
-	struct xlog_rec_header	*rhead,
-	char			*dp,
-	struct xlog		*log)
-{
-	__le32			crc;
-
-	crc = xlog_cksum(log, rhead, dp, be32_to_cpu(rhead->h_len));
-	if (crc != rhead->h_crc) {
-		if (rhead->h_crc || xfs_sb_version_hascrc(&log->l_mp->m_sb)) {
-			xfs_alert(log->l_mp,
-		"log record CRC mismatch: found 0x%x, expected 0x%x.",
-					le32_to_cpu(rhead->h_crc),
-					le32_to_cpu(crc));
-			xfs_hex_dump(dp, 32);
-		}
-
-		/*
-		 * If we've detected a log record corruption, then we can't
-		 * recover past this point. Abort recovery if we are enforcing
-		 * CRC protection by punting an error back up the stack.
-		 */
-		if (xfs_sb_version_hascrc(&log->l_mp->m_sb))
-			return -EFSCORRUPTED;
-	}
-
-	return 0;
-}
-
 STATIC int
 xlog_unpack_data(
 	struct xlog_rec_header	*rhead,
@@ -4165,11 +4125,6 @@ xlog_unpack_data(
 	struct xlog		*log)
 {
 	int			i, j, k;
-	int			error;
-
-	error = xlog_unpack_data_crc(rhead, dp, log);
-	if (error)
-		return error;
 
 	for (i = 0; i < BTOBB(be32_to_cpu(rhead->h_len)) &&
 		  i < (XLOG_HEADER_CYCLE_SIZE / BBSIZE); i++) {
@@ -4191,7 +4146,7 @@ xlog_unpack_data(
 }
 
 /*
- * Unpack and process a log record.
+ * CRC check, unpack and process a log record.
  */
 STATIC int
 xlog_recover_process(
@@ -4202,6 +4157,31 @@ xlog_recover_process(
 	int			pass)
 {
 	int			error;
+	__le32			crc;
+
+	/*
+	 * Check the CRC and issue a warning if and only if the CRC in the
+	 * header is non-zero. This is an advisory warning and the zero CRC
+	 * check prevents warnings from being emitted when upgrading the kernel
+	 * from one that does not add CRCs by default.
+	 */
+	crc = xlog_cksum(log, rhead, dp, be32_to_cpu(rhead->h_len));
+	if (crc != le32_to_cpu(rhead->h_crc)) {
+		if (rhead->h_crc || xfs_sb_version_hascrc(&log->l_mp->m_sb)) {
+			xfs_alert(log->l_mp,
+		"log record CRC mismatch: found 0x%x, expected 0x%x.",
+					le32_to_cpu(rhead->h_crc),
+					le32_to_cpu(crc));
+			xfs_hex_dump(dp, 32);
+		}
+
+		/*
+		 * If the filesystem is CRC enabled, this mismatch becomes a
+		 * fatal log corruption failure.
+		 */
+		if (xfs_sb_version_hascrc(&log->l_mp->m_sb))
+			return -EFSCORRUPTED;
+	}
 
 	error = xlog_unpack_data(rhead, dp, log);
 	if (error)
-- 
2.1.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
