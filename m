Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 696C829E4D
	for <xfs@oss.sgi.com>; Wed,  4 Sep 2013 17:21:46 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 4BC86304039
	for <xfs@oss.sgi.com>; Wed,  4 Sep 2013 15:21:46 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	7kVw9skQbMHsg7pF for <xfs@oss.sgi.com>;
	Wed, 04 Sep 2013 15:21:44 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1VHLDA-0007dm-1u
	for xfs@oss.sgi.com; Thu, 05 Sep 2013 08:06:04 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1VHLDA-0003tN-1Z
	for xfs@oss.sgi.com; Thu, 05 Sep 2013 08:06:04 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 28/55] xfs: move unrealted definitions out of xfs_inode.h
Date: Thu,  5 Sep 2013 08:05:32 +1000
Message-Id: <1378332359-14737-29-git-send-email-david@fromorbit.com>
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

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 include/Makefile         |  1 +
 include/libxfs.h         |  1 +
 include/xfs_inode.h      | 36 ------------------------------------
 include/xfs_log_format.h |  7 +++++++
 libxfs/xfs.h             |  3 +++
 5 files changed, 12 insertions(+), 36 deletions(-)

diff --git a/include/Makefile b/include/Makefile
index 94cb8e0..a8a4311 100644
--- a/include/Makefile
+++ b/include/Makefile
@@ -31,6 +31,7 @@ QAHFILES = libxfs.h libxlog.h \
 	xfs_ialloc.h \
 	xfs_ialloc_btree.h \
 	xfs_inode.h \
+	xfs_inode_fork.h \
 	xfs_inum.h \
 	xfs_log_format.h \
 	xfs_log_recover.h \
diff --git a/include/libxfs.h b/include/libxfs.h
index 6d96c41..05aac34 100644
--- a/include/libxfs.h
+++ b/include/libxfs.h
@@ -54,6 +54,7 @@
 #include <xfs/xfs_ialloc_btree.h>
 #include <xfs/xfs_attr_sf.h>
 #include <xfs/xfs_dinode.h>
+#include <xfs/xfs_inode_fork.h>
 #include <xfs/xfs_inode.h>
 #include <xfs/xfs_alloc.h>
 #include <xfs/xfs_btree.h>
diff --git a/include/xfs_inode.h b/include/xfs_inode.h
index 6ee8bb7..99c034e 100644
--- a/include/xfs_inode.h
+++ b/include/xfs_inode.h
@@ -34,35 +34,6 @@ struct xfs_imap {
 	ushort		im_boffset;	/* inode offset in block in bytes */
 };
 
-/*
- * This is the xfs in-core inode structure.
- * Most of the on-disk inode is embedded in the i_d field.
- *
- * The extent pointers/inline file space, however, are managed
- * separately.  The memory for this information is pointed to by
- * the if_u1 unions depending on the type of the data.
- * This is used to linearize the array of extents for fast in-core
- * access.  This is used until the file's number of extents
- * surpasses XFS_MAX_INCORE_EXTENTS, at which point all extent pointers
- * are accessed through the buffer cache.
- *
- * Other state kept in the in-core inode is used for identification,
- * locking, transactional updating, etc of the inode.
- *
- * Generally, we do not want to hold the i_rlock while holding the
- * i_ilock. Hierarchy is i_iolock followed by i_rlock.
- *
- * xfs_iptr_t contains all the inode fields up to and including the
- * i_mnext and i_mprev fields, it is used as a marker in the inode
- * chain off the mount structure by xfs_sync calls.
- */
-/*
- * Flags for xfs_ichgtime().
- */
-#define	XFS_ICHGTIME_MOD	0x1	/* data fork modification timestamp */
-#define	XFS_ICHGTIME_CHG	0x2	/* inode field change timestamp */
-#define	XFS_ICHGTIME_CREATE	0x4	/* inode create timestamp */
-
 
 #ifdef __KERNEL__
 
@@ -398,13 +369,6 @@ do { \
 
 #endif /* __KERNEL__ */
 
-/*
- * Flags for xfs_iget()
- */
-#define XFS_IGET_CREATE		0x1
-#define XFS_IGET_UNTRUSTED	0x2
-#define XFS_IGET_DONTCACHE	0x4
-
 int		xfs_imap_to_bp(struct xfs_mount *, struct xfs_trans *,
 			       struct xfs_imap *, struct xfs_dinode **,
 			       struct xfs_buf **, uint, uint);
diff --git a/include/xfs_log_format.h b/include/xfs_log_format.h
index 13a0734..f57975d 100644
--- a/include/xfs_log_format.h
+++ b/include/xfs_log_format.h
@@ -392,6 +392,13 @@ struct xfs_log_item_desc {
 #define	XFS_ATTR_BTREE_REF	1
 #define	XFS_DQUOT_REF		1
 
+/*
+ * Flags for xfs_trans_ichgtime().
+ */
+#define	XFS_ICHGTIME_MOD	0x1	/* data fork modification timestamp */
+#define	XFS_ICHGTIME_CHG	0x2	/* inode field change timestamp */
+#define	XFS_ICHGTIME_CREATE	0x4	/* inode create timestamp */
+
 
 /*
  * Inode Log Item Format definitions.
diff --git a/libxfs/xfs.h b/libxfs/xfs.h
index 7149c09..1a01c61 100644
--- a/libxfs/xfs.h
+++ b/libxfs/xfs.h
@@ -68,6 +68,9 @@ typedef __uint32_t		inst_t;		/* an instruction */
 
 #define IHOLD(ip)			((void) 0)
 
+#define XFS_IGET_CREATE			0x1
+#define XFS_IGET_UNTRUSTED		0x2
+
 /* stop unused var warnings by assigning mp to itself */
 #define XFS_CORRUPTION_ERROR(e,l,mp,m)	do { \
 	(mp) = (mp); \
-- 
1.8.3.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
