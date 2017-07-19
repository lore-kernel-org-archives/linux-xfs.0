Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:38492 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755259AbdGSQDW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Jul 2017 12:03:22 -0400
Date: Wed, 19 Jul 2017 09:03:18 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [RFC PATCH] xfs: consolidate local format inode fork verifiers
Message-ID: <20170719160318.GP4224@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: xfs <linux-xfs@vger.kernel.org>
Cc: Dave Chinner <david@fromorbit.com>

Create a centralized function to verify local format inode forks, then
migrate the existing short format directory verifier to use this
framework and add verifiers for the other two things we support (attrs
and symlinks).

Obviously this will get broken up into smaller pieces (one patch to
refactor/move the existing verifier calls, another one to add the two
new verifiers), but what do people think?

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_attr_leaf.c      |   70 ++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_attr_leaf.h      |    1 +
 fs/xfs/libxfs/xfs_inode_fork.c     |   10 -----
 fs/xfs/libxfs/xfs_shared.h         |    1 +
 fs/xfs/libxfs/xfs_symlink_remote.c |   29 +++++++++++++++
 fs/xfs/xfs_icache.c                |   46 ++++++++++++++++++++++++
 fs/xfs/xfs_icache.h                |    1 +
 fs/xfs/xfs_inode.c                 |    6 +--
 8 files changed, 150 insertions(+), 14 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index c6c15e5..43b881e 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -871,6 +871,76 @@ xfs_attr_shortform_allfit(
 	return xfs_attr_shortform_bytesfit(dp, bytes);
 }
 
+/* Verify the consistency of an inline attribute fork. */
+int
+xfs_attr_shortform_verify(
+	struct xfs_inode		*ip)
+{
+	struct xfs_attr_shortform	*sfp;
+	struct xfs_attr_sf_entry	*sfep;
+	struct xfs_attr_sf_entry	*next_sfep;
+	char				*endp;
+	struct xfs_ifork		*ifp;
+	int				i;
+	int				size;
+
+	ASSERT(ip->i_d.di_aformat == XFS_DINODE_FMT_LOCAL);
+	ifp = XFS_IFORK_PTR(ip, XFS_ATTR_FORK);
+	sfp = (struct xfs_attr_shortform *)ifp->if_u1.if_data;
+	size = ifp->if_bytes;
+
+	/*
+	 * Give up if the attribute is way too short.
+	 */
+	if (size < sizeof (struct xfs_attr_sf_hdr))
+		return -EFSCORRUPTED;
+
+	endp = (char *)sfp + size;
+
+	/* Check all reported entries */
+	sfep = &sfp->list[0];
+	for (i = 0; i < sfp->hdr.count; i++) {
+		/*
+		 * struct xfs_attr_sf_entry has a variable length.
+		 * Check the fixed-offset parts of the structure are
+		 * within the data buffer.
+		 */
+		if (((char *)sfep + sizeof(*sfep)) >= endp)
+			return -EFSCORRUPTED;
+
+		/* Don't allow names with known bad length. */
+		if (sfep->namelen == 0)
+			return -EFSCORRUPTED;
+
+		/*
+		 * Check that the variable-length part of the structure is
+		 * within the data buffer.  The next entry starts after the
+		 * name component, so nextentry is an acceptable test.
+		 */
+		next_sfep = XFS_ATTR_SF_NEXTENTRY(sfep);
+		if (endp < (char *)next_sfep)
+			return -EFSCORRUPTED;
+
+		/*
+		 * Check for unknown flags.  Short form doesn't support
+		 * the incomplete or local bits.
+		 */
+		if (sfep->flags & ~(XFS_ATTR_ROOT | XFS_ATTR_SECURE))
+			return -EFSCORRUPTED;
+
+		/* Check for invalid namespace combinations. */
+		if ((sfep->flags & XFS_ATTR_ROOT) &&
+		    (sfep->flags & XFS_ATTR_SECURE))
+			return -EFSCORRUPTED;
+
+		sfep = next_sfep;
+	}
+	if ((void *)sfep != (void *)endp)
+		return -EFSCORRUPTED;
+
+	return 0;
+}
+
 /*
  * Convert a leaf attribute list to shortform attribute list
  */
