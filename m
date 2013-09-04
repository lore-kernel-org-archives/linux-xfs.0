Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id EB44E7F58
	for <xfs@oss.sgi.com>; Wed,  4 Sep 2013 17:06:11 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id CD5ED304039
	for <xfs@oss.sgi.com>; Wed,  4 Sep 2013 15:06:11 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	ARItd3R9vMD4LRqy for <xfs@oss.sgi.com>;
	Wed, 04 Sep 2013 15:06:10 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1VHLD9-0007cl-GL
	for xfs@oss.sgi.com; Thu, 05 Sep 2013 08:06:03 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1VHLD9-0003rC-FD
	for xfs@oss.sgi.com; Thu, 05 Sep 2013 08:06:03 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 01/55] xfsprogs: introduce xfs_icreate.h
Date: Thu,  5 Sep 2013 08:05:05 +1000
Message-Id: <1378332359-14737-2-git-send-email-david@fromorbit.com>
In-Reply-To: <1378332359-14737-1-git-send-email-david@fromorbit.com>
References: <1378332359-14737-1-git-send-email-david@fromorbit.com>
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

Bring the new inode create item definitions across from kernel space
for xfs_logprint to be able to parse.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 include/Makefile           |  2 +-
 include/xfs_icreate_item.h | 52 ++++++++++++++++++++++++++++++++++++++++++++++
 include/xfs_log.h          |  3 ++-
 include/xfs_trans.h        |  7 +++++--
 4 files changed, 60 insertions(+), 4 deletions(-)
 create mode 100644 include/xfs_icreate_item.h

diff --git a/include/Makefile b/include/Makefile
index 92161bd..ba2c80d 100644
--- a/include/Makefile
+++ b/include/Makefile
@@ -26,7 +26,7 @@ QAHFILES = libxfs.h libxlog.h \
 	xfs_btree_trace.h xfs_buf_item.h xfs_cksum.h xfs_da_btree.h \
 	xfs_dinode.h xfs_dir2.h xfs_dir2_format.h \
 	xfs_extfree_item.h xfs_ialloc.h xfs_ialloc_btree.h \
-	xfs_inode.h xfs_inode_item.h xfs_inum.h \
+	xfs_icreate_item.h xfs_inode.h xfs_inode_item.h xfs_inum.h \
 	xfs_log.h xfs_log_priv.h xfs_log_recover.h xfs_metadump.h \
 	xfs_mount.h xfs_quota.h xfs_rtalloc.h xfs_sb.h xfs_symlink.h \
 	xfs_trace.h xfs_trans.h xfs_trans_space.h xfs_dfrag.h
diff --git a/include/xfs_icreate_item.h b/include/xfs_icreate_item.h
new file mode 100644
index 0000000..88ba8aa
--- /dev/null
+++ b/include/xfs_icreate_item.h
@@ -0,0 +1,52 @@
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
+#ifndef XFS_ICREATE_ITEM_H
+#define XFS_ICREATE_ITEM_H	1
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
+/* in memory log item structure */
+struct xfs_icreate_item {
+	struct xfs_log_item	ic_item;
+	struct xfs_icreate_log	ic_format;
+};
+
+extern kmem_zone_t *xfs_icreate_zone;	/* inode create item zone */
+
+void xfs_icreate_log(struct xfs_trans *tp, xfs_agnumber_t agno,
+			xfs_agblock_t agbno, unsigned int count,
+			unsigned int inode_size, xfs_agblock_t length,
+			unsigned int generation);
+
+#endif	/* XFS_ICREATE_ITEM_H */
diff --git a/include/xfs_log.h b/include/xfs_log.h
index 5caee96..70cc014 100644
--- a/include/xfs_log.h
+++ b/include/xfs_log.h
@@ -88,7 +88,8 @@ static inline xfs_lsn_t	_lsn_cmp(xfs_lsn_t lsn1, xfs_lsn_t lsn2)
 #define XLOG_REG_TYPE_UNMOUNT		17
 #define XLOG_REG_TYPE_COMMIT		18
 #define XLOG_REG_TYPE_TRANSHDR		19
-#define XLOG_REG_TYPE_MAX		19
+#define XLOG_REG_TYPE_ICREATE		20
+#define XLOG_REG_TYPE_MAX		20
 
 typedef struct xfs_log_iovec {
 	void		*i_addr;	/* beginning address of region */
diff --git a/include/xfs_trans.h b/include/xfs_trans.h
index acf1381..36a0026 100644
--- a/include/xfs_trans.h
+++ b/include/xfs_trans.h
@@ -48,6 +48,7 @@ typedef struct xfs_trans_header {
 #define	XFS_LI_BUF		0x123c	/* v2 bufs, variable sized inode bufs */
 #define	XFS_LI_DQUOT		0x123d
 #define	XFS_LI_QUOTAOFF		0x123e
+#define	XFS_LI_ICREATE		0x123f
 
 #define XFS_LI_TYPE_DESC \
 	{ XFS_LI_EFI,		"XFS_LI_EFI" }, \
@@ -56,7 +57,8 @@ typedef struct xfs_trans_header {
 	{ XFS_LI_INODE,		"XFS_LI_INODE" }, \
 	{ XFS_LI_BUF,		"XFS_LI_BUF" }, \
 	{ XFS_LI_DQUOT,		"XFS_LI_DQUOT" }, \
-	{ XFS_LI_QUOTAOFF,	"XFS_LI_QUOTAOFF" }
+	{ XFS_LI_QUOTAOFF,	"XFS_LI_QUOTAOFF" }, \
+	{ XFS_LI_ICREATE,	"XFS_LI_ICREATE" }
 
 /*
  * Transaction types.  Used to distinguish types of buffers.
@@ -107,7 +109,8 @@ typedef struct xfs_trans_header {
 #define	XFS_TRANS_SWAPEXT		40
 #define	XFS_TRANS_SB_COUNT		41
 #define	XFS_TRANS_CHECKPOINT		42
-#define	XFS_TRANS_TYPE_MAX		42
+#define	XFS_TRANS_ICREATE		43
+#define	XFS_TRANS_TYPE_MAX		43
 /* new transaction types need to be reflected in xfs_logprint(8) */
 
 #define XFS_TRANS_TYPES \
-- 
1.8.3.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
