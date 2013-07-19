Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 491E07FA9
	for <xfs@oss.sgi.com>; Fri, 19 Jul 2013 01:25:55 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 3A3DF8F8033
	for <xfs@oss.sgi.com>; Thu, 18 Jul 2013 23:25:55 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	k7VOIejWd8fMrL93 for <xfs@oss.sgi.com>;
	Thu, 18 Jul 2013 23:25:53 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1V0482-000488-Oc
	for xfs@oss.sgi.com; Fri, 19 Jul 2013 16:25:22 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1V0482-0001xf-Nj
	for xfs@oss.sgi.com; Fri, 19 Jul 2013 16:25:22 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 13/49] xfs: move unrealted definitions out of xfs_inode.h
Date: Fri, 19 Jul 2013 16:24:44 +1000
Message-Id: <1374215120-7271-14-git-send-email-david@fromorbit.com>
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

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_ialloc.c     |  1 +
 fs/xfs/xfs_icache.h     |  7 +++++++
 fs/xfs/xfs_inode.h      | 38 --------------------------------------
 fs/xfs/xfs_log_format.h |  8 ++++++++
 4 files changed, 16 insertions(+), 38 deletions(-)

diff --git a/fs/xfs/xfs_ialloc.c b/fs/xfs/xfs_ialloc.c
index 7a0c17d..bd4e2a7 100644
--- a/fs/xfs/xfs_ialloc.c
+++ b/fs/xfs/xfs_ialloc.c
@@ -39,6 +39,7 @@
 #include "xfs_cksum.h"
 #include "xfs_buf_item.h"
 #include "xfs_icreate_item.h"
+#include "xfs_icache.h"
 
 
 /*
diff --git a/fs/xfs/xfs_icache.h b/fs/xfs/xfs_icache.h
index a01afbb..e3f2ee0 100644
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
index bf0f714..0bd034a 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -34,37 +34,6 @@ struct xfs_imap {
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
 
 struct xfs_buf;
@@ -400,13 +369,6 @@ do { \
 
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
diff --git a/fs/xfs/xfs_log_format.h b/fs/xfs/xfs_log_format.h
index faf3f43..198381e 100644
--- a/fs/xfs/xfs_log_format.h
+++ b/fs/xfs/xfs_log_format.h
@@ -393,6 +393,14 @@ struct xfs_log_item_desc {
 #define	XFS_DQUOT_REF		1
 
 /*
+ * Flags for xfs_trans_ichgtime().
+ */
+#define	XFS_ICHGTIME_MOD	0x1	/* data fork modification timestamp */
+#define	XFS_ICHGTIME_CHG	0x2	/* inode field change timestamp */
+#define	XFS_ICHGTIME_CREATE	0x4	/* inode create timestamp */
+
+
+/*
  * Inode Log Item Format definitions.
  *
  * This is the structure used to lay out an inode log item in the
-- 
1.8.3.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
