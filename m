Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:43208 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728234AbfAACTx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 31 Dec 2018 21:19:53 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id x012EBvH018775
        for <linux-xfs@vger.kernel.org>; Tue, 1 Jan 2019 02:19:52 GMT
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp2130.oracle.com with ESMTP id 2pp0btp796-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 01 Jan 2019 02:19:52 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id x012Jj5a009579
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 1 Jan 2019 02:19:46 GMT
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x012Jjrh001602
        for <linux-xfs@vger.kernel.org>; Tue, 1 Jan 2019 02:19:45 GMT
Subject: [PATCH 07/22] xfs: decouple platform-specific inode allocation
 functions
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Mon, 31 Dec 2018 18:19:44 -0800
Message-ID: <154630918439.18437.3847814286604639982.stgit@magnolia>
In-Reply-To: <154630914104.18437.15354380637179830566.stgit@magnolia>
References: <154630914104.18437.15354380637179830566.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Decouple the xfs_ialloc function from the platform-specific pieces by
passing in an operations structure.  This prepares the function for
hoisting to libxfs.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_inode_util.h |   30 ++++++++++++++++++++++++++++++
 fs/xfs/xfs_inode.c             |   13 ++++++++++---
 2 files changed, 40 insertions(+), 3 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_inode_util.h b/fs/xfs/libxfs/xfs_inode_util.h
index 942524b59cf6..6318234003e1 100644
--- a/fs/xfs/libxfs/xfs_inode_util.h
+++ b/fs/xfs/libxfs/xfs_inode_util.h
@@ -43,8 +43,11 @@ xfs_get_initial_prid(struct xfs_icdinode *id)
 	return XFS_PROJID_DEFAULT;
 }
 
+struct xfs_ialloc_ops;
+
 /* Initial ids, link count, device number, and mode of a new inode. */
 struct xfs_ialloc_args {
+	const struct xfs_ialloc_ops	*ops;
 	struct xfs_inode		*pip;	/* parent inode or null */
 
 	uint32_t			uid;
@@ -57,4 +60,31 @@ struct xfs_ialloc_args {
 	umode_t				mode;
 };
 
+/* Platform-specific inode allocation functions. */
+struct xfs_ialloc_ops {
+	/*
+	 * Load in-core inode given our new inode number, returning the inode
+	 * with ILOCK_EXCL held to prevent anyone else from seeing the inode
+	 * until we're done.
+	 */
+	int (*iget)(struct xfs_mount *mp, struct xfs_trans *tp, xfs_ino_t ino,
+		    struct xfs_inode **ipp);
+
+	/*
+	 * Do whatever platform-specific initialization is necessary to bring
+	 * up this new inode.  This is called after we've set up default values
+	 * on the inode but before propagating required fields from the parent
+	 * inode.
+	 */
+	void (*platform_init)(struct xfs_trans *tp,
+			      const struct xfs_ialloc_args *args,
+			      struct xfs_inode *ip);
+
+	/* Do any final setup needed before we return the inode. */
+	void (*setup)(struct xfs_inode *ip);
+};
+
+/* The libxfs client must provide this symbol. */
+extern const struct xfs_ialloc_ops xfs_default_ialloc_ops;
+
 #endif /* __XFS_INODE_UTIL_H__ */
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index b635d43caeed..41fab97d1270 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -647,6 +647,12 @@ xfs_ialloc_platform_init(
 	VFS_I(ip)->i_ctime = tv;
 }
 
+const struct xfs_ialloc_ops xfs_default_ialloc_ops = {
+	.iget		= xfs_ialloc_iget,
+	.platform_init	= xfs_ialloc_platform_init,
+	.setup		= xfs_setup_inode,
+};
+
 /*
  * Allocate an inode on disk and return a copy of its in-core version.
  * The in-core inode is locked exclusively.  Set mode, nlink, and rdev
@@ -724,7 +730,7 @@ xfs_ialloc(
 	 * This is because we're setting fields here we need
 	 * to prevent others from looking at until we're done.
 	 */
-	error = xfs_ialloc_iget(mp, tp, ino, &ip);
+	error = args->ops->iget(mp, tp, ino, &ip);
 	if (error)
 		return error;
 	ASSERT(ip != NULL);
@@ -785,7 +791,7 @@ xfs_ialloc(
 		ip->i_d.di_crtime.t_nsec = 0;
 	}
 
-	xfs_ialloc_platform_init(tp, args, ip);
+	args->ops->platform_init(tp, args, ip);
 
 	flags = XFS_ILOG_CORE;
 	switch (args->mode & S_IFMT) {
@@ -877,7 +883,7 @@ xfs_ialloc(
 	xfs_trans_log_inode(tp, ip, flags);
 
 	/* now that we have an i_mode we can setup the inode structure */
-	xfs_setup_inode(ip);
+	args->ops->setup(ip);
 
 	*ipp = ip;
 	return 0;
@@ -907,6 +913,7 @@ xfs_dir_ialloc(
 					   locked. */
 {
 	struct xfs_ialloc_args	args = {
+		.ops	= &xfs_default_ialloc_ops,
 		.pip	= dp,
 		.uid	= xfs_kuid_to_uid(current_fsuid()),
 		.gid	= xfs_kgid_to_gid(current_fsgid()),
