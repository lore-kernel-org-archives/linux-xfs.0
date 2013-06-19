Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 6C10F7FCC
	for <xfs@oss.sgi.com>; Wed, 19 Jun 2013 00:36:53 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id EE33EAC002
	for <xfs@oss.sgi.com>; Tue, 18 Jun 2013 22:36:52 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	7rH6d3Q38eFcBLru for <xfs@oss.sgi.com>;
	Tue, 18 Jun 2013 22:36:50 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1UpB4Z-0003Bz-OE
	for xfs@oss.sgi.com; Wed, 19 Jun 2013 15:36:47 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1UpB4U-0000Fq-8p
	for xfs@oss.sgi.com; Wed, 19 Jun 2013 15:36:42 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 32/50] xfs: separate icreate log format definitions from
	xfs_icreate_item.h
Date: Wed, 19 Jun 2013 15:35:55 +1000
Message-Id: <1371620173-712-33-git-send-email-david@fromorbit.com>
In-Reply-To: <1371620173-712-1-git-send-email-david@fromorbit.com>
References: <1371620173-712-1-git-send-email-david@fromorbit.com>
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

From: Dave Chinner <dchinner@redhat.com>

The on disk log format definitions for the icreate log item are
intertwined with the kernel-only in-memory log item definitions.
Separate the log format definitions out into their own header file
so they can easily be shared with userspace.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 include/Makefile                  |    2 +-
 include/libxfs.h                  |    2 +-
 include/libxlog.h                 |    2 +-
 include/xfs_icreate_item.h        |   22 +--------------------
 include/xfs_icreate_item_format.h |   39 +++++++++++++++++++++++++++++++++++++
 5 files changed, 43 insertions(+), 24 deletions(-)
 create mode 100644 include/xfs_icreate_item_format.h

diff --git a/include/Makefile b/include/Makefile
index 144e9dc..34a1fce 100644
--- a/include/Makefile
+++ b/include/Makefile
@@ -30,7 +30,7 @@ QAHFILES = libxfs.h libxlog.h \
 	xfs_extfree_item_format.h \
 	xfs_ialloc.h \
 	xfs_ialloc_btree.h \
-	xfs_icreate_item.h \
+	xfs_icreate_item_format.h \
 	xfs_inode_buf.h \
 	xfs_inode_fork.h \
 	xfs_inode_item_format.h \
diff --git a/include/libxfs.h b/include/libxfs.h
index 6448bc9..7070c2e 100644
--- a/include/libxfs.h
+++ b/include/libxfs.h
@@ -56,7 +56,7 @@
 #include <xfs/xfs_bmap.h>
 #include <xfs/xfs_trace.h>
 #include <xfs/xfs_symlink.h>
-#include <xfs/xfs_icreate_item.h>
+#include <xfs/xfs_icreate_item_format.h>
 #include <xfs/xfs_trans.h>
 
 #ifndef ARRAY_SIZE
diff --git a/include/libxlog.h b/include/libxlog.h
index 9570ae1..f837f84 100644
--- a/include/libxlog.h
+++ b/include/libxlog.h
@@ -51,7 +51,7 @@ struct xlog {
 #include <xfs/xfs_buf_item_format.h>
 #include <xfs/xfs_inode_item_format.h>
 #include <xfs/xfs_extfree_item_format.h>
-#include <xfs/xfs_icreate_item.h>
+#include <xfs/xfs_icreate_item_format.h>
 
 typedef union {
 	xlog_rec_header_t       hic_header;
diff --git a/include/xfs_icreate_item.h b/include/xfs_icreate_item.h
index 79df981..e796608 100644
--- a/include/xfs_icreate_item.h
+++ b/include/xfs_icreate_item.h
@@ -18,25 +18,7 @@
 #ifndef XFS_ICREATE_ITEM_H
 #define XFS_ICREATE_ITEM_H	1
 
-/*
- * on disk log item structure
- *
- * Log recovery assumes the first two entries are the type and size and they fit
- * in 32 bits. Also in host order (ugh) so they have to be 32 bit aligned so
- * decoding can be done correctly.
- */
-struct xfs_icreate_log {
-	__uint16_t	icl_type;	/* type of log format structure */
-	__uint16_t	icl_size;	/* size of log format structure */
-	__be32		icl_ag;		/* ag being allocated in */
-	__be32		icl_agbno;	/* start block of inode range */
-	__be32		icl_count;	/* number of inodes to initialise */
-	__be32		icl_isize;	/* size of inodes */
-	__be32		icl_length;	/* length of extent to initialise */
-	__be32		icl_gen;	/* inode generation number to use */
-};
-
-#ifdef __KERNEL__
+#include "xfs_icreate_item_format.h"
 
 /* in memory log item structure */
 struct xfs_icreate_item {
@@ -51,6 +33,4 @@ void xfs_icreate_log(struct xfs_trans *tp, xfs_agnumber_t agno,
 			unsigned int inode_size, xfs_agblock_t length,
 			unsigned int generation);
 
-#endif /* __KERNEL__ */
-
 #endif	/* XFS_ICREATE_ITEM_H */
diff --git a/include/xfs_icreate_item_format.h b/include/xfs_icreate_item_format.h
new file mode 100644
index 0000000..0299652
--- /dev/null
+++ b/include/xfs_icreate_item_format.h
@@ -0,0 +1,39 @@
+/*
+ * Copyright (c) 2008-2010, Dave Chinner
+ * All Rights Reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it would be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write the Free Software Foundation,
+ * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+#ifndef __XFS_ICREATE_ITEM_FORMAT_H__
+#define __XFS_ICREATE_ITEM_FORMAT_H__	1
+
+/*
+ * on disk log item structure
+ *
+ * Log recovery assumes the first two entries are the type and size and they fit
+ * in 32 bits. Also in host order (ugh) so they have to be 32 bit aligned so
+ * decoding can be done correctly.
+ */
+struct xfs_icreate_log {
+	__uint16_t	icl_type;	/* type of log format structure */
+	__uint16_t	icl_size;	/* size of log format structure */
+	__be32		icl_ag;		/* ag being allocated in */
+	__be32		icl_agbno;	/* start block of inode range */
+	__be32		icl_count;	/* number of inodes to initialise */
+	__be32		icl_isize;	/* size of inodes */
+	__be32		icl_length;	/* length of extent to initialise */
+	__be32		icl_gen;	/* inode generation number to use */
+};
+
+#endif	/* __XFS_ICREATE_ITEM_FORMAT_H__ */
-- 
1.7.10.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
