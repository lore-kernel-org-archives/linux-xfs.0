Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:40496 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757168AbdLWBOK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 22 Dec 2017 20:14:10 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.21/8.16.0.21) with SMTP id vBN1CJcX079506
        for <linux-xfs@vger.kernel.org>; Sat, 23 Dec 2017 01:14:10 GMT
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by aserp2120.oracle.com with ESMTP id 2f1cvd81w0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sat, 23 Dec 2017 01:14:07 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id vBN1931g012916
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Sat, 23 Dec 2017 01:09:03 GMT
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id vBN1930T009877
        for <linux-xfs@vger.kernel.org>; Sat, 23 Dec 2017 01:09:03 GMT
Subject: [PATCH 19/20] xfs: teach error reporting functions to take
 xfs_failaddr_t
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 22 Dec 2017 17:09:02 -0800
Message-ID: <151399134260.23543.8399442741926285897.stgit@magnolia>
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

Convert the two other error reporting functions to take xfs_failaddr_t
when the caller wishes to capture a code pointer instead of the classic
void * pointer.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_error.c |    8 ++++----
 fs/xfs/xfs_error.h |    5 +++--
 2 files changed, 7 insertions(+), 6 deletions(-)


diff --git a/fs/xfs/xfs_error.c b/fs/xfs/xfs_error.c
index 7e58a99..d46cbcf9 100644
--- a/fs/xfs/xfs_error.c
+++ b/fs/xfs/xfs_error.c
@@ -314,12 +314,12 @@ xfs_error_report(
 	struct xfs_mount	*mp,
 	const char		*filename,
 	int			linenum,
-	void			*ra)
+	xfs_failaddr_t		failaddr)
 {
 	if (level <= xfs_error_level) {
 		xfs_alert_tag(mp, XFS_PTAG_ERROR_REPORT,
 		"Internal error %s at line %d of file %s.  Caller %pS",
-			    tag, linenum, filename, ra);
+			    tag, linenum, filename, failaddr);
 
 		xfs_stack_trace();
 	}
@@ -333,11 +333,11 @@ xfs_corruption_error(
 	void			*p,
 	const char		*filename,
 	int			linenum,
-	void			*ra)
+	xfs_failaddr_t		failaddr)
 {
 	if (level <= xfs_error_level)
 		xfs_hex_dump(p, 64);
-	xfs_error_report(tag, level, mp, filename, linenum, ra);
+	xfs_error_report(tag, level, mp, filename, linenum, failaddr);
 	xfs_alert(mp, "Corruption detected. Unmount and run xfs_repair");
 }
 
diff --git a/fs/xfs/xfs_error.h b/fs/xfs/xfs_error.h
index 11f80e0..f086040 100644
--- a/fs/xfs/xfs_error.h
+++ b/fs/xfs/xfs_error.h
@@ -21,10 +21,11 @@
 struct xfs_mount;
 
 extern void xfs_error_report(const char *tag, int level, struct xfs_mount *mp,
-			const char *filename, int linenum, void *ra);
+			const char *filename, int linenum,
+			xfs_failaddr_t failaddr);
 extern void xfs_corruption_error(const char *tag, int level,
 			struct xfs_mount *mp, void *p, const char *filename,
-			int linenum, void *ra);
+			int linenum, xfs_failaddr_t failaddr);
 extern void xfs_verifier_error(struct xfs_buf *bp, int error,
 			xfs_failaddr_t failaddr);
 

