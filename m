Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:58742 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751022AbeCTDIa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 19 Mar 2018 23:08:30 -0400
Subject: [PATCH 1/4] xfs_repair: implement custom ifork verifiers
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Mon, 19 Mar 2018 20:08:26 -0700
Message-ID: <152151530602.18312.5227395146899805650.stgit@magnolia>
In-Reply-To: <152151529988.18312.2660325658864402943.stgit@magnolia>
References: <152151529988.18312.2660325658864402943.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@redhat.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

There are a few cases where an early stage of xfs_repair will write an
invalid inode fork buffer to signal to a later stage that it needs to
correct the value.  This happens in phase 4 when we detect an inline
format directory with an invalid .. pointer.  To avoid triggering the
ifork verifiers on this, inject a custom verifier for phase 6 that lets
this pass for now.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libxfs/libxfs_api_defs.h |    2 +
 repair/phase6.c          |   66 +++++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 67 insertions(+), 1 deletion(-)


diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index 5d56340..78daca0 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -150,5 +150,7 @@
 #define xfs_rmap_lookup_le_range	libxfs_rmap_lookup_le_range
 #define xfs_refc_block			libxfs_refc_block
 #define xfs_rmap_compare		libxfs_rmap_compare
+#define xfs_dir_get_ops			libxfs_dir_get_ops
+#define xfs_default_ifork_ops		libxfs_default_ifork_ops
 
 #endif /* __LIBXFS_API_DEFS_H__ */
diff --git a/repair/phase6.c b/repair/phase6.c
index aff83bc..e9189af 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -39,6 +39,70 @@ static struct xfs_name		xfs_name_dot = {(unsigned char *)".",
 						XFS_DIR3_FT_DIR};
 
 /*
+ * When we're checking directory inodes, we're allowed to set a directory's
+ * dotdot entry to zero to signal that the parent needs to be reconnected
+ * during phase 6.  The ifork verifiers would normally fail that, but we'll
+ * accept this canary so that we can fix the dir.
+ */
+static xfs_failaddr_t
+phase6_verify_dir(
+	struct xfs_inode		*ip)
+{
+	struct xfs_mount		*mp = ip->i_mount;
+	const struct xfs_dir_ops	*dops;
+	struct xfs_ifork		*ifp;
+	struct xfs_dir2_sf_hdr		*sfp;
+	xfs_failaddr_t			fa;
+	xfs_ino_t			old_parent;
+	bool				parent_bypass = false;
+	int				size;
+
+	dops = libxfs_dir_get_ops(mp, NULL);
+
+	ifp = XFS_IFORK_PTR(ip, XFS_DATA_FORK);
+	sfp = (struct xfs_dir2_sf_hdr *)ifp->if_u1.if_data;
+	size = ifp->if_bytes;
+
+	/* Don't let the NULLFSINO .. entry blow everything up. */
+	if (size > offsetof(struct xfs_dir2_sf_hdr, parent) &&
+	    size >= xfs_dir2_sf_hdr_size(sfp->i8count)) {
+		old_parent = dops->sf_get_parent_ino(sfp);
+		if (old_parent == 0) {
+			dops->sf_put_parent_ino(sfp, mp->m_sb.sb_rootino);
+			parent_bypass = true;
+		}
+	}
+
+	fa = libxfs_default_ifork_ops.verify_dir(ip);
+
+	/* Put it back. */
+	if (parent_bypass)
+		dops->sf_put_parent_ino(sfp, old_parent);
+
+	return fa;
+}
+
+static xfs_failaddr_t
+phase6_verify_attr(
+	struct xfs_inode		*ip)
+{
+	return libxfs_default_ifork_ops.verify_attr(ip);
+}
+
+static xfs_failaddr_t
+phase6_verify_symlink(
+	struct xfs_inode		*ip)
+{
+	return libxfs_default_ifork_ops.verify_symlink(ip);
+}
+
+struct xfs_ifork_ops phase6_default_ifork_ops = {
+	.verify_attr	= phase6_verify_attr,
+	.verify_dir	= phase6_verify_dir,
+	.verify_symlink	= phase6_verify_symlink,
+};
+
+/*
  * Data structures used to keep track of directories where the ".."
  * entries are updated. These must be rebuilt after the initial pass
  */
@@ -2833,7 +2897,7 @@ process_dir_inode(
 
 	ASSERT(!is_inode_refchecked(irec, ino_offset) || dotdot_update);
 
-	error = -libxfs_iget(mp, NULL, ino, 0, &ip, NULL);
+	error = -libxfs_iget(mp, NULL, ino, 0, &ip, &phase6_default_ifork_ops);
 	if (error) {
 		if (!no_modify)
 			do_error(

