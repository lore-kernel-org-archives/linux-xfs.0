Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:39994 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751029AbdLMX7S (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 13 Dec 2017 18:59:18 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.21/8.16.0.21) with SMTP id vBDNm2Cb025054
        for <linux-xfs@vger.kernel.org>; Wed, 13 Dec 2017 23:59:17 GMT
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by userp2120.oracle.com with ESMTP id 2eudq605nn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 13 Dec 2017 23:59:17 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id vBDNxHD0003213
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 13 Dec 2017 23:59:17 GMT
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id vBDNxG3N012054
        for <linux-xfs@vger.kernel.org>; Wed, 13 Dec 2017 23:59:16 GMT
Subject: [PATCH 10/13] xfs: provide a centralized method for verifying
 inline fork data
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Wed, 13 Dec 2017 15:59:13 -0800
Message-ID: <151320955376.30654.3972078644450529725.stgit@magnolia>
In-Reply-To: <151320949282.30654.14805160700975182459.stgit@magnolia>
References: <151320949282.30654.14805160700975182459.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Replace the current haphazard dir2 shortform verifier callsites with a
centralized verifier function that can be called either with the default
verifier functions or with a custom set.  This helps us strengthen
integrity checking while providing us with flexibility for repair tools.

xfs_repair wants this to be able to supply its own verifier functions
when trying to fix possibly corrupt metadata.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_inode_fork.c |   73 +++++++++++++++++++++++++++++-----------
 fs/xfs/libxfs/xfs_inode_fork.h |   14 ++++++++
 fs/xfs/xfs_icache.c            |    5 +++
 fs/xfs/xfs_inode.c             |   34 ++++++++++++++++---
 fs/xfs/xfs_inode.h             |    2 +
 fs/xfs/xfs_log_recover.c       |    4 ++
 6 files changed, 108 insertions(+), 24 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
index a92395a..7756103 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.c
+++ b/fs/xfs/libxfs/xfs_inode_fork.c
@@ -35,6 +35,8 @@
 #include "xfs_da_format.h"
 #include "xfs_da_btree.h"
 #include "xfs_dir2_priv.h"
+#include "xfs_attr_leaf.h"
+#include "xfs_shared.h"
 
 kmem_zone_t *xfs_ifork_zone;
 
@@ -97,14 +99,6 @@ xfs_iformat_fork(
 	if (error)
 		return error;
 
-	/* Check inline dir contents. */
-	if (S_ISDIR(inode->i_mode) && dip->di_format == XFS_DINODE_FMT_LOCAL) {
-		if (xfs_dir2_sf_verify(ip)) {
-			xfs_idestroy_fork(ip, XFS_DATA_FORK);
-			return -EFSCORRUPTED;
-		}
-	}
-
 	if (xfs_is_reflink_inode(ip)) {
 		ASSERT(ip->i_cowfp == NULL);
 		xfs_ifork_init_cow(ip);
@@ -121,18 +115,6 @@ xfs_iformat_fork(
 		atp = (xfs_attr_shortform_t *)XFS_DFORK_APTR(dip);
 		size = be16_to_cpu(atp->hdr.totsize);
 
-		if (unlikely(size < sizeof(struct xfs_attr_sf_hdr))) {
-			xfs_warn(ip->i_mount,
-				"corrupt inode %Lu (bad attr fork size %Ld).",
-				(unsigned long long) ip->i_ino,
-				(long long) size);
-			XFS_CORRUPTION_ERROR("xfs_iformat(8)",
-					     XFS_ERRLEVEL_LOW,
-					     ip->i_mount, dip);
-			error = -EFSCORRUPTED;
-			break;
-		}
-
 		error = xfs_iformat_local(ip, dip, XFS_ATTR_FORK, size);
 		break;
 	case XFS_DINODE_FMT_EXTENTS:
@@ -740,3 +722,54 @@ xfs_ifork_init_cow(
 	ip->i_cformat = XFS_DINODE_FMT_EXTENTS;
 	ip->i_cnextents = 0;
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
+xfs_failaddr_t
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
+xfs_failaddr_t
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
index b9f0098..dd8aba0 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.h
+++ b/fs/xfs/libxfs/xfs_inode_fork.h
@@ -186,4 +186,18 @@ extern struct kmem_zone	*xfs_ifork_zone;
 
 extern void xfs_ifork_init_cow(struct xfs_inode *ip);
 
+typedef xfs_failaddr_t (*xfs_ifork_verifier_t)(struct xfs_inode *);
+
+struct xfs_ifork_ops {
+	xfs_ifork_verifier_t	verify_symlink;
+	xfs_ifork_verifier_t	verify_dir;
+	xfs_ifork_verifier_t	verify_attr;
+};
+extern struct xfs_ifork_ops	xfs_default_ifork_ops;
+
+xfs_failaddr_t xfs_ifork_verify_data(struct xfs_inode *ip,
+		struct xfs_ifork_ops *ops);
+xfs_failaddr_t xfs_ifork_verify_attr(struct xfs_inode *ip,
+		struct xfs_ifork_ops *ops);
+
 #endif	/* __XFS_INODE_FORK_H__ */
diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 43005fb..81ebb68 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -473,6 +473,11 @@ xfs_iget_cache_miss(
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
index 8012741..d1e2518 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -3488,6 +3488,34 @@ xfs_iflush(
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
+	xfs_failaddr_t		fa;
+
+	fa = xfs_ifork_verify_data(ip, &xfs_default_ifork_ops);
+	if (fa) {
+		xfs_alert(ip->i_mount,
+				"%s: bad inode %llu inline data fork at %pF",
+				__func__, ip->i_ino, fa);
+		return false;
+	}
+
+	fa = xfs_ifork_verify_attr(ip, &xfs_default_ifork_ops);
+	if (fa) {
+		xfs_alert(ip->i_mount,
+				"%s: bad inode %llu inline attr fork at %pF",
+				__func__, ip->i_ino, fa);
+		return false;
+	}
+	return true;
+}
+
 STATIC int
 xfs_iflush_int(
 	struct xfs_inode	*ip,
@@ -3566,10 +3594,8 @@ xfs_iflush_int(
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
index cc13c37..e4d1708 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -490,4 +490,6 @@ extern struct kmem_zone	*xfs_inode_zone;
 /* The default CoW extent size hint. */
 #define XFS_DEFAULT_COWEXTSZ_HINT 32
 
+bool xfs_inode_verify_forks(struct xfs_inode *ip);
+
 #endif	/* __XFS_INODE_H__ */
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 28d1abf..04f5b30 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -2957,6 +2957,10 @@ xfs_recover_inode_owner_change(
 	if (error)
 		goto out_free_ip;
 
+	if (!xfs_inode_verify_forks(ip)) {
+		error = -EFSCORRUPTED;
+		goto out_free_ip;
+	}
 
 	if (in_f->ilf_fields & XFS_ILOG_DOWNER) {
 		ASSERT(in_f->ilf_fields & XFS_ILOG_DBROOT);

