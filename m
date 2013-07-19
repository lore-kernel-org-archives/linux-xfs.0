Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 9EC768096
	for <xfs@oss.sgi.com>; Fri, 19 Jul 2013 01:45:52 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 80F6230404E
	for <xfs@oss.sgi.com>; Thu, 18 Jul 2013 23:45:52 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	oMMjGE79QE9CFSJV for <xfs@oss.sgi.com>;
	Thu, 18 Jul 2013 23:45:50 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1V04RS-0004Ih-Vf
	for xfs@oss.sgi.com; Fri, 19 Jul 2013 16:45:27 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1V04RS-0002Kj-Uj
	for xfs@oss.sgi.com; Fri, 19 Jul 2013 16:45:26 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 21/49] xfs: separate icreate log format definitions from
	xfs_icreate_item.h
Date: Fri, 19 Jul 2013 16:44:56 +1000
Message-Id: <1374216324-8781-22-git-send-email-david@fromorbit.com>
In-Reply-To: <1374216324-8781-1-git-send-email-david@fromorbit.com>
References: <1374216324-8781-1-git-send-email-david@fromorbit.com>
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
 include/Makefile           |  1 -
 include/libxfs.h           |  1 -
 include/libxlog.h          |  1 -
 include/xfs_icreate_item.h | 55 ----------------------------------------------
 include/xfs_log_format.h   | 18 +++++++++++++++
 5 files changed, 18 insertions(+), 58 deletions(-)
 delete mode 100644 include/xfs_icreate_item.h

diff --git a/include/Makefile b/include/Makefile
index 8f738a8..ab71aad 100644
--- a/include/Makefile
+++ b/include/Makefile
@@ -30,7 +30,6 @@ QAHFILES = libxfs.h libxlog.h \
 	xfs_format.h \
 	xfs_ialloc.h \
 	xfs_ialloc_btree.h \
-	xfs_icreate_item.h \
 	xfs_inode.h \
 	xfs_inum.h \
 	xfs_log_format.h \
diff --git a/include/libxfs.h b/include/libxfs.h
index 646ca79..bc90082 100644
--- a/include/libxfs.h
+++ b/include/libxfs.h
@@ -59,7 +59,6 @@
 #include <xfs/xfs_bmap.h>
 #include <xfs/xfs_trace.h>
 #include <xfs/xfs_symlink.h>
-#include <xfs/xfs_icreate_item.h>
 
 
 #ifndef ARRAY_SIZE
diff --git a/include/libxlog.h b/include/libxlog.h
index ee23212..e65b607 100644
--- a/include/libxlog.h
+++ b/include/libxlog.h
@@ -48,7 +48,6 @@ struct xlog {
 };
 
 #include <xfs/xfs_log_recover.h>
-#include <xfs/xfs_icreate_item.h>
 
 /*
  * macros mapping kernel code to user code
diff --git a/include/xfs_icreate_item.h b/include/xfs_icreate_item.h
deleted file mode 100644
index 70dc03c..0000000
--- a/include/xfs_icreate_item.h
+++ /dev/null
@@ -1,55 +0,0 @@
-/*
- * Copyright (c) 2008-2010, Dave Chinner
- * All Rights Reserved.
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License as
- * published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it would be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write the Free Software Foundation,
- * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
- */
-#ifndef XFS_ICREATE_ITEM_H
-#define XFS_ICREATE_ITEM_H	1
-
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
-
-/* in memory log item structure */
-struct xfs_icreate_item {
-	struct xfs_log_item	ic_item;
-	struct xfs_icreate_log	ic_format;
-};
-
-extern kmem_zone_t *xfs_icreate_zone;	/* inode create item zone */
-
-void xfs_icreate_log(struct xfs_trans *tp, xfs_agnumber_t agno,
-			xfs_agblock_t agbno, unsigned int count,
-			unsigned int inode_size, xfs_agblock_t length,
-			unsigned int generation);
-#endif /* __KERNEL__ */
-
-#endif	/* XFS_ICREATE_ITEM_H */
diff --git a/include/xfs_log_format.h b/include/xfs_log_format.h
index 5963ec7..02639c7 100644
--- a/include/xfs_log_format.h
+++ b/include/xfs_log_format.h
@@ -602,4 +602,22 @@ typedef struct xfs_qoff_logformat {
 #define XFS_ALL_QUOTA_CHKD	\
 		(XFS_UQUOTA_CHKD | XFS_GQUOTA_CHKD | XFS_PQUOTA_CHKD)
 
+/*
+ * Inode create log item structure
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
 #endif /* __XFS_LOG_FORMAT_H__ */
-- 
1.8.3.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
