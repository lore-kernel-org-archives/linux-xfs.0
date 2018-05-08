Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:33524 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752306AbeEHEn3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 8 May 2018 00:43:29 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w484gGY7067233
        for <linux-xfs@vger.kernel.org>; Tue, 8 May 2018 04:43:29 GMT
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by userp2130.oracle.com with ESMTP id 2hs426euqv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 08 May 2018 04:43:29 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w484hTNI029014
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 8 May 2018 04:43:29 GMT
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w484hSdb025427
        for <linux-xfs@vger.kernel.org>; Tue, 8 May 2018 04:43:28 GMT
From: Allison Henderson <allison.henderson@oracle.com>
Subject: [PATCH 11/21] xfsprogs: add parent pointer support to attribute code
Date: Mon,  7 May 2018 21:41:09 -0700
Message-Id: <1525754479-12177-12-git-send-email-allison.henderson@oracle.com>
In-Reply-To: <1525754479-12177-1-git-send-email-allison.henderson@oracle.com>
References: <1525754479-12177-1-git-send-email-allison.henderson@oracle.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Add the new parent attribute type. XFS_ATTR_PARENT is used only for
parent pointer entries; it uses reserved blocks like XFS_ATTR_ROOT.

[dchinner: forward ported and cleaned up]
[achender: rebased]

Signed-off-by: Mark Tinguely <tinguely@sgi.com>
Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 libxfs/xfs_attr.c      |  2 +-
 libxfs/xfs_attr.h      |  2 ++
 libxfs/xfs_attr_leaf.c |  1 +
 libxfs/xfs_da_format.h | 12 ++++++++----
 4 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index f83aa33..b1f5db6 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -373,7 +373,7 @@ xfs_attr_set(
 	struct xfs_defer_ops	dfops;
 	struct xfs_trans_res	tres;
 	xfs_fsblock_t		firstblock;
-	int			rsvd = (flags & ATTR_ROOT) != 0;
+	bool			rsvd = (flags & (ATTR_ROOT | ATTR_PARENT)) != 0;
 	int			error, local;
 
 	XFS_STATS_INC(mp, xs_attr_set);
diff --git a/libxfs/xfs_attr.h b/libxfs/xfs_attr.h
index d23cf4a..f388f5f 100644
--- a/libxfs/xfs_attr.h
+++ b/libxfs/xfs_attr.h
@@ -44,6 +44,7 @@ struct xfs_attr_list_context;
 #define ATTR_SECURE	0x0008	/* use attrs in security namespace */
 #define ATTR_CREATE	0x0010	/* pure create: fail if attr already exists */
 #define ATTR_REPLACE	0x0020	/* pure set: fail if attr does not exist */
+#define ATTR_PARENT	0x0040	/*  use attrs in parent namespace */
 
 #define ATTR_INCOMPLETE	0x4000	/* [kernel] return INCOMPLETE attr keys */
 
@@ -54,6 +55,7 @@ struct xfs_attr_list_context;
 	{ ATTR_SECURE,		"SECURE" }, \
 	{ ATTR_CREATE,		"CREATE" }, \
 	{ ATTR_REPLACE,		"REPLACE" }, \
+	{ ATTR_PARENT,		"PARENT" }, \
 	{ ATTR_KERNOTIME,	"KERNOTIME" }, \
 	{ ATTR_KERNOVAL,	"KERNOVAL" }, \
 	{ ATTR_INCOMPLETE,	"INCOMPLETE" }
diff --git a/libxfs/xfs_attr_leaf.c b/libxfs/xfs_attr_leaf.c
index ef53215..b037788 100644
--- a/libxfs/xfs_attr_leaf.c
+++ b/libxfs/xfs_attr_leaf.c
@@ -37,6 +37,7 @@
 #include "xfs_trace.h"
 #include "xfs_cksum.h"
 #include "xfs_dir2.h"
+#include "xfs_attr.h"
 
 
 /*
diff --git a/libxfs/xfs_da_format.h b/libxfs/xfs_da_format.h
index 7e77299..9bd2e6b 100644
--- a/libxfs/xfs_da_format.h
+++ b/libxfs/xfs_da_format.h
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

