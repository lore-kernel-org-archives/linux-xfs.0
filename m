Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q27HL2Ws134562 for <xfs@oss.sgi.com>; Wed, 7 Mar 2012 11:21:03 -0600
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id flvzehFiCqHgCRWw for
	<xfs@oss.sgi.com>; Wed, 07 Mar 2012 09:21:01 -0800 (PST)
Message-ID: <4F5798F9.2050809@redhat.com>
Date: Wed, 07 Mar 2012 11:20:57 -0600
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: [PATCH] default to 64 bit inodes & add feature flag
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs-oss <xfs@oss.sgi.com>
Cc: Josef 'Jeff' Sipek <jeffpc@josefsipek.net>, Dave Chinner <dchinner@redhat.com>

From: Dave Chinner <dchinner@redhat.com>

Default to allowing 64-bit inodes on the filesystem.

Add a feature bit to the the superblock to record whether 64 bit inodes have
been allocated on the filesystem or not. This allows us to reject mounting the
filesytem with inode32 if 64 bit inodes are present.

Once a 64 bitinode is allocated, the inode64 superblock feature bit will be set.
Once the superblock feature bit is set, the filesystem will default to 64 bit
inodes regardless of whether inode64 is specified as a mount option.

To ensure only 32 bit inodes are created, the inode32 mount option must be
used. If there are already 64 bit inodes as flagged by the superblock feature
bit, then the inode32 mount will be refused.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---

Passing this along to revive the old discussion ... 
Thanks,
-Eric

diff --git a/fs/xfs/xfs_ialloc.c b/fs/xfs/xfs_ialloc.c
index dad1a31..c80790e 100644
--- a/fs/xfs/xfs_ialloc.c
+++ b/fs/xfs/xfs_ialloc.c
@@ -1011,6 +1011,19 @@ alloc_inode:
 	xfs_btree_del_cursor(cur, XFS_BTREE_NOERROR);
 	xfs_trans_mod_sb(tp, XFS_TRANS_SB_IFREE, -1);
 	xfs_perag_put(pag);
+
+	/* set the inode64 feature bit if necessary */
+	if (ino > XFS_MAXINUMBER_32 &&
+	    !xfs_sb_version_hasinode64(&mp->m_sb)) {
+		spin_lock(&mp->m_sb_lock);
+		if (!xfs_sb_version_hasinode64(&mp->m_sb)) {
+			xfs_sb_version_addinode64(&mp->m_sb);
+			spin_unlock(&mp->m_sb_lock);
+			xfs_mod_sb(tp, XFS_SB_VERSIONNUM | XFS_SB_FEATURES2);
+		} else
+			spin_unlock(&mp->m_sb_lock);
+	}
+
 	*inop = ino;
 	return 0;
 error1:
diff --git a/fs/xfs/xfs_sb.h b/fs/xfs/xfs_sb.h
index cb6ae71..5e28c99 100644
--- a/fs/xfs/xfs_sb.h
+++ b/fs/xfs/xfs_sb.h
@@ -80,6 +80,7 @@ struct xfs_mount;
 #define XFS_SB_VERSION2_RESERVED4BIT	0x00000004
 #define XFS_SB_VERSION2_ATTR2BIT	0x00000008	/* Inline attr rework */
 #define XFS_SB_VERSION2_PARENTBIT	0x00000010	/* parent pointers */
+#define XFS_SB_VERSION2_INODE64		0x00000020	/* 64 bit inodes */
 #define XFS_SB_VERSION2_PROJID32BIT	0x00000080	/* 32 bit project id */
 
 #define	XFS_SB_VERSION2_OKREALFBITS	\
@@ -503,6 +504,18 @@ static inline int xfs_sb_version_hasprojid32bit(xfs_sb_t *sbp)
 		(sbp->sb_features2 & XFS_SB_VERSION2_PROJID32BIT);
 }
 
+static inline int xfs_sb_version_hasinode64(xfs_sb_t *sbp)
+{
+	return xfs_sb_version_hasmorebits(sbp) &&
+		(sbp->sb_features2 & XFS_SB_VERSION2_INODE64);
+}
+
+static inline void xfs_sb_version_addinode64(xfs_sb_t *sbp)
+{
+	sbp->sb_versionnum |= XFS_SB_VERSION_MOREBITSBIT;
+	sbp->sb_features2 |= XFS_SB_VERSION2_INODE64;
+}
+
 /*
  * end of superblock version macros
  */
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index ee5b695..376a12d 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -88,6 +88,7 @@ mempool_t *xfs_ioend_pool;
 #define MNTOPT_BARRIER	"barrier"	/* use writer barriers for log write and
 					 * unwritten extent conversion */
 #define MNTOPT_NOBARRIER "nobarrier"	/* .. disable */
+#define MNTOPT_32BITINODE   "inode32"	/* inodes allowed in first 32 bits */
 #define MNTOPT_64BITINODE   "inode64"	/* inodes can be allocated anywhere */
 #define MNTOPT_IKEEP	"ikeep"		/* do not free empty inode clusters */
 #define MNTOPT_NOIKEEP	"noikeep"	/* free empty inode clusters */
@@ -198,7 +199,8 @@ xfs_parseargs(
 	 */
 	mp->m_flags |= XFS_MOUNT_BARRIER;
 	mp->m_flags |= XFS_MOUNT_COMPAT_IOSIZE;
-	mp->m_flags |= XFS_MOUNT_SMALL_INUMS;
+	if (!xfs_sb_version_hasinode64(&mp->m_sb))
+		mp->m_flags |= XFS_MOUNT_SMALL_INUMS;
 
 	/*
 	 * These can be overridden by the mount option parsing.
@@ -295,6 +297,15 @@ xfs_parseargs(
 				return EINVAL;
 			}
 			dswidth = simple_strtoul(value, &eov, 10);
+		} else if (!strcmp(this_char, MNTOPT_32BITINODE)) {
+			if (xfs_sb_version_hasinode64(&mp->m_sb)) {
+				xfs_warn(mp,
+					"XFS: 64 bit inodes present. "
+					"%s option not allowed on this system",
+					this_char);
+				return EINVAL;
+			}
+			mp->m_flags |= ~XFS_MOUNT_SMALL_INUMS;
 		} else if (!strcmp(this_char, MNTOPT_64BITINODE)) {
 			mp->m_flags &= ~XFS_MOUNT_SMALL_INUMS;
 #if !XFS_BIG_INUMS
@@ -494,6 +505,7 @@ xfs_showargs(
 		{ XFS_MOUNT_FILESTREAMS,	"," MNTOPT_FILESTREAM },
 		{ XFS_MOUNT_GRPID,		"," MNTOPT_GRPID },
 		{ XFS_MOUNT_DISCARD,		"," MNTOPT_DISCARD },
+		{ XFS_MOUNT_SMALL_INUMS, 	"," MNTOPT_32BITINODE },
 		{ 0, NULL }
 	};
 	static struct proc_xfs_info xfs_info_unset[] = {

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
