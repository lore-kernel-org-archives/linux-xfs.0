Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id D489729E68
	for <xfs@oss.sgi.com>; Tue, 18 Jun 2013 23:52:21 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id D05B6304043
	for <xfs@oss.sgi.com>; Tue, 18 Jun 2013 21:52:21 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	JoKxGaIUgldNDWpi for <xfs@oss.sgi.com>;
	Tue, 18 Jun 2013 21:52:20 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1UpANV-0002zw-NS
	for xfs@oss.sgi.com; Wed, 19 Jun 2013 14:52:17 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1UpANV-00006B-KG
	for xfs@oss.sgi.com; Wed, 19 Jun 2013 14:52:17 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 33/60] xfs: move unrealted definitions out of xfs_inode.h
Date: Wed, 19 Jun 2013 14:50:41 +1000
Message-Id: <1371617468-32559-34-git-send-email-david@fromorbit.com>
In-Reply-To: <1371617468-32559-1-git-send-email-david@fromorbit.com>
References: <1371617468-32559-1-git-send-email-david@fromorbit.com>
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
 fs/xfs/xfs_ialloc.c |    1 +
 fs/xfs/xfs_icache.h |    7 +++++++
 fs/xfs/xfs_inode.h  |   38 --------------------------------------
 fs/xfs/xfs_trans.h  |    7 +++++++
 4 files changed, 15 insertions(+), 38 deletions(-)

diff --git a/fs/xfs/xfs_ialloc.c b/fs/xfs/xfs_ialloc.c
index 96a53bd..2de4b4c 100644
--- a/fs/xfs/xfs_ialloc.c
+++ b/fs/xfs/xfs_ialloc.c
@@ -39,6 +39,7 @@
 #include "xfs_cksum.h"
 #include "xfs_buf_item.h"
 #include "xfs_icreate_item.h"
+#include "xfs_icache.h"
 
 
 /*
diff --git a/fs/xfs/xfs_icache.h b/fs/xfs/xfs_icache.h
index e0f138c..20179ae 100644
--- a/fs/xfs/xfs_icache.h
+++ b/fs/xfs/xfs_icache.h
@@ -24,6 +24,13 @@ struct xfs_perag;
 #define SYNC_WAIT		0x0001	/* wait for i/o to complete */
 #define SYNC_TRYLOCK		0x0002  /* only try to lock inodes */
 
+/*
+ * Flags for xfs_iget()
+ */
+#define XFS_IGET_CREATE		0x1
+#define XFS_IGET_UNTRUSTED	0x2
+#define XFS_IGET_DONTCACHE	0x4
+
 int xfs_iget(struct xfs_mount *mp, struct xfs_trans *tp, xfs_ino_t ino,
 	     uint flags, uint lock_flags, xfs_inode_t **ipp);
 
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index a55d68b..3f8c56a 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -32,53 +32,15 @@ struct xfs_imap {
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
 #include "xfs_inode_fork.h"
 #include "xfs_inode_item_format.h"
 
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
diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
index 21cafaa..4654b58 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
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
-- 
1.7.10.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
