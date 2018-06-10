Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:49244 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753729AbeFJFKN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 10 Jun 2018 01:10:13 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w5A56UWA141626
        for <linux-xfs@vger.kernel.org>; Sun, 10 Jun 2018 05:10:13 GMT
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by aserp2120.oracle.com with ESMTP id 2jgecx94pa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 10 Jun 2018 05:10:13 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w5A5AC73004545
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 10 Jun 2018 05:10:12 GMT
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w5A5ACRl003827
        for <linux-xfs@vger.kernel.org>; Sun, 10 Jun 2018 05:10:12 GMT
From: Allison Henderson <allison.henderson@oracle.com>
Subject: [PATCH v2 12/27] xfsprogs: add parent pointer support to attribute code
Date: Sat,  9 Jun 2018 22:07:37 -0700
Message-Id: <1528607272-11122-13-git-send-email-allison.henderson@oracle.com>
In-Reply-To: <1528607272-11122-1-git-send-email-allison.henderson@oracle.com>
References: <1528607272-11122-1-git-send-email-allison.henderson@oracle.com>
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
 libxfs/xfs_attr_leaf.c |  2 +-
 libxfs/xfs_da_format.h | 12 ++++++++----
 4 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index 64fb6ef..df0bd91 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -384,7 +384,7 @@ xfs_attr_set(
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
index ef53215..0440003 100644
--- a/libxfs/xfs_attr_leaf.c
+++ b/libxfs/xfs_attr_leaf.c
@@ -37,7 +37,7 @@
 #include "xfs_trace.h"
 #include "xfs_cksum.h"
 #include "xfs_dir2.h"
-
+#include "xfs_attr.h"
 
 /*
  * xfs_attr_leaf.c
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

