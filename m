Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 286697FED
	for <xfs@oss.sgi.com>; Wed, 19 Jun 2013 00:36:55 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 24C628F8033
	for <xfs@oss.sgi.com>; Tue, 18 Jun 2013 22:36:55 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	sMiWhMOHScDoZXGD for <xfs@oss.sgi.com>;
	Tue, 18 Jun 2013 22:36:53 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1UpB4Z-0003BY-Fw
	for xfs@oss.sgi.com; Wed, 19 Jun 2013 15:36:47 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1UpB4U-0000FW-3Z
	for xfs@oss.sgi.com; Wed, 19 Jun 2013 15:36:42 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 27/50] xfs: move unrealted definitions out of xfs_inode.h
Date: Wed, 19 Jun 2013 15:35:50 +1000
Message-Id: <1371620173-712-28-git-send-email-david@fromorbit.com>
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

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 include/xfs_inode.h |   38 --------------------------------------
 include/xfs_trans.h |    7 +++++++
 libxfs/xfs.h        |    3 +++
 3 files changed, 10 insertions(+), 38 deletions(-)

diff --git a/include/xfs_inode.h b/include/xfs_inode.h
index 7450b74..ec092b1 100644
--- a/include/xfs_inode.h
+++ b/include/xfs_inode.h
@@ -32,50 +32,12 @@ struct xfs_imap {
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
-
-/*
- * Flags for xfs_ichgtime().
- */
-#define	XFS_ICHGTIME_MOD	0x1	/* data fork modification timestamp */
-#define	XFS_ICHGTIME_CHG	0x2	/* inode field change timestamp */
-#define	XFS_ICHGTIME_CREATE	0x4	/* inode create timestamp */
-
-
 #ifdef __KERNEL__
 
 #include "xfs_inode_ops.h"
 
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
diff --git a/include/xfs_trans.h b/include/xfs_trans.h
index 21cafaa..4654b58 100644
--- a/include/xfs_trans.h
+++ b/include/xfs_trans.h
@@ -227,6 +227,13 @@ struct xfs_log_item_desc {
 #define	XFS_ATTR_BTREE_REF	1
 #define	XFS_DQUOT_REF		1
 
+/*
+ * Flags for xfs_trans_ichgtime().
+ */
+#define	XFS_ICHGTIME_MOD	0x1	/* data fork modification timestamp */
+#define	XFS_ICHGTIME_CHG	0x2	/* inode field change timestamp */
+#define	XFS_ICHGTIME_CREATE	0x4	/* inode create timestamp */
+
 #ifdef __KERNEL__
 
 struct xfs_buf;
diff --git a/libxfs/xfs.h b/libxfs/xfs.h
index acf5895..0113b50 100644
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
1.7.10.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
