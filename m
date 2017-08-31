Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:48078 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751024AbdHaUdx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 31 Aug 2017 16:33:53 -0400
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v7VKXqGS013941
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 31 Aug 2017 20:33:53 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id v7VKXqFY030728
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 31 Aug 2017 20:33:52 GMT
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id v7VKXpFt017790
        for <linux-xfs@vger.kernel.org>; Thu, 31 Aug 2017 20:33:52 GMT
Subject: [PATCH 04/19] xfs: introduce realtime rmap btree definitions
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 31 Aug 2017 13:33:49 -0700
Message-ID: <150421162950.17458.13956738145194349139.stgit@magnolia>
In-Reply-To: <150421160433.17458.10817316901867396010.stgit@magnolia>
References: <150421160433.17458.10817316901867396010.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Add new realtime rmap btree definitions. The realtime rmap btree will
be rooted from a hidden inode, but has its own shape and therefore
needs to have most of its own separate types.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_btree.c  |    4 ++--
 fs/xfs/libxfs/xfs_btree.h  |    1 +
 fs/xfs/libxfs/xfs_format.h |    7 +++++++
 fs/xfs/libxfs/xfs_types.h  |    3 ++-
 4 files changed, 12 insertions(+), 3 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index d0a357e..c0614e4 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -45,10 +45,10 @@ kmem_zone_t	*xfs_btree_cur_zone;
  */
 static const uint32_t xfs_magics[2][XFS_BTNUM_MAX] = {
 	{ XFS_ABTB_MAGIC, XFS_ABTC_MAGIC, 0, XFS_BMAP_MAGIC, XFS_IBT_MAGIC,
-	  XFS_FIBT_MAGIC, 0 },
+	  XFS_FIBT_MAGIC, 0, 0 },
 	{ XFS_ABTB_CRC_MAGIC, XFS_ABTC_CRC_MAGIC, XFS_RMAP_CRC_MAGIC,
 	  XFS_BMAP_CRC_MAGIC, XFS_IBT_CRC_MAGIC, XFS_FIBT_CRC_MAGIC,
-	  XFS_REFC_CRC_MAGIC }
+	  XFS_REFC_CRC_MAGIC, XFS_RTRMAP_CRC_MAGIC }
 };
 
 uint32_t
diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
index 39d2143..e7bbf760 100644
--- a/fs/xfs/libxfs/xfs_btree.h
+++ b/fs/xfs/libxfs/xfs_btree.h
@@ -75,6 +75,7 @@ union xfs_btree_rec {
 #define	XFS_BTNUM_FINO	((xfs_btnum_t)XFS_BTNUM_FINOi)
 #define	XFS_BTNUM_RMAP	((xfs_btnum_t)XFS_BTNUM_RMAPi)
 #define	XFS_BTNUM_REFC	((xfs_btnum_t)XFS_BTNUM_REFCi)
+#define	XFS_BTNUM_RTRMAP	((xfs_btnum_t)XFS_BTNUM_RTRMAPi)
 
 uint32_t xfs_btree_magic(int crc, xfs_btnum_t btnum);
 
diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index 294aa65..c9138d5 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -1462,6 +1462,13 @@ typedef __be32 xfs_rmap_ptr_t;
 	 XFS_IBT_BLOCK(mp) + 1)
 
 /*
+ * Realtime Reverse mapping btree format definitions
+ *
+ * There is a btree for the reverse map per allocation group
+ */
+#define	XFS_RTRMAP_CRC_MAGIC	0x4d415052	/* 'MAPR' */
+
+/*
  * Reference Count Btree format definitions
  *
  */
diff --git a/fs/xfs/libxfs/xfs_types.h b/fs/xfs/libxfs/xfs_types.h
index 0220159..9fa4236 100644
--- a/fs/xfs/libxfs/xfs_types.h
+++ b/fs/xfs/libxfs/xfs_types.h
@@ -112,7 +112,8 @@ typedef enum {
 
 typedef enum {
 	XFS_BTNUM_BNOi, XFS_BTNUM_CNTi, XFS_BTNUM_RMAPi, XFS_BTNUM_BMAPi,
-	XFS_BTNUM_INOi, XFS_BTNUM_FINOi, XFS_BTNUM_REFCi, XFS_BTNUM_MAX
+	XFS_BTNUM_INOi, XFS_BTNUM_FINOi, XFS_BTNUM_REFCi, XFS_BTNUM_RTRMAPi,
+	XFS_BTNUM_MAX
 } xfs_btnum_t;
 
 struct xfs_name {

