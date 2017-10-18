Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:29960 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751108AbdJRXAP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 Oct 2017 19:00:15 -0400
From: Allison Henderson <allison.henderson@oracle.com>
Subject: [PATCH 08/17] xfs: add parent pointer support to attribute code
Date: Wed, 18 Oct 2017 15:55:24 -0700
Message-Id: <1508367333-3237-9-git-send-email-allison.henderson@oracle.com>
In-Reply-To: <1508367333-3237-1-git-send-email-allison.henderson@oracle.com>
References: <1508367333-3237-1-git-send-email-allison.henderson@oracle.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: Mark Tinguely <tinguely@sgi.com>, Dave Chinner <dchinner@redhat.com>, Allison Henderson <allison.henderson@oracle.com>

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
 fs/xfs/libxfs/xfs_da_format.h | 12 ++++++++----
 fs/xfs/xfs_attr.h             |  2 ++
 3 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index b94f0cd..8f8bfff9 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -397,7 +397,7 @@ xfs_attr_set(
 	struct xfs_da_args	args;
 	struct xfs_defer_ops	dfops;
 	xfs_fsblock_t		firstblock;
-	int			rsvd = (flags & ATTR_ROOT) != 0;
+	bool			rsvd = (flags & (ATTR_ROOT | ATTR_PARENT)) != 0;
 	int			error, local;
 
 	XFS_STATS_INC(mp, xs_attr_set);
diff --git a/fs/xfs/libxfs/xfs_da_format.h b/fs/xfs/libxfs/xfs_da_format.h
index 3771edc..5f94c84 100644
--- a/fs/xfs/libxfs/xfs_da_format.h
+++ b/fs/xfs/libxfs/xfs_da_format.h
@@ -758,24 +758,28 @@ struct xfs_attr3_icleaf_hdr {
 #define	XFS_ATTR_LOCAL_BIT	0	/* attr is stored locally */
 #define	XFS_ATTR_ROOT_BIT	1	/* limit access to trusted attrs */
 #define	XFS_ATTR_SECURE_BIT	2	/* limit access to secure attrs */
+#define XFS_ATTR_PARENT_BIT	3	/* parent pointer secure attrs */
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
diff --git a/fs/xfs/xfs_attr.h b/fs/xfs/xfs_attr.h
index 532567e..7901c3b 100644
--- a/fs/xfs/xfs_attr.h
+++ b/fs/xfs/xfs_attr.h
@@ -46,6 +46,7 @@ struct xfs_attr_list_context;
 #define ATTR_SECURE	0x0008	/* use attrs in security namespace */
 #define ATTR_CREATE	0x0010	/* pure create: fail if attr already exists */
 #define ATTR_REPLACE	0x0020	/* pure set: fail if attr does not exist */
+#define ATTR_PARENT	0x0040	/*  use attrs in parent namespace */
 
 #define ATTR_KERNOTIME	0x1000	/* [kernel] don't update inode timestamps */
 #define ATTR_KERNOVAL	0x2000	/* [kernel] get attr size only, not value */
@@ -57,6 +58,7 @@ struct xfs_attr_list_context;
 	{ ATTR_SECURE,		"SECURE" }, \
 	{ ATTR_CREATE,		"CREATE" }, \
 	{ ATTR_REPLACE,		"REPLACE" }, \
+	{ ATTR_PARENT,		"PARENT" }, \
 	{ ATTR_KERNOTIME,	"KERNOTIME" }, \
 	{ ATTR_KERNOVAL,	"KERNOVAL" }
 
-- 
2.7.4

