Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:47304 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751781AbeAXCTJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 23 Jan 2018 21:19:09 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w0O27ScT066424
        for <linux-xfs@vger.kernel.org>; Wed, 24 Jan 2018 02:19:09 GMT
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by userp2120.oracle.com with ESMTP id 2fpgyjg1jn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 24 Jan 2018 02:19:08 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w0O2J8gx002650
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Wed, 24 Jan 2018 02:19:08 GMT
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w0O2J7uq024365
        for <linux-xfs@vger.kernel.org>; Wed, 24 Jan 2018 02:19:07 GMT
Subject: [PATCH 10/11] xfs: refactor inode verifier corruption error printing
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 23 Jan 2018 18:19:06 -0800
Message-ID: <151676034665.12349.14442218679852748423.stgit@magnolia>
In-Reply-To: <151676027743.12349.3845769501491774512.stgit@magnolia>
References: <151676027743.12349.3845769501491774512.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Refactor inode verifier error reporting into a non-libxfs function so
that we aren't encoding the message format in libxfs.  This also
changes the kernel dmesg output to resemble buffer verifier errors
more closely.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_inode_buf.c |    6 ++----
 fs/xfs/xfs_error.c            |   37 +++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_error.h            |    3 +++
 fs/xfs/xfs_inode.c            |   14 ++++++++------
 4 files changed, 50 insertions(+), 10 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index 6e9dcdb..6d05ba6 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -578,10 +578,8 @@ xfs_iread(
 	/* even unallocated inodes are verified */
 	fa = xfs_dinode_verify(mp, ip->i_ino, dip);
 	if (fa) {
-		xfs_alert(mp, "%s: validation failed for inode %lld at %pS",
-				__func__, ip->i_ino, fa);
-
-		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp, dip);
+		xfs_inode_verifier_error(ip, -EFSCORRUPTED, "record", dip,
+				sizeof(*dip), fa);
 		error = -EFSCORRUPTED;
 		goto out_brelse;
 	}
diff --git a/fs/xfs/xfs_error.c b/fs/xfs/xfs_error.c
index 980d5f0..ccf520f 100644
--- a/fs/xfs/xfs_error.c
+++ b/fs/xfs/xfs_error.c
@@ -24,6 +24,7 @@
 #include "xfs_errortag.h"
 #include "xfs_error.h"
 #include "xfs_sysfs.h"
+#include "xfs_inode.h"
 
 #ifdef DEBUG
 
@@ -372,3 +373,39 @@ xfs_verifier_error(
 	if (xfs_error_level >= XFS_ERRLEVEL_HIGH)
 		xfs_stack_trace();
 }
+
+/*
+ * Warnings for inode corruption problems.  Don't bother with the stack
+ * trace unless the error level is turned up high.
+ */
+void
+xfs_inode_verifier_error(
+	struct xfs_inode	*ip,
+	int			error,
+	const char		*name,
+	void			*buf,
+	size_t			bufsz,
+	xfs_failaddr_t		failaddr)
+{
+	struct xfs_mount	*mp = ip->i_mount;
+	xfs_failaddr_t		fa;
+	int			sz;
+
+	fa = failaddr ? failaddr : __return_address;
+
+	xfs_alert(mp, "Metadata %s detected at %pS, inode 0x%llx %s",
+		  error == -EFSBADCRC ? "CRC error" : "corruption",
+		  fa, ip->i_ino, name);
+
+	xfs_alert(mp, "Unmount and run xfs_repair");
+
+	if (buf && xfs_error_level >= XFS_ERRLEVEL_LOW) {
+		sz = min_t(size_t, XFS_CORRUPTION_DUMP_LEN, bufsz);
+		xfs_alert(mp, "First %d bytes of corrupted metadata buffer:",
+				sz);
+		xfs_hex_dump(buf, sz);
+	}
+
+	if (xfs_error_level >= XFS_ERRLEVEL_HIGH)
+		xfs_stack_trace();
+}
diff --git a/fs/xfs/xfs_error.h b/fs/xfs/xfs_error.h
index a3ba05b..7e728c5 100644
--- a/fs/xfs/xfs_error.h
+++ b/fs/xfs/xfs_error.h
@@ -28,6 +28,9 @@ extern void xfs_corruption_error(const char *tag, int level,
 			int linenum, xfs_failaddr_t failaddr);
 extern void xfs_verifier_error(struct xfs_buf *bp, int error,
 			xfs_failaddr_t failaddr);
+extern void xfs_inode_verifier_error(struct xfs_inode *ip, int error,
+			const char *name, void *buf, size_t bufsz,
+			xfs_failaddr_t failaddr);
 
 #define	XFS_ERROR_REPORT(e, lvl, mp)	\
 	xfs_error_report(e, lvl, mp, __FILE__, __LINE__, __return_address)
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index fc118dd..c60efec 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -3502,21 +3502,23 @@ bool
 xfs_inode_verify_forks(
 	struct xfs_inode	*ip)
 {
+	struct xfs_ifork	*ifp;
 	xfs_failaddr_t		fa;
 
 	fa = xfs_ifork_verify_data(ip, &xfs_default_ifork_ops);
 	if (fa) {
-		xfs_alert(ip->i_mount,
-				"%s: bad inode %llu inline data fork at %pS",
-				__func__, ip->i_ino, fa);
+		ifp = XFS_IFORK_PTR(ip, XFS_DATA_FORK);
+		xfs_inode_verifier_error(ip, -EFSCORRUPTED, "data fork",
+				ifp->if_u1.if_data, ifp->if_bytes, fa);
 		return false;
 	}
 
 	fa = xfs_ifork_verify_attr(ip, &xfs_default_ifork_ops);
 	if (fa) {
-		xfs_alert(ip->i_mount,
-				"%s: bad inode %llu inline attr fork at %pS",
-				__func__, ip->i_ino, fa);
+		ifp = XFS_IFORK_PTR(ip, XFS_ATTR_FORK);
+		xfs_inode_verifier_error(ip, -EFSCORRUPTED, "attr fork",
+				ifp ? ifp->if_u1.if_data : NULL,
+				ifp ? ifp->if_bytes : 0, fa);
 		return false;
 	}
 	return true;

