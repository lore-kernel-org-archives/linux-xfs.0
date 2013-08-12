Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 76D157F59
	for <xfs@oss.sgi.com>; Mon, 12 Aug 2013 05:50:49 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 66DFF8F8049
	for <xfs@oss.sgi.com>; Mon, 12 Aug 2013 03:50:49 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	uwu6cPEfArO27zH2 for <xfs@oss.sgi.com>;
	Mon, 12 Aug 2013 03:50:48 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1V8phW-0004XZ-Op
	for xfs@oss.sgi.com; Mon, 12 Aug 2013 20:50:14 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1V8phW-00060v-O4
	for xfs@oss.sgi.com; Mon, 12 Aug 2013 20:50:14 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: ***** SUSPECTED SPAM ***** [PATCH 06/50] xfs: separate icreate log
	format definitions from xfs_icreate_item.h
Date: Mon, 12 Aug 2013 20:49:27 +1000
Message-Id: <1376304611-22994-7-git-send-email-david@fromorbit.com>
In-Reply-To: <1376304611-22994-1-git-send-email-david@fromorbit.com>
References: <1376304611-22994-1-git-send-email-david@fromorbit.com>
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
Reviewed-by: Brian Foster <bfoster@redhat.com>
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
