Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:36820 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752448AbdLWBJL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 22 Dec 2017 20:09:11 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.21/8.16.0.21) with SMTP id vBN17Eb9076551
        for <linux-xfs@vger.kernel.org>; Sat, 23 Dec 2017 01:09:11 GMT
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by aserp2120.oracle.com with ESMTP id 2f1cvd812a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sat, 23 Dec 2017 01:09:11 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id vBN199jc022727
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Sat, 23 Dec 2017 01:09:10 GMT
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id vBN199Fa006692
        for <linux-xfs@vger.kernel.org>; Sat, 23 Dec 2017 01:09:09 GMT
Subject: [PATCH 20/20] xfs: dump the first 128 bytes of any corrupt buffer
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 22 Dec 2017 17:09:08 -0800
Message-ID: <151399134865.23543.2687306518339510402.stgit@magnolia>
In-Reply-To: <151399122361.23543.15718507168231759645.stgit@magnolia>
References: <151399122361.23543.15718507168231759645.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Increase the corrupt buffer dump to the first 128 bytes since v5
filesystems have larger block headers than before.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_buf.c   |    3 ++-
 fs/xfs/xfs_error.c |    7 ++++---
 fs/xfs/xfs_error.h |    3 +++
 3 files changed, 9 insertions(+), 4 deletions(-)


diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 45987a2..1981ef7 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -1381,7 +1381,8 @@ _xfs_buf_ioapply(
 				xfs_warn(mp,
 					"%s: no ops on block 0x%llx/0x%x",
 					__func__, bp->b_bn, bp->b_length);
-				xfs_hex_dump(bp->b_addr, 64);
+				xfs_hex_dump(bp->b_addr,
+						XFS_CORRUPTION_DUMP_LEN);
 				dump_stack();
 			}
 		}
diff --git a/fs/xfs/xfs_error.c b/fs/xfs/xfs_error.c
index d46cbcf9..00aa70f 100644
--- a/fs/xfs/xfs_error.c
+++ b/fs/xfs/xfs_error.c
@@ -336,7 +336,7 @@ xfs_corruption_error(
 	xfs_failaddr_t		failaddr)
 {
 	if (level <= xfs_error_level)
-		xfs_hex_dump(p, 64);
+		xfs_hex_dump(p, XFS_CORRUPTION_DUMP_LEN);
 	xfs_error_report(tag, level, mp, filename, linenum, failaddr);
 	xfs_alert(mp, "Corruption detected. Unmount and run xfs_repair");
 }
@@ -364,8 +364,9 @@ xfs_verifier_error(
 	xfs_alert(mp, "Unmount and run xfs_repair");
 
 	if (xfs_error_level >= XFS_ERRLEVEL_LOW) {
-		xfs_alert(mp, "First 64 bytes of corrupted metadata buffer:");
-		xfs_hex_dump(xfs_buf_offset(bp, 0), 64);
+		xfs_alert(mp, "First %d bytes of corrupted metadata buffer:",
+				XFS_CORRUPTION_DUMP_LEN);
+		xfs_hex_dump(xfs_buf_offset(bp, 0), XFS_CORRUPTION_DUMP_LEN);
 	}
 
 	if (xfs_error_level >= XFS_ERRLEVEL_HIGH)
diff --git a/fs/xfs/xfs_error.h b/fs/xfs/xfs_error.h
index f086040..a3ba05b 100644
--- a/fs/xfs/xfs_error.h
+++ b/fs/xfs/xfs_error.h
@@ -39,6 +39,9 @@ extern void xfs_verifier_error(struct xfs_buf *bp, int error,
 #define XFS_ERRLEVEL_LOW	1
 #define XFS_ERRLEVEL_HIGH	5
 
+/* Dump 128 bytes of any corrupt buffer */
+#define XFS_CORRUPTION_DUMP_LEN		(128)
+
 /*
  * Macros to set EFSCORRUPTED & return/branch.
  */

