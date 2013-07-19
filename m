Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 361FE7F6B
	for <xfs@oss.sgi.com>; Fri, 19 Jul 2013 01:25:36 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id B7F54AC010
	for <xfs@oss.sgi.com>; Thu, 18 Jul 2013 23:25:35 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	Tg9Oj2Vww0teZCDi for <xfs@oss.sgi.com>;
	Thu, 18 Jul 2013 23:25:33 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1V0482-00047z-K9
	for xfs@oss.sgi.com; Fri, 19 Jul 2013 16:25:22 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1V0482-0001x5-JE
	for xfs@oss.sgi.com; Fri, 19 Jul 2013 16:25:22 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 06/49] xfs: separate icreate log format definitions from
	xfs_icreate_item.h
Date: Fri, 19 Jul 2013 16:24:37 +1000
Message-Id: <1374215120-7271-7-git-send-email-david@fromorbit.com>
In-Reply-To: <1374215120-7271-1-git-send-email-david@fromorbit.com>
References: <1374215120-7271-1-git-send-email-david@fromorbit.com>
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
 fs/xfs/xfs_icreate_item.h | 18 ------------------
 fs/xfs/xfs_log_format.h   | 18 ++++++++++++++++++
 2 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/fs/xfs/xfs_icreate_item.h b/fs/xfs/xfs_icreate_item.h
index 88ba8aa..59e89f8 100644
--- a/fs/xfs/xfs_icreate_item.h
+++ b/fs/xfs/xfs_icreate_item.h
@@ -18,24 +18,6 @@
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
 /* in memory log item structure */
 struct xfs_icreate_item {
 	struct xfs_log_item	ic_item;
diff --git a/fs/xfs/xfs_log_format.h b/fs/xfs/xfs_log_format.h
index 5963ec7..02639c7 100644
--- a/fs/xfs/xfs_log_format.h
+++ b/fs/xfs/xfs_log_format.h
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