diff --git a/fs/xfs/libxfs/xfs_attr_leaf.h b/fs/xfs/libxfs/xfs_attr_leaf.h
index f7dda0c..ec7291d 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.h
+++ b/fs/xfs/libxfs/xfs_attr_leaf.h
@@ -52,6 +52,7 @@ int	xfs_attr_shortform_to_leaf(struct xfs_da_args *args);
 int	xfs_attr_shortform_remove(struct xfs_da_args *args);
 int	xfs_attr_shortform_allfit(struct xfs_buf *bp, struct xfs_inode *dp);
 int	xfs_attr_shortform_bytesfit(struct xfs_inode *dp, int bytes);
+int	xfs_attr_shortform_verify(struct xfs_inode *ip);
 void	xfs_attr_fork_remove(struct xfs_inode *ip, struct xfs_trans *tp);
 
 /*
diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
index 0e80f34..5484211 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.c
+++ b/fs/xfs/libxfs/xfs_inode_fork.c
@@ -183,16 +183,6 @@ xfs_iformat_fork(
 	if (error)
 		return error;
 
-	/* Check inline dir contents. */
-	if (S_ISDIR(VFS_I(ip)->i_mode) &&
-	    dip->di_format == XFS_DINODE_FMT_LOCAL) {
-		error = xfs_dir2_sf_verify(ip);
-		if (error) {
-			xfs_idestroy_fork(ip, XFS_DATA_FORK);
-			return error;
-		}
-	}
-
 	if (xfs_is_reflink_inode(ip)) {
 		ASSERT(ip->i_cowfp == NULL);
 		xfs_ifork_init_cow(ip);
diff --git a/fs/xfs/libxfs/xfs_shared.h b/fs/xfs/libxfs/xfs_shared.h
index c6f4eb4..7e35a16 100644
--- a/fs/xfs/libxfs/xfs_shared.h
+++ b/fs/xfs/libxfs/xfs_shared.h
@@ -143,5 +143,6 @@ bool xfs_symlink_hdr_ok(xfs_ino_t ino, uint32_t offset,
 			uint32_t size, struct xfs_buf *bp);
 void xfs_symlink_local_to_remote(struct xfs_trans *tp, struct xfs_buf *bp,
 				 struct xfs_inode *ip, struct xfs_ifork *ifp);
+int xfs_symlink_sf_verify(struct xfs_inode *ip);
 
 #endif /* __XFS_SHARED_H__ */
diff --git a/fs/xfs/libxfs/xfs_symlink_remote.c b/fs/xfs/libxfs/xfs_symlink_remote.c
index c484877..96e2957 100644
--- a/fs/xfs/libxfs/xfs_symlink_remote.c
+++ b/fs/xfs/libxfs/xfs_symlink_remote.c
@@ -207,3 +207,32 @@ xfs_symlink_local_to_remote(
 	xfs_trans_log_buf(tp, bp, 0, sizeof(struct xfs_dsymlink_hdr) +
 					ifp->if_bytes - 1);
 }
+
+/* Verify the consistency of an inline symlink. */
+int
+xfs_symlink_sf_verify(
+	struct xfs_inode	*ip)
+{
+	char			*sfp;
+	char			*endp;
+	struct xfs_ifork	*ifp;
+	int			size;
+
+	ASSERT(ip->i_d.di_format == XFS_DINODE_FMT_LOCAL);
+	ifp = XFS_IFORK_PTR(ip, XFS_DATA_FORK);
+	sfp = (char *)ifp->if_u1.if_data;
+	size = ifp->if_bytes;
+	endp = sfp + size;
+
+	/* No negative sizes or overly long symlink targets. */
+	if (size < 0 || size > XFS_SYMLINK_MAXLEN)
+		return -EFSCORRUPTED;
+
+	/* No NULLs in the target either. */
+	for (; sfp < endp; sfp++) {
+		if (*sfp == 0)
+			return -EFSCORRUPTED;
+	}
+
+	return 0;
+}
diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 0a9e698..fd1d430 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -34,6 +34,11 @@
 #include "xfs_dquot_item.h"
 #include "xfs_dquot.h"
 #include "xfs_reflink.h"
+#include "xfs_da_format.h"
+#include "xfs_da_btree.h"
+#include "xfs_dir2_priv.h"
+#include "xfs_attr_leaf.h"
+#include "xfs_shared.h"
 
 #include <linux/kthread.h>
 #include <linux/freezer.h>
@@ -449,6 +454,43 @@ xfs_iget_cache_hit(
 	return error;
 }
 
+/* Check inline fork contents. */
+int
+xfs_iget_verify_forks(
+	struct xfs_inode		*ip)
+{
+	int				error;
+
+	/* Check the attribute fork if there is one. */
+	if (XFS_IFORK_PTR(ip, XFS_ATTR_FORK) &&
+	    ip->i_d.di_aformat == XFS_DINODE_FMT_LOCAL) {
+		error = xfs_attr_shortform_verify(ip);
+		if (error) {
+			xfs_alert(ip->i_mount,
+					"%s: bad inode %Lu inline attr fork",
+					__func__, ip->i_ino);
+			return error;
+		}
+	}
+
+	/* Non-local data fork, jump out. */
+	if (ip->i_d.di_format != XFS_DINODE_FMT_LOCAL)
+		return 0;
+
+	/* Check the inline data fork if there is one. */
+	if (S_ISDIR(VFS_I(ip)->i_mode))
+		error = xfs_dir2_sf_verify(ip);
+	else if (S_ISLNK(VFS_I(ip)->i_mode))
+		error = xfs_symlink_sf_verify(ip);
+	else
+		error = -EFSCORRUPTED;
+
+	if (error)
+		xfs_alert(ip->i_mount, "%s: bad inode %Lu inline data fork",
+				__func__, ip->i_ino);
+	return error;
+}
+
 
 static int
 xfs_iget_cache_miss(
@@ -473,6 +515,10 @@ xfs_iget_cache_miss(
 	if (error)
 		goto out_destroy;
 
+	error = xfs_iget_verify_forks(ip);
+	if (error)
+		goto out_destroy;
+
 	trace_xfs_iget_miss(ip);
 
 	if ((VFS_I(ip)->i_mode == 0) && !(flags & XFS_IGET_CREATE)) {
diff --git a/fs/xfs/xfs_icache.h b/fs/xfs/xfs_icache.h
index bff4d85..abf1cff 100644
--- a/fs/xfs/xfs_icache.h
+++ b/fs/xfs/xfs_icache.h
@@ -129,5 +129,6 @@ xfs_fs_eofblocks_from_user(
 
 int xfs_icache_inode_is_allocated(struct xfs_mount *mp, struct xfs_trans *tp,
 				  xfs_ino_t ino, bool *inuse);
+int xfs_iget_verify_forks(struct xfs_inode *ip);
 
 #endif
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index ceef77c..7ca8336 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -3547,10 +3547,8 @@ xfs_iflush_int(
 	if (ip->i_d.di_version < 3)
 		ip->i_d.di_flushiter++;
 
-	/* Check the inline directory data. */
-	if (S_ISDIR(VFS_I(ip)->i_mode) &&
-	    ip->i_d.di_format == XFS_DINODE_FMT_LOCAL &&
-	    xfs_dir2_sf_verify(ip))
+	/* Check the inline fork data. */
+	if (xfs_iget_verify_forks(ip))
 		goto corrupt_out;
 
 	/*
