Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id C95B97F6D
	for <xfs@oss.sgi.com>; Thu, 12 Nov 2015 09:37:32 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 3B1DAAC002
	for <xfs@oss.sgi.com>; Thu, 12 Nov 2015 07:37:32 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id g8gADF2Cji2gpcf2 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 12 Nov 2015 07:37:30 -0800 (PST)
Received: from int-mx09.intmail.prod.int.phx2.redhat.com
	(int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (Postfix) with ESMTPS id D24ACC60EE
	for <xfs@oss.sgi.com>; Thu, 12 Nov 2015 15:37:29 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-36.bos.redhat.com [10.18.41.36])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id tACFbTri032681
	for <xfs@oss.sgi.com>; Thu, 12 Nov 2015 10:37:29 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v2 5/8] xfs: support a crc verification only log record pass
Date: Thu, 12 Nov 2015 10:37:25 -0500
Message-Id: <1447342648-40012-6-git-send-email-bfoster@redhat.com>
In-Reply-To: <1447342648-40012-1-git-send-email-bfoster@redhat.com>
References: <1447342648-40012-1-git-send-email-bfoster@redhat.com>
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

Log recovery torn write detection uses CRC verification over a range of
the active log to identify torn writes. Since the generic log recovery
pass code implements a superset of the functionality required for CRC
verification, it can be easily modified to support a CRC verification
only pass.

Create a new CRC pass type and update the log record processing helper
to skip everything beyond CRC verification when in this mode. This pass
will be invoked in subsequent patches to implement torn write detection.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/libxfs/xfs_log_recover.h |  1 +
 fs/xfs/xfs_log_recover.c        | 24 +++++++++++++++++++-----
 2 files changed, 20 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_log_recover.h b/fs/xfs/libxfs/xfs_log_recover.h
index 1c55ccb..8e385f9 100644
--- a/fs/xfs/libxfs/xfs_log_recover.h
+++ b/fs/xfs/libxfs/xfs_log_recover.h
@@ -60,6 +60,7 @@ typedef struct xlog_recover {
  */
 #define	XLOG_BC_TABLE_SIZE	64
 
+#define	XLOG_RECOVER_CRCPASS	0
 #define	XLOG_RECOVER_PASS1	1
 #define	XLOG_RECOVER_PASS2	2
 
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index e0318e8..1be2590 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -4159,13 +4159,27 @@ xlog_recover_process(
 	int			error;
 	__le32			crc;
 
+	crc = xlog_cksum(log, rhead, dp, be32_to_cpu(rhead->h_len));
+
 	/*
-	 * Check the CRC and issue a warning if and only if the CRC in the
-	 * header is non-zero. This is an advisory warning and the zero CRC
-	 * check prevents warnings from being emitted when upgrading the kernel
-	 * from one that does not add CRCs by default.
+	 * Nothing else to do if this is a CRC verification pass. Just return
+	 * if this a record with a non-zero crc. Unfortunately, mkfs always
+	 * sets h_crc to 0 so we must consider this valid even on v5 supers.
+	 * Otherwise, return EFSBADCRC on failure so the callers up the stack
+	 * know precisely what failed.
+	 */
+	if (pass == XLOG_RECOVER_CRCPASS) {
+		if (rhead->h_crc && crc != le32_to_cpu(rhead->h_crc))
+			return -EFSBADCRC;
+		return 0;
+	}
+
+	/*
+	 * We're in the normal recovery path. Issue a warning if and only if the
+	 * CRC in the header is non-zero. This is an advisory warning and the
+	 * zero CRC check prevents warnings from being emitted when upgrading
+	 * the kernel from one that does not add CRCs by default.
 	 */
-	crc = xlog_cksum(log, rhead, dp, be32_to_cpu(rhead->h_len));
 	if (crc != le32_to_cpu(rhead->h_crc)) {
 		if (rhead->h_crc || xfs_sb_version_hascrc(&log->l_mp->m_sb)) {
 			xfs_alert(log->l_mp,
-- 
2.1.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
