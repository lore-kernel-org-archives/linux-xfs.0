Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:38801 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751493AbcKEAVn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 4 Nov 2016 20:21:43 -0400
Subject: [PATCH 24/41] xfs: scrub symbolic links
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 04 Nov 2016 17:21:37 -0700
Message-ID: <147830529785.2155.17782599820575587904.stgit@birch.djwong.org>
In-Reply-To: <147830514302.2155.3920703176812208304.stgit@birch.djwong.org>
References: <147830514302.2155.3920703176812208304.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

Create the infrastructure to scrub symbolic link data.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_fs.h |    3 ++
 fs/xfs/xfs_scrub.c     |   58 ++++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_trace.h     |    3 ++
 3 files changed, 62 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index d6b702d..93a983c 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -591,7 +591,8 @@ struct xfs_scrub_metadata {
 #define XFS_SCRUB_TYPE_BMBTC	14	/* CoW fork block mapping */
 #define XFS_SCRUB_TYPE_DIR	15	/* directory */
 #define XFS_SCRUB_TYPE_XATTR	16	/* extended attribute */
-#define XFS_SCRUB_TYPE_MAX	16
+#define XFS_SCRUB_TYPE_SYMLINK	17	/* symbolic link */
+#define XFS_SCRUB_TYPE_MAX	17
 
 #define XFS_SCRUB_FLAG_REPAIR	0x1	/* i: repair this metadata */
 #define XFS_SCRUB_FLAG_CORRUPT	0x2	/* o: needs repair */
diff --git a/fs/xfs/xfs_scrub.c b/fs/xfs/xfs_scrub.c
index 7f00cf0..6f6b5a8 100644
--- a/fs/xfs/xfs_scrub.c
+++ b/fs/xfs/xfs_scrub.c
@@ -53,6 +53,7 @@
 #include "xfs_dir2_priv.h"
 #include "xfs_attr_leaf.h"
 #include "xfs_attr.h"
+#include "xfs_symlink.h"
 
 #include <linux/posix_acl_xattr.h>
 #include <linux/xattr.h>
@@ -1486,6 +1487,32 @@ xfs_scrub_setup_inode_xattr(
 	return 0;
 }
 
+/* Set us up with an inode and a buffer for reading symlink targets. */
+STATIC int
+xfs_scrub_setup_inode_symlink(
+	struct xfs_scrub_context	*sc,
+	struct xfs_inode		*ip,
+	struct xfs_scrub_metadata	*sm,
+	bool				retry_deadlocked)
+{
+	void				*buf;
+	int				error;
+
+	/* Allocate the buffer without the inode lock held. */
+	buf = kmem_zalloc_large(MAXPATHLEN + 1, KM_SLEEP);
+	if (!buf)
+		return -ENOMEM;
+
+	error = xfs_scrub_setup_inode(sc, ip, sm, retry_deadlocked);
+	if (error) {
+		kmem_free(buf);
+		return error;
+	}
+
+	sc->buf = buf;
+	return 0;
+}
+
 /* Metadata scrubbers */
 
 #define XFS_SCRUB_SB_CHECK(fs_ok) \
@@ -3329,6 +3356,36 @@ xfs_scrub_xattr(
 	return error;
 }
 
+/* Symbolic links. */
+
+#define XFS_SCRUB_SYMLINK_CHECK(fs_ok) \
+	XFS_SCRUB_INO_CHECK(sc, NULL, "symlink", fs_ok)
+STATIC int
+xfs_scrub_symlink(
+	struct xfs_scrub_context	*sc)
+{
+	int				error = 0;
+
+	if (!S_ISLNK(VFS_I(sc->ip)->i_mode))
+		return -ENOENT;
+
+	/* Inline symlink? */
+	if (sc->ip->i_df.if_flags & XFS_IFINLINE) {
+		XFS_SCRUB_SYMLINK_CHECK(sc->ip->i_d.di_size <= MAXPATHLEN);
+		goto out;
+	}
+
+	/* Remote symlink; must read. */
+	xfs_iunlock(sc->ip, XFS_ILOCK_EXCL);
+	error = xfs_readlink(sc->ip, sc->buf);
+	xfs_ilock(sc->ip, XFS_ILOCK_EXCL);
+	XFS_SCRUB_FILE_OP_ERROR_GOTO(sc, XFS_DATA_FORK, 0, "symlink",
+			&error, out);
+out:
+	return error;
+}
+#undef XFS_SCRUB_SYMLINK_CHECK
+
 /* Scrubbing dispatch. */
 
 struct xfs_scrub_meta_fns {
@@ -3357,6 +3414,7 @@ static const struct xfs_scrub_meta_fns meta_scrub_fns[] = {
 	{xfs_scrub_setup_inode_bmap, xfs_scrub_bmap_cow, NULL, NULL},
 	{xfs_scrub_setup_inode, xfs_scrub_directory, NULL, NULL},
 	{xfs_scrub_setup_inode_xattr, xfs_scrub_xattr, NULL, NULL},
+	{xfs_scrub_setup_inode_symlink, xfs_scrub_symlink, NULL, NULL},
 };
 
 /* Dispatch metadata scrubbing. */
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 39af47f..386ad26 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -3478,7 +3478,8 @@ DEFINE_GETFSMAP_EVENT(xfs_getfsmap_mapping);
 	{ XFS_SCRUB_TYPE_BMBTA,		"bmapbta" }, \
 	{ XFS_SCRUB_TYPE_BMBTC,		"bmapbtc" }, \
 	{ XFS_SCRUB_TYPE_DIR,		"dir" }, \
-	{ XFS_SCRUB_TYPE_XATTR,		"xattr" }
+	{ XFS_SCRUB_TYPE_XATTR,		"xattr" }, \
+	{ XFS_SCRUB_TYPE_SYMLINK,	"symlink" }
 DECLARE_EVENT_CLASS(xfs_scrub_class,
 	TP_PROTO(struct xfs_inode *ip, int type, xfs_agnumber_t agno,
 		 xfs_ino_t inum, unsigned int gen, unsigned int flags,

