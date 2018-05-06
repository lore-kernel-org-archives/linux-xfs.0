Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:44034 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751822AbeEFR1K (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 6 May 2018 13:27:10 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w46HQUWR128037
        for <linux-xfs@vger.kernel.org>; Sun, 6 May 2018 17:27:10 GMT
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp2130.oracle.com with ESMTP id 2hs426a11h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 06 May 2018 17:27:09 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w46HR8RX010612
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 6 May 2018 17:27:09 GMT
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w46HR8mV021682
        for <linux-xfs@vger.kernel.org>; Sun, 6 May 2018 17:27:08 GMT
From: Allison Henderson <allison.henderson@oracle.com>
Subject: [PATCH 11/21] xfs: add parent pointer support to attribute code
Date: Sun,  6 May 2018 10:24:44 -0700
Message-Id: <1525627494-12873-12-git-send-email-allison.henderson@oracle.com>
In-Reply-To: <1525627494-12873-1-git-send-email-allison.henderson@oracle.com>
References: <1525627494-12873-1-git-send-email-allison.henderson@oracle.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

From: Mark Tinguely <tinguely@sgi.com>

Add the new parent attribute type. XFS_ATTR_PARENT is used only for
parent pointer entries; it uses reserved blocks like XFS_ATTR_ROOT.

[dchinner: forward ported and cleaned up]
[achender: rebased]

Signed-off-by: Mark Tinguely <tinguely@sgi.com>
Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 fs/xfs/libxfs/xfs_attr.c      |  2 +-
 fs/xfs/libxfs/xfs_attr.h      |  2 ++
 fs/xfs/libxfs/xfs_da_format.h | 12 ++++++++----
 3 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 484fa86..41b31dc 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -377,7 +377,7 @@ xfs_attr_set(
 	struct xfs_defer_ops	dfops;
 	struct xfs_trans_res	tres;
 	xfs_fsblock_t		firstblock;
-	int			rsvd = (flags & ATTR_ROOT) != 0;
+	bool			rsvd = (flags & (ATTR_ROOT | ATTR_PARENT)) != 0;
 	int			error, local;
 
 	XFS_STATS_INC(mp, xs_attr_set);
diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
index 308a93e..d041734 100644
--- a/fs/xfs/libxfs/xfs_attr.h
+++ b/fs/xfs/libxfs/xfs_attr.h
@@ -46,6 +46,7 @@ struct xfs_attr_list_context;
 #define ATTR_SECURE	0x0008	/* use attrs in security namespace */
 #define ATTR_CREATE	0x0010	/* pure create: fail if attr already exists */
 #define ATTR_REPLACE	0x0020	/* pure set: fail if attr does not exist */
+#define ATTR_PARENT	0x0040	/*  use attrs in parent namespace */
 
 #define ATTR_KERNOTIME	0x1000	/* [kernel] don't update inode timestamps */
 #define ATTR_KERNOVAL	0x2000	/* [kernel] get attr size only, not value */
@@ -59,6 +60,7 @@ struct xfs_attr_list_context;
 	{ ATTR_SECURE,		"SECURE" }, \
 	{ ATTR_CREATE,		"CREATE" }, \
 	{ ATTR_REPLACE,		"REPLACE" }, \
+	{ ATTR_PARENT,		"PARENT" }, \
 	{ ATTR_KERNOTIME,	"KERNOTIME" }, \
 	{ ATTR_KERNOVAL,	"KERNOVAL" }, \
 	{ ATTR_INCOMPLETE,	"INCOMPLETE" }
diff --git a/fs/xfs/libxfs/xfs_da_format.h b/fs/xfs/libxfs/xfs_da_format.h
index 7e77299..9bd2e6b 100644
--- a/fs/xfs/libxfs/xfs_da_format.h
+++ b/fs/xfs/libxfs/xfs_da_format.h
@@ -758,24 +758,28 @@ struct xfs_attr3_icleaf_hdr {
 #define	XFS_ATTR_LOCAL_BIT	0	/* attr is stored locally */
 #define	XFS_ATTR_ROOT_BIT	1	/* limit access to trusted attrs */
 #define	XFS_ATTR_SECURE_BIT	2	/* limit access to secure attrs */
+#define 	XFS_ATTR_PARENT_BIT	3	/* parent pointer secure attrs */
 #define	XFS_ATTR_INCOMPLETE_BIT	7	/* attr in middle of create/delete */
 #define XFS_ATTR_LOCAL		(1 << XFS_ATTR_LOCAL_BIT)
 #define XFS_ATTR_ROOT		(1 << XFS_ATTR_ROOT_BIT)
 #define XFS_ATTR_SECURE		(1 << XFS_ATTR_SECURE_BIT)
+#define XFS_ATTR_PARENT		(1 << XFS_ATTR_PARENT_BIT)
 #define XFS_ATTR_INCOMPLETE	(1 << XFS_ATTR_INCOMPLETE_BIT)
 
 /*
  * Conversion macros for converting namespace bits from argument flags
  * to ondisk flags.
  */
-#define XFS_ATTR_NSP_ARGS_MASK		(ATTR_ROOT | ATTR_SECURE)
-#define XFS_ATTR_NSP_ONDISK_MASK	(XFS_ATTR_ROOT | XFS_ATTR_SECURE)
+#define XFS_ATTR_NSP_ARGS_MASK		(ATTR_ROOT | ATTR_SECURE | XFS_ATTR_PARENT)
+#define XFS_ATTR_NSP_ONDISK_MASK	(XFS_ATTR_ROOT | XFS_ATTR_SECURE | XFS_ATTR_PARENT)
 #define XFS_ATTR_NSP_ONDISK(flags)	((flags) & XFS_ATTR_NSP_ONDISK_MASK)
 #define XFS_ATTR_NSP_ARGS(flags)	((flags) & XFS_ATTR_NSP_ARGS_MASK)
 #define XFS_ATTR_NSP_ARGS_TO_ONDISK(x)	(((x) & ATTR_ROOT ? XFS_ATTR_ROOT : 0) |\
-					 ((x) & ATTR_SECURE ? XFS_ATTR_SECURE : 0))
+					 ((x) & ATTR_SECURE ? XFS_ATTR_SECURE : 0) | \
+					 ((x) & ATTR_PARENT ? XFS_ATTR_PARENT : 0))
 #define XFS_ATTR_NSP_ONDISK_TO_ARGS(x)	(((x) & XFS_ATTR_ROOT ? ATTR_ROOT : 0) |\
-					 ((x) & XFS_ATTR_SECURE ? ATTR_SECURE : 0))
+					 ((x) & XFS_ATTR_SECURE ? ATTR_SECURE : 0) | \
+					 ((x) & XFS_ATTR_PARENT ? ATTR_PARENT : 0))
 
 /*
  * Alignment for namelist and valuelist entries (since they are mixed
-- 
2.7.4

