Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id BB99D7F7B
	for <xfs@oss.sgi.com>; Mon,  5 May 2014 09:26:04 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 9B2CD304043
	for <xfs@oss.sgi.com>; Mon,  5 May 2014 07:26:01 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id QG77J8GT9afm9QhV for
	<xfs@oss.sgi.com>; Mon, 05 May 2014 07:26:00 -0700 (PDT)
Received: from int-mx11.intmail.prod.int.phx2.redhat.com
	(int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s45EQ0fc021853
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=OK) for <xfs@oss.sgi.com>; Mon, 5 May 2014 10:26:00 -0400
Received: from bfoster.bfoster ([10.18.41.237])
	by int-mx11.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id s45EPxme006246
	for <xfs@oss.sgi.com>; Mon, 5 May 2014 10:25:59 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v2] xfs: initialize default acls for ->tmpfile()
Date: Mon,  5 May 2014 10:25:58 -0400
Message-Id: <1399299958-34588-1-git-send-email-bfoster@redhat.com>
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

The current tmpfile handler does not initialize default ACLs. Doing so
within xfs_vn_tmpfile() makes it roughly equivalent to xfs_vn_mknod(),
which is already used as a common create handler.

xfs_vn_mknod() does not currently have a mechanism to determine whether
to link the file into the namespace. Therefore, further abstract
xfs_vn_mknod() into a new xfs_generic_create() handler with a tmpfile
parameter. This new handler calls xfs_create_tmpfile() and d_tmpfile()
on the dentry when called via ->tmpfile().

Signed-off-by: Brian Foster <bfoster@redhat.com>
---

v2: rebased to 3.15-rc4

 fs/xfs/xfs_iops.c | 55 +++++++++++++++++++++++++++++--------------------------
 1 file changed, 29 insertions(+), 26 deletions(-)

diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index ef1ca01..301ecbf 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -124,15 +124,15 @@ xfs_cleanup_inode(
 	xfs_dentry_to_name(&teardown, dentry, 0);
 
 	xfs_remove(XFS_I(dir), &teardown, XFS_I(inode));
-	iput(inode);
 }
 
 STATIC int
-xfs_vn_mknod(
+xfs_generic_create(
 	struct inode	*dir,
 	struct dentry	*dentry,
 	umode_t		mode,
-	dev_t		rdev)
+	dev_t		rdev,
+	bool		tmpfile)	/* unnamed file */
 {
 	struct inode	*inode;
 	struct xfs_inode *ip = NULL;
@@ -156,8 +156,12 @@ xfs_vn_mknod(
 	if (error)
 		return error;
 
-	xfs_dentry_to_name(&name, dentry, mode);
-	error = xfs_create(XFS_I(dir), &name, mode, rdev, &ip);
+	if (!tmpfile) {
+		xfs_dentry_to_name(&name, dentry, mode);
+		error = xfs_create(XFS_I(dir), &name, mode, rdev, &ip);
+	} else {
+		error = xfs_create_tmpfile(XFS_I(dir), dentry, mode, &ip);
+	}
 	if (unlikely(error))
 		goto out_free_acl;
 
@@ -180,7 +184,11 @@ xfs_vn_mknod(
 	}
 #endif
 
-	d_instantiate(dentry, inode);
+	if (tmpfile)
+		d_tmpfile(dentry, inode);
+	else
+		d_instantiate(dentry, inode);
+
  out_free_acl:
 	if (default_acl)
 		posix_acl_release(default_acl);
@@ -189,11 +197,23 @@ xfs_vn_mknod(
 	return -error;
 
  out_cleanup_inode:
-	xfs_cleanup_inode(dir, inode, dentry);
+	if (!tmpfile)
+		xfs_cleanup_inode(dir, inode, dentry);
+	iput(inode);
 	goto out_free_acl;
 }
 
 STATIC int
+xfs_vn_mknod(
+	struct inode	*dir,
+	struct dentry	*dentry,
+	umode_t		mode,
+	dev_t		rdev)
+{
+	return xfs_generic_create(dir, dentry, mode, rdev, false);
+}
+
+STATIC int
 xfs_vn_create(
 	struct inode	*dir,
 	struct dentry	*dentry,
@@ -353,6 +373,7 @@ xfs_vn_symlink(
 
  out_cleanup_inode:
 	xfs_cleanup_inode(dir, inode, dentry);
+	iput(inode);
  out:
 	return -error;
 }
@@ -1053,25 +1074,7 @@ xfs_vn_tmpfile(
 	struct dentry	*dentry,
 	umode_t		mode)
 {
-	int			error;
-	struct xfs_inode	*ip;
-	struct inode		*inode;
-
-	error = xfs_create_tmpfile(XFS_I(dir), dentry, mode, &ip);
-	if (unlikely(error))
-		return -error;
-
-	inode = VFS_I(ip);
-
-	error = xfs_init_security(inode, dir, &dentry->d_name);
-	if (unlikely(error)) {
-		iput(inode);
-		return -error;
-	}
-
-	d_tmpfile(dentry, inode);
-
-	return 0;
+	return xfs_generic_create(dir, dentry, mode, 0, true);
 }
 
 static const struct inode_operations xfs_inode_operations = {
-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
