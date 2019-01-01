Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:43026 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728231AbfAACTf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 31 Dec 2018 21:19:35 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id x012EtPd019123
        for <linux-xfs@vger.kernel.org>; Tue, 1 Jan 2019 02:19:33 GMT
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp2130.oracle.com with ESMTP id 2pp0btp792-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 01 Jan 2019 02:19:33 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id x012JR6n009124
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 1 Jan 2019 02:19:27 GMT
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x012JR0Z001533
        for <linux-xfs@vger.kernel.org>; Tue, 1 Jan 2019 02:19:27 GMT
Subject: [PATCH 04/22] xfs: hoist project id get/set functions
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Mon, 31 Dec 2018 18:19:26 -0800
Message-ID: <154630916606.18437.8437608724088276130.stgit@magnolia>
In-Reply-To: <154630914104.18437.15354380637179830566.stgit@magnolia>
References: <154630914104.18437.15354380637179830566.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Move the project id get and set functions into libxfs.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_inode_util.h |   29 +++++++++++++++++++++++++++++
 fs/xfs/xfs_inode.h             |   27 ---------------------------
 fs/xfs/xfs_linux.h             |    2 --
 3 files changed, 29 insertions(+), 29 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_inode_util.h b/fs/xfs/libxfs/xfs_inode_util.h
index 45f8c4869c4b..808e4322106e 100644
--- a/fs/xfs/libxfs/xfs_inode_util.h
+++ b/fs/xfs/libxfs/xfs_inode_util.h
@@ -14,4 +14,33 @@ uint64_t	xfs_flags2diflags2(struct xfs_inode *ip, unsigned int xflags);
 uint32_t	xfs_dic2xflags(uint16_t di_flags, uint64_t di_flags2,
 			       bool has_attr);
 
+/*
+ * Project quota id helpers (previously projid was 16bit only and using two
+ * 16bit values to hold new 32bit projid was chosen to retain compatibility
+ * with "old" filesystems).
+ */
+static inline prid_t
+xfs_get_projid(struct xfs_icdinode *id)
+{
+	return (prid_t)id->di_projid_hi << 16 | id->di_projid_lo;
+}
+
+static inline void
+xfs_set_projid(struct xfs_icdinode *id, prid_t projid)
+{
+	id->di_projid_hi = (uint16_t) (projid >> 16);
+	id->di_projid_lo = (uint16_t) (projid & 0xffff);
+}
+
+#define XFS_PROJID_DEFAULT		0
+
+static inline prid_t
+xfs_get_initial_prid(struct xfs_icdinode *id)
+{
+	if (id->di_flags & XFS_DIFLAG_PROJINHERIT)
+		return xfs_get_projid(id);
+
+	return XFS_PROJID_DEFAULT;
+}
+
 #endif /* __XFS_INODE_UTIL_H__ */
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index ca2623e0dd4f..fb55e3b74b34 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -165,33 +165,6 @@ xfs_iflags_test_and_set(xfs_inode_t *ip, unsigned short flags)
 	return ret;
 }
 
-/*
- * Project quota id helpers (previously projid was 16bit only
- * and using two 16bit values to hold new 32bit projid was chosen
- * to retain compatibility with "old" filesystems).
- */
-static inline prid_t
-xfs_get_projid(struct xfs_icdinode *id)
-{
-	return (prid_t)id->di_projid_hi << 16 | id->di_projid_lo;
-}
-
-static inline void
-xfs_set_projid(struct xfs_icdinode *id, prid_t projid)
-{
-	id->di_projid_hi = (uint16_t) (projid >> 16);
-	id->di_projid_lo = (uint16_t) (projid & 0xffff);
-}
-
-static inline prid_t
-xfs_get_initial_prid(struct xfs_icdinode *id)
-{
-	if (id->di_flags & XFS_DIFLAG_PROJINHERIT)
-		return xfs_get_projid(id);
-
-	return XFS_PROJID_DEFAULT;
-}
-
 static inline bool xfs_is_reflink_inode(struct xfs_inode *ip)
 {
 	return ip->i_d.di_flags2 & XFS_DIFLAG2_REFLINK;
diff --git a/fs/xfs/xfs_linux.h b/fs/xfs/xfs_linux.h
index edbd5a210df2..f2835a9f0a16 100644
--- a/fs/xfs/xfs_linux.h
+++ b/fs/xfs/xfs_linux.h
@@ -138,8 +138,6 @@ typedef __u32			xfs_nlink_t;
  */
 #define __this_address	({ __label__ __here; __here: barrier(); &&__here; })
 
-#define XFS_PROJID_DEFAULT	0
-
 #define howmany(x, y)	(((x)+((y)-1))/(y))
 
 static inline void delay(long ticks)
