Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:24058 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751182AbdH1SRf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 28 Aug 2017 14:17:35 -0400
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v7SIHYh3019758
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 28 Aug 2017 18:17:34 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id v7SIHYPi028951
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 28 Aug 2017 18:17:34 GMT
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id v7SIHXGC019880
        for <linux-xfs@vger.kernel.org>; Mon, 28 Aug 2017 18:17:33 GMT
Subject: [PATCH 10/12] xfs: provide a centralized method for verifying
 inline fork data
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Mon, 28 Aug 2017 11:17:32 -0700
Message-ID: <150394425265.24826.16466638584081945605.stgit@magnolia>
In-Reply-To: <150394418979.24826.12970283067445908653.stgit@magnolia>
References: <150394418979.24826.12970283067445908653.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org, darrick.wong@oracle.com

From: Darrick J. Wong <darrick.wong@oracle.com>

Replace the current haphazard dir2 shortform verifier callsites with a
centralized verifier function that can be called either with the default
verifier functions or with a custom set.  This helps us strengthen
integrity checking while providing us with flexibility for repair tools.

xfs_repair wants this to be able to supply its own verifier functions
when trying to fix possibly corrupt metadata.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_inode_fork.c |   62 ++++++++++++++++++++++++++++++++++------
 fs/xfs/libxfs/xfs_inode_fork.h |   12 ++++++++
 fs/xfs/xfs_icache.c            |    6 +++-
 fs/xfs/xfs_inode.c             |   34 +++++++++++++++++++---
 fs/xfs/xfs_inode.h             |    2 +
 fs/xfs/xfs_log_recover.c       |    4 +++
 6 files changed, 106 insertions(+), 14 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
index 43213d5..ec9df5f 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.c
+++ b/fs/xfs/libxfs/xfs_inode_fork.c
@@ -35,6 +35,8 @@
 #include "xfs_da_format.h"
 #include "xfs_da_btree.h"
 #include "xfs_dir2_priv.h"
+#include "xfs_attr_leaf.h"
+#include "xfs_shared.h"
 
 kmem_zone_t *xfs_ifork_zone;
 
