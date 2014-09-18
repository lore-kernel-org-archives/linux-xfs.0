Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 245087F37
	for <xfs@oss.sgi.com>; Thu, 18 Sep 2014 15:11:28 -0500 (CDT)
Date: Thu, 18 Sep 2014 15:11:27 -0500
From: Ben Myers <bpm@sgi.com>
Subject: [PATCH 05/10] xfs: add a superblock feature bit to indicate UTF-8
	support.
Message-ID: <20140918201127.GG4482@sgi.com>
References: <20140918195650.GI19952@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140918195650.GI19952@sgi.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: linux-fsdevel@vger.kernel.org
Cc: tinguely@sgi.com, olaf@sgi.com, xfs@oss.sgi.com

From: Olaf Weber <olaf@sgi.com>

When UTF-8 support is enabled, the xfs_dir_ci_inode_operations must be
installed. Add xfs_sb_version_hasci(), which tests both the borgbit and
the utf8bit, and returns true if at least one of them is set. Replace
calls to xfs_sb_version_hasasciici() as needed.

Signed-off-by: Olaf Weber <olaf@sgi.com>
---
 fs/xfs/libxfs/xfs_sb.h | 24 +++++++++++++++++++++++-
 fs/xfs/xfs_fs.h        |  1 +
 fs/xfs/xfs_fsops.c     |  4 +++-
 fs/xfs/xfs_iops.c      |  4 ++--
 4 files changed, 29 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_sb.h b/fs/xfs/libxfs/xfs_sb.h
index 2e73970..525eacb 100644
--- a/fs/xfs/libxfs/xfs_sb.h
+++ b/fs/xfs/libxfs/xfs_sb.h
@@ -70,6 +70,7 @@ struct xfs_trans;
 #define XFS_SB_VERSION2_RESERVED4BIT	0x00000004
 #define XFS_SB_VERSION2_ATTR2BIT	0x00000008	/* Inline attr rework */
 #define XFS_SB_VERSION2_PARENTBIT	0x00000010	/* parent pointers */
+#define XFS_SB_VERSION2_UTF8BIT		0x00000020      /* utf8 names */
 #define XFS_SB_VERSION2_PROJID32BIT	0x00000080	/* 32 bit project id */
 #define XFS_SB_VERSION2_CRCBIT		0x00000100	/* metadata CRCs */
 #define XFS_SB_VERSION2_FTYPE		0x00000200	/* inode type in dir */
@@ -77,6 +78,7 @@ struct xfs_trans;
 #define	XFS_SB_VERSION2_OKBITS		\
 	(XFS_SB_VERSION2_LAZYSBCOUNTBIT	| \
 	 XFS_SB_VERSION2_ATTR2BIT	| \
+	 XFS_SB_VERSION2_UTF8BIT	| \
 	 XFS_SB_VERSION2_PROJID32BIT	| \
 	 XFS_SB_VERSION2_FTYPE)
 
@@ -509,8 +511,10 @@ xfs_sb_has_ro_compat_feature(
 }
 
 #define XFS_SB_FEAT_INCOMPAT_FTYPE	(1 << 0)	/* filetype in dirent */
+#define XFS_SB_FEAT_INCOMPAT_UTF8	(1 << 1)	/* utf-8 name support */
 #define XFS_SB_FEAT_INCOMPAT_ALL \
-		(XFS_SB_FEAT_INCOMPAT_FTYPE)
+		(XFS_SB_FEAT_INCOMPAT_FTYPE | \
+		 XFS_SB_FEAT_INCOMPAT_UTF8)
 
 #define XFS_SB_FEAT_INCOMPAT_UNKNOWN	~XFS_SB_FEAT_INCOMPAT_ALL
 static inline bool
@@ -558,6 +562,24 @@ static inline int xfs_sb_version_hasfinobt(xfs_sb_t *sbp)
 		(sbp->sb_features_ro_compat & XFS_SB_FEAT_RO_COMPAT_FINOBT);
 }
 
+static inline int xfs_sb_version_hasutf8(xfs_sb_t *sbp)
+{
+	return (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5 &&
+		xfs_sb_has_incompat_feature(sbp, XFS_SB_FEAT_INCOMPAT_UTF8)) ||
+		(xfs_sb_version_hasmorebits(sbp) &&
+		(sbp->sb_features2 & XFS_SB_VERSION2_UTF8BIT));
+}
+
+/*
+ * Special case: there are a number of places where we need to test
+ * both the borgbit and the utf8bit, and take the same action if
+ * either of those is set.
+ */
+static inline int xfs_sb_version_hasci(xfs_sb_t *sbp)
+{
+	return xfs_sb_version_hasasciici(sbp) || xfs_sb_version_hasutf8(sbp);
+}
+
 /*
  * end of superblock version macros
  */
diff --git a/fs/xfs/xfs_fs.h b/fs/xfs/xfs_fs.h
index 18dc721..e845d75 100644
--- a/fs/xfs/xfs_fs.h
+++ b/fs/xfs/xfs_fs.h
@@ -239,6 +239,7 @@ typedef struct xfs_fsop_resblks {
 #define XFS_FSOP_GEOM_FLAGS_V5SB	0x8000	/* version 5 superblock */
 #define XFS_FSOP_GEOM_FLAGS_FTYPE	0x10000	/* inode directory types */
 #define XFS_FSOP_GEOM_FLAGS_FINOBT	0x20000	/* free inode btree */
+#define XFS_FSOP_GEOM_FLAGS_UTF8	0x40000	/* utf8 filenames */
 
 /*
  * Minimum and maximum sizes need for growth checks.
diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index f91de1e..1a83eef 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -103,7 +103,9 @@ xfs_fs_geometry(
 			(xfs_sb_version_hasftype(&mp->m_sb) ?
 				XFS_FSOP_GEOM_FLAGS_FTYPE : 0) |
 			(xfs_sb_version_hasfinobt(&mp->m_sb) ?
-				XFS_FSOP_GEOM_FLAGS_FINOBT : 0);
+				XFS_FSOP_GEOM_FLAGS_FINOBT : 0) |
+			(xfs_sb_version_hasutf8(&mp->m_sb) ?
+				XFS_FSOP_GEOM_FLAGS_UTF8 : 0);
 		geo->logsectsize = xfs_sb_version_hassector(&mp->m_sb) ?
 				mp->m_sb.sb_logsectsize : BBSIZE;
 		geo->rtsectsize = mp->m_sb.sb_blocksize;
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 7212949..cea3d64 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -335,9 +335,9 @@ xfs_vn_unlink(
 	/*
 	 * With unlink, the VFS makes the dentry "negative": no inode,
 	 * but still hashed. This is incompatible with case-insensitive
-	 * mode, so invalidate (unhash) the dentry in CI-mode.
+	 * or utf8 mode, so invalidate (unhash) the dentry in CI-mode.
 	 */
-	if (xfs_sb_version_hasasciici(&XFS_M(dir->i_sb)->m_sb))
+	if (xfs_sb_version_hasci(&XFS_M(dir->i_sb)->m_sb))
 		d_invalidate(dentry);
 	return 0;
 }
-- 
1.7.12.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