@@ -96,15 +98,6 @@ xfs_iformat_fork(
 	if (error)
 		return error;
 
-	/* Check inline dir contents. */
-	if (S_ISDIR(VFS_I(ip)->i_mode) &&
-	    dip->di_format == XFS_DINODE_FMT_LOCAL) {
-		if (xfs_dir2_sf_verify(ip)) {
-			xfs_idestroy_fork(ip, XFS_DATA_FORK);
-			return -EFSCORRUPTED;
-		}
-	}
-
 	if (xfs_is_reflink_inode(ip)) {
 		ASSERT(ip->i_cowfp == NULL);
 		xfs_ifork_init_cow(ip);
@@ -1923,3 +1916,54 @@ xfs_iext_get_extent(
 	xfs_bmbt_get_all(xfs_iext_get_ext(ifp, idx), gotp);
 	return true;
 }
+
+/* Default fork content verifiers. */
+struct xfs_ifork_ops xfs_default_ifork_ops = {
+	.verify_attr	= xfs_attr_shortform_verify,
+	.verify_dir	= xfs_dir2_sf_verify,
+	.verify_symlink	= xfs_symlink_shortform_verify,
+};
+
+/* Verify the inline contents of the data fork of an inode. */
+void *
+xfs_ifork_verify_data(
+	struct xfs_inode	*ip,
+	struct xfs_ifork_ops	*ops)
+{
+	xfs_ifork_verifier_t	fn = NULL;
+
+	/* Non-local data fork, we're done. */
+	if (ip->i_d.di_format != XFS_DINODE_FMT_LOCAL)
+		return NULL;
+
+	/* Check the inline data fork if there is one. */
+	if (S_ISDIR(VFS_I(ip)->i_mode))
+		fn = ops->verify_dir;
+	else if (S_ISLNK(VFS_I(ip)->i_mode))
+		fn = ops->verify_symlink;
+
+	if (fn)
+		return fn(ip);
+	return NULL;
+}
+
+/* Verify the inline contents of the attr fork of an inode. */
+void *
+xfs_ifork_verify_attr(
+	struct xfs_inode	*ip,
+	struct xfs_ifork_ops	*ops)
+{
+	xfs_ifork_verifier_t	fn = NULL;
+
+	/* There has to be an attr fork allocated if aformat is local. */
+	if (ip->i_d.di_aformat == XFS_DINODE_FMT_LOCAL) {
+		if (XFS_IFORK_PTR(ip, XFS_ATTR_FORK))
+			fn = ops->verify_attr;
+		else
+			return __this_address;
+	}
+
+	if (fn)
+		return fn(ip);
+	return NULL;
+}
diff --git a/fs/xfs/libxfs/xfs_inode_fork.h b/fs/xfs/libxfs/xfs_inode_fork.h
index 7fb8365..abab8fb 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.h
+++ b/fs/xfs/libxfs/xfs_inode_fork.h
@@ -192,4 +192,16 @@ extern struct kmem_zone	*xfs_ifork_zone;
 
 extern void xfs_ifork_init_cow(struct xfs_inode *ip);
 
+typedef void *(*xfs_ifork_verifier_t)(struct xfs_inode *);
+
+struct xfs_ifork_ops {
+	xfs_ifork_verifier_t	verify_symlink;
+	xfs_ifork_verifier_t	verify_dir;
+	xfs_ifork_verifier_t	verify_attr;
+};
+extern struct xfs_ifork_ops	xfs_default_ifork_ops;
+
+void *xfs_ifork_verify_data(struct xfs_inode *ip, struct xfs_ifork_ops *ops);
+void *xfs_ifork_verify_attr(struct xfs_inode *ip, struct xfs_ifork_ops *ops);
+
 #endif	/* __XFS_INODE_FORK_H__ */
diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 7a715cd..89567b9 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -449,7 +449,6 @@ xfs_iget_cache_hit(
 	return error;
 }
 
-
 static int
 xfs_iget_cache_miss(
 	struct xfs_mount	*mp,
@@ -473,6 +472,11 @@ xfs_iget_cache_miss(
 	if (error)
 		goto out_destroy;
 
+	if (!xfs_inode_verify_forks(ip)) {
+		error = -EFSCORRUPTED;
+		goto out_destroy;
+	}
+
 	trace_xfs_iget_miss(ip);
 
 	if ((VFS_I(ip)->i_mode == 0) && !(flags & XFS_IGET_CREATE)) {
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index ff48f00..4e05325 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -3471,6 +3471,34 @@ xfs_iflush(
 	return error;
 }
 
+/*
+ * If there are inline format data / attr forks attached to this inode,
+ * make sure they're not corrupt.
+ */
+bool
+xfs_inode_verify_forks(
+	struct xfs_inode	*ip)
+{
+	void			*failed_at;
+
+	failed_at = xfs_ifork_verify_data(ip, &xfs_default_ifork_ops);
+	if (failed_at) {
+		xfs_alert(ip->i_mount,
+				"%s: bad inode %llu inline data fork at %pF",
+				__func__, ip->i_ino, failed_at);
+		return false;
+	}
+
+	failed_at = xfs_ifork_verify_attr(ip, &xfs_default_ifork_ops);
+	if (failed_at) {
+		xfs_alert(ip->i_mount,
+				"%s: bad inode %llu inline attr fork at %pF",
+				__func__, ip->i_ino, failed_at);
+		return false;
+	}
+	return true;
+}
+
 STATIC int
 xfs_iflush_int(
 	struct xfs_inode	*ip,
@@ -3549,10 +3577,8 @@ xfs_iflush_int(
 	if (ip->i_d.di_version < 3)
 		ip->i_d.di_flushiter++;
 
-	/* Check the inline directory data. */
-	if (S_ISDIR(VFS_I(ip)->i_mode) &&
-	    ip->i_d.di_format == XFS_DINODE_FMT_LOCAL &&
-	    xfs_dir2_sf_verify(ip))
+	/* Check the inline fork data before we write out. */
+	if (!xfs_inode_verify_forks(ip))
 		goto corrupt_out;
 
 	/*
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 0ee453d..fcd1192 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -490,4 +490,6 @@ extern struct kmem_zone	*xfs_inode_zone;
 /* The default CoW extent size hint. */
 #define XFS_DEFAULT_COWEXTSZ_HINT 32
 
+bool xfs_inode_verify_forks(struct xfs_inode *ip);
+
 #endif	/* __XFS_INODE_H__ */
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 9549188..6c72bdf 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -2920,6 +2920,10 @@ xfs_recover_inode_owner_change(
 	if (error)
 		goto out_free_ip;
 
+	if (!xfs_inode_verify_forks(ip)) {
+		error = -EFSCORRUPTED;
+		goto out_free_ip;
+	}
 
 	if (in_f->ilf_fields & XFS_ILOG_DOWNER) {
 		ASSERT(in_f->ilf_fields & XFS_ILOG_DBROOT);

